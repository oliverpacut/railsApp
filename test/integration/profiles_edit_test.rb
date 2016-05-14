require 'test_helper'

class ProfilesEditTest < ActionDispatch::IntegrationTest
  def setup
    @profile = profiles(:Jimmy)
  end

  test "unsuccessful edit" do
    log_in_as(@profile)
    get edit_profile_path(@profile)
    assert_template 'profiles/edit'
    patch profile_path(@profile), profile: { name:  "",
                                    email: "foo@invalid",
                                    password:              "foo",
                                    password_confirmation: "bar" }
    assert_template 'profiles/edit'
  end

  test "successful edit with friendly forwarding" do
    get edit_profile_path(@profile)
    log_in_as(@profile)
    assert_redirected_to edit_profile_path(@profile)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch profile_path(@profile), profile: { name:  name,
                                    email: email,
                                    password:              "",
                                    password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @profile
    @profile.reload
    assert_equal name,  @profile.name
    assert_equal email, @profile.email
  end
end
