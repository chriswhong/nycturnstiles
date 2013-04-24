nycturnstiles
=============

Scripts that tinker with the MTA's turnstile data

turnstile.rb parses the oh-so-ugly format that the MTA delivers turnstile data in and makes each reading into a single line with the following columns:

Control Area, Remote Unit, SCP, Date, Time, Type, Entries, and Exits

Pass it a turnstile file as an argument and it will spit out output.txt

TODO: 

-Add station names based on Remote Unit Lookup
-Consolidate

MTA turnstile data is available here:

http://www.mta.info/developers/turnstile.html


Update 4/24/2013:

Added Processing Sketch for this animation:  http://www.youtube.com/watch?v=g6EaMQDHu7Q&feature=youtu.be

Added geocodedstations.csv - This is the answer key for mapping MTA turnstile data.  It was hand-jammed on 4/23/2013 with help from Mala Hertz