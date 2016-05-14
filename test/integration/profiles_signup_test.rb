require 'test_helper'

class ProfilesSignupTest < ActionDispatch::IntegrationTest
 test "invalid signup information" do
    get signup_path
    assert_no_difference 'Profile.count' do
      post profiles_path, profile: { name:  "",
                               email: "user@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'profiles/new'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'Profile.count', 1 do
      post_via_redirect profiles_path, profile: { name:  "Example User",
                                            email: "user@example.com",
                                            password:              "password",
                                            password_confirmation: "password" }
    end
    assert_template 'profiles/show'
    assert is_logged_in?
  end
end
