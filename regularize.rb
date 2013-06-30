#!/usr/bin/env ruby
# this script loops through datafile for REGULAR audit events -- 
# and prints each event on it's own line instead of the 8 column multiplex format from the MTA.
# the script also creates a datetime string for use with excel that combines the data & time.

require "csv"
require "fileutils.rb"
#require "date"
#require "parsedate"

$tfile = ARGV[0]
$count=1

readfile = CSV.open $tfile, "r"
writefile = File.open "reg_"+$tfile,"a"
		readfile.each do |t|
			controlArea = t[0]
			remoteUnit = t[1]
			scp = t[2]
			
			# set up looping structure since 8 groups of data per line
			i=0
			while i<8
				
				# only record 'regular' audit events 
				if t[5+(5*i)] == "REGULAR"
					date = t[3+(5*i)]
					break if date.nil?
					time = t[4+(5*i)]
					type = t[5+(5*i)]
					entries = t[6+(5*i)]
					exits = t[7+(5*i)]
					
					datetime_string = (date + " " + time)					
					#format = "%m-%d-%y %H:%M:%S"
					
					# datetime is more important sorting criteria than the scp code, especially since we're just going to sum across all scps. 
					# and i'm not sure controlArea matters at all, but we'll keep it for now
					writefile.puts controlArea + "," + remoteUnit + "," + datetime_string + "," + scp + "," + entries + "," + exits
					puts $count.to_s() + " " + controlArea + "," + remoteUnit + "," + datetime_string + "," + scp + "," + entries + "," + exits

				end
					i = i+1
					
			end
			$count = $count+1
			
			
		end
