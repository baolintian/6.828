
_uthread:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
}


int 
main(int argc, char *argv[]) 
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
thread_create(void (*func)())
{
  thread_p t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
    if (t->state == FREE) break;
  11:	a1 2c 4d 00 00       	mov    0x4d2c,%eax
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
  16:	c7 05 4c 8d 00 00 20 	movl   $0xd20,0x8d4c
  1d:	0d 00 00 
  current_thread->state = RUNNING;
  20:	c7 05 24 2d 00 00 01 	movl   $0x1,0x2d24
  27:	00 00 00 
thread_create(void (*func)())
{
  thread_p t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
    if (t->state == FREE) break;
  2a:	85 c0                	test   %eax,%eax
  2c:	0f 84 8b 00 00 00    	je     bd <main+0xbd>
  32:	a1 34 6d 00 00       	mov    0x6d34,%eax
  37:	85 c0                	test   %eax,%eax
  39:	0f 84 85 00 00 00    	je     c4 <main+0xc4>
void 
thread_create(void (*func)())
{
  thread_p t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  3f:	8b 0d 3c 8d 00 00    	mov    0x8d3c,%ecx
  45:	ba 38 6d 00 00       	mov    $0x6d38,%edx
  4a:	b8 40 8d 00 00       	mov    $0x8d40,%eax
  4f:	85 c9                	test   %ecx,%ecx
  51:	0f 44 c2             	cmove  %edx,%eax
    if (t->state == FREE) break;
  }
  t->sp = (int) (t->stack + STACK_SIZE);   // set sp to the top of the stack
  t->sp -= 4;                              // space for return address
  54:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
  * (int *) (t->sp) = (int)func;           // push return address on stack
  5a:	c7 80 00 20 00 00 70 	movl   $0x170,0x2000(%eax)
  61:	01 00 00 
  t->sp -= 32;                             // space for registers that thread_switch expects，正好容纳pushal所有的值
  t->state = RUNNABLE;
  64:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
  6b:	00 00 00 

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
    if (t->state == FREE) break;
  }
  t->sp = (int) (t->stack + STACK_SIZE);   // set sp to the top of the stack
  t->sp -= 4;                              // space for return address
  6e:	89 10                	mov    %edx,(%eax)
  * (int *) (t->sp) = (int)func;           // push return address on stack
  t->sp -= 32;                             // space for registers that thread_switch expects，正好容纳pushal所有的值
  70:	83 28 20             	subl   $0x20,(%eax)
void 
thread_create(void (*func)())
{
  thread_p t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  73:	b8 20 0d 00 00       	mov    $0xd20,%eax
    if (t->state == FREE) break;
  78:	8b 90 04 20 00 00    	mov    0x2004(%eax),%edx
  7e:	85 d2                	test   %edx,%edx
  80:	74 0c                	je     8e <main+0x8e>
void 
thread_create(void (*func)())
{
  thread_p t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  82:	05 08 20 00 00       	add    $0x2008,%eax
  87:	3d 40 8d 00 00       	cmp    $0x8d40,%eax
  8c:	75 ea                	jne    78 <main+0x78>
    if (t->state == FREE) break;
  }
  t->sp = (int) (t->stack + STACK_SIZE);   // set sp to the top of the stack
  t->sp -= 4;                              // space for return address
  8e:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
  * (int *) (t->sp) = (int)func;           // push return address on stack
  94:	c7 80 00 20 00 00 70 	movl   $0x170,0x2000(%eax)
  9b:	01 00 00 
  t->sp -= 32;                             // space for registers that thread_switch expects，正好容纳pushal所有的值
  t->state = RUNNABLE;
  9e:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
  a5:	00 00 00 

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
    if (t->state == FREE) break;
  }
  t->sp = (int) (t->stack + STACK_SIZE);   // set sp to the top of the stack
  t->sp -= 4;                              // space for return address
  a8:	89 10                	mov    %edx,(%eax)
  * (int *) (t->sp) = (int)func;           // push return address on stack
  t->sp -= 32;                             // space for registers that thread_switch expects，正好容纳pushal所有的值
  aa:	83 28 20             	subl   $0x20,(%eax)
main(int argc, char *argv[]) 
{
  thread_init();
  thread_create(mythread);
  thread_create(mythread);
  thread_schedule();
  ad:	e8 1e 00 00 00       	call   d0 <thread_schedule>
  return 0;
}
  b2:	83 c4 04             	add    $0x4,%esp
  b5:	31 c0                	xor    %eax,%eax
  b7:	59                   	pop    %ecx
  b8:	5d                   	pop    %ebp
  b9:	8d 61 fc             	lea    -0x4(%ecx),%esp
  bc:	c3                   	ret    
void 
thread_create(void (*func)())
{
  thread_p t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  bd:	b8 28 2d 00 00       	mov    $0x2d28,%eax
  c2:	eb 90                	jmp    54 <main+0x54>
  c4:	b8 30 4d 00 00       	mov    $0x4d30,%eax
  c9:	eb 89                	jmp    54 <main+0x54>
  cb:	66 90                	xchg   %ax,%ax
  cd:	66 90                	xchg   %ax,%ax
  cf:	90                   	nop

000000d0 <thread_schedule>:
  current_thread->state = RUNNING;
}

static void 
thread_schedule(void)
{
  d0:	55                   	push   %ebp
  thread_p t;

  /* Find another runnable thread. */
  next_thread = 0;
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  d1:	b8 20 0d 00 00       	mov    $0xd20,%eax
  current_thread->state = RUNNING;
}

static void 
thread_schedule(void)
{
  d6:	89 e5                	mov    %esp,%ebp
  d8:	83 ec 08             	sub    $0x8,%esp
  db:	8b 15 4c 8d 00 00    	mov    0x8d4c,%edx
  thread_p t;

  /* Find another runnable thread. */
  next_thread = 0;
  e1:	c7 05 50 8d 00 00 00 	movl   $0x0,0x8d50
  e8:	00 00 00 
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
    if (t->state == RUNNABLE && t != current_thread) {
  eb:	83 b8 04 20 00 00 02 	cmpl   $0x2,0x2004(%eax)
  f2:	74 3c                	je     130 <thread_schedule+0x60>
{
  thread_p t;

  /* Find another runnable thread. */
  next_thread = 0;
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  f4:	05 08 20 00 00       	add    $0x2008,%eax
  f9:	3d 40 8d 00 00       	cmp    $0x8d40,%eax
  fe:	75 eb                	jne    eb <thread_schedule+0x1b>
      next_thread = t;
      break;
    }
  }

  if (t >= all_thread + MAX_THREAD && current_thread->state == RUNNABLE) {
 100:	83 ba 04 20 00 00 02 	cmpl   $0x2,0x2004(%edx)
 107:	74 57                	je     160 <thread_schedule+0x90>
 109:	a1 50 8d 00 00       	mov    0x8d50,%eax
    /* The current thread is the only runnable thread; run it. */
    next_thread = current_thread;
  }

  if (next_thread == 0) {
 10e:	85 c0                	test   %eax,%eax
 110:	74 32                	je     144 <thread_schedule+0x74>
    printf(2, "thread_schedule: no runnable threads\n");
    exit();
  }

  if (current_thread != next_thread) {         /* switch threads?  */
 112:	39 05 4c 8d 00 00    	cmp    %eax,0x8d4c
 118:	74 46                	je     160 <thread_schedule+0x90>
    next_thread->state = RUNNING;
 11a:	c7 80 04 20 00 00 01 	movl   $0x1,0x2004(%eax)
 121:	00 00 00 
    thread_switch();
  } else
    next_thread = 0;
}
 124:	c9                   	leave  
    exit();
  }

  if (current_thread != next_thread) {         /* switch threads?  */
    next_thread->state = RUNNING;
    thread_switch();
 125:	e9 3e 01 00 00       	jmp    268 <thread_switch>
 12a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  thread_p t;

  /* Find another runnable thread. */
  next_thread = 0;
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
    if (t->state == RUNNABLE && t != current_thread) {
 130:	39 c2                	cmp    %eax,%edx
 132:	74 c0                	je     f4 <thread_schedule+0x24>
      next_thread = t;
      break;
    }
  }

  if (t >= all_thread + MAX_THREAD && current_thread->state == RUNNABLE) {
 134:	3d 40 8d 00 00       	cmp    $0x8d40,%eax

  /* Find another runnable thread. */
  next_thread = 0;
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
    if (t->state == RUNNABLE && t != current_thread) {
      next_thread = t;
 139:	a3 50 8d 00 00       	mov    %eax,0x8d50
      break;
    }
  }

  if (t >= all_thread + MAX_THREAD && current_thread->state == RUNNABLE) {
 13e:	73 c0                	jae    100 <thread_schedule+0x30>
    /* The current thread is the only runnable thread; run it. */
    next_thread = current_thread;
  }

  if (next_thread == 0) {
 140:	85 c0                	test   %eax,%eax
 142:	75 d6                	jne    11a <thread_schedule+0x4a>
    printf(2, "thread_schedule: no runnable threads\n");
 144:	50                   	push   %eax
 145:	50                   	push   %eax
 146:	68 50 09 00 00       	push   $0x950
 14b:	6a 02                	push   $0x2
 14d:	e8 de 04 00 00       	call   630 <printf>
    exit();
 152:	e8 7b 03 00 00       	call   4d2 <exit>
 157:	89 f6                	mov    %esi,%esi
 159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  if (current_thread != next_thread) {         /* switch threads?  */
    next_thread->state = RUNNING;
    thread_switch();
  } else
    next_thread = 0;
 160:	c7 05 50 8d 00 00 00 	movl   $0x0,0x8d50
 167:	00 00 00 
}
 16a:	c9                   	leave  
 16b:	c3                   	ret    
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000170 <mythread>:
  thread_schedule();
}

