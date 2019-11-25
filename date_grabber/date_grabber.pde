import java.util.*;
import java.time.*;
import java.time.format.*;

String icsUrlBooking;
String icsUrlOpeningHours;
//String bookingOutputFileNameTh;
//String openingHoursOutputFileName;

DateGrabber bookingThisWeek;
DateGrabber openingHoursThisWeek;

DateGrabber bookingNextWeek;
DateGrabber openingHoursNextWeek;

void setup(){
  size(100,100);
  background(255);
  icsUrlBooking = loadStrings("icsUrl.txt")[0];
  icsUrlOpeningHours = loadStrings("icsUrl.txt")[1];
  //bookingOutputFileName = "/home/pi/Documents/this_week/booking_event_data";
  //openingHoursOutputFileName = "/home/pi/Documents/this_week/opening_hours_event_data";
  bookingThisWeek = new DateGrabber(icsUrlBooking, "/home/pi/Documents/this_week/booking_event_data");
  openingHoursThisWeek = new DateGrabber(icsUrlOpeningHours, "/home/pi/Documents/this_week/opening_hours_event_data");
  bookingThisWeek.run(0); // this week = offset 0 days
  openingHoursThisWeek.run(0); // this week = offset 0 days
  
  bookingNextWeek = new DateGrabber(icsUrlBooking, "/home/pi/Documents/next_week/booking_event_data");
  openingHoursNextWeek = new DateGrabber(icsUrlOpeningHours, "/home/pi/Documents/next_week/opening_hours_event_data");
  bookingNextWeek.run(7); // next week offset 7 days
  openingHoursNextWeek.run(7); // next week offset 7 days
  
  //println("test_2");
  //delay(5000);
  exit();
}


class DateGrabber {

  
  private String icsUrl;// = loadStrings("icsUrl.txt")[0]; // ### loads ics url links from the data folder. --- [0] is booking calendar, [1] is lab opening hours.
  private String [] icsFile;// = loadStrings(icsUrl);
  private String [] calendarEventInfo; // Array for storing event info, used to generate textfile from at the end
  private String outputFileName;

  public DateGrabber(String icsUrl, String outputFileName) {
    this.icsUrl = icsUrl;
    this.outputFileName = outputFileName;
  }

  public void run(int daysOffset) {
    println("FN: " + outputFileName);
    int iterator = 0;
    int count = 0;
    icsFile = loadStrings(icsUrl);
    if (icsFile==null) {
      println("NULL ERROR");
      exit();
    } else { // ics data load sucessfull

      // Count the number of calendar events in the ics file  
      for (int i = 0; i < icsFile.length; i++) {
        if (icsFile[i].indexOf("DTSTART") != -1 && icsFile[i+1].indexOf("DTEND") != -1) {
          count++;
          //println("Hit count ", count, count*7);
        }
      }
      calendarEventInfo = new String[count*7]; // ### 7 is the number of array fields one event used
      LocalDate startOfWeek = LocalDate.now();
      LocalDate endOfWeek;
      println("DO: " + daysOffset);
      println("SW 1: " + startOfWeek.toString());
      startOfWeek = startOfWeek.minusDays(startOfWeek.getDayOfWeek().getValue()-1);
      println("SW 2: " + startOfWeek.toString());
      startOfWeek = startOfWeek.plusDays(daysOffset);
      println("SW: 3: " + startOfWeek.toString());
      endOfWeek = startOfWeek.plusDays(6);
      println("EW: " + endOfWeek.toString());



      for (int i = 0; i < icsFile.length; i++) { // traverses each line of the ics file

        if (icsFile[i].indexOf("DTSTART") != -1 && icsFile[i+1].indexOf("DTEND") != -1) { // an event begin line has been reached

          // start date
          String date = split(icsFile[i], "Time:")[1];
          String [] container = split(date, "T"); // generates array where date isn on in field [0] and time is in filed [1].

          DateTimeFormatter formatter = DateTimeFormatter.ofPattern( "yyyyMMdd" );

          LocalDate dataDay = LocalDate.parse( container[0], formatter );
          if (dataDay.isBefore(startOfWeek) || dataDay.isAfter(endOfWeek)) continue; // if event date is outside current week -> forward to next iteration of loop
          
          //println("Ite " + iterator);

          println();
          println("**********");
          formatter = DateTimeFormatter.ofPattern( "yyyyMMdd:HHmmss" );
          LocalDateTime startTime = LocalDateTime.parse( container[0] + ":" + container[1], formatter );
          String day = ""+startTime.getDayOfMonth();
          String month = ""+startTime.getMonthValue();
          String year= ""+startTime.getYear();

          // start date
          calendarEventInfo[iterator] = day+"/"+month+"/"+year; // add start date to text file
          println("Start date: " + calendarEventInfo[iterator]);
          iterator++;

          // start day
          calendarEventInfo[iterator] = startTime.getDayOfWeek().toString(); // add weekday to text file
          println("Start day: " + calendarEventInfo[iterator]);
          iterator++;

          // start time
          if (startTime.getMinute()<10) calendarEventInfo[iterator] = ""+startTime.getHour()+":0"+startTime.getMinute();
          else calendarEventInfo[iterator] = ""+startTime.getHour()+":"+startTime.getMinute();
          println("Start time: " + calendarEventInfo[iterator]);
          iterator++;

          // end date
          date = split(icsFile[i+1], "Time:")[1];
          container = split(date, "T");
          LocalDateTime endTime = LocalDateTime.parse( container[0] + ":" + container[1], formatter );
          day = ""+endTime.getDayOfMonth();
          month = ""+endTime.getMonthValue();
          year= ""+endTime.getYear();
          calendarEventInfo[iterator] = day+"/"+month+"/"+year; // add end date to text file
          println("End date: " + calendarEventInfo[iterator]);
          iterator++;

          // end day
          calendarEventInfo[iterator] = endTime.getDayOfWeek().toString(); // add weekday to text file
          println("End day: " + calendarEventInfo[iterator]);
          iterator++;

          // end time
          if (endTime.getMinute()<10) calendarEventInfo[iterator] = ""+endTime.getHour()+":0"+endTime.getMinute();
          else calendarEventInfo[iterator] = ""+endTime.getHour()+":"+endTime.getMinute();
          println("End time: " + calendarEventInfo[iterator]);
          iterator++;

          // summary
          String summary = icsFile[i-1].substring(8, icsFile[i-1].length());
          calendarEventInfo[iterator] = summary;
          println("Summary: " + calendarEventInfo[iterator]);
          iterator++;

          println("**********");
        }
      }

      // save data to .txt file
      saveStrings(outputFileName+".txt", subset(calendarEventInfo, 0, iterator));
    }
  }
}
