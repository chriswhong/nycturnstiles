#!/usr/bin/env ruby
# Pull station data from db, matching desired station, start, and end date -- and put it into a hash
# Create an array of unique datetimes for the set
# Build a new hash which sums all the entry/exit data for each of those unique datetimes in the array.
## Resulting CSV is compatible with the plot_template.xlsx spreadsheet
# Finally create a 3rd hash to calculate & house the plot-ready interval data
## Resulting CSV is ready to plot with any web based plot tool.

require "csv"
require "fileutils.rb"
require "mysql"
#require "date"
#require "parsedate"
require "time"

# get station & date parameters
station = ARGV[0]
startdate = ARGV[1]
enddate = ARGV[2]   # add 1 day to end date programmatically and convert back to string. This is necessary fo the SQL query
	timeFmtStr="%Y-%m-%d"
	enddate = (Time.parse("'"+enddate+" 00:00:00'") + (60 * 60 * 24)).strftime(timeFmtStr)

#Set db session variables -- REPLACE THESE WITH YOUR OWN DB CREDENTIALS 
@host = ""
@user = ""
@pass = ""
@db = ""
@table = ""

$dates = Array.new
table = Hash.new(0)

$count=1

# open db connection & pull in station data, populate local hash, create unique/sorted/scrubbed date array
con = Mysql.connect(@host, @user, @pass, @db)
station_data = con.query("SELECT datetime, entries, exits FROM main WHERE remoteUnit = '"+ station +"' AND datetime >='" + startdate+ " 00:00:00' AND datetime < '" + enddate + " 00:00:00'")
con.close
		
	station_data.each do |t|
		datetime = t[0]
		entries = t[1]
		exits = t[2]

		$dates[$count-1] = datetime
		table[[$count-1,"datetime"]] = datetime
		table[[$count-1,"entries"]] = entries
		table[[$count-1,"exits"]] = exits
		#puts datetime + ", " + entries + ", " + exits

		$count += 1
	end
	#puts station + " data downloaded (" + startdate +" - " + enddate + ")"
	
	# de-dupe and sort array of dates [compaction may be necessary to eliminate nil values]
	# oh, and strip any dates that aren't :00:00 hour times.
	$dates.uniq!.sort!
	$dates.delete_if{ |z| z !~ /:00:00/ }
	#puts $dates

# write out unique timecodes with summed entries/exits. -- this datafile is compatible with the plot_template spreadsheet. 
writefile = File.open station+"_"+startdate+"_"+enddate+".csv","a"
	$count = 0
	table2 = Hash.new(0)
	$dates.each do |d|
		
			# now search hash (table) for all elements matching date (d)
		
			table2[[$count,"date"]] = d
		
			k = table.select{ |k,v| v == d}              # select from hash (table) rows matching current date (d) 
			ent = 0
			ex = 0
			k.each do |b|
				ent += table[[b[0][0],"entries"]].to_i   # add those entries/exits!
				ex += table[[b[0][0],"exits"]].to_i      #
			end
			
			# compile info into new hash (table2) [date, sum of entries across scp codes, sum of exits across scp codes]
			table2[[$count,"entries"]] = ent
			table2[[$count,"exits"]] = ex
		
			#output check
			#puts table2[[$count,"date"]] + ", " + table2[[$count,"entries"]].to_s + ", "+ table2[[$count,"exits"]].to_s
			writefile.puts table2[[$count,"date"]] + ", " + table2[[$count,"entries"]].to_s + ", "+ table2[[$count,"exits"]].to_s

			$count += 1			
	end

# write out final chart data intervals
writefile = File.open "chartdata_"+station+"_"+startdate+"_"+enddate+".csv","a"
	$count = 0
	plot = Hash.new(0)
	while $count < ($dates.length-1) do
		
			plot[[$count,"interval"]] = table2[[$count,"date"]].to_s + " - " + table2[[$count+1,"date"]].to_s
			plot[[$count,"entries"]] = table2[[$count+1,"entries"]] - table2[[$count,"entries"]]
			plot[[$count,"exits"]] = table2[[$count+1,"exits"]] - table2[[$count,"exits"]]
			
			#output check
			puts plot[[$count,"interval"]] + ", " + plot[[$count,"entries"]].to_s + ", "+ plot[[$count,"exits"]].to_s
			writefile.puts plot[[$count,"interval"]] + ", " + plot[[$count,"entries"]].to_s + ", "+ plot[[$count,"exits"]].to_s

			$count += 1			
	end	
		
