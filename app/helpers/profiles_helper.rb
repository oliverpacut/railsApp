module ProfilesHelper
  
  #Returns the Gravatar for the given user.
  def gravatar_for(profile, options = { size: 50 })
    gravatar_id = Digest::MD5::hexdigest(profile.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: profile.name, class: "gravatar")
  end
end
