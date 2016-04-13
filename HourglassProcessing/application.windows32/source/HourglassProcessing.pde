/**
 * Chess Clock Processing Code
 * @author Mark Sivak, PhD
 * Fall 2014 - Spring 2016 
 */

import g4p_controls.*;
import java.util.ArrayList;
import java.awt.Rectangle;
import processing.serial.*; 
import com.dhchoi.CountdownTimer;

Boolean macMode = false; //Used to disable the Serial.list() issue in Windows

//Serial Variables
Serial clockPort;
String portName;
Boolean connected;

//Timer Variables
CountdownTimer timer;

//Window Objects
GWindow p1TimeWindow;
GWindow p2TimeWindow;
GWindow p1Scenario;
GWindow p2Scenario;
PApplet p2App;
PApplet p3App;
PApplet p4App;
PApplet p5App;

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
int wS;
int hS;

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

String scenario1 = "0";
String scenario2 = "0";

int prevP = -1;
String prevTime = "";

Boolean pTrigger = true;
int wOld, hOld;
int tW = 240;
int tH = 120;

import java.util.Map;

//Setup function
void setup() {
  size(640, 480); //required for Processing 3.0
  
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
      //w1 = width;
      //h1 = height;
      saveConfig(); //when paused save the settings
    }
    else{
      colorMode(RGB);
      fill(fontColor);
    }
    text(timeText, textX, textY);
    //checkPanel();
  }
  if(connected){
    serialRead();
  }
}

void drawPlayer2(PApplet appc, GWinData data){
  appc.background(backgroundColor);
  appc.textFont(timeFont);
  appc.textSize(timeSize);
  appc.textAlign(LEFT, TOP);

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

void drawPlayer1(PApplet appc, GWinData data2){
    appc.background(backgroundColor);
    appc.textFont(timeFont);
    appc.textSize(timeSize);
    appc.textAlign(LEFT, TOP);
    
   if(pause){
      appc.colorMode(HSB);
      appc.fill(c, 255, 255);
      p1x = appc.frame.getX();
      p1y = appc.frame.getY();
      w1 = appc.width;
      h1 = appc.height;
    }
    else{
      appc.colorMode(RGB);
      appc.fill(fontColor);
    }
    appc.text(timeText, 0, 0);
}

void drawScenario1(PApplet appc, GWinData data4){
   appc.background(backgroundColor);
   appc.textFont(timeFont);
   appc.textSize(timeSize);
   appc.textAlign(LEFT, TOP);
  
  if(pause){
      appc.colorMode(HSB);
      appc.fill(c, 255, 255);
    }
    else{
      appc.colorMode(RGB);
      appc.fill(fontColor);
    }
    appc.text(scenario1, 0, 0);
}

void drawScenario2(PApplet appc, GWinData data5){
  appc.background(backgroundColor);
  appc.textFont(timeFont);
  appc.textSize(timeSize);
  appc.textAlign(LEFT, TOP);
  
  if(pause){
      appc.colorMode(HSB);
      appc.fill(c, 255, 255);
    }
    else{
      appc.colorMode(RGB);
      appc.fill(fontColor);
    }
    appc.text(scenario2, 0, 0);
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