static void 
mythread(void)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	53                   	push   %ebx
  int i;
  printf(1, "my thread running\n");
 174:	bb 64 00 00 00       	mov    $0x64,%ebx
  thread_schedule();
}

static void 
mythread(void)
{
 179:	83 ec 0c             	sub    $0xc,%esp
  int i;
  printf(1, "my thread running\n");
 17c:	68 78 09 00 00       	push   $0x978
 181:	6a 01                	push   $0x1
 183:	e8 a8 04 00 00       	call   630 <printf>
 188:	83 c4 10             	add    $0x10,%esp
 18b:	90                   	nop
 18c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i < 100; i++) {
    printf(1, "my thread 0x%x\n", (int) current_thread);
 190:	83 ec 04             	sub    $0x4,%esp
 193:	ff 35 4c 8d 00 00    	pushl  0x8d4c
 199:	68 8b 09 00 00       	push   $0x98b
 19e:	6a 01                	push   $0x1
 1a0:	e8 8b 04 00 00       	call   630 <printf>
}

void 
thread_yield(void)
{
  current_thread->state = RUNNABLE;
 1a5:	a1 4c 8d 00 00       	mov    0x8d4c,%eax
 1aa:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
 1b1:	00 00 00 
  thread_schedule();
 1b4:	e8 17 ff ff ff       	call   d0 <thread_schedule>
static void 
mythread(void)
{
  int i;
  printf(1, "my thread running\n");
  for (i = 0; i < 100; i++) {
 1b9:	83 c4 10             	add    $0x10,%esp
 1bc:	83 eb 01             	sub    $0x1,%ebx
 1bf:	75 cf                	jne    190 <mythread+0x20>
    printf(1, "my thread 0x%x\n", (int) current_thread);
    thread_yield();
  }
  printf(1, "my thread: exit\n");
 1c1:	83 ec 08             	sub    $0x8,%esp
 1c4:	68 9b 09 00 00       	push   $0x99b
 1c9:	6a 01                	push   $0x1
 1cb:	e8 60 04 00 00       	call   630 <printf>
  current_thread->state = FREE;
 1d0:	a1 4c 8d 00 00       	mov    0x8d4c,%eax
  thread_schedule();
 1d5:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 100; i++) {
    printf(1, "my thread 0x%x\n", (int) current_thread);
    thread_yield();
  }
  printf(1, "my thread: exit\n");
  current_thread->state = FREE;
 1d8:	c7 80 04 20 00 00 00 	movl   $0x0,0x2004(%eax)
 1df:	00 00 00 
  thread_schedule();
}
 1e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1e5:	c9                   	leave  
    printf(1, "my thread 0x%x\n", (int) current_thread);
    thread_yield();
  }
  printf(1, "my thread: exit\n");
  current_thread->state = FREE;
  thread_schedule();
 1e6:	e9 e5 fe ff ff       	jmp    d0 <thread_schedule>
 1eb:	90                   	nop
 1ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001f0 <thread_init>:
