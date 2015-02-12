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
  
}

public void saveConfig(){
  
 p1x = frame.getX();
 p1y = frame.getY();
 
 w1 = width;
 h1 = height;
  
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
