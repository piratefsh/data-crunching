oauth = ARGV[0]
infile = '_response.json'
outfile = '_attendees.csv'
if not oauth
	puts "usage: run <eventbrite oauth token>"
end

`ruby eventbrite.rb #{oauth} #{infile} >&2`
`ruby json-to-csv.rb #{infile} #{outfile}`
`ruby rgkl-data-crunch.rb #{outfile} >&2`