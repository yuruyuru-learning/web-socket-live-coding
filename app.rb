require 'bundler/setup'
Bundler.require

require "./appRequires"

not_found do
  redirect "/"
end

set :server, 'thin'
set :sockets, []

get '/' do
  erb :index
end

get '/websocket' do
  if request.websocket?
    request.websocket do |ws|
      ws.onopen do
        settings.sockets << ws
      end
      ws.onmessage do |msg|
        settings.sockets.each do |s|
          s.send(msg)
        end
      end
      ws.onclose do
        settings.sockets.delete(ws)
      end
    end
  end
end

