#!/usr/bin/env ruby
# this script takes the output from regularize.rb and writes out all the data associated with one station remoteUnit code.
# this operation can take a while since we're looping over the entire file with an if statement. this can probably be sped up.

require "csv"
require "fileutils.rb"
#require "date"
#require "parsedate"

$tfile = ARGV[0]
$station = ARGV[1]
$count = 1

readfile = CSV.open $tfile, "r"
writefile = File.open $station +"_"+$tfile,"a"
		readfile.each do |t|
			
			if t[1] == $station
				controlArea = t[0]
				remoteUnit = t[1]
				datetime = t[2]
				scp = t[3]
				entries = t[4]
				exits = t[5]
			
				#format = "%m-%d-%y %H:%M:%S"
				#datetime = DateTime.strptime(datetime, format)
					
				writefile.puts controlArea + "," + remoteUnit + "," + datetime + "," + scp + "," + entries + "," + exits
				puts $count.to_s() + " " + controlArea + "," + remoteUnit + "," + datetime + "," + scp + "," + entries + "," + exits
			
			end
			$count = $count+1
			
		end
		
		puts "Dunzo"