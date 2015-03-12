//The Serial Code for the Chess Clock
//Mark Sivak, PhD
//Fall 2014

void serialRead(){
  if(Serial.available()){
    noReset = true;
    p1Name = "";
    p2Name = "";
    nameSpaces = "";
    p2 = false;
      while(Serial.available()){
        delay(3);
        readChar = Serial.read();
        if(readChar == 37){
          Serial.flush();
          break;
        }
        if(readChar == 124){
          pause = !pause;
         // playing = true;
          Serial.flush();
          noReset = false;
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
      if(noReset){
        p1Time[0] = Serial.parseInt();
        p2Time[0] = Serial.parseInt();
        gameMode = Serial.parseInt();
        p1Tinit = p1Time[0];
        p2Tinit = p2Time[0];
        p1Time[1] = 0;
        p2Time[1] = 0;
        
        pause = true;
        
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
