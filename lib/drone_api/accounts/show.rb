class DroneApi::Accounts::Show < DroneApi::Base

  private

  def api_path
    "/api/v2/accounts/#{@account_id}"
  end

  def request_type
    'GET'
  end
end
