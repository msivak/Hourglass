


//The Arduino Code for the Chessclock will go here

#include "Timer.h"
#include <LiquidCrystal.h>


boolean activePlayer;
byte minute, second;
int p1Time[2], p2Time[2];
boolean playing = false;
boolean flip = false;
int gameTime;
boolean pause = false;
boolean pauseHold = true;
String timeText = "";
String timeText2 = "";
int pausePin = 7;
int playerPin = 13;
int p1LEDPin = 9;
int p2LEDPin = 10;
int speakerPin = 6;
int modePin = 8;
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);
String minStr;
String secStr;
int fade = 0;
int fadeSwitch = 2;
long pauseTime = 0;
long toneTime = 0;
long gameOverTime = 0;
boolean toggle = false;

Timer t;
Timer p;

void setup(){
  Serial.begin(9600);
  pinMode(pausePin, INPUT);
  pinMode(playerPin, INPUT);
  pinMode(p1LEDPin, OUTPUT);
  pinMode(p2LEDPin, OUTPUT);
  pinMode(speakerPin, OUTPUT);
  
  lcd.begin(16, 2);
  lcd.clear();
  
  activePlayer = false;
  
  int tickEvent = t.every(1000, timer);
  int pauseEvent = p.every(30000, pauser);
  
  p1Time[1] = p2Time[1] = 0;
  p1Time[0] = p2Time[0] = 0;
   
   lcd.print("PLAYER1  PLAYER2");
   
   
}

void loop(){
  serialRead();
  if(playing){
    playerSwitch();
    pauseSwitch();
    if(!pause){
      t.update();
      if(toneTime+500 < millis() && gameOverTime+2000 < millis()){
        analogWrite(speakerPin, 0);
      }
      
      if(activePlayer){
        analogWrite(p1LEDPin, 125);
        analogWrite(p2LEDPin, 0);
      }
      else{
        analogWrite(p1LEDPin, 0);
        analogWrite(p2LEDPin, 125);
      }
    }
    else{
      p.update();
      
      if(pauseTime+500 < millis()){
        analogWrite(speakerPin, 0);
      }
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
  }
}

void timer(){
  if(activePlayer){
     if(p1Time[1] <= 0){
        timeText = String(p1Time[0])+":00";
        p1Time[0]--;
        if(p1Time[0]<10){
          minStr = "0";
        }
        else{
          minStr = "";
        }
        if(p1Time[0] == 0){
        playTone();
        }
        if(p1Time[0] <= 0 && p1Time[1] <= 0){
          gameOver();
        }
        p1Time[1] = 60;
        secStr = "";
      }
      else if(p1Time[1] <= 10 && p1Time[1] > 0){
        secStr = "0";
      }
      else{
        secStr = "";
      }
      
      if(p1Time[0] == 0 && p1Time[1] < 5){
        playTone();
      }
      
      p1Time[1]--;
      timeText = minStr+String(p1Time[0])+":"+secStr+String(p1Time[1]);
      
    }
    else if(activePlayer == false){
     if(p2Time[1] <= 0){
       p2Time[0]--;
       if(p2Time[0] < 10){
         minStr = "0";
       }
       else{
         minStr = "";
       }
       secStr = "";
       p2Time[1] = 60;
     }
     else if(p2Time[1] <= 10 && p2Time[1] > 0){
       secStr = "0";
     }
     else{
       secStr = "";
     }
     p2Time[1]--;
     timeText2 = minStr+String(p2Time[0])+":"+secStr+String(p2Time[1]);
       
   }
  serialWrite();
  lcdWrite();
}

void pauser(){
  pauseTime = millis();
  analogWrite(speakerPin, 125);
}

void playerSwitch(){
  if(digitalRead(playerPin) == HIGH){
    activePlayer = true;
 }
 else{
   activePlayer = false;
 }
}

void pauseSwitch(){
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

void serialRead(){
  if(Serial.available() > 0){
    if(!playing){
      p1Time[0] = p2Time[0] = Serial.parseInt();
      if(p1Time[0] < 10){
        minStr = "0";
      }
      else{
        minStr = "";
      }
      timeText = minStr+String(p1Time[0])+":00";
      timeText2 = minStr+String(p2Time[0])+":00";
      lcd.print(timeText+"      "+timeText2);
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
  Serial.print(activePlayer);
  Serial.print(" ");
  if(activePlayer){
    Serial.print(timeText);
  }
  else{
    Serial.print(timeText2);
  }
  Serial.println();
}

void lcdWrite(){
  lcd.setCursor(0,1);
  lcd.print(timeText+"      "+timeText2);
}

void playTone(){
  toneTime = millis();
  analogWrite(speakerPin, 125);
}

void gameOver(){
  gameOverTime = millis();
  analogWrite(speakerPin, 200);
}
