module Auth
  module Strategies
    # This strategy should be used as basis for authentication strategies. It retrieves
    # parameters both from params or from http authorization headers. See database_authenticatable
    # for an example.
    class Authenticatable < Base
      # authentication_type will always be :params_auth
      attr_accessor :authentication_hash, :authentication_type, :password

      def valid?
        valid_for_params_auth?
      end

      def clean_up_csrf?
        true
      end

      private

      # Receives a resource and check if it is valid by calling valid_for_authentication?
      # An optional block that will be triggered while validating can be optionally
      # given as parameter. Check Auth::Models::Authenticatable.valid_for_authentication?
      # for more information.
      #
      # In case the resource can't be validated, it will fail with the given
      # unauthenticated_message.
      def validate(resource, &block)
        result = resource && resource.valid_for_authentication?(&block)

        if result
          true
        else
          fail!(:invalid) if resource
          false
        end
      end

      # Get values from params and set in the resource.
      def remember_me(resource)
        resource.remember_me = remember_me? if resource.respond_to?(:remember_me=)
      end

      # Should this resource be marked to be remembered?
      def remember_me?
        valid_params? && Dry::Types::Coercions::Form::TRUE_VALUES.include?(params_auth_hash[:remember_me])
      end

      # Check if this is a valid strategy for params authentication by:
      #
      #   * Validating if the model allows params authentication;
      #   * If the request hits the sessions controller through POST;
      #   * If the params[scope] returns a hash with credentials;
      #   * If all authentication keys are present;
      #
      def valid_for_params_auth?
        valid_params_request? &&
          valid_params? && with_authentication_hash(:params_auth, params_auth_hash)
      end

      # Extract the appropriate subhash for authentication from params.
      def params_auth_hash
        params[scope]
      end

      # By default, a request is valid if the controller set the proper env variable.
      def valid_params_request?
        !!env["devise.allow_params_authentication"]
      end

      # If the request is valid, finally check if params_auth_hash returns a hash.
      def valid_params?
        params_auth_hash.is_a?(Hash)
      end

      # Note: unlike `Model.valid_password?`, this method does not actually
      # ensure that the password in the params matches the password stored in
      # the database. It only checks if the password is *present*. Do not rely
      # on this method for validating that a given password is correct.
      def valid_password?
        password.present?
      end

      # Helper to decode credentials from HTTP.
      def decode_credentials
        return [] unless request.authorization && request.authorization =~ /^Basic (.*)/mi
        Base64.decode64(Regexp.last_match(1)).split(/:/, 2)
      end

      # Sets the authentication hash and the password from params_auth_hash.
      # (original method could also handle http_auth_hash, maybe this method
      # exists as a generic interface for something which no longer needs to be
      # generic?)  DEVISETODO
      # :params_auth, params_auth_hash
      def with_authentication_hash(auth_type, auth_values)
        self.authentication_hash = {}
        self.authentication_type = auth_type
        self.password = auth_values[:password]

        parse_authentication_key_values(auth_values, authentication_keys) &&
          parse_authentication_key_values(request_values, request_keys)
      end

      def authentication_keys
        @authentication_keys ||= model.authentication_keys
      end

      def request_keys
        @request_keys ||= model.request_keys
      end

      def request_values
        values = request_keys.map { |k| self.request.send(k) }
        Hash[request_keys.zip(values)]
      end

      def parse_authentication_key_values(hash, keys)
        keys.each do |key, enforce|
          value = hash[key].presence
          if value
            self.authentication_hash[key] = value
          else
            return false unless enforce == false
          end
        end
        true
      end

      # Holds the authenticatable name for this class. Auth::Strategies::DatabaseAuthenticatable
      # becomes simply :database.
      def authenticatable_name
        @authenticatable_name ||=
          ActiveSupport::Inflector.underscore(self.class.name.split("::").last)
                                  .sub("_authenticatable", "").to_sym
      end
    end
  end
end
