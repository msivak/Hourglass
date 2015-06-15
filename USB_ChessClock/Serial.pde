
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
      s[0] = trim(s[0]);
      if(s[0].equals("~")){
        pause = true;
      }
      else if(s[0].equals("$")){
        timeText = str(gameTime)+":00";
        timeText2 = str(gameTime)+":00";
      }
      if(s.length == 2){
        if(s[1].length > 4 && s[1].charAt(0) == '0'){
          s[1] = s[1].subString(1, s[1].length);
        }
        pause = false;
        if(int(s[0]) == 0){
          timeText = s[1];
        }
        else if(int(s[0]) == 1){
          timeText2 = s[1];
        }
      }
      break;
    }
    }
  }
}

void configSerial(){
  player1 = trim(player1);
  player2 = trim(player2);
  if(player1.length() > 8){
    player1 = player1.substring(0,7);
  }
  if(player2.length() > 8){
    player2 = player2.substring(0,7);
  }
  
  clockPort.write(player1+"~"+player2+"%"+p1tt+" "+p2tt+" "+str(gameMode));
  clockPort.clear();
  timeText = p1tt+":00";
  timeText2 = p2tt+":00";
  connected = true;
}
