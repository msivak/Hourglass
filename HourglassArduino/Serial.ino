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
        p2Time[0] = Serial.parseInt();
        p1Time[0] = Serial.parseInt();
        
        gameMode = Serial.parseInt();
        switch(gameMode){
          case 0:
            p1Ex = p2Ex = false;
            break;
          case 1:
            p1Ex = p2Ex = true;
            break;
          case 2:
            p1Ex = p2Ex = false;
            break;
          
        }
        
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
        p1n = p1Name;
        p2n = p2Name;
        for(int j = 0; j < i; j++){
          nameSpaces = nameSpaces+" ";
        }
        playerString = p1Name+nameSpaces+p2Name;
        lcd.setCursor(0,0);
        lcd.print(playerString);
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
  Serial.print(activePlayer);
  Serial.print(" ");
  if(activePlayer){
    Serial.print(timeText);
    Serial.print(" ");
    Serial.print(p2Scenario);
  }
  else{
    Serial.print(timeText2);
    Serial.print(" ");
    Serial.print(p1Scenario);
  }
  Serial.println();
}
