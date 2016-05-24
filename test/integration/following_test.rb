require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @profile = profiles(:michael)
    @other   = profiles(:archer)
    log_in_as(@profile)
  end

  test "following page" do
    get following_profile_path(@profile)
    assert_not @profile.following.empty?
    assert_match @profile.following.count.to_s, response.body
    @profile.following.each do |profile|
      assert_select "a[href=?]", profile_path(profile)
    end
  end

  test "followers page" do
    get followers_profile_path(@profile)
    assert_not @profile.followers.empty?
    assert_match @profile.followers.count.to_s, response.body
    @profile.followers.each do |profile|
      assert_select "a[href=?]", profile_path(profile)
    end
  end

  test "should follow a profile the standard way" do
    assert_difference '@profile.following.count', 1 do
      post relationships_path, followed_id: @other.id
    end
  end

  test "should follow a profile with Ajax" do
    assert_difference '@profile.following.count', 1 do
      xhr :post, relationships_path, followed_id: @other.id
    end
  end

  test "should unfollow a profile the standard way" do
    @profile.follow(@other)
    relationship = @profile.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@profile.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "should unfollow a profile with Ajax" do
    @profile.follow(@other)
    relationship = @profile.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@profile.following.count', -1 do
      xhr :delete, relationship_path(relationship)
    end
  end
end
