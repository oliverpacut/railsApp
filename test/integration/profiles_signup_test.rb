require 'test_helper'

class ProfilesSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

 test "invalid signup information" do
    get signup_path
    assert_no_difference 'Profile.count' do
      post profiles_path, profile: { name:  "",
                               email: "user@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'profiles/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'Profile.count', 1 do
      post profiles_path, profile: { name:  "Example Profile",
                               email: "example@railstutorial.org",
                               password:              "password",
                               password_confirmation: "password" }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    profile = assigns(:profile)
    assert_not profile.activated?
    # Try to log in before activation.
    log_in_as(profile)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(profile.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(profile.activation_token, email: profile.email)
    assert profile.reload.activated?
    follow_redirect!
    assert_template 'profiles/show'
    assert is_logged_in?
  end
end
