
require 'json'
require 'csv'

infile = ARGV[0]
outfile = ARGV[1]

if not infile or not outfile
	puts 'usage: ruby json-to-csv.rb <infile> <outfile>'
	abort
end


f 			= File.open(infile, 'rb')

if not f 
	puts 'Cannot open file: ' + infile
	abort
end

json 		= JSON.parse(f.read)
f.close 

attendees 	= json['attendees']

profile_headers = attendees.first['profile'].keys
answer_headers = []

attendees.first['answers'].each do |a|
	answer_headers.push a['question']
end

csv = CSV.open(outfile, 'wb') do |csv|
	csv << (['created'] + profile_headers + answer_headers)
	attendees.each do |a|
		# Profile
		p = a['profile']
		val = []

		# Date registered
		date = a['created']
		val.push date

		profile_headers.each do |k|
			val.push p[k]
		end

		# Answers
		ans = a['answers']
		ans.each do |a|
			val.push a['answer']
		end

		csv << val
	end
	
end
