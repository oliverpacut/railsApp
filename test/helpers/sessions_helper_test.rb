require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @profile = profiles(:Jimmy)
    remember(@profile)
  end

  test "current_profile returns right profile when session is nil" do
    assert_equal @profile, current_profile
    assert is_logged_in?
  end

  test "current_profile returns nil when remember digest is wrong" do
    @profile.update_attribute(:remember_digest, Profile.digest(Profile.new_token))
    assert_nil current_profile
  end
end
