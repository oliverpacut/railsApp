require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @profile = profiles(:michael)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Invalid email
    post password_resets_path, password_reset: { email: "" }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Valid email
    post password_resets_path, password_reset: { email: @profile.email }
    assert_not_equal @profile.reset_digest, @profile.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # Password reset form
    profile = assigns(:profile)
    # Wrong email
    get edit_password_reset_path(profile.reset_token, email: "")
    assert_redirected_to root_url
    # Inactive profile
    profile.toggle!(:activated)
    get edit_password_reset_path(profile.reset_token, email: profile.email)
    assert_redirected_to root_url
    profile.toggle!(:activated)
    # Right email, wrong token
    get edit_password_reset_path('wrong token', email: profile.email)
    assert_redirected_to root_url
    # Right email, right token
    get edit_password_reset_path(profile.reset_token, email: profile.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", profile.email
    # Invalid password & confirmation
    patch password_reset_path(profile.reset_token),
          email: profile.email,
          profile: { password:              "foobaz",
                  password_confirmation: "barquux" }
    assert_select 'div#error_explanation'
    # Empty password
    patch password_reset_path(profile.reset_token),
          email: profile.email,
          profile: { password:              "",
                  password_confirmation: "" }
    assert_select 'div#error_explanation'
    # Valid password & confirmation
    patch password_reset_path(profile.reset_token),
          email: profile.email,
          profile: { password:              "foobaz",
                  password_confirmation: "foobaz" }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to profile
  end
end
