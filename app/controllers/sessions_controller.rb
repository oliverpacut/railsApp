class SessionsController < ApplicationController

  def new
  end

  def create
    profile = Profile.find_by(email: params[:session][:email].downcase)
    if profile && profile.authenticate(params[:session][:password])
      #
      if profile.activated?
        log_in profile
        params[:session][:remember_me] == '1' ? remember(profile) : forget(profile)
        redirect_back_or profile
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
