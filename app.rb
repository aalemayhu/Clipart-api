require 'sinatra'
require 'httparty'
require 'json'

tmpDirectory = "/tmp/requests-clipart"
get '/' do
  version = `git describe --tags` 
  "#{version}"
end

get '/search' do
  content_type :json
  query = params['query'] || "play"
  amount = params['amount'] || "20"
  `mkdir -p #{tmpDirectory}`
  queryUrl = "https://openclipart.org/search/json/?query=#{query}&amount=#{amount}"
  response = HTTParty.get(queryUrl)
  payload = response.parsed_response.to_json
  File.open("#{tmpDirectory}/#{query}.#{amount}.txt", 'w') { |file| file.write(payload) }

  payload
end
