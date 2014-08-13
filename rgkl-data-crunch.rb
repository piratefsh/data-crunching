# Open CSV file 
require 'csv'

file_name = ARGV[0];
table = CSV.read(file_name, {:headers => true});

# Keys
age = 'Age'
gender = 'Gender'
$programmed = "Have you programmed before?"
$programmed_languages = "Which programming languages are you familiar with?"

$job_tech_keywords = %w(developer engineer it software programmer)

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
		vals
	end
end 


def print_programmed_in_tech(table)
	count = 0
	table.select_secondary($programmed, 'Yes', 'Job Title').each do |job|
		tokens = job.downcase.split(' ')
		overlap = tokens & $job_tech_keywords
		if overlap.size > 0
			count = count + 1
		end
	end
	puts "Out of those who have programmed %2.2f%% are in tech " % (count*100.0 / table.get_rows_with($programmed, 'Yes').size)
	divider()
end

divider()
puts "Total %d Sign Ups" % table.length
table.print_stat(gender)
table.print_range(age)

table.print_stat($programmed)
print_programmed_in_tech(table)



