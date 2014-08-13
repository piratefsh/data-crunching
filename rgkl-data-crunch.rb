# Open CSV file 
require 'csv'
require_relative 'csv-plus'
require_relative 'constants'

def divider()
	print "============================================\n"
end

def get_names(file)
	names = [];
	file.each do |person|
		names.push(person['Last Name'] + ", " + person['First Name'])
	end
	names
end

class Array
    def sum
        self.inject{|sum,x| sum + x }
    end
end

def print_programmed_in_tech(table)
	count = 0
	not_tech = []
	table.select_secondary($keys[:programmed], 'Yes', $keys[:job_title]).each do |job|
		tokens = job.downcase.split(' ')
		overlap = tokens & $job_tech_keywords
		if overlap.size > 0
			count = count + 1
		else 
			not_tech.push(job)

		end

	end
	puts "Out of those who have programmed %2.2f%% are in tech " % (count*100.0 / table.get_rows_with($keys[:programmed], 'Yes').size)
	puts "%2.2f%% of total %d applicants are in tech and have programmed (not our target group)" % [count*100.0/table.size, table.size]
	puts "\nJobs of those not in tech " + not_tech.uniq.to_s
	divider()
end

def print_students(table)
	jobs = table.get_values($keys[:job_title])
	count = 0
	jobs.each do |job|
		overlap = job.downcase.split(' ') & $student_keywords

		if overlap.size > 0
			count = count + 1
		end
	end

	puts "Students applicants are %d of %d (%2.2f%%)" % [count, table.size, count*100.0/table.size]
	divider()
end


def print_dates(table)
	date_range_format =  "From %s to %s (%d days)"
	dates = table.get_values($keys[:created]).sort

	start_date = Date.parse(dates.first)
	end_date = Date.parse(dates.last)

	date_format = '%d/%m/%Y'
	puts date_range_format % [start_date.strftime(date_format), end_date.strftime(date_format), end_date - start_date]
end
