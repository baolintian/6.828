#include "ns.h"

extern union Nsipc nsipcbuf;
static struct jif_pkt *pkt = (struct jif_pkt *)REQVA;

void
sleep(int msec)
{
	unsigned now = sys_time_msec();
	unsigned end = now + msec;

	if ((int)now < 0 && (int)now > -MAXERROR)
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
		panic("sleep: wrap");

	while (sys_time_msec() < end)
		sys_yield();
}




void input(envid_t ns_envid)
{   
    binaryname = "ns_input";

    int i, r;
    int32_t length;
    struct jif_pkt *cpkt = pkt;

    for(i = 0; i < 10; i++)
        if ((r = sys_page_alloc(0, (void*)((uintptr_t)pkt + i * PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
            panic("sys_page_alloc: %e", r);

    i = 0; 
    while(1) {
        while((length = sys_netpacket_recv((void*)((uintptr_t)cpkt + sizeof(cpkt->jp_len)), PGSIZE - sizeof(cpkt->jp_len))) < 0) {
			//cprintf("in len: %d\n", length);
            sys_yield();
        }
        //cprintf("out len: %d\n", length);

        cpkt->jp_len = length;
        ipc_send(ns_envid, NSREQ_INPUT, cpkt, PTE_P | PTE_U | PTE_W);
        i = (i + 1) % 10;
        cpkt = (struct jif_pkt*)((uintptr_t)pkt + i * PGSIZE);
        sys_yield();
    }
    
}