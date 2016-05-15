# Preview all emails at http://localhost:3000/rails/mailers/profile_mailer
class ProfileMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/profile_mailer/account_activation
  def account_activation
    profile = Profile.first
    profile.activation_token = Profile.new_token
    ProfileMailer.account_activation(profile)
  end

  # Preview this email at http://localhost:3000/rails/mailers/profile_mailer/password_reset
  def password_reset
    profile = Profile.first
    profile.reset_token = Profile.new_token
    ProfileMailer.password_reset(profile)
  end

end
