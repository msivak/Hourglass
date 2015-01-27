void playTone(){
  toneTime = millis();
  analogWrite(speakerPin, 125);
}

void toneEnd(){
  if(toneTime+500 < millis() && gameOverTime+2000 < millis()){
    analogWrite(speakerPin, 0);
  }
}


