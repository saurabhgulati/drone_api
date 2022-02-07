require "drone_api/version"
require 'net/http'
require 'json'

module DroneApi
  class Error < StandardError; end
  # Your code goes here...

  class ConfigurationError < DroneApi::Error
    def message
      'Account id, client_id, client_secret must be defined in config'
    end
  end

  class AuthError < DroneApi::Error
    def message
      'Invalid auth token'
    end
  end

  class << self
    attr_accessor :configuration

    def configure &blk
      self.configuration ||= DroneApi::Configuration.new.tap(&blk)
    end

    def generate_token payload={ username: DroneApi.configuration&.client_id }
      DroneApi::Auth.new(payload).response
    end
  end

  class Configuration
    attr_accessor :client_secret, :client_id, :account_id, :env, :current_token, :encryption_token
    
    def initialize(options={})
      self.client_secret = options['client_secret']
      self.client_id = options['client_id']
      self.account_id = options['account_id']
      self.env = options['env'] || 'production'
      self.encryption_token = options['encryption_token']
    end
  end

  class Base
    attr_reader :response_data, :response_status, :client_secret, :client_id, :account_id

    def initialize
      @client_secret = DroneApi.configuration&.client_secret
      @client_id = DroneApi.configuration&.client_id
      @account_id = DroneApi.configuration&.account_id
      @drone_env = DroneApi.configuration&.env

      raise DroneApi::ConfigurationError if !valid_for_execution

      @errors = Hash.new {|h,k| h[k] = Array.new }
    end

    def set_auth_header(request)
      if requires_authentication?
        DroneApi.generate_token if DroneApi.configuration.current_token.to_s.empty?
        request["Auth-Token"] = DroneApi.configuration.current_token
      end
    end

    def is_form_request?
      false
    end

    def response
      execute
      return self
    end

    def errors
      @errors ||= {}
    end

    def valid?
      errors.empty?
    end

    # def errors_hash
    #   { errors: errors }
    # end

    # def success_hash
    #   {}
    # end

    def request path, request_type, &blck
      url = env_url+path
      url = URI(url)
      url.query = URI.encode_www_form(query_params) if query_params.any?
      http = Net::HTTP.new(url.host, url.port)
      # http.use_ssl = true
      # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      case request_type 
      when 'GET'
        request = Net::HTTP::Get.new(url)
      when 'POST'
        request = Net::HTTP::Post.new(url)
      when 'PUT'
        request = Net::HTTP::Put.new(url)
      when 'DELETE'
        request = Net::HTTP::Delete.new(url)
      else
        raise 'Invalid request type'
      end

      set_auth_header(request)
      if is_form_request?
        request["content-type"] = 'application/x-www-form-urlencoded'
      else
        request["content-type"] = 'application/json'
      end
      yield(http, request)
    end

    def execute
      validate
      if valid?
        make_request
      end
    end

    def validate
    end

    def make_request
      request(api_path, request_type) do |http, request|
        request.body = parse_payload if payload.any?
        process_request http, request
      end
    end

    #NOTE: raise configuration error if token is invalid
    ##Token is stored in DroneApi.configuration.current_token which can expire
    ##So once its expire we'll rase authication error to let application handle it
    ##Refresh token using DroneApi.generate_token if this error is raised

    def process_request http, request
      response = http.request(request)
      @response_status = response.code.to_i

      raise DroneApi::AuthError if @response_status == 401

      process_response(response.body) if response.body 
    end

    def request_type
      raise 'Define request type in base class'
    end

    def api_path
      raise 'Define api path of API in base class'
    end

    def query_params
      {}
    end

    def parse_payload
      if is_form_request?
        return URI.encode_www_form(payload)
      else
        return payload.to_json
      end
    end

    def env_url
      if @drone_env == 'production'
        return 'http://192.168.33.10:81'
      elsif @drone_env == 'staging'
        return 'http://drone.stg.ccubeapp.com'
      else
        return 'http://localhost:3001'
      end
    end

    def requires_authentication?
      true
    end

    private 

    def payload
      {}
    end

    def valid_for_execution
      !(@client_secret.to_s.empty? || @client_id.to_s.empty? || @account_id.to_s.empty?)
    end
  end
end

require 'drone_api/auth'
require 'drone_api/accounts'
require 'drone_api/clients'
require 'drone_api/buildings'
