
/**
 * Chess Clock Code
 * @author Mark Sivak, PhD
 * Fall 2014
 */

import g4p_controls.*;
import java.util.ArrayList;
import java.awt.Rectangle;
import processing.serial.*; 
import com.dhchoi.CountdownTimer;

//Serial Variables
Serial clockPort;
String portName;
Boolean connected;

//Window Objects
GWindow window2;
PApplet p2App;

//GUI Objects
GPanel configPanel;
GButton btnStart;
GTextArea p1Text;
GTextArea p2Text;
GOption deathClock, timedTurns, hardcore;
GToggleGroup tg;
GCustomSlider timeSlide;
GLabel fontLabel;
GDropList fontList;
GButton btnBackgroundColor;
GSketchPad spad;
PGraphics pg;
GButton btnFontColor;
GSketchPad spad2;
PGraphics pg2;
GButton btnDefaultFont;
GDropList serialList;
GButton btnSerialConnect;
GOption usbClock, laptopClock;
GToggleGroup tgClock;

//Config Variables
color backgroundColor;
int gameTime = 60;
Boolean usbMode = false;
String player1;
String player2;
byte[] p1Time;
byte[] p2Time;
Boolean gameMode;
PFont timeFont;
int timeSize;
color fontColor;
int panelW;
int panelH;
String[] fNames = PFont.list();
String[] sNames = Serial.list();
int activePlayer = 0;
int textX;
int textY;
int turnExtension;
Boolean config;
String timeText = "";
String timeText2 = "";
Boolean pause = true;
int numPlayers = 2;
int[] p1t;
int[] p2t;
float c = 0;

CountdownTimer timer;

//Setup function
void setup() {
  processingSetup();
  serialSetup();
  configGUISetup(); 
}

/**
 * Draw for the main window
 */
void draw() {
  G4P.setWindowColorScheme(this, 5);
  background(backgroundColor);
  
  if(config){
    fill(fontColor);
    text("12:34", textX, textY, 240, 120);
  }
  else{
    if(pause){
      colorMode(HSB);
      if (c >= 255)  c=0;  else  c++;
      fill(c, 255, 255);
    }
    else{
      colorMode(RGB);
      fill(fontColor);
    }
    text(timeText, 0, 0, 240, 120);
  }
  if(connected){
    serialRead();
  }
}

void drawPlayer2(GWinApplet appc, GWinData data){
  appc.background(backgroundColor);
  if(pause){
      appc.colorMode(HSB);
      appc.fill(c, 255, 255);
    }
  else{
      appc.colorMode(RGB);
      appc.fill(fontColor);
  }
  appc.text(timeText2, 0, 0, 240, 120);
}

void keyPlayer2(GWinApplet appc, GWinData data, KeyEvent eyevent){
  if(eyevent.getKey() == 'c'){
   if(configPanel.getX() != 0 && configPanel.getY() != 0){ 
     configPanel.moveTo(0,0);
   }
   else{
     configPanel.moveTo(-50,-50);
     configPanel.setCollapsed(true);
   }
 } 
 
 if(eyevent.getKeyCode() == UP){
   timeSize += 2;
   textSize(timeSize);
   if(p2App != null){
     p2App.textSize(timeSize);
   }
 }
 
 if(eyevent.getKeyCode() == DOWN){
   if(timeSize > 8){
     timeSize -= 2;
     textSize(timeSize);
     if(p2App != null){
       p2App.textSize(timeSize);
     } 
   }
 }
 
 if(eyevent.getKey() == 'p'){
   pause = true;
     if(timer.isRunning()){
       timer.stop();
     }
 }
 
 if(eyevent.getKey() == 's'){
   pause = false;
   if(!timer.isRunning()){
       timer.start();
     }
 }
 
   if(eyevent.getKey() == ' '){
     activePlayer = (activePlayer+1)%numPlayers;
   }
}

void processingSetup(){
  size(640, 360);
   if (frame != null) {
    frame.setResizable(true);
  }
  
  backgroundColor = color(0);
  
  textX = 360+20;
  textY = height/2-60;
  timeSize = 96;
  fontColor = color(255);
  timeFont = createFont("Let's go Digital Regular.ttf", timeSize);
  textFont(timeFont);
  textSize(timeSize);
  textAlign(LEFT, TOP);
  
  p1Time = new byte[2];
  p2Time = new byte[2];
  p1t = new int[2];
  p2t = new int[2];
  
  activePlayer = 0;
  
  config = true;
  
  
}

void createWindows() {
  window2 = new GWindow(this, "Player2", 0, 0, 240, 100, false, JAVA2D);
  p2App = window2.papplet;
  window2.addDrawHandler(this, "drawPlayer2");
  window2.addKeyHandler(this, "keyPlayer2");
  window2.addData(new Player2Data());
  p2App.textFont(timeFont);
  p2App.textSize(timeSize);
  p2App.textAlign(LEFT, TOP);
  window2.setBackground(backgroundColor);
}


void onTickEvent(int timerId, long timeLeftUntilFinish){
  if(timerId == 0){
    if(activePlayer == 0){
     if(p1t[1] <= 0){
        timeText = str(p1t[0])+":00";
        p1t[0]--;
        p1t[1] = 60;
      }
      else if(p1t[1] < 10){
        timeText = str(p1t[0])+":0"+str(p1t[1]);
      }
      else{
        timeText = str(p1t[0])+":"+str(p1t[1]);
      }
      p1t[1]--;
    }
    else if(activePlayer == 1){
      if(p2t[1] <= 0){
        timeText2 = str(p2t[0])+":00";
        p2t[0]--;
        p2t[1] = 60;
      }
      else if(p2t[1] < 10){
        timeText2 = str(p2t[0])+":0"+str(p2t[1]);
      }
      else{
        timeText2 = str(p2t[0])+":"+str(p2t[1]);
      }
      p2t[1]--;
    }
  }
}


void onFinishEvent(int timerId){
  print("what");
}

void keyPressed(){
  
 if(key == 'c'){
   if(configPanel.getX() != 0 && configPanel.getY() != 0){ 
     configPanel.moveTo(0,0);
   }
   else{
     configPanel.moveTo(-50,-50);
     configPanel.setCollapsed(true);
   }
 } 
 
 if(keyCode == UP){
   timeSize += 2;
   textSize(timeSize);
   if(p2App != null){
     p2App.textSize(timeSize);
   }
 }
 
 if(keyCode == DOWN){
   if(timeSize > 8){
     timeSize -= 2;
     textSize(timeSize);
     if(p2App != null){
       p2App.textSize(timeSize);
     } 
   }
 }
 
if(key == 'p'){
   pause = true;
     if(timer.isRunning()){
       timer.stop();
     }
 }
 
 if(key == 's'){
   pause = false;
   if(!timer.isRunning()){
       timer.start();
     }
 }
 
 if(key == ' '){
   activePlayer = (activePlayer+1)%numPlayers;
   print(activePlayer);
 }
 
}

class Player2Data extends GWinData {
  
}

