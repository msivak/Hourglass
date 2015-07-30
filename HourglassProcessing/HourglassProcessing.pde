/**
 * Chess Clock Processing Code
 * @author Mark Sivak, PhD
 * Fall 2014 - Spring 2015 
 */

import g4p_controls.*;
import java.util.ArrayList;
import java.awt.Rectangle;
import processing.serial.*; 
import com.dhchoi.CountdownTimer;

Boolean macMode = true; //Used to disable the Serial.list() issue in Windows

//Serial Variables
Serial clockPort;
String portName;
Boolean connected;

//Timer Variables
CountdownTimer timer;

//Window Objects
GWindow window2;
GWindow window3;
PApplet p2App;
PApplet p3App;

//GUI Objects
GPanel configPanel;
//Buttons
GButton btnStart;
GButton btnFontColor;
GButton btnBackgroundColor;
GButton btnDefaultFont;
GButton btnSerialConnect;
//Radiobuttons
GOption deathClock, timedTurns, hardcore;
GOption usbClock, laptopClock;
//Text Areas
GTextArea serialText;
GTextArea p1Text;
GTextArea p2Text;
GTextArea p1TimeText;
GTextArea p2TimeText;
GTextArea wWText;
GTextArea wHText;
//Sliders and Drop Lists
GCustomSlider timeSlide;
GDropList fontList;
GDropList serialList;
//Groups
GToggleGroup tg;
GToggleGroup tgClock;
GLabel fontLabel;
//Sketchpads
GSketchPad spad;
GSketchPad spad2;

//GUI Variables
PGraphics pg;
PGraphics pg2;
color backgroundColor; //The background color for the time windows
color fontColor;
PFont timeFont;
int timeSize;
int panelW;
int panelH;
String[] fNames = PFont.list();
String[] sNames;
int textX;
int textY;
String player1 = "PLAYER1";
String player2 = "PLAYER2";
String p1tt = "60";
String p2tt = "60";
String timeText = "";
String timeText2 = "";
int w1; //window width for player 1
int h1; //window height for player 1
int p1x; //window location for player 1
int p1y; //window location for player 1
int w2; //window width for player 2
int h2; //window height for player 2
int p2x; //window location for player 2
int p2y; //window location for player 2

//Config File Variables
JSONObject configFile;
Table gameFile;
String gameFileName;

//Game Variables
int gameTime; //The game time each player has in minutes
Boolean usbMode = true;
byte[] p1Time;
byte[] p2Time;
int gameMode = 0;
int activePlayer = 0;
int turnExtension;
Boolean config;
Boolean pause = true;
int numPlayers = 2;
int[] p1t;
int[] p2t;
float c = 0;

int prevP = -1;
String prevTime = "";

Boolean pTrigger = true;
int wOld, hOld;
int tW = 240;
int tH = 120;

import java.util.Map;

//Setup function
void setup() {
  
  String[] ports = Serial.list();
 
  for (int i=0; i < ports.length; i++) {
    Map<String, String> props = Serial.getProperties(ports[i]);
    print(ports[i]+": ");
    println(props);
  }
  
  configFile(); 
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
    text("12:34", textX, textY);
  }
  else{
    if(pause){
      colorMode(HSB);
      if (c >= 255)  c=0;  else  c++;
      fill(c, 255, 255);
      p1x = frame.getX();
      p1y = frame.getY();
      w1 = width;
      h1 = height;
      saveConfig(); //when paused save the settings
    }
    else{
      colorMode(RGB);
      fill(fontColor);
    }
    text(timeText, 0, 0);
    //checkPanel();
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
      p2x = appc.frame.getX();
      p2y = appc.frame.getY();
      w2 = appc.width;
      h2 = appc.height;
    }
  else{
      appc.colorMode(RGB);
      appc.fill(fontColor);
      
  }
  appc.text(timeText2, 0, 0);
}

void drawPlayer1(GWinApplet appc2, GWinData data2){
  appc2.background(backgroundColor);
  
  
   if(pause){
      appc2.colorMode(HSB);
      if (c >= 255)  c=0;  else  c++;
      appc2.fill(c, 255, 255);
      p1x = appc2.frame.getX();
      p1y = appc2.frame.getY();
      w1 = width;
      h1 = height;
      saveConfig(); //when paused save the settings
    }
    else{
      appc2.colorMode(RGB);
      appc2.fill(fontColor);
    }
    appc2.text(timeText, 0, 0);
    //checkPanel();
}

//Instantiate variable for the time windows and Processing variables
void processingSetup(){
  size(640, 480);
   if (frame != null) {
    frame.setResizable(true);
  }
  
  textX = 360+20;
  textY = height/2-60;

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
  window2 = new GWindow(this, player2, p2y, p2x, w2, h2, false, JAVA2D);
  p2App = window2.papplet;
  window2.addDrawHandler(this, "drawPlayer2");
  window2.addKeyHandler(this, "keyPlayer2");
  window2.addData(new Player2Data());
  window2.setOnTop(false);
  p2App.textFont(timeFont);
  p2App.textSize(timeSize);
  p2App.textAlign(LEFT, TOP);
  window2.setBackground(backgroundColor);
  
  window3 = new GWindow(this, player1, p1y, p1x, w1, h1, false, JAVA2D);
  p3App = window3.papplet;
  window3.addDrawHandler(this, "drawPlayer1");
  window3.addKeyHandler(this, "keyPlayer1");
  window3.addData(new Player3Data());
  window3.setOnTop(false);
  p3App.textFont(timeFont);
  p3App.textSize(timeSize);
  p3App.textAlign(LEFT, TOP);
  window3.setBackground(backgroundColor);
  
  createScenario();
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
}

void checkPanel(){
  
  if(!config){
    if(!configPanel.isCollapsed()){
      if(pTrigger){
        wOld = width;
        hOld = height;
        pTrigger = false;
      }
      frame.setSize(360, 380);
    }
    else{
      pTrigger = true;
    }
  }
}

void createScenario(){
  window3 = new GWindow(this, player2, p2y, p2x, wS, hS, false, JAVA2D);
  p3App = window3.papplet;
  window3.addDrawHandler(this, "drawScenario1");
  window3.addKeyHandler(this, "keyPlayer2");
  window3.addData(new Player2Data());
  window3.setOnTop(false);
  p3App.textFont(timeFont);
  p3App.textSize(timeSize);
  p3App.textAlign(LEFT, TOP);
  window3.setBackground(backgroundColor);
  
  window4 = new GWindow(this, player2, p2y, p2x, wS, hS, false, JAVA2D);
  p4App = window4.papplet;
  window4.addDrawHandler(this, "drawScenario2");
  window4.addKeyHandler(this, "keyPlayer2");
  window4.addData(new Player2Data());
  window4.setOnTop(false);
  p4App.textFont(timeFont);
  p4App.textSize(timeSize);
  p4App.textAlign(LEFT, TOP);
  window4.setBackground(backgroundColor);
  
  
}

class Player2Data extends GWinData {
  
}

class Player3Data extends GWinData {
  
}

class Scenario1Data extends GWinData {
  
}

class Scenario2Data extends GWinData {
  
}
