void pinSetup(){
  //Setup the pause button
  pinMode(pausePin, INPUT);
  digitalWrite(pausePin, HIGH);
  
  //Setup the player switch
  pinMode(playerPin, INPUT);
  digitalWrite(playerPin, HIGH);
  
  //Set the other PWM output pins
  pinMode(p1LEDPin, OUTPUT);
  pinMode(p2LEDPin, OUTPUT);
  pinMode(speakerPin, OUTPUT);
}

void timerSetup(){
  //Initialize the two timers
  int tickEvent = t.every(1000, timer);
  int pauseEvent = p.every(30000, playTone);
}

void clockSetup(){
  //Set the active player based on the wiring of the player switch
  activePlayer = false;
  
  //Initialize the time arrays with default values
  p1Time[1] = p2Time[1] = 0;
  p1Time[0] = p2Time[0] = 0;
}

void lcdSetup(){
  //Initialize the LCD
  lcd.begin(16, 2);
  lcd.clear();
  
  //Write the first line of the LCD for feedback to the user 
  lcd.print("PLAYER1  PLAYER2");
}
