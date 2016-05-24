require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  def setup
    @profile = Profile.new(name: "Example User", email: "user@example.com",
			   password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @profile.valid?
  end

  test "name should be present" do
    @profile.name = "     "
    assert_not @profile.valid?
  end

  test "email should be present" do
    @profile.email = "     "
    assert_not @profile.valid?
  end

  test "name should not be too long" do
    @profile.name = "a"*51
    assert_not @profile.valid?
  end

  test "email should not be too long" do
    @profile.email = "a"*244 + "@example.com"
    assert_not @profile.valid?
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @profile.email = invalid_address
      assert_not @profile.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @profile.dup
    duplicate_user.email = @profile.email.upcase
    @profile.save
    assert_not duplicate_user.valid?
  end
  test "password should be present (nonblank)" do
    @profile.password = @profile.password_confirmation = " " * 6
    assert_not @profile.valid?
  end

  test "password should have a minimum length" do
    @profile.password = @profile.password_confirmation = "a" * 5
    assert_not @profile.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @profile.authenticated?(:remember, '')
  end
  
  test "associated posts should be destroyed" do
    @profile.save
    @profile.posts.create!(content: "Lorem ipsum")
    assert_difference 'Post.count', -1 do
      @profile.destroy
    end
  end

  test "should follow and unfollow a profile" do
    michael = profiles(:michael)
    archer  = profiles(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end

  test "feed should have the right posts" do
    michael = profiles(:michael)
    archer  = profiles(:archer)
    lana    = profiles(:lana)
    # Posts from followed profile
    lana.posts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # Posts from self
    michael.posts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # Posts from unfollowed profile
    archer.posts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end
end
