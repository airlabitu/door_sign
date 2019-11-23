void runFunctions() {
  if (showFrames) {
    drawFrames();
  }
  if (showGrid) {
    drawGrid();
  }
  
  getColors();
  getFonts();
  responsiveSketch();
  
  if (frameCount%600 == 0) {
    //loadEventData();
    loadEventDataThisWeek();
    loadEventDataNextWeek();
  }
 
  
  drawTimeTable(headerThisWeekStartY, tableStartX, tableThisWeekStartY, "This week");
  drawTimeTable(headerNextWeekStartY, tableStartX, tableNextWeekStartY, "Next week");
  drawBottomInfo();
  
  if (frameCount%600==300) {
    //launch("/home/pi/sketchbook/date_grabber/application.linux-armv6hf/date_grabber");
    try {

      // print a message
      println("Executing date_grabber.pde");
      // create a process and execute date_grabber
      Process process = Runtime.getRuntime().exec("processing-java --sketch=/home/pi/sketchbook/date_grabber --run");

    } 
    catch (Exception ex) {
      ex.printStackTrace();
      println(ex);
    }
  }
}



void responsiveSketch() {
  int includeHalfs = 2;
  aspectWidth = 9 * includeHalfs; 
  //aspectHeight = 16 * includeHalfs;
  aspectHeight = 20 * includeHalfs;
  cell_w = (float)width/aspectWidth;
  cell_h = (float)height/aspectHeight;
  textSize = cell_h/3;
  
  //headerStartY = cell_h;
  headerThisWeekStartY = cell_h;
  headerNextWeekStartY = cell_h*18;
  //tableStartX = cell_w*2;
  //tableStartY = cell_h*6;
  
  tableStartX = cell_w*2;
  tableThisWeekStartY = cell_h*6;
  tableNextWeekStartY = cell_h*23;

  eventWidth = cell_w*2;

  switch(daysInCalendar) {
  case 5:
    dayWidth = 1.5;
    break;
  case 7:
    dayWidth = 1;
    break;
  case 14:
    dayWidth = 0.5;
    break;
  default:
    dayWidth = 0;
    println("ERROR! choose 5, 7 or 14 days in calendar (search for variable name: daysInCalendar)");
    break;
  }
}

void drawBottomInfo(){
  noStroke();
  fill(c_primary);
  rect(tableStartX, cell_h*35, cell_h, cell_h);
  text("AIR LAB open", tableStartX+cell_w, cell_h*35+cell_h/2);
  fill(c_secondary);
  rect(tableStartX, cell_h*36+cell_h/2, cell_h, cell_h);
  text("AIR LAB booked", tableStartX+cell_w, cell_h*36+cell_h);
  String links = "air@itu.dk | airlab.itu.dk | airlab.itu.dk/booking | facebook.com/airlabitu | instagram.com/air_lab_itu";
  text(links, width/2-textWidth(links)/2, cell_h*39);
  
  
}

int getDayIndex(String _day) {
  int dayIndex;
  switch(_day) {
  case "MONDAY":
    dayIndex = 0;
    break;
  case "TUESDAY":
    dayIndex = 1;
    break;
  case "WEDNESDAY":
    dayIndex = 2;
    break;
  case "THURSDAY":
    dayIndex = 3;
    break;
  case "FRIDAY":
    dayIndex = 4;
    break;
  case "SATURDAY":
    dayIndex = 5;
    break;
  case "SUNDAY":
    dayIndex = 6;
    break;
  default:
    dayIndex = 0;
    break;
  }
  return dayIndex;
}


//void drawTimeTable(float tableX, float tableY, String weekString) {
void drawTimeTable(float headerY, float tableX, float tableY, String weekString) {
  fill(c_primary);
  textAlign(CENTER, TOP);
  textFont(Prime, textSize*3);
  text("AIR Lab", width/2, headerY);
  textFont(RobotoMono, textSize*2);
  text(weekString, width/2, headerY+cell_h);

  stroke(c_text);
  strokeWeight(2);
  fill(c_text);
  textAlign(CENTER, CENTER);
  textFont(RobotoMono, textSize);
  for (int i = 0; i <= timeMax-timeMin; i++) {
    line(tableX, tableY+i*cell_h, width-cell_w-cell_w, tableY+i*cell_h);
    //line(tableStartX, tableStartY+i*cell_h, width-cell_w, tableStartY+i*cell_h);
    text(timeMin+i, cell_w+cell_w/2, tableY+i*cell_h);
  }

  textAlign(LEFT, CENTER);
  for (int i = 0; i < daysInCalendar; i++) {

    String dayFormatted = getDayInfo(i, "day").substring(0, 3).toLowerCase();
    text(dayFormatted, tableX+cell_w/2+eventWidth*i*dayWidth, tableY-cell_h*1.5);
    String dateFormatted = getDayInfo(i, "date");
    String monthFormatted = getDayInfo(i, "month");
    if (dateFormatted.length() < 2) {
      dateFormatted = "0" + dateFormatted;
    }
    if (monthFormatted.length() < 2) {
      dateFormatted = "0" + monthFormatted;
    }
    if (daysInCalendar != 14) {
      dateFormatted = dateFormatted + "." + monthFormatted;
    }
    text(dateFormatted, tableX+cell_w/2+eventWidth*i*dayWidth, tableY-cell_h);
  }
}


void drawFrames() {
  stroke(c_grid);
  strokeWeight(2);
  noFill();

  //Margin
  //rect(cell_w,cell_w,width-cell_w*2,height-cell_w*2);

  //Upper Half within margin
  rect(cell_w, cell_h, width-cell_w*2, height/2-cell_h);
  //Upper Half within margin
  rect(cell_w, height/2, width-cell_w*2, height/2-cell_h);
}




