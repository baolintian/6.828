// program to cause a general protection exception

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	// Try to load the kernel's TSS selector into the DS register.
	//An attempt to load a TSS descriptor into any of the segment registers (CS, SS, DS, ES, FS, GS) causes an exception.
	// https://pdos.csail.mit.edu/6.828/2018/readings/i386/s07_02.htm
	
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
}

