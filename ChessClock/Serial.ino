//The Serial Code for the Chess Clock
//Mark Sivak, PhD
//Fall 2014

void serialRead(){
  if(Serial.available() > 0){
    if(!playing){
      p1Time[0] = p2Time[0] = Serial.parseInt();
      if(p1Time[0] < 10){
        minStr = "0";
      }
      else{
        minStr = "";
      }
      timeText = minStr+String(p1Time[0])+":00";
      timeText2 = minStr+String(p2Time[0])+":00";
      lcd.print(timeText+"      "+timeText2);
      if(p1Time[0] != 0){
      playing = true;
      }
    }
    else{
      if(Serial.read() == 126){
        pause = !pause;
      }
    }
  }
}


void serialWrite(){
  Serial.print(!activePlayer);
  Serial.print(" ");
  if(activePlayer){
    Serial.print(timeText);
  }
  else{
    Serial.print(timeText2);
  }
  Serial.println();
}
