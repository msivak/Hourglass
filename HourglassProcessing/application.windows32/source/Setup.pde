

//Instantiate variable for the time windows and Processing variables
void processingSetup(){
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

void createWindows() {
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

void createScenario(){

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