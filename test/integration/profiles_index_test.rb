require 'test_helper'

class ProfilesIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin     = profiles(:michael)
    @non_admin = profiles(:archer)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get profiles_path
    assert_template 'profiles/index'
    assert_select 'div.pagination'
    first_page_of_profiles = Profile.paginate(page: 1)
    first_page_of_profiles.each do |profile|
      assert_select 'a[href=?]', profile_path(profile), text: profile.name
      unless profile == @admin
        assert_select 'a[href=?]', profile_path(profile), text: 'delete'
      end
    end
    assert_difference 'Profile.count', -1 do
      delete profile_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get profiles_path
    assert_select 'a', text: 'delete', count: 0
  end
end
