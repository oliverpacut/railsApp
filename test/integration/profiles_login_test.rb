require 'test_helper'

class ProfilesLoginTest < ActionDispatch::IntegrationTest

  def setup
    @profile = profiles(:Jimmy)
  end
  
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: "", password: "" }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information" do
    get login_path
    post login_path, session: { email: @profile.email, password: 'password' }
    assert_redirected_to @profile
    follow_redirect!
    assert_template 'profiles/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", profile_path(@profile)
  end


  test "login with valid information followed by logout" do
    get login_path
    post login_path, session: { email: @profile.email, password: 'password' }
    assert is_logged_in?
    assert_redirected_to @profile
    follow_redirect!
    assert_template 'profiles/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", profile_path(@profile)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # Simulate a user clicking logout in a second window.
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", profile_path(@profile), count: 0
  end


  test "login with remembering" do
    log_in_as(@profile, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as(@profile, remember_me: '0')
    assert_nil cookies['remember_token']
  end
end
