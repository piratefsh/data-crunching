require 'csv'
require_relative 'csv-plus'
require_relative 'constants'
require_relative 'rgkl-data-crunch'

file_name = ARGV[0];

if not file_name
	puts "usage: ruby filter-data.rb <infile>"
	abort
end

table = CSV.read(file_name, {:headers => true});

beginner = table.get_rows_with($keys[:programmed], 'No')
female = table.get_rows_with($keys[:gender], 'female')

puts

divider()
puts "Total %d Sign Ups" % table.length

print_dates(table)

table.print_stat($keys[:gender])
table.print_range($keys[:age])

table.print_stat($keys[:programmed])
print_programmed_in_tech(table)

print_students(table)

#puts 'Companies: ' + table.get_values($keys[:company]).uniq.to_s

target_total = (beginner & female).size
puts "Total female and beginner applicants: %d (%2.2f%%)" % [target_total, target_total * 100.0 / table.size]



puts