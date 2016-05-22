require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @profile = profiles(:michael)
    # This is not idiomatically correct.
    @post = @profile.posts.build(content: "Lorem ipsum") # Post.new(content: "Lorem ipsum", profile_id: @profile.id)
  end

  test "should be valid" do
    assert @post.valid?
  end

  test "profile id should be present" do
    @post.profile_id = nil
    assert_not @post.valid?
  end

  test "content should be present" do
    @post.content = "   "
    assert_not @post.valid?
  end

  test "order should be most recent first" do
    assert_equal posts(:most_recent), Post.first
  end
end
