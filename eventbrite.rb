require 'rest_client'
require 'json'
require 'csv'

token = ARGV[0]
outfile = ARGV[1]

page = 1

if not token or not outfile
	puts 'Usage: ruby eventbrite.rb <oauth token> <outfile>'
	abort
end

root_uri 	= "http://eventbriteapi.com/v3"
orders_uri 	= root_uri + "/orders/"
event_uri 	= root_uri + "/events/"
attendee_uri = root_uri + "/events/%s/attendees/%s/" 
attendees_uri = root_uri + "/events/%s/attendees"

event_id 	= "12457844749"

url = URI.parse((attendees_uri) % event_id)

puts "GET " + url.path

def do_get(url, token, page)
	response = RestClient.get(url.to_s, {:accept => 'json', :params => {
	:token => token,
	:page => page,
	}});
	response
end


total_pages = 9999
response = nil
data = nil

while page < total_pages do 
	response = do_get(url, token, page)

	response_json = JSON.parse(response.body)
	total_pages = response_json['pagination']['page_count']

	if page == 1
		data = response_json
	else
		puts data['attendees'].size
		data['attendees'] << response_json['attendees']
	end

	page = page + 1
end

f = File.new(outfile, 'w')
f.puts(data.to_json)
f.close