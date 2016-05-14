class AddAdminToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :admin, :boolean, default: false
  end
end
