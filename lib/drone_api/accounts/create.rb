class DroneApi::Accounts::Create < DroneApi::Base

  Params = Struct.new(
      :name,
      :email,
      :first_name,
      :last_name,
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
    @errors['name'] << 'Can\'t be blank' if @params.name.to_s.empty?
    @errors['email'] << 'Can\'t be blank' if @params.email.to_s.empty?
    @errors['first_name'] << 'Can\'t be blank' if @params.first_name.to_s.empty?
    @errors['last_name'] << 'Can\'t be blank' if @params.last_name.to_s.empty?
  end

  def api_path
    "/api/v2/accounts"
  end

  def request_type
    'POST'
  end

  def payload
    {
      account: {
        name: @params.name,
        email: @params.email,
        first_name: @params.first_name,
        last_name:  @params.last_name
      }
    }
  end
end
