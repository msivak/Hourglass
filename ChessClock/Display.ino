void playerLED(){
 if(!activePlayer){
    analogWrite(p1LEDPin, 75);
    analogWrite(p2LEDPin, 0);
  }
  else{
    analogWrite(p1LEDPin, 0);
    analogWrite(p2LEDPin, 75);
  } 
}

void ledFade(){
 if(millis()%30 == 0){
    analogWrite(p1LEDPin, 125-fade);
    analogWrite(p2LEDPin, fade);
    toggle = !toggle;
    fade = fade+ fadeSwitch;
    if(fade >= 125){
      fade = 125;
      fadeSwitch = -1;
    }
    if(fade <= 0){
      fade = 0;
      fadeSwitch = 1;
    }
  } 
}

void lcdWrite(){
  int i = 16 - timeText.length() - timeText2.length();
  timerSpaces = "";
  for(int j = 0; j < i; j++){
    timerSpaces = timerSpaces+" ";
  }
  lcd.setCursor(0,1);
  //lcd.print(timeText+timerSpaces+timeText2);
  lcd.print(timeText2+timerSpaces+timeText);
}
