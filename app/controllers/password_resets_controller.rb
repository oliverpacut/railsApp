class PasswordResetsController < ApplicationController
  before_action :get_profile,   only: [:edit, :update]
  before_action :valid_profile, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @profile = Profile.find_by(email: params[:password_reset][:email].downcase)
    if @profile
      @profile.create_reset_digest
      @profile.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:profile][:password].empty?
      @profile.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @profile.update_attributes(profile_params)
      log_in @profile
      flash[:success] = "Password has been reset."
      redirect_to @profile
    else
      render 'edit'
    end
  end

  private

    def profile_params
      params.require(:profile).permit(:password, :password_confirmation)
    end
 
    def get_profile
      @profile = Profile.find_by(email: params[:email])
    end

    # Confirms a valid profile.
    def valid_profile
      unless (@profile && @profile.activated? &&
              @profile.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    def check_expiration
      if @profile.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
