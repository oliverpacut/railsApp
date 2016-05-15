class AddResetToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :reset_digest, :string
    add_column :profiles, :reset_sent_at, :datetime
  end
end
