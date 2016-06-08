
; Atari 800 Hardware

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
	.bank

	*=	$80
tmp	.ds	1
addr	.ds	2
count	.ds	2

; Min address to prevent dup.sys reload
	*=	$3400
; Make OS/A+ happy
	rts

; Address of screen: it's 4010 .. 5F4F
; We start at +$10 to handle 4K crossing issue
scr	=	$4010

; Display list
dlist	.byte	$70
	.byte	$70
	.byte	$70
; 200 lines...
	.byte	$4e
	.word	scr
	.dc	101 $0e
	.byte	$4e
	.word	scr+4096-16
	.dc	97 $0e
; Wait for V-SYNC and repeat
	.byte	$41
	.word	dlist

; Wait for V-SYNC
wvsync	lda	VCOUNT
	bne	wvsync
	rts

main
; Clear pixel ram
	lda	#<scr
	sta	addr
	lda	#>scr
	sta	addr+1
	lda	#<8000
	sta	count
	lda	#>8000
	sta	count+1
	lda	#0
	jsr	memset

; Disable OS
	sei
	lda	#0
	sta	IRQEN
	sta	NMIEN
	sta	DMACTL
; Wait for V-SYNC
	jsr	wvsync
; Install our display list
	lda	#<dlist
	sta	DLISTL
	lda	#>dlist
	sta	DLISTH
; Enable DMA
	lda	#$22
	sta	DMACTL

; Demo
	lda	#0
	sta	tmp
	jmp	startit
loop	inc	tmp
startit	jsr	xorit
;	lda	#1*16+5	; Timing check
;	sta	COLBK
	jsr	wvsync
	lda	#0*16+0
	sta	COLBK
; Wait for user to hit Start
	lda	CONSOL
	and	#1
	bne	loop

; Restore
	lda	#0
	sta	DMACTL
	jsr	wvsync
	lda	SDLSTL
	sta	DLISTL
	lda	SDLSTL+1
	sta	DLISTH
	lda	SDMCTL
	sta	DMACTL
	lda	#$40
	sta	NMIEN
	lda	POKMSK
	sta	IRQEN
	cli
	rts

; Draw some dots
;xorit
;	ldx	#0
;xorit1	lda	daddrl,x
;	sta	addr
;	lda	daddrh,x
;	sta	addr+1
;	lda	dots,x
;	jsr	draw
;	inx
;	bne	xorit1
;	rts


; Include offtab, bittab and xorit code.
	.include "autogen.asm"

; Draw a pixel
;  Line address in addr
;  X offset in A
;  tmp has rotation offset
draw
	pha
	clc
	adc	tmp
	tay
	lda	offtab,y
	tay
	lda	#0
;	eor	(addr),y
	sta	(addr),y

	pla
	sec
	adc	tmp
	tay
	lda	bittab,y
	pha
	lda	offtab,y
	tay
	pla
;	eor	(addr),y
	sta	(addr),y
	rts

; Byte fill a block of memory
;  Enter: addr set with address
;         A set with byte
memset	ldy	#0
	ldx	count+1
	beq	short

inner	sta	(addr),y
	iny
	sta	(addr),y
	iny
	sta	(addr),y
	iny
	sta	(addr),y
	iny
	bne	inner

	inc	addr+1
	dec	count+1
	bne	inner
	beq	short

slolop	sta	(addr),y
	iny
short	cpy	count
	bne	slolop

	rts

	.bank
; Set run address
	*=	$2e0
	.word	main
	.end
