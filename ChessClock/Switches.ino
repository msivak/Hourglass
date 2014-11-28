void playerSwitch(){
  if(digitalRead(playerPin) == HIGH){
    activePlayer = true;
 }
 else{
   activePlayer = false;
 }
}

void pauseSwitch(){
  if(!switchType){
    if(digitalRead(pausePin) == LOW){
      
      if(pauseHold){
        Serial.println("~");
        pauseHold = false;
        pause = !pause;
      }
    }
    if(digitalRead(pausePin) == HIGH){
      pauseHold = true;
    }
  }
  else{
    if(digitalRead(pausePin) == LOW){
      pause = true;
      if(pauseHold){
        Serial.println("~");
        pauseHold = false;
      }
    }
    else{
      pause = false;
    }
    if(digitalRead(pausePin) == HIGH){
      pauseHold = true;
    }
  }
}
