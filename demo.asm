
; Atari equates
	.include "atari.asm"

	.bank

; Zero page temporaries
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
; 160x200 2 bits per pixel

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

; Main entry point
main
; Clear bitmap
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
; Exit demo when user hits Start button
	lda	CONSOL
	and	#1
	bne	loop

; Restore screen and return to OS
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
;  Start of line address in addr
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
; We put this in a seperate bank to force it to be at the end of file
; (otherwise atasm emits sections in address order)
	*=	$2e0
	.word	main
	.end
