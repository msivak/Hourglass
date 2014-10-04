

// G4P code for colour chooser
public void handleBackgroundColorChooser() {
  backgroundColor = G4P.selectColor();
  pg.beginDraw();
  pg.background(backgroundColor);
  pg.endDraw();
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
void handleButtonEvents(GButton button, GEvent event) {
  if(button == btnStart){
    if (window2 == null && event == GEvent.CLICKED) {
      createWindows();
      configPanel.setText("CP");
      frame.setSize(240,120);
    }
  }
  else if(button == btnBackgroundColor){
    handleBackgroundColorChooser();
  }
  else if(button == btnFontColor){
    handleFontColorChooser();
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
