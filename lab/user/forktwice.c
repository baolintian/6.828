#include <inc/lib.h>

int a = 2;

void
umain(int argc, char **argv)
{
    int envid = 0;
    if((envid = fork()) == 0){
        cprintf("in child\n");
        a = 233;
        cprintf("write page in child, a address: %x\n", &a);
        return ;
    }
    cprintf("in parent, child envid %d, a address: %x\n", envid, &a);
    a = 322;
    cprintf("write page in parent\n");
	
}

