require File.expand_path('../helper', __FILE__)

class ChallengepostTest < Service::TestCase
  def setup
    @stubs = Faraday::Adapter::Test::Stubs.new
    @svc   = service(data, {'repository'=> { 'name' => "testing" }})
  end

  def test_reads_token_from_data
    assert_equal "aeb811db58b6353331294a4614c3eac0", @svc.token
  end

  def test_strips_whitespace_from_token
    svc = service({'token' => 'aeb811db58b6353331294a4614c3eac0  '}, payload)
    assert_equal 'aeb811db58b6353331294a4614c3eac0', svc.token
  end

  def test_posts_payload
    @stubs.post '/hooks/github' do |env|
      assert_equal 'https', env[:url].scheme
      assert_equal 'api.challengepost.com', env[:url].host
      assert_equal "Token token=\"aeb811db58b6353331294a4614c3eac0\"", env[:request_headers]['Authorization']
      assert JSON.parse(env[:body]).keys.include?("payload")
      assert_equal "testing", JSON.parse(env[:body])["payload"]["repository"]["name"]
    end

    @svc.receive_event
  end

  private

  def service(*args)
    super Service::Challengepost, *args
  end

  def data
    { 'token' => 'aeb811db58b6353331294a4614c3eac0' }
  end

end
