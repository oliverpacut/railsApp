# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class ProfileMailerPreview < ActionMailer::Preview

  # Preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    profile = Profile.first
    profile.activation_token = Profile.new_token
    ProfileMailer.account_activation(profile)
  end

  # Preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    ProfileMailer.password_reset
  end

end