thread_p  next_thread;
extern void thread_switch(void);

void 
thread_init(void)
{
 1f0:	55                   	push   %ebp
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
 1f1:	c7 05 4c 8d 00 00 20 	movl   $0xd20,0x8d4c
 1f8:	0d 00 00 
  current_thread->state = RUNNING;
 1fb:	c7 05 24 2d 00 00 01 	movl   $0x1,0x2d24
 202:	00 00 00 
thread_p  next_thread;
extern void thread_switch(void);

void 
thread_init(void)
{
 205:	89 e5                	mov    %esp,%ebp
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
  current_thread->state = RUNNING;
}
 207:	5d                   	pop    %ebp
 208:	c3                   	ret    
 209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000210 <thread_create>:
    next_thread = 0;
}

void 
thread_create(void (*func)())
{
 210:	55                   	push   %ebp
  thread_p t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 211:	b8 20 0d 00 00       	mov    $0xd20,%eax
    next_thread = 0;
}

void 
thread_create(void (*func)())
{
 216:	89 e5                	mov    %esp,%ebp
  thread_p t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
    if (t->state == FREE) break;
 218:	8b 90 04 20 00 00    	mov    0x2004(%eax),%edx
 21e:	85 d2                	test   %edx,%edx
 220:	74 0c                	je     22e <thread_create+0x1e>
void 
thread_create(void (*func)())
{
  thread_p t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 222:	05 08 20 00 00       	add    $0x2008,%eax
 227:	3d 40 8d 00 00       	cmp    $0x8d40,%eax
 22c:	75 ea                	jne    218 <thread_create+0x8>
    if (t->state == FREE) break;
  }
  t->sp = (int) (t->stack + STACK_SIZE);   // set sp to the top of the stack
  t->sp -= 4;                              // space for return address
 22e:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
  * (int *) (t->sp) = (int)func;           // push return address on stack
  t->sp -= 32;                             // space for registers that thread_switch expects，正好容纳pushal所有的值
  t->state = RUNNABLE;
 234:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
 23b:	00 00 00 

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
    if (t->state == FREE) break;
  }
  t->sp = (int) (t->stack + STACK_SIZE);   // set sp to the top of the stack
  t->sp -= 4;                              // space for return address
 23e:	89 10                	mov    %edx,(%eax)
  * (int *) (t->sp) = (int)func;           // push return address on stack
 240:	8b 55 08             	mov    0x8(%ebp),%edx
  t->sp -= 32;                             // space for registers that thread_switch expects，正好容纳pushal所有的值
 243:	83 28 20             	subl   $0x20,(%eax)
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
    if (t->state == FREE) break;
  }
  t->sp = (int) (t->stack + STACK_SIZE);   // set sp to the top of the stack
  t->sp -= 4;                              // space for return address
  * (int *) (t->sp) = (int)func;           // push return address on stack
 246:	89 90 00 20 00 00    	mov    %edx,0x2000(%eax)
  t->sp -= 32;                             // space for registers that thread_switch expects，正好容纳pushal所有的值
  t->state = RUNNABLE;
}
 24c:	5d                   	pop    %ebp
 24d:	c3                   	ret    
 24e:	66 90                	xchg   %ax,%ax

00000250 <thread_yield>:

void 
thread_yield(void)
{
  current_thread->state = RUNNABLE;
 250:	a1 4c 8d 00 00       	mov    0x8d4c,%eax
  t->state = RUNNABLE;
}

void 
thread_yield(void)
{
 255:	55                   	push   %ebp
 256:	89 e5                	mov    %esp,%ebp
  current_thread->state = RUNNABLE;
 258:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
 25f:	00 00 00 
  thread_schedule();
}
 262:	5d                   	pop    %ebp

