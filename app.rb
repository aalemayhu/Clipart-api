require 'sinatra'
require 'httparty'
require 'json'
require 'digest/sha1'
require 'open-uri'

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

  def extractImages(payload)
    images = URI.extract(payload)
    images.each { |image| 
      if image.end_with?(".png")
        hashed = Digest::SHA1.hexdigest "#{image}"
        downloadImage = open("#{image}")
        IO.copy_stream(downloadImage, "/tmp/#{hashed}.png")
      end
    }
  end

  get '/search' do
    # The caller is expecting a json paylod
    content_type :json

    query = params['query'] || "play"
    amount = params['amount'] || "20"

    response = HTTParty.get(queryUrl(query, amount))
    payload = response.parsed_response.to_json
    payload = JSON.pretty_generate(response.parsed_response)

    extractImages(payload)

    # Write the response to disk for further testing
    File.open("#{tmpDirectory}/#{query}.#{amount}.txt", 'w') { |file| file.write(payload) }

    payload
  end
end
