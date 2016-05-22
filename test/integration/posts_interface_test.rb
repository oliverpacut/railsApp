require 'test_helper'

class PostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @profile = profiles(:michael)
  end

  test "post interface" do
    log_in_as(@profile)
    get root_path
    assert_select 'div.pagination'
    # Invalid submission
    assert_no_difference 'Post.count' do
      post posts_path, post: { content: "" }
    end
    assert_select 'div#error_explanation'
    # Valid submission
    content = "This post really ties the room together"
    assert_difference 'Post.count', 1 do
      post posts_path, post: { content: content }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Delete a post.
    assert_select 'a', text: 'delete'
    first_post = @profile.posts.paginate(page: 1).first
    assert_difference 'Post.count', -1 do
      delete post_path(first_post)
    end
    # Visit a different user.
    get profile_path(profiles(:archer))
    assert_select 'a', text: 'delete', count: 0
  end
end
