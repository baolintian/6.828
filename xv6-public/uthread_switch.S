	.text

/* Switch from current_thread to next_thread. Make next_thread
 * the current_thread, and set next_thread to 0.
 * Use eax as a temporary register; it is caller saved.
 */
	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
    //C语言函数调用会压入下一条语句的 eip.
    //%esp保存着下一个thread地址 
    pushal
    movl current_thread, %eax
    //保存此刻的sp
    movl %esp, (%eax)


    movl next_thread, %eax
    movl %eax, current_thread
    //还原sp
    movl (%eax), %esp
    popal
	movl $0x0, next_thread
	ret				/* pop return address from stack */
