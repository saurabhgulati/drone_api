class DroneApi::Buildings::Create < DroneApi::Base

  Params = Struct.new(
      :name,
      :address,
      :city,
      :state,
      :zipcode,
      :country,
      :latitude,
      :longitude,
      :client_id,
      :original_building_id,
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
    @errors['name']      << 'Can\'t be blank' if @params.name.empty?
    @errors['address']   << 'Can\'t be blank' if @params.address.empty?
    @errors['city']      << 'Can\'t be blank' if @params.city.empty?
    @errors['state'].    << 'Can\'t be blank' if @params.state.empty?
    @errors['zipcode']   << 'Can\'t be blank' if @params.zipcode.to_s.empty?
    @errors['country']   << 'Can\'t be blank' if @params.country.empty?
    @errors['latitude']  << 'Can\'t be blank' if @params.latitude.to_s.empty?
    @errors['longitude'] << 'Can\'t be blank' if @params.longitude.to_s.empty?
    @errors['client_id'] << 'Can\'t be blank' if @params.client_id.to_s.empty?
    @errors['original_building_id'] << 'Can\'t be blank' if @params.original_building_id.to_s.empty?
  end

  def api_path
    "/api/v2/buildings"
  end

  def request_type
    'POST'
  end

  def payload
    {
      building: {
        name:      @params.name,
        address:   @params.address,
        city:      @params.city,
        state:     @params.state,
        zipcode:   @params.zipcode,
        country:   @params.country,
        latitude:  @params.latitude,
        longitude: @params.longitude,
        client_id: @params.client_id,
        original_building_id: @params.original_building_id
      }
    }
  end
end
