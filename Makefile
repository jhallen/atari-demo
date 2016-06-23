all : maze.atr dos2s.atr
#	sio2linux maze.atr

serv : maze.atr
# USB sio2pc needs -n flag
	sio2linux -s /dev/ttyUSB0 -n maze.atr
# Original sio2pc on real serial port does not
#	sio2linux -s /dev/ttyS0 maze.atr

try : maze.atr
	atari++ -VideoMode NTSC -Image.1 maze.atr

maze.atr : maze.com demo.com
	atr maze.atr put maze.com
	atr maze.atr put demo.com

dos2s.atr : maze.com
	atr dos2s.atr put maze.com
	atr dos2s.atr put demo.com

maze.com : maze.asm
	rm -f maze.com
	atasm -omaze.com maze.asm

genrnd : genrnd.c
	cc -o genrnd genrnd.c -lm

demo.com : demo.asm genrnd
	rm -f demo.com autogen.asm
	./genrnd >autogen.asm
	atasm -odemo.com demo.asm
