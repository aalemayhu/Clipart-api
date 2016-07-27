require 'sinatra'
require 'httparty'
require 'json'
require 'uri'

require 'sinatra/base'

class App < Sinatra::Base
  # For testing purposes let's persist all responses
  tmpDirectory = "/tmp/requests-clipart"
  `mkdir -p #{tmpDirectory}`

  # Make it easy to know what's running on the server
  get '/' do
    version = `git describe --tags` 
    "#{version}"
  end

  # Use the parameters to build the payload resource
  def queryUrl(query, amount)
    "https://openclipart.org/search/json/?query=#{query}&amount=#{amount}"
  end

  get '/search' do
    # The caller is expecting a json paylod
    content_type :json

    query = params['query'] || "play"
    amount = params['amount'] || "20"

    response = HTTParty.get(queryUrl(query, amount))
    payload = response.parsed_response.to_json
    payload = JSON.pretty_generate(response.parsed_response)

    # Write the response to disk for further testing
    File.open("#{tmpDirectory}/#{query}.#{amount}.txt", 'w') { |file| file.write(payload) }

    "payload: #{URI.extract(payload)}"
  end
end
