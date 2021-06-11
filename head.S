	org	0x7e00
	jmp	_start
	extern	load
	global	_start

[SECTION .s16]
[BITS 16]

_start:
	mov	ax,	cs
	mov	ds,	ax
	mov	es,	ax
	mov	ss,	ax
	mov	sp,	0x00

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
	push	ax
	in	al,	0x92
	or	al,	0b00000010
	out	0x92,	al
	
	cli
	db	0x66
	lidt	[IDT_POINTER]
	db	0x66
	lgdt	[GdtPtr]

	mov	eax,	cr0
	or	eax,	1
	mov	cr0,	eax

	jmp	dword	SelectorCode32: TMP_Protect

[SECTION .s32]
[BITS 32]
TMP_Protect:
	mov	ax,	SelectorData32
	mov	ds,	ax
	mov	es,	ax
	mov	fs,	ax
	mov	esp,	0x7c00

	call	load
	
	mov	dword	[0x90000],	0x91007
	mov	dword	[0x90004],	0x00000
	mov	dword	[0x90800],	0x91007
	mov	dword	[0x90804],	0x00000
	mov	dword	[0x91000],	0x92007
	mov	dword	[0x91004],	0x00000
	mov	dword	[0x92000],	0x000083
	mov	dword	[0x92004],	0x000000
	mov	dword	[0x92008],	0x200083
	mov	dword	[0x9200c],	0x000000
	mov	dword	[0x92010],	0x400083
	mov	dword	[0x92014],	0x000000
	mov	dword	[0x92018],	0x600083
	mov	dword	[0x9201c],	0x000000
	mov	dword	[0x92020],	0x800083
	mov	dword	[0x92024],	0x000000
	mov	dword	[0x92028],	0xa00083
	mov	dword	[0x9202c],	0x000000

	db	0x66
	lgdt	[GdtPtr64]

	mov	ax,	SelectorData64
	mov	ds,	ax
	mov	es,	ax
	mov	fs,	ax
	mov	gs,	ax

	mov	esp,	0x7c00

	mov	eax,	cr4
	bts	eax,	5
	mov	cr4,	eax

	mov	eax,	0x90000
	mov	cr3,	eax

	mov	ecx,	0xc0000080
	rdmsr
	bts	eax,	8
	wrmsr

	mov	eax,	cr0
	bts	eax,	0
	bts	eax,	31
	mov	cr0,	eax
	jmp	SelectorCode64: KernelAddr

[SECTION GDT]
GDT:		dd	0, 0
DESC_CODE32:	dd	0x0000ffff, 0x00cf9a00
DESC_DATA32:	dd	0x0000ffff, 0x00cf9200

GdtPtr:		dw	$ - GDT - 1
		dd	GDT

SelectorCode32	equ	DESC_CODE32 - GDT
SelectorData32	equ	DESC_DATA32 - GDT

[SECTION GDT64]
GDT64:		dq	0
DESC_CODE64:	dq	0x0020980000000000
DESC_DATA64:	dq	0x0000920000000000

GdtPtr64:	dw	$ - GDT64 - 1
		dd	GDT64

SelectorCode64	equ	DESC_CODE64 - GDT64
SelectorData64	equ	DESC_DATA64 - GDT64

KernelAddr	equ	0x100000

IDT: times 0x50	dq	0
IDT_END:

IDT_POINTER:	dw	IDT_END - IDT - 1
		dd	IDT
TouhouBootMsg:	db	"Touhou boot"
