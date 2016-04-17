class Profile < ActiveRecord::Base
  before_save { self.email = email.downcase }
  has_many :posts
  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
		    format: { with: VALID_EMAIL_REGEX },
		    uniqueness: { case_sensitive: false }
  validates :name, presence: true, length: { maximum: 20 }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