void 
thread_yield(void)
{
  current_thread->state = RUNNABLE;
  thread_schedule();
 263:	e9 68 fe ff ff       	jmp    d0 <thread_schedule>

00000268 <thread_switch>:
	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
    //C语言函数调用会压入下一条语句的 eip.
    //%esp保存着下一个thread地址 
    pushal
 268:	60                   	pusha  
    movl current_thread, %eax
 269:	a1 4c 8d 00 00       	mov    0x8d4c,%eax
    //保存此刻的sp
    movl %esp, (%eax)
 26e:	89 20                	mov    %esp,(%eax)


    movl next_thread, %eax
 270:	a1 50 8d 00 00       	mov    0x8d50,%eax
    movl %eax, current_thread
 275:	a3 4c 8d 00 00       	mov    %eax,0x8d4c
    //还原sp
    movl (%eax), %esp
 27a:	8b 20                	mov    (%eax),%esp
    popal
 27c:	61                   	popa   
	movl $0x0, next_thread
 27d:	c7 05 50 8d 00 00 00 	movl   $0x0,0x8d50
 284:	00 00 00 
	ret				/* pop return address from stack */
 287:	c3                   	ret    
 288:	66 90                	xchg   %ax,%ax
 28a:	66 90                	xchg   %ax,%ax
 28c:	66 90                	xchg   %ax,%ax
 28e:	66 90                	xchg   %ax,%ax

00000290 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	53                   	push   %ebx
 294:	8b 45 08             	mov    0x8(%ebp),%eax
 297:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 29a:	89 c2                	mov    %eax,%edx
 29c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2a0:	83 c1 01             	add    $0x1,%ecx
 2a3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 2a7:	83 c2 01             	add    $0x1,%edx
 2aa:	84 db                	test   %bl,%bl
 2ac:	88 5a ff             	mov    %bl,-0x1(%edx)
 2af:	75 ef                	jne    2a0 <strcpy+0x10>
    ;
  return os;
}
 2b1:	5b                   	pop    %ebx
 2b2:	5d                   	pop    %ebp
 2b3:	c3                   	ret    
 2b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000002c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	56                   	push   %esi
 2c4:	53                   	push   %ebx
 2c5:	8b 55 08             	mov    0x8(%ebp),%edx
 2c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 2cb:	0f b6 02             	movzbl (%edx),%eax
 2ce:	0f b6 19             	movzbl (%ecx),%ebx
 2d1:	84 c0                	test   %al,%al
 2d3:	75 1e                	jne    2f3 <strcmp+0x33>
 2d5:	eb 29                	jmp    300 <strcmp+0x40>
 2d7:	89 f6                	mov    %esi,%esi
 2d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 2e0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2e3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 2e6:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2e9:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 2ed:	84 c0                	test   %al,%al
 2ef:	74 0f                	je     300 <strcmp+0x40>
 2f1:	89 f1                	mov    %esi,%ecx
 2f3:	38 d8                	cmp    %bl,%al
 2f5:	74 e9                	je     2e0 <strcmp+0x20>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2f7:	29 d8                	sub    %ebx,%eax
}
 2f9:	5b                   	pop    %ebx
 2fa:	5e                   	pop    %esi
 2fb:	5d                   	pop    %ebp
 2fc:	c3                   	ret    
 2fd:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 300:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 302:	29 d8                	sub    %ebx,%eax
}
 304:	5b                   	pop    %ebx
 305:	5e                   	pop    %esi
 306:	5d                   	pop    %ebp
 307:	c3                   	ret    
 308:	90                   	nop
 309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000310 <strlen>:

uint
strlen(const char *s)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 316:	80 39 00             	cmpb   $0x0,(%ecx)
 319:	74 12                	je     32d <strlen+0x1d>
 31b:	31 d2                	xor    %edx,%edx
 31d:	8d 76 00             	lea    0x0(%esi),%esi
 320:	83 c2 01             	add    $0x1,%edx
 323:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 327:	89 d0                	mov    %edx,%eax
 329:	75 f5                	jne    320 <strlen+0x10>
    ;
  return n;
}
 32b:	5d                   	pop    %ebp
 32c:	c3                   	ret    
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 32d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 32f:	5d                   	pop    %ebp
 330:	c3                   	ret    
 331:	eb 0d                	jmp    340 <memset>
 333:	90                   	nop
 334:	90                   	nop
 335:	90                   	nop
 336:	90                   	nop
 337:	90                   	nop
 338:	90                   	nop
 339:	90                   	nop
 33a:	90                   	nop
 33b:	90                   	nop
 33c:	90                   	nop
 33d:	90                   	nop
 33e:	90                   	nop
 33f:	90                   	nop

00000340 <memset>:

void*
memset(void *dst, int c, uint n)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	57                   	push   %edi
 344:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 347:	8b 4d 10             	mov    0x10(%ebp),%ecx
 34a:	8b 45 0c             	mov    0xc(%ebp),%eax
 34d:	89 d7                	mov    %edx,%edi
 34f:	fc                   	cld    
 350:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 352:	89 d0                	mov    %edx,%eax
 354:	5f                   	pop    %edi
 355:	5d                   	pop    %ebp
 356:	c3                   	ret    
 357:	89 f6                	mov    %esi,%esi
 359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000360 <strchr>:

char*
strchr(const char *s, char c)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	53                   	push   %ebx
 364:	8b 45 08             	mov    0x8(%ebp),%eax
 367:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 36a:	0f b6 10             	movzbl (%eax),%edx
 36d:	84 d2                	test   %dl,%dl
 36f:	74 1d                	je     38e <strchr+0x2e>
    if(*s == c)
 371:	38 d3                	cmp    %dl,%bl
 373:	89 d9                	mov    %ebx,%ecx
 375:	75 0d                	jne    384 <strchr+0x24>
 377:	eb 17                	jmp    390 <strchr+0x30>
 379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 380:	38 ca                	cmp    %cl,%dl
 382:	74 0c                	je     390 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 384:	83 c0 01             	add    $0x1,%eax
 387:	0f b6 10             	movzbl (%eax),%edx
 38a:	84 d2                	test   %dl,%dl
 38c:	75 f2                	jne    380 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 38e:	31 c0                	xor    %eax,%eax
}
 390:	5b                   	pop    %ebx
 391:	5d                   	pop    %ebp
 392:	c3                   	ret    
 393:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003a0 <gets>:

