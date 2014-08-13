# Open CSV file 
require 'csv'

file_name = ARGV[0];
table = CSV.read(file_name, {:headers => true});

# Keys

$job_tech_keywords = %w(developer engineer it software programmer)
$student_keywords = %w(student intern)
$keys = {
	:created => 'created',
	:job_title => 'job_title',
	:age => 'age',
	:gender => 'gender',
	:programmed => "Have you programmed before?",
	:programmed_languages => "Which programming languages are you familiar with?"
}

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

class CSV::Table
	def get_rows_with(key, value)
	 	rows = [];
		self.each do |row|
			if row[key] == value 
				rows.push(row)
			end
		end
		rows
	end

	def get_values(key)

	 	val = [];
		self.each do |person|
			val.push(person[key])
		end
		val
	end

	def get_count(key)
	 	map = {}
		self.each do |row|
			v = row[key]

			if v 
				map[v] ||= 0 
				map[v] = map[v] + 1
			end
		end
		map
	end

	def print_stat(key)
		divider()
		val = self.get_count(key)
		if val.size <= 0
			puts "Column does not exist: " + key
			return
		end

		total = val.values.compact.sum

		puts key
		val.each do |k,v|
			puts "%10s : %3d (%2.1f %%)" % [k, v, v * 1.0 /total * 100]
		end

		divider()
	end

	def print_range(key)
		vals = get_values(key).compact

		if vals.size <= 0
			puts "Column does not exist: " + key
			return
		end

		format = "%10d to %d" 

		puts key 
		puts format % [vals.min, vals.max]

	end

	def select_secondary(key, val, sec_key)
		vals = [];
		self.get_rows_with(key, val).each do |r|
			vals.push(r[sec_key])
		end
		vals.compact
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
	puts "This means %2.2f%% of total %d applicants are in tech" % [count*100.0/table.size, table.size]
	# puts "\nJobs of those not in tech " + not_tech.to_s
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

	puts "Students are %d of %d (%2.2f%%)" % [count, table.size, count*100.0/table.size]
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

divider()
puts "Total %d Sign Ups" % table.length

print_dates(table)

table.print_stat($keys[:gender])
table.print_range($keys[:age])

table.print_stat($keys[:programmed])
print_programmed_in_tech(table)


print_students(table)
