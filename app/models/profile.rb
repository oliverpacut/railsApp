class Profile < ActiveRecord::Base
  has_many :posts
  validates :email, presence: true
  validates :name, presence: true
end
