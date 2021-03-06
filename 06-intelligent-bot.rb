require 'slack-ruby-bot'
require 'http'

class Bot < SlackRubyBot::Bot
  match(/^(?<bot>\w*)\s(?<expression>.*)$/) do |client, data, match|
    expression = match['expression'].strip
    results = JSON.parse HTTP.get("https://www.googleapis.com/customsearch/v1", params: {
      q: expression,
      key: ENV['GOOGLE_API_KEY'],
      cx: ENV['GOOGLE_CSE_ID']
    })
    result = results['items'].first
    next unless result
    message = result['title'] + "\n" + result['link']
    client.message channel: data.channel, text: message
  end
end

Bot.instance.run
