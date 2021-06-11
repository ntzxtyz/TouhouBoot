all: boot loader

boot: boot.asm
	nasm boot.asm -o boot.bin

load.o: load.c
	gcc -m32 -c -o load.o load.c

head.o: head.S
	nasm -f elf -o head.o head.S
