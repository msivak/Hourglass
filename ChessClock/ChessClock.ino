//The Arduino Code for the Chessclock will go here

#include "Timer.h"




boolean activePlayer;
byte minute, second;
int p1Time[2], p2Time[2];
boolean playing = false;
boolean flip = false;
int gameTime;

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
  }
}

void timer(){
  p1Time[1]--;
  if(p1Time[1] == 0){
    p1Time[0]--;
    p1Time[1] = 60;
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

void serialRead(){
  if(Serial.available() > 0){
    p1Time[0] = Serial.parseInt();
    Serial.print(p1Time[0]);
    p1Time[0]--;
    if(p1Time[0] != 0){
    playing = true;
    }
  }
}


void serialWrite(){
  //Serial.write(byte(p1Time[0]));
  //Serial.write(byte(p1Time[1]));
  Serial.print(p1Time[0]);
  Serial.print(":");
  Serial.print(p1Time[1]);
  Serial.println();
}
