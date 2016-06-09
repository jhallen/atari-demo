; Atari 800 Hardware
; Labels used are mostly from "Mapping the Atari"
;  see http://www.atariarchives.org/mapping/memorymap.php

; COLOR = HUE*16 + LUMINANCE
;Color             Value         Color             Value
;Black           0,      0       Medium blue     8,    128
;Rust            1,     16       Dark blue       9,    144
;Red-orange      2,     32       Blue-grey      10,    160
;Dark orange     3,     48       Olive green    11,    176
;Red             4,     64       Medium green   12,    192
;Dk lavender     5,     80       Dark green     13,    208
;Cobalt blue     6,     96       Orange-green   14,    224
;Ultramarine     7,    112       Orange         15,    240

; Pixel values
;  4-color modes:
;   00 = COLOR 0 = COLBK
;   01 = COLOR 1 = COLPF0
;   10 = COLOR 2 = COLPF1
;   11 = COLOR 3 = COLPF2
;  2-color modes:
;   0 = COLOR 0 = COLBK
;   1 = COLOR 1 = COLPF0

; GTIA
HPOS0	=	$D000	; W
M0PF	=	$D000	; R
HPOS1	=	$D001	; W
M1PF	=	$D001	; R
HPOS2	=	$D002	; W
M2PF	=	$D002	; R
HPOS3	=	$D003	; W
M3PF	=	$D003	; R
HPOSM0	=	$D004	; W
P0PF	=	$D004	; R
HPOSM1	=	$D005
P1PF	=	$D005
HPOSM2	=	$D006
P2PF	=	$D006
HPOSM3	=	$D007
P3PF	=	$D007
SIZEP0	=	$D008
M0PL	=	$D008
SIZEP1	=	$D009
M1PL	=	$D009
SIZEP2	=	$D00A
M2PL	=	$D00A
SIZEP3	=	$D00B
M3PL	=	$D00B
SIZEM	=	$D00C
P0PL	=	$D00C
GRAFP0	=	$D00D
P1PL	=	$D00D
GRAFP1	=	$D00E
P2PL	=	$D00E
GRAFP2	=	$D00F
P3PL	=	$D00F
GRAFP3	=	$D010
TRIG0	=	$D010
GRAFM	=	$D011
TRIG1	=	$D011
COLPM0	=	$D012
TRIG2	=	$D012
COLPM1	=	$D013
TRIG3	=	$D013
COLPM2	=	$D014
PAL	=	$D014
COLPM3	=	$D015

COLPF0	=	$D016
COLPF1	=	$D017
COLPF2	=	$D018
COLPF3	=	$D019
COLBK	=	$D01A
PRIOR	=	$D01B
VDELAY	=	$D01C
GRACTL	=	$D01D
HITCLR	=	$D01E
CONSOL	=	$D01F

; Pokey
AUDF1	=	$D200
POT0	=	$D200
AUDC1	=	$D201
POT1	=	$D201
AUDF2	=	$D202
POT2	=	$D202
AUDC2	=	$D203
POT3	=	$D203
AUDF3	=	$D204
POT4	=	$D204
AUDC3	=	$D205
POT5	=	$D205
AUDF4	=	$D206
POT6	=	$D206
AUDC4	=	$D207
POT7	=	$D207
AUDCTL	=	$D208
ALLPOT	=	$D208
STIMER	=	$D209
KBCODE	=	$D209
SKREST	=	$D20A
RANDOM	=	$D20A
POTGO	=	$D20B
SEROUT	=	$D20D
SERIN	=	$D20D
IRQEN	=	$D20E
IRQST	=	$D20E
SKCTL	=	$D20F
SKSTAT	=	$D20F

; PIA
PORTA	=	$D300
PORTB	=	$D301
PACTL	=	$D302
PBCTL	=	$D303

; Antic
DMACTL	=	$D400
CHACTL	=	$D401
DLISTL	=	$D402
DLISTH	=	$D403
HSCROL	=	$D404
VSCROL	=	$D405
PMBASE	=	$D407
CHBASE	=	$D409
WSYNC	=	$D40A
VCOUNT	=	$D40B
PENH	=	$D40C
PENV	=	$D40D
NMIEN	=	$D40E
NMIRES	=	$D40F
NMIST	=	$D40F

; 6502
NMIVEC	=	$FFFA
RESVEC	=	$FFFC
IRQVEC	=	$FFFE

; Atari 800 OS

DOSVEC	=	$000A
POKMSK	=	$0010
SAVMSC	=	$0058
SDMCTL	=	$022F	; Shadow for DMACTL
SDLSTL	=	$0230	; Shadow for DLISTL, DLISTH
GPRIOR	=	$026F	; Shadow for PRIOR
PCOLR0	=	$02C0	; Shadow for COLPM0
PCOLR1	=	$02C1	; Shadow for COLPM1
PCOLR2	=	$02C2	; Shadow for COLPM2
PCOLR3	=	$02C3	; Shadow for COLPM3
COLOR0	=	$02C4	; Shadow for COLPF0
COLOR1	=	$02C5	; Shadow for COLPF1
COLOR2	=	$02C6	; Shadow for COLPF2
COLOR3	=	$02C7	; Shadow for COLPF3
COLOR4	=	$02C7	; Shadow for COLBK
CHACT	=	$02F3	; Shadow for CHACTL
CHBAS	=	$02F4	; Shadow for CHBASE

; OS
CIOV	=	$D456
