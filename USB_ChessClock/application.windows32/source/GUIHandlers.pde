

// G4P code for colour chooser
public void handleBackgroundColorChooser() {
  backgroundColor = G4P.selectColor();
  configFile.setString("backgroundColor", hex(backgroundColor));
  saveJSONObject(configFile, "data/ClockConfig.json");
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
void handleButtonEvents(GButton button, GEvent event) {
  if(button == btnStart){
    frame.setLocation(p1x, p1y);
    configPanel.setCollapsed(true);
    configPanel.moveTo(-50,-50);
    if (window2 == null && event == GEvent.CLICKED) {
      createWindows();
      config = false;
      frame.setSize(w1,h1+20);
    }
    else{
      frame.setSize(wOld,hOld+20);
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
    if(window2 != null){
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
    if(window2 != null){
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
}


public void handlePanelEvents(GPanel panel, GEvent event) {
  
}
