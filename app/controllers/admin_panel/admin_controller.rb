module AdminPanel
  class AdminController < ::ApplicationController

    before_action :authenticate_admin!
  end
end
