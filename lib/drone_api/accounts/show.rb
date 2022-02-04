class DroneApi::Accounts::Show < DroneApi::Base

  def process_response response
    @response_data = JSON.parse(response)
  end

  private

  def api_path
    "/api/v2/accounts/#{@account_id}"
  end

  def request_type
    'GET'
  end
end
