String TIMESTAMP = ""+year()+nf(month(), 2)+nf(day(), 2)+"_"+nf(hour(), 2)+nf(minute(), 2)+nf(second(), 2);
// %yyyy-%mm-%dd %hh:%mm:%ss
LOGFILE log;

void logexit() {
  log.log("exiting...");
  saveStrings("log_"+TIMESTAMP+".log", log.logstrings);
}

String CURRENT_TIMESTAMP() {
  return ""+year()+nf(month(), 2)+nf(day(), 2)+"_"+nf(hour(), 2)+nf(minute(), 2)+nf(second(), 2);
}

String TIMESTAMP_DETAIL() {
  return ""+year()+"/"+nf(month(), 2)+"/"+nf(day(), 2)+" "+nf(hour(), 2)+":"+nf(minute(), 2)+":"+nf(second(), 2);
}

class LOGFILE {
  String[] logstrings = {};
  public LOGFILE() {}
  public void log(String what) {
    logstrings = append(logstrings, "["+TIMESTAMP_DETAIL()+"; frame "+realt+"; "+millis()+" ms]"+": "+what);
  }
}
