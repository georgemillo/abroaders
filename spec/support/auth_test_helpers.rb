module Auth
  module TestHelpers
    def self.included(base)
      base.class_eval do
        setup :setup_controller_for_warden, :warden if respond_to?(:setup)
      end
    end

    # Override process to consider warden.
    def process(*)
      # Make sure we always return @response, a la ActionController::TestCase::Behaviour#process, even if warden interrupts
      _catch_warden { super } # || @response  # _catch_warden will setup the @response object

      # process needs to return the ActionDispath::TestResponse object
      @response
    end

    # We need to set up the environment variables and the response in the controller.
    def setup_controller_for_warden #:nodoc:
      @request.env['action_controller.instance'] = @controller
    end

    # Quick access to Warden::Proxy.
    def warden #:nodoc:
      @request.env['warden'] ||= begin
        manager = Warden::Manager.new(nil) do |config|
          config.merge! Devise.warden_config
        end
        Warden::Proxy.new(@request.env, manager)
      end
    end

    # sign_in a given resource by storing its keys in the session.
    # This method bypass any warden authentication callback.
    #
    # Examples:
    #
    #   sign_in @user
    #
    def sign_in(resource)
      scope = resource.warden_scope

      warden.instance_variable_get(:@users).delete(scope)
      warden.session_serializer.store(resource, scope)
    end

    # Sign out a given scope by calling logout on Warden.
    # This method bypasses any warden logout callback.
    #
    # Examples:
    #
    #   sign_out :user     # sign_out(scope)
    #
    def sign_out(scope)
      @controller.instance_variable_set(:"@current_#{scope}", nil)
      user = warden.instance_variable_get(:@users).delete(scope)
      warden.session_serializer.delete(scope, user)
    end

    protected

    # Catch warden continuations and handle like the middleware would.
    # Returns nil when interrupted, otherwise the normal result of the block.
    def _catch_warden(&block)
      result = catch(:warden, &block)

      env = @controller.request.env

      result ||= {}

      # Set the response. In production, the rack result is returned
      # from Warden::Manager#call, which the following is modelled on.
      case result
      when Array
        if result.first == 401 && intercept_401?(env) # does this happen during testing?
          _process_unauthenticated(env)
        else
          result
        end
      when Hash
        _process_unauthenticated(env, result)
      else
        result
      end
    end

    def _process_unauthenticated(env, options = {})
      options[:action] ||= :unauthenticated
      proxy = env['warden']
      result = options[:result] || proxy.result

      ret = case result
            when :redirect
              body = proxy.message || "You are being redirected to #{proxy.headers['Location']}"
              [proxy.status, proxy.headers, [body]]
            when :custom
              proxy.custom_response
            else
              env["PATH_INFO"] = "/#{options[:action]}"
              env["warden.options"] = options
              Warden::Manager._run_callbacks(:before_failure, env, options)

              # DEVISETODO how do I access the regular warden config?
              status, headers, response = Devise.warden_config[:failure_app].call(env).to_a
              @controller.response.headers.merge!(headers)
              r_opts = { status: status, content_type: headers["Content-Type"], location: headers["Location"] }
              r_opts[Rails.version.start_with?('5') ? :body : :text] = response.body
              @controller.send :render, r_opts
              nil # causes process return @response
            end

      # ensure that the controller response is set up. In production, this is
      # not necessary since warden returns the results to rack. However, at
      # testing time, we want the response to be available to the testing
      # framework to verify what would be returned to rack.
      if ret.is_a?(Array)
        # ensure the controller response is set to our response.
        @controller.response ||= @response
        @response.status = ret.first
        @response.headers.clear
        ret.second.each { |k, v| @response[k] = v }
        @response.body = ret.third
      end

      ret
    end
  end
end
