# Atari 800 demo

This is a rotating cylinder demo.

To run it in a simulator, type:

	make try

To run it with sio2pc (for a real Atari to boot), type:

	make serv

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

This is for the [sio2pc](http://www.atarimax.com/sio2pc/documentation/jack/index.php)
module connected to a real serial port, not USB.
