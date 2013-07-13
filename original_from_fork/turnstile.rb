#!/usr/bin/env ruby

require "csv"
require "fileutils.rb"

$tfile = ARGV[0]
$count=1

readfile = CSV.open $tfile, "r"
writefile = File.open "mod_"+$tfile,"a"
		readfile.each do |t|
			controlArea = t[0]
			remoteUnit = t[1]
			scp = t[2]
			
			i=0
			while i<8
				date = t[3+(5*i)]
				break if date.nil?
				time = t[4+(5*i)]
				
				type = t[5+(5*i)]
				
				entries = t[6+(5*i)]
			
				exits = t[7+(5*i)]
			
				
				
				
				writefile.puts controlArea + "," + remoteUnit + "," + scp + "," + date + "," + time + "," + type + "," + entries + "," + exits
				
				
				puts $count.to_s() + " " +controlArea + "," + remoteUnit + "," + scp + "," + date + "," + time + "," + type + "," + entries + "," + exits
				
				
				i = i+1
			end
			$count = $count+1
			
			
		end