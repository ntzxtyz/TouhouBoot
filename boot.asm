	org 0x7c00
	jmp _start

BootStart	equ	0x1
BootEnd		equ	0xff
BootAddr	equ	0x8000

_start:
	mov	ax,	cs
	mov	ds,	ax
	mov	es,	ax
	mov	gs,	ax
	mov	fs,	ax
	mov	sp,	0x500

	mov	ax, 	0x0600
	mov	bx,	0x0700
	mov	cx,	0
	mov	dx,	0x184f
	int	0x10

	mov	dx,	0x1f2
	mov	al,	BootEnd
	sub	al,	BootStart
	out	dx,	al

	mov	dx,	0x1f3
	mov	eax,	BootStart
	out	dx,	al
	
	mov	dx,	0x1f4
	mov	cl,	8
	shr	eax,	cl
	out	dx,	al

	mov	dx,	0x1f5
	shr	eax,	cl
	out	dx,	al

	mov	dx,	0x1f6
	shr	eax,	cl
	and	al,	0x0f
	or	al,	0xe0
	out	dx,	al

	mov	dx,	0x1f7
	mov	al,	0x20
	out	dx,	al

.ready:
	nop
	in	al,	dx
	and	al,	0x88
	cmp	al,	0x08
	jnz	.ready

	mov	ax,	BootEnd
	sub	ax,	BootStart
	mov	dx,	256
	mul	dx
	mov	cx,	ax
	mov	bx,	0xb800
	mov	ds,	bx
	mov	bx,	0
	mov	dx,	0x1f0

.get_data:
	in	ax,	dx
	mov	[ds:bx],	ax
	add	bx,	2
	loop	.get_data

	;show boot message
	mov	ax,	0x1301
	mov	bx,	0x000f
	mov	dx,	0x0100
	mov	cx,	11
	mov	bp,	TouhouBootMsg
	int	0x10

	;get memory address and type
	
	;get SVGA infomation

	;enter 32bit mode
	in	al,	0x92
	or	al,	0b00000010
	out	0x92,	al
	
	cli
	db	0x66
	lgdt	[GdtPtr]

	mov	eax,	cr0
	or	eax,	1
	mov	cr0,	eax

	jmp	dword	SelectorCode32: BootAddr

GDT:			dd	0, 0
DESC_CODE32:		dd	0x0000ffff, 0x00cf9a00
DESC_DATA32:		dd	0x0000ffff, 0x00cf9200

GdtPtr:			dw	$ - GDT - 1
			dd	GDT

SelectorCode32		equ	DESC_CODE32 - GDT
SelectorData32		equ	DESC_DATA32 - GDT

TouhouBootMsg:		db	"Touhou boot"

times (446 - ($ - $$))	db	0x00

BootActiveFlag:		db	0x80
BootCHS:		db	0, 0, 0, 0x81, 0, 0, 0
BootStartSec:		dd	BootStart
BootEndSec:		dd	BootEnd
SystemActiveFlag:	db	0x80
SystemCHS:		db	0, 0, 0, 0x81, 0, 0, 0
SystemStartSec:		dd	0x400
SystemEndSec:		dd	0x1000000
Empty:	times 32	db	0

			dw	0xaa55
