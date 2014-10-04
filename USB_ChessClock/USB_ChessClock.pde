/**
 * Chess Clock Code
 * @author Mark Sivak, PhD
 * Fall 2014
 */

import g4p_controls.*;
import java.util.ArrayList;
import java.awt.Rectangle;

GWindow window2;

//G4P_Dialogs check it

//GUI Variables
GPanel configPanel;
GButton btnStart;
//GTextArea p1Text;
//GTextArea p2Text;
GOption deathClock, timedTurns;
GToggleGroup tg;
GCustomSlider timeSlide;
GDropList fontList;


// Controls used for colour chooser dialog GUI 
GButton btnBackgroundColor;
GSketchPad spad;
PGraphics pg;
int sel_bg_col = -1;

GButton btnFontColor;
GSketchPad spad2;
PGraphics pg2;
int sel_f_col = -1;

//Config Variables
color backgroundColor;
int gameTime;
String player1;
String player2;
int[] p1Time;
int[] p2Time;
Boolean gameMode;
PFont timeFont;
int panelW = 240;
int panelH = 240;
String[] fNames = {"Black", "White", "Red", "Green", "Blue", "Yellow", "Pink", "Grey"};
ArrayList<Rectangle> rects ;

//Setup function
void setup() {
  size(640, 480);
   if (frame != null) {
    frame.setResizable(true);
  }
  rects = new ArrayList<Rectangle> ();
  backgroundColor = color(240,240,240);
  //serialSetup();
  configGUISetup();
  createColorChooserGUI(480, 20, 160, 60, 6);
  
}

/**
 * Draw for the main window
 */
void draw() {
  G4P.setWindowColorScheme(this, 5);
  background(backgroundColor);
}


// G4P code for colour chooser
public void handleColorChooser() {
  sel_bg_col = G4P.selectColor();
  pg.beginDraw();
  pg.background(sel_bg_col);
  pg.endDraw();
}


void createWindows() {
  window2 = new GWindow(this, player2, 70, 160, 200, 200, false, JAVA2D);
  window2.setBackground(backgroundColor);
  //window2.addData(new MyWinData());
}

/**
 * Button Event Handler
 * @param button
 */
void handleButtonEvents(GButton button, GEvent event) {
  if(button == btnStart){
    if (window2 == null && event == GEvent.CLICKED) {
      createWindows();
      configPanel.setText("CP");
    }
  }
  else if(button == btnBackgroundColor){
    handleColorChooser();
  }
  else if(button == btnFontColor){
    
  }
}

/**
 * Radio Button Event Handler
 * @param toggle
 */
public void handleToggleControlEvents(GToggleControl option, GEvent event) {
  if (option == deathClock) {
    gameMode = true;
  }
  if (option == timedTurns) {
    gameMode = false;
  }
}

// The next 4 methods are simply to create the GUI. So there is
// no more code related to the various dialogs.
public void createColorChooserGUI(int x, int y, int w, int h, int border) {
  // Store picture frame
  rects.add(new Rectangle(x, y, w, h));
  // Set inner frame position
  x += border; 
  y += border;
  w -= 2*border; 
  h -= 2*border;
  GLabel title = new GLabel(this, x, y, w, 20);
  title.setText("Color picker dialog", GAlign.LEFT, GAlign.MIDDLE);
  title.setOpaque(true);
  title.setTextBold();
  btnBackgroundColor = new GButton(this, x, y+26, 80, 20, "Choose");
  sel_bg_col = color(255);
  pg = createGraphics(60, 20, JAVA2D);
  pg.beginDraw();
  pg.background(sel_bg_col);
  pg.endDraw();
  spad = new GSketchPad(this, x+88, y+26, pg.width, pg.height);
  spad.setGraphic(pg);
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
public void handleListEvents(){}
