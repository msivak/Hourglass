
public void serialSetup(){
  connected = false;
}

int lf = 10;    // Linefeed in ASCII
String myString = null;


void serialRead(){
  if(connected){
    myString = null;
    while(clockPort.available() > 0){
      
     myString = clockPort.readStringUntil(lf);
    if (myString != null) {
      timeText = myString;
      break;
    }
    }
  }
}

void configSerial(){
  String sTime = str(gameTime);
  
  clockPort.write(sTime);
  clockPort.clear();
  connected = true;
}
