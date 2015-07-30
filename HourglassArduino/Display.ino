void playerLED(){
 if(activePlayer){
    analogWrite(p1LEDPin, 125);
    analogWrite(p2LEDPin, 0);
    digitalWrite(17, 75);
    digitalWrite(16, 0);
  }
  else{
    analogWrite(p1LEDPin, 0);
    analogWrite(p2LEDPin, 125);
    digitalWrite(16, 75);
    digitalWrite(17, 0);
  } 
}

void ledFade(){
 if(millis()%30 == 0){
    analogWrite(p1LEDPin, 125-fade);
    analogWrite(p2LEDPin, fade);
    digitalWrite(16, 0);
    digitalWrite(17, 0);
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
  int i = 12 - timeText.length() - timeText2.length();
  timerSpaces = "";
  for(int j = 0; j < i; j++){
    timerSpaces = timerSpaces+" ";
  }
  lcd.setCursor(0,1);
  //lcd.print(timeText+timerSpaces+timeText2);
  lcd.print(timeText2+" "+p1Scenario+timerSpaces+p2Scenario+" "+timeText);
}

void gameOverLCD(){
  lcd.setCursor(0,0);
  lcd.print("   GAME  OVER   ");
  lcd.setCursor(0,1);
  if(activePlayer){
    int pl = 12-p1n.length();
    String go = p1n;
    for(int i = 0; i<pl; i++){
      go = go+" ";
    }
    go = go+"WINS";
    lcd.print(go);
  }
  else{
    int pl = 12-p2n.length();
    String go = p2n;
    for(int i = 0; i<pl; i++){
      go = go+" ";
    }
    go = go+"WINS";
    lcd.print(go);
  }
}
