require 'bundler/setup'
require 'sinatra/base'
require 'json'
require 'rest-client'
$stdout.sync = true

class App < Sinatra::Base

  post '/linebot/callback' do

    line_mes = JSON.parse(request.body.read)["result"][0]
    fwd_msg = line_mes["content"]["text"]

    dl_res = JSON.parse( RestClient.post 'https://chatbot-api.userlocal.jp/api/chat', :message => fwd_msg , :key => '4d8f5da67e6d96ef57d8')
puts dl_res
    rply_msg = dl_res["result"]
puts rply_msg

# --- editing in progress"
  params = JSON.parse(request.body.read) 
 
  params['result'].each do |msg|
      request_content = {
        to: [msg['content']['from']],
        toChannel: 1383378250, # Fixed  value
        eventType: "138311608800106203", # Fixed value
        content: {
          contentType:1,
          toType:1,
          text: rply_msg
        }
      }

      endpoint_uri = 'https://trialbot-api.line.me/v1/events'
      content_json = request_content.to_json

      RestClient.proxy = ENV["FIXIE_URL"]
      RestClient.post(endpoint_uri, content_json, {
        'Content-Type' => 'application/json; charset=UTF-8',
        'X-Line-ChannelID' => ENV["LINE_CHANNEL_ID"],
        'X-Line-ChannelSecret' => ENV["LINE_CHANNEL_SECRET"],
        'X-Line-Trusted-User-With-ACL' => ENV["LINE_CHANNEL_MID"],
      })
    end

    "OK"
  end
end

run App
