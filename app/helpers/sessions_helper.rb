module SessionsHelper

  # Logs in the given user
  def log_in(profile)
    session[:profile_id] = profile.id
  end

  # Remembers a user in a persistent session.
  def remember(profile)
    profile.remember
    cookies.permanent.signed[:profile_id] = profile.id
    cookies.permanent[:remember_token] = profile.remember_token
  end

  # Returns the current logged-in user (if any).
  def current_profile
    if (profile_id = session[:profile_id])
      @current_profile ||= Profile.find_by(id: profile_id)
    elsif (profile_id = cookies.signed[:profile_id])
      profile = Profile.find_by(id: profile_id)
      if profile && profile.authenticated?(cookies[:remember_token])
        log_in profile
        @current_profile = profile
      end
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_profile.nil?
  end

  def forget(profile)
    profile.forget
    cookies.delete(:profile_id)
    cookies.delete(:remmeber_token)
  end

  def log_out
    session.delete(:profile_id)
    @current_profile = nil
  end
end
