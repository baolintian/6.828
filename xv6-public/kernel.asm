
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 90 2f 10 80       	mov    $0x80102f90,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 71 10 80       	push   $0x801071e0
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 c5 42 00 00       	call   80104320 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 71 10 80       	push   $0x801071e7
80100097:	50                   	push   %eax
80100098:	e8 53 41 00 00       	call   801041f0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 97 43 00 00       	call   80104480 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 c9 43 00 00       	call   80104530 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 40 00 00       	call   80104230 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 6d 20 00 00       	call   801021f0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ee 71 10 80       	push   $0x801071ee
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 1d 41 00 00       	call   801042d0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 27 20 00 00       	jmp    801021f0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 ff 71 10 80       	push   $0x801071ff
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 dc 40 00 00       	call   801042d0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 8c 40 00 00       	call   80104290 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 70 42 00 00       	call   80104480 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 cf 42 00 00       	jmp    80104530 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 06 72 10 80       	push   $0x80107206
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 cb 15 00 00       	call   80101850 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 ef 41 00 00       	call   80104480 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002a6:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 a5 10 80       	push   $0x8010a520
801002b8:	68 a0 ff 10 80       	push   $0x8010ffa0
801002bd:	e8 be 3b 00 00       	call   80103e80 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 e9 35 00 00       	call   801038c0 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 a5 10 80       	push   $0x8010a520
801002e6:	e8 45 42 00 00       	call   80104530 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 7d 14 00 00       	call   80101770 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 a5 10 80       	push   $0x8010a520
80100346:	e8 e5 41 00 00       	call   80104530 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 1d 14 00 00       	call   80101770 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100379:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100380:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 62 24 00 00       	call   801027f0 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 0d 72 10 80       	push   $0x8010720d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 e4 79 10 80 	movl   $0x801079e4,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 83 3f 00 00       	call   80104340 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 21 72 10 80       	push   $0x80107221
801003cd:	e8 8e 02 00 00       	call   80100660 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 41 59 00 00       	call   80105d60 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 88 58 00 00       	call   80105d60 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 7c 58 00 00       	call   80105d60 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 70 58 00 00       	call   80105d60 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 17 41 00 00       	call   80104630 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 52 40 00 00       	call   80104580 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 25 72 10 80       	push   $0x80107225
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 50 72 10 80 	movzbl -0x7fef8db0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 3c 12 00 00       	call   80101850 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 60 3e 00 00       	call   80104480 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 e4 3e 00 00       	call   80104530 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 1b 11 00 00       	call   80101770 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 a5 10 80       	push   $0x8010a520
8010070d:	e8 1e 3e 00 00       	call   80104530 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 38 72 10 80       	mov    $0x80107238,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 a5 10 80       	push   $0x8010a520
801007c8:	e8 b3 3c 00 00       	call   80104480 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 3f 72 10 80       	push   $0x8010723f
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 a5 10 80       	push   $0x8010a520
80100803:	e8 78 3c 00 00       	call   80104480 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100836:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 a5 10 80       	push   $0x8010a520
80100868:	e8 c3 3c 00 00       	call   80104530 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008f1:	68 a0 ff 10 80       	push   $0x8010ffa0
801008f6:	e8 45 37 00 00       	call   80104040 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010090d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100934:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 b4 37 00 00       	jmp    80104130 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 48 72 10 80       	push   $0x80107248
801009ab:	68 20 a5 10 80       	push   $0x8010a520
801009b0:	e8 6b 39 00 00       	call   80104320 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009b5:	58                   	pop    %eax
801009b6:	5a                   	pop    %edx
801009b7:	6a 00                	push   $0x0
801009b9:	6a 01                	push   $0x1
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bb:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009d6:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009d9:	e8 c2 19 00 00       	call   801023a0 <ioapicenable>
}
801009de:	83 c4 10             	add    $0x10,%esp
801009e1:	c9                   	leave  
801009e2:	c3                   	ret    
801009e3:	66 90                	xchg   %ax,%ax
801009e5:	66 90                	xchg   %ax,%ax
801009e7:	66 90                	xchg   %ax,%ax
801009e9:	66 90                	xchg   %ax,%ax
801009eb:	66 90                	xchg   %ax,%ax
801009ed:	66 90                	xchg   %ax,%ax
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009fc:	e8 bf 2e 00 00       	call   801038c0 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a07:	e8 34 22 00 00       	call   80102c40 <begin_op>

  if((ip = namei(path)) == 0){
80100a0c:	83 ec 0c             	sub    $0xc,%esp
80100a0f:	ff 75 08             	pushl  0x8(%ebp)
80100a12:	e8 a9 15 00 00       	call   80101fc0 <namei>
80100a17:	83 c4 10             	add    $0x10,%esp
80100a1a:	85 c0                	test   %eax,%eax
80100a1c:	0f 84 9c 01 00 00    	je     80100bbe <exec+0x1ce>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a22:	83 ec 0c             	sub    $0xc,%esp
80100a25:	89 c3                	mov    %eax,%ebx
80100a27:	50                   	push   %eax
80100a28:	e8 43 0d 00 00       	call   80101770 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a33:	6a 34                	push   $0x34
80100a35:	6a 00                	push   $0x0
80100a37:	50                   	push   %eax
80100a38:	53                   	push   %ebx
80100a39:	e8 12 10 00 00       	call   80101a50 <readi>
80100a3e:	83 c4 20             	add    $0x20,%esp
80100a41:	83 f8 34             	cmp    $0x34,%eax
80100a44:	74 22                	je     80100a68 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	53                   	push   %ebx
80100a4a:	e8 b1 0f 00 00       	call   80101a00 <iunlockput>
    end_op();
80100a4f:	e8 5c 22 00 00       	call   80102cb0 <end_op>
80100a54:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a5f:	5b                   	pop    %ebx
80100a60:	5e                   	pop    %esi
80100a61:	5f                   	pop    %edi
80100a62:	5d                   	pop    %ebp
80100a63:	c3                   	ret    
80100a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a68:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a6f:	45 4c 46 
80100a72:	75 d2                	jne    80100a46 <exec+0x56>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a74:	e8 a7 64 00 00       	call   80106f20 <setupkvm>
80100a79:	85 c0                	test   %eax,%eax
80100a7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a81:	74 c3                	je     80100a46 <exec+0x56>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a83:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a8a:	00 
80100a8b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a91:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a98:	00 00 00 
80100a9b:	0f 84 c5 00 00 00    	je     80100b66 <exec+0x176>
80100aa1:	31 ff                	xor    %edi,%edi
80100aa3:	eb 18                	jmp    80100abd <exec+0xcd>
80100aa5:	8d 76 00             	lea    0x0(%esi),%esi
80100aa8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100aaf:	83 c7 01             	add    $0x1,%edi
80100ab2:	83 c6 20             	add    $0x20,%esi
80100ab5:	39 f8                	cmp    %edi,%eax
80100ab7:	0f 8e a9 00 00 00    	jle    80100b66 <exec+0x176>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100abd:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ac3:	6a 20                	push   $0x20
80100ac5:	56                   	push   %esi
80100ac6:	50                   	push   %eax
80100ac7:	53                   	push   %ebx
80100ac8:	e8 83 0f 00 00       	call   80101a50 <readi>
80100acd:	83 c4 10             	add    $0x10,%esp
80100ad0:	83 f8 20             	cmp    $0x20,%eax
80100ad3:	75 7b                	jne    80100b50 <exec+0x160>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ad5:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100adc:	75 ca                	jne    80100aa8 <exec+0xb8>
      continue;
    if(ph.memsz < ph.filesz)
80100ade:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ae4:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100aea:	72 64                	jb     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100aec:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100af2:	72 5c                	jb     80100b50 <exec+0x160>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100af4:	83 ec 04             	sub    $0x4,%esp
80100af7:	50                   	push   %eax
80100af8:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100afe:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b04:	e8 67 62 00 00       	call   80106d70 <allocuvm>
80100b09:	83 c4 10             	add    $0x10,%esp
80100b0c:	85 c0                	test   %eax,%eax
80100b0e:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b14:	74 3a                	je     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b16:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b1c:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b21:	75 2d                	jne    80100b50 <exec+0x160>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b23:	83 ec 0c             	sub    $0xc,%esp
80100b26:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b2c:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b32:	53                   	push   %ebx
80100b33:	50                   	push   %eax
80100b34:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b3a:	e8 71 61 00 00       	call   80106cb0 <loaduvm>
80100b3f:	83 c4 20             	add    $0x20,%esp
80100b42:	85 c0                	test   %eax,%eax
80100b44:	0f 89 5e ff ff ff    	jns    80100aa8 <exec+0xb8>
80100b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b50:	83 ec 0c             	sub    $0xc,%esp
80100b53:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b59:	e8 42 63 00 00       	call   80106ea0 <freevm>
80100b5e:	83 c4 10             	add    $0x10,%esp
80100b61:	e9 e0 fe ff ff       	jmp    80100a46 <exec+0x56>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b66:	83 ec 0c             	sub    $0xc,%esp
80100b69:	53                   	push   %ebx
80100b6a:	e8 91 0e 00 00       	call   80101a00 <iunlockput>
  end_op();
80100b6f:	e8 3c 21 00 00       	call   80102cb0 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b74:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b7a:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b7d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b87:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b8d:	52                   	push   %edx
80100b8e:	50                   	push   %eax
80100b8f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b95:	e8 d6 61 00 00       	call   80106d70 <allocuvm>
80100b9a:	83 c4 10             	add    $0x10,%esp
80100b9d:	85 c0                	test   %eax,%eax
80100b9f:	89 c6                	mov    %eax,%esi
80100ba1:	75 3a                	jne    80100bdd <exec+0x1ed>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100ba3:	83 ec 0c             	sub    $0xc,%esp
80100ba6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bac:	e8 ef 62 00 00       	call   80106ea0 <freevm>
80100bb1:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bb9:	e9 9e fe ff ff       	jmp    80100a5c <exec+0x6c>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100bbe:	e8 ed 20 00 00       	call   80102cb0 <end_op>
    cprintf("exec: fail\n");
80100bc3:	83 ec 0c             	sub    $0xc,%esp
80100bc6:	68 61 72 10 80       	push   $0x80107261
80100bcb:	e8 90 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100bd0:	83 c4 10             	add    $0x10,%esp
80100bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd8:	e9 7f fe ff ff       	jmp    80100a5c <exec+0x6c>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bdd:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100be3:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100be6:	31 ff                	xor    %edi,%edi
80100be8:	89 f3                	mov    %esi,%ebx
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bea:	50                   	push   %eax
80100beb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bf1:	e8 ca 63 00 00       	call   80106fc0 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bf9:	83 c4 10             	add    $0x10,%esp
80100bfc:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c02:	8b 00                	mov    (%eax),%eax
80100c04:	85 c0                	test   %eax,%eax
80100c06:	74 79                	je     80100c81 <exec+0x291>
80100c08:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c0e:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c14:	eb 13                	jmp    80100c29 <exec+0x239>
80100c16:	8d 76 00             	lea    0x0(%esi),%esi
80100c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(argc >= MAXARG)
80100c20:	83 ff 20             	cmp    $0x20,%edi
80100c23:	0f 84 7a ff ff ff    	je     80100ba3 <exec+0x1b3>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c29:	83 ec 0c             	sub    $0xc,%esp
80100c2c:	50                   	push   %eax
80100c2d:	e8 8e 3b 00 00       	call   801047c0 <strlen>
80100c32:	f7 d0                	not    %eax
80100c34:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c36:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c39:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c3a:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c3d:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c40:	e8 7b 3b 00 00       	call   801047c0 <strlen>
80100c45:	83 c0 01             	add    $0x1,%eax
80100c48:	50                   	push   %eax
80100c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4f:	53                   	push   %ebx
80100c50:	56                   	push   %esi
80100c51:	e8 ea 64 00 00       	call   80107140 <copyout>
80100c56:	83 c4 20             	add    $0x20,%esp
80100c59:	85 c0                	test   %eax,%eax
80100c5b:	0f 88 42 ff ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c61:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c64:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c6b:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c6e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c74:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c77:	85 c0                	test   %eax,%eax
80100c79:	75 a5                	jne    80100c20 <exec+0x230>
80100c7b:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c81:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c88:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c8a:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c91:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100c95:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c9c:	ff ff ff 
  ustack[1] = argc;
80100c9f:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ca5:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100ca7:	83 c0 0c             	add    $0xc,%eax
80100caa:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cac:	50                   	push   %eax
80100cad:	52                   	push   %edx
80100cae:	53                   	push   %ebx
80100caf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb5:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cbb:	e8 80 64 00 00       	call   80107140 <copyout>
80100cc0:	83 c4 10             	add    $0x10,%esp
80100cc3:	85 c0                	test   %eax,%eax
80100cc5:	0f 88 d8 fe ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ccb:	8b 45 08             	mov    0x8(%ebp),%eax
80100cce:	0f b6 10             	movzbl (%eax),%edx
80100cd1:	84 d2                	test   %dl,%dl
80100cd3:	74 19                	je     80100cee <exec+0x2fe>
80100cd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cd8:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100cdb:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cde:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100ce1:	0f 44 c8             	cmove  %eax,%ecx
80100ce4:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ce7:	84 d2                	test   %dl,%dl
80100ce9:	75 f0                	jne    80100cdb <exec+0x2eb>
80100ceb:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cee:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cf4:	50                   	push   %eax
80100cf5:	6a 10                	push   $0x10
80100cf7:	ff 75 08             	pushl  0x8(%ebp)
80100cfa:	89 f8                	mov    %edi,%eax
80100cfc:	83 c0 6c             	add    $0x6c,%eax
80100cff:	50                   	push   %eax
80100d00:	e8 7b 3a 00 00       	call   80104780 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d05:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100d0b:	89 f8                	mov    %edi,%eax
80100d0d:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
80100d10:	89 30                	mov    %esi,(%eax)
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d12:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100d15:	89 c1                	mov    %eax,%ecx
80100d17:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d1d:	8b 40 18             	mov    0x18(%eax),%eax
80100d20:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d23:	8b 41 18             	mov    0x18(%ecx),%eax
80100d26:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d29:	89 0c 24             	mov    %ecx,(%esp)
80100d2c:	e8 ef 5d 00 00       	call   80106b20 <switchuvm>
  freevm(oldpgdir);
80100d31:	89 3c 24             	mov    %edi,(%esp)
80100d34:	e8 67 61 00 00       	call   80106ea0 <freevm>
  return 0;
80100d39:	83 c4 10             	add    $0x10,%esp
80100d3c:	31 c0                	xor    %eax,%eax
80100d3e:	e9 19 fd ff ff       	jmp    80100a5c <exec+0x6c>
80100d43:	66 90                	xchg   %ax,%ax
80100d45:	66 90                	xchg   %ax,%ax
80100d47:	66 90                	xchg   %ax,%ax
80100d49:	66 90                	xchg   %ax,%ax
80100d4b:	66 90                	xchg   %ax,%ax
80100d4d:	66 90                	xchg   %ax,%ax
80100d4f:	90                   	nop

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	68 6d 72 10 80       	push   $0x8010726d
80100d5b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d60:	e8 bb 35 00 00       	call   80104320 <initlock>
}
80100d65:	83 c4 10             	add    $0x10,%esp
80100d68:	c9                   	leave  
80100d69:	c3                   	ret    
80100d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d79:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d7c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d81:	e8 fa 36 00 00       	call   80104480 <acquire>
80100d86:	83 c4 10             	add    $0x10,%esp
80100d89:	eb 10                	jmp    80100d9b <filealloc+0x2b>
80100d8b:	90                   	nop
80100d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100da5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dac:	68 c0 ff 10 80       	push   $0x8010ffc0
80100db1:	e8 7a 37 00 00       	call   80104530 <release>
      return f;
80100db6:	89 d8                	mov    %ebx,%eax
80100db8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dbe:	c9                   	leave  
80100dbf:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100dc0:	83 ec 0c             	sub    $0xc,%esp
80100dc3:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dc8:	e8 63 37 00 00       	call   80104530 <release>
  return 0;
80100dcd:	83 c4 10             	add    $0x10,%esp
80100dd0:	31 c0                	xor    %eax,%eax
}
80100dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dd5:	c9                   	leave  
80100dd6:	c3                   	ret    
80100dd7:	89 f6                	mov    %esi,%esi
80100dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 10             	sub    $0x10,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	68 c0 ff 10 80       	push   $0x8010ffc0
80100def:	e8 8c 36 00 00       	call   80104480 <acquire>
  if(f->ref < 1)
80100df4:	8b 43 04             	mov    0x4(%ebx),%eax
80100df7:	83 c4 10             	add    $0x10,%esp
80100dfa:	85 c0                	test   %eax,%eax
80100dfc:	7e 1a                	jle    80100e18 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dfe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e01:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100e04:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e07:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e0c:	e8 1f 37 00 00       	call   80104530 <release>
  return f;
}
80100e11:	89 d8                	mov    %ebx,%eax
80100e13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e16:	c9                   	leave  
80100e17:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e18:	83 ec 0c             	sub    $0xc,%esp
80100e1b:	68 74 72 10 80       	push   $0x80107274
80100e20:	e8 4b f5 ff ff       	call   80100370 <panic>
80100e25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 28             	sub    $0x28,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e41:	e8 3a 36 00 00       	call   80104480 <acquire>
  if(f->ref < 1)
80100e46:	8b 47 04             	mov    0x4(%edi),%eax
80100e49:	83 c4 10             	add    $0x10,%esp
80100e4c:	85 c0                	test   %eax,%eax
80100e4e:	0f 8e 9b 00 00 00    	jle    80100eef <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e54:	83 e8 01             	sub    $0x1,%eax
80100e57:	85 c0                	test   %eax,%eax
80100e59:	89 47 04             	mov    %eax,0x4(%edi)
80100e5c:	74 1a                	je     80100e78 <fileclose+0x48>
    release(&ftable.lock);
80100e5e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e68:	5b                   	pop    %ebx
80100e69:	5e                   	pop    %esi
80100e6a:	5f                   	pop    %edi
80100e6b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e6c:	e9 bf 36 00 00       	jmp    80104530 <release>
80100e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e78:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e7c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e7e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e81:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e84:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e8a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e8d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e90:	68 c0 ff 10 80       	push   $0x8010ffc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e95:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e98:	e8 93 36 00 00       	call   80104530 <release>

  if(ff.type == FD_PIPE)
80100e9d:	83 c4 10             	add    $0x10,%esp
80100ea0:	83 fb 01             	cmp    $0x1,%ebx
80100ea3:	74 13                	je     80100eb8 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100ea5:	83 fb 02             	cmp    $0x2,%ebx
80100ea8:	74 26                	je     80100ed0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ead:	5b                   	pop    %ebx
80100eae:	5e                   	pop    %esi
80100eaf:	5f                   	pop    %edi
80100eb0:	5d                   	pop    %ebp
80100eb1:	c3                   	ret    
80100eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100eb8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ebc:	83 ec 08             	sub    $0x8,%esp
80100ebf:	53                   	push   %ebx
80100ec0:	56                   	push   %esi
80100ec1:	e8 5a 25 00 00       	call   80103420 <pipeclose>
80100ec6:	83 c4 10             	add    $0x10,%esp
80100ec9:	eb df                	jmp    80100eaa <fileclose+0x7a>
80100ecb:	90                   	nop
80100ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ed0:	e8 6b 1d 00 00       	call   80102c40 <begin_op>
    iput(ff.ip);
80100ed5:	83 ec 0c             	sub    $0xc,%esp
80100ed8:	ff 75 e0             	pushl  -0x20(%ebp)
80100edb:	e8 c0 09 00 00       	call   801018a0 <iput>
    end_op();
80100ee0:	83 c4 10             	add    $0x10,%esp
  }
}
80100ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ee6:	5b                   	pop    %ebx
80100ee7:	5e                   	pop    %esi
80100ee8:	5f                   	pop    %edi
80100ee9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eea:	e9 c1 1d 00 00       	jmp    80102cb0 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100eef:	83 ec 0c             	sub    $0xc,%esp
80100ef2:	68 7c 72 10 80       	push   $0x8010727c
80100ef7:	e8 74 f4 ff ff       	call   80100370 <panic>
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f00 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
80100f04:	83 ec 04             	sub    $0x4,%esp
80100f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f0a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f0d:	75 31                	jne    80100f40 <filestat+0x40>
    ilock(f->ip);
80100f0f:	83 ec 0c             	sub    $0xc,%esp
80100f12:	ff 73 10             	pushl  0x10(%ebx)
80100f15:	e8 56 08 00 00       	call   80101770 <ilock>
    stati(f->ip, st);
80100f1a:	58                   	pop    %eax
80100f1b:	5a                   	pop    %edx
80100f1c:	ff 75 0c             	pushl  0xc(%ebp)
80100f1f:	ff 73 10             	pushl  0x10(%ebx)
80100f22:	e8 f9 0a 00 00       	call   80101a20 <stati>
    iunlock(f->ip);
80100f27:	59                   	pop    %ecx
80100f28:	ff 73 10             	pushl  0x10(%ebx)
80100f2b:	e8 20 09 00 00       	call   80101850 <iunlock>
    return 0;
80100f30:	83 c4 10             	add    $0x10,%esp
80100f33:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f38:	c9                   	leave  
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f50 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	57                   	push   %edi
80100f54:	56                   	push   %esi
80100f55:	53                   	push   %ebx
80100f56:	83 ec 0c             	sub    $0xc,%esp
80100f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f5f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f62:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f66:	74 60                	je     80100fc8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f68:	8b 03                	mov    (%ebx),%eax
80100f6a:	83 f8 01             	cmp    $0x1,%eax
80100f6d:	74 41                	je     80100fb0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f6f:	83 f8 02             	cmp    $0x2,%eax
80100f72:	75 5b                	jne    80100fcf <fileread+0x7f>
    ilock(f->ip);
80100f74:	83 ec 0c             	sub    $0xc,%esp
80100f77:	ff 73 10             	pushl  0x10(%ebx)
80100f7a:	e8 f1 07 00 00       	call   80101770 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f7f:	57                   	push   %edi
80100f80:	ff 73 14             	pushl  0x14(%ebx)
80100f83:	56                   	push   %esi
80100f84:	ff 73 10             	pushl  0x10(%ebx)
80100f87:	e8 c4 0a 00 00       	call   80101a50 <readi>
80100f8c:	83 c4 20             	add    $0x20,%esp
80100f8f:	85 c0                	test   %eax,%eax
80100f91:	89 c6                	mov    %eax,%esi
80100f93:	7e 03                	jle    80100f98 <fileread+0x48>
      f->off += r;
80100f95:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f98:	83 ec 0c             	sub    $0xc,%esp
80100f9b:	ff 73 10             	pushl  0x10(%ebx)
80100f9e:	e8 ad 08 00 00       	call   80101850 <iunlock>
    return r;
80100fa3:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fa6:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fab:	5b                   	pop    %ebx
80100fac:	5e                   	pop    %esi
80100fad:	5f                   	pop    %edi
80100fae:	5d                   	pop    %ebp
80100faf:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fb0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fb3:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	5b                   	pop    %ebx
80100fba:	5e                   	pop    %esi
80100fbb:	5f                   	pop    %edi
80100fbc:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fbd:	e9 fe 25 00 00       	jmp    801035c0 <piperead>
80100fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fcd:	eb d9                	jmp    80100fa8 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fcf:	83 ec 0c             	sub    $0xc,%esp
80100fd2:	68 86 72 10 80       	push   $0x80107286
80100fd7:	e8 94 f3 ff ff       	call   80100370 <panic>
80100fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 1c             	sub    $0x1c,%esp
80100fe9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fef:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff6:	8b 45 10             	mov    0x10(%ebp),%eax
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100ffc:	0f 84 aa 00 00 00    	je     801010ac <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 06                	mov    (%esi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d8 00 00 00    	jne    801010ee <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 ff                	xor    %edi,%edi
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 34                	jg     80101053 <filewrite+0x73>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101028:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010102b:	83 ec 0c             	sub    $0xc,%esp
8010102e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101031:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101034:	e8 17 08 00 00       	call   80101850 <iunlock>
      end_op();
80101039:	e8 72 1c 00 00       	call   80102cb0 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101041:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101044:	39 d8                	cmp    %ebx,%eax
80101046:	0f 85 95 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010104c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010104e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101051:	7e 6d                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101053:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101056:	b8 00 06 00 00       	mov    $0x600,%eax
8010105b:	29 fb                	sub    %edi,%ebx
8010105d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101063:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101066:	e8 d5 1b 00 00       	call   80102c40 <begin_op>
      ilock(f->ip);
8010106b:	83 ec 0c             	sub    $0xc,%esp
8010106e:	ff 76 10             	pushl  0x10(%esi)
80101071:	e8 fa 06 00 00       	call   80101770 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101076:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101079:	53                   	push   %ebx
8010107a:	ff 76 14             	pushl  0x14(%esi)
8010107d:	01 f8                	add    %edi,%eax
8010107f:	50                   	push   %eax
80101080:	ff 76 10             	pushl  0x10(%esi)
80101083:	e8 c8 0a 00 00       	call   80101b50 <writei>
80101088:	83 c4 20             	add    $0x20,%esp
8010108b:	85 c0                	test   %eax,%eax
8010108d:	7f 99                	jg     80101028 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010108f:	83 ec 0c             	sub    $0xc,%esp
80101092:	ff 76 10             	pushl  0x10(%esi)
80101095:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101098:	e8 b3 07 00 00       	call   80101850 <iunlock>
      end_op();
8010109d:	e8 0e 1c 00 00       	call   80102cb0 <end_op>

      if(r < 0)
801010a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010a5:	83 c4 10             	add    $0x10,%esp
801010a8:	85 c0                	test   %eax,%eax
801010aa:	74 98                	je     80101044 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801010b4:	5b                   	pop    %ebx
801010b5:	5e                   	pop    %esi
801010b6:	5f                   	pop    %edi
801010b7:	5d                   	pop    %ebp
801010b8:	c3                   	ret    
801010b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010c0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010c3:	75 e7                	jne    801010ac <filewrite+0xcc>
  }
  panic("filewrite");
}
801010c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c8:	89 f8                	mov    %edi,%eax
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 46 0c             	mov    0xc(%esi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 df 23 00 00       	jmp    801034c0 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010e1:	83 ec 0c             	sub    $0xc,%esp
801010e4:	68 8f 72 10 80       	push   $0x8010728f
801010e9:	e8 82 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ee:	83 ec 0c             	sub    $0xc,%esp
801010f1:	68 95 72 10 80       	push   $0x80107295
801010f6:	e8 75 f2 ff ff       	call   80100370 <panic>
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	56                   	push   %esi
80101104:	53                   	push   %ebx
80101105:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101107:	c1 ea 0c             	shr    $0xc,%edx
8010110a:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101110:	83 ec 08             	sub    $0x8,%esp
80101113:	52                   	push   %edx
80101114:	50                   	push   %eax
80101115:	e8 b6 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010111a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010111c:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101122:	ba 01 00 00 00       	mov    $0x1,%edx
80101127:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010112a:	c1 fb 03             	sar    $0x3,%ebx
8010112d:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101130:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101132:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101137:	85 d1                	test   %edx,%ecx
80101139:	74 27                	je     80101162 <bfree+0x62>
8010113b:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010113d:	f7 d2                	not    %edx
8010113f:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101141:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101144:	21 d0                	and    %edx,%eax
80101146:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010114a:	56                   	push   %esi
8010114b:	e8 10 1d 00 00       	call   80102e60 <log_write>
  brelse(bp);
80101150:	89 34 24             	mov    %esi,(%esp)
80101153:	e8 88 f0 ff ff       	call   801001e0 <brelse>
}
80101158:	83 c4 10             	add    $0x10,%esp
8010115b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010115e:	5b                   	pop    %ebx
8010115f:	5e                   	pop    %esi
80101160:	5d                   	pop    %ebp
80101161:	c3                   	ret    

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101162:	83 ec 0c             	sub    $0xc,%esp
80101165:	68 9f 72 10 80       	push   $0x8010729f
8010116a:	e8 01 f2 ff ff       	call   80100370 <panic>
8010116f:	90                   	nop

80101170 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101170:	55                   	push   %ebp
80101171:	89 e5                	mov    %esp,%ebp
80101173:	57                   	push   %edi
80101174:	56                   	push   %esi
80101175:	53                   	push   %ebx
80101176:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101179:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010117f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101182:	85 c9                	test   %ecx,%ecx
80101184:	0f 84 85 00 00 00    	je     8010120f <balloc+0x9f>
8010118a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101191:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101194:	83 ec 08             	sub    $0x8,%esp
80101197:	89 f0                	mov    %esi,%eax
80101199:	c1 f8 0c             	sar    $0xc,%eax
8010119c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011a2:	50                   	push   %eax
801011a3:	ff 75 d8             	pushl  -0x28(%ebp)
801011a6:	e8 25 ef ff ff       	call   801000d0 <bread>
801011ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011ae:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011b3:	83 c4 10             	add    $0x10,%esp
801011b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011b9:	31 c0                	xor    %eax,%eax
801011bb:	eb 2d                	jmp    801011ea <balloc+0x7a>
801011bd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011c0:	89 c1                	mov    %eax,%ecx
801011c2:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011c7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801011ca:	83 e1 07             	and    $0x7,%ecx
801011cd:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011cf:	89 c1                	mov    %eax,%ecx
801011d1:	c1 f9 03             	sar    $0x3,%ecx
801011d4:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
801011d9:	85 d7                	test   %edx,%edi
801011db:	74 43                	je     80101220 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011dd:	83 c0 01             	add    $0x1,%eax
801011e0:	83 c6 01             	add    $0x1,%esi
801011e3:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011e8:	74 05                	je     801011ef <balloc+0x7f>
801011ea:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801011ed:	72 d1                	jb     801011c0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801011ef:	83 ec 0c             	sub    $0xc,%esp
801011f2:	ff 75 e4             	pushl  -0x1c(%ebp)
801011f5:	e8 e6 ef ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011fa:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101201:	83 c4 10             	add    $0x10,%esp
80101204:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101207:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010120d:	77 82                	ja     80101191 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010120f:	83 ec 0c             	sub    $0xc,%esp
80101212:	68 b2 72 10 80       	push   $0x801072b2
80101217:	e8 54 f1 ff ff       	call   80100370 <panic>
8010121c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101220:	09 fa                	or     %edi,%edx
80101222:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101225:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101228:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010122c:	57                   	push   %edi
8010122d:	e8 2e 1c 00 00       	call   80102e60 <log_write>
        brelse(bp);
80101232:	89 3c 24             	mov    %edi,(%esp)
80101235:	e8 a6 ef ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
8010123a:	58                   	pop    %eax
8010123b:	5a                   	pop    %edx
8010123c:	56                   	push   %esi
8010123d:	ff 75 d8             	pushl  -0x28(%ebp)
80101240:	e8 8b ee ff ff       	call   801000d0 <bread>
80101245:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101247:	8d 40 5c             	lea    0x5c(%eax),%eax
8010124a:	83 c4 0c             	add    $0xc,%esp
8010124d:	68 00 02 00 00       	push   $0x200
80101252:	6a 00                	push   $0x0
80101254:	50                   	push   %eax
80101255:	e8 26 33 00 00       	call   80104580 <memset>
  log_write(bp);
8010125a:	89 1c 24             	mov    %ebx,(%esp)
8010125d:	e8 fe 1b 00 00       	call   80102e60 <log_write>
  brelse(bp);
80101262:	89 1c 24             	mov    %ebx,(%esp)
80101265:	e8 76 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010126a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010126d:	89 f0                	mov    %esi,%eax
8010126f:	5b                   	pop    %ebx
80101270:	5e                   	pop    %esi
80101271:	5f                   	pop    %edi
80101272:	5d                   	pop    %ebp
80101273:	c3                   	ret    
80101274:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010127a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101280 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101280:	55                   	push   %ebp
80101281:	89 e5                	mov    %esp,%ebp
80101283:	57                   	push   %edi
80101284:	56                   	push   %esi
80101285:	53                   	push   %ebx
80101286:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101288:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010128f:	83 ec 28             	sub    $0x28,%esp
80101292:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101295:	68 e0 09 11 80       	push   $0x801109e0
8010129a:	e8 e1 31 00 00       	call   80104480 <acquire>
8010129f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012a5:	eb 1b                	jmp    801012c2 <iget+0x42>
801012a7:	89 f6                	mov    %esi,%esi
801012a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012b0:	85 f6                	test   %esi,%esi
801012b2:	74 44                	je     801012f8 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012ba:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012c0:	74 4e                	je     80101310 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012c2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012c5:	85 c9                	test   %ecx,%ecx
801012c7:	7e e7                	jle    801012b0 <iget+0x30>
801012c9:	39 3b                	cmp    %edi,(%ebx)
801012cb:	75 e3                	jne    801012b0 <iget+0x30>
801012cd:	39 53 04             	cmp    %edx,0x4(%ebx)
801012d0:	75 de                	jne    801012b0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
801012d2:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
801012d5:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
801012d8:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
801012da:	68 e0 09 11 80       	push   $0x801109e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
801012df:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012e2:	e8 49 32 00 00       	call   80104530 <release>
      return ip;
801012e7:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
801012ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ed:	89 f0                	mov    %esi,%eax
801012ef:	5b                   	pop    %ebx
801012f0:	5e                   	pop    %esi
801012f1:	5f                   	pop    %edi
801012f2:	5d                   	pop    %ebp
801012f3:	c3                   	ret    
801012f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012f8:	85 c9                	test   %ecx,%ecx
801012fa:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fd:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101303:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101309:	75 b7                	jne    801012c2 <iget+0x42>
8010130b:	90                   	nop
8010130c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101310:	85 f6                	test   %esi,%esi
80101312:	74 2d                	je     80101341 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101314:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101317:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101319:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010131c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101323:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010132a:	68 e0 09 11 80       	push   $0x801109e0
8010132f:	e8 fc 31 00 00       	call   80104530 <release>

  return ip;
80101334:	83 c4 10             	add    $0x10,%esp
}
80101337:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133a:	89 f0                	mov    %esi,%eax
8010133c:	5b                   	pop    %ebx
8010133d:	5e                   	pop    %esi
8010133e:	5f                   	pop    %edi
8010133f:	5d                   	pop    %ebp
80101340:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
80101341:	83 ec 0c             	sub    $0xc,%esp
80101344:	68 c8 72 10 80       	push   $0x801072c8
80101349:	e8 22 f0 ff ff       	call   80100370 <panic>
8010134e:	66 90                	xchg   %ax,%ax

80101350 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	56                   	push   %esi
80101355:	53                   	push   %ebx
80101356:	89 c6                	mov    %eax,%esi
80101358:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp, *bp2;

  if(bn < NDIRECT){
8010135b:	83 fa 0a             	cmp    $0xa,%edx
8010135e:	77 20                	ja     80101380 <bmap+0x30>
80101360:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
80101363:	8b 43 5c             	mov    0x5c(%ebx),%eax
80101366:	85 c0                	test   %eax,%eax
80101368:	0f 84 f2 00 00 00    	je     80101460 <bmap+0x110>
    brelse(bp2);
    return addr;
  }
  
  panic("bmap: out of range");
}
8010136e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101371:	5b                   	pop    %ebx
80101372:	5e                   	pop    %esi
80101373:	5f                   	pop    %edi
80101374:	5d                   	pop    %ebp
80101375:	c3                   	ret    
80101376:	8d 76 00             	lea    0x0(%esi),%esi
80101379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101380:	8d 5a f5             	lea    -0xb(%edx),%ebx

  if(bn < NINDIRECT){
80101383:	83 fb 7f             	cmp    $0x7f,%ebx
80101386:	0f 86 8c 00 00 00    	jbe    80101418 <bmap+0xc8>
    }
    brelse(bp);
    return addr;
  }
  //cprintf("in it %d\n", bn);
  bn -= (NINDIRECT);
8010138c:	8d 9a 75 ff ff ff    	lea    -0x8b(%edx),%ebx
  if(bn < NDINDIRECT){
80101392:	81 fb ff 3f 00 00    	cmp    $0x3fff,%ebx
80101398:	0f 87 7c 01 00 00    	ja     8010151a <bmap+0x1ca>
    if((addr = ip->addrs[NDIRECT+1]) == 0)
8010139e:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801013a4:	85 c0                	test   %eax,%eax
801013a6:	0f 84 5c 01 00 00    	je     80101508 <bmap+0x1b8>
        ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013ac:	83 ec 08             	sub    $0x8,%esp
    a = (uint*)bp->data;
    int page = bn/NINDIRECT;
    int item = bn%NINDIRECT;
801013af:	89 df                	mov    %ebx,%edi
    if((addr = a[page]) == 0){
801013b1:	c1 eb 07             	shr    $0x7,%ebx
  //cprintf("in it %d\n", bn);
  bn -= (NINDIRECT);
  if(bn < NDINDIRECT){
    if((addr = ip->addrs[NDIRECT+1]) == 0)
        ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013b4:	50                   	push   %eax
801013b5:	ff 36                	pushl  (%esi)
    a = (uint*)bp->data;
    int page = bn/NINDIRECT;
    int item = bn%NINDIRECT;
801013b7:	83 e7 7f             	and    $0x7f,%edi
  //cprintf("in it %d\n", bn);
  bn -= (NINDIRECT);
  if(bn < NDINDIRECT){
    if((addr = ip->addrs[NDIRECT+1]) == 0)
        ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013ba:	e8 11 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    int page = bn/NINDIRECT;
    int item = bn%NINDIRECT;
    if((addr = a[page]) == 0){
801013bf:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013c3:	83 c4 10             	add    $0x10,%esp
  //cprintf("in it %d\n", bn);
  bn -= (NINDIRECT);
  if(bn < NDINDIRECT){
    if((addr = ip->addrs[NDIRECT+1]) == 0)
        ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
    int page = bn/NINDIRECT;
    int item = bn%NINDIRECT;
    if((addr = a[page]) == 0){
801013c9:	8b 1a                	mov    (%edx),%ebx
801013cb:	85 db                	test   %ebx,%ebx
801013cd:	0f 84 0d 01 00 00    	je     801014e0 <bmap+0x190>
        a[page] = addr = balloc(ip->dev);
        log_write(bp);
    }
    bp2 = bread(ip->dev, addr);
801013d3:	83 ec 08             	sub    $0x8,%esp
801013d6:	53                   	push   %ebx
801013d7:	ff 36                	pushl  (%esi)
801013d9:	e8 f2 ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp2->data;
    if((addr = a[item]) == 0){
801013de:	8d 54 b8 5c          	lea    0x5c(%eax,%edi,4),%edx
801013e2:	83 c4 10             	add    $0x10,%esp
    int item = bn%NINDIRECT;
    if((addr = a[page]) == 0){
        a[page] = addr = balloc(ip->dev);
        log_write(bp);
    }
    bp2 = bread(ip->dev, addr);
801013e5:	89 c3                	mov    %eax,%ebx
    a = (uint*)bp2->data;
    if((addr = a[item]) == 0){
801013e7:	8b 3a                	mov    (%edx),%edi
801013e9:	85 ff                	test   %edi,%edi
801013eb:	0f 84 af 00 00 00    	je     801014a0 <bmap+0x150>
        a[item] = addr = balloc(ip->dev);
        log_write(bp2);
    }
    brelse(bp);
801013f1:	83 ec 0c             	sub    $0xc,%esp
801013f4:	ff 75 e4             	pushl  -0x1c(%ebp)
801013f7:	e8 e4 ed ff ff       	call   801001e0 <brelse>
    brelse(bp2);
801013fc:	89 1c 24             	mov    %ebx,(%esp)
801013ff:	e8 dc ed ff ff       	call   801001e0 <brelse>
80101404:	83 c4 10             	add    $0x10,%esp
    return addr;
  }
  
  panic("bmap: out of range");
}
80101407:	8d 65 f4             	lea    -0xc(%ebp),%esp
        a[item] = addr = balloc(ip->dev);
        log_write(bp2);
    }
    brelse(bp);
    brelse(bp2);
    return addr;
8010140a:	89 f8                	mov    %edi,%eax
  }
  
  panic("bmap: out of range");
}
8010140c:	5b                   	pop    %ebx
8010140d:	5e                   	pop    %esi
8010140e:	5f                   	pop    %edi
8010140f:	5d                   	pop    %ebp
80101410:	c3                   	ret    
80101411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101418:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
8010141e:	85 c0                	test   %eax,%eax
80101420:	0f 84 a2 00 00 00    	je     801014c8 <bmap+0x178>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101426:	83 ec 08             	sub    $0x8,%esp
80101429:	50                   	push   %eax
8010142a:	ff 36                	pushl  (%esi)
8010142c:	e8 9f ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101431:	8d 7c 98 5c          	lea    0x5c(%eax,%ebx,4),%edi
80101435:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101438:	89 c2                	mov    %eax,%edx
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
8010143a:	8b 1f                	mov    (%edi),%ebx
8010143c:	85 db                	test   %ebx,%ebx
8010143e:	74 38                	je     80101478 <bmap+0x128>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101440:	83 ec 0c             	sub    $0xc,%esp
80101443:	52                   	push   %edx
80101444:	e8 97 ed ff ff       	call   801001e0 <brelse>
80101449:	83 c4 10             	add    $0x10,%esp
    brelse(bp2);
    return addr;
  }
  
  panic("bmap: out of range");
}
8010144c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    return addr;
8010144f:	89 d8                	mov    %ebx,%eax
    brelse(bp2);
    return addr;
  }
  
  panic("bmap: out of range");
}
80101451:	5b                   	pop    %ebx
80101452:	5e                   	pop    %esi
80101453:	5f                   	pop    %edi
80101454:	5d                   	pop    %ebp
80101455:	c3                   	ret    
80101456:	8d 76 00             	lea    0x0(%esi),%esi
80101459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint addr, *a;
  struct buf *bp, *bp2;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101460:	8b 06                	mov    (%esi),%eax
80101462:	e8 09 fd ff ff       	call   80101170 <balloc>
80101467:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp2);
    return addr;
  }
  
  panic("bmap: out of range");
}
8010146a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010146d:	5b                   	pop    %ebx
8010146e:	5e                   	pop    %esi
8010146f:	5f                   	pop    %edi
80101470:	5d                   	pop    %ebp
80101471:	c3                   	ret    
80101472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101478:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
8010147b:	8b 06                	mov    (%esi),%eax
8010147d:	e8 ee fc ff ff       	call   80101170 <balloc>
      log_write(bp);
80101482:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101485:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101488:	89 07                	mov    %eax,(%edi)
8010148a:	89 c3                	mov    %eax,%ebx
      log_write(bp);
8010148c:	52                   	push   %edx
8010148d:	e8 ce 19 00 00       	call   80102e60 <log_write>
80101492:	83 c4 10             	add    $0x10,%esp
80101495:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101498:	eb a6                	jmp    80101440 <bmap+0xf0>
8010149a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        log_write(bp);
    }
    bp2 = bread(ip->dev, addr);
    a = (uint*)bp2->data;
    if((addr = a[item]) == 0){
        a[item] = addr = balloc(ip->dev);
801014a0:	8b 06                	mov    (%esi),%eax
801014a2:	89 55 e0             	mov    %edx,-0x20(%ebp)
801014a5:	e8 c6 fc ff ff       	call   80101170 <balloc>
801014aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
        log_write(bp2);
801014ad:	83 ec 0c             	sub    $0xc,%esp
        log_write(bp);
    }
    bp2 = bread(ip->dev, addr);
    a = (uint*)bp2->data;
    if((addr = a[item]) == 0){
        a[item] = addr = balloc(ip->dev);
801014b0:	89 c7                	mov    %eax,%edi
801014b2:	89 02                	mov    %eax,(%edx)
        log_write(bp2);
801014b4:	53                   	push   %ebx
801014b5:	e8 a6 19 00 00       	call   80102e60 <log_write>
801014ba:	83 c4 10             	add    $0x10,%esp
801014bd:	e9 2f ff ff ff       	jmp    801013f1 <bmap+0xa1>
801014c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014c8:	8b 06                	mov    (%esi),%eax
801014ca:	e8 a1 fc ff ff       	call   80101170 <balloc>
801014cf:	89 86 88 00 00 00    	mov    %eax,0x88(%esi)
801014d5:	e9 4c ff ff ff       	jmp    80101426 <bmap+0xd6>
801014da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    int page = bn/NINDIRECT;
    int item = bn%NINDIRECT;
    if((addr = a[page]) == 0){
        a[page] = addr = balloc(ip->dev);
801014e0:	8b 06                	mov    (%esi),%eax
801014e2:	89 55 e0             	mov    %edx,-0x20(%ebp)
801014e5:	e8 86 fc ff ff       	call   80101170 <balloc>
801014ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
        log_write(bp);
801014ed:	83 ec 0c             	sub    $0xc,%esp
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    int page = bn/NINDIRECT;
    int item = bn%NINDIRECT;
    if((addr = a[page]) == 0){
        a[page] = addr = balloc(ip->dev);
801014f0:	89 c3                	mov    %eax,%ebx
801014f2:	89 02                	mov    %eax,(%edx)
        log_write(bp);
801014f4:	ff 75 e4             	pushl  -0x1c(%ebp)
801014f7:	e8 64 19 00 00       	call   80102e60 <log_write>
801014fc:	83 c4 10             	add    $0x10,%esp
801014ff:	e9 cf fe ff ff       	jmp    801013d3 <bmap+0x83>
80101504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  //cprintf("in it %d\n", bn);
  bn -= (NINDIRECT);
  if(bn < NDINDIRECT){
    if((addr = ip->addrs[NDIRECT+1]) == 0)
        ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
80101508:	8b 06                	mov    (%esi),%eax
8010150a:	e8 61 fc ff ff       	call   80101170 <balloc>
8010150f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101515:	e9 92 fe ff ff       	jmp    801013ac <bmap+0x5c>
    brelse(bp);
    brelse(bp2);
    return addr;
  }
  
  panic("bmap: out of range");
8010151a:	83 ec 0c             	sub    $0xc,%esp
8010151d:	68 d8 72 10 80       	push   $0x801072d8
80101522:	e8 49 ee ff ff       	call   80100370 <panic>
80101527:	89 f6                	mov    %esi,%esi
80101529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101530 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	56                   	push   %esi
80101534:	53                   	push   %ebx
80101535:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101538:	83 ec 08             	sub    $0x8,%esp
8010153b:	6a 01                	push   $0x1
8010153d:	ff 75 08             	pushl  0x8(%ebp)
80101540:	e8 8b eb ff ff       	call   801000d0 <bread>
80101545:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101547:	8d 40 5c             	lea    0x5c(%eax),%eax
8010154a:	83 c4 0c             	add    $0xc,%esp
8010154d:	6a 1c                	push   $0x1c
8010154f:	50                   	push   %eax
80101550:	56                   	push   %esi
80101551:	e8 da 30 00 00       	call   80104630 <memmove>
  brelse(bp);
80101556:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101559:	83 c4 10             	add    $0x10,%esp
}
8010155c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010155f:	5b                   	pop    %ebx
80101560:	5e                   	pop    %esi
80101561:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101562:	e9 79 ec ff ff       	jmp    801001e0 <brelse>
80101567:	89 f6                	mov    %esi,%esi
80101569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101570 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	53                   	push   %ebx
80101574:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101579:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010157c:	68 eb 72 10 80       	push   $0x801072eb
80101581:	68 e0 09 11 80       	push   $0x801109e0
80101586:	e8 95 2d 00 00       	call   80104320 <initlock>
8010158b:	83 c4 10             	add    $0x10,%esp
8010158e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101590:	83 ec 08             	sub    $0x8,%esp
80101593:	68 f2 72 10 80       	push   $0x801072f2
80101598:	53                   	push   %ebx
80101599:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010159f:	e8 4c 2c 00 00       	call   801041f0 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801015a4:	83 c4 10             	add    $0x10,%esp
801015a7:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801015ad:	75 e1                	jne    80101590 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801015af:	83 ec 08             	sub    $0x8,%esp
801015b2:	68 c0 09 11 80       	push   $0x801109c0
801015b7:	ff 75 08             	pushl  0x8(%ebp)
801015ba:	e8 71 ff ff ff       	call   80101530 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015bf:	ff 35 d8 09 11 80    	pushl  0x801109d8
801015c5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801015cb:	ff 35 d0 09 11 80    	pushl  0x801109d0
801015d1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801015d7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801015dd:	ff 35 c4 09 11 80    	pushl  0x801109c4
801015e3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801015e9:	68 58 73 10 80       	push   $0x80107358
801015ee:	e8 6d f0 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801015f3:	83 c4 30             	add    $0x30,%esp
801015f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015f9:	c9                   	leave  
801015fa:	c3                   	ret    
801015fb:	90                   	nop
801015fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101600 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	57                   	push   %edi
80101604:	56                   	push   %esi
80101605:	53                   	push   %ebx
80101606:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101609:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101610:	8b 45 0c             	mov    0xc(%ebp),%eax
80101613:	8b 75 08             	mov    0x8(%ebp),%esi
80101616:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101619:	0f 86 91 00 00 00    	jbe    801016b0 <ialloc+0xb0>
8010161f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101624:	eb 21                	jmp    80101647 <ialloc+0x47>
80101626:	8d 76 00             	lea    0x0(%esi),%esi
80101629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101630:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101633:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101636:	57                   	push   %edi
80101637:	e8 a4 eb ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010163c:	83 c4 10             	add    $0x10,%esp
8010163f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101645:	76 69                	jbe    801016b0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101647:	89 d8                	mov    %ebx,%eax
80101649:	83 ec 08             	sub    $0x8,%esp
8010164c:	c1 e8 03             	shr    $0x3,%eax
8010164f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101655:	50                   	push   %eax
80101656:	56                   	push   %esi
80101657:	e8 74 ea ff ff       	call   801000d0 <bread>
8010165c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010165e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101660:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101663:	83 e0 07             	and    $0x7,%eax
80101666:	c1 e0 06             	shl    $0x6,%eax
80101669:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010166d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101671:	75 bd                	jne    80101630 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101673:	83 ec 04             	sub    $0x4,%esp
80101676:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101679:	6a 40                	push   $0x40
8010167b:	6a 00                	push   $0x0
8010167d:	51                   	push   %ecx
8010167e:	e8 fd 2e 00 00       	call   80104580 <memset>
      dip->type = type;
80101683:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101687:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010168a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010168d:	89 3c 24             	mov    %edi,(%esp)
80101690:	e8 cb 17 00 00       	call   80102e60 <log_write>
      brelse(bp);
80101695:	89 3c 24             	mov    %edi,(%esp)
80101698:	e8 43 eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010169d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801016a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801016a3:	89 da                	mov    %ebx,%edx
801016a5:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801016a7:	5b                   	pop    %ebx
801016a8:	5e                   	pop    %esi
801016a9:	5f                   	pop    %edi
801016aa:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801016ab:	e9 d0 fb ff ff       	jmp    80101280 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016b0:	83 ec 0c             	sub    $0xc,%esp
801016b3:	68 f8 72 10 80       	push   $0x801072f8
801016b8:	e8 b3 ec ff ff       	call   80100370 <panic>
801016bd:	8d 76 00             	lea    0x0(%esi),%esi

801016c0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	56                   	push   %esi
801016c4:	53                   	push   %ebx
801016c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c8:	83 ec 08             	sub    $0x8,%esp
801016cb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016ce:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d1:	c1 e8 03             	shr    $0x3,%eax
801016d4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016da:	50                   	push   %eax
801016db:	ff 73 a4             	pushl  -0x5c(%ebx)
801016de:	e8 ed e9 ff ff       	call   801000d0 <bread>
801016e3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801016e8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016ec:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ef:	83 e0 07             	and    $0x7,%eax
801016f2:	c1 e0 06             	shl    $0x6,%eax
801016f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016f9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016fc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101700:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
80101703:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101707:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010170b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010170f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101713:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101717:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010171a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010171d:	6a 34                	push   $0x34
8010171f:	53                   	push   %ebx
80101720:	50                   	push   %eax
80101721:	e8 0a 2f 00 00       	call   80104630 <memmove>
  log_write(bp);
80101726:	89 34 24             	mov    %esi,(%esp)
80101729:	e8 32 17 00 00       	call   80102e60 <log_write>
  brelse(bp);
8010172e:	89 75 08             	mov    %esi,0x8(%ebp)
80101731:	83 c4 10             	add    $0x10,%esp
}
80101734:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101737:	5b                   	pop    %ebx
80101738:	5e                   	pop    %esi
80101739:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010173a:	e9 a1 ea ff ff       	jmp    801001e0 <brelse>
8010173f:	90                   	nop

80101740 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	53                   	push   %ebx
80101744:	83 ec 10             	sub    $0x10,%esp
80101747:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010174a:	68 e0 09 11 80       	push   $0x801109e0
8010174f:	e8 2c 2d 00 00       	call   80104480 <acquire>
  ip->ref++;
80101754:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101758:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010175f:	e8 cc 2d 00 00       	call   80104530 <release>
  return ip;
}
80101764:	89 d8                	mov    %ebx,%eax
80101766:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101769:	c9                   	leave  
8010176a:	c3                   	ret    
8010176b:	90                   	nop
8010176c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101770 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	56                   	push   %esi
80101774:	53                   	push   %ebx
80101775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101778:	85 db                	test   %ebx,%ebx
8010177a:	0f 84 b7 00 00 00    	je     80101837 <ilock+0xc7>
80101780:	8b 53 08             	mov    0x8(%ebx),%edx
80101783:	85 d2                	test   %edx,%edx
80101785:	0f 8e ac 00 00 00    	jle    80101837 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
8010178b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010178e:	83 ec 0c             	sub    $0xc,%esp
80101791:	50                   	push   %eax
80101792:	e8 99 2a 00 00       	call   80104230 <acquiresleep>

  if(ip->valid == 0){
80101797:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010179a:	83 c4 10             	add    $0x10,%esp
8010179d:	85 c0                	test   %eax,%eax
8010179f:	74 0f                	je     801017b0 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801017a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017a4:	5b                   	pop    %ebx
801017a5:	5e                   	pop    %esi
801017a6:	5d                   	pop    %ebp
801017a7:	c3                   	ret    
801017a8:	90                   	nop
801017a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017b0:	8b 43 04             	mov    0x4(%ebx),%eax
801017b3:	83 ec 08             	sub    $0x8,%esp
801017b6:	c1 e8 03             	shr    $0x3,%eax
801017b9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801017bf:	50                   	push   %eax
801017c0:	ff 33                	pushl  (%ebx)
801017c2:	e8 09 e9 ff ff       	call   801000d0 <bread>
801017c7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017c9:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017cc:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017cf:	83 e0 07             	and    $0x7,%eax
801017d2:	c1 e0 06             	shl    $0x6,%eax
801017d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017d9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017dc:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801017df:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017e3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017e7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017eb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017f3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017fb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017fe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101801:	6a 34                	push   $0x34
80101803:	50                   	push   %eax
80101804:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101807:	50                   	push   %eax
80101808:	e8 23 2e 00 00       	call   80104630 <memmove>
    brelse(bp);
8010180d:	89 34 24             	mov    %esi,(%esp)
80101810:	e8 cb e9 ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101815:	83 c4 10             	add    $0x10,%esp
80101818:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010181d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101824:	0f 85 77 ff ff ff    	jne    801017a1 <ilock+0x31>
      panic("ilock: no type");
8010182a:	83 ec 0c             	sub    $0xc,%esp
8010182d:	68 10 73 10 80       	push   $0x80107310
80101832:	e8 39 eb ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101837:	83 ec 0c             	sub    $0xc,%esp
8010183a:	68 0a 73 10 80       	push   $0x8010730a
8010183f:	e8 2c eb ff ff       	call   80100370 <panic>
80101844:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010184a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101850 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101850:	55                   	push   %ebp
80101851:	89 e5                	mov    %esp,%ebp
80101853:	56                   	push   %esi
80101854:	53                   	push   %ebx
80101855:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101858:	85 db                	test   %ebx,%ebx
8010185a:	74 28                	je     80101884 <iunlock+0x34>
8010185c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010185f:	83 ec 0c             	sub    $0xc,%esp
80101862:	56                   	push   %esi
80101863:	e8 68 2a 00 00       	call   801042d0 <holdingsleep>
80101868:	83 c4 10             	add    $0x10,%esp
8010186b:	85 c0                	test   %eax,%eax
8010186d:	74 15                	je     80101884 <iunlock+0x34>
8010186f:	8b 43 08             	mov    0x8(%ebx),%eax
80101872:	85 c0                	test   %eax,%eax
80101874:	7e 0e                	jle    80101884 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101876:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101879:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010187c:	5b                   	pop    %ebx
8010187d:	5e                   	pop    %esi
8010187e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010187f:	e9 0c 2a 00 00       	jmp    80104290 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101884:	83 ec 0c             	sub    $0xc,%esp
80101887:	68 1f 73 10 80       	push   $0x8010731f
8010188c:	e8 df ea ff ff       	call   80100370 <panic>
80101891:	eb 0d                	jmp    801018a0 <iput>
80101893:	90                   	nop
80101894:	90                   	nop
80101895:	90                   	nop
80101896:	90                   	nop
80101897:	90                   	nop
80101898:	90                   	nop
80101899:	90                   	nop
8010189a:	90                   	nop
8010189b:	90                   	nop
8010189c:	90                   	nop
8010189d:	90                   	nop
8010189e:	90                   	nop
8010189f:	90                   	nop

801018a0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801018a0:	55                   	push   %ebp
801018a1:	89 e5                	mov    %esp,%ebp
801018a3:	57                   	push   %edi
801018a4:	56                   	push   %esi
801018a5:	53                   	push   %ebx
801018a6:	83 ec 28             	sub    $0x28,%esp
801018a9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801018ac:	8d 7e 0c             	lea    0xc(%esi),%edi
801018af:	57                   	push   %edi
801018b0:	e8 7b 29 00 00       	call   80104230 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018b5:	8b 56 4c             	mov    0x4c(%esi),%edx
801018b8:	83 c4 10             	add    $0x10,%esp
801018bb:	85 d2                	test   %edx,%edx
801018bd:	74 07                	je     801018c6 <iput+0x26>
801018bf:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801018c4:	74 32                	je     801018f8 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
801018c6:	83 ec 0c             	sub    $0xc,%esp
801018c9:	57                   	push   %edi
801018ca:	e8 c1 29 00 00       	call   80104290 <releasesleep>

  acquire(&icache.lock);
801018cf:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018d6:	e8 a5 2b 00 00       	call   80104480 <acquire>
  ip->ref--;
801018db:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801018df:	83 c4 10             	add    $0x10,%esp
801018e2:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801018e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018ec:	5b                   	pop    %ebx
801018ed:	5e                   	pop    %esi
801018ee:	5f                   	pop    %edi
801018ef:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
801018f0:	e9 3b 2c 00 00       	jmp    80104530 <release>
801018f5:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
801018f8:	83 ec 0c             	sub    $0xc,%esp
801018fb:	68 e0 09 11 80       	push   $0x801109e0
80101900:	e8 7b 2b 00 00       	call   80104480 <acquire>
    int r = ip->ref;
80101905:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101908:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010190f:	e8 1c 2c 00 00       	call   80104530 <release>
    if(r == 1){
80101914:	83 c4 10             	add    $0x10,%esp
80101917:	83 fb 01             	cmp    $0x1,%ebx
8010191a:	75 aa                	jne    801018c6 <iput+0x26>
8010191c:	8d 8e 88 00 00 00    	lea    0x88(%esi),%ecx
80101922:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101925:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101928:	89 cf                	mov    %ecx,%edi
8010192a:	eb 0b                	jmp    80101937 <iput+0x97>
8010192c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101930:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101933:	39 fb                	cmp    %edi,%ebx
80101935:	74 19                	je     80101950 <iput+0xb0>
    if(ip->addrs[i]){
80101937:	8b 13                	mov    (%ebx),%edx
80101939:	85 d2                	test   %edx,%edx
8010193b:	74 f3                	je     80101930 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010193d:	8b 06                	mov    (%esi),%eax
8010193f:	e8 bc f7 ff ff       	call   80101100 <bfree>
      ip->addrs[i] = 0;
80101944:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010194a:	eb e4                	jmp    80101930 <iput+0x90>
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101950:	8b 86 88 00 00 00    	mov    0x88(%esi),%eax
80101956:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101959:	85 c0                	test   %eax,%eax
8010195b:	75 33                	jne    80101990 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010195d:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101960:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101967:	56                   	push   %esi
80101968:	e8 53 fd ff ff       	call   801016c0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010196d:	31 c0                	xor    %eax,%eax
8010196f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101973:	89 34 24             	mov    %esi,(%esp)
80101976:	e8 45 fd ff ff       	call   801016c0 <iupdate>
      ip->valid = 0;
8010197b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101982:	83 c4 10             	add    $0x10,%esp
80101985:	e9 3c ff ff ff       	jmp    801018c6 <iput+0x26>
8010198a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101990:	83 ec 08             	sub    $0x8,%esp
80101993:	50                   	push   %eax
80101994:	ff 36                	pushl  (%esi)
80101996:	e8 35 e7 ff ff       	call   801000d0 <bread>
8010199b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019a1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801019a7:	8d 58 5c             	lea    0x5c(%eax),%ebx
801019aa:	83 c4 10             	add    $0x10,%esp
801019ad:	89 cf                	mov    %ecx,%edi
801019af:	eb 0e                	jmp    801019bf <iput+0x11f>
801019b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019b8:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
801019bb:	39 fb                	cmp    %edi,%ebx
801019bd:	74 0f                	je     801019ce <iput+0x12e>
      if(a[j])
801019bf:	8b 13                	mov    (%ebx),%edx
801019c1:	85 d2                	test   %edx,%edx
801019c3:	74 f3                	je     801019b8 <iput+0x118>
        bfree(ip->dev, a[j]);
801019c5:	8b 06                	mov    (%esi),%eax
801019c7:	e8 34 f7 ff ff       	call   80101100 <bfree>
801019cc:	eb ea                	jmp    801019b8 <iput+0x118>
    }
    brelse(bp);
801019ce:	83 ec 0c             	sub    $0xc,%esp
801019d1:	ff 75 e4             	pushl  -0x1c(%ebp)
801019d4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019d7:	e8 04 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019dc:	8b 96 88 00 00 00    	mov    0x88(%esi),%edx
801019e2:	8b 06                	mov    (%esi),%eax
801019e4:	e8 17 f7 ff ff       	call   80101100 <bfree>
    ip->addrs[NDIRECT] = 0;
801019e9:	c7 86 88 00 00 00 00 	movl   $0x0,0x88(%esi)
801019f0:	00 00 00 
801019f3:	83 c4 10             	add    $0x10,%esp
801019f6:	e9 62 ff ff ff       	jmp    8010195d <iput+0xbd>
801019fb:	90                   	nop
801019fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a00 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101a00:	55                   	push   %ebp
80101a01:	89 e5                	mov    %esp,%ebp
80101a03:	53                   	push   %ebx
80101a04:	83 ec 10             	sub    $0x10,%esp
80101a07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a0a:	53                   	push   %ebx
80101a0b:	e8 40 fe ff ff       	call   80101850 <iunlock>
  iput(ip);
80101a10:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a13:	83 c4 10             	add    $0x10,%esp
}
80101a16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a19:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
80101a1a:	e9 81 fe ff ff       	jmp    801018a0 <iput>
80101a1f:	90                   	nop

80101a20 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	8b 55 08             	mov    0x8(%ebp),%edx
80101a26:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a29:	8b 0a                	mov    (%edx),%ecx
80101a2b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a2e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a31:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a34:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a38:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a3b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a3f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a43:	8b 52 58             	mov    0x58(%edx),%edx
80101a46:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a49:	5d                   	pop    %ebp
80101a4a:	c3                   	ret    
80101a4b:	90                   	nop
80101a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a50 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a50:	55                   	push   %ebp
80101a51:	89 e5                	mov    %esp,%ebp
80101a53:	57                   	push   %edi
80101a54:	56                   	push   %esi
80101a55:	53                   	push   %ebx
80101a56:	83 ec 1c             	sub    $0x1c,%esp
80101a59:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a5f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a62:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a67:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a6a:	8b 7d 14             	mov    0x14(%ebp),%edi
80101a6d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a70:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a73:	0f 84 a7 00 00 00    	je     80101b20 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a7c:	8b 40 58             	mov    0x58(%eax),%eax
80101a7f:	39 f0                	cmp    %esi,%eax
80101a81:	0f 82 c1 00 00 00    	jb     80101b48 <readi+0xf8>
80101a87:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a8a:	89 fa                	mov    %edi,%edx
80101a8c:	01 f2                	add    %esi,%edx
80101a8e:	0f 82 b4 00 00 00    	jb     80101b48 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a94:	89 c1                	mov    %eax,%ecx
80101a96:	29 f1                	sub    %esi,%ecx
80101a98:	39 d0                	cmp    %edx,%eax
80101a9a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a9d:	31 ff                	xor    %edi,%edi
80101a9f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aa1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aa4:	74 6d                	je     80101b13 <readi+0xc3>
80101aa6:	8d 76 00             	lea    0x0(%esi),%esi
80101aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ab0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ab3:	89 f2                	mov    %esi,%edx
80101ab5:	c1 ea 09             	shr    $0x9,%edx
80101ab8:	89 d8                	mov    %ebx,%eax
80101aba:	e8 91 f8 ff ff       	call   80101350 <bmap>
80101abf:	83 ec 08             	sub    $0x8,%esp
80101ac2:	50                   	push   %eax
80101ac3:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ac5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aca:	e8 01 e6 ff ff       	call   801000d0 <bread>
80101acf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ad1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ad4:	89 f1                	mov    %esi,%ecx
80101ad6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101adc:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
80101adf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae2:	29 cb                	sub    %ecx,%ebx
80101ae4:	29 f8                	sub    %edi,%eax
80101ae6:	39 c3                	cmp    %eax,%ebx
80101ae8:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101aeb:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
80101aef:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101af0:	01 df                	add    %ebx,%edi
80101af2:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101af4:	50                   	push   %eax
80101af5:	ff 75 e0             	pushl  -0x20(%ebp)
80101af8:	e8 33 2b 00 00       	call   80104630 <memmove>
    brelse(bp);
80101afd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b00:	89 14 24             	mov    %edx,(%esp)
80101b03:	e8 d8 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b08:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b0b:	83 c4 10             	add    $0x10,%esp
80101b0e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b11:	77 9d                	ja     80101ab0 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101b13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b19:	5b                   	pop    %ebx
80101b1a:	5e                   	pop    %esi
80101b1b:	5f                   	pop    %edi
80101b1c:	5d                   	pop    %ebp
80101b1d:	c3                   	ret    
80101b1e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b24:	66 83 f8 09          	cmp    $0x9,%ax
80101b28:	77 1e                	ja     80101b48 <readi+0xf8>
80101b2a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101b31:	85 c0                	test   %eax,%eax
80101b33:	74 13                	je     80101b48 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101b35:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101b38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b3b:	5b                   	pop    %ebx
80101b3c:	5e                   	pop    %esi
80101b3d:	5f                   	pop    %edi
80101b3e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101b3f:	ff e0                	jmp    *%eax
80101b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101b48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b4d:	eb c7                	jmp    80101b16 <readi+0xc6>
80101b4f:	90                   	nop

80101b50 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b50:	55                   	push   %ebp
80101b51:	89 e5                	mov    %esp,%ebp
80101b53:	57                   	push   %edi
80101b54:	56                   	push   %esi
80101b55:	53                   	push   %ebx
80101b56:	83 ec 1c             	sub    $0x1c,%esp
80101b59:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b5f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b62:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b67:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b6d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b70:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b73:	0f 84 b7 00 00 00    	je     80101c30 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b7c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b7f:	0f 82 eb 00 00 00    	jb     80101c70 <writei+0x120>
80101b85:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b88:	89 f8                	mov    %edi,%eax
80101b8a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b8c:	3d 00 16 81 00       	cmp    $0x811600,%eax
80101b91:	0f 87 d9 00 00 00    	ja     80101c70 <writei+0x120>
80101b97:	39 c6                	cmp    %eax,%esi
80101b99:	0f 87 d1 00 00 00    	ja     80101c70 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b9f:	85 ff                	test   %edi,%edi
80101ba1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ba8:	74 78                	je     80101c22 <writei+0xd2>
80101baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bb0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bb3:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101bb5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bba:	c1 ea 09             	shr    $0x9,%edx
80101bbd:	89 f8                	mov    %edi,%eax
80101bbf:	e8 8c f7 ff ff       	call   80101350 <bmap>
80101bc4:	83 ec 08             	sub    $0x8,%esp
80101bc7:	50                   	push   %eax
80101bc8:	ff 37                	pushl  (%edi)
80101bca:	e8 01 e5 ff ff       	call   801000d0 <bread>
80101bcf:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101bd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101bd4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101bd7:	89 f1                	mov    %esi,%ecx
80101bd9:	83 c4 0c             	add    $0xc,%esp
80101bdc:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101be2:	29 cb                	sub    %ecx,%ebx
80101be4:	39 c3                	cmp    %eax,%ebx
80101be6:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101be9:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101bed:	53                   	push   %ebx
80101bee:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bf1:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101bf3:	50                   	push   %eax
80101bf4:	e8 37 2a 00 00       	call   80104630 <memmove>
    log_write(bp);
80101bf9:	89 3c 24             	mov    %edi,(%esp)
80101bfc:	e8 5f 12 00 00       	call   80102e60 <log_write>
    brelse(bp);
80101c01:	89 3c 24             	mov    %edi,(%esp)
80101c04:	e8 d7 e5 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c09:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c0c:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c0f:	83 c4 10             	add    $0x10,%esp
80101c12:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c15:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101c18:	77 96                	ja     80101bb0 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101c1a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c1d:	3b 70 58             	cmp    0x58(%eax),%esi
80101c20:	77 36                	ja     80101c58 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c22:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c28:	5b                   	pop    %ebx
80101c29:	5e                   	pop    %esi
80101c2a:	5f                   	pop    %edi
80101c2b:	5d                   	pop    %ebp
80101c2c:	c3                   	ret    
80101c2d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c34:	66 83 f8 09          	cmp    $0x9,%ax
80101c38:	77 36                	ja     80101c70 <writei+0x120>
80101c3a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101c41:	85 c0                	test   %eax,%eax
80101c43:	74 2b                	je     80101c70 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101c45:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101c48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c4b:	5b                   	pop    %ebx
80101c4c:	5e                   	pop    %esi
80101c4d:	5f                   	pop    %edi
80101c4e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101c4f:	ff e0                	jmp    *%eax
80101c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101c58:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c5b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101c5e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c61:	50                   	push   %eax
80101c62:	e8 59 fa ff ff       	call   801016c0 <iupdate>
80101c67:	83 c4 10             	add    $0x10,%esp
80101c6a:	eb b6                	jmp    80101c22 <writei+0xd2>
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c75:	eb ae                	jmp    80101c25 <writei+0xd5>
80101c77:	89 f6                	mov    %esi,%esi
80101c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c80 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c80:	55                   	push   %ebp
80101c81:	89 e5                	mov    %esp,%ebp
80101c83:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c86:	6a 0e                	push   $0xe
80101c88:	ff 75 0c             	pushl  0xc(%ebp)
80101c8b:	ff 75 08             	pushl  0x8(%ebp)
80101c8e:	e8 1d 2a 00 00       	call   801046b0 <strncmp>
}
80101c93:	c9                   	leave  
80101c94:	c3                   	ret    
80101c95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ca0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ca0:	55                   	push   %ebp
80101ca1:	89 e5                	mov    %esp,%ebp
80101ca3:	57                   	push   %edi
80101ca4:	56                   	push   %esi
80101ca5:	53                   	push   %ebx
80101ca6:	83 ec 1c             	sub    $0x1c,%esp
80101ca9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cb1:	0f 85 80 00 00 00    	jne    80101d37 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cb7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cba:	31 ff                	xor    %edi,%edi
80101cbc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cbf:	85 d2                	test   %edx,%edx
80101cc1:	75 0d                	jne    80101cd0 <dirlookup+0x30>
80101cc3:	eb 5b                	jmp    80101d20 <dirlookup+0x80>
80101cc5:	8d 76 00             	lea    0x0(%esi),%esi
80101cc8:	83 c7 10             	add    $0x10,%edi
80101ccb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101cce:	76 50                	jbe    80101d20 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101cd0:	6a 10                	push   $0x10
80101cd2:	57                   	push   %edi
80101cd3:	56                   	push   %esi
80101cd4:	53                   	push   %ebx
80101cd5:	e8 76 fd ff ff       	call   80101a50 <readi>
80101cda:	83 c4 10             	add    $0x10,%esp
80101cdd:	83 f8 10             	cmp    $0x10,%eax
80101ce0:	75 48                	jne    80101d2a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101ce2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ce7:	74 df                	je     80101cc8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101ce9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cec:	83 ec 04             	sub    $0x4,%esp
80101cef:	6a 0e                	push   $0xe
80101cf1:	50                   	push   %eax
80101cf2:	ff 75 0c             	pushl  0xc(%ebp)
80101cf5:	e8 b6 29 00 00       	call   801046b0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101cfa:	83 c4 10             	add    $0x10,%esp
80101cfd:	85 c0                	test   %eax,%eax
80101cff:	75 c7                	jne    80101cc8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101d01:	8b 45 10             	mov    0x10(%ebp),%eax
80101d04:	85 c0                	test   %eax,%eax
80101d06:	74 05                	je     80101d0d <dirlookup+0x6d>
        *poff = off;
80101d08:	8b 45 10             	mov    0x10(%ebp),%eax
80101d0b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101d0d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101d11:	8b 03                	mov    (%ebx),%eax
80101d13:	e8 68 f5 ff ff       	call   80101280 <iget>
    }
  }

  return 0;
}
80101d18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d1b:	5b                   	pop    %ebx
80101d1c:	5e                   	pop    %esi
80101d1d:	5f                   	pop    %edi
80101d1e:	5d                   	pop    %ebp
80101d1f:	c3                   	ret    
80101d20:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101d23:	31 c0                	xor    %eax,%eax
}
80101d25:	5b                   	pop    %ebx
80101d26:	5e                   	pop    %esi
80101d27:	5f                   	pop    %edi
80101d28:	5d                   	pop    %ebp
80101d29:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101d2a:	83 ec 0c             	sub    $0xc,%esp
80101d2d:	68 39 73 10 80       	push   $0x80107339
80101d32:	e8 39 e6 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101d37:	83 ec 0c             	sub    $0xc,%esp
80101d3a:	68 27 73 10 80       	push   $0x80107327
80101d3f:	e8 2c e6 ff ff       	call   80100370 <panic>
80101d44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101d50 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d50:	55                   	push   %ebp
80101d51:	89 e5                	mov    %esp,%ebp
80101d53:	57                   	push   %edi
80101d54:	56                   	push   %esi
80101d55:	53                   	push   %ebx
80101d56:	89 cf                	mov    %ecx,%edi
80101d58:	89 c3                	mov    %eax,%ebx
80101d5a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d5d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d60:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101d63:	0f 84 53 01 00 00    	je     80101ebc <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d69:	e8 52 1b 00 00       	call   801038c0 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101d6e:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d71:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101d74:	68 e0 09 11 80       	push   $0x801109e0
80101d79:	e8 02 27 00 00       	call   80104480 <acquire>
  ip->ref++;
80101d7e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d82:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101d89:	e8 a2 27 00 00       	call   80104530 <release>
80101d8e:	83 c4 10             	add    $0x10,%esp
80101d91:	eb 08                	jmp    80101d9b <namex+0x4b>
80101d93:	90                   	nop
80101d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101d98:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101d9b:	0f b6 03             	movzbl (%ebx),%eax
80101d9e:	3c 2f                	cmp    $0x2f,%al
80101da0:	74 f6                	je     80101d98 <namex+0x48>
    path++;
  if(*path == 0)
80101da2:	84 c0                	test   %al,%al
80101da4:	0f 84 e3 00 00 00    	je     80101e8d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101daa:	0f b6 03             	movzbl (%ebx),%eax
80101dad:	89 da                	mov    %ebx,%edx
80101daf:	84 c0                	test   %al,%al
80101db1:	0f 84 ac 00 00 00    	je     80101e63 <namex+0x113>
80101db7:	3c 2f                	cmp    $0x2f,%al
80101db9:	75 09                	jne    80101dc4 <namex+0x74>
80101dbb:	e9 a3 00 00 00       	jmp    80101e63 <namex+0x113>
80101dc0:	84 c0                	test   %al,%al
80101dc2:	74 0a                	je     80101dce <namex+0x7e>
    path++;
80101dc4:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101dc7:	0f b6 02             	movzbl (%edx),%eax
80101dca:	3c 2f                	cmp    $0x2f,%al
80101dcc:	75 f2                	jne    80101dc0 <namex+0x70>
80101dce:	89 d1                	mov    %edx,%ecx
80101dd0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101dd2:	83 f9 0d             	cmp    $0xd,%ecx
80101dd5:	0f 8e 8d 00 00 00    	jle    80101e68 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101ddb:	83 ec 04             	sub    $0x4,%esp
80101dde:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101de1:	6a 0e                	push   $0xe
80101de3:	53                   	push   %ebx
80101de4:	57                   	push   %edi
80101de5:	e8 46 28 00 00       	call   80104630 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101dea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101ded:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101df0:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101df2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101df5:	75 11                	jne    80101e08 <namex+0xb8>
80101df7:	89 f6                	mov    %esi,%esi
80101df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101e00:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101e03:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e06:	74 f8                	je     80101e00 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e08:	83 ec 0c             	sub    $0xc,%esp
80101e0b:	56                   	push   %esi
80101e0c:	e8 5f f9 ff ff       	call   80101770 <ilock>
    if(ip->type != T_DIR){
80101e11:	83 c4 10             	add    $0x10,%esp
80101e14:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e19:	0f 85 7f 00 00 00    	jne    80101e9e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e1f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e22:	85 d2                	test   %edx,%edx
80101e24:	74 09                	je     80101e2f <namex+0xdf>
80101e26:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e29:	0f 84 a3 00 00 00    	je     80101ed2 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e2f:	83 ec 04             	sub    $0x4,%esp
80101e32:	6a 00                	push   $0x0
80101e34:	57                   	push   %edi
80101e35:	56                   	push   %esi
80101e36:	e8 65 fe ff ff       	call   80101ca0 <dirlookup>
80101e3b:	83 c4 10             	add    $0x10,%esp
80101e3e:	85 c0                	test   %eax,%eax
80101e40:	74 5c                	je     80101e9e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101e42:	83 ec 0c             	sub    $0xc,%esp
80101e45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101e48:	56                   	push   %esi
80101e49:	e8 02 fa ff ff       	call   80101850 <iunlock>
  iput(ip);
80101e4e:	89 34 24             	mov    %esi,(%esp)
80101e51:	e8 4a fa ff ff       	call   801018a0 <iput>
80101e56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e59:	83 c4 10             	add    $0x10,%esp
80101e5c:	89 c6                	mov    %eax,%esi
80101e5e:	e9 38 ff ff ff       	jmp    80101d9b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101e63:	31 c9                	xor    %ecx,%ecx
80101e65:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101e68:	83 ec 04             	sub    $0x4,%esp
80101e6b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e6e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101e71:	51                   	push   %ecx
80101e72:	53                   	push   %ebx
80101e73:	57                   	push   %edi
80101e74:	e8 b7 27 00 00       	call   80104630 <memmove>
    name[len] = 0;
80101e79:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e7c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e7f:	83 c4 10             	add    $0x10,%esp
80101e82:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e86:	89 d3                	mov    %edx,%ebx
80101e88:	e9 65 ff ff ff       	jmp    80101df2 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e90:	85 c0                	test   %eax,%eax
80101e92:	75 54                	jne    80101ee8 <namex+0x198>
80101e94:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101e96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e99:	5b                   	pop    %ebx
80101e9a:	5e                   	pop    %esi
80101e9b:	5f                   	pop    %edi
80101e9c:	5d                   	pop    %ebp
80101e9d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101e9e:	83 ec 0c             	sub    $0xc,%esp
80101ea1:	56                   	push   %esi
80101ea2:	e8 a9 f9 ff ff       	call   80101850 <iunlock>
  iput(ip);
80101ea7:	89 34 24             	mov    %esi,(%esp)
80101eaa:	e8 f1 f9 ff ff       	call   801018a0 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101eaf:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101eb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101eb5:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101eb7:	5b                   	pop    %ebx
80101eb8:	5e                   	pop    %esi
80101eb9:	5f                   	pop    %edi
80101eba:	5d                   	pop    %ebp
80101ebb:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101ebc:	ba 01 00 00 00       	mov    $0x1,%edx
80101ec1:	b8 01 00 00 00       	mov    $0x1,%eax
80101ec6:	e8 b5 f3 ff ff       	call   80101280 <iget>
80101ecb:	89 c6                	mov    %eax,%esi
80101ecd:	e9 c9 fe ff ff       	jmp    80101d9b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101ed2:	83 ec 0c             	sub    $0xc,%esp
80101ed5:	56                   	push   %esi
80101ed6:	e8 75 f9 ff ff       	call   80101850 <iunlock>
      return ip;
80101edb:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101ede:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101ee1:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101ee3:	5b                   	pop    %ebx
80101ee4:	5e                   	pop    %esi
80101ee5:	5f                   	pop    %edi
80101ee6:	5d                   	pop    %ebp
80101ee7:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	56                   	push   %esi
80101eec:	e8 af f9 ff ff       	call   801018a0 <iput>
    return 0;
80101ef1:	83 c4 10             	add    $0x10,%esp
80101ef4:	31 c0                	xor    %eax,%eax
80101ef6:	eb 9e                	jmp    80101e96 <namex+0x146>
80101ef8:	90                   	nop
80101ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101f00 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101f00:	55                   	push   %ebp
80101f01:	89 e5                	mov    %esp,%ebp
80101f03:	57                   	push   %edi
80101f04:	56                   	push   %esi
80101f05:	53                   	push   %ebx
80101f06:	83 ec 20             	sub    $0x20,%esp
80101f09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f0c:	6a 00                	push   $0x0
80101f0e:	ff 75 0c             	pushl  0xc(%ebp)
80101f11:	53                   	push   %ebx
80101f12:	e8 89 fd ff ff       	call   80101ca0 <dirlookup>
80101f17:	83 c4 10             	add    $0x10,%esp
80101f1a:	85 c0                	test   %eax,%eax
80101f1c:	75 67                	jne    80101f85 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f1e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f21:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f24:	85 ff                	test   %edi,%edi
80101f26:	74 29                	je     80101f51 <dirlink+0x51>
80101f28:	31 ff                	xor    %edi,%edi
80101f2a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f2d:	eb 09                	jmp    80101f38 <dirlink+0x38>
80101f2f:	90                   	nop
80101f30:	83 c7 10             	add    $0x10,%edi
80101f33:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101f36:	76 19                	jbe    80101f51 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f38:	6a 10                	push   $0x10
80101f3a:	57                   	push   %edi
80101f3b:	56                   	push   %esi
80101f3c:	53                   	push   %ebx
80101f3d:	e8 0e fb ff ff       	call   80101a50 <readi>
80101f42:	83 c4 10             	add    $0x10,%esp
80101f45:	83 f8 10             	cmp    $0x10,%eax
80101f48:	75 4e                	jne    80101f98 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101f4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f4f:	75 df                	jne    80101f30 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101f51:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f54:	83 ec 04             	sub    $0x4,%esp
80101f57:	6a 0e                	push   $0xe
80101f59:	ff 75 0c             	pushl  0xc(%ebp)
80101f5c:	50                   	push   %eax
80101f5d:	e8 be 27 00 00       	call   80104720 <strncpy>
  de.inum = inum;
80101f62:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f65:	6a 10                	push   $0x10
80101f67:	57                   	push   %edi
80101f68:	56                   	push   %esi
80101f69:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101f6a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f6e:	e8 dd fb ff ff       	call   80101b50 <writei>
80101f73:	83 c4 20             	add    $0x20,%esp
80101f76:	83 f8 10             	cmp    $0x10,%eax
80101f79:	75 2a                	jne    80101fa5 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101f7b:	31 c0                	xor    %eax,%eax
}
80101f7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f80:	5b                   	pop    %ebx
80101f81:	5e                   	pop    %esi
80101f82:	5f                   	pop    %edi
80101f83:	5d                   	pop    %ebp
80101f84:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101f85:	83 ec 0c             	sub    $0xc,%esp
80101f88:	50                   	push   %eax
80101f89:	e8 12 f9 ff ff       	call   801018a0 <iput>
    return -1;
80101f8e:	83 c4 10             	add    $0x10,%esp
80101f91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f96:	eb e5                	jmp    80101f7d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101f98:	83 ec 0c             	sub    $0xc,%esp
80101f9b:	68 48 73 10 80       	push   $0x80107348
80101fa0:	e8 cb e3 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101fa5:	83 ec 0c             	sub    $0xc,%esp
80101fa8:	68 66 79 10 80       	push   $0x80107966
80101fad:	e8 be e3 ff ff       	call   80100370 <panic>
80101fb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fc0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101fc0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101fc1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101fc3:	89 e5                	mov    %esp,%ebp
80101fc5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101fc8:	8b 45 08             	mov    0x8(%ebp),%eax
80101fcb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101fce:	e8 7d fd ff ff       	call   80101d50 <namex>
}
80101fd3:	c9                   	leave  
80101fd4:	c3                   	ret    
80101fd5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fe0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101fe0:	55                   	push   %ebp
  return namex(path, 1, name);
80101fe1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101fe6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101fe8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101feb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fee:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101fef:	e9 5c fd ff ff       	jmp    80101d50 <namex>
80101ff4:	66 90                	xchg   %ax,%ax
80101ff6:	66 90                	xchg   %ax,%ax
80101ff8:	66 90                	xchg   %ax,%ax
80101ffa:	66 90                	xchg   %ax,%ax
80101ffc:	66 90                	xchg   %ax,%ax
80101ffe:	66 90                	xchg   %ax,%ax

80102000 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102000:	55                   	push   %ebp
  if(b == 0)
80102001:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102003:	89 e5                	mov    %esp,%ebp
80102005:	56                   	push   %esi
80102006:	53                   	push   %ebx
  if(b == 0)
80102007:	0f 84 ad 00 00 00    	je     801020ba <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
8010200d:	8b 58 08             	mov    0x8(%eax),%ebx
80102010:	89 c1                	mov    %eax,%ecx
80102012:	81 fb 1f 4e 00 00    	cmp    $0x4e1f,%ebx
80102018:	0f 87 8f 00 00 00    	ja     801020ad <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010201e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102023:	90                   	nop
80102024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102028:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102029:	83 e0 c0             	and    $0xffffffc0,%eax
8010202c:	3c 40                	cmp    $0x40,%al
8010202e:	75 f8                	jne    80102028 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102030:	31 f6                	xor    %esi,%esi
80102032:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102037:	89 f0                	mov    %esi,%eax
80102039:	ee                   	out    %al,(%dx)
8010203a:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010203f:	b8 01 00 00 00       	mov    $0x1,%eax
80102044:	ee                   	out    %al,(%dx)
80102045:	ba f3 01 00 00       	mov    $0x1f3,%edx
8010204a:	89 d8                	mov    %ebx,%eax
8010204c:	ee                   	out    %al,(%dx)
8010204d:	89 d8                	mov    %ebx,%eax
8010204f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102054:	c1 f8 08             	sar    $0x8,%eax
80102057:	ee                   	out    %al,(%dx)
80102058:	ba f5 01 00 00       	mov    $0x1f5,%edx
8010205d:	89 f0                	mov    %esi,%eax
8010205f:	ee                   	out    %al,(%dx)
80102060:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80102064:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102069:	83 e0 01             	and    $0x1,%eax
8010206c:	c1 e0 04             	shl    $0x4,%eax
8010206f:	83 c8 e0             	or     $0xffffffe0,%eax
80102072:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80102073:	f6 01 04             	testb  $0x4,(%ecx)
80102076:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010207b:	75 13                	jne    80102090 <idestart+0x90>
8010207d:	b8 20 00 00 00       	mov    $0x20,%eax
80102082:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102083:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102086:	5b                   	pop    %ebx
80102087:	5e                   	pop    %esi
80102088:	5d                   	pop    %ebp
80102089:	c3                   	ret    
8010208a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102090:	b8 30 00 00 00       	mov    $0x30,%eax
80102095:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80102096:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
8010209b:	8d 71 5c             	lea    0x5c(%ecx),%esi
8010209e:	b9 80 00 00 00       	mov    $0x80,%ecx
801020a3:	fc                   	cld    
801020a4:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
801020a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801020a9:	5b                   	pop    %ebx
801020aa:	5e                   	pop    %esi
801020ab:	5d                   	pop    %ebp
801020ac:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
801020ad:	83 ec 0c             	sub    $0xc,%esp
801020b0:	68 b4 73 10 80       	push   $0x801073b4
801020b5:	e8 b6 e2 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
801020ba:	83 ec 0c             	sub    $0xc,%esp
801020bd:	68 ab 73 10 80       	push   $0x801073ab
801020c2:	e8 a9 e2 ff ff       	call   80100370 <panic>
801020c7:	89 f6                	mov    %esi,%esi
801020c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020d0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
801020d0:	55                   	push   %ebp
801020d1:	89 e5                	mov    %esp,%ebp
801020d3:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
801020d6:	68 c6 73 10 80       	push   $0x801073c6
801020db:	68 80 a5 10 80       	push   $0x8010a580
801020e0:	e8 3b 22 00 00       	call   80104320 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801020e5:	58                   	pop    %eax
801020e6:	a1 00 2d 11 80       	mov    0x80112d00,%eax
801020eb:	5a                   	pop    %edx
801020ec:	83 e8 01             	sub    $0x1,%eax
801020ef:	50                   	push   %eax
801020f0:	6a 0e                	push   $0xe
801020f2:	e8 a9 02 00 00       	call   801023a0 <ioapicenable>
801020f7:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020fa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020ff:	90                   	nop
80102100:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102101:	83 e0 c0             	and    $0xffffffc0,%eax
80102104:	3c 40                	cmp    $0x40,%al
80102106:	75 f8                	jne    80102100 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102108:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010210d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102112:	ee                   	out    %al,(%dx)
80102113:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102118:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010211d:	eb 06                	jmp    80102125 <ideinit+0x55>
8010211f:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102120:	83 e9 01             	sub    $0x1,%ecx
80102123:	74 0f                	je     80102134 <ideinit+0x64>
80102125:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102126:	84 c0                	test   %al,%al
80102128:	74 f6                	je     80102120 <ideinit+0x50>
      havedisk1 = 1;
8010212a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102131:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102134:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102139:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010213e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010213f:	c9                   	leave  
80102140:	c3                   	ret    
80102141:	eb 0d                	jmp    80102150 <ideintr>
80102143:	90                   	nop
80102144:	90                   	nop
80102145:	90                   	nop
80102146:	90                   	nop
80102147:	90                   	nop
80102148:	90                   	nop
80102149:	90                   	nop
8010214a:	90                   	nop
8010214b:	90                   	nop
8010214c:	90                   	nop
8010214d:	90                   	nop
8010214e:	90                   	nop
8010214f:	90                   	nop

80102150 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102150:	55                   	push   %ebp
80102151:	89 e5                	mov    %esp,%ebp
80102153:	57                   	push   %edi
80102154:	56                   	push   %esi
80102155:	53                   	push   %ebx
80102156:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102159:	68 80 a5 10 80       	push   $0x8010a580
8010215e:	e8 1d 23 00 00       	call   80104480 <acquire>
  //sti();
  if((b = idequeue) == 0){
80102163:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102169:	83 c4 10             	add    $0x10,%esp
8010216c:	85 db                	test   %ebx,%ebx
8010216e:	74 34                	je     801021a4 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102170:	8b 43 58             	mov    0x58(%ebx),%eax
80102173:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102178:	8b 33                	mov    (%ebx),%esi
8010217a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102180:	74 3e                	je     801021c0 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102182:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102185:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102188:	83 ce 02             	or     $0x2,%esi
8010218b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010218d:	53                   	push   %ebx
8010218e:	e8 ad 1e 00 00       	call   80104040 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102193:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102198:	83 c4 10             	add    $0x10,%esp
8010219b:	85 c0                	test   %eax,%eax
8010219d:	74 05                	je     801021a4 <ideintr+0x54>
    idestart(idequeue);
8010219f:	e8 5c fe ff ff       	call   80102000 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);
  //sti();
  if((b = idequeue) == 0){
    release(&idelock);
801021a4:	83 ec 0c             	sub    $0xc,%esp
801021a7:	68 80 a5 10 80       	push   $0x8010a580
801021ac:	e8 7f 23 00 00       	call   80104530 <release>
  if(idequeue != 0)
    idestart(idequeue);

  //cli();
  release(&idelock);
}
801021b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021b4:	5b                   	pop    %ebx
801021b5:	5e                   	pop    %esi
801021b6:	5f                   	pop    %edi
801021b7:	5d                   	pop    %ebp
801021b8:	c3                   	ret    
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021c0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021c5:	8d 76 00             	lea    0x0(%esi),%esi
801021c8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021c9:	89 c1                	mov    %eax,%ecx
801021cb:	83 e1 c0             	and    $0xffffffc0,%ecx
801021ce:	80 f9 40             	cmp    $0x40,%cl
801021d1:	75 f5                	jne    801021c8 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801021d3:	a8 21                	test   $0x21,%al
801021d5:	75 ab                	jne    80102182 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801021d7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801021da:	b9 80 00 00 00       	mov    $0x80,%ecx
801021df:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021e4:	fc                   	cld    
801021e5:	f3 6d                	rep insl (%dx),%es:(%edi)
801021e7:	8b 33                	mov    (%ebx),%esi
801021e9:	eb 97                	jmp    80102182 <ideintr+0x32>
801021eb:	90                   	nop
801021ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801021f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801021f0:	55                   	push   %ebp
801021f1:	89 e5                	mov    %esp,%ebp
801021f3:	53                   	push   %ebx
801021f4:	83 ec 10             	sub    $0x10,%esp
801021f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801021fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801021fd:	50                   	push   %eax
801021fe:	e8 cd 20 00 00       	call   801042d0 <holdingsleep>
80102203:	83 c4 10             	add    $0x10,%esp
80102206:	85 c0                	test   %eax,%eax
80102208:	0f 84 ad 00 00 00    	je     801022bb <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010220e:	8b 03                	mov    (%ebx),%eax
80102210:	83 e0 06             	and    $0x6,%eax
80102213:	83 f8 02             	cmp    $0x2,%eax
80102216:	0f 84 b9 00 00 00    	je     801022d5 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010221c:	8b 53 04             	mov    0x4(%ebx),%edx
8010221f:	85 d2                	test   %edx,%edx
80102221:	74 0d                	je     80102230 <iderw+0x40>
80102223:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102228:	85 c0                	test   %eax,%eax
8010222a:	0f 84 98 00 00 00    	je     801022c8 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102230:	83 ec 0c             	sub    $0xc,%esp
80102233:	68 80 a5 10 80       	push   $0x8010a580
80102238:	e8 43 22 00 00       	call   80104480 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010223d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102243:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102246:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010224d:	85 d2                	test   %edx,%edx
8010224f:	75 09                	jne    8010225a <iderw+0x6a>
80102251:	eb 58                	jmp    801022ab <iderw+0xbb>
80102253:	90                   	nop
80102254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102258:	89 c2                	mov    %eax,%edx
8010225a:	8b 42 58             	mov    0x58(%edx),%eax
8010225d:	85 c0                	test   %eax,%eax
8010225f:	75 f7                	jne    80102258 <iderw+0x68>
80102261:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102264:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102266:	3b 1d 64 a5 10 80    	cmp    0x8010a564,%ebx
8010226c:	74 44                	je     801022b2 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010226e:	8b 03                	mov    (%ebx),%eax
80102270:	83 e0 06             	and    $0x6,%eax
80102273:	83 f8 02             	cmp    $0x2,%eax
80102276:	74 23                	je     8010229b <iderw+0xab>
80102278:	90                   	nop
80102279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102280:	83 ec 08             	sub    $0x8,%esp
80102283:	68 80 a5 10 80       	push   $0x8010a580
80102288:	53                   	push   %ebx
80102289:	e8 f2 1b 00 00       	call   80103e80 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010228e:	8b 03                	mov    (%ebx),%eax
80102290:	83 c4 10             	add    $0x10,%esp
80102293:	83 e0 06             	and    $0x6,%eax
80102296:	83 f8 02             	cmp    $0x2,%eax
80102299:	75 e5                	jne    80102280 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
8010229b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801022a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801022a5:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
801022a6:	e9 85 22 00 00       	jmp    80104530 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022ab:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801022b0:	eb b2                	jmp    80102264 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801022b2:	89 d8                	mov    %ebx,%eax
801022b4:	e8 47 fd ff ff       	call   80102000 <idestart>
801022b9:	eb b3                	jmp    8010226e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801022bb:	83 ec 0c             	sub    $0xc,%esp
801022be:	68 ca 73 10 80       	push   $0x801073ca
801022c3:	e8 a8 e0 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801022c8:	83 ec 0c             	sub    $0xc,%esp
801022cb:	68 f5 73 10 80       	push   $0x801073f5
801022d0:	e8 9b e0 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801022d5:	83 ec 0c             	sub    $0xc,%esp
801022d8:	68 e0 73 10 80       	push   $0x801073e0
801022dd:	e8 8e e0 ff ff       	call   80100370 <panic>
801022e2:	66 90                	xchg   %ax,%ax
801022e4:	66 90                	xchg   %ax,%ax
801022e6:	66 90                	xchg   %ax,%ax
801022e8:	66 90                	xchg   %ax,%ax
801022ea:	66 90                	xchg   %ax,%ax
801022ec:	66 90                	xchg   %ax,%ax
801022ee:	66 90                	xchg   %ax,%ax

801022f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801022f0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801022f1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801022f8:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
801022fb:	89 e5                	mov    %esp,%ebp
801022fd:	56                   	push   %esi
801022fe:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801022ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102306:	00 00 00 
  return ioapic->data;
80102309:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010230f:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102312:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102318:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010231e:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102325:	89 f0                	mov    %esi,%eax
80102327:	c1 e8 10             	shr    $0x10,%eax
8010232a:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010232d:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102330:	c1 e8 18             	shr    $0x18,%eax
80102333:	39 d0                	cmp    %edx,%eax
80102335:	74 16                	je     8010234d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102337:	83 ec 0c             	sub    $0xc,%esp
8010233a:	68 14 74 10 80       	push   $0x80107414
8010233f:	e8 1c e3 ff ff       	call   80100660 <cprintf>
80102344:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010234a:	83 c4 10             	add    $0x10,%esp
8010234d:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102350:	ba 10 00 00 00       	mov    $0x10,%edx
80102355:	b8 20 00 00 00       	mov    $0x20,%eax
8010235a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102360:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102362:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102368:	89 c3                	mov    %eax,%ebx
8010236a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102370:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102373:	89 59 10             	mov    %ebx,0x10(%ecx)
80102376:	8d 5a 01             	lea    0x1(%edx),%ebx
80102379:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010237c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010237e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102380:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102386:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010238d:	75 d1                	jne    80102360 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010238f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102392:	5b                   	pop    %ebx
80102393:	5e                   	pop    %esi
80102394:	5d                   	pop    %ebp
80102395:	c3                   	ret    
80102396:	8d 76 00             	lea    0x0(%esi),%esi
80102399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801023a0:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801023a1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
801023a7:	89 e5                	mov    %esp,%ebp
801023a9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801023ac:	8d 50 20             	lea    0x20(%eax),%edx
801023af:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801023b3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023b5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801023bb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801023be:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023c1:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801023c4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023c6:	a1 34 26 11 80       	mov    0x80112634,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023cb:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801023ce:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801023d1:	5d                   	pop    %ebp
801023d2:	c3                   	ret    
801023d3:	66 90                	xchg   %ax,%ax
801023d5:	66 90                	xchg   %ax,%ax
801023d7:	66 90                	xchg   %ax,%ax
801023d9:	66 90                	xchg   %ax,%ax
801023db:	66 90                	xchg   %ax,%ax
801023dd:	66 90                	xchg   %ax,%ax
801023df:	90                   	nop

801023e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	53                   	push   %ebx
801023e4:	83 ec 04             	sub    $0x4,%esp
801023e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801023ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801023f0:	75 70                	jne    80102462 <kfree+0x82>
801023f2:	81 fb a8 57 11 80    	cmp    $0x801157a8,%ebx
801023f8:	72 68                	jb     80102462 <kfree+0x82>
801023fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102400:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102405:	77 5b                	ja     80102462 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102407:	83 ec 04             	sub    $0x4,%esp
8010240a:	68 00 10 00 00       	push   $0x1000
8010240f:	6a 01                	push   $0x1
80102411:	53                   	push   %ebx
80102412:	e8 69 21 00 00       	call   80104580 <memset>

  if(kmem.use_lock)
80102417:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010241d:	83 c4 10             	add    $0x10,%esp
80102420:	85 d2                	test   %edx,%edx
80102422:	75 2c                	jne    80102450 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102424:	a1 78 26 11 80       	mov    0x80112678,%eax
80102429:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010242b:	a1 74 26 11 80       	mov    0x80112674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102430:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102436:	85 c0                	test   %eax,%eax
80102438:	75 06                	jne    80102440 <kfree+0x60>
    release(&kmem.lock);
}
8010243a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010243d:	c9                   	leave  
8010243e:	c3                   	ret    
8010243f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102440:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102447:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010244a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010244b:	e9 e0 20 00 00       	jmp    80104530 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102450:	83 ec 0c             	sub    $0xc,%esp
80102453:	68 40 26 11 80       	push   $0x80112640
80102458:	e8 23 20 00 00       	call   80104480 <acquire>
8010245d:	83 c4 10             	add    $0x10,%esp
80102460:	eb c2                	jmp    80102424 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102462:	83 ec 0c             	sub    $0xc,%esp
80102465:	68 46 74 10 80       	push   $0x80107446
8010246a:	e8 01 df ff ff       	call   80100370 <panic>
8010246f:	90                   	nop

80102470 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	56                   	push   %esi
80102474:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102475:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102478:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010247b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102481:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102487:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010248d:	39 de                	cmp    %ebx,%esi
8010248f:	72 23                	jb     801024b4 <freerange+0x44>
80102491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102498:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010249e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024a7:	50                   	push   %eax
801024a8:	e8 33 ff ff ff       	call   801023e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024ad:	83 c4 10             	add    $0x10,%esp
801024b0:	39 f3                	cmp    %esi,%ebx
801024b2:	76 e4                	jbe    80102498 <freerange+0x28>
    kfree(p);
}
801024b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024b7:	5b                   	pop    %ebx
801024b8:	5e                   	pop    %esi
801024b9:	5d                   	pop    %ebp
801024ba:	c3                   	ret    
801024bb:	90                   	nop
801024bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801024c0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	56                   	push   %esi
801024c4:	53                   	push   %ebx
801024c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801024c8:	83 ec 08             	sub    $0x8,%esp
801024cb:	68 4c 74 10 80       	push   $0x8010744c
801024d0:	68 40 26 11 80       	push   $0x80112640
801024d5:	e8 46 1e 00 00       	call   80104320 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801024da:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024dd:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801024e0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801024e7:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801024ea:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024f0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024f6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024fc:	39 de                	cmp    %ebx,%esi
801024fe:	72 1c                	jb     8010251c <kinit1+0x5c>
    kfree(p);
80102500:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102506:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102509:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010250f:	50                   	push   %eax
80102510:	e8 cb fe ff ff       	call   801023e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102515:	83 c4 10             	add    $0x10,%esp
80102518:	39 de                	cmp    %ebx,%esi
8010251a:	73 e4                	jae    80102500 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010251c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010251f:	5b                   	pop    %ebx
80102520:	5e                   	pop    %esi
80102521:	5d                   	pop    %ebp
80102522:	c3                   	ret    
80102523:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102530 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102530:	55                   	push   %ebp
80102531:	89 e5                	mov    %esp,%ebp
80102533:	56                   	push   %esi
80102534:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102535:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102538:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010253b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102541:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102547:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010254d:	39 de                	cmp    %ebx,%esi
8010254f:	72 23                	jb     80102574 <kinit2+0x44>
80102551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102558:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010255e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102561:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102567:	50                   	push   %eax
80102568:	e8 73 fe ff ff       	call   801023e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010256d:	83 c4 10             	add    $0x10,%esp
80102570:	39 de                	cmp    %ebx,%esi
80102572:	73 e4                	jae    80102558 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102574:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010257b:	00 00 00 
}
8010257e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102581:	5b                   	pop    %ebx
80102582:	5e                   	pop    %esi
80102583:	5d                   	pop    %ebp
80102584:	c3                   	ret    
80102585:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102590 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	53                   	push   %ebx
80102594:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102597:	a1 74 26 11 80       	mov    0x80112674,%eax
8010259c:	85 c0                	test   %eax,%eax
8010259e:	75 30                	jne    801025d0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801025a0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801025a6:	85 db                	test   %ebx,%ebx
801025a8:	74 1c                	je     801025c6 <kalloc+0x36>
    kmem.freelist = r->next;
801025aa:	8b 13                	mov    (%ebx),%edx
801025ac:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801025b2:	85 c0                	test   %eax,%eax
801025b4:	74 10                	je     801025c6 <kalloc+0x36>
    release(&kmem.lock);
801025b6:	83 ec 0c             	sub    $0xc,%esp
801025b9:	68 40 26 11 80       	push   $0x80112640
801025be:	e8 6d 1f 00 00       	call   80104530 <release>
801025c3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
801025c6:	89 d8                	mov    %ebx,%eax
801025c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025cb:	c9                   	leave  
801025cc:	c3                   	ret    
801025cd:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801025d0:	83 ec 0c             	sub    $0xc,%esp
801025d3:	68 40 26 11 80       	push   $0x80112640
801025d8:	e8 a3 1e 00 00       	call   80104480 <acquire>
  r = kmem.freelist;
801025dd:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801025e3:	83 c4 10             	add    $0x10,%esp
801025e6:	a1 74 26 11 80       	mov    0x80112674,%eax
801025eb:	85 db                	test   %ebx,%ebx
801025ed:	75 bb                	jne    801025aa <kalloc+0x1a>
801025ef:	eb c1                	jmp    801025b2 <kalloc+0x22>
801025f1:	66 90                	xchg   %ax,%ax
801025f3:	66 90                	xchg   %ax,%ax
801025f5:	66 90                	xchg   %ax,%ax
801025f7:	66 90                	xchg   %ax,%ax
801025f9:	66 90                	xchg   %ax,%ax
801025fb:	66 90                	xchg   %ax,%ax
801025fd:	66 90                	xchg   %ax,%ax
801025ff:	90                   	nop

80102600 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102600:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102601:	ba 64 00 00 00       	mov    $0x64,%edx
80102606:	89 e5                	mov    %esp,%ebp
80102608:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102609:	a8 01                	test   $0x1,%al
8010260b:	0f 84 af 00 00 00    	je     801026c0 <kbdgetc+0xc0>
80102611:	ba 60 00 00 00       	mov    $0x60,%edx
80102616:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102617:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010261a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102620:	74 7e                	je     801026a0 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102622:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102624:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010262a:	79 24                	jns    80102650 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010262c:	f6 c1 40             	test   $0x40,%cl
8010262f:	75 05                	jne    80102636 <kbdgetc+0x36>
80102631:	89 c2                	mov    %eax,%edx
80102633:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102636:	0f b6 82 80 75 10 80 	movzbl -0x7fef8a80(%edx),%eax
8010263d:	83 c8 40             	or     $0x40,%eax
80102640:	0f b6 c0             	movzbl %al,%eax
80102643:	f7 d0                	not    %eax
80102645:	21 c8                	and    %ecx,%eax
80102647:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010264c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010264e:	5d                   	pop    %ebp
8010264f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102650:	f6 c1 40             	test   $0x40,%cl
80102653:	74 09                	je     8010265e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102655:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102658:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010265b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010265e:	0f b6 82 80 75 10 80 	movzbl -0x7fef8a80(%edx),%eax
80102665:	09 c1                	or     %eax,%ecx
80102667:	0f b6 82 80 74 10 80 	movzbl -0x7fef8b80(%edx),%eax
8010266e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102670:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102672:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102678:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010267b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010267e:	8b 04 85 60 74 10 80 	mov    -0x7fef8ba0(,%eax,4),%eax
80102685:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102689:	74 c3                	je     8010264e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010268b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010268e:	83 fa 19             	cmp    $0x19,%edx
80102691:	77 1d                	ja     801026b0 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102693:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102696:	5d                   	pop    %ebp
80102697:	c3                   	ret    
80102698:	90                   	nop
80102699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
801026a0:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801026a2:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801026a9:	5d                   	pop    %ebp
801026aa:	c3                   	ret    
801026ab:	90                   	nop
801026ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801026b0:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801026b3:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
801026b6:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
801026b7:	83 f9 19             	cmp    $0x19,%ecx
801026ba:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
801026bd:	c3                   	ret    
801026be:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801026c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801026c5:	5d                   	pop    %ebp
801026c6:	c3                   	ret    
801026c7:	89 f6                	mov    %esi,%esi
801026c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026d0 <kbdintr>:

void
kbdintr(void)
{
801026d0:	55                   	push   %ebp
801026d1:	89 e5                	mov    %esp,%ebp
801026d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801026d6:	68 00 26 10 80       	push   $0x80102600
801026db:	e8 10 e1 ff ff       	call   801007f0 <consoleintr>
}
801026e0:	83 c4 10             	add    $0x10,%esp
801026e3:	c9                   	leave  
801026e4:	c3                   	ret    
801026e5:	66 90                	xchg   %ax,%ax
801026e7:	66 90                	xchg   %ax,%ax
801026e9:	66 90                	xchg   %ax,%ax
801026eb:	66 90                	xchg   %ax,%ax
801026ed:	66 90                	xchg   %ax,%ax
801026ef:	90                   	nop

801026f0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801026f0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801026f5:	55                   	push   %ebp
801026f6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801026f8:	85 c0                	test   %eax,%eax
801026fa:	0f 84 c8 00 00 00    	je     801027c8 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102700:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102707:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010270a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010270d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102714:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102717:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010271a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102721:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102724:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102727:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010272e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102731:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102734:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010273b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010273e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102741:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102748:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010274b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010274e:	8b 50 30             	mov    0x30(%eax),%edx
80102751:	c1 ea 10             	shr    $0x10,%edx
80102754:	80 fa 03             	cmp    $0x3,%dl
80102757:	77 77                	ja     801027d0 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102759:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102760:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102763:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102766:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010276d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102770:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102773:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010277a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010277d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102780:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102787:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010278a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010278d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102794:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102797:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010279a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801027a1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801027a4:	8b 50 20             	mov    0x20(%eax),%edx
801027a7:	89 f6                	mov    %esi,%esi
801027a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801027b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801027b6:	80 e6 10             	and    $0x10,%dh
801027b9:	75 f5                	jne    801027b0 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801027c2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027c5:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801027c8:	5d                   	pop    %ebp
801027c9:	c3                   	ret    
801027ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801027d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027da:	8b 50 20             	mov    0x20(%eax),%edx
801027dd:	e9 77 ff ff ff       	jmp    80102759 <lapicinit+0x69>
801027e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027f0 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
801027f0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
801027f5:	55                   	push   %ebp
801027f6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801027f8:	85 c0                	test   %eax,%eax
801027fa:	74 0c                	je     80102808 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801027fc:	8b 40 20             	mov    0x20(%eax),%eax
}
801027ff:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102800:	c1 e8 18             	shr    $0x18,%eax
}
80102803:	c3                   	ret    
80102804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102808:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
8010280a:	5d                   	pop    %ebp
8010280b:	c3                   	ret    
8010280c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102810 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102810:	a1 7c 26 11 80       	mov    0x8011267c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102815:	55                   	push   %ebp
80102816:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102818:	85 c0                	test   %eax,%eax
8010281a:	74 0d                	je     80102829 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010281c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102823:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102826:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102829:	5d                   	pop    %ebp
8010282a:	c3                   	ret    
8010282b:	90                   	nop
8010282c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102830 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102830:	55                   	push   %ebp
80102831:	89 e5                	mov    %esp,%ebp
}
80102833:	5d                   	pop    %ebp
80102834:	c3                   	ret    
80102835:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102840 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102840:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102841:	ba 70 00 00 00       	mov    $0x70,%edx
80102846:	b8 0f 00 00 00       	mov    $0xf,%eax
8010284b:	89 e5                	mov    %esp,%ebp
8010284d:	53                   	push   %ebx
8010284e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102851:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102854:	ee                   	out    %al,(%dx)
80102855:	ba 71 00 00 00       	mov    $0x71,%edx
8010285a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010285f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102860:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102862:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102865:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010286b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010286d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102870:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102873:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102875:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102878:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010287e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102883:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102889:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010288c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102893:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102896:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102899:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801028a0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a3:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028a6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028ac:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028af:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028b5:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028b8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028be:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028c1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028c7:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801028ca:	5b                   	pop    %ebx
801028cb:	5d                   	pop    %ebp
801028cc:	c3                   	ret    
801028cd:	8d 76 00             	lea    0x0(%esi),%esi

801028d0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801028d0:	55                   	push   %ebp
801028d1:	ba 70 00 00 00       	mov    $0x70,%edx
801028d6:	b8 0b 00 00 00       	mov    $0xb,%eax
801028db:	89 e5                	mov    %esp,%ebp
801028dd:	57                   	push   %edi
801028de:	56                   	push   %esi
801028df:	53                   	push   %ebx
801028e0:	83 ec 4c             	sub    $0x4c,%esp
801028e3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028e4:	ba 71 00 00 00       	mov    $0x71,%edx
801028e9:	ec                   	in     (%dx),%al
801028ea:	83 e0 04             	and    $0x4,%eax
801028ed:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f0:	31 db                	xor    %ebx,%ebx
801028f2:	88 45 b7             	mov    %al,-0x49(%ebp)
801028f5:	bf 70 00 00 00       	mov    $0x70,%edi
801028fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102900:	89 d8                	mov    %ebx,%eax
80102902:	89 fa                	mov    %edi,%edx
80102904:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102905:	b9 71 00 00 00       	mov    $0x71,%ecx
8010290a:	89 ca                	mov    %ecx,%edx
8010290c:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010290d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102910:	89 fa                	mov    %edi,%edx
80102912:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102915:	b8 02 00 00 00       	mov    $0x2,%eax
8010291a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010291b:	89 ca                	mov    %ecx,%edx
8010291d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
8010291e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102921:	89 fa                	mov    %edi,%edx
80102923:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102926:	b8 04 00 00 00       	mov    $0x4,%eax
8010292b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010292c:	89 ca                	mov    %ecx,%edx
8010292e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
8010292f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102932:	89 fa                	mov    %edi,%edx
80102934:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102937:	b8 07 00 00 00       	mov    $0x7,%eax
8010293c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010293d:	89 ca                	mov    %ecx,%edx
8010293f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102940:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102943:	89 fa                	mov    %edi,%edx
80102945:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102948:	b8 08 00 00 00       	mov    $0x8,%eax
8010294d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010294e:	89 ca                	mov    %ecx,%edx
80102950:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102951:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102954:	89 fa                	mov    %edi,%edx
80102956:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102959:	b8 09 00 00 00       	mov    $0x9,%eax
8010295e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010295f:	89 ca                	mov    %ecx,%edx
80102961:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102962:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102965:	89 fa                	mov    %edi,%edx
80102967:	89 45 cc             	mov    %eax,-0x34(%ebp)
8010296a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010296f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102970:	89 ca                	mov    %ecx,%edx
80102972:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102973:	84 c0                	test   %al,%al
80102975:	78 89                	js     80102900 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102977:	89 d8                	mov    %ebx,%eax
80102979:	89 fa                	mov    %edi,%edx
8010297b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010297c:	89 ca                	mov    %ecx,%edx
8010297e:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010297f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102982:	89 fa                	mov    %edi,%edx
80102984:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102987:	b8 02 00 00 00       	mov    $0x2,%eax
8010298c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010298d:	89 ca                	mov    %ecx,%edx
8010298f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102990:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102993:	89 fa                	mov    %edi,%edx
80102995:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102998:	b8 04 00 00 00       	mov    $0x4,%eax
8010299d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010299e:	89 ca                	mov    %ecx,%edx
801029a0:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
801029a1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029a4:	89 fa                	mov    %edi,%edx
801029a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801029a9:	b8 07 00 00 00       	mov    $0x7,%eax
801029ae:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029af:	89 ca                	mov    %ecx,%edx
801029b1:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
801029b2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b5:	89 fa                	mov    %edi,%edx
801029b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801029ba:	b8 08 00 00 00       	mov    $0x8,%eax
801029bf:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c0:	89 ca                	mov    %ecx,%edx
801029c2:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
801029c3:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c6:	89 fa                	mov    %edi,%edx
801029c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801029cb:	b8 09 00 00 00       	mov    $0x9,%eax
801029d0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d1:	89 ca                	mov    %ecx,%edx
801029d3:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
801029d4:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801029d7:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
801029da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801029dd:	8d 45 b8             	lea    -0x48(%ebp),%eax
801029e0:	6a 18                	push   $0x18
801029e2:	56                   	push   %esi
801029e3:	50                   	push   %eax
801029e4:	e8 e7 1b 00 00       	call   801045d0 <memcmp>
801029e9:	83 c4 10             	add    $0x10,%esp
801029ec:	85 c0                	test   %eax,%eax
801029ee:	0f 85 0c ff ff ff    	jne    80102900 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
801029f4:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801029f8:	75 78                	jne    80102a72 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801029fa:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029fd:	89 c2                	mov    %eax,%edx
801029ff:	83 e0 0f             	and    $0xf,%eax
80102a02:	c1 ea 04             	shr    $0x4,%edx
80102a05:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a08:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a0b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102a0e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a11:	89 c2                	mov    %eax,%edx
80102a13:	83 e0 0f             	and    $0xf,%eax
80102a16:	c1 ea 04             	shr    $0x4,%edx
80102a19:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a1c:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a1f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102a22:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a25:	89 c2                	mov    %eax,%edx
80102a27:	83 e0 0f             	and    $0xf,%eax
80102a2a:	c1 ea 04             	shr    $0x4,%edx
80102a2d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a30:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a33:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102a36:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a39:	89 c2                	mov    %eax,%edx
80102a3b:	83 e0 0f             	and    $0xf,%eax
80102a3e:	c1 ea 04             	shr    $0x4,%edx
80102a41:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a44:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a47:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102a4a:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a4d:	89 c2                	mov    %eax,%edx
80102a4f:	83 e0 0f             	and    $0xf,%eax
80102a52:	c1 ea 04             	shr    $0x4,%edx
80102a55:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a58:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a5b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102a5e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a61:	89 c2                	mov    %eax,%edx
80102a63:	83 e0 0f             	and    $0xf,%eax
80102a66:	c1 ea 04             	shr    $0x4,%edx
80102a69:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a6c:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a6f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102a72:	8b 75 08             	mov    0x8(%ebp),%esi
80102a75:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a78:	89 06                	mov    %eax,(%esi)
80102a7a:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a7d:	89 46 04             	mov    %eax,0x4(%esi)
80102a80:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a83:	89 46 08             	mov    %eax,0x8(%esi)
80102a86:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a89:	89 46 0c             	mov    %eax,0xc(%esi)
80102a8c:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a8f:	89 46 10             	mov    %eax,0x10(%esi)
80102a92:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a95:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a98:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102aa2:	5b                   	pop    %ebx
80102aa3:	5e                   	pop    %esi
80102aa4:	5f                   	pop    %edi
80102aa5:	5d                   	pop    %ebp
80102aa6:	c3                   	ret    
80102aa7:	66 90                	xchg   %ax,%ax
80102aa9:	66 90                	xchg   %ax,%ax
80102aab:	66 90                	xchg   %ax,%ax
80102aad:	66 90                	xchg   %ax,%ax
80102aaf:	90                   	nop

80102ab0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ab0:	55                   	push   %ebp
80102ab1:	89 e5                	mov    %esp,%ebp
80102ab3:	53                   	push   %ebx
80102ab4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ab7:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102abd:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102ac3:	e8 08 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ac8:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ace:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102ad1:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ad3:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ad5:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ad8:	7e 1f                	jle    80102af9 <write_head+0x49>
80102ada:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102ae1:	31 d2                	xor    %edx,%edx
80102ae3:	90                   	nop
80102ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102ae8:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102aee:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102af2:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102af5:	39 c2                	cmp    %eax,%edx
80102af7:	75 ef                	jne    80102ae8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102af9:	83 ec 0c             	sub    $0xc,%esp
80102afc:	53                   	push   %ebx
80102afd:	e8 9e d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b02:	89 1c 24             	mov    %ebx,(%esp)
80102b05:	e8 d6 d6 ff ff       	call   801001e0 <brelse>
}
80102b0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b0d:	c9                   	leave  
80102b0e:	c3                   	ret    
80102b0f:	90                   	nop

80102b10 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
80102b13:	57                   	push   %edi
80102b14:	56                   	push   %esi
80102b15:	53                   	push   %ebx
80102b16:	83 ec 34             	sub    $0x34,%esp
80102b19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102b1c:	68 80 76 10 80       	push   $0x80107680
80102b21:	68 80 26 11 80       	push   $0x80112680
80102b26:	e8 f5 17 00 00       	call   80104320 <initlock>
  readsb(dev, &sb);
80102b2b:	5f                   	pop    %edi
80102b2c:	58                   	pop    %eax
80102b2d:	8d 45 cc             	lea    -0x34(%ebp),%eax
80102b30:	50                   	push   %eax
80102b31:	53                   	push   %ebx
80102b32:	e8 f9 e9 ff ff       	call   80101530 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b37:	8b 55 d8             	mov    -0x28(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  log.size = sb.nlog;
  log.dev = dev;
80102b3d:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b43:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b49:	a3 b4 26 11 80       	mov    %eax,0x801126b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b4e:	5a                   	pop    %edx
80102b4f:	59                   	pop    %ecx
80102b50:	50                   	push   %eax
80102b51:	53                   	push   %ebx
80102b52:	e8 79 d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b57:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102b5a:	83 c4 10             	add    $0x10,%esp
80102b5d:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b5f:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102b65:	7e 1a                	jle    80102b81 <initlog+0x71>
80102b67:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102b6e:	31 d2                	xor    %edx,%edx
    log.lh.block[i] = lh->block[i];
80102b70:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b74:	83 c2 04             	add    $0x4,%edx
80102b77:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b7d:	39 d3                	cmp    %edx,%ebx
80102b7f:	75 ef                	jne    80102b70 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b81:	83 ec 0c             	sub    $0xc,%esp
80102b84:	50                   	push   %eax
80102b85:	e8 56 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();      
  cprintf("recovery: n=%d but ignoring\n", log.lh.n);
80102b8a:	59                   	pop    %ecx
80102b8b:	5b                   	pop    %ebx
80102b8c:	ff 35 c8 26 11 80    	pushl  0x801126c8
80102b92:	68 84 76 10 80       	push   $0x80107684
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b97:	31 db                	xor    %ebx,%ebx

static void
recover_from_log(void)
{
  read_head();      
  cprintf("recovery: n=%d but ignoring\n", log.lh.n);
80102b99:	e8 c2 da ff ff       	call   80100660 <cprintf>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b9e:	8b 35 c8 26 11 80    	mov    0x801126c8,%esi
80102ba4:	83 c4 10             	add    $0x10,%esp
80102ba7:	85 f6                	test   %esi,%esi
80102ba9:	7e 71                	jle    80102c1c <initlog+0x10c>
80102bab:	90                   	nop
80102bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bb0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102bb5:	83 ec 08             	sub    $0x8,%esp
80102bb8:	01 d8                	add    %ebx,%eax
80102bba:	83 c0 01             	add    $0x1,%eax
80102bbd:	50                   	push   %eax
80102bbe:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102bc4:	e8 07 d5 ff ff       	call   801000d0 <bread>
80102bc9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bcb:	58                   	pop    %eax
80102bcc:	5a                   	pop    %edx
80102bcd:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102bd4:	ff 35 c4 26 11 80    	pushl  0x801126c4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bda:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdd:	e8 ee d4 ff ff       	call   801000d0 <bread>
80102be2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102be4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102be7:	83 c4 0c             	add    $0xc,%esp
80102bea:	68 00 02 00 00       	push   $0x200
80102bef:	50                   	push   %eax
80102bf0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bf3:	50                   	push   %eax
80102bf4:	e8 37 1a 00 00       	call   80104630 <memmove>
    bwrite(dbuf);  // write dst to disk
80102bf9:	89 34 24             	mov    %esi,(%esp)
80102bfc:	e8 9f d5 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102c01:	89 3c 24             	mov    %edi,(%esp)
80102c04:	e8 d7 d5 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102c09:	89 34 24             	mov    %esi,(%esp)
80102c0c:	e8 cf d5 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c11:	83 c4 10             	add    $0x10,%esp
80102c14:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c1a:	7c 94                	jl     80102bb0 <initlog+0xa0>
recover_from_log(void)
{
  read_head();      
  cprintf("recovery: n=%d but ignoring\n", log.lh.n);
  install_trans();
  log.lh.n = 0;
80102c1c:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c23:	00 00 00 
  write_head();
80102c26:	e8 85 fe ff ff       	call   80102ab0 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102c2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c2e:	5b                   	pop    %ebx
80102c2f:	5e                   	pop    %esi
80102c30:	5f                   	pop    %edi
80102c31:	5d                   	pop    %ebp
80102c32:	c3                   	ret    
80102c33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102c46:	68 80 26 11 80       	push   $0x80112680
80102c4b:	e8 30 18 00 00       	call   80104480 <acquire>
80102c50:	83 c4 10             	add    $0x10,%esp
80102c53:	eb 18                	jmp    80102c6d <begin_op+0x2d>
80102c55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102c58:	83 ec 08             	sub    $0x8,%esp
80102c5b:	68 80 26 11 80       	push   $0x80112680
80102c60:	68 80 26 11 80       	push   $0x80112680
80102c65:	e8 16 12 00 00       	call   80103e80 <sleep>
80102c6a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102c6d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102c72:	85 c0                	test   %eax,%eax
80102c74:	75 e2                	jne    80102c58 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c76:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102c7b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102c81:	83 c0 01             	add    $0x1,%eax
80102c84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c8a:	83 fa 1e             	cmp    $0x1e,%edx
80102c8d:	7f c9                	jg     80102c58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c8f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102c92:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102c97:	68 80 26 11 80       	push   $0x80112680
80102c9c:	e8 8f 18 00 00       	call   80104530 <release>
      break;
    }
  }
}
80102ca1:	83 c4 10             	add    $0x10,%esp
80102ca4:	c9                   	leave  
80102ca5:	c3                   	ret    
80102ca6:	8d 76 00             	lea    0x0(%esi),%esi
80102ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102cb0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102cb0:	55                   	push   %ebp
80102cb1:	89 e5                	mov    %esp,%ebp
80102cb3:	57                   	push   %edi
80102cb4:	56                   	push   %esi
80102cb5:	53                   	push   %ebx
80102cb6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102cb9:	68 80 26 11 80       	push   $0x80112680
80102cbe:	e8 bd 17 00 00       	call   80104480 <acquire>
  log.outstanding -= 1;
80102cc3:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102cc8:	8b 3d c0 26 11 80    	mov    0x801126c0,%edi
80102cce:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102cd1:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102cd4:	85 ff                	test   %edi,%edi
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102cd6:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102cdb:	0f 85 63 01 00 00    	jne    80102e44 <end_op+0x194>
    panic("log.committing");
  if(log.outstanding == 0){
80102ce1:	85 c0                	test   %eax,%eax
80102ce3:	0f 85 37 01 00 00    	jne    80102e20 <end_op+0x170>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102ce9:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102cec:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102cf3:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102cf6:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102cf8:	68 80 26 11 80       	push   $0x80112680
80102cfd:	e8 2e 18 00 00       	call   80104530 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102d02:	8b 35 c8 26 11 80    	mov    0x801126c8,%esi
80102d08:	83 c4 10             	add    $0x10,%esp
80102d0b:	85 f6                	test   %esi,%esi
80102d0d:	0f 8e c9 00 00 00    	jle    80102ddc <end_op+0x12c>
80102d13:	90                   	nop
80102d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102d18:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102d1d:	83 ec 08             	sub    $0x8,%esp
80102d20:	01 d8                	add    %ebx,%eax
80102d22:	83 c0 01             	add    $0x1,%eax
80102d25:	50                   	push   %eax
80102d26:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102d2c:	e8 9f d3 ff ff       	call   801000d0 <bread>
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d31:	5a                   	pop    %edx
80102d32:	59                   	pop    %ecx
80102d33:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102d3a:	ff 35 c4 26 11 80    	pushl  0x801126c4
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102d40:	89 c6                	mov    %eax,%esi
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d42:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d45:	e8 86 d3 ff ff       	call   801000d0 <bread>
80102d4a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102d4c:	8d 40 5c             	lea    0x5c(%eax),%eax
80102d4f:	83 c4 0c             	add    $0xc,%esp
80102d52:	68 00 02 00 00       	push   $0x200
80102d57:	50                   	push   %eax
80102d58:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d5b:	50                   	push   %eax
80102d5c:	e8 cf 18 00 00       	call   80104630 <memmove>
    bwrite(to);  // write the log
80102d61:	89 34 24             	mov    %esi,(%esp)
80102d64:	e8 37 d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102d69:	89 3c 24             	mov    %edi,(%esp)
80102d6c:	e8 6f d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102d71:	89 34 24             	mov    %esi,(%esp)
80102d74:	e8 67 d4 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d79:	83 c4 10             	add    $0x10,%esp
80102d7c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102d82:	7c 94                	jl     80102d18 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d84:	e8 27 fd ff ff       	call   80102ab0 <write_head>
static void
install_trans1(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d89:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102d8e:	31 db                	xor    %ebx,%ebx
80102d90:	85 c0                	test   %eax,%eax
80102d92:	7e 39                	jle    80102dcd <end_op+0x11d>
80102d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    //struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d98:	83 ec 08             	sub    $0x8,%esp
80102d9b:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102da2:	ff 35 c4 26 11 80    	pushl  0x801126c4
static void
install_trans1(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102da8:	83 c3 01             	add    $0x1,%ebx
    //struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dab:	e8 20 d3 ff ff       	call   801000d0 <bread>
80102db0:	89 c6                	mov    %eax,%esi
    //memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
80102db2:	89 04 24             	mov    %eax,(%esp)
80102db5:	e8 e6 d3 ff ff       	call   801001a0 <bwrite>
    //brelse(lbuf);
    brelse(dbuf);
80102dba:	89 34 24             	mov    %esi,(%esp)
80102dbd:	e8 1e d4 ff ff       	call   801001e0 <brelse>
static void
install_trans1(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102dc2:	83 c4 10             	add    $0x10,%esp
80102dc5:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102dcb:	7c cb                	jl     80102d98 <end_op+0xe8>
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    install_trans1(); // Now install writes to home locations
    log.lh.n = 0;
80102dcd:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102dd4:	00 00 00 
    write_head();    // Erase the transaction from the log
80102dd7:	e8 d4 fc ff ff       	call   80102ab0 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102ddc:	83 ec 0c             	sub    $0xc,%esp
80102ddf:	68 80 26 11 80       	push   $0x80112680
80102de4:	e8 97 16 00 00       	call   80104480 <acquire>
    log.committing = 0;
    wakeup(&log);
80102de9:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102df0:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102df7:	00 00 00 
    wakeup(&log);
80102dfa:	e8 41 12 00 00       	call   80104040 <wakeup>
    release(&log.lock);
80102dff:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e06:	e8 25 17 00 00       	call   80104530 <release>
80102e0b:	83 c4 10             	add    $0x10,%esp
  }
}
80102e0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e11:	5b                   	pop    %ebx
80102e12:	5e                   	pop    %esi
80102e13:	5f                   	pop    %edi
80102e14:	5d                   	pop    %ebp
80102e15:	c3                   	ret    
80102e16:	8d 76 00             	lea    0x0(%esi),%esi
80102e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80102e20:	83 ec 0c             	sub    $0xc,%esp
80102e23:	68 80 26 11 80       	push   $0x80112680
80102e28:	e8 13 12 00 00       	call   80104040 <wakeup>
  }
  release(&log.lock);
80102e2d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e34:	e8 f7 16 00 00       	call   80104530 <release>
80102e39:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102e3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e3f:	5b                   	pop    %ebx
80102e40:	5e                   	pop    %esi
80102e41:	5f                   	pop    %edi
80102e42:	5d                   	pop    %ebp
80102e43:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102e44:	83 ec 0c             	sub    $0xc,%esp
80102e47:	68 a1 76 10 80       	push   $0x801076a1
80102e4c:	e8 1f d5 ff ff       	call   80100370 <panic>
80102e51:	eb 0d                	jmp    80102e60 <log_write>
80102e53:	90                   	nop
80102e54:	90                   	nop
80102e55:	90                   	nop
80102e56:	90                   	nop
80102e57:	90                   	nop
80102e58:	90                   	nop
80102e59:	90                   	nop
80102e5a:	90                   	nop
80102e5b:	90                   	nop
80102e5c:	90                   	nop
80102e5d:	90                   	nop
80102e5e:	90                   	nop
80102e5f:	90                   	nop

80102e60 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	53                   	push   %ebx
80102e64:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e67:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102e6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e70:	83 fa 1d             	cmp    $0x1d,%edx
80102e73:	0f 8f 97 00 00 00    	jg     80102f10 <log_write+0xb0>
80102e79:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102e7e:	83 e8 01             	sub    $0x1,%eax
80102e81:	39 c2                	cmp    %eax,%edx
80102e83:	0f 8d 87 00 00 00    	jge    80102f10 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102e89:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102e8e:	85 c0                	test   %eax,%eax
80102e90:	0f 8e 87 00 00 00    	jle    80102f1d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102e96:	83 ec 0c             	sub    $0xc,%esp
80102e99:	68 80 26 11 80       	push   $0x80112680
80102e9e:	e8 dd 15 00 00       	call   80104480 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102ea3:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102ea9:	83 c4 10             	add    $0x10,%esp
80102eac:	83 fa 00             	cmp    $0x0,%edx
80102eaf:	7e 50                	jle    80102f01 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102eb1:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102eb4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102eb6:	3b 0d cc 26 11 80    	cmp    0x801126cc,%ecx
80102ebc:	75 0b                	jne    80102ec9 <log_write+0x69>
80102ebe:	eb 38                	jmp    80102ef8 <log_write+0x98>
80102ec0:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102ec7:	74 2f                	je     80102ef8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102ec9:	83 c0 01             	add    $0x1,%eax
80102ecc:	39 d0                	cmp    %edx,%eax
80102ece:	75 f0                	jne    80102ec0 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102ed0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102ed7:	83 c2 01             	add    $0x1,%edx
80102eda:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102ee0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102ee3:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102eea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102eed:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102eee:	e9 3d 16 00 00       	jmp    80104530 <release>
80102ef3:	90                   	nop
80102ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102ef8:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102eff:	eb df                	jmp    80102ee0 <log_write+0x80>
80102f01:	8b 43 08             	mov    0x8(%ebx),%eax
80102f04:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102f09:	75 d5                	jne    80102ee0 <log_write+0x80>
80102f0b:	eb ca                	jmp    80102ed7 <log_write+0x77>
80102f0d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102f10:	83 ec 0c             	sub    $0xc,%esp
80102f13:	68 b0 76 10 80       	push   $0x801076b0
80102f18:	e8 53 d4 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102f1d:	83 ec 0c             	sub    $0xc,%esp
80102f20:	68 c6 76 10 80       	push   $0x801076c6
80102f25:	e8 46 d4 ff ff       	call   80100370 <panic>
80102f2a:	66 90                	xchg   %ax,%ax
80102f2c:	66 90                	xchg   %ax,%ax
80102f2e:	66 90                	xchg   %ax,%ax

80102f30 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102f30:	55                   	push   %ebp
80102f31:	89 e5                	mov    %esp,%ebp
80102f33:	53                   	push   %ebx
80102f34:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102f37:	e8 64 09 00 00       	call   801038a0 <cpuid>
80102f3c:	89 c3                	mov    %eax,%ebx
80102f3e:	e8 5d 09 00 00       	call   801038a0 <cpuid>
80102f43:	83 ec 04             	sub    $0x4,%esp
80102f46:	53                   	push   %ebx
80102f47:	50                   	push   %eax
80102f48:	68 e1 76 10 80       	push   $0x801076e1
80102f4d:	e8 0e d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102f52:	e8 89 29 00 00       	call   801058e0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102f57:	e8 c4 08 00 00       	call   80103820 <mycpu>
80102f5c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102f5e:	b8 01 00 00 00       	mov    $0x1,%eax
80102f63:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102f6a:	e8 21 0c 00 00       	call   80103b90 <scheduler>
80102f6f:	90                   	nop

80102f70 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102f70:	55                   	push   %ebp
80102f71:	89 e5                	mov    %esp,%ebp
80102f73:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102f76:	e8 85 3b 00 00       	call   80106b00 <switchkvm>
  seginit();
80102f7b:	e8 a0 38 00 00       	call   80106820 <seginit>
  lapicinit();
80102f80:	e8 6b f7 ff ff       	call   801026f0 <lapicinit>
  mpmain();
80102f85:	e8 a6 ff ff ff       	call   80102f30 <mpmain>
80102f8a:	66 90                	xchg   %ax,%ax
80102f8c:	66 90                	xchg   %ax,%ax
80102f8e:	66 90                	xchg   %ax,%ax

80102f90 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102f90:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102f94:	83 e4 f0             	and    $0xfffffff0,%esp
80102f97:	ff 71 fc             	pushl  -0x4(%ecx)
80102f9a:	55                   	push   %ebp
80102f9b:	89 e5                	mov    %esp,%ebp
80102f9d:	53                   	push   %ebx
80102f9e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f9f:	bb 80 27 11 80       	mov    $0x80112780,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102fa4:	83 ec 08             	sub    $0x8,%esp
80102fa7:	68 00 00 40 80       	push   $0x80400000
80102fac:	68 a8 57 11 80       	push   $0x801157a8
80102fb1:	e8 0a f5 ff ff       	call   801024c0 <kinit1>
  kvmalloc();      // kernel page table
80102fb6:	e8 e5 3f 00 00       	call   80106fa0 <kvmalloc>
  mpinit();        // detect other processors
80102fbb:	e8 70 01 00 00       	call   80103130 <mpinit>
  lapicinit();     // interrupt controller
80102fc0:	e8 2b f7 ff ff       	call   801026f0 <lapicinit>
  seginit();       // segment descriptors
80102fc5:	e8 56 38 00 00       	call   80106820 <seginit>
  picinit();       // disable pic
80102fca:	e8 31 03 00 00       	call   80103300 <picinit>
  ioapicinit();    // another interrupt controller
80102fcf:	e8 1c f3 ff ff       	call   801022f0 <ioapicinit>
  consoleinit();   // console hardware
80102fd4:	e8 c7 d9 ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102fd9:	e8 c2 2c 00 00       	call   80105ca0 <uartinit>
  pinit();         // process table
80102fde:	e8 1d 08 00 00       	call   80103800 <pinit>
  tvinit();        // trap vectors
80102fe3:	e8 58 28 00 00       	call   80105840 <tvinit>
  binit();         // buffer cache
80102fe8:	e8 53 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102fed:	e8 5e dd ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102ff2:	e8 d9 f0 ff ff       	call   801020d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102ff7:	83 c4 0c             	add    $0xc,%esp
80102ffa:	68 8a 00 00 00       	push   $0x8a
80102fff:	68 8c a4 10 80       	push   $0x8010a48c
80103004:	68 00 70 00 80       	push   $0x80007000
80103009:	e8 22 16 00 00       	call   80104630 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010300e:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103015:	00 00 00 
80103018:	83 c4 10             	add    $0x10,%esp
8010301b:	05 80 27 11 80       	add    $0x80112780,%eax
80103020:	39 d8                	cmp    %ebx,%eax
80103022:	76 6f                	jbe    80103093 <main+0x103>
80103024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80103028:	e8 f3 07 00 00       	call   80103820 <mycpu>
8010302d:	39 d8                	cmp    %ebx,%eax
8010302f:	74 49                	je     8010307a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103031:	e8 5a f5 ff ff       	call   80102590 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80103036:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
8010303b:	c7 05 f8 6f 00 80 70 	movl   $0x80102f70,0x80006ff8
80103042:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103045:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010304c:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
8010304f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103054:	0f b6 03             	movzbl (%ebx),%eax
80103057:	83 ec 08             	sub    $0x8,%esp
8010305a:	68 00 70 00 00       	push   $0x7000
8010305f:	50                   	push   %eax
80103060:	e8 db f7 ff ff       	call   80102840 <lapicstartap>
80103065:	83 c4 10             	add    $0x10,%esp
80103068:	90                   	nop
80103069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103070:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103076:	85 c0                	test   %eax,%eax
80103078:	74 f6                	je     80103070 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010307a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103081:	00 00 00 
80103084:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010308a:	05 80 27 11 80       	add    $0x80112780,%eax
8010308f:	39 c3                	cmp    %eax,%ebx
80103091:	72 95                	jb     80103028 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103093:	83 ec 08             	sub    $0x8,%esp
80103096:	68 00 00 00 8e       	push   $0x8e000000
8010309b:	68 00 00 40 80       	push   $0x80400000
801030a0:	e8 8b f4 ff ff       	call   80102530 <kinit2>
  userinit();      // first user process
801030a5:	e8 46 08 00 00       	call   801038f0 <userinit>
  mpmain();        // finish this processor's setup
801030aa:	e8 81 fe ff ff       	call   80102f30 <mpmain>
801030af:	90                   	nop

801030b0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801030b0:	55                   	push   %ebp
801030b1:	89 e5                	mov    %esp,%ebp
801030b3:	57                   	push   %edi
801030b4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801030b5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801030bb:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
801030bc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801030bf:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801030c2:	39 de                	cmp    %ebx,%esi
801030c4:	73 48                	jae    8010310e <mpsearch1+0x5e>
801030c6:	8d 76 00             	lea    0x0(%esi),%esi
801030c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801030d0:	83 ec 04             	sub    $0x4,%esp
801030d3:	8d 7e 10             	lea    0x10(%esi),%edi
801030d6:	6a 04                	push   $0x4
801030d8:	68 f5 76 10 80       	push   $0x801076f5
801030dd:	56                   	push   %esi
801030de:	e8 ed 14 00 00       	call   801045d0 <memcmp>
801030e3:	83 c4 10             	add    $0x10,%esp
801030e6:	85 c0                	test   %eax,%eax
801030e8:	75 1e                	jne    80103108 <mpsearch1+0x58>
801030ea:	8d 7e 10             	lea    0x10(%esi),%edi
801030ed:	89 f2                	mov    %esi,%edx
801030ef:	31 c9                	xor    %ecx,%ecx
801030f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
801030f8:	0f b6 02             	movzbl (%edx),%eax
801030fb:	83 c2 01             	add    $0x1,%edx
801030fe:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103100:	39 fa                	cmp    %edi,%edx
80103102:	75 f4                	jne    801030f8 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103104:	84 c9                	test   %cl,%cl
80103106:	74 10                	je     80103118 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103108:	39 fb                	cmp    %edi,%ebx
8010310a:	89 fe                	mov    %edi,%esi
8010310c:	77 c2                	ja     801030d0 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
8010310e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103111:	31 c0                	xor    %eax,%eax
}
80103113:	5b                   	pop    %ebx
80103114:	5e                   	pop    %esi
80103115:	5f                   	pop    %edi
80103116:	5d                   	pop    %ebp
80103117:	c3                   	ret    
80103118:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010311b:	89 f0                	mov    %esi,%eax
8010311d:	5b                   	pop    %ebx
8010311e:	5e                   	pop    %esi
8010311f:	5f                   	pop    %edi
80103120:	5d                   	pop    %ebp
80103121:	c3                   	ret    
80103122:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103130 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103130:	55                   	push   %ebp
80103131:	89 e5                	mov    %esp,%ebp
80103133:	57                   	push   %edi
80103134:	56                   	push   %esi
80103135:	53                   	push   %ebx
80103136:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103139:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103140:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103147:	c1 e0 08             	shl    $0x8,%eax
8010314a:	09 d0                	or     %edx,%eax
8010314c:	c1 e0 04             	shl    $0x4,%eax
8010314f:	85 c0                	test   %eax,%eax
80103151:	75 1b                	jne    8010316e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80103153:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010315a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103161:	c1 e0 08             	shl    $0x8,%eax
80103164:	09 d0                	or     %edx,%eax
80103166:	c1 e0 0a             	shl    $0xa,%eax
80103169:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010316e:	ba 00 04 00 00       	mov    $0x400,%edx
80103173:	e8 38 ff ff ff       	call   801030b0 <mpsearch1>
80103178:	85 c0                	test   %eax,%eax
8010317a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010317d:	0f 84 37 01 00 00    	je     801032ba <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103183:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103186:	8b 58 04             	mov    0x4(%eax),%ebx
80103189:	85 db                	test   %ebx,%ebx
8010318b:	0f 84 43 01 00 00    	je     801032d4 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103191:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103197:	83 ec 04             	sub    $0x4,%esp
8010319a:	6a 04                	push   $0x4
8010319c:	68 fa 76 10 80       	push   $0x801076fa
801031a1:	56                   	push   %esi
801031a2:	e8 29 14 00 00       	call   801045d0 <memcmp>
801031a7:	83 c4 10             	add    $0x10,%esp
801031aa:	85 c0                	test   %eax,%eax
801031ac:	0f 85 22 01 00 00    	jne    801032d4 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
801031b2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801031b9:	3c 01                	cmp    $0x1,%al
801031bb:	74 08                	je     801031c5 <mpinit+0x95>
801031bd:	3c 04                	cmp    $0x4,%al
801031bf:	0f 85 0f 01 00 00    	jne    801032d4 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801031c5:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801031cc:	85 ff                	test   %edi,%edi
801031ce:	74 21                	je     801031f1 <mpinit+0xc1>
801031d0:	31 d2                	xor    %edx,%edx
801031d2:	31 c0                	xor    %eax,%eax
801031d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801031d8:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
801031df:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801031e0:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801031e3:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801031e5:	39 c7                	cmp    %eax,%edi
801031e7:	75 ef                	jne    801031d8 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801031e9:	84 d2                	test   %dl,%dl
801031eb:	0f 85 e3 00 00 00    	jne    801032d4 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801031f1:	85 f6                	test   %esi,%esi
801031f3:	0f 84 db 00 00 00    	je     801032d4 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801031f9:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801031ff:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103204:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
8010320b:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103211:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103216:	01 d6                	add    %edx,%esi
80103218:	90                   	nop
80103219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103220:	39 c6                	cmp    %eax,%esi
80103222:	76 23                	jbe    80103247 <mpinit+0x117>
80103224:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
80103227:	80 fa 04             	cmp    $0x4,%dl
8010322a:	0f 87 c0 00 00 00    	ja     801032f0 <mpinit+0x1c0>
80103230:	ff 24 95 38 77 10 80 	jmp    *-0x7fef88c8(,%edx,4)
80103237:	89 f6                	mov    %esi,%esi
80103239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103240:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103243:	39 c6                	cmp    %eax,%esi
80103245:	77 dd                	ja     80103224 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103247:	85 db                	test   %ebx,%ebx
80103249:	0f 84 92 00 00 00    	je     801032e1 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010324f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103252:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103256:	74 15                	je     8010326d <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103258:	ba 22 00 00 00       	mov    $0x22,%edx
8010325d:	b8 70 00 00 00       	mov    $0x70,%eax
80103262:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103263:	ba 23 00 00 00       	mov    $0x23,%edx
80103268:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103269:	83 c8 01             	or     $0x1,%eax
8010326c:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010326d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103270:	5b                   	pop    %ebx
80103271:	5e                   	pop    %esi
80103272:	5f                   	pop    %edi
80103273:	5d                   	pop    %ebp
80103274:	c3                   	ret    
80103275:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103278:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
8010327e:	83 f9 07             	cmp    $0x7,%ecx
80103281:	7f 19                	jg     8010329c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103283:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103287:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010328d:	83 c1 01             	add    $0x1,%ecx
80103290:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103296:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010329c:	83 c0 14             	add    $0x14,%eax
      continue;
8010329f:	e9 7c ff ff ff       	jmp    80103220 <mpinit+0xf0>
801032a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801032a8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801032ac:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801032af:	88 15 60 27 11 80    	mov    %dl,0x80112760
      p += sizeof(struct mpioapic);
      continue;
801032b5:	e9 66 ff ff ff       	jmp    80103220 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801032ba:	ba 00 00 01 00       	mov    $0x10000,%edx
801032bf:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801032c4:	e8 e7 fd ff ff       	call   801030b0 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032c9:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801032cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032ce:	0f 85 af fe ff ff    	jne    80103183 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
801032d4:	83 ec 0c             	sub    $0xc,%esp
801032d7:	68 ff 76 10 80       	push   $0x801076ff
801032dc:	e8 8f d0 ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
801032e1:	83 ec 0c             	sub    $0xc,%esp
801032e4:	68 18 77 10 80       	push   $0x80107718
801032e9:	e8 82 d0 ff ff       	call   80100370 <panic>
801032ee:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801032f0:	31 db                	xor    %ebx,%ebx
801032f2:	e9 30 ff ff ff       	jmp    80103227 <mpinit+0xf7>
801032f7:	66 90                	xchg   %ax,%ax
801032f9:	66 90                	xchg   %ax,%ax
801032fb:	66 90                	xchg   %ax,%ax
801032fd:	66 90                	xchg   %ax,%ax
801032ff:	90                   	nop

80103300 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103300:	55                   	push   %ebp
80103301:	ba 21 00 00 00       	mov    $0x21,%edx
80103306:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010330b:	89 e5                	mov    %esp,%ebp
8010330d:	ee                   	out    %al,(%dx)
8010330e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103313:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103314:	5d                   	pop    %ebp
80103315:	c3                   	ret    
80103316:	66 90                	xchg   %ax,%ax
80103318:	66 90                	xchg   %ax,%ax
8010331a:	66 90                	xchg   %ax,%ax
8010331c:	66 90                	xchg   %ax,%ax
8010331e:	66 90                	xchg   %ax,%ax

80103320 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103320:	55                   	push   %ebp
80103321:	89 e5                	mov    %esp,%ebp
80103323:	57                   	push   %edi
80103324:	56                   	push   %esi
80103325:	53                   	push   %ebx
80103326:	83 ec 0c             	sub    $0xc,%esp
80103329:	8b 75 08             	mov    0x8(%ebp),%esi
8010332c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010332f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103335:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010333b:	e8 30 da ff ff       	call   80100d70 <filealloc>
80103340:	85 c0                	test   %eax,%eax
80103342:	89 06                	mov    %eax,(%esi)
80103344:	0f 84 a8 00 00 00    	je     801033f2 <pipealloc+0xd2>
8010334a:	e8 21 da ff ff       	call   80100d70 <filealloc>
8010334f:	85 c0                	test   %eax,%eax
80103351:	89 03                	mov    %eax,(%ebx)
80103353:	0f 84 87 00 00 00    	je     801033e0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103359:	e8 32 f2 ff ff       	call   80102590 <kalloc>
8010335e:	85 c0                	test   %eax,%eax
80103360:	89 c7                	mov    %eax,%edi
80103362:	0f 84 b0 00 00 00    	je     80103418 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103368:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010336b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103372:	00 00 00 
  p->writeopen = 1;
80103375:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010337c:	00 00 00 
  p->nwrite = 0;
8010337f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103386:	00 00 00 
  p->nread = 0;
80103389:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103390:	00 00 00 
  initlock(&p->lock, "pipe");
80103393:	68 4c 77 10 80       	push   $0x8010774c
80103398:	50                   	push   %eax
80103399:	e8 82 0f 00 00       	call   80104320 <initlock>
  (*f0)->type = FD_PIPE;
8010339e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801033a0:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
801033a3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801033a9:	8b 06                	mov    (%esi),%eax
801033ab:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801033af:	8b 06                	mov    (%esi),%eax
801033b1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801033b5:	8b 06                	mov    (%esi),%eax
801033b7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801033ba:	8b 03                	mov    (%ebx),%eax
801033bc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801033c2:	8b 03                	mov    (%ebx),%eax
801033c4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801033c8:	8b 03                	mov    (%ebx),%eax
801033ca:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801033ce:	8b 03                	mov    (%ebx),%eax
801033d0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801033d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801033d6:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801033d8:	5b                   	pop    %ebx
801033d9:	5e                   	pop    %esi
801033da:	5f                   	pop    %edi
801033db:	5d                   	pop    %ebp
801033dc:	c3                   	ret    
801033dd:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801033e0:	8b 06                	mov    (%esi),%eax
801033e2:	85 c0                	test   %eax,%eax
801033e4:	74 1e                	je     80103404 <pipealloc+0xe4>
    fileclose(*f0);
801033e6:	83 ec 0c             	sub    $0xc,%esp
801033e9:	50                   	push   %eax
801033ea:	e8 41 da ff ff       	call   80100e30 <fileclose>
801033ef:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801033f2:	8b 03                	mov    (%ebx),%eax
801033f4:	85 c0                	test   %eax,%eax
801033f6:	74 0c                	je     80103404 <pipealloc+0xe4>
    fileclose(*f1);
801033f8:	83 ec 0c             	sub    $0xc,%esp
801033fb:	50                   	push   %eax
801033fc:	e8 2f da ff ff       	call   80100e30 <fileclose>
80103401:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103404:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
80103407:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010340c:	5b                   	pop    %ebx
8010340d:	5e                   	pop    %esi
8010340e:	5f                   	pop    %edi
8010340f:	5d                   	pop    %ebp
80103410:	c3                   	ret    
80103411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103418:	8b 06                	mov    (%esi),%eax
8010341a:	85 c0                	test   %eax,%eax
8010341c:	75 c8                	jne    801033e6 <pipealloc+0xc6>
8010341e:	eb d2                	jmp    801033f2 <pipealloc+0xd2>

80103420 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103420:	55                   	push   %ebp
80103421:	89 e5                	mov    %esp,%ebp
80103423:	56                   	push   %esi
80103424:	53                   	push   %ebx
80103425:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103428:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010342b:	83 ec 0c             	sub    $0xc,%esp
8010342e:	53                   	push   %ebx
8010342f:	e8 4c 10 00 00       	call   80104480 <acquire>
  if(writable){
80103434:	83 c4 10             	add    $0x10,%esp
80103437:	85 f6                	test   %esi,%esi
80103439:	74 45                	je     80103480 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010343b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103441:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103444:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010344b:	00 00 00 
    wakeup(&p->nread);
8010344e:	50                   	push   %eax
8010344f:	e8 ec 0b 00 00       	call   80104040 <wakeup>
80103454:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103457:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010345d:	85 d2                	test   %edx,%edx
8010345f:	75 0a                	jne    8010346b <pipeclose+0x4b>
80103461:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103467:	85 c0                	test   %eax,%eax
80103469:	74 35                	je     801034a0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010346b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010346e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103471:	5b                   	pop    %ebx
80103472:	5e                   	pop    %esi
80103473:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103474:	e9 b7 10 00 00       	jmp    80104530 <release>
80103479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103480:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103486:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103489:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103490:	00 00 00 
    wakeup(&p->nwrite);
80103493:	50                   	push   %eax
80103494:	e8 a7 0b 00 00       	call   80104040 <wakeup>
80103499:	83 c4 10             	add    $0x10,%esp
8010349c:	eb b9                	jmp    80103457 <pipeclose+0x37>
8010349e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
801034a0:	83 ec 0c             	sub    $0xc,%esp
801034a3:	53                   	push   %ebx
801034a4:	e8 87 10 00 00       	call   80104530 <release>
    kfree((char*)p);
801034a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801034ac:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
801034af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034b2:	5b                   	pop    %ebx
801034b3:	5e                   	pop    %esi
801034b4:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
801034b5:	e9 26 ef ff ff       	jmp    801023e0 <kfree>
801034ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801034c0 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801034c0:	55                   	push   %ebp
801034c1:	89 e5                	mov    %esp,%ebp
801034c3:	57                   	push   %edi
801034c4:	56                   	push   %esi
801034c5:	53                   	push   %ebx
801034c6:	83 ec 28             	sub    $0x28,%esp
801034c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801034cc:	53                   	push   %ebx
801034cd:	e8 ae 0f 00 00       	call   80104480 <acquire>
  for(i = 0; i < n; i++){
801034d2:	8b 45 10             	mov    0x10(%ebp),%eax
801034d5:	83 c4 10             	add    $0x10,%esp
801034d8:	85 c0                	test   %eax,%eax
801034da:	0f 8e b9 00 00 00    	jle    80103599 <pipewrite+0xd9>
801034e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801034e3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801034e9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034ef:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801034f5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801034f8:	03 4d 10             	add    0x10(%ebp),%ecx
801034fb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034fe:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103504:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
8010350a:	39 d0                	cmp    %edx,%eax
8010350c:	74 38                	je     80103546 <pipewrite+0x86>
8010350e:	eb 59                	jmp    80103569 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
80103510:	e8 ab 03 00 00       	call   801038c0 <myproc>
80103515:	8b 48 24             	mov    0x24(%eax),%ecx
80103518:	85 c9                	test   %ecx,%ecx
8010351a:	75 34                	jne    80103550 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010351c:	83 ec 0c             	sub    $0xc,%esp
8010351f:	57                   	push   %edi
80103520:	e8 1b 0b 00 00       	call   80104040 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103525:	58                   	pop    %eax
80103526:	5a                   	pop    %edx
80103527:	53                   	push   %ebx
80103528:	56                   	push   %esi
80103529:	e8 52 09 00 00       	call   80103e80 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010352e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103534:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010353a:	83 c4 10             	add    $0x10,%esp
8010353d:	05 00 02 00 00       	add    $0x200,%eax
80103542:	39 c2                	cmp    %eax,%edx
80103544:	75 2a                	jne    80103570 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
80103546:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010354c:	85 c0                	test   %eax,%eax
8010354e:	75 c0                	jne    80103510 <pipewrite+0x50>
        release(&p->lock);
80103550:	83 ec 0c             	sub    $0xc,%esp
80103553:	53                   	push   %ebx
80103554:	e8 d7 0f 00 00       	call   80104530 <release>
        return -1;
80103559:	83 c4 10             	add    $0x10,%esp
8010355c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103561:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103564:	5b                   	pop    %ebx
80103565:	5e                   	pop    %esi
80103566:	5f                   	pop    %edi
80103567:	5d                   	pop    %ebp
80103568:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103569:	89 c2                	mov    %eax,%edx
8010356b:	90                   	nop
8010356c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103570:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103573:	8d 42 01             	lea    0x1(%edx),%eax
80103576:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010357a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103580:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103586:	0f b6 09             	movzbl (%ecx),%ecx
80103589:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
8010358d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103590:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103593:	0f 85 65 ff ff ff    	jne    801034fe <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103599:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010359f:	83 ec 0c             	sub    $0xc,%esp
801035a2:	50                   	push   %eax
801035a3:	e8 98 0a 00 00       	call   80104040 <wakeup>
  release(&p->lock);
801035a8:	89 1c 24             	mov    %ebx,(%esp)
801035ab:	e8 80 0f 00 00       	call   80104530 <release>
  return n;
801035b0:	83 c4 10             	add    $0x10,%esp
801035b3:	8b 45 10             	mov    0x10(%ebp),%eax
801035b6:	eb a9                	jmp    80103561 <pipewrite+0xa1>
801035b8:	90                   	nop
801035b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801035c0 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	57                   	push   %edi
801035c4:	56                   	push   %esi
801035c5:	53                   	push   %ebx
801035c6:	83 ec 18             	sub    $0x18,%esp
801035c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801035cf:	53                   	push   %ebx
801035d0:	e8 ab 0e 00 00       	call   80104480 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801035d5:	83 c4 10             	add    $0x10,%esp
801035d8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801035de:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
801035e4:	75 6a                	jne    80103650 <piperead+0x90>
801035e6:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
801035ec:	85 f6                	test   %esi,%esi
801035ee:	0f 84 cc 00 00 00    	je     801036c0 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801035f4:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
801035fa:	eb 2d                	jmp    80103629 <piperead+0x69>
801035fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103600:	83 ec 08             	sub    $0x8,%esp
80103603:	53                   	push   %ebx
80103604:	56                   	push   %esi
80103605:	e8 76 08 00 00       	call   80103e80 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010360a:	83 c4 10             	add    $0x10,%esp
8010360d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103613:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103619:	75 35                	jne    80103650 <piperead+0x90>
8010361b:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103621:	85 d2                	test   %edx,%edx
80103623:	0f 84 97 00 00 00    	je     801036c0 <piperead+0x100>
    if(myproc()->killed){
80103629:	e8 92 02 00 00       	call   801038c0 <myproc>
8010362e:	8b 48 24             	mov    0x24(%eax),%ecx
80103631:	85 c9                	test   %ecx,%ecx
80103633:	74 cb                	je     80103600 <piperead+0x40>
      release(&p->lock);
80103635:	83 ec 0c             	sub    $0xc,%esp
80103638:	53                   	push   %ebx
80103639:	e8 f2 0e 00 00       	call   80104530 <release>
      return -1;
8010363e:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103641:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103644:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103649:	5b                   	pop    %ebx
8010364a:	5e                   	pop    %esi
8010364b:	5f                   	pop    %edi
8010364c:	5d                   	pop    %ebp
8010364d:	c3                   	ret    
8010364e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103650:	8b 45 10             	mov    0x10(%ebp),%eax
80103653:	85 c0                	test   %eax,%eax
80103655:	7e 69                	jle    801036c0 <piperead+0x100>
    if(p->nread == p->nwrite)
80103657:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010365d:	31 c9                	xor    %ecx,%ecx
8010365f:	eb 15                	jmp    80103676 <piperead+0xb6>
80103661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103668:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010366e:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103674:	74 5a                	je     801036d0 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103676:	8d 70 01             	lea    0x1(%eax),%esi
80103679:	25 ff 01 00 00       	and    $0x1ff,%eax
8010367e:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103684:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103689:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010368c:	83 c1 01             	add    $0x1,%ecx
8010368f:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103692:	75 d4                	jne    80103668 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103694:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010369a:	83 ec 0c             	sub    $0xc,%esp
8010369d:	50                   	push   %eax
8010369e:	e8 9d 09 00 00       	call   80104040 <wakeup>
  release(&p->lock);
801036a3:	89 1c 24             	mov    %ebx,(%esp)
801036a6:	e8 85 0e 00 00       	call   80104530 <release>
  return i;
801036ab:	8b 45 10             	mov    0x10(%ebp),%eax
801036ae:	83 c4 10             	add    $0x10,%esp
}
801036b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036b4:	5b                   	pop    %ebx
801036b5:	5e                   	pop    %esi
801036b6:	5f                   	pop    %edi
801036b7:	5d                   	pop    %ebp
801036b8:	c3                   	ret    
801036b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036c0:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
801036c7:	eb cb                	jmp    80103694 <piperead+0xd4>
801036c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036d0:	89 4d 10             	mov    %ecx,0x10(%ebp)
801036d3:	eb bf                	jmp    80103694 <piperead+0xd4>
801036d5:	66 90                	xchg   %ax,%ax
801036d7:	66 90                	xchg   %ax,%ax
801036d9:	66 90                	xchg   %ax,%ax
801036db:	66 90                	xchg   %ax,%ax
801036dd:	66 90                	xchg   %ax,%ax
801036df:	90                   	nop

801036e0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036e4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801036e9:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801036ec:	68 20 2d 11 80       	push   $0x80112d20
801036f1:	e8 8a 0d 00 00       	call   80104480 <acquire>
801036f6:	83 c4 10             	add    $0x10,%esp
801036f9:	eb 13                	jmp    8010370e <allocproc+0x2e>
801036fb:	90                   	nop
801036fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103700:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103706:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
8010370c:	74 7a                	je     80103788 <allocproc+0xa8>
    if(p->state == UNUSED)
8010370e:	8b 43 0c             	mov    0xc(%ebx),%eax
80103711:	85 c0                	test   %eax,%eax
80103713:	75 eb                	jne    80103700 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103715:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
8010371a:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010371d:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;

  release(&ptable.lock);
80103724:	68 20 2d 11 80       	push   $0x80112d20
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103729:	8d 50 01             	lea    0x1(%eax),%edx
8010372c:	89 43 10             	mov    %eax,0x10(%ebx)
8010372f:	89 15 04 a0 10 80    	mov    %edx,0x8010a004

  release(&ptable.lock);
80103735:	e8 f6 0d 00 00       	call   80104530 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010373a:	e8 51 ee ff ff       	call   80102590 <kalloc>
8010373f:	83 c4 10             	add    $0x10,%esp
80103742:	85 c0                	test   %eax,%eax
80103744:	89 43 08             	mov    %eax,0x8(%ebx)
80103747:	74 56                	je     8010379f <allocproc+0xbf>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103749:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010374f:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103752:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103757:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
8010375a:	c7 40 14 2f 58 10 80 	movl   $0x8010582f,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103761:	6a 14                	push   $0x14
80103763:	6a 00                	push   $0x0
80103765:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103766:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103769:	e8 12 0e 00 00       	call   80104580 <memset>
  p->context->eip = (uint)forkret;
8010376e:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103771:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
80103774:	c7 40 10 b0 37 10 80 	movl   $0x801037b0,0x10(%eax)

  return p;
8010377b:	89 d8                	mov    %ebx,%eax
}
8010377d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103780:	c9                   	leave  
80103781:	c3                   	ret    
80103782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103788:	83 ec 0c             	sub    $0xc,%esp
8010378b:	68 20 2d 11 80       	push   $0x80112d20
80103790:	e8 9b 0d 00 00       	call   80104530 <release>
  return 0;
80103795:	83 c4 10             	add    $0x10,%esp
80103798:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
8010379a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010379d:	c9                   	leave  
8010379e:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010379f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801037a6:	eb d5                	jmp    8010377d <allocproc+0x9d>
801037a8:	90                   	nop
801037a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801037b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801037b6:	68 20 2d 11 80       	push   $0x80112d20
801037bb:	e8 70 0d 00 00       	call   80104530 <release>

  if (first) {
801037c0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801037c5:	83 c4 10             	add    $0x10,%esp
801037c8:	85 c0                	test   %eax,%eax
801037ca:	75 04                	jne    801037d0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801037cc:	c9                   	leave  
801037cd:	c3                   	ret    
801037ce:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
801037d0:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801037d3:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801037da:	00 00 00 
    iinit(ROOTDEV);
801037dd:	6a 01                	push   $0x1
801037df:	e8 8c dd ff ff       	call   80101570 <iinit>
    initlog(ROOTDEV);
801037e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801037eb:	e8 20 f3 ff ff       	call   80102b10 <initlog>
801037f0:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
801037f3:	c9                   	leave  
801037f4:	c3                   	ret    
801037f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103800 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103806:	68 51 77 10 80       	push   $0x80107751
8010380b:	68 20 2d 11 80       	push   $0x80112d20
80103810:	e8 0b 0b 00 00       	call   80104320 <initlock>
}
80103815:	83 c4 10             	add    $0x10,%esp
80103818:	c9                   	leave  
80103819:	c3                   	ret    
8010381a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103820 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	56                   	push   %esi
80103824:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103825:	9c                   	pushf  
80103826:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
80103827:	f6 c4 02             	test   $0x2,%ah
8010382a:	75 5b                	jne    80103887 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
8010382c:	e8 bf ef ff ff       	call   801027f0 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103831:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103837:	85 f6                	test   %esi,%esi
80103839:	7e 3f                	jle    8010387a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010383b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103842:	39 d0                	cmp    %edx,%eax
80103844:	74 30                	je     80103876 <mycpu+0x56>
80103846:	b9 30 28 11 80       	mov    $0x80112830,%ecx
8010384b:	31 d2                	xor    %edx,%edx
8010384d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103850:	83 c2 01             	add    $0x1,%edx
80103853:	39 f2                	cmp    %esi,%edx
80103855:	74 23                	je     8010387a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103857:	0f b6 19             	movzbl (%ecx),%ebx
8010385a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103860:	39 d8                	cmp    %ebx,%eax
80103862:	75 ec                	jne    80103850 <mycpu+0x30>
      return &cpus[i];
80103864:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
8010386a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010386d:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
8010386e:	05 80 27 11 80       	add    $0x80112780,%eax
  }
  panic("unknown apicid\n");
}
80103873:	5e                   	pop    %esi
80103874:	5d                   	pop    %ebp
80103875:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103876:	31 d2                	xor    %edx,%edx
80103878:	eb ea                	jmp    80103864 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
8010387a:	83 ec 0c             	sub    $0xc,%esp
8010387d:	68 58 77 10 80       	push   $0x80107758
80103882:	e8 e9 ca ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103887:	83 ec 0c             	sub    $0xc,%esp
8010388a:	68 34 78 10 80       	push   $0x80107834
8010388f:	e8 dc ca ff ff       	call   80100370 <panic>
80103894:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010389a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038a0 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801038a6:	e8 75 ff ff ff       	call   80103820 <mycpu>
801038ab:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
801038b0:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
801038b1:	c1 f8 04             	sar    $0x4,%eax
801038b4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801038ba:	c3                   	ret    
801038bb:	90                   	nop
801038bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038c0 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	53                   	push   %ebx
801038c4:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
801038c7:	e8 d4 0a 00 00       	call   801043a0 <pushcli>
  c = mycpu();
801038cc:	e8 4f ff ff ff       	call   80103820 <mycpu>
  p = c->proc;
801038d1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801038d7:	e8 04 0b 00 00       	call   801043e0 <popcli>
  return p;
}
801038dc:	83 c4 04             	add    $0x4,%esp
801038df:	89 d8                	mov    %ebx,%eax
801038e1:	5b                   	pop    %ebx
801038e2:	5d                   	pop    %ebp
801038e3:	c3                   	ret    
801038e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038f0 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	53                   	push   %ebx
801038f4:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801038f7:	e8 e4 fd ff ff       	call   801036e0 <allocproc>
801038fc:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
801038fe:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103903:	e8 18 36 00 00       	call   80106f20 <setupkvm>
80103908:	85 c0                	test   %eax,%eax
8010390a:	89 43 04             	mov    %eax,0x4(%ebx)
8010390d:	0f 84 bd 00 00 00    	je     801039d0 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103913:	83 ec 04             	sub    $0x4,%esp
80103916:	68 2c 00 00 00       	push   $0x2c
8010391b:	68 60 a4 10 80       	push   $0x8010a460
80103920:	50                   	push   %eax
80103921:	e8 0a 33 00 00       	call   80106c30 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80103926:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80103929:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010392f:	6a 4c                	push   $0x4c
80103931:	6a 00                	push   $0x0
80103933:	ff 73 18             	pushl  0x18(%ebx)
80103936:	e8 45 0c 00 00       	call   80104580 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010393b:	8b 43 18             	mov    0x18(%ebx),%eax
8010393e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103943:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103948:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010394b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010394f:	8b 43 18             	mov    0x18(%ebx),%eax
80103952:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103956:	8b 43 18             	mov    0x18(%ebx),%eax
80103959:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010395d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103961:	8b 43 18             	mov    0x18(%ebx),%eax
80103964:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103968:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010396c:	8b 43 18             	mov    0x18(%ebx),%eax
8010396f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103976:	8b 43 18             	mov    0x18(%ebx),%eax
80103979:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103980:	8b 43 18             	mov    0x18(%ebx),%eax
80103983:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010398a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010398d:	6a 10                	push   $0x10
8010398f:	68 81 77 10 80       	push   $0x80107781
80103994:	50                   	push   %eax
80103995:	e8 e6 0d 00 00       	call   80104780 <safestrcpy>
  p->cwd = namei("/");
8010399a:	c7 04 24 8a 77 10 80 	movl   $0x8010778a,(%esp)
801039a1:	e8 1a e6 ff ff       	call   80101fc0 <namei>
801039a6:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801039a9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039b0:	e8 cb 0a 00 00       	call   80104480 <acquire>

  p->state = RUNNABLE;
801039b5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
801039bc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039c3:	e8 68 0b 00 00       	call   80104530 <release>
}
801039c8:	83 c4 10             	add    $0x10,%esp
801039cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039ce:	c9                   	leave  
801039cf:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
801039d0:	83 ec 0c             	sub    $0xc,%esp
801039d3:	68 68 77 10 80       	push   $0x80107768
801039d8:	e8 93 c9 ff ff       	call   80100370 <panic>
801039dd:	8d 76 00             	lea    0x0(%esi),%esi

801039e0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	57                   	push   %edi
801039e4:	56                   	push   %esi
801039e5:	53                   	push   %ebx
801039e6:	83 ec 0c             	sub    $0xc,%esp
801039e9:	8b 7d 08             	mov    0x8(%ebp),%edi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801039ec:	e8 af 09 00 00       	call   801043a0 <pushcli>
  c = mycpu();
801039f1:	e8 2a fe ff ff       	call   80103820 <mycpu>
  p = c->proc;
801039f6:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801039fc:	e8 df 09 00 00       	call   801043e0 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
80103a01:	83 ff 00             	cmp    $0x0,%edi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80103a04:	8b 06                	mov    (%esi),%eax
  if(n > 0){
80103a06:	7e 38                	jle    80103a40 <growproc+0x60>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a08:	8d 14 38             	lea    (%eax,%edi,1),%edx
80103a0b:	83 ec 04             	sub    $0x4,%esp
80103a0e:	89 fb                	mov    %edi,%ebx
80103a10:	52                   	push   %edx
80103a11:	50                   	push   %eax
80103a12:	ff 76 04             	pushl  0x4(%esi)
80103a15:	e8 56 33 00 00       	call   80106d70 <allocuvm>
80103a1a:	83 c4 10             	add    $0x10,%esp
80103a1d:	85 c0                	test   %eax,%eax
80103a1f:	74 3f                	je     80103a60 <growproc+0x80>
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz+n;
80103a21:	01 c3                	add    %eax,%ebx
  switchuvm(curproc);
80103a23:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz+n;
80103a26:	89 1e                	mov    %ebx,(%esi)
  switchuvm(curproc);
80103a28:	56                   	push   %esi
80103a29:	e8 f2 30 00 00       	call   80106b20 <switchuvm>
  return 0;
80103a2e:	83 c4 10             	add    $0x10,%esp
80103a31:	31 c0                	xor    %eax,%eax
}
80103a33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a36:	5b                   	pop    %ebx
80103a37:	5e                   	pop    %esi
80103a38:	5f                   	pop    %edi
80103a39:	5d                   	pop    %ebp
80103a3a:	c3                   	ret    
80103a3b:	90                   	nop
80103a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a40:	bb 00 00 00 00       	mov    $0x0,%ebx

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103a45:	74 da                	je     80103a21 <growproc+0x41>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a47:	8d 14 38             	lea    (%eax,%edi,1),%edx
80103a4a:	83 ec 04             	sub    $0x4,%esp
80103a4d:	89 fb                	mov    %edi,%ebx
80103a4f:	52                   	push   %edx
80103a50:	50                   	push   %eax
80103a51:	ff 76 04             	pushl  0x4(%esi)
80103a54:	e8 17 34 00 00       	call   80106e70 <deallocuvm>
80103a59:	83 c4 10             	add    $0x10,%esp
80103a5c:	85 c0                	test   %eax,%eax
80103a5e:	75 c1                	jne    80103a21 <growproc+0x41>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103a60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a65:	eb cc                	jmp    80103a33 <growproc+0x53>
80103a67:	89 f6                	mov    %esi,%esi
80103a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a70 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	57                   	push   %edi
80103a74:	56                   	push   %esi
80103a75:	53                   	push   %ebx
80103a76:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103a79:	e8 22 09 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103a7e:	e8 9d fd ff ff       	call   80103820 <mycpu>
  p = c->proc;
80103a83:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a89:	e8 52 09 00 00       	call   801043e0 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
80103a8e:	e8 4d fc ff ff       	call   801036e0 <allocproc>
80103a93:	85 c0                	test   %eax,%eax
80103a95:	89 c7                	mov    %eax,%edi
80103a97:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103a9a:	0f 84 b5 00 00 00    	je     80103b55 <fork+0xe5>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103aa0:	83 ec 08             	sub    $0x8,%esp
80103aa3:	ff 33                	pushl  (%ebx)
80103aa5:	ff 73 04             	pushl  0x4(%ebx)
80103aa8:	e8 43 35 00 00       	call   80106ff0 <copyuvm>
80103aad:	83 c4 10             	add    $0x10,%esp
80103ab0:	85 c0                	test   %eax,%eax
80103ab2:	89 47 04             	mov    %eax,0x4(%edi)
80103ab5:	0f 84 a1 00 00 00    	je     80103b5c <fork+0xec>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103abb:	8b 03                	mov    (%ebx),%eax
80103abd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103ac0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103ac2:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103ac5:	89 c8                	mov    %ecx,%eax
80103ac7:	8b 79 18             	mov    0x18(%ecx),%edi
80103aca:	8b 73 18             	mov    0x18(%ebx),%esi
80103acd:	b9 13 00 00 00       	mov    $0x13,%ecx
80103ad2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103ad4:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103ad6:	8b 40 18             	mov    0x18(%eax),%eax
80103ad9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103ae0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ae4:	85 c0                	test   %eax,%eax
80103ae6:	74 13                	je     80103afb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103ae8:	83 ec 0c             	sub    $0xc,%esp
80103aeb:	50                   	push   %eax
80103aec:	e8 ef d2 ff ff       	call   80100de0 <filedup>
80103af1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103af4:	83 c4 10             	add    $0x10,%esp
80103af7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103afb:	83 c6 01             	add    $0x1,%esi
80103afe:	83 fe 10             	cmp    $0x10,%esi
80103b01:	75 dd                	jne    80103ae0 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103b03:	83 ec 0c             	sub    $0xc,%esp
80103b06:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b09:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103b0c:	e8 2f dc ff ff       	call   80101740 <idup>
80103b11:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b14:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103b17:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b1a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103b1d:	6a 10                	push   $0x10
80103b1f:	53                   	push   %ebx
80103b20:	50                   	push   %eax
80103b21:	e8 5a 0c 00 00       	call   80104780 <safestrcpy>

  pid = np->pid;
80103b26:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103b29:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b30:	e8 4b 09 00 00       	call   80104480 <acquire>

  np->state = RUNNABLE;
80103b35:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103b3c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b43:	e8 e8 09 00 00       	call   80104530 <release>

  return pid;
80103b48:	83 c4 10             	add    $0x10,%esp
80103b4b:	89 d8                	mov    %ebx,%eax
}
80103b4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b50:	5b                   	pop    %ebx
80103b51:	5e                   	pop    %esi
80103b52:	5f                   	pop    %edi
80103b53:	5d                   	pop    %ebp
80103b54:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103b55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b5a:	eb f1                	jmp    80103b4d <fork+0xdd>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103b5c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103b5f:	83 ec 0c             	sub    $0xc,%esp
80103b62:	ff 77 08             	pushl  0x8(%edi)
80103b65:	e8 76 e8 ff ff       	call   801023e0 <kfree>
    np->kstack = 0;
80103b6a:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103b71:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103b78:	83 c4 10             	add    $0x10,%esp
80103b7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b80:	eb cb                	jmp    80103b4d <fork+0xdd>
80103b82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b90 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	57                   	push   %edi
80103b94:	56                   	push   %esi
80103b95:	53                   	push   %ebx
80103b96:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103b99:	e8 82 fc ff ff       	call   80103820 <mycpu>
80103b9e:	8d 78 04             	lea    0x4(%eax),%edi
80103ba1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103ba3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103baa:	00 00 00 
80103bad:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103bb0:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103bb1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bb4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103bb9:	68 20 2d 11 80       	push   $0x80112d20
80103bbe:	e8 bd 08 00 00       	call   80104480 <acquire>
80103bc3:	83 c4 10             	add    $0x10,%esp
80103bc6:	eb 16                	jmp    80103bde <scheduler+0x4e>
80103bc8:	90                   	nop
80103bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bd0:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103bd6:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103bdc:	74 4a                	je     80103c28 <scheduler+0x98>
      if(p->state != RUNNABLE)
80103bde:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103be2:	75 ec                	jne    80103bd0 <scheduler+0x40>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103be4:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103be7:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103bed:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bee:	81 c3 88 00 00 00    	add    $0x88,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103bf4:	e8 27 2f 00 00       	call   80106b20 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103bf9:	58                   	pop    %eax
80103bfa:	5a                   	pop    %edx
80103bfb:	ff 73 94             	pushl  -0x6c(%ebx)
80103bfe:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103bff:	c7 43 84 04 00 00 00 	movl   $0x4,-0x7c(%ebx)

      swtch(&(c->scheduler), p->context);
80103c06:	e8 d0 0b 00 00       	call   801047db <swtch>
      switchkvm();
80103c0b:	e8 f0 2e 00 00       	call   80106b00 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103c10:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c13:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103c19:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103c20:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c23:	75 b9                	jne    80103bde <scheduler+0x4e>
80103c25:	8d 76 00             	lea    0x0(%esi),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103c28:	83 ec 0c             	sub    $0xc,%esp
80103c2b:	68 20 2d 11 80       	push   $0x80112d20
80103c30:	e8 fb 08 00 00       	call   80104530 <release>

  }
80103c35:	83 c4 10             	add    $0x10,%esp
80103c38:	e9 73 ff ff ff       	jmp    80103bb0 <scheduler+0x20>
80103c3d:	8d 76 00             	lea    0x0(%esi),%esi

80103c40 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	56                   	push   %esi
80103c44:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103c45:	e8 56 07 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103c4a:	e8 d1 fb ff ff       	call   80103820 <mycpu>
  p = c->proc;
80103c4f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c55:	e8 86 07 00 00       	call   801043e0 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103c5a:	83 ec 0c             	sub    $0xc,%esp
80103c5d:	68 20 2d 11 80       	push   $0x80112d20
80103c62:	e8 e9 07 00 00       	call   80104450 <holding>
80103c67:	83 c4 10             	add    $0x10,%esp
80103c6a:	85 c0                	test   %eax,%eax
80103c6c:	74 4f                	je     80103cbd <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103c6e:	e8 ad fb ff ff       	call   80103820 <mycpu>
80103c73:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103c7a:	75 68                	jne    80103ce4 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
80103c7c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103c80:	74 55                	je     80103cd7 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c82:	9c                   	pushf  
80103c83:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103c84:	f6 c4 02             	test   $0x2,%ah
80103c87:	75 41                	jne    80103cca <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103c89:	e8 92 fb ff ff       	call   80103820 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103c8e:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103c91:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103c97:	e8 84 fb ff ff       	call   80103820 <mycpu>
80103c9c:	83 ec 08             	sub    $0x8,%esp
80103c9f:	ff 70 04             	pushl  0x4(%eax)
80103ca2:	53                   	push   %ebx
80103ca3:	e8 33 0b 00 00       	call   801047db <swtch>
  mycpu()->intena = intena;
80103ca8:	e8 73 fb ff ff       	call   80103820 <mycpu>
}
80103cad:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80103cb0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103cb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cb9:	5b                   	pop    %ebx
80103cba:	5e                   	pop    %esi
80103cbb:	5d                   	pop    %ebp
80103cbc:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103cbd:	83 ec 0c             	sub    $0xc,%esp
80103cc0:	68 8c 77 10 80       	push   $0x8010778c
80103cc5:	e8 a6 c6 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103cca:	83 ec 0c             	sub    $0xc,%esp
80103ccd:	68 b8 77 10 80       	push   $0x801077b8
80103cd2:	e8 99 c6 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103cd7:	83 ec 0c             	sub    $0xc,%esp
80103cda:	68 aa 77 10 80       	push   $0x801077aa
80103cdf:	e8 8c c6 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103ce4:	83 ec 0c             	sub    $0xc,%esp
80103ce7:	68 9e 77 10 80       	push   $0x8010779e
80103cec:	e8 7f c6 ff ff       	call   80100370 <panic>
80103cf1:	eb 0d                	jmp    80103d00 <exit>
80103cf3:	90                   	nop
80103cf4:	90                   	nop
80103cf5:	90                   	nop
80103cf6:	90                   	nop
80103cf7:	90                   	nop
80103cf8:	90                   	nop
80103cf9:	90                   	nop
80103cfa:	90                   	nop
80103cfb:	90                   	nop
80103cfc:	90                   	nop
80103cfd:	90                   	nop
80103cfe:	90                   	nop
80103cff:	90                   	nop

80103d00 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	57                   	push   %edi
80103d04:	56                   	push   %esi
80103d05:	53                   	push   %ebx
80103d06:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d09:	e8 92 06 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103d0e:	e8 0d fb ff ff       	call   80103820 <mycpu>
  p = c->proc;
80103d13:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103d19:	e8 c2 06 00 00       	call   801043e0 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103d1e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103d24:	8d 5e 28             	lea    0x28(%esi),%ebx
80103d27:	8d 7e 68             	lea    0x68(%esi),%edi
80103d2a:	0f 84 f1 00 00 00    	je     80103e21 <exit+0x121>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103d30:	8b 03                	mov    (%ebx),%eax
80103d32:	85 c0                	test   %eax,%eax
80103d34:	74 12                	je     80103d48 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103d36:	83 ec 0c             	sub    $0xc,%esp
80103d39:	50                   	push   %eax
80103d3a:	e8 f1 d0 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103d3f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103d45:	83 c4 10             	add    $0x10,%esp
80103d48:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103d4b:	39 df                	cmp    %ebx,%edi
80103d4d:	75 e1                	jne    80103d30 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103d4f:	e8 ec ee ff ff       	call   80102c40 <begin_op>
  iput(curproc->cwd);
80103d54:	83 ec 0c             	sub    $0xc,%esp
80103d57:	ff 76 68             	pushl  0x68(%esi)
80103d5a:	e8 41 db ff ff       	call   801018a0 <iput>
  end_op();
80103d5f:	e8 4c ef ff ff       	call   80102cb0 <end_op>
  curproc->cwd = 0;
80103d64:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
80103d6b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d72:	e8 09 07 00 00       	call   80104480 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103d77:	8b 56 14             	mov    0x14(%esi),%edx
80103d7a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d7d:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d82:	eb 10                	jmp    80103d94 <exit+0x94>
80103d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d88:	05 88 00 00 00       	add    $0x88,%eax
80103d8d:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103d92:	74 1e                	je     80103db2 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80103d94:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d98:	75 ee                	jne    80103d88 <exit+0x88>
80103d9a:	3b 50 20             	cmp    0x20(%eax),%edx
80103d9d:	75 e9                	jne    80103d88 <exit+0x88>
      p->state = RUNNABLE;
80103d9f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103da6:	05 88 00 00 00       	add    $0x88,%eax
80103dab:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103db0:	75 e2                	jne    80103d94 <exit+0x94>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103db2:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
80103db8:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103dbd:	eb 0f                	jmp    80103dce <exit+0xce>
80103dbf:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dc0:	81 c2 88 00 00 00    	add    $0x88,%edx
80103dc6:	81 fa 54 4f 11 80    	cmp    $0x80114f54,%edx
80103dcc:	74 3a                	je     80103e08 <exit+0x108>
    if(p->parent == curproc){
80103dce:	39 72 14             	cmp    %esi,0x14(%edx)
80103dd1:	75 ed                	jne    80103dc0 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103dd3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103dd7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103dda:	75 e4                	jne    80103dc0 <exit+0xc0>
80103ddc:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103de1:	eb 11                	jmp    80103df4 <exit+0xf4>
80103de3:	90                   	nop
80103de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103de8:	05 88 00 00 00       	add    $0x88,%eax
80103ded:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103df2:	74 cc                	je     80103dc0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103df4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103df8:	75 ee                	jne    80103de8 <exit+0xe8>
80103dfa:	3b 48 20             	cmp    0x20(%eax),%ecx
80103dfd:	75 e9                	jne    80103de8 <exit+0xe8>
      p->state = RUNNABLE;
80103dff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e06:	eb e0                	jmp    80103de8 <exit+0xe8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103e08:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103e0f:	e8 2c fe ff ff       	call   80103c40 <sched>
  panic("zombie exit");
80103e14:	83 ec 0c             	sub    $0xc,%esp
80103e17:	68 d9 77 10 80       	push   $0x801077d9
80103e1c:	e8 4f c5 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103e21:	83 ec 0c             	sub    $0xc,%esp
80103e24:	68 cc 77 10 80       	push   $0x801077cc
80103e29:	e8 42 c5 ff ff       	call   80100370 <panic>
80103e2e:	66 90                	xchg   %ax,%ax

80103e30 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	53                   	push   %ebx
80103e34:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103e37:	68 20 2d 11 80       	push   $0x80112d20
80103e3c:	e8 3f 06 00 00       	call   80104480 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103e41:	e8 5a 05 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103e46:	e8 d5 f9 ff ff       	call   80103820 <mycpu>
  p = c->proc;
80103e4b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e51:	e8 8a 05 00 00       	call   801043e0 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
80103e56:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103e5d:	e8 de fd ff ff       	call   80103c40 <sched>
  release(&ptable.lock);
80103e62:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e69:	e8 c2 06 00 00       	call   80104530 <release>
}
80103e6e:	83 c4 10             	add    $0x10,%esp
80103e71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e74:	c9                   	leave  
80103e75:	c3                   	ret    
80103e76:	8d 76 00             	lea    0x0(%esi),%esi
80103e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e80 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	57                   	push   %edi
80103e84:	56                   	push   %esi
80103e85:	53                   	push   %ebx
80103e86:	83 ec 0c             	sub    $0xc,%esp
80103e89:	8b 7d 08             	mov    0x8(%ebp),%edi
80103e8c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103e8f:	e8 0c 05 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103e94:	e8 87 f9 ff ff       	call   80103820 <mycpu>
  p = c->proc;
80103e99:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e9f:	e8 3c 05 00 00       	call   801043e0 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80103ea4:	85 db                	test   %ebx,%ebx
80103ea6:	0f 84 87 00 00 00    	je     80103f33 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
80103eac:	85 f6                	test   %esi,%esi
80103eae:	74 76                	je     80103f26 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103eb0:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103eb6:	74 50                	je     80103f08 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103eb8:	83 ec 0c             	sub    $0xc,%esp
80103ebb:	68 20 2d 11 80       	push   $0x80112d20
80103ec0:	e8 bb 05 00 00       	call   80104480 <acquire>
    release(lk);
80103ec5:	89 34 24             	mov    %esi,(%esp)
80103ec8:	e8 63 06 00 00       	call   80104530 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103ecd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103ed0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103ed7:	e8 64 fd ff ff       	call   80103c40 <sched>

  // Tidy up.
  p->chan = 0;
80103edc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103ee3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103eea:	e8 41 06 00 00       	call   80104530 <release>
    acquire(lk);
80103eef:	89 75 08             	mov    %esi,0x8(%ebp)
80103ef2:	83 c4 10             	add    $0x10,%esp
  }
}
80103ef5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ef8:	5b                   	pop    %ebx
80103ef9:	5e                   	pop    %esi
80103efa:	5f                   	pop    %edi
80103efb:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103efc:	e9 7f 05 00 00       	jmp    80104480 <acquire>
80103f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103f08:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f0b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103f12:	e8 29 fd ff ff       	call   80103c40 <sched>

  // Tidy up.
  p->chan = 0;
80103f17:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103f1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f21:	5b                   	pop    %ebx
80103f22:	5e                   	pop    %esi
80103f23:	5f                   	pop    %edi
80103f24:	5d                   	pop    %ebp
80103f25:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103f26:	83 ec 0c             	sub    $0xc,%esp
80103f29:	68 eb 77 10 80       	push   $0x801077eb
80103f2e:	e8 3d c4 ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103f33:	83 ec 0c             	sub    $0xc,%esp
80103f36:	68 e5 77 10 80       	push   $0x801077e5
80103f3b:	e8 30 c4 ff ff       	call   80100370 <panic>

80103f40 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103f40:	55                   	push   %ebp
80103f41:	89 e5                	mov    %esp,%ebp
80103f43:	56                   	push   %esi
80103f44:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103f45:	e8 56 04 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103f4a:	e8 d1 f8 ff ff       	call   80103820 <mycpu>
  p = c->proc;
80103f4f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f55:	e8 86 04 00 00       	call   801043e0 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
80103f5a:	83 ec 0c             	sub    $0xc,%esp
80103f5d:	68 20 2d 11 80       	push   $0x80112d20
80103f62:	e8 19 05 00 00       	call   80104480 <acquire>
80103f67:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103f6a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f6c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103f71:	eb 13                	jmp    80103f86 <wait+0x46>
80103f73:	90                   	nop
80103f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f78:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103f7e:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103f84:	74 22                	je     80103fa8 <wait+0x68>
      if(p->parent != curproc)
80103f86:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f89:	75 ed                	jne    80103f78 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103f8b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f8f:	74 35                	je     80103fc6 <wait+0x86>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f91:	81 c3 88 00 00 00    	add    $0x88,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103f97:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f9c:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103fa2:	75 e2                	jne    80103f86 <wait+0x46>
80103fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103fa8:	85 c0                	test   %eax,%eax
80103faa:	74 70                	je     8010401c <wait+0xdc>
80103fac:	8b 46 24             	mov    0x24(%esi),%eax
80103faf:	85 c0                	test   %eax,%eax
80103fb1:	75 69                	jne    8010401c <wait+0xdc>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103fb3:	83 ec 08             	sub    $0x8,%esp
80103fb6:	68 20 2d 11 80       	push   $0x80112d20
80103fbb:	56                   	push   %esi
80103fbc:	e8 bf fe ff ff       	call   80103e80 <sleep>
  }
80103fc1:	83 c4 10             	add    $0x10,%esp
80103fc4:	eb a4                	jmp    80103f6a <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103fc6:	83 ec 0c             	sub    $0xc,%esp
80103fc9:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103fcc:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103fcf:	e8 0c e4 ff ff       	call   801023e0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103fd4:	5a                   	pop    %edx
80103fd5:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103fd8:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103fdf:	e8 bc 2e 00 00       	call   80106ea0 <freevm>
        p->pid = 0;
80103fe4:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103feb:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103ff2:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103ff6:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103ffd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104004:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010400b:	e8 20 05 00 00       	call   80104530 <release>
        return pid;
80104010:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104013:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80104016:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104018:	5b                   	pop    %ebx
80104019:	5e                   	pop    %esi
8010401a:	5d                   	pop    %ebp
8010401b:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
8010401c:	83 ec 0c             	sub    $0xc,%esp
8010401f:	68 20 2d 11 80       	push   $0x80112d20
80104024:	e8 07 05 00 00       	call   80104530 <release>
      return -1;
80104029:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
8010402c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
8010402f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104034:	5b                   	pop    %ebx
80104035:	5e                   	pop    %esi
80104036:	5d                   	pop    %ebp
80104037:	c3                   	ret    
80104038:	90                   	nop
80104039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104040 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	53                   	push   %ebx
80104044:	83 ec 10             	sub    $0x10,%esp
80104047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010404a:	68 20 2d 11 80       	push   $0x80112d20
8010404f:	e8 2c 04 00 00       	call   80104480 <acquire>
80104054:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104057:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010405c:	eb 0e                	jmp    8010406c <wakeup+0x2c>
8010405e:	66 90                	xchg   %ax,%ax
80104060:	05 88 00 00 00       	add    $0x88,%eax
80104065:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
8010406a:	74 1e                	je     8010408a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010406c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104070:	75 ee                	jne    80104060 <wakeup+0x20>
80104072:	3b 58 20             	cmp    0x20(%eax),%ebx
80104075:	75 e9                	jne    80104060 <wakeup+0x20>
      p->state = RUNNABLE;
80104077:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010407e:	05 88 00 00 00       	add    $0x88,%eax
80104083:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80104088:	75 e2                	jne    8010406c <wakeup+0x2c>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
8010408a:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104091:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104094:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104095:	e9 96 04 00 00       	jmp    80104530 <release>
8010409a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	53                   	push   %ebx
801040a4:	83 ec 10             	sub    $0x10,%esp
801040a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801040aa:	68 20 2d 11 80       	push   $0x80112d20
801040af:	e8 cc 03 00 00       	call   80104480 <acquire>
801040b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040b7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801040bc:	eb 0e                	jmp    801040cc <kill+0x2c>
801040be:	66 90                	xchg   %ax,%ax
801040c0:	05 88 00 00 00       	add    $0x88,%eax
801040c5:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
801040ca:	74 3c                	je     80104108 <kill+0x68>
    if(p->pid == pid){
801040cc:	39 58 10             	cmp    %ebx,0x10(%eax)
801040cf:	75 ef                	jne    801040c0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801040d1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
801040d5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801040dc:	74 1a                	je     801040f8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
801040de:	83 ec 0c             	sub    $0xc,%esp
801040e1:	68 20 2d 11 80       	push   $0x80112d20
801040e6:	e8 45 04 00 00       	call   80104530 <release>
      return 0;
801040eb:	83 c4 10             	add    $0x10,%esp
801040ee:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801040f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040f3:	c9                   	leave  
801040f4:	c3                   	ret    
801040f5:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
801040f8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801040ff:	eb dd                	jmp    801040de <kill+0x3e>
80104101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104108:	83 ec 0c             	sub    $0xc,%esp
8010410b:	68 20 2d 11 80       	push   $0x80112d20
80104110:	e8 1b 04 00 00       	call   80104530 <release>
  return -1;
80104115:	83 c4 10             	add    $0x10,%esp
80104118:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010411d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104120:	c9                   	leave  
80104121:	c3                   	ret    
80104122:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104130 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	57                   	push   %edi
80104134:	56                   	push   %esi
80104135:	53                   	push   %ebx
80104136:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104139:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010413e:	83 ec 3c             	sub    $0x3c,%esp
80104141:	eb 27                	jmp    8010416a <procdump+0x3a>
80104143:	90                   	nop
80104144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104148:	83 ec 0c             	sub    $0xc,%esp
8010414b:	68 e4 79 10 80       	push   $0x801079e4
80104150:	e8 0b c5 ff ff       	call   80100660 <cprintf>
80104155:	83 c4 10             	add    $0x10,%esp
80104158:	81 c3 88 00 00 00    	add    $0x88,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010415e:	81 fb c0 4f 11 80    	cmp    $0x80114fc0,%ebx
80104164:	0f 84 7e 00 00 00    	je     801041e8 <procdump+0xb8>
    if(p->state == UNUSED)
8010416a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010416d:	85 c0                	test   %eax,%eax
8010416f:	74 e7                	je     80104158 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104171:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104174:	ba fc 77 10 80       	mov    $0x801077fc,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104179:	77 11                	ja     8010418c <procdump+0x5c>
8010417b:	8b 14 85 5c 78 10 80 	mov    -0x7fef87a4(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80104182:	b8 fc 77 10 80       	mov    $0x801077fc,%eax
80104187:	85 d2                	test   %edx,%edx
80104189:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010418c:	53                   	push   %ebx
8010418d:	52                   	push   %edx
8010418e:	ff 73 a4             	pushl  -0x5c(%ebx)
80104191:	68 00 78 10 80       	push   $0x80107800
80104196:	e8 c5 c4 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010419b:	83 c4 10             	add    $0x10,%esp
8010419e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801041a2:	75 a4                	jne    80104148 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801041a4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801041a7:	83 ec 08             	sub    $0x8,%esp
801041aa:	8d 7d c0             	lea    -0x40(%ebp),%edi
801041ad:	50                   	push   %eax
801041ae:	8b 43 b0             	mov    -0x50(%ebx),%eax
801041b1:	8b 40 0c             	mov    0xc(%eax),%eax
801041b4:	83 c0 08             	add    $0x8,%eax
801041b7:	50                   	push   %eax
801041b8:	e8 83 01 00 00       	call   80104340 <getcallerpcs>
801041bd:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801041c0:	8b 17                	mov    (%edi),%edx
801041c2:	85 d2                	test   %edx,%edx
801041c4:	74 82                	je     80104148 <procdump+0x18>
        cprintf(" %p", pc[i]);
801041c6:	83 ec 08             	sub    $0x8,%esp
801041c9:	83 c7 04             	add    $0x4,%edi
801041cc:	52                   	push   %edx
801041cd:	68 21 72 10 80       	push   $0x80107221
801041d2:	e8 89 c4 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801041d7:	83 c4 10             	add    $0x10,%esp
801041da:	39 f7                	cmp    %esi,%edi
801041dc:	75 e2                	jne    801041c0 <procdump+0x90>
801041de:	e9 65 ff ff ff       	jmp    80104148 <procdump+0x18>
801041e3:	90                   	nop
801041e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801041e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041eb:	5b                   	pop    %ebx
801041ec:	5e                   	pop    %esi
801041ed:	5f                   	pop    %edi
801041ee:	5d                   	pop    %ebp
801041ef:	c3                   	ret    

801041f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	53                   	push   %ebx
801041f4:	83 ec 0c             	sub    $0xc,%esp
801041f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801041fa:	68 74 78 10 80       	push   $0x80107874
801041ff:	8d 43 04             	lea    0x4(%ebx),%eax
80104202:	50                   	push   %eax
80104203:	e8 18 01 00 00       	call   80104320 <initlock>
  lk->name = name;
80104208:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010420b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104211:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104214:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010421b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010421e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104221:	c9                   	leave  
80104222:	c3                   	ret    
80104223:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104230 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	56                   	push   %esi
80104234:	53                   	push   %ebx
80104235:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104238:	83 ec 0c             	sub    $0xc,%esp
8010423b:	8d 73 04             	lea    0x4(%ebx),%esi
8010423e:	56                   	push   %esi
8010423f:	e8 3c 02 00 00       	call   80104480 <acquire>
  while (lk->locked) {
80104244:	8b 13                	mov    (%ebx),%edx
80104246:	83 c4 10             	add    $0x10,%esp
80104249:	85 d2                	test   %edx,%edx
8010424b:	74 16                	je     80104263 <acquiresleep+0x33>
8010424d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104250:	83 ec 08             	sub    $0x8,%esp
80104253:	56                   	push   %esi
80104254:	53                   	push   %ebx
80104255:	e8 26 fc ff ff       	call   80103e80 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010425a:	8b 03                	mov    (%ebx),%eax
8010425c:	83 c4 10             	add    $0x10,%esp
8010425f:	85 c0                	test   %eax,%eax
80104261:	75 ed                	jne    80104250 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104263:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104269:	e8 52 f6 ff ff       	call   801038c0 <myproc>
8010426e:	8b 40 10             	mov    0x10(%eax),%eax
80104271:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104274:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104277:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010427a:	5b                   	pop    %ebx
8010427b:	5e                   	pop    %esi
8010427c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010427d:	e9 ae 02 00 00       	jmp    80104530 <release>
80104282:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104290 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	56                   	push   %esi
80104294:	53                   	push   %ebx
80104295:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104298:	83 ec 0c             	sub    $0xc,%esp
8010429b:	8d 73 04             	lea    0x4(%ebx),%esi
8010429e:	56                   	push   %esi
8010429f:	e8 dc 01 00 00       	call   80104480 <acquire>
  lk->locked = 0;
801042a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801042aa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801042b1:	89 1c 24             	mov    %ebx,(%esp)
801042b4:	e8 87 fd ff ff       	call   80104040 <wakeup>
  release(&lk->lk);
801042b9:	89 75 08             	mov    %esi,0x8(%ebp)
801042bc:	83 c4 10             	add    $0x10,%esp
}
801042bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042c2:	5b                   	pop    %ebx
801042c3:	5e                   	pop    %esi
801042c4:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
801042c5:	e9 66 02 00 00       	jmp    80104530 <release>
801042ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042d0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	57                   	push   %edi
801042d4:	56                   	push   %esi
801042d5:	53                   	push   %ebx
801042d6:	31 ff                	xor    %edi,%edi
801042d8:	83 ec 18             	sub    $0x18,%esp
801042db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801042de:	8d 73 04             	lea    0x4(%ebx),%esi
801042e1:	56                   	push   %esi
801042e2:	e8 99 01 00 00       	call   80104480 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801042e7:	8b 03                	mov    (%ebx),%eax
801042e9:	83 c4 10             	add    $0x10,%esp
801042ec:	85 c0                	test   %eax,%eax
801042ee:	74 13                	je     80104303 <holdingsleep+0x33>
801042f0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801042f3:	e8 c8 f5 ff ff       	call   801038c0 <myproc>
801042f8:	39 58 10             	cmp    %ebx,0x10(%eax)
801042fb:	0f 94 c0             	sete   %al
801042fe:	0f b6 c0             	movzbl %al,%eax
80104301:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104303:	83 ec 0c             	sub    $0xc,%esp
80104306:	56                   	push   %esi
80104307:	e8 24 02 00 00       	call   80104530 <release>
  return r;
}
8010430c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010430f:	89 f8                	mov    %edi,%eax
80104311:	5b                   	pop    %ebx
80104312:	5e                   	pop    %esi
80104313:	5f                   	pop    %edi
80104314:	5d                   	pop    %ebp
80104315:	c3                   	ret    
80104316:	66 90                	xchg   %ax,%ax
80104318:	66 90                	xchg   %ax,%ax
8010431a:	66 90                	xchg   %ax,%ax
8010431c:	66 90                	xchg   %ax,%ax
8010431e:	66 90                	xchg   %ax,%ax

80104320 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104326:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104329:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010432f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104332:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104339:	5d                   	pop    %ebp
8010433a:	c3                   	ret    
8010433b:	90                   	nop
8010433c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104340 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104344:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104347:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010434a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010434d:	31 c0                	xor    %eax,%eax
8010434f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104350:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104356:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010435c:	77 1a                	ja     80104378 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010435e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104361:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104364:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104367:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104369:	83 f8 0a             	cmp    $0xa,%eax
8010436c:	75 e2                	jne    80104350 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010436e:	5b                   	pop    %ebx
8010436f:	5d                   	pop    %ebp
80104370:	c3                   	ret    
80104371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104378:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010437f:	83 c0 01             	add    $0x1,%eax
80104382:	83 f8 0a             	cmp    $0xa,%eax
80104385:	74 e7                	je     8010436e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104387:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010438e:	83 c0 01             	add    $0x1,%eax
80104391:	83 f8 0a             	cmp    $0xa,%eax
80104394:	75 e2                	jne    80104378 <getcallerpcs+0x38>
80104396:	eb d6                	jmp    8010436e <getcallerpcs+0x2e>
80104398:	90                   	nop
80104399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	53                   	push   %ebx
801043a4:	83 ec 04             	sub    $0x4,%esp
801043a7:	9c                   	pushf  
801043a8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
801043a9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801043aa:	e8 71 f4 ff ff       	call   80103820 <mycpu>
801043af:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801043b5:	85 c0                	test   %eax,%eax
801043b7:	75 11                	jne    801043ca <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801043b9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801043bf:	e8 5c f4 ff ff       	call   80103820 <mycpu>
801043c4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801043ca:	e8 51 f4 ff ff       	call   80103820 <mycpu>
801043cf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801043d6:	83 c4 04             	add    $0x4,%esp
801043d9:	5b                   	pop    %ebx
801043da:	5d                   	pop    %ebp
801043db:	c3                   	ret    
801043dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801043e0 <popcli>:

void
popcli(void)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043e6:	9c                   	pushf  
801043e7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801043e8:	f6 c4 02             	test   $0x2,%ah
801043eb:	75 52                	jne    8010443f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801043ed:	e8 2e f4 ff ff       	call   80103820 <mycpu>
801043f2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801043f8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801043fb:	85 d2                	test   %edx,%edx
801043fd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104403:	78 2d                	js     80104432 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104405:	e8 16 f4 ff ff       	call   80103820 <mycpu>
8010440a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104410:	85 d2                	test   %edx,%edx
80104412:	74 0c                	je     80104420 <popcli+0x40>
    sti();
}
80104414:	c9                   	leave  
80104415:	c3                   	ret    
80104416:	8d 76 00             	lea    0x0(%esi),%esi
80104419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104420:	e8 fb f3 ff ff       	call   80103820 <mycpu>
80104425:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010442b:	85 c0                	test   %eax,%eax
8010442d:	74 e5                	je     80104414 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
8010442f:	fb                   	sti    
    sti();
}
80104430:	c9                   	leave  
80104431:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104432:	83 ec 0c             	sub    $0xc,%esp
80104435:	68 96 78 10 80       	push   $0x80107896
8010443a:	e8 31 bf ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
8010443f:	83 ec 0c             	sub    $0xc,%esp
80104442:	68 7f 78 10 80       	push   $0x8010787f
80104447:	e8 24 bf ff ff       	call   80100370 <panic>
8010444c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104450 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	56                   	push   %esi
80104454:	53                   	push   %ebx
80104455:	8b 75 08             	mov    0x8(%ebp),%esi
80104458:	31 db                	xor    %ebx,%ebx
  int r;
  pushcli();
8010445a:	e8 41 ff ff ff       	call   801043a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010445f:	8b 06                	mov    (%esi),%eax
80104461:	85 c0                	test   %eax,%eax
80104463:	74 10                	je     80104475 <holding+0x25>
80104465:	8b 5e 08             	mov    0x8(%esi),%ebx
80104468:	e8 b3 f3 ff ff       	call   80103820 <mycpu>
8010446d:	39 c3                	cmp    %eax,%ebx
8010446f:	0f 94 c3             	sete   %bl
80104472:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104475:	e8 66 ff ff ff       	call   801043e0 <popcli>
  return r;
}
8010447a:	89 d8                	mov    %ebx,%eax
8010447c:	5b                   	pop    %ebx
8010447d:	5e                   	pop    %esi
8010447e:	5d                   	pop    %ebp
8010447f:	c3                   	ret    

80104480 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	53                   	push   %ebx
80104484:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104487:	e8 14 ff ff ff       	call   801043a0 <pushcli>
  if(holding(lk))
8010448c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010448f:	83 ec 0c             	sub    $0xc,%esp
80104492:	53                   	push   %ebx
80104493:	e8 b8 ff ff ff       	call   80104450 <holding>
80104498:	83 c4 10             	add    $0x10,%esp
8010449b:	85 c0                	test   %eax,%eax
8010449d:	0f 85 7d 00 00 00    	jne    80104520 <acquire+0xa0>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801044a3:	ba 01 00 00 00       	mov    $0x1,%edx
801044a8:	eb 09                	jmp    801044b3 <acquire+0x33>
801044aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044b3:	89 d0                	mov    %edx,%eax
801044b5:	f0 87 03             	lock xchg %eax,(%ebx)
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801044b8:	85 c0                	test   %eax,%eax
801044ba:	75 f4                	jne    801044b0 <acquire+0x30>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801044bc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801044c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044c4:	e8 57 f3 ff ff       	call   80103820 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801044c9:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
801044cb:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801044ce:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801044d1:	31 c0                	xor    %eax,%eax
801044d3:	90                   	nop
801044d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801044d8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801044de:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801044e4:	77 1a                	ja     80104500 <acquire+0x80>
      break;
    pcs[i] = ebp[1];     // saved %eip
801044e6:	8b 5a 04             	mov    0x4(%edx),%ebx
801044e9:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801044ec:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801044ef:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801044f1:	83 f8 0a             	cmp    $0xa,%eax
801044f4:	75 e2                	jne    801044d8 <acquire+0x58>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
801044f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044f9:	c9                   	leave  
801044fa:	c3                   	ret    
801044fb:	90                   	nop
801044fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104500:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104507:	83 c0 01             	add    $0x1,%eax
8010450a:	83 f8 0a             	cmp    $0xa,%eax
8010450d:	74 e7                	je     801044f6 <acquire+0x76>
    pcs[i] = 0;
8010450f:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104516:	83 c0 01             	add    $0x1,%eax
80104519:	83 f8 0a             	cmp    $0xa,%eax
8010451c:	75 e2                	jne    80104500 <acquire+0x80>
8010451e:	eb d6                	jmp    801044f6 <acquire+0x76>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104520:	83 ec 0c             	sub    $0xc,%esp
80104523:	68 9d 78 10 80       	push   $0x8010789d
80104528:	e8 43 be ff ff       	call   80100370 <panic>
8010452d:	8d 76 00             	lea    0x0(%esi),%esi

80104530 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	53                   	push   %ebx
80104534:	83 ec 10             	sub    $0x10,%esp
80104537:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010453a:	53                   	push   %ebx
8010453b:	e8 10 ff ff ff       	call   80104450 <holding>
80104540:	83 c4 10             	add    $0x10,%esp
80104543:	85 c0                	test   %eax,%eax
80104545:	74 22                	je     80104569 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
80104547:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010454e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104555:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010455a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104560:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104563:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104564:	e9 77 fe ff ff       	jmp    801043e0 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104569:	83 ec 0c             	sub    $0xc,%esp
8010456c:	68 a5 78 10 80       	push   $0x801078a5
80104571:	e8 fa bd ff ff       	call   80100370 <panic>
80104576:	66 90                	xchg   %ax,%ax
80104578:	66 90                	xchg   %ax,%ax
8010457a:	66 90                	xchg   %ax,%ax
8010457c:	66 90                	xchg   %ax,%ax
8010457e:	66 90                	xchg   %ax,%ax

80104580 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	57                   	push   %edi
80104584:	53                   	push   %ebx
80104585:	8b 55 08             	mov    0x8(%ebp),%edx
80104588:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010458b:	f6 c2 03             	test   $0x3,%dl
8010458e:	75 05                	jne    80104595 <memset+0x15>
80104590:	f6 c1 03             	test   $0x3,%cl
80104593:	74 13                	je     801045a8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104595:	89 d7                	mov    %edx,%edi
80104597:	8b 45 0c             	mov    0xc(%ebp),%eax
8010459a:	fc                   	cld    
8010459b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010459d:	5b                   	pop    %ebx
8010459e:	89 d0                	mov    %edx,%eax
801045a0:	5f                   	pop    %edi
801045a1:	5d                   	pop    %ebp
801045a2:	c3                   	ret    
801045a3:	90                   	nop
801045a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
801045a8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801045ac:	c1 e9 02             	shr    $0x2,%ecx
801045af:	89 fb                	mov    %edi,%ebx
801045b1:	89 f8                	mov    %edi,%eax
801045b3:	c1 e3 18             	shl    $0x18,%ebx
801045b6:	c1 e0 10             	shl    $0x10,%eax
801045b9:	09 d8                	or     %ebx,%eax
801045bb:	09 f8                	or     %edi,%eax
801045bd:	c1 e7 08             	shl    $0x8,%edi
801045c0:	09 f8                	or     %edi,%eax
801045c2:	89 d7                	mov    %edx,%edi
801045c4:	fc                   	cld    
801045c5:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801045c7:	5b                   	pop    %ebx
801045c8:	89 d0                	mov    %edx,%eax
801045ca:	5f                   	pop    %edi
801045cb:	5d                   	pop    %ebp
801045cc:	c3                   	ret    
801045cd:	8d 76 00             	lea    0x0(%esi),%esi

801045d0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	57                   	push   %edi
801045d4:	56                   	push   %esi
801045d5:	8b 45 10             	mov    0x10(%ebp),%eax
801045d8:	53                   	push   %ebx
801045d9:	8b 75 0c             	mov    0xc(%ebp),%esi
801045dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801045df:	85 c0                	test   %eax,%eax
801045e1:	74 29                	je     8010460c <memcmp+0x3c>
    if(*s1 != *s2)
801045e3:	0f b6 13             	movzbl (%ebx),%edx
801045e6:	0f b6 0e             	movzbl (%esi),%ecx
801045e9:	38 d1                	cmp    %dl,%cl
801045eb:	75 2b                	jne    80104618 <memcmp+0x48>
801045ed:	8d 78 ff             	lea    -0x1(%eax),%edi
801045f0:	31 c0                	xor    %eax,%eax
801045f2:	eb 14                	jmp    80104608 <memcmp+0x38>
801045f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045f8:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
801045fd:	83 c0 01             	add    $0x1,%eax
80104600:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104604:	38 ca                	cmp    %cl,%dl
80104606:	75 10                	jne    80104618 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104608:	39 f8                	cmp    %edi,%eax
8010460a:	75 ec                	jne    801045f8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010460c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010460d:	31 c0                	xor    %eax,%eax
}
8010460f:	5e                   	pop    %esi
80104610:	5f                   	pop    %edi
80104611:	5d                   	pop    %ebp
80104612:	c3                   	ret    
80104613:	90                   	nop
80104614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104618:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
8010461b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
8010461c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010461e:	5e                   	pop    %esi
8010461f:	5f                   	pop    %edi
80104620:	5d                   	pop    %ebp
80104621:	c3                   	ret    
80104622:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104630 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	56                   	push   %esi
80104634:	53                   	push   %ebx
80104635:	8b 45 08             	mov    0x8(%ebp),%eax
80104638:	8b 75 0c             	mov    0xc(%ebp),%esi
8010463b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010463e:	39 c6                	cmp    %eax,%esi
80104640:	73 2e                	jae    80104670 <memmove+0x40>
80104642:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104645:	39 c8                	cmp    %ecx,%eax
80104647:	73 27                	jae    80104670 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104649:	85 db                	test   %ebx,%ebx
8010464b:	8d 53 ff             	lea    -0x1(%ebx),%edx
8010464e:	74 17                	je     80104667 <memmove+0x37>
      *--d = *--s;
80104650:	29 d9                	sub    %ebx,%ecx
80104652:	89 cb                	mov    %ecx,%ebx
80104654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104658:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
8010465c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010465f:	83 ea 01             	sub    $0x1,%edx
80104662:	83 fa ff             	cmp    $0xffffffff,%edx
80104665:	75 f1                	jne    80104658 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104667:	5b                   	pop    %ebx
80104668:	5e                   	pop    %esi
80104669:	5d                   	pop    %ebp
8010466a:	c3                   	ret    
8010466b:	90                   	nop
8010466c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104670:	31 d2                	xor    %edx,%edx
80104672:	85 db                	test   %ebx,%ebx
80104674:	74 f1                	je     80104667 <memmove+0x37>
80104676:	8d 76 00             	lea    0x0(%esi),%esi
80104679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104680:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104684:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104687:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010468a:	39 d3                	cmp    %edx,%ebx
8010468c:	75 f2                	jne    80104680 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010468e:	5b                   	pop    %ebx
8010468f:	5e                   	pop    %esi
80104690:	5d                   	pop    %ebp
80104691:	c3                   	ret    
80104692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046a0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801046a3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801046a4:	eb 8a                	jmp    80104630 <memmove>
801046a6:	8d 76 00             	lea    0x0(%esi),%esi
801046a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046b0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	57                   	push   %edi
801046b4:	56                   	push   %esi
801046b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046b8:	53                   	push   %ebx
801046b9:	8b 7d 08             	mov    0x8(%ebp),%edi
801046bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801046bf:	85 c9                	test   %ecx,%ecx
801046c1:	74 37                	je     801046fa <strncmp+0x4a>
801046c3:	0f b6 17             	movzbl (%edi),%edx
801046c6:	0f b6 1e             	movzbl (%esi),%ebx
801046c9:	84 d2                	test   %dl,%dl
801046cb:	74 3f                	je     8010470c <strncmp+0x5c>
801046cd:	38 d3                	cmp    %dl,%bl
801046cf:	75 3b                	jne    8010470c <strncmp+0x5c>
801046d1:	8d 47 01             	lea    0x1(%edi),%eax
801046d4:	01 cf                	add    %ecx,%edi
801046d6:	eb 1b                	jmp    801046f3 <strncmp+0x43>
801046d8:	90                   	nop
801046d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046e0:	0f b6 10             	movzbl (%eax),%edx
801046e3:	84 d2                	test   %dl,%dl
801046e5:	74 21                	je     80104708 <strncmp+0x58>
801046e7:	0f b6 19             	movzbl (%ecx),%ebx
801046ea:	83 c0 01             	add    $0x1,%eax
801046ed:	89 ce                	mov    %ecx,%esi
801046ef:	38 da                	cmp    %bl,%dl
801046f1:	75 19                	jne    8010470c <strncmp+0x5c>
801046f3:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
801046f5:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801046f8:	75 e6                	jne    801046e0 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801046fa:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
801046fb:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
801046fd:	5e                   	pop    %esi
801046fe:	5f                   	pop    %edi
801046ff:	5d                   	pop    %ebp
80104700:	c3                   	ret    
80104701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104708:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010470c:	0f b6 c2             	movzbl %dl,%eax
8010470f:	29 d8                	sub    %ebx,%eax
}
80104711:	5b                   	pop    %ebx
80104712:	5e                   	pop    %esi
80104713:	5f                   	pop    %edi
80104714:	5d                   	pop    %ebp
80104715:	c3                   	ret    
80104716:	8d 76 00             	lea    0x0(%esi),%esi
80104719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104720 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	56                   	push   %esi
80104724:	53                   	push   %ebx
80104725:	8b 45 08             	mov    0x8(%ebp),%eax
80104728:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010472b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010472e:	89 c2                	mov    %eax,%edx
80104730:	eb 19                	jmp    8010474b <strncpy+0x2b>
80104732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104738:	83 c3 01             	add    $0x1,%ebx
8010473b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010473f:	83 c2 01             	add    $0x1,%edx
80104742:	84 c9                	test   %cl,%cl
80104744:	88 4a ff             	mov    %cl,-0x1(%edx)
80104747:	74 09                	je     80104752 <strncpy+0x32>
80104749:	89 f1                	mov    %esi,%ecx
8010474b:	85 c9                	test   %ecx,%ecx
8010474d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104750:	7f e6                	jg     80104738 <strncpy+0x18>
    ;
  while(n-- > 0)
80104752:	31 c9                	xor    %ecx,%ecx
80104754:	85 f6                	test   %esi,%esi
80104756:	7e 17                	jle    8010476f <strncpy+0x4f>
80104758:	90                   	nop
80104759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104760:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104764:	89 f3                	mov    %esi,%ebx
80104766:	83 c1 01             	add    $0x1,%ecx
80104769:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010476b:	85 db                	test   %ebx,%ebx
8010476d:	7f f1                	jg     80104760 <strncpy+0x40>
    *s++ = 0;
  return os;
}
8010476f:	5b                   	pop    %ebx
80104770:	5e                   	pop    %esi
80104771:	5d                   	pop    %ebp
80104772:	c3                   	ret    
80104773:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104780 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	56                   	push   %esi
80104784:	53                   	push   %ebx
80104785:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104788:	8b 45 08             	mov    0x8(%ebp),%eax
8010478b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010478e:	85 c9                	test   %ecx,%ecx
80104790:	7e 26                	jle    801047b8 <safestrcpy+0x38>
80104792:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104796:	89 c1                	mov    %eax,%ecx
80104798:	eb 17                	jmp    801047b1 <safestrcpy+0x31>
8010479a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801047a0:	83 c2 01             	add    $0x1,%edx
801047a3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801047a7:	83 c1 01             	add    $0x1,%ecx
801047aa:	84 db                	test   %bl,%bl
801047ac:	88 59 ff             	mov    %bl,-0x1(%ecx)
801047af:	74 04                	je     801047b5 <safestrcpy+0x35>
801047b1:	39 f2                	cmp    %esi,%edx
801047b3:	75 eb                	jne    801047a0 <safestrcpy+0x20>
    ;
  *s = 0;
801047b5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801047b8:	5b                   	pop    %ebx
801047b9:	5e                   	pop    %esi
801047ba:	5d                   	pop    %ebp
801047bb:	c3                   	ret    
801047bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047c0 <strlen>:

int
strlen(const char *s)
{
801047c0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801047c1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
801047c3:	89 e5                	mov    %esp,%ebp
801047c5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801047c8:	80 3a 00             	cmpb   $0x0,(%edx)
801047cb:	74 0c                	je     801047d9 <strlen+0x19>
801047cd:	8d 76 00             	lea    0x0(%esi),%esi
801047d0:	83 c0 01             	add    $0x1,%eax
801047d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801047d7:	75 f7                	jne    801047d0 <strlen+0x10>
    ;
  return n;
}
801047d9:	5d                   	pop    %ebp
801047da:	c3                   	ret    

801047db <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801047db:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801047df:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801047e3:	55                   	push   %ebp
  pushl %ebx
801047e4:	53                   	push   %ebx
  pushl %esi
801047e5:	56                   	push   %esi
  pushl %edi
801047e6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801047e7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801047e9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801047eb:	5f                   	pop    %edi
  popl %esi
801047ec:	5e                   	pop    %esi
  popl %ebx
801047ed:	5b                   	pop    %ebx
  popl %ebp
801047ee:	5d                   	pop    %ebp
  ret
801047ef:	c3                   	ret    

801047f0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	53                   	push   %ebx
801047f4:	83 ec 04             	sub    $0x4,%esp
801047f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801047fa:	e8 c1 f0 ff ff       	call   801038c0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801047ff:	8b 00                	mov    (%eax),%eax
80104801:	39 d8                	cmp    %ebx,%eax
80104803:	76 1b                	jbe    80104820 <fetchint+0x30>
80104805:	8d 53 04             	lea    0x4(%ebx),%edx
80104808:	39 d0                	cmp    %edx,%eax
8010480a:	72 14                	jb     80104820 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010480c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010480f:	8b 13                	mov    (%ebx),%edx
80104811:	89 10                	mov    %edx,(%eax)
  return 0;
80104813:	31 c0                	xor    %eax,%eax
}
80104815:	83 c4 04             	add    $0x4,%esp
80104818:	5b                   	pop    %ebx
80104819:	5d                   	pop    %ebp
8010481a:	c3                   	ret    
8010481b:	90                   	nop
8010481c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104825:	eb ee                	jmp    80104815 <fetchint+0x25>
80104827:	89 f6                	mov    %esi,%esi
80104829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104830 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	53                   	push   %ebx
80104834:	83 ec 04             	sub    $0x4,%esp
80104837:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010483a:	e8 81 f0 ff ff       	call   801038c0 <myproc>

  if(addr >= curproc->sz)
8010483f:	39 18                	cmp    %ebx,(%eax)
80104841:	76 29                	jbe    8010486c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104843:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104846:	89 da                	mov    %ebx,%edx
80104848:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010484a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010484c:	39 c3                	cmp    %eax,%ebx
8010484e:	73 1c                	jae    8010486c <fetchstr+0x3c>
    if(*s == 0)
80104850:	80 3b 00             	cmpb   $0x0,(%ebx)
80104853:	75 10                	jne    80104865 <fetchstr+0x35>
80104855:	eb 29                	jmp    80104880 <fetchstr+0x50>
80104857:	89 f6                	mov    %esi,%esi
80104859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104860:	80 3a 00             	cmpb   $0x0,(%edx)
80104863:	74 1b                	je     80104880 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104865:	83 c2 01             	add    $0x1,%edx
80104868:	39 d0                	cmp    %edx,%eax
8010486a:	77 f4                	ja     80104860 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
8010486c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
8010486f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104874:	5b                   	pop    %ebx
80104875:	5d                   	pop    %ebp
80104876:	c3                   	ret    
80104877:	89 f6                	mov    %esi,%esi
80104879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104880:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104883:	89 d0                	mov    %edx,%eax
80104885:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104887:	5b                   	pop    %ebx
80104888:	5d                   	pop    %ebp
80104889:	c3                   	ret    
8010488a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104890 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	56                   	push   %esi
80104894:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104895:	e8 26 f0 ff ff       	call   801038c0 <myproc>
8010489a:	8b 40 18             	mov    0x18(%eax),%eax
8010489d:	8b 55 08             	mov    0x8(%ebp),%edx
801048a0:	8b 40 44             	mov    0x44(%eax),%eax
801048a3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
801048a6:	e8 15 f0 ff ff       	call   801038c0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048ab:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801048ad:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048b0:	39 c6                	cmp    %eax,%esi
801048b2:	73 1c                	jae    801048d0 <argint+0x40>
801048b4:	8d 53 08             	lea    0x8(%ebx),%edx
801048b7:	39 d0                	cmp    %edx,%eax
801048b9:	72 15                	jb     801048d0 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
801048bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801048be:	8b 53 04             	mov    0x4(%ebx),%edx
801048c1:	89 10                	mov    %edx,(%eax)
  return 0;
801048c3:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
801048c5:	5b                   	pop    %ebx
801048c6:	5e                   	pop    %esi
801048c7:	5d                   	pop    %ebp
801048c8:	c3                   	ret    
801048c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
801048d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048d5:	eb ee                	jmp    801048c5 <argint+0x35>
801048d7:	89 f6                	mov    %esi,%esi
801048d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048e0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	56                   	push   %esi
801048e4:	53                   	push   %ebx
801048e5:	83 ec 10             	sub    $0x10,%esp
801048e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801048eb:	e8 d0 ef ff ff       	call   801038c0 <myproc>
801048f0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801048f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048f5:	83 ec 08             	sub    $0x8,%esp
801048f8:	50                   	push   %eax
801048f9:	ff 75 08             	pushl  0x8(%ebp)
801048fc:	e8 8f ff ff ff       	call   80104890 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104901:	c1 e8 1f             	shr    $0x1f,%eax
80104904:	83 c4 10             	add    $0x10,%esp
80104907:	84 c0                	test   %al,%al
80104909:	75 2d                	jne    80104938 <argptr+0x58>
8010490b:	89 d8                	mov    %ebx,%eax
8010490d:	c1 e8 1f             	shr    $0x1f,%eax
80104910:	84 c0                	test   %al,%al
80104912:	75 24                	jne    80104938 <argptr+0x58>
80104914:	8b 16                	mov    (%esi),%edx
80104916:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104919:	39 c2                	cmp    %eax,%edx
8010491b:	76 1b                	jbe    80104938 <argptr+0x58>
8010491d:	01 c3                	add    %eax,%ebx
8010491f:	39 da                	cmp    %ebx,%edx
80104921:	72 15                	jb     80104938 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80104923:	8b 55 0c             	mov    0xc(%ebp),%edx
80104926:	89 02                	mov    %eax,(%edx)
  return 0;
80104928:	31 c0                	xor    %eax,%eax
}
8010492a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010492d:	5b                   	pop    %ebx
8010492e:	5e                   	pop    %esi
8010492f:	5d                   	pop    %ebp
80104930:	c3                   	ret    
80104931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80104938:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010493d:	eb eb                	jmp    8010492a <argptr+0x4a>
8010493f:	90                   	nop

80104940 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104946:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104949:	50                   	push   %eax
8010494a:	ff 75 08             	pushl  0x8(%ebp)
8010494d:	e8 3e ff ff ff       	call   80104890 <argint>
80104952:	83 c4 10             	add    $0x10,%esp
80104955:	85 c0                	test   %eax,%eax
80104957:	78 17                	js     80104970 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104959:	83 ec 08             	sub    $0x8,%esp
8010495c:	ff 75 0c             	pushl  0xc(%ebp)
8010495f:	ff 75 f4             	pushl  -0xc(%ebp)
80104962:	e8 c9 fe ff ff       	call   80104830 <fetchstr>
80104967:	83 c4 10             	add    $0x10,%esp
}
8010496a:	c9                   	leave  
8010496b:	c3                   	ret    
8010496c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104970:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104975:	c9                   	leave  
80104976:	c3                   	ret    
80104977:	89 f6                	mov    %esi,%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104980 <syscall>:
// [SYS_date]    "date",
// };

void
syscall(void)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	56                   	push   %esi
80104984:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104985:	e8 36 ef ff ff       	call   801038c0 <myproc>

  num = curproc->tf->eax;
8010498a:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
8010498d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010498f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104992:	8d 50 ff             	lea    -0x1(%eax),%edx
80104995:	83 fa 16             	cmp    $0x16,%edx
80104998:	77 1e                	ja     801049b8 <syscall+0x38>
8010499a:	8b 14 85 e0 78 10 80 	mov    -0x7fef8720(,%eax,4),%edx
801049a1:	85 d2                	test   %edx,%edx
801049a3:	74 13                	je     801049b8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801049a5:	ff d2                	call   *%edx
801049a7:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801049aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049ad:	5b                   	pop    %ebx
801049ae:	5e                   	pop    %esi
801049af:	5d                   	pop    %ebp
801049b0:	c3                   	ret    
801049b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    curproc->tf->eax = syscalls[num]();
    // hw3 requirements.
    // cprintf("%s -> %d\n", syscall_name[num], num);

  } else {
    cprintf("%d %s: unknown sys call %d\n",
801049b8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801049b9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    curproc->tf->eax = syscalls[num]();
    // hw3 requirements.
    // cprintf("%s -> %d\n", syscall_name[num], num);

  } else {
    cprintf("%d %s: unknown sys call %d\n",
801049bc:	50                   	push   %eax
801049bd:	ff 73 10             	pushl  0x10(%ebx)
801049c0:	68 ad 78 10 80       	push   $0x801078ad
801049c5:	e8 96 bc ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
801049ca:	8b 43 18             	mov    0x18(%ebx),%eax
801049cd:	83 c4 10             	add    $0x10,%esp
801049d0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801049d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049da:	5b                   	pop    %ebx
801049db:	5e                   	pop    %esi
801049dc:	5d                   	pop    %ebp
801049dd:	c3                   	ret    
801049de:	66 90                	xchg   %ax,%ax

801049e0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	57                   	push   %edi
801049e4:	56                   	push   %esi
801049e5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801049e6:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801049e9:	83 ec 34             	sub    $0x34,%esp
801049ec:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801049ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801049f2:	56                   	push   %esi
801049f3:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801049f4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801049f7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801049fa:	e8 e1 d5 ff ff       	call   80101fe0 <nameiparent>
801049ff:	83 c4 10             	add    $0x10,%esp
80104a02:	85 c0                	test   %eax,%eax
80104a04:	0f 84 f6 00 00 00    	je     80104b00 <create+0x120>
    return 0;
  ilock(dp);
80104a0a:	83 ec 0c             	sub    $0xc,%esp
80104a0d:	89 c7                	mov    %eax,%edi
80104a0f:	50                   	push   %eax
80104a10:	e8 5b cd ff ff       	call   80101770 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104a15:	83 c4 0c             	add    $0xc,%esp
80104a18:	6a 00                	push   $0x0
80104a1a:	56                   	push   %esi
80104a1b:	57                   	push   %edi
80104a1c:	e8 7f d2 ff ff       	call   80101ca0 <dirlookup>
80104a21:	83 c4 10             	add    $0x10,%esp
80104a24:	85 c0                	test   %eax,%eax
80104a26:	89 c3                	mov    %eax,%ebx
80104a28:	74 56                	je     80104a80 <create+0xa0>
    iunlockput(dp);
80104a2a:	83 ec 0c             	sub    $0xc,%esp
80104a2d:	57                   	push   %edi
80104a2e:	e8 cd cf ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
80104a33:	89 1c 24             	mov    %ebx,(%esp)
80104a36:	e8 35 cd ff ff       	call   80101770 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104a3b:	83 c4 10             	add    $0x10,%esp
80104a3e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104a43:	75 1b                	jne    80104a60 <create+0x80>
80104a45:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104a4a:	89 d8                	mov    %ebx,%eax
80104a4c:	75 12                	jne    80104a60 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104a4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a51:	5b                   	pop    %ebx
80104a52:	5e                   	pop    %esi
80104a53:	5f                   	pop    %edi
80104a54:	5d                   	pop    %ebp
80104a55:	c3                   	ret    
80104a56:	8d 76 00             	lea    0x0(%esi),%esi
80104a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104a60:	83 ec 0c             	sub    $0xc,%esp
80104a63:	53                   	push   %ebx
80104a64:	e8 97 cf ff ff       	call   80101a00 <iunlockput>
    return 0;
80104a69:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104a6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80104a6f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104a71:	5b                   	pop    %ebx
80104a72:	5e                   	pop    %esi
80104a73:	5f                   	pop    %edi
80104a74:	5d                   	pop    %ebp
80104a75:	c3                   	ret    
80104a76:	8d 76 00             	lea    0x0(%esi),%esi
80104a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104a80:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104a84:	83 ec 08             	sub    $0x8,%esp
80104a87:	50                   	push   %eax
80104a88:	ff 37                	pushl  (%edi)
80104a8a:	e8 71 cb ff ff       	call   80101600 <ialloc>
80104a8f:	83 c4 10             	add    $0x10,%esp
80104a92:	85 c0                	test   %eax,%eax
80104a94:	89 c3                	mov    %eax,%ebx
80104a96:	0f 84 cc 00 00 00    	je     80104b68 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
80104a9c:	83 ec 0c             	sub    $0xc,%esp
80104a9f:	50                   	push   %eax
80104aa0:	e8 cb cc ff ff       	call   80101770 <ilock>
  ip->major = major;
80104aa5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104aa9:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104aad:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104ab1:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104ab5:	b8 01 00 00 00       	mov    $0x1,%eax
80104aba:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104abe:	89 1c 24             	mov    %ebx,(%esp)
80104ac1:	e8 fa cb ff ff       	call   801016c0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104ac6:	83 c4 10             	add    $0x10,%esp
80104ac9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104ace:	74 40                	je     80104b10 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104ad0:	83 ec 04             	sub    $0x4,%esp
80104ad3:	ff 73 04             	pushl  0x4(%ebx)
80104ad6:	56                   	push   %esi
80104ad7:	57                   	push   %edi
80104ad8:	e8 23 d4 ff ff       	call   80101f00 <dirlink>
80104add:	83 c4 10             	add    $0x10,%esp
80104ae0:	85 c0                	test   %eax,%eax
80104ae2:	78 77                	js     80104b5b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80104ae4:	83 ec 0c             	sub    $0xc,%esp
80104ae7:	57                   	push   %edi
80104ae8:	e8 13 cf ff ff       	call   80101a00 <iunlockput>

  return ip;
80104aed:	83 c4 10             	add    $0x10,%esp
}
80104af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104af3:	89 d8                	mov    %ebx,%eax
}
80104af5:	5b                   	pop    %ebx
80104af6:	5e                   	pop    %esi
80104af7:	5f                   	pop    %edi
80104af8:	5d                   	pop    %ebp
80104af9:	c3                   	ret    
80104afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104b00:	31 c0                	xor    %eax,%eax
80104b02:	e9 47 ff ff ff       	jmp    80104a4e <create+0x6e>
80104b07:	89 f6                	mov    %esi,%esi
80104b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104b10:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104b15:	83 ec 0c             	sub    $0xc,%esp
80104b18:	57                   	push   %edi
80104b19:	e8 a2 cb ff ff       	call   801016c0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104b1e:	83 c4 0c             	add    $0xc,%esp
80104b21:	ff 73 04             	pushl  0x4(%ebx)
80104b24:	68 5c 79 10 80       	push   $0x8010795c
80104b29:	53                   	push   %ebx
80104b2a:	e8 d1 d3 ff ff       	call   80101f00 <dirlink>
80104b2f:	83 c4 10             	add    $0x10,%esp
80104b32:	85 c0                	test   %eax,%eax
80104b34:	78 18                	js     80104b4e <create+0x16e>
80104b36:	83 ec 04             	sub    $0x4,%esp
80104b39:	ff 77 04             	pushl  0x4(%edi)
80104b3c:	68 5b 79 10 80       	push   $0x8010795b
80104b41:	53                   	push   %ebx
80104b42:	e8 b9 d3 ff ff       	call   80101f00 <dirlink>
80104b47:	83 c4 10             	add    $0x10,%esp
80104b4a:	85 c0                	test   %eax,%eax
80104b4c:	79 82                	jns    80104ad0 <create+0xf0>
      panic("create dots");
80104b4e:	83 ec 0c             	sub    $0xc,%esp
80104b51:	68 4f 79 10 80       	push   $0x8010794f
80104b56:	e8 15 b8 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104b5b:	83 ec 0c             	sub    $0xc,%esp
80104b5e:	68 5e 79 10 80       	push   $0x8010795e
80104b63:	e8 08 b8 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104b68:	83 ec 0c             	sub    $0xc,%esp
80104b6b:	68 40 79 10 80       	push   $0x80107940
80104b70:	e8 fb b7 ff ff       	call   80100370 <panic>
80104b75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b80 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	56                   	push   %esi
80104b84:	53                   	push   %ebx
80104b85:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104b87:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104b8a:	89 d3                	mov    %edx,%ebx
80104b8c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104b8f:	50                   	push   %eax
80104b90:	6a 00                	push   $0x0
80104b92:	e8 f9 fc ff ff       	call   80104890 <argint>
80104b97:	83 c4 10             	add    $0x10,%esp
80104b9a:	85 c0                	test   %eax,%eax
80104b9c:	78 32                	js     80104bd0 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104b9e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ba2:	77 2c                	ja     80104bd0 <argfd.constprop.0+0x50>
80104ba4:	e8 17 ed ff ff       	call   801038c0 <myproc>
80104ba9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104bac:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104bb0:	85 c0                	test   %eax,%eax
80104bb2:	74 1c                	je     80104bd0 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80104bb4:	85 f6                	test   %esi,%esi
80104bb6:	74 02                	je     80104bba <argfd.constprop.0+0x3a>
    *pfd = fd;
80104bb8:	89 16                	mov    %edx,(%esi)
  if(pf)
80104bba:	85 db                	test   %ebx,%ebx
80104bbc:	74 22                	je     80104be0 <argfd.constprop.0+0x60>
    *pf = f;
80104bbe:	89 03                	mov    %eax,(%ebx)
  return 0;
80104bc0:	31 c0                	xor    %eax,%eax
}
80104bc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bc5:	5b                   	pop    %ebx
80104bc6:	5e                   	pop    %esi
80104bc7:	5d                   	pop    %ebp
80104bc8:	c3                   	ret    
80104bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80104bd8:	5b                   	pop    %ebx
80104bd9:	5e                   	pop    %esi
80104bda:	5d                   	pop    %ebp
80104bdb:	c3                   	ret    
80104bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104be0:	31 c0                	xor    %eax,%eax
80104be2:	eb de                	jmp    80104bc2 <argfd.constprop.0+0x42>
80104be4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104bf0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104bf0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104bf1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104bf3:	89 e5                	mov    %esp,%ebp
80104bf5:	56                   	push   %esi
80104bf6:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104bf7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80104bfa:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104bfd:	e8 7e ff ff ff       	call   80104b80 <argfd.constprop.0>
80104c02:	85 c0                	test   %eax,%eax
80104c04:	78 1a                	js     80104c20 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104c06:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80104c08:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80104c0b:	e8 b0 ec ff ff       	call   801038c0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104c10:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104c14:	85 d2                	test   %edx,%edx
80104c16:	74 18                	je     80104c30 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104c18:	83 c3 01             	add    $0x1,%ebx
80104c1b:	83 fb 10             	cmp    $0x10,%ebx
80104c1e:	75 f0                	jne    80104c10 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104c20:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104c23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104c28:	5b                   	pop    %ebx
80104c29:	5e                   	pop    %esi
80104c2a:	5d                   	pop    %ebp
80104c2b:	c3                   	ret    
80104c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104c30:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104c34:	83 ec 0c             	sub    $0xc,%esp
80104c37:	ff 75 f4             	pushl  -0xc(%ebp)
80104c3a:	e8 a1 c1 ff ff       	call   80100de0 <filedup>
  return fd;
80104c3f:	83 c4 10             	add    $0x10,%esp
}
80104c42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80104c45:	89 d8                	mov    %ebx,%eax
}
80104c47:	5b                   	pop    %ebx
80104c48:	5e                   	pop    %esi
80104c49:	5d                   	pop    %ebp
80104c4a:	c3                   	ret    
80104c4b:	90                   	nop
80104c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c50 <sys_read>:

int
sys_read(void)
{
80104c50:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c51:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104c53:	89 e5                	mov    %esp,%ebp
80104c55:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c58:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104c5b:	e8 20 ff ff ff       	call   80104b80 <argfd.constprop.0>
80104c60:	85 c0                	test   %eax,%eax
80104c62:	78 4c                	js     80104cb0 <sys_read+0x60>
80104c64:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c67:	83 ec 08             	sub    $0x8,%esp
80104c6a:	50                   	push   %eax
80104c6b:	6a 02                	push   $0x2
80104c6d:	e8 1e fc ff ff       	call   80104890 <argint>
80104c72:	83 c4 10             	add    $0x10,%esp
80104c75:	85 c0                	test   %eax,%eax
80104c77:	78 37                	js     80104cb0 <sys_read+0x60>
80104c79:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c7c:	83 ec 04             	sub    $0x4,%esp
80104c7f:	ff 75 f0             	pushl  -0x10(%ebp)
80104c82:	50                   	push   %eax
80104c83:	6a 01                	push   $0x1
80104c85:	e8 56 fc ff ff       	call   801048e0 <argptr>
80104c8a:	83 c4 10             	add    $0x10,%esp
80104c8d:	85 c0                	test   %eax,%eax
80104c8f:	78 1f                	js     80104cb0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104c91:	83 ec 04             	sub    $0x4,%esp
80104c94:	ff 75 f0             	pushl  -0x10(%ebp)
80104c97:	ff 75 f4             	pushl  -0xc(%ebp)
80104c9a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c9d:	e8 ae c2 ff ff       	call   80100f50 <fileread>
80104ca2:	83 c4 10             	add    $0x10,%esp
}
80104ca5:	c9                   	leave  
80104ca6:	c3                   	ret    
80104ca7:	89 f6                	mov    %esi,%esi
80104ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104cb5:	c9                   	leave  
80104cb6:	c3                   	ret    
80104cb7:	89 f6                	mov    %esi,%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cc0 <sys_write>:

int
sys_write(void)
{
80104cc0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cc1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104cc3:	89 e5                	mov    %esp,%ebp
80104cc5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cc8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104ccb:	e8 b0 fe ff ff       	call   80104b80 <argfd.constprop.0>
80104cd0:	85 c0                	test   %eax,%eax
80104cd2:	78 4c                	js     80104d20 <sys_write+0x60>
80104cd4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104cd7:	83 ec 08             	sub    $0x8,%esp
80104cda:	50                   	push   %eax
80104cdb:	6a 02                	push   $0x2
80104cdd:	e8 ae fb ff ff       	call   80104890 <argint>
80104ce2:	83 c4 10             	add    $0x10,%esp
80104ce5:	85 c0                	test   %eax,%eax
80104ce7:	78 37                	js     80104d20 <sys_write+0x60>
80104ce9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cec:	83 ec 04             	sub    $0x4,%esp
80104cef:	ff 75 f0             	pushl  -0x10(%ebp)
80104cf2:	50                   	push   %eax
80104cf3:	6a 01                	push   $0x1
80104cf5:	e8 e6 fb ff ff       	call   801048e0 <argptr>
80104cfa:	83 c4 10             	add    $0x10,%esp
80104cfd:	85 c0                	test   %eax,%eax
80104cff:	78 1f                	js     80104d20 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104d01:	83 ec 04             	sub    $0x4,%esp
80104d04:	ff 75 f0             	pushl  -0x10(%ebp)
80104d07:	ff 75 f4             	pushl  -0xc(%ebp)
80104d0a:	ff 75 ec             	pushl  -0x14(%ebp)
80104d0d:	e8 ce c2 ff ff       	call   80100fe0 <filewrite>
80104d12:	83 c4 10             	add    $0x10,%esp
}
80104d15:	c9                   	leave  
80104d16:	c3                   	ret    
80104d17:	89 f6                	mov    %esi,%esi
80104d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104d20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104d25:	c9                   	leave  
80104d26:	c3                   	ret    
80104d27:	89 f6                	mov    %esi,%esi
80104d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d30 <sys_close>:

int
sys_close(void)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104d36:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104d39:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d3c:	e8 3f fe ff ff       	call   80104b80 <argfd.constprop.0>
80104d41:	85 c0                	test   %eax,%eax
80104d43:	78 2b                	js     80104d70 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80104d45:	e8 76 eb ff ff       	call   801038c0 <myproc>
80104d4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104d4d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80104d50:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104d57:	00 
  fileclose(f);
80104d58:	ff 75 f4             	pushl  -0xc(%ebp)
80104d5b:	e8 d0 c0 ff ff       	call   80100e30 <fileclose>
  return 0;
80104d60:	83 c4 10             	add    $0x10,%esp
80104d63:	31 c0                	xor    %eax,%eax
}
80104d65:	c9                   	leave  
80104d66:	c3                   	ret    
80104d67:	89 f6                	mov    %esi,%esi
80104d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104d70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104d75:	c9                   	leave  
80104d76:	c3                   	ret    
80104d77:	89 f6                	mov    %esi,%esi
80104d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d80 <sys_fstat>:

int
sys_fstat(void)
{
80104d80:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104d81:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104d83:	89 e5                	mov    %esp,%ebp
80104d85:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104d88:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104d8b:	e8 f0 fd ff ff       	call   80104b80 <argfd.constprop.0>
80104d90:	85 c0                	test   %eax,%eax
80104d92:	78 2c                	js     80104dc0 <sys_fstat+0x40>
80104d94:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d97:	83 ec 04             	sub    $0x4,%esp
80104d9a:	6a 14                	push   $0x14
80104d9c:	50                   	push   %eax
80104d9d:	6a 01                	push   $0x1
80104d9f:	e8 3c fb ff ff       	call   801048e0 <argptr>
80104da4:	83 c4 10             	add    $0x10,%esp
80104da7:	85 c0                	test   %eax,%eax
80104da9:	78 15                	js     80104dc0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104dab:	83 ec 08             	sub    $0x8,%esp
80104dae:	ff 75 f4             	pushl  -0xc(%ebp)
80104db1:	ff 75 f0             	pushl  -0x10(%ebp)
80104db4:	e8 47 c1 ff ff       	call   80100f00 <filestat>
80104db9:	83 c4 10             	add    $0x10,%esp
}
80104dbc:	c9                   	leave  
80104dbd:	c3                   	ret    
80104dbe:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104dc5:	c9                   	leave  
80104dc6:	c3                   	ret    
80104dc7:	89 f6                	mov    %esi,%esi
80104dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dd0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	57                   	push   %edi
80104dd4:	56                   	push   %esi
80104dd5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104dd6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104dd9:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ddc:	50                   	push   %eax
80104ddd:	6a 00                	push   $0x0
80104ddf:	e8 5c fb ff ff       	call   80104940 <argstr>
80104de4:	83 c4 10             	add    $0x10,%esp
80104de7:	85 c0                	test   %eax,%eax
80104de9:	0f 88 fb 00 00 00    	js     80104eea <sys_link+0x11a>
80104def:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104df2:	83 ec 08             	sub    $0x8,%esp
80104df5:	50                   	push   %eax
80104df6:	6a 01                	push   $0x1
80104df8:	e8 43 fb ff ff       	call   80104940 <argstr>
80104dfd:	83 c4 10             	add    $0x10,%esp
80104e00:	85 c0                	test   %eax,%eax
80104e02:	0f 88 e2 00 00 00    	js     80104eea <sys_link+0x11a>
    return -1;

  begin_op();
80104e08:	e8 33 de ff ff       	call   80102c40 <begin_op>
  if((ip = namei(old)) == 0){
80104e0d:	83 ec 0c             	sub    $0xc,%esp
80104e10:	ff 75 d4             	pushl  -0x2c(%ebp)
80104e13:	e8 a8 d1 ff ff       	call   80101fc0 <namei>
80104e18:	83 c4 10             	add    $0x10,%esp
80104e1b:	85 c0                	test   %eax,%eax
80104e1d:	89 c3                	mov    %eax,%ebx
80104e1f:	0f 84 f3 00 00 00    	je     80104f18 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80104e25:	83 ec 0c             	sub    $0xc,%esp
80104e28:	50                   	push   %eax
80104e29:	e8 42 c9 ff ff       	call   80101770 <ilock>
  if(ip->type == T_DIR){
80104e2e:	83 c4 10             	add    $0x10,%esp
80104e31:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e36:	0f 84 c4 00 00 00    	je     80104f00 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104e3c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104e41:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104e44:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104e47:	53                   	push   %ebx
80104e48:	e8 73 c8 ff ff       	call   801016c0 <iupdate>
  iunlock(ip);
80104e4d:	89 1c 24             	mov    %ebx,(%esp)
80104e50:	e8 fb c9 ff ff       	call   80101850 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104e55:	58                   	pop    %eax
80104e56:	5a                   	pop    %edx
80104e57:	57                   	push   %edi
80104e58:	ff 75 d0             	pushl  -0x30(%ebp)
80104e5b:	e8 80 d1 ff ff       	call   80101fe0 <nameiparent>
80104e60:	83 c4 10             	add    $0x10,%esp
80104e63:	85 c0                	test   %eax,%eax
80104e65:	89 c6                	mov    %eax,%esi
80104e67:	74 5b                	je     80104ec4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104e69:	83 ec 0c             	sub    $0xc,%esp
80104e6c:	50                   	push   %eax
80104e6d:	e8 fe c8 ff ff       	call   80101770 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104e72:	83 c4 10             	add    $0x10,%esp
80104e75:	8b 03                	mov    (%ebx),%eax
80104e77:	39 06                	cmp    %eax,(%esi)
80104e79:	75 3d                	jne    80104eb8 <sys_link+0xe8>
80104e7b:	83 ec 04             	sub    $0x4,%esp
80104e7e:	ff 73 04             	pushl  0x4(%ebx)
80104e81:	57                   	push   %edi
80104e82:	56                   	push   %esi
80104e83:	e8 78 d0 ff ff       	call   80101f00 <dirlink>
80104e88:	83 c4 10             	add    $0x10,%esp
80104e8b:	85 c0                	test   %eax,%eax
80104e8d:	78 29                	js     80104eb8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104e8f:	83 ec 0c             	sub    $0xc,%esp
80104e92:	56                   	push   %esi
80104e93:	e8 68 cb ff ff       	call   80101a00 <iunlockput>
  iput(ip);
80104e98:	89 1c 24             	mov    %ebx,(%esp)
80104e9b:	e8 00 ca ff ff       	call   801018a0 <iput>

  end_op();
80104ea0:	e8 0b de ff ff       	call   80102cb0 <end_op>

  return 0;
80104ea5:	83 c4 10             	add    $0x10,%esp
80104ea8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ead:	5b                   	pop    %ebx
80104eae:	5e                   	pop    %esi
80104eaf:	5f                   	pop    %edi
80104eb0:	5d                   	pop    %ebp
80104eb1:	c3                   	ret    
80104eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104eb8:	83 ec 0c             	sub    $0xc,%esp
80104ebb:	56                   	push   %esi
80104ebc:	e8 3f cb ff ff       	call   80101a00 <iunlockput>
    goto bad;
80104ec1:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80104ec4:	83 ec 0c             	sub    $0xc,%esp
80104ec7:	53                   	push   %ebx
80104ec8:	e8 a3 c8 ff ff       	call   80101770 <ilock>
  ip->nlink--;
80104ecd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ed2:	89 1c 24             	mov    %ebx,(%esp)
80104ed5:	e8 e6 c7 ff ff       	call   801016c0 <iupdate>
  iunlockput(ip);
80104eda:	89 1c 24             	mov    %ebx,(%esp)
80104edd:	e8 1e cb ff ff       	call   80101a00 <iunlockput>
  end_op();
80104ee2:	e8 c9 dd ff ff       	call   80102cb0 <end_op>
  return -1;
80104ee7:	83 c4 10             	add    $0x10,%esp
}
80104eea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104eed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ef2:	5b                   	pop    %ebx
80104ef3:	5e                   	pop    %esi
80104ef4:	5f                   	pop    %edi
80104ef5:	5d                   	pop    %ebp
80104ef6:	c3                   	ret    
80104ef7:	89 f6                	mov    %esi,%esi
80104ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80104f00:	83 ec 0c             	sub    $0xc,%esp
80104f03:	53                   	push   %ebx
80104f04:	e8 f7 ca ff ff       	call   80101a00 <iunlockput>
    end_op();
80104f09:	e8 a2 dd ff ff       	call   80102cb0 <end_op>
    return -1;
80104f0e:	83 c4 10             	add    $0x10,%esp
80104f11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f16:	eb 92                	jmp    80104eaa <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80104f18:	e8 93 dd ff ff       	call   80102cb0 <end_op>
    return -1;
80104f1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f22:	eb 86                	jmp    80104eaa <sys_link+0xda>
80104f24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104f30 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	57                   	push   %edi
80104f34:	56                   	push   %esi
80104f35:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104f36:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104f39:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104f3c:	50                   	push   %eax
80104f3d:	6a 00                	push   $0x0
80104f3f:	e8 fc f9 ff ff       	call   80104940 <argstr>
80104f44:	83 c4 10             	add    $0x10,%esp
80104f47:	85 c0                	test   %eax,%eax
80104f49:	0f 88 82 01 00 00    	js     801050d1 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80104f4f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80104f52:	e8 e9 dc ff ff       	call   80102c40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104f57:	83 ec 08             	sub    $0x8,%esp
80104f5a:	53                   	push   %ebx
80104f5b:	ff 75 c0             	pushl  -0x40(%ebp)
80104f5e:	e8 7d d0 ff ff       	call   80101fe0 <nameiparent>
80104f63:	83 c4 10             	add    $0x10,%esp
80104f66:	85 c0                	test   %eax,%eax
80104f68:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104f6b:	0f 84 6a 01 00 00    	je     801050db <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80104f71:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104f74:	83 ec 0c             	sub    $0xc,%esp
80104f77:	56                   	push   %esi
80104f78:	e8 f3 c7 ff ff       	call   80101770 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104f7d:	58                   	pop    %eax
80104f7e:	5a                   	pop    %edx
80104f7f:	68 5c 79 10 80       	push   $0x8010795c
80104f84:	53                   	push   %ebx
80104f85:	e8 f6 cc ff ff       	call   80101c80 <namecmp>
80104f8a:	83 c4 10             	add    $0x10,%esp
80104f8d:	85 c0                	test   %eax,%eax
80104f8f:	0f 84 fc 00 00 00    	je     80105091 <sys_unlink+0x161>
80104f95:	83 ec 08             	sub    $0x8,%esp
80104f98:	68 5b 79 10 80       	push   $0x8010795b
80104f9d:	53                   	push   %ebx
80104f9e:	e8 dd cc ff ff       	call   80101c80 <namecmp>
80104fa3:	83 c4 10             	add    $0x10,%esp
80104fa6:	85 c0                	test   %eax,%eax
80104fa8:	0f 84 e3 00 00 00    	je     80105091 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104fae:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104fb1:	83 ec 04             	sub    $0x4,%esp
80104fb4:	50                   	push   %eax
80104fb5:	53                   	push   %ebx
80104fb6:	56                   	push   %esi
80104fb7:	e8 e4 cc ff ff       	call   80101ca0 <dirlookup>
80104fbc:	83 c4 10             	add    $0x10,%esp
80104fbf:	85 c0                	test   %eax,%eax
80104fc1:	89 c3                	mov    %eax,%ebx
80104fc3:	0f 84 c8 00 00 00    	je     80105091 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80104fc9:	83 ec 0c             	sub    $0xc,%esp
80104fcc:	50                   	push   %eax
80104fcd:	e8 9e c7 ff ff       	call   80101770 <ilock>

  if(ip->nlink < 1)
80104fd2:	83 c4 10             	add    $0x10,%esp
80104fd5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104fda:	0f 8e 24 01 00 00    	jle    80105104 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104fe0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104fe5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104fe8:	74 66                	je     80105050 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104fea:	83 ec 04             	sub    $0x4,%esp
80104fed:	6a 10                	push   $0x10
80104fef:	6a 00                	push   $0x0
80104ff1:	56                   	push   %esi
80104ff2:	e8 89 f5 ff ff       	call   80104580 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104ff7:	6a 10                	push   $0x10
80104ff9:	ff 75 c4             	pushl  -0x3c(%ebp)
80104ffc:	56                   	push   %esi
80104ffd:	ff 75 b4             	pushl  -0x4c(%ebp)
80105000:	e8 4b cb ff ff       	call   80101b50 <writei>
80105005:	83 c4 20             	add    $0x20,%esp
80105008:	83 f8 10             	cmp    $0x10,%eax
8010500b:	0f 85 e6 00 00 00    	jne    801050f7 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105011:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105016:	0f 84 9c 00 00 00    	je     801050b8 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
8010501c:	83 ec 0c             	sub    $0xc,%esp
8010501f:	ff 75 b4             	pushl  -0x4c(%ebp)
80105022:	e8 d9 c9 ff ff       	call   80101a00 <iunlockput>

  ip->nlink--;
80105027:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010502c:	89 1c 24             	mov    %ebx,(%esp)
8010502f:	e8 8c c6 ff ff       	call   801016c0 <iupdate>
  iunlockput(ip);
80105034:	89 1c 24             	mov    %ebx,(%esp)
80105037:	e8 c4 c9 ff ff       	call   80101a00 <iunlockput>

  end_op();
8010503c:	e8 6f dc ff ff       	call   80102cb0 <end_op>

  return 0;
80105041:	83 c4 10             	add    $0x10,%esp
80105044:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105046:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105049:	5b                   	pop    %ebx
8010504a:	5e                   	pop    %esi
8010504b:	5f                   	pop    %edi
8010504c:	5d                   	pop    %ebp
8010504d:	c3                   	ret    
8010504e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105050:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105054:	76 94                	jbe    80104fea <sys_unlink+0xba>
80105056:	bf 20 00 00 00       	mov    $0x20,%edi
8010505b:	eb 0f                	jmp    8010506c <sys_unlink+0x13c>
8010505d:	8d 76 00             	lea    0x0(%esi),%esi
80105060:	83 c7 10             	add    $0x10,%edi
80105063:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105066:	0f 83 7e ff ff ff    	jae    80104fea <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010506c:	6a 10                	push   $0x10
8010506e:	57                   	push   %edi
8010506f:	56                   	push   %esi
80105070:	53                   	push   %ebx
80105071:	e8 da c9 ff ff       	call   80101a50 <readi>
80105076:	83 c4 10             	add    $0x10,%esp
80105079:	83 f8 10             	cmp    $0x10,%eax
8010507c:	75 6c                	jne    801050ea <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010507e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105083:	74 db                	je     80105060 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80105085:	83 ec 0c             	sub    $0xc,%esp
80105088:	53                   	push   %ebx
80105089:	e8 72 c9 ff ff       	call   80101a00 <iunlockput>
    goto bad;
8010508e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105091:	83 ec 0c             	sub    $0xc,%esp
80105094:	ff 75 b4             	pushl  -0x4c(%ebp)
80105097:	e8 64 c9 ff ff       	call   80101a00 <iunlockput>
  end_op();
8010509c:	e8 0f dc ff ff       	call   80102cb0 <end_op>
  return -1;
801050a1:	83 c4 10             	add    $0x10,%esp
}
801050a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
801050a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050ac:	5b                   	pop    %ebx
801050ad:	5e                   	pop    %esi
801050ae:	5f                   	pop    %edi
801050af:	5d                   	pop    %ebp
801050b0:	c3                   	ret    
801050b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801050b8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801050bb:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801050be:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801050c3:	50                   	push   %eax
801050c4:	e8 f7 c5 ff ff       	call   801016c0 <iupdate>
801050c9:	83 c4 10             	add    $0x10,%esp
801050cc:	e9 4b ff ff ff       	jmp    8010501c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
801050d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050d6:	e9 6b ff ff ff       	jmp    80105046 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
801050db:	e8 d0 db ff ff       	call   80102cb0 <end_op>
    return -1;
801050e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050e5:	e9 5c ff ff ff       	jmp    80105046 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
801050ea:	83 ec 0c             	sub    $0xc,%esp
801050ed:	68 80 79 10 80       	push   $0x80107980
801050f2:	e8 79 b2 ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
801050f7:	83 ec 0c             	sub    $0xc,%esp
801050fa:	68 92 79 10 80       	push   $0x80107992
801050ff:	e8 6c b2 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105104:	83 ec 0c             	sub    $0xc,%esp
80105107:	68 6e 79 10 80       	push   $0x8010796e
8010510c:	e8 5f b2 ff ff       	call   80100370 <panic>
80105111:	eb 0d                	jmp    80105120 <sys_open>
80105113:	90                   	nop
80105114:	90                   	nop
80105115:	90                   	nop
80105116:	90                   	nop
80105117:	90                   	nop
80105118:	90                   	nop
80105119:	90                   	nop
8010511a:	90                   	nop
8010511b:	90                   	nop
8010511c:	90                   	nop
8010511d:	90                   	nop
8010511e:	90                   	nop
8010511f:	90                   	nop

80105120 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	57                   	push   %edi
80105124:	56                   	push   %esi
80105125:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105126:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105129:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010512c:	50                   	push   %eax
8010512d:	6a 00                	push   $0x0
8010512f:	e8 0c f8 ff ff       	call   80104940 <argstr>
80105134:	83 c4 10             	add    $0x10,%esp
80105137:	85 c0                	test   %eax,%eax
80105139:	0f 88 9e 00 00 00    	js     801051dd <sys_open+0xbd>
8010513f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105142:	83 ec 08             	sub    $0x8,%esp
80105145:	50                   	push   %eax
80105146:	6a 01                	push   $0x1
80105148:	e8 43 f7 ff ff       	call   80104890 <argint>
8010514d:	83 c4 10             	add    $0x10,%esp
80105150:	85 c0                	test   %eax,%eax
80105152:	0f 88 85 00 00 00    	js     801051dd <sys_open+0xbd>
    return -1;

  begin_op();
80105158:	e8 e3 da ff ff       	call   80102c40 <begin_op>

  if(omode & O_CREATE){
8010515d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105161:	0f 85 89 00 00 00    	jne    801051f0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105167:	83 ec 0c             	sub    $0xc,%esp
8010516a:	ff 75 e0             	pushl  -0x20(%ebp)
8010516d:	e8 4e ce ff ff       	call   80101fc0 <namei>
80105172:	83 c4 10             	add    $0x10,%esp
80105175:	85 c0                	test   %eax,%eax
80105177:	89 c6                	mov    %eax,%esi
80105179:	0f 84 8e 00 00 00    	je     8010520d <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
8010517f:	83 ec 0c             	sub    $0xc,%esp
80105182:	50                   	push   %eax
80105183:	e8 e8 c5 ff ff       	call   80101770 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105188:	83 c4 10             	add    $0x10,%esp
8010518b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105190:	0f 84 d2 00 00 00    	je     80105268 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105196:	e8 d5 bb ff ff       	call   80100d70 <filealloc>
8010519b:	85 c0                	test   %eax,%eax
8010519d:	89 c7                	mov    %eax,%edi
8010519f:	74 2b                	je     801051cc <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801051a1:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801051a3:	e8 18 e7 ff ff       	call   801038c0 <myproc>
801051a8:	90                   	nop
801051a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801051b0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801051b4:	85 d2                	test   %edx,%edx
801051b6:	74 68                	je     80105220 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801051b8:	83 c3 01             	add    $0x1,%ebx
801051bb:	83 fb 10             	cmp    $0x10,%ebx
801051be:	75 f0                	jne    801051b0 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
801051c0:	83 ec 0c             	sub    $0xc,%esp
801051c3:	57                   	push   %edi
801051c4:	e8 67 bc ff ff       	call   80100e30 <fileclose>
801051c9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801051cc:	83 ec 0c             	sub    $0xc,%esp
801051cf:	56                   	push   %esi
801051d0:	e8 2b c8 ff ff       	call   80101a00 <iunlockput>
    end_op();
801051d5:	e8 d6 da ff ff       	call   80102cb0 <end_op>
    return -1;
801051da:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801051dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
801051e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801051e5:	5b                   	pop    %ebx
801051e6:	5e                   	pop    %esi
801051e7:	5f                   	pop    %edi
801051e8:	5d                   	pop    %ebp
801051e9:	c3                   	ret    
801051ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801051f0:	83 ec 0c             	sub    $0xc,%esp
801051f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051f6:	31 c9                	xor    %ecx,%ecx
801051f8:	6a 00                	push   $0x0
801051fa:	ba 02 00 00 00       	mov    $0x2,%edx
801051ff:	e8 dc f7 ff ff       	call   801049e0 <create>
    if(ip == 0){
80105204:	83 c4 10             	add    $0x10,%esp
80105207:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105209:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010520b:	75 89                	jne    80105196 <sys_open+0x76>
      end_op();
8010520d:	e8 9e da ff ff       	call   80102cb0 <end_op>
      return -1;
80105212:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105217:	eb 43                	jmp    8010525c <sys_open+0x13c>
80105219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105220:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105223:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105227:	56                   	push   %esi
80105228:	e8 23 c6 ff ff       	call   80101850 <iunlock>
  end_op();
8010522d:	e8 7e da ff ff       	call   80102cb0 <end_op>

  f->type = FD_INODE;
80105232:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105238:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010523b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010523e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105241:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105248:	89 d0                	mov    %edx,%eax
8010524a:	83 e0 01             	and    $0x1,%eax
8010524d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105250:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105253:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105256:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
8010525a:	89 d8                	mov    %ebx,%eax
}
8010525c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010525f:	5b                   	pop    %ebx
80105260:	5e                   	pop    %esi
80105261:	5f                   	pop    %edi
80105262:	5d                   	pop    %ebp
80105263:	c3                   	ret    
80105264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105268:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010526b:	85 c9                	test   %ecx,%ecx
8010526d:	0f 84 23 ff ff ff    	je     80105196 <sys_open+0x76>
80105273:	e9 54 ff ff ff       	jmp    801051cc <sys_open+0xac>
80105278:	90                   	nop
80105279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105280 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105286:	e8 b5 d9 ff ff       	call   80102c40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010528b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010528e:	83 ec 08             	sub    $0x8,%esp
80105291:	50                   	push   %eax
80105292:	6a 00                	push   $0x0
80105294:	e8 a7 f6 ff ff       	call   80104940 <argstr>
80105299:	83 c4 10             	add    $0x10,%esp
8010529c:	85 c0                	test   %eax,%eax
8010529e:	78 30                	js     801052d0 <sys_mkdir+0x50>
801052a0:	83 ec 0c             	sub    $0xc,%esp
801052a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052a6:	31 c9                	xor    %ecx,%ecx
801052a8:	6a 00                	push   $0x0
801052aa:	ba 01 00 00 00       	mov    $0x1,%edx
801052af:	e8 2c f7 ff ff       	call   801049e0 <create>
801052b4:	83 c4 10             	add    $0x10,%esp
801052b7:	85 c0                	test   %eax,%eax
801052b9:	74 15                	je     801052d0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801052bb:	83 ec 0c             	sub    $0xc,%esp
801052be:	50                   	push   %eax
801052bf:	e8 3c c7 ff ff       	call   80101a00 <iunlockput>
  end_op();
801052c4:	e8 e7 d9 ff ff       	call   80102cb0 <end_op>
  return 0;
801052c9:	83 c4 10             	add    $0x10,%esp
801052cc:	31 c0                	xor    %eax,%eax
}
801052ce:	c9                   	leave  
801052cf:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801052d0:	e8 db d9 ff ff       	call   80102cb0 <end_op>
    return -1;
801052d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801052da:	c9                   	leave  
801052db:	c3                   	ret    
801052dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052e0 <sys_mknod>:

int
sys_mknod(void)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801052e6:	e8 55 d9 ff ff       	call   80102c40 <begin_op>
  if((argstr(0, &path)) < 0 ||
801052eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801052ee:	83 ec 08             	sub    $0x8,%esp
801052f1:	50                   	push   %eax
801052f2:	6a 00                	push   $0x0
801052f4:	e8 47 f6 ff ff       	call   80104940 <argstr>
801052f9:	83 c4 10             	add    $0x10,%esp
801052fc:	85 c0                	test   %eax,%eax
801052fe:	78 60                	js     80105360 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105300:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105303:	83 ec 08             	sub    $0x8,%esp
80105306:	50                   	push   %eax
80105307:	6a 01                	push   $0x1
80105309:	e8 82 f5 ff ff       	call   80104890 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
8010530e:	83 c4 10             	add    $0x10,%esp
80105311:	85 c0                	test   %eax,%eax
80105313:	78 4b                	js     80105360 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105315:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105318:	83 ec 08             	sub    $0x8,%esp
8010531b:	50                   	push   %eax
8010531c:	6a 02                	push   $0x2
8010531e:	e8 6d f5 ff ff       	call   80104890 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105323:	83 c4 10             	add    $0x10,%esp
80105326:	85 c0                	test   %eax,%eax
80105328:	78 36                	js     80105360 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010532a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010532e:	83 ec 0c             	sub    $0xc,%esp
80105331:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105335:	ba 03 00 00 00       	mov    $0x3,%edx
8010533a:	50                   	push   %eax
8010533b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010533e:	e8 9d f6 ff ff       	call   801049e0 <create>
80105343:	83 c4 10             	add    $0x10,%esp
80105346:	85 c0                	test   %eax,%eax
80105348:	74 16                	je     80105360 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010534a:	83 ec 0c             	sub    $0xc,%esp
8010534d:	50                   	push   %eax
8010534e:	e8 ad c6 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105353:	e8 58 d9 ff ff       	call   80102cb0 <end_op>
  return 0;
80105358:	83 c4 10             	add    $0x10,%esp
8010535b:	31 c0                	xor    %eax,%eax
}
8010535d:	c9                   	leave  
8010535e:	c3                   	ret    
8010535f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105360:	e8 4b d9 ff ff       	call   80102cb0 <end_op>
    return -1;
80105365:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010536a:	c9                   	leave  
8010536b:	c3                   	ret    
8010536c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105370 <sys_chdir>:

int
sys_chdir(void)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	56                   	push   %esi
80105374:	53                   	push   %ebx
80105375:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105378:	e8 43 e5 ff ff       	call   801038c0 <myproc>
8010537d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010537f:	e8 bc d8 ff ff       	call   80102c40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105384:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105387:	83 ec 08             	sub    $0x8,%esp
8010538a:	50                   	push   %eax
8010538b:	6a 00                	push   $0x0
8010538d:	e8 ae f5 ff ff       	call   80104940 <argstr>
80105392:	83 c4 10             	add    $0x10,%esp
80105395:	85 c0                	test   %eax,%eax
80105397:	78 77                	js     80105410 <sys_chdir+0xa0>
80105399:	83 ec 0c             	sub    $0xc,%esp
8010539c:	ff 75 f4             	pushl  -0xc(%ebp)
8010539f:	e8 1c cc ff ff       	call   80101fc0 <namei>
801053a4:	83 c4 10             	add    $0x10,%esp
801053a7:	85 c0                	test   %eax,%eax
801053a9:	89 c3                	mov    %eax,%ebx
801053ab:	74 63                	je     80105410 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801053ad:	83 ec 0c             	sub    $0xc,%esp
801053b0:	50                   	push   %eax
801053b1:	e8 ba c3 ff ff       	call   80101770 <ilock>
  if(ip->type != T_DIR){
801053b6:	83 c4 10             	add    $0x10,%esp
801053b9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053be:	75 30                	jne    801053f0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801053c0:	83 ec 0c             	sub    $0xc,%esp
801053c3:	53                   	push   %ebx
801053c4:	e8 87 c4 ff ff       	call   80101850 <iunlock>
  iput(curproc->cwd);
801053c9:	58                   	pop    %eax
801053ca:	ff 76 68             	pushl  0x68(%esi)
801053cd:	e8 ce c4 ff ff       	call   801018a0 <iput>
  end_op();
801053d2:	e8 d9 d8 ff ff       	call   80102cb0 <end_op>
  curproc->cwd = ip;
801053d7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801053da:	83 c4 10             	add    $0x10,%esp
801053dd:	31 c0                	xor    %eax,%eax
}
801053df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053e2:	5b                   	pop    %ebx
801053e3:	5e                   	pop    %esi
801053e4:	5d                   	pop    %ebp
801053e5:	c3                   	ret    
801053e6:	8d 76 00             	lea    0x0(%esi),%esi
801053e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
801053f0:	83 ec 0c             	sub    $0xc,%esp
801053f3:	53                   	push   %ebx
801053f4:	e8 07 c6 ff ff       	call   80101a00 <iunlockput>
    end_op();
801053f9:	e8 b2 d8 ff ff       	call   80102cb0 <end_op>
    return -1;
801053fe:	83 c4 10             	add    $0x10,%esp
80105401:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105406:	eb d7                	jmp    801053df <sys_chdir+0x6f>
80105408:	90                   	nop
80105409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105410:	e8 9b d8 ff ff       	call   80102cb0 <end_op>
    return -1;
80105415:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010541a:	eb c3                	jmp    801053df <sys_chdir+0x6f>
8010541c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105420 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	57                   	push   %edi
80105424:	56                   	push   %esi
80105425:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105426:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010542c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105432:	50                   	push   %eax
80105433:	6a 00                	push   $0x0
80105435:	e8 06 f5 ff ff       	call   80104940 <argstr>
8010543a:	83 c4 10             	add    $0x10,%esp
8010543d:	85 c0                	test   %eax,%eax
8010543f:	78 7f                	js     801054c0 <sys_exec+0xa0>
80105441:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105447:	83 ec 08             	sub    $0x8,%esp
8010544a:	50                   	push   %eax
8010544b:	6a 01                	push   $0x1
8010544d:	e8 3e f4 ff ff       	call   80104890 <argint>
80105452:	83 c4 10             	add    $0x10,%esp
80105455:	85 c0                	test   %eax,%eax
80105457:	78 67                	js     801054c0 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105459:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010545f:	83 ec 04             	sub    $0x4,%esp
80105462:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105468:	68 80 00 00 00       	push   $0x80
8010546d:	6a 00                	push   $0x0
8010546f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105475:	50                   	push   %eax
80105476:	31 db                	xor    %ebx,%ebx
80105478:	e8 03 f1 ff ff       	call   80104580 <memset>
8010547d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105480:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105486:	83 ec 08             	sub    $0x8,%esp
80105489:	57                   	push   %edi
8010548a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010548d:	50                   	push   %eax
8010548e:	e8 5d f3 ff ff       	call   801047f0 <fetchint>
80105493:	83 c4 10             	add    $0x10,%esp
80105496:	85 c0                	test   %eax,%eax
80105498:	78 26                	js     801054c0 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
8010549a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801054a0:	85 c0                	test   %eax,%eax
801054a2:	74 2c                	je     801054d0 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801054a4:	83 ec 08             	sub    $0x8,%esp
801054a7:	56                   	push   %esi
801054a8:	50                   	push   %eax
801054a9:	e8 82 f3 ff ff       	call   80104830 <fetchstr>
801054ae:	83 c4 10             	add    $0x10,%esp
801054b1:	85 c0                	test   %eax,%eax
801054b3:	78 0b                	js     801054c0 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801054b5:	83 c3 01             	add    $0x1,%ebx
801054b8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801054bb:	83 fb 20             	cmp    $0x20,%ebx
801054be:	75 c0                	jne    80105480 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801054c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801054c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801054c8:	5b                   	pop    %ebx
801054c9:	5e                   	pop    %esi
801054ca:	5f                   	pop    %edi
801054cb:	5d                   	pop    %ebp
801054cc:	c3                   	ret    
801054cd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801054d0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801054d6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801054d9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801054e0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801054e4:	50                   	push   %eax
801054e5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801054eb:	e8 00 b5 ff ff       	call   801009f0 <exec>
801054f0:	83 c4 10             	add    $0x10,%esp
}
801054f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054f6:	5b                   	pop    %ebx
801054f7:	5e                   	pop    %esi
801054f8:	5f                   	pop    %edi
801054f9:	5d                   	pop    %ebp
801054fa:	c3                   	ret    
801054fb:	90                   	nop
801054fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105500 <sys_pipe>:

int
sys_pipe(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	57                   	push   %edi
80105504:	56                   	push   %esi
80105505:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105506:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105509:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010550c:	6a 08                	push   $0x8
8010550e:	50                   	push   %eax
8010550f:	6a 00                	push   $0x0
80105511:	e8 ca f3 ff ff       	call   801048e0 <argptr>
80105516:	83 c4 10             	add    $0x10,%esp
80105519:	85 c0                	test   %eax,%eax
8010551b:	78 4a                	js     80105567 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010551d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105520:	83 ec 08             	sub    $0x8,%esp
80105523:	50                   	push   %eax
80105524:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105527:	50                   	push   %eax
80105528:	e8 f3 dd ff ff       	call   80103320 <pipealloc>
8010552d:	83 c4 10             	add    $0x10,%esp
80105530:	85 c0                	test   %eax,%eax
80105532:	78 33                	js     80105567 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105534:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105536:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105539:	e8 82 e3 ff ff       	call   801038c0 <myproc>
8010553e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105540:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105544:	85 f6                	test   %esi,%esi
80105546:	74 30                	je     80105578 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105548:	83 c3 01             	add    $0x1,%ebx
8010554b:	83 fb 10             	cmp    $0x10,%ebx
8010554e:	75 f0                	jne    80105540 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105550:	83 ec 0c             	sub    $0xc,%esp
80105553:	ff 75 e0             	pushl  -0x20(%ebp)
80105556:	e8 d5 b8 ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
8010555b:	58                   	pop    %eax
8010555c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010555f:	e8 cc b8 ff ff       	call   80100e30 <fileclose>
    return -1;
80105564:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105567:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
8010556a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010556f:	5b                   	pop    %ebx
80105570:	5e                   	pop    %esi
80105571:	5f                   	pop    %edi
80105572:	5d                   	pop    %ebp
80105573:	c3                   	ret    
80105574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105578:	8d 73 08             	lea    0x8(%ebx),%esi
8010557b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010557f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105582:	e8 39 e3 ff ff       	call   801038c0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105587:	31 d2                	xor    %edx,%edx
80105589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105590:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105594:	85 c9                	test   %ecx,%ecx
80105596:	74 18                	je     801055b0 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105598:	83 c2 01             	add    $0x1,%edx
8010559b:	83 fa 10             	cmp    $0x10,%edx
8010559e:	75 f0                	jne    80105590 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801055a0:	e8 1b e3 ff ff       	call   801038c0 <myproc>
801055a5:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801055ac:	00 
801055ad:	eb a1                	jmp    80105550 <sys_pipe+0x50>
801055af:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801055b0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801055b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801055b7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801055b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801055bc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
801055bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
801055c2:	31 c0                	xor    %eax,%eax
}
801055c4:	5b                   	pop    %ebx
801055c5:	5e                   	pop    %esi
801055c6:	5f                   	pop    %edi
801055c7:	5d                   	pop    %ebp
801055c8:	c3                   	ret    
801055c9:	66 90                	xchg   %ax,%ax
801055cb:	66 90                	xchg   %ax,%ax
801055cd:	66 90                	xchg   %ax,%ax
801055cf:	90                   	nop

801055d0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801055d3:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801055d4:	e9 97 e4 ff ff       	jmp    80103a70 <fork>
801055d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801055e0 <sys_exit>:
}

int
sys_exit(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	83 ec 08             	sub    $0x8,%esp
  exit();
801055e6:	e8 15 e7 ff ff       	call   80103d00 <exit>
  return 0;  // not reached
}
801055eb:	31 c0                	xor    %eax,%eax
801055ed:	c9                   	leave  
801055ee:	c3                   	ret    
801055ef:	90                   	nop

801055f0 <sys_wait>:

int
sys_wait(void)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801055f3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
801055f4:	e9 47 e9 ff ff       	jmp    80103f40 <wait>
801055f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105600 <sys_kill>:
}

int
sys_kill(void)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105606:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105609:	50                   	push   %eax
8010560a:	6a 00                	push   $0x0
8010560c:	e8 7f f2 ff ff       	call   80104890 <argint>
80105611:	83 c4 10             	add    $0x10,%esp
80105614:	85 c0                	test   %eax,%eax
80105616:	78 18                	js     80105630 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105618:	83 ec 0c             	sub    $0xc,%esp
8010561b:	ff 75 f4             	pushl  -0xc(%ebp)
8010561e:	e8 7d ea ff ff       	call   801040a0 <kill>
80105623:	83 c4 10             	add    $0x10,%esp
}
80105626:	c9                   	leave  
80105627:	c3                   	ret    
80105628:	90                   	nop
80105629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105630:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105635:	c9                   	leave  
80105636:	c3                   	ret    
80105637:	89 f6                	mov    %esi,%esi
80105639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105640 <sys_getpid>:

int
sys_getpid(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105646:	e8 75 e2 ff ff       	call   801038c0 <myproc>
8010564b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010564e:	c9                   	leave  
8010564f:	c3                   	ret    

80105650 <sys_sbrk>:

int
sys_sbrk(void)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105654:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105657:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010565a:	50                   	push   %eax
8010565b:	6a 00                	push   $0x0
8010565d:	e8 2e f2 ff ff       	call   80104890 <argint>
80105662:	83 c4 10             	add    $0x10,%esp
80105665:	85 c0                	test   %eax,%eax
80105667:	78 27                	js     80105690 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105669:	e8 52 e2 ff ff       	call   801038c0 <myproc>
  if(growproc(n) < 0)
8010566e:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105671:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105673:	ff 75 f4             	pushl  -0xc(%ebp)
80105676:	e8 65 e3 ff ff       	call   801039e0 <growproc>
8010567b:	83 c4 10             	add    $0x10,%esp
8010567e:	85 c0                	test   %eax,%eax
80105680:	78 0e                	js     80105690 <sys_sbrk+0x40>
    return -1;
  return addr;
80105682:	89 d8                	mov    %ebx,%eax
}
80105684:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105687:	c9                   	leave  
80105688:	c3                   	ret    
80105689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105690:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105695:	eb ed                	jmp    80105684 <sys_sbrk+0x34>
80105697:	89 f6                	mov    %esi,%esi
80105699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056a0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801056a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
801056a7:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801056aa:	50                   	push   %eax
801056ab:	6a 00                	push   $0x0
801056ad:	e8 de f1 ff ff       	call   80104890 <argint>
801056b2:	83 c4 10             	add    $0x10,%esp
801056b5:	85 c0                	test   %eax,%eax
801056b7:	0f 88 8a 00 00 00    	js     80105747 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801056bd:	83 ec 0c             	sub    $0xc,%esp
801056c0:	68 60 4f 11 80       	push   $0x80114f60
801056c5:	e8 b6 ed ff ff       	call   80104480 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801056ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056cd:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
801056d0:	8b 1d a0 57 11 80    	mov    0x801157a0,%ebx
  while(ticks - ticks0 < n){
801056d6:	85 d2                	test   %edx,%edx
801056d8:	75 27                	jne    80105701 <sys_sleep+0x61>
801056da:	eb 54                	jmp    80105730 <sys_sleep+0x90>
801056dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801056e0:	83 ec 08             	sub    $0x8,%esp
801056e3:	68 60 4f 11 80       	push   $0x80114f60
801056e8:	68 a0 57 11 80       	push   $0x801157a0
801056ed:	e8 8e e7 ff ff       	call   80103e80 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801056f2:	a1 a0 57 11 80       	mov    0x801157a0,%eax
801056f7:	83 c4 10             	add    $0x10,%esp
801056fa:	29 d8                	sub    %ebx,%eax
801056fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801056ff:	73 2f                	jae    80105730 <sys_sleep+0x90>
    if(myproc()->killed){
80105701:	e8 ba e1 ff ff       	call   801038c0 <myproc>
80105706:	8b 40 24             	mov    0x24(%eax),%eax
80105709:	85 c0                	test   %eax,%eax
8010570b:	74 d3                	je     801056e0 <sys_sleep+0x40>
      release(&tickslock);
8010570d:	83 ec 0c             	sub    $0xc,%esp
80105710:	68 60 4f 11 80       	push   $0x80114f60
80105715:	e8 16 ee ff ff       	call   80104530 <release>
      return -1;
8010571a:	83 c4 10             	add    $0x10,%esp
8010571d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105722:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105725:	c9                   	leave  
80105726:	c3                   	ret    
80105727:	89 f6                	mov    %esi,%esi
80105729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105730:	83 ec 0c             	sub    $0xc,%esp
80105733:	68 60 4f 11 80       	push   $0x80114f60
80105738:	e8 f3 ed ff ff       	call   80104530 <release>
  return 0;
8010573d:	83 c4 10             	add    $0x10,%esp
80105740:	31 c0                	xor    %eax,%eax
}
80105742:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105745:	c9                   	leave  
80105746:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105747:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010574c:	eb d4                	jmp    80105722 <sys_sleep+0x82>
8010574e:	66 90                	xchg   %ax,%ax

80105750 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	53                   	push   %ebx
80105754:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105757:	68 60 4f 11 80       	push   $0x80114f60
8010575c:	e8 1f ed ff ff       	call   80104480 <acquire>
  xticks = ticks;
80105761:	8b 1d a0 57 11 80    	mov    0x801157a0,%ebx
  release(&tickslock);
80105767:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
8010576e:	e8 bd ed ff ff       	call   80104530 <release>
  return xticks;
}
80105773:	89 d8                	mov    %ebx,%eax
80105775:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105778:	c9                   	leave  
80105779:	c3                   	ret    
8010577a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105780 <sys_date>:

int sys_date(void){
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	83 ec 1c             	sub    $0x1c,%esp
  struct rtcdate *r;
	if(argptr(0, (void*)&r, sizeof(*r)) < 0)
80105786:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105789:	6a 18                	push   $0x18
8010578b:	50                   	push   %eax
8010578c:	6a 00                	push   $0x0
8010578e:	e8 4d f1 ff ff       	call   801048e0 <argptr>
80105793:	83 c4 10             	add    $0x10,%esp
80105796:	85 c0                	test   %eax,%eax
80105798:	78 16                	js     801057b0 <sys_date+0x30>
    	return -1;
  cmostime(r);
8010579a:	83 ec 0c             	sub    $0xc,%esp
8010579d:	ff 75 f4             	pushl  -0xc(%ebp)
801057a0:	e8 2b d1 ff ff       	call   801028d0 <cmostime>
	return 0;
801057a5:	83 c4 10             	add    $0x10,%esp
801057a8:	31 c0                	xor    %eax,%eax
}
801057aa:	c9                   	leave  
801057ab:	c3                   	ret    
801057ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

int sys_date(void){
  struct rtcdate *r;
	if(argptr(0, (void*)&r, sizeof(*r)) < 0)
    	return -1;
801057b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  cmostime(r);
	return 0;
}
801057b5:	c9                   	leave  
801057b6:	c3                   	ret    
801057b7:	89 f6                	mov    %esi,%esi
801057b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057c0 <sys_alarm>:

 int
sys_alarm(void)
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	83 ec 20             	sub    $0x20,%esp
  int ticks;
  void (*handler)();

  if(argint(0, &ticks) < 0)
801057c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057c9:	50                   	push   %eax
801057ca:	6a 00                	push   $0x0
801057cc:	e8 bf f0 ff ff       	call   80104890 <argint>
801057d1:	83 c4 10             	add    $0x10,%esp
801057d4:	85 c0                	test   %eax,%eax
801057d6:	78 38                	js     80105810 <sys_alarm+0x50>
    return -1;
  if(argptr(1, (char**)&handler, 1) < 0)
801057d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057db:	83 ec 04             	sub    $0x4,%esp
801057de:	6a 01                	push   $0x1
801057e0:	50                   	push   %eax
801057e1:	6a 01                	push   $0x1
801057e3:	e8 f8 f0 ff ff       	call   801048e0 <argptr>
801057e8:	83 c4 10             	add    $0x10,%esp
801057eb:	85 c0                	test   %eax,%eax
801057ed:	78 21                	js     80105810 <sys_alarm+0x50>
    return -1;
  myproc()->alarmticks = ticks;
801057ef:	e8 cc e0 ff ff       	call   801038c0 <myproc>
801057f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801057f7:	89 50 7c             	mov    %edx,0x7c(%eax)
  myproc()->alarmhandler = handler;
801057fa:	e8 c1 e0 ff ff       	call   801038c0 <myproc>
801057ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105802:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  return 0;
80105808:	31 c0                	xor    %eax,%eax
8010580a:	c9                   	leave  
8010580b:	c3                   	ret    
8010580c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int ticks;
  void (*handler)();

  if(argint(0, &ticks) < 0)
    return -1;
80105810:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(argptr(1, (char**)&handler, 1) < 0)
    return -1;
  myproc()->alarmticks = ticks;
  myproc()->alarmhandler = handler;
  return 0;
80105815:	c9                   	leave  
80105816:	c3                   	ret    

80105817 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105817:	1e                   	push   %ds
  pushl %es
80105818:	06                   	push   %es
  pushl %fs
80105819:	0f a0                	push   %fs
  pushl %gs
8010581b:	0f a8                	push   %gs
  pushal
8010581d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010581e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105822:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105824:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105826:	54                   	push   %esp
  call trap
80105827:	e8 e4 00 00 00       	call   80105910 <trap>
  addl $4, %esp
8010582c:	83 c4 04             	add    $0x4,%esp

8010582f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010582f:	61                   	popa   
  popl %gs
80105830:	0f a9                	pop    %gs
  popl %fs
80105832:	0f a1                	pop    %fs
  popl %es
80105834:	07                   	pop    %es
  popl %ds
80105835:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105836:	83 c4 08             	add    $0x8,%esp
  iret
80105839:	cf                   	iret   
8010583a:	66 90                	xchg   %ax,%ax
8010583c:	66 90                	xchg   %ax,%ax
8010583e:	66 90                	xchg   %ax,%ax

80105840 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105840:	31 c0                	xor    %eax,%eax
80105842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105848:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010584f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105854:	c6 04 c5 a4 4f 11 80 	movb   $0x0,-0x7feeb05c(,%eax,8)
8010585b:	00 
8010585c:	66 89 0c c5 a2 4f 11 	mov    %cx,-0x7feeb05e(,%eax,8)
80105863:	80 
80105864:	c6 04 c5 a5 4f 11 80 	movb   $0x8e,-0x7feeb05b(,%eax,8)
8010586b:	8e 
8010586c:	66 89 14 c5 a0 4f 11 	mov    %dx,-0x7feeb060(,%eax,8)
80105873:	80 
80105874:	c1 ea 10             	shr    $0x10,%edx
80105877:	66 89 14 c5 a6 4f 11 	mov    %dx,-0x7feeb05a(,%eax,8)
8010587e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010587f:	83 c0 01             	add    $0x1,%eax
80105882:	3d 00 01 00 00       	cmp    $0x100,%eax
80105887:	75 bf                	jne    80105848 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105889:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010588a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010588f:	89 e5                	mov    %esp,%ebp
80105891:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105894:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105899:	68 a1 79 10 80       	push   $0x801079a1
8010589e:	68 60 4f 11 80       	push   $0x80114f60
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801058a3:	66 89 15 a2 51 11 80 	mov    %dx,0x801151a2
801058aa:	c6 05 a4 51 11 80 00 	movb   $0x0,0x801151a4
801058b1:	66 a3 a0 51 11 80    	mov    %ax,0x801151a0
801058b7:	c1 e8 10             	shr    $0x10,%eax
801058ba:	c6 05 a5 51 11 80 ef 	movb   $0xef,0x801151a5
801058c1:	66 a3 a6 51 11 80    	mov    %ax,0x801151a6

  initlock(&tickslock, "time");
801058c7:	e8 54 ea ff ff       	call   80104320 <initlock>
}
801058cc:	83 c4 10             	add    $0x10,%esp
801058cf:	c9                   	leave  
801058d0:	c3                   	ret    
801058d1:	eb 0d                	jmp    801058e0 <idtinit>
801058d3:	90                   	nop
801058d4:	90                   	nop
801058d5:	90                   	nop
801058d6:	90                   	nop
801058d7:	90                   	nop
801058d8:	90                   	nop
801058d9:	90                   	nop
801058da:	90                   	nop
801058db:	90                   	nop
801058dc:	90                   	nop
801058dd:	90                   	nop
801058de:	90                   	nop
801058df:	90                   	nop

801058e0 <idtinit>:

void
idtinit(void)
{
801058e0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801058e1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801058e6:	89 e5                	mov    %esp,%ebp
801058e8:	83 ec 10             	sub    $0x10,%esp
801058eb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801058ef:	b8 a0 4f 11 80       	mov    $0x80114fa0,%eax
801058f4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801058f8:	c1 e8 10             	shr    $0x10,%eax
801058fb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801058ff:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105902:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105905:	c9                   	leave  
80105906:	c3                   	ret    
80105907:	89 f6                	mov    %esi,%esi
80105909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105910 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	57                   	push   %edi
80105914:	56                   	push   %esi
80105915:	53                   	push   %ebx
80105916:	83 ec 0c             	sub    $0xc,%esp
80105919:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010591c:	8b 43 30             	mov    0x30(%ebx),%eax
8010591f:	83 f8 40             	cmp    $0x40,%eax
80105922:	0f 84 98 01 00 00    	je     80105ac0 <trap+0x1b0>
    return;
  }

  

  switch(tf->trapno){
80105928:	83 e8 20             	sub    $0x20,%eax
8010592b:	83 f8 1f             	cmp    $0x1f,%eax
8010592e:	0f 87 cc 01 00 00    	ja     80105b00 <trap+0x1f0>
80105934:	ff 24 85 40 7a 10 80 	jmp    *-0x7fef85c0(,%eax,4)
8010593b:	90                   	nop
8010593c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105940:	e8 5b df ff ff       	call   801038a0 <cpuid>
80105945:	85 c0                	test   %eax,%eax
80105947:	0f 84 53 02 00 00    	je     80105ba0 <trap+0x290>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
8010594d:	e8 be ce ff ff       	call   80102810 <lapiceoi>
    if(myproc() != 0 && (tf->cs & 3) == 3){
80105952:	e8 69 df ff ff       	call   801038c0 <myproc>
80105957:	85 c0                	test   %eax,%eax
80105959:	74 75                	je     801059d0 <trap+0xc0>
8010595b:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010595f:	83 e0 03             	and    $0x3,%eax
80105962:	66 83 f8 03          	cmp    $0x3,%ax
80105966:	75 68                	jne    801059d0 <trap+0xc0>
      myproc()->ticks++;
80105968:	e8 53 df ff ff       	call   801038c0 <myproc>
8010596d:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
      if(myproc()->ticks == myproc()->alarmticks) {
80105974:	e8 47 df ff ff       	call   801038c0 <myproc>
80105979:	8b b0 84 00 00 00    	mov    0x84(%eax),%esi
8010597f:	e8 3c df ff ff       	call   801038c0 <myproc>
80105984:	3b 70 7c             	cmp    0x7c(%eax),%esi
80105987:	75 47                	jne    801059d0 <trap+0xc0>
        myproc()->ticks = 0;
80105989:	e8 32 df ff ff       	call   801038c0 <myproc>
8010598e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80105995:	00 00 00 
        // 为什么不能像下面这样调用函数
        //myproc()->alarmhandler();
        tf->esp -= 4;
80105998:	8b 43 44             	mov    0x44(%ebx),%eax
        // eip压栈
        *(uint *)(tf->esp) = tf->eip;
        cprintf("%x %x\n", (uint *)(tf->esp), tf->esp);
8010599b:	83 ec 04             	sub    $0x4,%esp
      myproc()->ticks++;
      if(myproc()->ticks == myproc()->alarmticks) {
        myproc()->ticks = 0;
        // 为什么不能像下面这样调用函数
        //myproc()->alarmhandler();
        tf->esp -= 4;
8010599e:	8d 50 fc             	lea    -0x4(%eax),%edx
801059a1:	89 53 44             	mov    %edx,0x44(%ebx)
        // eip压栈
        *(uint *)(tf->esp) = tf->eip;
801059a4:	8b 53 38             	mov    0x38(%ebx),%edx
801059a7:	89 50 fc             	mov    %edx,-0x4(%eax)
        cprintf("%x %x\n", (uint *)(tf->esp), tf->esp);
801059aa:	8b 43 44             	mov    0x44(%ebx),%eax
801059ad:	50                   	push   %eax
801059ae:	50                   	push   %eax
801059af:	68 a6 79 10 80       	push   $0x801079a6
801059b4:	e8 a7 ac ff ff       	call   80100660 <cprintf>
        //(tf->esp) = tf->eip;
        tf->eip = (uint)myproc()->alarmhandler;
801059b9:	e8 02 df ff ff       	call   801038c0 <myproc>
801059be:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801059c4:	83 c4 10             	add    $0x10,%esp
801059c7:	89 43 38             	mov    %eax,0x38(%ebx)
801059ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059d0:	e8 eb de ff ff       	call   801038c0 <myproc>
801059d5:	85 c0                	test   %eax,%eax
801059d7:	74 0c                	je     801059e5 <trap+0xd5>
801059d9:	e8 e2 de ff ff       	call   801038c0 <myproc>
801059de:	8b 50 24             	mov    0x24(%eax),%edx
801059e1:	85 d2                	test   %edx,%edx
801059e3:	75 4b                	jne    80105a30 <trap+0x120>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801059e5:	e8 d6 de ff ff       	call   801038c0 <myproc>
801059ea:	85 c0                	test   %eax,%eax
801059ec:	74 0b                	je     801059f9 <trap+0xe9>
801059ee:	e8 cd de ff ff       	call   801038c0 <myproc>
801059f3:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801059f7:	74 4f                	je     80105a48 <trap+0x138>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059f9:	e8 c2 de ff ff       	call   801038c0 <myproc>
801059fe:	85 c0                	test   %eax,%eax
80105a00:	74 1d                	je     80105a1f <trap+0x10f>
80105a02:	e8 b9 de ff ff       	call   801038c0 <myproc>
80105a07:	8b 40 24             	mov    0x24(%eax),%eax
80105a0a:	85 c0                	test   %eax,%eax
80105a0c:	74 11                	je     80105a1f <trap+0x10f>
80105a0e:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a12:	83 e0 03             	and    $0x3,%eax
80105a15:	66 83 f8 03          	cmp    $0x3,%ax
80105a19:	0f 84 ce 00 00 00    	je     80105aed <trap+0x1dd>
    exit();
}
80105a1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a22:	5b                   	pop    %ebx
80105a23:	5e                   	pop    %esi
80105a24:	5f                   	pop    %edi
80105a25:	5d                   	pop    %ebp
80105a26:	c3                   	ret    
80105a27:	89 f6                	mov    %esi,%esi
80105a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a30:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a34:	83 e0 03             	and    $0x3,%eax
80105a37:	66 83 f8 03          	cmp    $0x3,%ax
80105a3b:	75 a8                	jne    801059e5 <trap+0xd5>
    exit();
80105a3d:	e8 be e2 ff ff       	call   80103d00 <exit>
80105a42:	eb a1                	jmp    801059e5 <trap+0xd5>
80105a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105a48:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105a4c:	75 ab                	jne    801059f9 <trap+0xe9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80105a4e:	e8 dd e3 ff ff       	call   80103e30 <yield>
80105a53:	eb a4                	jmp    801059f9 <trap+0xe9>
80105a55:	8d 76 00             	lea    0x0(%esi),%esi
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105a58:	e8 73 cc ff ff       	call   801026d0 <kbdintr>
    lapiceoi();
80105a5d:	e8 ae cd ff ff       	call   80102810 <lapiceoi>
    break;
80105a62:	e9 69 ff ff ff       	jmp    801059d0 <trap+0xc0>
80105a67:	89 f6                	mov    %esi,%esi
80105a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105a70:	e8 1b 03 00 00       	call   80105d90 <uartintr>
    lapiceoi();
80105a75:	e8 96 cd ff ff       	call   80102810 <lapiceoi>
    break;
80105a7a:	e9 51 ff ff ff       	jmp    801059d0 <trap+0xc0>
80105a7f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105a80:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105a84:	8b 7b 38             	mov    0x38(%ebx),%edi
80105a87:	e8 14 de ff ff       	call   801038a0 <cpuid>
80105a8c:	57                   	push   %edi
80105a8d:	56                   	push   %esi
80105a8e:	50                   	push   %eax
80105a8f:	68 e8 79 10 80       	push   $0x801079e8
80105a94:	e8 c7 ab ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105a99:	e8 72 cd ff ff       	call   80102810 <lapiceoi>
    break;
80105a9e:	83 c4 10             	add    $0x10,%esp
80105aa1:	e9 2a ff ff ff       	jmp    801059d0 <trap+0xc0>
80105aa6:	8d 76 00             	lea    0x0(%esi),%esi
80105aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        tf->eip = (uint)myproc()->alarmhandler;
        }
	  }
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105ab0:	e8 9b c6 ff ff       	call   80102150 <ideintr>
    lapiceoi();
80105ab5:	e8 56 cd ff ff       	call   80102810 <lapiceoi>
    break;
80105aba:	e9 11 ff ff ff       	jmp    801059d0 <trap+0xc0>
80105abf:	90                   	nop
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80105ac0:	e8 fb dd ff ff       	call   801038c0 <myproc>
80105ac5:	8b 70 24             	mov    0x24(%eax),%esi
80105ac8:	85 f6                	test   %esi,%esi
80105aca:	0f 85 c0 00 00 00    	jne    80105b90 <trap+0x280>
      exit();
    myproc()->tf = tf;
80105ad0:	e8 eb dd ff ff       	call   801038c0 <myproc>
80105ad5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105ad8:	e8 a3 ee ff ff       	call   80104980 <syscall>
    if(myproc()->killed)
80105add:	e8 de dd ff ff       	call   801038c0 <myproc>
80105ae2:	8b 48 24             	mov    0x24(%eax),%ecx
80105ae5:	85 c9                	test   %ecx,%ecx
80105ae7:	0f 84 32 ff ff ff    	je     80105a1f <trap+0x10f>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105aed:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105af0:	5b                   	pop    %ebx
80105af1:	5e                   	pop    %esi
80105af2:	5f                   	pop    %edi
80105af3:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80105af4:	e9 07 e2 ff ff       	jmp    80103d00 <exit>
80105af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105b00:	e8 bb dd ff ff       	call   801038c0 <myproc>
80105b05:	85 c0                	test   %eax,%eax
80105b07:	0f 84 dc 00 00 00    	je     80105be9 <trap+0x2d9>
80105b0d:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105b11:	0f 84 d2 00 00 00    	je     80105be9 <trap+0x2d9>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105b17:	0f 20 d7             	mov    %cr2,%edi
    }
    // In user space, assume process misbehaved.
    uint a;
    char *mem;
    a = PGROUNDDOWN(rcr2());
    mem = kalloc();
80105b1a:	e8 71 ca ff ff       	call   80102590 <kalloc>
      panic("trap");
    }
    // In user space, assume process misbehaved.
    uint a;
    char *mem;
    a = PGROUNDDOWN(rcr2());
80105b1f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    mem = kalloc();
    if(mem == 0){
80105b25:	85 c0                	test   %eax,%eax
    }
    // In user space, assume process misbehaved.
    uint a;
    char *mem;
    a = PGROUNDDOWN(rcr2());
    mem = kalloc();
80105b27:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80105b29:	0f 84 a5 00 00 00    	je     80105bd4 <trap+0x2c4>
      cprintf("allocuvm out of memory\n");
      //deallocuvm(pgdir, newsz, oldsz);
    }
    memset(mem, 0, PGSIZE);
80105b2f:	83 ec 04             	sub    $0x4,%esp
80105b32:	68 00 10 00 00       	push   $0x1000
80105b37:	6a 00                	push   $0x0
80105b39:	56                   	push   %esi
80105b3a:	e8 41 ea ff ff       	call   80104580 <memset>
    extern int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm);
    if(mappages(myproc()->pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80105b3f:	e8 7c dd ff ff       	call   801038c0 <myproc>
80105b44:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80105b4a:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80105b51:	52                   	push   %edx
80105b52:	68 00 10 00 00       	push   $0x1000
80105b57:	57                   	push   %edi
80105b58:	ff 70 04             	pushl  0x4(%eax)
80105b5b:	e8 00 0f 00 00       	call   80106a60 <mappages>
80105b60:	83 c4 20             	add    $0x20,%esp
80105b63:	85 c0                	test   %eax,%eax
80105b65:	0f 89 65 fe ff ff    	jns    801059d0 <trap+0xc0>
      cprintf("allocuvm out of memory (2)\n");
80105b6b:	83 ec 0c             	sub    $0xc,%esp
80105b6e:	68 ca 79 10 80       	push   $0x801079ca
80105b73:	e8 e8 aa ff ff       	call   80100660 <cprintf>
      //deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80105b78:	89 34 24             	mov    %esi,(%esp)
80105b7b:	e8 60 c8 ff ff       	call   801023e0 <kfree>
80105b80:	83 c4 10             	add    $0x10,%esp
80105b83:	e9 48 fe ff ff       	jmp    801059d0 <trap+0xc0>
80105b88:	90                   	nop
80105b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80105b90:	e8 6b e1 ff ff       	call   80103d00 <exit>
80105b95:	e9 36 ff ff ff       	jmp    80105ad0 <trap+0x1c0>
80105b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80105ba0:	83 ec 0c             	sub    $0xc,%esp
80105ba3:	68 60 4f 11 80       	push   $0x80114f60
80105ba8:	e8 d3 e8 ff ff       	call   80104480 <acquire>
      ticks++;
      wakeup(&ticks);
80105bad:	c7 04 24 a0 57 11 80 	movl   $0x801157a0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80105bb4:	83 05 a0 57 11 80 01 	addl   $0x1,0x801157a0
      wakeup(&ticks);
80105bbb:	e8 80 e4 ff ff       	call   80104040 <wakeup>
      release(&tickslock);
80105bc0:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80105bc7:	e8 64 e9 ff ff       	call   80104530 <release>
80105bcc:	83 c4 10             	add    $0x10,%esp
80105bcf:	e9 79 fd ff ff       	jmp    8010594d <trap+0x3d>
    uint a;
    char *mem;
    a = PGROUNDDOWN(rcr2());
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
80105bd4:	83 ec 0c             	sub    $0xc,%esp
80105bd7:	68 b2 79 10 80       	push   $0x801079b2
80105bdc:	e8 7f aa ff ff       	call   80100660 <cprintf>
80105be1:	83 c4 10             	add    $0x10,%esp
80105be4:	e9 46 ff ff ff       	jmp    80105b2f <trap+0x21f>
80105be9:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105bec:	8b 73 38             	mov    0x38(%ebx),%esi
80105bef:	e8 ac dc ff ff       	call   801038a0 <cpuid>
80105bf4:	83 ec 0c             	sub    $0xc,%esp
80105bf7:	57                   	push   %edi
80105bf8:	56                   	push   %esi
80105bf9:	50                   	push   %eax
80105bfa:	ff 73 30             	pushl  0x30(%ebx)
80105bfd:	68 0c 7a 10 80       	push   $0x80107a0c
80105c02:	e8 59 aa ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80105c07:	83 c4 14             	add    $0x14,%esp
80105c0a:	68 ad 79 10 80       	push   $0x801079ad
80105c0f:	e8 5c a7 ff ff       	call   80100370 <panic>
80105c14:	66 90                	xchg   %ax,%ax
80105c16:	66 90                	xchg   %ax,%ax
80105c18:	66 90                	xchg   %ax,%ax
80105c1a:	66 90                	xchg   %ax,%ax
80105c1c:	66 90                	xchg   %ax,%ax
80105c1e:	66 90                	xchg   %ax,%ax

80105c20 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105c20:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105c25:	55                   	push   %ebp
80105c26:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105c28:	85 c0                	test   %eax,%eax
80105c2a:	74 1c                	je     80105c48 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c2c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c31:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105c32:	a8 01                	test   $0x1,%al
80105c34:	74 12                	je     80105c48 <uartgetc+0x28>
80105c36:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c3b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105c3c:	0f b6 c0             	movzbl %al,%eax
}
80105c3f:	5d                   	pop    %ebp
80105c40:	c3                   	ret    
80105c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105c48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105c4d:	5d                   	pop    %ebp
80105c4e:	c3                   	ret    
80105c4f:	90                   	nop

80105c50 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
80105c53:	57                   	push   %edi
80105c54:	56                   	push   %esi
80105c55:	53                   	push   %ebx
80105c56:	89 c7                	mov    %eax,%edi
80105c58:	bb 80 00 00 00       	mov    $0x80,%ebx
80105c5d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105c62:	83 ec 0c             	sub    $0xc,%esp
80105c65:	eb 1b                	jmp    80105c82 <uartputc.part.0+0x32>
80105c67:	89 f6                	mov    %esi,%esi
80105c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105c70:	83 ec 0c             	sub    $0xc,%esp
80105c73:	6a 0a                	push   $0xa
80105c75:	e8 b6 cb ff ff       	call   80102830 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105c7a:	83 c4 10             	add    $0x10,%esp
80105c7d:	83 eb 01             	sub    $0x1,%ebx
80105c80:	74 07                	je     80105c89 <uartputc.part.0+0x39>
80105c82:	89 f2                	mov    %esi,%edx
80105c84:	ec                   	in     (%dx),%al
80105c85:	a8 20                	test   $0x20,%al
80105c87:	74 e7                	je     80105c70 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105c89:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c8e:	89 f8                	mov    %edi,%eax
80105c90:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105c91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c94:	5b                   	pop    %ebx
80105c95:	5e                   	pop    %esi
80105c96:	5f                   	pop    %edi
80105c97:	5d                   	pop    %ebp
80105c98:	c3                   	ret    
80105c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ca0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105ca0:	55                   	push   %ebp
80105ca1:	31 c9                	xor    %ecx,%ecx
80105ca3:	89 c8                	mov    %ecx,%eax
80105ca5:	89 e5                	mov    %esp,%ebp
80105ca7:	57                   	push   %edi
80105ca8:	56                   	push   %esi
80105ca9:	53                   	push   %ebx
80105caa:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105caf:	89 da                	mov    %ebx,%edx
80105cb1:	83 ec 0c             	sub    $0xc,%esp
80105cb4:	ee                   	out    %al,(%dx)
80105cb5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105cba:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105cbf:	89 fa                	mov    %edi,%edx
80105cc1:	ee                   	out    %al,(%dx)
80105cc2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105cc7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ccc:	ee                   	out    %al,(%dx)
80105ccd:	be f9 03 00 00       	mov    $0x3f9,%esi
80105cd2:	89 c8                	mov    %ecx,%eax
80105cd4:	89 f2                	mov    %esi,%edx
80105cd6:	ee                   	out    %al,(%dx)
80105cd7:	b8 03 00 00 00       	mov    $0x3,%eax
80105cdc:	89 fa                	mov    %edi,%edx
80105cde:	ee                   	out    %al,(%dx)
80105cdf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105ce4:	89 c8                	mov    %ecx,%eax
80105ce6:	ee                   	out    %al,(%dx)
80105ce7:	b8 01 00 00 00       	mov    $0x1,%eax
80105cec:	89 f2                	mov    %esi,%edx
80105cee:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105cef:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105cf4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105cf5:	3c ff                	cmp    $0xff,%al
80105cf7:	74 5a                	je     80105d53 <uartinit+0xb3>
    return;
  uart = 1;
80105cf9:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105d00:	00 00 00 
80105d03:	89 da                	mov    %ebx,%edx
80105d05:	ec                   	in     (%dx),%al
80105d06:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d0b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105d0c:	83 ec 08             	sub    $0x8,%esp
80105d0f:	bb c0 7a 10 80       	mov    $0x80107ac0,%ebx
80105d14:	6a 00                	push   $0x0
80105d16:	6a 04                	push   $0x4
80105d18:	e8 83 c6 ff ff       	call   801023a0 <ioapicenable>
80105d1d:	83 c4 10             	add    $0x10,%esp
80105d20:	b8 78 00 00 00       	mov    $0x78,%eax
80105d25:	eb 13                	jmp    80105d3a <uartinit+0x9a>
80105d27:	89 f6                	mov    %esi,%esi
80105d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105d30:	83 c3 01             	add    $0x1,%ebx
80105d33:	0f be 03             	movsbl (%ebx),%eax
80105d36:	84 c0                	test   %al,%al
80105d38:	74 19                	je     80105d53 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
80105d3a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105d40:	85 d2                	test   %edx,%edx
80105d42:	74 ec                	je     80105d30 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105d44:	83 c3 01             	add    $0x1,%ebx
80105d47:	e8 04 ff ff ff       	call   80105c50 <uartputc.part.0>
80105d4c:	0f be 03             	movsbl (%ebx),%eax
80105d4f:	84 c0                	test   %al,%al
80105d51:	75 e7                	jne    80105d3a <uartinit+0x9a>
    uartputc(*p);
}
80105d53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d56:	5b                   	pop    %ebx
80105d57:	5e                   	pop    %esi
80105d58:	5f                   	pop    %edi
80105d59:	5d                   	pop    %ebp
80105d5a:	c3                   	ret    
80105d5b:	90                   	nop
80105d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d60 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105d60:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105d66:	55                   	push   %ebp
80105d67:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80105d69:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
80105d6e:	74 10                	je     80105d80 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80105d70:	5d                   	pop    %ebp
80105d71:	e9 da fe ff ff       	jmp    80105c50 <uartputc.part.0>
80105d76:	8d 76 00             	lea    0x0(%esi),%esi
80105d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105d80:	5d                   	pop    %ebp
80105d81:	c3                   	ret    
80105d82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d90 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105d90:	55                   	push   %ebp
80105d91:	89 e5                	mov    %esp,%ebp
80105d93:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105d96:	68 20 5c 10 80       	push   $0x80105c20
80105d9b:	e8 50 aa ff ff       	call   801007f0 <consoleintr>
}
80105da0:	83 c4 10             	add    $0x10,%esp
80105da3:	c9                   	leave  
80105da4:	c3                   	ret    

80105da5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105da5:	6a 00                	push   $0x0
  pushl $0
80105da7:	6a 00                	push   $0x0
  jmp alltraps
80105da9:	e9 69 fa ff ff       	jmp    80105817 <alltraps>

80105dae <vector1>:
.globl vector1
vector1:
  pushl $0
80105dae:	6a 00                	push   $0x0
  pushl $1
80105db0:	6a 01                	push   $0x1
  jmp alltraps
80105db2:	e9 60 fa ff ff       	jmp    80105817 <alltraps>

80105db7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105db7:	6a 00                	push   $0x0
  pushl $2
80105db9:	6a 02                	push   $0x2
  jmp alltraps
80105dbb:	e9 57 fa ff ff       	jmp    80105817 <alltraps>

80105dc0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105dc0:	6a 00                	push   $0x0
  pushl $3
80105dc2:	6a 03                	push   $0x3
  jmp alltraps
80105dc4:	e9 4e fa ff ff       	jmp    80105817 <alltraps>

80105dc9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105dc9:	6a 00                	push   $0x0
  pushl $4
80105dcb:	6a 04                	push   $0x4
  jmp alltraps
80105dcd:	e9 45 fa ff ff       	jmp    80105817 <alltraps>

80105dd2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105dd2:	6a 00                	push   $0x0
  pushl $5
80105dd4:	6a 05                	push   $0x5
  jmp alltraps
80105dd6:	e9 3c fa ff ff       	jmp    80105817 <alltraps>

80105ddb <vector6>:
.globl vector6
vector6:
  pushl $0
80105ddb:	6a 00                	push   $0x0
  pushl $6
80105ddd:	6a 06                	push   $0x6
  jmp alltraps
80105ddf:	e9 33 fa ff ff       	jmp    80105817 <alltraps>

80105de4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105de4:	6a 00                	push   $0x0
  pushl $7
80105de6:	6a 07                	push   $0x7
  jmp alltraps
80105de8:	e9 2a fa ff ff       	jmp    80105817 <alltraps>

80105ded <vector8>:
.globl vector8
vector8:
  pushl $8
80105ded:	6a 08                	push   $0x8
  jmp alltraps
80105def:	e9 23 fa ff ff       	jmp    80105817 <alltraps>

80105df4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105df4:	6a 00                	push   $0x0
  pushl $9
80105df6:	6a 09                	push   $0x9
  jmp alltraps
80105df8:	e9 1a fa ff ff       	jmp    80105817 <alltraps>

80105dfd <vector10>:
.globl vector10
vector10:
  pushl $10
80105dfd:	6a 0a                	push   $0xa
  jmp alltraps
80105dff:	e9 13 fa ff ff       	jmp    80105817 <alltraps>

80105e04 <vector11>:
.globl vector11
vector11:
  pushl $11
80105e04:	6a 0b                	push   $0xb
  jmp alltraps
80105e06:	e9 0c fa ff ff       	jmp    80105817 <alltraps>

80105e0b <vector12>:
.globl vector12
vector12:
  pushl $12
80105e0b:	6a 0c                	push   $0xc
  jmp alltraps
80105e0d:	e9 05 fa ff ff       	jmp    80105817 <alltraps>

80105e12 <vector13>:
.globl vector13
vector13:
  pushl $13
80105e12:	6a 0d                	push   $0xd
  jmp alltraps
80105e14:	e9 fe f9 ff ff       	jmp    80105817 <alltraps>

80105e19 <vector14>:
.globl vector14
vector14:
  pushl $14
80105e19:	6a 0e                	push   $0xe
  jmp alltraps
80105e1b:	e9 f7 f9 ff ff       	jmp    80105817 <alltraps>

80105e20 <vector15>:
.globl vector15
vector15:
  pushl $0
80105e20:	6a 00                	push   $0x0
  pushl $15
80105e22:	6a 0f                	push   $0xf
  jmp alltraps
80105e24:	e9 ee f9 ff ff       	jmp    80105817 <alltraps>

80105e29 <vector16>:
.globl vector16
vector16:
  pushl $0
80105e29:	6a 00                	push   $0x0
  pushl $16
80105e2b:	6a 10                	push   $0x10
  jmp alltraps
80105e2d:	e9 e5 f9 ff ff       	jmp    80105817 <alltraps>

80105e32 <vector17>:
.globl vector17
vector17:
  pushl $17
80105e32:	6a 11                	push   $0x11
  jmp alltraps
80105e34:	e9 de f9 ff ff       	jmp    80105817 <alltraps>

80105e39 <vector18>:
.globl vector18
vector18:
  pushl $0
80105e39:	6a 00                	push   $0x0
  pushl $18
80105e3b:	6a 12                	push   $0x12
  jmp alltraps
80105e3d:	e9 d5 f9 ff ff       	jmp    80105817 <alltraps>

80105e42 <vector19>:
.globl vector19
vector19:
  pushl $0
80105e42:	6a 00                	push   $0x0
  pushl $19
80105e44:	6a 13                	push   $0x13
  jmp alltraps
80105e46:	e9 cc f9 ff ff       	jmp    80105817 <alltraps>

80105e4b <vector20>:
.globl vector20
vector20:
  pushl $0
80105e4b:	6a 00                	push   $0x0
  pushl $20
80105e4d:	6a 14                	push   $0x14
  jmp alltraps
80105e4f:	e9 c3 f9 ff ff       	jmp    80105817 <alltraps>

80105e54 <vector21>:
.globl vector21
vector21:
  pushl $0
80105e54:	6a 00                	push   $0x0
  pushl $21
80105e56:	6a 15                	push   $0x15
  jmp alltraps
80105e58:	e9 ba f9 ff ff       	jmp    80105817 <alltraps>

80105e5d <vector22>:
.globl vector22
vector22:
  pushl $0
80105e5d:	6a 00                	push   $0x0
  pushl $22
80105e5f:	6a 16                	push   $0x16
  jmp alltraps
80105e61:	e9 b1 f9 ff ff       	jmp    80105817 <alltraps>

80105e66 <vector23>:
.globl vector23
vector23:
  pushl $0
80105e66:	6a 00                	push   $0x0
  pushl $23
80105e68:	6a 17                	push   $0x17
  jmp alltraps
80105e6a:	e9 a8 f9 ff ff       	jmp    80105817 <alltraps>

80105e6f <vector24>:
.globl vector24
vector24:
  pushl $0
80105e6f:	6a 00                	push   $0x0
  pushl $24
80105e71:	6a 18                	push   $0x18
  jmp alltraps
80105e73:	e9 9f f9 ff ff       	jmp    80105817 <alltraps>

80105e78 <vector25>:
.globl vector25
vector25:
  pushl $0
80105e78:	6a 00                	push   $0x0
  pushl $25
80105e7a:	6a 19                	push   $0x19
  jmp alltraps
80105e7c:	e9 96 f9 ff ff       	jmp    80105817 <alltraps>

80105e81 <vector26>:
.globl vector26
vector26:
  pushl $0
80105e81:	6a 00                	push   $0x0
  pushl $26
80105e83:	6a 1a                	push   $0x1a
  jmp alltraps
80105e85:	e9 8d f9 ff ff       	jmp    80105817 <alltraps>

80105e8a <vector27>:
.globl vector27
vector27:
  pushl $0
80105e8a:	6a 00                	push   $0x0
  pushl $27
80105e8c:	6a 1b                	push   $0x1b
  jmp alltraps
80105e8e:	e9 84 f9 ff ff       	jmp    80105817 <alltraps>

80105e93 <vector28>:
.globl vector28
vector28:
  pushl $0
80105e93:	6a 00                	push   $0x0
  pushl $28
80105e95:	6a 1c                	push   $0x1c
  jmp alltraps
80105e97:	e9 7b f9 ff ff       	jmp    80105817 <alltraps>

80105e9c <vector29>:
.globl vector29
vector29:
  pushl $0
80105e9c:	6a 00                	push   $0x0
  pushl $29
80105e9e:	6a 1d                	push   $0x1d
  jmp alltraps
80105ea0:	e9 72 f9 ff ff       	jmp    80105817 <alltraps>

80105ea5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105ea5:	6a 00                	push   $0x0
  pushl $30
80105ea7:	6a 1e                	push   $0x1e
  jmp alltraps
80105ea9:	e9 69 f9 ff ff       	jmp    80105817 <alltraps>

80105eae <vector31>:
.globl vector31
vector31:
  pushl $0
80105eae:	6a 00                	push   $0x0
  pushl $31
80105eb0:	6a 1f                	push   $0x1f
  jmp alltraps
80105eb2:	e9 60 f9 ff ff       	jmp    80105817 <alltraps>

80105eb7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105eb7:	6a 00                	push   $0x0
  pushl $32
80105eb9:	6a 20                	push   $0x20
  jmp alltraps
80105ebb:	e9 57 f9 ff ff       	jmp    80105817 <alltraps>

80105ec0 <vector33>:
.globl vector33
vector33:
  pushl $0
80105ec0:	6a 00                	push   $0x0
  pushl $33
80105ec2:	6a 21                	push   $0x21
  jmp alltraps
80105ec4:	e9 4e f9 ff ff       	jmp    80105817 <alltraps>

80105ec9 <vector34>:
.globl vector34
vector34:
  pushl $0
80105ec9:	6a 00                	push   $0x0
  pushl $34
80105ecb:	6a 22                	push   $0x22
  jmp alltraps
80105ecd:	e9 45 f9 ff ff       	jmp    80105817 <alltraps>

80105ed2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ed2:	6a 00                	push   $0x0
  pushl $35
80105ed4:	6a 23                	push   $0x23
  jmp alltraps
80105ed6:	e9 3c f9 ff ff       	jmp    80105817 <alltraps>

80105edb <vector36>:
.globl vector36
vector36:
  pushl $0
80105edb:	6a 00                	push   $0x0
  pushl $36
80105edd:	6a 24                	push   $0x24
  jmp alltraps
80105edf:	e9 33 f9 ff ff       	jmp    80105817 <alltraps>

80105ee4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105ee4:	6a 00                	push   $0x0
  pushl $37
80105ee6:	6a 25                	push   $0x25
  jmp alltraps
80105ee8:	e9 2a f9 ff ff       	jmp    80105817 <alltraps>

80105eed <vector38>:
.globl vector38
vector38:
  pushl $0
80105eed:	6a 00                	push   $0x0
  pushl $38
80105eef:	6a 26                	push   $0x26
  jmp alltraps
80105ef1:	e9 21 f9 ff ff       	jmp    80105817 <alltraps>

80105ef6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105ef6:	6a 00                	push   $0x0
  pushl $39
80105ef8:	6a 27                	push   $0x27
  jmp alltraps
80105efa:	e9 18 f9 ff ff       	jmp    80105817 <alltraps>

80105eff <vector40>:
.globl vector40
vector40:
  pushl $0
80105eff:	6a 00                	push   $0x0
  pushl $40
80105f01:	6a 28                	push   $0x28
  jmp alltraps
80105f03:	e9 0f f9 ff ff       	jmp    80105817 <alltraps>

80105f08 <vector41>:
.globl vector41
vector41:
  pushl $0
80105f08:	6a 00                	push   $0x0
  pushl $41
80105f0a:	6a 29                	push   $0x29
  jmp alltraps
80105f0c:	e9 06 f9 ff ff       	jmp    80105817 <alltraps>

80105f11 <vector42>:
.globl vector42
vector42:
  pushl $0
80105f11:	6a 00                	push   $0x0
  pushl $42
80105f13:	6a 2a                	push   $0x2a
  jmp alltraps
80105f15:	e9 fd f8 ff ff       	jmp    80105817 <alltraps>

80105f1a <vector43>:
.globl vector43
vector43:
  pushl $0
80105f1a:	6a 00                	push   $0x0
  pushl $43
80105f1c:	6a 2b                	push   $0x2b
  jmp alltraps
80105f1e:	e9 f4 f8 ff ff       	jmp    80105817 <alltraps>

80105f23 <vector44>:
.globl vector44
vector44:
  pushl $0
80105f23:	6a 00                	push   $0x0
  pushl $44
80105f25:	6a 2c                	push   $0x2c
  jmp alltraps
80105f27:	e9 eb f8 ff ff       	jmp    80105817 <alltraps>

80105f2c <vector45>:
.globl vector45
vector45:
  pushl $0
80105f2c:	6a 00                	push   $0x0
  pushl $45
80105f2e:	6a 2d                	push   $0x2d
  jmp alltraps
80105f30:	e9 e2 f8 ff ff       	jmp    80105817 <alltraps>

80105f35 <vector46>:
.globl vector46
vector46:
  pushl $0
80105f35:	6a 00                	push   $0x0
  pushl $46
80105f37:	6a 2e                	push   $0x2e
  jmp alltraps
80105f39:	e9 d9 f8 ff ff       	jmp    80105817 <alltraps>

80105f3e <vector47>:
.globl vector47
vector47:
  pushl $0
80105f3e:	6a 00                	push   $0x0
  pushl $47
80105f40:	6a 2f                	push   $0x2f
  jmp alltraps
80105f42:	e9 d0 f8 ff ff       	jmp    80105817 <alltraps>

80105f47 <vector48>:
.globl vector48
vector48:
  pushl $0
80105f47:	6a 00                	push   $0x0
  pushl $48
80105f49:	6a 30                	push   $0x30
  jmp alltraps
80105f4b:	e9 c7 f8 ff ff       	jmp    80105817 <alltraps>

80105f50 <vector49>:
.globl vector49
vector49:
  pushl $0
80105f50:	6a 00                	push   $0x0
  pushl $49
80105f52:	6a 31                	push   $0x31
  jmp alltraps
80105f54:	e9 be f8 ff ff       	jmp    80105817 <alltraps>

80105f59 <vector50>:
.globl vector50
vector50:
  pushl $0
80105f59:	6a 00                	push   $0x0
  pushl $50
80105f5b:	6a 32                	push   $0x32
  jmp alltraps
80105f5d:	e9 b5 f8 ff ff       	jmp    80105817 <alltraps>

80105f62 <vector51>:
.globl vector51
vector51:
  pushl $0
80105f62:	6a 00                	push   $0x0
  pushl $51
80105f64:	6a 33                	push   $0x33
  jmp alltraps
80105f66:	e9 ac f8 ff ff       	jmp    80105817 <alltraps>

80105f6b <vector52>:
.globl vector52
vector52:
  pushl $0
80105f6b:	6a 00                	push   $0x0
  pushl $52
80105f6d:	6a 34                	push   $0x34
  jmp alltraps
80105f6f:	e9 a3 f8 ff ff       	jmp    80105817 <alltraps>

80105f74 <vector53>:
.globl vector53
vector53:
  pushl $0
80105f74:	6a 00                	push   $0x0
  pushl $53
80105f76:	6a 35                	push   $0x35
  jmp alltraps
80105f78:	e9 9a f8 ff ff       	jmp    80105817 <alltraps>

80105f7d <vector54>:
.globl vector54
vector54:
  pushl $0
80105f7d:	6a 00                	push   $0x0
  pushl $54
80105f7f:	6a 36                	push   $0x36
  jmp alltraps
80105f81:	e9 91 f8 ff ff       	jmp    80105817 <alltraps>

80105f86 <vector55>:
.globl vector55
vector55:
  pushl $0
80105f86:	6a 00                	push   $0x0
  pushl $55
80105f88:	6a 37                	push   $0x37
  jmp alltraps
80105f8a:	e9 88 f8 ff ff       	jmp    80105817 <alltraps>

80105f8f <vector56>:
.globl vector56
vector56:
  pushl $0
80105f8f:	6a 00                	push   $0x0
  pushl $56
80105f91:	6a 38                	push   $0x38
  jmp alltraps
80105f93:	e9 7f f8 ff ff       	jmp    80105817 <alltraps>

80105f98 <vector57>:
.globl vector57
vector57:
  pushl $0
80105f98:	6a 00                	push   $0x0
  pushl $57
80105f9a:	6a 39                	push   $0x39
  jmp alltraps
80105f9c:	e9 76 f8 ff ff       	jmp    80105817 <alltraps>

80105fa1 <vector58>:
.globl vector58
vector58:
  pushl $0
80105fa1:	6a 00                	push   $0x0
  pushl $58
80105fa3:	6a 3a                	push   $0x3a
  jmp alltraps
80105fa5:	e9 6d f8 ff ff       	jmp    80105817 <alltraps>

80105faa <vector59>:
.globl vector59
vector59:
  pushl $0
80105faa:	6a 00                	push   $0x0
  pushl $59
80105fac:	6a 3b                	push   $0x3b
  jmp alltraps
80105fae:	e9 64 f8 ff ff       	jmp    80105817 <alltraps>

80105fb3 <vector60>:
.globl vector60
vector60:
  pushl $0
80105fb3:	6a 00                	push   $0x0
  pushl $60
80105fb5:	6a 3c                	push   $0x3c
  jmp alltraps
80105fb7:	e9 5b f8 ff ff       	jmp    80105817 <alltraps>

80105fbc <vector61>:
.globl vector61
vector61:
  pushl $0
80105fbc:	6a 00                	push   $0x0
  pushl $61
80105fbe:	6a 3d                	push   $0x3d
  jmp alltraps
80105fc0:	e9 52 f8 ff ff       	jmp    80105817 <alltraps>

80105fc5 <vector62>:
.globl vector62
vector62:
  pushl $0
80105fc5:	6a 00                	push   $0x0
  pushl $62
80105fc7:	6a 3e                	push   $0x3e
  jmp alltraps
80105fc9:	e9 49 f8 ff ff       	jmp    80105817 <alltraps>

80105fce <vector63>:
.globl vector63
vector63:
  pushl $0
80105fce:	6a 00                	push   $0x0
  pushl $63
80105fd0:	6a 3f                	push   $0x3f
  jmp alltraps
80105fd2:	e9 40 f8 ff ff       	jmp    80105817 <alltraps>

80105fd7 <vector64>:
.globl vector64
vector64:
  pushl $0
80105fd7:	6a 00                	push   $0x0
  pushl $64
80105fd9:	6a 40                	push   $0x40
  jmp alltraps
80105fdb:	e9 37 f8 ff ff       	jmp    80105817 <alltraps>

80105fe0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105fe0:	6a 00                	push   $0x0
  pushl $65
80105fe2:	6a 41                	push   $0x41
  jmp alltraps
80105fe4:	e9 2e f8 ff ff       	jmp    80105817 <alltraps>

80105fe9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105fe9:	6a 00                	push   $0x0
  pushl $66
80105feb:	6a 42                	push   $0x42
  jmp alltraps
80105fed:	e9 25 f8 ff ff       	jmp    80105817 <alltraps>

80105ff2 <vector67>:
.globl vector67
vector67:
  pushl $0
80105ff2:	6a 00                	push   $0x0
  pushl $67
80105ff4:	6a 43                	push   $0x43
  jmp alltraps
80105ff6:	e9 1c f8 ff ff       	jmp    80105817 <alltraps>

80105ffb <vector68>:
.globl vector68
vector68:
  pushl $0
80105ffb:	6a 00                	push   $0x0
  pushl $68
80105ffd:	6a 44                	push   $0x44
  jmp alltraps
80105fff:	e9 13 f8 ff ff       	jmp    80105817 <alltraps>

80106004 <vector69>:
.globl vector69
vector69:
  pushl $0
80106004:	6a 00                	push   $0x0
  pushl $69
80106006:	6a 45                	push   $0x45
  jmp alltraps
80106008:	e9 0a f8 ff ff       	jmp    80105817 <alltraps>

8010600d <vector70>:
.globl vector70
vector70:
  pushl $0
8010600d:	6a 00                	push   $0x0
  pushl $70
8010600f:	6a 46                	push   $0x46
  jmp alltraps
80106011:	e9 01 f8 ff ff       	jmp    80105817 <alltraps>

80106016 <vector71>:
.globl vector71
vector71:
  pushl $0
80106016:	6a 00                	push   $0x0
  pushl $71
80106018:	6a 47                	push   $0x47
  jmp alltraps
8010601a:	e9 f8 f7 ff ff       	jmp    80105817 <alltraps>

8010601f <vector72>:
.globl vector72
vector72:
  pushl $0
8010601f:	6a 00                	push   $0x0
  pushl $72
80106021:	6a 48                	push   $0x48
  jmp alltraps
80106023:	e9 ef f7 ff ff       	jmp    80105817 <alltraps>

80106028 <vector73>:
.globl vector73
vector73:
  pushl $0
80106028:	6a 00                	push   $0x0
  pushl $73
8010602a:	6a 49                	push   $0x49
  jmp alltraps
8010602c:	e9 e6 f7 ff ff       	jmp    80105817 <alltraps>

80106031 <vector74>:
.globl vector74
vector74:
  pushl $0
80106031:	6a 00                	push   $0x0
  pushl $74
80106033:	6a 4a                	push   $0x4a
  jmp alltraps
80106035:	e9 dd f7 ff ff       	jmp    80105817 <alltraps>

8010603a <vector75>:
.globl vector75
vector75:
  pushl $0
8010603a:	6a 00                	push   $0x0
  pushl $75
8010603c:	6a 4b                	push   $0x4b
  jmp alltraps
8010603e:	e9 d4 f7 ff ff       	jmp    80105817 <alltraps>

80106043 <vector76>:
.globl vector76
vector76:
  pushl $0
80106043:	6a 00                	push   $0x0
  pushl $76
80106045:	6a 4c                	push   $0x4c
  jmp alltraps
80106047:	e9 cb f7 ff ff       	jmp    80105817 <alltraps>

8010604c <vector77>:
.globl vector77
vector77:
  pushl $0
8010604c:	6a 00                	push   $0x0
  pushl $77
8010604e:	6a 4d                	push   $0x4d
  jmp alltraps
80106050:	e9 c2 f7 ff ff       	jmp    80105817 <alltraps>

80106055 <vector78>:
.globl vector78
vector78:
  pushl $0
80106055:	6a 00                	push   $0x0
  pushl $78
80106057:	6a 4e                	push   $0x4e
  jmp alltraps
80106059:	e9 b9 f7 ff ff       	jmp    80105817 <alltraps>

8010605e <vector79>:
.globl vector79
vector79:
  pushl $0
8010605e:	6a 00                	push   $0x0
  pushl $79
80106060:	6a 4f                	push   $0x4f
  jmp alltraps
80106062:	e9 b0 f7 ff ff       	jmp    80105817 <alltraps>

80106067 <vector80>:
.globl vector80
vector80:
  pushl $0
80106067:	6a 00                	push   $0x0
  pushl $80
80106069:	6a 50                	push   $0x50
  jmp alltraps
8010606b:	e9 a7 f7 ff ff       	jmp    80105817 <alltraps>

80106070 <vector81>:
.globl vector81
vector81:
  pushl $0
80106070:	6a 00                	push   $0x0
  pushl $81
80106072:	6a 51                	push   $0x51
  jmp alltraps
80106074:	e9 9e f7 ff ff       	jmp    80105817 <alltraps>

80106079 <vector82>:
.globl vector82
vector82:
  pushl $0
80106079:	6a 00                	push   $0x0
  pushl $82
8010607b:	6a 52                	push   $0x52
  jmp alltraps
8010607d:	e9 95 f7 ff ff       	jmp    80105817 <alltraps>

80106082 <vector83>:
.globl vector83
vector83:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $83
80106084:	6a 53                	push   $0x53
  jmp alltraps
80106086:	e9 8c f7 ff ff       	jmp    80105817 <alltraps>

8010608b <vector84>:
.globl vector84
vector84:
  pushl $0
8010608b:	6a 00                	push   $0x0
  pushl $84
8010608d:	6a 54                	push   $0x54
  jmp alltraps
8010608f:	e9 83 f7 ff ff       	jmp    80105817 <alltraps>

80106094 <vector85>:
.globl vector85
vector85:
  pushl $0
80106094:	6a 00                	push   $0x0
  pushl $85
80106096:	6a 55                	push   $0x55
  jmp alltraps
80106098:	e9 7a f7 ff ff       	jmp    80105817 <alltraps>

8010609d <vector86>:
.globl vector86
vector86:
  pushl $0
8010609d:	6a 00                	push   $0x0
  pushl $86
8010609f:	6a 56                	push   $0x56
  jmp alltraps
801060a1:	e9 71 f7 ff ff       	jmp    80105817 <alltraps>

801060a6 <vector87>:
.globl vector87
vector87:
  pushl $0
801060a6:	6a 00                	push   $0x0
  pushl $87
801060a8:	6a 57                	push   $0x57
  jmp alltraps
801060aa:	e9 68 f7 ff ff       	jmp    80105817 <alltraps>

801060af <vector88>:
.globl vector88
vector88:
  pushl $0
801060af:	6a 00                	push   $0x0
  pushl $88
801060b1:	6a 58                	push   $0x58
  jmp alltraps
801060b3:	e9 5f f7 ff ff       	jmp    80105817 <alltraps>

801060b8 <vector89>:
.globl vector89
vector89:
  pushl $0
801060b8:	6a 00                	push   $0x0
  pushl $89
801060ba:	6a 59                	push   $0x59
  jmp alltraps
801060bc:	e9 56 f7 ff ff       	jmp    80105817 <alltraps>

801060c1 <vector90>:
.globl vector90
vector90:
  pushl $0
801060c1:	6a 00                	push   $0x0
  pushl $90
801060c3:	6a 5a                	push   $0x5a
  jmp alltraps
801060c5:	e9 4d f7 ff ff       	jmp    80105817 <alltraps>

801060ca <vector91>:
.globl vector91
vector91:
  pushl $0
801060ca:	6a 00                	push   $0x0
  pushl $91
801060cc:	6a 5b                	push   $0x5b
  jmp alltraps
801060ce:	e9 44 f7 ff ff       	jmp    80105817 <alltraps>

801060d3 <vector92>:
.globl vector92
vector92:
  pushl $0
801060d3:	6a 00                	push   $0x0
  pushl $92
801060d5:	6a 5c                	push   $0x5c
  jmp alltraps
801060d7:	e9 3b f7 ff ff       	jmp    80105817 <alltraps>

801060dc <vector93>:
.globl vector93
vector93:
  pushl $0
801060dc:	6a 00                	push   $0x0
  pushl $93
801060de:	6a 5d                	push   $0x5d
  jmp alltraps
801060e0:	e9 32 f7 ff ff       	jmp    80105817 <alltraps>

801060e5 <vector94>:
.globl vector94
vector94:
  pushl $0
801060e5:	6a 00                	push   $0x0
  pushl $94
801060e7:	6a 5e                	push   $0x5e
  jmp alltraps
801060e9:	e9 29 f7 ff ff       	jmp    80105817 <alltraps>

801060ee <vector95>:
.globl vector95
vector95:
  pushl $0
801060ee:	6a 00                	push   $0x0
  pushl $95
801060f0:	6a 5f                	push   $0x5f
  jmp alltraps
801060f2:	e9 20 f7 ff ff       	jmp    80105817 <alltraps>

801060f7 <vector96>:
.globl vector96
vector96:
  pushl $0
801060f7:	6a 00                	push   $0x0
  pushl $96
801060f9:	6a 60                	push   $0x60
  jmp alltraps
801060fb:	e9 17 f7 ff ff       	jmp    80105817 <alltraps>

80106100 <vector97>:
.globl vector97
vector97:
  pushl $0
80106100:	6a 00                	push   $0x0
  pushl $97
80106102:	6a 61                	push   $0x61
  jmp alltraps
80106104:	e9 0e f7 ff ff       	jmp    80105817 <alltraps>

80106109 <vector98>:
.globl vector98
vector98:
  pushl $0
80106109:	6a 00                	push   $0x0
  pushl $98
8010610b:	6a 62                	push   $0x62
  jmp alltraps
8010610d:	e9 05 f7 ff ff       	jmp    80105817 <alltraps>

80106112 <vector99>:
.globl vector99
vector99:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $99
80106114:	6a 63                	push   $0x63
  jmp alltraps
80106116:	e9 fc f6 ff ff       	jmp    80105817 <alltraps>

8010611b <vector100>:
.globl vector100
vector100:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $100
8010611d:	6a 64                	push   $0x64
  jmp alltraps
8010611f:	e9 f3 f6 ff ff       	jmp    80105817 <alltraps>

80106124 <vector101>:
.globl vector101
vector101:
  pushl $0
80106124:	6a 00                	push   $0x0
  pushl $101
80106126:	6a 65                	push   $0x65
  jmp alltraps
80106128:	e9 ea f6 ff ff       	jmp    80105817 <alltraps>

8010612d <vector102>:
.globl vector102
vector102:
  pushl $0
8010612d:	6a 00                	push   $0x0
  pushl $102
8010612f:	6a 66                	push   $0x66
  jmp alltraps
80106131:	e9 e1 f6 ff ff       	jmp    80105817 <alltraps>

80106136 <vector103>:
.globl vector103
vector103:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $103
80106138:	6a 67                	push   $0x67
  jmp alltraps
8010613a:	e9 d8 f6 ff ff       	jmp    80105817 <alltraps>

8010613f <vector104>:
.globl vector104
vector104:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $104
80106141:	6a 68                	push   $0x68
  jmp alltraps
80106143:	e9 cf f6 ff ff       	jmp    80105817 <alltraps>

80106148 <vector105>:
.globl vector105
vector105:
  pushl $0
80106148:	6a 00                	push   $0x0
  pushl $105
8010614a:	6a 69                	push   $0x69
  jmp alltraps
8010614c:	e9 c6 f6 ff ff       	jmp    80105817 <alltraps>

80106151 <vector106>:
.globl vector106
vector106:
  pushl $0
80106151:	6a 00                	push   $0x0
  pushl $106
80106153:	6a 6a                	push   $0x6a
  jmp alltraps
80106155:	e9 bd f6 ff ff       	jmp    80105817 <alltraps>

8010615a <vector107>:
.globl vector107
vector107:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $107
8010615c:	6a 6b                	push   $0x6b
  jmp alltraps
8010615e:	e9 b4 f6 ff ff       	jmp    80105817 <alltraps>

80106163 <vector108>:
.globl vector108
vector108:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $108
80106165:	6a 6c                	push   $0x6c
  jmp alltraps
80106167:	e9 ab f6 ff ff       	jmp    80105817 <alltraps>

8010616c <vector109>:
.globl vector109
vector109:
  pushl $0
8010616c:	6a 00                	push   $0x0
  pushl $109
8010616e:	6a 6d                	push   $0x6d
  jmp alltraps
80106170:	e9 a2 f6 ff ff       	jmp    80105817 <alltraps>

80106175 <vector110>:
.globl vector110
vector110:
  pushl $0
80106175:	6a 00                	push   $0x0
  pushl $110
80106177:	6a 6e                	push   $0x6e
  jmp alltraps
80106179:	e9 99 f6 ff ff       	jmp    80105817 <alltraps>

8010617e <vector111>:
.globl vector111
vector111:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $111
80106180:	6a 6f                	push   $0x6f
  jmp alltraps
80106182:	e9 90 f6 ff ff       	jmp    80105817 <alltraps>

80106187 <vector112>:
.globl vector112
vector112:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $112
80106189:	6a 70                	push   $0x70
  jmp alltraps
8010618b:	e9 87 f6 ff ff       	jmp    80105817 <alltraps>

80106190 <vector113>:
.globl vector113
vector113:
  pushl $0
80106190:	6a 00                	push   $0x0
  pushl $113
80106192:	6a 71                	push   $0x71
  jmp alltraps
80106194:	e9 7e f6 ff ff       	jmp    80105817 <alltraps>

80106199 <vector114>:
.globl vector114
vector114:
  pushl $0
80106199:	6a 00                	push   $0x0
  pushl $114
8010619b:	6a 72                	push   $0x72
  jmp alltraps
8010619d:	e9 75 f6 ff ff       	jmp    80105817 <alltraps>

801061a2 <vector115>:
.globl vector115
vector115:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $115
801061a4:	6a 73                	push   $0x73
  jmp alltraps
801061a6:	e9 6c f6 ff ff       	jmp    80105817 <alltraps>

801061ab <vector116>:
.globl vector116
vector116:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $116
801061ad:	6a 74                	push   $0x74
  jmp alltraps
801061af:	e9 63 f6 ff ff       	jmp    80105817 <alltraps>

801061b4 <vector117>:
.globl vector117
vector117:
  pushl $0
801061b4:	6a 00                	push   $0x0
  pushl $117
801061b6:	6a 75                	push   $0x75
  jmp alltraps
801061b8:	e9 5a f6 ff ff       	jmp    80105817 <alltraps>

801061bd <vector118>:
.globl vector118
vector118:
  pushl $0
801061bd:	6a 00                	push   $0x0
  pushl $118
801061bf:	6a 76                	push   $0x76
  jmp alltraps
801061c1:	e9 51 f6 ff ff       	jmp    80105817 <alltraps>

801061c6 <vector119>:
.globl vector119
vector119:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $119
801061c8:	6a 77                	push   $0x77
  jmp alltraps
801061ca:	e9 48 f6 ff ff       	jmp    80105817 <alltraps>

801061cf <vector120>:
.globl vector120
vector120:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $120
801061d1:	6a 78                	push   $0x78
  jmp alltraps
801061d3:	e9 3f f6 ff ff       	jmp    80105817 <alltraps>

801061d8 <vector121>:
.globl vector121
vector121:
  pushl $0
801061d8:	6a 00                	push   $0x0
  pushl $121
801061da:	6a 79                	push   $0x79
  jmp alltraps
801061dc:	e9 36 f6 ff ff       	jmp    80105817 <alltraps>

801061e1 <vector122>:
.globl vector122
vector122:
  pushl $0
801061e1:	6a 00                	push   $0x0
  pushl $122
801061e3:	6a 7a                	push   $0x7a
  jmp alltraps
801061e5:	e9 2d f6 ff ff       	jmp    80105817 <alltraps>

801061ea <vector123>:
.globl vector123
vector123:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $123
801061ec:	6a 7b                	push   $0x7b
  jmp alltraps
801061ee:	e9 24 f6 ff ff       	jmp    80105817 <alltraps>

801061f3 <vector124>:
.globl vector124
vector124:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $124
801061f5:	6a 7c                	push   $0x7c
  jmp alltraps
801061f7:	e9 1b f6 ff ff       	jmp    80105817 <alltraps>

801061fc <vector125>:
.globl vector125
vector125:
  pushl $0
801061fc:	6a 00                	push   $0x0
  pushl $125
801061fe:	6a 7d                	push   $0x7d
  jmp alltraps
80106200:	e9 12 f6 ff ff       	jmp    80105817 <alltraps>

80106205 <vector126>:
.globl vector126
vector126:
  pushl $0
80106205:	6a 00                	push   $0x0
  pushl $126
80106207:	6a 7e                	push   $0x7e
  jmp alltraps
80106209:	e9 09 f6 ff ff       	jmp    80105817 <alltraps>

8010620e <vector127>:
.globl vector127
vector127:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $127
80106210:	6a 7f                	push   $0x7f
  jmp alltraps
80106212:	e9 00 f6 ff ff       	jmp    80105817 <alltraps>

80106217 <vector128>:
.globl vector128
vector128:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $128
80106219:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010621e:	e9 f4 f5 ff ff       	jmp    80105817 <alltraps>

80106223 <vector129>:
.globl vector129
vector129:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $129
80106225:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010622a:	e9 e8 f5 ff ff       	jmp    80105817 <alltraps>

8010622f <vector130>:
.globl vector130
vector130:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $130
80106231:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106236:	e9 dc f5 ff ff       	jmp    80105817 <alltraps>

8010623b <vector131>:
.globl vector131
vector131:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $131
8010623d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106242:	e9 d0 f5 ff ff       	jmp    80105817 <alltraps>

80106247 <vector132>:
.globl vector132
vector132:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $132
80106249:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010624e:	e9 c4 f5 ff ff       	jmp    80105817 <alltraps>

80106253 <vector133>:
.globl vector133
vector133:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $133
80106255:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010625a:	e9 b8 f5 ff ff       	jmp    80105817 <alltraps>

8010625f <vector134>:
.globl vector134
vector134:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $134
80106261:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106266:	e9 ac f5 ff ff       	jmp    80105817 <alltraps>

8010626b <vector135>:
.globl vector135
vector135:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $135
8010626d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106272:	e9 a0 f5 ff ff       	jmp    80105817 <alltraps>

80106277 <vector136>:
.globl vector136
vector136:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $136
80106279:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010627e:	e9 94 f5 ff ff       	jmp    80105817 <alltraps>

80106283 <vector137>:
.globl vector137
vector137:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $137
80106285:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010628a:	e9 88 f5 ff ff       	jmp    80105817 <alltraps>

8010628f <vector138>:
.globl vector138
vector138:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $138
80106291:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106296:	e9 7c f5 ff ff       	jmp    80105817 <alltraps>

8010629b <vector139>:
.globl vector139
vector139:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $139
8010629d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801062a2:	e9 70 f5 ff ff       	jmp    80105817 <alltraps>

801062a7 <vector140>:
.globl vector140
vector140:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $140
801062a9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801062ae:	e9 64 f5 ff ff       	jmp    80105817 <alltraps>

801062b3 <vector141>:
.globl vector141
vector141:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $141
801062b5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801062ba:	e9 58 f5 ff ff       	jmp    80105817 <alltraps>

801062bf <vector142>:
.globl vector142
vector142:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $142
801062c1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801062c6:	e9 4c f5 ff ff       	jmp    80105817 <alltraps>

801062cb <vector143>:
.globl vector143
vector143:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $143
801062cd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801062d2:	e9 40 f5 ff ff       	jmp    80105817 <alltraps>

801062d7 <vector144>:
.globl vector144
vector144:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $144
801062d9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801062de:	e9 34 f5 ff ff       	jmp    80105817 <alltraps>

801062e3 <vector145>:
.globl vector145
vector145:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $145
801062e5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801062ea:	e9 28 f5 ff ff       	jmp    80105817 <alltraps>

801062ef <vector146>:
.globl vector146
vector146:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $146
801062f1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801062f6:	e9 1c f5 ff ff       	jmp    80105817 <alltraps>

801062fb <vector147>:
.globl vector147
vector147:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $147
801062fd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106302:	e9 10 f5 ff ff       	jmp    80105817 <alltraps>

80106307 <vector148>:
.globl vector148
vector148:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $148
80106309:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010630e:	e9 04 f5 ff ff       	jmp    80105817 <alltraps>

80106313 <vector149>:
.globl vector149
vector149:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $149
80106315:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010631a:	e9 f8 f4 ff ff       	jmp    80105817 <alltraps>

8010631f <vector150>:
.globl vector150
vector150:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $150
80106321:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106326:	e9 ec f4 ff ff       	jmp    80105817 <alltraps>

8010632b <vector151>:
.globl vector151
vector151:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $151
8010632d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106332:	e9 e0 f4 ff ff       	jmp    80105817 <alltraps>

80106337 <vector152>:
.globl vector152
vector152:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $152
80106339:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010633e:	e9 d4 f4 ff ff       	jmp    80105817 <alltraps>

80106343 <vector153>:
.globl vector153
vector153:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $153
80106345:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010634a:	e9 c8 f4 ff ff       	jmp    80105817 <alltraps>

8010634f <vector154>:
.globl vector154
vector154:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $154
80106351:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106356:	e9 bc f4 ff ff       	jmp    80105817 <alltraps>

8010635b <vector155>:
.globl vector155
vector155:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $155
8010635d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106362:	e9 b0 f4 ff ff       	jmp    80105817 <alltraps>

80106367 <vector156>:
.globl vector156
vector156:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $156
80106369:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010636e:	e9 a4 f4 ff ff       	jmp    80105817 <alltraps>

80106373 <vector157>:
.globl vector157
vector157:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $157
80106375:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010637a:	e9 98 f4 ff ff       	jmp    80105817 <alltraps>

8010637f <vector158>:
.globl vector158
vector158:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $158
80106381:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106386:	e9 8c f4 ff ff       	jmp    80105817 <alltraps>

8010638b <vector159>:
.globl vector159
vector159:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $159
8010638d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106392:	e9 80 f4 ff ff       	jmp    80105817 <alltraps>

80106397 <vector160>:
.globl vector160
vector160:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $160
80106399:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010639e:	e9 74 f4 ff ff       	jmp    80105817 <alltraps>

801063a3 <vector161>:
.globl vector161
vector161:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $161
801063a5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801063aa:	e9 68 f4 ff ff       	jmp    80105817 <alltraps>

801063af <vector162>:
.globl vector162
vector162:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $162
801063b1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801063b6:	e9 5c f4 ff ff       	jmp    80105817 <alltraps>

801063bb <vector163>:
.globl vector163
vector163:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $163
801063bd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801063c2:	e9 50 f4 ff ff       	jmp    80105817 <alltraps>

801063c7 <vector164>:
.globl vector164
vector164:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $164
801063c9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801063ce:	e9 44 f4 ff ff       	jmp    80105817 <alltraps>

801063d3 <vector165>:
.globl vector165
vector165:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $165
801063d5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801063da:	e9 38 f4 ff ff       	jmp    80105817 <alltraps>

801063df <vector166>:
.globl vector166
vector166:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $166
801063e1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801063e6:	e9 2c f4 ff ff       	jmp    80105817 <alltraps>

801063eb <vector167>:
.globl vector167
vector167:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $167
801063ed:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801063f2:	e9 20 f4 ff ff       	jmp    80105817 <alltraps>

801063f7 <vector168>:
.globl vector168
vector168:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $168
801063f9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801063fe:	e9 14 f4 ff ff       	jmp    80105817 <alltraps>

80106403 <vector169>:
.globl vector169
vector169:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $169
80106405:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010640a:	e9 08 f4 ff ff       	jmp    80105817 <alltraps>

8010640f <vector170>:
.globl vector170
vector170:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $170
80106411:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106416:	e9 fc f3 ff ff       	jmp    80105817 <alltraps>

8010641b <vector171>:
.globl vector171
vector171:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $171
8010641d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106422:	e9 f0 f3 ff ff       	jmp    80105817 <alltraps>

80106427 <vector172>:
.globl vector172
vector172:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $172
80106429:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010642e:	e9 e4 f3 ff ff       	jmp    80105817 <alltraps>

80106433 <vector173>:
.globl vector173
vector173:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $173
80106435:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010643a:	e9 d8 f3 ff ff       	jmp    80105817 <alltraps>

8010643f <vector174>:
.globl vector174
vector174:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $174
80106441:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106446:	e9 cc f3 ff ff       	jmp    80105817 <alltraps>

8010644b <vector175>:
.globl vector175
vector175:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $175
8010644d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106452:	e9 c0 f3 ff ff       	jmp    80105817 <alltraps>

80106457 <vector176>:
.globl vector176
vector176:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $176
80106459:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010645e:	e9 b4 f3 ff ff       	jmp    80105817 <alltraps>

80106463 <vector177>:
.globl vector177
vector177:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $177
80106465:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010646a:	e9 a8 f3 ff ff       	jmp    80105817 <alltraps>

8010646f <vector178>:
.globl vector178
vector178:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $178
80106471:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106476:	e9 9c f3 ff ff       	jmp    80105817 <alltraps>

8010647b <vector179>:
.globl vector179
vector179:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $179
8010647d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106482:	e9 90 f3 ff ff       	jmp    80105817 <alltraps>

80106487 <vector180>:
.globl vector180
vector180:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $180
80106489:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010648e:	e9 84 f3 ff ff       	jmp    80105817 <alltraps>

80106493 <vector181>:
.globl vector181
vector181:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $181
80106495:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010649a:	e9 78 f3 ff ff       	jmp    80105817 <alltraps>

8010649f <vector182>:
.globl vector182
vector182:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $182
801064a1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801064a6:	e9 6c f3 ff ff       	jmp    80105817 <alltraps>

801064ab <vector183>:
.globl vector183
vector183:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $183
801064ad:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801064b2:	e9 60 f3 ff ff       	jmp    80105817 <alltraps>

801064b7 <vector184>:
.globl vector184
vector184:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $184
801064b9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801064be:	e9 54 f3 ff ff       	jmp    80105817 <alltraps>

801064c3 <vector185>:
.globl vector185
vector185:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $185
801064c5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801064ca:	e9 48 f3 ff ff       	jmp    80105817 <alltraps>

801064cf <vector186>:
.globl vector186
vector186:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $186
801064d1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801064d6:	e9 3c f3 ff ff       	jmp    80105817 <alltraps>

801064db <vector187>:
.globl vector187
vector187:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $187
801064dd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801064e2:	e9 30 f3 ff ff       	jmp    80105817 <alltraps>

801064e7 <vector188>:
.globl vector188
vector188:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $188
801064e9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801064ee:	e9 24 f3 ff ff       	jmp    80105817 <alltraps>

801064f3 <vector189>:
.globl vector189
vector189:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $189
801064f5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801064fa:	e9 18 f3 ff ff       	jmp    80105817 <alltraps>

801064ff <vector190>:
.globl vector190
vector190:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $190
80106501:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106506:	e9 0c f3 ff ff       	jmp    80105817 <alltraps>

8010650b <vector191>:
.globl vector191
vector191:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $191
8010650d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106512:	e9 00 f3 ff ff       	jmp    80105817 <alltraps>

80106517 <vector192>:
.globl vector192
vector192:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $192
80106519:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010651e:	e9 f4 f2 ff ff       	jmp    80105817 <alltraps>

80106523 <vector193>:
.globl vector193
vector193:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $193
80106525:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010652a:	e9 e8 f2 ff ff       	jmp    80105817 <alltraps>

8010652f <vector194>:
.globl vector194
vector194:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $194
80106531:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106536:	e9 dc f2 ff ff       	jmp    80105817 <alltraps>

8010653b <vector195>:
.globl vector195
vector195:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $195
8010653d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106542:	e9 d0 f2 ff ff       	jmp    80105817 <alltraps>

80106547 <vector196>:
.globl vector196
vector196:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $196
80106549:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010654e:	e9 c4 f2 ff ff       	jmp    80105817 <alltraps>

80106553 <vector197>:
.globl vector197
vector197:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $197
80106555:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010655a:	e9 b8 f2 ff ff       	jmp    80105817 <alltraps>

8010655f <vector198>:
.globl vector198
vector198:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $198
80106561:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106566:	e9 ac f2 ff ff       	jmp    80105817 <alltraps>

8010656b <vector199>:
.globl vector199
vector199:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $199
8010656d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106572:	e9 a0 f2 ff ff       	jmp    80105817 <alltraps>

80106577 <vector200>:
.globl vector200
vector200:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $200
80106579:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010657e:	e9 94 f2 ff ff       	jmp    80105817 <alltraps>

80106583 <vector201>:
.globl vector201
vector201:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $201
80106585:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010658a:	e9 88 f2 ff ff       	jmp    80105817 <alltraps>

8010658f <vector202>:
.globl vector202
vector202:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $202
80106591:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106596:	e9 7c f2 ff ff       	jmp    80105817 <alltraps>

8010659b <vector203>:
.globl vector203
vector203:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $203
8010659d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801065a2:	e9 70 f2 ff ff       	jmp    80105817 <alltraps>

801065a7 <vector204>:
.globl vector204
vector204:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $204
801065a9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801065ae:	e9 64 f2 ff ff       	jmp    80105817 <alltraps>

801065b3 <vector205>:
.globl vector205
vector205:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $205
801065b5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801065ba:	e9 58 f2 ff ff       	jmp    80105817 <alltraps>

801065bf <vector206>:
.globl vector206
vector206:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $206
801065c1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801065c6:	e9 4c f2 ff ff       	jmp    80105817 <alltraps>

801065cb <vector207>:
.globl vector207
vector207:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $207
801065cd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801065d2:	e9 40 f2 ff ff       	jmp    80105817 <alltraps>

801065d7 <vector208>:
.globl vector208
vector208:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $208
801065d9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801065de:	e9 34 f2 ff ff       	jmp    80105817 <alltraps>

801065e3 <vector209>:
.globl vector209
vector209:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $209
801065e5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801065ea:	e9 28 f2 ff ff       	jmp    80105817 <alltraps>

801065ef <vector210>:
.globl vector210
vector210:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $210
801065f1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801065f6:	e9 1c f2 ff ff       	jmp    80105817 <alltraps>

801065fb <vector211>:
.globl vector211
vector211:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $211
801065fd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106602:	e9 10 f2 ff ff       	jmp    80105817 <alltraps>

80106607 <vector212>:
.globl vector212
vector212:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $212
80106609:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010660e:	e9 04 f2 ff ff       	jmp    80105817 <alltraps>

80106613 <vector213>:
.globl vector213
vector213:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $213
80106615:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010661a:	e9 f8 f1 ff ff       	jmp    80105817 <alltraps>

8010661f <vector214>:
.globl vector214
vector214:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $214
80106621:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106626:	e9 ec f1 ff ff       	jmp    80105817 <alltraps>

8010662b <vector215>:
.globl vector215
vector215:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $215
8010662d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106632:	e9 e0 f1 ff ff       	jmp    80105817 <alltraps>

80106637 <vector216>:
.globl vector216
vector216:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $216
80106639:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010663e:	e9 d4 f1 ff ff       	jmp    80105817 <alltraps>

80106643 <vector217>:
.globl vector217
vector217:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $217
80106645:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010664a:	e9 c8 f1 ff ff       	jmp    80105817 <alltraps>

8010664f <vector218>:
.globl vector218
vector218:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $218
80106651:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106656:	e9 bc f1 ff ff       	jmp    80105817 <alltraps>

8010665b <vector219>:
.globl vector219
vector219:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $219
8010665d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106662:	e9 b0 f1 ff ff       	jmp    80105817 <alltraps>

80106667 <vector220>:
.globl vector220
vector220:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $220
80106669:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010666e:	e9 a4 f1 ff ff       	jmp    80105817 <alltraps>

80106673 <vector221>:
.globl vector221
vector221:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $221
80106675:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010667a:	e9 98 f1 ff ff       	jmp    80105817 <alltraps>

8010667f <vector222>:
.globl vector222
vector222:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $222
80106681:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106686:	e9 8c f1 ff ff       	jmp    80105817 <alltraps>

8010668b <vector223>:
.globl vector223
vector223:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $223
8010668d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106692:	e9 80 f1 ff ff       	jmp    80105817 <alltraps>

80106697 <vector224>:
.globl vector224
vector224:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $224
80106699:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010669e:	e9 74 f1 ff ff       	jmp    80105817 <alltraps>

801066a3 <vector225>:
.globl vector225
vector225:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $225
801066a5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801066aa:	e9 68 f1 ff ff       	jmp    80105817 <alltraps>

801066af <vector226>:
.globl vector226
vector226:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $226
801066b1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801066b6:	e9 5c f1 ff ff       	jmp    80105817 <alltraps>

801066bb <vector227>:
.globl vector227
vector227:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $227
801066bd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801066c2:	e9 50 f1 ff ff       	jmp    80105817 <alltraps>

801066c7 <vector228>:
.globl vector228
vector228:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $228
801066c9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801066ce:	e9 44 f1 ff ff       	jmp    80105817 <alltraps>

801066d3 <vector229>:
.globl vector229
vector229:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $229
801066d5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801066da:	e9 38 f1 ff ff       	jmp    80105817 <alltraps>

801066df <vector230>:
.globl vector230
vector230:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $230
801066e1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801066e6:	e9 2c f1 ff ff       	jmp    80105817 <alltraps>

801066eb <vector231>:
.globl vector231
vector231:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $231
801066ed:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801066f2:	e9 20 f1 ff ff       	jmp    80105817 <alltraps>

801066f7 <vector232>:
.globl vector232
vector232:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $232
801066f9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801066fe:	e9 14 f1 ff ff       	jmp    80105817 <alltraps>

80106703 <vector233>:
.globl vector233
vector233:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $233
80106705:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010670a:	e9 08 f1 ff ff       	jmp    80105817 <alltraps>

8010670f <vector234>:
.globl vector234
vector234:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $234
80106711:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106716:	e9 fc f0 ff ff       	jmp    80105817 <alltraps>

8010671b <vector235>:
.globl vector235
vector235:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $235
8010671d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106722:	e9 f0 f0 ff ff       	jmp    80105817 <alltraps>

80106727 <vector236>:
.globl vector236
vector236:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $236
80106729:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010672e:	e9 e4 f0 ff ff       	jmp    80105817 <alltraps>

80106733 <vector237>:
.globl vector237
vector237:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $237
80106735:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010673a:	e9 d8 f0 ff ff       	jmp    80105817 <alltraps>

8010673f <vector238>:
.globl vector238
vector238:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $238
80106741:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106746:	e9 cc f0 ff ff       	jmp    80105817 <alltraps>

8010674b <vector239>:
.globl vector239
vector239:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $239
8010674d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106752:	e9 c0 f0 ff ff       	jmp    80105817 <alltraps>

80106757 <vector240>:
.globl vector240
vector240:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $240
80106759:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010675e:	e9 b4 f0 ff ff       	jmp    80105817 <alltraps>

80106763 <vector241>:
.globl vector241
vector241:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $241
80106765:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010676a:	e9 a8 f0 ff ff       	jmp    80105817 <alltraps>

8010676f <vector242>:
.globl vector242
vector242:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $242
80106771:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106776:	e9 9c f0 ff ff       	jmp    80105817 <alltraps>

8010677b <vector243>:
.globl vector243
vector243:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $243
8010677d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106782:	e9 90 f0 ff ff       	jmp    80105817 <alltraps>

80106787 <vector244>:
.globl vector244
vector244:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $244
80106789:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010678e:	e9 84 f0 ff ff       	jmp    80105817 <alltraps>

80106793 <vector245>:
.globl vector245
vector245:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $245
80106795:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010679a:	e9 78 f0 ff ff       	jmp    80105817 <alltraps>

8010679f <vector246>:
.globl vector246
vector246:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $246
801067a1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801067a6:	e9 6c f0 ff ff       	jmp    80105817 <alltraps>

801067ab <vector247>:
.globl vector247
vector247:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $247
801067ad:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801067b2:	e9 60 f0 ff ff       	jmp    80105817 <alltraps>

801067b7 <vector248>:
.globl vector248
vector248:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $248
801067b9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801067be:	e9 54 f0 ff ff       	jmp    80105817 <alltraps>

801067c3 <vector249>:
.globl vector249
vector249:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $249
801067c5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801067ca:	e9 48 f0 ff ff       	jmp    80105817 <alltraps>

801067cf <vector250>:
.globl vector250
vector250:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $250
801067d1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801067d6:	e9 3c f0 ff ff       	jmp    80105817 <alltraps>

801067db <vector251>:
.globl vector251
vector251:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $251
801067dd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801067e2:	e9 30 f0 ff ff       	jmp    80105817 <alltraps>

801067e7 <vector252>:
.globl vector252
vector252:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $252
801067e9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801067ee:	e9 24 f0 ff ff       	jmp    80105817 <alltraps>

801067f3 <vector253>:
.globl vector253
vector253:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $253
801067f5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801067fa:	e9 18 f0 ff ff       	jmp    80105817 <alltraps>

801067ff <vector254>:
.globl vector254
vector254:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $254
80106801:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106806:	e9 0c f0 ff ff       	jmp    80105817 <alltraps>

8010680b <vector255>:
.globl vector255
vector255:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $255
8010680d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106812:	e9 00 f0 ff ff       	jmp    80105817 <alltraps>
80106817:	66 90                	xchg   %ax,%ax
80106819:	66 90                	xchg   %ax,%ax
8010681b:	66 90                	xchg   %ax,%ax
8010681d:	66 90                	xchg   %ax,%ax
8010681f:	90                   	nop

80106820 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106820:	55                   	push   %ebp
80106821:	89 e5                	mov    %esp,%ebp
80106823:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106826:	e8 75 d0 ff ff       	call   801038a0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010682b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106831:	31 c9                	xor    %ecx,%ecx
80106833:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106838:	66 89 90 f8 27 11 80 	mov    %dx,-0x7feed808(%eax)
8010683f:	66 89 88 fa 27 11 80 	mov    %cx,-0x7feed806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106846:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010684b:	31 c9                	xor    %ecx,%ecx
8010684d:	66 89 90 00 28 11 80 	mov    %dx,-0x7feed800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106854:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106859:	66 89 88 02 28 11 80 	mov    %cx,-0x7feed7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106860:	31 c9                	xor    %ecx,%ecx
80106862:	66 89 90 08 28 11 80 	mov    %dx,-0x7feed7f8(%eax)
80106869:	66 89 88 0a 28 11 80 	mov    %cx,-0x7feed7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106870:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106875:	31 c9                	xor    %ecx,%ecx
80106877:	66 89 90 10 28 11 80 	mov    %dx,-0x7feed7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010687e:	c6 80 fc 27 11 80 00 	movb   $0x0,-0x7feed804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106885:	ba 2f 00 00 00       	mov    $0x2f,%edx
8010688a:	c6 80 fd 27 11 80 9a 	movb   $0x9a,-0x7feed803(%eax)
80106891:	c6 80 fe 27 11 80 cf 	movb   $0xcf,-0x7feed802(%eax)
80106898:	c6 80 ff 27 11 80 00 	movb   $0x0,-0x7feed801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010689f:	c6 80 04 28 11 80 00 	movb   $0x0,-0x7feed7fc(%eax)
801068a6:	c6 80 05 28 11 80 92 	movb   $0x92,-0x7feed7fb(%eax)
801068ad:	c6 80 06 28 11 80 cf 	movb   $0xcf,-0x7feed7fa(%eax)
801068b4:	c6 80 07 28 11 80 00 	movb   $0x0,-0x7feed7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801068bb:	c6 80 0c 28 11 80 00 	movb   $0x0,-0x7feed7f4(%eax)
801068c2:	c6 80 0d 28 11 80 fa 	movb   $0xfa,-0x7feed7f3(%eax)
801068c9:	c6 80 0e 28 11 80 cf 	movb   $0xcf,-0x7feed7f2(%eax)
801068d0:	c6 80 0f 28 11 80 00 	movb   $0x0,-0x7feed7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801068d7:	66 89 88 12 28 11 80 	mov    %cx,-0x7feed7ee(%eax)
801068de:	c6 80 14 28 11 80 00 	movb   $0x0,-0x7feed7ec(%eax)
801068e5:	c6 80 15 28 11 80 f2 	movb   $0xf2,-0x7feed7eb(%eax)
801068ec:	c6 80 16 28 11 80 cf 	movb   $0xcf,-0x7feed7ea(%eax)
801068f3:	c6 80 17 28 11 80 00 	movb   $0x0,-0x7feed7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801068fa:	05 f0 27 11 80       	add    $0x801127f0,%eax
801068ff:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106903:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106907:	c1 e8 10             	shr    $0x10,%eax
8010690a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010690e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106911:	0f 01 10             	lgdtl  (%eax)
}
80106914:	c9                   	leave  
80106915:	c3                   	ret    
80106916:	8d 76 00             	lea    0x0(%esi),%esi
80106919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106920 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106920:	55                   	push   %ebp
80106921:	89 e5                	mov    %esp,%ebp
80106923:	57                   	push   %edi
80106924:	56                   	push   %esi
80106925:	53                   	push   %ebx
80106926:	83 ec 0c             	sub    $0xc,%esp
80106929:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010692c:	8b 55 08             	mov    0x8(%ebp),%edx
8010692f:	89 df                	mov    %ebx,%edi
80106931:	c1 ef 16             	shr    $0x16,%edi
80106934:	8d 3c ba             	lea    (%edx,%edi,4),%edi
  if(*pde & PTE_P){
80106937:	8b 07                	mov    (%edi),%eax
80106939:	a8 01                	test   $0x1,%al
8010693b:	74 23                	je     80106960 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010693d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106942:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106948:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010694b:	c1 eb 0a             	shr    $0xa,%ebx
8010694e:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
80106954:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106957:	5b                   	pop    %ebx
80106958:	5e                   	pop    %esi
80106959:	5f                   	pop    %edi
8010695a:	5d                   	pop    %ebp
8010695b:	c3                   	ret    
8010695c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106960:	8b 45 10             	mov    0x10(%ebp),%eax
80106963:	85 c0                	test   %eax,%eax
80106965:	74 31                	je     80106998 <walkpgdir+0x78>
80106967:	e8 24 bc ff ff       	call   80102590 <kalloc>
8010696c:	85 c0                	test   %eax,%eax
8010696e:	89 c6                	mov    %eax,%esi
80106970:	74 26                	je     80106998 <walkpgdir+0x78>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80106972:	83 ec 04             	sub    $0x4,%esp
80106975:	68 00 10 00 00       	push   $0x1000
8010697a:	6a 00                	push   $0x0
8010697c:	50                   	push   %eax
8010697d:	e8 fe db ff ff       	call   80104580 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106982:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106988:	83 c4 10             	add    $0x10,%esp
8010698b:	83 c8 07             	or     $0x7,%eax
8010698e:	89 07                	mov    %eax,(%edi)
80106990:	eb b6                	jmp    80106948 <walkpgdir+0x28>
80106992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  return &pgtab[PTX(va)];
}
80106998:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
8010699b:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
8010699d:	5b                   	pop    %ebx
8010699e:	5e                   	pop    %esi
8010699f:	5f                   	pop    %edi
801069a0:	5d                   	pop    %ebp
801069a1:	c3                   	ret    
801069a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069b0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069b0:	55                   	push   %ebp
801069b1:	89 e5                	mov    %esp,%ebp
801069b3:	57                   	push   %edi
801069b4:	56                   	push   %esi
801069b5:	53                   	push   %ebx
801069b6:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801069b8:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069be:	89 c6                	mov    %eax,%esi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801069c0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069c6:	83 ec 1c             	sub    $0x1c,%esp
801069c9:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801069cc:	39 da                	cmp    %ebx,%edx
801069ce:	73 6a                	jae    80106a3a <deallocuvm.part.0+0x8a>
801069d0:	89 d7                	mov    %edx,%edi
801069d2:	eb 3b                	jmp    80106a0f <deallocuvm.part.0+0x5f>
801069d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801069d8:	8b 08                	mov    (%eax),%ecx
801069da:	f6 c1 01             	test   $0x1,%cl
801069dd:	74 26                	je     80106a05 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801069df:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
801069e5:	74 5e                	je     80106a45 <deallocuvm.part.0+0x95>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801069e7:	83 ec 0c             	sub    $0xc,%esp
801069ea:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
801069f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801069f3:	51                   	push   %ecx
801069f4:	e8 e7 b9 ff ff       	call   801023e0 <kfree>
      *pte = 0;
801069f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801069fc:	83 c4 10             	add    $0x10,%esp
801069ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106a05:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106a0b:	39 df                	cmp    %ebx,%edi
80106a0d:	73 2b                	jae    80106a3a <deallocuvm.part.0+0x8a>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106a0f:	83 ec 04             	sub    $0x4,%esp
80106a12:	6a 00                	push   $0x0
80106a14:	57                   	push   %edi
80106a15:	56                   	push   %esi
80106a16:	e8 05 ff ff ff       	call   80106920 <walkpgdir>
    if(!pte)
80106a1b:	83 c4 10             	add    $0x10,%esp
80106a1e:	85 c0                	test   %eax,%eax
80106a20:	75 b6                	jne    801069d8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106a22:	89 fa                	mov    %edi,%edx
80106a24:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106a2a:	8d ba 00 f0 3f 00    	lea    0x3ff000(%edx),%edi

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106a30:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106a36:	39 df                	cmp    %ebx,%edi
80106a38:	72 d5                	jb     80106a0f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106a3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a40:	5b                   	pop    %ebx
80106a41:	5e                   	pop    %esi
80106a42:	5f                   	pop    %edi
80106a43:	5d                   	pop    %ebp
80106a44:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
80106a45:	83 ec 0c             	sub    $0xc,%esp
80106a48:	68 46 74 10 80       	push   $0x80107446
80106a4d:	e8 1e 99 ff ff       	call   80100370 <panic>
80106a52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a60 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106a60:	55                   	push   %ebp
80106a61:	89 e5                	mov    %esp,%ebp
80106a63:	57                   	push   %edi
80106a64:	56                   	push   %esi
80106a65:	53                   	push   %ebx
80106a66:	83 ec 1c             	sub    $0x1c,%esp
80106a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a6c:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106a6f:	8b 75 14             	mov    0x14(%ebp),%esi
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106a72:	89 c7                	mov    %eax,%edi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a74:	8d 44 08 ff          	lea    -0x1(%eax,%ecx,1),%eax
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106a78:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a7e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a83:	29 fe                	sub    %edi,%esi
80106a85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106a88:	8b 45 18             	mov    0x18(%ebp),%eax
80106a8b:	83 c8 01             	or     $0x1,%eax
80106a8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106a91:	89 f0                	mov    %esi,%eax
80106a93:	89 fe                	mov    %edi,%esi
80106a95:	89 c7                	mov    %eax,%edi
80106a97:	eb 1c                	jmp    80106ab5 <mappages+0x55>
80106a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106aa0:	f6 00 01             	testb  $0x1,(%eax)
80106aa3:	75 45                	jne    80106aea <mappages+0x8a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106aa5:	0b 5d e0             	or     -0x20(%ebp),%ebx
    if(a == last)
80106aa8:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106aab:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106aad:	74 31                	je     80106ae0 <mappages+0x80>
      break;
    a += PGSIZE;
80106aaf:	81 c6 00 10 00 00    	add    $0x1000,%esi
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106ab5:	83 ec 04             	sub    $0x4,%esp
80106ab8:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
80106abb:	6a 01                	push   $0x1
80106abd:	56                   	push   %esi
80106abe:	ff 75 08             	pushl  0x8(%ebp)
80106ac1:	e8 5a fe ff ff       	call   80106920 <walkpgdir>
80106ac6:	83 c4 10             	add    $0x10,%esp
80106ac9:	85 c0                	test   %eax,%eax
80106acb:	75 d3                	jne    80106aa0 <mappages+0x40>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106acd:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
80106ad0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106ad5:	5b                   	pop    %ebx
80106ad6:	5e                   	pop    %esi
80106ad7:	5f                   	pop    %edi
80106ad8:	5d                   	pop    %ebp
80106ad9:	c3                   	ret    
80106ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ae0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106ae3:	31 c0                	xor    %eax,%eax
}
80106ae5:	5b                   	pop    %ebx
80106ae6:	5e                   	pop    %esi
80106ae7:	5f                   	pop    %edi
80106ae8:	5d                   	pop    %ebp
80106ae9:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106aea:	83 ec 0c             	sub    $0xc,%esp
80106aed:	68 c8 7a 10 80       	push   $0x80107ac8
80106af2:	e8 79 98 ff ff       	call   80100370 <panic>
80106af7:	89 f6                	mov    %esi,%esi
80106af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b00 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b00:	a1 a4 57 11 80       	mov    0x801157a4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106b05:	55                   	push   %ebp
80106b06:	89 e5                	mov    %esp,%ebp
80106b08:	05 00 00 00 80       	add    $0x80000000,%eax
80106b0d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80106b10:	5d                   	pop    %ebp
80106b11:	c3                   	ret    
80106b12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b20 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106b20:	55                   	push   %ebp
80106b21:	89 e5                	mov    %esp,%ebp
80106b23:	57                   	push   %edi
80106b24:	56                   	push   %esi
80106b25:	53                   	push   %ebx
80106b26:	83 ec 1c             	sub    $0x1c,%esp
80106b29:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106b2c:	85 f6                	test   %esi,%esi
80106b2e:	0f 84 cd 00 00 00    	je     80106c01 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106b34:	8b 46 08             	mov    0x8(%esi),%eax
80106b37:	85 c0                	test   %eax,%eax
80106b39:	0f 84 dc 00 00 00    	je     80106c1b <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106b3f:	8b 7e 04             	mov    0x4(%esi),%edi
80106b42:	85 ff                	test   %edi,%edi
80106b44:	0f 84 c4 00 00 00    	je     80106c0e <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
80106b4a:	e8 51 d8 ff ff       	call   801043a0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b4f:	e8 cc cc ff ff       	call   80103820 <mycpu>
80106b54:	89 c3                	mov    %eax,%ebx
80106b56:	e8 c5 cc ff ff       	call   80103820 <mycpu>
80106b5b:	89 c7                	mov    %eax,%edi
80106b5d:	e8 be cc ff ff       	call   80103820 <mycpu>
80106b62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b65:	83 c7 08             	add    $0x8,%edi
80106b68:	e8 b3 cc ff ff       	call   80103820 <mycpu>
80106b6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b70:	83 c0 08             	add    $0x8,%eax
80106b73:	ba 67 00 00 00       	mov    $0x67,%edx
80106b78:	c1 e8 18             	shr    $0x18,%eax
80106b7b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106b82:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106b89:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106b90:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106b97:	83 c1 08             	add    $0x8,%ecx
80106b9a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106ba0:	c1 e9 10             	shr    $0x10,%ecx
80106ba3:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ba9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106bae:	e8 6d cc ff ff       	call   80103820 <mycpu>
80106bb3:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106bba:	e8 61 cc ff ff       	call   80103820 <mycpu>
80106bbf:	b9 10 00 00 00       	mov    $0x10,%ecx
80106bc4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106bc8:	e8 53 cc ff ff       	call   80103820 <mycpu>
80106bcd:	8b 56 08             	mov    0x8(%esi),%edx
80106bd0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106bd6:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106bd9:	e8 42 cc ff ff       	call   80103820 <mycpu>
80106bde:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106be2:	b8 28 00 00 00       	mov    $0x28,%eax
80106be7:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106bea:	8b 46 04             	mov    0x4(%esi),%eax
80106bed:	05 00 00 00 80       	add    $0x80000000,%eax
80106bf2:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80106bf5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bf8:	5b                   	pop    %ebx
80106bf9:	5e                   	pop    %esi
80106bfa:	5f                   	pop    %edi
80106bfb:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106bfc:	e9 df d7 ff ff       	jmp    801043e0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106c01:	83 ec 0c             	sub    $0xc,%esp
80106c04:	68 ce 7a 10 80       	push   $0x80107ace
80106c09:	e8 62 97 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106c0e:	83 ec 0c             	sub    $0xc,%esp
80106c11:	68 f9 7a 10 80       	push   $0x80107af9
80106c16:	e8 55 97 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80106c1b:	83 ec 0c             	sub    $0xc,%esp
80106c1e:	68 e4 7a 10 80       	push   $0x80107ae4
80106c23:	e8 48 97 ff ff       	call   80100370 <panic>
80106c28:	90                   	nop
80106c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c30 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106c30:	55                   	push   %ebp
80106c31:	89 e5                	mov    %esp,%ebp
80106c33:	57                   	push   %edi
80106c34:	56                   	push   %esi
80106c35:	53                   	push   %ebx
80106c36:	83 ec 1c             	sub    $0x1c,%esp
80106c39:	8b 75 10             	mov    0x10(%ebp),%esi
80106c3c:	8b 55 08             	mov    0x8(%ebp),%edx
80106c3f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106c42:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106c48:	77 50                	ja     80106c9a <inituvm+0x6a>
80106c4a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    panic("inituvm: more than a page");
  mem = kalloc();
80106c4d:	e8 3e b9 ff ff       	call   80102590 <kalloc>
  memset(mem, 0, PGSIZE);
80106c52:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106c55:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106c57:	68 00 10 00 00       	push   $0x1000
80106c5c:	6a 00                	push   $0x0
80106c5e:	50                   	push   %eax
80106c5f:	e8 1c d9 ff ff       	call   80104580 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106c64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106c67:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c6d:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106c74:	50                   	push   %eax
80106c75:	68 00 10 00 00       	push   $0x1000
80106c7a:	6a 00                	push   $0x0
80106c7c:	52                   	push   %edx
80106c7d:	e8 de fd ff ff       	call   80106a60 <mappages>
  memmove(mem, init, sz);
80106c82:	89 75 10             	mov    %esi,0x10(%ebp)
80106c85:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106c88:	83 c4 20             	add    $0x20,%esp
80106c8b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106c8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c91:	5b                   	pop    %ebx
80106c92:	5e                   	pop    %esi
80106c93:	5f                   	pop    %edi
80106c94:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106c95:	e9 96 d9 ff ff       	jmp    80104630 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106c9a:	83 ec 0c             	sub    $0xc,%esp
80106c9d:	68 0d 7b 10 80       	push   $0x80107b0d
80106ca2:	e8 c9 96 ff ff       	call   80100370 <panic>
80106ca7:	89 f6                	mov    %esi,%esi
80106ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cb0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106cb0:	55                   	push   %ebp
80106cb1:	89 e5                	mov    %esp,%ebp
80106cb3:	57                   	push   %edi
80106cb4:	56                   	push   %esi
80106cb5:	53                   	push   %ebx
80106cb6:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106cb9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106cc0:	0f 85 99 00 00 00    	jne    80106d5f <loaduvm+0xaf>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106cc6:	8b 5d 18             	mov    0x18(%ebp),%ebx
80106cc9:	31 ff                	xor    %edi,%edi
80106ccb:	85 db                	test   %ebx,%ebx
80106ccd:	75 1a                	jne    80106ce9 <loaduvm+0x39>
80106ccf:	eb 77                	jmp    80106d48 <loaduvm+0x98>
80106cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cd8:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106cde:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106ce4:	39 7d 18             	cmp    %edi,0x18(%ebp)
80106ce7:	76 5f                	jbe    80106d48 <loaduvm+0x98>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ce9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cec:	83 ec 04             	sub    $0x4,%esp
80106cef:	6a 00                	push   $0x0
80106cf1:	01 f8                	add    %edi,%eax
80106cf3:	50                   	push   %eax
80106cf4:	ff 75 08             	pushl  0x8(%ebp)
80106cf7:	e8 24 fc ff ff       	call   80106920 <walkpgdir>
80106cfc:	83 c4 10             	add    $0x10,%esp
80106cff:	85 c0                	test   %eax,%eax
80106d01:	74 4f                	je     80106d52 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106d03:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d05:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80106d08:	be 00 10 00 00       	mov    $0x1000,%esi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106d0d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106d12:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106d18:	0f 46 f3             	cmovbe %ebx,%esi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d1b:	01 f9                	add    %edi,%ecx
80106d1d:	05 00 00 00 80       	add    $0x80000000,%eax
80106d22:	56                   	push   %esi
80106d23:	51                   	push   %ecx
80106d24:	50                   	push   %eax
80106d25:	ff 75 10             	pushl  0x10(%ebp)
80106d28:	e8 23 ad ff ff       	call   80101a50 <readi>
80106d2d:	83 c4 10             	add    $0x10,%esp
80106d30:	39 c6                	cmp    %eax,%esi
80106d32:	74 a4                	je     80106cd8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106d34:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106d37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106d3c:	5b                   	pop    %ebx
80106d3d:	5e                   	pop    %esi
80106d3e:	5f                   	pop    %edi
80106d3f:	5d                   	pop    %ebp
80106d40:	c3                   	ret    
80106d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d48:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106d4b:	31 c0                	xor    %eax,%eax
}
80106d4d:	5b                   	pop    %ebx
80106d4e:	5e                   	pop    %esi
80106d4f:	5f                   	pop    %edi
80106d50:	5d                   	pop    %ebp
80106d51:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106d52:	83 ec 0c             	sub    $0xc,%esp
80106d55:	68 27 7b 10 80       	push   $0x80107b27
80106d5a:	e8 11 96 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106d5f:	83 ec 0c             	sub    $0xc,%esp
80106d62:	68 94 7b 10 80       	push   $0x80107b94
80106d67:	e8 04 96 ff ff       	call   80100370 <panic>
80106d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d70 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	57                   	push   %edi
80106d74:	56                   	push   %esi
80106d75:	53                   	push   %ebx
80106d76:	83 ec 0c             	sub    $0xc,%esp
80106d79:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106d7c:	85 ff                	test   %edi,%edi
80106d7e:	0f 88 ca 00 00 00    	js     80106e4e <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80106d84:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106d8a:	0f 82 84 00 00 00    	jb     80106e14 <allocuvm+0xa4>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106d90:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106d96:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106d9c:	39 df                	cmp    %ebx,%edi
80106d9e:	77 45                	ja     80106de5 <allocuvm+0x75>
80106da0:	e9 bb 00 00 00       	jmp    80106e60 <allocuvm+0xf0>
80106da5:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106da8:	83 ec 04             	sub    $0x4,%esp
80106dab:	68 00 10 00 00       	push   $0x1000
80106db0:	6a 00                	push   $0x0
80106db2:	50                   	push   %eax
80106db3:	e8 c8 d7 ff ff       	call   80104580 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106db8:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106dbe:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106dc5:	50                   	push   %eax
80106dc6:	68 00 10 00 00       	push   $0x1000
80106dcb:	53                   	push   %ebx
80106dcc:	ff 75 08             	pushl  0x8(%ebp)
80106dcf:	e8 8c fc ff ff       	call   80106a60 <mappages>
80106dd4:	83 c4 20             	add    $0x20,%esp
80106dd7:	85 c0                	test   %eax,%eax
80106dd9:	78 45                	js     80106e20 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106ddb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106de1:	39 df                	cmp    %ebx,%edi
80106de3:	76 7b                	jbe    80106e60 <allocuvm+0xf0>
    mem = kalloc();
80106de5:	e8 a6 b7 ff ff       	call   80102590 <kalloc>
    if(mem == 0){
80106dea:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106dec:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106dee:	75 b8                	jne    80106da8 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106df0:	83 ec 0c             	sub    $0xc,%esp
80106df3:	68 b2 79 10 80       	push   $0x801079b2
80106df8:	e8 63 98 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106dfd:	83 c4 10             	add    $0x10,%esp
80106e00:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106e03:	76 49                	jbe    80106e4e <allocuvm+0xde>
80106e05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e08:	8b 45 08             	mov    0x8(%ebp),%eax
80106e0b:	89 fa                	mov    %edi,%edx
80106e0d:	e8 9e fb ff ff       	call   801069b0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106e12:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106e14:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e17:	5b                   	pop    %ebx
80106e18:	5e                   	pop    %esi
80106e19:	5f                   	pop    %edi
80106e1a:	5d                   	pop    %ebp
80106e1b:	c3                   	ret    
80106e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106e20:	83 ec 0c             	sub    $0xc,%esp
80106e23:	68 ca 79 10 80       	push   $0x801079ca
80106e28:	e8 33 98 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106e2d:	83 c4 10             	add    $0x10,%esp
80106e30:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106e33:	76 0d                	jbe    80106e42 <allocuvm+0xd2>
80106e35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e38:	8b 45 08             	mov    0x8(%ebp),%eax
80106e3b:	89 fa                	mov    %edi,%edx
80106e3d:	e8 6e fb ff ff       	call   801069b0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106e42:	83 ec 0c             	sub    $0xc,%esp
80106e45:	56                   	push   %esi
80106e46:	e8 95 b5 ff ff       	call   801023e0 <kfree>
      return 0;
80106e4b:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
80106e4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106e51:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106e53:	5b                   	pop    %ebx
80106e54:	5e                   	pop    %esi
80106e55:	5f                   	pop    %edi
80106e56:	5d                   	pop    %ebp
80106e57:	c3                   	ret    
80106e58:	90                   	nop
80106e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106e63:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106e65:	5b                   	pop    %ebx
80106e66:	5e                   	pop    %esi
80106e67:	5f                   	pop    %edi
80106e68:	5d                   	pop    %ebp
80106e69:	c3                   	ret    
80106e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e70 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e76:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106e79:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106e7c:	39 d1                	cmp    %edx,%ecx
80106e7e:	73 10                	jae    80106e90 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106e80:	5d                   	pop    %ebp
80106e81:	e9 2a fb ff ff       	jmp    801069b0 <deallocuvm.part.0>
80106e86:	8d 76 00             	lea    0x0(%esi),%esi
80106e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106e90:	89 d0                	mov    %edx,%eax
80106e92:	5d                   	pop    %ebp
80106e93:	c3                   	ret    
80106e94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ea0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	57                   	push   %edi
80106ea4:	56                   	push   %esi
80106ea5:	53                   	push   %ebx
80106ea6:	83 ec 0c             	sub    $0xc,%esp
80106ea9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106eac:	85 f6                	test   %esi,%esi
80106eae:	74 59                	je     80106f09 <freevm+0x69>
80106eb0:	31 c9                	xor    %ecx,%ecx
80106eb2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106eb7:	89 f0                	mov    %esi,%eax
80106eb9:	e8 f2 fa ff ff       	call   801069b0 <deallocuvm.part.0>
80106ebe:	89 f3                	mov    %esi,%ebx
80106ec0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106ec6:	eb 0f                	jmp    80106ed7 <freevm+0x37>
80106ec8:	90                   	nop
80106ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ed0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ed3:	39 fb                	cmp    %edi,%ebx
80106ed5:	74 23                	je     80106efa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106ed7:	8b 03                	mov    (%ebx),%eax
80106ed9:	a8 01                	test   $0x1,%al
80106edb:	74 f3                	je     80106ed0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106edd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ee2:	83 ec 0c             	sub    $0xc,%esp
80106ee5:	83 c3 04             	add    $0x4,%ebx
80106ee8:	05 00 00 00 80       	add    $0x80000000,%eax
80106eed:	50                   	push   %eax
80106eee:	e8 ed b4 ff ff       	call   801023e0 <kfree>
80106ef3:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ef6:	39 fb                	cmp    %edi,%ebx
80106ef8:	75 dd                	jne    80106ed7 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106efa:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106efd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f00:	5b                   	pop    %ebx
80106f01:	5e                   	pop    %esi
80106f02:	5f                   	pop    %edi
80106f03:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106f04:	e9 d7 b4 ff ff       	jmp    801023e0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106f09:	83 ec 0c             	sub    $0xc,%esp
80106f0c:	68 45 7b 10 80       	push   $0x80107b45
80106f11:	e8 5a 94 ff ff       	call   80100370 <panic>
80106f16:	8d 76 00             	lea    0x0(%esi),%esi
80106f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f20 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	56                   	push   %esi
80106f24:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106f25:	e8 66 b6 ff ff       	call   80102590 <kalloc>
80106f2a:	85 c0                	test   %eax,%eax
80106f2c:	74 6a                	je     80106f98 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106f2e:	83 ec 04             	sub    $0x4,%esp
80106f31:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f33:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106f38:	68 00 10 00 00       	push   $0x1000
80106f3d:	6a 00                	push   $0x0
80106f3f:	50                   	push   %eax
80106f40:	e8 3b d6 ff ff       	call   80104580 <memset>
80106f45:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106f48:	8b 43 04             	mov    0x4(%ebx),%eax
80106f4b:	8b 53 08             	mov    0x8(%ebx),%edx
80106f4e:	83 ec 0c             	sub    $0xc,%esp
80106f51:	ff 73 0c             	pushl  0xc(%ebx)
80106f54:	29 c2                	sub    %eax,%edx
80106f56:	50                   	push   %eax
80106f57:	52                   	push   %edx
80106f58:	ff 33                	pushl  (%ebx)
80106f5a:	56                   	push   %esi
80106f5b:	e8 00 fb ff ff       	call   80106a60 <mappages>
80106f60:	83 c4 20             	add    $0x20,%esp
80106f63:	85 c0                	test   %eax,%eax
80106f65:	78 19                	js     80106f80 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f67:	83 c3 10             	add    $0x10,%ebx
80106f6a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106f70:	75 d6                	jne    80106f48 <setupkvm+0x28>
80106f72:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106f74:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f77:	5b                   	pop    %ebx
80106f78:	5e                   	pop    %esi
80106f79:	5d                   	pop    %ebp
80106f7a:	c3                   	ret    
80106f7b:	90                   	nop
80106f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106f80:	83 ec 0c             	sub    $0xc,%esp
80106f83:	56                   	push   %esi
80106f84:	e8 17 ff ff ff       	call   80106ea0 <freevm>
      return 0;
80106f89:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
80106f8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106f8f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80106f91:	5b                   	pop    %ebx
80106f92:	5e                   	pop    %esi
80106f93:	5d                   	pop    %ebp
80106f94:	c3                   	ret    
80106f95:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106f98:	31 c0                	xor    %eax,%eax
80106f9a:	eb d8                	jmp    80106f74 <setupkvm+0x54>
80106f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106fa0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106fa6:	e8 75 ff ff ff       	call   80106f20 <setupkvm>
80106fab:	a3 a4 57 11 80       	mov    %eax,0x801157a4
80106fb0:	05 00 00 00 80       	add    $0x80000000,%eax
80106fb5:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80106fb8:	c9                   	leave  
80106fb9:	c3                   	ret    
80106fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106fc0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106fc6:	6a 00                	push   $0x0
80106fc8:	ff 75 0c             	pushl  0xc(%ebp)
80106fcb:	ff 75 08             	pushl  0x8(%ebp)
80106fce:	e8 4d f9 ff ff       	call   80106920 <walkpgdir>
  if(pte == 0)
80106fd3:	83 c4 10             	add    $0x10,%esp
80106fd6:	85 c0                	test   %eax,%eax
80106fd8:	74 05                	je     80106fdf <clearpteu+0x1f>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106fda:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106fdd:	c9                   	leave  
80106fde:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106fdf:	83 ec 0c             	sub    $0xc,%esp
80106fe2:	68 56 7b 10 80       	push   $0x80107b56
80106fe7:	e8 84 93 ff ff       	call   80100370 <panic>
80106fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ff0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	57                   	push   %edi
80106ff4:	56                   	push   %esi
80106ff5:	53                   	push   %ebx
80106ff6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106ff9:	e8 22 ff ff ff       	call   80106f20 <setupkvm>
80106ffe:	85 c0                	test   %eax,%eax
80107000:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107003:	0f 84 cd 00 00 00    	je     801070d6 <copyuvm+0xe6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107009:	8b 55 0c             	mov    0xc(%ebp),%edx
8010700c:	85 d2                	test   %edx,%edx
8010700e:	0f 84 a4 00 00 00    	je     801070b8 <copyuvm+0xc8>
80107014:	31 f6                	xor    %esi,%esi
80107016:	eb 48                	jmp    80107060 <copyuvm+0x70>
80107018:	90                   	nop
80107019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107020:	83 ec 04             	sub    $0x4,%esp
80107023:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107029:	68 00 10 00 00       	push   $0x1000
8010702e:	53                   	push   %ebx
8010702f:	50                   	push   %eax
80107030:	e8 fb d5 ff ff       	call   80104630 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107035:	58                   	pop    %eax
80107036:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
8010703c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010703f:	50                   	push   %eax
80107040:	68 00 10 00 00       	push   $0x1000
80107045:	56                   	push   %esi
80107046:	ff 75 e0             	pushl  -0x20(%ebp)
80107049:	e8 12 fa ff ff       	call   80106a60 <mappages>
8010704e:	83 c4 20             	add    $0x20,%esp
80107051:	85 c0                	test   %eax,%eax
80107053:	78 73                	js     801070c8 <copyuvm+0xd8>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107055:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010705b:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010705e:	76 58                	jbe    801070b8 <copyuvm+0xc8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107060:	83 ec 04             	sub    $0x4,%esp
80107063:	6a 00                	push   $0x0
80107065:	56                   	push   %esi
80107066:	ff 75 08             	pushl  0x8(%ebp)
80107069:	e8 b2 f8 ff ff       	call   80106920 <walkpgdir>
8010706e:	83 c4 10             	add    $0x10,%esp
80107071:	85 c0                	test   %eax,%eax
80107073:	74 72                	je     801070e7 <copyuvm+0xf7>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107075:	8b 38                	mov    (%eax),%edi
80107077:	f7 c7 01 00 00 00    	test   $0x1,%edi
8010707d:	74 5b                	je     801070da <copyuvm+0xea>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
8010707f:	89 fb                	mov    %edi,%ebx
    flags = PTE_FLAGS(*pte);
80107081:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80107087:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
8010708a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80107090:	e8 fb b4 ff ff       	call   80102590 <kalloc>
80107095:	85 c0                	test   %eax,%eax
80107097:	89 c7                	mov    %eax,%edi
80107099:	75 85                	jne    80107020 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
8010709b:	83 ec 0c             	sub    $0xc,%esp
8010709e:	ff 75 e0             	pushl  -0x20(%ebp)
801070a1:	e8 fa fd ff ff       	call   80106ea0 <freevm>
  return 0;
801070a6:	83 c4 10             	add    $0x10,%esp
801070a9:	31 c0                	xor    %eax,%eax
}
801070ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070ae:	5b                   	pop    %ebx
801070af:	5e                   	pop    %esi
801070b0:	5f                   	pop    %edi
801070b1:	5d                   	pop    %ebp
801070b2:	c3                   	ret    
801070b3:	90                   	nop
801070b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801070b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
801070bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070be:	5b                   	pop    %ebx
801070bf:	5e                   	pop    %esi
801070c0:	5f                   	pop    %edi
801070c1:	5d                   	pop    %ebp
801070c2:	c3                   	ret    
801070c3:	90                   	nop
801070c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
801070c8:	83 ec 0c             	sub    $0xc,%esp
801070cb:	57                   	push   %edi
801070cc:	e8 0f b3 ff ff       	call   801023e0 <kfree>
      goto bad;
801070d1:	83 c4 10             	add    $0x10,%esp
801070d4:	eb c5                	jmp    8010709b <copyuvm+0xab>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
801070d6:	31 c0                	xor    %eax,%eax
801070d8:	eb d1                	jmp    801070ab <copyuvm+0xbb>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
801070da:	83 ec 0c             	sub    $0xc,%esp
801070dd:	68 7a 7b 10 80       	push   $0x80107b7a
801070e2:	e8 89 92 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801070e7:	83 ec 0c             	sub    $0xc,%esp
801070ea:	68 60 7b 10 80       	push   $0x80107b60
801070ef:	e8 7c 92 ff ff       	call   80100370 <panic>
801070f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107100 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107106:	6a 00                	push   $0x0
80107108:	ff 75 0c             	pushl  0xc(%ebp)
8010710b:	ff 75 08             	pushl  0x8(%ebp)
8010710e:	e8 0d f8 ff ff       	call   80106920 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107113:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80107115:	83 c4 10             	add    $0x10,%esp
80107118:	89 c2                	mov    %eax,%edx
8010711a:	83 e2 05             	and    $0x5,%edx
8010711d:	83 fa 05             	cmp    $0x5,%edx
80107120:	75 0e                	jne    80107130 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107122:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80107127:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107128:	05 00 00 00 80       	add    $0x80000000,%eax
}
8010712d:	c3                   	ret    
8010712e:	66 90                	xchg   %ax,%ax

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107130:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107132:	c9                   	leave  
80107133:	c3                   	ret    
80107134:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010713a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107140 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	57                   	push   %edi
80107144:	56                   	push   %esi
80107145:	53                   	push   %ebx
80107146:	83 ec 1c             	sub    $0x1c,%esp
80107149:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010714c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010714f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107152:	85 db                	test   %ebx,%ebx
80107154:	75 40                	jne    80107196 <copyout+0x56>
80107156:	eb 70                	jmp    801071c8 <copyout+0x88>
80107158:	90                   	nop
80107159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107160:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107163:	89 f1                	mov    %esi,%ecx
80107165:	29 d1                	sub    %edx,%ecx
80107167:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010716d:	39 d9                	cmp    %ebx,%ecx
8010716f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107172:	29 f2                	sub    %esi,%edx
80107174:	83 ec 04             	sub    $0x4,%esp
80107177:	01 d0                	add    %edx,%eax
80107179:	51                   	push   %ecx
8010717a:	57                   	push   %edi
8010717b:	50                   	push   %eax
8010717c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010717f:	e8 ac d4 ff ff       	call   80104630 <memmove>
    len -= n;
    buf += n;
80107184:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107187:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
8010718a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107190:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107192:	29 cb                	sub    %ecx,%ebx
80107194:	74 32                	je     801071c8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107196:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107198:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010719b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010719e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801071a4:	56                   	push   %esi
801071a5:	ff 75 08             	pushl  0x8(%ebp)
801071a8:	e8 53 ff ff ff       	call   80107100 <uva2ka>
    if(pa0 == 0)
801071ad:	83 c4 10             	add    $0x10,%esp
801071b0:	85 c0                	test   %eax,%eax
801071b2:	75 ac                	jne    80107160 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801071b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
801071b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801071bc:	5b                   	pop    %ebx
801071bd:	5e                   	pop    %esi
801071be:	5f                   	pop    %edi
801071bf:	5d                   	pop    %ebp
801071c0:	c3                   	ret    
801071c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801071cb:	31 c0                	xor    %eax,%eax
}
801071cd:	5b                   	pop    %ebx
801071ce:	5e                   	pop    %esi
801071cf:	5f                   	pop    %edi
801071d0:	5d                   	pop    %ebp
801071d1:	c3                   	ret    
