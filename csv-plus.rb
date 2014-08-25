require 'csv'

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
	def get_rows_with_conditions(pairs)
	 	rows = [];
		self.each do |row|
			push = true
			pairs.each do |key, value|
				if row[key] != value 
					push = false
				end
			end

			rows.push(row) if push
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



