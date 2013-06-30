Based on @louiedog98's original turnstile script, I created three new scripts and a spreadsheet template, which enable you to transform a <a href="http://www.mta.info/developers/turnstile.html">raw data file</a> into a chart illustrating turnstile traffic at any MTA station. Obviously this can use some refactoring so it's a single script (and an interface for that matter), but this is a useable option for anyone familiar with the console.

<ol>

<li>Run <strong>regularize.rb</strong> on a raw turnstile file (<a href="https://github.com/nealrs/MTA-Turnstile-Data/blob/master/example/turnstile_130209.txt">turnstile_130209.txt</a>) to remove the 8x multiplexing and eliminate any non-'REGULAR' audit events.</li>

<li>Run  <strong>one_station.rb</strong> on the resulting file (<a href="https://github.com/nealrs/MTA-Turnstile-Data/blob/master/example/reg_turnstile_130209.txt">reg_turnstile_130209.txt</a>) & input the desired station / remoteUnit code (e.g R021 for Bryant Park. This will write out the station specific turnstile data. This takes a little while because it's looping over everything, so be patient. The script prints 'Dunzo' to the console once it's complete.</li>

<li>Run  <strong>compile_station.rb</strong> on the resulting file (<a href="https://github.com/nealrs/MTA-Turnstile-Data/blob/master/example/R021_reg_turnstile_130209.txt">R021_reg_turnstile_130209.txt</a>) to setup the charting data. The script first establishes a unique, sorted, set of datetime codes - and then it strips out any irregular audit times (e.g 4:15:09) so that it always represents 4 hour intervals. Next, it loops through the one_station data and sums entries & exits (across all scp codes) for each datetime. And of course, it writes out everything to a new file.</li>

<li>Finally, it's chart time. Follow the instructions in <strong><a href="https://github.com/nealrs/MTA-Turnstile-Data/blob/master/plot_template.xlsx">plot_template.xlsx</a></strong> and paste in the chart data (<a href="https://github.com/nealrs/MTA-Turnstile-Data/blob/master/example/sum_R021_reg_turnstile_130209.txt">sum_R021_reg_turnstile130209.txt</a>) to plot the data as shown below.</li>

</ol>

<strong>Note:</strong> Because I'm only using REGULAR, on-hour audit events, there are a few issues with the resulting data (notice how there is some data missing on Thursday?) - but I'm working on it!

![r021_13_02_09_plot](https://raw.github.com/nealrs/MTA-Turnstile-Data/master/example/R021_13_02_09_plot.png)
