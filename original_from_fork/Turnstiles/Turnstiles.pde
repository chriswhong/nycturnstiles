import java.util.*;
import java.text.*;
import java.io.*;

int interval, currentTime;
Csvdb db;
MercatorMap mercatorMap;
Row current;
BlobSystem blobSystem;
PImage mapImage;
PImage twitter;
PFont legendFont,header,small;
int tintamount = 50;


int cx, cy;
float secondsRadius;
float minutesRadius;
float hoursRadius;
float clockDiameter;
int radius = 150;

void setup() {
  //frameRate(10);
  size(1280, 720);
  smooth();

  mapImage = loadImage("nycbasemap2.png");
  image(mapImage, 0, 0, width, height);
 
  mercatorMap = new MercatorMap(1280, 720, 
  40.864459, 40.653816, -74.112053, -73.615265);

  legendFont = createFont("Century Gothic", 30);
   header = createFont("Century Gothic", 50);
   small = createFont("Century Gothic", 20);

  //mercatorMap = new MercatorMap(1280, 720, 
  //40.938156, 40.513016, -74.444733, -73.44223);

  interval = 300;

  db = new Csvdb();
  current = db.get(0);

  currentTime = current.timestamp;

  blobSystem = new BlobSystem();

  secondsRadius = radius * 0.72;
  minutesRadius = radius * 0.60;
  hoursRadius = radius * 0.50;
  clockDiameter = radius * 1.8;

  cx = 1025;
  cy = 400;
}

void draw() {
  tint(tintamount);
  image(mapImage, 0, 0, width, height);



  println("Blobs: " + blobSystem.size());

  ArrayList<Row> newRows = db.rowsThrough(currentTime);



  blobSystem.addRows(newRows);
  println("Where am I crashing?");
  blobSystem.draw();
  println("Where am I crashing?");
  currentTime += interval;


  // generate formatted date
  int offsetTime = currentTime + 14400;
  Date time = new java.util.Date((long)offsetTime*1000);
  DateFormat df = new SimpleDateFormat("EEEE MM/dd/yyyy HH:mm");
  String reportDate = df.format(time);
  DateFormat minsFormat = new SimpleDateFormat("m");
  String mins = minsFormat.format(time);
  int minsint = Integer.parseInt(mins);
  DateFormat hoursFormat = new SimpleDateFormat("h");
  String hours = hoursFormat.format(time);
  int hoursint = Integer.parseInt(hours);
  DateFormat apFormat = new SimpleDateFormat("a");
  String ap = apFormat.format(time);
  textAlign(CENTER);
  textFont(legendFont);
  fill(200);
  text(reportDate, 1025, 650);
  
  textFont(header);
  text("NYC Subway",  1025,100);
    text("Turnstile Data",  1025,160);
  //All below draws a clock face


textFont(small);
 text("Visualization by @chris_whong",  200,100);
 
 tint(255);
  twitter = loadImage("tweet.png");
   image(twitter,260,50);

  // Angles for sin() and cos() start at 3 o'clock;
  // subtract HALF_PI to make them start at the top

  float m = map(minsint + 0, 0, 60, 0, TWO_PI) - HALF_PI; 
  float h = map(hoursint + norm(minsint, 0, 60), 0, 24, 0, TWO_PI * 2) - HALF_PI;





  // Draw the hands of the clock
  stroke(255);

  strokeWeight(4);
  line(cx, cy, cx + cos(m) * minutesRadius, cy + sin(m) * minutesRadius);
  strokeWeight(6);
  line(cx, cy, cx + cos(h) * hoursRadius, cy + sin(h) * hoursRadius);

  // Draw the minute ticks
  strokeWeight(2);
  beginShape(POINTS);
  for (int a = 0; a < 360; a+=6) {
    float angle = radians(a);
    float x = cx + cos(angle) * secondsRadius;
    float y = cy + sin(angle) * secondsRadius;
    vertex(x, y);
  }
  endShape();

  textFont(legendFont);
  text(ap, 1025, 460);
  
  
   saveFrame("output/frames####.tiff");

}

PVector screenLocation(float lat, float lon) {
  return mercatorMap.getScreenLocation(new PVector(lat, lon));
}

