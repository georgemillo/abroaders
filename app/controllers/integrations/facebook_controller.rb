module Integrations
  class FacebookController < ApplicationController
    include SignInOut

    def callback
      run Account::FindOrCreateFromFacebook, env: request.env
      sign_in(:account, @model)
      redirect_to root_path
    end
  end
end