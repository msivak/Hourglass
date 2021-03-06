import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import g4p_controls.*; 
import java.util.ArrayList; 
import java.awt.Rectangle; 
import processing.serial.*; 
import com.dhchoi.CountdownTimer; 
import java.util.Map; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class HourglassProcessing extends PApplet {

/**
 * Chess Clock Processing Code
 * @author Mark Sivak, PhD
 * Fall 2014 - Spring 2016 
 */




 


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
int backgroundColor; //The background color for the time windows
int fontColor;
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



//Setup function
public void setup() {
   //required for Processing 3.0
  
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
public void draw() {
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

public void drawPlayer2(PApplet appc, GWinData data){
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

public void drawPlayer1(PApplet appc, GWinData data2){
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

public void drawScenario1(PApplet appc, GWinData data4){
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

public void drawScenario2(PApplet appc, GWinData data5){
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
}

//This function is used to place all the config GUI components
public void configGUISetup(){
  panelW = 360;
  panelH = 480;
  
  configPanel = new GPanel(this, 0, 0, panelW, panelH, "Configuration Panel");
  configPanel.setCollapsed(false);
  
  createClockMode();          //Radiobutton control to change between USB and Laptop mode
  createFontList();           //Dropdown control to change the font
  createStartBtn();           //Button for starting the clock
  createGameMode();           //Radiobutton control for Deathclock, Hardcore, and Timed Turns
  createGameTime();           //Scale control for the number of minutes
  createPlayerNames();        //Text input control for the names of the players
  createPlayerTime();         //Text input control for the minutes for each player
  createBackgroundColor();    //
  createFontColor();          //
  createSerial();             //
  createWindowSize();         //
}


public void createWindowSize(){
  GLabel title = new GLabel(this, 10, panelH-155, 150, 20);
  title.setText("Window Width", GAlign.MIDDLE, GAlign.MIDDLE);
  title.setOpaque(true);
  title.setTextBold();
  configPanel.addControl(title);
  
  wWText = new GTextArea(this, 70, panelH-125, 80, 40);
  wWText.setPromptText(str(w1));
  wWText.setOpaque(false);
  configPanel.addControl(wWText);
  
  GLabel title2 = new GLabel(this, panelW-160, panelH-155, 150, 20);
  title2.setText("Window Height", GAlign.MIDDLE, GAlign.MIDDLE);
  title2.setOpaque(true);
  title2.setTextBold();
  configPanel.addControl(title2);
  
  wHText = new GTextArea(this, panelW-90, panelH-125, 80, 40);
  wHText.setOpaque(false);
  wHText.setPromptText(str(h1));
  configPanel.addControl(wHText);
}

public void createFontList(){
  fontLabel = new GLabel(this, 120, 160, 100, 20);
  fontLabel.setText("or Choose: ", GAlign.MIDDLE, GAlign.MIDDLE);
  fontLabel.setOpaque(true);
  configPanel.addControl(fontLabel);
  
  fontList = new GDropList(this, panelW-130, 160, 120, 120, 5);
  fontList.setItems(fNames, 0);
  fontList.setOpaque(true);
  configPanel.addControl(fontList);
  
  btnDefaultFont = new GButton(this, 10, 160, 100, 20, "Default Font");
  configPanel.addControl(btnDefaultFont);
}


public void createStartBtn(){
  btnStart = new GButton(this, panelW/2-30, panelH-20, 60, 20, "Start");
  btnStart.setEnabled(false);
  configPanel.addControl(btnStart);
}


public void createGameTime(){
  timeSlide =  new GCustomSlider(this, 0, panelH-90, panelW, 50, null);
  timeSlide.setShowDecor(false, true, true, true);
  timeSlide.setNbrTicks(10);
  timeSlide.setLimits(gameTime, 0, 90);
  configPanel.addControl(timeSlide);
}


public void createClockMode(){
  usbClock = new GOption(this, 10, 20, 100, 20, "USB Clock");
  laptopClock = new GOption(this, panelW-110, 20, 100, 20, "Laptop Clock");
  
  tgClock = new GToggleGroup();
  tgClock.addControls(usbClock, laptopClock);
  configPanel.addControls(usbClock, laptopClock);
  usbClock.setSelected(true);
}

public void createGameMode(){
  deathClock = new GOption(this, 10, panelH-40, 100, 20, "Death Clock");
  timedTurns = new GOption(this, panelW/2-50, panelH-40, 100, 20, "Timed Turns");
  hardcore = new GOption(this, panelW-100, panelH-40, 100, 20, "Hardcore");
  
  tg = new GToggleGroup();
  tg.addControls(deathClock, timedTurns, hardcore);
  configPanel.addControls(deathClock, timedTurns, hardcore);
  deathClock.setSelected(true);
}

public void createBackgroundColor() {
  int x = 10;
  int y = 90;
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
  int y = 90;
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
  if(macMode){
    serialList = new GDropList(this, 100, 50, 250, 120, 5);
    serialList.setItems(Serial.list(), 0);
    for(int i = 0; i<Serial.list().length; i++){
     if(portName.equals(Serial.list()[i])){
       serialList.setSelected(i);
     } 
    }
    serialList.setOpaque(true);
    configPanel.addControl(serialList);
  }
  else{
    serialText = new GTextArea(this, 100, 40, 100, 40);
    serialText.setOpaque(false);
    serialText.setPromptText(portName);
    configPanel.addControl(serialText);
  }
  
  btnSerialConnect = new GButton(this, 10, 50, 80, 20, "Connect");
  configPanel.addControl(btnSerialConnect);
}

public void createPlayerTime(){
  GLabel title = new GLabel(this, 10, 240, 60, 20);
  title.setText("P1 Mins", GAlign.MIDDLE, GAlign.MIDDLE);
  title.setOpaque(true);
  title.setTextBold();
  configPanel.addControl(title);
  
  p1TimeText = new GTextArea(this, 70, 230, 80, 40);
  p1TimeText.setPromptText(str(gameTime));
  p1TimeText.setOpaque(false);
  configPanel.addControl(p1TimeText);
  
  GLabel title2 = new GLabel(this, panelW-150, 240, 60, 20);
  title2.setText("P2 Mins", GAlign.MIDDLE, GAlign.MIDDLE);
  title2.setOpaque(true);
  title2.setTextBold();
  configPanel.addControl(title2);
  
  p2TimeText = new GTextArea(this, panelW-90, 230, 80, 40);
  p2TimeText.setPromptText(str(gameTime));
  p2TimeText.setOpaque(false);
  configPanel.addControl(p2TimeText);
}

public void createPlayerNames(){
  GLabel title = new GLabel(this, 10, 200, 60, 20);
  title.setText("P1 Name", GAlign.MIDDLE, GAlign.MIDDLE);
  title.setOpaque(true);
  title.setTextBold();
  configPanel.addControl(title);
  
  p1Text = new GTextArea(this, 70, 190, 80, 40);
  p1Text.setPromptText("PLAYER1");
  p1Text.setOpaque(false);
  configPanel.addControl(p1Text);
  
  GLabel title2 = new GLabel(this, panelW-150, 200, 60, 20);
  title2.setText("P2 Name", GAlign.MIDDLE, GAlign.MIDDLE);
  title2.setOpaque(true);
  title2.setTextBold();
  configPanel.addControl(title2);
  
  p2Text = new GTextArea(this, panelW-90, 190, 80, 40);
  p2Text.setOpaque(false);
  p2Text.setPromptText("PLAYER2");
  configPanel.addControl(p2Text);
}
public void configFile(){
  configFile = loadJSONObject("ClockConfig.json");
  
  backgroundColor = unhex(configFile.getString("backgroundColor"));
  gameTime = configFile.getInt("gameTime");
  
  fontColor = unhex(configFile.getString("fontColor"));
  timeSize = configFile.getInt("fontSize");
  timeFont = createFont(configFile.getString("font"), timeSize);
  
  portName = configFile.getString("portName");
  
  p1x = configFile.getInt("p1x");
  p1y = configFile.getInt("p1y");
  w1 = configFile.getInt("w1");
  h1 = configFile.getInt("h1");
  
  p2x = configFile.getInt("p2x");
  p2y = configFile.getInt("p2y");
  w2 = configFile.getInt("w2");
  h2 = configFile.getInt("h2");
  
  wS = configFile.getInt("wS");
  hS = configFile.getInt("hS");
  
}

public void saveConfig(){
  
 //p1x = frame.getX();
 //p1y = frame.getY()+2;
 
// w1 = width;
// h1 = height+2;
  
 configFile.setInt("p1x", p1x);
 configFile.setInt("p1y", p1y);
 configFile.setInt("w1", w1);
 configFile.setInt("h1", h1);
 
 configFile.setInt("p2x", p2x);
 configFile.setInt("p2y", p2y);
 configFile.setInt("w2", w2);
 configFile.setInt("h2", h2);
 
 configFile.setInt("fontSize", timeSize);
 
 saveJSONObject(configFile, "data/ClockConfig.json"); 
}

public void gameFileSetup(){
  
  gameFile = new Table();
  gameFile.addColumn(player1);
  gameFile.addColumn(player2);
  gameFileName = "game/"+day()+"-"+month()+"-"+year()+"'"+hour()+minute()+".csv";
  TableRow row = gameFile.addRow();
  row.setString(player1, "60:00");
  row.setString(player2, "60:00");
}

public void gameFileWrite(String pP, String pT){
  TableRow row = gameFile.addRow();
  row.setString(pP, pT);
  //row.setString(p, t);
  saveTable(gameFile, gameFileName);
  
}


// G4P code for colour chooser
public void handleBackgroundColorChooser() {
  backgroundColor = G4P.selectColor();
  configFile.setString("backgroundColor", hex(backgroundColor));
  saveJSONObject(configFile, "data/ClockConfig.json");
  pg.beginDraw();
  pg.background(backgroundColor);
  pg.endDraw();
  
  if(p2TimeWindow != null){
    //window2.setBackground(backgroundColor);
  }
}

// G4P code for colour chooser
public void handleFontColorChooser() {
  fontColor = G4P.selectColor();
  configFile.setString("fontColor", hex(fontColor));
  saveJSONObject(configFile, "data/ClockConfig.json");
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
   frame.setLocation(p1x, p1y);
   gameFileSetup();
   if (p2TimeWindow == null && event == GEvent.CLICKED) {
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
    configFile.setString("font", "Let's go Digital Regular.ttf");
    saveJSONObject(configFile, "data/ClockConfig.json");
    textFont(timeFont);
    if(p2TimeWindow != null){
      p2App.textFont(timeFont);
    }
  }
  else if(button == btnSerialConnect){
   clockPort = new Serial(this, portName, 9600);
   btnStart.setEnabled(true);
   btnSerialConnect.setText("Connected");
  }
}

/**
 * Radio Button Event Handler
 * @param toggle
 */
public void handleToggleControlEvents(GToggleControl option, GEvent event) {
  if(option == deathClock) {
    gameMode = 0;
  }
  else if(option == timedTurns) {
    gameMode = 1;
    turnExtension = 5;
  }
  else if(option == hardcore){
    gameMode = 2;
    turnExtension = 0;
  }
  
  if(option == usbClock){
    usbMode = true;
    btnStart.setEnabled(false);
  }
  else if(option == laptopClock){
    usbMode = false;
    btnStart.setEnabled(true);
  }
}

/**
 * Slider Event Handler
 * @param slider
 */
public void handleSliderEvents(GValueControl slider, GEvent event) {
  if(slider == timeSlide){
    gameTime = timeSlide.getValueI();
    p1tt = str(gameTime);
    p1TimeText.setPromptText(str(gameTime));
    p2tt = str(gameTime);
    p2TimeText.setPromptText(str(gameTime));
    configFile.setInt("fontSize", gameTime);
    saveJSONObject(configFile, "data/ClockConfig.json");
  }
}

/**
 * List Event Handler
 *
 */
public void handleDropListEvents(GDropList list, GEvent event) {
  if(list == fontList){
    timeFont = createFont(list.getSelectedText(), timeSize);
    configFile.setString("font", list.getSelectedText());
    saveJSONObject(configFile, "data/ClockConfig.json");
    textFont(timeFont);
    if(p2TimeWindow != null){
      p2App.textFont(timeFont);  
    }
  }
  if(list == serialList && macMode){
    portName = list.getSelectedText();
  }
}

public void handleTextEvents(GEditableTextControl textControl, GEvent event){
  if(textControl == serialText){
    portName = serialText.getText();
  }
  
  if(textControl == p1TimeText){
    p1tt = p1TimeText.getText();
  }
  
  if(textControl == p2TimeText){
    p2tt = p2TimeText.getText();
  }
  
  if(textControl == p1Text){
    player1 = p1Text.getText();
  }
  
  if(textControl == p2Text){
    player2 = p2Text.getText();
  }
  
  if(textControl == wWText){
    w1 = PApplet.parseInt(trim(wWText.getText()));
    w2 = PApplet.parseInt(trim(wWText.getText()));
  }
  
  if(textControl == wHText){
    h1 = PApplet.parseInt(trim(wHText.getText()));
    h2 = PApplet.parseInt(trim(wHText.getText()));
  }
  
}


public void handlePanelEvents(GPanel panel, GEvent event) {
  
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
  
   if(!usbMode){
       pause = true;
       if(timer.isRunning()){
         timer.stop();
       }
   }
   else if(connected){
     pause = !pause;
     clockPort.write("|");
   }
 }
 
 if(key == 's'){
   if(!usbMode){
     pause = false;
     if(!timer.isRunning()){
         timer.start();
       }
   }
   else if(connected){
   }
 }
 
 if(key == ' '){
   activePlayer = (activePlayer+1)%numPlayers;
   
 }
 
}

public void keyPlayer1(PApplet appc2, GWinData data2, KeyEvent eyevent){
  
}

public void keyPlayer2(PApplet appc, GWinData data, KeyEvent eyevent){
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
   if(!usbMode){
     pause = true;
       if(timer.isRunning()){
         timer.stop();
       }
   }
   else if(connected){
     clockPort.write("|");
     pause = !pause;
   }
 }
 
 if(eyevent.getKey() == 's'){
   if(!usbMode){
     pause = false;
     if(!timer.isRunning()){
         timer.start();
       }
   }
   else if(connected){
     //pause = false;
   }
 }
 
   if(eyevent.getKey() == ' '){
     if(!usbMode){
       activePlayer = (activePlayer+1)%numPlayers;
     }
   }
}

public void serialSetup(){
  connected = false;
  sNames = Serial.list();
  
//  for (String port: Serial.list()){
//    try{
//      clockPort = new Serial(this, port, 9600);
//      if(clockPort.available() > 0){
//         println("yo"); 
//      }
//      
//    }
//    finally{
//      println(Serial.getProperties(port));
//    }
//  }
}

int lf = 10;    // Linefeed in ASCII
String myString = null;


public void serialRead(){
  if(connected){
    myString = null;
    while(clockPort.available() > 0){
      
     myString = clockPort.readStringUntil(lf);
    if (myString != null) {
      //println(myString);
      String[] s = split(myString, ' ');
      s[0] = trim(s[0]);
      println(s);
      if(s[0].equals("~")){
        pause = true;
      }
      else if(s[0].equals("$")){
        timeText = str(gameTime)+":00";
        timeText2 = str(gameTime)+":00";
      }
      if(s.length == 3){
        s[2] = s[2].substring(0, s[1].length()-2);
        if(s[1].length() > 5 && s[1].charAt(0) == '0'){
          s[1] = s[1].substring(1, s[1].length());
        }
        pause = false;
        if(PApplet.parseInt(s[0]) == 0){
          timeText = s[1];
          scenario1 = s[2];
          if(prevP == 1){
            gameFileWrite(player2, prevTime);
          }
          else if(prevP == -1){
            //gameFileWrite(player2, "60:00", player1, s[1]);
          }
        }
        else if(PApplet.parseInt(s[0]) == 1){
          timeText2 = s[1];
          scenario2 = s[2];
          if(prevP == 0 || prevP == -1){
            gameFileWrite(player1, prevTime);
          }
          else if(prevP == -1){
            //gameFileWrite(player1, "60:00", player2, s[1]);
          }
        }
        prevP = PApplet.parseInt(s[0]);
        prevTime = s[1];
      }
      break;
    }
    }
  }
}

public void configSerial(){
  player1 = trim(player1);
  player2 = trim(player2);
  if(player1.length() > 8){
    player1 = player1.substring(0,7);
  }
  if(player2.length() > 8){
    player2 = player2.substring(0,7);
  }
  
  clockPort.write(player1+"~"+player2+"%"+p1tt+" "+p2tt+" "+str(gameMode));
  clockPort.clear();
  timeText = p1tt+":00";
  timeText2 = p2tt+":00";
  connected = true;
}


//Instantiate variable for the time windows and Processing variables
public void processingSetup(){
   if (frame != null) {
    surface.setResizable(true);
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

public void createWindows() {
  p2TimeWindow = GWindow.getWindow(this, player2, 50, 50, w2, h2, JAVA2D);
  p2TimeWindow.getSurface().setResizable(true);
  p2App = p2TimeWindow;
  p2TimeWindow.addDrawHandler(this, "drawPlayer2");
  p2TimeWindow.addKeyHandler(this, "keyPlayer2");
  
  p1TimeWindow = GWindow.getWindow(this, player1, 0, 0, w1, h1, JAVA2D);
  p1TimeWindow.getSurface().setResizable(true);
  p3App = p1TimeWindow;
  p1TimeWindow.addDrawHandler(this, "drawPlayer1");
  p1TimeWindow.addKeyHandler(this, "keyPlayer2");
  
  createScenario();
}

public void createScenario(){

  p1Scenario = GWindow.getWindow(this, "SCENARIO1", 0, 0, wS, hS, JAVA2D);
  p1Scenario.getSurface().setResizable(true);
  p5App = p1Scenario;
  p1Scenario.addDrawHandler(this, "drawScenario1");
  p1Scenario.addKeyHandler(this, "keyPlayer2");

  p2Scenario = GWindow.getWindow(this, "SCENARIO2", 0, 0, wS, hS, JAVA2D);
  p2Scenario.getSurface().setResizable(true);
  p4App = p2Scenario;
  p2Scenario.addDrawHandler(this, "drawScenario2");
  p2Scenario.addKeyHandler(this, "keyPlayer2");
  
}
  public void settings() {  size(640, 480); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "HourglassProcessing" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
