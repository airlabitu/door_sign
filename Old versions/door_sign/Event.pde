class Event {
  int id, dayIndex, xID;
  float x, xoffset, y, w, l;
  String dayInWeek, dayInMonth, month, eventName, openHrs, openMins, closeHrs, closeMins;
  String[] splitDate, splitStartTime, splitEndTime;
  float openToFloat, closeToFloat;
  color boxColor;

  Event(int _id, String _month, String _day, int _dayIndex, String _startTime, String _endTime, String _eventName, color _boxColor, float tableStartY) {
    id = _id/dataPerEvent;
    splitDate = split(_month, '/');
    dayInMonth = splitDate[0];
    month = splitDate[1];
    dayInWeek = _day;
    //println(dayInWeek);
    dayIndex = _dayIndex;


    boxColor = _boxColor;

    //if (eventAdded()) {
      eventName = _eventName;
      splitStartTime = split(_startTime, ':');
      splitEndTime = split(_endTime, ':');
      openHrs = splitStartTime[0];
      openMins = splitStartTime[1];
      closeHrs = splitEndTime[0];
      closeMins = splitEndTime[1];
      //println(openHrs,openMins,closeHrs,closeMins);
      //println(eventName);

      openToFloat = float(openHrs)+float(openMins)/60;
      closeToFloat = float(closeHrs)+float(closeMins)/60;
      //println(openToFloat, closeToFloat);

      l = (closeToFloat-openToFloat)*cell_h;
      y= tableStartY+(openToFloat-timeMin)*cell_h;
    //}
  }

  void display() {
    //x = tableStartX + cell_w+eventWidth*dayIndex*dayWidth;
    x = tableStartX + eventWidth*dayIndex*dayWidth;
    w = eventWidth;
    fill(boxColor);
    stroke(boxColor);
    rect(x, y, w, l, w/10);
    fill(c_text);
  }
}
