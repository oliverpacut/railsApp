class AddPasswordDigestToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :password_digest, :string
  end
end
