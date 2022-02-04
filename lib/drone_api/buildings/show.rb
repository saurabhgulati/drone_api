class DroneApi::Buildings::Show < DroneApi::Base

  def initialize id
    super()
    @id = id
  end

  def process_response response
    @response_data = JSON.parse(response)
  end

  private

  def api_path
    "/api/v2/buildings/#{@params.id}"
  end

  def request_type
    'GET'
  end

  def payload
    {
      client: {
        id: @params.id,
      }
    }
  end

end
