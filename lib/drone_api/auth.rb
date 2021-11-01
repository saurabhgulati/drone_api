#
## obj = DroneApi::Auth.new.response
## obj.response_code => 401, 200, 422
## obj.response_data => { 'token' => '<JWT token>'}
#

class DroneApi::Auth < DroneApi::Base

  def process_response response
    data = JSON.parse(response)
    DroneApi.configuration.current_token = data['token']
    @response_data = data
  end
  
  private

  def api_path
    '/api/v2/auth'
  end

  def request_type
    'POST'
  end

  def payload
    {
      account_id: @account_id,
      client_id: @client_id,
      client_secret: @client_secret
    }
  end

  def requires_authentication?
    false
  end
end