char*
gets(char *buf, int max)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
 3a4:	56                   	push   %esi
 3a5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3a6:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 3a8:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 3ab:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3ae:	eb 29                	jmp    3d9 <gets+0x39>
    cc = read(0, &c, 1);
 3b0:	83 ec 04             	sub    $0x4,%esp
 3b3:	6a 01                	push   $0x1
 3b5:	57                   	push   %edi
 3b6:	6a 00                	push   $0x0
 3b8:	e8 2d 01 00 00       	call   4ea <read>
    if(cc < 1)
 3bd:	83 c4 10             	add    $0x10,%esp
 3c0:	85 c0                	test   %eax,%eax
 3c2:	7e 1d                	jle    3e1 <gets+0x41>
      break;
    buf[i++] = c;
 3c4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3c8:	8b 55 08             	mov    0x8(%ebp),%edx
 3cb:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 3cd:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 3cf:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 3d3:	74 1b                	je     3f0 <gets+0x50>
 3d5:	3c 0d                	cmp    $0xd,%al
 3d7:	74 17                	je     3f0 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3d9:	8d 5e 01             	lea    0x1(%esi),%ebx
 3dc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3df:	7c cf                	jl     3b0 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3e1:	8b 45 08             	mov    0x8(%ebp),%eax
 3e4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 3e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3eb:	5b                   	pop    %ebx
 3ec:	5e                   	pop    %esi
 3ed:	5f                   	pop    %edi
 3ee:	5d                   	pop    %ebp
 3ef:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3f0:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3f3:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3f5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 3f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3fc:	5b                   	pop    %ebx
 3fd:	5e                   	pop    %esi
 3fe:	5f                   	pop    %edi
 3ff:	5d                   	pop    %ebp
 400:	c3                   	ret    
 401:	eb 0d                	jmp    410 <stat>
 403:	90                   	nop
 404:	90                   	nop
 405:	90                   	nop
 406:	90                   	nop
 407:	90                   	nop
 408:	90                   	nop
 409:	90                   	nop
 40a:	90                   	nop
 40b:	90                   	nop
 40c:	90                   	nop
 40d:	90                   	nop
 40e:	90                   	nop
 40f:	90                   	nop

00000410 <stat>:

int
stat(const char *n, struct stat *st)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	56                   	push   %esi
 414:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 415:	83 ec 08             	sub    $0x8,%esp
 418:	6a 00                	push   $0x0
 41a:	ff 75 08             	pushl  0x8(%ebp)
 41d:	e8 f0 00 00 00       	call   512 <open>
  if(fd < 0)
 422:	83 c4 10             	add    $0x10,%esp
 425:	85 c0                	test   %eax,%eax
 427:	78 27                	js     450 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 429:	83 ec 08             	sub    $0x8,%esp
 42c:	ff 75 0c             	pushl  0xc(%ebp)
 42f:	89 c3                	mov    %eax,%ebx
 431:	50                   	push   %eax
 432:	e8 f3 00 00 00       	call   52a <fstat>
 437:	89 c6                	mov    %eax,%esi
  close(fd);
 439:	89 1c 24             	mov    %ebx,(%esp)
 43c:	e8 b9 00 00 00       	call   4fa <close>
  return r;
 441:	83 c4 10             	add    $0x10,%esp
 444:	89 f0                	mov    %esi,%eax
}
 446:	8d 65 f8             	lea    -0x8(%ebp),%esp
 449:	5b                   	pop    %ebx
 44a:	5e                   	pop    %esi
 44b:	5d                   	pop    %ebp
 44c:	c3                   	ret    
 44d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 450:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 455:	eb ef                	jmp    446 <stat+0x36>
 457:	89 f6                	mov    %esi,%esi
 459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000460 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	53                   	push   %ebx
 464:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 467:	0f be 11             	movsbl (%ecx),%edx
 46a:	8d 42 d0             	lea    -0x30(%edx),%eax
 46d:	3c 09                	cmp    $0x9,%al
 46f:	b8 00 00 00 00       	mov    $0x0,%eax
 474:	77 1f                	ja     495 <atoi+0x35>
 476:	8d 76 00             	lea    0x0(%esi),%esi
 479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 480:	8d 04 80             	lea    (%eax,%eax,4),%eax
 483:	83 c1 01             	add    $0x1,%ecx
 486:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 48a:	0f be 11             	movsbl (%ecx),%edx
 48d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 490:	80 fb 09             	cmp    $0x9,%bl
 493:	76 eb                	jbe    480 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 495:	5b                   	pop    %ebx
 496:	5d                   	pop    %ebp
 497:	c3                   	ret    
 498:	90                   	nop
 499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000004a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	56                   	push   %esi
 4a4:	53                   	push   %ebx
 4a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4a8:	8b 45 08             	mov    0x8(%ebp),%eax
 4ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4ae:	85 db                	test   %ebx,%ebx
 4b0:	7e 14                	jle    4c6 <memmove+0x26>
 4b2:	31 d2                	xor    %edx,%edx
 4b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 4b8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 4bc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 4bf:	83 c2 01             	add    $0x1,%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4c2:	39 da                	cmp    %ebx,%edx
 4c4:	75 f2                	jne    4b8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 4c6:	5b                   	pop    %ebx
 4c7:	5e                   	pop    %esi
 4c8:	5d                   	pop    %ebp
 4c9:	c3                   	ret    

000004ca <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4ca:	b8 01 00 00 00       	mov    $0x1,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <exit>:
SYSCALL(exit)
 4d2:	b8 02 00 00 00       	mov    $0x2,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <wait>:
SYSCALL(wait)
 4da:	b8 03 00 00 00       	mov    $0x3,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <pipe>:
SYSCALL(pipe)
 4e2:	b8 04 00 00 00       	mov    $0x4,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <read>:
SYSCALL(read)
 4ea:	b8 05 00 00 00       	mov    $0x5,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <write>:
SYSCALL(write)
 4f2:	b8 10 00 00 00       	mov    $0x10,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <close>:
SYSCALL(close)
 4fa:	b8 15 00 00 00       	mov    $0x15,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <kill>:
SYSCALL(kill)
 502:	b8 06 00 00 00       	mov    $0x6,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <exec>:
SYSCALL(exec)
 50a:	b8 07 00 00 00       	mov    $0x7,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <open>:
