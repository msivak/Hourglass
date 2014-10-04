
//This function is used to place all the config GUI components
public void configGUISetup(){
  
  configPanel = new GPanel(this, 0, 0, panelW, panelH, "Configuration Panel");
  configPanel.setCollapsed(false);
  
  fontList = new GDropList(this, panelW/2-55, 30, 120, 110, 5);
  fontList.setItems(fNames, 0);
  fontList.setOpaque(false);
  configPanel.addControl(fontList);
  
  btnStart = new GButton(this, panelW/2-30, panelH-20, 60, 20, "Start");
  configPanel.addControl(btnStart);
  
//  p1Text = new GTextArea(this, 0, 0, 60, 40);
//  p1Text.setText("Player1");
//  configPanel.addControl(p1Text);
//  p2Text = new GTextArea(this, 0, 50, 60, 40);
//  p2Text.setText("Player2");
//  configPanel.addControl(p2Text);
  
  deathClock = new GOption(this, panelW/2-100, panelH-40, 100, 20, "Death Clock");
  timedTurns = new GOption(this, panelW/2, panelH-40, 100, 20, "Timed Turns");
  tg = new GToggleGroup();
  tg.addControls(deathClock, timedTurns);
  configPanel.addControls(deathClock, timedTurns);
  
  timeSlide =  new GCustomSlider(this, 0, panelH-90, panelW, 50, null);
  timeSlide.setShowDecor(false, true, true, true);
  timeSlide.setNbrTicks(10);
  timeSlide.setLimits(60, 0, 90);
  configPanel.addControl(timeSlide);
}
