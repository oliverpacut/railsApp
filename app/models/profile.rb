class Profile < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest

  has_many :posts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
				  foreign_key: "follower_id",
				  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
		    format: { with: VALID_EMAIL_REGEX },
		    uniqueness: { case_sensitive: false }
  validates :name, presence: true, length: { maximum: 50 }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Returns the hash digest of the given string.
  def Profile.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
						  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def Profile.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = Profile.new_token
    update_attribute(:remember_digest, Profile.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    ProfileMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = Profile.new_token
    update_attribute(:reset_digest, Profile.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    ProfileMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
		     WHERE follower_id = :profile_id"
    Post.where("profile_id IN (#{following_ids})
		OR profile_id = :profile_id", profile_id: id)
  end

  def follow(other_profile)
    active_relationships.create(followed_id: other_profile.id)
  end

  def unfollow(other_profile)
    active_relationships.find_by(followed_id: other_profile.id).destroy
  end

  def following?(other_profile)
    following.include?(other_profile)
  end

  private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = Profile.new_token
      self.activation_digest = Profile.digest(activation_token)
    end
end
