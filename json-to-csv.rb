
require 'json'
require 'csv'

f 			= File.open('response.json', 'rb')
json 		= JSON.parse(f.read)
f.close 

attendees 	= json['attendees']

profile_headers = attendees.first['profile'].keys
answer_headers = []

attendees.first['answers'].each do |a|
	answer_headers.push a['question']
end

csv = CSV.open("attendees.csv", 'wb') do |csv|
	csv << (profile_headers + answer_headers)
	attendees.each do |a|
		# Profile
		p = a['profile']
		val = []
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
attendees.each do |a| 

end