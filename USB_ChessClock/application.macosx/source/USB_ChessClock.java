import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import g4p_controls.*; 
import java.util.ArrayList; 
import java.awt.Rectangle; 
import processing.serial.*; 
import com.dhchoi.CountdownTimer; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class USB_ChessClock extends PApplet {

/**
 * Chess Clock Code
 * @author Mark Sivak, PhD
 * Fall 2014
 */




 


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
int backgroundColor;
int gameTime = 60;
Boolean usbMode = false;
String player1;
String player2;
byte[] p1Time;
byte[] p2Time;
Boolean gameMode;
PFont timeFont;
int timeSize;
int fontColor;
int panelW;
int panelH;
String[] fNames = PFont.list();
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
public void setup() {
  processingSetup();
  serialSetup();
  configGUISetup(); 
}

/**
 * Draw for the main window
 */
public void draw() {
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

public void drawPlayer2(GWinApplet appc, GWinData data){
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

public void keyPlayer2(GWinApplet appc, GWinData data, KeyEvent eyevent){
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

public void processingSetup(){
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

public void createWindows() {
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


public void onTickEvent(int timerId, long timeLeftUntilFinish){
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


public void onFinishEvent(int timerId){
  print("what");
}

public void keyPressed(){
  
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


//This function is used to place all the config GUI components
public void configGUISetup(){
  panelW = 360;
  panelH = 360;
  
  configPanel = new GPanel(this, 0, 0, panelW, panelH, "Configuration Panel");
  configPanel.setCollapsed(false);
  
  createClockMode();
  createFontList();
  createStartBtn();
  createGameMode();
  createGameTime();
  //createPlayerNames();
  createBackgroundColor();
  createFontColor();
  createSerial();
}


public void createFontList(){
  fontLabel = new GLabel(this, 120, panelH-120, 100, 20);
  fontLabel.setText("or Choose: ", GAlign.MIDDLE, GAlign.MIDDLE);
  fontLabel.setOpaque(true);
  configPanel.addControl(fontLabel);
  
  fontList = new GDropList(this, panelW-130, panelH-120, 120, 120, 5);
  fontList.setItems(fNames, 0);
  fontList.setOpaque(true);
  configPanel.addControl(fontList);
  
  btnDefaultFont = new GButton(this, 10, panelH-120, 100, 20, "Default Font");
  configPanel.addControl(btnDefaultFont);
}


public void createStartBtn(){
  btnStart = new GButton(this, panelW/2-30, panelH-20, 60, 20, "Start");
  configPanel.addControl(btnStart);
}


public void createGameTime(){
  timeSlide =  new GCustomSlider(this, 0, panelH-90, panelW, 50, null);
  timeSlide.setShowDecor(false, true, true, true);
  timeSlide.setNbrTicks(10);
  timeSlide.setLimits(60, 0, 90);
  configPanel.addControl(timeSlide);
}


public void createClockMode(){
  usbClock = new GOption(this, 10, 90, 100, 20, "USB Clock");
  laptopClock = new GOption(this, panelW-110, 90, 100, 20, "Laptop Clock");
  //usbClock.setSelected(true);
  tgClock = new GToggleGroup();
  tgClock.addControls(usbClock, laptopClock);
  configPanel.addControls(usbClock, laptopClock);
}

public void createGameMode(){
  deathClock = new GOption(this, 10, panelH-40, 100, 20, "Death Clock");
  timedTurns = new GOption(this, panelW/2-50, panelH-40, 100, 20, "Timed Turns");
  hardcore = new GOption(this, panelW-100, panelH-40, 100, 20, "Hardcore");
  //deathClock.setSelected(true);
  tg = new GToggleGroup();
  tg.addControls(deathClock, timedTurns, hardcore);
  configPanel.addControls(deathClock, timedTurns, hardcore);
}

public void createBackgroundColor() {
  int x = 10;
  int y = 30;
  GLabel title = new GLabel(this, x, y, 150, 20);
  title.setText("Background Color", GAlign.MIDDLE, GAlign.MIDDLE);
  title.setOpaque(true);
  title.setTextBold();
  btnBackgroundColor = new GButton(this, x, y+26, 80, 20, "Choose");
  pg = createGraphics(60, 20, JAVA2D);
  pg.beginDraw();
  pg.background(backgroundColor);
  pg.endDraw();
  spad = new GSketchPad(this, x+88, y+26, pg.width, pg.height);
  spad.setGraphic(pg);
  configPanel.addControls(title, btnBackgroundColor, spad);
}


public void createFontColor(){
  int x = panelW-160;
  int y = 30;
  GLabel title = new GLabel(this, x, y, 150, 20);
  title.setText("Font Color", GAlign.MIDDLE, GAlign.MIDDLE);
  title.setOpaque(true);
  title.setTextBold();
  btnFontColor = new GButton(this, x, y+26, 80, 20, "Choose");
  pg2 = createGraphics(60, 20, JAVA2D);
  pg2.beginDraw();
  pg2.background(fontColor);
  pg2.endDraw();
  spad2 = new GSketchPad(this, x+88, y+26, pg2.width, pg2.height);
  spad2.setGraphic(pg2);
  configPanel.addControls(title, btnFontColor, spad2);
}

public void createSerial(){
  serialList = new GDropList(this, 100, 140, 250, 120, 5);
  serialList.setItems(Serial.list(), 0);
  serialList.setOpaque(true);
  configPanel.addControl(serialList);
  
  btnSerialConnect = new GButton(this, 10, 140, 80, 20, "Connect");
  configPanel.addControl(btnSerialConnect);
}


public void createPlayerNames(){
  p1Text = new GTextArea(this, 0, 0, 60, 40);
  p1Text.setText("Player1");
  configPanel.addControl(p1Text);
  p2Text = new GTextArea(this, 0, 50, 60, 40);
  p2Text.setText("Player2");
  configPanel.addControl(p2Text);
}




// G4P code for colour chooser
public void handleBackgroundColorChooser() {
  backgroundColor = G4P.selectColor();
  pg.beginDraw();
  pg.background(backgroundColor);
  pg.endDraw();
  
  if(window2 != null){
    window2.setBackground(backgroundColor);
  }
}

// G4P code for colour chooser
public void handleFontColorChooser() {
  fontColor = G4P.selectColor();
  pg2.beginDraw();
  pg2.background(fontColor);
  pg2.endDraw();
}

/**
 * Button Event Handler
 * @param button
 */
public void handleButtonEvents(GButton button, GEvent event) {
  if(button == btnStart){
    configPanel.setText("CP");
    frame.setSize(240,120);
    configPanel.setCollapsed(true);
    configPanel.moveTo(-50,-50);
    if (window2 == null && event == GEvent.CLICKED) {
      createWindows();
      config = false;
    }
    if(usbMode){
      configSerial();
    }
    else{
      p1t[0] = gameTime;
      p1t[1] = 0;
      p2t[0] = gameTime;
      p2t[1] = 0;
      timeText = str(p1t[0])+":00";
      timeText2 = str(p2t[0])+":00";
      timer = CountdownTimer.getNewCountdownTimer(this).configure(1000, gameTime*numPlayers*60*1000);  
    }
  }
  else if(button == btnBackgroundColor){
    handleBackgroundColorChooser();
  }
  else if(button == btnFontColor){
    handleFontColorChooser();
  }
  else if(button == btnDefaultFont){
    timeFont = createFont("Let's go Digital Regular.ttf", timeSize);
    textFont(timeFont);
    if(window2 != null){
      p2App.textFont(timeFont);
    }
  }
  else if(button == btnSerialConnect){
   clockPort = new Serial(this, portName, 9600); 
  }
}

/**
 * Radio Button Event Handler
 * @param toggle
 */
public void handleToggleControlEvents(GToggleControl option, GEvent event) {
  if(option == deathClock) {
    gameMode = true;
  }
  else if(option == timedTurns) {
    gameMode = false;
    turnExtension = 5;
  }
  else if(option == hardcore){
    gameMode = false;
    turnExtension = 0;
  }
  
  if(option == usbClock){
    usbMode = true;
  }
  else if(option == laptopClock){
    usbMode = false;
  }
}

/**
 * Slider Event Handler
 * @param slider
 */
public void handleSliderEvents(GValueControl slider, GEvent event) {
  if(slider == timeSlide){
    gameTime = timeSlide.getValueI();
  }
}

/**
 * List Event Handler
 *
 */
public void handleDropListEvents(GDropList list, GEvent event) {
  if(list == fontList){
    timeFont = createFont(list.getSelectedText(), timeSize);
    textFont(timeFont);
    if(window2 != null){
      p2App.textFont(timeFont);  
    }
  }
  if(list == serialList){
    portName = list.getSelectedText();
  }
}


public void handlePanelEvents(GPanel panel, GEvent event) {
  
}

public void serialSetup(){
  connected = false;
}

int lf = 10;    // Linefeed in ASCII
String myString = null;


public void serialRead(){
  if(connected){
    myString = null;
    while(clockPort.available() > 0){
      
     myString = clockPort.readStringUntil(lf);
    if (myString != null) {
      timeText = myString;
      break;
    }
    }
  }
}

public void configSerial(){
  String sTime = str(gameTime);
  
  clockPort.write(sTime);
  clockPort.clear();
  connected = true;
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "USB_ChessClock" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
