class Service::Challengepost < Service::HttpPost
  string :token

  default_events :push, :release

  url "http://challengepost.com"

  maintained_by :github => "rossta"

  supported_by :web => "http://help.challengepost.com/",
    :email => "support@challengepost.com",
    :twitter => "@ChallengePost"

  def receive_event
    token = required_config_value('token')
    http.token_auth token
    deliver 'https://api.challengepost.com/hooks/github', content_type: :json
  end

  def token
    data["token"].to_s.strip
  end
end
