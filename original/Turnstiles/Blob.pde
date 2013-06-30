

public class Blob {


  ArrayList<Shot> shots;
  color trailColor;
  float lifespan;
  //lifespan for mid-trail tweets
  float lifespan2;
  Shot r = null;
  PVector loc = null;
  PVector loc2 = null;
  PVector loc3 = null;
  int nexttweettime;
  int firsttweettime;
  int timediff;
  int isnew;

  Shot shot;

  Shot s;

  Blob() {
    shots = new ArrayList<Shot>();

    lifespan = 255.0;
  }

  void add(Row r) {  //takes the provided row and creates shots, adding each shot to the Arraylist

    //add shots for each entry
    for (int j=0;j<(r.entries/50);j++) {

      shot = new Shot();
      shot.entry=true;
      //shot.starttime = int(random(r.timestamp, r.timestamp+(r.delay/2)));
      shot.starttime = int(random(r.timestamp, r.timestamp+(r.delay)));
      //shot.endtime = int(random(r.timestamp+(r.delay/2), r.timestamp+r.delay));
      shot.endtime = shot.starttime + r.delay;

      shot.home = screenLocation(r.lat, r.lon);
      //randomly assign a position, calculate velocity pvector to arrive at origin at endtime!!!
      float radius = random(20);
      float a = random(TWO_PI);
      float x = shot.home.x+cos(a )*radius;
      float y = shot.home.y+sin( a )*radius;



      shot.loc = new PVector(x, y);
      float timedelta = shot.endtime-shot.starttime;


      shot.velocity = new PVector((((shot.home.x-shot.loc.x)/timedelta)*interval), ((shot.home.y-shot.loc.y)/timedelta)*interval);
      //shot.velocity = new PVector(1,1);

      shots.add(shot);
    }
    //add shots for each exit
    for (int j=0;j<(r.exits/50);j++) {

      shot = new Shot();
      shot.entry=false;
      //shot.starttime = int(random(r.timestamp, r.timestamp+(r.delay/2)));
      shot.starttime = int(random(r.timestamp, r.timestamp+(r.delay)));
      //shot.endtime = int(random(r.timestamp+(r.delay/2), r.timestamp+r.delay));
      shot.endtime = shot.starttime + r.delay;

      shot.loc = screenLocation(r.lat, r.lon);
      //randomly assign a position, calculate velocity pvector to arrive at origin at endtime!!!
      float radius = random(20);
      float a = random(TWO_PI);
      float x = shot.loc.x+cos(a )*radius;
      float y = shot.loc.y+sin( a )*radius;



      shot.home = new PVector(x, y);
      float timedelta = shot.endtime-shot.starttime;


      shot.velocity = new PVector((((shot.home.x-shot.loc.x)/timedelta)*interval), ((shot.home.y-shot.loc.y)/timedelta)*interval);
      //shot.velocity = new PVector(1,1);

      shots.add(shot);
    }
  }



  void updateanddraw() {
    Iterator<Shot> it = shots.iterator();
    println(shots.size());
    while (it.hasNext ()) {
      s = it.next();

      // println("The current time is: " + currentTime);
      // println("This shot starts at: " + s.starttime);
      // println("This shot ends at: " + s.endtime);

      if (s.starttime>currentTime) {
        // it.remove();
      }
      else if (s.starttime<currentTime && s.endtime>currentTime) {   
        s.loc.add(s.velocity);
        noStroke();
        if (s.entry) {
          fill(#39a044, 50);
        }
        else{
          fill(#FF0000,50);
        }


        
        ellipse(s.loc.x, s.loc.y, 2, 2);
        //fill(#FF00FF);
        // ellipse(s.home.x,s.home.y,3,3);
      }
      else {
        it.remove();
        //println("Removed a shot!");
      }
    }
  }
}




