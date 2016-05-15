require 'test_helper'

class ProfileMailerTest < ActionMailer::TestCase

  test "account_activation" do
    profile = profiles(:Jimmy)
    profile.activation_token = Profile.new_token
    mail = ProfileMailer.account_activation(profile)
    assert_equal "Account activation", mail.subject
    assert_equal [profile.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match profile.name,			mail.body.encoded
    assert_match profile.activation_token,	mail.body.encoded
    assert_match CGI::escape(profile.email),	mail.body.encoded
  end

  test "password_reset" do
    profile = profiles(:Jimmy)
    profile.reset_token = Profile.new_token
    mail = ProfileMailer.password_reset(profile)
    assert_equal "Password reset", mail.subject
    assert_equal [profile.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match profile.reset_token,        mail.body.encoded
    assert_match CGI::escape(profile.email), mail.body.encoded
  end
end
