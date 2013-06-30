Based on Chris Whong's <a href="https://github.com/louiedog98/nycturnstiles">original project</a>, these scripts take <a href="http://www.mta.info/developers/turnstile.html">raw MTA turnstile data files</a> and  generate plot ready data for charting turnstile traffic at any station. And yep, an online interface is next on the docket - so stay tuned!

<ul>

  <li><strong>load_db.rb</strong> takes a raw <a href="https://github.com/nealrs/MTA-Turnstile-Data/blob/master/example/turnstile_130209.txt">turnstile file</a>, strips out non-'REGULAR' audit events, and stores it in a MySQL database. Obviously - you'll want to change the db parameters to reflect your own.</li> 

	<li><strong>get_data.rb</strong> takes 3 parameters: remoteUnit code, start, and end date, (e.g './get_data.rb R021 2013-02-02 2013-02-08' for Bryant Park), queries the db, and exports two data files: 

	<ol>
		<li>A <a href="https://github.com/nealrs/MTA/blob/db/example/R021_2013-02-02_2013-02-09.csv">CSV</a> summary of the cumulative entry & exit traffic for each audit event. Paste this into the included <a href="https://github.com/nealrs/MTA-Turnstile-Data/blob/master/plot_template.xlsx">spreadsheet</a> to create charts like the one shown below.</li>
		
		<li>A <a href="https://github.com/nealrs/MTA/blob/db/example/chartdata_R021_2013-02-02_2013-02-09.csv">CSV</a> of plot ready data suitable for any charting software/API.</li>
	</ol>
	
	</li>

</ul>

<strong>Note:</strong> Because the scripts strip non-'REGULAR' & off-hour audit events, there are a few issues with the resulting data (notice how there is some data missing for Thursday?) - but I'm working on it!

![r021_13_02_09_plot](https://raw.github.com/nealrs/MTA/master/example/R021_13_02_09_plot%20copy.png)


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/nealrs/MTA/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

