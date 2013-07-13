// TrailSystem.pde
// (c) 2012 David Troy (@davetroy)
//
// TrailSystem is a wrapper for a Hashtable that tracks trails for individual objects
// in this case, the keys are screenNames associated with tweets. We keep all of the
// active trails in the TrailSystem. When a trail finally fades out and dies, we remove
// it from the system. The system is also responsible for rotating through our color palette.
// (Two palettes provided, courtesy of Friends of the Web, Baltimore -- one dark, one light --
// note that hex colors are provided in 32-bit alpha+rgb order format.)

class BlobSystem {
  Hashtable blobs;



  BlobSystem() {
    blobs = new Hashtable();
  }



  Blob findOrCreateBlob(String identifier) {
    Blob blob = (Blob)blobs.get(identifier);
    if (blob == null) {
      blob = new Blob();
      blobs.put(identifier, blob);
    }
    return blob;
  }





  void addRows(ArrayList<Row> rows) {    
    Iterator<Row> it = rows.iterator();
    while (it.hasNext ()) {
      Row r = it.next();

      //create an arraylist

        Blob blob = findOrCreateBlob(r.identifier);
        blob.add(r);//this should make multiple arraylists, one for each movement... I think I need another class for this
    }
  }

  int size() {
    return blobs.size();
  }

  void draw() {
      if (blobSystem.size()==0)
      exit();
      
      Iterator<Blob> it = blobs.values().iterator();
    while (it.hasNext ()) {
      Blob bl = it.next();
       
        bl.updateanddraw();
      


    }
    
  }
}

