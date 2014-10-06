
public void serialSetup(){
  connected = false;
}

void serialRead(){
  if(connected){
    while(clockPort.available() > 0){
      //clockPort.read()
    }
  }
}
