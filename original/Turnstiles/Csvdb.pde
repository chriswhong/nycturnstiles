//csvdb.pde
//based on tweetbase.pde by Dave Troy
public class Csvdb {
  String[] rows;
  int index;

  Csvdb() {

    rows = loadStrings("firstpass.csv");
    index = 0;
  }

  Row get(int index) {
    if (index<rows.length) {
      return new Row(rows[index]);
    }
    else {
      return null;
    }
  }

  Row next() {
    return this.get(index);
  }

  ArrayList<Row> rowsThrough(int maxTimestamp) {

    ArrayList<Row> rows = new ArrayList<Row>();
    Row row;
    do {
      row = this.next();
      if (row != null && row.timestamp<=maxTimestamp) {

        rows.add(row);
        index++;
      }
    } 
    while ( (row != null) && (row.timestamp<=maxTimestamp) );
    return rows;
  }
}
