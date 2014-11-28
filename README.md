USB-ChessClock
==============

The Processing and Arduino code for a USB connected chess clock

Controls:

P: Used to pause the clock from the keyboard
S: Used to start the clock from the keyboard
SPACE: Used to switch players from the keyboard

Design choice notes
-Time should be maintained on the Arduino because then it is OS independent and above all else we want the output the players see to be accurate
-To handle turn extensions when time expires hitting the pause button will give the extension

Processing features implemented:
- Multiple windows that can be resized
- Changing the background color
- Movable config panel
- Mode change between deathclock and timed turns
- Change color of clock
- Change font
- Add fonts to data folder
- Change font size using arrows
- Turn extension length
- Config panel hide/show
- Resizeable windows
- Pause Feedback
- Position in window
- Non-Arduino Mode
- Serial connection with an arduino

Processing features to implement:
- Color change for when time runs low
- Player names to input to Arduino
- Keyboard to arduino input
- Serial port choice fixed
- Direct time input for each player

Arduino features implemented:
- Serial communication
- Countdown of time
- Switching turns with a switch
- Pausing with a button
- Display to LCD
- Switch turn LED feedback'
- Ready to start mode

Arduino features to implment:
- Holding down a button to reset
- Turn extensions done with the button
- Sound issue
- Display issues

Documentation to add:
- BOM for parts
- Installation instructions
- Assembly instructions
- Case models
- Finalize code documentation
