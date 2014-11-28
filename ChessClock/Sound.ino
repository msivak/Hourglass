void pauser(){
  pauseTime = millis();
  analogWrite(speakerPin, 125);
}

void playTone(){
  toneTime = millis();
  analogWrite(speakerPin, 125);
}

void gameOver(){
  gameOverTime = millis();
  analogWrite(speakerPin, 200);
}

void toneEnd(){
  if(toneTime+500 < millis() && gameOverTime+2000 < millis()){
    analogWrite(speakerPin, 0);
  }
}

void pauseToneEnd(){
  if(pauseTime+500 < millis()){
    analogWrite(speakerPin, 0);
  }
}
