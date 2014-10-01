/**
 * Chess Clock Code
 * @author Mark Sivak, PhD
 * Fall 2014
 */

import g4p_controls.*;

//GUI Variables
GWindow window2;
GButton btnStart;
GLabel lblInstr;
GTextArea p1Text;
GTextArea p2Text;

//Config Variables
color backgroundColor;
long gameTime;
String player1;
String player2;
int[] p1Time;
int[] p2Time;

void setup() {
  size(640, 480);
  backgroundColor = color(240,240,240);
  
  btnStart = new GButton(this, 4, 34, 120, 60, "Start");
  p1Text = new GTextArea(this, 0, 100, 100, 50);
  p1Text.setText("Player1");
  p2Text = new GTextArea(this, 0, 200, 100, 50);
  p2Text.setText("Player2");
  //btnGameMode = 
  //btnGameTime = 
  
  lblInstr = new GLabel(this, 132, 34, 120, 60, "Use the mouse to draw a rectangle in any of the 3 windows");
  lblInstr.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lblInstr.setVisible(false);
}

/**
 * Draw for the main window
 */
void draw() {
  background(backgroundColor);
}


void createWindows() {
  window2 = new GWindow(this, player2, 70, 160, 200, 200, false, JAVA2D);
  window2.setBackground(backgroundColor);
  window2.addData(new MyWinData());
  window2.addDrawHandler(this, "windowDraw");
  window2.addMouseHandler(this, "windowMouse");
}

/**
 * Click the button to create the windows.
 * @param button
 */
void handleButtonEvents(GButton button, GEvent event) {
  if (window2 == null && event == GEvent.CLICKED) {
    createWindows();
    lblInstr.setVisible(true);
    button.setEnabled(false);
  }
}

/**
 * Handles mouse events for ALL GWindow objects
 *  
 * @param appc the PApplet object embeded into the frame
 * @param data the data for the GWindow being used
 * @param event the mouse event
 */
void windowMouse(GWinApplet appc, GWinData data, MouseEvent event) {
  MyWinData data2 = (MyWinData)data;
  switch(event.getAction()) {
  case MouseEvent.PRESS:
    data2.sx = data2.ex = appc.mouseX;
    data2.sy = data2.ey = appc.mouseY;
    data2.done = false;
    break;
  case MouseEvent.RELEASE:
    data2.ex = appc.mouseX;
    data2.ey = appc.mouseY;
    data2.done = true;
    break;
  case MouseEvent.DRAG:
    data2.ex = appc.mouseX;
    data2.ey = appc.mouseY;
    break;
  }
}

/**
 * Handles drawing to the windows PApplet area
 * 
 * @param appc the PApplet object embeded into the frame
 * @param data the data for the GWindow being used
 */
void windowDraw(GWinApplet appc, GWinData data) {
  MyWinData data2 = (MyWinData)data;
  if (!(data2.sx == data2.ex && data2.ey == data2.ey)) {
    appc.stroke(255);
    appc.strokeWeight(2);
    appc.noFill();
    if (data2.done) {
      appc.fill(128);
    }
    appc.rectMode(CORNERS);
    appc.rect(data2.sx, data2.sy, data2.ex, data2.ey);
  }
}  

/**
 * Simple class that extends GWinData and holds the data 
 * that is specific to a particular window.
 * 
 * @author Peter Lager
 */
class MyWinData extends GWinData {
  int sx, sy, ex, ey;
  boolean done;
}