void drawGrid() {
  stroke(c_grid);
  strokeWeight(1);
  fill(c_grid);
  textAlign(CENTER, CENTER);
  for (int i = 0; i < aspectWidth; i++) {
    line(i*cell_w, 0, i*cell_w, height);
    text(i, cell_w/2+i*cell_w, cell_h/2);
  }
  for (int i = 0; i < aspectHeight; i++) {
    line(0, i*cell_h, width, i*cell_h);
    text(i, cell_w/2, cell_h/2+i*cell_h);
  }
}


void getFonts() {
  Prime = createFont("Prime", 32);
  Helvetica = createFont("Helvetica", 32);
  RobotoMono =  createFont("Roboto Mono", 32);
}


void getColors() {
  color c_white = color(255), c_black = color(0), c_pink = color(235, 115, 200), c_yellow = color(240, 245, 116), c_grey = color(150), c_blue = color(100, 125, 175);

  c_bg = c_white;
  c_text = c_black;
  c_primary = c_pink;
  c_secondary = c_blue;
  c_grid = c_grey;
}

void keyReleased() {
  if (key == 'f') {
    showFrames = !showFrames;
  }
  if (key == 'g') {
    showGrid = !showGrid;
  }
  println(getDayInfo(2, "date"));
}


void loadEventDataThisWeek() {
  openingHoursDataThisWeek = loadStrings("/home/pi/Documents/this_week/opening_hours_event_data.txt");
  bookingDataThisWeek = loadStrings("/home/pi/Documents/this_week/booking_event_data.txt");
  //eventsPerDay = new int[daysInCalendar];
  eventsThisWeek.clear();
  println("Event data cleared and loaded");
  
  for (int i = 0; i < openingHoursDataThisWeek.length; i ++) {
    //println(i + ": ", openingHoursData[i]);

    if (i%dataPerEvent == 0) {
      String wday = openingHoursDataThisWeek[i+1];
      int dayIndex = getDayIndex(wday);
      //eventsPerDay[dayIndex] += 1;
      eventsThisWeek.add(new Event(i, openingHoursDataThisWeek[i], wday, dayIndex, openingHoursDataThisWeek[i+2], openingHoursDataThisWeek[i+5], openingHoursDataThisWeek[i+6], c_primary, tableThisWeekStartY));
    }
  }
  for (int i = 0; i < bookingDataThisWeek.length; i ++) {
    if (i%dataPerEvent == 0) {
      String wday = bookingDataThisWeek[i+1];
      int dayIndex = getDayIndex(wday);
      //eventsPerDay[dayIndex] += 1;
      eventsThisWeek.add(new Event(i, bookingDataThisWeek[i], wday, dayIndex, bookingDataThisWeek[i+2], bookingDataThisWeek[i+5], bookingDataThisWeek[i+6], c_secondary, tableThisWeekStartY));
    }
  }

  //println("EVENTS PER DAY");
  //printArray(eventsPerDay);
}

void loadEventDataNextWeek() {
  openingHoursDataNextWeek = loadStrings("/home/pi/Documents/next_week/opening_hours_event_data.txt");
  bookingDataNextWeek = loadStrings("/home/pi/Documents/next_week/booking_event_data.txt");
  //eventsPerDay = new int[daysInCalendar];
  eventsNextWeek.clear();
  println("Event data cleared and loaded");
  
  for (int i = 0; i < openingHoursDataNextWeek.length; i ++) {
    //println(i + ": ", openingHoursData[i]);

    if (i%dataPerEvent == 0) {
      String wday = openingHoursDataNextWeek[i+1];
      int dayIndex = getDayIndex(wday);
      //eventsPerDay[dayIndex] += 1;
      eventsNextWeek.add(new Event(i, openingHoursDataNextWeek[i], wday, dayIndex, openingHoursDataNextWeek[i+2], openingHoursDataNextWeek[i+5], openingHoursDataNextWeek[i+6], c_primary, tableNextWeekStartY));
    }
  }
  for (int i = 0; i < bookingDataNextWeek.length; i ++) {
    if (i%dataPerEvent == 0) {
      String wday = bookingDataNextWeek[i+1];
      int dayIndex = getDayIndex(wday);
      //eventsPerDay[dayIndex] += 1;
      eventsNextWeek.add(new Event(i, bookingDataNextWeek[i], wday, dayIndex, bookingDataNextWeek[i+2], bookingDataNextWeek[i+5], bookingDataNextWeek[i+6], c_secondary, tableNextWeekStartY));
    }
  }

  //println("EVENTS PER DAY");
  //printArray(eventsPerDay);
}


String getDayInfo(int dayToGet, String infoToGet) {
  String dayData;
  LocalDate startOfWeek = LocalDate.now();
  startOfWeek = startOfWeek.minusDays(startOfWeek.getDayOfWeek().getValue()-1);

  String day = ""+startOfWeek.plusDays(dayToGet).getDayOfWeek();
  String date = ""+startOfWeek.plusDays(dayToGet).getDayOfMonth();
  String month = ""+startOfWeek.plusDays(dayToGet).getMonthValue();
  String year= ""+startOfWeek.plusDays(dayToGet).getYear();

  switch(infoToGet) {
  case "day":
    dayData = day;
    break;
  case "date":
    dayData = date;
    break;
  case "month":
    dayData = month;
    break;
  case "year":
    dayData = year;
    break;
  default:
    dayData = "PLEASE SPECIFY DATA TO GET IN getDayInfo()";
    break;
  }

  //dayData = day+date+month+year;

  return dayData;
}

//println(startOfWeek.getDayOfWeek(),startOfWeek.getDayOfMonth() + "/" + startOfWeek.getMonthValue());
