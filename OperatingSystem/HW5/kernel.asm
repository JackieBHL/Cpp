
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
8010002d:	b8 80 2f 10 80       	mov    $0x80102f80,%eax
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
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 40 70 10 80       	push   $0x80107040
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 65 43 00 00       	call   801043c0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 bc fc 10 80       	mov    $0x8010fcbc,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 70 10 80       	push   $0x80107047
80100097:	50                   	push   %eax
80100098:	e8 13 42 00 00       	call   801042b0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 fa 10 80    	cmp    $0x8010fa60,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

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
801000d9:	8b 7d 08             	mov    0x8(%ebp),%edi
801000dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 d7 43 00 00       	call   801044c0 <acquire>
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
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 79 44 00 00       	call   801045e0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 7e 41 00 00       	call   801042f0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 6f 20 00 00       	call   80102200 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 4e 70 10 80       	push   $0x8010704e
801001a8:	e8 d3 01 00 00       	call   80100380 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 cd 41 00 00       	call   80104390 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 27 20 00 00       	jmp    80102200 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 5f 70 10 80       	push   $0x8010705f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 8c 41 00 00       	call   80104390 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 3c 41 00 00       	call   80104350 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010021b:	e8 a0 42 00 00       	call   801044c0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 6f 43 00 00       	jmp    801045e0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 66 70 10 80       	push   $0x80107066
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100289:	ff 75 08             	pushl  0x8(%ebp)
{
8010028c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
8010028f:	89 de                	mov    %ebx,%esi
  iunlock(ip);
80100291:	e8 6a 15 00 00       	call   80101800 <iunlock>
  acquire(&cons.lock);
80100296:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010029d:	e8 1e 42 00 00       	call   801044c0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002a2:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002a8:	01 df                	add    %ebx,%edi
  while(n > 0){
801002aa:	85 db                	test   %ebx,%ebx
801002ac:	0f 8e 9b 00 00 00    	jle    8010034d <consoleread+0xcd>
    while(input.r == input.w){
801002b2:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002b7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002bd:	74 2b                	je     801002ea <consoleread+0x6a>
801002bf:	eb 5f                	jmp    80100320 <consoleread+0xa0>
801002c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      sleep(&input.r, &cons.lock);
801002c8:	83 ec 08             	sub    $0x8,%esp
801002cb:	68 20 a5 10 80       	push   $0x8010a520
801002d0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002d5:	e8 66 3b 00 00       	call   80103e40 <sleep>
    while(input.r == input.w){
801002da:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002df:	83 c4 10             	add    $0x10,%esp
801002e2:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002e8:	75 36                	jne    80100320 <consoleread+0xa0>
      if(myproc()->killed){
801002ea:	e8 91 35 00 00       	call   80103880 <myproc>
801002ef:	8b 48 24             	mov    0x24(%eax),%ecx
801002f2:	85 c9                	test   %ecx,%ecx
801002f4:	74 d2                	je     801002c8 <consoleread+0x48>
        release(&cons.lock);
801002f6:	83 ec 0c             	sub    $0xc,%esp
801002f9:	68 20 a5 10 80       	push   $0x8010a520
801002fe:	e8 dd 42 00 00       	call   801045e0 <release>
        ilock(ip);
80100303:	5a                   	pop    %edx
80100304:	ff 75 08             	pushl  0x8(%ebp)
80100307:	e8 14 14 00 00       	call   80101720 <ilock>
        return -1;
8010030c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010030f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100312:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100317:	5b                   	pop    %ebx
80100318:	5e                   	pop    %esi
80100319:	5f                   	pop    %edi
8010031a:	5d                   	pop    %ebp
8010031b:	c3                   	ret    
8010031c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100320:	8d 50 01             	lea    0x1(%eax),%edx
80100323:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100329:	89 c2                	mov    %eax,%edx
8010032b:	83 e2 7f             	and    $0x7f,%edx
8010032e:	0f be 8a 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%ecx
    if(c == C('D')){  // EOF
80100335:	80 f9 04             	cmp    $0x4,%cl
80100338:	74 38                	je     80100372 <consoleread+0xf2>
    *dst++ = c;
8010033a:	89 d8                	mov    %ebx,%eax
    --n;
8010033c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010033f:	f7 d8                	neg    %eax
80100341:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100344:	83 f9 0a             	cmp    $0xa,%ecx
80100347:	0f 85 5d ff ff ff    	jne    801002aa <consoleread+0x2a>
  release(&cons.lock);
8010034d:	83 ec 0c             	sub    $0xc,%esp
80100350:	68 20 a5 10 80       	push   $0x8010a520
80100355:	e8 86 42 00 00       	call   801045e0 <release>
  ilock(ip);
8010035a:	58                   	pop    %eax
8010035b:	ff 75 08             	pushl  0x8(%ebp)
8010035e:	e8 bd 13 00 00       	call   80101720 <ilock>
  return target - n;
80100363:	89 f0                	mov    %esi,%eax
80100365:	83 c4 10             	add    $0x10,%esp
}
80100368:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010036b:	29 d8                	sub    %ebx,%eax
}
8010036d:	5b                   	pop    %ebx
8010036e:	5e                   	pop    %esi
8010036f:	5f                   	pop    %edi
80100370:	5d                   	pop    %ebp
80100371:	c3                   	ret    
      if(n < target){
80100372:	39 f3                	cmp    %esi,%ebx
80100374:	73 d7                	jae    8010034d <consoleread+0xcd>
        input.r--;
80100376:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
8010037b:	eb d0                	jmp    8010034d <consoleread+0xcd>
8010037d:	8d 76 00             	lea    0x0(%esi),%esi

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 72 24 00 00       	call   80102810 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 6d 70 10 80       	push   $0x8010706d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	pushl  0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 1f 7a 10 80 	movl   $0x80107a1f,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 13 40 00 00       	call   801043e0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	pushl  (%ebx)
801003d5:	83 c3 04             	add    $0x4,%ebx
801003d8:	68 81 70 10 80       	push   $0x80107081
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 51 58 00 00       	call   80105c70 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100434:	89 ca                	mov    %ecx,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c6                	mov    %eax,%esi
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 ca                	mov    %ecx,%edx
80100449:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 90 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	74 70                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100460:	0f b6 db             	movzbl %bl,%ebx
80100463:	8d 70 01             	lea    0x1(%eax),%esi
80100466:	80 cf 07             	or     $0x7,%bh
80100469:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100470:	80 
  if(pos < 0 || pos > 25*80)
80100471:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100477:	0f 8f f9 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100483:	0f 8f a7 00 00 00    	jg     80100530 <consputc.part.0+0x130>
80100489:	89 f0                	mov    %esi,%eax
8010048b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
80100492:	88 45 e7             	mov    %al,-0x19(%ebp)
80100495:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100498:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049d:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a2:	89 da                	mov    %ebx,%edx
801004a4:	ee                   	out    %al,(%dx)
801004a5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004aa:	89 f8                	mov    %edi,%eax
801004ac:	89 ca                	mov    %ecx,%edx
801004ae:	ee                   	out    %al,(%dx)
801004af:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b4:	89 da                	mov    %ebx,%edx
801004b6:	ee                   	out    %al,(%dx)
801004b7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004bb:	89 ca                	mov    %ecx,%edx
801004bd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 06             	mov    %ax,(%esi)
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
801004ce:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 9a                	jne    80100471 <consputc.part.0+0x71>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b4                	jmp    80100498 <consputc.part.0+0x98>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 71 ff ff ff       	jmp    80100471 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 66 57 00 00       	call   80105c70 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 5a 57 00 00       	call   80105c70 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 4e 57 00 00       	call   80105c70 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 7a 41 00 00       	call   801046d0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 c5 40 00 00       	call   80104630 <memset>
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 22 ff ff ff       	jmp    80100498 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 85 70 10 80       	push   $0x80107085
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <printint>:
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 2c             	sub    $0x2c,%esp
80100599:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
8010059c:	85 c9                	test   %ecx,%ecx
8010059e:	74 04                	je     801005a4 <printint+0x14>
801005a0:	85 c0                	test   %eax,%eax
801005a2:	78 6d                	js     80100611 <printint+0x81>
    x = xx;
801005a4:	89 c1                	mov    %eax,%ecx
801005a6:	31 f6                	xor    %esi,%esi
  i = 0;
801005a8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005ab:	31 db                	xor    %ebx,%ebx
801005ad:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005b0:	89 c8                	mov    %ecx,%eax
801005b2:	31 d2                	xor    %edx,%edx
801005b4:	89 ce                	mov    %ecx,%esi
801005b6:	f7 75 d4             	divl   -0x2c(%ebp)
801005b9:	0f b6 92 b0 70 10 80 	movzbl -0x7fef8f50(%edx),%edx
801005c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005c3:	89 d8                	mov    %ebx,%eax
801005c5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005c8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005cb:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005ce:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005d1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005d4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005d7:	73 d7                	jae    801005b0 <printint+0x20>
801005d9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005dc:	85 f6                	test   %esi,%esi
801005de:	74 0c                	je     801005ec <printint+0x5c>
    buf[i++] = '-';
801005e0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005e5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005e7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005ec:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
801005f0:	0f be c2             	movsbl %dl,%eax
  if(panicked){
801005f3:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801005f9:	85 d2                	test   %edx,%edx
801005fb:	74 03                	je     80100600 <printint+0x70>
  asm volatile("cli");
801005fd:	fa                   	cli    
    for(;;)
801005fe:	eb fe                	jmp    801005fe <printint+0x6e>
80100600:	e8 fb fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100605:	39 fb                	cmp    %edi,%ebx
80100607:	74 10                	je     80100619 <printint+0x89>
80100609:	0f be 03             	movsbl (%ebx),%eax
8010060c:	83 eb 01             	sub    $0x1,%ebx
8010060f:	eb e2                	jmp    801005f3 <printint+0x63>
    x = -xx;
80100611:	f7 d8                	neg    %eax
80100613:	89 ce                	mov    %ecx,%esi
80100615:	89 c1                	mov    %eax,%ecx
80100617:	eb 8f                	jmp    801005a8 <printint+0x18>
}
80100619:	83 c4 2c             	add    $0x2c,%esp
8010061c:	5b                   	pop    %ebx
8010061d:	5e                   	pop    %esi
8010061e:	5f                   	pop    %edi
8010061f:	5d                   	pop    %ebp
80100620:	c3                   	ret    
80100621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100628:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010062f:	90                   	nop

80100630 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100630:	55                   	push   %ebp
80100631:	89 e5                	mov    %esp,%ebp
80100633:	57                   	push   %edi
80100634:	56                   	push   %esi
80100635:	53                   	push   %ebx
80100636:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100639:	ff 75 08             	pushl  0x8(%ebp)
{
8010063c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
8010063f:	e8 bc 11 00 00       	call   80101800 <iunlock>
  acquire(&cons.lock);
80100644:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010064b:	e8 70 3e 00 00       	call   801044c0 <acquire>
  for(i = 0; i < n; i++)
80100650:	83 c4 10             	add    $0x10,%esp
80100653:	85 db                	test   %ebx,%ebx
80100655:	7e 28                	jle    8010067f <consolewrite+0x4f>
80100657:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010065a:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
8010065d:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100663:	85 d2                	test   %edx,%edx
80100665:	74 09                	je     80100670 <consolewrite+0x40>
80100667:	fa                   	cli    
    for(;;)
80100668:	eb fe                	jmp    80100668 <consolewrite+0x38>
8010066a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100670:	0f b6 07             	movzbl (%edi),%eax
80100673:	83 c7 01             	add    $0x1,%edi
80100676:	e8 85 fd ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
8010067b:	39 fe                	cmp    %edi,%esi
8010067d:	75 de                	jne    8010065d <consolewrite+0x2d>
  release(&cons.lock);
8010067f:	83 ec 0c             	sub    $0xc,%esp
80100682:	68 20 a5 10 80       	push   $0x8010a520
80100687:	e8 54 3f 00 00       	call   801045e0 <release>
  ilock(ip);
8010068c:	58                   	pop    %eax
8010068d:	ff 75 08             	pushl  0x8(%ebp)
80100690:	e8 8b 10 00 00       	call   80101720 <ilock>

  return n;
}
80100695:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100698:	89 d8                	mov    %ebx,%eax
8010069a:	5b                   	pop    %ebx
8010069b:	5e                   	pop    %esi
8010069c:	5f                   	pop    %edi
8010069d:	5d                   	pop    %ebp
8010069e:	c3                   	ret    
8010069f:	90                   	nop

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801006ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 e4 00 00 00    	jne    8010079d <cprintf+0xfd>
  if (fmt == 0)
801006b9:	8b 45 08             	mov    0x8(%ebp),%eax
801006bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006bf:	85 c0                	test   %eax,%eax
801006c1:	0f 84 5e 01 00 00    	je     80100825 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c7:	0f b6 00             	movzbl (%eax),%eax
801006ca:	85 c0                	test   %eax,%eax
801006cc:	74 32                	je     80100700 <cprintf+0x60>
  argp = (uint*)(void*)(&fmt + 1);
801006ce:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d1:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006d3:	83 f8 25             	cmp    $0x25,%eax
801006d6:	74 40                	je     80100718 <cprintf+0x78>
  if(panicked){
801006d8:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801006de:	85 c9                	test   %ecx,%ecx
801006e0:	74 0b                	je     801006ed <cprintf+0x4d>
801006e2:	fa                   	cli    
    for(;;)
801006e3:	eb fe                	jmp    801006e3 <cprintf+0x43>
801006e5:	8d 76 00             	lea    0x0(%esi),%esi
801006e8:	b8 25 00 00 00       	mov    $0x25,%eax
801006ed:	e8 0e fd ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006f5:	83 c6 01             	add    $0x1,%esi
801006f8:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
801006fc:	85 c0                	test   %eax,%eax
801006fe:	75 d3                	jne    801006d3 <cprintf+0x33>
  if(locking)
80100700:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100703:	85 c0                	test   %eax,%eax
80100705:	0f 85 05 01 00 00    	jne    80100810 <cprintf+0x170>
}
8010070b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010070e:	5b                   	pop    %ebx
8010070f:	5e                   	pop    %esi
80100710:	5f                   	pop    %edi
80100711:	5d                   	pop    %ebp
80100712:	c3                   	ret    
80100713:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100717:	90                   	nop
    c = fmt[++i] & 0xff;
80100718:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010071b:	83 c6 01             	add    $0x1,%esi
8010071e:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
80100722:	85 ff                	test   %edi,%edi
80100724:	74 da                	je     80100700 <cprintf+0x60>
    switch(c){
80100726:	83 ff 70             	cmp    $0x70,%edi
80100729:	74 5a                	je     80100785 <cprintf+0xe5>
8010072b:	7f 2a                	jg     80100757 <cprintf+0xb7>
8010072d:	83 ff 25             	cmp    $0x25,%edi
80100730:	0f 84 92 00 00 00    	je     801007c8 <cprintf+0x128>
80100736:	83 ff 64             	cmp    $0x64,%edi
80100739:	0f 85 a1 00 00 00    	jne    801007e0 <cprintf+0x140>
      printint(*argp++, 10, 1);
8010073f:	8b 03                	mov    (%ebx),%eax
80100741:	8d 7b 04             	lea    0x4(%ebx),%edi
80100744:	b9 01 00 00 00       	mov    $0x1,%ecx
80100749:	ba 0a 00 00 00       	mov    $0xa,%edx
8010074e:	89 fb                	mov    %edi,%ebx
80100750:	e8 3b fe ff ff       	call   80100590 <printint>
      break;
80100755:	eb 9b                	jmp    801006f2 <cprintf+0x52>
    switch(c){
80100757:	83 ff 73             	cmp    $0x73,%edi
8010075a:	75 24                	jne    80100780 <cprintf+0xe0>
      if((s = (char*)*argp++) == 0)
8010075c:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075f:	8b 1b                	mov    (%ebx),%ebx
80100761:	85 db                	test   %ebx,%ebx
80100763:	75 55                	jne    801007ba <cprintf+0x11a>
        s = "(null)";
80100765:	bb 98 70 10 80       	mov    $0x80107098,%ebx
      for(; *s; s++)
8010076a:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
8010076f:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100775:	85 d2                	test   %edx,%edx
80100777:	74 39                	je     801007b2 <cprintf+0x112>
80100779:	fa                   	cli    
    for(;;)
8010077a:	eb fe                	jmp    8010077a <cprintf+0xda>
8010077c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100780:	83 ff 78             	cmp    $0x78,%edi
80100783:	75 5b                	jne    801007e0 <cprintf+0x140>
      printint(*argp++, 16, 0);
80100785:	8b 03                	mov    (%ebx),%eax
80100787:	8d 7b 04             	lea    0x4(%ebx),%edi
8010078a:	31 c9                	xor    %ecx,%ecx
8010078c:	ba 10 00 00 00       	mov    $0x10,%edx
80100791:	89 fb                	mov    %edi,%ebx
80100793:	e8 f8 fd ff ff       	call   80100590 <printint>
      break;
80100798:	e9 55 ff ff ff       	jmp    801006f2 <cprintf+0x52>
    acquire(&cons.lock);
8010079d:	83 ec 0c             	sub    $0xc,%esp
801007a0:	68 20 a5 10 80       	push   $0x8010a520
801007a5:	e8 16 3d 00 00       	call   801044c0 <acquire>
801007aa:	83 c4 10             	add    $0x10,%esp
801007ad:	e9 07 ff ff ff       	jmp    801006b9 <cprintf+0x19>
801007b2:	e8 49 fc ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
801007b7:	83 c3 01             	add    $0x1,%ebx
801007ba:	0f be 03             	movsbl (%ebx),%eax
801007bd:	84 c0                	test   %al,%al
801007bf:	75 ae                	jne    8010076f <cprintf+0xcf>
      if((s = (char*)*argp++) == 0)
801007c1:	89 fb                	mov    %edi,%ebx
801007c3:	e9 2a ff ff ff       	jmp    801006f2 <cprintf+0x52>
  if(panicked){
801007c8:	8b 3d 58 a5 10 80    	mov    0x8010a558,%edi
801007ce:	85 ff                	test   %edi,%edi
801007d0:	0f 84 12 ff ff ff    	je     801006e8 <cprintf+0x48>
801007d6:	fa                   	cli    
    for(;;)
801007d7:	eb fe                	jmp    801007d7 <cprintf+0x137>
801007d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007e0:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801007e6:	85 c9                	test   %ecx,%ecx
801007e8:	74 06                	je     801007f0 <cprintf+0x150>
801007ea:	fa                   	cli    
    for(;;)
801007eb:	eb fe                	jmp    801007eb <cprintf+0x14b>
801007ed:	8d 76 00             	lea    0x0(%esi),%esi
801007f0:	b8 25 00 00 00       	mov    $0x25,%eax
801007f5:	e8 06 fc ff ff       	call   80100400 <consputc.part.0>
  if(panicked){
801007fa:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100800:	85 d2                	test   %edx,%edx
80100802:	74 34                	je     80100838 <cprintf+0x198>
80100804:	fa                   	cli    
    for(;;)
80100805:	eb fe                	jmp    80100805 <cprintf+0x165>
80100807:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010080e:	66 90                	xchg   %ax,%ax
    release(&cons.lock);
80100810:	83 ec 0c             	sub    $0xc,%esp
80100813:	68 20 a5 10 80       	push   $0x8010a520
80100818:	e8 c3 3d 00 00       	call   801045e0 <release>
8010081d:	83 c4 10             	add    $0x10,%esp
}
80100820:	e9 e6 fe ff ff       	jmp    8010070b <cprintf+0x6b>
    panic("null fmt");
80100825:	83 ec 0c             	sub    $0xc,%esp
80100828:	68 9f 70 10 80       	push   $0x8010709f
8010082d:	e8 4e fb ff ff       	call   80100380 <panic>
80100832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100838:	89 f8                	mov    %edi,%eax
8010083a:	e8 c1 fb ff ff       	call   80100400 <consputc.part.0>
8010083f:	e9 ae fe ff ff       	jmp    801006f2 <cprintf+0x52>
80100844:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010084b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010084f:	90                   	nop

80100850 <consoleintr>:
{
80100850:	55                   	push   %ebp
80100851:	89 e5                	mov    %esp,%ebp
80100853:	57                   	push   %edi
80100854:	56                   	push   %esi
  int c, doprocdump = 0;
80100855:	31 f6                	xor    %esi,%esi
{
80100857:	53                   	push   %ebx
80100858:	83 ec 18             	sub    $0x18,%esp
8010085b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010085e:	68 20 a5 10 80       	push   $0x8010a520
80100863:	e8 58 3c 00 00       	call   801044c0 <acquire>
  while((c = getc()) >= 0){
80100868:	83 c4 10             	add    $0x10,%esp
8010086b:	eb 17                	jmp    80100884 <consoleintr+0x34>
    switch(c){
8010086d:	83 fb 08             	cmp    $0x8,%ebx
80100870:	0f 84 fa 00 00 00    	je     80100970 <consoleintr+0x120>
80100876:	83 fb 10             	cmp    $0x10,%ebx
80100879:	0f 85 19 01 00 00    	jne    80100998 <consoleintr+0x148>
8010087f:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100884:	ff d7                	call   *%edi
80100886:	89 c3                	mov    %eax,%ebx
80100888:	85 c0                	test   %eax,%eax
8010088a:	0f 88 27 01 00 00    	js     801009b7 <consoleintr+0x167>
    switch(c){
80100890:	83 fb 15             	cmp    $0x15,%ebx
80100893:	74 7b                	je     80100910 <consoleintr+0xc0>
80100895:	7e d6                	jle    8010086d <consoleintr+0x1d>
80100897:	83 fb 7f             	cmp    $0x7f,%ebx
8010089a:	0f 84 d0 00 00 00    	je     80100970 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008a5:	89 c2                	mov    %eax,%edx
801008a7:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008ad:	83 fa 7f             	cmp    $0x7f,%edx
801008b0:	77 d2                	ja     80100884 <consoleintr+0x34>
        c = (c == '\r') ? '\n' : c;
801008b2:	8d 48 01             	lea    0x1(%eax),%ecx
801008b5:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801008bb:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008be:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008c4:	83 fb 0d             	cmp    $0xd,%ebx
801008c7:	0f 84 06 01 00 00    	je     801009d3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008cd:	88 98 20 ff 10 80    	mov    %bl,-0x7fef00e0(%eax)
  if(panicked){
801008d3:	85 d2                	test   %edx,%edx
801008d5:	0f 85 03 01 00 00    	jne    801009de <consoleintr+0x18e>
801008db:	89 d8                	mov    %ebx,%eax
801008dd:	e8 1e fb ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e2:	83 fb 0a             	cmp    $0xa,%ebx
801008e5:	0f 84 13 01 00 00    	je     801009fe <consoleintr+0x1ae>
801008eb:	83 fb 04             	cmp    $0x4,%ebx
801008ee:	0f 84 0a 01 00 00    	je     801009fe <consoleintr+0x1ae>
801008f4:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008f9:	83 e8 80             	sub    $0xffffff80,%eax
801008fc:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100902:	75 80                	jne    80100884 <consoleintr+0x34>
80100904:	e9 fa 00 00 00       	jmp    80100a03 <consoleintr+0x1b3>
80100909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100910:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100915:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
8010091b:	0f 84 63 ff ff ff    	je     80100884 <consoleintr+0x34>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100921:	83 e8 01             	sub    $0x1,%eax
80100924:	89 c2                	mov    %eax,%edx
80100926:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100929:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100930:	0f 84 4e ff ff ff    	je     80100884 <consoleintr+0x34>
  if(panicked){
80100936:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.e--;
8010093c:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100941:	85 d2                	test   %edx,%edx
80100943:	74 0b                	je     80100950 <consoleintr+0x100>
80100945:	fa                   	cli    
    for(;;)
80100946:	eb fe                	jmp    80100946 <consoleintr+0xf6>
80100948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010094f:	90                   	nop
80100950:	b8 00 01 00 00       	mov    $0x100,%eax
80100955:	e8 a6 fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
8010095a:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010095f:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100965:	75 ba                	jne    80100921 <consoleintr+0xd1>
80100967:	e9 18 ff ff ff       	jmp    80100884 <consoleintr+0x34>
8010096c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100970:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100975:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010097b:	0f 84 03 ff ff ff    	je     80100884 <consoleintr+0x34>
        input.e--;
80100981:	83 e8 01             	sub    $0x1,%eax
80100984:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100989:	a1 58 a5 10 80       	mov    0x8010a558,%eax
8010098e:	85 c0                	test   %eax,%eax
80100990:	74 16                	je     801009a8 <consoleintr+0x158>
80100992:	fa                   	cli    
    for(;;)
80100993:	eb fe                	jmp    80100993 <consoleintr+0x143>
80100995:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100998:	85 db                	test   %ebx,%ebx
8010099a:	0f 84 e4 fe ff ff    	je     80100884 <consoleintr+0x34>
801009a0:	e9 fb fe ff ff       	jmp    801008a0 <consoleintr+0x50>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
801009b2:	e9 cd fe ff ff       	jmp    80100884 <consoleintr+0x34>
  release(&cons.lock);
801009b7:	83 ec 0c             	sub    $0xc,%esp
801009ba:	68 20 a5 10 80       	push   $0x8010a520
801009bf:	e8 1c 3c 00 00       	call   801045e0 <release>
  if(doprocdump) {
801009c4:	83 c4 10             	add    $0x10,%esp
801009c7:	85 f6                	test   %esi,%esi
801009c9:	75 1d                	jne    801009e8 <consoleintr+0x198>
}
801009cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009ce:	5b                   	pop    %ebx
801009cf:	5e                   	pop    %esi
801009d0:	5f                   	pop    %edi
801009d1:	5d                   	pop    %ebp
801009d2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009d3:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
  if(panicked){
801009da:	85 d2                	test   %edx,%edx
801009dc:	74 16                	je     801009f4 <consoleintr+0x1a4>
801009de:	fa                   	cli    
    for(;;)
801009df:	eb fe                	jmp    801009df <consoleintr+0x18f>
801009e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009eb:	5b                   	pop    %ebx
801009ec:	5e                   	pop    %esi
801009ed:	5f                   	pop    %edi
801009ee:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ef:	e9 dc 36 00 00       	jmp    801040d0 <procdump>
801009f4:	b8 0a 00 00 00       	mov    $0xa,%eax
801009f9:	e8 02 fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009fe:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
          wakeup(&input.r);
80100a03:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a06:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100a0b:	68 a0 ff 10 80       	push   $0x8010ffa0
80100a10:	e8 db 35 00 00       	call   80103ff0 <wakeup>
80100a15:	83 c4 10             	add    $0x10,%esp
80100a18:	e9 67 fe ff ff       	jmp    80100884 <consoleintr+0x34>
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi

80100a20 <consoleinit>:

void
consoleinit(void)
{
80100a20:	55                   	push   %ebp
80100a21:	89 e5                	mov    %esp,%ebp
80100a23:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a26:	68 a8 70 10 80       	push   $0x801070a8
80100a2b:	68 20 a5 10 80       	push   $0x8010a520
80100a30:	e8 8b 39 00 00       	call   801043c0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a35:	58                   	pop    %eax
80100a36:	5a                   	pop    %edx
80100a37:	6a 00                	push   $0x0
80100a39:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a3b:	c7 05 6c 09 11 80 30 	movl   $0x80100630,0x8011096c
80100a42:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a45:	c7 05 68 09 11 80 80 	movl   $0x80100280,0x80110968
80100a4c:	02 10 80 
  cons.locking = 1;
80100a4f:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a56:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a59:	e8 42 19 00 00       	call   801023a0 <ioapicenable>
}
80100a5e:	83 c4 10             	add    $0x10,%esp
80100a61:	c9                   	leave  
80100a62:	c3                   	ret    
80100a63:	66 90                	xchg   %ax,%ax
80100a65:	66 90                	xchg   %ax,%ax
80100a67:	66 90                	xchg   %ax,%ax
80100a69:	66 90                	xchg   %ax,%ax
80100a6b:	66 90                	xchg   %ax,%ax
80100a6d:	66 90                	xchg   %ax,%ax
80100a6f:	90                   	nop

80100a70 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a70:	55                   	push   %ebp
80100a71:	89 e5                	mov    %esp,%ebp
80100a73:	57                   	push   %edi
80100a74:	56                   	push   %esi
80100a75:	53                   	push   %ebx
80100a76:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a7c:	e8 ff 2d 00 00       	call   80103880 <myproc>
80100a81:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a87:	e8 f4 21 00 00       	call   80102c80 <begin_op>

  if((ip = namei(path)) == 0){
80100a8c:	83 ec 0c             	sub    $0xc,%esp
80100a8f:	ff 75 08             	pushl  0x8(%ebp)
80100a92:	e8 29 15 00 00       	call   80101fc0 <namei>
80100a97:	83 c4 10             	add    $0x10,%esp
80100a9a:	85 c0                	test   %eax,%eax
80100a9c:	0f 84 09 03 00 00    	je     80100dab <exec+0x33b>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100aa2:	83 ec 0c             	sub    $0xc,%esp
80100aa5:	89 c3                	mov    %eax,%ebx
80100aa7:	50                   	push   %eax
80100aa8:	e8 73 0c 00 00       	call   80101720 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aad:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ab3:	6a 34                	push   $0x34
80100ab5:	6a 00                	push   $0x0
80100ab7:	50                   	push   %eax
80100ab8:	53                   	push   %ebx
80100ab9:	e8 42 0f 00 00       	call   80101a00 <readi>
80100abe:	83 c4 20             	add    $0x20,%esp
80100ac1:	83 f8 34             	cmp    $0x34,%eax
80100ac4:	74 22                	je     80100ae8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ac6:	83 ec 0c             	sub    $0xc,%esp
80100ac9:	53                   	push   %ebx
80100aca:	e8 e1 0e 00 00       	call   801019b0 <iunlockput>
    end_op();
80100acf:	e8 1c 22 00 00       	call   80102cf0 <end_op>
80100ad4:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100ad7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100adc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100adf:	5b                   	pop    %ebx
80100ae0:	5e                   	pop    %esi
80100ae1:	5f                   	pop    %edi
80100ae2:	5d                   	pop    %ebp
80100ae3:	c3                   	ret    
80100ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100ae8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100aef:	45 4c 46 
80100af2:	75 d2                	jne    80100ac6 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100af4:	e8 c7 62 00 00       	call   80106dc0 <setupkvm>
80100af9:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100aff:	85 c0                	test   %eax,%eax
80100b01:	74 c3                	je     80100ac6 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b03:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b0a:	00 
80100b0b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b11:	0f 84 b3 02 00 00    	je     80100dca <exec+0x35a>
  sz = 0;
80100b17:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b1e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b21:	31 ff                	xor    %edi,%edi
80100b23:	e9 8e 00 00 00       	jmp    80100bb6 <exec+0x146>
80100b28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b2f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b30:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b37:	75 6c                	jne    80100ba5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b39:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b3f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b45:	0f 82 87 00 00 00    	jb     80100bd2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b4b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b51:	72 7f                	jb     80100bd2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b53:	83 ec 04             	sub    $0x4,%esp
80100b56:	50                   	push   %eax
80100b57:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b5d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b63:	e8 78 60 00 00       	call   80106be0 <allocuvm>
80100b68:	83 c4 10             	add    $0x10,%esp
80100b6b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b71:	85 c0                	test   %eax,%eax
80100b73:	74 5d                	je     80100bd2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b75:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b7b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b80:	75 50                	jne    80100bd2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b82:	83 ec 0c             	sub    $0xc,%esp
80100b85:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b8b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b91:	53                   	push   %ebx
80100b92:	50                   	push   %eax
80100b93:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b99:	e8 82 5f 00 00       	call   80106b20 <loaduvm>
80100b9e:	83 c4 20             	add    $0x20,%esp
80100ba1:	85 c0                	test   %eax,%eax
80100ba3:	78 2d                	js     80100bd2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ba5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bac:	83 c7 01             	add    $0x1,%edi
80100baf:	83 c6 20             	add    $0x20,%esi
80100bb2:	39 f8                	cmp    %edi,%eax
80100bb4:	7e 3a                	jle    80100bf0 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bb6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bbc:	6a 20                	push   $0x20
80100bbe:	56                   	push   %esi
80100bbf:	50                   	push   %eax
80100bc0:	53                   	push   %ebx
80100bc1:	e8 3a 0e 00 00       	call   80101a00 <readi>
80100bc6:	83 c4 10             	add    $0x10,%esp
80100bc9:	83 f8 20             	cmp    $0x20,%eax
80100bcc:	0f 84 5e ff ff ff    	je     80100b30 <exec+0xc0>
    freevm(pgdir);
80100bd2:	83 ec 0c             	sub    $0xc,%esp
80100bd5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bdb:	e8 60 61 00 00       	call   80106d40 <freevm>
  if(ip){
80100be0:	83 c4 10             	add    $0x10,%esp
80100be3:	e9 de fe ff ff       	jmp    80100ac6 <exec+0x56>
80100be8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bef:	90                   	nop
80100bf0:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100bf6:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100bfc:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c02:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c08:	83 ec 0c             	sub    $0xc,%esp
80100c0b:	53                   	push   %ebx
80100c0c:	e8 9f 0d 00 00       	call   801019b0 <iunlockput>
  end_op();
80100c11:	e8 da 20 00 00       	call   80102cf0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c16:	83 c4 0c             	add    $0xc,%esp
80100c19:	56                   	push   %esi
80100c1a:	57                   	push   %edi
80100c1b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c21:	57                   	push   %edi
80100c22:	e8 b9 5f 00 00       	call   80106be0 <allocuvm>
80100c27:	83 c4 10             	add    $0x10,%esp
80100c2a:	89 c6                	mov    %eax,%esi
80100c2c:	85 c0                	test   %eax,%eax
80100c2e:	0f 84 94 00 00 00    	je     80100cc8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c34:	83 ec 08             	sub    $0x8,%esp
80100c37:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c3d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c3f:	50                   	push   %eax
80100c40:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c41:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c43:	e8 18 62 00 00       	call   80106e60 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c48:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4b:	83 c4 10             	add    $0x10,%esp
80100c4e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c54:	8b 00                	mov    (%eax),%eax
80100c56:	85 c0                	test   %eax,%eax
80100c58:	0f 84 8b 00 00 00    	je     80100ce9 <exec+0x279>
80100c5e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c64:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c6a:	eb 23                	jmp    80100c8f <exec+0x21f>
80100c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c70:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c73:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c7a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c83:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c86:	85 c0                	test   %eax,%eax
80100c88:	74 59                	je     80100ce3 <exec+0x273>
    if(argc >= MAXARG)
80100c8a:	83 ff 20             	cmp    $0x20,%edi
80100c8d:	74 39                	je     80100cc8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c8f:	83 ec 0c             	sub    $0xc,%esp
80100c92:	50                   	push   %eax
80100c93:	e8 98 3b 00 00       	call   80104830 <strlen>
80100c98:	f7 d0                	not    %eax
80100c9a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c9c:	58                   	pop    %eax
80100c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ca0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ca3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100ca6:	e8 85 3b 00 00       	call   80104830 <strlen>
80100cab:	83 c0 01             	add    $0x1,%eax
80100cae:	50                   	push   %eax
80100caf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cb2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb5:	53                   	push   %ebx
80100cb6:	56                   	push   %esi
80100cb7:	e8 f4 62 00 00       	call   80106fb0 <copyout>
80100cbc:	83 c4 20             	add    $0x20,%esp
80100cbf:	85 c0                	test   %eax,%eax
80100cc1:	79 ad                	jns    80100c70 <exec+0x200>
80100cc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cc7:	90                   	nop
    freevm(pgdir);
80100cc8:	83 ec 0c             	sub    $0xc,%esp
80100ccb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100cd1:	e8 6a 60 00 00       	call   80106d40 <freevm>
80100cd6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100cd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cde:	e9 f9 fd ff ff       	jmp    80100adc <exec+0x6c>
80100ce3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ce9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100cf0:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100cf2:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100cf9:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cfd:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cff:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d02:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d08:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d0a:	50                   	push   %eax
80100d0b:	52                   	push   %edx
80100d0c:	53                   	push   %ebx
80100d0d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d13:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d1a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d1d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d23:	e8 88 62 00 00       	call   80106fb0 <copyout>
80100d28:	83 c4 10             	add    $0x10,%esp
80100d2b:	85 c0                	test   %eax,%eax
80100d2d:	78 99                	js     80100cc8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d2f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d32:	8b 55 08             	mov    0x8(%ebp),%edx
80100d35:	0f b6 00             	movzbl (%eax),%eax
80100d38:	84 c0                	test   %al,%al
80100d3a:	74 13                	je     80100d4f <exec+0x2df>
80100d3c:	89 d1                	mov    %edx,%ecx
80100d3e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d40:	83 c1 01             	add    $0x1,%ecx
80100d43:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d45:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d48:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d4b:	84 c0                	test   %al,%al
80100d4d:	75 f1                	jne    80100d40 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d4f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d55:	83 ec 04             	sub    $0x4,%esp
80100d58:	6a 10                	push   $0x10
80100d5a:	89 f8                	mov    %edi,%eax
80100d5c:	52                   	push   %edx
80100d5d:	83 c0 6c             	add    $0x6c,%eax
80100d60:	50                   	push   %eax
80100d61:	e8 8a 3a 00 00       	call   801047f0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d66:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d6c:	89 f8                	mov    %edi,%eax
80100d6e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d71:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d73:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d76:	89 c1                	mov    %eax,%ecx
80100d78:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d7e:	8b 40 18             	mov    0x18(%eax),%eax
80100d81:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d84:	8b 41 18             	mov    0x18(%ecx),%eax
80100d87:	89 58 44             	mov    %ebx,0x44(%eax)
  curproc->priority = 2;
80100d8a:	c7 41 7c 02 00 00 00 	movl   $0x2,0x7c(%ecx)
  switchuvm(curproc);
80100d91:	89 0c 24             	mov    %ecx,(%esp)
80100d94:	e8 f7 5b 00 00       	call   80106990 <switchuvm>
  freevm(oldpgdir);
80100d99:	89 3c 24             	mov    %edi,(%esp)
80100d9c:	e8 9f 5f 00 00       	call   80106d40 <freevm>
  return 0;
80100da1:	83 c4 10             	add    $0x10,%esp
80100da4:	31 c0                	xor    %eax,%eax
80100da6:	e9 31 fd ff ff       	jmp    80100adc <exec+0x6c>
    end_op();
80100dab:	e8 40 1f 00 00       	call   80102cf0 <end_op>
    cprintf("exec: fail\n");
80100db0:	83 ec 0c             	sub    $0xc,%esp
80100db3:	68 c1 70 10 80       	push   $0x801070c1
80100db8:	e8 e3 f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100dbd:	83 c4 10             	add    $0x10,%esp
80100dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dc5:	e9 12 fd ff ff       	jmp    80100adc <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dca:	31 ff                	xor    %edi,%edi
80100dcc:	be 00 20 00 00       	mov    $0x2000,%esi
80100dd1:	e9 32 fe ff ff       	jmp    80100c08 <exec+0x198>
80100dd6:	66 90                	xchg   %ax,%ax
80100dd8:	66 90                	xchg   %ax,%ax
80100dda:	66 90                	xchg   %ax,%ax
80100ddc:	66 90                	xchg   %ax,%ax
80100dde:	66 90                	xchg   %ax,%ax

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100de6:	68 cd 70 10 80       	push   $0x801070cd
80100deb:	68 c0 ff 10 80       	push   $0x8010ffc0
80100df0:	e8 cb 35 00 00       	call   801043c0 <initlock>
}
80100df5:	83 c4 10             	add    $0x10,%esp
80100df8:	c9                   	leave  
80100df9:	c3                   	ret    
80100dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e04:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100e09:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e0c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e11:	e8 aa 36 00 00       	call   801044c0 <acquire>
80100e16:	83 c4 10             	add    $0x10,%esp
80100e19:	eb 10                	jmp    80100e2b <filealloc+0x2b>
80100e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e41:	e8 9a 37 00 00       	call   801045e0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e5a:	e8 81 37 00 00       	call   801045e0 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	53                   	push   %ebx
80100e74:	83 ec 10             	sub    $0x10,%esp
80100e77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7a:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e7f:	e8 3c 36 00 00       	call   801044c0 <acquire>
  if(f->ref < 1)
80100e84:	8b 43 04             	mov    0x4(%ebx),%eax
80100e87:	83 c4 10             	add    $0x10,%esp
80100e8a:	85 c0                	test   %eax,%eax
80100e8c:	7e 1a                	jle    80100ea8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e8e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e91:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e94:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e97:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e9c:	e8 3f 37 00 00       	call   801045e0 <release>
  return f;
}
80100ea1:	89 d8                	mov    %ebx,%eax
80100ea3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ea6:	c9                   	leave  
80100ea7:	c3                   	ret    
    panic("filedup");
80100ea8:	83 ec 0c             	sub    $0xc,%esp
80100eab:	68 d4 70 10 80       	push   $0x801070d4
80100eb0:	e8 cb f4 ff ff       	call   80100380 <panic>
80100eb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	57                   	push   %edi
80100ec4:	56                   	push   %esi
80100ec5:	53                   	push   %ebx
80100ec6:	83 ec 28             	sub    $0x28,%esp
80100ec9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ecc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ed1:	e8 ea 35 00 00       	call   801044c0 <acquire>
  if(f->ref < 1)
80100ed6:	8b 53 04             	mov    0x4(%ebx),%edx
80100ed9:	83 c4 10             	add    $0x10,%esp
80100edc:	85 d2                	test   %edx,%edx
80100ede:	0f 8e a5 00 00 00    	jle    80100f89 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ee4:	83 ea 01             	sub    $0x1,%edx
80100ee7:	89 53 04             	mov    %edx,0x4(%ebx)
80100eea:	75 44                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100eec:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef0:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef3:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100efb:	8b 73 0c             	mov    0xc(%ebx),%esi
80100efe:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f01:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f04:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100f09:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f0c:	e8 cf 36 00 00       	call   801045e0 <release>

  if(ff.type == FD_PIPE)
80100f11:	83 c4 10             	add    $0x10,%esp
80100f14:	83 ff 01             	cmp    $0x1,%edi
80100f17:	74 57                	je     80100f70 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f19:	83 ff 02             	cmp    $0x2,%edi
80100f1c:	74 2a                	je     80100f48 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f21:	5b                   	pop    %ebx
80100f22:	5e                   	pop    %esi
80100f23:	5f                   	pop    %edi
80100f24:	5d                   	pop    %ebp
80100f25:	c3                   	ret    
80100f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f2d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f30:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 9d 36 00 00       	jmp    801045e0 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 33 1d 00 00       	call   80102c80 <begin_op>
    iput(ff.ip);
80100f4d:	83 ec 0c             	sub    $0xc,%esp
80100f50:	ff 75 e0             	pushl  -0x20(%ebp)
80100f53:	e8 f8 08 00 00       	call   80101850 <iput>
    end_op();
80100f58:	83 c4 10             	add    $0x10,%esp
}
80100f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5e:	5b                   	pop    %ebx
80100f5f:	5e                   	pop    %esi
80100f60:	5f                   	pop    %edi
80100f61:	5d                   	pop    %ebp
    end_op();
80100f62:	e9 89 1d 00 00       	jmp    80102cf0 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 a2 24 00 00       	call   80103420 <pipeclose>
80100f7e:	83 c4 10             	add    $0x10,%esp
}
80100f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f84:	5b                   	pop    %ebx
80100f85:	5e                   	pop    %esi
80100f86:	5f                   	pop    %edi
80100f87:	5d                   	pop    %ebp
80100f88:	c3                   	ret    
    panic("fileclose");
80100f89:	83 ec 0c             	sub    $0xc,%esp
80100f8c:	68 dc 70 10 80       	push   $0x801070dc
80100f91:	e8 ea f3 ff ff       	call   80100380 <panic>
80100f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9d:	8d 76 00             	lea    0x0(%esi),%esi

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	55                   	push   %ebp
80100fa1:	89 e5                	mov    %esp,%ebp
80100fa3:	53                   	push   %ebx
80100fa4:	83 ec 04             	sub    $0x4,%esp
80100fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100faa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fad:	75 31                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100faf:	83 ec 0c             	sub    $0xc,%esp
80100fb2:	ff 73 10             	pushl  0x10(%ebx)
80100fb5:	e8 66 07 00 00       	call   80101720 <ilock>
    stati(f->ip, st);
80100fba:	58                   	pop    %eax
80100fbb:	5a                   	pop    %edx
80100fbc:	ff 75 0c             	pushl  0xc(%ebp)
80100fbf:	ff 73 10             	pushl  0x10(%ebx)
80100fc2:	e8 09 0a 00 00       	call   801019d0 <stati>
    iunlock(f->ip);
80100fc7:	59                   	pop    %ecx
80100fc8:	ff 73 10             	pushl  0x10(%ebx)
80100fcb:	e8 30 08 00 00       	call   80101800 <iunlock>
    return 0;
  }
  return -1;
}
80100fd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fd3:	83 c4 10             	add    $0x10,%esp
80100fd6:	31 c0                	xor    %eax,%eax
}
80100fd8:	c9                   	leave  
80100fd9:	c3                   	ret    
80100fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 0c             	sub    $0xc,%esp
80100ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100ffc:	8b 75 0c             	mov    0xc(%ebp),%esi
80100fff:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101002:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101006:	74 60                	je     80101068 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101008:	8b 03                	mov    (%ebx),%eax
8010100a:	83 f8 01             	cmp    $0x1,%eax
8010100d:	74 41                	je     80101050 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100f:	83 f8 02             	cmp    $0x2,%eax
80101012:	75 5b                	jne    8010106f <fileread+0x7f>
    ilock(f->ip);
80101014:	83 ec 0c             	sub    $0xc,%esp
80101017:	ff 73 10             	pushl  0x10(%ebx)
8010101a:	e8 01 07 00 00       	call   80101720 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010101f:	57                   	push   %edi
80101020:	ff 73 14             	pushl  0x14(%ebx)
80101023:	56                   	push   %esi
80101024:	ff 73 10             	pushl  0x10(%ebx)
80101027:	e8 d4 09 00 00       	call   80101a00 <readi>
8010102c:	83 c4 20             	add    $0x20,%esp
8010102f:	89 c6                	mov    %eax,%esi
80101031:	85 c0                	test   %eax,%eax
80101033:	7e 03                	jle    80101038 <fileread+0x48>
      f->off += r;
80101035:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101038:	83 ec 0c             	sub    $0xc,%esp
8010103b:	ff 73 10             	pushl  0x10(%ebx)
8010103e:	e8 bd 07 00 00       	call   80101800 <iunlock>
    return r;
80101043:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101046:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101049:	89 f0                	mov    %esi,%eax
8010104b:	5b                   	pop    %ebx
8010104c:	5e                   	pop    %esi
8010104d:	5f                   	pop    %edi
8010104e:	5d                   	pop    %ebp
8010104f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101050:	8b 43 0c             	mov    0xc(%ebx),%eax
80101053:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101056:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101059:	5b                   	pop    %ebx
8010105a:	5e                   	pop    %esi
8010105b:	5f                   	pop    %edi
8010105c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010105d:	e9 5e 25 00 00       	jmp    801035c0 <piperead>
80101062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101068:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010106d:	eb d7                	jmp    80101046 <fileread+0x56>
  panic("fileread");
8010106f:	83 ec 0c             	sub    $0xc,%esp
80101072:	68 e6 70 10 80       	push   $0x801070e6
80101077:	e8 04 f3 ff ff       	call   80100380 <panic>
8010107c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101080 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101080:	55                   	push   %ebp
80101081:	89 e5                	mov    %esp,%ebp
80101083:	57                   	push   %edi
80101084:	56                   	push   %esi
80101085:	53                   	push   %ebx
80101086:	83 ec 1c             	sub    $0x1c,%esp
80101089:	8b 45 0c             	mov    0xc(%ebp),%eax
8010108c:	8b 75 08             	mov    0x8(%ebp),%esi
8010108f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101092:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101095:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101099:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010109c:	0f 84 bd 00 00 00    	je     8010115f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010a2:	8b 06                	mov    (%esi),%eax
801010a4:	83 f8 01             	cmp    $0x1,%eax
801010a7:	0f 84 bf 00 00 00    	je     8010116c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010ad:	83 f8 02             	cmp    $0x2,%eax
801010b0:	0f 85 c8 00 00 00    	jne    8010117e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010b9:	31 ff                	xor    %edi,%edi
    while(i < n){
801010bb:	85 c0                	test   %eax,%eax
801010bd:	7f 30                	jg     801010ef <filewrite+0x6f>
801010bf:	e9 94 00 00 00       	jmp    80101158 <filewrite+0xd8>
801010c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010c8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010cb:	83 ec 0c             	sub    $0xc,%esp
801010ce:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010d4:	e8 27 07 00 00       	call   80101800 <iunlock>
      end_op();
801010d9:	e8 12 1c 00 00       	call   80102cf0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010e1:	83 c4 10             	add    $0x10,%esp
801010e4:	39 c3                	cmp    %eax,%ebx
801010e6:	75 60                	jne    80101148 <filewrite+0xc8>
        panic("short filewrite");
      i += r;
801010e8:	01 df                	add    %ebx,%edi
    while(i < n){
801010ea:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010ed:	7e 69                	jle    80101158 <filewrite+0xd8>
      int n1 = n - i;
801010ef:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801010f2:	b8 00 06 00 00       	mov    $0x600,%eax
801010f7:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
801010f9:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801010ff:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101102:	e8 79 1b 00 00       	call   80102c80 <begin_op>
      ilock(f->ip);
80101107:	83 ec 0c             	sub    $0xc,%esp
8010110a:	ff 76 10             	pushl  0x10(%esi)
8010110d:	e8 0e 06 00 00       	call   80101720 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101112:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101115:	53                   	push   %ebx
80101116:	ff 76 14             	pushl  0x14(%esi)
80101119:	01 f8                	add    %edi,%eax
8010111b:	50                   	push   %eax
8010111c:	ff 76 10             	pushl  0x10(%esi)
8010111f:	e8 dc 09 00 00       	call   80101b00 <writei>
80101124:	83 c4 20             	add    $0x20,%esp
80101127:	85 c0                	test   %eax,%eax
80101129:	7f 9d                	jg     801010c8 <filewrite+0x48>
      iunlock(f->ip);
8010112b:	83 ec 0c             	sub    $0xc,%esp
8010112e:	ff 76 10             	pushl  0x10(%esi)
80101131:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101134:	e8 c7 06 00 00       	call   80101800 <iunlock>
      end_op();
80101139:	e8 b2 1b 00 00       	call   80102cf0 <end_op>
      if(r < 0)
8010113e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101141:	83 c4 10             	add    $0x10,%esp
80101144:	85 c0                	test   %eax,%eax
80101146:	75 17                	jne    8010115f <filewrite+0xdf>
        panic("short filewrite");
80101148:	83 ec 0c             	sub    $0xc,%esp
8010114b:	68 ef 70 10 80       	push   $0x801070ef
80101150:	e8 2b f2 ff ff       	call   80100380 <panic>
80101155:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101158:	89 f8                	mov    %edi,%eax
8010115a:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
8010115d:	74 05                	je     80101164 <filewrite+0xe4>
8010115f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101164:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101167:	5b                   	pop    %ebx
80101168:	5e                   	pop    %esi
80101169:	5f                   	pop    %edi
8010116a:	5d                   	pop    %ebp
8010116b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010116c:	8b 46 0c             	mov    0xc(%esi),%eax
8010116f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101172:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101175:	5b                   	pop    %ebx
80101176:	5e                   	pop    %esi
80101177:	5f                   	pop    %edi
80101178:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101179:	e9 42 23 00 00       	jmp    801034c0 <pipewrite>
  panic("filewrite");
8010117e:	83 ec 0c             	sub    $0xc,%esp
80101181:	68 f5 70 10 80       	push   $0x801070f5
80101186:	e8 f5 f1 ff ff       	call   80100380 <panic>
8010118b:	66 90                	xchg   %ax,%ax
8010118d:	66 90                	xchg   %ax,%ax
8010118f:	90                   	nop

80101190 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101190:	55                   	push   %ebp
80101191:	89 e5                	mov    %esp,%ebp
80101193:	57                   	push   %edi
80101194:	56                   	push   %esi
80101195:	53                   	push   %ebx
80101196:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101199:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010119f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011a2:	85 c9                	test   %ecx,%ecx
801011a4:	0f 84 87 00 00 00    	je     80101231 <balloc+0xa1>
801011aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011b1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011b4:	83 ec 08             	sub    $0x8,%esp
801011b7:	89 f0                	mov    %esi,%eax
801011b9:	c1 f8 0c             	sar    $0xc,%eax
801011bc:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011c2:	50                   	push   %eax
801011c3:	ff 75 d8             	pushl  -0x28(%ebp)
801011c6:	e8 05 ef ff ff       	call   801000d0 <bread>
801011cb:	83 c4 10             	add    $0x10,%esp
801011ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011d1:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011d9:	31 c0                	xor    %eax,%eax
801011db:	eb 2f                	jmp    8010120c <balloc+0x7c>
801011dd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011e0:	89 c1                	mov    %eax,%ecx
801011e2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011ea:	83 e1 07             	and    $0x7,%ecx
801011ed:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011ef:	89 c1                	mov    %eax,%ecx
801011f1:	c1 f9 03             	sar    $0x3,%ecx
801011f4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011f9:	89 fa                	mov    %edi,%edx
801011fb:	85 df                	test   %ebx,%edi
801011fd:	74 41                	je     80101240 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ff:	83 c0 01             	add    $0x1,%eax
80101202:	83 c6 01             	add    $0x1,%esi
80101205:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010120a:	74 05                	je     80101211 <balloc+0x81>
8010120c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010120f:	77 cf                	ja     801011e0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101211:	83 ec 0c             	sub    $0xc,%esp
80101214:	ff 75 e4             	pushl  -0x1c(%ebp)
80101217:	e8 d4 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010121c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101223:	83 c4 10             	add    $0x10,%esp
80101226:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101229:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010122f:	77 80                	ja     801011b1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101231:	83 ec 0c             	sub    $0xc,%esp
80101234:	68 ff 70 10 80       	push   $0x801070ff
80101239:	e8 42 f1 ff ff       	call   80100380 <panic>
8010123e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101240:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101243:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101246:	09 da                	or     %ebx,%edx
80101248:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010124c:	57                   	push   %edi
8010124d:	e8 0e 1c 00 00       	call   80102e60 <log_write>
        brelse(bp);
80101252:	89 3c 24             	mov    %edi,(%esp)
80101255:	e8 96 ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010125a:	58                   	pop    %eax
8010125b:	5a                   	pop    %edx
8010125c:	56                   	push   %esi
8010125d:	ff 75 d8             	pushl  -0x28(%ebp)
80101260:	e8 6b ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101265:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101268:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010126a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010126d:	68 00 02 00 00       	push   $0x200
80101272:	6a 00                	push   $0x0
80101274:	50                   	push   %eax
80101275:	e8 b6 33 00 00       	call   80104630 <memset>
  log_write(bp);
8010127a:	89 1c 24             	mov    %ebx,(%esp)
8010127d:	e8 de 1b 00 00       	call   80102e60 <log_write>
  brelse(bp);
80101282:	89 1c 24             	mov    %ebx,(%esp)
80101285:	e8 66 ef ff ff       	call   801001f0 <brelse>
}
8010128a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010128d:	89 f0                	mov    %esi,%eax
8010128f:	5b                   	pop    %ebx
80101290:	5e                   	pop    %esi
80101291:	5f                   	pop    %edi
80101292:	5d                   	pop    %ebp
80101293:	c3                   	ret    
80101294:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010129b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010129f:	90                   	nop

801012a0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012a0:	55                   	push   %ebp
801012a1:	89 e5                	mov    %esp,%ebp
801012a3:	57                   	push   %edi
801012a4:	89 c7                	mov    %eax,%edi
801012a6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012a7:	31 f6                	xor    %esi,%esi
{
801012a9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012aa:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
801012af:	83 ec 28             	sub    $0x28,%esp
801012b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012b5:	68 e0 09 11 80       	push   $0x801109e0
801012ba:	e8 01 32 00 00       	call   801044c0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801012c2:	83 c4 10             	add    $0x10,%esp
801012c5:	eb 1b                	jmp    801012e2 <iget+0x42>
801012c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012ce:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012d0:	39 3b                	cmp    %edi,(%ebx)
801012d2:	74 6c                	je     80101340 <iget+0xa0>
801012d4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012da:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012e0:	73 26                	jae    80101308 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012e2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012e5:	85 c9                	test   %ecx,%ecx
801012e7:	7f e7                	jg     801012d0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012e9:	85 f6                	test   %esi,%esi
801012eb:	75 e7                	jne    801012d4 <iget+0x34>
801012ed:	89 d8                	mov    %ebx,%eax
801012ef:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012f5:	85 c9                	test   %ecx,%ecx
801012f7:	75 6e                	jne    80101367 <iget+0xc7>
801012f9:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fb:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101301:	72 df                	jb     801012e2 <iget+0x42>
80101303:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101307:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101308:	85 f6                	test   %esi,%esi
8010130a:	74 73                	je     8010137f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010130c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010130f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101311:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101314:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010131b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101322:	68 e0 09 11 80       	push   $0x801109e0
80101327:	e8 b4 32 00 00       	call   801045e0 <release>

  return ip;
8010132c:	83 c4 10             	add    $0x10,%esp
}
8010132f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101332:	89 f0                	mov    %esi,%eax
80101334:	5b                   	pop    %ebx
80101335:	5e                   	pop    %esi
80101336:	5f                   	pop    %edi
80101337:	5d                   	pop    %ebp
80101338:	c3                   	ret    
80101339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101340:	39 53 04             	cmp    %edx,0x4(%ebx)
80101343:	75 8f                	jne    801012d4 <iget+0x34>
      release(&icache.lock);
80101345:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101348:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010134b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010134d:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
80101352:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101355:	e8 86 32 00 00       	call   801045e0 <release>
      return ip;
8010135a:	83 c4 10             	add    $0x10,%esp
}
8010135d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101360:	89 f0                	mov    %esi,%eax
80101362:	5b                   	pop    %ebx
80101363:	5e                   	pop    %esi
80101364:	5f                   	pop    %edi
80101365:	5d                   	pop    %ebp
80101366:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101367:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010136d:	73 10                	jae    8010137f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010136f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101372:	85 c9                	test   %ecx,%ecx
80101374:	0f 8f 56 ff ff ff    	jg     801012d0 <iget+0x30>
8010137a:	e9 6e ff ff ff       	jmp    801012ed <iget+0x4d>
    panic("iget: no inodes");
8010137f:	83 ec 0c             	sub    $0xc,%esp
80101382:	68 15 71 10 80       	push   $0x80107115
80101387:	e8 f4 ef ff ff       	call   80100380 <panic>
8010138c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101390 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	57                   	push   %edi
80101394:	56                   	push   %esi
80101395:	89 c6                	mov    %eax,%esi
80101397:	53                   	push   %ebx
80101398:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010139b:	83 fa 0b             	cmp    $0xb,%edx
8010139e:	0f 86 84 00 00 00    	jbe    80101428 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801013a4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801013a7:	83 fb 7f             	cmp    $0x7f,%ebx
801013aa:	0f 87 98 00 00 00    	ja     80101448 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801013b0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801013b6:	8b 16                	mov    (%esi),%edx
801013b8:	85 c0                	test   %eax,%eax
801013ba:	74 54                	je     80101410 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013bc:	83 ec 08             	sub    $0x8,%esp
801013bf:	50                   	push   %eax
801013c0:	52                   	push   %edx
801013c1:	e8 0a ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013c6:	83 c4 10             	add    $0x10,%esp
801013c9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
801013cd:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013cf:	8b 1a                	mov    (%edx),%ebx
801013d1:	85 db                	test   %ebx,%ebx
801013d3:	74 1b                	je     801013f0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013d5:	83 ec 0c             	sub    $0xc,%esp
801013d8:	57                   	push   %edi
801013d9:	e8 12 ee ff ff       	call   801001f0 <brelse>
    return addr;
801013de:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
801013e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e4:	89 d8                	mov    %ebx,%eax
801013e6:	5b                   	pop    %ebx
801013e7:	5e                   	pop    %esi
801013e8:	5f                   	pop    %edi
801013e9:	5d                   	pop    %ebp
801013ea:	c3                   	ret    
801013eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013ef:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801013f0:	8b 06                	mov    (%esi),%eax
801013f2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013f5:	e8 96 fd ff ff       	call   80101190 <balloc>
801013fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013fd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101400:	89 c3                	mov    %eax,%ebx
80101402:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101404:	57                   	push   %edi
80101405:	e8 56 1a 00 00       	call   80102e60 <log_write>
8010140a:	83 c4 10             	add    $0x10,%esp
8010140d:	eb c6                	jmp    801013d5 <bmap+0x45>
8010140f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101410:	89 d0                	mov    %edx,%eax
80101412:	e8 79 fd ff ff       	call   80101190 <balloc>
80101417:	8b 16                	mov    (%esi),%edx
80101419:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010141f:	eb 9b                	jmp    801013bc <bmap+0x2c>
80101421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101428:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010142b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010142e:	85 db                	test   %ebx,%ebx
80101430:	75 af                	jne    801013e1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101432:	8b 00                	mov    (%eax),%eax
80101434:	e8 57 fd ff ff       	call   80101190 <balloc>
80101439:	89 47 5c             	mov    %eax,0x5c(%edi)
8010143c:	89 c3                	mov    %eax,%ebx
}
8010143e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101441:	89 d8                	mov    %ebx,%eax
80101443:	5b                   	pop    %ebx
80101444:	5e                   	pop    %esi
80101445:	5f                   	pop    %edi
80101446:	5d                   	pop    %ebp
80101447:	c3                   	ret    
  panic("bmap: out of range");
80101448:	83 ec 0c             	sub    $0xc,%esp
8010144b:	68 25 71 10 80       	push   $0x80107125
80101450:	e8 2b ef ff ff       	call   80100380 <panic>
80101455:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010145c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101460 <readsb>:
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	56                   	push   %esi
80101464:	53                   	push   %ebx
80101465:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101468:	83 ec 08             	sub    $0x8,%esp
8010146b:	6a 01                	push   $0x1
8010146d:	ff 75 08             	pushl  0x8(%ebp)
80101470:	e8 5b ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101475:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101478:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010147a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010147d:	6a 1c                	push   $0x1c
8010147f:	50                   	push   %eax
80101480:	56                   	push   %esi
80101481:	e8 4a 32 00 00       	call   801046d0 <memmove>
  brelse(bp);
80101486:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101489:	83 c4 10             	add    $0x10,%esp
}
8010148c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010148f:	5b                   	pop    %ebx
80101490:	5e                   	pop    %esi
80101491:	5d                   	pop    %ebp
  brelse(bp);
80101492:	e9 59 ed ff ff       	jmp    801001f0 <brelse>
80101497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010149e:	66 90                	xchg   %ax,%ax

801014a0 <bfree>:
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	56                   	push   %esi
801014a4:	89 c6                	mov    %eax,%esi
801014a6:	53                   	push   %ebx
801014a7:	89 d3                	mov    %edx,%ebx
  readsb(dev, &sb);
801014a9:	83 ec 08             	sub    $0x8,%esp
801014ac:	68 c0 09 11 80       	push   $0x801109c0
801014b1:	50                   	push   %eax
801014b2:	e8 a9 ff ff ff       	call   80101460 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014b7:	58                   	pop    %eax
801014b8:	89 d8                	mov    %ebx,%eax
801014ba:	5a                   	pop    %edx
801014bb:	c1 e8 0c             	shr    $0xc,%eax
801014be:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801014c4:	50                   	push   %eax
801014c5:	56                   	push   %esi
801014c6:	e8 05 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801014cb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014cd:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801014d0:	ba 01 00 00 00       	mov    $0x1,%edx
801014d5:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014d8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801014de:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801014e1:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801014e3:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801014e8:	85 d1                	test   %edx,%ecx
801014ea:	74 25                	je     80101511 <bfree+0x71>
  bp->data[bi/8] &= ~m;
801014ec:	f7 d2                	not    %edx
  log_write(bp);
801014ee:	83 ec 0c             	sub    $0xc,%esp
801014f1:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
801014f3:	21 ca                	and    %ecx,%edx
801014f5:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
801014f9:	50                   	push   %eax
801014fa:	e8 61 19 00 00       	call   80102e60 <log_write>
  brelse(bp);
801014ff:	89 34 24             	mov    %esi,(%esp)
80101502:	e8 e9 ec ff ff       	call   801001f0 <brelse>
}
80101507:	83 c4 10             	add    $0x10,%esp
8010150a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010150d:	5b                   	pop    %ebx
8010150e:	5e                   	pop    %esi
8010150f:	5d                   	pop    %ebp
80101510:	c3                   	ret    
    panic("freeing free block");
80101511:	83 ec 0c             	sub    $0xc,%esp
80101514:	68 38 71 10 80       	push   $0x80107138
80101519:	e8 62 ee ff ff       	call   80100380 <panic>
8010151e:	66 90                	xchg   %ax,%ax

80101520 <iinit>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	53                   	push   %ebx
80101524:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101529:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010152c:	68 4b 71 10 80       	push   $0x8010714b
80101531:	68 e0 09 11 80       	push   $0x801109e0
80101536:	e8 85 2e 00 00       	call   801043c0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010153b:	83 c4 10             	add    $0x10,%esp
8010153e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101540:	83 ec 08             	sub    $0x8,%esp
80101543:	68 52 71 10 80       	push   $0x80107152
80101548:	53                   	push   %ebx
80101549:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010154f:	e8 5c 2d 00 00       	call   801042b0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101554:	83 c4 10             	add    $0x10,%esp
80101557:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010155d:	75 e1                	jne    80101540 <iinit+0x20>
  readsb(dev, &sb);
8010155f:	83 ec 08             	sub    $0x8,%esp
80101562:	68 c0 09 11 80       	push   $0x801109c0
80101567:	ff 75 08             	pushl  0x8(%ebp)
8010156a:	e8 f1 fe ff ff       	call   80101460 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010156f:	ff 35 d8 09 11 80    	pushl  0x801109d8
80101575:	ff 35 d4 09 11 80    	pushl  0x801109d4
8010157b:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101581:	ff 35 cc 09 11 80    	pushl  0x801109cc
80101587:	ff 35 c8 09 11 80    	pushl  0x801109c8
8010158d:	ff 35 c4 09 11 80    	pushl  0x801109c4
80101593:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101599:	68 b8 71 10 80       	push   $0x801071b8
8010159e:	e8 fd f0 ff ff       	call   801006a0 <cprintf>
}
801015a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015a6:	83 c4 30             	add    $0x30,%esp
801015a9:	c9                   	leave  
801015aa:	c3                   	ret    
801015ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015af:	90                   	nop

801015b0 <ialloc>:
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	57                   	push   %edi
801015b4:	56                   	push   %esi
801015b5:	53                   	push   %ebx
801015b6:	83 ec 1c             	sub    $0x1c,%esp
801015b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015bc:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
801015c3:	8b 75 08             	mov    0x8(%ebp),%esi
801015c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015c9:	0f 86 91 00 00 00    	jbe    80101660 <ialloc+0xb0>
801015cf:	bf 01 00 00 00       	mov    $0x1,%edi
801015d4:	eb 21                	jmp    801015f7 <ialloc+0x47>
801015d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015dd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801015e0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015e3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801015e6:	53                   	push   %ebx
801015e7:	e8 04 ec ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801015ec:	83 c4 10             	add    $0x10,%esp
801015ef:	3b 3d c8 09 11 80    	cmp    0x801109c8,%edi
801015f5:	73 69                	jae    80101660 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801015f7:	89 f8                	mov    %edi,%eax
801015f9:	83 ec 08             	sub    $0x8,%esp
801015fc:	c1 e8 03             	shr    $0x3,%eax
801015ff:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101605:	50                   	push   %eax
80101606:	56                   	push   %esi
80101607:	e8 c4 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010160c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010160f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101611:	89 f8                	mov    %edi,%eax
80101613:	83 e0 07             	and    $0x7,%eax
80101616:	c1 e0 06             	shl    $0x6,%eax
80101619:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010161d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101621:	75 bd                	jne    801015e0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101623:	83 ec 04             	sub    $0x4,%esp
80101626:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101629:	6a 40                	push   $0x40
8010162b:	6a 00                	push   $0x0
8010162d:	51                   	push   %ecx
8010162e:	e8 fd 2f 00 00       	call   80104630 <memset>
      dip->type = type;
80101633:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101637:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010163a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010163d:	89 1c 24             	mov    %ebx,(%esp)
80101640:	e8 1b 18 00 00       	call   80102e60 <log_write>
      brelse(bp);
80101645:	89 1c 24             	mov    %ebx,(%esp)
80101648:	e8 a3 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010164d:	83 c4 10             	add    $0x10,%esp
}
80101650:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101653:	89 fa                	mov    %edi,%edx
}
80101655:	5b                   	pop    %ebx
      return iget(dev, inum);
80101656:	89 f0                	mov    %esi,%eax
}
80101658:	5e                   	pop    %esi
80101659:	5f                   	pop    %edi
8010165a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010165b:	e9 40 fc ff ff       	jmp    801012a0 <iget>
  panic("ialloc: no inodes");
80101660:	83 ec 0c             	sub    $0xc,%esp
80101663:	68 58 71 10 80       	push   $0x80107158
80101668:	e8 13 ed ff ff       	call   80100380 <panic>
8010166d:	8d 76 00             	lea    0x0(%esi),%esi

80101670 <iupdate>:
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	56                   	push   %esi
80101674:	53                   	push   %ebx
80101675:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101678:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010167b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010167e:	83 ec 08             	sub    $0x8,%esp
80101681:	c1 e8 03             	shr    $0x3,%eax
80101684:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010168a:	50                   	push   %eax
8010168b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010168e:	e8 3d ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101693:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101697:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010169a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010169c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010169f:	83 e0 07             	and    $0x7,%eax
801016a2:	c1 e0 06             	shl    $0x6,%eax
801016a5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016a9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016ac:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016b0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016b3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016b7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016bb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016bf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016c3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016c7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016ca:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cd:	6a 34                	push   $0x34
801016cf:	53                   	push   %ebx
801016d0:	50                   	push   %eax
801016d1:	e8 fa 2f 00 00       	call   801046d0 <memmove>
  log_write(bp);
801016d6:	89 34 24             	mov    %esi,(%esp)
801016d9:	e8 82 17 00 00       	call   80102e60 <log_write>
  brelse(bp);
801016de:	89 75 08             	mov    %esi,0x8(%ebp)
801016e1:	83 c4 10             	add    $0x10,%esp
}
801016e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016e7:	5b                   	pop    %ebx
801016e8:	5e                   	pop    %esi
801016e9:	5d                   	pop    %ebp
  brelse(bp);
801016ea:	e9 01 eb ff ff       	jmp    801001f0 <brelse>
801016ef:	90                   	nop

801016f0 <idup>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	53                   	push   %ebx
801016f4:	83 ec 10             	sub    $0x10,%esp
801016f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016fa:	68 e0 09 11 80       	push   $0x801109e0
801016ff:	e8 bc 2d 00 00       	call   801044c0 <acquire>
  ip->ref++;
80101704:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101708:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010170f:	e8 cc 2e 00 00       	call   801045e0 <release>
}
80101714:	89 d8                	mov    %ebx,%eax
80101716:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101719:	c9                   	leave  
8010171a:	c3                   	ret    
8010171b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010171f:	90                   	nop

80101720 <ilock>:
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	56                   	push   %esi
80101724:	53                   	push   %ebx
80101725:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101728:	85 db                	test   %ebx,%ebx
8010172a:	0f 84 b7 00 00 00    	je     801017e7 <ilock+0xc7>
80101730:	8b 53 08             	mov    0x8(%ebx),%edx
80101733:	85 d2                	test   %edx,%edx
80101735:	0f 8e ac 00 00 00    	jle    801017e7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010173b:	83 ec 0c             	sub    $0xc,%esp
8010173e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101741:	50                   	push   %eax
80101742:	e8 a9 2b 00 00       	call   801042f0 <acquiresleep>
  if(ip->valid == 0){
80101747:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010174a:	83 c4 10             	add    $0x10,%esp
8010174d:	85 c0                	test   %eax,%eax
8010174f:	74 0f                	je     80101760 <ilock+0x40>
}
80101751:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101754:	5b                   	pop    %ebx
80101755:	5e                   	pop    %esi
80101756:	5d                   	pop    %ebp
80101757:	c3                   	ret    
80101758:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010175f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101760:	8b 43 04             	mov    0x4(%ebx),%eax
80101763:	83 ec 08             	sub    $0x8,%esp
80101766:	c1 e8 03             	shr    $0x3,%eax
80101769:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010176f:	50                   	push   %eax
80101770:	ff 33                	pushl  (%ebx)
80101772:	e8 59 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101777:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010177a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010177c:	8b 43 04             	mov    0x4(%ebx),%eax
8010177f:	83 e0 07             	and    $0x7,%eax
80101782:	c1 e0 06             	shl    $0x6,%eax
80101785:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101789:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010178c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010178f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101793:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101797:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010179b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010179f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017a3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017a7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017ab:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ae:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b1:	6a 34                	push   $0x34
801017b3:	50                   	push   %eax
801017b4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017b7:	50                   	push   %eax
801017b8:	e8 13 2f 00 00       	call   801046d0 <memmove>
    brelse(bp);
801017bd:	89 34 24             	mov    %esi,(%esp)
801017c0:	e8 2b ea ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
801017c5:	83 c4 10             	add    $0x10,%esp
801017c8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801017cd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017d4:	0f 85 77 ff ff ff    	jne    80101751 <ilock+0x31>
      panic("ilock: no type");
801017da:	83 ec 0c             	sub    $0xc,%esp
801017dd:	68 70 71 10 80       	push   $0x80107170
801017e2:	e8 99 eb ff ff       	call   80100380 <panic>
    panic("ilock");
801017e7:	83 ec 0c             	sub    $0xc,%esp
801017ea:	68 6a 71 10 80       	push   $0x8010716a
801017ef:	e8 8c eb ff ff       	call   80100380 <panic>
801017f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017ff:	90                   	nop

80101800 <iunlock>:
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	56                   	push   %esi
80101804:	53                   	push   %ebx
80101805:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101808:	85 db                	test   %ebx,%ebx
8010180a:	74 28                	je     80101834 <iunlock+0x34>
8010180c:	83 ec 0c             	sub    $0xc,%esp
8010180f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101812:	56                   	push   %esi
80101813:	e8 78 2b 00 00       	call   80104390 <holdingsleep>
80101818:	83 c4 10             	add    $0x10,%esp
8010181b:	85 c0                	test   %eax,%eax
8010181d:	74 15                	je     80101834 <iunlock+0x34>
8010181f:	8b 43 08             	mov    0x8(%ebx),%eax
80101822:	85 c0                	test   %eax,%eax
80101824:	7e 0e                	jle    80101834 <iunlock+0x34>
  releasesleep(&ip->lock);
80101826:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101829:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010182c:	5b                   	pop    %ebx
8010182d:	5e                   	pop    %esi
8010182e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010182f:	e9 1c 2b 00 00       	jmp    80104350 <releasesleep>
    panic("iunlock");
80101834:	83 ec 0c             	sub    $0xc,%esp
80101837:	68 7f 71 10 80       	push   $0x8010717f
8010183c:	e8 3f eb ff ff       	call   80100380 <panic>
80101841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101848:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010184f:	90                   	nop

80101850 <iput>:
{
80101850:	55                   	push   %ebp
80101851:	89 e5                	mov    %esp,%ebp
80101853:	57                   	push   %edi
80101854:	56                   	push   %esi
80101855:	53                   	push   %ebx
80101856:	83 ec 28             	sub    $0x28,%esp
80101859:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010185c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010185f:	57                   	push   %edi
80101860:	e8 8b 2a 00 00       	call   801042f0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101865:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101868:	83 c4 10             	add    $0x10,%esp
8010186b:	85 d2                	test   %edx,%edx
8010186d:	74 07                	je     80101876 <iput+0x26>
8010186f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101874:	74 32                	je     801018a8 <iput+0x58>
  releasesleep(&ip->lock);
80101876:	83 ec 0c             	sub    $0xc,%esp
80101879:	57                   	push   %edi
8010187a:	e8 d1 2a 00 00       	call   80104350 <releasesleep>
  acquire(&icache.lock);
8010187f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101886:	e8 35 2c 00 00       	call   801044c0 <acquire>
  ip->ref--;
8010188b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010188f:	83 c4 10             	add    $0x10,%esp
80101892:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101899:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010189c:	5b                   	pop    %ebx
8010189d:	5e                   	pop    %esi
8010189e:	5f                   	pop    %edi
8010189f:	5d                   	pop    %ebp
  release(&icache.lock);
801018a0:	e9 3b 2d 00 00       	jmp    801045e0 <release>
801018a5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801018a8:	83 ec 0c             	sub    $0xc,%esp
801018ab:	68 e0 09 11 80       	push   $0x801109e0
801018b0:	e8 0b 2c 00 00       	call   801044c0 <acquire>
    int r = ip->ref;
801018b5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801018b8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018bf:	e8 1c 2d 00 00       	call   801045e0 <release>
    if(r == 1){
801018c4:	83 c4 10             	add    $0x10,%esp
801018c7:	83 fe 01             	cmp    $0x1,%esi
801018ca:	75 aa                	jne    80101876 <iput+0x26>
801018cc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801018d2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018d5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801018d8:	89 cf                	mov    %ecx,%edi
801018da:	eb 0b                	jmp    801018e7 <iput+0x97>
801018dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018e0:	83 c6 04             	add    $0x4,%esi
801018e3:	39 fe                	cmp    %edi,%esi
801018e5:	74 19                	je     80101900 <iput+0xb0>
    if(ip->addrs[i]){
801018e7:	8b 16                	mov    (%esi),%edx
801018e9:	85 d2                	test   %edx,%edx
801018eb:	74 f3                	je     801018e0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801018ed:	8b 03                	mov    (%ebx),%eax
801018ef:	e8 ac fb ff ff       	call   801014a0 <bfree>
      ip->addrs[i] = 0;
801018f4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801018fa:	eb e4                	jmp    801018e0 <iput+0x90>
801018fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101900:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101906:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101909:	85 c0                	test   %eax,%eax
8010190b:	75 33                	jne    80101940 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010190d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101910:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101917:	53                   	push   %ebx
80101918:	e8 53 fd ff ff       	call   80101670 <iupdate>
      ip->type = 0;
8010191d:	31 c0                	xor    %eax,%eax
8010191f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101923:	89 1c 24             	mov    %ebx,(%esp)
80101926:	e8 45 fd ff ff       	call   80101670 <iupdate>
      ip->valid = 0;
8010192b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101932:	83 c4 10             	add    $0x10,%esp
80101935:	e9 3c ff ff ff       	jmp    80101876 <iput+0x26>
8010193a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101940:	83 ec 08             	sub    $0x8,%esp
80101943:	50                   	push   %eax
80101944:	ff 33                	pushl  (%ebx)
80101946:	e8 85 e7 ff ff       	call   801000d0 <bread>
8010194b:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010194e:	83 c4 10             	add    $0x10,%esp
80101951:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101957:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
8010195a:	8d 70 5c             	lea    0x5c(%eax),%esi
8010195d:	89 cf                	mov    %ecx,%edi
8010195f:	eb 0e                	jmp    8010196f <iput+0x11f>
80101961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101968:	83 c6 04             	add    $0x4,%esi
8010196b:	39 f7                	cmp    %esi,%edi
8010196d:	74 11                	je     80101980 <iput+0x130>
      if(a[j])
8010196f:	8b 16                	mov    (%esi),%edx
80101971:	85 d2                	test   %edx,%edx
80101973:	74 f3                	je     80101968 <iput+0x118>
        bfree(ip->dev, a[j]);
80101975:	8b 03                	mov    (%ebx),%eax
80101977:	e8 24 fb ff ff       	call   801014a0 <bfree>
8010197c:	eb ea                	jmp    80101968 <iput+0x118>
8010197e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101980:	83 ec 0c             	sub    $0xc,%esp
80101983:	ff 75 e4             	pushl  -0x1c(%ebp)
80101986:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101989:	e8 62 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010198e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101994:	8b 03                	mov    (%ebx),%eax
80101996:	e8 05 fb ff ff       	call   801014a0 <bfree>
    ip->addrs[NDIRECT] = 0;
8010199b:	83 c4 10             	add    $0x10,%esp
8010199e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019a5:	00 00 00 
801019a8:	e9 60 ff ff ff       	jmp    8010190d <iput+0xbd>
801019ad:	8d 76 00             	lea    0x0(%esi),%esi

801019b0 <iunlockput>:
{
801019b0:	55                   	push   %ebp
801019b1:	89 e5                	mov    %esp,%ebp
801019b3:	53                   	push   %ebx
801019b4:	83 ec 10             	sub    $0x10,%esp
801019b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801019ba:	53                   	push   %ebx
801019bb:	e8 40 fe ff ff       	call   80101800 <iunlock>
  iput(ip);
801019c0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019c3:	83 c4 10             	add    $0x10,%esp
}
801019c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019c9:	c9                   	leave  
  iput(ip);
801019ca:	e9 81 fe ff ff       	jmp    80101850 <iput>
801019cf:	90                   	nop

801019d0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	8b 55 08             	mov    0x8(%ebp),%edx
801019d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019d9:	8b 0a                	mov    (%edx),%ecx
801019db:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019de:	8b 4a 04             	mov    0x4(%edx),%ecx
801019e1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801019e4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801019e8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801019eb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801019ef:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801019f3:	8b 52 58             	mov    0x58(%edx),%edx
801019f6:	89 50 10             	mov    %edx,0x10(%eax)
}
801019f9:	5d                   	pop    %ebp
801019fa:	c3                   	ret    
801019fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019ff:	90                   	nop

80101a00 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a00:	55                   	push   %ebp
80101a01:	89 e5                	mov    %esp,%ebp
80101a03:	57                   	push   %edi
80101a04:	56                   	push   %esi
80101a05:	53                   	push   %ebx
80101a06:	83 ec 1c             	sub    $0x1c,%esp
80101a09:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0f:	8b 75 10             	mov    0x10(%ebp),%esi
80101a12:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a15:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a18:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a1d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a20:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a23:	0f 84 a7 00 00 00    	je     80101ad0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a2c:	8b 40 58             	mov    0x58(%eax),%eax
80101a2f:	39 c6                	cmp    %eax,%esi
80101a31:	0f 87 ba 00 00 00    	ja     80101af1 <readi+0xf1>
80101a37:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a3a:	31 c9                	xor    %ecx,%ecx
80101a3c:	89 da                	mov    %ebx,%edx
80101a3e:	01 f2                	add    %esi,%edx
80101a40:	0f 92 c1             	setb   %cl
80101a43:	89 cf                	mov    %ecx,%edi
80101a45:	0f 82 a6 00 00 00    	jb     80101af1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a4b:	89 c1                	mov    %eax,%ecx
80101a4d:	29 f1                	sub    %esi,%ecx
80101a4f:	39 d0                	cmp    %edx,%eax
80101a51:	0f 43 cb             	cmovae %ebx,%ecx
80101a54:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a57:	85 c9                	test   %ecx,%ecx
80101a59:	74 67                	je     80101ac2 <readi+0xc2>
80101a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a5f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a60:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a63:	89 f2                	mov    %esi,%edx
80101a65:	c1 ea 09             	shr    $0x9,%edx
80101a68:	89 d8                	mov    %ebx,%eax
80101a6a:	e8 21 f9 ff ff       	call   80101390 <bmap>
80101a6f:	83 ec 08             	sub    $0x8,%esp
80101a72:	50                   	push   %eax
80101a73:	ff 33                	pushl  (%ebx)
80101a75:	e8 56 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a7a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a7d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a82:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a85:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a87:	89 f0                	mov    %esi,%eax
80101a89:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a8e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a90:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a93:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a95:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a99:	39 d9                	cmp    %ebx,%ecx
80101a9b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a9e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a9f:	01 df                	add    %ebx,%edi
80101aa1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101aa3:	50                   	push   %eax
80101aa4:	ff 75 e0             	pushl  -0x20(%ebp)
80101aa7:	e8 24 2c 00 00       	call   801046d0 <memmove>
    brelse(bp);
80101aac:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101aaf:	89 14 24             	mov    %edx,(%esp)
80101ab2:	e8 39 e7 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ab7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101aba:	83 c4 10             	add    $0x10,%esp
80101abd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ac0:	77 9e                	ja     80101a60 <readi+0x60>
  }
  return n;
80101ac2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ac5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ac8:	5b                   	pop    %ebx
80101ac9:	5e                   	pop    %esi
80101aca:	5f                   	pop    %edi
80101acb:	5d                   	pop    %ebp
80101acc:	c3                   	ret    
80101acd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ad0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ad4:	66 83 f8 09          	cmp    $0x9,%ax
80101ad8:	77 17                	ja     80101af1 <readi+0xf1>
80101ada:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101ae1:	85 c0                	test   %eax,%eax
80101ae3:	74 0c                	je     80101af1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101ae5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ae8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aeb:	5b                   	pop    %ebx
80101aec:	5e                   	pop    %esi
80101aed:	5f                   	pop    %edi
80101aee:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101aef:	ff e0                	jmp    *%eax
      return -1;
80101af1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101af6:	eb cd                	jmp    80101ac5 <readi+0xc5>
80101af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101aff:	90                   	nop

80101b00 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	57                   	push   %edi
80101b04:	56                   	push   %esi
80101b05:	53                   	push   %ebx
80101b06:	83 ec 1c             	sub    $0x1c,%esp
80101b09:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b0f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b12:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b17:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b1d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b20:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b23:	0f 84 b7 00 00 00    	je     80101be0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b2f:	0f 82 e7 00 00 00    	jb     80101c1c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b35:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b38:	89 f8                	mov    %edi,%eax
80101b3a:	01 f0                	add    %esi,%eax
80101b3c:	0f 82 da 00 00 00    	jb     80101c1c <writei+0x11c>
80101b42:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b47:	0f 87 cf 00 00 00    	ja     80101c1c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b4d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b54:	85 ff                	test   %edi,%edi
80101b56:	74 79                	je     80101bd1 <writei+0xd1>
80101b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b60:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b63:	89 f2                	mov    %esi,%edx
80101b65:	c1 ea 09             	shr    $0x9,%edx
80101b68:	89 f8                	mov    %edi,%eax
80101b6a:	e8 21 f8 ff ff       	call   80101390 <bmap>
80101b6f:	83 ec 08             	sub    $0x8,%esp
80101b72:	50                   	push   %eax
80101b73:	ff 37                	pushl  (%edi)
80101b75:	e8 56 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b7a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b7f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b82:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b85:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b87:	89 f0                	mov    %esi,%eax
80101b89:	83 c4 0c             	add    $0xc,%esp
80101b8c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b91:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b93:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b97:	39 d9                	cmp    %ebx,%ecx
80101b99:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b9c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b9d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b9f:	ff 75 dc             	pushl  -0x24(%ebp)
80101ba2:	50                   	push   %eax
80101ba3:	e8 28 2b 00 00       	call   801046d0 <memmove>
    log_write(bp);
80101ba8:	89 3c 24             	mov    %edi,(%esp)
80101bab:	e8 b0 12 00 00       	call   80102e60 <log_write>
    brelse(bp);
80101bb0:	89 3c 24             	mov    %edi,(%esp)
80101bb3:	e8 38 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bbb:	83 c4 10             	add    $0x10,%esp
80101bbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101bc1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101bc4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101bc7:	77 97                	ja     80101b60 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101bc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bcc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bcf:	77 37                	ja     80101c08 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101bd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101bd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bd7:	5b                   	pop    %ebx
80101bd8:	5e                   	pop    %esi
80101bd9:	5f                   	pop    %edi
80101bda:	5d                   	pop    %ebp
80101bdb:	c3                   	ret    
80101bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101be0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101be4:	66 83 f8 09          	cmp    $0x9,%ax
80101be8:	77 32                	ja     80101c1c <writei+0x11c>
80101bea:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101bf1:	85 c0                	test   %eax,%eax
80101bf3:	74 27                	je     80101c1c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101bf5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101bf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bfb:	5b                   	pop    %ebx
80101bfc:	5e                   	pop    %esi
80101bfd:	5f                   	pop    %edi
80101bfe:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101bff:	ff e0                	jmp    *%eax
80101c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c08:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c0b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c0e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c11:	50                   	push   %eax
80101c12:	e8 59 fa ff ff       	call   80101670 <iupdate>
80101c17:	83 c4 10             	add    $0x10,%esp
80101c1a:	eb b5                	jmp    80101bd1 <writei+0xd1>
      return -1;
80101c1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c21:	eb b1                	jmp    80101bd4 <writei+0xd4>
80101c23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c30 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c30:	55                   	push   %ebp
80101c31:	89 e5                	mov    %esp,%ebp
80101c33:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c36:	6a 0e                	push   $0xe
80101c38:	ff 75 0c             	pushl  0xc(%ebp)
80101c3b:	ff 75 08             	pushl  0x8(%ebp)
80101c3e:	e8 fd 2a 00 00       	call   80104740 <strncmp>
}
80101c43:	c9                   	leave  
80101c44:	c3                   	ret    
80101c45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c50 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	57                   	push   %edi
80101c54:	56                   	push   %esi
80101c55:	53                   	push   %ebx
80101c56:	83 ec 1c             	sub    $0x1c,%esp
80101c59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c5c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c61:	0f 85 85 00 00 00    	jne    80101cec <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c67:	8b 53 58             	mov    0x58(%ebx),%edx
80101c6a:	31 ff                	xor    %edi,%edi
80101c6c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c6f:	85 d2                	test   %edx,%edx
80101c71:	74 3e                	je     80101cb1 <dirlookup+0x61>
80101c73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c77:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c78:	6a 10                	push   $0x10
80101c7a:	57                   	push   %edi
80101c7b:	56                   	push   %esi
80101c7c:	53                   	push   %ebx
80101c7d:	e8 7e fd ff ff       	call   80101a00 <readi>
80101c82:	83 c4 10             	add    $0x10,%esp
80101c85:	83 f8 10             	cmp    $0x10,%eax
80101c88:	75 55                	jne    80101cdf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c8a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c8f:	74 18                	je     80101ca9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c91:	83 ec 04             	sub    $0x4,%esp
80101c94:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c97:	6a 0e                	push   $0xe
80101c99:	50                   	push   %eax
80101c9a:	ff 75 0c             	pushl  0xc(%ebp)
80101c9d:	e8 9e 2a 00 00       	call   80104740 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101ca2:	83 c4 10             	add    $0x10,%esp
80101ca5:	85 c0                	test   %eax,%eax
80101ca7:	74 17                	je     80101cc0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ca9:	83 c7 10             	add    $0x10,%edi
80101cac:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101caf:	72 c7                	jb     80101c78 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101cb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101cb4:	31 c0                	xor    %eax,%eax
}
80101cb6:	5b                   	pop    %ebx
80101cb7:	5e                   	pop    %esi
80101cb8:	5f                   	pop    %edi
80101cb9:	5d                   	pop    %ebp
80101cba:	c3                   	ret    
80101cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101cbf:	90                   	nop
      if(poff)
80101cc0:	8b 45 10             	mov    0x10(%ebp),%eax
80101cc3:	85 c0                	test   %eax,%eax
80101cc5:	74 05                	je     80101ccc <dirlookup+0x7c>
        *poff = off;
80101cc7:	8b 45 10             	mov    0x10(%ebp),%eax
80101cca:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101ccc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101cd0:	8b 03                	mov    (%ebx),%eax
80101cd2:	e8 c9 f5 ff ff       	call   801012a0 <iget>
}
80101cd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cda:	5b                   	pop    %ebx
80101cdb:	5e                   	pop    %esi
80101cdc:	5f                   	pop    %edi
80101cdd:	5d                   	pop    %ebp
80101cde:	c3                   	ret    
      panic("dirlookup read");
80101cdf:	83 ec 0c             	sub    $0xc,%esp
80101ce2:	68 99 71 10 80       	push   $0x80107199
80101ce7:	e8 94 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101cec:	83 ec 0c             	sub    $0xc,%esp
80101cef:	68 87 71 10 80       	push   $0x80107187
80101cf4:	e8 87 e6 ff ff       	call   80100380 <panic>
80101cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d00 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	57                   	push   %edi
80101d04:	56                   	push   %esi
80101d05:	53                   	push   %ebx
80101d06:	89 c3                	mov    %eax,%ebx
80101d08:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d0b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d0e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d11:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d14:	0f 84 86 01 00 00    	je     80101ea0 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d1a:	e8 61 1b 00 00       	call   80103880 <myproc>
  acquire(&icache.lock);
80101d1f:	83 ec 0c             	sub    $0xc,%esp
80101d22:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d24:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d27:	68 e0 09 11 80       	push   $0x801109e0
80101d2c:	e8 8f 27 00 00       	call   801044c0 <acquire>
  ip->ref++;
80101d31:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d35:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101d3c:	e8 9f 28 00 00       	call   801045e0 <release>
80101d41:	83 c4 10             	add    $0x10,%esp
80101d44:	eb 0d                	jmp    80101d53 <namex+0x53>
80101d46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d4d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101d50:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101d53:	0f b6 07             	movzbl (%edi),%eax
80101d56:	3c 2f                	cmp    $0x2f,%al
80101d58:	74 f6                	je     80101d50 <namex+0x50>
  if(*path == 0)
80101d5a:	84 c0                	test   %al,%al
80101d5c:	0f 84 ee 00 00 00    	je     80101e50 <namex+0x150>
  while(*path != '/' && *path != 0)
80101d62:	0f b6 07             	movzbl (%edi),%eax
80101d65:	84 c0                	test   %al,%al
80101d67:	0f 84 fb 00 00 00    	je     80101e68 <namex+0x168>
80101d6d:	89 fb                	mov    %edi,%ebx
80101d6f:	3c 2f                	cmp    $0x2f,%al
80101d71:	0f 84 f1 00 00 00    	je     80101e68 <namex+0x168>
80101d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d7e:	66 90                	xchg   %ax,%ax
80101d80:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101d84:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101d87:	3c 2f                	cmp    $0x2f,%al
80101d89:	74 04                	je     80101d8f <namex+0x8f>
80101d8b:	84 c0                	test   %al,%al
80101d8d:	75 f1                	jne    80101d80 <namex+0x80>
  len = path - s;
80101d8f:	89 d8                	mov    %ebx,%eax
80101d91:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101d93:	83 f8 0d             	cmp    $0xd,%eax
80101d96:	0f 8e 84 00 00 00    	jle    80101e20 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101d9c:	83 ec 04             	sub    $0x4,%esp
80101d9f:	6a 0e                	push   $0xe
80101da1:	57                   	push   %edi
    path++;
80101da2:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101da4:	ff 75 e4             	pushl  -0x1c(%ebp)
80101da7:	e8 24 29 00 00       	call   801046d0 <memmove>
80101dac:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101daf:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101db2:	75 0c                	jne    80101dc0 <namex+0xc0>
80101db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101db8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dbb:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101dbe:	74 f8                	je     80101db8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101dc0:	83 ec 0c             	sub    $0xc,%esp
80101dc3:	56                   	push   %esi
80101dc4:	e8 57 f9 ff ff       	call   80101720 <ilock>
    if(ip->type != T_DIR){
80101dc9:	83 c4 10             	add    $0x10,%esp
80101dcc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101dd1:	0f 85 a1 00 00 00    	jne    80101e78 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101dd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101dda:	85 d2                	test   %edx,%edx
80101ddc:	74 09                	je     80101de7 <namex+0xe7>
80101dde:	80 3f 00             	cmpb   $0x0,(%edi)
80101de1:	0f 84 d9 00 00 00    	je     80101ec0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101de7:	83 ec 04             	sub    $0x4,%esp
80101dea:	6a 00                	push   $0x0
80101dec:	ff 75 e4             	pushl  -0x1c(%ebp)
80101def:	56                   	push   %esi
80101df0:	e8 5b fe ff ff       	call   80101c50 <dirlookup>
80101df5:	83 c4 10             	add    $0x10,%esp
80101df8:	89 c3                	mov    %eax,%ebx
80101dfa:	85 c0                	test   %eax,%eax
80101dfc:	74 7a                	je     80101e78 <namex+0x178>
  iunlock(ip);
80101dfe:	83 ec 0c             	sub    $0xc,%esp
80101e01:	56                   	push   %esi
80101e02:	e8 f9 f9 ff ff       	call   80101800 <iunlock>
  iput(ip);
80101e07:	89 34 24             	mov    %esi,(%esp)
80101e0a:	89 de                	mov    %ebx,%esi
80101e0c:	e8 3f fa ff ff       	call   80101850 <iput>
80101e11:	83 c4 10             	add    $0x10,%esp
80101e14:	e9 3a ff ff ff       	jmp    80101d53 <namex+0x53>
80101e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e23:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e26:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e29:	83 ec 04             	sub    $0x4,%esp
80101e2c:	50                   	push   %eax
80101e2d:	57                   	push   %edi
    name[len] = 0;
80101e2e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101e30:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e33:	e8 98 28 00 00       	call   801046d0 <memmove>
    name[len] = 0;
80101e38:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e3b:	83 c4 10             	add    $0x10,%esp
80101e3e:	c6 00 00             	movb   $0x0,(%eax)
80101e41:	e9 69 ff ff ff       	jmp    80101daf <namex+0xaf>
80101e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e4d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e50:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e53:	85 c0                	test   %eax,%eax
80101e55:	0f 85 85 00 00 00    	jne    80101ee0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e5e:	89 f0                	mov    %esi,%eax
80101e60:	5b                   	pop    %ebx
80101e61:	5e                   	pop    %esi
80101e62:	5f                   	pop    %edi
80101e63:	5d                   	pop    %ebp
80101e64:	c3                   	ret    
80101e65:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e6b:	89 fb                	mov    %edi,%ebx
80101e6d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101e70:	31 c0                	xor    %eax,%eax
80101e72:	eb b5                	jmp    80101e29 <namex+0x129>
80101e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e78:	83 ec 0c             	sub    $0xc,%esp
80101e7b:	56                   	push   %esi
80101e7c:	e8 7f f9 ff ff       	call   80101800 <iunlock>
  iput(ip);
80101e81:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e84:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e86:	e8 c5 f9 ff ff       	call   80101850 <iput>
      return 0;
80101e8b:	83 c4 10             	add    $0x10,%esp
}
80101e8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e91:	89 f0                	mov    %esi,%eax
80101e93:	5b                   	pop    %ebx
80101e94:	5e                   	pop    %esi
80101e95:	5f                   	pop    %edi
80101e96:	5d                   	pop    %ebp
80101e97:	c3                   	ret    
80101e98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e9f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101ea0:	ba 01 00 00 00       	mov    $0x1,%edx
80101ea5:	b8 01 00 00 00       	mov    $0x1,%eax
80101eaa:	89 df                	mov    %ebx,%edi
80101eac:	e8 ef f3 ff ff       	call   801012a0 <iget>
80101eb1:	89 c6                	mov    %eax,%esi
80101eb3:	e9 9b fe ff ff       	jmp    80101d53 <namex+0x53>
80101eb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebf:	90                   	nop
      iunlock(ip);
80101ec0:	83 ec 0c             	sub    $0xc,%esp
80101ec3:	56                   	push   %esi
80101ec4:	e8 37 f9 ff ff       	call   80101800 <iunlock>
      return ip;
80101ec9:	83 c4 10             	add    $0x10,%esp
}
80101ecc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ecf:	89 f0                	mov    %esi,%eax
80101ed1:	5b                   	pop    %ebx
80101ed2:	5e                   	pop    %esi
80101ed3:	5f                   	pop    %edi
80101ed4:	5d                   	pop    %ebp
80101ed5:	c3                   	ret    
80101ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101edd:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101ee0:	83 ec 0c             	sub    $0xc,%esp
80101ee3:	56                   	push   %esi
    return 0;
80101ee4:	31 f6                	xor    %esi,%esi
    iput(ip);
80101ee6:	e8 65 f9 ff ff       	call   80101850 <iput>
    return 0;
80101eeb:	83 c4 10             	add    $0x10,%esp
80101eee:	e9 68 ff ff ff       	jmp    80101e5b <namex+0x15b>
80101ef3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f00 <dirlink>:
{
80101f00:	55                   	push   %ebp
80101f01:	89 e5                	mov    %esp,%ebp
80101f03:	57                   	push   %edi
80101f04:	56                   	push   %esi
80101f05:	53                   	push   %ebx
80101f06:	83 ec 20             	sub    $0x20,%esp
80101f09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f0c:	6a 00                	push   $0x0
80101f0e:	ff 75 0c             	pushl  0xc(%ebp)
80101f11:	53                   	push   %ebx
80101f12:	e8 39 fd ff ff       	call   80101c50 <dirlookup>
80101f17:	83 c4 10             	add    $0x10,%esp
80101f1a:	85 c0                	test   %eax,%eax
80101f1c:	75 67                	jne    80101f85 <dirlink+0x85>
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
80101f33:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f36:	73 19                	jae    80101f51 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f38:	6a 10                	push   $0x10
80101f3a:	57                   	push   %edi
80101f3b:	56                   	push   %esi
80101f3c:	53                   	push   %ebx
80101f3d:	e8 be fa ff ff       	call   80101a00 <readi>
80101f42:	83 c4 10             	add    $0x10,%esp
80101f45:	83 f8 10             	cmp    $0x10,%eax
80101f48:	75 4e                	jne    80101f98 <dirlink+0x98>
    if(de.inum == 0)
80101f4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f4f:	75 df                	jne    80101f30 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101f51:	83 ec 04             	sub    $0x4,%esp
80101f54:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f57:	6a 0e                	push   $0xe
80101f59:	ff 75 0c             	pushl  0xc(%ebp)
80101f5c:	50                   	push   %eax
80101f5d:	e8 2e 28 00 00       	call   80104790 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f62:	6a 10                	push   $0x10
  de.inum = inum;
80101f64:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f67:	57                   	push   %edi
80101f68:	56                   	push   %esi
80101f69:	53                   	push   %ebx
  de.inum = inum;
80101f6a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f6e:	e8 8d fb ff ff       	call   80101b00 <writei>
80101f73:	83 c4 20             	add    $0x20,%esp
80101f76:	83 f8 10             	cmp    $0x10,%eax
80101f79:	75 2a                	jne    80101fa5 <dirlink+0xa5>
  return 0;
80101f7b:	31 c0                	xor    %eax,%eax
}
80101f7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f80:	5b                   	pop    %ebx
80101f81:	5e                   	pop    %esi
80101f82:	5f                   	pop    %edi
80101f83:	5d                   	pop    %ebp
80101f84:	c3                   	ret    
    iput(ip);
80101f85:	83 ec 0c             	sub    $0xc,%esp
80101f88:	50                   	push   %eax
80101f89:	e8 c2 f8 ff ff       	call   80101850 <iput>
    return -1;
80101f8e:	83 c4 10             	add    $0x10,%esp
80101f91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f96:	eb e5                	jmp    80101f7d <dirlink+0x7d>
      panic("dirlink read");
80101f98:	83 ec 0c             	sub    $0xc,%esp
80101f9b:	68 a8 71 10 80       	push   $0x801071a8
80101fa0:	e8 db e3 ff ff       	call   80100380 <panic>
    panic("dirlink");
80101fa5:	83 ec 0c             	sub    $0xc,%esp
80101fa8:	68 06 78 10 80       	push   $0x80107806
80101fad:	e8 ce e3 ff ff       	call   80100380 <panic>
80101fb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fc0 <namei>:

struct inode*
namei(char *path)
{
80101fc0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101fc1:	31 d2                	xor    %edx,%edx
{
80101fc3:	89 e5                	mov    %esp,%ebp
80101fc5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101fc8:	8b 45 08             	mov    0x8(%ebp),%eax
80101fcb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101fce:	e8 2d fd ff ff       	call   80101d00 <namex>
}
80101fd3:	c9                   	leave  
80101fd4:	c3                   	ret    
80101fd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101fe0:	55                   	push   %ebp
  return namex(path, 1, name);
80101fe1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101fe6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101fe8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101feb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fee:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101fef:	e9 0c fd ff ff       	jmp    80101d00 <namex>
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
80102001:	89 e5                	mov    %esp,%ebp
80102003:	57                   	push   %edi
80102004:	56                   	push   %esi
80102005:	53                   	push   %ebx
80102006:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102009:	85 c0                	test   %eax,%eax
8010200b:	0f 84 b4 00 00 00    	je     801020c5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102011:	8b 70 08             	mov    0x8(%eax),%esi
80102014:	89 c3                	mov    %eax,%ebx
80102016:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010201c:	0f 87 96 00 00 00    	ja     801020b8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102022:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010202e:	66 90                	xchg   %ax,%ax
80102030:	89 ca                	mov    %ecx,%edx
80102032:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102033:	83 e0 c0             	and    $0xffffffc0,%eax
80102036:	3c 40                	cmp    $0x40,%al
80102038:	75 f6                	jne    80102030 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010203a:	31 ff                	xor    %edi,%edi
8010203c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102041:	89 f8                	mov    %edi,%eax
80102043:	ee                   	out    %al,(%dx)
80102044:	b8 01 00 00 00       	mov    $0x1,%eax
80102049:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010204e:	ee                   	out    %al,(%dx)
8010204f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102054:	89 f0                	mov    %esi,%eax
80102056:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102057:	89 f0                	mov    %esi,%eax
80102059:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010205e:	c1 f8 08             	sar    $0x8,%eax
80102061:	ee                   	out    %al,(%dx)
80102062:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102067:	89 f8                	mov    %edi,%eax
80102069:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010206a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010206e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102073:	c1 e0 04             	shl    $0x4,%eax
80102076:	83 e0 10             	and    $0x10,%eax
80102079:	83 c8 e0             	or     $0xffffffe0,%eax
8010207c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010207d:	f6 03 04             	testb  $0x4,(%ebx)
80102080:	75 16                	jne    80102098 <idestart+0x98>
80102082:	b8 20 00 00 00       	mov    $0x20,%eax
80102087:	89 ca                	mov    %ecx,%edx
80102089:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010208a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010208d:	5b                   	pop    %ebx
8010208e:	5e                   	pop    %esi
8010208f:	5f                   	pop    %edi
80102090:	5d                   	pop    %ebp
80102091:	c3                   	ret    
80102092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102098:	b8 30 00 00 00       	mov    $0x30,%eax
8010209d:	89 ca                	mov    %ecx,%edx
8010209f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801020a0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801020a5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801020a8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020ad:	fc                   	cld    
801020ae:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801020b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020b3:	5b                   	pop    %ebx
801020b4:	5e                   	pop    %esi
801020b5:	5f                   	pop    %edi
801020b6:	5d                   	pop    %ebp
801020b7:	c3                   	ret    
    panic("incorrect blockno");
801020b8:	83 ec 0c             	sub    $0xc,%esp
801020bb:	68 14 72 10 80       	push   $0x80107214
801020c0:	e8 bb e2 ff ff       	call   80100380 <panic>
    panic("idestart");
801020c5:	83 ec 0c             	sub    $0xc,%esp
801020c8:	68 0b 72 10 80       	push   $0x8010720b
801020cd:	e8 ae e2 ff ff       	call   80100380 <panic>
801020d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020e0 <ideinit>:
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801020e6:	68 26 72 10 80       	push   $0x80107226
801020eb:	68 80 a5 10 80       	push   $0x8010a580
801020f0:	e8 cb 22 00 00       	call   801043c0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801020f5:	58                   	pop    %eax
801020f6:	a1 00 2d 11 80       	mov    0x80112d00,%eax
801020fb:	5a                   	pop    %edx
801020fc:	83 e8 01             	sub    $0x1,%eax
801020ff:	50                   	push   %eax
80102100:	6a 0e                	push   $0xe
80102102:	e8 99 02 00 00       	call   801023a0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102107:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010210a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010210f:	90                   	nop
80102110:	ec                   	in     (%dx),%al
80102111:	83 e0 c0             	and    $0xffffffc0,%eax
80102114:	3c 40                	cmp    $0x40,%al
80102116:	75 f8                	jne    80102110 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102118:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010211d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102122:	ee                   	out    %al,(%dx)
80102123:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102128:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010212d:	eb 06                	jmp    80102135 <ideinit+0x55>
8010212f:	90                   	nop
  for(i=0; i<1000; i++){
80102130:	83 e9 01             	sub    $0x1,%ecx
80102133:	74 0f                	je     80102144 <ideinit+0x64>
80102135:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102136:	84 c0                	test   %al,%al
80102138:	74 f6                	je     80102130 <ideinit+0x50>
      havedisk1 = 1;
8010213a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102141:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102144:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102149:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010214e:	ee                   	out    %al,(%dx)
}
8010214f:	c9                   	leave  
80102150:	c3                   	ret    
80102151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102158:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010215f:	90                   	nop

80102160 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102160:	55                   	push   %ebp
80102161:	89 e5                	mov    %esp,%ebp
80102163:	57                   	push   %edi
80102164:	56                   	push   %esi
80102165:	53                   	push   %ebx
80102166:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102169:	68 80 a5 10 80       	push   $0x8010a580
8010216e:	e8 4d 23 00 00       	call   801044c0 <acquire>

  if((b = idequeue) == 0){
80102173:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102179:	83 c4 10             	add    $0x10,%esp
8010217c:	85 db                	test   %ebx,%ebx
8010217e:	74 63                	je     801021e3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102180:	8b 43 58             	mov    0x58(%ebx),%eax
80102183:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102188:	8b 33                	mov    (%ebx),%esi
8010218a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102190:	75 2f                	jne    801021c1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102192:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010219e:	66 90                	xchg   %ax,%ax
801021a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021a1:	89 c1                	mov    %eax,%ecx
801021a3:	83 e1 c0             	and    $0xffffffc0,%ecx
801021a6:	80 f9 40             	cmp    $0x40,%cl
801021a9:	75 f5                	jne    801021a0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801021ab:	a8 21                	test   $0x21,%al
801021ad:	75 12                	jne    801021c1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801021af:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801021b2:	b9 80 00 00 00       	mov    $0x80,%ecx
801021b7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021bc:	fc                   	cld    
801021bd:	f3 6d                	rep insl (%dx),%es:(%edi)
801021bf:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801021c1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801021c4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801021c7:	83 ce 02             	or     $0x2,%esi
801021ca:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801021cc:	53                   	push   %ebx
801021cd:	e8 1e 1e 00 00       	call   80103ff0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801021d2:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801021d7:	83 c4 10             	add    $0x10,%esp
801021da:	85 c0                	test   %eax,%eax
801021dc:	74 05                	je     801021e3 <ideintr+0x83>
    idestart(idequeue);
801021de:	e8 1d fe ff ff       	call   80102000 <idestart>
    release(&idelock);
801021e3:	83 ec 0c             	sub    $0xc,%esp
801021e6:	68 80 a5 10 80       	push   $0x8010a580
801021eb:	e8 f0 23 00 00       	call   801045e0 <release>

  release(&idelock);
}
801021f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021f3:	5b                   	pop    %ebx
801021f4:	5e                   	pop    %esi
801021f5:	5f                   	pop    %edi
801021f6:	5d                   	pop    %ebp
801021f7:	c3                   	ret    
801021f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ff:	90                   	nop

80102200 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102200:	55                   	push   %ebp
80102201:	89 e5                	mov    %esp,%ebp
80102203:	53                   	push   %ebx
80102204:	83 ec 10             	sub    $0x10,%esp
80102207:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010220a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010220d:	50                   	push   %eax
8010220e:	e8 7d 21 00 00       	call   80104390 <holdingsleep>
80102213:	83 c4 10             	add    $0x10,%esp
80102216:	85 c0                	test   %eax,%eax
80102218:	0f 84 c3 00 00 00    	je     801022e1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010221e:	8b 03                	mov    (%ebx),%eax
80102220:	83 e0 06             	and    $0x6,%eax
80102223:	83 f8 02             	cmp    $0x2,%eax
80102226:	0f 84 a8 00 00 00    	je     801022d4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010222c:	8b 53 04             	mov    0x4(%ebx),%edx
8010222f:	85 d2                	test   %edx,%edx
80102231:	74 0d                	je     80102240 <iderw+0x40>
80102233:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102238:	85 c0                	test   %eax,%eax
8010223a:	0f 84 87 00 00 00    	je     801022c7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102240:	83 ec 0c             	sub    $0xc,%esp
80102243:	68 80 a5 10 80       	push   $0x8010a580
80102248:	e8 73 22 00 00       	call   801044c0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010224d:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
80102252:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 c0                	test   %eax,%eax
8010225e:	74 60                	je     801022c0 <iderw+0xc0>
80102260:	89 c2                	mov    %eax,%edx
80102262:	8b 40 58             	mov    0x58(%eax),%eax
80102265:	85 c0                	test   %eax,%eax
80102267:	75 f7                	jne    80102260 <iderw+0x60>
80102269:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010226c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010226e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80102274:	74 3a                	je     801022b0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102276:	8b 03                	mov    (%ebx),%eax
80102278:	83 e0 06             	and    $0x6,%eax
8010227b:	83 f8 02             	cmp    $0x2,%eax
8010227e:	74 1b                	je     8010229b <iderw+0x9b>
    sleep(b, &idelock);
80102280:	83 ec 08             	sub    $0x8,%esp
80102283:	68 80 a5 10 80       	push   $0x8010a580
80102288:	53                   	push   %ebx
80102289:	e8 b2 1b 00 00       	call   80103e40 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010228e:	8b 03                	mov    (%ebx),%eax
80102290:	83 c4 10             	add    $0x10,%esp
80102293:	83 e0 06             	and    $0x6,%eax
80102296:	83 f8 02             	cmp    $0x2,%eax
80102299:	75 e5                	jne    80102280 <iderw+0x80>
  }


  release(&idelock);
8010229b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801022a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801022a5:	c9                   	leave  
  release(&idelock);
801022a6:	e9 35 23 00 00       	jmp    801045e0 <release>
801022ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022af:	90                   	nop
    idestart(b);
801022b0:	89 d8                	mov    %ebx,%eax
801022b2:	e8 49 fd ff ff       	call   80102000 <idestart>
801022b7:	eb bd                	jmp    80102276 <iderw+0x76>
801022b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022c0:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801022c5:	eb a5                	jmp    8010226c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801022c7:	83 ec 0c             	sub    $0xc,%esp
801022ca:	68 55 72 10 80       	push   $0x80107255
801022cf:	e8 ac e0 ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801022d4:	83 ec 0c             	sub    $0xc,%esp
801022d7:	68 40 72 10 80       	push   $0x80107240
801022dc:	e8 9f e0 ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801022e1:	83 ec 0c             	sub    $0xc,%esp
801022e4:	68 2a 72 10 80       	push   $0x8010722a
801022e9:	e8 92 e0 ff ff       	call   80100380 <panic>
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
{
801022fb:	89 e5                	mov    %esp,%ebp
801022fd:	56                   	push   %esi
801022fe:	53                   	push   %ebx
  ioapic->reg = reg;
801022ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102306:	00 00 00 
  return ioapic->data;
80102309:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010230f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102312:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102318:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010231e:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102325:	c1 ee 10             	shr    $0x10,%esi
80102328:	89 f0                	mov    %esi,%eax
8010232a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010232d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102330:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102333:	39 c2                	cmp    %eax,%edx
80102335:	74 16                	je     8010234d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102337:	83 ec 0c             	sub    $0xc,%esp
8010233a:	68 74 72 10 80       	push   $0x80107274
8010233f:	e8 5c e3 ff ff       	call   801006a0 <cprintf>
80102344:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010234a:	83 c4 10             	add    $0x10,%esp
8010234d:	83 c6 21             	add    $0x21,%esi
{
80102350:	ba 10 00 00 00       	mov    $0x10,%edx
80102355:	b8 20 00 00 00       	mov    $0x20,%eax
8010235a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102360:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102362:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102364:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010236a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010236d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102373:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102376:	8d 5a 01             	lea    0x1(%edx),%ebx
80102379:	83 c2 02             	add    $0x2,%edx
8010237c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010237e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102384:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010238b:	39 f0                	cmp    %esi,%eax
8010238d:	75 d1                	jne    80102360 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010238f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102392:	5b                   	pop    %ebx
80102393:	5e                   	pop    %esi
80102394:	5d                   	pop    %ebp
80102395:	c3                   	ret    
80102396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010239d:	8d 76 00             	lea    0x0(%esi),%esi

801023a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801023a0:	55                   	push   %ebp
  ioapic->reg = reg;
801023a1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801023a7:	89 e5                	mov    %esp,%ebp
801023a9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801023ac:	8d 50 20             	lea    0x20(%eax),%edx
801023af:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801023b3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023b5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023bb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801023be:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801023c4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023c6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023cb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801023ce:	89 50 10             	mov    %edx,0x10(%eax)
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
801023f0:	75 76                	jne    80102468 <kfree+0x88>
801023f2:	81 fb a8 55 11 80    	cmp    $0x801155a8,%ebx
801023f8:	72 6e                	jb     80102468 <kfree+0x88>
801023fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102400:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102405:	77 61                	ja     80102468 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102407:	83 ec 04             	sub    $0x4,%esp
8010240a:	68 00 10 00 00       	push   $0x1000
8010240f:	6a 01                	push   $0x1
80102411:	53                   	push   %ebx
80102412:	e8 19 22 00 00       	call   80104630 <memset>

  if(kmem.use_lock)
80102417:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010241d:	83 c4 10             	add    $0x10,%esp
80102420:	85 d2                	test   %edx,%edx
80102422:	75 1c                	jne    80102440 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102424:	a1 78 26 11 80       	mov    0x80112678,%eax
80102429:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010242b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102430:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102436:	85 c0                	test   %eax,%eax
80102438:	75 1e                	jne    80102458 <kfree+0x78>
    release(&kmem.lock);
}
8010243a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010243d:	c9                   	leave  
8010243e:	c3                   	ret    
8010243f:	90                   	nop
    acquire(&kmem.lock);
80102440:	83 ec 0c             	sub    $0xc,%esp
80102443:	68 40 26 11 80       	push   $0x80112640
80102448:	e8 73 20 00 00       	call   801044c0 <acquire>
8010244d:	83 c4 10             	add    $0x10,%esp
80102450:	eb d2                	jmp    80102424 <kfree+0x44>
80102452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102458:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010245f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102462:	c9                   	leave  
    release(&kmem.lock);
80102463:	e9 78 21 00 00       	jmp    801045e0 <release>
    panic("kfree");
80102468:	83 ec 0c             	sub    $0xc,%esp
8010246b:	68 a6 72 10 80       	push   $0x801072a6
80102470:	e8 0b df ff ff       	call   80100380 <panic>
80102475:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102480 <freerange>:
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102484:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102487:	8b 75 0c             	mov    0xc(%ebp),%esi
8010248a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010248b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102491:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102497:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010249d:	39 de                	cmp    %ebx,%esi
8010249f:	72 23                	jb     801024c4 <freerange+0x44>
801024a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024a8:	83 ec 0c             	sub    $0xc,%esp
801024ab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024b7:	50                   	push   %eax
801024b8:	e8 23 ff ff ff       	call   801023e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024bd:	83 c4 10             	add    $0x10,%esp
801024c0:	39 f3                	cmp    %esi,%ebx
801024c2:	76 e4                	jbe    801024a8 <freerange+0x28>
}
801024c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024c7:	5b                   	pop    %ebx
801024c8:	5e                   	pop    %esi
801024c9:	5d                   	pop    %ebp
801024ca:	c3                   	ret    
801024cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024cf:	90                   	nop

801024d0 <kinit1>:
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	56                   	push   %esi
801024d4:	53                   	push   %ebx
801024d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801024d8:	83 ec 08             	sub    $0x8,%esp
801024db:	68 ac 72 10 80       	push   $0x801072ac
801024e0:	68 40 26 11 80       	push   $0x80112640
801024e5:	e8 d6 1e 00 00       	call   801043c0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801024ea:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024ed:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801024f0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801024f7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801024fa:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102500:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102506:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010250c:	39 de                	cmp    %ebx,%esi
8010250e:	72 1c                	jb     8010252c <kinit1+0x5c>
    kfree(p);
80102510:	83 ec 0c             	sub    $0xc,%esp
80102513:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102519:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010251f:	50                   	push   %eax
80102520:	e8 bb fe ff ff       	call   801023e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102525:	83 c4 10             	add    $0x10,%esp
80102528:	39 de                	cmp    %ebx,%esi
8010252a:	73 e4                	jae    80102510 <kinit1+0x40>
}
8010252c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010252f:	5b                   	pop    %ebx
80102530:	5e                   	pop    %esi
80102531:	5d                   	pop    %ebp
80102532:	c3                   	ret    
80102533:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010253a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102540 <kinit2>:
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102544:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102547:	8b 75 0c             	mov    0xc(%ebp),%esi
8010254a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010254b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102551:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102557:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010255d:	39 de                	cmp    %ebx,%esi
8010255f:	72 23                	jb     80102584 <kinit2+0x44>
80102561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102568:	83 ec 0c             	sub    $0xc,%esp
8010256b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102571:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102577:	50                   	push   %eax
80102578:	e8 63 fe ff ff       	call   801023e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	39 de                	cmp    %ebx,%esi
80102582:	73 e4                	jae    80102568 <kinit2+0x28>
  kmem.use_lock = 1;
80102584:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010258b:	00 00 00 
}
8010258e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102591:	5b                   	pop    %ebx
80102592:	5e                   	pop    %esi
80102593:	5d                   	pop    %ebp
80102594:	c3                   	ret    
80102595:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010259c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025a0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801025a0:	a1 74 26 11 80       	mov    0x80112674,%eax
801025a5:	85 c0                	test   %eax,%eax
801025a7:	75 1f                	jne    801025c8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801025a9:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
801025ae:	85 c0                	test   %eax,%eax
801025b0:	74 0e                	je     801025c0 <kalloc+0x20>
    kmem.freelist = r->next;
801025b2:	8b 10                	mov    (%eax),%edx
801025b4:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801025ba:	c3                   	ret    
801025bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025bf:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801025c0:	c3                   	ret    
801025c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801025c8:	55                   	push   %ebp
801025c9:	89 e5                	mov    %esp,%ebp
801025cb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801025ce:	68 40 26 11 80       	push   $0x80112640
801025d3:	e8 e8 1e 00 00       	call   801044c0 <acquire>
  r = kmem.freelist;
801025d8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
801025dd:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801025e3:	83 c4 10             	add    $0x10,%esp
801025e6:	85 c0                	test   %eax,%eax
801025e8:	74 08                	je     801025f2 <kalloc+0x52>
    kmem.freelist = r->next;
801025ea:	8b 08                	mov    (%eax),%ecx
801025ec:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801025f2:	85 d2                	test   %edx,%edx
801025f4:	74 16                	je     8010260c <kalloc+0x6c>
    release(&kmem.lock);
801025f6:	83 ec 0c             	sub    $0xc,%esp
801025f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801025fc:	68 40 26 11 80       	push   $0x80112640
80102601:	e8 da 1f 00 00       	call   801045e0 <release>
  return (char*)r;
80102606:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102609:	83 c4 10             	add    $0x10,%esp
}
8010260c:	c9                   	leave  
8010260d:	c3                   	ret    
8010260e:	66 90                	xchg   %ax,%ax

80102610 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102610:	ba 64 00 00 00       	mov    $0x64,%edx
80102615:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102616:	a8 01                	test   $0x1,%al
80102618:	0f 84 c2 00 00 00    	je     801026e0 <kbdgetc+0xd0>
{
8010261e:	55                   	push   %ebp
8010261f:	ba 60 00 00 00       	mov    $0x60,%edx
80102624:	89 e5                	mov    %esp,%ebp
80102626:	53                   	push   %ebx
80102627:	ec                   	in     (%dx),%al
  return data;
80102628:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
    return -1;
  data = inb(KBDATAP);
8010262e:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102631:	3c e0                	cmp    $0xe0,%al
80102633:	74 5b                	je     80102690 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102635:	89 d9                	mov    %ebx,%ecx
80102637:	83 e1 40             	and    $0x40,%ecx
8010263a:	84 c0                	test   %al,%al
8010263c:	78 62                	js     801026a0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010263e:	85 c9                	test   %ecx,%ecx
80102640:	74 09                	je     8010264b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102642:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102645:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102648:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
8010264b:	0f b6 8a e0 73 10 80 	movzbl -0x7fef8c20(%edx),%ecx
  shift ^= togglecode[data];
80102652:	0f b6 82 e0 72 10 80 	movzbl -0x7fef8d20(%edx),%eax
  shift |= shiftcode[data];
80102659:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010265b:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010265d:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
8010265f:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102665:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102668:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010266b:	8b 04 85 c0 72 10 80 	mov    -0x7fef8d40(,%eax,4),%eax
80102672:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102676:	74 0b                	je     80102683 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102678:	8d 50 9f             	lea    -0x61(%eax),%edx
8010267b:	83 fa 19             	cmp    $0x19,%edx
8010267e:	77 48                	ja     801026c8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102680:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102683:	5b                   	pop    %ebx
80102684:	5d                   	pop    %ebp
80102685:	c3                   	ret    
80102686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010268d:	8d 76 00             	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102690:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102693:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102695:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
8010269b:	5b                   	pop    %ebx
8010269c:	5d                   	pop    %ebp
8010269d:	c3                   	ret    
8010269e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801026a0:	83 e0 7f             	and    $0x7f,%eax
801026a3:	85 c9                	test   %ecx,%ecx
801026a5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
801026a8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801026aa:	0f b6 8a e0 73 10 80 	movzbl -0x7fef8c20(%edx),%ecx
801026b1:	83 c9 40             	or     $0x40,%ecx
801026b4:	0f b6 c9             	movzbl %cl,%ecx
801026b7:	f7 d1                	not    %ecx
801026b9:	21 d9                	and    %ebx,%ecx
}
801026bb:	5b                   	pop    %ebx
801026bc:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
801026bd:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
801026c3:	c3                   	ret    
801026c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801026c8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801026cb:	8d 50 20             	lea    0x20(%eax),%edx
}
801026ce:	5b                   	pop    %ebx
801026cf:	5d                   	pop    %ebp
      c += 'a' - 'A';
801026d0:	83 f9 1a             	cmp    $0x1a,%ecx
801026d3:	0f 42 c2             	cmovb  %edx,%eax
}
801026d6:	c3                   	ret    
801026d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026de:	66 90                	xchg   %ax,%ax
    return -1;
801026e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801026e5:	c3                   	ret    
801026e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026ed:	8d 76 00             	lea    0x0(%esi),%esi

801026f0 <kbdintr>:

void
kbdintr(void)
{
801026f0:	55                   	push   %ebp
801026f1:	89 e5                	mov    %esp,%ebp
801026f3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801026f6:	68 10 26 10 80       	push   $0x80102610
801026fb:	e8 50 e1 ff ff       	call   80100850 <consoleintr>
}
80102700:	83 c4 10             	add    $0x10,%esp
80102703:	c9                   	leave  
80102704:	c3                   	ret    
80102705:	66 90                	xchg   %ax,%ax
80102707:	66 90                	xchg   %ax,%ax
80102709:	66 90                	xchg   %ax,%ax
8010270b:	66 90                	xchg   %ax,%ax
8010270d:	66 90                	xchg   %ax,%ax
8010270f:	90                   	nop

80102710 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102710:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102715:	85 c0                	test   %eax,%eax
80102717:	0f 84 cb 00 00 00    	je     801027e8 <lapicinit+0xd8>
  lapic[index] = value;
8010271d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102724:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102727:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010272a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102731:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102734:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102737:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010273e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102741:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102744:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010274b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010274e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102751:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102758:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010275b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010275e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102765:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102768:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010276b:	8b 50 30             	mov    0x30(%eax),%edx
8010276e:	c1 ea 10             	shr    $0x10,%edx
80102771:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102777:	75 77                	jne    801027f0 <lapicinit+0xe0>
  lapic[index] = value;
80102779:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102780:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102783:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102786:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010278d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102790:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102793:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010279a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010279d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027a0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027a7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027aa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ad:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801027b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ba:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801027c1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801027c4:	8b 50 20             	mov    0x20(%eax),%edx
801027c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ce:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801027d0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801027d6:	80 e6 10             	and    $0x10,%dh
801027d9:	75 f5                	jne    801027d0 <lapicinit+0xc0>
  lapic[index] = value;
801027db:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801027e2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801027e8:	c3                   	ret    
801027e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801027f0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801027f7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027fa:	8b 50 20             	mov    0x20(%eax),%edx
}
801027fd:	e9 77 ff ff ff       	jmp    80102779 <lapicinit+0x69>
80102802:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102810 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102810:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102815:	85 c0                	test   %eax,%eax
80102817:	74 07                	je     80102820 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102819:	8b 40 20             	mov    0x20(%eax),%eax
8010281c:	c1 e8 18             	shr    $0x18,%eax
8010281f:	c3                   	ret    
    return 0;
80102820:	31 c0                	xor    %eax,%eax
}
80102822:	c3                   	ret    
80102823:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010282a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102830 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102830:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102835:	85 c0                	test   %eax,%eax
80102837:	74 0d                	je     80102846 <lapiceoi+0x16>
  lapic[index] = value;
80102839:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102840:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102843:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102846:	c3                   	ret    
80102847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010284e:	66 90                	xchg   %ax,%ax

80102850 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102850:	c3                   	ret    
80102851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102858:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010285f:	90                   	nop

80102860 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102860:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102861:	b8 0f 00 00 00       	mov    $0xf,%eax
80102866:	ba 70 00 00 00       	mov    $0x70,%edx
8010286b:	89 e5                	mov    %esp,%ebp
8010286d:	53                   	push   %ebx
8010286e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102871:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102874:	ee                   	out    %al,(%dx)
80102875:	b8 0a 00 00 00       	mov    $0xa,%eax
8010287a:	ba 71 00 00 00       	mov    $0x71,%edx
8010287f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102880:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102882:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102885:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010288b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010288d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102890:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102892:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102895:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102898:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010289e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028a3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028a9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028ac:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801028b3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028b6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028b9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801028c0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028c6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028cc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028cf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028d5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028d8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028e1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
801028e7:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
801028e8:	8b 40 20             	mov    0x20(%eax),%eax
}
801028eb:	5d                   	pop    %ebp
801028ec:	c3                   	ret    
801028ed:	8d 76 00             	lea    0x0(%esi),%esi

801028f0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801028f0:	55                   	push   %ebp
801028f1:	b8 0b 00 00 00       	mov    $0xb,%eax
801028f6:	ba 70 00 00 00       	mov    $0x70,%edx
801028fb:	89 e5                	mov    %esp,%ebp
801028fd:	57                   	push   %edi
801028fe:	56                   	push   %esi
801028ff:	53                   	push   %ebx
80102900:	83 ec 4c             	sub    $0x4c,%esp
80102903:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102904:	ba 71 00 00 00       	mov    $0x71,%edx
80102909:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010290a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010290d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102912:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102915:	8d 76 00             	lea    0x0(%esi),%esi
80102918:	31 c0                	xor    %eax,%eax
8010291a:	89 da                	mov    %ebx,%edx
8010291c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010291d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102922:	89 ca                	mov    %ecx,%edx
80102924:	ec                   	in     (%dx),%al
80102925:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102928:	89 da                	mov    %ebx,%edx
8010292a:	b8 02 00 00 00       	mov    $0x2,%eax
8010292f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102930:	89 ca                	mov    %ecx,%edx
80102932:	ec                   	in     (%dx),%al
80102933:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102936:	89 da                	mov    %ebx,%edx
80102938:	b8 04 00 00 00       	mov    $0x4,%eax
8010293d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010293e:	89 ca                	mov    %ecx,%edx
80102940:	ec                   	in     (%dx),%al
80102941:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102944:	89 da                	mov    %ebx,%edx
80102946:	b8 07 00 00 00       	mov    $0x7,%eax
8010294b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010294c:	89 ca                	mov    %ecx,%edx
8010294e:	ec                   	in     (%dx),%al
8010294f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102952:	89 da                	mov    %ebx,%edx
80102954:	b8 08 00 00 00       	mov    $0x8,%eax
80102959:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010295a:	89 ca                	mov    %ecx,%edx
8010295c:	ec                   	in     (%dx),%al
8010295d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010295f:	89 da                	mov    %ebx,%edx
80102961:	b8 09 00 00 00       	mov    $0x9,%eax
80102966:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102967:	89 ca                	mov    %ecx,%edx
80102969:	ec                   	in     (%dx),%al
8010296a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010296c:	89 da                	mov    %ebx,%edx
8010296e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102973:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102974:	89 ca                	mov    %ecx,%edx
80102976:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102977:	84 c0                	test   %al,%al
80102979:	78 9d                	js     80102918 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010297b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010297f:	89 fa                	mov    %edi,%edx
80102981:	0f b6 fa             	movzbl %dl,%edi
80102984:	89 f2                	mov    %esi,%edx
80102986:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102989:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
8010298d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102990:	89 da                	mov    %ebx,%edx
80102992:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102995:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102998:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010299c:	89 75 cc             	mov    %esi,-0x34(%ebp)
8010299f:	89 45 c0             	mov    %eax,-0x40(%ebp)
801029a2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801029a6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801029a9:	31 c0                	xor    %eax,%eax
801029ab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ac:	89 ca                	mov    %ecx,%edx
801029ae:	ec                   	in     (%dx),%al
801029af:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b2:	89 da                	mov    %ebx,%edx
801029b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801029b7:	b8 02 00 00 00       	mov    $0x2,%eax
801029bc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029bd:	89 ca                	mov    %ecx,%edx
801029bf:	ec                   	in     (%dx),%al
801029c0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c3:	89 da                	mov    %ebx,%edx
801029c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801029c8:	b8 04 00 00 00       	mov    $0x4,%eax
801029cd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ce:	89 ca                	mov    %ecx,%edx
801029d0:	ec                   	in     (%dx),%al
801029d1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d4:	89 da                	mov    %ebx,%edx
801029d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801029d9:	b8 07 00 00 00       	mov    $0x7,%eax
801029de:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029df:	89 ca                	mov    %ecx,%edx
801029e1:	ec                   	in     (%dx),%al
801029e2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e5:	89 da                	mov    %ebx,%edx
801029e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801029ea:	b8 08 00 00 00       	mov    $0x8,%eax
801029ef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f0:	89 ca                	mov    %ecx,%edx
801029f2:	ec                   	in     (%dx),%al
801029f3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f6:	89 da                	mov    %ebx,%edx
801029f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801029fb:	b8 09 00 00 00       	mov    $0x9,%eax
80102a00:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a01:	89 ca                	mov    %ecx,%edx
80102a03:	ec                   	in     (%dx),%al
80102a04:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a07:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102a0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a0d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102a10:	6a 18                	push   $0x18
80102a12:	50                   	push   %eax
80102a13:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102a16:	50                   	push   %eax
80102a17:	e8 64 1c 00 00       	call   80104680 <memcmp>
80102a1c:	83 c4 10             	add    $0x10,%esp
80102a1f:	85 c0                	test   %eax,%eax
80102a21:	0f 85 f1 fe ff ff    	jne    80102918 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102a27:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102a2b:	75 78                	jne    80102aa5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102a2d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a30:	89 c2                	mov    %eax,%edx
80102a32:	83 e0 0f             	and    $0xf,%eax
80102a35:	c1 ea 04             	shr    $0x4,%edx
80102a38:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a3b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a3e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102a41:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a44:	89 c2                	mov    %eax,%edx
80102a46:	83 e0 0f             	and    $0xf,%eax
80102a49:	c1 ea 04             	shr    $0x4,%edx
80102a4c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a4f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a52:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102a55:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a58:	89 c2                	mov    %eax,%edx
80102a5a:	83 e0 0f             	and    $0xf,%eax
80102a5d:	c1 ea 04             	shr    $0x4,%edx
80102a60:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a63:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a66:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102a69:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a6c:	89 c2                	mov    %eax,%edx
80102a6e:	83 e0 0f             	and    $0xf,%eax
80102a71:	c1 ea 04             	shr    $0x4,%edx
80102a74:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a77:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a7a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102a7d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a80:	89 c2                	mov    %eax,%edx
80102a82:	83 e0 0f             	and    $0xf,%eax
80102a85:	c1 ea 04             	shr    $0x4,%edx
80102a88:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a8b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a8e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102a91:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a94:	89 c2                	mov    %eax,%edx
80102a96:	83 e0 0f             	and    $0xf,%eax
80102a99:	c1 ea 04             	shr    $0x4,%edx
80102a9c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a9f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102aa2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102aa5:	8b 75 08             	mov    0x8(%ebp),%esi
80102aa8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102aab:	89 06                	mov    %eax,(%esi)
80102aad:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ab0:	89 46 04             	mov    %eax,0x4(%esi)
80102ab3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ab6:	89 46 08             	mov    %eax,0x8(%esi)
80102ab9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102abc:	89 46 0c             	mov    %eax,0xc(%esi)
80102abf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ac2:	89 46 10             	mov    %eax,0x10(%esi)
80102ac5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ac8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102acb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102ad2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ad5:	5b                   	pop    %ebx
80102ad6:	5e                   	pop    %esi
80102ad7:	5f                   	pop    %edi
80102ad8:	5d                   	pop    %ebp
80102ad9:	c3                   	ret    
80102ada:	66 90                	xchg   %ax,%ax
80102adc:	66 90                	xchg   %ax,%ax
80102ade:	66 90                	xchg   %ax,%ax

80102ae0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ae0:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102ae6:	85 c9                	test   %ecx,%ecx
80102ae8:	0f 8e 8a 00 00 00    	jle    80102b78 <install_trans+0x98>
{
80102aee:	55                   	push   %ebp
80102aef:	89 e5                	mov    %esp,%ebp
80102af1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102af2:	31 ff                	xor    %edi,%edi
{
80102af4:	56                   	push   %esi
80102af5:	53                   	push   %ebx
80102af6:	83 ec 0c             	sub    $0xc,%esp
80102af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102b00:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102b05:	83 ec 08             	sub    $0x8,%esp
80102b08:	01 f8                	add    %edi,%eax
80102b0a:	83 c0 01             	add    $0x1,%eax
80102b0d:	50                   	push   %eax
80102b0e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102b14:	e8 b7 d5 ff ff       	call   801000d0 <bread>
80102b19:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b1b:	58                   	pop    %eax
80102b1c:	5a                   	pop    %edx
80102b1d:	ff 34 bd cc 26 11 80 	pushl  -0x7feed934(,%edi,4)
80102b24:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102b2a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b2d:	e8 9e d5 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b32:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b35:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b37:	8d 46 5c             	lea    0x5c(%esi),%eax
80102b3a:	68 00 02 00 00       	push   $0x200
80102b3f:	50                   	push   %eax
80102b40:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102b43:	50                   	push   %eax
80102b44:	e8 87 1b 00 00       	call   801046d0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102b49:	89 1c 24             	mov    %ebx,(%esp)
80102b4c:	e8 5f d6 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102b51:	89 34 24             	mov    %esi,(%esp)
80102b54:	e8 97 d6 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102b59:	89 1c 24             	mov    %ebx,(%esp)
80102b5c:	e8 8f d6 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102b61:	83 c4 10             	add    $0x10,%esp
80102b64:	39 3d c8 26 11 80    	cmp    %edi,0x801126c8
80102b6a:	7f 94                	jg     80102b00 <install_trans+0x20>
  }
}
80102b6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b6f:	5b                   	pop    %ebx
80102b70:	5e                   	pop    %esi
80102b71:	5f                   	pop    %edi
80102b72:	5d                   	pop    %ebp
80102b73:	c3                   	ret    
80102b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b78:	c3                   	ret    
80102b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102b80 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	53                   	push   %ebx
80102b84:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102b87:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102b8d:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102b93:	e8 38 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102b98:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102b9b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102b9d:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102ba2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102ba5:	85 c0                	test   %eax,%eax
80102ba7:	7e 19                	jle    80102bc2 <write_head+0x42>
80102ba9:	31 d2                	xor    %edx,%edx
80102bab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102baf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102bb0:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102bb7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102bbb:	83 c2 01             	add    $0x1,%edx
80102bbe:	39 d0                	cmp    %edx,%eax
80102bc0:	75 ee                	jne    80102bb0 <write_head+0x30>
  }
  bwrite(buf);
80102bc2:	83 ec 0c             	sub    $0xc,%esp
80102bc5:	53                   	push   %ebx
80102bc6:	e8 e5 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102bcb:	89 1c 24             	mov    %ebx,(%esp)
80102bce:	e8 1d d6 ff ff       	call   801001f0 <brelse>
}
80102bd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bd6:	83 c4 10             	add    $0x10,%esp
80102bd9:	c9                   	leave  
80102bda:	c3                   	ret    
80102bdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bdf:	90                   	nop

80102be0 <initlog>:
{
80102be0:	55                   	push   %ebp
80102be1:	89 e5                	mov    %esp,%ebp
80102be3:	53                   	push   %ebx
80102be4:	83 ec 2c             	sub    $0x2c,%esp
80102be7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102bea:	68 e0 74 10 80       	push   $0x801074e0
80102bef:	68 80 26 11 80       	push   $0x80112680
80102bf4:	e8 c7 17 00 00       	call   801043c0 <initlock>
  readsb(dev, &sb);
80102bf9:	58                   	pop    %eax
80102bfa:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102bfd:	5a                   	pop    %edx
80102bfe:	50                   	push   %eax
80102bff:	53                   	push   %ebx
80102c00:	e8 5b e8 ff ff       	call   80101460 <readsb>
  log.start = sb.logstart;
80102c05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102c08:	59                   	pop    %ecx
  log.dev = dev;
80102c09:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102c0f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102c12:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102c17:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  struct buf *buf = bread(log.dev, log.start);
80102c1d:	5a                   	pop    %edx
80102c1e:	50                   	push   %eax
80102c1f:	53                   	push   %ebx
80102c20:	e8 ab d4 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102c25:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102c28:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102c2b:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102c31:	85 c9                	test   %ecx,%ecx
80102c33:	7e 1d                	jle    80102c52 <initlog+0x72>
80102c35:	31 d2                	xor    %edx,%edx
80102c37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c3e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102c40:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102c44:	89 1c 95 cc 26 11 80 	mov    %ebx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c4b:	83 c2 01             	add    $0x1,%edx
80102c4e:	39 d1                	cmp    %edx,%ecx
80102c50:	75 ee                	jne    80102c40 <initlog+0x60>
  brelse(buf);
80102c52:	83 ec 0c             	sub    $0xc,%esp
80102c55:	50                   	push   %eax
80102c56:	e8 95 d5 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102c5b:	e8 80 fe ff ff       	call   80102ae0 <install_trans>
  log.lh.n = 0;
80102c60:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c67:	00 00 00 
  write_head(); // clear the log
80102c6a:	e8 11 ff ff ff       	call   80102b80 <write_head>
}
80102c6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c72:	83 c4 10             	add    $0x10,%esp
80102c75:	c9                   	leave  
80102c76:	c3                   	ret    
80102c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c7e:	66 90                	xchg   %ax,%ax

80102c80 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102c80:	55                   	push   %ebp
80102c81:	89 e5                	mov    %esp,%ebp
80102c83:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102c86:	68 80 26 11 80       	push   $0x80112680
80102c8b:	e8 30 18 00 00       	call   801044c0 <acquire>
80102c90:	83 c4 10             	add    $0x10,%esp
80102c93:	eb 18                	jmp    80102cad <begin_op+0x2d>
80102c95:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102c98:	83 ec 08             	sub    $0x8,%esp
80102c9b:	68 80 26 11 80       	push   $0x80112680
80102ca0:	68 80 26 11 80       	push   $0x80112680
80102ca5:	e8 96 11 00 00       	call   80103e40 <sleep>
80102caa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102cad:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102cb2:	85 c0                	test   %eax,%eax
80102cb4:	75 e2                	jne    80102c98 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102cb6:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102cbb:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102cc1:	83 c0 01             	add    $0x1,%eax
80102cc4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102cc7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102cca:	83 fa 1e             	cmp    $0x1e,%edx
80102ccd:	7f c9                	jg     80102c98 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102ccf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102cd2:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102cd7:	68 80 26 11 80       	push   $0x80112680
80102cdc:	e8 ff 18 00 00       	call   801045e0 <release>
      break;
    }
  }
}
80102ce1:	83 c4 10             	add    $0x10,%esp
80102ce4:	c9                   	leave  
80102ce5:	c3                   	ret    
80102ce6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ced:	8d 76 00             	lea    0x0(%esi),%esi

80102cf0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102cf0:	55                   	push   %ebp
80102cf1:	89 e5                	mov    %esp,%ebp
80102cf3:	57                   	push   %edi
80102cf4:	56                   	push   %esi
80102cf5:	53                   	push   %ebx
80102cf6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102cf9:	68 80 26 11 80       	push   $0x80112680
80102cfe:	e8 bd 17 00 00       	call   801044c0 <acquire>
  log.outstanding -= 1;
80102d03:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102d08:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102d0e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102d11:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102d14:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102d1a:	85 f6                	test   %esi,%esi
80102d1c:	0f 85 22 01 00 00    	jne    80102e44 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102d22:	85 db                	test   %ebx,%ebx
80102d24:	0f 85 f6 00 00 00    	jne    80102e20 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102d2a:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102d31:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102d34:	83 ec 0c             	sub    $0xc,%esp
80102d37:	68 80 26 11 80       	push   $0x80112680
80102d3c:	e8 9f 18 00 00       	call   801045e0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102d41:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102d47:	83 c4 10             	add    $0x10,%esp
80102d4a:	85 c9                	test   %ecx,%ecx
80102d4c:	7f 42                	jg     80102d90 <end_op+0xa0>
    acquire(&log.lock);
80102d4e:	83 ec 0c             	sub    $0xc,%esp
80102d51:	68 80 26 11 80       	push   $0x80112680
80102d56:	e8 65 17 00 00       	call   801044c0 <acquire>
    wakeup(&log);
80102d5b:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102d62:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102d69:	00 00 00 
    wakeup(&log);
80102d6c:	e8 7f 12 00 00       	call   80103ff0 <wakeup>
    release(&log.lock);
80102d71:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d78:	e8 63 18 00 00       	call   801045e0 <release>
80102d7d:	83 c4 10             	add    $0x10,%esp
}
80102d80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d83:	5b                   	pop    %ebx
80102d84:	5e                   	pop    %esi
80102d85:	5f                   	pop    %edi
80102d86:	5d                   	pop    %ebp
80102d87:	c3                   	ret    
80102d88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d8f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102d90:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102d95:	83 ec 08             	sub    $0x8,%esp
80102d98:	01 d8                	add    %ebx,%eax
80102d9a:	83 c0 01             	add    $0x1,%eax
80102d9d:	50                   	push   %eax
80102d9e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102da4:	e8 27 d3 ff ff       	call   801000d0 <bread>
80102da9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102dab:	58                   	pop    %eax
80102dac:	5a                   	pop    %edx
80102dad:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102db4:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102dba:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102dbd:	e8 0e d3 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102dc2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102dc5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102dc7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102dca:	68 00 02 00 00       	push   $0x200
80102dcf:	50                   	push   %eax
80102dd0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102dd3:	50                   	push   %eax
80102dd4:	e8 f7 18 00 00       	call   801046d0 <memmove>
    bwrite(to);  // write the log
80102dd9:	89 34 24             	mov    %esi,(%esp)
80102ddc:	e8 cf d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102de1:	89 3c 24             	mov    %edi,(%esp)
80102de4:	e8 07 d4 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102de9:	89 34 24             	mov    %esi,(%esp)
80102dec:	e8 ff d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102df1:	83 c4 10             	add    $0x10,%esp
80102df4:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102dfa:	7c 94                	jl     80102d90 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102dfc:	e8 7f fd ff ff       	call   80102b80 <write_head>
    install_trans(); // Now install writes to home locations
80102e01:	e8 da fc ff ff       	call   80102ae0 <install_trans>
    log.lh.n = 0;
80102e06:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102e0d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102e10:	e8 6b fd ff ff       	call   80102b80 <write_head>
80102e15:	e9 34 ff ff ff       	jmp    80102d4e <end_op+0x5e>
80102e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102e20:	83 ec 0c             	sub    $0xc,%esp
80102e23:	68 80 26 11 80       	push   $0x80112680
80102e28:	e8 c3 11 00 00       	call   80103ff0 <wakeup>
  release(&log.lock);
80102e2d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e34:	e8 a7 17 00 00       	call   801045e0 <release>
80102e39:	83 c4 10             	add    $0x10,%esp
}
80102e3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e3f:	5b                   	pop    %ebx
80102e40:	5e                   	pop    %esi
80102e41:	5f                   	pop    %edi
80102e42:	5d                   	pop    %ebp
80102e43:	c3                   	ret    
    panic("log.committing");
80102e44:	83 ec 0c             	sub    $0xc,%esp
80102e47:	68 e4 74 10 80       	push   $0x801074e4
80102e4c:	e8 2f d5 ff ff       	call   80100380 <panic>
80102e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
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
{
80102e6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e70:	83 fa 1d             	cmp    $0x1d,%edx
80102e73:	0f 8f 85 00 00 00    	jg     80102efe <log_write+0x9e>
80102e79:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102e7e:	83 e8 01             	sub    $0x1,%eax
80102e81:	39 c2                	cmp    %eax,%edx
80102e83:	7d 79                	jge    80102efe <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102e85:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102e8a:	85 c0                	test   %eax,%eax
80102e8c:	7e 7d                	jle    80102f0b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102e8e:	83 ec 0c             	sub    $0xc,%esp
80102e91:	68 80 26 11 80       	push   $0x80112680
80102e96:	e8 25 16 00 00       	call   801044c0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102e9b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102ea1:	83 c4 10             	add    $0x10,%esp
80102ea4:	85 d2                	test   %edx,%edx
80102ea6:	7e 4a                	jle    80102ef2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ea8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102eab:	31 c0                	xor    %eax,%eax
80102ead:	eb 08                	jmp    80102eb7 <log_write+0x57>
80102eaf:	90                   	nop
80102eb0:	83 c0 01             	add    $0x1,%eax
80102eb3:	39 c2                	cmp    %eax,%edx
80102eb5:	74 29                	je     80102ee0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102eb7:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102ebe:	75 f0                	jne    80102eb0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102ec0:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102ec7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102eca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102ecd:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102ed4:	c9                   	leave  
  release(&log.lock);
80102ed5:	e9 06 17 00 00       	jmp    801045e0 <release>
80102eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102ee0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
    log.lh.n++;
80102ee7:	83 c2 01             	add    $0x1,%edx
80102eea:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
80102ef0:	eb d5                	jmp    80102ec7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102ef2:	8b 43 08             	mov    0x8(%ebx),%eax
80102ef5:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102efa:	75 cb                	jne    80102ec7 <log_write+0x67>
80102efc:	eb e9                	jmp    80102ee7 <log_write+0x87>
    panic("too big a transaction");
80102efe:	83 ec 0c             	sub    $0xc,%esp
80102f01:	68 f3 74 10 80       	push   $0x801074f3
80102f06:	e8 75 d4 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102f0b:	83 ec 0c             	sub    $0xc,%esp
80102f0e:	68 09 75 10 80       	push   $0x80107509
80102f13:	e8 68 d4 ff ff       	call   80100380 <panic>
80102f18:	66 90                	xchg   %ax,%ax
80102f1a:	66 90                	xchg   %ax,%ax
80102f1c:	66 90                	xchg   %ax,%ax
80102f1e:	66 90                	xchg   %ax,%ax

80102f20 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	53                   	push   %ebx
80102f24:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102f27:	e8 34 09 00 00       	call   80103860 <cpuid>
80102f2c:	89 c3                	mov    %eax,%ebx
80102f2e:	e8 2d 09 00 00       	call   80103860 <cpuid>
80102f33:	83 ec 04             	sub    $0x4,%esp
80102f36:	53                   	push   %ebx
80102f37:	50                   	push   %eax
80102f38:	68 24 75 10 80       	push   $0x80107524
80102f3d:	e8 5e d7 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80102f42:	e8 69 29 00 00       	call   801058b0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102f47:	e8 a4 08 00 00       	call   801037f0 <mycpu>
80102f4c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102f4e:	b8 01 00 00 00       	mov    $0x1,%eax
80102f53:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102f5a:	e8 e1 0b 00 00       	call   80103b40 <scheduler>
80102f5f:	90                   	nop

80102f60 <mpenter>:
{
80102f60:	55                   	push   %ebp
80102f61:	89 e5                	mov    %esp,%ebp
80102f63:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102f66:	e8 15 3a 00 00       	call   80106980 <switchkvm>
  seginit();
80102f6b:	e8 80 39 00 00       	call   801068f0 <seginit>
  lapicinit();
80102f70:	e8 9b f7 ff ff       	call   80102710 <lapicinit>
  mpmain();
80102f75:	e8 a6 ff ff ff       	call   80102f20 <mpmain>
80102f7a:	66 90                	xchg   %ax,%ax
80102f7c:	66 90                	xchg   %ax,%ax
80102f7e:	66 90                	xchg   %ax,%ax

80102f80 <main>:
{
80102f80:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102f84:	83 e4 f0             	and    $0xfffffff0,%esp
80102f87:	ff 71 fc             	pushl  -0x4(%ecx)
80102f8a:	55                   	push   %ebp
80102f8b:	89 e5                	mov    %esp,%ebp
80102f8d:	53                   	push   %ebx
80102f8e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102f8f:	83 ec 08             	sub    $0x8,%esp
80102f92:	68 00 00 40 80       	push   $0x80400000
80102f97:	68 a8 55 11 80       	push   $0x801155a8
80102f9c:	e8 2f f5 ff ff       	call   801024d0 <kinit1>
  kvmalloc();      // kernel page table
80102fa1:	e8 9a 3e 00 00       	call   80106e40 <kvmalloc>
  mpinit();        // detect other processors
80102fa6:	e8 85 01 00 00       	call   80103130 <mpinit>
  lapicinit();     // interrupt controller
80102fab:	e8 60 f7 ff ff       	call   80102710 <lapicinit>
  seginit();       // segment descriptors
80102fb0:	e8 3b 39 00 00       	call   801068f0 <seginit>
  picinit();       // disable pic
80102fb5:	e8 46 03 00 00       	call   80103300 <picinit>
  ioapicinit();    // another interrupt controller
80102fba:	e8 31 f3 ff ff       	call   801022f0 <ioapicinit>
  consoleinit();   // console hardware
80102fbf:	e8 5c da ff ff       	call   80100a20 <consoleinit>
  uartinit();      // serial port
80102fc4:	e8 e7 2b 00 00       	call   80105bb0 <uartinit>
  pinit();         // process table
80102fc9:	e8 02 08 00 00       	call   801037d0 <pinit>
  tvinit();        // trap vectors
80102fce:	e8 5d 28 00 00       	call   80105830 <tvinit>
  binit();         // buffer cache
80102fd3:	e8 68 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102fd8:	e8 03 de ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
80102fdd:	e8 fe f0 ff ff       	call   801020e0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102fe2:	83 c4 0c             	add    $0xc,%esp
80102fe5:	68 8a 00 00 00       	push   $0x8a
80102fea:	68 8c a4 10 80       	push   $0x8010a48c
80102fef:	68 00 70 00 80       	push   $0x80007000
80102ff4:	e8 d7 16 00 00       	call   801046d0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102ff9:	83 c4 10             	add    $0x10,%esp
80102ffc:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103003:	00 00 00 
80103006:	05 80 27 11 80       	add    $0x80112780,%eax
8010300b:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80103010:	76 7e                	jbe    80103090 <main+0x110>
80103012:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80103017:	eb 20                	jmp    80103039 <main+0xb9>
80103019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103020:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103027:	00 00 00 
8010302a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103030:	05 80 27 11 80       	add    $0x80112780,%eax
80103035:	39 c3                	cmp    %eax,%ebx
80103037:	73 57                	jae    80103090 <main+0x110>
    if(c == mycpu())  // We've started already.
80103039:	e8 b2 07 00 00       	call   801037f0 <mycpu>
8010303e:	39 c3                	cmp    %eax,%ebx
80103040:	74 de                	je     80103020 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103042:	e8 59 f5 ff ff       	call   801025a0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103047:	83 ec 08             	sub    $0x8,%esp
    *(void**)(code-8) = mpenter;
8010304a:	c7 05 f8 6f 00 80 60 	movl   $0x80102f60,0x80006ff8
80103051:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103054:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010305b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010305e:	05 00 10 00 00       	add    $0x1000,%eax
80103063:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103068:	0f b6 03             	movzbl (%ebx),%eax
8010306b:	68 00 70 00 00       	push   $0x7000
80103070:	50                   	push   %eax
80103071:	e8 ea f7 ff ff       	call   80102860 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103076:	83 c4 10             	add    $0x10,%esp
80103079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103080:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103086:	85 c0                	test   %eax,%eax
80103088:	74 f6                	je     80103080 <main+0x100>
8010308a:	eb 94                	jmp    80103020 <main+0xa0>
8010308c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103090:	83 ec 08             	sub    $0x8,%esp
80103093:	68 00 00 00 8e       	push   $0x8e000000
80103098:	68 00 00 40 80       	push   $0x80400000
8010309d:	e8 9e f4 ff ff       	call   80102540 <kinit2>
  userinit();      // first user process
801030a2:	e8 09 08 00 00       	call   801038b0 <userinit>
  mpmain();        // finish this processor's setup
801030a7:	e8 74 fe ff ff       	call   80102f20 <mpmain>
801030ac:	66 90                	xchg   %ax,%ax
801030ae:	66 90                	xchg   %ax,%ax

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
{
801030bb:	53                   	push   %ebx
  e = addr+len;
801030bc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801030bf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801030c2:	39 de                	cmp    %ebx,%esi
801030c4:	72 10                	jb     801030d6 <mpsearch1+0x26>
801030c6:	eb 50                	jmp    80103118 <mpsearch1+0x68>
801030c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030cf:	90                   	nop
801030d0:	89 fe                	mov    %edi,%esi
801030d2:	39 fb                	cmp    %edi,%ebx
801030d4:	76 42                	jbe    80103118 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801030d6:	83 ec 04             	sub    $0x4,%esp
801030d9:	8d 7e 10             	lea    0x10(%esi),%edi
801030dc:	6a 04                	push   $0x4
801030de:	68 38 75 10 80       	push   $0x80107538
801030e3:	56                   	push   %esi
801030e4:	e8 97 15 00 00       	call   80104680 <memcmp>
801030e9:	83 c4 10             	add    $0x10,%esp
801030ec:	85 c0                	test   %eax,%eax
801030ee:	75 e0                	jne    801030d0 <mpsearch1+0x20>
801030f0:	89 f2                	mov    %esi,%edx
801030f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801030f8:	0f b6 0a             	movzbl (%edx),%ecx
801030fb:	83 c2 01             	add    $0x1,%edx
801030fe:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103100:	39 fa                	cmp    %edi,%edx
80103102:	75 f4                	jne    801030f8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103104:	84 c0                	test   %al,%al
80103106:	75 c8                	jne    801030d0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103108:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010310b:	89 f0                	mov    %esi,%eax
8010310d:	5b                   	pop    %ebx
8010310e:	5e                   	pop    %esi
8010310f:	5f                   	pop    %edi
80103110:	5d                   	pop    %ebp
80103111:	c3                   	ret    
80103112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103118:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010311b:	31 f6                	xor    %esi,%esi
}
8010311d:	5b                   	pop    %ebx
8010311e:	89 f0                	mov    %esi,%eax
80103120:	5e                   	pop    %esi
80103121:	5f                   	pop    %edi
80103122:	5d                   	pop    %ebp
80103123:	c3                   	ret    
80103124:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010312b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010312f:	90                   	nop

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
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103139:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103140:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103147:	c1 e0 08             	shl    $0x8,%eax
8010314a:	09 d0                	or     %edx,%eax
8010314c:	c1 e0 04             	shl    $0x4,%eax
8010314f:	75 1b                	jne    8010316c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103151:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103158:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010315f:	c1 e0 08             	shl    $0x8,%eax
80103162:	09 d0                	or     %edx,%eax
80103164:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103167:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010316c:	ba 00 04 00 00       	mov    $0x400,%edx
80103171:	e8 3a ff ff ff       	call   801030b0 <mpsearch1>
80103176:	89 c6                	mov    %eax,%esi
80103178:	85 c0                	test   %eax,%eax
8010317a:	0f 84 40 01 00 00    	je     801032c0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103180:	8b 5e 04             	mov    0x4(%esi),%ebx
80103183:	85 db                	test   %ebx,%ebx
80103185:	0f 84 55 01 00 00    	je     801032e0 <mpinit+0x1b0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010318b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010318e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103194:	6a 04                	push   $0x4
80103196:	68 3d 75 10 80       	push   $0x8010753d
8010319b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010319c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010319f:	e8 dc 14 00 00       	call   80104680 <memcmp>
801031a4:	83 c4 10             	add    $0x10,%esp
801031a7:	85 c0                	test   %eax,%eax
801031a9:	0f 85 31 01 00 00    	jne    801032e0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801031af:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801031b6:	3c 01                	cmp    $0x1,%al
801031b8:	74 08                	je     801031c2 <mpinit+0x92>
801031ba:	3c 04                	cmp    $0x4,%al
801031bc:	0f 85 1e 01 00 00    	jne    801032e0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801031c2:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
801031c9:	66 85 d2             	test   %dx,%dx
801031cc:	74 22                	je     801031f0 <mpinit+0xc0>
801031ce:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801031d1:	89 d8                	mov    %ebx,%eax
  sum = 0;
801031d3:	31 d2                	xor    %edx,%edx
801031d5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801031d8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801031df:	83 c0 01             	add    $0x1,%eax
801031e2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801031e4:	39 f8                	cmp    %edi,%eax
801031e6:	75 f0                	jne    801031d8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801031e8:	84 d2                	test   %dl,%dl
801031ea:	0f 85 f0 00 00 00    	jne    801032e0 <mpinit+0x1b0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801031f0:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801031f6:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031fb:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103201:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103208:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010320d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103210:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103213:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103217:	90                   	nop
80103218:	39 c2                	cmp    %eax,%edx
8010321a:	76 15                	jbe    80103231 <mpinit+0x101>
    switch(*p){
8010321c:	0f b6 08             	movzbl (%eax),%ecx
8010321f:	80 f9 02             	cmp    $0x2,%cl
80103222:	74 54                	je     80103278 <mpinit+0x148>
80103224:	77 3a                	ja     80103260 <mpinit+0x130>
80103226:	84 c9                	test   %cl,%cl
80103228:	74 66                	je     80103290 <mpinit+0x160>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010322a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010322d:	39 c2                	cmp    %eax,%edx
8010322f:	77 eb                	ja     8010321c <mpinit+0xec>
80103231:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103234:	85 db                	test   %ebx,%ebx
80103236:	0f 84 b1 00 00 00    	je     801032ed <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010323c:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103240:	74 15                	je     80103257 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103242:	b8 70 00 00 00       	mov    $0x70,%eax
80103247:	ba 22 00 00 00       	mov    $0x22,%edx
8010324c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010324d:	ba 23 00 00 00       	mov    $0x23,%edx
80103252:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103253:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103256:	ee                   	out    %al,(%dx)
  }
}
80103257:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010325a:	5b                   	pop    %ebx
8010325b:	5e                   	pop    %esi
8010325c:	5f                   	pop    %edi
8010325d:	5d                   	pop    %ebp
8010325e:	c3                   	ret    
8010325f:	90                   	nop
    switch(*p){
80103260:	83 e9 03             	sub    $0x3,%ecx
80103263:	80 f9 01             	cmp    $0x1,%cl
80103266:	76 c2                	jbe    8010322a <mpinit+0xfa>
80103268:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010326f:	eb a7                	jmp    80103218 <mpinit+0xe8>
80103271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103278:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010327c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010327f:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
80103285:	eb 91                	jmp    80103218 <mpinit+0xe8>
80103287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010328e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103290:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
80103296:	83 f9 07             	cmp    $0x7,%ecx
80103299:	7f 19                	jg     801032b4 <mpinit+0x184>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010329b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801032a1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801032a5:	83 c1 01             	add    $0x1,%ecx
801032a8:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801032ae:	88 9f 80 27 11 80    	mov    %bl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
801032b4:	83 c0 14             	add    $0x14,%eax
      continue;
801032b7:	e9 5c ff ff ff       	jmp    80103218 <mpinit+0xe8>
801032bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801032c0:	ba 00 00 01 00       	mov    $0x10000,%edx
801032c5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801032ca:	e8 e1 fd ff ff       	call   801030b0 <mpsearch1>
801032cf:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032d1:	85 c0                	test   %eax,%eax
801032d3:	0f 85 a7 fe ff ff    	jne    80103180 <mpinit+0x50>
801032d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801032e0:	83 ec 0c             	sub    $0xc,%esp
801032e3:	68 42 75 10 80       	push   $0x80107542
801032e8:	e8 93 d0 ff ff       	call   80100380 <panic>
    panic("Didn't find a suitable machine");
801032ed:	83 ec 0c             	sub    $0xc,%esp
801032f0:	68 5c 75 10 80       	push   $0x8010755c
801032f5:	e8 86 d0 ff ff       	call   80100380 <panic>
801032fa:	66 90                	xchg   %ax,%ax
801032fc:	66 90                	xchg   %ax,%ax
801032fe:	66 90                	xchg   %ax,%ax

80103300 <picinit>:
80103300:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103305:	ba 21 00 00 00       	mov    $0x21,%edx
8010330a:	ee                   	out    %al,(%dx)
8010330b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103310:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103311:	c3                   	ret    
80103312:	66 90                	xchg   %ax,%ax
80103314:	66 90                	xchg   %ax,%ax
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
80103329:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010332c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010332f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103335:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010333b:	e8 c0 da ff ff       	call   80100e00 <filealloc>
80103340:	89 03                	mov    %eax,(%ebx)
80103342:	85 c0                	test   %eax,%eax
80103344:	0f 84 a8 00 00 00    	je     801033f2 <pipealloc+0xd2>
8010334a:	e8 b1 da ff ff       	call   80100e00 <filealloc>
8010334f:	89 06                	mov    %eax,(%esi)
80103351:	85 c0                	test   %eax,%eax
80103353:	0f 84 87 00 00 00    	je     801033e0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103359:	e8 42 f2 ff ff       	call   801025a0 <kalloc>
8010335e:	89 c7                	mov    %eax,%edi
80103360:	85 c0                	test   %eax,%eax
80103362:	0f 84 b0 00 00 00    	je     80103418 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103368:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010336f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103372:	83 ec 08             	sub    $0x8,%esp
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
80103393:	68 7b 75 10 80       	push   $0x8010757b
80103398:	50                   	push   %eax
80103399:	e8 22 10 00 00       	call   801043c0 <initlock>
  (*f0)->type = FD_PIPE;
8010339e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801033a0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801033a3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801033a9:	8b 03                	mov    (%ebx),%eax
801033ab:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801033af:	8b 03                	mov    (%ebx),%eax
801033b1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801033b5:	8b 03                	mov    (%ebx),%eax
801033b7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801033ba:	8b 06                	mov    (%esi),%eax
801033bc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801033c2:	8b 06                	mov    (%esi),%eax
801033c4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801033c8:	8b 06                	mov    (%esi),%eax
801033ca:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801033ce:	8b 06                	mov    (%esi),%eax
801033d0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801033d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033d6:	31 c0                	xor    %eax,%eax
}
801033d8:	5b                   	pop    %ebx
801033d9:	5e                   	pop    %esi
801033da:	5f                   	pop    %edi
801033db:	5d                   	pop    %ebp
801033dc:	c3                   	ret    
801033dd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801033e0:	8b 03                	mov    (%ebx),%eax
801033e2:	85 c0                	test   %eax,%eax
801033e4:	74 1e                	je     80103404 <pipealloc+0xe4>
    fileclose(*f0);
801033e6:	83 ec 0c             	sub    $0xc,%esp
801033e9:	50                   	push   %eax
801033ea:	e8 d1 da ff ff       	call   80100ec0 <fileclose>
801033ef:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801033f2:	8b 06                	mov    (%esi),%eax
801033f4:	85 c0                	test   %eax,%eax
801033f6:	74 0c                	je     80103404 <pipealloc+0xe4>
    fileclose(*f1);
801033f8:	83 ec 0c             	sub    $0xc,%esp
801033fb:	50                   	push   %eax
801033fc:	e8 bf da ff ff       	call   80100ec0 <fileclose>
80103401:	83 c4 10             	add    $0x10,%esp
}
80103404:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103407:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010340c:	5b                   	pop    %ebx
8010340d:	5e                   	pop    %esi
8010340e:	5f                   	pop    %edi
8010340f:	5d                   	pop    %ebp
80103410:	c3                   	ret    
80103411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103418:	8b 03                	mov    (%ebx),%eax
8010341a:	85 c0                	test   %eax,%eax
8010341c:	75 c8                	jne    801033e6 <pipealloc+0xc6>
8010341e:	eb d2                	jmp    801033f2 <pipealloc+0xd2>

80103420 <pipeclose>:

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
8010342f:	e8 8c 10 00 00       	call   801044c0 <acquire>
  if(writable){
80103434:	83 c4 10             	add    $0x10,%esp
80103437:	85 f6                	test   %esi,%esi
80103439:	74 45                	je     80103480 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010343b:	83 ec 0c             	sub    $0xc,%esp
8010343e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103444:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010344b:	00 00 00 
    wakeup(&p->nread);
8010344e:	50                   	push   %eax
8010344f:	e8 9c 0b 00 00       	call   80103ff0 <wakeup>
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
    release(&p->lock);
80103474:	e9 67 11 00 00       	jmp    801045e0 <release>
80103479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103480:	83 ec 0c             	sub    $0xc,%esp
80103483:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103489:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103490:	00 00 00 
    wakeup(&p->nwrite);
80103493:	50                   	push   %eax
80103494:	e8 57 0b 00 00       	call   80103ff0 <wakeup>
80103499:	83 c4 10             	add    $0x10,%esp
8010349c:	eb b9                	jmp    80103457 <pipeclose+0x37>
8010349e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801034a0:	83 ec 0c             	sub    $0xc,%esp
801034a3:	53                   	push   %ebx
801034a4:	e8 37 11 00 00       	call   801045e0 <release>
    kfree((char*)p);
801034a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801034ac:	83 c4 10             	add    $0x10,%esp
}
801034af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034b2:	5b                   	pop    %ebx
801034b3:	5e                   	pop    %esi
801034b4:	5d                   	pop    %ebp
    kfree((char*)p);
801034b5:	e9 26 ef ff ff       	jmp    801023e0 <kfree>
801034ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801034c0 <pipewrite>:

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
801034cd:	e8 ee 0f 00 00       	call   801044c0 <acquire>
  for(i = 0; i < n; i++){
801034d2:	8b 45 10             	mov    0x10(%ebp),%eax
801034d5:	83 c4 10             	add    $0x10,%esp
801034d8:	85 c0                	test   %eax,%eax
801034da:	0f 8e c0 00 00 00    	jle    801035a0 <pipewrite+0xe0>
801034e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801034e3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801034e9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801034ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801034f2:	03 45 10             	add    0x10(%ebp),%eax
801034f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034f8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034fe:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103504:	89 ca                	mov    %ecx,%edx
80103506:	05 00 02 00 00       	add    $0x200,%eax
8010350b:	39 c1                	cmp    %eax,%ecx
8010350d:	74 3f                	je     8010354e <pipewrite+0x8e>
8010350f:	eb 67                	jmp    80103578 <pipewrite+0xb8>
80103511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103518:	e8 63 03 00 00       	call   80103880 <myproc>
8010351d:	8b 48 24             	mov    0x24(%eax),%ecx
80103520:	85 c9                	test   %ecx,%ecx
80103522:	75 34                	jne    80103558 <pipewrite+0x98>
      wakeup(&p->nread);
80103524:	83 ec 0c             	sub    $0xc,%esp
80103527:	57                   	push   %edi
80103528:	e8 c3 0a 00 00       	call   80103ff0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010352d:	58                   	pop    %eax
8010352e:	5a                   	pop    %edx
8010352f:	53                   	push   %ebx
80103530:	56                   	push   %esi
80103531:	e8 0a 09 00 00       	call   80103e40 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103536:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010353c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103542:	83 c4 10             	add    $0x10,%esp
80103545:	05 00 02 00 00       	add    $0x200,%eax
8010354a:	39 c2                	cmp    %eax,%edx
8010354c:	75 2a                	jne    80103578 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010354e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103554:	85 c0                	test   %eax,%eax
80103556:	75 c0                	jne    80103518 <pipewrite+0x58>
        release(&p->lock);
80103558:	83 ec 0c             	sub    $0xc,%esp
8010355b:	53                   	push   %ebx
8010355c:	e8 7f 10 00 00       	call   801045e0 <release>
        return -1;
80103561:	83 c4 10             	add    $0x10,%esp
80103564:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103569:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010356c:	5b                   	pop    %ebx
8010356d:	5e                   	pop    %esi
8010356e:	5f                   	pop    %edi
8010356f:	5d                   	pop    %ebp
80103570:	c3                   	ret    
80103571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103578:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010357b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010357e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103584:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010358a:	0f b6 06             	movzbl (%esi),%eax
8010358d:	83 c6 01             	add    $0x1,%esi
80103590:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103593:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103597:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010359a:	0f 85 58 ff ff ff    	jne    801034f8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801035a0:	83 ec 0c             	sub    $0xc,%esp
801035a3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801035a9:	50                   	push   %eax
801035aa:	e8 41 0a 00 00       	call   80103ff0 <wakeup>
  release(&p->lock);
801035af:	89 1c 24             	mov    %ebx,(%esp)
801035b2:	e8 29 10 00 00       	call   801045e0 <release>
  return n;
801035b7:	8b 45 10             	mov    0x10(%ebp),%eax
801035ba:	83 c4 10             	add    $0x10,%esp
801035bd:	eb aa                	jmp    80103569 <pipewrite+0xa9>
801035bf:	90                   	nop

801035c0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	57                   	push   %edi
801035c4:	56                   	push   %esi
801035c5:	53                   	push   %ebx
801035c6:	83 ec 18             	sub    $0x18,%esp
801035c9:	8b 75 08             	mov    0x8(%ebp),%esi
801035cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801035cf:	56                   	push   %esi
801035d0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801035d6:	e8 e5 0e 00 00       	call   801044c0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801035db:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801035e1:	83 c4 10             	add    $0x10,%esp
801035e4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801035ea:	74 2f                	je     8010361b <piperead+0x5b>
801035ec:	eb 37                	jmp    80103625 <piperead+0x65>
801035ee:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801035f0:	e8 8b 02 00 00       	call   80103880 <myproc>
801035f5:	8b 48 24             	mov    0x24(%eax),%ecx
801035f8:	85 c9                	test   %ecx,%ecx
801035fa:	0f 85 80 00 00 00    	jne    80103680 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103600:	83 ec 08             	sub    $0x8,%esp
80103603:	56                   	push   %esi
80103604:	53                   	push   %ebx
80103605:	e8 36 08 00 00       	call   80103e40 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010360a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103610:	83 c4 10             	add    $0x10,%esp
80103613:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103619:	75 0a                	jne    80103625 <piperead+0x65>
8010361b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103621:	85 c0                	test   %eax,%eax
80103623:	75 cb                	jne    801035f0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103625:	8b 55 10             	mov    0x10(%ebp),%edx
80103628:	31 db                	xor    %ebx,%ebx
8010362a:	85 d2                	test   %edx,%edx
8010362c:	7f 20                	jg     8010364e <piperead+0x8e>
8010362e:	eb 2c                	jmp    8010365c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103630:	8d 48 01             	lea    0x1(%eax),%ecx
80103633:	25 ff 01 00 00       	and    $0x1ff,%eax
80103638:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010363e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103643:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103646:	83 c3 01             	add    $0x1,%ebx
80103649:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010364c:	74 0e                	je     8010365c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010364e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103654:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010365a:	75 d4                	jne    80103630 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010365c:	83 ec 0c             	sub    $0xc,%esp
8010365f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103665:	50                   	push   %eax
80103666:	e8 85 09 00 00       	call   80103ff0 <wakeup>
  release(&p->lock);
8010366b:	89 34 24             	mov    %esi,(%esp)
8010366e:	e8 6d 0f 00 00       	call   801045e0 <release>
  return i;
80103673:	83 c4 10             	add    $0x10,%esp
}
80103676:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103679:	89 d8                	mov    %ebx,%eax
8010367b:	5b                   	pop    %ebx
8010367c:	5e                   	pop    %esi
8010367d:	5f                   	pop    %edi
8010367e:	5d                   	pop    %ebp
8010367f:	c3                   	ret    
      release(&p->lock);
80103680:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103683:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103688:	56                   	push   %esi
80103689:	e8 52 0f 00 00       	call   801045e0 <release>
      return -1;
8010368e:	83 c4 10             	add    $0x10,%esp
}
80103691:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103694:	89 d8                	mov    %ebx,%eax
80103696:	5b                   	pop    %ebx
80103697:	5e                   	pop    %esi
80103698:	5f                   	pop    %edi
80103699:	5d                   	pop    %ebp
8010369a:	c3                   	ret    
8010369b:	66 90                	xchg   %ax,%ax
8010369d:	66 90                	xchg   %ax,%ax
8010369f:	90                   	nop

801036a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036a4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801036a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801036ac:	68 20 2d 11 80       	push   $0x80112d20
801036b1:	e8 0a 0e 00 00       	call   801044c0 <acquire>
801036b6:	83 c4 10             	add    $0x10,%esp
801036b9:	eb 14                	jmp    801036cf <allocproc+0x2f>
801036bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036bf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036c0:	83 eb 80             	sub    $0xffffff80,%ebx
801036c3:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801036c9:	0f 84 81 00 00 00    	je     80103750 <allocproc+0xb0>
    if(p->state == UNUSED)
801036cf:	8b 43 0c             	mov    0xc(%ebx),%eax
801036d2:	85 c0                	test   %eax,%eax
801036d4:	75 ea                	jne    801036c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801036d6:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  p->priority = 10; //default = 10
  release(&ptable.lock);
801036db:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801036de:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->priority = 10; //default = 10
801036e5:	c7 43 7c 0a 00 00 00 	movl   $0xa,0x7c(%ebx)
  p->pid = nextpid++;
801036ec:	89 43 10             	mov    %eax,0x10(%ebx)
801036ef:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801036f2:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
801036f7:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
801036fd:	e8 de 0e 00 00       	call   801045e0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103702:	e8 99 ee ff ff       	call   801025a0 <kalloc>
80103707:	83 c4 10             	add    $0x10,%esp
8010370a:	89 43 08             	mov    %eax,0x8(%ebx)
8010370d:	85 c0                	test   %eax,%eax
8010370f:	74 58                	je     80103769 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103711:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103717:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010371a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010371f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103722:	c7 40 14 1f 58 10 80 	movl   $0x8010581f,0x14(%eax)
  p->context = (struct context*)sp;
80103729:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010372c:	6a 14                	push   $0x14
8010372e:	6a 00                	push   $0x0
80103730:	50                   	push   %eax
80103731:	e8 fa 0e 00 00       	call   80104630 <memset>
  p->context->eip = (uint)forkret;
80103736:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103739:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010373c:	c7 40 10 80 37 10 80 	movl   $0x80103780,0x10(%eax)
}
80103743:	89 d8                	mov    %ebx,%eax
80103745:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103748:	c9                   	leave  
80103749:	c3                   	ret    
8010374a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103750:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103753:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103755:	68 20 2d 11 80       	push   $0x80112d20
8010375a:	e8 81 0e 00 00       	call   801045e0 <release>
}
8010375f:	89 d8                	mov    %ebx,%eax
  return 0;
80103761:	83 c4 10             	add    $0x10,%esp
}
80103764:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103767:	c9                   	leave  
80103768:	c3                   	ret    
    p->state = UNUSED;
80103769:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103770:	31 db                	xor    %ebx,%ebx
}
80103772:	89 d8                	mov    %ebx,%eax
80103774:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103777:	c9                   	leave  
80103778:	c3                   	ret    
80103779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103780 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103786:	68 20 2d 11 80       	push   $0x80112d20
8010378b:	e8 50 0e 00 00       	call   801045e0 <release>

  if (first) {
80103790:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103795:	83 c4 10             	add    $0x10,%esp
80103798:	85 c0                	test   %eax,%eax
8010379a:	75 04                	jne    801037a0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010379c:	c9                   	leave  
8010379d:	c3                   	ret    
8010379e:	66 90                	xchg   %ax,%ax
    first = 0;
801037a0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801037a7:	00 00 00 
    iinit(ROOTDEV);
801037aa:	83 ec 0c             	sub    $0xc,%esp
801037ad:	6a 01                	push   $0x1
801037af:	e8 6c dd ff ff       	call   80101520 <iinit>
    initlog(ROOTDEV);
801037b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801037bb:	e8 20 f4 ff ff       	call   80102be0 <initlog>
}
801037c0:	83 c4 10             	add    $0x10,%esp
801037c3:	c9                   	leave  
801037c4:	c3                   	ret    
801037c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801037d0 <pinit>:
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801037d6:	68 80 75 10 80       	push   $0x80107580
801037db:	68 20 2d 11 80       	push   $0x80112d20
801037e0:	e8 db 0b 00 00       	call   801043c0 <initlock>
}
801037e5:	83 c4 10             	add    $0x10,%esp
801037e8:	c9                   	leave  
801037e9:	c3                   	ret    
801037ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801037f0 <mycpu>:
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	56                   	push   %esi
801037f4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801037f5:	9c                   	pushf  
801037f6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801037f7:	f6 c4 02             	test   $0x2,%ah
801037fa:	75 4e                	jne    8010384a <mycpu+0x5a>
  apicid = lapicid();
801037fc:	e8 0f f0 ff ff       	call   80102810 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103801:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
  apicid = lapicid();
80103807:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103809:	85 f6                	test   %esi,%esi
8010380b:	7e 30                	jle    8010383d <mycpu+0x4d>
8010380d:	31 d2                	xor    %edx,%edx
8010380f:	eb 0e                	jmp    8010381f <mycpu+0x2f>
80103811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103818:	83 c2 01             	add    $0x1,%edx
8010381b:	39 f2                	cmp    %esi,%edx
8010381d:	74 1e                	je     8010383d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010381f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103825:	0f b6 81 80 27 11 80 	movzbl -0x7feed880(%ecx),%eax
8010382c:	39 d8                	cmp    %ebx,%eax
8010382e:	75 e8                	jne    80103818 <mycpu+0x28>
}
80103830:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103833:	8d 81 80 27 11 80    	lea    -0x7feed880(%ecx),%eax
}
80103839:	5b                   	pop    %ebx
8010383a:	5e                   	pop    %esi
8010383b:	5d                   	pop    %ebp
8010383c:	c3                   	ret    
  panic("unknown apicid\n");
8010383d:	83 ec 0c             	sub    $0xc,%esp
80103840:	68 87 75 10 80       	push   $0x80107587
80103845:	e8 36 cb ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
8010384a:	83 ec 0c             	sub    $0xc,%esp
8010384d:	68 b0 76 10 80       	push   $0x801076b0
80103852:	e8 29 cb ff ff       	call   80100380 <panic>
80103857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010385e:	66 90                	xchg   %ax,%ax

80103860 <cpuid>:
cpuid() {
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103866:	e8 85 ff ff ff       	call   801037f0 <mycpu>
}
8010386b:	c9                   	leave  
  return mycpu()-cpus;
8010386c:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103871:	c1 f8 04             	sar    $0x4,%eax
80103874:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010387a:	c3                   	ret    
8010387b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010387f:	90                   	nop

80103880 <myproc>:
myproc(void) {
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	53                   	push   %ebx
80103884:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103887:	e8 e4 0b 00 00       	call   80104470 <pushcli>
  c = mycpu();
8010388c:	e8 5f ff ff ff       	call   801037f0 <mycpu>
  p = c->proc;
80103891:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103897:	e8 e4 0c 00 00       	call   80104580 <popcli>
}
8010389c:	83 c4 04             	add    $0x4,%esp
8010389f:	89 d8                	mov    %ebx,%eax
801038a1:	5b                   	pop    %ebx
801038a2:	5d                   	pop    %ebp
801038a3:	c3                   	ret    
801038a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038af:	90                   	nop

801038b0 <userinit>:
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	53                   	push   %ebx
801038b4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801038b7:	e8 e4 fd ff ff       	call   801036a0 <allocproc>
801038bc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801038be:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801038c3:	e8 f8 34 00 00       	call   80106dc0 <setupkvm>
801038c8:	89 43 04             	mov    %eax,0x4(%ebx)
801038cb:	85 c0                	test   %eax,%eax
801038cd:	0f 84 bd 00 00 00    	je     80103990 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801038d3:	83 ec 04             	sub    $0x4,%esp
801038d6:	68 2c 00 00 00       	push   $0x2c
801038db:	68 60 a4 10 80       	push   $0x8010a460
801038e0:	50                   	push   %eax
801038e1:	e8 ba 31 00 00       	call   80106aa0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801038e6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801038e9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801038ef:	6a 4c                	push   $0x4c
801038f1:	6a 00                	push   $0x0
801038f3:	ff 73 18             	pushl  0x18(%ebx)
801038f6:	e8 35 0d 00 00       	call   80104630 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038fb:	8b 43 18             	mov    0x18(%ebx),%eax
801038fe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103903:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103906:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010390b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010390f:	8b 43 18             	mov    0x18(%ebx),%eax
80103912:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103916:	8b 43 18             	mov    0x18(%ebx),%eax
80103919:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010391d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103921:	8b 43 18             	mov    0x18(%ebx),%eax
80103924:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103928:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010392c:	8b 43 18             	mov    0x18(%ebx),%eax
8010392f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103936:	8b 43 18             	mov    0x18(%ebx),%eax
80103939:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103940:	8b 43 18             	mov    0x18(%ebx),%eax
80103943:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010394a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010394d:	6a 10                	push   $0x10
8010394f:	68 b0 75 10 80       	push   $0x801075b0
80103954:	50                   	push   %eax
80103955:	e8 96 0e 00 00       	call   801047f0 <safestrcpy>
  p->cwd = namei("/");
8010395a:	c7 04 24 b9 75 10 80 	movl   $0x801075b9,(%esp)
80103961:	e8 5a e6 ff ff       	call   80101fc0 <namei>
80103966:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103969:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103970:	e8 4b 0b 00 00       	call   801044c0 <acquire>
  p->state = RUNNABLE;
80103975:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010397c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103983:	e8 58 0c 00 00       	call   801045e0 <release>
}
80103988:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010398b:	83 c4 10             	add    $0x10,%esp
8010398e:	c9                   	leave  
8010398f:	c3                   	ret    
    panic("userinit: out of memory?");
80103990:	83 ec 0c             	sub    $0xc,%esp
80103993:	68 97 75 10 80       	push   $0x80107597
80103998:	e8 e3 c9 ff ff       	call   80100380 <panic>
8010399d:	8d 76 00             	lea    0x0(%esi),%esi

801039a0 <growproc>:
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	56                   	push   %esi
801039a4:	53                   	push   %ebx
801039a5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801039a8:	e8 c3 0a 00 00       	call   80104470 <pushcli>
  c = mycpu();
801039ad:	e8 3e fe ff ff       	call   801037f0 <mycpu>
  p = c->proc;
801039b2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039b8:	e8 c3 0b 00 00       	call   80104580 <popcli>
  sz = curproc->sz;
801039bd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801039bf:	85 f6                	test   %esi,%esi
801039c1:	7f 1d                	jg     801039e0 <growproc+0x40>
  } else if(n < 0){
801039c3:	75 3b                	jne    80103a00 <growproc+0x60>
  switchuvm(curproc);
801039c5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801039c8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801039ca:	53                   	push   %ebx
801039cb:	e8 c0 2f 00 00       	call   80106990 <switchuvm>
  return 0;
801039d0:	83 c4 10             	add    $0x10,%esp
801039d3:	31 c0                	xor    %eax,%eax
}
801039d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039d8:	5b                   	pop    %ebx
801039d9:	5e                   	pop    %esi
801039da:	5d                   	pop    %ebp
801039db:	c3                   	ret    
801039dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801039e0:	83 ec 04             	sub    $0x4,%esp
801039e3:	01 c6                	add    %eax,%esi
801039e5:	56                   	push   %esi
801039e6:	50                   	push   %eax
801039e7:	ff 73 04             	pushl  0x4(%ebx)
801039ea:	e8 f1 31 00 00       	call   80106be0 <allocuvm>
801039ef:	83 c4 10             	add    $0x10,%esp
801039f2:	85 c0                	test   %eax,%eax
801039f4:	75 cf                	jne    801039c5 <growproc+0x25>
      return -1;
801039f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039fb:	eb d8                	jmp    801039d5 <growproc+0x35>
801039fd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a00:	83 ec 04             	sub    $0x4,%esp
80103a03:	01 c6                	add    %eax,%esi
80103a05:	56                   	push   %esi
80103a06:	50                   	push   %eax
80103a07:	ff 73 04             	pushl  0x4(%ebx)
80103a0a:	e8 01 33 00 00       	call   80106d10 <deallocuvm>
80103a0f:	83 c4 10             	add    $0x10,%esp
80103a12:	85 c0                	test   %eax,%eax
80103a14:	75 af                	jne    801039c5 <growproc+0x25>
80103a16:	eb de                	jmp    801039f6 <growproc+0x56>
80103a18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a1f:	90                   	nop

80103a20 <fork>:
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	57                   	push   %edi
80103a24:	56                   	push   %esi
80103a25:	53                   	push   %ebx
80103a26:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103a29:	e8 42 0a 00 00       	call   80104470 <pushcli>
  c = mycpu();
80103a2e:	e8 bd fd ff ff       	call   801037f0 <mycpu>
  p = c->proc;
80103a33:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a39:	e8 42 0b 00 00       	call   80104580 <popcli>
  if((np = allocproc()) == 0){
80103a3e:	e8 5d fc ff ff       	call   801036a0 <allocproc>
80103a43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103a46:	85 c0                	test   %eax,%eax
80103a48:	0f 84 b7 00 00 00    	je     80103b05 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103a4e:	83 ec 08             	sub    $0x8,%esp
80103a51:	ff 33                	pushl  (%ebx)
80103a53:	89 c7                	mov    %eax,%edi
80103a55:	ff 73 04             	pushl  0x4(%ebx)
80103a58:	e8 33 34 00 00       	call   80106e90 <copyuvm>
80103a5d:	83 c4 10             	add    $0x10,%esp
80103a60:	89 47 04             	mov    %eax,0x4(%edi)
80103a63:	85 c0                	test   %eax,%eax
80103a65:	0f 84 a1 00 00 00    	je     80103b0c <fork+0xec>
  np->sz = curproc->sz;
80103a6b:	8b 03                	mov    (%ebx),%eax
80103a6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103a70:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103a72:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103a75:	89 c8                	mov    %ecx,%eax
80103a77:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103a7a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103a7f:	8b 73 18             	mov    0x18(%ebx),%esi
80103a82:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103a84:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103a86:	8b 40 18             	mov    0x18(%eax),%eax
80103a89:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103a90:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103a94:	85 c0                	test   %eax,%eax
80103a96:	74 13                	je     80103aab <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103a98:	83 ec 0c             	sub    $0xc,%esp
80103a9b:	50                   	push   %eax
80103a9c:	e8 cf d3 ff ff       	call   80100e70 <filedup>
80103aa1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103aa4:	83 c4 10             	add    $0x10,%esp
80103aa7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103aab:	83 c6 01             	add    $0x1,%esi
80103aae:	83 fe 10             	cmp    $0x10,%esi
80103ab1:	75 dd                	jne    80103a90 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103ab3:	83 ec 0c             	sub    $0xc,%esp
80103ab6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ab9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103abc:	e8 2f dc ff ff       	call   801016f0 <idup>
80103ac1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ac4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103ac7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103aca:	8d 47 6c             	lea    0x6c(%edi),%eax
80103acd:	6a 10                	push   $0x10
80103acf:	53                   	push   %ebx
80103ad0:	50                   	push   %eax
80103ad1:	e8 1a 0d 00 00       	call   801047f0 <safestrcpy>
  pid = np->pid;
80103ad6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103ad9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ae0:	e8 db 09 00 00       	call   801044c0 <acquire>
  np->state = RUNNABLE;
80103ae5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103aec:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103af3:	e8 e8 0a 00 00       	call   801045e0 <release>
  return pid;
80103af8:	83 c4 10             	add    $0x10,%esp
}
80103afb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103afe:	89 d8                	mov    %ebx,%eax
80103b00:	5b                   	pop    %ebx
80103b01:	5e                   	pop    %esi
80103b02:	5f                   	pop    %edi
80103b03:	5d                   	pop    %ebp
80103b04:	c3                   	ret    
    return -1;
80103b05:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103b0a:	eb ef                	jmp    80103afb <fork+0xdb>
    kfree(np->kstack);
80103b0c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103b0f:	83 ec 0c             	sub    $0xc,%esp
80103b12:	ff 73 08             	pushl  0x8(%ebx)
80103b15:	e8 c6 e8 ff ff       	call   801023e0 <kfree>
    np->kstack = 0;
80103b1a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103b21:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103b24:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103b2b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103b30:	eb c9                	jmp    80103afb <fork+0xdb>
80103b32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b40 <scheduler>:
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	57                   	push   %edi
80103b44:	56                   	push   %esi
80103b45:	53                   	push   %ebx
80103b46:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103b49:	e8 a2 fc ff ff       	call   801037f0 <mycpu>
  c->proc = 0;
80103b4e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103b55:	00 00 00 
  struct cpu *c = mycpu();
80103b58:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
80103b5a:	8d 70 04             	lea    0x4(%eax),%esi
80103b5d:	eb 1c                	jmp    80103b7b <scheduler+0x3b>
80103b5f:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b60:	83 ef 80             	sub    $0xffffff80,%edi
80103b63:	81 ff 54 4d 11 80    	cmp    $0x80114d54,%edi
80103b69:	72 26                	jb     80103b91 <scheduler+0x51>
    release(&ptable.lock);
80103b6b:	83 ec 0c             	sub    $0xc,%esp
80103b6e:	68 20 2d 11 80       	push   $0x80112d20
80103b73:	e8 68 0a 00 00       	call   801045e0 <release>
  for(;;){
80103b78:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
80103b7b:	fb                   	sti    
    acquire(&ptable.lock);
80103b7c:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b7f:	bf 54 2d 11 80       	mov    $0x80112d54,%edi
    acquire(&ptable.lock);
80103b84:	68 20 2d 11 80       	push   $0x80112d20
80103b89:	e8 32 09 00 00       	call   801044c0 <acquire>
80103b8e:	83 c4 10             	add    $0x10,%esp
      if(p->state != RUNNABLE)
80103b91:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80103b95:	75 c9                	jne    80103b60 <scheduler+0x20>
      for(p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
80103b97:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	 if(p1->state != RUNNABLE)
80103ba0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103ba4:	75 09                	jne    80103baf <scheduler+0x6f>
	 if ( highP->priority > p1->priority ) // larger value, lower priority
80103ba6:	8b 50 7c             	mov    0x7c(%eax),%edx
80103ba9:	39 57 7c             	cmp    %edx,0x7c(%edi)
80103bac:	0f 4f f8             	cmovg  %eax,%edi
      for(p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
80103baf:	83 e8 80             	sub    $0xffffff80,%eax
80103bb2:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103bb7:	75 e7                	jne    80103ba0 <scheduler+0x60>
      switchuvm(p);
80103bb9:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103bbc:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
      switchuvm(p);
80103bc2:	57                   	push   %edi
80103bc3:	e8 c8 2d 00 00       	call   80106990 <switchuvm>
      p->state = RUNNING;
80103bc8:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
      swtch(&(c->scheduler), p->context);
80103bcf:	58                   	pop    %eax
80103bd0:	5a                   	pop    %edx
80103bd1:	ff 77 1c             	pushl  0x1c(%edi)
80103bd4:	56                   	push   %esi
80103bd5:	e8 71 0c 00 00       	call   8010484b <swtch>
      switchkvm();
80103bda:	e8 a1 2d 00 00       	call   80106980 <switchkvm>
      c->proc = 0;
80103bdf:	83 c4 10             	add    $0x10,%esp
80103be2:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103be9:	00 00 00 
80103bec:	e9 6f ff ff ff       	jmp    80103b60 <scheduler+0x20>
80103bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bff:	90                   	nop

80103c00 <sched>:
{
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	56                   	push   %esi
80103c04:	53                   	push   %ebx
  pushcli();
80103c05:	e8 66 08 00 00       	call   80104470 <pushcli>
  c = mycpu();
80103c0a:	e8 e1 fb ff ff       	call   801037f0 <mycpu>
  p = c->proc;
80103c0f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c15:	e8 66 09 00 00       	call   80104580 <popcli>
  if(!holding(&ptable.lock))
80103c1a:	83 ec 0c             	sub    $0xc,%esp
80103c1d:	68 20 2d 11 80       	push   $0x80112d20
80103c22:	e8 09 08 00 00       	call   80104430 <holding>
80103c27:	83 c4 10             	add    $0x10,%esp
80103c2a:	85 c0                	test   %eax,%eax
80103c2c:	74 4f                	je     80103c7d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103c2e:	e8 bd fb ff ff       	call   801037f0 <mycpu>
80103c33:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103c3a:	75 68                	jne    80103ca4 <sched+0xa4>
  if(p->state == RUNNING)
80103c3c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103c40:	74 55                	je     80103c97 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c42:	9c                   	pushf  
80103c43:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c44:	f6 c4 02             	test   $0x2,%ah
80103c47:	75 41                	jne    80103c8a <sched+0x8a>
  intena = mycpu()->intena;
80103c49:	e8 a2 fb ff ff       	call   801037f0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103c4e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103c51:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103c57:	e8 94 fb ff ff       	call   801037f0 <mycpu>
80103c5c:	83 ec 08             	sub    $0x8,%esp
80103c5f:	ff 70 04             	pushl  0x4(%eax)
80103c62:	53                   	push   %ebx
80103c63:	e8 e3 0b 00 00       	call   8010484b <swtch>
  mycpu()->intena = intena;
80103c68:	e8 83 fb ff ff       	call   801037f0 <mycpu>
}
80103c6d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103c70:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103c76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c79:	5b                   	pop    %ebx
80103c7a:	5e                   	pop    %esi
80103c7b:	5d                   	pop    %ebp
80103c7c:	c3                   	ret    
    panic("sched ptable.lock");
80103c7d:	83 ec 0c             	sub    $0xc,%esp
80103c80:	68 bb 75 10 80       	push   $0x801075bb
80103c85:	e8 f6 c6 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103c8a:	83 ec 0c             	sub    $0xc,%esp
80103c8d:	68 e7 75 10 80       	push   $0x801075e7
80103c92:	e8 e9 c6 ff ff       	call   80100380 <panic>
    panic("sched running");
80103c97:	83 ec 0c             	sub    $0xc,%esp
80103c9a:	68 d9 75 10 80       	push   $0x801075d9
80103c9f:	e8 dc c6 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103ca4:	83 ec 0c             	sub    $0xc,%esp
80103ca7:	68 cd 75 10 80       	push   $0x801075cd
80103cac:	e8 cf c6 ff ff       	call   80100380 <panic>
80103cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cbf:	90                   	nop

80103cc0 <exit>:
{
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	57                   	push   %edi
80103cc4:	56                   	push   %esi
80103cc5:	53                   	push   %ebx
80103cc6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103cc9:	e8 a2 07 00 00       	call   80104470 <pushcli>
  c = mycpu();
80103cce:	e8 1d fb ff ff       	call   801037f0 <mycpu>
  p = c->proc;
80103cd3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103cd9:	e8 a2 08 00 00       	call   80104580 <popcli>
  if(curproc == initproc)
80103cde:	8d 5e 28             	lea    0x28(%esi),%ebx
80103ce1:	8d 7e 68             	lea    0x68(%esi),%edi
80103ce4:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103cea:	0f 84 e7 00 00 00    	je     80103dd7 <exit+0x117>
    if(curproc->ofile[fd]){
80103cf0:	8b 03                	mov    (%ebx),%eax
80103cf2:	85 c0                	test   %eax,%eax
80103cf4:	74 12                	je     80103d08 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103cf6:	83 ec 0c             	sub    $0xc,%esp
80103cf9:	50                   	push   %eax
80103cfa:	e8 c1 d1 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80103cff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103d05:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103d08:	83 c3 04             	add    $0x4,%ebx
80103d0b:	39 df                	cmp    %ebx,%edi
80103d0d:	75 e1                	jne    80103cf0 <exit+0x30>
  begin_op();
80103d0f:	e8 6c ef ff ff       	call   80102c80 <begin_op>
  iput(curproc->cwd);
80103d14:	83 ec 0c             	sub    $0xc,%esp
80103d17:	ff 76 68             	pushl  0x68(%esi)
80103d1a:	e8 31 db ff ff       	call   80101850 <iput>
  end_op();
80103d1f:	e8 cc ef ff ff       	call   80102cf0 <end_op>
  curproc->cwd = 0;
80103d24:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103d2b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d32:	e8 89 07 00 00       	call   801044c0 <acquire>
  wakeup1(curproc->parent);
80103d37:	8b 56 14             	mov    0x14(%esi),%edx
80103d3a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d3d:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d42:	eb 0e                	jmp    80103d52 <exit+0x92>
80103d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d48:	83 e8 80             	sub    $0xffffff80,%eax
80103d4b:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103d50:	74 1c                	je     80103d6e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103d52:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d56:	75 f0                	jne    80103d48 <exit+0x88>
80103d58:	3b 50 20             	cmp    0x20(%eax),%edx
80103d5b:	75 eb                	jne    80103d48 <exit+0x88>
      p->state = RUNNABLE;
80103d5d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d64:	83 e8 80             	sub    $0xffffff80,%eax
80103d67:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103d6c:	75 e4                	jne    80103d52 <exit+0x92>
      p->parent = initproc;
80103d6e:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d74:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103d79:	eb 10                	jmp    80103d8b <exit+0xcb>
80103d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d7f:	90                   	nop
80103d80:	83 ea 80             	sub    $0xffffff80,%edx
80103d83:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103d89:	74 33                	je     80103dbe <exit+0xfe>
    if(p->parent == curproc){
80103d8b:	39 72 14             	cmp    %esi,0x14(%edx)
80103d8e:	75 f0                	jne    80103d80 <exit+0xc0>
      if(p->state == ZOMBIE)
80103d90:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103d94:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103d97:	75 e7                	jne    80103d80 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d99:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d9e:	eb 0a                	jmp    80103daa <exit+0xea>
80103da0:	83 e8 80             	sub    $0xffffff80,%eax
80103da3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103da8:	74 d6                	je     80103d80 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103daa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103dae:	75 f0                	jne    80103da0 <exit+0xe0>
80103db0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103db3:	75 eb                	jne    80103da0 <exit+0xe0>
      p->state = RUNNABLE;
80103db5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103dbc:	eb e2                	jmp    80103da0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103dbe:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103dc5:	e8 36 fe ff ff       	call   80103c00 <sched>
  panic("zombie exit");
80103dca:	83 ec 0c             	sub    $0xc,%esp
80103dcd:	68 08 76 10 80       	push   $0x80107608
80103dd2:	e8 a9 c5 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103dd7:	83 ec 0c             	sub    $0xc,%esp
80103dda:	68 fb 75 10 80       	push   $0x801075fb
80103ddf:	e8 9c c5 ff ff       	call   80100380 <panic>
80103de4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103def:	90                   	nop

80103df0 <yield>:
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	53                   	push   %ebx
80103df4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103df7:	68 20 2d 11 80       	push   $0x80112d20
80103dfc:	e8 bf 06 00 00       	call   801044c0 <acquire>
  pushcli();
80103e01:	e8 6a 06 00 00       	call   80104470 <pushcli>
  c = mycpu();
80103e06:	e8 e5 f9 ff ff       	call   801037f0 <mycpu>
  p = c->proc;
80103e0b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e11:	e8 6a 07 00 00       	call   80104580 <popcli>
  myproc()->state = RUNNABLE;
80103e16:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103e1d:	e8 de fd ff ff       	call   80103c00 <sched>
  release(&ptable.lock);
80103e22:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e29:	e8 b2 07 00 00       	call   801045e0 <release>
}
80103e2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e31:	83 c4 10             	add    $0x10,%esp
80103e34:	c9                   	leave  
80103e35:	c3                   	ret    
80103e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e3d:	8d 76 00             	lea    0x0(%esi),%esi

80103e40 <sleep>:
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	57                   	push   %edi
80103e44:	56                   	push   %esi
80103e45:	53                   	push   %ebx
80103e46:	83 ec 0c             	sub    $0xc,%esp
80103e49:	8b 7d 08             	mov    0x8(%ebp),%edi
80103e4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103e4f:	e8 1c 06 00 00       	call   80104470 <pushcli>
  c = mycpu();
80103e54:	e8 97 f9 ff ff       	call   801037f0 <mycpu>
  p = c->proc;
80103e59:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e5f:	e8 1c 07 00 00       	call   80104580 <popcli>
  if(p == 0)
80103e64:	85 db                	test   %ebx,%ebx
80103e66:	0f 84 87 00 00 00    	je     80103ef3 <sleep+0xb3>
  if(lk == 0)
80103e6c:	85 f6                	test   %esi,%esi
80103e6e:	74 76                	je     80103ee6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103e70:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103e76:	74 50                	je     80103ec8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103e78:	83 ec 0c             	sub    $0xc,%esp
80103e7b:	68 20 2d 11 80       	push   $0x80112d20
80103e80:	e8 3b 06 00 00       	call   801044c0 <acquire>
    release(lk);
80103e85:	89 34 24             	mov    %esi,(%esp)
80103e88:	e8 53 07 00 00       	call   801045e0 <release>
  p->chan = chan;
80103e8d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e90:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103e97:	e8 64 fd ff ff       	call   80103c00 <sched>
  p->chan = 0;
80103e9c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103ea3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103eaa:	e8 31 07 00 00       	call   801045e0 <release>
    acquire(lk);
80103eaf:	89 75 08             	mov    %esi,0x8(%ebp)
80103eb2:	83 c4 10             	add    $0x10,%esp
}
80103eb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103eb8:	5b                   	pop    %ebx
80103eb9:	5e                   	pop    %esi
80103eba:	5f                   	pop    %edi
80103ebb:	5d                   	pop    %ebp
    acquire(lk);
80103ebc:	e9 ff 05 00 00       	jmp    801044c0 <acquire>
80103ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103ec8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103ecb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103ed2:	e8 29 fd ff ff       	call   80103c00 <sched>
  p->chan = 0;
80103ed7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103ede:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ee1:	5b                   	pop    %ebx
80103ee2:	5e                   	pop    %esi
80103ee3:	5f                   	pop    %edi
80103ee4:	5d                   	pop    %ebp
80103ee5:	c3                   	ret    
    panic("sleep without lk");
80103ee6:	83 ec 0c             	sub    $0xc,%esp
80103ee9:	68 1a 76 10 80       	push   $0x8010761a
80103eee:	e8 8d c4 ff ff       	call   80100380 <panic>
    panic("sleep");
80103ef3:	83 ec 0c             	sub    $0xc,%esp
80103ef6:	68 14 76 10 80       	push   $0x80107614
80103efb:	e8 80 c4 ff ff       	call   80100380 <panic>

80103f00 <wait>:
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	56                   	push   %esi
80103f04:	53                   	push   %ebx
  pushcli();
80103f05:	e8 66 05 00 00       	call   80104470 <pushcli>
  c = mycpu();
80103f0a:	e8 e1 f8 ff ff       	call   801037f0 <mycpu>
  p = c->proc;
80103f0f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f15:	e8 66 06 00 00       	call   80104580 <popcli>
  acquire(&ptable.lock);
80103f1a:	83 ec 0c             	sub    $0xc,%esp
80103f1d:	68 20 2d 11 80       	push   $0x80112d20
80103f22:	e8 99 05 00 00       	call   801044c0 <acquire>
80103f27:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f2a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f2c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103f31:	eb 10                	jmp    80103f43 <wait+0x43>
80103f33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f37:	90                   	nop
80103f38:	83 eb 80             	sub    $0xffffff80,%ebx
80103f3b:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103f41:	74 1b                	je     80103f5e <wait+0x5e>
      if(p->parent != curproc)
80103f43:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f46:	75 f0                	jne    80103f38 <wait+0x38>
      if(p->state == ZOMBIE){
80103f48:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f4c:	74 32                	je     80103f80 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f4e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80103f51:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f56:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103f5c:	75 e5                	jne    80103f43 <wait+0x43>
    if(!havekids || curproc->killed){
80103f5e:	85 c0                	test   %eax,%eax
80103f60:	74 74                	je     80103fd6 <wait+0xd6>
80103f62:	8b 46 24             	mov    0x24(%esi),%eax
80103f65:	85 c0                	test   %eax,%eax
80103f67:	75 6d                	jne    80103fd6 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103f69:	83 ec 08             	sub    $0x8,%esp
80103f6c:	68 20 2d 11 80       	push   $0x80112d20
80103f71:	56                   	push   %esi
80103f72:	e8 c9 fe ff ff       	call   80103e40 <sleep>
    havekids = 0;
80103f77:	83 c4 10             	add    $0x10,%esp
80103f7a:	eb ae                	jmp    80103f2a <wait+0x2a>
80103f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80103f80:	83 ec 0c             	sub    $0xc,%esp
80103f83:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103f86:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f89:	e8 52 e4 ff ff       	call   801023e0 <kfree>
        freevm(p->pgdir);
80103f8e:	5a                   	pop    %edx
80103f8f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80103f92:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f99:	e8 a2 2d 00 00       	call   80106d40 <freevm>
        release(&ptable.lock);
80103f9e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103fa5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103fac:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103fb3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103fb7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103fbe:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103fc5:	e8 16 06 00 00       	call   801045e0 <release>
        return pid;
80103fca:	83 c4 10             	add    $0x10,%esp
}
80103fcd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fd0:	89 f0                	mov    %esi,%eax
80103fd2:	5b                   	pop    %ebx
80103fd3:	5e                   	pop    %esi
80103fd4:	5d                   	pop    %ebp
80103fd5:	c3                   	ret    
      release(&ptable.lock);
80103fd6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103fd9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103fde:	68 20 2d 11 80       	push   $0x80112d20
80103fe3:	e8 f8 05 00 00       	call   801045e0 <release>
      return -1;
80103fe8:	83 c4 10             	add    $0x10,%esp
80103feb:	eb e0                	jmp    80103fcd <wait+0xcd>
80103fed:	8d 76 00             	lea    0x0(%esi),%esi

80103ff0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	53                   	push   %ebx
80103ff4:	83 ec 10             	sub    $0x10,%esp
80103ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103ffa:	68 20 2d 11 80       	push   $0x80112d20
80103fff:	e8 bc 04 00 00       	call   801044c0 <acquire>
80104004:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104007:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010400c:	eb 0c                	jmp    8010401a <wakeup+0x2a>
8010400e:	66 90                	xchg   %ax,%ax
80104010:	83 e8 80             	sub    $0xffffff80,%eax
80104013:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104018:	74 1c                	je     80104036 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010401a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010401e:	75 f0                	jne    80104010 <wakeup+0x20>
80104020:	3b 58 20             	cmp    0x20(%eax),%ebx
80104023:	75 eb                	jne    80104010 <wakeup+0x20>
      p->state = RUNNABLE;
80104025:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010402c:	83 e8 80             	sub    $0xffffff80,%eax
8010402f:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104034:	75 e4                	jne    8010401a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104036:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
8010403d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104040:	c9                   	leave  
  release(&ptable.lock);
80104041:	e9 9a 05 00 00       	jmp    801045e0 <release>
80104046:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010404d:	8d 76 00             	lea    0x0(%esi),%esi

80104050 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	53                   	push   %ebx
80104054:	83 ec 10             	sub    $0x10,%esp
80104057:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010405a:	68 20 2d 11 80       	push   $0x80112d20
8010405f:	e8 5c 04 00 00       	call   801044c0 <acquire>
80104064:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104067:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010406c:	eb 0c                	jmp    8010407a <kill+0x2a>
8010406e:	66 90                	xchg   %ax,%ax
80104070:	83 e8 80             	sub    $0xffffff80,%eax
80104073:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104078:	74 36                	je     801040b0 <kill+0x60>
    if(p->pid == pid){
8010407a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010407d:	75 f1                	jne    80104070 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010407f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104083:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010408a:	75 07                	jne    80104093 <kill+0x43>
        p->state = RUNNABLE;
8010408c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104093:	83 ec 0c             	sub    $0xc,%esp
80104096:	68 20 2d 11 80       	push   $0x80112d20
8010409b:	e8 40 05 00 00       	call   801045e0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801040a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801040a3:	83 c4 10             	add    $0x10,%esp
801040a6:	31 c0                	xor    %eax,%eax
}
801040a8:	c9                   	leave  
801040a9:	c3                   	ret    
801040aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801040b0:	83 ec 0c             	sub    $0xc,%esp
801040b3:	68 20 2d 11 80       	push   $0x80112d20
801040b8:	e8 23 05 00 00       	call   801045e0 <release>
}
801040bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801040c0:	83 c4 10             	add    $0x10,%esp
801040c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801040c8:	c9                   	leave  
801040c9:	c3                   	ret    
801040ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040d0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	57                   	push   %edi
801040d4:	56                   	push   %esi
801040d5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801040d8:	53                   	push   %ebx
801040d9:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
801040de:	83 ec 3c             	sub    $0x3c,%esp
801040e1:	eb 24                	jmp    80104107 <procdump+0x37>
801040e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040e7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801040e8:	83 ec 0c             	sub    $0xc,%esp
801040eb:	68 1f 7a 10 80       	push   $0x80107a1f
801040f0:	e8 ab c5 ff ff       	call   801006a0 <cprintf>
801040f5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040f8:	83 eb 80             	sub    $0xffffff80,%ebx
801040fb:	81 fb c0 4d 11 80    	cmp    $0x80114dc0,%ebx
80104101:	0f 84 81 00 00 00    	je     80104188 <procdump+0xb8>
    if(p->state == UNUSED)
80104107:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010410a:	85 c0                	test   %eax,%eax
8010410c:	74 ea                	je     801040f8 <procdump+0x28>
      state = "???";
8010410e:	ba 2b 76 10 80       	mov    $0x8010762b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104113:	83 f8 05             	cmp    $0x5,%eax
80104116:	77 11                	ja     80104129 <procdump+0x59>
80104118:	8b 14 85 fc 76 10 80 	mov    -0x7fef8904(,%eax,4),%edx
      state = "???";
8010411f:	b8 2b 76 10 80       	mov    $0x8010762b,%eax
80104124:	85 d2                	test   %edx,%edx
80104126:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104129:	53                   	push   %ebx
8010412a:	52                   	push   %edx
8010412b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010412e:	68 2f 76 10 80       	push   $0x8010762f
80104133:	e8 68 c5 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104138:	83 c4 10             	add    $0x10,%esp
8010413b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010413f:	75 a7                	jne    801040e8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104141:	83 ec 08             	sub    $0x8,%esp
80104144:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104147:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010414a:	50                   	push   %eax
8010414b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010414e:	8b 40 0c             	mov    0xc(%eax),%eax
80104151:	83 c0 08             	add    $0x8,%eax
80104154:	50                   	push   %eax
80104155:	e8 86 02 00 00       	call   801043e0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010415a:	83 c4 10             	add    $0x10,%esp
8010415d:	8d 76 00             	lea    0x0(%esi),%esi
80104160:	8b 17                	mov    (%edi),%edx
80104162:	85 d2                	test   %edx,%edx
80104164:	74 82                	je     801040e8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104166:	83 ec 08             	sub    $0x8,%esp
80104169:	83 c7 04             	add    $0x4,%edi
8010416c:	52                   	push   %edx
8010416d:	68 81 70 10 80       	push   $0x80107081
80104172:	e8 29 c5 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104177:	83 c4 10             	add    $0x10,%esp
8010417a:	39 fe                	cmp    %edi,%esi
8010417c:	75 e2                	jne    80104160 <procdump+0x90>
8010417e:	e9 65 ff ff ff       	jmp    801040e8 <procdump+0x18>
80104183:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104187:	90                   	nop
  }
}
80104188:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010418b:	5b                   	pop    %ebx
8010418c:	5e                   	pop    %esi
8010418d:	5f                   	pop    %edi
8010418e:	5d                   	pop    %ebp
8010418f:	c3                   	ret    

80104190 <cps>:


int
cps()
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	53                   	push   %ebx
80104194:	83 ec 10             	sub    $0x10,%esp
  asm volatile("sti");
80104197:	fb                   	sti    
 struct proc *p;

 // Enable interrupts on this processor.
 sti();
 // Loop over process table looking for process with pid.
 acquire(&ptable.lock);
80104198:	68 20 2d 11 80       	push   $0x80112d20
 cprintf("name \t pid \t state \t priority \t  \n");
 for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010419d:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
 acquire(&ptable.lock);
801041a2:	e8 19 03 00 00       	call   801044c0 <acquire>
 cprintf("name \t pid \t state \t priority \t  \n");
801041a7:	c7 04 24 d8 76 10 80 	movl   $0x801076d8,(%esp)
801041ae:	e8 ed c4 ff ff       	call   801006a0 <cprintf>
801041b3:	83 c4 10             	add    $0x10,%esp
801041b6:	eb 1d                	jmp    801041d5 <cps+0x45>
801041b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041bf:	90                   	nop
	 if ( p->state == SLEEPING ){
 cprintf("%s \t %d \t SLEEPING \t %d\n ", p->name, p->pid, p->priority );
 }
 else if ( p->state == RUNNING ){
801041c0:	83 f8 04             	cmp    $0x4,%eax
801041c3:	74 5b                	je     80104220 <cps+0x90>
 cprintf("%s \t %d \t RUNNING \t %d\n ", p->name, p->pid, p->priority );
 }
else if (p->state == RUNNABLE){
801041c5:	83 f8 03             	cmp    $0x3,%eax
801041c8:	74 76                	je     80104240 <cps+0xb0>
 for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041ca:	83 eb 80             	sub    $0xffffff80,%ebx
801041cd:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801041d3:	74 2a                	je     801041ff <cps+0x6f>
	 if ( p->state == SLEEPING ){
801041d5:	8b 43 0c             	mov    0xc(%ebx),%eax
801041d8:	83 f8 02             	cmp    $0x2,%eax
801041db:	75 e3                	jne    801041c0 <cps+0x30>
 cprintf("%s \t %d \t SLEEPING \t %d\n ", p->name, p->pid, p->priority );
801041dd:	8d 43 6c             	lea    0x6c(%ebx),%eax
801041e0:	ff 73 7c             	pushl  0x7c(%ebx)
 for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041e3:	83 eb 80             	sub    $0xffffff80,%ebx
 cprintf("%s \t %d \t SLEEPING \t %d\n ", p->name, p->pid, p->priority );
801041e6:	ff 73 90             	pushl  -0x70(%ebx)
801041e9:	50                   	push   %eax
801041ea:	68 38 76 10 80       	push   $0x80107638
801041ef:	e8 ac c4 ff ff       	call   801006a0 <cprintf>
801041f4:	83 c4 10             	add    $0x10,%esp
 for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041f7:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801041fd:	75 d6                	jne    801041d5 <cps+0x45>
 cprintf("%s \t %d \t RUNNABLE \t %d\n ", p->name, p->pid, p->priority );
 }
	}
 release(&ptable.lock);
801041ff:	83 ec 0c             	sub    $0xc,%esp
80104202:	68 20 2d 11 80       	push   $0x80112d20
80104207:	e8 d4 03 00 00       	call   801045e0 <release>

 return 22;
}
8010420c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010420f:	b8 16 00 00 00       	mov    $0x16,%eax
80104214:	c9                   	leave  
80104215:	c3                   	ret    
80104216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010421d:	8d 76 00             	lea    0x0(%esi),%esi
 cprintf("%s \t %d \t RUNNING \t %d\n ", p->name, p->pid, p->priority );
80104220:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104223:	ff 73 7c             	pushl  0x7c(%ebx)
80104226:	ff 73 10             	pushl  0x10(%ebx)
80104229:	50                   	push   %eax
8010422a:	68 52 76 10 80       	push   $0x80107652
8010422f:	e8 6c c4 ff ff       	call   801006a0 <cprintf>
80104234:	83 c4 10             	add    $0x10,%esp
80104237:	eb 91                	jmp    801041ca <cps+0x3a>
80104239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 cprintf("%s \t %d \t RUNNABLE \t %d\n ", p->name, p->pid, p->priority );
80104240:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104243:	ff 73 7c             	pushl  0x7c(%ebx)
80104246:	ff 73 10             	pushl  0x10(%ebx)
80104249:	50                   	push   %eax
8010424a:	68 6b 76 10 80       	push   $0x8010766b
8010424f:	e8 4c c4 ff ff       	call   801006a0 <cprintf>
80104254:	83 c4 10             	add    $0x10,%esp
80104257:	e9 6e ff ff ff       	jmp    801041ca <cps+0x3a>
8010425c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104260 <chpr>:

//change priority
int
chpr( int pid, int priority )
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	53                   	push   %ebx
80104264:	83 ec 10             	sub    $0x10,%esp
80104267:	8b 5d 08             	mov    0x8(%ebp),%ebx
 struct proc *p;

 acquire(&ptable.lock);
8010426a:	68 20 2d 11 80       	push   $0x80112d20
8010426f:	e8 4c 02 00 00       	call   801044c0 <acquire>
80104274:	83 c4 10             	add    $0x10,%esp
 for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104277:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010427c:	eb 0c                	jmp    8010428a <chpr+0x2a>
8010427e:	66 90                	xchg   %ax,%ax
80104280:	83 e8 80             	sub    $0xffffff80,%eax
80104283:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104288:	74 0b                	je     80104295 <chpr+0x35>
 if(p->pid == pid ) {
8010428a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010428d:	75 f1                	jne    80104280 <chpr+0x20>
 p->priority = priority;
8010428f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104292:	89 50 7c             	mov    %edx,0x7c(%eax)
 break;
 }
 }
 release(&ptable.lock);
80104295:	83 ec 0c             	sub    $0xc,%esp
80104298:	68 20 2d 11 80       	push   $0x80112d20
8010429d:	e8 3e 03 00 00       	call   801045e0 <release>
 return pid;
}
801042a2:	89 d8                	mov    %ebx,%eax
801042a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042a7:	c9                   	leave  
801042a8:	c3                   	ret    
801042a9:	66 90                	xchg   %ax,%ax
801042ab:	66 90                	xchg   %ax,%ax
801042ad:	66 90                	xchg   %ax,%ax
801042af:	90                   	nop

801042b0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	53                   	push   %ebx
801042b4:	83 ec 0c             	sub    $0xc,%esp
801042b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801042ba:	68 14 77 10 80       	push   $0x80107714
801042bf:	8d 43 04             	lea    0x4(%ebx),%eax
801042c2:	50                   	push   %eax
801042c3:	e8 f8 00 00 00       	call   801043c0 <initlock>
  lk->name = name;
801042c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801042cb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801042d1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801042d4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801042db:	89 43 38             	mov    %eax,0x38(%ebx)
}
801042de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042e1:	c9                   	leave  
801042e2:	c3                   	ret    
801042e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042f0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	56                   	push   %esi
801042f4:	53                   	push   %ebx
801042f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801042f8:	8d 73 04             	lea    0x4(%ebx),%esi
801042fb:	83 ec 0c             	sub    $0xc,%esp
801042fe:	56                   	push   %esi
801042ff:	e8 bc 01 00 00       	call   801044c0 <acquire>
  while (lk->locked) {
80104304:	8b 13                	mov    (%ebx),%edx
80104306:	83 c4 10             	add    $0x10,%esp
80104309:	85 d2                	test   %edx,%edx
8010430b:	74 16                	je     80104323 <acquiresleep+0x33>
8010430d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104310:	83 ec 08             	sub    $0x8,%esp
80104313:	56                   	push   %esi
80104314:	53                   	push   %ebx
80104315:	e8 26 fb ff ff       	call   80103e40 <sleep>
  while (lk->locked) {
8010431a:	8b 03                	mov    (%ebx),%eax
8010431c:	83 c4 10             	add    $0x10,%esp
8010431f:	85 c0                	test   %eax,%eax
80104321:	75 ed                	jne    80104310 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104323:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104329:	e8 52 f5 ff ff       	call   80103880 <myproc>
8010432e:	8b 40 10             	mov    0x10(%eax),%eax
80104331:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104334:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104337:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010433a:	5b                   	pop    %ebx
8010433b:	5e                   	pop    %esi
8010433c:	5d                   	pop    %ebp
  release(&lk->lk);
8010433d:	e9 9e 02 00 00       	jmp    801045e0 <release>
80104342:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104350 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	56                   	push   %esi
80104354:	53                   	push   %ebx
80104355:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104358:	8d 73 04             	lea    0x4(%ebx),%esi
8010435b:	83 ec 0c             	sub    $0xc,%esp
8010435e:	56                   	push   %esi
8010435f:	e8 5c 01 00 00       	call   801044c0 <acquire>
  lk->locked = 0;
80104364:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010436a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104371:	89 1c 24             	mov    %ebx,(%esp)
80104374:	e8 77 fc ff ff       	call   80103ff0 <wakeup>
  release(&lk->lk);
80104379:	89 75 08             	mov    %esi,0x8(%ebp)
8010437c:	83 c4 10             	add    $0x10,%esp
}
8010437f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104382:	5b                   	pop    %ebx
80104383:	5e                   	pop    %esi
80104384:	5d                   	pop    %ebp
  release(&lk->lk);
80104385:	e9 56 02 00 00       	jmp    801045e0 <release>
8010438a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104390 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	56                   	push   %esi
80104394:	53                   	push   %ebx
80104395:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104398:	8d 5e 04             	lea    0x4(%esi),%ebx
8010439b:	83 ec 0c             	sub    $0xc,%esp
8010439e:	53                   	push   %ebx
8010439f:	e8 1c 01 00 00       	call   801044c0 <acquire>
  r = lk->locked;
801043a4:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801043a6:	89 1c 24             	mov    %ebx,(%esp)
801043a9:	e8 32 02 00 00       	call   801045e0 <release>
  return r;
}
801043ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043b1:	89 f0                	mov    %esi,%eax
801043b3:	5b                   	pop    %ebx
801043b4:	5e                   	pop    %esi
801043b5:	5d                   	pop    %ebp
801043b6:	c3                   	ret    
801043b7:	66 90                	xchg   %ax,%ax
801043b9:	66 90                	xchg   %ax,%ax
801043bb:	66 90                	xchg   %ax,%ax
801043bd:	66 90                	xchg   %ax,%ax
801043bf:	90                   	nop

801043c0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801043c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801043c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801043cf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801043d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801043d9:	5d                   	pop    %ebp
801043da:	c3                   	ret    
801043db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043df:	90                   	nop

801043e0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801043e0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043e1:	31 d2                	xor    %edx,%edx
{
801043e3:	89 e5                	mov    %esp,%ebp
801043e5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801043e6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801043e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801043ec:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801043ef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801043f0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801043f6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801043fc:	77 1a                	ja     80104418 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801043fe:	8b 58 04             	mov    0x4(%eax),%ebx
80104401:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104404:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104407:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104409:	83 fa 0a             	cmp    $0xa,%edx
8010440c:	75 e2                	jne    801043f0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010440e:	5b                   	pop    %ebx
8010440f:	5d                   	pop    %ebp
80104410:	c3                   	ret    
80104411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104418:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010441b:	8d 51 28             	lea    0x28(%ecx),%edx
8010441e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104420:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104426:	83 c0 04             	add    $0x4,%eax
80104429:	39 d0                	cmp    %edx,%eax
8010442b:	75 f3                	jne    80104420 <getcallerpcs+0x40>
}
8010442d:	5b                   	pop    %ebx
8010442e:	5d                   	pop    %ebp
8010442f:	c3                   	ret    

80104430 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	53                   	push   %ebx
80104434:	83 ec 04             	sub    $0x4,%esp
80104437:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010443a:	8b 02                	mov    (%edx),%eax
8010443c:	85 c0                	test   %eax,%eax
8010443e:	75 10                	jne    80104450 <holding+0x20>
}
80104440:	83 c4 04             	add    $0x4,%esp
80104443:	31 c0                	xor    %eax,%eax
80104445:	5b                   	pop    %ebx
80104446:	5d                   	pop    %ebp
80104447:	c3                   	ret    
80104448:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010444f:	90                   	nop
  return lock->locked && lock->cpu == mycpu();
80104450:	8b 5a 08             	mov    0x8(%edx),%ebx
80104453:	e8 98 f3 ff ff       	call   801037f0 <mycpu>
80104458:	39 c3                	cmp    %eax,%ebx
8010445a:	0f 94 c0             	sete   %al
}
8010445d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104460:	0f b6 c0             	movzbl %al,%eax
}
80104463:	5b                   	pop    %ebx
80104464:	5d                   	pop    %ebp
80104465:	c3                   	ret    
80104466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010446d:	8d 76 00             	lea    0x0(%esi),%esi

80104470 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	53                   	push   %ebx
80104474:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104477:	9c                   	pushf  
80104478:	5b                   	pop    %ebx
  asm volatile("cli");
80104479:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010447a:	e8 71 f3 ff ff       	call   801037f0 <mycpu>
8010447f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104485:	85 c0                	test   %eax,%eax
80104487:	74 17                	je     801044a0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104489:	e8 62 f3 ff ff       	call   801037f0 <mycpu>
8010448e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104495:	83 c4 04             	add    $0x4,%esp
80104498:	5b                   	pop    %ebx
80104499:	5d                   	pop    %ebp
8010449a:	c3                   	ret    
8010449b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010449f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801044a0:	e8 4b f3 ff ff       	call   801037f0 <mycpu>
801044a5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801044ab:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801044b1:	eb d6                	jmp    80104489 <pushcli+0x19>
801044b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044c0 <acquire>:
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	56                   	push   %esi
801044c4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801044c5:	e8 a6 ff ff ff       	call   80104470 <pushcli>
  if(holding(lk))
801044ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801044cd:	8b 03                	mov    (%ebx),%eax
801044cf:	85 c0                	test   %eax,%eax
801044d1:	0f 85 81 00 00 00    	jne    80104558 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
801044d7:	ba 01 00 00 00       	mov    $0x1,%edx
801044dc:	eb 05                	jmp    801044e3 <acquire+0x23>
801044de:	66 90                	xchg   %ax,%ax
801044e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044e3:	89 d0                	mov    %edx,%eax
801044e5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801044e8:	85 c0                	test   %eax,%eax
801044ea:	75 f4                	jne    801044e0 <acquire+0x20>
  __sync_synchronize();
801044ec:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801044f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044f4:	e8 f7 f2 ff ff       	call   801037f0 <mycpu>
  ebp = (uint*)v - 2;
801044f9:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801044fb:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801044fe:	31 c0                	xor    %eax,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104500:	8d 8a 00 00 00 80    	lea    -0x80000000(%edx),%ecx
80104506:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
8010450c:	77 22                	ja     80104530 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
8010450e:	8b 4a 04             	mov    0x4(%edx),%ecx
80104511:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
  for(i = 0; i < 10; i++){
80104515:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104518:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010451a:	83 f8 0a             	cmp    $0xa,%eax
8010451d:	75 e1                	jne    80104500 <acquire+0x40>
}
8010451f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104522:	5b                   	pop    %ebx
80104523:	5e                   	pop    %esi
80104524:	5d                   	pop    %ebp
80104525:	c3                   	ret    
80104526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010452d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104530:	8d 44 83 0c          	lea    0xc(%ebx,%eax,4),%eax
80104534:	83 c3 34             	add    $0x34,%ebx
80104537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010453e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104540:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104546:	83 c0 04             	add    $0x4,%eax
80104549:	39 d8                	cmp    %ebx,%eax
8010454b:	75 f3                	jne    80104540 <acquire+0x80>
}
8010454d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104550:	5b                   	pop    %ebx
80104551:	5e                   	pop    %esi
80104552:	5d                   	pop    %ebp
80104553:	c3                   	ret    
80104554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104558:	8b 73 08             	mov    0x8(%ebx),%esi
8010455b:	e8 90 f2 ff ff       	call   801037f0 <mycpu>
80104560:	39 c6                	cmp    %eax,%esi
80104562:	0f 85 6f ff ff ff    	jne    801044d7 <acquire+0x17>
    panic("acquire");
80104568:	83 ec 0c             	sub    $0xc,%esp
8010456b:	68 1f 77 10 80       	push   $0x8010771f
80104570:	e8 0b be ff ff       	call   80100380 <panic>
80104575:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010457c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104580 <popcli>:

void
popcli(void)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104586:	9c                   	pushf  
80104587:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104588:	f6 c4 02             	test   $0x2,%ah
8010458b:	75 35                	jne    801045c2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010458d:	e8 5e f2 ff ff       	call   801037f0 <mycpu>
80104592:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104599:	78 34                	js     801045cf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010459b:	e8 50 f2 ff ff       	call   801037f0 <mycpu>
801045a0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801045a6:	85 d2                	test   %edx,%edx
801045a8:	74 06                	je     801045b0 <popcli+0x30>
    sti();
}
801045aa:	c9                   	leave  
801045ab:	c3                   	ret    
801045ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045b0:	e8 3b f2 ff ff       	call   801037f0 <mycpu>
801045b5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801045bb:	85 c0                	test   %eax,%eax
801045bd:	74 eb                	je     801045aa <popcli+0x2a>
  asm volatile("sti");
801045bf:	fb                   	sti    
}
801045c0:	c9                   	leave  
801045c1:	c3                   	ret    
    panic("popcli - interruptible");
801045c2:	83 ec 0c             	sub    $0xc,%esp
801045c5:	68 27 77 10 80       	push   $0x80107727
801045ca:	e8 b1 bd ff ff       	call   80100380 <panic>
    panic("popcli");
801045cf:	83 ec 0c             	sub    $0xc,%esp
801045d2:	68 3e 77 10 80       	push   $0x8010773e
801045d7:	e8 a4 bd ff ff       	call   80100380 <panic>
801045dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045e0 <release>:
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	56                   	push   %esi
801045e4:	53                   	push   %ebx
801045e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801045e8:	8b 03                	mov    (%ebx),%eax
801045ea:	85 c0                	test   %eax,%eax
801045ec:	75 12                	jne    80104600 <release+0x20>
    panic("release");
801045ee:	83 ec 0c             	sub    $0xc,%esp
801045f1:	68 45 77 10 80       	push   $0x80107745
801045f6:	e8 85 bd ff ff       	call   80100380 <panic>
801045fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045ff:	90                   	nop
  return lock->locked && lock->cpu == mycpu();
80104600:	8b 73 08             	mov    0x8(%ebx),%esi
80104603:	e8 e8 f1 ff ff       	call   801037f0 <mycpu>
80104608:	39 c6                	cmp    %eax,%esi
8010460a:	75 e2                	jne    801045ee <release+0xe>
  lk->pcs[0] = 0;
8010460c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104613:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010461a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010461f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104625:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104628:	5b                   	pop    %ebx
80104629:	5e                   	pop    %esi
8010462a:	5d                   	pop    %ebp
  popcli();
8010462b:	e9 50 ff ff ff       	jmp    80104580 <popcli>

80104630 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	57                   	push   %edi
80104634:	8b 55 08             	mov    0x8(%ebp),%edx
80104637:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010463a:	53                   	push   %ebx
8010463b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010463e:	89 d7                	mov    %edx,%edi
80104640:	09 cf                	or     %ecx,%edi
80104642:	83 e7 03             	and    $0x3,%edi
80104645:	75 29                	jne    80104670 <memset+0x40>
    c &= 0xFF;
80104647:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010464a:	c1 e0 18             	shl    $0x18,%eax
8010464d:	89 fb                	mov    %edi,%ebx
8010464f:	c1 e9 02             	shr    $0x2,%ecx
80104652:	c1 e3 10             	shl    $0x10,%ebx
80104655:	09 d8                	or     %ebx,%eax
80104657:	09 f8                	or     %edi,%eax
80104659:	c1 e7 08             	shl    $0x8,%edi
8010465c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010465e:	89 d7                	mov    %edx,%edi
80104660:	fc                   	cld    
80104661:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104663:	5b                   	pop    %ebx
80104664:	89 d0                	mov    %edx,%eax
80104666:	5f                   	pop    %edi
80104667:	5d                   	pop    %ebp
80104668:	c3                   	ret    
80104669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104670:	89 d7                	mov    %edx,%edi
80104672:	fc                   	cld    
80104673:	f3 aa                	rep stos %al,%es:(%edi)
80104675:	5b                   	pop    %ebx
80104676:	89 d0                	mov    %edx,%eax
80104678:	5f                   	pop    %edi
80104679:	5d                   	pop    %ebp
8010467a:	c3                   	ret    
8010467b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010467f:	90                   	nop

80104680 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	56                   	push   %esi
80104684:	8b 75 10             	mov    0x10(%ebp),%esi
80104687:	8b 55 08             	mov    0x8(%ebp),%edx
8010468a:	53                   	push   %ebx
8010468b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010468e:	85 f6                	test   %esi,%esi
80104690:	74 2e                	je     801046c0 <memcmp+0x40>
80104692:	01 c6                	add    %eax,%esi
80104694:	eb 14                	jmp    801046aa <memcmp+0x2a>
80104696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010469d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801046a0:	83 c0 01             	add    $0x1,%eax
801046a3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801046a6:	39 f0                	cmp    %esi,%eax
801046a8:	74 16                	je     801046c0 <memcmp+0x40>
    if(*s1 != *s2)
801046aa:	0f b6 0a             	movzbl (%edx),%ecx
801046ad:	0f b6 18             	movzbl (%eax),%ebx
801046b0:	38 d9                	cmp    %bl,%cl
801046b2:	74 ec                	je     801046a0 <memcmp+0x20>
      return *s1 - *s2;
801046b4:	0f b6 c1             	movzbl %cl,%eax
801046b7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801046b9:	5b                   	pop    %ebx
801046ba:	5e                   	pop    %esi
801046bb:	5d                   	pop    %ebp
801046bc:	c3                   	ret    
801046bd:	8d 76 00             	lea    0x0(%esi),%esi
801046c0:	5b                   	pop    %ebx
  return 0;
801046c1:	31 c0                	xor    %eax,%eax
}
801046c3:	5e                   	pop    %esi
801046c4:	5d                   	pop    %ebp
801046c5:	c3                   	ret    
801046c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046cd:	8d 76 00             	lea    0x0(%esi),%esi

801046d0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	57                   	push   %edi
801046d4:	8b 55 08             	mov    0x8(%ebp),%edx
801046d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046da:	56                   	push   %esi
801046db:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801046de:	39 d6                	cmp    %edx,%esi
801046e0:	73 26                	jae    80104708 <memmove+0x38>
801046e2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801046e5:	39 fa                	cmp    %edi,%edx
801046e7:	73 1f                	jae    80104708 <memmove+0x38>
801046e9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801046ec:	85 c9                	test   %ecx,%ecx
801046ee:	74 0f                	je     801046ff <memmove+0x2f>
      *--d = *--s;
801046f0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801046f4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801046f7:	83 e8 01             	sub    $0x1,%eax
801046fa:	83 f8 ff             	cmp    $0xffffffff,%eax
801046fd:	75 f1                	jne    801046f0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801046ff:	5e                   	pop    %esi
80104700:	89 d0                	mov    %edx,%eax
80104702:	5f                   	pop    %edi
80104703:	5d                   	pop    %ebp
80104704:	c3                   	ret    
80104705:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104708:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010470b:	89 d7                	mov    %edx,%edi
8010470d:	85 c9                	test   %ecx,%ecx
8010470f:	74 ee                	je     801046ff <memmove+0x2f>
80104711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104718:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104719:	39 f0                	cmp    %esi,%eax
8010471b:	75 fb                	jne    80104718 <memmove+0x48>
}
8010471d:	5e                   	pop    %esi
8010471e:	89 d0                	mov    %edx,%eax
80104720:	5f                   	pop    %edi
80104721:	5d                   	pop    %ebp
80104722:	c3                   	ret    
80104723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010472a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104730 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104730:	eb 9e                	jmp    801046d0 <memmove>
80104732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104740 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	56                   	push   %esi
80104744:	8b 75 10             	mov    0x10(%ebp),%esi
80104747:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010474a:	53                   	push   %ebx
8010474b:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
8010474e:	85 f6                	test   %esi,%esi
80104750:	74 36                	je     80104788 <strncmp+0x48>
80104752:	01 c6                	add    %eax,%esi
80104754:	eb 18                	jmp    8010476e <strncmp+0x2e>
80104756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010475d:	8d 76 00             	lea    0x0(%esi),%esi
80104760:	38 da                	cmp    %bl,%dl
80104762:	75 14                	jne    80104778 <strncmp+0x38>
    n--, p++, q++;
80104764:	83 c0 01             	add    $0x1,%eax
80104767:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010476a:	39 f0                	cmp    %esi,%eax
8010476c:	74 1a                	je     80104788 <strncmp+0x48>
8010476e:	0f b6 11             	movzbl (%ecx),%edx
80104771:	0f b6 18             	movzbl (%eax),%ebx
80104774:	84 d2                	test   %dl,%dl
80104776:	75 e8                	jne    80104760 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104778:	0f b6 c2             	movzbl %dl,%eax
8010477b:	29 d8                	sub    %ebx,%eax
}
8010477d:	5b                   	pop    %ebx
8010477e:	5e                   	pop    %esi
8010477f:	5d                   	pop    %ebp
80104780:	c3                   	ret    
80104781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104788:	5b                   	pop    %ebx
    return 0;
80104789:	31 c0                	xor    %eax,%eax
}
8010478b:	5e                   	pop    %esi
8010478c:	5d                   	pop    %ebp
8010478d:	c3                   	ret    
8010478e:	66 90                	xchg   %ax,%ax

80104790 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	57                   	push   %edi
80104794:	56                   	push   %esi
80104795:	8b 75 08             	mov    0x8(%ebp),%esi
80104798:	53                   	push   %ebx
80104799:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010479c:	89 f2                	mov    %esi,%edx
8010479e:	eb 17                	jmp    801047b7 <strncpy+0x27>
801047a0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801047a4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801047a7:	83 c2 01             	add    $0x1,%edx
801047aa:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
801047ae:	89 f9                	mov    %edi,%ecx
801047b0:	88 4a ff             	mov    %cl,-0x1(%edx)
801047b3:	84 c9                	test   %cl,%cl
801047b5:	74 09                	je     801047c0 <strncpy+0x30>
801047b7:	89 c3                	mov    %eax,%ebx
801047b9:	83 e8 01             	sub    $0x1,%eax
801047bc:	85 db                	test   %ebx,%ebx
801047be:	7f e0                	jg     801047a0 <strncpy+0x10>
    ;
  while(n-- > 0)
801047c0:	89 d1                	mov    %edx,%ecx
801047c2:	85 c0                	test   %eax,%eax
801047c4:	7e 1d                	jle    801047e3 <strncpy+0x53>
801047c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047cd:	8d 76 00             	lea    0x0(%esi),%esi
    *s++ = 0;
801047d0:	83 c1 01             	add    $0x1,%ecx
801047d3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801047d7:	89 c8                	mov    %ecx,%eax
801047d9:	f7 d0                	not    %eax
801047db:	01 d0                	add    %edx,%eax
801047dd:	01 d8                	add    %ebx,%eax
801047df:	85 c0                	test   %eax,%eax
801047e1:	7f ed                	jg     801047d0 <strncpy+0x40>
  return os;
}
801047e3:	5b                   	pop    %ebx
801047e4:	89 f0                	mov    %esi,%eax
801047e6:	5e                   	pop    %esi
801047e7:	5f                   	pop    %edi
801047e8:	5d                   	pop    %ebp
801047e9:	c3                   	ret    
801047ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047f0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	56                   	push   %esi
801047f4:	8b 55 10             	mov    0x10(%ebp),%edx
801047f7:	8b 75 08             	mov    0x8(%ebp),%esi
801047fa:	53                   	push   %ebx
801047fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801047fe:	85 d2                	test   %edx,%edx
80104800:	7e 25                	jle    80104827 <safestrcpy+0x37>
80104802:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104806:	89 f2                	mov    %esi,%edx
80104808:	eb 16                	jmp    80104820 <safestrcpy+0x30>
8010480a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104810:	0f b6 08             	movzbl (%eax),%ecx
80104813:	83 c0 01             	add    $0x1,%eax
80104816:	83 c2 01             	add    $0x1,%edx
80104819:	88 4a ff             	mov    %cl,-0x1(%edx)
8010481c:	84 c9                	test   %cl,%cl
8010481e:	74 04                	je     80104824 <safestrcpy+0x34>
80104820:	39 d8                	cmp    %ebx,%eax
80104822:	75 ec                	jne    80104810 <safestrcpy+0x20>
    ;
  *s = 0;
80104824:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104827:	89 f0                	mov    %esi,%eax
80104829:	5b                   	pop    %ebx
8010482a:	5e                   	pop    %esi
8010482b:	5d                   	pop    %ebp
8010482c:	c3                   	ret    
8010482d:	8d 76 00             	lea    0x0(%esi),%esi

80104830 <strlen>:

int
strlen(const char *s)
{
80104830:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104831:	31 c0                	xor    %eax,%eax
{
80104833:	89 e5                	mov    %esp,%ebp
80104835:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104838:	80 3a 00             	cmpb   $0x0,(%edx)
8010483b:	74 0c                	je     80104849 <strlen+0x19>
8010483d:	8d 76 00             	lea    0x0(%esi),%esi
80104840:	83 c0 01             	add    $0x1,%eax
80104843:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104847:	75 f7                	jne    80104840 <strlen+0x10>
    ;
  return n;
}
80104849:	5d                   	pop    %ebp
8010484a:	c3                   	ret    

8010484b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010484b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010484f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104853:	55                   	push   %ebp
  pushl %ebx
80104854:	53                   	push   %ebx
  pushl %esi
80104855:	56                   	push   %esi
  pushl %edi
80104856:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104857:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104859:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010485b:	5f                   	pop    %edi
  popl %esi
8010485c:	5e                   	pop    %esi
  popl %ebx
8010485d:	5b                   	pop    %ebx
  popl %ebp
8010485e:	5d                   	pop    %ebp
  ret
8010485f:	c3                   	ret    

80104860 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	53                   	push   %ebx
80104864:	83 ec 04             	sub    $0x4,%esp
80104867:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010486a:	e8 11 f0 ff ff       	call   80103880 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010486f:	8b 00                	mov    (%eax),%eax
80104871:	39 d8                	cmp    %ebx,%eax
80104873:	76 1b                	jbe    80104890 <fetchint+0x30>
80104875:	8d 53 04             	lea    0x4(%ebx),%edx
80104878:	39 d0                	cmp    %edx,%eax
8010487a:	72 14                	jb     80104890 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010487c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010487f:	8b 13                	mov    (%ebx),%edx
80104881:	89 10                	mov    %edx,(%eax)
  return 0;
80104883:	31 c0                	xor    %eax,%eax
}
80104885:	83 c4 04             	add    $0x4,%esp
80104888:	5b                   	pop    %ebx
80104889:	5d                   	pop    %ebp
8010488a:	c3                   	ret    
8010488b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010488f:	90                   	nop
    return -1;
80104890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104895:	eb ee                	jmp    80104885 <fetchint+0x25>
80104897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010489e:	66 90                	xchg   %ax,%ax

801048a0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	53                   	push   %ebx
801048a4:	83 ec 04             	sub    $0x4,%esp
801048a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801048aa:	e8 d1 ef ff ff       	call   80103880 <myproc>

  if(addr >= curproc->sz)
801048af:	39 18                	cmp    %ebx,(%eax)
801048b1:	76 2d                	jbe    801048e0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
801048b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801048b6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801048b8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801048ba:	39 d3                	cmp    %edx,%ebx
801048bc:	73 22                	jae    801048e0 <fetchstr+0x40>
801048be:	89 d8                	mov    %ebx,%eax
801048c0:	eb 0d                	jmp    801048cf <fetchstr+0x2f>
801048c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048c8:	83 c0 01             	add    $0x1,%eax
801048cb:	39 c2                	cmp    %eax,%edx
801048cd:	76 11                	jbe    801048e0 <fetchstr+0x40>
    if(*s == 0)
801048cf:	80 38 00             	cmpb   $0x0,(%eax)
801048d2:	75 f4                	jne    801048c8 <fetchstr+0x28>
      return s - *pp;
  }
  return -1;
}
801048d4:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
801048d7:	29 d8                	sub    %ebx,%eax
}
801048d9:	5b                   	pop    %ebx
801048da:	5d                   	pop    %ebp
801048db:	c3                   	ret    
801048dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048e0:	83 c4 04             	add    $0x4,%esp
    return -1;
801048e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801048e8:	5b                   	pop    %ebx
801048e9:	5d                   	pop    %ebp
801048ea:	c3                   	ret    
801048eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048ef:	90                   	nop

801048f0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	56                   	push   %esi
801048f4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801048f5:	e8 86 ef ff ff       	call   80103880 <myproc>
801048fa:	8b 55 08             	mov    0x8(%ebp),%edx
801048fd:	8b 40 18             	mov    0x18(%eax),%eax
80104900:	8b 40 44             	mov    0x44(%eax),%eax
80104903:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104906:	e8 75 ef ff ff       	call   80103880 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010490b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010490e:	8b 00                	mov    (%eax),%eax
80104910:	39 c6                	cmp    %eax,%esi
80104912:	73 1c                	jae    80104930 <argint+0x40>
80104914:	8d 53 08             	lea    0x8(%ebx),%edx
80104917:	39 d0                	cmp    %edx,%eax
80104919:	72 15                	jb     80104930 <argint+0x40>
  *ip = *(int*)(addr);
8010491b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010491e:	8b 53 04             	mov    0x4(%ebx),%edx
80104921:	89 10                	mov    %edx,(%eax)
  return 0;
80104923:	31 c0                	xor    %eax,%eax
}
80104925:	5b                   	pop    %ebx
80104926:	5e                   	pop    %esi
80104927:	5d                   	pop    %ebp
80104928:	c3                   	ret    
80104929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104930:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104935:	eb ee                	jmp    80104925 <argint+0x35>
80104937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010493e:	66 90                	xchg   %ax,%ax

80104940 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	56                   	push   %esi
80104944:	53                   	push   %ebx
80104945:	83 ec 10             	sub    $0x10,%esp
80104948:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010494b:	e8 30 ef ff ff       	call   80103880 <myproc>
 
  if(argint(n, &i) < 0)
80104950:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104953:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104955:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104958:	50                   	push   %eax
80104959:	ff 75 08             	pushl  0x8(%ebp)
8010495c:	e8 8f ff ff ff       	call   801048f0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104961:	83 c4 10             	add    $0x10,%esp
80104964:	85 c0                	test   %eax,%eax
80104966:	78 28                	js     80104990 <argptr+0x50>
80104968:	85 db                	test   %ebx,%ebx
8010496a:	78 24                	js     80104990 <argptr+0x50>
8010496c:	8b 16                	mov    (%esi),%edx
8010496e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104971:	39 c2                	cmp    %eax,%edx
80104973:	76 1b                	jbe    80104990 <argptr+0x50>
80104975:	01 c3                	add    %eax,%ebx
80104977:	39 da                	cmp    %ebx,%edx
80104979:	72 15                	jb     80104990 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010497b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010497e:	89 02                	mov    %eax,(%edx)
  return 0;
80104980:	31 c0                	xor    %eax,%eax
}
80104982:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104985:	5b                   	pop    %ebx
80104986:	5e                   	pop    %esi
80104987:	5d                   	pop    %ebp
80104988:	c3                   	ret    
80104989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104995:	eb eb                	jmp    80104982 <argptr+0x42>
80104997:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010499e:	66 90                	xchg   %ax,%ax

801049a0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801049a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049a9:	50                   	push   %eax
801049aa:	ff 75 08             	pushl  0x8(%ebp)
801049ad:	e8 3e ff ff ff       	call   801048f0 <argint>
801049b2:	83 c4 10             	add    $0x10,%esp
801049b5:	85 c0                	test   %eax,%eax
801049b7:	78 17                	js     801049d0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801049b9:	83 ec 08             	sub    $0x8,%esp
801049bc:	ff 75 0c             	pushl  0xc(%ebp)
801049bf:	ff 75 f4             	pushl  -0xc(%ebp)
801049c2:	e8 d9 fe ff ff       	call   801048a0 <fetchstr>
801049c7:	83 c4 10             	add    $0x10,%esp
}
801049ca:	c9                   	leave  
801049cb:	c3                   	ret    
801049cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049d0:	c9                   	leave  
    return -1;
801049d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049d6:	c3                   	ret    
801049d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049de:	66 90                	xchg   %ax,%ax

801049e0 <syscall>:
[SYS_chpr]    sys_chpr,
};

void
syscall(void)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	53                   	push   %ebx
801049e4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801049e7:	e8 94 ee ff ff       	call   80103880 <myproc>
801049ec:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801049ee:	8b 40 18             	mov    0x18(%eax),%eax
801049f1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801049f4:	8d 50 ff             	lea    -0x1(%eax),%edx
801049f7:	83 fa 16             	cmp    $0x16,%edx
801049fa:	77 24                	ja     80104a20 <syscall+0x40>
801049fc:	8b 14 85 80 77 10 80 	mov    -0x7fef8880(,%eax,4),%edx
80104a03:	85 d2                	test   %edx,%edx
80104a05:	74 19                	je     80104a20 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104a07:	ff d2                	call   *%edx
80104a09:	89 c2                	mov    %eax,%edx
80104a0b:	8b 43 18             	mov    0x18(%ebx),%eax
80104a0e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104a11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a14:	c9                   	leave  
80104a15:	c3                   	ret    
80104a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a1d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104a20:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104a21:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104a24:	50                   	push   %eax
80104a25:	ff 73 10             	pushl  0x10(%ebx)
80104a28:	68 4d 77 10 80       	push   $0x8010774d
80104a2d:	e8 6e bc ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104a32:	8b 43 18             	mov    0x18(%ebx),%eax
80104a35:	83 c4 10             	add    $0x10,%esp
80104a38:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104a3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a42:	c9                   	leave  
80104a43:	c3                   	ret    
80104a44:	66 90                	xchg   %ax,%ax
80104a46:	66 90                	xchg   %ax,%ax
80104a48:	66 90                	xchg   %ax,%ax
80104a4a:	66 90                	xchg   %ax,%ax
80104a4c:	66 90                	xchg   %ax,%ax
80104a4e:	66 90                	xchg   %ax,%ax

80104a50 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	57                   	push   %edi
80104a54:	56                   	push   %esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104a55:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104a58:	53                   	push   %ebx
80104a59:	83 ec 44             	sub    $0x44,%esp
80104a5c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104a5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104a62:	57                   	push   %edi
80104a63:	50                   	push   %eax
{
80104a64:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104a67:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104a6a:	e8 71 d5 ff ff       	call   80101fe0 <nameiparent>
80104a6f:	83 c4 10             	add    $0x10,%esp
80104a72:	85 c0                	test   %eax,%eax
80104a74:	0f 84 46 01 00 00    	je     80104bc0 <create+0x170>
    return 0;
  ilock(dp);
80104a7a:	83 ec 0c             	sub    $0xc,%esp
80104a7d:	89 c3                	mov    %eax,%ebx
80104a7f:	50                   	push   %eax
80104a80:	e8 9b cc ff ff       	call   80101720 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104a85:	83 c4 0c             	add    $0xc,%esp
80104a88:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104a8b:	50                   	push   %eax
80104a8c:	57                   	push   %edi
80104a8d:	53                   	push   %ebx
80104a8e:	e8 bd d1 ff ff       	call   80101c50 <dirlookup>
80104a93:	83 c4 10             	add    $0x10,%esp
80104a96:	89 c6                	mov    %eax,%esi
80104a98:	85 c0                	test   %eax,%eax
80104a9a:	74 54                	je     80104af0 <create+0xa0>
    iunlockput(dp);
80104a9c:	83 ec 0c             	sub    $0xc,%esp
80104a9f:	53                   	push   %ebx
80104aa0:	e8 0b cf ff ff       	call   801019b0 <iunlockput>
    ilock(ip);
80104aa5:	89 34 24             	mov    %esi,(%esp)
80104aa8:	e8 73 cc ff ff       	call   80101720 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104aad:	83 c4 10             	add    $0x10,%esp
80104ab0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104ab5:	75 19                	jne    80104ad0 <create+0x80>
80104ab7:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104abc:	75 12                	jne    80104ad0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104abe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ac1:	89 f0                	mov    %esi,%eax
80104ac3:	5b                   	pop    %ebx
80104ac4:	5e                   	pop    %esi
80104ac5:	5f                   	pop    %edi
80104ac6:	5d                   	pop    %ebp
80104ac7:	c3                   	ret    
80104ac8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104acf:	90                   	nop
    iunlockput(ip);
80104ad0:	83 ec 0c             	sub    $0xc,%esp
80104ad3:	56                   	push   %esi
    return 0;
80104ad4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104ad6:	e8 d5 ce ff ff       	call   801019b0 <iunlockput>
    return 0;
80104adb:	83 c4 10             	add    $0x10,%esp
}
80104ade:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ae1:	89 f0                	mov    %esi,%eax
80104ae3:	5b                   	pop    %ebx
80104ae4:	5e                   	pop    %esi
80104ae5:	5f                   	pop    %edi
80104ae6:	5d                   	pop    %ebp
80104ae7:	c3                   	ret    
80104ae8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aef:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104af0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104af4:	83 ec 08             	sub    $0x8,%esp
80104af7:	50                   	push   %eax
80104af8:	ff 33                	pushl  (%ebx)
80104afa:	e8 b1 ca ff ff       	call   801015b0 <ialloc>
80104aff:	83 c4 10             	add    $0x10,%esp
80104b02:	89 c6                	mov    %eax,%esi
80104b04:	85 c0                	test   %eax,%eax
80104b06:	0f 84 cd 00 00 00    	je     80104bd9 <create+0x189>
  ilock(ip);
80104b0c:	83 ec 0c             	sub    $0xc,%esp
80104b0f:	50                   	push   %eax
80104b10:	e8 0b cc ff ff       	call   80101720 <ilock>
  ip->major = major;
80104b15:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104b19:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104b1d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104b21:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104b25:	b8 01 00 00 00       	mov    $0x1,%eax
80104b2a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104b2e:	89 34 24             	mov    %esi,(%esp)
80104b31:	e8 3a cb ff ff       	call   80101670 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104b36:	83 c4 10             	add    $0x10,%esp
80104b39:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104b3e:	74 30                	je     80104b70 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104b40:	83 ec 04             	sub    $0x4,%esp
80104b43:	ff 76 04             	pushl  0x4(%esi)
80104b46:	57                   	push   %edi
80104b47:	53                   	push   %ebx
80104b48:	e8 b3 d3 ff ff       	call   80101f00 <dirlink>
80104b4d:	83 c4 10             	add    $0x10,%esp
80104b50:	85 c0                	test   %eax,%eax
80104b52:	78 78                	js     80104bcc <create+0x17c>
  iunlockput(dp);
80104b54:	83 ec 0c             	sub    $0xc,%esp
80104b57:	53                   	push   %ebx
80104b58:	e8 53 ce ff ff       	call   801019b0 <iunlockput>
  return ip;
80104b5d:	83 c4 10             	add    $0x10,%esp
}
80104b60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b63:	89 f0                	mov    %esi,%eax
80104b65:	5b                   	pop    %ebx
80104b66:	5e                   	pop    %esi
80104b67:	5f                   	pop    %edi
80104b68:	5d                   	pop    %ebp
80104b69:	c3                   	ret    
80104b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104b70:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104b73:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104b78:	53                   	push   %ebx
80104b79:	e8 f2 ca ff ff       	call   80101670 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104b7e:	83 c4 0c             	add    $0xc,%esp
80104b81:	ff 76 04             	pushl  0x4(%esi)
80104b84:	68 fc 77 10 80       	push   $0x801077fc
80104b89:	56                   	push   %esi
80104b8a:	e8 71 d3 ff ff       	call   80101f00 <dirlink>
80104b8f:	83 c4 10             	add    $0x10,%esp
80104b92:	85 c0                	test   %eax,%eax
80104b94:	78 18                	js     80104bae <create+0x15e>
80104b96:	83 ec 04             	sub    $0x4,%esp
80104b99:	ff 73 04             	pushl  0x4(%ebx)
80104b9c:	68 fb 77 10 80       	push   $0x801077fb
80104ba1:	56                   	push   %esi
80104ba2:	e8 59 d3 ff ff       	call   80101f00 <dirlink>
80104ba7:	83 c4 10             	add    $0x10,%esp
80104baa:	85 c0                	test   %eax,%eax
80104bac:	79 92                	jns    80104b40 <create+0xf0>
      panic("create dots");
80104bae:	83 ec 0c             	sub    $0xc,%esp
80104bb1:	68 ef 77 10 80       	push   $0x801077ef
80104bb6:	e8 c5 b7 ff ff       	call   80100380 <panic>
80104bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bbf:	90                   	nop
}
80104bc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104bc3:	31 f6                	xor    %esi,%esi
}
80104bc5:	5b                   	pop    %ebx
80104bc6:	89 f0                	mov    %esi,%eax
80104bc8:	5e                   	pop    %esi
80104bc9:	5f                   	pop    %edi
80104bca:	5d                   	pop    %ebp
80104bcb:	c3                   	ret    
    panic("create: dirlink");
80104bcc:	83 ec 0c             	sub    $0xc,%esp
80104bcf:	68 fe 77 10 80       	push   $0x801077fe
80104bd4:	e8 a7 b7 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104bd9:	83 ec 0c             	sub    $0xc,%esp
80104bdc:	68 e0 77 10 80       	push   $0x801077e0
80104be1:	e8 9a b7 ff ff       	call   80100380 <panic>
80104be6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bed:	8d 76 00             	lea    0x0(%esi),%esi

80104bf0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	56                   	push   %esi
80104bf4:	89 d6                	mov    %edx,%esi
80104bf6:	53                   	push   %ebx
80104bf7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104bf9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104bfc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104bff:	50                   	push   %eax
80104c00:	6a 00                	push   $0x0
80104c02:	e8 e9 fc ff ff       	call   801048f0 <argint>
80104c07:	83 c4 10             	add    $0x10,%esp
80104c0a:	85 c0                	test   %eax,%eax
80104c0c:	78 2a                	js     80104c38 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104c0e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104c12:	77 24                	ja     80104c38 <argfd.constprop.0+0x48>
80104c14:	e8 67 ec ff ff       	call   80103880 <myproc>
80104c19:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c1c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104c20:	85 c0                	test   %eax,%eax
80104c22:	74 14                	je     80104c38 <argfd.constprop.0+0x48>
  if(pfd)
80104c24:	85 db                	test   %ebx,%ebx
80104c26:	74 02                	je     80104c2a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104c28:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104c2a:	89 06                	mov    %eax,(%esi)
  return 0;
80104c2c:	31 c0                	xor    %eax,%eax
}
80104c2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c31:	5b                   	pop    %ebx
80104c32:	5e                   	pop    %esi
80104c33:	5d                   	pop    %ebp
80104c34:	c3                   	ret    
80104c35:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104c38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c3d:	eb ef                	jmp    80104c2e <argfd.constprop.0+0x3e>
80104c3f:	90                   	nop

80104c40 <sys_dup>:
{
80104c40:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104c41:	31 c0                	xor    %eax,%eax
{
80104c43:	89 e5                	mov    %esp,%ebp
80104c45:	56                   	push   %esi
80104c46:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104c47:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104c4a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104c4d:	e8 9e ff ff ff       	call   80104bf0 <argfd.constprop.0>
80104c52:	85 c0                	test   %eax,%eax
80104c54:	78 1a                	js     80104c70 <sys_dup+0x30>
  if((fd=fdalloc(f)) < 0)
80104c56:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104c59:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104c5b:	e8 20 ec ff ff       	call   80103880 <myproc>
    if(curproc->ofile[fd] == 0){
80104c60:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104c64:	85 d2                	test   %edx,%edx
80104c66:	74 18                	je     80104c80 <sys_dup+0x40>
  for(fd = 0; fd < NOFILE; fd++){
80104c68:	83 c3 01             	add    $0x1,%ebx
80104c6b:	83 fb 10             	cmp    $0x10,%ebx
80104c6e:	75 f0                	jne    80104c60 <sys_dup+0x20>
}
80104c70:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104c73:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104c78:	89 d8                	mov    %ebx,%eax
80104c7a:	5b                   	pop    %ebx
80104c7b:	5e                   	pop    %esi
80104c7c:	5d                   	pop    %ebp
80104c7d:	c3                   	ret    
80104c7e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80104c80:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104c84:	83 ec 0c             	sub    $0xc,%esp
80104c87:	ff 75 f4             	pushl  -0xc(%ebp)
80104c8a:	e8 e1 c1 ff ff       	call   80100e70 <filedup>
  return fd;
80104c8f:	83 c4 10             	add    $0x10,%esp
}
80104c92:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c95:	89 d8                	mov    %ebx,%eax
80104c97:	5b                   	pop    %ebx
80104c98:	5e                   	pop    %esi
80104c99:	5d                   	pop    %ebp
80104c9a:	c3                   	ret    
80104c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c9f:	90                   	nop

80104ca0 <sys_read>:
{
80104ca0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ca1:	31 c0                	xor    %eax,%eax
{
80104ca3:	89 e5                	mov    %esp,%ebp
80104ca5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ca8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104cab:	e8 40 ff ff ff       	call   80104bf0 <argfd.constprop.0>
80104cb0:	85 c0                	test   %eax,%eax
80104cb2:	78 4c                	js     80104d00 <sys_read+0x60>
80104cb4:	83 ec 08             	sub    $0x8,%esp
80104cb7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104cba:	50                   	push   %eax
80104cbb:	6a 02                	push   $0x2
80104cbd:	e8 2e fc ff ff       	call   801048f0 <argint>
80104cc2:	83 c4 10             	add    $0x10,%esp
80104cc5:	85 c0                	test   %eax,%eax
80104cc7:	78 37                	js     80104d00 <sys_read+0x60>
80104cc9:	83 ec 04             	sub    $0x4,%esp
80104ccc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ccf:	ff 75 f0             	pushl  -0x10(%ebp)
80104cd2:	50                   	push   %eax
80104cd3:	6a 01                	push   $0x1
80104cd5:	e8 66 fc ff ff       	call   80104940 <argptr>
80104cda:	83 c4 10             	add    $0x10,%esp
80104cdd:	85 c0                	test   %eax,%eax
80104cdf:	78 1f                	js     80104d00 <sys_read+0x60>
  return fileread(f, p, n);
80104ce1:	83 ec 04             	sub    $0x4,%esp
80104ce4:	ff 75 f0             	pushl  -0x10(%ebp)
80104ce7:	ff 75 f4             	pushl  -0xc(%ebp)
80104cea:	ff 75 ec             	pushl  -0x14(%ebp)
80104ced:	e8 fe c2 ff ff       	call   80100ff0 <fileread>
80104cf2:	83 c4 10             	add    $0x10,%esp
}
80104cf5:	c9                   	leave  
80104cf6:	c3                   	ret    
80104cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cfe:	66 90                	xchg   %ax,%ax
80104d00:	c9                   	leave  
    return -1;
80104d01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d06:	c3                   	ret    
80104d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0e:	66 90                	xchg   %ax,%ax

80104d10 <sys_write>:
{
80104d10:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d11:	31 c0                	xor    %eax,%eax
{
80104d13:	89 e5                	mov    %esp,%ebp
80104d15:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d18:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d1b:	e8 d0 fe ff ff       	call   80104bf0 <argfd.constprop.0>
80104d20:	85 c0                	test   %eax,%eax
80104d22:	78 4c                	js     80104d70 <sys_write+0x60>
80104d24:	83 ec 08             	sub    $0x8,%esp
80104d27:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d2a:	50                   	push   %eax
80104d2b:	6a 02                	push   $0x2
80104d2d:	e8 be fb ff ff       	call   801048f0 <argint>
80104d32:	83 c4 10             	add    $0x10,%esp
80104d35:	85 c0                	test   %eax,%eax
80104d37:	78 37                	js     80104d70 <sys_write+0x60>
80104d39:	83 ec 04             	sub    $0x4,%esp
80104d3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d3f:	ff 75 f0             	pushl  -0x10(%ebp)
80104d42:	50                   	push   %eax
80104d43:	6a 01                	push   $0x1
80104d45:	e8 f6 fb ff ff       	call   80104940 <argptr>
80104d4a:	83 c4 10             	add    $0x10,%esp
80104d4d:	85 c0                	test   %eax,%eax
80104d4f:	78 1f                	js     80104d70 <sys_write+0x60>
  return filewrite(f, p, n);
80104d51:	83 ec 04             	sub    $0x4,%esp
80104d54:	ff 75 f0             	pushl  -0x10(%ebp)
80104d57:	ff 75 f4             	pushl  -0xc(%ebp)
80104d5a:	ff 75 ec             	pushl  -0x14(%ebp)
80104d5d:	e8 1e c3 ff ff       	call   80101080 <filewrite>
80104d62:	83 c4 10             	add    $0x10,%esp
}
80104d65:	c9                   	leave  
80104d66:	c3                   	ret    
80104d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d6e:	66 90                	xchg   %ax,%ax
80104d70:	c9                   	leave  
    return -1;
80104d71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d76:	c3                   	ret    
80104d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d7e:	66 90                	xchg   %ax,%ax

80104d80 <sys_close>:
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104d86:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104d89:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d8c:	e8 5f fe ff ff       	call   80104bf0 <argfd.constprop.0>
80104d91:	85 c0                	test   %eax,%eax
80104d93:	78 2b                	js     80104dc0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104d95:	e8 e6 ea ff ff       	call   80103880 <myproc>
80104d9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104d9d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104da0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104da7:	00 
  fileclose(f);
80104da8:	ff 75 f4             	pushl  -0xc(%ebp)
80104dab:	e8 10 c1 ff ff       	call   80100ec0 <fileclose>
  return 0;
80104db0:	83 c4 10             	add    $0x10,%esp
80104db3:	31 c0                	xor    %eax,%eax
}
80104db5:	c9                   	leave  
80104db6:	c3                   	ret    
80104db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dbe:	66 90                	xchg   %ax,%ax
80104dc0:	c9                   	leave  
    return -1;
80104dc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dc6:	c3                   	ret    
80104dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dce:	66 90                	xchg   %ax,%ax

80104dd0 <sys_fstat>:
{
80104dd0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104dd1:	31 c0                	xor    %eax,%eax
{
80104dd3:	89 e5                	mov    %esp,%ebp
80104dd5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104dd8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104ddb:	e8 10 fe ff ff       	call   80104bf0 <argfd.constprop.0>
80104de0:	85 c0                	test   %eax,%eax
80104de2:	78 2c                	js     80104e10 <sys_fstat+0x40>
80104de4:	83 ec 04             	sub    $0x4,%esp
80104de7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dea:	6a 14                	push   $0x14
80104dec:	50                   	push   %eax
80104ded:	6a 01                	push   $0x1
80104def:	e8 4c fb ff ff       	call   80104940 <argptr>
80104df4:	83 c4 10             	add    $0x10,%esp
80104df7:	85 c0                	test   %eax,%eax
80104df9:	78 15                	js     80104e10 <sys_fstat+0x40>
  return filestat(f, st);
80104dfb:	83 ec 08             	sub    $0x8,%esp
80104dfe:	ff 75 f4             	pushl  -0xc(%ebp)
80104e01:	ff 75 f0             	pushl  -0x10(%ebp)
80104e04:	e8 97 c1 ff ff       	call   80100fa0 <filestat>
80104e09:	83 c4 10             	add    $0x10,%esp
}
80104e0c:	c9                   	leave  
80104e0d:	c3                   	ret    
80104e0e:	66 90                	xchg   %ax,%ax
80104e10:	c9                   	leave  
    return -1;
80104e11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e16:	c3                   	ret    
80104e17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1e:	66 90                	xchg   %ax,%ax

80104e20 <sys_link>:
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	57                   	push   %edi
80104e24:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e25:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104e28:	53                   	push   %ebx
80104e29:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e2c:	50                   	push   %eax
80104e2d:	6a 00                	push   $0x0
80104e2f:	e8 6c fb ff ff       	call   801049a0 <argstr>
80104e34:	83 c4 10             	add    $0x10,%esp
80104e37:	85 c0                	test   %eax,%eax
80104e39:	0f 88 fb 00 00 00    	js     80104f3a <sys_link+0x11a>
80104e3f:	83 ec 08             	sub    $0x8,%esp
80104e42:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104e45:	50                   	push   %eax
80104e46:	6a 01                	push   $0x1
80104e48:	e8 53 fb ff ff       	call   801049a0 <argstr>
80104e4d:	83 c4 10             	add    $0x10,%esp
80104e50:	85 c0                	test   %eax,%eax
80104e52:	0f 88 e2 00 00 00    	js     80104f3a <sys_link+0x11a>
  begin_op();
80104e58:	e8 23 de ff ff       	call   80102c80 <begin_op>
  if((ip = namei(old)) == 0){
80104e5d:	83 ec 0c             	sub    $0xc,%esp
80104e60:	ff 75 d4             	pushl  -0x2c(%ebp)
80104e63:	e8 58 d1 ff ff       	call   80101fc0 <namei>
80104e68:	83 c4 10             	add    $0x10,%esp
80104e6b:	89 c3                	mov    %eax,%ebx
80104e6d:	85 c0                	test   %eax,%eax
80104e6f:	0f 84 e4 00 00 00    	je     80104f59 <sys_link+0x139>
  ilock(ip);
80104e75:	83 ec 0c             	sub    $0xc,%esp
80104e78:	50                   	push   %eax
80104e79:	e8 a2 c8 ff ff       	call   80101720 <ilock>
  if(ip->type == T_DIR){
80104e7e:	83 c4 10             	add    $0x10,%esp
80104e81:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e86:	0f 84 b5 00 00 00    	je     80104f41 <sys_link+0x121>
  iupdate(ip);
80104e8c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104e8f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104e94:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104e97:	53                   	push   %ebx
80104e98:	e8 d3 c7 ff ff       	call   80101670 <iupdate>
  iunlock(ip);
80104e9d:	89 1c 24             	mov    %ebx,(%esp)
80104ea0:	e8 5b c9 ff ff       	call   80101800 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104ea5:	58                   	pop    %eax
80104ea6:	5a                   	pop    %edx
80104ea7:	57                   	push   %edi
80104ea8:	ff 75 d0             	pushl  -0x30(%ebp)
80104eab:	e8 30 d1 ff ff       	call   80101fe0 <nameiparent>
80104eb0:	83 c4 10             	add    $0x10,%esp
80104eb3:	89 c6                	mov    %eax,%esi
80104eb5:	85 c0                	test   %eax,%eax
80104eb7:	74 5b                	je     80104f14 <sys_link+0xf4>
  ilock(dp);
80104eb9:	83 ec 0c             	sub    $0xc,%esp
80104ebc:	50                   	push   %eax
80104ebd:	e8 5e c8 ff ff       	call   80101720 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104ec2:	8b 03                	mov    (%ebx),%eax
80104ec4:	83 c4 10             	add    $0x10,%esp
80104ec7:	39 06                	cmp    %eax,(%esi)
80104ec9:	75 3d                	jne    80104f08 <sys_link+0xe8>
80104ecb:	83 ec 04             	sub    $0x4,%esp
80104ece:	ff 73 04             	pushl  0x4(%ebx)
80104ed1:	57                   	push   %edi
80104ed2:	56                   	push   %esi
80104ed3:	e8 28 d0 ff ff       	call   80101f00 <dirlink>
80104ed8:	83 c4 10             	add    $0x10,%esp
80104edb:	85 c0                	test   %eax,%eax
80104edd:	78 29                	js     80104f08 <sys_link+0xe8>
  iunlockput(dp);
80104edf:	83 ec 0c             	sub    $0xc,%esp
80104ee2:	56                   	push   %esi
80104ee3:	e8 c8 ca ff ff       	call   801019b0 <iunlockput>
  iput(ip);
80104ee8:	89 1c 24             	mov    %ebx,(%esp)
80104eeb:	e8 60 c9 ff ff       	call   80101850 <iput>
  end_op();
80104ef0:	e8 fb dd ff ff       	call   80102cf0 <end_op>
  return 0;
80104ef5:	83 c4 10             	add    $0x10,%esp
80104ef8:	31 c0                	xor    %eax,%eax
}
80104efa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104efd:	5b                   	pop    %ebx
80104efe:	5e                   	pop    %esi
80104eff:	5f                   	pop    %edi
80104f00:	5d                   	pop    %ebp
80104f01:	c3                   	ret    
80104f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104f08:	83 ec 0c             	sub    $0xc,%esp
80104f0b:	56                   	push   %esi
80104f0c:	e8 9f ca ff ff       	call   801019b0 <iunlockput>
    goto bad;
80104f11:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104f14:	83 ec 0c             	sub    $0xc,%esp
80104f17:	53                   	push   %ebx
80104f18:	e8 03 c8 ff ff       	call   80101720 <ilock>
  ip->nlink--;
80104f1d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f22:	89 1c 24             	mov    %ebx,(%esp)
80104f25:	e8 46 c7 ff ff       	call   80101670 <iupdate>
  iunlockput(ip);
80104f2a:	89 1c 24             	mov    %ebx,(%esp)
80104f2d:	e8 7e ca ff ff       	call   801019b0 <iunlockput>
  end_op();
80104f32:	e8 b9 dd ff ff       	call   80102cf0 <end_op>
  return -1;
80104f37:	83 c4 10             	add    $0x10,%esp
80104f3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f3f:	eb b9                	jmp    80104efa <sys_link+0xda>
    iunlockput(ip);
80104f41:	83 ec 0c             	sub    $0xc,%esp
80104f44:	53                   	push   %ebx
80104f45:	e8 66 ca ff ff       	call   801019b0 <iunlockput>
    end_op();
80104f4a:	e8 a1 dd ff ff       	call   80102cf0 <end_op>
    return -1;
80104f4f:	83 c4 10             	add    $0x10,%esp
80104f52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f57:	eb a1                	jmp    80104efa <sys_link+0xda>
    end_op();
80104f59:	e8 92 dd ff ff       	call   80102cf0 <end_op>
    return -1;
80104f5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f63:	eb 95                	jmp    80104efa <sys_link+0xda>
80104f65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f70 <sys_unlink>:
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	57                   	push   %edi
80104f74:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80104f75:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104f78:	53                   	push   %ebx
80104f79:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104f7c:	50                   	push   %eax
80104f7d:	6a 00                	push   $0x0
80104f7f:	e8 1c fa ff ff       	call   801049a0 <argstr>
80104f84:	83 c4 10             	add    $0x10,%esp
80104f87:	85 c0                	test   %eax,%eax
80104f89:	0f 88 91 01 00 00    	js     80105120 <sys_unlink+0x1b0>
  begin_op();
80104f8f:	e8 ec dc ff ff       	call   80102c80 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104f94:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104f97:	83 ec 08             	sub    $0x8,%esp
80104f9a:	53                   	push   %ebx
80104f9b:	ff 75 c0             	pushl  -0x40(%ebp)
80104f9e:	e8 3d d0 ff ff       	call   80101fe0 <nameiparent>
80104fa3:	83 c4 10             	add    $0x10,%esp
80104fa6:	89 c6                	mov    %eax,%esi
80104fa8:	85 c0                	test   %eax,%eax
80104faa:	0f 84 7a 01 00 00    	je     8010512a <sys_unlink+0x1ba>
  ilock(dp);
80104fb0:	83 ec 0c             	sub    $0xc,%esp
80104fb3:	50                   	push   %eax
80104fb4:	e8 67 c7 ff ff       	call   80101720 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104fb9:	58                   	pop    %eax
80104fba:	5a                   	pop    %edx
80104fbb:	68 fc 77 10 80       	push   $0x801077fc
80104fc0:	53                   	push   %ebx
80104fc1:	e8 6a cc ff ff       	call   80101c30 <namecmp>
80104fc6:	83 c4 10             	add    $0x10,%esp
80104fc9:	85 c0                	test   %eax,%eax
80104fcb:	0f 84 0f 01 00 00    	je     801050e0 <sys_unlink+0x170>
80104fd1:	83 ec 08             	sub    $0x8,%esp
80104fd4:	68 fb 77 10 80       	push   $0x801077fb
80104fd9:	53                   	push   %ebx
80104fda:	e8 51 cc ff ff       	call   80101c30 <namecmp>
80104fdf:	83 c4 10             	add    $0x10,%esp
80104fe2:	85 c0                	test   %eax,%eax
80104fe4:	0f 84 f6 00 00 00    	je     801050e0 <sys_unlink+0x170>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104fea:	83 ec 04             	sub    $0x4,%esp
80104fed:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104ff0:	50                   	push   %eax
80104ff1:	53                   	push   %ebx
80104ff2:	56                   	push   %esi
80104ff3:	e8 58 cc ff ff       	call   80101c50 <dirlookup>
80104ff8:	83 c4 10             	add    $0x10,%esp
80104ffb:	89 c3                	mov    %eax,%ebx
80104ffd:	85 c0                	test   %eax,%eax
80104fff:	0f 84 db 00 00 00    	je     801050e0 <sys_unlink+0x170>
  ilock(ip);
80105005:	83 ec 0c             	sub    $0xc,%esp
80105008:	50                   	push   %eax
80105009:	e8 12 c7 ff ff       	call   80101720 <ilock>
  if(ip->nlink < 1)
8010500e:	83 c4 10             	add    $0x10,%esp
80105011:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105016:	0f 8e 37 01 00 00    	jle    80105153 <sys_unlink+0x1e3>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010501c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105021:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105024:	74 6a                	je     80105090 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105026:	83 ec 04             	sub    $0x4,%esp
80105029:	6a 10                	push   $0x10
8010502b:	6a 00                	push   $0x0
8010502d:	57                   	push   %edi
8010502e:	e8 fd f5 ff ff       	call   80104630 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105033:	6a 10                	push   $0x10
80105035:	ff 75 c4             	pushl  -0x3c(%ebp)
80105038:	57                   	push   %edi
80105039:	56                   	push   %esi
8010503a:	e8 c1 ca ff ff       	call   80101b00 <writei>
8010503f:	83 c4 20             	add    $0x20,%esp
80105042:	83 f8 10             	cmp    $0x10,%eax
80105045:	0f 85 fb 00 00 00    	jne    80105146 <sys_unlink+0x1d6>
  if(ip->type == T_DIR){
8010504b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105050:	0f 84 aa 00 00 00    	je     80105100 <sys_unlink+0x190>
  iunlockput(dp);
80105056:	83 ec 0c             	sub    $0xc,%esp
80105059:	56                   	push   %esi
8010505a:	e8 51 c9 ff ff       	call   801019b0 <iunlockput>
  ip->nlink--;
8010505f:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105064:	89 1c 24             	mov    %ebx,(%esp)
80105067:	e8 04 c6 ff ff       	call   80101670 <iupdate>
  iunlockput(ip);
8010506c:	89 1c 24             	mov    %ebx,(%esp)
8010506f:	e8 3c c9 ff ff       	call   801019b0 <iunlockput>
  end_op();
80105074:	e8 77 dc ff ff       	call   80102cf0 <end_op>
  return 0;
80105079:	83 c4 10             	add    $0x10,%esp
8010507c:	31 c0                	xor    %eax,%eax
}
8010507e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105081:	5b                   	pop    %ebx
80105082:	5e                   	pop    %esi
80105083:	5f                   	pop    %edi
80105084:	5d                   	pop    %ebp
80105085:	c3                   	ret    
80105086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010508d:	8d 76 00             	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105090:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105094:	76 90                	jbe    80105026 <sys_unlink+0xb6>
80105096:	ba 20 00 00 00       	mov    $0x20,%edx
8010509b:	eb 0f                	jmp    801050ac <sys_unlink+0x13c>
8010509d:	8d 76 00             	lea    0x0(%esi),%esi
801050a0:	83 c2 10             	add    $0x10,%edx
801050a3:	39 53 58             	cmp    %edx,0x58(%ebx)
801050a6:	0f 86 7a ff ff ff    	jbe    80105026 <sys_unlink+0xb6>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801050ac:	6a 10                	push   $0x10
801050ae:	52                   	push   %edx
801050af:	57                   	push   %edi
801050b0:	53                   	push   %ebx
801050b1:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801050b4:	e8 47 c9 ff ff       	call   80101a00 <readi>
801050b9:	83 c4 10             	add    $0x10,%esp
801050bc:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801050bf:	83 f8 10             	cmp    $0x10,%eax
801050c2:	75 75                	jne    80105139 <sys_unlink+0x1c9>
    if(de.inum != 0)
801050c4:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801050c9:	74 d5                	je     801050a0 <sys_unlink+0x130>
    iunlockput(ip);
801050cb:	83 ec 0c             	sub    $0xc,%esp
801050ce:	53                   	push   %ebx
801050cf:	e8 dc c8 ff ff       	call   801019b0 <iunlockput>
    goto bad;
801050d4:	83 c4 10             	add    $0x10,%esp
801050d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050de:	66 90                	xchg   %ax,%ax
  iunlockput(dp);
801050e0:	83 ec 0c             	sub    $0xc,%esp
801050e3:	56                   	push   %esi
801050e4:	e8 c7 c8 ff ff       	call   801019b0 <iunlockput>
  end_op();
801050e9:	e8 02 dc ff ff       	call   80102cf0 <end_op>
  return -1;
801050ee:	83 c4 10             	add    $0x10,%esp
801050f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050f6:	eb 86                	jmp    8010507e <sys_unlink+0x10e>
801050f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ff:	90                   	nop
    iupdate(dp);
80105100:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105103:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105108:	56                   	push   %esi
80105109:	e8 62 c5 ff ff       	call   80101670 <iupdate>
8010510e:	83 c4 10             	add    $0x10,%esp
80105111:	e9 40 ff ff ff       	jmp    80105056 <sys_unlink+0xe6>
80105116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010511d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105120:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105125:	e9 54 ff ff ff       	jmp    8010507e <sys_unlink+0x10e>
    end_op();
8010512a:	e8 c1 db ff ff       	call   80102cf0 <end_op>
    return -1;
8010512f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105134:	e9 45 ff ff ff       	jmp    8010507e <sys_unlink+0x10e>
      panic("isdirempty: readi");
80105139:	83 ec 0c             	sub    $0xc,%esp
8010513c:	68 20 78 10 80       	push   $0x80107820
80105141:	e8 3a b2 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
80105146:	83 ec 0c             	sub    $0xc,%esp
80105149:	68 32 78 10 80       	push   $0x80107832
8010514e:	e8 2d b2 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
80105153:	83 ec 0c             	sub    $0xc,%esp
80105156:	68 0e 78 10 80       	push   $0x8010780e
8010515b:	e8 20 b2 ff ff       	call   80100380 <panic>

80105160 <sys_open>:

int
sys_open(void)
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	57                   	push   %edi
80105164:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105165:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105168:	53                   	push   %ebx
80105169:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010516c:	50                   	push   %eax
8010516d:	6a 00                	push   $0x0
8010516f:	e8 2c f8 ff ff       	call   801049a0 <argstr>
80105174:	83 c4 10             	add    $0x10,%esp
80105177:	85 c0                	test   %eax,%eax
80105179:	0f 88 8e 00 00 00    	js     8010520d <sys_open+0xad>
8010517f:	83 ec 08             	sub    $0x8,%esp
80105182:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105185:	50                   	push   %eax
80105186:	6a 01                	push   $0x1
80105188:	e8 63 f7 ff ff       	call   801048f0 <argint>
8010518d:	83 c4 10             	add    $0x10,%esp
80105190:	85 c0                	test   %eax,%eax
80105192:	78 79                	js     8010520d <sys_open+0xad>
    return -1;

  begin_op();
80105194:	e8 e7 da ff ff       	call   80102c80 <begin_op>

  if(omode & O_CREATE){
80105199:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010519d:	75 79                	jne    80105218 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010519f:	83 ec 0c             	sub    $0xc,%esp
801051a2:	ff 75 e0             	pushl  -0x20(%ebp)
801051a5:	e8 16 ce ff ff       	call   80101fc0 <namei>
801051aa:	83 c4 10             	add    $0x10,%esp
801051ad:	89 c6                	mov    %eax,%esi
801051af:	85 c0                	test   %eax,%eax
801051b1:	0f 84 7e 00 00 00    	je     80105235 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801051b7:	83 ec 0c             	sub    $0xc,%esp
801051ba:	50                   	push   %eax
801051bb:	e8 60 c5 ff ff       	call   80101720 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801051c0:	83 c4 10             	add    $0x10,%esp
801051c3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801051c8:	0f 84 c2 00 00 00    	je     80105290 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801051ce:	e8 2d bc ff ff       	call   80100e00 <filealloc>
801051d3:	89 c7                	mov    %eax,%edi
801051d5:	85 c0                	test   %eax,%eax
801051d7:	74 23                	je     801051fc <sys_open+0x9c>
  struct proc *curproc = myproc();
801051d9:	e8 a2 e6 ff ff       	call   80103880 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801051de:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801051e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801051e4:	85 d2                	test   %edx,%edx
801051e6:	74 60                	je     80105248 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801051e8:	83 c3 01             	add    $0x1,%ebx
801051eb:	83 fb 10             	cmp    $0x10,%ebx
801051ee:	75 f0                	jne    801051e0 <sys_open+0x80>
    if(f)
      fileclose(f);
801051f0:	83 ec 0c             	sub    $0xc,%esp
801051f3:	57                   	push   %edi
801051f4:	e8 c7 bc ff ff       	call   80100ec0 <fileclose>
801051f9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801051fc:	83 ec 0c             	sub    $0xc,%esp
801051ff:	56                   	push   %esi
80105200:	e8 ab c7 ff ff       	call   801019b0 <iunlockput>
    end_op();
80105205:	e8 e6 da ff ff       	call   80102cf0 <end_op>
    return -1;
8010520a:	83 c4 10             	add    $0x10,%esp
8010520d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105212:	eb 6d                	jmp    80105281 <sys_open+0x121>
80105214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105218:	83 ec 0c             	sub    $0xc,%esp
8010521b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010521e:	31 c9                	xor    %ecx,%ecx
80105220:	ba 02 00 00 00       	mov    $0x2,%edx
80105225:	6a 00                	push   $0x0
80105227:	e8 24 f8 ff ff       	call   80104a50 <create>
    if(ip == 0){
8010522c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010522f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105231:	85 c0                	test   %eax,%eax
80105233:	75 99                	jne    801051ce <sys_open+0x6e>
      end_op();
80105235:	e8 b6 da ff ff       	call   80102cf0 <end_op>
      return -1;
8010523a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010523f:	eb 40                	jmp    80105281 <sys_open+0x121>
80105241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105248:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010524b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010524f:	56                   	push   %esi
80105250:	e8 ab c5 ff ff       	call   80101800 <iunlock>
  end_op();
80105255:	e8 96 da ff ff       	call   80102cf0 <end_op>

  f->type = FD_INODE;
8010525a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105260:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105263:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105266:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105269:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010526b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105272:	f7 d0                	not    %eax
80105274:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105277:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010527a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010527d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105281:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105284:	89 d8                	mov    %ebx,%eax
80105286:	5b                   	pop    %ebx
80105287:	5e                   	pop    %esi
80105288:	5f                   	pop    %edi
80105289:	5d                   	pop    %ebp
8010528a:	c3                   	ret    
8010528b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010528f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105290:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105293:	85 c9                	test   %ecx,%ecx
80105295:	0f 84 33 ff ff ff    	je     801051ce <sys_open+0x6e>
8010529b:	e9 5c ff ff ff       	jmp    801051fc <sys_open+0x9c>

801052a0 <sys_mkdir>:

int
sys_mkdir(void)
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801052a6:	e8 d5 d9 ff ff       	call   80102c80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801052ab:	83 ec 08             	sub    $0x8,%esp
801052ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052b1:	50                   	push   %eax
801052b2:	6a 00                	push   $0x0
801052b4:	e8 e7 f6 ff ff       	call   801049a0 <argstr>
801052b9:	83 c4 10             	add    $0x10,%esp
801052bc:	85 c0                	test   %eax,%eax
801052be:	78 30                	js     801052f0 <sys_mkdir+0x50>
801052c0:	83 ec 0c             	sub    $0xc,%esp
801052c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052c6:	31 c9                	xor    %ecx,%ecx
801052c8:	ba 01 00 00 00       	mov    $0x1,%edx
801052cd:	6a 00                	push   $0x0
801052cf:	e8 7c f7 ff ff       	call   80104a50 <create>
801052d4:	83 c4 10             	add    $0x10,%esp
801052d7:	85 c0                	test   %eax,%eax
801052d9:	74 15                	je     801052f0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801052db:	83 ec 0c             	sub    $0xc,%esp
801052de:	50                   	push   %eax
801052df:	e8 cc c6 ff ff       	call   801019b0 <iunlockput>
  end_op();
801052e4:	e8 07 da ff ff       	call   80102cf0 <end_op>
  return 0;
801052e9:	83 c4 10             	add    $0x10,%esp
801052ec:	31 c0                	xor    %eax,%eax
}
801052ee:	c9                   	leave  
801052ef:	c3                   	ret    
    end_op();
801052f0:	e8 fb d9 ff ff       	call   80102cf0 <end_op>
    return -1;
801052f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052fa:	c9                   	leave  
801052fb:	c3                   	ret    
801052fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105300 <sys_mknod>:

int
sys_mknod(void)
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105306:	e8 75 d9 ff ff       	call   80102c80 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010530b:	83 ec 08             	sub    $0x8,%esp
8010530e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105311:	50                   	push   %eax
80105312:	6a 00                	push   $0x0
80105314:	e8 87 f6 ff ff       	call   801049a0 <argstr>
80105319:	83 c4 10             	add    $0x10,%esp
8010531c:	85 c0                	test   %eax,%eax
8010531e:	78 60                	js     80105380 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105320:	83 ec 08             	sub    $0x8,%esp
80105323:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105326:	50                   	push   %eax
80105327:	6a 01                	push   $0x1
80105329:	e8 c2 f5 ff ff       	call   801048f0 <argint>
  if((argstr(0, &path)) < 0 ||
8010532e:	83 c4 10             	add    $0x10,%esp
80105331:	85 c0                	test   %eax,%eax
80105333:	78 4b                	js     80105380 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105335:	83 ec 08             	sub    $0x8,%esp
80105338:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010533b:	50                   	push   %eax
8010533c:	6a 02                	push   $0x2
8010533e:	e8 ad f5 ff ff       	call   801048f0 <argint>
     argint(1, &major) < 0 ||
80105343:	83 c4 10             	add    $0x10,%esp
80105346:	85 c0                	test   %eax,%eax
80105348:	78 36                	js     80105380 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010534a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010534e:	83 ec 0c             	sub    $0xc,%esp
80105351:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105355:	ba 03 00 00 00       	mov    $0x3,%edx
8010535a:	50                   	push   %eax
8010535b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010535e:	e8 ed f6 ff ff       	call   80104a50 <create>
     argint(2, &minor) < 0 ||
80105363:	83 c4 10             	add    $0x10,%esp
80105366:	85 c0                	test   %eax,%eax
80105368:	74 16                	je     80105380 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010536a:	83 ec 0c             	sub    $0xc,%esp
8010536d:	50                   	push   %eax
8010536e:	e8 3d c6 ff ff       	call   801019b0 <iunlockput>
  end_op();
80105373:	e8 78 d9 ff ff       	call   80102cf0 <end_op>
  return 0;
80105378:	83 c4 10             	add    $0x10,%esp
8010537b:	31 c0                	xor    %eax,%eax
}
8010537d:	c9                   	leave  
8010537e:	c3                   	ret    
8010537f:	90                   	nop
    end_op();
80105380:	e8 6b d9 ff ff       	call   80102cf0 <end_op>
    return -1;
80105385:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010538a:	c9                   	leave  
8010538b:	c3                   	ret    
8010538c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105390 <sys_chdir>:

int
sys_chdir(void)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	56                   	push   %esi
80105394:	53                   	push   %ebx
80105395:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105398:	e8 e3 e4 ff ff       	call   80103880 <myproc>
8010539d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010539f:	e8 dc d8 ff ff       	call   80102c80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801053a4:	83 ec 08             	sub    $0x8,%esp
801053a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053aa:	50                   	push   %eax
801053ab:	6a 00                	push   $0x0
801053ad:	e8 ee f5 ff ff       	call   801049a0 <argstr>
801053b2:	83 c4 10             	add    $0x10,%esp
801053b5:	85 c0                	test   %eax,%eax
801053b7:	78 77                	js     80105430 <sys_chdir+0xa0>
801053b9:	83 ec 0c             	sub    $0xc,%esp
801053bc:	ff 75 f4             	pushl  -0xc(%ebp)
801053bf:	e8 fc cb ff ff       	call   80101fc0 <namei>
801053c4:	83 c4 10             	add    $0x10,%esp
801053c7:	89 c3                	mov    %eax,%ebx
801053c9:	85 c0                	test   %eax,%eax
801053cb:	74 63                	je     80105430 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801053cd:	83 ec 0c             	sub    $0xc,%esp
801053d0:	50                   	push   %eax
801053d1:	e8 4a c3 ff ff       	call   80101720 <ilock>
  if(ip->type != T_DIR){
801053d6:	83 c4 10             	add    $0x10,%esp
801053d9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053de:	75 30                	jne    80105410 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801053e0:	83 ec 0c             	sub    $0xc,%esp
801053e3:	53                   	push   %ebx
801053e4:	e8 17 c4 ff ff       	call   80101800 <iunlock>
  iput(curproc->cwd);
801053e9:	58                   	pop    %eax
801053ea:	ff 76 68             	pushl  0x68(%esi)
801053ed:	e8 5e c4 ff ff       	call   80101850 <iput>
  end_op();
801053f2:	e8 f9 d8 ff ff       	call   80102cf0 <end_op>
  curproc->cwd = ip;
801053f7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801053fa:	83 c4 10             	add    $0x10,%esp
801053fd:	31 c0                	xor    %eax,%eax
}
801053ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105402:	5b                   	pop    %ebx
80105403:	5e                   	pop    %esi
80105404:	5d                   	pop    %ebp
80105405:	c3                   	ret    
80105406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010540d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105410:	83 ec 0c             	sub    $0xc,%esp
80105413:	53                   	push   %ebx
80105414:	e8 97 c5 ff ff       	call   801019b0 <iunlockput>
    end_op();
80105419:	e8 d2 d8 ff ff       	call   80102cf0 <end_op>
    return -1;
8010541e:	83 c4 10             	add    $0x10,%esp
80105421:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105426:	eb d7                	jmp    801053ff <sys_chdir+0x6f>
80105428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010542f:	90                   	nop
    end_op();
80105430:	e8 bb d8 ff ff       	call   80102cf0 <end_op>
    return -1;
80105435:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010543a:	eb c3                	jmp    801053ff <sys_chdir+0x6f>
8010543c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105440 <sys_exec>:

int
sys_exec(void)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	57                   	push   %edi
80105444:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105445:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010544b:	53                   	push   %ebx
8010544c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105452:	50                   	push   %eax
80105453:	6a 00                	push   $0x0
80105455:	e8 46 f5 ff ff       	call   801049a0 <argstr>
8010545a:	83 c4 10             	add    $0x10,%esp
8010545d:	85 c0                	test   %eax,%eax
8010545f:	0f 88 87 00 00 00    	js     801054ec <sys_exec+0xac>
80105465:	83 ec 08             	sub    $0x8,%esp
80105468:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010546e:	50                   	push   %eax
8010546f:	6a 01                	push   $0x1
80105471:	e8 7a f4 ff ff       	call   801048f0 <argint>
80105476:	83 c4 10             	add    $0x10,%esp
80105479:	85 c0                	test   %eax,%eax
8010547b:	78 6f                	js     801054ec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010547d:	83 ec 04             	sub    $0x4,%esp
80105480:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105486:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105488:	68 80 00 00 00       	push   $0x80
8010548d:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105493:	6a 00                	push   $0x0
80105495:	50                   	push   %eax
80105496:	e8 95 f1 ff ff       	call   80104630 <memset>
8010549b:	83 c4 10             	add    $0x10,%esp
8010549e:	66 90                	xchg   %ax,%ax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801054a0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801054a6:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801054ad:	83 ec 08             	sub    $0x8,%esp
801054b0:	57                   	push   %edi
801054b1:	01 f0                	add    %esi,%eax
801054b3:	50                   	push   %eax
801054b4:	e8 a7 f3 ff ff       	call   80104860 <fetchint>
801054b9:	83 c4 10             	add    $0x10,%esp
801054bc:	85 c0                	test   %eax,%eax
801054be:	78 2c                	js     801054ec <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801054c0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801054c6:	85 c0                	test   %eax,%eax
801054c8:	74 36                	je     80105500 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801054ca:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801054d0:	83 ec 08             	sub    $0x8,%esp
801054d3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801054d6:	52                   	push   %edx
801054d7:	50                   	push   %eax
801054d8:	e8 c3 f3 ff ff       	call   801048a0 <fetchstr>
801054dd:	83 c4 10             	add    $0x10,%esp
801054e0:	85 c0                	test   %eax,%eax
801054e2:	78 08                	js     801054ec <sys_exec+0xac>
  for(i=0;; i++){
801054e4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801054e7:	83 fb 20             	cmp    $0x20,%ebx
801054ea:	75 b4                	jne    801054a0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801054ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801054ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054f4:	5b                   	pop    %ebx
801054f5:	5e                   	pop    %esi
801054f6:	5f                   	pop    %edi
801054f7:	5d                   	pop    %ebp
801054f8:	c3                   	ret    
801054f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105500:	83 ec 08             	sub    $0x8,%esp
80105503:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105509:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105510:	00 00 00 00 
  return exec(path, argv);
80105514:	50                   	push   %eax
80105515:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010551b:	e8 50 b5 ff ff       	call   80100a70 <exec>
80105520:	83 c4 10             	add    $0x10,%esp
}
80105523:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105526:	5b                   	pop    %ebx
80105527:	5e                   	pop    %esi
80105528:	5f                   	pop    %edi
80105529:	5d                   	pop    %ebp
8010552a:	c3                   	ret    
8010552b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010552f:	90                   	nop

80105530 <sys_pipe>:

int
sys_pipe(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	57                   	push   %edi
80105534:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105535:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105538:	53                   	push   %ebx
80105539:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010553c:	6a 08                	push   $0x8
8010553e:	50                   	push   %eax
8010553f:	6a 00                	push   $0x0
80105541:	e8 fa f3 ff ff       	call   80104940 <argptr>
80105546:	83 c4 10             	add    $0x10,%esp
80105549:	85 c0                	test   %eax,%eax
8010554b:	78 4a                	js     80105597 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010554d:	83 ec 08             	sub    $0x8,%esp
80105550:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105553:	50                   	push   %eax
80105554:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105557:	50                   	push   %eax
80105558:	e8 c3 dd ff ff       	call   80103320 <pipealloc>
8010555d:	83 c4 10             	add    $0x10,%esp
80105560:	85 c0                	test   %eax,%eax
80105562:	78 33                	js     80105597 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105564:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105567:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105569:	e8 12 e3 ff ff       	call   80103880 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010556e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105570:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105574:	85 f6                	test   %esi,%esi
80105576:	74 28                	je     801055a0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105578:	83 c3 01             	add    $0x1,%ebx
8010557b:	83 fb 10             	cmp    $0x10,%ebx
8010557e:	75 f0                	jne    80105570 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105580:	83 ec 0c             	sub    $0xc,%esp
80105583:	ff 75 e0             	pushl  -0x20(%ebp)
80105586:	e8 35 b9 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
8010558b:	58                   	pop    %eax
8010558c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010558f:	e8 2c b9 ff ff       	call   80100ec0 <fileclose>
    return -1;
80105594:	83 c4 10             	add    $0x10,%esp
80105597:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010559c:	eb 53                	jmp    801055f1 <sys_pipe+0xc1>
8010559e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801055a0:	8d 73 08             	lea    0x8(%ebx),%esi
801055a3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801055a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801055aa:	e8 d1 e2 ff ff       	call   80103880 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801055af:	31 d2                	xor    %edx,%edx
801055b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801055b8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801055bc:	85 c9                	test   %ecx,%ecx
801055be:	74 20                	je     801055e0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801055c0:	83 c2 01             	add    $0x1,%edx
801055c3:	83 fa 10             	cmp    $0x10,%edx
801055c6:	75 f0                	jne    801055b8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801055c8:	e8 b3 e2 ff ff       	call   80103880 <myproc>
801055cd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801055d4:	00 
801055d5:	eb a9                	jmp    80105580 <sys_pipe+0x50>
801055d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055de:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801055e0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801055e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801055e7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801055e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801055ec:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801055ef:	31 c0                	xor    %eax,%eax
}
801055f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055f4:	5b                   	pop    %ebx
801055f5:	5e                   	pop    %esi
801055f6:	5f                   	pop    %edi
801055f7:	5d                   	pop    %ebp
801055f8:	c3                   	ret    
801055f9:	66 90                	xchg   %ax,%ax
801055fb:	66 90                	xchg   %ax,%ax
801055fd:	66 90                	xchg   %ax,%ax
801055ff:	90                   	nop

80105600 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105600:	e9 1b e4 ff ff       	jmp    80103a20 <fork>
80105605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010560c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105610 <sys_exit>:
}

int
sys_exit(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	83 ec 08             	sub    $0x8,%esp
  exit();
80105616:	e8 a5 e6 ff ff       	call   80103cc0 <exit>
  return 0;  // not reached
}
8010561b:	31 c0                	xor    %eax,%eax
8010561d:	c9                   	leave  
8010561e:	c3                   	ret    
8010561f:	90                   	nop

80105620 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105620:	e9 db e8 ff ff       	jmp    80103f00 <wait>
80105625:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010562c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105630 <sys_kill>:
}

int
sys_kill(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105636:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105639:	50                   	push   %eax
8010563a:	6a 00                	push   $0x0
8010563c:	e8 af f2 ff ff       	call   801048f0 <argint>
80105641:	83 c4 10             	add    $0x10,%esp
80105644:	85 c0                	test   %eax,%eax
80105646:	78 18                	js     80105660 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105648:	83 ec 0c             	sub    $0xc,%esp
8010564b:	ff 75 f4             	pushl  -0xc(%ebp)
8010564e:	e8 fd e9 ff ff       	call   80104050 <kill>
80105653:	83 c4 10             	add    $0x10,%esp
}
80105656:	c9                   	leave  
80105657:	c3                   	ret    
80105658:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010565f:	90                   	nop
80105660:	c9                   	leave  
    return -1;
80105661:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105666:	c3                   	ret    
80105667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010566e:	66 90                	xchg   %ax,%ax

80105670 <sys_getpid>:

int
sys_getpid(void)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105676:	e8 05 e2 ff ff       	call   80103880 <myproc>
8010567b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010567e:	c9                   	leave  
8010567f:	c3                   	ret    

80105680 <sys_sbrk>:

int
sys_sbrk(void)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105684:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105687:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010568a:	50                   	push   %eax
8010568b:	6a 00                	push   $0x0
8010568d:	e8 5e f2 ff ff       	call   801048f0 <argint>
80105692:	83 c4 10             	add    $0x10,%esp
80105695:	85 c0                	test   %eax,%eax
80105697:	78 27                	js     801056c0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105699:	e8 e2 e1 ff ff       	call   80103880 <myproc>
  if(growproc(n) < 0)
8010569e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801056a1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801056a3:	ff 75 f4             	pushl  -0xc(%ebp)
801056a6:	e8 f5 e2 ff ff       	call   801039a0 <growproc>
801056ab:	83 c4 10             	add    $0x10,%esp
801056ae:	85 c0                	test   %eax,%eax
801056b0:	78 0e                	js     801056c0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801056b2:	89 d8                	mov    %ebx,%eax
801056b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056b7:	c9                   	leave  
801056b8:	c3                   	ret    
801056b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801056c0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801056c5:	eb eb                	jmp    801056b2 <sys_sbrk+0x32>
801056c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ce:	66 90                	xchg   %ax,%ax

801056d0 <sys_sleep>:

int
sys_sleep(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801056d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801056d7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801056da:	50                   	push   %eax
801056db:	6a 00                	push   $0x0
801056dd:	e8 0e f2 ff ff       	call   801048f0 <argint>
801056e2:	83 c4 10             	add    $0x10,%esp
801056e5:	85 c0                	test   %eax,%eax
801056e7:	0f 88 8a 00 00 00    	js     80105777 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801056ed:	83 ec 0c             	sub    $0xc,%esp
801056f0:	68 60 4d 11 80       	push   $0x80114d60
801056f5:	e8 c6 ed ff ff       	call   801044c0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801056fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801056fd:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  while(ticks - ticks0 < n){
80105703:	83 c4 10             	add    $0x10,%esp
80105706:	85 d2                	test   %edx,%edx
80105708:	75 27                	jne    80105731 <sys_sleep+0x61>
8010570a:	eb 54                	jmp    80105760 <sys_sleep+0x90>
8010570c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105710:	83 ec 08             	sub    $0x8,%esp
80105713:	68 60 4d 11 80       	push   $0x80114d60
80105718:	68 a0 55 11 80       	push   $0x801155a0
8010571d:	e8 1e e7 ff ff       	call   80103e40 <sleep>
  while(ticks - ticks0 < n){
80105722:	a1 a0 55 11 80       	mov    0x801155a0,%eax
80105727:	83 c4 10             	add    $0x10,%esp
8010572a:	29 d8                	sub    %ebx,%eax
8010572c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010572f:	73 2f                	jae    80105760 <sys_sleep+0x90>
    if(myproc()->killed){
80105731:	e8 4a e1 ff ff       	call   80103880 <myproc>
80105736:	8b 40 24             	mov    0x24(%eax),%eax
80105739:	85 c0                	test   %eax,%eax
8010573b:	74 d3                	je     80105710 <sys_sleep+0x40>
      release(&tickslock);
8010573d:	83 ec 0c             	sub    $0xc,%esp
80105740:	68 60 4d 11 80       	push   $0x80114d60
80105745:	e8 96 ee ff ff       	call   801045e0 <release>
  }
  release(&tickslock);
  return 0;
}
8010574a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010574d:	83 c4 10             	add    $0x10,%esp
80105750:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105755:	c9                   	leave  
80105756:	c3                   	ret    
80105757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010575e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105760:	83 ec 0c             	sub    $0xc,%esp
80105763:	68 60 4d 11 80       	push   $0x80114d60
80105768:	e8 73 ee ff ff       	call   801045e0 <release>
  return 0;
8010576d:	83 c4 10             	add    $0x10,%esp
80105770:	31 c0                	xor    %eax,%eax
}
80105772:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105775:	c9                   	leave  
80105776:	c3                   	ret    
    return -1;
80105777:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010577c:	eb f4                	jmp    80105772 <sys_sleep+0xa2>
8010577e:	66 90                	xchg   %ax,%ax

80105780 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	53                   	push   %ebx
80105784:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105787:	68 60 4d 11 80       	push   $0x80114d60
8010578c:	e8 2f ed ff ff       	call   801044c0 <acquire>
  xticks = ticks;
80105791:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  release(&tickslock);
80105797:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
8010579e:	e8 3d ee ff ff       	call   801045e0 <release>
  return xticks;
}
801057a3:	89 d8                	mov    %ebx,%eax
801057a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057a8:	c9                   	leave  
801057a9:	c3                   	ret    
801057aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801057b0 <sys_cps>:


int
sys_cps(void)
{
	return cps();
801057b0:	e9 db e9 ff ff       	jmp    80104190 <cps>
801057b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057c0 <sys_chpr>:
}
int
sys_chpr (void)
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	83 ec 20             	sub    $0x20,%esp
 int pid, pr;
 if(argint(0, &pid) < 0)
801057c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057c9:	50                   	push   %eax
801057ca:	6a 00                	push   $0x0
801057cc:	e8 1f f1 ff ff       	call   801048f0 <argint>
801057d1:	83 c4 10             	add    $0x10,%esp
801057d4:	85 c0                	test   %eax,%eax
801057d6:	78 28                	js     80105800 <sys_chpr+0x40>
 return -1;
 if(argint(1, &pr) < 0)
801057d8:	83 ec 08             	sub    $0x8,%esp
801057db:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057de:	50                   	push   %eax
801057df:	6a 01                	push   $0x1
801057e1:	e8 0a f1 ff ff       	call   801048f0 <argint>
801057e6:	83 c4 10             	add    $0x10,%esp
801057e9:	85 c0                	test   %eax,%eax
801057eb:	78 13                	js     80105800 <sys_chpr+0x40>
 return -1;
 return chpr ( pid, pr );
801057ed:	83 ec 08             	sub    $0x8,%esp
801057f0:	ff 75 f4             	pushl  -0xc(%ebp)
801057f3:	ff 75 f0             	pushl  -0x10(%ebp)
801057f6:	e8 65 ea ff ff       	call   80104260 <chpr>
801057fb:	83 c4 10             	add    $0x10,%esp
}
801057fe:	c9                   	leave  
801057ff:	c3                   	ret    
80105800:	c9                   	leave  
 return -1;
80105801:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105806:	c3                   	ret    

80105807 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105807:	1e                   	push   %ds
  pushl %es
80105808:	06                   	push   %es
  pushl %fs
80105809:	0f a0                	push   %fs
  pushl %gs
8010580b:	0f a8                	push   %gs
  pushal
8010580d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010580e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105812:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105814:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105816:	54                   	push   %esp
  call trap
80105817:	e8 c4 00 00 00       	call   801058e0 <trap>
  addl $4, %esp
8010581c:	83 c4 04             	add    $0x4,%esp

8010581f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010581f:	61                   	popa   
  popl %gs
80105820:	0f a9                	pop    %gs
  popl %fs
80105822:	0f a1                	pop    %fs
  popl %es
80105824:	07                   	pop    %es
  popl %ds
80105825:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105826:	83 c4 08             	add    $0x8,%esp
  iret
80105829:	cf                   	iret   
8010582a:	66 90                	xchg   %ax,%ax
8010582c:	66 90                	xchg   %ax,%ax
8010582e:	66 90                	xchg   %ax,%ax

80105830 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105830:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105831:	31 c0                	xor    %eax,%eax
{
80105833:	89 e5                	mov    %esp,%ebp
80105835:	83 ec 08             	sub    $0x8,%esp
80105838:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010583f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105840:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105847:	c7 04 c5 a2 4d 11 80 	movl   $0x8e000008,-0x7feeb25e(,%eax,8)
8010584e:	08 00 00 8e 
80105852:	66 89 14 c5 a0 4d 11 	mov    %dx,-0x7feeb260(,%eax,8)
80105859:	80 
8010585a:	c1 ea 10             	shr    $0x10,%edx
8010585d:	66 89 14 c5 a6 4d 11 	mov    %dx,-0x7feeb25a(,%eax,8)
80105864:	80 
  for(i = 0; i < 256; i++)
80105865:	83 c0 01             	add    $0x1,%eax
80105868:	3d 00 01 00 00       	cmp    $0x100,%eax
8010586d:	75 d1                	jne    80105840 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010586f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105872:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105877:	c7 05 a2 4f 11 80 08 	movl   $0xef000008,0x80114fa2
8010587e:	00 00 ef 
  initlock(&tickslock, "time");
80105881:	68 41 78 10 80       	push   $0x80107841
80105886:	68 60 4d 11 80       	push   $0x80114d60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010588b:	66 a3 a0 4f 11 80    	mov    %ax,0x80114fa0
80105891:	c1 e8 10             	shr    $0x10,%eax
80105894:	66 a3 a6 4f 11 80    	mov    %ax,0x80114fa6
  initlock(&tickslock, "time");
8010589a:	e8 21 eb ff ff       	call   801043c0 <initlock>
}
8010589f:	83 c4 10             	add    $0x10,%esp
801058a2:	c9                   	leave  
801058a3:	c3                   	ret    
801058a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058af:	90                   	nop

801058b0 <idtinit>:

void
idtinit(void)
{
801058b0:	55                   	push   %ebp
  pd[0] = size-1;
801058b1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801058b6:	89 e5                	mov    %esp,%ebp
801058b8:	83 ec 10             	sub    $0x10,%esp
801058bb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801058bf:	b8 a0 4d 11 80       	mov    $0x80114da0,%eax
801058c4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801058c8:	c1 e8 10             	shr    $0x10,%eax
801058cb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801058cf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801058d2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801058d5:	c9                   	leave  
801058d6:	c3                   	ret    
801058d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058de:	66 90                	xchg   %ax,%ax

801058e0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	57                   	push   %edi
801058e4:	56                   	push   %esi
801058e5:	53                   	push   %ebx
801058e6:	83 ec 1c             	sub    $0x1c,%esp
801058e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801058ec:	8b 43 30             	mov    0x30(%ebx),%eax
801058ef:	83 f8 40             	cmp    $0x40,%eax
801058f2:	0f 84 c0 01 00 00    	je     80105ab8 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801058f8:	83 e8 20             	sub    $0x20,%eax
801058fb:	83 f8 1f             	cmp    $0x1f,%eax
801058fe:	77 07                	ja     80105907 <trap+0x27>
80105900:	ff 24 85 e8 78 10 80 	jmp    *-0x7fef8718(,%eax,4)
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105907:	e8 74 df ff ff       	call   80103880 <myproc>
8010590c:	8b 7b 38             	mov    0x38(%ebx),%edi
8010590f:	85 c0                	test   %eax,%eax
80105911:	0f 84 f0 01 00 00    	je     80105b07 <trap+0x227>
80105917:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010591b:	0f 84 e6 01 00 00    	je     80105b07 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105921:	0f 20 d1             	mov    %cr2,%ecx
80105924:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105927:	e8 34 df ff ff       	call   80103860 <cpuid>
8010592c:	8b 73 30             	mov    0x30(%ebx),%esi
8010592f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105932:	8b 43 34             	mov    0x34(%ebx),%eax
80105935:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105938:	e8 43 df ff ff       	call   80103880 <myproc>
8010593d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105940:	e8 3b df ff ff       	call   80103880 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105945:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105948:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010594b:	51                   	push   %ecx
8010594c:	57                   	push   %edi
8010594d:	52                   	push   %edx
8010594e:	ff 75 e4             	pushl  -0x1c(%ebp)
80105951:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105952:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105955:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105958:	56                   	push   %esi
80105959:	ff 70 10             	pushl  0x10(%eax)
8010595c:	68 a4 78 10 80       	push   $0x801078a4
80105961:	e8 3a ad ff ff       	call   801006a0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105966:	83 c4 20             	add    $0x20,%esp
80105969:	e8 12 df ff ff       	call   80103880 <myproc>
8010596e:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105975:	e8 06 df ff ff       	call   80103880 <myproc>
8010597a:	85 c0                	test   %eax,%eax
8010597c:	74 1d                	je     8010599b <trap+0xbb>
8010597e:	e8 fd de ff ff       	call   80103880 <myproc>
80105983:	8b 50 24             	mov    0x24(%eax),%edx
80105986:	85 d2                	test   %edx,%edx
80105988:	74 11                	je     8010599b <trap+0xbb>
8010598a:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010598e:	83 e0 03             	and    $0x3,%eax
80105991:	66 83 f8 03          	cmp    $0x3,%ax
80105995:	0f 84 55 01 00 00    	je     80105af0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010599b:	e8 e0 de ff ff       	call   80103880 <myproc>
801059a0:	85 c0                	test   %eax,%eax
801059a2:	74 0f                	je     801059b3 <trap+0xd3>
801059a4:	e8 d7 de ff ff       	call   80103880 <myproc>
801059a9:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801059ad:	0f 84 ed 00 00 00    	je     80105aa0 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059b3:	e8 c8 de ff ff       	call   80103880 <myproc>
801059b8:	85 c0                	test   %eax,%eax
801059ba:	74 1d                	je     801059d9 <trap+0xf9>
801059bc:	e8 bf de ff ff       	call   80103880 <myproc>
801059c1:	8b 40 24             	mov    0x24(%eax),%eax
801059c4:	85 c0                	test   %eax,%eax
801059c6:	74 11                	je     801059d9 <trap+0xf9>
801059c8:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801059cc:	83 e0 03             	and    $0x3,%eax
801059cf:	66 83 f8 03          	cmp    $0x3,%ax
801059d3:	0f 84 08 01 00 00    	je     80105ae1 <trap+0x201>
    exit();
}
801059d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059dc:	5b                   	pop    %ebx
801059dd:	5e                   	pop    %esi
801059de:	5f                   	pop    %edi
801059df:	5d                   	pop    %ebp
801059e0:	c3                   	ret    
    ideintr();
801059e1:	e8 7a c7 ff ff       	call   80102160 <ideintr>
    lapiceoi();
801059e6:	e8 45 ce ff ff       	call   80102830 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059eb:	e8 90 de ff ff       	call   80103880 <myproc>
801059f0:	85 c0                	test   %eax,%eax
801059f2:	75 8a                	jne    8010597e <trap+0x9e>
801059f4:	eb a5                	jmp    8010599b <trap+0xbb>
    if(cpuid() == 0){
801059f6:	e8 65 de ff ff       	call   80103860 <cpuid>
801059fb:	85 c0                	test   %eax,%eax
801059fd:	75 e7                	jne    801059e6 <trap+0x106>
      acquire(&tickslock);
801059ff:	83 ec 0c             	sub    $0xc,%esp
80105a02:	68 60 4d 11 80       	push   $0x80114d60
80105a07:	e8 b4 ea ff ff       	call   801044c0 <acquire>
      wakeup(&ticks);
80105a0c:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
      ticks++;
80105a13:	83 05 a0 55 11 80 01 	addl   $0x1,0x801155a0
      wakeup(&ticks);
80105a1a:	e8 d1 e5 ff ff       	call   80103ff0 <wakeup>
      release(&tickslock);
80105a1f:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105a26:	e8 b5 eb ff ff       	call   801045e0 <release>
80105a2b:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105a2e:	eb b6                	jmp    801059e6 <trap+0x106>
    kbdintr();
80105a30:	e8 bb cc ff ff       	call   801026f0 <kbdintr>
    lapiceoi();
80105a35:	e8 f6 cd ff ff       	call   80102830 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a3a:	e8 41 de ff ff       	call   80103880 <myproc>
80105a3f:	85 c0                	test   %eax,%eax
80105a41:	0f 85 37 ff ff ff    	jne    8010597e <trap+0x9e>
80105a47:	e9 4f ff ff ff       	jmp    8010599b <trap+0xbb>
    uartintr();
80105a4c:	e8 4f 02 00 00       	call   80105ca0 <uartintr>
    lapiceoi();
80105a51:	e8 da cd ff ff       	call   80102830 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a56:	e8 25 de ff ff       	call   80103880 <myproc>
80105a5b:	85 c0                	test   %eax,%eax
80105a5d:	0f 85 1b ff ff ff    	jne    8010597e <trap+0x9e>
80105a63:	e9 33 ff ff ff       	jmp    8010599b <trap+0xbb>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105a68:	8b 7b 38             	mov    0x38(%ebx),%edi
80105a6b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105a6f:	e8 ec dd ff ff       	call   80103860 <cpuid>
80105a74:	57                   	push   %edi
80105a75:	56                   	push   %esi
80105a76:	50                   	push   %eax
80105a77:	68 4c 78 10 80       	push   $0x8010784c
80105a7c:	e8 1f ac ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105a81:	e8 aa cd ff ff       	call   80102830 <lapiceoi>
    break;
80105a86:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a89:	e8 f2 dd ff ff       	call   80103880 <myproc>
80105a8e:	85 c0                	test   %eax,%eax
80105a90:	0f 85 e8 fe ff ff    	jne    8010597e <trap+0x9e>
80105a96:	e9 00 ff ff ff       	jmp    8010599b <trap+0xbb>
80105a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a9f:	90                   	nop
  if(myproc() && myproc()->state == RUNNING &&
80105aa0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105aa4:	0f 85 09 ff ff ff    	jne    801059b3 <trap+0xd3>
    yield();
80105aaa:	e8 41 e3 ff ff       	call   80103df0 <yield>
80105aaf:	e9 ff fe ff ff       	jmp    801059b3 <trap+0xd3>
80105ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105ab8:	e8 c3 dd ff ff       	call   80103880 <myproc>
80105abd:	8b 70 24             	mov    0x24(%eax),%esi
80105ac0:	85 f6                	test   %esi,%esi
80105ac2:	75 3c                	jne    80105b00 <trap+0x220>
    myproc()->tf = tf;
80105ac4:	e8 b7 dd ff ff       	call   80103880 <myproc>
80105ac9:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105acc:	e8 0f ef ff ff       	call   801049e0 <syscall>
    if(myproc()->killed)
80105ad1:	e8 aa dd ff ff       	call   80103880 <myproc>
80105ad6:	8b 48 24             	mov    0x24(%eax),%ecx
80105ad9:	85 c9                	test   %ecx,%ecx
80105adb:	0f 84 f8 fe ff ff    	je     801059d9 <trap+0xf9>
}
80105ae1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ae4:	5b                   	pop    %ebx
80105ae5:	5e                   	pop    %esi
80105ae6:	5f                   	pop    %edi
80105ae7:	5d                   	pop    %ebp
      exit();
80105ae8:	e9 d3 e1 ff ff       	jmp    80103cc0 <exit>
80105aed:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105af0:	e8 cb e1 ff ff       	call   80103cc0 <exit>
80105af5:	e9 a1 fe ff ff       	jmp    8010599b <trap+0xbb>
80105afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105b00:	e8 bb e1 ff ff       	call   80103cc0 <exit>
80105b05:	eb bd                	jmp    80105ac4 <trap+0x1e4>
80105b07:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105b0a:	e8 51 dd ff ff       	call   80103860 <cpuid>
80105b0f:	83 ec 0c             	sub    $0xc,%esp
80105b12:	56                   	push   %esi
80105b13:	57                   	push   %edi
80105b14:	50                   	push   %eax
80105b15:	ff 73 30             	pushl  0x30(%ebx)
80105b18:	68 70 78 10 80       	push   $0x80107870
80105b1d:	e8 7e ab ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105b22:	83 c4 14             	add    $0x14,%esp
80105b25:	68 46 78 10 80       	push   $0x80107846
80105b2a:	e8 51 a8 ff ff       	call   80100380 <panic>
80105b2f:	90                   	nop

80105b30 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105b30:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105b35:	85 c0                	test   %eax,%eax
80105b37:	74 17                	je     80105b50 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b39:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105b3e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105b3f:	a8 01                	test   $0x1,%al
80105b41:	74 0d                	je     80105b50 <uartgetc+0x20>
80105b43:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b48:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105b49:	0f b6 c0             	movzbl %al,%eax
80105b4c:	c3                   	ret    
80105b4d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b55:	c3                   	ret    
80105b56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b5d:	8d 76 00             	lea    0x0(%esi),%esi

80105b60 <uartputc.part.0>:
uartputc(int c)
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	57                   	push   %edi
80105b64:	89 c7                	mov    %eax,%edi
80105b66:	56                   	push   %esi
80105b67:	be fd 03 00 00       	mov    $0x3fd,%esi
80105b6c:	53                   	push   %ebx
80105b6d:	bb 80 00 00 00       	mov    $0x80,%ebx
80105b72:	83 ec 0c             	sub    $0xc,%esp
80105b75:	eb 1b                	jmp    80105b92 <uartputc.part.0+0x32>
80105b77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b7e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105b80:	83 ec 0c             	sub    $0xc,%esp
80105b83:	6a 0a                	push   $0xa
80105b85:	e8 c6 cc ff ff       	call   80102850 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105b8a:	83 c4 10             	add    $0x10,%esp
80105b8d:	83 eb 01             	sub    $0x1,%ebx
80105b90:	74 07                	je     80105b99 <uartputc.part.0+0x39>
80105b92:	89 f2                	mov    %esi,%edx
80105b94:	ec                   	in     (%dx),%al
80105b95:	a8 20                	test   $0x20,%al
80105b97:	74 e7                	je     80105b80 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105b99:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b9e:	89 f8                	mov    %edi,%eax
80105ba0:	ee                   	out    %al,(%dx)
}
80105ba1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ba4:	5b                   	pop    %ebx
80105ba5:	5e                   	pop    %esi
80105ba6:	5f                   	pop    %edi
80105ba7:	5d                   	pop    %ebp
80105ba8:	c3                   	ret    
80105ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105bb0 <uartinit>:
{
80105bb0:	55                   	push   %ebp
80105bb1:	31 c9                	xor    %ecx,%ecx
80105bb3:	89 c8                	mov    %ecx,%eax
80105bb5:	89 e5                	mov    %esp,%ebp
80105bb7:	57                   	push   %edi
80105bb8:	56                   	push   %esi
80105bb9:	53                   	push   %ebx
80105bba:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105bbf:	89 da                	mov    %ebx,%edx
80105bc1:	83 ec 0c             	sub    $0xc,%esp
80105bc4:	ee                   	out    %al,(%dx)
80105bc5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105bca:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105bcf:	89 fa                	mov    %edi,%edx
80105bd1:	ee                   	out    %al,(%dx)
80105bd2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105bd7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105bdc:	ee                   	out    %al,(%dx)
80105bdd:	be f9 03 00 00       	mov    $0x3f9,%esi
80105be2:	89 c8                	mov    %ecx,%eax
80105be4:	89 f2                	mov    %esi,%edx
80105be6:	ee                   	out    %al,(%dx)
80105be7:	b8 03 00 00 00       	mov    $0x3,%eax
80105bec:	89 fa                	mov    %edi,%edx
80105bee:	ee                   	out    %al,(%dx)
80105bef:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105bf4:	89 c8                	mov    %ecx,%eax
80105bf6:	ee                   	out    %al,(%dx)
80105bf7:	b8 01 00 00 00       	mov    $0x1,%eax
80105bfc:	89 f2                	mov    %esi,%edx
80105bfe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105bff:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c04:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105c05:	3c ff                	cmp    $0xff,%al
80105c07:	74 56                	je     80105c5f <uartinit+0xaf>
  uart = 1;
80105c09:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105c10:	00 00 00 
80105c13:	89 da                	mov    %ebx,%edx
80105c15:	ec                   	in     (%dx),%al
80105c16:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c1b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105c1c:	83 ec 08             	sub    $0x8,%esp
80105c1f:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105c24:	bb 68 79 10 80       	mov    $0x80107968,%ebx
  ioapicenable(IRQ_COM1, 0);
80105c29:	6a 00                	push   $0x0
80105c2b:	6a 04                	push   $0x4
80105c2d:	e8 6e c7 ff ff       	call   801023a0 <ioapicenable>
80105c32:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105c35:	b8 78 00 00 00       	mov    $0x78,%eax
80105c3a:	eb 08                	jmp    80105c44 <uartinit+0x94>
80105c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c40:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105c44:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105c4a:	85 d2                	test   %edx,%edx
80105c4c:	74 08                	je     80105c56 <uartinit+0xa6>
    uartputc(*p);
80105c4e:	0f be c0             	movsbl %al,%eax
80105c51:	e8 0a ff ff ff       	call   80105b60 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105c56:	89 f0                	mov    %esi,%eax
80105c58:	83 c3 01             	add    $0x1,%ebx
80105c5b:	84 c0                	test   %al,%al
80105c5d:	75 e1                	jne    80105c40 <uartinit+0x90>
}
80105c5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c62:	5b                   	pop    %ebx
80105c63:	5e                   	pop    %esi
80105c64:	5f                   	pop    %edi
80105c65:	5d                   	pop    %ebp
80105c66:	c3                   	ret    
80105c67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c6e:	66 90                	xchg   %ax,%ax

80105c70 <uartputc>:
{
80105c70:	55                   	push   %ebp
  if(!uart)
80105c71:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105c77:	89 e5                	mov    %esp,%ebp
80105c79:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105c7c:	85 d2                	test   %edx,%edx
80105c7e:	74 10                	je     80105c90 <uartputc+0x20>
}
80105c80:	5d                   	pop    %ebp
80105c81:	e9 da fe ff ff       	jmp    80105b60 <uartputc.part.0>
80105c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c8d:	8d 76 00             	lea    0x0(%esi),%esi
80105c90:	5d                   	pop    %ebp
80105c91:	c3                   	ret    
80105c92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ca0 <uartintr>:

void
uartintr(void)
{
80105ca0:	55                   	push   %ebp
80105ca1:	89 e5                	mov    %esp,%ebp
80105ca3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105ca6:	68 30 5b 10 80       	push   $0x80105b30
80105cab:	e8 a0 ab ff ff       	call   80100850 <consoleintr>
}
80105cb0:	83 c4 10             	add    $0x10,%esp
80105cb3:	c9                   	leave  
80105cb4:	c3                   	ret    

80105cb5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105cb5:	6a 00                	push   $0x0
  pushl $0
80105cb7:	6a 00                	push   $0x0
  jmp alltraps
80105cb9:	e9 49 fb ff ff       	jmp    80105807 <alltraps>

80105cbe <vector1>:
.globl vector1
vector1:
  pushl $0
80105cbe:	6a 00                	push   $0x0
  pushl $1
80105cc0:	6a 01                	push   $0x1
  jmp alltraps
80105cc2:	e9 40 fb ff ff       	jmp    80105807 <alltraps>

80105cc7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105cc7:	6a 00                	push   $0x0
  pushl $2
80105cc9:	6a 02                	push   $0x2
  jmp alltraps
80105ccb:	e9 37 fb ff ff       	jmp    80105807 <alltraps>

80105cd0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105cd0:	6a 00                	push   $0x0
  pushl $3
80105cd2:	6a 03                	push   $0x3
  jmp alltraps
80105cd4:	e9 2e fb ff ff       	jmp    80105807 <alltraps>

80105cd9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105cd9:	6a 00                	push   $0x0
  pushl $4
80105cdb:	6a 04                	push   $0x4
  jmp alltraps
80105cdd:	e9 25 fb ff ff       	jmp    80105807 <alltraps>

80105ce2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105ce2:	6a 00                	push   $0x0
  pushl $5
80105ce4:	6a 05                	push   $0x5
  jmp alltraps
80105ce6:	e9 1c fb ff ff       	jmp    80105807 <alltraps>

80105ceb <vector6>:
.globl vector6
vector6:
  pushl $0
80105ceb:	6a 00                	push   $0x0
  pushl $6
80105ced:	6a 06                	push   $0x6
  jmp alltraps
80105cef:	e9 13 fb ff ff       	jmp    80105807 <alltraps>

80105cf4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105cf4:	6a 00                	push   $0x0
  pushl $7
80105cf6:	6a 07                	push   $0x7
  jmp alltraps
80105cf8:	e9 0a fb ff ff       	jmp    80105807 <alltraps>

80105cfd <vector8>:
.globl vector8
vector8:
  pushl $8
80105cfd:	6a 08                	push   $0x8
  jmp alltraps
80105cff:	e9 03 fb ff ff       	jmp    80105807 <alltraps>

80105d04 <vector9>:
.globl vector9
vector9:
  pushl $0
80105d04:	6a 00                	push   $0x0
  pushl $9
80105d06:	6a 09                	push   $0x9
  jmp alltraps
80105d08:	e9 fa fa ff ff       	jmp    80105807 <alltraps>

80105d0d <vector10>:
.globl vector10
vector10:
  pushl $10
80105d0d:	6a 0a                	push   $0xa
  jmp alltraps
80105d0f:	e9 f3 fa ff ff       	jmp    80105807 <alltraps>

80105d14 <vector11>:
.globl vector11
vector11:
  pushl $11
80105d14:	6a 0b                	push   $0xb
  jmp alltraps
80105d16:	e9 ec fa ff ff       	jmp    80105807 <alltraps>

80105d1b <vector12>:
.globl vector12
vector12:
  pushl $12
80105d1b:	6a 0c                	push   $0xc
  jmp alltraps
80105d1d:	e9 e5 fa ff ff       	jmp    80105807 <alltraps>

80105d22 <vector13>:
.globl vector13
vector13:
  pushl $13
80105d22:	6a 0d                	push   $0xd
  jmp alltraps
80105d24:	e9 de fa ff ff       	jmp    80105807 <alltraps>

80105d29 <vector14>:
.globl vector14
vector14:
  pushl $14
80105d29:	6a 0e                	push   $0xe
  jmp alltraps
80105d2b:	e9 d7 fa ff ff       	jmp    80105807 <alltraps>

80105d30 <vector15>:
.globl vector15
vector15:
  pushl $0
80105d30:	6a 00                	push   $0x0
  pushl $15
80105d32:	6a 0f                	push   $0xf
  jmp alltraps
80105d34:	e9 ce fa ff ff       	jmp    80105807 <alltraps>

80105d39 <vector16>:
.globl vector16
vector16:
  pushl $0
80105d39:	6a 00                	push   $0x0
  pushl $16
80105d3b:	6a 10                	push   $0x10
  jmp alltraps
80105d3d:	e9 c5 fa ff ff       	jmp    80105807 <alltraps>

80105d42 <vector17>:
.globl vector17
vector17:
  pushl $17
80105d42:	6a 11                	push   $0x11
  jmp alltraps
80105d44:	e9 be fa ff ff       	jmp    80105807 <alltraps>

80105d49 <vector18>:
.globl vector18
vector18:
  pushl $0
80105d49:	6a 00                	push   $0x0
  pushl $18
80105d4b:	6a 12                	push   $0x12
  jmp alltraps
80105d4d:	e9 b5 fa ff ff       	jmp    80105807 <alltraps>

80105d52 <vector19>:
.globl vector19
vector19:
  pushl $0
80105d52:	6a 00                	push   $0x0
  pushl $19
80105d54:	6a 13                	push   $0x13
  jmp alltraps
80105d56:	e9 ac fa ff ff       	jmp    80105807 <alltraps>

80105d5b <vector20>:
.globl vector20
vector20:
  pushl $0
80105d5b:	6a 00                	push   $0x0
  pushl $20
80105d5d:	6a 14                	push   $0x14
  jmp alltraps
80105d5f:	e9 a3 fa ff ff       	jmp    80105807 <alltraps>

80105d64 <vector21>:
.globl vector21
vector21:
  pushl $0
80105d64:	6a 00                	push   $0x0
  pushl $21
80105d66:	6a 15                	push   $0x15
  jmp alltraps
80105d68:	e9 9a fa ff ff       	jmp    80105807 <alltraps>

80105d6d <vector22>:
.globl vector22
vector22:
  pushl $0
80105d6d:	6a 00                	push   $0x0
  pushl $22
80105d6f:	6a 16                	push   $0x16
  jmp alltraps
80105d71:	e9 91 fa ff ff       	jmp    80105807 <alltraps>

80105d76 <vector23>:
.globl vector23
vector23:
  pushl $0
80105d76:	6a 00                	push   $0x0
  pushl $23
80105d78:	6a 17                	push   $0x17
  jmp alltraps
80105d7a:	e9 88 fa ff ff       	jmp    80105807 <alltraps>

80105d7f <vector24>:
.globl vector24
vector24:
  pushl $0
80105d7f:	6a 00                	push   $0x0
  pushl $24
80105d81:	6a 18                	push   $0x18
  jmp alltraps
80105d83:	e9 7f fa ff ff       	jmp    80105807 <alltraps>

80105d88 <vector25>:
.globl vector25
vector25:
  pushl $0
80105d88:	6a 00                	push   $0x0
  pushl $25
80105d8a:	6a 19                	push   $0x19
  jmp alltraps
80105d8c:	e9 76 fa ff ff       	jmp    80105807 <alltraps>

80105d91 <vector26>:
.globl vector26
vector26:
  pushl $0
80105d91:	6a 00                	push   $0x0
  pushl $26
80105d93:	6a 1a                	push   $0x1a
  jmp alltraps
80105d95:	e9 6d fa ff ff       	jmp    80105807 <alltraps>

80105d9a <vector27>:
.globl vector27
vector27:
  pushl $0
80105d9a:	6a 00                	push   $0x0
  pushl $27
80105d9c:	6a 1b                	push   $0x1b
  jmp alltraps
80105d9e:	e9 64 fa ff ff       	jmp    80105807 <alltraps>

80105da3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105da3:	6a 00                	push   $0x0
  pushl $28
80105da5:	6a 1c                	push   $0x1c
  jmp alltraps
80105da7:	e9 5b fa ff ff       	jmp    80105807 <alltraps>

80105dac <vector29>:
.globl vector29
vector29:
  pushl $0
80105dac:	6a 00                	push   $0x0
  pushl $29
80105dae:	6a 1d                	push   $0x1d
  jmp alltraps
80105db0:	e9 52 fa ff ff       	jmp    80105807 <alltraps>

80105db5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105db5:	6a 00                	push   $0x0
  pushl $30
80105db7:	6a 1e                	push   $0x1e
  jmp alltraps
80105db9:	e9 49 fa ff ff       	jmp    80105807 <alltraps>

80105dbe <vector31>:
.globl vector31
vector31:
  pushl $0
80105dbe:	6a 00                	push   $0x0
  pushl $31
80105dc0:	6a 1f                	push   $0x1f
  jmp alltraps
80105dc2:	e9 40 fa ff ff       	jmp    80105807 <alltraps>

80105dc7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105dc7:	6a 00                	push   $0x0
  pushl $32
80105dc9:	6a 20                	push   $0x20
  jmp alltraps
80105dcb:	e9 37 fa ff ff       	jmp    80105807 <alltraps>

80105dd0 <vector33>:
.globl vector33
vector33:
  pushl $0
80105dd0:	6a 00                	push   $0x0
  pushl $33
80105dd2:	6a 21                	push   $0x21
  jmp alltraps
80105dd4:	e9 2e fa ff ff       	jmp    80105807 <alltraps>

80105dd9 <vector34>:
.globl vector34
vector34:
  pushl $0
80105dd9:	6a 00                	push   $0x0
  pushl $34
80105ddb:	6a 22                	push   $0x22
  jmp alltraps
80105ddd:	e9 25 fa ff ff       	jmp    80105807 <alltraps>

80105de2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105de2:	6a 00                	push   $0x0
  pushl $35
80105de4:	6a 23                	push   $0x23
  jmp alltraps
80105de6:	e9 1c fa ff ff       	jmp    80105807 <alltraps>

80105deb <vector36>:
.globl vector36
vector36:
  pushl $0
80105deb:	6a 00                	push   $0x0
  pushl $36
80105ded:	6a 24                	push   $0x24
  jmp alltraps
80105def:	e9 13 fa ff ff       	jmp    80105807 <alltraps>

80105df4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105df4:	6a 00                	push   $0x0
  pushl $37
80105df6:	6a 25                	push   $0x25
  jmp alltraps
80105df8:	e9 0a fa ff ff       	jmp    80105807 <alltraps>

80105dfd <vector38>:
.globl vector38
vector38:
  pushl $0
80105dfd:	6a 00                	push   $0x0
  pushl $38
80105dff:	6a 26                	push   $0x26
  jmp alltraps
80105e01:	e9 01 fa ff ff       	jmp    80105807 <alltraps>

80105e06 <vector39>:
.globl vector39
vector39:
  pushl $0
80105e06:	6a 00                	push   $0x0
  pushl $39
80105e08:	6a 27                	push   $0x27
  jmp alltraps
80105e0a:	e9 f8 f9 ff ff       	jmp    80105807 <alltraps>

80105e0f <vector40>:
.globl vector40
vector40:
  pushl $0
80105e0f:	6a 00                	push   $0x0
  pushl $40
80105e11:	6a 28                	push   $0x28
  jmp alltraps
80105e13:	e9 ef f9 ff ff       	jmp    80105807 <alltraps>

80105e18 <vector41>:
.globl vector41
vector41:
  pushl $0
80105e18:	6a 00                	push   $0x0
  pushl $41
80105e1a:	6a 29                	push   $0x29
  jmp alltraps
80105e1c:	e9 e6 f9 ff ff       	jmp    80105807 <alltraps>

80105e21 <vector42>:
.globl vector42
vector42:
  pushl $0
80105e21:	6a 00                	push   $0x0
  pushl $42
80105e23:	6a 2a                	push   $0x2a
  jmp alltraps
80105e25:	e9 dd f9 ff ff       	jmp    80105807 <alltraps>

80105e2a <vector43>:
.globl vector43
vector43:
  pushl $0
80105e2a:	6a 00                	push   $0x0
  pushl $43
80105e2c:	6a 2b                	push   $0x2b
  jmp alltraps
80105e2e:	e9 d4 f9 ff ff       	jmp    80105807 <alltraps>

80105e33 <vector44>:
.globl vector44
vector44:
  pushl $0
80105e33:	6a 00                	push   $0x0
  pushl $44
80105e35:	6a 2c                	push   $0x2c
  jmp alltraps
80105e37:	e9 cb f9 ff ff       	jmp    80105807 <alltraps>

80105e3c <vector45>:
.globl vector45
vector45:
  pushl $0
80105e3c:	6a 00                	push   $0x0
  pushl $45
80105e3e:	6a 2d                	push   $0x2d
  jmp alltraps
80105e40:	e9 c2 f9 ff ff       	jmp    80105807 <alltraps>

80105e45 <vector46>:
.globl vector46
vector46:
  pushl $0
80105e45:	6a 00                	push   $0x0
  pushl $46
80105e47:	6a 2e                	push   $0x2e
  jmp alltraps
80105e49:	e9 b9 f9 ff ff       	jmp    80105807 <alltraps>

80105e4e <vector47>:
.globl vector47
vector47:
  pushl $0
80105e4e:	6a 00                	push   $0x0
  pushl $47
80105e50:	6a 2f                	push   $0x2f
  jmp alltraps
80105e52:	e9 b0 f9 ff ff       	jmp    80105807 <alltraps>

80105e57 <vector48>:
.globl vector48
vector48:
  pushl $0
80105e57:	6a 00                	push   $0x0
  pushl $48
80105e59:	6a 30                	push   $0x30
  jmp alltraps
80105e5b:	e9 a7 f9 ff ff       	jmp    80105807 <alltraps>

80105e60 <vector49>:
.globl vector49
vector49:
  pushl $0
80105e60:	6a 00                	push   $0x0
  pushl $49
80105e62:	6a 31                	push   $0x31
  jmp alltraps
80105e64:	e9 9e f9 ff ff       	jmp    80105807 <alltraps>

80105e69 <vector50>:
.globl vector50
vector50:
  pushl $0
80105e69:	6a 00                	push   $0x0
  pushl $50
80105e6b:	6a 32                	push   $0x32
  jmp alltraps
80105e6d:	e9 95 f9 ff ff       	jmp    80105807 <alltraps>

80105e72 <vector51>:
.globl vector51
vector51:
  pushl $0
80105e72:	6a 00                	push   $0x0
  pushl $51
80105e74:	6a 33                	push   $0x33
  jmp alltraps
80105e76:	e9 8c f9 ff ff       	jmp    80105807 <alltraps>

80105e7b <vector52>:
.globl vector52
vector52:
  pushl $0
80105e7b:	6a 00                	push   $0x0
  pushl $52
80105e7d:	6a 34                	push   $0x34
  jmp alltraps
80105e7f:	e9 83 f9 ff ff       	jmp    80105807 <alltraps>

80105e84 <vector53>:
.globl vector53
vector53:
  pushl $0
80105e84:	6a 00                	push   $0x0
  pushl $53
80105e86:	6a 35                	push   $0x35
  jmp alltraps
80105e88:	e9 7a f9 ff ff       	jmp    80105807 <alltraps>

80105e8d <vector54>:
.globl vector54
vector54:
  pushl $0
80105e8d:	6a 00                	push   $0x0
  pushl $54
80105e8f:	6a 36                	push   $0x36
  jmp alltraps
80105e91:	e9 71 f9 ff ff       	jmp    80105807 <alltraps>

80105e96 <vector55>:
.globl vector55
vector55:
  pushl $0
80105e96:	6a 00                	push   $0x0
  pushl $55
80105e98:	6a 37                	push   $0x37
  jmp alltraps
80105e9a:	e9 68 f9 ff ff       	jmp    80105807 <alltraps>

80105e9f <vector56>:
.globl vector56
vector56:
  pushl $0
80105e9f:	6a 00                	push   $0x0
  pushl $56
80105ea1:	6a 38                	push   $0x38
  jmp alltraps
80105ea3:	e9 5f f9 ff ff       	jmp    80105807 <alltraps>

80105ea8 <vector57>:
.globl vector57
vector57:
  pushl $0
80105ea8:	6a 00                	push   $0x0
  pushl $57
80105eaa:	6a 39                	push   $0x39
  jmp alltraps
80105eac:	e9 56 f9 ff ff       	jmp    80105807 <alltraps>

80105eb1 <vector58>:
.globl vector58
vector58:
  pushl $0
80105eb1:	6a 00                	push   $0x0
  pushl $58
80105eb3:	6a 3a                	push   $0x3a
  jmp alltraps
80105eb5:	e9 4d f9 ff ff       	jmp    80105807 <alltraps>

80105eba <vector59>:
.globl vector59
vector59:
  pushl $0
80105eba:	6a 00                	push   $0x0
  pushl $59
80105ebc:	6a 3b                	push   $0x3b
  jmp alltraps
80105ebe:	e9 44 f9 ff ff       	jmp    80105807 <alltraps>

80105ec3 <vector60>:
.globl vector60
vector60:
  pushl $0
80105ec3:	6a 00                	push   $0x0
  pushl $60
80105ec5:	6a 3c                	push   $0x3c
  jmp alltraps
80105ec7:	e9 3b f9 ff ff       	jmp    80105807 <alltraps>

80105ecc <vector61>:
.globl vector61
vector61:
  pushl $0
80105ecc:	6a 00                	push   $0x0
  pushl $61
80105ece:	6a 3d                	push   $0x3d
  jmp alltraps
80105ed0:	e9 32 f9 ff ff       	jmp    80105807 <alltraps>

80105ed5 <vector62>:
.globl vector62
vector62:
  pushl $0
80105ed5:	6a 00                	push   $0x0
  pushl $62
80105ed7:	6a 3e                	push   $0x3e
  jmp alltraps
80105ed9:	e9 29 f9 ff ff       	jmp    80105807 <alltraps>

80105ede <vector63>:
.globl vector63
vector63:
  pushl $0
80105ede:	6a 00                	push   $0x0
  pushl $63
80105ee0:	6a 3f                	push   $0x3f
  jmp alltraps
80105ee2:	e9 20 f9 ff ff       	jmp    80105807 <alltraps>

80105ee7 <vector64>:
.globl vector64
vector64:
  pushl $0
80105ee7:	6a 00                	push   $0x0
  pushl $64
80105ee9:	6a 40                	push   $0x40
  jmp alltraps
80105eeb:	e9 17 f9 ff ff       	jmp    80105807 <alltraps>

80105ef0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105ef0:	6a 00                	push   $0x0
  pushl $65
80105ef2:	6a 41                	push   $0x41
  jmp alltraps
80105ef4:	e9 0e f9 ff ff       	jmp    80105807 <alltraps>

80105ef9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105ef9:	6a 00                	push   $0x0
  pushl $66
80105efb:	6a 42                	push   $0x42
  jmp alltraps
80105efd:	e9 05 f9 ff ff       	jmp    80105807 <alltraps>

80105f02 <vector67>:
.globl vector67
vector67:
  pushl $0
80105f02:	6a 00                	push   $0x0
  pushl $67
80105f04:	6a 43                	push   $0x43
  jmp alltraps
80105f06:	e9 fc f8 ff ff       	jmp    80105807 <alltraps>

80105f0b <vector68>:
.globl vector68
vector68:
  pushl $0
80105f0b:	6a 00                	push   $0x0
  pushl $68
80105f0d:	6a 44                	push   $0x44
  jmp alltraps
80105f0f:	e9 f3 f8 ff ff       	jmp    80105807 <alltraps>

80105f14 <vector69>:
.globl vector69
vector69:
  pushl $0
80105f14:	6a 00                	push   $0x0
  pushl $69
80105f16:	6a 45                	push   $0x45
  jmp alltraps
80105f18:	e9 ea f8 ff ff       	jmp    80105807 <alltraps>

80105f1d <vector70>:
.globl vector70
vector70:
  pushl $0
80105f1d:	6a 00                	push   $0x0
  pushl $70
80105f1f:	6a 46                	push   $0x46
  jmp alltraps
80105f21:	e9 e1 f8 ff ff       	jmp    80105807 <alltraps>

80105f26 <vector71>:
.globl vector71
vector71:
  pushl $0
80105f26:	6a 00                	push   $0x0
  pushl $71
80105f28:	6a 47                	push   $0x47
  jmp alltraps
80105f2a:	e9 d8 f8 ff ff       	jmp    80105807 <alltraps>

80105f2f <vector72>:
.globl vector72
vector72:
  pushl $0
80105f2f:	6a 00                	push   $0x0
  pushl $72
80105f31:	6a 48                	push   $0x48
  jmp alltraps
80105f33:	e9 cf f8 ff ff       	jmp    80105807 <alltraps>

80105f38 <vector73>:
.globl vector73
vector73:
  pushl $0
80105f38:	6a 00                	push   $0x0
  pushl $73
80105f3a:	6a 49                	push   $0x49
  jmp alltraps
80105f3c:	e9 c6 f8 ff ff       	jmp    80105807 <alltraps>

80105f41 <vector74>:
.globl vector74
vector74:
  pushl $0
80105f41:	6a 00                	push   $0x0
  pushl $74
80105f43:	6a 4a                	push   $0x4a
  jmp alltraps
80105f45:	e9 bd f8 ff ff       	jmp    80105807 <alltraps>

80105f4a <vector75>:
.globl vector75
vector75:
  pushl $0
80105f4a:	6a 00                	push   $0x0
  pushl $75
80105f4c:	6a 4b                	push   $0x4b
  jmp alltraps
80105f4e:	e9 b4 f8 ff ff       	jmp    80105807 <alltraps>

80105f53 <vector76>:
.globl vector76
vector76:
  pushl $0
80105f53:	6a 00                	push   $0x0
  pushl $76
80105f55:	6a 4c                	push   $0x4c
  jmp alltraps
80105f57:	e9 ab f8 ff ff       	jmp    80105807 <alltraps>

80105f5c <vector77>:
.globl vector77
vector77:
  pushl $0
80105f5c:	6a 00                	push   $0x0
  pushl $77
80105f5e:	6a 4d                	push   $0x4d
  jmp alltraps
80105f60:	e9 a2 f8 ff ff       	jmp    80105807 <alltraps>

80105f65 <vector78>:
.globl vector78
vector78:
  pushl $0
80105f65:	6a 00                	push   $0x0
  pushl $78
80105f67:	6a 4e                	push   $0x4e
  jmp alltraps
80105f69:	e9 99 f8 ff ff       	jmp    80105807 <alltraps>

80105f6e <vector79>:
.globl vector79
vector79:
  pushl $0
80105f6e:	6a 00                	push   $0x0
  pushl $79
80105f70:	6a 4f                	push   $0x4f
  jmp alltraps
80105f72:	e9 90 f8 ff ff       	jmp    80105807 <alltraps>

80105f77 <vector80>:
.globl vector80
vector80:
  pushl $0
80105f77:	6a 00                	push   $0x0
  pushl $80
80105f79:	6a 50                	push   $0x50
  jmp alltraps
80105f7b:	e9 87 f8 ff ff       	jmp    80105807 <alltraps>

80105f80 <vector81>:
.globl vector81
vector81:
  pushl $0
80105f80:	6a 00                	push   $0x0
  pushl $81
80105f82:	6a 51                	push   $0x51
  jmp alltraps
80105f84:	e9 7e f8 ff ff       	jmp    80105807 <alltraps>

80105f89 <vector82>:
.globl vector82
vector82:
  pushl $0
80105f89:	6a 00                	push   $0x0
  pushl $82
80105f8b:	6a 52                	push   $0x52
  jmp alltraps
80105f8d:	e9 75 f8 ff ff       	jmp    80105807 <alltraps>

80105f92 <vector83>:
.globl vector83
vector83:
  pushl $0
80105f92:	6a 00                	push   $0x0
  pushl $83
80105f94:	6a 53                	push   $0x53
  jmp alltraps
80105f96:	e9 6c f8 ff ff       	jmp    80105807 <alltraps>

80105f9b <vector84>:
.globl vector84
vector84:
  pushl $0
80105f9b:	6a 00                	push   $0x0
  pushl $84
80105f9d:	6a 54                	push   $0x54
  jmp alltraps
80105f9f:	e9 63 f8 ff ff       	jmp    80105807 <alltraps>

80105fa4 <vector85>:
.globl vector85
vector85:
  pushl $0
80105fa4:	6a 00                	push   $0x0
  pushl $85
80105fa6:	6a 55                	push   $0x55
  jmp alltraps
80105fa8:	e9 5a f8 ff ff       	jmp    80105807 <alltraps>

80105fad <vector86>:
.globl vector86
vector86:
  pushl $0
80105fad:	6a 00                	push   $0x0
  pushl $86
80105faf:	6a 56                	push   $0x56
  jmp alltraps
80105fb1:	e9 51 f8 ff ff       	jmp    80105807 <alltraps>

80105fb6 <vector87>:
.globl vector87
vector87:
  pushl $0
80105fb6:	6a 00                	push   $0x0
  pushl $87
80105fb8:	6a 57                	push   $0x57
  jmp alltraps
80105fba:	e9 48 f8 ff ff       	jmp    80105807 <alltraps>

80105fbf <vector88>:
.globl vector88
vector88:
  pushl $0
80105fbf:	6a 00                	push   $0x0
  pushl $88
80105fc1:	6a 58                	push   $0x58
  jmp alltraps
80105fc3:	e9 3f f8 ff ff       	jmp    80105807 <alltraps>

80105fc8 <vector89>:
.globl vector89
vector89:
  pushl $0
80105fc8:	6a 00                	push   $0x0
  pushl $89
80105fca:	6a 59                	push   $0x59
  jmp alltraps
80105fcc:	e9 36 f8 ff ff       	jmp    80105807 <alltraps>

80105fd1 <vector90>:
.globl vector90
vector90:
  pushl $0
80105fd1:	6a 00                	push   $0x0
  pushl $90
80105fd3:	6a 5a                	push   $0x5a
  jmp alltraps
80105fd5:	e9 2d f8 ff ff       	jmp    80105807 <alltraps>

80105fda <vector91>:
.globl vector91
vector91:
  pushl $0
80105fda:	6a 00                	push   $0x0
  pushl $91
80105fdc:	6a 5b                	push   $0x5b
  jmp alltraps
80105fde:	e9 24 f8 ff ff       	jmp    80105807 <alltraps>

80105fe3 <vector92>:
.globl vector92
vector92:
  pushl $0
80105fe3:	6a 00                	push   $0x0
  pushl $92
80105fe5:	6a 5c                	push   $0x5c
  jmp alltraps
80105fe7:	e9 1b f8 ff ff       	jmp    80105807 <alltraps>

80105fec <vector93>:
.globl vector93
vector93:
  pushl $0
80105fec:	6a 00                	push   $0x0
  pushl $93
80105fee:	6a 5d                	push   $0x5d
  jmp alltraps
80105ff0:	e9 12 f8 ff ff       	jmp    80105807 <alltraps>

80105ff5 <vector94>:
.globl vector94
vector94:
  pushl $0
80105ff5:	6a 00                	push   $0x0
  pushl $94
80105ff7:	6a 5e                	push   $0x5e
  jmp alltraps
80105ff9:	e9 09 f8 ff ff       	jmp    80105807 <alltraps>

80105ffe <vector95>:
.globl vector95
vector95:
  pushl $0
80105ffe:	6a 00                	push   $0x0
  pushl $95
80106000:	6a 5f                	push   $0x5f
  jmp alltraps
80106002:	e9 00 f8 ff ff       	jmp    80105807 <alltraps>

80106007 <vector96>:
.globl vector96
vector96:
  pushl $0
80106007:	6a 00                	push   $0x0
  pushl $96
80106009:	6a 60                	push   $0x60
  jmp alltraps
8010600b:	e9 f7 f7 ff ff       	jmp    80105807 <alltraps>

80106010 <vector97>:
.globl vector97
vector97:
  pushl $0
80106010:	6a 00                	push   $0x0
  pushl $97
80106012:	6a 61                	push   $0x61
  jmp alltraps
80106014:	e9 ee f7 ff ff       	jmp    80105807 <alltraps>

80106019 <vector98>:
.globl vector98
vector98:
  pushl $0
80106019:	6a 00                	push   $0x0
  pushl $98
8010601b:	6a 62                	push   $0x62
  jmp alltraps
8010601d:	e9 e5 f7 ff ff       	jmp    80105807 <alltraps>

80106022 <vector99>:
.globl vector99
vector99:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $99
80106024:	6a 63                	push   $0x63
  jmp alltraps
80106026:	e9 dc f7 ff ff       	jmp    80105807 <alltraps>

8010602b <vector100>:
.globl vector100
vector100:
  pushl $0
8010602b:	6a 00                	push   $0x0
  pushl $100
8010602d:	6a 64                	push   $0x64
  jmp alltraps
8010602f:	e9 d3 f7 ff ff       	jmp    80105807 <alltraps>

80106034 <vector101>:
.globl vector101
vector101:
  pushl $0
80106034:	6a 00                	push   $0x0
  pushl $101
80106036:	6a 65                	push   $0x65
  jmp alltraps
80106038:	e9 ca f7 ff ff       	jmp    80105807 <alltraps>

8010603d <vector102>:
.globl vector102
vector102:
  pushl $0
8010603d:	6a 00                	push   $0x0
  pushl $102
8010603f:	6a 66                	push   $0x66
  jmp alltraps
80106041:	e9 c1 f7 ff ff       	jmp    80105807 <alltraps>

80106046 <vector103>:
.globl vector103
vector103:
  pushl $0
80106046:	6a 00                	push   $0x0
  pushl $103
80106048:	6a 67                	push   $0x67
  jmp alltraps
8010604a:	e9 b8 f7 ff ff       	jmp    80105807 <alltraps>

8010604f <vector104>:
.globl vector104
vector104:
  pushl $0
8010604f:	6a 00                	push   $0x0
  pushl $104
80106051:	6a 68                	push   $0x68
  jmp alltraps
80106053:	e9 af f7 ff ff       	jmp    80105807 <alltraps>

80106058 <vector105>:
.globl vector105
vector105:
  pushl $0
80106058:	6a 00                	push   $0x0
  pushl $105
8010605a:	6a 69                	push   $0x69
  jmp alltraps
8010605c:	e9 a6 f7 ff ff       	jmp    80105807 <alltraps>

80106061 <vector106>:
.globl vector106
vector106:
  pushl $0
80106061:	6a 00                	push   $0x0
  pushl $106
80106063:	6a 6a                	push   $0x6a
  jmp alltraps
80106065:	e9 9d f7 ff ff       	jmp    80105807 <alltraps>

8010606a <vector107>:
.globl vector107
vector107:
  pushl $0
8010606a:	6a 00                	push   $0x0
  pushl $107
8010606c:	6a 6b                	push   $0x6b
  jmp alltraps
8010606e:	e9 94 f7 ff ff       	jmp    80105807 <alltraps>

80106073 <vector108>:
.globl vector108
vector108:
  pushl $0
80106073:	6a 00                	push   $0x0
  pushl $108
80106075:	6a 6c                	push   $0x6c
  jmp alltraps
80106077:	e9 8b f7 ff ff       	jmp    80105807 <alltraps>

8010607c <vector109>:
.globl vector109
vector109:
  pushl $0
8010607c:	6a 00                	push   $0x0
  pushl $109
8010607e:	6a 6d                	push   $0x6d
  jmp alltraps
80106080:	e9 82 f7 ff ff       	jmp    80105807 <alltraps>

80106085 <vector110>:
.globl vector110
vector110:
  pushl $0
80106085:	6a 00                	push   $0x0
  pushl $110
80106087:	6a 6e                	push   $0x6e
  jmp alltraps
80106089:	e9 79 f7 ff ff       	jmp    80105807 <alltraps>

8010608e <vector111>:
.globl vector111
vector111:
  pushl $0
8010608e:	6a 00                	push   $0x0
  pushl $111
80106090:	6a 6f                	push   $0x6f
  jmp alltraps
80106092:	e9 70 f7 ff ff       	jmp    80105807 <alltraps>

80106097 <vector112>:
.globl vector112
vector112:
  pushl $0
80106097:	6a 00                	push   $0x0
  pushl $112
80106099:	6a 70                	push   $0x70
  jmp alltraps
8010609b:	e9 67 f7 ff ff       	jmp    80105807 <alltraps>

801060a0 <vector113>:
.globl vector113
vector113:
  pushl $0
801060a0:	6a 00                	push   $0x0
  pushl $113
801060a2:	6a 71                	push   $0x71
  jmp alltraps
801060a4:	e9 5e f7 ff ff       	jmp    80105807 <alltraps>

801060a9 <vector114>:
.globl vector114
vector114:
  pushl $0
801060a9:	6a 00                	push   $0x0
  pushl $114
801060ab:	6a 72                	push   $0x72
  jmp alltraps
801060ad:	e9 55 f7 ff ff       	jmp    80105807 <alltraps>

801060b2 <vector115>:
.globl vector115
vector115:
  pushl $0
801060b2:	6a 00                	push   $0x0
  pushl $115
801060b4:	6a 73                	push   $0x73
  jmp alltraps
801060b6:	e9 4c f7 ff ff       	jmp    80105807 <alltraps>

801060bb <vector116>:
.globl vector116
vector116:
  pushl $0
801060bb:	6a 00                	push   $0x0
  pushl $116
801060bd:	6a 74                	push   $0x74
  jmp alltraps
801060bf:	e9 43 f7 ff ff       	jmp    80105807 <alltraps>

801060c4 <vector117>:
.globl vector117
vector117:
  pushl $0
801060c4:	6a 00                	push   $0x0
  pushl $117
801060c6:	6a 75                	push   $0x75
  jmp alltraps
801060c8:	e9 3a f7 ff ff       	jmp    80105807 <alltraps>

801060cd <vector118>:
.globl vector118
vector118:
  pushl $0
801060cd:	6a 00                	push   $0x0
  pushl $118
801060cf:	6a 76                	push   $0x76
  jmp alltraps
801060d1:	e9 31 f7 ff ff       	jmp    80105807 <alltraps>

801060d6 <vector119>:
.globl vector119
vector119:
  pushl $0
801060d6:	6a 00                	push   $0x0
  pushl $119
801060d8:	6a 77                	push   $0x77
  jmp alltraps
801060da:	e9 28 f7 ff ff       	jmp    80105807 <alltraps>

801060df <vector120>:
.globl vector120
vector120:
  pushl $0
801060df:	6a 00                	push   $0x0
  pushl $120
801060e1:	6a 78                	push   $0x78
  jmp alltraps
801060e3:	e9 1f f7 ff ff       	jmp    80105807 <alltraps>

801060e8 <vector121>:
.globl vector121
vector121:
  pushl $0
801060e8:	6a 00                	push   $0x0
  pushl $121
801060ea:	6a 79                	push   $0x79
  jmp alltraps
801060ec:	e9 16 f7 ff ff       	jmp    80105807 <alltraps>

801060f1 <vector122>:
.globl vector122
vector122:
  pushl $0
801060f1:	6a 00                	push   $0x0
  pushl $122
801060f3:	6a 7a                	push   $0x7a
  jmp alltraps
801060f5:	e9 0d f7 ff ff       	jmp    80105807 <alltraps>

801060fa <vector123>:
.globl vector123
vector123:
  pushl $0
801060fa:	6a 00                	push   $0x0
  pushl $123
801060fc:	6a 7b                	push   $0x7b
  jmp alltraps
801060fe:	e9 04 f7 ff ff       	jmp    80105807 <alltraps>

80106103 <vector124>:
.globl vector124
vector124:
  pushl $0
80106103:	6a 00                	push   $0x0
  pushl $124
80106105:	6a 7c                	push   $0x7c
  jmp alltraps
80106107:	e9 fb f6 ff ff       	jmp    80105807 <alltraps>

8010610c <vector125>:
.globl vector125
vector125:
  pushl $0
8010610c:	6a 00                	push   $0x0
  pushl $125
8010610e:	6a 7d                	push   $0x7d
  jmp alltraps
80106110:	e9 f2 f6 ff ff       	jmp    80105807 <alltraps>

80106115 <vector126>:
.globl vector126
vector126:
  pushl $0
80106115:	6a 00                	push   $0x0
  pushl $126
80106117:	6a 7e                	push   $0x7e
  jmp alltraps
80106119:	e9 e9 f6 ff ff       	jmp    80105807 <alltraps>

8010611e <vector127>:
.globl vector127
vector127:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $127
80106120:	6a 7f                	push   $0x7f
  jmp alltraps
80106122:	e9 e0 f6 ff ff       	jmp    80105807 <alltraps>

80106127 <vector128>:
.globl vector128
vector128:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $128
80106129:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010612e:	e9 d4 f6 ff ff       	jmp    80105807 <alltraps>

80106133 <vector129>:
.globl vector129
vector129:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $129
80106135:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010613a:	e9 c8 f6 ff ff       	jmp    80105807 <alltraps>

8010613f <vector130>:
.globl vector130
vector130:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $130
80106141:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106146:	e9 bc f6 ff ff       	jmp    80105807 <alltraps>

8010614b <vector131>:
.globl vector131
vector131:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $131
8010614d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106152:	e9 b0 f6 ff ff       	jmp    80105807 <alltraps>

80106157 <vector132>:
.globl vector132
vector132:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $132
80106159:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010615e:	e9 a4 f6 ff ff       	jmp    80105807 <alltraps>

80106163 <vector133>:
.globl vector133
vector133:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $133
80106165:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010616a:	e9 98 f6 ff ff       	jmp    80105807 <alltraps>

8010616f <vector134>:
.globl vector134
vector134:
  pushl $0
8010616f:	6a 00                	push   $0x0
  pushl $134
80106171:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106176:	e9 8c f6 ff ff       	jmp    80105807 <alltraps>

8010617b <vector135>:
.globl vector135
vector135:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $135
8010617d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106182:	e9 80 f6 ff ff       	jmp    80105807 <alltraps>

80106187 <vector136>:
.globl vector136
vector136:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $136
80106189:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010618e:	e9 74 f6 ff ff       	jmp    80105807 <alltraps>

80106193 <vector137>:
.globl vector137
vector137:
  pushl $0
80106193:	6a 00                	push   $0x0
  pushl $137
80106195:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010619a:	e9 68 f6 ff ff       	jmp    80105807 <alltraps>

8010619f <vector138>:
.globl vector138
vector138:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $138
801061a1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801061a6:	e9 5c f6 ff ff       	jmp    80105807 <alltraps>

801061ab <vector139>:
.globl vector139
vector139:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $139
801061ad:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801061b2:	e9 50 f6 ff ff       	jmp    80105807 <alltraps>

801061b7 <vector140>:
.globl vector140
vector140:
  pushl $0
801061b7:	6a 00                	push   $0x0
  pushl $140
801061b9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801061be:	e9 44 f6 ff ff       	jmp    80105807 <alltraps>

801061c3 <vector141>:
.globl vector141
vector141:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $141
801061c5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801061ca:	e9 38 f6 ff ff       	jmp    80105807 <alltraps>

801061cf <vector142>:
.globl vector142
vector142:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $142
801061d1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801061d6:	e9 2c f6 ff ff       	jmp    80105807 <alltraps>

801061db <vector143>:
.globl vector143
vector143:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $143
801061dd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801061e2:	e9 20 f6 ff ff       	jmp    80105807 <alltraps>

801061e7 <vector144>:
.globl vector144
vector144:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $144
801061e9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801061ee:	e9 14 f6 ff ff       	jmp    80105807 <alltraps>

801061f3 <vector145>:
.globl vector145
vector145:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $145
801061f5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801061fa:	e9 08 f6 ff ff       	jmp    80105807 <alltraps>

801061ff <vector146>:
.globl vector146
vector146:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $146
80106201:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106206:	e9 fc f5 ff ff       	jmp    80105807 <alltraps>

8010620b <vector147>:
.globl vector147
vector147:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $147
8010620d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106212:	e9 f0 f5 ff ff       	jmp    80105807 <alltraps>

80106217 <vector148>:
.globl vector148
vector148:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $148
80106219:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010621e:	e9 e4 f5 ff ff       	jmp    80105807 <alltraps>

80106223 <vector149>:
.globl vector149
vector149:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $149
80106225:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010622a:	e9 d8 f5 ff ff       	jmp    80105807 <alltraps>

8010622f <vector150>:
.globl vector150
vector150:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $150
80106231:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106236:	e9 cc f5 ff ff       	jmp    80105807 <alltraps>

8010623b <vector151>:
.globl vector151
vector151:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $151
8010623d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106242:	e9 c0 f5 ff ff       	jmp    80105807 <alltraps>

80106247 <vector152>:
.globl vector152
vector152:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $152
80106249:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010624e:	e9 b4 f5 ff ff       	jmp    80105807 <alltraps>

80106253 <vector153>:
.globl vector153
vector153:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $153
80106255:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010625a:	e9 a8 f5 ff ff       	jmp    80105807 <alltraps>

8010625f <vector154>:
.globl vector154
vector154:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $154
80106261:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106266:	e9 9c f5 ff ff       	jmp    80105807 <alltraps>

8010626b <vector155>:
.globl vector155
vector155:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $155
8010626d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106272:	e9 90 f5 ff ff       	jmp    80105807 <alltraps>

80106277 <vector156>:
.globl vector156
vector156:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $156
80106279:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010627e:	e9 84 f5 ff ff       	jmp    80105807 <alltraps>

80106283 <vector157>:
.globl vector157
vector157:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $157
80106285:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010628a:	e9 78 f5 ff ff       	jmp    80105807 <alltraps>

8010628f <vector158>:
.globl vector158
vector158:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $158
80106291:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106296:	e9 6c f5 ff ff       	jmp    80105807 <alltraps>

8010629b <vector159>:
.globl vector159
vector159:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $159
8010629d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801062a2:	e9 60 f5 ff ff       	jmp    80105807 <alltraps>

801062a7 <vector160>:
.globl vector160
vector160:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $160
801062a9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801062ae:	e9 54 f5 ff ff       	jmp    80105807 <alltraps>

801062b3 <vector161>:
.globl vector161
vector161:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $161
801062b5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801062ba:	e9 48 f5 ff ff       	jmp    80105807 <alltraps>

801062bf <vector162>:
.globl vector162
vector162:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $162
801062c1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801062c6:	e9 3c f5 ff ff       	jmp    80105807 <alltraps>

801062cb <vector163>:
.globl vector163
vector163:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $163
801062cd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801062d2:	e9 30 f5 ff ff       	jmp    80105807 <alltraps>

801062d7 <vector164>:
.globl vector164
vector164:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $164
801062d9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801062de:	e9 24 f5 ff ff       	jmp    80105807 <alltraps>

801062e3 <vector165>:
.globl vector165
vector165:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $165
801062e5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801062ea:	e9 18 f5 ff ff       	jmp    80105807 <alltraps>

801062ef <vector166>:
.globl vector166
vector166:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $166
801062f1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801062f6:	e9 0c f5 ff ff       	jmp    80105807 <alltraps>

801062fb <vector167>:
.globl vector167
vector167:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $167
801062fd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106302:	e9 00 f5 ff ff       	jmp    80105807 <alltraps>

80106307 <vector168>:
.globl vector168
vector168:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $168
80106309:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010630e:	e9 f4 f4 ff ff       	jmp    80105807 <alltraps>

80106313 <vector169>:
.globl vector169
vector169:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $169
80106315:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010631a:	e9 e8 f4 ff ff       	jmp    80105807 <alltraps>

8010631f <vector170>:
.globl vector170
vector170:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $170
80106321:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106326:	e9 dc f4 ff ff       	jmp    80105807 <alltraps>

8010632b <vector171>:
.globl vector171
vector171:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $171
8010632d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106332:	e9 d0 f4 ff ff       	jmp    80105807 <alltraps>

80106337 <vector172>:
.globl vector172
vector172:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $172
80106339:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010633e:	e9 c4 f4 ff ff       	jmp    80105807 <alltraps>

80106343 <vector173>:
.globl vector173
vector173:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $173
80106345:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010634a:	e9 b8 f4 ff ff       	jmp    80105807 <alltraps>

8010634f <vector174>:
.globl vector174
vector174:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $174
80106351:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106356:	e9 ac f4 ff ff       	jmp    80105807 <alltraps>

8010635b <vector175>:
.globl vector175
vector175:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $175
8010635d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106362:	e9 a0 f4 ff ff       	jmp    80105807 <alltraps>

80106367 <vector176>:
.globl vector176
vector176:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $176
80106369:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010636e:	e9 94 f4 ff ff       	jmp    80105807 <alltraps>

80106373 <vector177>:
.globl vector177
vector177:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $177
80106375:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010637a:	e9 88 f4 ff ff       	jmp    80105807 <alltraps>

8010637f <vector178>:
.globl vector178
vector178:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $178
80106381:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106386:	e9 7c f4 ff ff       	jmp    80105807 <alltraps>

8010638b <vector179>:
.globl vector179
vector179:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $179
8010638d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106392:	e9 70 f4 ff ff       	jmp    80105807 <alltraps>

80106397 <vector180>:
.globl vector180
vector180:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $180
80106399:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010639e:	e9 64 f4 ff ff       	jmp    80105807 <alltraps>

801063a3 <vector181>:
.globl vector181
vector181:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $181
801063a5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801063aa:	e9 58 f4 ff ff       	jmp    80105807 <alltraps>

801063af <vector182>:
.globl vector182
vector182:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $182
801063b1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801063b6:	e9 4c f4 ff ff       	jmp    80105807 <alltraps>

801063bb <vector183>:
.globl vector183
vector183:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $183
801063bd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801063c2:	e9 40 f4 ff ff       	jmp    80105807 <alltraps>

801063c7 <vector184>:
.globl vector184
vector184:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $184
801063c9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801063ce:	e9 34 f4 ff ff       	jmp    80105807 <alltraps>

801063d3 <vector185>:
.globl vector185
vector185:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $185
801063d5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801063da:	e9 28 f4 ff ff       	jmp    80105807 <alltraps>

801063df <vector186>:
.globl vector186
vector186:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $186
801063e1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801063e6:	e9 1c f4 ff ff       	jmp    80105807 <alltraps>

801063eb <vector187>:
.globl vector187
vector187:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $187
801063ed:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801063f2:	e9 10 f4 ff ff       	jmp    80105807 <alltraps>

801063f7 <vector188>:
.globl vector188
vector188:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $188
801063f9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801063fe:	e9 04 f4 ff ff       	jmp    80105807 <alltraps>

80106403 <vector189>:
.globl vector189
vector189:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $189
80106405:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010640a:	e9 f8 f3 ff ff       	jmp    80105807 <alltraps>

8010640f <vector190>:
.globl vector190
vector190:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $190
80106411:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106416:	e9 ec f3 ff ff       	jmp    80105807 <alltraps>

8010641b <vector191>:
.globl vector191
vector191:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $191
8010641d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106422:	e9 e0 f3 ff ff       	jmp    80105807 <alltraps>

80106427 <vector192>:
.globl vector192
vector192:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $192
80106429:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010642e:	e9 d4 f3 ff ff       	jmp    80105807 <alltraps>

80106433 <vector193>:
.globl vector193
vector193:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $193
80106435:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010643a:	e9 c8 f3 ff ff       	jmp    80105807 <alltraps>

8010643f <vector194>:
.globl vector194
vector194:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $194
80106441:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106446:	e9 bc f3 ff ff       	jmp    80105807 <alltraps>

8010644b <vector195>:
.globl vector195
vector195:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $195
8010644d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106452:	e9 b0 f3 ff ff       	jmp    80105807 <alltraps>

80106457 <vector196>:
.globl vector196
vector196:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $196
80106459:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010645e:	e9 a4 f3 ff ff       	jmp    80105807 <alltraps>

80106463 <vector197>:
.globl vector197
vector197:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $197
80106465:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010646a:	e9 98 f3 ff ff       	jmp    80105807 <alltraps>

8010646f <vector198>:
.globl vector198
vector198:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $198
80106471:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106476:	e9 8c f3 ff ff       	jmp    80105807 <alltraps>

8010647b <vector199>:
.globl vector199
vector199:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $199
8010647d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106482:	e9 80 f3 ff ff       	jmp    80105807 <alltraps>

80106487 <vector200>:
.globl vector200
vector200:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $200
80106489:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010648e:	e9 74 f3 ff ff       	jmp    80105807 <alltraps>

80106493 <vector201>:
.globl vector201
vector201:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $201
80106495:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010649a:	e9 68 f3 ff ff       	jmp    80105807 <alltraps>

8010649f <vector202>:
.globl vector202
vector202:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $202
801064a1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801064a6:	e9 5c f3 ff ff       	jmp    80105807 <alltraps>

801064ab <vector203>:
.globl vector203
vector203:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $203
801064ad:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801064b2:	e9 50 f3 ff ff       	jmp    80105807 <alltraps>

801064b7 <vector204>:
.globl vector204
vector204:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $204
801064b9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801064be:	e9 44 f3 ff ff       	jmp    80105807 <alltraps>

801064c3 <vector205>:
.globl vector205
vector205:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $205
801064c5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801064ca:	e9 38 f3 ff ff       	jmp    80105807 <alltraps>

801064cf <vector206>:
.globl vector206
vector206:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $206
801064d1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801064d6:	e9 2c f3 ff ff       	jmp    80105807 <alltraps>

801064db <vector207>:
.globl vector207
vector207:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $207
801064dd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801064e2:	e9 20 f3 ff ff       	jmp    80105807 <alltraps>

801064e7 <vector208>:
.globl vector208
vector208:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $208
801064e9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801064ee:	e9 14 f3 ff ff       	jmp    80105807 <alltraps>

801064f3 <vector209>:
.globl vector209
vector209:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $209
801064f5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801064fa:	e9 08 f3 ff ff       	jmp    80105807 <alltraps>

801064ff <vector210>:
.globl vector210
vector210:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $210
80106501:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106506:	e9 fc f2 ff ff       	jmp    80105807 <alltraps>

8010650b <vector211>:
.globl vector211
vector211:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $211
8010650d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106512:	e9 f0 f2 ff ff       	jmp    80105807 <alltraps>

80106517 <vector212>:
.globl vector212
vector212:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $212
80106519:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010651e:	e9 e4 f2 ff ff       	jmp    80105807 <alltraps>

80106523 <vector213>:
.globl vector213
vector213:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $213
80106525:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010652a:	e9 d8 f2 ff ff       	jmp    80105807 <alltraps>

8010652f <vector214>:
.globl vector214
vector214:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $214
80106531:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106536:	e9 cc f2 ff ff       	jmp    80105807 <alltraps>

8010653b <vector215>:
.globl vector215
vector215:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $215
8010653d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106542:	e9 c0 f2 ff ff       	jmp    80105807 <alltraps>

80106547 <vector216>:
.globl vector216
vector216:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $216
80106549:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010654e:	e9 b4 f2 ff ff       	jmp    80105807 <alltraps>

80106553 <vector217>:
.globl vector217
vector217:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $217
80106555:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010655a:	e9 a8 f2 ff ff       	jmp    80105807 <alltraps>

8010655f <vector218>:
.globl vector218
vector218:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $218
80106561:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106566:	e9 9c f2 ff ff       	jmp    80105807 <alltraps>

8010656b <vector219>:
.globl vector219
vector219:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $219
8010656d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106572:	e9 90 f2 ff ff       	jmp    80105807 <alltraps>

80106577 <vector220>:
.globl vector220
vector220:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $220
80106579:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010657e:	e9 84 f2 ff ff       	jmp    80105807 <alltraps>

80106583 <vector221>:
.globl vector221
vector221:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $221
80106585:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010658a:	e9 78 f2 ff ff       	jmp    80105807 <alltraps>

8010658f <vector222>:
.globl vector222
vector222:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $222
80106591:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106596:	e9 6c f2 ff ff       	jmp    80105807 <alltraps>

8010659b <vector223>:
.globl vector223
vector223:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $223
8010659d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801065a2:	e9 60 f2 ff ff       	jmp    80105807 <alltraps>

801065a7 <vector224>:
.globl vector224
vector224:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $224
801065a9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801065ae:	e9 54 f2 ff ff       	jmp    80105807 <alltraps>

801065b3 <vector225>:
.globl vector225
vector225:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $225
801065b5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801065ba:	e9 48 f2 ff ff       	jmp    80105807 <alltraps>

801065bf <vector226>:
.globl vector226
vector226:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $226
801065c1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801065c6:	e9 3c f2 ff ff       	jmp    80105807 <alltraps>

801065cb <vector227>:
.globl vector227
vector227:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $227
801065cd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801065d2:	e9 30 f2 ff ff       	jmp    80105807 <alltraps>

801065d7 <vector228>:
.globl vector228
vector228:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $228
801065d9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801065de:	e9 24 f2 ff ff       	jmp    80105807 <alltraps>

801065e3 <vector229>:
.globl vector229
vector229:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $229
801065e5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801065ea:	e9 18 f2 ff ff       	jmp    80105807 <alltraps>

801065ef <vector230>:
.globl vector230
vector230:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $230
801065f1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801065f6:	e9 0c f2 ff ff       	jmp    80105807 <alltraps>

801065fb <vector231>:
.globl vector231
vector231:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $231
801065fd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106602:	e9 00 f2 ff ff       	jmp    80105807 <alltraps>

80106607 <vector232>:
.globl vector232
vector232:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $232
80106609:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010660e:	e9 f4 f1 ff ff       	jmp    80105807 <alltraps>

80106613 <vector233>:
.globl vector233
vector233:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $233
80106615:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010661a:	e9 e8 f1 ff ff       	jmp    80105807 <alltraps>

8010661f <vector234>:
.globl vector234
vector234:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $234
80106621:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106626:	e9 dc f1 ff ff       	jmp    80105807 <alltraps>

8010662b <vector235>:
.globl vector235
vector235:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $235
8010662d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106632:	e9 d0 f1 ff ff       	jmp    80105807 <alltraps>

80106637 <vector236>:
.globl vector236
vector236:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $236
80106639:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010663e:	e9 c4 f1 ff ff       	jmp    80105807 <alltraps>

80106643 <vector237>:
.globl vector237
vector237:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $237
80106645:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010664a:	e9 b8 f1 ff ff       	jmp    80105807 <alltraps>

8010664f <vector238>:
.globl vector238
vector238:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $238
80106651:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106656:	e9 ac f1 ff ff       	jmp    80105807 <alltraps>

8010665b <vector239>:
.globl vector239
vector239:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $239
8010665d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106662:	e9 a0 f1 ff ff       	jmp    80105807 <alltraps>

80106667 <vector240>:
.globl vector240
vector240:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $240
80106669:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010666e:	e9 94 f1 ff ff       	jmp    80105807 <alltraps>

80106673 <vector241>:
.globl vector241
vector241:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $241
80106675:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010667a:	e9 88 f1 ff ff       	jmp    80105807 <alltraps>

8010667f <vector242>:
.globl vector242
vector242:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $242
80106681:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106686:	e9 7c f1 ff ff       	jmp    80105807 <alltraps>

8010668b <vector243>:
.globl vector243
vector243:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $243
8010668d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106692:	e9 70 f1 ff ff       	jmp    80105807 <alltraps>

80106697 <vector244>:
.globl vector244
vector244:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $244
80106699:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010669e:	e9 64 f1 ff ff       	jmp    80105807 <alltraps>

801066a3 <vector245>:
.globl vector245
vector245:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $245
801066a5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801066aa:	e9 58 f1 ff ff       	jmp    80105807 <alltraps>

801066af <vector246>:
.globl vector246
vector246:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $246
801066b1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801066b6:	e9 4c f1 ff ff       	jmp    80105807 <alltraps>

801066bb <vector247>:
.globl vector247
vector247:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $247
801066bd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801066c2:	e9 40 f1 ff ff       	jmp    80105807 <alltraps>

801066c7 <vector248>:
.globl vector248
vector248:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $248
801066c9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801066ce:	e9 34 f1 ff ff       	jmp    80105807 <alltraps>

801066d3 <vector249>:
.globl vector249
vector249:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $249
801066d5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801066da:	e9 28 f1 ff ff       	jmp    80105807 <alltraps>

801066df <vector250>:
.globl vector250
vector250:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $250
801066e1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801066e6:	e9 1c f1 ff ff       	jmp    80105807 <alltraps>

801066eb <vector251>:
.globl vector251
vector251:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $251
801066ed:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801066f2:	e9 10 f1 ff ff       	jmp    80105807 <alltraps>

801066f7 <vector252>:
.globl vector252
vector252:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $252
801066f9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801066fe:	e9 04 f1 ff ff       	jmp    80105807 <alltraps>

80106703 <vector253>:
.globl vector253
vector253:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $253
80106705:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010670a:	e9 f8 f0 ff ff       	jmp    80105807 <alltraps>

8010670f <vector254>:
.globl vector254
vector254:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $254
80106711:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106716:	e9 ec f0 ff ff       	jmp    80105807 <alltraps>

8010671b <vector255>:
.globl vector255
vector255:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $255
8010671d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106722:	e9 e0 f0 ff ff       	jmp    80105807 <alltraps>
80106727:	66 90                	xchg   %ax,%ax
80106729:	66 90                	xchg   %ax,%ax
8010672b:	66 90                	xchg   %ax,%ax
8010672d:	66 90                	xchg   %ax,%ax
8010672f:	90                   	nop

80106730 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106730:	55                   	push   %ebp
80106731:	89 e5                	mov    %esp,%ebp
80106733:	57                   	push   %edi
80106734:	56                   	push   %esi
80106735:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106737:	c1 ea 16             	shr    $0x16,%edx
{
8010673a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010673b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010673e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106741:	8b 1f                	mov    (%edi),%ebx
80106743:	f6 c3 01             	test   $0x1,%bl
80106746:	74 28                	je     80106770 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106748:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010674e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106754:	89 f0                	mov    %esi,%eax
}
80106756:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106759:	c1 e8 0a             	shr    $0xa,%eax
8010675c:	25 fc 0f 00 00       	and    $0xffc,%eax
80106761:	01 d8                	add    %ebx,%eax
}
80106763:	5b                   	pop    %ebx
80106764:	5e                   	pop    %esi
80106765:	5f                   	pop    %edi
80106766:	5d                   	pop    %ebp
80106767:	c3                   	ret    
80106768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010676f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106770:	85 c9                	test   %ecx,%ecx
80106772:	74 2c                	je     801067a0 <walkpgdir+0x70>
80106774:	e8 27 be ff ff       	call   801025a0 <kalloc>
80106779:	89 c3                	mov    %eax,%ebx
8010677b:	85 c0                	test   %eax,%eax
8010677d:	74 21                	je     801067a0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010677f:	83 ec 04             	sub    $0x4,%esp
80106782:	68 00 10 00 00       	push   $0x1000
80106787:	6a 00                	push   $0x0
80106789:	50                   	push   %eax
8010678a:	e8 a1 de ff ff       	call   80104630 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010678f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106795:	83 c4 10             	add    $0x10,%esp
80106798:	83 c8 07             	or     $0x7,%eax
8010679b:	89 07                	mov    %eax,(%edi)
8010679d:	eb b5                	jmp    80106754 <walkpgdir+0x24>
8010679f:	90                   	nop
}
801067a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801067a3:	31 c0                	xor    %eax,%eax
}
801067a5:	5b                   	pop    %ebx
801067a6:	5e                   	pop    %esi
801067a7:	5f                   	pop    %edi
801067a8:	5d                   	pop    %ebp
801067a9:	c3                   	ret    
801067aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801067b0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801067b0:	55                   	push   %ebp
801067b1:	89 e5                	mov    %esp,%ebp
801067b3:	57                   	push   %edi
801067b4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801067b6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
801067ba:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801067bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
801067c0:	89 d6                	mov    %edx,%esi
{
801067c2:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801067c3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
801067c9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801067cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801067cf:	8b 45 08             	mov    0x8(%ebp),%eax
801067d2:	29 f0                	sub    %esi,%eax
801067d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801067d7:	eb 1f                	jmp    801067f8 <mappages+0x48>
801067d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801067e0:	f6 00 01             	testb  $0x1,(%eax)
801067e3:	75 45                	jne    8010682a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801067e5:	0b 5d 0c             	or     0xc(%ebp),%ebx
801067e8:	83 cb 01             	or     $0x1,%ebx
801067eb:	89 18                	mov    %ebx,(%eax)
    if(a == last)
801067ed:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801067f0:	74 2e                	je     80106820 <mappages+0x70>
      break;
    a += PGSIZE;
801067f2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
801067f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801067fb:	b9 01 00 00 00       	mov    $0x1,%ecx
80106800:	89 f2                	mov    %esi,%edx
80106802:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106805:	89 f8                	mov    %edi,%eax
80106807:	e8 24 ff ff ff       	call   80106730 <walkpgdir>
8010680c:	85 c0                	test   %eax,%eax
8010680e:	75 d0                	jne    801067e0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106810:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106813:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106818:	5b                   	pop    %ebx
80106819:	5e                   	pop    %esi
8010681a:	5f                   	pop    %edi
8010681b:	5d                   	pop    %ebp
8010681c:	c3                   	ret    
8010681d:	8d 76 00             	lea    0x0(%esi),%esi
80106820:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106823:	31 c0                	xor    %eax,%eax
}
80106825:	5b                   	pop    %ebx
80106826:	5e                   	pop    %esi
80106827:	5f                   	pop    %edi
80106828:	5d                   	pop    %ebp
80106829:	c3                   	ret    
      panic("remap");
8010682a:	83 ec 0c             	sub    $0xc,%esp
8010682d:	68 70 79 10 80       	push   $0x80107970
80106832:	e8 49 9b ff ff       	call   80100380 <panic>
80106837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010683e:	66 90                	xchg   %ax,%ax

80106840 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106840:	55                   	push   %ebp
80106841:	89 e5                	mov    %esp,%ebp
80106843:	57                   	push   %edi
80106844:	56                   	push   %esi
80106845:	89 c6                	mov    %eax,%esi
80106847:	53                   	push   %ebx
80106848:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010684a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80106850:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106856:	83 ec 1c             	sub    $0x1c,%esp
80106859:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010685c:	39 da                	cmp    %ebx,%edx
8010685e:	73 5b                	jae    801068bb <deallocuvm.part.0+0x7b>
80106860:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106863:	89 d7                	mov    %edx,%edi
80106865:	eb 14                	jmp    8010687b <deallocuvm.part.0+0x3b>
80106867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010686e:	66 90                	xchg   %ax,%ax
80106870:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106876:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106879:	76 40                	jbe    801068bb <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010687b:	31 c9                	xor    %ecx,%ecx
8010687d:	89 fa                	mov    %edi,%edx
8010687f:	89 f0                	mov    %esi,%eax
80106881:	e8 aa fe ff ff       	call   80106730 <walkpgdir>
80106886:	89 c3                	mov    %eax,%ebx
    if(!pte)
80106888:	85 c0                	test   %eax,%eax
8010688a:	74 44                	je     801068d0 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
8010688c:	8b 00                	mov    (%eax),%eax
8010688e:	a8 01                	test   $0x1,%al
80106890:	74 de                	je     80106870 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106892:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106897:	74 47                	je     801068e0 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106899:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010689c:	05 00 00 00 80       	add    $0x80000000,%eax
801068a1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
801068a7:	50                   	push   %eax
801068a8:	e8 33 bb ff ff       	call   801023e0 <kfree>
      *pte = 0;
801068ad:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801068b3:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
801068b6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801068b9:	77 c0                	ja     8010687b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
801068bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801068be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068c1:	5b                   	pop    %ebx
801068c2:	5e                   	pop    %esi
801068c3:	5f                   	pop    %edi
801068c4:	5d                   	pop    %ebp
801068c5:	c3                   	ret    
801068c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068cd:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801068d0:	89 fa                	mov    %edi,%edx
801068d2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
801068d8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
801068de:	eb 96                	jmp    80106876 <deallocuvm.part.0+0x36>
        panic("kfree");
801068e0:	83 ec 0c             	sub    $0xc,%esp
801068e3:	68 a6 72 10 80       	push   $0x801072a6
801068e8:	e8 93 9a ff ff       	call   80100380 <panic>
801068ed:	8d 76 00             	lea    0x0(%esi),%esi

801068f0 <seginit>:
{
801068f0:	55                   	push   %ebp
801068f1:	89 e5                	mov    %esp,%ebp
801068f3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801068f6:	e8 65 cf ff ff       	call   80103860 <cpuid>
  pd[0] = size-1;
801068fb:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106900:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106906:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010690a:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106911:	ff 00 00 
80106914:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
8010691b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010691e:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106925:	ff 00 00 
80106928:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
8010692f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106932:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106939:	ff 00 00 
8010693c:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106943:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106946:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
8010694d:	ff 00 00 
80106950:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106957:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010695a:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
8010695f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106963:	c1 e8 10             	shr    $0x10,%eax
80106966:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010696a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010696d:	0f 01 10             	lgdtl  (%eax)
}
80106970:	c9                   	leave  
80106971:	c3                   	ret    
80106972:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106980 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106980:	a1 a4 55 11 80       	mov    0x801155a4,%eax
80106985:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010698a:	0f 22 d8             	mov    %eax,%cr3
}
8010698d:	c3                   	ret    
8010698e:	66 90                	xchg   %ax,%ax

80106990 <switchuvm>:
{
80106990:	55                   	push   %ebp
80106991:	89 e5                	mov    %esp,%ebp
80106993:	57                   	push   %edi
80106994:	56                   	push   %esi
80106995:	53                   	push   %ebx
80106996:	83 ec 1c             	sub    $0x1c,%esp
80106999:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010699c:	85 f6                	test   %esi,%esi
8010699e:	0f 84 cb 00 00 00    	je     80106a6f <switchuvm+0xdf>
  if(p->kstack == 0)
801069a4:	8b 46 08             	mov    0x8(%esi),%eax
801069a7:	85 c0                	test   %eax,%eax
801069a9:	0f 84 da 00 00 00    	je     80106a89 <switchuvm+0xf9>
  if(p->pgdir == 0)
801069af:	8b 46 04             	mov    0x4(%esi),%eax
801069b2:	85 c0                	test   %eax,%eax
801069b4:	0f 84 c2 00 00 00    	je     80106a7c <switchuvm+0xec>
  pushcli();
801069ba:	e8 b1 da ff ff       	call   80104470 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801069bf:	e8 2c ce ff ff       	call   801037f0 <mycpu>
801069c4:	89 c3                	mov    %eax,%ebx
801069c6:	e8 25 ce ff ff       	call   801037f0 <mycpu>
801069cb:	89 c7                	mov    %eax,%edi
801069cd:	e8 1e ce ff ff       	call   801037f0 <mycpu>
801069d2:	83 c7 08             	add    $0x8,%edi
801069d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801069d8:	e8 13 ce ff ff       	call   801037f0 <mycpu>
801069dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801069e0:	ba 67 00 00 00       	mov    $0x67,%edx
801069e5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801069ec:	83 c0 08             	add    $0x8,%eax
801069ef:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801069f6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801069fb:	83 c1 08             	add    $0x8,%ecx
801069fe:	c1 e8 18             	shr    $0x18,%eax
80106a01:	c1 e9 10             	shr    $0x10,%ecx
80106a04:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106a0a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106a10:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106a15:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106a1c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106a21:	e8 ca cd ff ff       	call   801037f0 <mycpu>
80106a26:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106a2d:	e8 be cd ff ff       	call   801037f0 <mycpu>
80106a32:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106a36:	8b 5e 08             	mov    0x8(%esi),%ebx
80106a39:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a3f:	e8 ac cd ff ff       	call   801037f0 <mycpu>
80106a44:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106a47:	e8 a4 cd ff ff       	call   801037f0 <mycpu>
80106a4c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106a50:	b8 28 00 00 00       	mov    $0x28,%eax
80106a55:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106a58:	8b 46 04             	mov    0x4(%esi),%eax
80106a5b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a60:	0f 22 d8             	mov    %eax,%cr3
}
80106a63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a66:	5b                   	pop    %ebx
80106a67:	5e                   	pop    %esi
80106a68:	5f                   	pop    %edi
80106a69:	5d                   	pop    %ebp
  popcli();
80106a6a:	e9 11 db ff ff       	jmp    80104580 <popcli>
    panic("switchuvm: no process");
80106a6f:	83 ec 0c             	sub    $0xc,%esp
80106a72:	68 76 79 10 80       	push   $0x80107976
80106a77:	e8 04 99 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106a7c:	83 ec 0c             	sub    $0xc,%esp
80106a7f:	68 a1 79 10 80       	push   $0x801079a1
80106a84:	e8 f7 98 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106a89:	83 ec 0c             	sub    $0xc,%esp
80106a8c:	68 8c 79 10 80       	push   $0x8010798c
80106a91:	e8 ea 98 ff ff       	call   80100380 <panic>
80106a96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a9d:	8d 76 00             	lea    0x0(%esi),%esi

80106aa0 <inituvm>:
{
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	57                   	push   %edi
80106aa4:	56                   	push   %esi
80106aa5:	53                   	push   %ebx
80106aa6:	83 ec 1c             	sub    $0x1c,%esp
80106aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106aac:	8b 75 10             	mov    0x10(%ebp),%esi
80106aaf:	8b 7d 08             	mov    0x8(%ebp),%edi
80106ab2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106ab5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106abb:	77 4b                	ja     80106b08 <inituvm+0x68>
  mem = kalloc();
80106abd:	e8 de ba ff ff       	call   801025a0 <kalloc>
  memset(mem, 0, PGSIZE);
80106ac2:	83 ec 04             	sub    $0x4,%esp
80106ac5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106aca:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106acc:	6a 00                	push   $0x0
80106ace:	50                   	push   %eax
80106acf:	e8 5c db ff ff       	call   80104630 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106ad4:	58                   	pop    %eax
80106ad5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106adb:	5a                   	pop    %edx
80106adc:	6a 06                	push   $0x6
80106ade:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ae3:	31 d2                	xor    %edx,%edx
80106ae5:	50                   	push   %eax
80106ae6:	89 f8                	mov    %edi,%eax
80106ae8:	e8 c3 fc ff ff       	call   801067b0 <mappages>
  memmove(mem, init, sz);
80106aed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106af0:	89 75 10             	mov    %esi,0x10(%ebp)
80106af3:	83 c4 10             	add    $0x10,%esp
80106af6:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106af9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106afc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106aff:	5b                   	pop    %ebx
80106b00:	5e                   	pop    %esi
80106b01:	5f                   	pop    %edi
80106b02:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106b03:	e9 c8 db ff ff       	jmp    801046d0 <memmove>
    panic("inituvm: more than a page");
80106b08:	83 ec 0c             	sub    $0xc,%esp
80106b0b:	68 b5 79 10 80       	push   $0x801079b5
80106b10:	e8 6b 98 ff ff       	call   80100380 <panic>
80106b15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b20 <loaduvm>:
{
80106b20:	55                   	push   %ebp
80106b21:	89 e5                	mov    %esp,%ebp
80106b23:	57                   	push   %edi
80106b24:	56                   	push   %esi
80106b25:	53                   	push   %ebx
80106b26:	83 ec 1c             	sub    $0x1c,%esp
80106b29:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b2c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106b2f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106b34:	0f 85 8d 00 00 00    	jne    80106bc7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106b3a:	01 f0                	add    %esi,%eax
80106b3c:	89 f3                	mov    %esi,%ebx
80106b3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b41:	8b 45 14             	mov    0x14(%ebp),%eax
80106b44:	01 f0                	add    %esi,%eax
80106b46:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106b49:	85 f6                	test   %esi,%esi
80106b4b:	75 11                	jne    80106b5e <loaduvm+0x3e>
80106b4d:	eb 61                	jmp    80106bb0 <loaduvm+0x90>
80106b4f:	90                   	nop
80106b50:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106b56:	89 f0                	mov    %esi,%eax
80106b58:	29 d8                	sub    %ebx,%eax
80106b5a:	39 c6                	cmp    %eax,%esi
80106b5c:	76 52                	jbe    80106bb0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106b5e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106b61:	8b 45 08             	mov    0x8(%ebp),%eax
80106b64:	31 c9                	xor    %ecx,%ecx
80106b66:	29 da                	sub    %ebx,%edx
80106b68:	e8 c3 fb ff ff       	call   80106730 <walkpgdir>
80106b6d:	85 c0                	test   %eax,%eax
80106b6f:	74 49                	je     80106bba <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106b71:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b73:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106b76:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106b7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106b80:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106b86:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b89:	29 d9                	sub    %ebx,%ecx
80106b8b:	05 00 00 00 80       	add    $0x80000000,%eax
80106b90:	57                   	push   %edi
80106b91:	51                   	push   %ecx
80106b92:	50                   	push   %eax
80106b93:	ff 75 10             	pushl  0x10(%ebp)
80106b96:	e8 65 ae ff ff       	call   80101a00 <readi>
80106b9b:	83 c4 10             	add    $0x10,%esp
80106b9e:	39 f8                	cmp    %edi,%eax
80106ba0:	74 ae                	je     80106b50 <loaduvm+0x30>
}
80106ba2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ba5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106baa:	5b                   	pop    %ebx
80106bab:	5e                   	pop    %esi
80106bac:	5f                   	pop    %edi
80106bad:	5d                   	pop    %ebp
80106bae:	c3                   	ret    
80106baf:	90                   	nop
80106bb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106bb3:	31 c0                	xor    %eax,%eax
}
80106bb5:	5b                   	pop    %ebx
80106bb6:	5e                   	pop    %esi
80106bb7:	5f                   	pop    %edi
80106bb8:	5d                   	pop    %ebp
80106bb9:	c3                   	ret    
      panic("loaduvm: address should exist");
80106bba:	83 ec 0c             	sub    $0xc,%esp
80106bbd:	68 cf 79 10 80       	push   $0x801079cf
80106bc2:	e8 b9 97 ff ff       	call   80100380 <panic>
    panic("loaduvm: addr must be page aligned");
80106bc7:	83 ec 0c             	sub    $0xc,%esp
80106bca:	68 70 7a 10 80       	push   $0x80107a70
80106bcf:	e8 ac 97 ff ff       	call   80100380 <panic>
80106bd4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106bdf:	90                   	nop

80106be0 <allocuvm>:
{
80106be0:	55                   	push   %ebp
80106be1:	89 e5                	mov    %esp,%ebp
80106be3:	57                   	push   %edi
80106be4:	56                   	push   %esi
80106be5:	53                   	push   %ebx
80106be6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106be9:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106bec:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106bef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106bf2:	85 c0                	test   %eax,%eax
80106bf4:	0f 88 b6 00 00 00    	js     80106cb0 <allocuvm+0xd0>
  if(newsz < oldsz)
80106bfa:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106c00:	0f 82 9a 00 00 00    	jb     80106ca0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106c06:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106c0c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106c12:	39 75 10             	cmp    %esi,0x10(%ebp)
80106c15:	77 44                	ja     80106c5b <allocuvm+0x7b>
80106c17:	e9 87 00 00 00       	jmp    80106ca3 <allocuvm+0xc3>
80106c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106c20:	83 ec 04             	sub    $0x4,%esp
80106c23:	68 00 10 00 00       	push   $0x1000
80106c28:	6a 00                	push   $0x0
80106c2a:	50                   	push   %eax
80106c2b:	e8 00 da ff ff       	call   80104630 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106c30:	58                   	pop    %eax
80106c31:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c37:	5a                   	pop    %edx
80106c38:	6a 06                	push   $0x6
80106c3a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c3f:	89 f2                	mov    %esi,%edx
80106c41:	50                   	push   %eax
80106c42:	89 f8                	mov    %edi,%eax
80106c44:	e8 67 fb ff ff       	call   801067b0 <mappages>
80106c49:	83 c4 10             	add    $0x10,%esp
80106c4c:	85 c0                	test   %eax,%eax
80106c4e:	78 78                	js     80106cc8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106c50:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106c56:	39 75 10             	cmp    %esi,0x10(%ebp)
80106c59:	76 48                	jbe    80106ca3 <allocuvm+0xc3>
    mem = kalloc();
80106c5b:	e8 40 b9 ff ff       	call   801025a0 <kalloc>
80106c60:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106c62:	85 c0                	test   %eax,%eax
80106c64:	75 ba                	jne    80106c20 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106c66:	83 ec 0c             	sub    $0xc,%esp
80106c69:	68 ed 79 10 80       	push   $0x801079ed
80106c6e:	e8 2d 9a ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106c73:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c76:	83 c4 10             	add    $0x10,%esp
80106c79:	39 45 10             	cmp    %eax,0x10(%ebp)
80106c7c:	74 32                	je     80106cb0 <allocuvm+0xd0>
80106c7e:	8b 55 10             	mov    0x10(%ebp),%edx
80106c81:	89 c1                	mov    %eax,%ecx
80106c83:	89 f8                	mov    %edi,%eax
80106c85:	e8 b6 fb ff ff       	call   80106840 <deallocuvm.part.0>
      return 0;
80106c8a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106c91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c97:	5b                   	pop    %ebx
80106c98:	5e                   	pop    %esi
80106c99:	5f                   	pop    %edi
80106c9a:	5d                   	pop    %ebp
80106c9b:	c3                   	ret    
80106c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106ca0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106ca3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ca6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ca9:	5b                   	pop    %ebx
80106caa:	5e                   	pop    %esi
80106cab:	5f                   	pop    %edi
80106cac:	5d                   	pop    %ebp
80106cad:	c3                   	ret    
80106cae:	66 90                	xchg   %ax,%ax
    return 0;
80106cb0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106cb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106cba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cbd:	5b                   	pop    %ebx
80106cbe:	5e                   	pop    %esi
80106cbf:	5f                   	pop    %edi
80106cc0:	5d                   	pop    %ebp
80106cc1:	c3                   	ret    
80106cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106cc8:	83 ec 0c             	sub    $0xc,%esp
80106ccb:	68 05 7a 10 80       	push   $0x80107a05
80106cd0:	e8 cb 99 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cd8:	83 c4 10             	add    $0x10,%esp
80106cdb:	39 45 10             	cmp    %eax,0x10(%ebp)
80106cde:	74 0c                	je     80106cec <allocuvm+0x10c>
80106ce0:	8b 55 10             	mov    0x10(%ebp),%edx
80106ce3:	89 c1                	mov    %eax,%ecx
80106ce5:	89 f8                	mov    %edi,%eax
80106ce7:	e8 54 fb ff ff       	call   80106840 <deallocuvm.part.0>
      kfree(mem);
80106cec:	83 ec 0c             	sub    $0xc,%esp
80106cef:	53                   	push   %ebx
80106cf0:	e8 eb b6 ff ff       	call   801023e0 <kfree>
      return 0;
80106cf5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106cfc:	83 c4 10             	add    $0x10,%esp
}
80106cff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d05:	5b                   	pop    %ebx
80106d06:	5e                   	pop    %esi
80106d07:	5f                   	pop    %edi
80106d08:	5d                   	pop    %ebp
80106d09:	c3                   	ret    
80106d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d10 <deallocuvm>:
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d16:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106d19:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106d1c:	39 d1                	cmp    %edx,%ecx
80106d1e:	73 10                	jae    80106d30 <deallocuvm+0x20>
}
80106d20:	5d                   	pop    %ebp
80106d21:	e9 1a fb ff ff       	jmp    80106840 <deallocuvm.part.0>
80106d26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d2d:	8d 76 00             	lea    0x0(%esi),%esi
80106d30:	89 d0                	mov    %edx,%eax
80106d32:	5d                   	pop    %ebp
80106d33:	c3                   	ret    
80106d34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d3f:	90                   	nop

80106d40 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	57                   	push   %edi
80106d44:	56                   	push   %esi
80106d45:	53                   	push   %ebx
80106d46:	83 ec 0c             	sub    $0xc,%esp
80106d49:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106d4c:	85 f6                	test   %esi,%esi
80106d4e:	74 59                	je     80106da9 <freevm+0x69>
  if(newsz >= oldsz)
80106d50:	31 c9                	xor    %ecx,%ecx
80106d52:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106d57:	89 f0                	mov    %esi,%eax
80106d59:	89 f3                	mov    %esi,%ebx
80106d5b:	e8 e0 fa ff ff       	call   80106840 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106d60:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106d66:	eb 0f                	jmp    80106d77 <freevm+0x37>
80106d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d6f:	90                   	nop
80106d70:	83 c3 04             	add    $0x4,%ebx
80106d73:	39 df                	cmp    %ebx,%edi
80106d75:	74 23                	je     80106d9a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106d77:	8b 03                	mov    (%ebx),%eax
80106d79:	a8 01                	test   $0x1,%al
80106d7b:	74 f3                	je     80106d70 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106d7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106d82:	83 ec 0c             	sub    $0xc,%esp
80106d85:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106d88:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106d8d:	50                   	push   %eax
80106d8e:	e8 4d b6 ff ff       	call   801023e0 <kfree>
80106d93:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106d96:	39 df                	cmp    %ebx,%edi
80106d98:	75 dd                	jne    80106d77 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106d9a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106d9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106da0:	5b                   	pop    %ebx
80106da1:	5e                   	pop    %esi
80106da2:	5f                   	pop    %edi
80106da3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106da4:	e9 37 b6 ff ff       	jmp    801023e0 <kfree>
    panic("freevm: no pgdir");
80106da9:	83 ec 0c             	sub    $0xc,%esp
80106dac:	68 21 7a 10 80       	push   $0x80107a21
80106db1:	e8 ca 95 ff ff       	call   80100380 <panic>
80106db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dbd:	8d 76 00             	lea    0x0(%esi),%esi

80106dc0 <setupkvm>:
{
80106dc0:	55                   	push   %ebp
80106dc1:	89 e5                	mov    %esp,%ebp
80106dc3:	56                   	push   %esi
80106dc4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106dc5:	e8 d6 b7 ff ff       	call   801025a0 <kalloc>
80106dca:	89 c6                	mov    %eax,%esi
80106dcc:	85 c0                	test   %eax,%eax
80106dce:	74 42                	je     80106e12 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106dd0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106dd3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106dd8:	68 00 10 00 00       	push   $0x1000
80106ddd:	6a 00                	push   $0x0
80106ddf:	50                   	push   %eax
80106de0:	e8 4b d8 ff ff       	call   80104630 <memset>
80106de5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106de8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106deb:	83 ec 08             	sub    $0x8,%esp
80106dee:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106df1:	ff 73 0c             	pushl  0xc(%ebx)
80106df4:	8b 13                	mov    (%ebx),%edx
80106df6:	50                   	push   %eax
80106df7:	29 c1                	sub    %eax,%ecx
80106df9:	89 f0                	mov    %esi,%eax
80106dfb:	e8 b0 f9 ff ff       	call   801067b0 <mappages>
80106e00:	83 c4 10             	add    $0x10,%esp
80106e03:	85 c0                	test   %eax,%eax
80106e05:	78 19                	js     80106e20 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106e07:	83 c3 10             	add    $0x10,%ebx
80106e0a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106e10:	75 d6                	jne    80106de8 <setupkvm+0x28>
}
80106e12:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106e15:	89 f0                	mov    %esi,%eax
80106e17:	5b                   	pop    %ebx
80106e18:	5e                   	pop    %esi
80106e19:	5d                   	pop    %ebp
80106e1a:	c3                   	ret    
80106e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e1f:	90                   	nop
      freevm(pgdir);
80106e20:	83 ec 0c             	sub    $0xc,%esp
80106e23:	56                   	push   %esi
      return 0;
80106e24:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106e26:	e8 15 ff ff ff       	call   80106d40 <freevm>
      return 0;
80106e2b:	83 c4 10             	add    $0x10,%esp
}
80106e2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106e31:	89 f0                	mov    %esi,%eax
80106e33:	5b                   	pop    %ebx
80106e34:	5e                   	pop    %esi
80106e35:	5d                   	pop    %ebp
80106e36:	c3                   	ret    
80106e37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e3e:	66 90                	xchg   %ax,%ax

80106e40 <kvmalloc>:
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106e46:	e8 75 ff ff ff       	call   80106dc0 <setupkvm>
80106e4b:	a3 a4 55 11 80       	mov    %eax,0x801155a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e50:	05 00 00 00 80       	add    $0x80000000,%eax
80106e55:	0f 22 d8             	mov    %eax,%cr3
}
80106e58:	c9                   	leave  
80106e59:	c3                   	ret    
80106e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e60 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106e60:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e61:	31 c9                	xor    %ecx,%ecx
{
80106e63:	89 e5                	mov    %esp,%ebp
80106e65:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106e68:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e6b:	8b 45 08             	mov    0x8(%ebp),%eax
80106e6e:	e8 bd f8 ff ff       	call   80106730 <walkpgdir>
  if(pte == 0)
80106e73:	85 c0                	test   %eax,%eax
80106e75:	74 05                	je     80106e7c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106e77:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106e7a:	c9                   	leave  
80106e7b:	c3                   	ret    
    panic("clearpteu");
80106e7c:	83 ec 0c             	sub    $0xc,%esp
80106e7f:	68 32 7a 10 80       	push   $0x80107a32
80106e84:	e8 f7 94 ff ff       	call   80100380 <panic>
80106e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e90 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	57                   	push   %edi
80106e94:	56                   	push   %esi
80106e95:	53                   	push   %ebx
80106e96:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106e99:	e8 22 ff ff ff       	call   80106dc0 <setupkvm>
80106e9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106ea1:	85 c0                	test   %eax,%eax
80106ea3:	0f 84 a0 00 00 00    	je     80106f49 <copyuvm+0xb9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106ea9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106eac:	85 c9                	test   %ecx,%ecx
80106eae:	0f 84 95 00 00 00    	je     80106f49 <copyuvm+0xb9>
80106eb4:	31 f6                	xor    %esi,%esi
80106eb6:	eb 4e                	jmp    80106f06 <copyuvm+0x76>
80106eb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ebf:	90                   	nop
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106ec0:	83 ec 04             	sub    $0x4,%esp
80106ec3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106ec9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ecc:	68 00 10 00 00       	push   $0x1000
80106ed1:	57                   	push   %edi
80106ed2:	50                   	push   %eax
80106ed3:	e8 f8 d7 ff ff       	call   801046d0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106ed8:	58                   	pop    %eax
80106ed9:	5a                   	pop    %edx
80106eda:	53                   	push   %ebx
80106edb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106ede:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ee1:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ee6:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106eec:	52                   	push   %edx
80106eed:	89 f2                	mov    %esi,%edx
80106eef:	e8 bc f8 ff ff       	call   801067b0 <mappages>
80106ef4:	83 c4 10             	add    $0x10,%esp
80106ef7:	85 c0                	test   %eax,%eax
80106ef9:	78 39                	js     80106f34 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
80106efb:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106f01:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106f04:	76 43                	jbe    80106f49 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106f06:	8b 45 08             	mov    0x8(%ebp),%eax
80106f09:	31 c9                	xor    %ecx,%ecx
80106f0b:	89 f2                	mov    %esi,%edx
80106f0d:	e8 1e f8 ff ff       	call   80106730 <walkpgdir>
80106f12:	85 c0                	test   %eax,%eax
80106f14:	74 3e                	je     80106f54 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80106f16:	8b 18                	mov    (%eax),%ebx
80106f18:	f6 c3 01             	test   $0x1,%bl
80106f1b:	74 44                	je     80106f61 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
80106f1d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80106f1f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80106f25:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80106f2b:	e8 70 b6 ff ff       	call   801025a0 <kalloc>
80106f30:	85 c0                	test   %eax,%eax
80106f32:	75 8c                	jne    80106ec0 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106f34:	83 ec 0c             	sub    $0xc,%esp
80106f37:	ff 75 e0             	pushl  -0x20(%ebp)
80106f3a:	e8 01 fe ff ff       	call   80106d40 <freevm>
  return 0;
80106f3f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80106f46:	83 c4 10             	add    $0x10,%esp
}
80106f49:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f4f:	5b                   	pop    %ebx
80106f50:	5e                   	pop    %esi
80106f51:	5f                   	pop    %edi
80106f52:	5d                   	pop    %ebp
80106f53:	c3                   	ret    
      panic("copyuvm: pte should exist");
80106f54:	83 ec 0c             	sub    $0xc,%esp
80106f57:	68 3c 7a 10 80       	push   $0x80107a3c
80106f5c:	e8 1f 94 ff ff       	call   80100380 <panic>
      panic("copyuvm: page not present");
80106f61:	83 ec 0c             	sub    $0xc,%esp
80106f64:	68 56 7a 10 80       	push   $0x80107a56
80106f69:	e8 12 94 ff ff       	call   80100380 <panic>
80106f6e:	66 90                	xchg   %ax,%ax

80106f70 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106f70:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f71:	31 c9                	xor    %ecx,%ecx
{
80106f73:	89 e5                	mov    %esp,%ebp
80106f75:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106f78:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f7b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f7e:	e8 ad f7 ff ff       	call   80106730 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106f83:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80106f85:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80106f86:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106f88:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80106f8d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106f90:	05 00 00 00 80       	add    $0x80000000,%eax
80106f95:	83 fa 05             	cmp    $0x5,%edx
80106f98:	ba 00 00 00 00       	mov    $0x0,%edx
80106f9d:	0f 45 c2             	cmovne %edx,%eax
}
80106fa0:	c3                   	ret    
80106fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106faf:	90                   	nop

80106fb0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106fb0:	55                   	push   %ebp
80106fb1:	89 e5                	mov    %esp,%ebp
80106fb3:	57                   	push   %edi
80106fb4:	56                   	push   %esi
80106fb5:	53                   	push   %ebx
80106fb6:	83 ec 0c             	sub    $0xc,%esp
80106fb9:	8b 75 14             	mov    0x14(%ebp),%esi
80106fbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106fbf:	85 f6                	test   %esi,%esi
80106fc1:	75 38                	jne    80106ffb <copyout+0x4b>
80106fc3:	eb 6b                	jmp    80107030 <copyout+0x80>
80106fc5:	8d 76 00             	lea    0x0(%esi),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fcb:	89 fb                	mov    %edi,%ebx
80106fcd:	29 d3                	sub    %edx,%ebx
80106fcf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80106fd5:	39 f3                	cmp    %esi,%ebx
80106fd7:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106fda:	29 fa                	sub    %edi,%edx
80106fdc:	83 ec 04             	sub    $0x4,%esp
80106fdf:	01 c2                	add    %eax,%edx
80106fe1:	53                   	push   %ebx
80106fe2:	ff 75 10             	pushl  0x10(%ebp)
80106fe5:	52                   	push   %edx
80106fe6:	e8 e5 d6 ff ff       	call   801046d0 <memmove>
    len -= n;
    buf += n;
80106feb:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80106fee:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80106ff4:	83 c4 10             	add    $0x10,%esp
80106ff7:	29 de                	sub    %ebx,%esi
80106ff9:	74 35                	je     80107030 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80106ffb:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80106ffd:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107000:	89 55 0c             	mov    %edx,0xc(%ebp)
80107003:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107009:	57                   	push   %edi
8010700a:	ff 75 08             	pushl  0x8(%ebp)
8010700d:	e8 5e ff ff ff       	call   80106f70 <uva2ka>
    if(pa0 == 0)
80107012:	83 c4 10             	add    $0x10,%esp
80107015:	85 c0                	test   %eax,%eax
80107017:	75 af                	jne    80106fc8 <copyout+0x18>
  }
  return 0;
}
80107019:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010701c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107021:	5b                   	pop    %ebx
80107022:	5e                   	pop    %esi
80107023:	5f                   	pop    %edi
80107024:	5d                   	pop    %ebp
80107025:	c3                   	ret    
80107026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010702d:	8d 76 00             	lea    0x0(%esi),%esi
80107030:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107033:	31 c0                	xor    %eax,%eax
}
80107035:	5b                   	pop    %ebx
80107036:	5e                   	pop    %esi
80107037:	5f                   	pop    %edi
80107038:	5d                   	pop    %ebp
80107039:	c3                   	ret    
