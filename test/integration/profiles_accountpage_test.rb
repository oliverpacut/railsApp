require 'test_helper'

class ProfilesAccountpageTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @profile = profiles(:michael)
  end

  test "profile display" do
    get profile_path(@profile)
    assert_template 'profiles/show'
    assert_select 'title', full_title(@profile.name)
    assert_select 'h1', test: @profile.name
    assert_select 'h1>img.gravatar'
    assert_match @profile.posts.count.to_s, response.body
    assert_select 'div.pagination'
    @profile.posts.paginate(page: 1).each do |post|
      assert_match post.content, response.body
    end
  end
end
