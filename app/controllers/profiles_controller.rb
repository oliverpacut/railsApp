class ProfilesController < ApplicationController
  before_action :logged_in_profile,  only: [:index, :edit, :update, :destroy]
  before_action :correct_profile,    only: [:edit, :update]
  before_action :admin_profile,	     only: :destroy
  #before_action :set_profile, only: [:show, :edit, :update, :destroy]

  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.paginate(page: params[:page])
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    @profile = Profile.find(params[:id])
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
    @profile = Profile.find(params[:id])
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.new(profile_params)
    if @profile.save
      log_in @profile
      flash[:success] = "Welcome to our application!"
      redirect_to @profile
    else
      render 'new'
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    @profile = Profile.find(params[:id])
    if @profile.update_attributes(profile_params)
      flash[:success] = "Profile updated"
      redirect_to @profile
    else
      render 'edit'
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    Profile.find(params[:id]).destroy
    flash[:success] = "Profile deleted."
    redirect_to profiles_url
  end

  def logged_in_profile
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def correct_profile
    @profile = Profile.find(params[:id])
    redirect_to(root_url) unless @profile == current_profile
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    def admin_profile
      redirect_to(root_url) unless current_profile.admin?
    end
end
