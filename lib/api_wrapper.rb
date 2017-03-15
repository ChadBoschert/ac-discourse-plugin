require 'net/http'

module AptCrowd
  class ApiWrapper
    AC_URI = URI('http://aptcrowd.pythonanywhere.com/ask/')

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
    
    def self.ask requestBody
      request = Net::HTTP::Post.new(AC_URI, 'Content-Type' => 'application/json')
      request.basic_auth 'admin', 'secret' #TODO add as setting
      request.body = requestBody.to_json

      response = Net::HTTP.start(AC_URI.hostname, AC_URI.port) do |http|
        http.request(request)
      end

      return JSON.parse(response.body)
    end
  end
end
