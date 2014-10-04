/**
 * Chess Clock Code
 * @author Mark Sivak, PhD
 * Fall 2014
 */

import g4p_controls.*;
import java.util.ArrayList;
import java.awt.Rectangle;

GWindow window2;

//GUI Objects
GPanel configPanel;
GButton btnStart;
GTextArea p1Text;
GTextArea p2Text;
GOption deathClock, timedTurns;
GToggleGroup tg;
GCustomSlider timeSlide;
GDropList fontList;
GButton btnBackgroundColor;
GSketchPad spad;
PGraphics pg;
GButton btnFontColor;
GSketchPad spad2;
PGraphics pg2;

//Config Variables
color backgroundColor;
int gameTime;
String player1;
String player2;
int[] p1Time;
int[] p2Time;
Boolean gameMode;
PFont timeFont;
color fontColor;
int panelW = 360;
int panelH = 360;
String[] fNames = {"Black", "White", "Red", "Green", "Blue", "Yellow", "Pink", "Grey"};

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
}

void processingSetup(){
  size(640, 480);
   if (frame != null) {
    frame.setResizable(true);
  }
  backgroundColor = color(0);
  fontColor = color(255);
}

void createWindows() {
  window2 = new GWindow(this, player2, 70, 160, 200, 200, false, JAVA2D);
  window2.setBackground(backgroundColor);
  //window2.addData(new MyWinData());
}

