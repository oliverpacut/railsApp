class AddActivationToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :activation_digest, :string
    add_column :profiles, :activated, :boolean, default: false
    add_column :profiles, :activated_at, :datetime
  end
end
