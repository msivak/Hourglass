//The Arduino Code for the Hourglass
//Mark Sivak, PhD
//Fall 2014 - Spring 2015

#include "Timer.h"
#include "LiquidCrystal.h"
#include "Button.h"

boolean switchType = false; //for the pause button hardware, false for momentary switch

boolean activePlayer; //changed by the playerPin switch
boolean losingPlayer;
int gameMode = 0; //0 deathclock, 1 timed turns, 2 hardcore
boolean clockMode; //for use without Processing
int p1Time[2], p2Time[2]; //arrays to hold the time of each player
int p1Ti, p2Ti; //inital time used for resetting
int mins, secs; //used to craft the strings for the clock
boolean playing = false; //used to trigger setup ending by receiving time from Processing
boolean flip = false; //
boolean noReset;
int gameTime; //used to reset the time for timed turns and hardcore
int p1Tinit;
int p2Tinit;
boolean pause = true; //used to pause the game
boolean pauseHold = true; //needed for a momentary switch
char readChar;
boolean p2 = false;
String nameSpaces = "";

String p1Name = "";
String p2Name = "";
String p1n, p2n;
String playerString;

Button pauseButton = Button(19, HIGH);

boolean p1Ex = true;
boolean p2Ex = true;

String timeText = ""; //string for player 1 time for display and serial communication
String timeText2 = ""; //string for player 2 time for display and serial communication
String timerSpaces = "";
String minStr; //used for proper spacing on the LCD when time is < 10
String minStr2;
String secStr; //used for proper spacing on the LCD when time is < 10

int fade = 0;
int fadeSwitch = 2;
long pauseTime = 0;
long toneTime = 0;
long gameOverTime = 0;
boolean toggle = false;

//Pin Variables
int pausePin = 19; //This is equal to A5 and the pin for the pause button
int playerPin = 8; //The positive input for the player switch
int p1LEDPin = 9; //PWM control of the left LED
int p2LEDPin = 10; //PWM control of the right LED
int speakerPin = 6; //PWM control for the piezo speaker
int modePin; //will be used for non-Processing mode

//Object variables
Timer t; //main game timer
Timer p; //timer for pause beep
LiquidCrystal lcd(12, 11, 5, 4, 3, 2); //the numbers correspond to the pins of the LCD

//This function runs once at the beginning of the program
void setup(){
  
  Serial.begin(9600); //start serial communication with Processing
  
  pinSetup(); //perform pin setup for the different types of hardware
  timerSetup(); //initialize the main timer and the pause timer
  clockSetup(); //initialize variables
  lcdSetup(); //setup the LCD
}

//This function runs continuously once setup has finished
void loop(){
  
  pauseButton.listen();
  
  serialRead(); //look for input from Processing
  
  if(playing){
    playerSwitch(); //check if the active player has switched
    pauseSwitch(); //check to see if the game is paused
    toneEnd(); //check tone length
    
    if(!pause){
      t.update(); //update the timer
      playerLED(); //turn on the LED of the active player
    }
    else{
      p.update(); //update the pause timer
      ledFade(); //make the LEDs blink for pause feedback
      hold();
    }
  }
  
}





