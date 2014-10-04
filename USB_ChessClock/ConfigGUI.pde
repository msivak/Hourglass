
//This function is used to place all the config GUI components
public void configGUISetup(){
  
  configPanel = new GPanel(this, 0, 0, panelW, panelH, "Configuration Panel");
  configPanel.setCollapsed(false);
  
  createFontList();
  createStartBtn();
  createGameMode();
  createGameTime();
  //createPlayerNames();
  createBackgroundColor();
  createFontColor();
}


void createFontList(){
  fontList = new GDropList(this, panelW/2-55, panelH-120, 120, 110, 5);
  fontList.setItems(fNames, 0);
  fontList.setOpaque(false);
  configPanel.addControl(fontList);
}


void createStartBtn(){
  btnStart = new GButton(this, panelW/2-30, panelH-20, 60, 20, "Start");
  configPanel.addControl(btnStart);
}


void createGameTime(){
  timeSlide =  new GCustomSlider(this, 0, panelH-90, panelW, 50, null);
  timeSlide.setShowDecor(false, true, true, true);
  timeSlide.setNbrTicks(10);
  timeSlide.setLimits(60, 0, 90);
  configPanel.addControl(timeSlide);
}


void createGameMode(){
  deathClock = new GOption(this, panelW/2-100, panelH-40, 100, 20, "Death Clock");
  timedTurns = new GOption(this, panelW/2, panelH-40, 100, 20, "Timed Turns");
  tg = new GToggleGroup();
  tg.addControls(deathClock, timedTurns);
  configPanel.addControls(deathClock, timedTurns);
}

void createBackgroundColor() {
  int x = 10;
  int y = 30;
  GLabel title = new GLabel(this, x, y, 150, 20);
  title.setText("Background Color", GAlign.LEFT, GAlign.MIDDLE);
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
  int x = 170;
  int y = 30;
  GLabel title = new GLabel(this, x, y, 150, 20);
  title.setText("Font Color", GAlign.LEFT, GAlign.MIDDLE);
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


void createPlayerNames(){
  p1Text = new GTextArea(this, 0, 0, 60, 40);
  p1Text.setText("Player1");
  configPanel.addControl(p1Text);
  p2Text = new GTextArea(this, 0, 50, 60, 40);
  p2Text.setText("Player2");
  configPanel.addControl(p2Text);
}


