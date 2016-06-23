# Atari 800 demo

This is a rotating cylinder demo.

[watch demo on youtube](https://youtu.be/X7iS4jgMyZw)

Bonus demo: Atari BASIC maze generator:

[watch maze generator on youtube](https://youtu.be/Yf_OPNQA1-4)

## Atari development on Linux

To run it in a simulator, type:

	make try

To run it with sio2pc (for a real Atari to boot), type:

	sudo make serv

Then at the OS prompt, type:

	demo

Hit "Start" to exit the demo.

But first you need to install:

Mac65 compatible assembler:

[atasm106](https://sourceforge.net/projects/atasm/)

Atari 800 XL simulator for Linux.  You may want to apply the patch
atari++.patch to prevent atari++ from displaying its copyright notice and
asking if you really want to quit each time:

[atari++](http://www.xl-project.com/)

ATR disk image manager:

[atr](https://github.com/jhallen/atari-tools)

Linux command line version interface for "sio2pc" board.  You may want to
set "snoop = 0" to reduce the number of messages it prints:

[sio2linux](http://www.crowcastle.net/preston/atari/)

Tihs works with both the version which plugs into a real serial port:

[sio2pc](http://www.atarimax.com/sio2pc/documentation/jack/index.php)

And versions which use the FTDI USB to RS-232 adapter chip.  In this case
use the '-n' flag for sio2linux.

[sio2pc-usb](http://www.lotharek.pl/product.php?pid=98)

## Maze generator

It's m6.bas on maze.atr.
