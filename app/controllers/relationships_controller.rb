class RelationshipsController < ApplicationController
  before_action :logged_in_profile

  def create
    @profile = Profile.find(params[:followed_id])
    current_profile.follow(@profile)
    respond_to do |format|
      format.html { redirect_to @profile }
      format.js
    end
  end

  def destroy
    @profile = Relationship.find(params[:id]).followed
    current_profile.unfollow(@profile)
    respond_to do |format|
      format.html { redirect_to @profile }
      format.js
    end
  end
end
