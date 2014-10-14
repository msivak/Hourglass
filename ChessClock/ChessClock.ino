//The Arduino Code for the Chessclock will go here

#include "Timer.h"

boolean activePlayer;
byte minute, second;
int p1Time[2], p2Time[2];
boolean playing = false;
boolean flip = false;
int gameTime;
boolean pause = true;
boolean pauseHold = true;
String timeText = "";
String timeText2 = "";

Timer t;

void setup(){
  Serial.begin(9600);
  activePlayer = false;
   int tickEvent = t.every(1000, timer);
   p1Time[1] = 60;
   p1Time[0] = 0;
}

void loop(){
  serialRead();
  if(playing){
    t.update();
    playerSwitch();
    pauseSwitch();
  }
}

void timer(){
  if(activePlayer){
     if(p1Time[1] <= 0){
        timeText = String(p1Time[0])+":00";
        p1Time[0]--;
        p1Time[1] = 60;
      }
      else if(p1Time[1] < 10){
        timeText = String(p1Time[0])+":0"+String(p1Time[1]);
      }
      else{
        timeText = String(p1Time[0])+":"+String(p1Time[1]);
      }
      p1Time[1]--;
    }
    else if(activePlayer == false){
           if(p2Time[1] <= 0){
        timeText2 = String(p2Time[0])+":00";
        p2Time[0]--;
        p2Time[1] = 60;
      }
      else if(p2Time[1] < 10){
        timeText2 = String(p2Time[0])+":0"+String(p2Time[1]);
      }
      else{
        timeText2 = String(p2Time[0])+":"+String(p2Time[1]);
      }
      p2Time[1]--;
    }
  serialWrite();
}

void playerSwitch(){
  if(digitalRead(13) == HIGH){
    activePlayer = true;
 }
 else{
   activePlayer = false;
 }
}

void pauseSwitch(){
  if(digitalRead(12) == HIGH){
    if(pauseHold){
      pause = !pause;
      pauseHold = false;
    }
  }
  if(digitalRead(12) == LOW){
    pauseHold = true;
  }
}

void serialRead(){
  if(Serial.available() > 0){
    p1Time[0] = p2Time[0] = Serial.parseInt();
    //Serial.print(p1Time[0]);
    p1Time[0]--;
    p2Time[0]--;
    if(p1Time[0] != 0){
    playing = true;
    }
  }
}


void serialWrite(){
  //Serial.write(byte(p1Time[0]));
  //Serial.write(byte(p1Time[1]));
  Serial.print(activePlayer);
  Serial.print(" ");
  Serial.print(pause);
  Serial.print(" ");
  if(activePlayer){
    Serial.print(timeText); 
  }
  else{
    Serial.print(timeText2);
  }
  Serial.println();
}
