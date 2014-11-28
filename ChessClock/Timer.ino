

void timer(){
  if(activePlayer){
     if(p1Time[1] <= 0){
        timeText = String(p1Time[0])+":00";
        p1Time[0]--;
        if(p1Time[0]<10){
          minStr = "0";
        }
        else{
          minStr = "";
        }
        
        //if(p1Time[0] <= 0 && p1Time[1] <= 0){
          //gameOver();
        //}
        p1Time[1] = 60;
        secStr = "";
      }
      else if(p1Time[1] <= 10 && p1Time[1] > 0){
        secStr = "0";
      }
      else{
        secStr = "";
      }
      
      if(p1Time[0] == 1 && p1Time[1] == 1){
          playTone();
        }
        
      if(p1Time[0] == 0 && p1Time[1] < 5){
        playTone();
      }
      
      p1Time[1]--;
      timeText = minStr+String(p1Time[0])+":"+secStr+String(p1Time[1]);
      
    }
    else if(activePlayer == false){
     if(p2Time[1] <= 0){
       p2Time[0]--;
       if(p2Time[0] < 10){
         minStr = "0";
       }
       else{
         minStr = "";
       }
       
        //if(p2Time[0] <= 0 && p2Time[1] <= 0){
          //gameOver();
        //}
       secStr = "";
       p2Time[1] = 60;
     }
     else if(p2Time[1] <= 10 && p2Time[1] > 0){
       secStr = "0";
     }
     else{
       secStr = "";
     }
     
     if(p2Time[0] == 0 && p2Time[1] == 1){
          playTone();
     }
     
     if(p2Time[0] == 0 && p2Time[1] < 5){
        playTone();
      }
     
     p2Time[1]--;
     timeText2 = minStr+String(p2Time[0])+":"+secStr+String(p2Time[1]);
       
   }
  serialWrite();
  lcdWrite();
}
