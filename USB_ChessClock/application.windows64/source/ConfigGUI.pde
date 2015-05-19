
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


void createWindowSize(){
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

void createFontList(){
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


void createStartBtn(){
  btnStart = new GButton(this, panelW/2-30, panelH-20, 60, 20, "Start");
  btnStart.setEnabled(false);
  configPanel.addControl(btnStart);
}


void createGameTime(){
  timeSlide =  new GCustomSlider(this, 0, panelH-90, panelW, 50, null);
  timeSlide.setShowDecor(false, true, true, true);
  timeSlide.setNbrTicks(10);
  timeSlide.setLimits(gameTime, 0, 90);
  configPanel.addControl(timeSlide);
}


void createClockMode(){
  usbClock = new GOption(this, 10, 20, 100, 20, "USB Clock");
  laptopClock = new GOption(this, panelW-110, 20, 100, 20, "Laptop Clock");
  
  tgClock = new GToggleGroup();
  tgClock.addControls(usbClock, laptopClock);
  configPanel.addControls(usbClock, laptopClock);
  usbClock.setSelected(true);
}

void createGameMode(){
  deathClock = new GOption(this, 10, panelH-40, 100, 20, "Death Clock");
  timedTurns = new GOption(this, panelW/2-50, panelH-40, 100, 20, "Timed Turns");
  hardcore = new GOption(this, panelW-100, panelH-40, 100, 20, "Hardcore");
  
  tg = new GToggleGroup();
  tg.addControls(deathClock, timedTurns, hardcore);
  configPanel.addControls(deathClock, timedTurns, hardcore);
  deathClock.setSelected(true);
}

void createBackgroundColor() {
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


void createFontColor(){
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

void createSerial(){
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

void createPlayerTime(){
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

void createPlayerNames(){
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
