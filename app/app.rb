require 'sinatra/base'

class Application < Sinatra::Base
  get "/" do
    "<p>hello world</p>"
  end

  run!
end
