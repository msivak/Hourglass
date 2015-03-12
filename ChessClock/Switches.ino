void playerSwitch(){
  switch (gameMode){
    case 0:
      if(digitalRead(playerPin) == HIGH){
        activePlayer = true;
       }
       else{
         activePlayer = false;
       }
     break;
    case 1:
      if(digitalRead(playerPin) == HIGH){
        activePlayer = true;
        p2Time[0] = gameTime;
        p2Time[1] = 0;
      }
      else{
        activePlayer = false;
        p1Time[0] = gameTime;
        p1Time[1] = 0;
      }
      break;
    case 2:
      break;
  }
}

long resetTime = 0;
long delayTime = 1000;

void pauseSwitch(){
  
  if(pauseButton.onRelease()){
    pause = !pause;
    if(pause){
      Serial.println("~");
    }
    resetTime = millis();
  }
  
  if(pauseButton.onPress() && resetTime + delayTime <= millis()){
    
      p1Time[0] = p1Tinit;
      p1Time[1] = 0;
      p2Time[0] = p2Tinit;
      p2Time[1] = 0;
      if(p1Tinit < 10){
        minStr = "0";
      }
      else{
        minStr = "";
      }
      timeText = minStr+String(p1Time[0])+":00";
       if(p2Tinit < 10){
        minStr = "0";
      }
      else{
        minStr = "";
      }
      timeText2 = minStr+String(p2Time[0])+":00";
      Serial.println("$");
      lcdWrite();
      p1Ex = true;
      p2Ex = true;
      pause = true;
  }
  
}

void hold(){
  if(pauseButton.onDoubleClick()){
    switch(gameMode){
      case 0: 
        Serial.print("|");
        pause = true;
        
        break;
      case 1:
        if(activePlayer && p1Ex){
          p1Time[0] += 5;
          p1Ex = false;
        }
        else if(p2Ex){
          p2Time[0] += 5;
          p2Ex = false;
        }
        break;
    }
    
  }
}
