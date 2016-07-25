# ClipartApp
require 'sinatra'

class ClipartApp < Sinatra::Base
  get '/' do
    "`git tag --describe`"
  end
end
