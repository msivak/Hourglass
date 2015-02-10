
public void serialSetup(){
  connected = false;
  sNames = Serial.list();
}

int lf = 10;    // Linefeed in ASCII
String myString = null;


void serialRead(){
  if(connected){
    myString = null;
    while(clockPort.available() > 0){
      
     myString = clockPort.readStringUntil(lf);
    if (myString != null) {
      
      String[] s = split(myString, ' ');
      print(s[0]);
      s[0] = trim(s[0]);
      if(s[0].equals("~")){
        pause = true;
      }
      else if(s[0].equals("$")){
        timeText = str(gameTime)+":00";
        timeText2 = str(gameTime)+":00";
      }
      //println(s.length);
      if(s.length == 2){
        pause = false;
        if(int(s[0]) == 0){
          //println(timeText);
          timeText = s[1];
        }
        else if(int(s[0]) == 1){
          timeText2 = s[1];
          //println(timeText2);
        }
      }
      
      break;
    }
    }
  }
}

void configSerial(){
  String sTime = str(gameTime);
  
  clockPort.write(sTime+" "+str(gameMode));
  clockPort.clear();
  timeText = sTime+":00";
  timeText2 = sTime+":00";
  connected = true;
}
