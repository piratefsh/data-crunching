require 'rest_client'
require 'json'
require 'csv'

token = ARGV[0]
outfile = ARGV[1]

if not token or not outfile
	puts 'Usage: ruby eventbrite.rb <oauth token> <outfile>'
	abort
end

root_uri 	= "http://eventbriteapi.com/v3"
orders_uri 	= root_uri + "/orders/"
event_uri 	= root_uri + "/events/"
attendee_uri = root_uri + "/events/%s/attendees/%s/" 
attendees_uri = root_uri + "/events/%s/attendees"

oauth_token = '?token=' + ARGV[0]
event_id 	= "12457844749"

url = URI.parse((attendees_uri + oauth_token) % event_id)

puts "GET " + url.path

response = RestClient.get(url.to_s, {:accept => 'json'});

response_json = JSON.parse(response.body)

f = File.new(outfile, 'w')
f.puts(response.body)
f.close