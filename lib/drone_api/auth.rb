#
## obj = DroneApi::Auth.new.response
## obj.response_code => 401, 200, 422
## obj.response_data => { 'token' => '<JWT token>'}
#
require 'jwt'

class DroneApi::Auth < DroneApi::Base
  attr_reader :token

  Params = Struct.new(
      :username,
      keyword_init: true
    )

  def initialize params={}
    super()
    @params = Params.new(params)
  end

  def execute
    validate
    if valid?
      create_token
      DroneApi.configuration.current_token = @token
    end
  end

  private

  def validate
    @errors['account_id'] << 'Can\'t be blank' if @account_id.to_s.empty?
    @errors['username'] << 'Can\'t be blank' if @params.username.to_s.empty?
  end

  def payload
    {
      account_id: @account_id,
      username: @params.username
    }
  end

  def create_token
    @token = JWT.encode payload, DroneApi.configuration&.encryption_token, 'HS512'
  end
end
