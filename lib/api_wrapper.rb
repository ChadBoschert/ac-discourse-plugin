require 'net/http'
require 'net/https'

module AptCrowd
  class ApiWrapper
    attr_accessor :askuri, :username, :password

    

    def initialize uri, username, password
      @askuri = URI(uri + 'ask/')
      @username = username
      @password = password
    end

    ##### Sample Request Body #####
    # requestBody = {
    #   "title" => "How to fold fitted sheets?",
    #   "message_body" => "No matter how hard I try, I just can't figure it out. Fitted sheets are the worst. Please teach me your sorcery?",
    #   "category_id" => "1",
    #   "author_id" => "2",
    #   "post_id" => "3",
    #   "topic_id" => "4",
    #   "tags" => ["home","laundry"]
    # }
    
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
  end
end
