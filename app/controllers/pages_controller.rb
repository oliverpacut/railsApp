class PagesController < ApplicationController
  def home
    if logged_in?
      @post = current_profile.posts.build
      @feed_items = current_profile.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end

end
