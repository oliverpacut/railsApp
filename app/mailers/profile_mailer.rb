class ProfileMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.profile_mailer.account_activation.subject
  #
  def account_activation(profile)
    @profile = profile
    mail to: profile.email, subject: "Account activation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.profile_mailer.password_reset.subject
  #
  def password_reset(profile)
    @profile = profile
    mail to: profile.email, subject: "Password reset"
  end
end
