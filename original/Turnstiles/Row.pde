// Row.pde


public class Row {
  String identifier;
  int timestamp, delay, entries, exits, lifespan;
  float lat, lon;


  Row(String rowString) {
    String[] row = split(rowString, ',');
    
    identifier = row[1];
    timestamp = parseInt(row[4]);
    delay = parseInt(row[8]);
    entries = parseInt(row[9]);
    exits = parseInt(row[10]);
    lat = parseFloat(row[13]);
    lon = parseFloat(row[14]);

  
  }



  boolean isDead() {
    if (lifespan <= 0.0) {
      return true;
    } 
    else {
      return false;
    }
  }
}

