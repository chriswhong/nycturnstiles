#!/usr/bin/env ruby
# Load an MTA turnstile file into db  -- taking care of the annoying 8x multiplexing & only storing REGULAR events
# This script needs to be be converted to DBI.

require "csv"
require "fileutils.rb"
require "mysql"
require "date"
#require "parsedate"

$tfile = ARGV[0]
$count=1

readfile = CSV.open $tfile, "r"

#Set db session variables
@host = "mta.nealshyam.com"
@user = "ns_mta"
@pass = "ranc1dm3at"
@db = "turnstile"
@table = "main"

# open db connection
con = Mysql.connect(@host, @user, @pass, @db)

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
					
					# set up datetime field (kind of hacky, but it works)
					dt_string = (date + " " + time)	
					format = "%m-%d-%y %H:%M:%S"
					datetime = DateTime.strptime(dt_string, format)														
					timeFmtStr="%Y-%m-%d %H:%M:%S"
					datetime = datetime.strftime(timeFmtStr)
					
					# write to db & console
					con.query("INSERT INTO " + @table + "(controlArea, remoteUnit, scp, datetime, type, entries, exits) VALUES('"+controlArea+"', '"+remoteUnit+"', '"+scp+"', '"+datetime+"', '"+type+"', '"+entries+"', '"+exits+"' )")
					
					puts $count.to_s() + " " + controlArea + "," + remoteUnit + "," + datetime.to_s + "," + scp + "," + entries + "," + exits

				end
				i = i+1	
			end
			$count = $count+1
		end
con.close

puts "dunzo!"		