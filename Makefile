all: boot loader

boot: boot.asm
	nasm boot.asm -o boot.bin

loader: load.o head.o
	ld -e load -m elf_i386 -Ttext-seg=0x8000 -o loader head.o load.o

load.o: load.c
	gcc -m32 -fno-builtin -nostdlib -ffreestanding -c -o load.o load.c

head.o: head.S
	nasm -f elf -o head.o head.S

clean:
	rm *.o 
