class AddRememberDigestToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :remember_digest, :string
  end
end
