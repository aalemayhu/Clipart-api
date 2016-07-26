require 'sinatra'

get '/' do
  version = `git describe --tags` 
  "#{version}"
end

get '/search' do
  "search"
end
