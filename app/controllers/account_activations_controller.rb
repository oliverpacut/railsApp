class AccountActivationsController < ApplicationController
  def edit
    profile = Profile.find_by(email: params[:email])
    if profile && !profile.activated? && profile.authenticated?(:activation, params[:id])
      profile.activate
      log_in profile
      flash[:success] = "Account activated!"
      redirect_to profile
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
