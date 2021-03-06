require 'net/http'
require 'net/https'

module AptCrowd
  class ApiWrapper
    attr_accessor :askuri, :activityuri, :username, :password

    

    def initialize uri, username, password
      @askuri = URI(uri + 'ask/')
      @activityuri = URI(uri + 'activity/')
      @username = username
      @password = password
    end
    
    def ask requestBody
      request = Net::HTTP::Post.new(askuri, 'Content-Type' => 'application/json')
      request.basic_auth username, password
      request.body = requestBody.to_json

      # response = Net::HTTP.start(askuri.hostname, askuri.port) do |http|
      #   http.request(request)
      # end
      http = Net::HTTP.new(askuri.hostname, askuri.port)
      http.use_ssl = askuri.scheme.downcase == "https"
      response = http.start{|http| http.request(request)}

      return JSON.parse(response.body)
    end

    def activity requestBody
      request = Net::HTTP::Post.new(activityuri, 'Content-Type' => 'application/json')
      request.basic_auth username, password
      request.body = requestBody.to_json

      http = Net::HTTP.new(askuri.hostname, askuri.port)
      http.use_ssl = askuri.scheme.downcase == "https"
      response = http.start{|http| http.request(request)}

      return JSON.parse(response.body)
    end
  end
end
