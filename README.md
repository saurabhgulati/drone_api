# DroneApi

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/drone_api`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'drone_api'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install drone_api

## Usage

# Invoke Auth
DroneApi.generate_token

# Account Show
DroneApi::Accounts::Show.new.response

# Account Create
DroneApi::Accounts::Create.new(name: "Account Name", email: "test@email.com", first_name: "Account First Name", last_name: "Account Last Name").response

# Client Show
DroneApi::Clients::Show.new(1).response

# Client Create
DroneApi::Clients::Create.new(email: "test@email.com", first_name: "Client First Name", last_name: "Client Last Name", organization: "Org Name", original_client_id: 1122).response

# Building Show
DroneApi::Buildings::Show.new(1).response

# Bulding Create
DroneApi::Buildings::Create.new(name: "Building Name", address: "Address", city: "<City>", state: "<State>", zipcode: <Zip>, country: "<Country>", latitude: 123.234, longitude: 764.345, client_id: 1, original_building_id: 234).response

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/drone_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/drone_api/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DroneApi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/drone_api/blob/master/CODE_OF_CONDUCT.md).

# Add to initializers drone_api.rb

DroneApi.configure do |config|
  config.client_id = '<username in drone>'
  config.client_secret = '<password recieved from drone>'
  config.account_id = '<account_id from drone>'
  config.env = '<env>'
end
