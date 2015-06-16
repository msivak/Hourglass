Hourglass
==============

The Hourglass software and hardware is released under the GPL v3 license. Copyright (C) 2015  Mark Sivak.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

==============
The code is working but is still being cleaned and optimized, it should be considered beta until this process is finished.

==============
Controls:

P: Used to pause the clock from the keyboard

S: Used to start the clock from the keyboard

SPACE: Used to switch players from the keyboard

C: Show/hide the config panel

Design choice notes
-Time should be maintained on the Arduino because then it is OS independent and above all else we want the output the players see to be accurate
-To handle turn extensions when time expires hitting the pause button will give the extension

