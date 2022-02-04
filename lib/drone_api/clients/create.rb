class DroneApi::Clients::Create < DroneApi::Base

  Params = Struct.new(
      :email,
      :first_name,
      :last_name,
      :organization,
      :original_client_id,
      keyword_init: true
    )

  def initialize params={}
    super()
    @params = Params.new(params)
  end

  def process_response response
    @response_data = JSON.parse(response)
  end

  private

  def validate
    @errors['email'] << 'Can\'t be blank' if @params.email.empty?
    @errors['first_name'] << 'Can\'t be blank' if @params.first_name.empty?
    @errors['last_name'] << 'Can\'t be blank' if @params.last_name.empty?
    @errors['organization'] << 'Can\'t be blank' if @params.organization.empty?
    @errors['original_client_id'] << 'Can\'t be blank' if @params.original_client_id.to_s.empty?
  end

  def api_path
    "/api/v2/clients"
  end

  def request_type
    'POST'
  end

  def payload
    {
      client: {
        email: @params.email,
        first_name: @params.first_name,
        last_name:  @params.last_name,
        organization: @params.organization,
        original_client_id: @params.original_client_id
      }
    }
  end
end
