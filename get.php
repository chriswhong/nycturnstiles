<?php

if (!empty($_GET["remote"])) {$remote = $_GET["remote"]; } //else {$remote = "R021";}

if (!empty($_GET["dates"])){
	// transform dates, etc.
	$start = substr($_GET["dates"], 6,4)."-".substr($_GET["dates"], 0,2)."-".substr($_GET["dates"], 3,2)." 00:00:00";
	$end = substr($_GET["dates"], 20,4)."-".substr($_GET["dates"], 14,2)."-".substr($_GET["dates"], 17,2);
} /*else {
	$start = "2013-02-02 00:00:00";
	$end = "2013-02-08";
  }*/

// define a function to go pull the neccesary plot data.
function get_data($remote, $start, $end){

		// convert to time, add a day and convert back (kind of inefficient, but ugh, it was in ruby too.
		$date = date_create($end);
		$date ->modify('+1 day');
		$end =  date_format($date, 'Y-m-d')." 00:00:00";

	// MYSQL PDO INIT
			$db = new PDO('mysql:host=mta.nealshyam.com; dbname=turnstile; charset=UTF-8', 'mtauser', 'mtauser');
			$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
			$db->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
			$db_table="main";
	// END MYSQL INIT
		
	// BEGIN LOOPED MYSQL PDO CODE
		
			// get unique/sorted datetime array 	
			//$load_dates = $db->prepare("SELECT DISTINCT datetime FROM main WHERE remoteUnit = ? AND datetime >= ? AND datetime < ? AND datetime REGEXP ':00:00' ORDER BY datetime ASC");
			$load_dates = $db->prepare("SELECT DISTINCT datetime FROM main WHERE remoteUnit = ? AND datetime >= ? AND datetime <= ? AND MINUTE(datetime) = 0 AND SECOND(datetime) = 0 ORDER BY datetime ASC");

			$load_dates->execute(array($remote, $start, $end));

			$dates = array();
			$alt=0;
		
			while($row = $load_dates->fetch(PDO::FETCH_ASSOC)){
				$dates[$alt] = $row['datetime'];
			
				//print $dates[$alt]."<br>\r\n";
				
				$alt++;	
			}
			//var_dump($dates);
		
			// pull entry/exit data for specific station & time range
			//$load_data = $db->prepare("SELECT datetime, entries, exits FROM main WHERE remoteUnit = ? AND datetime >= ? AND datetime < ? AND datetime REGEXP ':00:00' ");
			$load_data = $db->prepare("SELECT datetime, entries, exits FROM main WHERE remoteUnit = ? AND datetime >= ? AND datetime <= ? AND MINUTE(datetime) = 0 AND SECOND(datetime) = 0");
			$load_data->execute(array($remote, $start, $end));

			$table = array();
			$alt=0;
		
			while($row = $load_data->fetch(PDO::FETCH_ASSOC)){
				$table[$alt] = array();
			
				$datetime = $row['datetime'];
				$entries = $row['entries'];
				$exits = $row['exits'];

				$table[$alt][0] = $datetime;
				$table[$alt][1] = (int) $entries;
				$table[$alt][2] = (int) $exits;
			
				$alt++;	
			}
			//var_dump($table);
		
			// close mysql connection
			$db = null;
		
			// establish array of 'sums' for each timecode
			$sum_table = array();
			$alt=0;
		
			foreach ($dates as &$d) {
				$ent=0;
				$ex=0;
				foreach ($table as &$row){
					if ($row[0] == $d){
						$ent += $row[1];
						$ex  += $row[2];	
					}
				}
			
				$sum_table[$alt] = array();
				$sum_table[$alt][0] = $d;
				$sum_table[$alt][1] = $ent;
				$sum_table[$alt][2] = $ex;
			
				$alt++;
			}
			//var_dump($sum_table);
				
			// establish plot-ready data intervals
			$plot_ent =array();
			$plat_ex = array();
			$data_table = array();
			
			$alt=0;
		
			while ($sum_table[$alt+1][0]){
						
				$plot_ent[$alt]['x'] = $sum_table[$alt+1][0]; 						// end of interval date
				$plot_ex[$alt]['x'] =  $sum_table[$alt+1][0]; 						// end of interval date
				
				$tent = $sum_table[$alt+1][1] - $sum_table[$alt][1]; 				// cumulative entries
				$tex  = $sum_table[$alt+1][2] - $sum_table[$alt][2]; 				// cumulative exits
			
				// if interval value is far out of range (>=40,000 or <0), set to zero and create a hole in the chart instead.
				// need to find a better way to adjust for this (what is traffic like at TSQ/busiest station in system?!
				if ($tent < 0 || $tent >= 40000){$tent = 0; }
				if ($tex < 0 || $tex >= 40000){$tex = 0;}
			
				$plot_ent[$alt]['y'] = $tent; 										// entries [interval] 
				$plot_ex[$alt]['y'] =  $tex; 										// exits [interval]
				
				
				// original full data table export, no data adjustments
				$data_table[$alt]['s_date'] =  $sum_table[$alt][0]; 				// stop date
				$data_table[$alt]['s_ent'] =  $sum_table[$alt][1]; 					// start entries
				$data_table[$alt]['s_ex'] =  $sum_table[$alt][2]; 					// start exits
				
				$data_table[$alt]['e_date'] =  $sum_table[$alt+1][0]; 				// end date
				$data_table[$alt]['e_ent'] =  $sum_table[$alt+1][1]; 				// end entries
				$data_table[$alt]['e_ex'] =  $sum_table[$alt+1][2]; 				// end exits
			
				$alt++;
			
			}
			//var_dump($plot);
			
				//var_dump(json_encode($plot_ent));
				//var_dump(json_encode($plot_ex));
			
			$json = json_encode( array( "entries" => $plot_ent, "exits" => $plot_ex, "table" => $data_table));
			echo $json;
}

list($pent,$pex) = get_data($remote, $start, $end);

?>