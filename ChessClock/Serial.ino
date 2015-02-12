//The Serial Code for the Chess Clock
//Mark Sivak, PhD
//Fall 2014

void serialRead(){
  if(Serial.available()){
    if(!playing){
      int y = 0;
      while(Serial.available()){
        delay(3);
        y++;
        readChar = Serial.read();
        if(readChar == 37){
          break;
        }
        if(readChar == 126){
          p2 = true;
        }
        if(!p2){
          p1Name = p1Name + readChar;
        }
        else if(readChar != 126){
          p2Name = p2Name + readChar;
        }
      }
      
      p1Time[0] = Serial.parseInt();
      p2Time[0] = Serial.parseInt();
      gameMode = Serial.parseInt();
      
      
      if(p1Time[0] < 10){
        minStr = "0";
      }
      else{
        minStr = "";
      }
      if(p2Time[0] < 10){
        minStr2 = "0";
      }
      else{
        minStr2 = "";
      }
      
      int i = 16 - p1Name.length() - p2Name.length();
      for(int j = 0; j < i; j++){
        nameSpaces = nameSpaces+" ";
      }
      lcd.setCursor(0,0);
      lcd.print(p1Name+nameSpaces+p2Name);
      Serial.println(p1Name+nameSpaces+p2Name);
      timeText = minStr+String(p1Time[0])+":00";
      timeText2 = minStr2+String(p2Time[0])+":00";
      lcdWrite();
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
