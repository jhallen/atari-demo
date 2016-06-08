	.include sysequ.m65
	.include iomac.lib

; Equates

savmsc	=	$58	; Has address of screen buffer
dosvec	=	$0A
; Initial screen has 24 lines of 40 characters each.

; This is an OS shadow register: copied to real reg. during blank.
chbas	=	$2f4	; Has address of font
; Font mapping:
;  ASCII $20 - $5F is Font $00 - $3F
;  graphic chars is Font $40 - $5F
;    Up arrow: $5C
;    Down arrow $5D
;    Left arrow $5E
;    Right arrow $5F
;  ASCII $60 - $7F is Font $60 - $7F


; Zero page locations

	.bank

	*=	$80

xpos	.ds	1	; Current x position
ypos	.ds	1	; Current y position
addr	.ds	2	; 16-bit destination pointer
src	.ds	2	; 16 bit source pointer
count	.ds	2	; 16-bit Counter

; Set run address for loader

; Main program

; MEMLO in DOS 2.0s is 1CFC, but DUP.SYS uses up to 3306
; MEMLO in OS/A+ version 2.00 is 2000

; In DOS 2.0s, DUP.SYS reloads if you load below $3400

;	*=	$3306	; bad
;	*=	$3380	; bad
;	*=	$33C0	; bad
;	*=	$33E0	; bad
;	*=	$33F0	; bad
;	*=	$33F8	; bad
;	*=	$33FC	; bad
	*=	$3400	; good
;	*=	$3800	; good

; Some versions of OS/A+ execute first segment
; even if $2E0 is set.
	rts

; Put buffer for print ahead of macros which use it.  PRINT macro
; is unhappy with forward references.
buffer	.ds	80
tmpr	.ds	4

main
	lda	#<buffer
	sta	addr
	lda	#>buffer
	sta	addr+1

	lda	#<msg
	sta	src
	lda	#>msg
	sta	src+1
	jsr	zcpy

	lda	#1
	sta	$f800
	lda	#2
	sta	$f801
	lda	#3
	sta	$f802
	lda	#4
	sta	$f803

; Disable all interupts
	sei
	lda	#0
	sta	$d40e

; Switch maps
	lda	#128+2
	sta	$d301

	sta	$f800

	lda	$f800
	sta	tmpr
	lda	$f801
	sta	tmpr+1
	lda	$f802
	sta	tmpr+2
	lda	$f803
	sta	tmpr+3

	lda	#128+3
	sta	$d301

; Enable them
	lda	#64
	sta	$d40e
	cli

	lda	tmpr
	jsr	cvthex
	lda	tmpr+1
	jsr	cvthex
	lda	tmpr+2
	jsr	cvthex
	lda	tmpr+3
	jsr	cvthex
	

	.if	0
;	lda	#$AB
	lda	MEMLO+1
	jsr	cvthex
;	lda	#$CD
	lda	MEMLO
	jsr	cvthex

	lda	#$20
	jsr	append

	lda	MEMLO
	ldy	MEMLO+1
	jsr	cvtdec
	.endif

	jsr	appeol

	print	0,buffer

;	jsr	clrscn

; Write A to top of screen
	lda	#$21
	ldy	#0
	sta	(savmsc),y

;	jmp	(dosvec)
	rts

; Subroutine to clear the screen
clrscn	lda	savmsc
	sta	addr
	lda	savmsc+1
	sta	addr+1

	lda	#<[40*24]
	sta	count
	lda	#>[40*24]
	sta	count+1

	lda	#$21

; Fall into memset

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

; Convert A to hex, append to (addr)

cvthex2
; Save registers on stack
	pha
	txa
	pha
	tya
	pha

; Get registers back as they were called
	tsx
	lda	$103,x	; get original a
	pha
	lda	$103,x	; get original x
	tax
	pla		; original a

; Restore registers from stack
	pla
	tay
	pla
	tax
	pla
	rts

; 31 bytes
;cvthex1	pha
;	lsr
;	lsr
;	lsr
;	lsr
;	jsr	cvth1
;	pla
;	and	#$0f
;cvth1	tax
;	lda	hexdig,x
;	bne	append
;hexdig	.byte	"0123456789ABCDEF"

; Convert A to hex, append to (addr)
; 21 bytes
cvthex	pha
	lsr
	lsr
	lsr
	lsr
	jsr	hex1
	pla
	and	#$0f
hex1	adc	#$30
	cmp	#$3a
	bcc	append
	adc	#$41-$3a
	bcc	append

; Convert Y:A to decimal

tmp	.ds	2

rslt	.ds	5

dechi	.byte	>10000
	.byte	>1000
	.byte	>100
	.byte	>10
	.byte	>1

declo	.byte	<10000
	.byte	<1000
	.byte	<100
	.byte	<10
	.byte	<1

cvtdec	sta	tmp
	sty	tmp+1
; Clear result
	lda	#$30
	ldy	#5
cvtdl	sta	[rslt-1],y
	dey
	bne	cvtdl

	ldy	#5
	ldx	#0

; Restoring division
cvtdl1	lda	tmp
	sec
	sbc	declo,x
	sta	tmp
	lda	tmp+1
	sbc	dechi,x
	bcc	borrow
	sta	tmp+1
	inc	rslt,x
	bne	cvtdl1
borrow	lda	tmp
	clc
	adc	declo,x
	sta	tmp
	inx
	dey
	bne	cvtdl1

; Now append result
; Skip leading digits
	ldx	#0
skip	lda	rslt,x
	cmp	#$30
	bne	rest
	inx
	cpx	#4
	bne	skip

; Copy rest of digits
crslt	lda	rslt,x
	
rest	jsr	append
	inx
	cpx	#5
	bne	crslt

	rts

; Append EOL
appeol	lda	#eol

; Append A to (addr)
append	ldy	#0
	sta	(addr),y
	inc	addr
	beq	inchgh
	rts
inchgh	inc	addr+1
cvtdon	rts

; Copy z-string at src to addr.
; Update addr to point to terminating NUL.

zcpy	ldy	#0
	lda	(src),y
	beq	zcpydn
zcpylp	sta	(addr),y
	iny
	lda	(src),y
	bne	zcpylp
	sta	(addr),y
zcpyic	tya
	clc
	adc	addr
	sta	addr
	beq	zcpybm
	rts
zcpybm	inc	addr+1
zcpydn	rts

msg	.byte	"MEMLO has ",0

; Buffer


	.bank
; Set run address.  This must be at the end (use 2nd bank to force it)
	*=	$2e0
	.word	main

	.end
