import java.time.*;

ArrayList <Event> eventsThisWeek = new ArrayList<Event>();
ArrayList <Event> eventsNextWeek = new ArrayList<Event>();
//ArrayList <Event> events = new ArrayList<Event>();
//String[] openingHoursData, bookingData;
String[] openingHoursDataThisWeek, bookingDataThisWeek, openingHoursDataNextWeek, bookingDataNextWeek;
int dataPerEvent = 7;


//Styles
PFont Prime, Helvetica, RobotoMono;
color c_bg, c_text, c_box, c_primary, c_secondary, c_grid;
float textSize;

//Time
int daysInCalendar = 5; // Must choose 5, 7 or 14
int timeMin = 8, timeMax = 19;
//int[] eventsPerDay = new int[daysInCalendar];

//Responsive Grid
int aspectWidth, aspectHeight;
float cell_w, cell_h, headerThisWeekStartY, headerNextWeekStartY, tableStartX, tableThisWeekStartY, tableNextWeekStartY, eventWidth, dayWidth;
//float cell_w, cell_h, headerStartY, tableStartX, tableStartY, eventWidth, dayWidth;

//Toggle functions
boolean showFrames, showGrid;

void setup() {
  //fullScreen();
  size(900, 1000);
  frameRate(1);
  smooth(4);
  //println(frameCount%60);
  responsiveSketch();
  runFunctions();
  //loadEventData();
  //loadEventDataThisWeek();
  //loadEventDataNextWeek();
}

void draw() {
  background(c_bg);
  runFunctions();
  //println();
  for (int i = 0; i < eventsThisWeek.size(); i ++) {
    //println("TW: " + i);
    Event eventT = eventsThisWeek.get(i);
    //if (eventT.eventAdded()) {
      //println("added TW");
      eventT.display();
    //}
  }
  
  for (int i = 0; i < eventsNextWeek.size(); i ++) {
    //println("NW: " + i);
    Event eventN = eventsNextWeek.get(i);
    //if (eventN.eventAdded()) {
      //println("added NW");
      eventN.display();
    //}
  }
  
  /*
  for (int i = 0; i < events.size(); i ++) {
    Event event = events.get(i);
    if (event.eventAdded()) {
      event.display();
    }
  }
  */
}
