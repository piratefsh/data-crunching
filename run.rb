oauth = ARGV[0]

if not oauth
	puts "usage: run <eventbrite oauth token>"
end

`ruby eventbrite.rb #{oauth}`
`ruby json-to-csv.rb`
`ruby rgkl-data-crunch.rb attendees.csv >&2`