SYSCALL(open)
 512:	b8 0f 00 00 00       	mov    $0xf,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <mknod>:
SYSCALL(mknod)
 51a:	b8 11 00 00 00       	mov    $0x11,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <unlink>:
SYSCALL(unlink)
 522:	b8 12 00 00 00       	mov    $0x12,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <fstat>:
SYSCALL(fstat)
 52a:	b8 08 00 00 00       	mov    $0x8,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <link>:
SYSCALL(link)
 532:	b8 13 00 00 00       	mov    $0x13,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <mkdir>:
SYSCALL(mkdir)
 53a:	b8 14 00 00 00       	mov    $0x14,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <chdir>:
SYSCALL(chdir)
 542:	b8 09 00 00 00       	mov    $0x9,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <dup>:
SYSCALL(dup)
 54a:	b8 0a 00 00 00       	mov    $0xa,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <getpid>:
SYSCALL(getpid)
 552:	b8 0b 00 00 00       	mov    $0xb,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <sbrk>:
SYSCALL(sbrk)
 55a:	b8 0c 00 00 00       	mov    $0xc,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <sleep>:
SYSCALL(sleep)
 562:	b8 0d 00 00 00       	mov    $0xd,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <uptime>:
SYSCALL(uptime)
 56a:	b8 0e 00 00 00       	mov    $0xe,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <date>:
SYSCALL(date)
 572:	b8 16 00 00 00       	mov    $0x16,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <alarm>:
SYSCALL(alarm)
 57a:	b8 17 00 00 00       	mov    $0x17,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    
 582:	66 90                	xchg   %ax,%ax
 584:	66 90                	xchg   %ax,%ax
 586:	66 90                	xchg   %ax,%ax
 588:	66 90                	xchg   %ax,%ax
 58a:	66 90                	xchg   %ax,%ax
 58c:	66 90                	xchg   %ax,%ax
 58e:	66 90                	xchg   %ax,%ax

