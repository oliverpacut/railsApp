class ProfilesController < ApplicationController
  before_action :logged_in_profile,  only: [:index, :edit, :update, :destroy,
					    :following, :followers]
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
    @posts = @profile.posts.paginate(page: params[:page])
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
      @profile.send_activation_email
      #ProfileMailer.account_activation(@profile).deliver_now
      flash[:info] = "Check your email to activate your account."
      redirect_to root_url
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

  def following
    @title = "Following"
    @profile = Profile.find(params[:id])
    @profiles = @profile.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @profile = Profile.find(params[:id])
    @profiles = @profile.followers.paginate(page: params[:page])
    render 'show_follow'
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
