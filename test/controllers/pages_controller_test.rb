require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "Example App"
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "Help | Example App"
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_select "title", "About | Example App"
  end

  test "should get contact" do
    get :contact
    assert_response :success
    assert_select "title", "Contact | Example App"
  end
end
