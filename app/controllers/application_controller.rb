class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :require_login

  protected
    def not_authenticated
      redirect_to login_path, alert: "Please login first"
      false
    end
end