00000590 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	57                   	push   %edi
 594:	56                   	push   %esi
 595:	53                   	push   %ebx
 596:	89 c6                	mov    %eax,%esi
 598:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 59b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 59e:	85 db                	test   %ebx,%ebx
 5a0:	74 7e                	je     620 <printint+0x90>
 5a2:	89 d0                	mov    %edx,%eax
 5a4:	c1 e8 1f             	shr    $0x1f,%eax
 5a7:	84 c0                	test   %al,%al
 5a9:	74 75                	je     620 <printint+0x90>
    neg = 1;
    x = -xx;
 5ab:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 5ad:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 5b4:	f7 d8                	neg    %eax
 5b6:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 5b9:	31 ff                	xor    %edi,%edi
 5bb:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 5be:	89 ce                	mov    %ecx,%esi
 5c0:	eb 08                	jmp    5ca <printint+0x3a>
 5c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 5c8:	89 cf                	mov    %ecx,%edi
 5ca:	31 d2                	xor    %edx,%edx
 5cc:	8d 4f 01             	lea    0x1(%edi),%ecx
 5cf:	f7 f6                	div    %esi
 5d1:	0f b6 92 b4 09 00 00 	movzbl 0x9b4(%edx),%edx
  }while((x /= base) != 0);
 5d8:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 5da:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 5dd:	75 e9                	jne    5c8 <printint+0x38>
  if(neg)
 5df:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5e2:	8b 75 c0             	mov    -0x40(%ebp),%esi
 5e5:	85 c0                	test   %eax,%eax
 5e7:	74 08                	je     5f1 <printint+0x61>
    buf[i++] = '-';
 5e9:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 5ee:	8d 4f 02             	lea    0x2(%edi),%ecx
 5f1:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 5f5:	8d 76 00             	lea    0x0(%esi),%esi
 5f8:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5fb:	83 ec 04             	sub    $0x4,%esp
 5fe:	83 ef 01             	sub    $0x1,%edi
 601:	6a 01                	push   $0x1
 603:	53                   	push   %ebx
 604:	56                   	push   %esi
 605:	88 45 d7             	mov    %al,-0x29(%ebp)
 608:	e8 e5 fe ff ff       	call   4f2 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 60d:	83 c4 10             	add    $0x10,%esp
 610:	39 df                	cmp    %ebx,%edi
 612:	75 e4                	jne    5f8 <printint+0x68>
    putc(fd, buf[i]);
}
 614:	8d 65 f4             	lea    -0xc(%ebp),%esp
 617:	5b                   	pop    %ebx
 618:	5e                   	pop    %esi
 619:	5f                   	pop    %edi
 61a:	5d                   	pop    %ebp
 61b:	c3                   	ret    
 61c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 620:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 622:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 629:	eb 8b                	jmp    5b6 <printint+0x26>
 62b:	90                   	nop
 62c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000630 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 630:	55                   	push   %ebp
 631:	89 e5                	mov    %esp,%ebp
 633:	57                   	push   %edi
 634:	56                   	push   %esi
 635:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 636:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 639:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 63c:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 63f:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 642:	89 45 d0             	mov    %eax,-0x30(%ebp)
 645:	0f b6 1e             	movzbl (%esi),%ebx
 648:	83 c6 01             	add    $0x1,%esi
 64b:	84 db                	test   %bl,%bl
 64d:	0f 84 b0 00 00 00    	je     703 <printf+0xd3>
 653:	31 d2                	xor    %edx,%edx
 655:	eb 39                	jmp    690 <printf+0x60>
 657:	89 f6                	mov    %esi,%esi
 659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 660:	83 f8 25             	cmp    $0x25,%eax
 663:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 666:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 66b:	74 18                	je     685 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 66d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 670:	83 ec 04             	sub    $0x4,%esp
 673:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 676:	6a 01                	push   $0x1
 678:	50                   	push   %eax
 679:	57                   	push   %edi
 67a:	e8 73 fe ff ff       	call   4f2 <write>
 67f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 682:	83 c4 10             	add    $0x10,%esp
 685:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 688:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 68c:	84 db                	test   %bl,%bl
 68e:	74 73                	je     703 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 690:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 692:	0f be cb             	movsbl %bl,%ecx
 695:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 698:	74 c6                	je     660 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 69a:	83 fa 25             	cmp    $0x25,%edx
 69d:	75 e6                	jne    685 <printf+0x55>
      if(c == 'd'){
 69f:	83 f8 64             	cmp    $0x64,%eax
 6a2:	0f 84 f8 00 00 00    	je     7a0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 6a8:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 6ae:	83 f9 70             	cmp    $0x70,%ecx
 6b1:	74 5d                	je     710 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 6b3:	83 f8 73             	cmp    $0x73,%eax
 6b6:	0f 84 84 00 00 00    	je     740 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6bc:	83 f8 63             	cmp    $0x63,%eax
 6bf:	0f 84 ea 00 00 00    	je     7af <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 6c5:	83 f8 25             	cmp    $0x25,%eax
 6c8:	0f 84 c2 00 00 00    	je     790 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6ce:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6d1:	83 ec 04             	sub    $0x4,%esp
 6d4:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6d8:	6a 01                	push   $0x1
 6da:	50                   	push   %eax
 6db:	57                   	push   %edi
 6dc:	e8 11 fe ff ff       	call   4f2 <write>
 6e1:	83 c4 0c             	add    $0xc,%esp
 6e4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 6e7:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 6ea:	6a 01                	push   $0x1
 6ec:	50                   	push   %eax
 6ed:	57                   	push   %edi
 6ee:	83 c6 01             	add    $0x1,%esi
 6f1:	e8 fc fd ff ff       	call   4f2 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6f6:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6fa:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6fd:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6ff:	84 db                	test   %bl,%bl
 701:	75 8d                	jne    690 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 703:	8d 65 f4             	lea    -0xc(%ebp),%esp
 706:	5b                   	pop    %ebx
 707:	5e                   	pop    %esi
 708:	5f                   	pop    %edi
 709:	5d                   	pop    %ebp
 70a:	c3                   	ret    
 70b:	90                   	nop
 70c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 710:	83 ec 0c             	sub    $0xc,%esp
 713:	b9 10 00 00 00       	mov    $0x10,%ecx
 718:	6a 00                	push   $0x0
 71a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 71d:	89 f8                	mov    %edi,%eax
 71f:	8b 13                	mov    (%ebx),%edx
 721:	e8 6a fe ff ff       	call   590 <printint>
        ap++;
 726:	89 d8                	mov    %ebx,%eax
 728:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 72b:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 72d:	83 c0 04             	add    $0x4,%eax
 730:	89 45 d0             	mov    %eax,-0x30(%ebp)
 733:	e9 4d ff ff ff       	jmp    685 <printf+0x55>
 738:	90                   	nop
 739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 740:	8b 45 d0             	mov    -0x30(%ebp),%eax
 743:	8b 18                	mov    (%eax),%ebx
        ap++;
 745:	83 c0 04             	add    $0x4,%eax
 748:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 74b:	b8 ac 09 00 00       	mov    $0x9ac,%eax
 750:	85 db                	test   %ebx,%ebx
 752:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 755:	0f b6 03             	movzbl (%ebx),%eax
 758:	84 c0                	test   %al,%al
 75a:	74 23                	je     77f <printf+0x14f>
 75c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 760:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 763:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 766:	83 ec 04             	sub    $0x4,%esp
 769:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 76b:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 76e:	50                   	push   %eax
 76f:	57                   	push   %edi
 770:	e8 7d fd ff ff       	call   4f2 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 775:	0f b6 03             	movzbl (%ebx),%eax
 778:	83 c4 10             	add    $0x10,%esp
 77b:	84 c0                	test   %al,%al
 77d:	75 e1                	jne    760 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 77f:	31 d2                	xor    %edx,%edx
 781:	e9 ff fe ff ff       	jmp    685 <printf+0x55>
 786:	8d 76 00             	lea    0x0(%esi),%esi
 789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 790:	83 ec 04             	sub    $0x4,%esp
 793:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 796:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 799:	6a 01                	push   $0x1
 79b:	e9 4c ff ff ff       	jmp    6ec <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 7a0:	83 ec 0c             	sub    $0xc,%esp
 7a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 7a8:	6a 01                	push   $0x1
 7aa:	e9 6b ff ff ff       	jmp    71a <printf+0xea>
 7af:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7b2:	83 ec 04             	sub    $0x4,%esp
 7b5:	8b 03                	mov    (%ebx),%eax
 7b7:	6a 01                	push   $0x1
 7b9:	88 45 e4             	mov    %al,-0x1c(%ebp)
 7bc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 7bf:	50                   	push   %eax
 7c0:	57                   	push   %edi
 7c1:	e8 2c fd ff ff       	call   4f2 <write>
 7c6:	e9 5b ff ff ff       	jmp    726 <printf+0xf6>
 7cb:	66 90                	xchg   %ax,%ax
 7cd:	66 90                	xchg   %ax,%ax
 7cf:	90                   	nop

000007d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d1:	a1 40 8d 00 00       	mov    0x8d40,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d6:	89 e5                	mov    %esp,%ebp
 7d8:	57                   	push   %edi
 7d9:	56                   	push   %esi
 7da:	53                   	push   %ebx
 7db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7de:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7e0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e3:	39 c8                	cmp    %ecx,%eax
 7e5:	73 19                	jae    800 <free+0x30>
 7e7:	89 f6                	mov    %esi,%esi
 7e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 7f0:	39 d1                	cmp    %edx,%ecx
 7f2:	72 1c                	jb     810 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f4:	39 d0                	cmp    %edx,%eax
 7f6:	73 18                	jae    810 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 7f8:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fa:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fc:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fe:	72 f0                	jb     7f0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 800:	39 d0                	cmp    %edx,%eax
 802:	72 f4                	jb     7f8 <free+0x28>
 804:	39 d1                	cmp    %edx,%ecx
 806:	73 f0                	jae    7f8 <free+0x28>
 808:	90                   	nop
 809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 810:	8b 73 fc             	mov    -0x4(%ebx),%esi
 813:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 816:	39 d7                	cmp    %edx,%edi
 818:	74 19                	je     833 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 81a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 81d:	8b 50 04             	mov    0x4(%eax),%edx
 820:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 823:	39 f1                	cmp    %esi,%ecx
 825:	74 23                	je     84a <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 827:	89 08                	mov    %ecx,(%eax)
  freep = p;
 829:	a3 40 8d 00 00       	mov    %eax,0x8d40
}
 82e:	5b                   	pop    %ebx
 82f:	5e                   	pop    %esi
 830:	5f                   	pop    %edi
 831:	5d                   	pop    %ebp
 832:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 833:	03 72 04             	add    0x4(%edx),%esi
 836:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 839:	8b 10                	mov    (%eax),%edx
 83b:	8b 12                	mov    (%edx),%edx
 83d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 840:	8b 50 04             	mov    0x4(%eax),%edx
 843:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 846:	39 f1                	cmp    %esi,%ecx
 848:	75 dd                	jne    827 <free+0x57>
    p->s.size += bp->s.size;
 84a:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 84d:	a3 40 8d 00 00       	mov    %eax,0x8d40
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 852:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 855:	8b 53 f8             	mov    -0x8(%ebx),%edx
 858:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 85a:	5b                   	pop    %ebx
 85b:	5e                   	pop    %esi
 85c:	5f                   	pop    %edi
 85d:	5d                   	pop    %ebp
 85e:	c3                   	ret    
 85f:	90                   	nop

