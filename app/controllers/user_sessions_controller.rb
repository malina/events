class UserSessionsController < ApplicationController
  skip_before_filter :require_login
  layout 'simple'

  def new
  	@user = User.new
  end

  def create
  	if @user = login(params[:email], params[:password], params[:remember_me])

      redirect_back_or_to(:root, notice: 'Login successful')
    else
      redirect_to login_path, alert: "Login failed"
    end
  end

  def destroy
  	logout
    flash.now[:alert] = "Login out!"
    render action: "new"
  end
end
