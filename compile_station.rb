#!/usr/bin/env ruby
# This script takes the output from one_staton.rb, creates a hash of the data, and
# iterates over that data to compile an array of unique timecodes for that station's dataset.
# Next we loop through the date array and search the original hash for all instances of that date.
# During this last loop, we populate a new hash with the sum of the entries/exits for each date
# this puts us only 1 step (intervals) away from plot-worthy data.

require "csv"
require "fileutils.rb"
#require "date"
#require "parsedate"
require "pp"

$tfile = ARGV[0]
#$station = ARGV[1]
$count = 1
$dates = Array.new
table = Hash.new(0)

readfile = CSV.open $tfile, "r"
		readfile.each do |t|
			
			$dates[$count-1] = t[2]

			table[[$count-1,"controlArea"]] = t[0]
			table[[$count-1,"remoteUnit"]] = t[1]
			table[[$count-1,"datetime"]] = t[2]
			table[[$count-1,"scp"]] = t[3]
			table[[$count-1,"entries"]] = t[4]
			table[[$count-1,"exits"]] = t[5]
			
			#puts table[[$count-1,"controlArea"]] + ", " + table[[$count-1,"remoteUnit"]] + ", " + table[[$count-1,"datetime"]] + ", " + table[[$count-1,"scp"]] + ", " + table[[$count-1,"entries"]] + ", " + table[[$count-1,"exits"]]			
			
			$count += 1
		end
		
		#de-duped and sort array of dates [compaction may be necessary to eliminate nil values]
		$dates.uniq!.sort!
		
		#puts "date array complete"
		#puts $dates


# loop through date array and check hash for all elements that match current date. 
# then sum entries/exits and assign them to the new hash called (table2) containing [date][entries][exits].
# oh yeah, and write the whole thing to file.

writefile = File.open "sum_"+$tfile,"a"
	$count = 0
	table2 = Hash.new(0)
	$dates.each do |d|
		
			# now search hash (table) for all elements matching date (d)
			# and then compile info into new hash.	[date, sum of entries across scp codes, sum of exits across scp codes]
		
			table2[[$count,"date"]] = d
		
			k = table.select{ |k,v| v == d}
			ent = 0
			ex = 0
			k.each do |b|
				ent += table[[b[0][0],"entries"]].to_i
				ex += table[[b[0][0],"exits"]].to_i
			end
		
			table2[[$count,"entries"]] = ent
			table2[[$count,"exits"]] = ex
		
			#output check
			puts table2[[$count,"date"]] + ", " + table2[[$count,"entries"]].to_s + ", "+ table2[[$count,"exits"]].to_s
			writefile.puts table2[[$count,"date"]] + ", " + table2[[$count,"entries"]].to_s + ", "+ table2[[$count,"exits"]].to_s

			$count += 1			
	end