00000860 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 860:	55                   	push   %ebp
 861:	89 e5                	mov    %esp,%ebp
 863:	57                   	push   %edi
 864:	56                   	push   %esi
 865:	53                   	push   %ebx
 866:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 869:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 86c:	8b 15 40 8d 00 00    	mov    0x8d40,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 872:	8d 78 07             	lea    0x7(%eax),%edi
 875:	c1 ef 03             	shr    $0x3,%edi
 878:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 87b:	85 d2                	test   %edx,%edx
 87d:	0f 84 a3 00 00 00    	je     926 <malloc+0xc6>
 883:	8b 02                	mov    (%edx),%eax
 885:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 888:	39 cf                	cmp    %ecx,%edi
 88a:	76 74                	jbe    900 <malloc+0xa0>
 88c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 892:	be 00 10 00 00       	mov    $0x1000,%esi
 897:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 89e:	0f 43 f7             	cmovae %edi,%esi
 8a1:	ba 00 80 00 00       	mov    $0x8000,%edx
 8a6:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 8ac:	0f 46 da             	cmovbe %edx,%ebx
 8af:	eb 10                	jmp    8c1 <malloc+0x61>
 8b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8ba:	8b 48 04             	mov    0x4(%eax),%ecx
 8bd:	39 cf                	cmp    %ecx,%edi
 8bf:	76 3f                	jbe    900 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8c1:	39 05 40 8d 00 00    	cmp    %eax,0x8d40
 8c7:	89 c2                	mov    %eax,%edx
 8c9:	75 ed                	jne    8b8 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 8cb:	83 ec 0c             	sub    $0xc,%esp
 8ce:	53                   	push   %ebx
 8cf:	e8 86 fc ff ff       	call   55a <sbrk>
  if(p == (char*)-1)
 8d4:	83 c4 10             	add    $0x10,%esp
 8d7:	83 f8 ff             	cmp    $0xffffffff,%eax
 8da:	74 1c                	je     8f8 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 8dc:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 8df:	83 ec 0c             	sub    $0xc,%esp
 8e2:	83 c0 08             	add    $0x8,%eax
 8e5:	50                   	push   %eax
 8e6:	e8 e5 fe ff ff       	call   7d0 <free>
  return freep;
 8eb:	8b 15 40 8d 00 00    	mov    0x8d40,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 8f1:	83 c4 10             	add    $0x10,%esp
 8f4:	85 d2                	test   %edx,%edx
 8f6:	75 c0                	jne    8b8 <malloc+0x58>
        return 0;
 8f8:	31 c0                	xor    %eax,%eax
 8fa:	eb 1c                	jmp    918 <malloc+0xb8>
 8fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 900:	39 cf                	cmp    %ecx,%edi
 902:	74 1c                	je     920 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 904:	29 f9                	sub    %edi,%ecx
 906:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 909:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 90c:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
 90f:	89 15 40 8d 00 00    	mov    %edx,0x8d40
      return (void*)(p + 1);
 915:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 918:	8d 65 f4             	lea    -0xc(%ebp),%esp
 91b:	5b                   	pop    %ebx
 91c:	5e                   	pop    %esi
 91d:	5f                   	pop    %edi
 91e:	5d                   	pop    %ebp
 91f:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 920:	8b 08                	mov    (%eax),%ecx
 922:	89 0a                	mov    %ecx,(%edx)
 924:	eb e9                	jmp    90f <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 926:	c7 05 40 8d 00 00 44 	movl   $0x8d44,0x8d40
 92d:	8d 00 00 
 930:	c7 05 44 8d 00 00 44 	movl   $0x8d44,0x8d44
 937:	8d 00 00 
    base.s.size = 0;
 93a:	b8 44 8d 00 00       	mov    $0x8d44,%eax
 93f:	c7 05 48 8d 00 00 00 	movl   $0x0,0x8d48
 946:	00 00 00 
 949:	e9 3e ff ff ff       	jmp    88c <malloc+0x2c>
