void keyPressed(){
  
 if(key == 'c'){
   if(configPanel.getX() != 0 && configPanel.getY() != 0){ 
     configPanel.moveTo(0,0);
   }
   else{
     configPanel.moveTo(-50,-50);
     configPanel.setCollapsed(true);
   }
 } 
 
 if(keyCode == UP){
   timeSize += 2;
   textSize(timeSize);
   if(p2App != null){
     p2App.textSize(timeSize);
   }
 }
 
 if(keyCode == DOWN){
   if(timeSize > 8){
     timeSize -= 2;
     textSize(timeSize);
     if(p2App != null){
       p2App.textSize(timeSize);
     } 
   }
 }
 
if(key == 'p'){
  
   if(!usbMode){
       pause = true;
       if(timer.isRunning()){
         timer.stop();
       }
   }
   else if(connected){
     pause = !pause;
     clockPort.write("|");
   }
 }
 
 if(key == 's'){
   if(!usbMode){
     pause = false;
     if(!timer.isRunning()){
         timer.start();
       }
   }
   else if(connected){
   }
 }
 
 if(key == ' '){
   activePlayer = (activePlayer+1)%numPlayers;
   
 }
 
}

void keyPlayer1(GWinApplet appc2, GWinData data2, KeyEvent eyevent){
  
}

void keyPlayer2(GWinApplet appc, GWinData data, KeyEvent eyevent){
  if(eyevent.getKey() == 'c'){
   if(configPanel.getX() != 0 && configPanel.getY() != 0){ 
     configPanel.moveTo(0,0);
   }
   else{
     configPanel.moveTo(-50,-50);
     configPanel.setCollapsed(true);
   }
 } 
 
 if(eyevent.getKeyCode() == UP){
   timeSize += 2;
   textSize(timeSize);
   if(p2App != null){
     p2App.textSize(timeSize);
   }
 }
 
 if(eyevent.getKeyCode() == DOWN){
   if(timeSize > 8){
     timeSize -= 2;
     textSize(timeSize);
     if(p2App != null){
       p2App.textSize(timeSize);
     } 
   }
 }
 
 if(eyevent.getKey() == 'p'){
   if(!usbMode){
     pause = true;
       if(timer.isRunning()){
         timer.stop();
       }
   }
   else if(connected){
     clockPort.write("|");
     pause = !pause;
   }
 }
 
 if(eyevent.getKey() == 's'){
   if(!usbMode){
     pause = false;
     if(!timer.isRunning()){
         timer.start();
       }
   }
   else if(connected){
     //pause = false;
   }
 }
 
   if(eyevent.getKey() == ' '){
     if(!usbMode){
       activePlayer = (activePlayer+1)%numPlayers;
     }
   }
}
