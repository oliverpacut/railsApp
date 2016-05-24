require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  def setup
    @profile 		= profiles(:Jimmy)
    @other_profile 	= profiles(:Swanson)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @profile
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @profile, profile: { name: @profile.name, email: @profile.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong profile" do
    log_in_as(@other_profile)
    get :edit, id: @profile
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong profile" do
    log_in_as(@other_profile)
    patch :update, id: @profile, profile: { name: @profile.name, email: @profile.email }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Profile.count' do
      delete :destroy, id: @profile
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_profile)
    assert_no_difference 'Profile.count' do
      delete :destroy, id: @profile
    end
    assert_redirected_to root_url
  end

  test "should redirect following when not logged in" do
    get :following, id: @profile
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get :followers, id: @profile
    assert_redirected_to login_url
  end

=begin
  setup do
    @profile = profiles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:profiles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create profile" do
    assert_difference('Profile.count') do
      post :create, profile: { email: @profile.email, name: @profile.name }
    end

    assert_redirected_to profile_path(assigns(:profile))
  end

  test "should show profile" do
    get :show, id: @profile
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @profile
    assert_response :success
  end

  test "should update profile" do
    patch :update, id: @profile, profile: { email: @profile.email, name: @profile.name }
    assert_redirected_to profile_path(assigns(:profile))
  end

  test "should destroy profile" do
    assert_difference('Profile.count', -1) do
      delete :destroy, id: @profile
    end

    assert_redirected_to profiles_path
  end
=end
end
