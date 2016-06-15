require 'bundler/setup'
require 'sinatra/base'
require 'json'
require 'rest-client'

class App < Sinatra::Base
  
#  messages = [
#  "かつまっさーん",
#  "ハハハハハハ",
#  "明日からフェス行くんで！",
#  "佐野さん怖いっす",
#  "なんかうまいもん食いたいっすね！"
#  ]
  messages[0] = RestClient.get 'https://chatbot-api.userlocal.jp/api/chat?message=あそぼー&key=4d8f5da67e6d96ef57d8'
  messages[1] = RestClient.get 'https://chatbot-api.userlocal.jp/api/chat?message=かえれ&key=4d8f5da67e6d96ef57d8'
  messages[2] = RestClient.get 'https://chatbot-api.userlocal.jp/api/chat?message=どこの国の人&key=4d8f5da67e6d96ef57d8'
  messages[3] = RestClient.get 'https://chatbot-api.userlocal.jp/api/chat?message=ビール飲みたい&key=4d8f5da67e6d96ef57d8'
  messages[4] = RestClient.get 'https://chatbot-api.userlocal.jp/api/chat?message=おつかれさまー&key=4d8f5da67e6d96ef57d8'

  post '/linebot/callback' do

    idx = rand(5)
    params = JSON.parse(request.body.read)

    params['result'].each do |msg|
      request_content = {
        to: [msg['content']['from']],
        toChannel: 1383378250, # Fixed  value
        eventType: "138311608800106203", # Fixed value
        content: {
          contentType:1,
          toType:1,
          text: messages[idx]
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
