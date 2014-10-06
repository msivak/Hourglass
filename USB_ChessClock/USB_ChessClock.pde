/**
 * Chess Clock Code
 * @author Mark Sivak, PhD
 * Fall 2014
 */

import g4p_controls.*;
import java.util.ArrayList;
import java.awt.Rectangle;
import processing.serial.*;

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

//Config Variables
color backgroundColor;
int gameTime;
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
int activePlayer;
int textX;
int textY;
int turnExtension;
Boolean config;

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
  
  fill(fontColor);
  if(config){
    text("12:34", textX, textY);
  }
  else{
    text("12:34", width/2, height/2);
  }
  serialRead();
}

void drawPlayer2(GWinApplet appc, GWinData data){
  appc.background(backgroundColor);
  appc.fill(fontColor);
  appc.text("12:34", appc.width/2, appc.height/2);
}

void processingSetup(){
  size(640, 360);
   if (frame != null) {
    frame.setResizable(true);
  }
  
  backgroundColor = color(0);
  
  textX = 480;
  textY = height/2;
  timeSize = 96;
  fontColor = color(255);
  timeFont = createFont("Let's go Digital Regular.ttf", timeSize);
  textFont(timeFont);
  textSize(timeSize);
  textAlign(CENTER, CENTER);
  
  p1Time = new byte[2];
  p2Time = new byte[2];
  
  activePlayer = 0;
  
  config = true;
}

void createWindows() {
  window2 = new GWindow(this, "Player2", 0, 0, 240, 100, false, JAVA2D);
  p2App = window2.papplet;
  window2.addDrawHandler(this, "drawPlayer2");
  window2.addData(new Player2Data());
  p2App.textFont(timeFont);
  p2App.textSize(timeSize);
  p2App.textAlign(CENTER, CENTER);
  window2.setBackground(backgroundColor);
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
}

class Player2Data extends GWinData {
  
}

