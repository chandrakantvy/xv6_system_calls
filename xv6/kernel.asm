
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
80100028:	bc 20 f7 10 80       	mov    $0x8010f720,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 52 2b 10 80       	mov    $0x80102b52,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	57                   	push   %edi
80100038:	56                   	push   %esi
80100039:	53                   	push   %ebx
8010003a:	83 ec 18             	sub    $0x18,%esp
8010003d:	89 c6                	mov    %eax,%esi
8010003f:	89 d7                	mov    %edx,%edi
  struct buf *b;

  acquire(&bcache.lock);
80100041:	68 20 f7 10 80       	push   $0x8010f720
80100046:	e8 5a 3f 00 00       	call   80103fa5 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010004b:	8b 1d 70 3e 11 80    	mov    0x80113e70,%ebx
80100051:	83 c4 10             	add    $0x10,%esp
80100054:	eb 03                	jmp    80100059 <bget+0x25>
80100056:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100059:	81 fb 1c 3e 11 80    	cmp    $0x80113e1c,%ebx
8010005f:	74 30                	je     80100091 <bget+0x5d>
    if(b->dev == dev && b->blockno == blockno){
80100061:	39 73 04             	cmp    %esi,0x4(%ebx)
80100064:	75 f0                	jne    80100056 <bget+0x22>
80100066:	39 7b 08             	cmp    %edi,0x8(%ebx)
80100069:	75 eb                	jne    80100056 <bget+0x22>
      b->refcnt++;
8010006b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010006e:	83 c0 01             	add    $0x1,%eax
80100071:	89 43 4c             	mov    %eax,0x4c(%ebx)
      release(&bcache.lock);
80100074:	83 ec 0c             	sub    $0xc,%esp
80100077:	68 20 f7 10 80       	push   $0x8010f720
8010007c:	e8 8d 3f 00 00       	call   8010400e <release>
      acquiresleep(&b->lock);
80100081:	8d 43 0c             	lea    0xc(%ebx),%eax
80100084:	89 04 24             	mov    %eax,(%esp)
80100087:	e8 0c 3d 00 00       	call   80103d98 <acquiresleep>
      return b;
8010008c:	83 c4 10             	add    $0x10,%esp
8010008f:	eb 4c                	jmp    801000dd <bget+0xa9>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100091:	8b 1d 6c 3e 11 80    	mov    0x80113e6c,%ebx
80100097:	eb 03                	jmp    8010009c <bget+0x68>
80100099:	8b 5b 50             	mov    0x50(%ebx),%ebx
8010009c:	81 fb 1c 3e 11 80    	cmp    $0x80113e1c,%ebx
801000a2:	74 43                	je     801000e7 <bget+0xb3>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
801000a4:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801000a8:	75 ef                	jne    80100099 <bget+0x65>
801000aa:	f6 03 04             	testb  $0x4,(%ebx)
801000ad:	75 ea                	jne    80100099 <bget+0x65>
      b->dev = dev;
801000af:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
801000b2:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
801000b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
801000bb:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
801000c2:	83 ec 0c             	sub    $0xc,%esp
801000c5:	68 20 f7 10 80       	push   $0x8010f720
801000ca:	e8 3f 3f 00 00       	call   8010400e <release>
      acquiresleep(&b->lock);
801000cf:	8d 43 0c             	lea    0xc(%ebx),%eax
801000d2:	89 04 24             	mov    %eax,(%esp)
801000d5:	e8 be 3c 00 00       	call   80103d98 <acquiresleep>
      return b;
801000da:	83 c4 10             	add    $0x10,%esp
    }
  }
  panic("bget: no buffers");
}
801000dd:	89 d8                	mov    %ebx,%eax
801000df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801000e2:	5b                   	pop    %ebx
801000e3:	5e                   	pop    %esi
801000e4:	5f                   	pop    %edi
801000e5:	5d                   	pop    %ebp
801000e6:	c3                   	ret    
  panic("bget: no buffers");
801000e7:	83 ec 0c             	sub    $0xc,%esp
801000ea:	68 40 6a 10 80       	push   $0x80106a40
801000ef:	e8 68 02 00 00       	call   8010035c <panic>

801000f4 <binit>:
{
801000f4:	f3 0f 1e fb          	endbr32 
801000f8:	55                   	push   %ebp
801000f9:	89 e5                	mov    %esp,%ebp
801000fb:	53                   	push   %ebx
801000fc:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
801000ff:	68 51 6a 10 80       	push   $0x80106a51
80100104:	68 20 f7 10 80       	push   $0x8010f720
80100109:	e8 47 3d 00 00       	call   80103e55 <initlock>
  bcache.head.prev = &bcache.head;
8010010e:	c7 05 6c 3e 11 80 1c 	movl   $0x80113e1c,0x80113e6c
80100115:	3e 11 80 
  bcache.head.next = &bcache.head;
80100118:	c7 05 70 3e 11 80 1c 	movl   $0x80113e1c,0x80113e70
8010011f:	3e 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100122:	83 c4 10             	add    $0x10,%esp
80100125:	bb 54 f7 10 80       	mov    $0x8010f754,%ebx
8010012a:	eb 37                	jmp    80100163 <binit+0x6f>
    b->next = bcache.head.next;
8010012c:	a1 70 3e 11 80       	mov    0x80113e70,%eax
80100131:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
80100134:	c7 43 50 1c 3e 11 80 	movl   $0x80113e1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
8010013b:	83 ec 08             	sub    $0x8,%esp
8010013e:	68 58 6a 10 80       	push   $0x80106a58
80100143:	8d 43 0c             	lea    0xc(%ebx),%eax
80100146:	50                   	push   %eax
80100147:	e8 15 3c 00 00       	call   80103d61 <initsleeplock>
    bcache.head.next->prev = b;
8010014c:	a1 70 3e 11 80       	mov    0x80113e70,%eax
80100151:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100154:	89 1d 70 3e 11 80    	mov    %ebx,0x80113e70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010015a:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
80100160:	83 c4 10             	add    $0x10,%esp
80100163:	81 fb 1c 3e 11 80    	cmp    $0x80113e1c,%ebx
80100169:	72 c1                	jb     8010012c <binit+0x38>
}
8010016b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010016e:	c9                   	leave  
8010016f:	c3                   	ret    

80100170 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
80100170:	f3 0f 1e fb          	endbr32 
80100174:	55                   	push   %ebp
80100175:	89 e5                	mov    %esp,%ebp
80100177:	53                   	push   %ebx
80100178:	83 ec 04             	sub    $0x4,%esp
  struct buf *b;

  b = bget(dev, blockno);
8010017b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010017e:	8b 45 08             	mov    0x8(%ebp),%eax
80100181:	e8 ae fe ff ff       	call   80100034 <bget>
80100186:	89 c3                	mov    %eax,%ebx
  if((b->flags & B_VALID) == 0) {
80100188:	f6 00 02             	testb  $0x2,(%eax)
8010018b:	74 07                	je     80100194 <bread+0x24>
    iderw(b);
  }
  return b;
}
8010018d:	89 d8                	mov    %ebx,%eax
8010018f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100192:	c9                   	leave  
80100193:	c3                   	ret    
    iderw(b);
80100194:	83 ec 0c             	sub    $0xc,%esp
80100197:	50                   	push   %eax
80100198:	e8 29 1d 00 00       	call   80101ec6 <iderw>
8010019d:	83 c4 10             	add    $0x10,%esp
  return b;
801001a0:	eb eb                	jmp    8010018d <bread+0x1d>

801001a2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a2:	f3 0f 1e fb          	endbr32 
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	53                   	push   %ebx
801001aa:	83 ec 10             	sub    $0x10,%esp
801001ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001b0:	8d 43 0c             	lea    0xc(%ebx),%eax
801001b3:	50                   	push   %eax
801001b4:	e8 71 3c 00 00       	call   80103e2a <holdingsleep>
801001b9:	83 c4 10             	add    $0x10,%esp
801001bc:	85 c0                	test   %eax,%eax
801001be:	74 14                	je     801001d4 <bwrite+0x32>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001c0:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001c3:	83 ec 0c             	sub    $0xc,%esp
801001c6:	53                   	push   %ebx
801001c7:	e8 fa 1c 00 00       	call   80101ec6 <iderw>
}
801001cc:	83 c4 10             	add    $0x10,%esp
801001cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d2:	c9                   	leave  
801001d3:	c3                   	ret    
    panic("bwrite");
801001d4:	83 ec 0c             	sub    $0xc,%esp
801001d7:	68 5f 6a 10 80       	push   $0x80106a5f
801001dc:	e8 7b 01 00 00       	call   8010035c <panic>

801001e1 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e1:	f3 0f 1e fb          	endbr32 
801001e5:	55                   	push   %ebp
801001e6:	89 e5                	mov    %esp,%ebp
801001e8:	56                   	push   %esi
801001e9:	53                   	push   %ebx
801001ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ed:	8d 73 0c             	lea    0xc(%ebx),%esi
801001f0:	83 ec 0c             	sub    $0xc,%esp
801001f3:	56                   	push   %esi
801001f4:	e8 31 3c 00 00       	call   80103e2a <holdingsleep>
801001f9:	83 c4 10             	add    $0x10,%esp
801001fc:	85 c0                	test   %eax,%eax
801001fe:	74 6b                	je     8010026b <brelse+0x8a>
    panic("brelse");

  releasesleep(&b->lock);
80100200:	83 ec 0c             	sub    $0xc,%esp
80100203:	56                   	push   %esi
80100204:	e8 e2 3b 00 00       	call   80103deb <releasesleep>

  acquire(&bcache.lock);
80100209:	c7 04 24 20 f7 10 80 	movl   $0x8010f720,(%esp)
80100210:	e8 90 3d 00 00       	call   80103fa5 <acquire>
  b->refcnt--;
80100215:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100218:	83 e8 01             	sub    $0x1,%eax
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	83 c4 10             	add    $0x10,%esp
80100221:	85 c0                	test   %eax,%eax
80100223:	75 2f                	jne    80100254 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100225:	8b 43 54             	mov    0x54(%ebx),%eax
80100228:	8b 53 50             	mov    0x50(%ebx),%edx
8010022b:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010022e:	8b 43 50             	mov    0x50(%ebx),%eax
80100231:	8b 53 54             	mov    0x54(%ebx),%edx
80100234:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100237:	a1 70 3e 11 80       	mov    0x80113e70,%eax
8010023c:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010023f:	c7 43 50 1c 3e 11 80 	movl   $0x80113e1c,0x50(%ebx)
    bcache.head.next->prev = b;
80100246:	a1 70 3e 11 80       	mov    0x80113e70,%eax
8010024b:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010024e:	89 1d 70 3e 11 80    	mov    %ebx,0x80113e70
  }
  
  release(&bcache.lock);
80100254:	83 ec 0c             	sub    $0xc,%esp
80100257:	68 20 f7 10 80       	push   $0x8010f720
8010025c:	e8 ad 3d 00 00       	call   8010400e <release>
}
80100261:	83 c4 10             	add    $0x10,%esp
80100264:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100267:	5b                   	pop    %ebx
80100268:	5e                   	pop    %esi
80100269:	5d                   	pop    %ebp
8010026a:	c3                   	ret    
    panic("brelse");
8010026b:	83 ec 0c             	sub    $0xc,%esp
8010026e:	68 66 6a 10 80       	push   $0x80106a66
80100273:	e8 e4 00 00 00       	call   8010035c <panic>

80100278 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100278:	f3 0f 1e fb          	endbr32 
8010027c:	55                   	push   %ebp
8010027d:	89 e5                	mov    %esp,%ebp
8010027f:	57                   	push   %edi
80100280:	56                   	push   %esi
80100281:	53                   	push   %ebx
80100282:	83 ec 28             	sub    $0x28,%esp
80100285:	8b 7d 08             	mov    0x8(%ebp),%edi
80100288:	8b 75 0c             	mov    0xc(%ebp),%esi
8010028b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
8010028e:	57                   	push   %edi
8010028f:	e8 39 14 00 00       	call   801016cd <iunlock>
  target = n;
80100294:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&cons.lock);
80100297:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010029e:	e8 02 3d 00 00       	call   80103fa5 <acquire>
  while(n > 0){
801002a3:	83 c4 10             	add    $0x10,%esp
801002a6:	85 db                	test   %ebx,%ebx
801002a8:	0f 8e 8f 00 00 00    	jle    8010033d <consoleread+0xc5>
    while(input.r == input.w){
801002ae:	a1 00 41 11 80       	mov    0x80114100,%eax
801002b3:	3b 05 04 41 11 80    	cmp    0x80114104,%eax
801002b9:	75 47                	jne    80100302 <consoleread+0x8a>
      if(myproc()->killed){
801002bb:	e8 7b 30 00 00       	call   8010333b <myproc>
801002c0:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801002c4:	75 17                	jne    801002dd <consoleread+0x65>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c6:	83 ec 08             	sub    $0x8,%esp
801002c9:	68 20 a5 10 80       	push   $0x8010a520
801002ce:	68 00 41 11 80       	push   $0x80114100
801002d3:	e8 4f 35 00 00       	call   80103827 <sleep>
801002d8:	83 c4 10             	add    $0x10,%esp
801002db:	eb d1                	jmp    801002ae <consoleread+0x36>
        release(&cons.lock);
801002dd:	83 ec 0c             	sub    $0xc,%esp
801002e0:	68 20 a5 10 80       	push   $0x8010a520
801002e5:	e8 24 3d 00 00       	call   8010400e <release>
        ilock(ip);
801002ea:	89 3c 24             	mov    %edi,(%esp)
801002ed:	e8 15 13 00 00       	call   80101607 <ilock>
        return -1;
801002f2:	83 c4 10             	add    $0x10,%esp
801002f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fd:	5b                   	pop    %ebx
801002fe:	5e                   	pop    %esi
801002ff:	5f                   	pop    %edi
80100300:	5d                   	pop    %ebp
80100301:	c3                   	ret    
    c = input.buf[input.r++ % INPUT_BUF];
80100302:	8d 50 01             	lea    0x1(%eax),%edx
80100305:	89 15 00 41 11 80    	mov    %edx,0x80114100
8010030b:	89 c2                	mov    %eax,%edx
8010030d:	83 e2 7f             	and    $0x7f,%edx
80100310:	0f b6 92 80 40 11 80 	movzbl -0x7feebf80(%edx),%edx
80100317:	0f be ca             	movsbl %dl,%ecx
    if(c == C('D')){  // EOF
8010031a:	80 fa 04             	cmp    $0x4,%dl
8010031d:	74 14                	je     80100333 <consoleread+0xbb>
    *dst++ = c;
8010031f:	8d 46 01             	lea    0x1(%esi),%eax
80100322:	88 16                	mov    %dl,(%esi)
    --n;
80100324:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100327:	83 f9 0a             	cmp    $0xa,%ecx
8010032a:	74 11                	je     8010033d <consoleread+0xc5>
    *dst++ = c;
8010032c:	89 c6                	mov    %eax,%esi
8010032e:	e9 73 ff ff ff       	jmp    801002a6 <consoleread+0x2e>
      if(n < target){
80100333:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80100336:	73 05                	jae    8010033d <consoleread+0xc5>
        input.r--;
80100338:	a3 00 41 11 80       	mov    %eax,0x80114100
  release(&cons.lock);
8010033d:	83 ec 0c             	sub    $0xc,%esp
80100340:	68 20 a5 10 80       	push   $0x8010a520
80100345:	e8 c4 3c 00 00       	call   8010400e <release>
  ilock(ip);
8010034a:	89 3c 24             	mov    %edi,(%esp)
8010034d:	e8 b5 12 00 00       	call   80101607 <ilock>
  return target - n;
80100352:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100355:	29 d8                	sub    %ebx,%eax
80100357:	83 c4 10             	add    $0x10,%esp
8010035a:	eb 9e                	jmp    801002fa <consoleread+0x82>

8010035c <panic>:
{
8010035c:	f3 0f 1e fb          	endbr32 
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	53                   	push   %ebx
80100364:	83 ec 34             	sub    $0x34,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100367:	fa                   	cli    
  cons.locking = 0;
80100368:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
8010036f:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
80100372:	e8 df 20 00 00       	call   80102456 <lapicid>
80100377:	83 ec 08             	sub    $0x8,%esp
8010037a:	50                   	push   %eax
8010037b:	68 6d 6a 10 80       	push   $0x80106a6d
80100380:	e8 a4 02 00 00       	call   80100629 <cprintf>
  cprintf(s);
80100385:	83 c4 04             	add    $0x4,%esp
80100388:	ff 75 08             	pushl  0x8(%ebp)
8010038b:	e8 99 02 00 00       	call   80100629 <cprintf>
  cprintf("\n");
80100390:	c7 04 24 17 74 10 80 	movl   $0x80107417,(%esp)
80100397:	e8 8d 02 00 00       	call   80100629 <cprintf>
  getcallerpcs(&s, pcs);
8010039c:	83 c4 08             	add    $0x8,%esp
8010039f:	8d 45 d0             	lea    -0x30(%ebp),%eax
801003a2:	50                   	push   %eax
801003a3:	8d 45 08             	lea    0x8(%ebp),%eax
801003a6:	50                   	push   %eax
801003a7:	e8 c8 3a 00 00       	call   80103e74 <getcallerpcs>
  for(i=0; i<10; i++)
801003ac:	83 c4 10             	add    $0x10,%esp
801003af:	bb 00 00 00 00       	mov    $0x0,%ebx
801003b4:	eb 17                	jmp    801003cd <panic+0x71>
    cprintf(" %p", pcs[i]);
801003b6:	83 ec 08             	sub    $0x8,%esp
801003b9:	ff 74 9d d0          	pushl  -0x30(%ebp,%ebx,4)
801003bd:	68 81 6a 10 80       	push   $0x80106a81
801003c2:	e8 62 02 00 00       	call   80100629 <cprintf>
  for(i=0; i<10; i++)
801003c7:	83 c3 01             	add    $0x1,%ebx
801003ca:	83 c4 10             	add    $0x10,%esp
801003cd:	83 fb 09             	cmp    $0x9,%ebx
801003d0:	7e e4                	jle    801003b6 <panic+0x5a>
  panicked = 1; // freeze other CPU
801003d2:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d9:	00 00 00 
  for(;;)
801003dc:	eb fe                	jmp    801003dc <panic+0x80>

801003de <cgaputc>:
{
801003de:	55                   	push   %ebp
801003df:	89 e5                	mov    %esp,%ebp
801003e1:	57                   	push   %edi
801003e2:	56                   	push   %esi
801003e3:	53                   	push   %ebx
801003e4:	83 ec 0c             	sub    $0xc,%esp
801003e7:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003e9:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
801003ee:	b8 0e 00 00 00       	mov    $0xe,%eax
801003f3:	89 ca                	mov    %ecx,%edx
801003f5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003f6:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801003fb:	89 da                	mov    %ebx,%edx
801003fd:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003fe:	0f b6 f8             	movzbl %al,%edi
80100401:	c1 e7 08             	shl    $0x8,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100404:	b8 0f 00 00 00       	mov    $0xf,%eax
80100409:	89 ca                	mov    %ecx,%edx
8010040b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010040c:	89 da                	mov    %ebx,%edx
8010040e:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010040f:	0f b6 c8             	movzbl %al,%ecx
80100412:	09 f9                	or     %edi,%ecx
  if(c == '\n')
80100414:	83 fe 0a             	cmp    $0xa,%esi
80100417:	74 66                	je     8010047f <cgaputc+0xa1>
  else if(c == BACKSPACE){
80100419:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010041f:	74 7f                	je     801004a0 <cgaputc+0xc2>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100421:	89 f0                	mov    %esi,%eax
80100423:	0f b6 f0             	movzbl %al,%esi
80100426:	8d 59 01             	lea    0x1(%ecx),%ebx
80100429:	66 81 ce 00 07       	or     $0x700,%si
8010042e:	66 89 b4 09 00 80 0b 	mov    %si,-0x7ff48000(%ecx,%ecx,1)
80100435:	80 
  if(pos < 0 || pos > 25*80)
80100436:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010043c:	77 6f                	ja     801004ad <cgaputc+0xcf>
  if((pos/80) >= 24){  // Scroll up.
8010043e:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100444:	7f 74                	jg     801004ba <cgaputc+0xdc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100446:	be d4 03 00 00       	mov    $0x3d4,%esi
8010044b:	b8 0e 00 00 00       	mov    $0xe,%eax
80100450:	89 f2                	mov    %esi,%edx
80100452:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80100453:	89 d8                	mov    %ebx,%eax
80100455:	c1 f8 08             	sar    $0x8,%eax
80100458:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010045d:	89 ca                	mov    %ecx,%edx
8010045f:	ee                   	out    %al,(%dx)
80100460:	b8 0f 00 00 00       	mov    $0xf,%eax
80100465:	89 f2                	mov    %esi,%edx
80100467:	ee                   	out    %al,(%dx)
80100468:	89 d8                	mov    %ebx,%eax
8010046a:	89 ca                	mov    %ecx,%edx
8010046c:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
8010046d:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
80100474:	80 20 07 
}
80100477:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010047a:	5b                   	pop    %ebx
8010047b:	5e                   	pop    %esi
8010047c:	5f                   	pop    %edi
8010047d:	5d                   	pop    %ebp
8010047e:	c3                   	ret    
    pos += 80 - pos%80;
8010047f:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100484:	89 c8                	mov    %ecx,%eax
80100486:	f7 ea                	imul   %edx
80100488:	c1 fa 05             	sar    $0x5,%edx
8010048b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010048e:	c1 e0 04             	shl    $0x4,%eax
80100491:	89 ca                	mov    %ecx,%edx
80100493:	29 c2                	sub    %eax,%edx
80100495:	bb 50 00 00 00       	mov    $0x50,%ebx
8010049a:	29 d3                	sub    %edx,%ebx
8010049c:	01 cb                	add    %ecx,%ebx
8010049e:	eb 96                	jmp    80100436 <cgaputc+0x58>
    if(pos > 0) --pos;
801004a0:	85 c9                	test   %ecx,%ecx
801004a2:	7e 05                	jle    801004a9 <cgaputc+0xcb>
801004a4:	8d 59 ff             	lea    -0x1(%ecx),%ebx
801004a7:	eb 8d                	jmp    80100436 <cgaputc+0x58>
  pos |= inb(CRTPORT+1);
801004a9:	89 cb                	mov    %ecx,%ebx
801004ab:	eb 89                	jmp    80100436 <cgaputc+0x58>
    panic("pos under/overflow");
801004ad:	83 ec 0c             	sub    $0xc,%esp
801004b0:	68 85 6a 10 80       	push   $0x80106a85
801004b5:	e8 a2 fe ff ff       	call   8010035c <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004ba:	83 ec 04             	sub    $0x4,%esp
801004bd:	68 60 0e 00 00       	push   $0xe60
801004c2:	68 a0 80 0b 80       	push   $0x800b80a0
801004c7:	68 00 80 0b 80       	push   $0x800b8000
801004cc:	e8 08 3c 00 00       	call   801040d9 <memmove>
    pos -= 80;
801004d1:	83 eb 50             	sub    $0x50,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004d4:	b8 80 07 00 00       	mov    $0x780,%eax
801004d9:	29 d8                	sub    %ebx,%eax
801004db:	8d 94 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%edx
801004e2:	83 c4 0c             	add    $0xc,%esp
801004e5:	01 c0                	add    %eax,%eax
801004e7:	50                   	push   %eax
801004e8:	6a 00                	push   $0x0
801004ea:	52                   	push   %edx
801004eb:	e8 69 3b 00 00       	call   80104059 <memset>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 4e ff ff ff       	jmp    80100446 <cgaputc+0x68>

801004f8 <consputc>:
  if(panicked){
801004f8:	83 3d 58 a5 10 80 00 	cmpl   $0x0,0x8010a558
801004ff:	74 03                	je     80100504 <consputc+0xc>
  asm volatile("cli");
80100501:	fa                   	cli    
    for(;;)
80100502:	eb fe                	jmp    80100502 <consputc+0xa>
{
80100504:	55                   	push   %ebp
80100505:	89 e5                	mov    %esp,%ebp
80100507:	53                   	push   %ebx
80100508:	83 ec 04             	sub    $0x4,%esp
8010050b:	89 c3                	mov    %eax,%ebx
  if(c == BACKSPACE){
8010050d:	3d 00 01 00 00       	cmp    $0x100,%eax
80100512:	74 18                	je     8010052c <consputc+0x34>
    uartputc(c);
80100514:	83 ec 0c             	sub    $0xc,%esp
80100517:	50                   	push   %eax
80100518:	e8 d3 50 00 00       	call   801055f0 <uartputc>
8010051d:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
80100520:	89 d8                	mov    %ebx,%eax
80100522:	e8 b7 fe ff ff       	call   801003de <cgaputc>
}
80100527:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010052a:	c9                   	leave  
8010052b:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010052c:	83 ec 0c             	sub    $0xc,%esp
8010052f:	6a 08                	push   $0x8
80100531:	e8 ba 50 00 00       	call   801055f0 <uartputc>
80100536:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010053d:	e8 ae 50 00 00       	call   801055f0 <uartputc>
80100542:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100549:	e8 a2 50 00 00       	call   801055f0 <uartputc>
8010054e:	83 c4 10             	add    $0x10,%esp
80100551:	eb cd                	jmp    80100520 <consputc+0x28>

80100553 <printint>:
{
80100553:	55                   	push   %ebp
80100554:	89 e5                	mov    %esp,%ebp
80100556:	57                   	push   %edi
80100557:	56                   	push   %esi
80100558:	53                   	push   %ebx
80100559:	83 ec 2c             	sub    $0x2c,%esp
8010055c:	89 d6                	mov    %edx,%esi
8010055e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100561:	85 c9                	test   %ecx,%ecx
80100563:	74 0c                	je     80100571 <printint+0x1e>
80100565:	89 c7                	mov    %eax,%edi
80100567:	c1 ef 1f             	shr    $0x1f,%edi
8010056a:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010056d:	85 c0                	test   %eax,%eax
8010056f:	78 38                	js     801005a9 <printint+0x56>
    x = xx;
80100571:	89 c1                	mov    %eax,%ecx
  i = 0;
80100573:	bb 00 00 00 00       	mov    $0x0,%ebx
    buf[i++] = digits[x % base];
80100578:	89 c8                	mov    %ecx,%eax
8010057a:	ba 00 00 00 00       	mov    $0x0,%edx
8010057f:	f7 f6                	div    %esi
80100581:	89 df                	mov    %ebx,%edi
80100583:	83 c3 01             	add    $0x1,%ebx
80100586:	0f b6 92 c4 6a 10 80 	movzbl -0x7fef953c(%edx),%edx
8010058d:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
80100591:	89 ca                	mov    %ecx,%edx
80100593:	89 c1                	mov    %eax,%ecx
80100595:	39 d6                	cmp    %edx,%esi
80100597:	76 df                	jbe    80100578 <printint+0x25>
  if(sign)
80100599:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
8010059d:	74 1a                	je     801005b9 <printint+0x66>
    buf[i++] = '-';
8010059f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
801005a4:	8d 5f 02             	lea    0x2(%edi),%ebx
801005a7:	eb 10                	jmp    801005b9 <printint+0x66>
    x = -xx;
801005a9:	f7 d8                	neg    %eax
801005ab:	89 c1                	mov    %eax,%ecx
801005ad:	eb c4                	jmp    80100573 <printint+0x20>
    consputc(buf[i]);
801005af:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
801005b4:	e8 3f ff ff ff       	call   801004f8 <consputc>
  while(--i >= 0)
801005b9:	83 eb 01             	sub    $0x1,%ebx
801005bc:	79 f1                	jns    801005af <printint+0x5c>
}
801005be:	83 c4 2c             	add    $0x2c,%esp
801005c1:	5b                   	pop    %ebx
801005c2:	5e                   	pop    %esi
801005c3:	5f                   	pop    %edi
801005c4:	5d                   	pop    %ebp
801005c5:	c3                   	ret    

801005c6 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005c6:	f3 0f 1e fb          	endbr32 
801005ca:	55                   	push   %ebp
801005cb:	89 e5                	mov    %esp,%ebp
801005cd:	57                   	push   %edi
801005ce:	56                   	push   %esi
801005cf:	53                   	push   %ebx
801005d0:	83 ec 18             	sub    $0x18,%esp
801005d3:	8b 7d 0c             	mov    0xc(%ebp),%edi
801005d6:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005d9:	ff 75 08             	pushl  0x8(%ebp)
801005dc:	e8 ec 10 00 00       	call   801016cd <iunlock>
  acquire(&cons.lock);
801005e1:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801005e8:	e8 b8 39 00 00       	call   80103fa5 <acquire>
  for(i = 0; i < n; i++)
801005ed:	83 c4 10             	add    $0x10,%esp
801005f0:	bb 00 00 00 00       	mov    $0x0,%ebx
801005f5:	39 f3                	cmp    %esi,%ebx
801005f7:	7d 0e                	jge    80100607 <consolewrite+0x41>
    consputc(buf[i] & 0xff);
801005f9:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801005fd:	e8 f6 fe ff ff       	call   801004f8 <consputc>
  for(i = 0; i < n; i++)
80100602:	83 c3 01             	add    $0x1,%ebx
80100605:	eb ee                	jmp    801005f5 <consolewrite+0x2f>
  release(&cons.lock);
80100607:	83 ec 0c             	sub    $0xc,%esp
8010060a:	68 20 a5 10 80       	push   $0x8010a520
8010060f:	e8 fa 39 00 00       	call   8010400e <release>
  ilock(ip);
80100614:	83 c4 04             	add    $0x4,%esp
80100617:	ff 75 08             	pushl  0x8(%ebp)
8010061a:	e8 e8 0f 00 00       	call   80101607 <ilock>

  return n;
}
8010061f:	89 f0                	mov    %esi,%eax
80100621:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100624:	5b                   	pop    %ebx
80100625:	5e                   	pop    %esi
80100626:	5f                   	pop    %edi
80100627:	5d                   	pop    %ebp
80100628:	c3                   	ret    

80100629 <cprintf>:
{
80100629:	f3 0f 1e fb          	endbr32 
8010062d:	55                   	push   %ebp
8010062e:	89 e5                	mov    %esp,%ebp
80100630:	57                   	push   %edi
80100631:	56                   	push   %esi
80100632:	53                   	push   %ebx
80100633:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100636:	a1 54 a5 10 80       	mov    0x8010a554,%eax
8010063b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
8010063e:	85 c0                	test   %eax,%eax
80100640:	75 10                	jne    80100652 <cprintf+0x29>
  if (fmt == 0)
80100642:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80100646:	74 1c                	je     80100664 <cprintf+0x3b>
  argp = (uint*)(void*)(&fmt + 1);
80100648:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010064b:	be 00 00 00 00       	mov    $0x0,%esi
80100650:	eb 27                	jmp    80100679 <cprintf+0x50>
    acquire(&cons.lock);
80100652:	83 ec 0c             	sub    $0xc,%esp
80100655:	68 20 a5 10 80       	push   $0x8010a520
8010065a:	e8 46 39 00 00       	call   80103fa5 <acquire>
8010065f:	83 c4 10             	add    $0x10,%esp
80100662:	eb de                	jmp    80100642 <cprintf+0x19>
    panic("null fmt");
80100664:	83 ec 0c             	sub    $0xc,%esp
80100667:	68 9f 6a 10 80       	push   $0x80106a9f
8010066c:	e8 eb fc ff ff       	call   8010035c <panic>
      consputc(c);
80100671:	e8 82 fe ff ff       	call   801004f8 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	83 c6 01             	add    $0x1,%esi
80100679:	8b 55 08             	mov    0x8(%ebp),%edx
8010067c:	0f b6 04 32          	movzbl (%edx,%esi,1),%eax
80100680:	85 c0                	test   %eax,%eax
80100682:	0f 84 b1 00 00 00    	je     80100739 <cprintf+0x110>
    if(c != '%'){
80100688:	83 f8 25             	cmp    $0x25,%eax
8010068b:	75 e4                	jne    80100671 <cprintf+0x48>
    c = fmt[++i] & 0xff;
8010068d:	83 c6 01             	add    $0x1,%esi
80100690:	0f b6 1c 32          	movzbl (%edx,%esi,1),%ebx
    if(c == 0)
80100694:	85 db                	test   %ebx,%ebx
80100696:	0f 84 9d 00 00 00    	je     80100739 <cprintf+0x110>
    switch(c){
8010069c:	83 fb 70             	cmp    $0x70,%ebx
8010069f:	74 2e                	je     801006cf <cprintf+0xa6>
801006a1:	7f 22                	jg     801006c5 <cprintf+0x9c>
801006a3:	83 fb 25             	cmp    $0x25,%ebx
801006a6:	74 6c                	je     80100714 <cprintf+0xeb>
801006a8:	83 fb 64             	cmp    $0x64,%ebx
801006ab:	75 76                	jne    80100723 <cprintf+0xfa>
      printint(*argp++, 10, 1);
801006ad:	8d 5f 04             	lea    0x4(%edi),%ebx
801006b0:	8b 07                	mov    (%edi),%eax
801006b2:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b7:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bc:	e8 92 fe ff ff       	call   80100553 <printint>
801006c1:	89 df                	mov    %ebx,%edi
      break;
801006c3:	eb b1                	jmp    80100676 <cprintf+0x4d>
    switch(c){
801006c5:	83 fb 73             	cmp    $0x73,%ebx
801006c8:	74 1d                	je     801006e7 <cprintf+0xbe>
801006ca:	83 fb 78             	cmp    $0x78,%ebx
801006cd:	75 54                	jne    80100723 <cprintf+0xfa>
      printint(*argp++, 16, 0);
801006cf:	8d 5f 04             	lea    0x4(%edi),%ebx
801006d2:	8b 07                	mov    (%edi),%eax
801006d4:	b9 00 00 00 00       	mov    $0x0,%ecx
801006d9:	ba 10 00 00 00       	mov    $0x10,%edx
801006de:	e8 70 fe ff ff       	call   80100553 <printint>
801006e3:	89 df                	mov    %ebx,%edi
      break;
801006e5:	eb 8f                	jmp    80100676 <cprintf+0x4d>
      if((s = (char*)*argp++) == 0)
801006e7:	8d 47 04             	lea    0x4(%edi),%eax
801006ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006ed:	8b 1f                	mov    (%edi),%ebx
801006ef:	85 db                	test   %ebx,%ebx
801006f1:	75 05                	jne    801006f8 <cprintf+0xcf>
        s = "(null)";
801006f3:	bb 98 6a 10 80       	mov    $0x80106a98,%ebx
      for(; *s; s++)
801006f8:	0f b6 03             	movzbl (%ebx),%eax
801006fb:	84 c0                	test   %al,%al
801006fd:	74 0d                	je     8010070c <cprintf+0xe3>
        consputc(*s);
801006ff:	0f be c0             	movsbl %al,%eax
80100702:	e8 f1 fd ff ff       	call   801004f8 <consputc>
      for(; *s; s++)
80100707:	83 c3 01             	add    $0x1,%ebx
8010070a:	eb ec                	jmp    801006f8 <cprintf+0xcf>
      if((s = (char*)*argp++) == 0)
8010070c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010070f:	e9 62 ff ff ff       	jmp    80100676 <cprintf+0x4d>
      consputc('%');
80100714:	b8 25 00 00 00       	mov    $0x25,%eax
80100719:	e8 da fd ff ff       	call   801004f8 <consputc>
      break;
8010071e:	e9 53 ff ff ff       	jmp    80100676 <cprintf+0x4d>
      consputc('%');
80100723:	b8 25 00 00 00       	mov    $0x25,%eax
80100728:	e8 cb fd ff ff       	call   801004f8 <consputc>
      consputc(c);
8010072d:	89 d8                	mov    %ebx,%eax
8010072f:	e8 c4 fd ff ff       	call   801004f8 <consputc>
      break;
80100734:	e9 3d ff ff ff       	jmp    80100676 <cprintf+0x4d>
  if(locking)
80100739:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010073d:	75 08                	jne    80100747 <cprintf+0x11e>
}
8010073f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100742:	5b                   	pop    %ebx
80100743:	5e                   	pop    %esi
80100744:	5f                   	pop    %edi
80100745:	5d                   	pop    %ebp
80100746:	c3                   	ret    
    release(&cons.lock);
80100747:	83 ec 0c             	sub    $0xc,%esp
8010074a:	68 20 a5 10 80       	push   $0x8010a520
8010074f:	e8 ba 38 00 00       	call   8010400e <release>
80100754:	83 c4 10             	add    $0x10,%esp
}
80100757:	eb e6                	jmp    8010073f <cprintf+0x116>

80100759 <do_shutdown>:
{
80100759:	f3 0f 1e fb          	endbr32 
8010075d:	55                   	push   %ebp
8010075e:	89 e5                	mov    %esp,%ebp
80100760:	83 ec 14             	sub    $0x14,%esp
  cprintf("\nShutting down ...\n");
80100763:	68 a8 6a 10 80       	push   $0x80106aa8
80100768:	e8 bc fe ff ff       	call   80100629 <cprintf>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010076d:	b8 00 20 00 00       	mov    $0x2000,%eax
80100772:	ba 04 06 00 00       	mov    $0x604,%edx
80100777:	66 ef                	out    %ax,(%dx)
  return;  // not reached
80100779:	83 c4 10             	add    $0x10,%esp
}
8010077c:	c9                   	leave  
8010077d:	c3                   	ret    

8010077e <consoleintr>:
{
8010077e:	f3 0f 1e fb          	endbr32 
80100782:	55                   	push   %ebp
80100783:	89 e5                	mov    %esp,%ebp
80100785:	57                   	push   %edi
80100786:	56                   	push   %esi
80100787:	53                   	push   %ebx
80100788:	83 ec 28             	sub    $0x28,%esp
8010078b:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
8010078e:	68 20 a5 10 80       	push   $0x8010a520
80100793:	e8 0d 38 00 00       	call   80103fa5 <acquire>
  while((c = getc()) >= 0){
80100798:	83 c4 10             	add    $0x10,%esp
  int shutdown = FALSE;
8010079b:	bf 00 00 00 00       	mov    $0x0,%edi
  int c, doprocdump = 0;
801007a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((c = getc()) >= 0){
801007a7:	e9 d5 00 00 00       	jmp    80100881 <consoleintr+0x103>
    switch(c){
801007ac:	83 fb 15             	cmp    $0x15,%ebx
801007af:	0f 84 94 00 00 00    	je     80100849 <consoleintr+0xcb>
801007b5:	83 fb 7f             	cmp    $0x7f,%ebx
801007b8:	0f 84 e4 00 00 00    	je     801008a2 <consoleintr+0x124>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801007be:	85 db                	test   %ebx,%ebx
801007c0:	0f 84 bb 00 00 00    	je     80100881 <consoleintr+0x103>
801007c6:	a1 08 41 11 80       	mov    0x80114108,%eax
801007cb:	89 c2                	mov    %eax,%edx
801007cd:	2b 15 00 41 11 80    	sub    0x80114100,%edx
801007d3:	83 fa 7f             	cmp    $0x7f,%edx
801007d6:	0f 87 a5 00 00 00    	ja     80100881 <consoleintr+0x103>
        c = (c == '\r') ? '\n' : c;
801007dc:	83 fb 0d             	cmp    $0xd,%ebx
801007df:	0f 84 84 00 00 00    	je     80100869 <consoleintr+0xeb>
        input.buf[input.e++ % INPUT_BUF] = c;
801007e5:	8d 50 01             	lea    0x1(%eax),%edx
801007e8:	89 15 08 41 11 80    	mov    %edx,0x80114108
801007ee:	83 e0 7f             	and    $0x7f,%eax
801007f1:	88 98 80 40 11 80    	mov    %bl,-0x7feebf80(%eax)
        consputc(c);
801007f7:	89 d8                	mov    %ebx,%eax
801007f9:	e8 fa fc ff ff       	call   801004f8 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801007fe:	83 fb 0a             	cmp    $0xa,%ebx
80100801:	0f 94 c2             	sete   %dl
80100804:	83 fb 04             	cmp    $0x4,%ebx
80100807:	0f 94 c0             	sete   %al
8010080a:	08 c2                	or     %al,%dl
8010080c:	75 10                	jne    8010081e <consoleintr+0xa0>
8010080e:	a1 00 41 11 80       	mov    0x80114100,%eax
80100813:	83 e8 80             	sub    $0xffffff80,%eax
80100816:	39 05 08 41 11 80    	cmp    %eax,0x80114108
8010081c:	75 63                	jne    80100881 <consoleintr+0x103>
          input.w = input.e;
8010081e:	a1 08 41 11 80       	mov    0x80114108,%eax
80100823:	a3 04 41 11 80       	mov    %eax,0x80114104
          wakeup(&input.r);
80100828:	83 ec 0c             	sub    $0xc,%esp
8010082b:	68 00 41 11 80       	push   $0x80114100
80100830:	e8 61 31 00 00       	call   80103996 <wakeup>
80100835:	83 c4 10             	add    $0x10,%esp
80100838:	eb 47                	jmp    80100881 <consoleintr+0x103>
        input.e--;
8010083a:	a3 08 41 11 80       	mov    %eax,0x80114108
        consputc(BACKSPACE);
8010083f:	b8 00 01 00 00       	mov    $0x100,%eax
80100844:	e8 af fc ff ff       	call   801004f8 <consputc>
      while(input.e != input.w &&
80100849:	a1 08 41 11 80       	mov    0x80114108,%eax
8010084e:	3b 05 04 41 11 80    	cmp    0x80114104,%eax
80100854:	74 2b                	je     80100881 <consoleintr+0x103>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100856:	83 e8 01             	sub    $0x1,%eax
80100859:	89 c2                	mov    %eax,%edx
8010085b:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
8010085e:	80 ba 80 40 11 80 0a 	cmpb   $0xa,-0x7feebf80(%edx)
80100865:	75 d3                	jne    8010083a <consoleintr+0xbc>
80100867:	eb 18                	jmp    80100881 <consoleintr+0x103>
        c = (c == '\r') ? '\n' : c;
80100869:	bb 0a 00 00 00       	mov    $0xa,%ebx
8010086e:	e9 72 ff ff ff       	jmp    801007e5 <consoleintr+0x67>
    switch(c){
80100873:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
8010087a:	eb 05                	jmp    80100881 <consoleintr+0x103>
      shutdown = TRUE;
8010087c:	bf 01 00 00 00       	mov    $0x1,%edi
  while((c = getc()) >= 0){
80100881:	ff d6                	call   *%esi
80100883:	89 c3                	mov    %eax,%ebx
80100885:	85 c0                	test   %eax,%eax
80100887:	78 3a                	js     801008c3 <consoleintr+0x145>
    switch(c){
80100889:	83 fb 10             	cmp    $0x10,%ebx
8010088c:	74 e5                	je     80100873 <consoleintr+0xf5>
8010088e:	0f 8f 18 ff ff ff    	jg     801007ac <consoleintr+0x2e>
80100894:	83 fb 04             	cmp    $0x4,%ebx
80100897:	74 e3                	je     8010087c <consoleintr+0xfe>
80100899:	83 fb 08             	cmp    $0x8,%ebx
8010089c:	0f 85 1c ff ff ff    	jne    801007be <consoleintr+0x40>
      if(input.e != input.w){
801008a2:	a1 08 41 11 80       	mov    0x80114108,%eax
801008a7:	3b 05 04 41 11 80    	cmp    0x80114104,%eax
801008ad:	74 d2                	je     80100881 <consoleintr+0x103>
        input.e--;
801008af:	83 e8 01             	sub    $0x1,%eax
801008b2:	a3 08 41 11 80       	mov    %eax,0x80114108
        consputc(BACKSPACE);
801008b7:	b8 00 01 00 00       	mov    $0x100,%eax
801008bc:	e8 37 fc ff ff       	call   801004f8 <consputc>
801008c1:	eb be                	jmp    80100881 <consoleintr+0x103>
  release(&cons.lock);
801008c3:	83 ec 0c             	sub    $0xc,%esp
801008c6:	68 20 a5 10 80       	push   $0x8010a520
801008cb:	e8 3e 37 00 00       	call   8010400e <release>
  if (shutdown)
801008d0:	83 c4 10             	add    $0x10,%esp
801008d3:	85 ff                	test   %edi,%edi
801008d5:	75 0e                	jne    801008e5 <consoleintr+0x167>
  if(doprocdump) {
801008d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801008db:	75 0f                	jne    801008ec <consoleintr+0x16e>
}
801008dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801008e0:	5b                   	pop    %ebx
801008e1:	5e                   	pop    %esi
801008e2:	5f                   	pop    %edi
801008e3:	5d                   	pop    %ebp
801008e4:	c3                   	ret    
    do_shutdown();
801008e5:	e8 6f fe ff ff       	call   80100759 <do_shutdown>
801008ea:	eb eb                	jmp    801008d7 <consoleintr+0x159>
    procdump();  // now call procdump() wo. cons.lock held
801008ec:	e8 aa 33 00 00       	call   80103c9b <procdump>
}
801008f1:	eb ea                	jmp    801008dd <consoleintr+0x15f>

801008f3 <consoleinit>:

void
consoleinit(void)
{
801008f3:	f3 0f 1e fb          	endbr32 
801008f7:	55                   	push   %ebp
801008f8:	89 e5                	mov    %esp,%ebp
801008fa:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801008fd:	68 bc 6a 10 80       	push   $0x80106abc
80100902:	68 20 a5 10 80       	push   $0x8010a520
80100907:	e8 49 35 00 00       	call   80103e55 <initlock>

  devsw[CONSOLE].write = consolewrite;
8010090c:	c7 05 cc 4a 11 80 c6 	movl   $0x801005c6,0x80114acc
80100913:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100916:	c7 05 c8 4a 11 80 78 	movl   $0x80100278,0x80114ac8
8010091d:	02 10 80 
  cons.locking = 1;
80100920:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100927:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
8010092a:	83 c4 08             	add    $0x8,%esp
8010092d:	6a 00                	push   $0x0
8010092f:	6a 01                	push   $0x1
80100931:	e8 02 17 00 00       	call   80102038 <ioapicenable>
}
80100936:	83 c4 10             	add    $0x10,%esp
80100939:	c9                   	leave  
8010093a:	c3                   	ret    

8010093b <exec>:
#include "elf.h"


int
exec(char *path, char **argv)
{
8010093b:	f3 0f 1e fb          	endbr32 
8010093f:	55                   	push   %ebp
80100940:	89 e5                	mov    %esp,%ebp
80100942:	57                   	push   %edi
80100943:	56                   	push   %esi
80100944:	53                   	push   %ebx
80100945:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
8010094b:	e8 eb 29 00 00       	call   8010333b <myproc>
80100950:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100956:	e8 31 1f 00 00       	call   8010288c <begin_op>

  if((ip = namei(path)) == 0){
8010095b:	83 ec 0c             	sub    $0xc,%esp
8010095e:	ff 75 08             	pushl  0x8(%ebp)
80100961:	e8 26 13 00 00       	call   80101c8c <namei>
80100966:	83 c4 10             	add    $0x10,%esp
80100969:	85 c0                	test   %eax,%eax
8010096b:	74 56                	je     801009c3 <exec+0x88>
8010096d:	89 c3                	mov    %eax,%ebx
#ifndef PDX_XV6
    cprintf("exec: fail\n");
#endif
    return -1;
  }
  ilock(ip);
8010096f:	83 ec 0c             	sub    $0xc,%esp
80100972:	50                   	push   %eax
80100973:	e8 8f 0c 00 00       	call   80101607 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100978:	6a 34                	push   $0x34
8010097a:	6a 00                	push   $0x0
8010097c:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100982:	50                   	push   %eax
80100983:	53                   	push   %ebx
80100984:	e8 84 0e 00 00       	call   8010180d <readi>
80100989:	83 c4 20             	add    $0x20,%esp
8010098c:	83 f8 34             	cmp    $0x34,%eax
8010098f:	75 0c                	jne    8010099d <exec+0x62>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100991:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100998:	45 4c 46 
8010099b:	74 32                	je     801009cf <exec+0x94>
  return 0;

bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
8010099d:	85 db                	test   %ebx,%ebx
8010099f:	0f 84 b9 02 00 00    	je     80100c5e <exec+0x323>
    iunlockput(ip);
801009a5:	83 ec 0c             	sub    $0xc,%esp
801009a8:	53                   	push   %ebx
801009a9:	e8 0c 0e 00 00       	call   801017ba <iunlockput>
    end_op();
801009ae:	e8 57 1f 00 00       	call   8010290a <end_op>
801009b3:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
801009b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801009bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009be:	5b                   	pop    %ebx
801009bf:	5e                   	pop    %esi
801009c0:	5f                   	pop    %edi
801009c1:	5d                   	pop    %ebp
801009c2:	c3                   	ret    
    end_op();
801009c3:	e8 42 1f 00 00       	call   8010290a <end_op>
    return -1;
801009c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009cd:	eb ec                	jmp    801009bb <exec+0x80>
  if((pgdir = setupkvm()) == 0)
801009cf:	e8 fe 5d 00 00       	call   801067d2 <setupkvm>
801009d4:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801009da:	85 c0                	test   %eax,%eax
801009dc:	0f 84 09 01 00 00    	je     80100aeb <exec+0x1b0>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801009e2:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  sz = 0;
801009e8:	bf 00 00 00 00       	mov    $0x0,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801009ed:	be 00 00 00 00       	mov    $0x0,%esi
801009f2:	eb 0c                	jmp    80100a00 <exec+0xc5>
801009f4:	83 c6 01             	add    $0x1,%esi
801009f7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
801009fd:	83 c0 20             	add    $0x20,%eax
80100a00:	0f b7 95 50 ff ff ff 	movzwl -0xb0(%ebp),%edx
80100a07:	39 f2                	cmp    %esi,%edx
80100a09:	0f 8e 98 00 00 00    	jle    80100aa7 <exec+0x16c>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a0f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a15:	6a 20                	push   $0x20
80100a17:	50                   	push   %eax
80100a18:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a1e:	50                   	push   %eax
80100a1f:	53                   	push   %ebx
80100a20:	e8 e8 0d 00 00       	call   8010180d <readi>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	83 f8 20             	cmp    $0x20,%eax
80100a2b:	0f 85 ba 00 00 00    	jne    80100aeb <exec+0x1b0>
    if(ph.type != ELF_PROG_LOAD)
80100a31:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100a38:	75 ba                	jne    801009f4 <exec+0xb9>
    if(ph.memsz < ph.filesz)
80100a3a:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100a40:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100a46:	0f 82 9f 00 00 00    	jb     80100aeb <exec+0x1b0>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100a4c:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100a52:	0f 82 93 00 00 00    	jb     80100aeb <exec+0x1b0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100a58:	83 ec 04             	sub    $0x4,%esp
80100a5b:	50                   	push   %eax
80100a5c:	57                   	push   %edi
80100a5d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100a63:	e8 09 5c 00 00       	call   80106671 <allocuvm>
80100a68:	89 c7                	mov    %eax,%edi
80100a6a:	83 c4 10             	add    $0x10,%esp
80100a6d:	85 c0                	test   %eax,%eax
80100a6f:	74 7a                	je     80100aeb <exec+0x1b0>
    if(ph.vaddr % PGSIZE != 0)
80100a71:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100a77:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100a7c:	75 6d                	jne    80100aeb <exec+0x1b0>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100a7e:	83 ec 0c             	sub    $0xc,%esp
80100a81:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100a87:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100a8d:	53                   	push   %ebx
80100a8e:	50                   	push   %eax
80100a8f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100a95:	e8 a2 5a 00 00       	call   8010653c <loaduvm>
80100a9a:	83 c4 20             	add    $0x20,%esp
80100a9d:	85 c0                	test   %eax,%eax
80100a9f:	0f 89 4f ff ff ff    	jns    801009f4 <exec+0xb9>
80100aa5:	eb 44                	jmp    80100aeb <exec+0x1b0>
  iunlockput(ip);
80100aa7:	83 ec 0c             	sub    $0xc,%esp
80100aaa:	53                   	push   %ebx
80100aab:	e8 0a 0d 00 00       	call   801017ba <iunlockput>
  end_op();
80100ab0:	e8 55 1e 00 00       	call   8010290a <end_op>
  sz = PGROUNDUP(sz);
80100ab5:	8d 87 ff 0f 00 00    	lea    0xfff(%edi),%eax
80100abb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ac0:	83 c4 0c             	add    $0xc,%esp
80100ac3:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100ac9:	52                   	push   %edx
80100aca:	50                   	push   %eax
80100acb:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100ad1:	57                   	push   %edi
80100ad2:	e8 9a 5b 00 00       	call   80106671 <allocuvm>
80100ad7:	89 c6                	mov    %eax,%esi
80100ad9:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100adf:	83 c4 10             	add    $0x10,%esp
80100ae2:	85 c0                	test   %eax,%eax
80100ae4:	75 24                	jne    80100b0a <exec+0x1cf>
  ip = 0;
80100ae6:	bb 00 00 00 00       	mov    $0x0,%ebx
  if(pgdir)
80100aeb:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100af1:	85 c0                	test   %eax,%eax
80100af3:	0f 84 a4 fe ff ff    	je     8010099d <exec+0x62>
    freevm(pgdir);
80100af9:	83 ec 0c             	sub    $0xc,%esp
80100afc:	50                   	push   %eax
80100afd:	e8 5c 5c 00 00       	call   8010675e <freevm>
80100b02:	83 c4 10             	add    $0x10,%esp
80100b05:	e9 93 fe ff ff       	jmp    8010099d <exec+0x62>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100b0a:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100b10:	83 ec 08             	sub    $0x8,%esp
80100b13:	50                   	push   %eax
80100b14:	57                   	push   %edi
80100b15:	e8 45 5d 00 00       	call   8010685f <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100b1a:	83 c4 10             	add    $0x10,%esp
80100b1d:	bf 00 00 00 00       	mov    $0x0,%edi
80100b22:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b25:	8d 1c b8             	lea    (%eax,%edi,4),%ebx
80100b28:	8b 03                	mov    (%ebx),%eax
80100b2a:	85 c0                	test   %eax,%eax
80100b2c:	74 4d                	je     80100b7b <exec+0x240>
    if(argc >= MAXARG)
80100b2e:	83 ff 1f             	cmp    $0x1f,%edi
80100b31:	0f 87 13 01 00 00    	ja     80100c4a <exec+0x30f>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100b37:	83 ec 0c             	sub    $0xc,%esp
80100b3a:	50                   	push   %eax
80100b3b:	e8 da 36 00 00       	call   8010421a <strlen>
80100b40:	29 c6                	sub    %eax,%esi
80100b42:	83 ee 01             	sub    $0x1,%esi
80100b45:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100b48:	83 c4 04             	add    $0x4,%esp
80100b4b:	ff 33                	pushl  (%ebx)
80100b4d:	e8 c8 36 00 00       	call   8010421a <strlen>
80100b52:	83 c0 01             	add    $0x1,%eax
80100b55:	50                   	push   %eax
80100b56:	ff 33                	pushl  (%ebx)
80100b58:	56                   	push   %esi
80100b59:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b5f:	e8 49 5e 00 00       	call   801069ad <copyout>
80100b64:	83 c4 20             	add    $0x20,%esp
80100b67:	85 c0                	test   %eax,%eax
80100b69:	0f 88 e5 00 00 00    	js     80100c54 <exec+0x319>
    ustack[3+argc] = sp;
80100b6f:	89 b4 bd 64 ff ff ff 	mov    %esi,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100b76:	83 c7 01             	add    $0x1,%edi
80100b79:	eb a7                	jmp    80100b22 <exec+0x1e7>
80100b7b:	89 f1                	mov    %esi,%ecx
80100b7d:	89 c3                	mov    %eax,%ebx
  ustack[3+argc] = 0;
80100b7f:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100b86:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100b8a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100b91:	ff ff ff 
  ustack[1] = argc;
80100b94:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100b9a:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100ba1:	89 f2                	mov    %esi,%edx
80100ba3:	29 c2                	sub    %eax,%edx
80100ba5:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100bab:	8d 04 bd 10 00 00 00 	lea    0x10(,%edi,4),%eax
80100bb2:	29 c1                	sub    %eax,%ecx
80100bb4:	89 ce                	mov    %ecx,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100bb6:	50                   	push   %eax
80100bb7:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100bbd:	50                   	push   %eax
80100bbe:	51                   	push   %ecx
80100bbf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc5:	e8 e3 5d 00 00       	call   801069ad <copyout>
80100bca:	83 c4 10             	add    $0x10,%esp
80100bcd:	85 c0                	test   %eax,%eax
80100bcf:	0f 88 16 ff ff ff    	js     80100aeb <exec+0x1b0>
  for(last=s=path; *s; s++)
80100bd5:	8b 55 08             	mov    0x8(%ebp),%edx
80100bd8:	89 d0                	mov    %edx,%eax
80100bda:	eb 03                	jmp    80100bdf <exec+0x2a4>
80100bdc:	83 c0 01             	add    $0x1,%eax
80100bdf:	0f b6 08             	movzbl (%eax),%ecx
80100be2:	84 c9                	test   %cl,%cl
80100be4:	74 0a                	je     80100bf0 <exec+0x2b5>
    if(*s == '/')
80100be6:	80 f9 2f             	cmp    $0x2f,%cl
80100be9:	75 f1                	jne    80100bdc <exec+0x2a1>
      last = s+1;
80100beb:	8d 50 01             	lea    0x1(%eax),%edx
80100bee:	eb ec                	jmp    80100bdc <exec+0x2a1>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100bf0:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100bf6:	89 f8                	mov    %edi,%eax
80100bf8:	83 c0 6c             	add    $0x6c,%eax
80100bfb:	83 ec 04             	sub    $0x4,%esp
80100bfe:	6a 10                	push   $0x10
80100c00:	52                   	push   %edx
80100c01:	50                   	push   %eax
80100c02:	e8 d2 35 00 00       	call   801041d9 <safestrcpy>
  oldpgdir = curproc->pgdir;
80100c07:	8b 5f 04             	mov    0x4(%edi),%ebx
  curproc->pgdir = pgdir;
80100c0a:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100c10:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100c13:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100c19:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100c1b:	8b 47 18             	mov    0x18(%edi),%eax
80100c1e:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100c24:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100c27:	8b 47 18             	mov    0x18(%edi),%eax
80100c2a:	89 70 44             	mov    %esi,0x44(%eax)
  switchuvm(curproc);
80100c2d:	89 3c 24             	mov    %edi,(%esp)
80100c30:	e8 7e 57 00 00       	call   801063b3 <switchuvm>
  freevm(oldpgdir);
80100c35:	89 1c 24             	mov    %ebx,(%esp)
80100c38:	e8 21 5b 00 00       	call   8010675e <freevm>
  return 0;
80100c3d:	83 c4 10             	add    $0x10,%esp
80100c40:	b8 00 00 00 00       	mov    $0x0,%eax
80100c45:	e9 71 fd ff ff       	jmp    801009bb <exec+0x80>
  ip = 0;
80100c4a:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c4f:	e9 97 fe ff ff       	jmp    80100aeb <exec+0x1b0>
80100c54:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c59:	e9 8d fe ff ff       	jmp    80100aeb <exec+0x1b0>
  return -1;
80100c5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c63:	e9 53 fd ff ff       	jmp    801009bb <exec+0x80>

80100c68 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100c68:	f3 0f 1e fb          	endbr32 
80100c6c:	55                   	push   %ebp
80100c6d:	89 e5                	mov    %esp,%ebp
80100c6f:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100c72:	68 d5 6a 10 80       	push   $0x80106ad5
80100c77:	68 20 41 11 80       	push   $0x80114120
80100c7c:	e8 d4 31 00 00       	call   80103e55 <initlock>
}
80100c81:	83 c4 10             	add    $0x10,%esp
80100c84:	c9                   	leave  
80100c85:	c3                   	ret    

80100c86 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100c86:	f3 0f 1e fb          	endbr32 
80100c8a:	55                   	push   %ebp
80100c8b:	89 e5                	mov    %esp,%ebp
80100c8d:	53                   	push   %ebx
80100c8e:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100c91:	68 20 41 11 80       	push   $0x80114120
80100c96:	e8 0a 33 00 00       	call   80103fa5 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c9b:	83 c4 10             	add    $0x10,%esp
80100c9e:	bb 54 41 11 80       	mov    $0x80114154,%ebx
80100ca3:	eb 03                	jmp    80100ca8 <filealloc+0x22>
80100ca5:	83 c3 18             	add    $0x18,%ebx
80100ca8:	81 fb b4 4a 11 80    	cmp    $0x80114ab4,%ebx
80100cae:	73 24                	jae    80100cd4 <filealloc+0x4e>
    if(f->ref == 0){
80100cb0:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100cb4:	75 ef                	jne    80100ca5 <filealloc+0x1f>
      f->ref = 1;
80100cb6:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100cbd:	83 ec 0c             	sub    $0xc,%esp
80100cc0:	68 20 41 11 80       	push   $0x80114120
80100cc5:	e8 44 33 00 00       	call   8010400e <release>
      return f;
80100cca:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ccd:	89 d8                	mov    %ebx,%eax
80100ccf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cd2:	c9                   	leave  
80100cd3:	c3                   	ret    
  release(&ftable.lock);
80100cd4:	83 ec 0c             	sub    $0xc,%esp
80100cd7:	68 20 41 11 80       	push   $0x80114120
80100cdc:	e8 2d 33 00 00       	call   8010400e <release>
  return 0;
80100ce1:	83 c4 10             	add    $0x10,%esp
80100ce4:	bb 00 00 00 00       	mov    $0x0,%ebx
80100ce9:	eb e2                	jmp    80100ccd <filealloc+0x47>

80100ceb <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ceb:	f3 0f 1e fb          	endbr32 
80100cef:	55                   	push   %ebp
80100cf0:	89 e5                	mov    %esp,%ebp
80100cf2:	53                   	push   %ebx
80100cf3:	83 ec 10             	sub    $0x10,%esp
80100cf6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100cf9:	68 20 41 11 80       	push   $0x80114120
80100cfe:	e8 a2 32 00 00       	call   80103fa5 <acquire>
  if(f->ref < 1)
80100d03:	8b 43 04             	mov    0x4(%ebx),%eax
80100d06:	83 c4 10             	add    $0x10,%esp
80100d09:	85 c0                	test   %eax,%eax
80100d0b:	7e 1a                	jle    80100d27 <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100d0d:	83 c0 01             	add    $0x1,%eax
80100d10:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100d13:	83 ec 0c             	sub    $0xc,%esp
80100d16:	68 20 41 11 80       	push   $0x80114120
80100d1b:	e8 ee 32 00 00       	call   8010400e <release>
  return f;
}
80100d20:	89 d8                	mov    %ebx,%eax
80100d22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d25:	c9                   	leave  
80100d26:	c3                   	ret    
    panic("filedup");
80100d27:	83 ec 0c             	sub    $0xc,%esp
80100d2a:	68 dc 6a 10 80       	push   $0x80106adc
80100d2f:	e8 28 f6 ff ff       	call   8010035c <panic>

80100d34 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100d34:	f3 0f 1e fb          	endbr32 
80100d38:	55                   	push   %ebp
80100d39:	89 e5                	mov    %esp,%ebp
80100d3b:	53                   	push   %ebx
80100d3c:	83 ec 30             	sub    $0x30,%esp
80100d3f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100d42:	68 20 41 11 80       	push   $0x80114120
80100d47:	e8 59 32 00 00       	call   80103fa5 <acquire>
  if(f->ref < 1)
80100d4c:	8b 43 04             	mov    0x4(%ebx),%eax
80100d4f:	83 c4 10             	add    $0x10,%esp
80100d52:	85 c0                	test   %eax,%eax
80100d54:	7e 65                	jle    80100dbb <fileclose+0x87>
    panic("fileclose");
  if(--f->ref > 0){
80100d56:	83 e8 01             	sub    $0x1,%eax
80100d59:	89 43 04             	mov    %eax,0x4(%ebx)
80100d5c:	85 c0                	test   %eax,%eax
80100d5e:	7f 68                	jg     80100dc8 <fileclose+0x94>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100d60:	8b 03                	mov    (%ebx),%eax
80100d62:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d65:	8b 43 08             	mov    0x8(%ebx),%eax
80100d68:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d6b:	8b 43 0c             	mov    0xc(%ebx),%eax
80100d6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100d71:	8b 43 10             	mov    0x10(%ebx),%eax
80100d74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  f->ref = 0;
80100d77:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100d7e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100d84:	83 ec 0c             	sub    $0xc,%esp
80100d87:	68 20 41 11 80       	push   $0x80114120
80100d8c:	e8 7d 32 00 00       	call   8010400e <release>

  if(ff.type == FD_PIPE)
80100d91:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d94:	83 c4 10             	add    $0x10,%esp
80100d97:	83 f8 01             	cmp    $0x1,%eax
80100d9a:	74 41                	je     80100ddd <fileclose+0xa9>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100d9c:	83 f8 02             	cmp    $0x2,%eax
80100d9f:	75 37                	jne    80100dd8 <fileclose+0xa4>
    begin_op();
80100da1:	e8 e6 1a 00 00       	call   8010288c <begin_op>
    iput(ff.ip);
80100da6:	83 ec 0c             	sub    $0xc,%esp
80100da9:	ff 75 f0             	pushl  -0x10(%ebp)
80100dac:	e8 65 09 00 00       	call   80101716 <iput>
    end_op();
80100db1:	e8 54 1b 00 00       	call   8010290a <end_op>
80100db6:	83 c4 10             	add    $0x10,%esp
80100db9:	eb 1d                	jmp    80100dd8 <fileclose+0xa4>
    panic("fileclose");
80100dbb:	83 ec 0c             	sub    $0xc,%esp
80100dbe:	68 e4 6a 10 80       	push   $0x80106ae4
80100dc3:	e8 94 f5 ff ff       	call   8010035c <panic>
    release(&ftable.lock);
80100dc8:	83 ec 0c             	sub    $0xc,%esp
80100dcb:	68 20 41 11 80       	push   $0x80114120
80100dd0:	e8 39 32 00 00       	call   8010400e <release>
    return;
80100dd5:	83 c4 10             	add    $0x10,%esp
  }
}
80100dd8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ddb:	c9                   	leave  
80100ddc:	c3                   	ret    
    pipeclose(ff.pipe, ff.writable);
80100ddd:	83 ec 08             	sub    $0x8,%esp
80100de0:	0f be 45 e9          	movsbl -0x17(%ebp),%eax
80100de4:	50                   	push   %eax
80100de5:	ff 75 ec             	pushl  -0x14(%ebp)
80100de8:	e8 32 21 00 00       	call   80102f1f <pipeclose>
80100ded:	83 c4 10             	add    $0x10,%esp
80100df0:	eb e6                	jmp    80100dd8 <fileclose+0xa4>

80100df2 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100df2:	f3 0f 1e fb          	endbr32 
80100df6:	55                   	push   %ebp
80100df7:	89 e5                	mov    %esp,%ebp
80100df9:	53                   	push   %ebx
80100dfa:	83 ec 04             	sub    $0x4,%esp
80100dfd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100e00:	83 3b 02             	cmpl   $0x2,(%ebx)
80100e03:	75 31                	jne    80100e36 <filestat+0x44>
    ilock(f->ip);
80100e05:	83 ec 0c             	sub    $0xc,%esp
80100e08:	ff 73 10             	pushl  0x10(%ebx)
80100e0b:	e8 f7 07 00 00       	call   80101607 <ilock>
    stati(f->ip, st);
80100e10:	83 c4 08             	add    $0x8,%esp
80100e13:	ff 75 0c             	pushl  0xc(%ebp)
80100e16:	ff 73 10             	pushl  0x10(%ebx)
80100e19:	e8 c0 09 00 00       	call   801017de <stati>
    iunlock(f->ip);
80100e1e:	83 c4 04             	add    $0x4,%esp
80100e21:	ff 73 10             	pushl  0x10(%ebx)
80100e24:	e8 a4 08 00 00       	call   801016cd <iunlock>
    return 0;
80100e29:	83 c4 10             	add    $0x10,%esp
80100e2c:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
80100e31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e34:	c9                   	leave  
80100e35:	c3                   	ret    
  return -1;
80100e36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e3b:	eb f4                	jmp    80100e31 <filestat+0x3f>

80100e3d <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100e3d:	f3 0f 1e fb          	endbr32 
80100e41:	55                   	push   %ebp
80100e42:	89 e5                	mov    %esp,%ebp
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->readable == 0)
80100e49:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100e4d:	74 70                	je     80100ebf <fileread+0x82>
    return -1;
  if(f->type == FD_PIPE)
80100e4f:	8b 03                	mov    (%ebx),%eax
80100e51:	83 f8 01             	cmp    $0x1,%eax
80100e54:	74 44                	je     80100e9a <fileread+0x5d>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100e56:	83 f8 02             	cmp    $0x2,%eax
80100e59:	75 57                	jne    80100eb2 <fileread+0x75>
    ilock(f->ip);
80100e5b:	83 ec 0c             	sub    $0xc,%esp
80100e5e:	ff 73 10             	pushl  0x10(%ebx)
80100e61:	e8 a1 07 00 00       	call   80101607 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100e66:	ff 75 10             	pushl  0x10(%ebp)
80100e69:	ff 73 14             	pushl  0x14(%ebx)
80100e6c:	ff 75 0c             	pushl  0xc(%ebp)
80100e6f:	ff 73 10             	pushl  0x10(%ebx)
80100e72:	e8 96 09 00 00       	call   8010180d <readi>
80100e77:	89 c6                	mov    %eax,%esi
80100e79:	83 c4 20             	add    $0x20,%esp
80100e7c:	85 c0                	test   %eax,%eax
80100e7e:	7e 03                	jle    80100e83 <fileread+0x46>
      f->off += r;
80100e80:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100e83:	83 ec 0c             	sub    $0xc,%esp
80100e86:	ff 73 10             	pushl  0x10(%ebx)
80100e89:	e8 3f 08 00 00       	call   801016cd <iunlock>
    return r;
80100e8e:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100e91:	89 f0                	mov    %esi,%eax
80100e93:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100e96:	5b                   	pop    %ebx
80100e97:	5e                   	pop    %esi
80100e98:	5d                   	pop    %ebp
80100e99:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100e9a:	83 ec 04             	sub    $0x4,%esp
80100e9d:	ff 75 10             	pushl  0x10(%ebp)
80100ea0:	ff 75 0c             	pushl  0xc(%ebp)
80100ea3:	ff 73 0c             	pushl  0xc(%ebx)
80100ea6:	e8 ce 21 00 00       	call   80103079 <piperead>
80100eab:	89 c6                	mov    %eax,%esi
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	eb df                	jmp    80100e91 <fileread+0x54>
  panic("fileread");
80100eb2:	83 ec 0c             	sub    $0xc,%esp
80100eb5:	68 ee 6a 10 80       	push   $0x80106aee
80100eba:	e8 9d f4 ff ff       	call   8010035c <panic>
    return -1;
80100ebf:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100ec4:	eb cb                	jmp    80100e91 <fileread+0x54>

80100ec6 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ec6:	f3 0f 1e fb          	endbr32 
80100eca:	55                   	push   %ebp
80100ecb:	89 e5                	mov    %esp,%ebp
80100ecd:	57                   	push   %edi
80100ece:	56                   	push   %esi
80100ecf:	53                   	push   %ebx
80100ed0:	83 ec 1c             	sub    $0x1c,%esp
80100ed3:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;

  if(f->writable == 0)
80100ed6:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80100eda:	0f 84 cc 00 00 00    	je     80100fac <filewrite+0xe6>
    return -1;
  if(f->type == FD_PIPE)
80100ee0:	8b 06                	mov    (%esi),%eax
80100ee2:	83 f8 01             	cmp    $0x1,%eax
80100ee5:	74 10                	je     80100ef7 <filewrite+0x31>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100ee7:	83 f8 02             	cmp    $0x2,%eax
80100eea:	0f 85 af 00 00 00    	jne    80100f9f <filewrite+0xd9>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
80100ef0:	bf 00 00 00 00       	mov    $0x0,%edi
80100ef5:	eb 67                	jmp    80100f5e <filewrite+0x98>
    return pipewrite(f->pipe, addr, n);
80100ef7:	83 ec 04             	sub    $0x4,%esp
80100efa:	ff 75 10             	pushl  0x10(%ebp)
80100efd:	ff 75 0c             	pushl  0xc(%ebp)
80100f00:	ff 76 0c             	pushl  0xc(%esi)
80100f03:	e8 a7 20 00 00       	call   80102faf <pipewrite>
80100f08:	83 c4 10             	add    $0x10,%esp
80100f0b:	e9 82 00 00 00       	jmp    80100f92 <filewrite+0xcc>
    while(i < n){
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
80100f10:	e8 77 19 00 00       	call   8010288c <begin_op>
      ilock(f->ip);
80100f15:	83 ec 0c             	sub    $0xc,%esp
80100f18:	ff 76 10             	pushl  0x10(%esi)
80100f1b:	e8 e7 06 00 00       	call   80101607 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100f20:	ff 75 e4             	pushl  -0x1c(%ebp)
80100f23:	ff 76 14             	pushl  0x14(%esi)
80100f26:	89 f8                	mov    %edi,%eax
80100f28:	03 45 0c             	add    0xc(%ebp),%eax
80100f2b:	50                   	push   %eax
80100f2c:	ff 76 10             	pushl  0x10(%esi)
80100f2f:	e8 da 09 00 00       	call   8010190e <writei>
80100f34:	89 c3                	mov    %eax,%ebx
80100f36:	83 c4 20             	add    $0x20,%esp
80100f39:	85 c0                	test   %eax,%eax
80100f3b:	7e 03                	jle    80100f40 <filewrite+0x7a>
        f->off += r;
80100f3d:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80100f40:	83 ec 0c             	sub    $0xc,%esp
80100f43:	ff 76 10             	pushl  0x10(%esi)
80100f46:	e8 82 07 00 00       	call   801016cd <iunlock>
      end_op();
80100f4b:	e8 ba 19 00 00       	call   8010290a <end_op>

      if(r < 0)
80100f50:	83 c4 10             	add    $0x10,%esp
80100f53:	85 db                	test   %ebx,%ebx
80100f55:	78 31                	js     80100f88 <filewrite+0xc2>
        break;
      if(r != n1)
80100f57:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80100f5a:	75 1f                	jne    80100f7b <filewrite+0xb5>
        panic("short filewrite");
      i += r;
80100f5c:	01 df                	add    %ebx,%edi
    while(i < n){
80100f5e:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100f61:	7d 25                	jge    80100f88 <filewrite+0xc2>
      int n1 = n - i;
80100f63:	8b 45 10             	mov    0x10(%ebp),%eax
80100f66:	29 f8                	sub    %edi,%eax
80100f68:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(n1 > max)
80100f6b:	3d 00 06 00 00       	cmp    $0x600,%eax
80100f70:	7e 9e                	jle    80100f10 <filewrite+0x4a>
        n1 = max;
80100f72:	c7 45 e4 00 06 00 00 	movl   $0x600,-0x1c(%ebp)
80100f79:	eb 95                	jmp    80100f10 <filewrite+0x4a>
        panic("short filewrite");
80100f7b:	83 ec 0c             	sub    $0xc,%esp
80100f7e:	68 f7 6a 10 80       	push   $0x80106af7
80100f83:	e8 d4 f3 ff ff       	call   8010035c <panic>
    }
    return i == n ? n : -1;
80100f88:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100f8b:	74 0d                	je     80100f9a <filewrite+0xd4>
80100f8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80100f92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f95:	5b                   	pop    %ebx
80100f96:	5e                   	pop    %esi
80100f97:	5f                   	pop    %edi
80100f98:	5d                   	pop    %ebp
80100f99:	c3                   	ret    
    return i == n ? n : -1;
80100f9a:	8b 45 10             	mov    0x10(%ebp),%eax
80100f9d:	eb f3                	jmp    80100f92 <filewrite+0xcc>
  panic("filewrite");
80100f9f:	83 ec 0c             	sub    $0xc,%esp
80100fa2:	68 fd 6a 10 80       	push   $0x80106afd
80100fa7:	e8 b0 f3 ff ff       	call   8010035c <panic>
    return -1;
80100fac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fb1:	eb df                	jmp    80100f92 <filewrite+0xcc>

80100fb3 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80100fb3:	55                   	push   %ebp
80100fb4:	89 e5                	mov    %esp,%ebp
80100fb6:	57                   	push   %edi
80100fb7:	56                   	push   %esi
80100fb8:	53                   	push   %ebx
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	89 d6                	mov    %edx,%esi
  char *s;
  int len;

  while(*path == '/')
80100fbe:	0f b6 10             	movzbl (%eax),%edx
80100fc1:	80 fa 2f             	cmp    $0x2f,%dl
80100fc4:	75 05                	jne    80100fcb <skipelem+0x18>
    path++;
80100fc6:	83 c0 01             	add    $0x1,%eax
80100fc9:	eb f3                	jmp    80100fbe <skipelem+0xb>
  if(*path == 0)
80100fcb:	84 d2                	test   %dl,%dl
80100fcd:	74 59                	je     80101028 <skipelem+0x75>
80100fcf:	89 c3                	mov    %eax,%ebx
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80100fd1:	0f b6 13             	movzbl (%ebx),%edx
80100fd4:	80 fa 2f             	cmp    $0x2f,%dl
80100fd7:	0f 95 c1             	setne  %cl
80100fda:	84 d2                	test   %dl,%dl
80100fdc:	0f 95 c2             	setne  %dl
80100fdf:	84 d1                	test   %dl,%cl
80100fe1:	74 05                	je     80100fe8 <skipelem+0x35>
    path++;
80100fe3:	83 c3 01             	add    $0x1,%ebx
80100fe6:	eb e9                	jmp    80100fd1 <skipelem+0x1e>
  len = path - s;
80100fe8:	89 df                	mov    %ebx,%edi
80100fea:	29 c7                	sub    %eax,%edi
  if(len >= DIRSIZ)
80100fec:	83 ff 0d             	cmp    $0xd,%edi
80100fef:	7e 11                	jle    80101002 <skipelem+0x4f>
    memmove(name, s, DIRSIZ);
80100ff1:	83 ec 04             	sub    $0x4,%esp
80100ff4:	6a 0e                	push   $0xe
80100ff6:	50                   	push   %eax
80100ff7:	56                   	push   %esi
80100ff8:	e8 dc 30 00 00       	call   801040d9 <memmove>
80100ffd:	83 c4 10             	add    $0x10,%esp
80101000:	eb 17                	jmp    80101019 <skipelem+0x66>
  else {
    memmove(name, s, len);
80101002:	83 ec 04             	sub    $0x4,%esp
80101005:	57                   	push   %edi
80101006:	50                   	push   %eax
80101007:	56                   	push   %esi
80101008:	e8 cc 30 00 00       	call   801040d9 <memmove>
    name[len] = 0;
8010100d:	c6 04 3e 00          	movb   $0x0,(%esi,%edi,1)
80101011:	83 c4 10             	add    $0x10,%esp
80101014:	eb 03                	jmp    80101019 <skipelem+0x66>
  }
  while(*path == '/')
    path++;
80101016:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101019:	80 3b 2f             	cmpb   $0x2f,(%ebx)
8010101c:	74 f8                	je     80101016 <skipelem+0x63>
  return path;
}
8010101e:	89 d8                	mov    %ebx,%eax
80101020:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101023:	5b                   	pop    %ebx
80101024:	5e                   	pop    %esi
80101025:	5f                   	pop    %edi
80101026:	5d                   	pop    %ebp
80101027:	c3                   	ret    
    return 0;
80101028:	bb 00 00 00 00       	mov    $0x0,%ebx
8010102d:	eb ef                	jmp    8010101e <skipelem+0x6b>

8010102f <bzero>:
{
8010102f:	55                   	push   %ebp
80101030:	89 e5                	mov    %esp,%ebp
80101032:	53                   	push   %ebx
80101033:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, bno);
80101036:	52                   	push   %edx
80101037:	50                   	push   %eax
80101038:	e8 33 f1 ff ff       	call   80100170 <bread>
8010103d:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010103f:	8d 40 5c             	lea    0x5c(%eax),%eax
80101042:	83 c4 0c             	add    $0xc,%esp
80101045:	68 00 02 00 00       	push   $0x200
8010104a:	6a 00                	push   $0x0
8010104c:	50                   	push   %eax
8010104d:	e8 07 30 00 00       	call   80104059 <memset>
  log_write(bp);
80101052:	89 1c 24             	mov    %ebx,(%esp)
80101055:	e8 63 19 00 00       	call   801029bd <log_write>
  brelse(bp);
8010105a:	89 1c 24             	mov    %ebx,(%esp)
8010105d:	e8 7f f1 ff ff       	call   801001e1 <brelse>
}
80101062:	83 c4 10             	add    $0x10,%esp
80101065:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101068:	c9                   	leave  
80101069:	c3                   	ret    

8010106a <balloc>:
{
8010106a:	55                   	push   %ebp
8010106b:	89 e5                	mov    %esp,%ebp
8010106d:	57                   	push   %edi
8010106e:	56                   	push   %esi
8010106f:	53                   	push   %ebx
80101070:	83 ec 1c             	sub    $0x1c,%esp
80101073:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101076:	be 00 00 00 00       	mov    $0x0,%esi
8010107b:	eb 14                	jmp    80101091 <balloc+0x27>
    brelse(bp);
8010107d:	83 ec 0c             	sub    $0xc,%esp
80101080:	ff 75 e4             	pushl  -0x1c(%ebp)
80101083:	e8 59 f1 ff ff       	call   801001e1 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101088:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010108e:	83 c4 10             	add    $0x10,%esp
80101091:	39 35 20 4b 11 80    	cmp    %esi,0x80114b20
80101097:	76 75                	jbe    8010110e <balloc+0xa4>
    bp = bread(dev, BBLOCK(b, sb));
80101099:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
8010109f:	85 f6                	test   %esi,%esi
801010a1:	0f 49 c6             	cmovns %esi,%eax
801010a4:	c1 f8 0c             	sar    $0xc,%eax
801010a7:	83 ec 08             	sub    $0x8,%esp
801010aa:	03 05 38 4b 11 80    	add    0x80114b38,%eax
801010b0:	50                   	push   %eax
801010b1:	ff 75 d8             	pushl  -0x28(%ebp)
801010b4:	e8 b7 f0 ff ff       	call   80100170 <bread>
801010b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801010bc:	83 c4 10             	add    $0x10,%esp
801010bf:	b8 00 00 00 00       	mov    $0x0,%eax
801010c4:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801010c9:	7f b2                	jg     8010107d <balloc+0x13>
801010cb:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
801010ce:	89 5d e0             	mov    %ebx,-0x20(%ebp)
801010d1:	3b 1d 20 4b 11 80    	cmp    0x80114b20,%ebx
801010d7:	73 a4                	jae    8010107d <balloc+0x13>
      m = 1 << (bi % 8);
801010d9:	99                   	cltd   
801010da:	c1 ea 1d             	shr    $0x1d,%edx
801010dd:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
801010e0:	83 e1 07             	and    $0x7,%ecx
801010e3:	29 d1                	sub    %edx,%ecx
801010e5:	ba 01 00 00 00       	mov    $0x1,%edx
801010ea:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801010ec:	8d 48 07             	lea    0x7(%eax),%ecx
801010ef:	85 c0                	test   %eax,%eax
801010f1:	0f 49 c8             	cmovns %eax,%ecx
801010f4:	c1 f9 03             	sar    $0x3,%ecx
801010f7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
801010fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801010fd:	0f b6 4c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%ecx
80101102:	0f b6 f9             	movzbl %cl,%edi
80101105:	85 d7                	test   %edx,%edi
80101107:	74 12                	je     8010111b <balloc+0xb1>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101109:	83 c0 01             	add    $0x1,%eax
8010110c:	eb b6                	jmp    801010c4 <balloc+0x5a>
  panic("balloc: out of blocks");
8010110e:	83 ec 0c             	sub    $0xc,%esp
80101111:	68 07 6b 10 80       	push   $0x80106b07
80101116:	e8 41 f2 ff ff       	call   8010035c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
8010111b:	09 ca                	or     %ecx,%edx
8010111d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101120:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101123:	88 54 30 5c          	mov    %dl,0x5c(%eax,%esi,1)
        log_write(bp);
80101127:	83 ec 0c             	sub    $0xc,%esp
8010112a:	89 c6                	mov    %eax,%esi
8010112c:	50                   	push   %eax
8010112d:	e8 8b 18 00 00       	call   801029bd <log_write>
        brelse(bp);
80101132:	89 34 24             	mov    %esi,(%esp)
80101135:	e8 a7 f0 ff ff       	call   801001e1 <brelse>
        bzero(dev, b + bi);
8010113a:	89 da                	mov    %ebx,%edx
8010113c:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010113f:	e8 eb fe ff ff       	call   8010102f <bzero>
}
80101144:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101147:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010114a:	5b                   	pop    %ebx
8010114b:	5e                   	pop    %esi
8010114c:	5f                   	pop    %edi
8010114d:	5d                   	pop    %ebp
8010114e:	c3                   	ret    

8010114f <bmap>:
{
8010114f:	55                   	push   %ebp
80101150:	89 e5                	mov    %esp,%ebp
80101152:	57                   	push   %edi
80101153:	56                   	push   %esi
80101154:	53                   	push   %ebx
80101155:	83 ec 1c             	sub    $0x1c,%esp
80101158:	89 c3                	mov    %eax,%ebx
8010115a:	89 d7                	mov    %edx,%edi
  if(bn < NDIRECT){
8010115c:	83 fa 0b             	cmp    $0xb,%edx
8010115f:	76 45                	jbe    801011a6 <bmap+0x57>
  bn -= NDIRECT;
80101161:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
80101164:	83 fe 7f             	cmp    $0x7f,%esi
80101167:	77 7f                	ja     801011e8 <bmap+0x99>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101169:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010116f:	85 c0                	test   %eax,%eax
80101171:	74 4a                	je     801011bd <bmap+0x6e>
    bp = bread(ip->dev, addr);
80101173:	83 ec 08             	sub    $0x8,%esp
80101176:	50                   	push   %eax
80101177:	ff 33                	pushl  (%ebx)
80101179:	e8 f2 ef ff ff       	call   80100170 <bread>
8010117e:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101180:	8d 44 b0 5c          	lea    0x5c(%eax,%esi,4),%eax
80101184:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101187:	8b 30                	mov    (%eax),%esi
80101189:	83 c4 10             	add    $0x10,%esp
8010118c:	85 f6                	test   %esi,%esi
8010118e:	74 3c                	je     801011cc <bmap+0x7d>
    brelse(bp);
80101190:	83 ec 0c             	sub    $0xc,%esp
80101193:	57                   	push   %edi
80101194:	e8 48 f0 ff ff       	call   801001e1 <brelse>
    return addr;
80101199:	83 c4 10             	add    $0x10,%esp
}
8010119c:	89 f0                	mov    %esi,%eax
8010119e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a1:	5b                   	pop    %ebx
801011a2:	5e                   	pop    %esi
801011a3:	5f                   	pop    %edi
801011a4:	5d                   	pop    %ebp
801011a5:	c3                   	ret    
    if((addr = ip->addrs[bn]) == 0)
801011a6:	8b 74 90 5c          	mov    0x5c(%eax,%edx,4),%esi
801011aa:	85 f6                	test   %esi,%esi
801011ac:	75 ee                	jne    8010119c <bmap+0x4d>
      ip->addrs[bn] = addr = balloc(ip->dev);
801011ae:	8b 00                	mov    (%eax),%eax
801011b0:	e8 b5 fe ff ff       	call   8010106a <balloc>
801011b5:	89 c6                	mov    %eax,%esi
801011b7:	89 44 bb 5c          	mov    %eax,0x5c(%ebx,%edi,4)
    return addr;
801011bb:	eb df                	jmp    8010119c <bmap+0x4d>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801011bd:	8b 03                	mov    (%ebx),%eax
801011bf:	e8 a6 fe ff ff       	call   8010106a <balloc>
801011c4:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
801011ca:	eb a7                	jmp    80101173 <bmap+0x24>
      a[bn] = addr = balloc(ip->dev);
801011cc:	8b 03                	mov    (%ebx),%eax
801011ce:	e8 97 fe ff ff       	call   8010106a <balloc>
801011d3:	89 c6                	mov    %eax,%esi
801011d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011d8:	89 30                	mov    %esi,(%eax)
      log_write(bp);
801011da:	83 ec 0c             	sub    $0xc,%esp
801011dd:	57                   	push   %edi
801011de:	e8 da 17 00 00       	call   801029bd <log_write>
801011e3:	83 c4 10             	add    $0x10,%esp
801011e6:	eb a8                	jmp    80101190 <bmap+0x41>
  panic("bmap: out of range");
801011e8:	83 ec 0c             	sub    $0xc,%esp
801011eb:	68 1d 6b 10 80       	push   $0x80106b1d
801011f0:	e8 67 f1 ff ff       	call   8010035c <panic>

801011f5 <iget>:
{
801011f5:	55                   	push   %ebp
801011f6:	89 e5                	mov    %esp,%ebp
801011f8:	57                   	push   %edi
801011f9:	56                   	push   %esi
801011fa:	53                   	push   %ebx
801011fb:	83 ec 28             	sub    $0x28,%esp
801011fe:	89 c7                	mov    %eax,%edi
80101200:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101203:	68 40 4b 11 80       	push   $0x80114b40
80101208:	e8 98 2d 00 00       	call   80103fa5 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010120d:	83 c4 10             	add    $0x10,%esp
  empty = 0;
80101210:	be 00 00 00 00       	mov    $0x0,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101215:	bb 74 4b 11 80       	mov    $0x80114b74,%ebx
8010121a:	eb 0a                	jmp    80101226 <iget+0x31>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010121c:	85 f6                	test   %esi,%esi
8010121e:	74 3b                	je     8010125b <iget+0x66>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101220:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101226:	81 fb 94 67 11 80    	cmp    $0x80116794,%ebx
8010122c:	73 35                	jae    80101263 <iget+0x6e>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010122e:	8b 43 08             	mov    0x8(%ebx),%eax
80101231:	85 c0                	test   %eax,%eax
80101233:	7e e7                	jle    8010121c <iget+0x27>
80101235:	39 3b                	cmp    %edi,(%ebx)
80101237:	75 e3                	jne    8010121c <iget+0x27>
80101239:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010123c:	39 4b 04             	cmp    %ecx,0x4(%ebx)
8010123f:	75 db                	jne    8010121c <iget+0x27>
      ip->ref++;
80101241:	83 c0 01             	add    $0x1,%eax
80101244:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101247:	83 ec 0c             	sub    $0xc,%esp
8010124a:	68 40 4b 11 80       	push   $0x80114b40
8010124f:	e8 ba 2d 00 00       	call   8010400e <release>
      return ip;
80101254:	83 c4 10             	add    $0x10,%esp
80101257:	89 de                	mov    %ebx,%esi
80101259:	eb 32                	jmp    8010128d <iget+0x98>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010125b:	85 c0                	test   %eax,%eax
8010125d:	75 c1                	jne    80101220 <iget+0x2b>
      empty = ip;
8010125f:	89 de                	mov    %ebx,%esi
80101261:	eb bd                	jmp    80101220 <iget+0x2b>
  if(empty == 0)
80101263:	85 f6                	test   %esi,%esi
80101265:	74 30                	je     80101297 <iget+0xa2>
  ip->dev = dev;
80101267:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101269:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010126c:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
8010126f:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101276:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010127d:	83 ec 0c             	sub    $0xc,%esp
80101280:	68 40 4b 11 80       	push   $0x80114b40
80101285:	e8 84 2d 00 00       	call   8010400e <release>
  return ip;
8010128a:	83 c4 10             	add    $0x10,%esp
}
8010128d:	89 f0                	mov    %esi,%eax
8010128f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101292:	5b                   	pop    %ebx
80101293:	5e                   	pop    %esi
80101294:	5f                   	pop    %edi
80101295:	5d                   	pop    %ebp
80101296:	c3                   	ret    
    panic("iget: no inodes");
80101297:	83 ec 0c             	sub    $0xc,%esp
8010129a:	68 30 6b 10 80       	push   $0x80106b30
8010129f:	e8 b8 f0 ff ff       	call   8010035c <panic>

801012a4 <readsb>:
{
801012a4:	f3 0f 1e fb          	endbr32 
801012a8:	55                   	push   %ebp
801012a9:	89 e5                	mov    %esp,%ebp
801012ab:	53                   	push   %ebx
801012ac:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, 1);
801012af:	6a 01                	push   $0x1
801012b1:	ff 75 08             	pushl  0x8(%ebp)
801012b4:	e8 b7 ee ff ff       	call   80100170 <bread>
801012b9:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801012bb:	8d 40 5c             	lea    0x5c(%eax),%eax
801012be:	83 c4 0c             	add    $0xc,%esp
801012c1:	6a 1c                	push   $0x1c
801012c3:	50                   	push   %eax
801012c4:	ff 75 0c             	pushl  0xc(%ebp)
801012c7:	e8 0d 2e 00 00       	call   801040d9 <memmove>
  brelse(bp);
801012cc:	89 1c 24             	mov    %ebx,(%esp)
801012cf:	e8 0d ef ff ff       	call   801001e1 <brelse>
}
801012d4:	83 c4 10             	add    $0x10,%esp
801012d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801012da:	c9                   	leave  
801012db:	c3                   	ret    

801012dc <bfree>:
{
801012dc:	55                   	push   %ebp
801012dd:	89 e5                	mov    %esp,%ebp
801012df:	57                   	push   %edi
801012e0:	56                   	push   %esi
801012e1:	53                   	push   %ebx
801012e2:	83 ec 14             	sub    $0x14,%esp
801012e5:	89 c3                	mov    %eax,%ebx
801012e7:	89 d6                	mov    %edx,%esi
  readsb(dev, &sb);
801012e9:	68 20 4b 11 80       	push   $0x80114b20
801012ee:	50                   	push   %eax
801012ef:	e8 b0 ff ff ff       	call   801012a4 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801012f4:	89 f0                	mov    %esi,%eax
801012f6:	c1 e8 0c             	shr    $0xc,%eax
801012f9:	83 c4 08             	add    $0x8,%esp
801012fc:	03 05 38 4b 11 80    	add    0x80114b38,%eax
80101302:	50                   	push   %eax
80101303:	53                   	push   %ebx
80101304:	e8 67 ee ff ff       	call   80100170 <bread>
80101309:	89 c3                	mov    %eax,%ebx
  bi = b % BPB;
8010130b:	89 f7                	mov    %esi,%edi
8010130d:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
  m = 1 << (bi % 8);
80101313:	89 f1                	mov    %esi,%ecx
80101315:	83 e1 07             	and    $0x7,%ecx
80101318:	b8 01 00 00 00       	mov    $0x1,%eax
8010131d:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
8010131f:	83 c4 10             	add    $0x10,%esp
80101322:	c1 ff 03             	sar    $0x3,%edi
80101325:	0f b6 54 3b 5c       	movzbl 0x5c(%ebx,%edi,1),%edx
8010132a:	0f b6 ca             	movzbl %dl,%ecx
8010132d:	85 c1                	test   %eax,%ecx
8010132f:	74 24                	je     80101355 <bfree+0x79>
  bp->data[bi/8] &= ~m;
80101331:	f7 d0                	not    %eax
80101333:	21 d0                	and    %edx,%eax
80101335:	88 44 3b 5c          	mov    %al,0x5c(%ebx,%edi,1)
  log_write(bp);
80101339:	83 ec 0c             	sub    $0xc,%esp
8010133c:	53                   	push   %ebx
8010133d:	e8 7b 16 00 00       	call   801029bd <log_write>
  brelse(bp);
80101342:	89 1c 24             	mov    %ebx,(%esp)
80101345:	e8 97 ee ff ff       	call   801001e1 <brelse>
}
8010134a:	83 c4 10             	add    $0x10,%esp
8010134d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101350:	5b                   	pop    %ebx
80101351:	5e                   	pop    %esi
80101352:	5f                   	pop    %edi
80101353:	5d                   	pop    %ebp
80101354:	c3                   	ret    
    panic("freeing free block");
80101355:	83 ec 0c             	sub    $0xc,%esp
80101358:	68 40 6b 10 80       	push   $0x80106b40
8010135d:	e8 fa ef ff ff       	call   8010035c <panic>

80101362 <iinit>:
{
80101362:	f3 0f 1e fb          	endbr32 
80101366:	55                   	push   %ebp
80101367:	89 e5                	mov    %esp,%ebp
80101369:	53                   	push   %ebx
8010136a:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010136d:	68 53 6b 10 80       	push   $0x80106b53
80101372:	68 40 4b 11 80       	push   $0x80114b40
80101377:	e8 d9 2a 00 00       	call   80103e55 <initlock>
  for(i = 0; i < NINODE; i++) {
8010137c:	83 c4 10             	add    $0x10,%esp
8010137f:	bb 00 00 00 00       	mov    $0x0,%ebx
80101384:	83 fb 31             	cmp    $0x31,%ebx
80101387:	7f 23                	jg     801013ac <iinit+0x4a>
    initsleeplock(&icache.inode[i].lock, "inode");
80101389:	83 ec 08             	sub    $0x8,%esp
8010138c:	68 5a 6b 10 80       	push   $0x80106b5a
80101391:	8d 14 db             	lea    (%ebx,%ebx,8),%edx
80101394:	89 d0                	mov    %edx,%eax
80101396:	c1 e0 04             	shl    $0x4,%eax
80101399:	05 80 4b 11 80       	add    $0x80114b80,%eax
8010139e:	50                   	push   %eax
8010139f:	e8 bd 29 00 00       	call   80103d61 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801013a4:	83 c3 01             	add    $0x1,%ebx
801013a7:	83 c4 10             	add    $0x10,%esp
801013aa:	eb d8                	jmp    80101384 <iinit+0x22>
  readsb(dev, &sb);
801013ac:	83 ec 08             	sub    $0x8,%esp
801013af:	68 20 4b 11 80       	push   $0x80114b20
801013b4:	ff 75 08             	pushl  0x8(%ebp)
801013b7:	e8 e8 fe ff ff       	call   801012a4 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801013bc:	ff 35 38 4b 11 80    	pushl  0x80114b38
801013c2:	ff 35 34 4b 11 80    	pushl  0x80114b34
801013c8:	ff 35 30 4b 11 80    	pushl  0x80114b30
801013ce:	ff 35 2c 4b 11 80    	pushl  0x80114b2c
801013d4:	ff 35 28 4b 11 80    	pushl  0x80114b28
801013da:	ff 35 24 4b 11 80    	pushl  0x80114b24
801013e0:	ff 35 20 4b 11 80    	pushl  0x80114b20
801013e6:	68 c0 6b 10 80       	push   $0x80106bc0
801013eb:	e8 39 f2 ff ff       	call   80100629 <cprintf>
}
801013f0:	83 c4 30             	add    $0x30,%esp
801013f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013f6:	c9                   	leave  
801013f7:	c3                   	ret    

801013f8 <ialloc>:
{
801013f8:	f3 0f 1e fb          	endbr32 
801013fc:	55                   	push   %ebp
801013fd:	89 e5                	mov    %esp,%ebp
801013ff:	57                   	push   %edi
80101400:	56                   	push   %esi
80101401:	53                   	push   %ebx
80101402:	83 ec 1c             	sub    $0x1c,%esp
80101405:	8b 45 0c             	mov    0xc(%ebp),%eax
80101408:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010140b:	bb 01 00 00 00       	mov    $0x1,%ebx
80101410:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101413:	39 1d 28 4b 11 80    	cmp    %ebx,0x80114b28
80101419:	76 76                	jbe    80101491 <ialloc+0x99>
    bp = bread(dev, IBLOCK(inum, sb));
8010141b:	89 d8                	mov    %ebx,%eax
8010141d:	c1 e8 03             	shr    $0x3,%eax
80101420:	83 ec 08             	sub    $0x8,%esp
80101423:	03 05 34 4b 11 80    	add    0x80114b34,%eax
80101429:	50                   	push   %eax
8010142a:	ff 75 08             	pushl  0x8(%ebp)
8010142d:	e8 3e ed ff ff       	call   80100170 <bread>
80101432:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
80101434:	89 d8                	mov    %ebx,%eax
80101436:	83 e0 07             	and    $0x7,%eax
80101439:	c1 e0 06             	shl    $0x6,%eax
8010143c:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
80101440:	83 c4 10             	add    $0x10,%esp
80101443:	66 83 3f 00          	cmpw   $0x0,(%edi)
80101447:	74 11                	je     8010145a <ialloc+0x62>
    brelse(bp);
80101449:	83 ec 0c             	sub    $0xc,%esp
8010144c:	56                   	push   %esi
8010144d:	e8 8f ed ff ff       	call   801001e1 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101452:	83 c3 01             	add    $0x1,%ebx
80101455:	83 c4 10             	add    $0x10,%esp
80101458:	eb b6                	jmp    80101410 <ialloc+0x18>
      memset(dip, 0, sizeof(*dip));
8010145a:	83 ec 04             	sub    $0x4,%esp
8010145d:	6a 40                	push   $0x40
8010145f:	6a 00                	push   $0x0
80101461:	57                   	push   %edi
80101462:	e8 f2 2b 00 00       	call   80104059 <memset>
      dip->type = type;
80101467:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010146b:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
8010146e:	89 34 24             	mov    %esi,(%esp)
80101471:	e8 47 15 00 00       	call   801029bd <log_write>
      brelse(bp);
80101476:	89 34 24             	mov    %esi,(%esp)
80101479:	e8 63 ed ff ff       	call   801001e1 <brelse>
      return iget(dev, inum);
8010147e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101481:	8b 45 08             	mov    0x8(%ebp),%eax
80101484:	e8 6c fd ff ff       	call   801011f5 <iget>
}
80101489:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010148c:	5b                   	pop    %ebx
8010148d:	5e                   	pop    %esi
8010148e:	5f                   	pop    %edi
8010148f:	5d                   	pop    %ebp
80101490:	c3                   	ret    
  panic("ialloc: no inodes");
80101491:	83 ec 0c             	sub    $0xc,%esp
80101494:	68 60 6b 10 80       	push   $0x80106b60
80101499:	e8 be ee ff ff       	call   8010035c <panic>

8010149e <iupdate>:
{
8010149e:	f3 0f 1e fb          	endbr32 
801014a2:	55                   	push   %ebp
801014a3:	89 e5                	mov    %esp,%ebp
801014a5:	56                   	push   %esi
801014a6:	53                   	push   %ebx
801014a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801014aa:	8b 43 04             	mov    0x4(%ebx),%eax
801014ad:	c1 e8 03             	shr    $0x3,%eax
801014b0:	83 ec 08             	sub    $0x8,%esp
801014b3:	03 05 34 4b 11 80    	add    0x80114b34,%eax
801014b9:	50                   	push   %eax
801014ba:	ff 33                	pushl  (%ebx)
801014bc:	e8 af ec ff ff       	call   80100170 <bread>
801014c1:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801014c3:	8b 43 04             	mov    0x4(%ebx),%eax
801014c6:	83 e0 07             	and    $0x7,%eax
801014c9:	c1 e0 06             	shl    $0x6,%eax
801014cc:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801014d0:	0f b7 53 50          	movzwl 0x50(%ebx),%edx
801014d4:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801014d7:	0f b7 53 52          	movzwl 0x52(%ebx),%edx
801014db:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801014df:	0f b7 53 54          	movzwl 0x54(%ebx),%edx
801014e3:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801014e7:	0f b7 53 56          	movzwl 0x56(%ebx),%edx
801014eb:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801014ef:	8b 53 58             	mov    0x58(%ebx),%edx
801014f2:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801014f5:	83 c3 5c             	add    $0x5c,%ebx
801014f8:	83 c0 0c             	add    $0xc,%eax
801014fb:	83 c4 0c             	add    $0xc,%esp
801014fe:	6a 34                	push   $0x34
80101500:	53                   	push   %ebx
80101501:	50                   	push   %eax
80101502:	e8 d2 2b 00 00       	call   801040d9 <memmove>
  log_write(bp);
80101507:	89 34 24             	mov    %esi,(%esp)
8010150a:	e8 ae 14 00 00       	call   801029bd <log_write>
  brelse(bp);
8010150f:	89 34 24             	mov    %esi,(%esp)
80101512:	e8 ca ec ff ff       	call   801001e1 <brelse>
}
80101517:	83 c4 10             	add    $0x10,%esp
8010151a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010151d:	5b                   	pop    %ebx
8010151e:	5e                   	pop    %esi
8010151f:	5d                   	pop    %ebp
80101520:	c3                   	ret    

80101521 <itrunc>:
{
80101521:	55                   	push   %ebp
80101522:	89 e5                	mov    %esp,%ebp
80101524:	57                   	push   %edi
80101525:	56                   	push   %esi
80101526:	53                   	push   %ebx
80101527:	83 ec 1c             	sub    $0x1c,%esp
8010152a:	89 c6                	mov    %eax,%esi
  for(i = 0; i < NDIRECT; i++){
8010152c:	bb 00 00 00 00       	mov    $0x0,%ebx
80101531:	eb 03                	jmp    80101536 <itrunc+0x15>
80101533:	83 c3 01             	add    $0x1,%ebx
80101536:	83 fb 0b             	cmp    $0xb,%ebx
80101539:	7f 19                	jg     80101554 <itrunc+0x33>
    if(ip->addrs[i]){
8010153b:	8b 54 9e 5c          	mov    0x5c(%esi,%ebx,4),%edx
8010153f:	85 d2                	test   %edx,%edx
80101541:	74 f0                	je     80101533 <itrunc+0x12>
      bfree(ip->dev, ip->addrs[i]);
80101543:	8b 06                	mov    (%esi),%eax
80101545:	e8 92 fd ff ff       	call   801012dc <bfree>
      ip->addrs[i] = 0;
8010154a:	c7 44 9e 5c 00 00 00 	movl   $0x0,0x5c(%esi,%ebx,4)
80101551:	00 
80101552:	eb df                	jmp    80101533 <itrunc+0x12>
  if(ip->addrs[NDIRECT]){
80101554:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
8010155a:	85 c0                	test   %eax,%eax
8010155c:	75 1b                	jne    80101579 <itrunc+0x58>
  ip->size = 0;
8010155e:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101565:	83 ec 0c             	sub    $0xc,%esp
80101568:	56                   	push   %esi
80101569:	e8 30 ff ff ff       	call   8010149e <iupdate>
}
8010156e:	83 c4 10             	add    $0x10,%esp
80101571:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101574:	5b                   	pop    %ebx
80101575:	5e                   	pop    %esi
80101576:	5f                   	pop    %edi
80101577:	5d                   	pop    %ebp
80101578:	c3                   	ret    
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101579:	83 ec 08             	sub    $0x8,%esp
8010157c:	50                   	push   %eax
8010157d:	ff 36                	pushl  (%esi)
8010157f:	e8 ec eb ff ff       	call   80100170 <bread>
80101584:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101587:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
8010158a:	83 c4 10             	add    $0x10,%esp
8010158d:	bb 00 00 00 00       	mov    $0x0,%ebx
80101592:	eb 0a                	jmp    8010159e <itrunc+0x7d>
        bfree(ip->dev, a[j]);
80101594:	8b 06                	mov    (%esi),%eax
80101596:	e8 41 fd ff ff       	call   801012dc <bfree>
    for(j = 0; j < NINDIRECT; j++){
8010159b:	83 c3 01             	add    $0x1,%ebx
8010159e:	83 fb 7f             	cmp    $0x7f,%ebx
801015a1:	77 09                	ja     801015ac <itrunc+0x8b>
      if(a[j])
801015a3:	8b 14 9f             	mov    (%edi,%ebx,4),%edx
801015a6:	85 d2                	test   %edx,%edx
801015a8:	74 f1                	je     8010159b <itrunc+0x7a>
801015aa:	eb e8                	jmp    80101594 <itrunc+0x73>
    brelse(bp);
801015ac:	83 ec 0c             	sub    $0xc,%esp
801015af:	ff 75 e4             	pushl  -0x1c(%ebp)
801015b2:	e8 2a ec ff ff       	call   801001e1 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801015b7:	8b 06                	mov    (%esi),%eax
801015b9:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801015bf:	e8 18 fd ff ff       	call   801012dc <bfree>
    ip->addrs[NDIRECT] = 0;
801015c4:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801015cb:	00 00 00 
801015ce:	83 c4 10             	add    $0x10,%esp
801015d1:	eb 8b                	jmp    8010155e <itrunc+0x3d>

801015d3 <idup>:
{
801015d3:	f3 0f 1e fb          	endbr32 
801015d7:	55                   	push   %ebp
801015d8:	89 e5                	mov    %esp,%ebp
801015da:	53                   	push   %ebx
801015db:	83 ec 10             	sub    $0x10,%esp
801015de:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801015e1:	68 40 4b 11 80       	push   $0x80114b40
801015e6:	e8 ba 29 00 00       	call   80103fa5 <acquire>
  ip->ref++;
801015eb:	8b 43 08             	mov    0x8(%ebx),%eax
801015ee:	83 c0 01             	add    $0x1,%eax
801015f1:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
801015f4:	c7 04 24 40 4b 11 80 	movl   $0x80114b40,(%esp)
801015fb:	e8 0e 2a 00 00       	call   8010400e <release>
}
80101600:	89 d8                	mov    %ebx,%eax
80101602:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101605:	c9                   	leave  
80101606:	c3                   	ret    

80101607 <ilock>:
{
80101607:	f3 0f 1e fb          	endbr32 
8010160b:	55                   	push   %ebp
8010160c:	89 e5                	mov    %esp,%ebp
8010160e:	56                   	push   %esi
8010160f:	53                   	push   %ebx
80101610:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101613:	85 db                	test   %ebx,%ebx
80101615:	74 22                	je     80101639 <ilock+0x32>
80101617:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
8010161b:	7e 1c                	jle    80101639 <ilock+0x32>
  acquiresleep(&ip->lock);
8010161d:	83 ec 0c             	sub    $0xc,%esp
80101620:	8d 43 0c             	lea    0xc(%ebx),%eax
80101623:	50                   	push   %eax
80101624:	e8 6f 27 00 00       	call   80103d98 <acquiresleep>
  if(ip->valid == 0){
80101629:	83 c4 10             	add    $0x10,%esp
8010162c:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80101630:	74 14                	je     80101646 <ilock+0x3f>
}
80101632:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101635:	5b                   	pop    %ebx
80101636:	5e                   	pop    %esi
80101637:	5d                   	pop    %ebp
80101638:	c3                   	ret    
    panic("ilock");
80101639:	83 ec 0c             	sub    $0xc,%esp
8010163c:	68 72 6b 10 80       	push   $0x80106b72
80101641:	e8 16 ed ff ff       	call   8010035c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101646:	8b 43 04             	mov    0x4(%ebx),%eax
80101649:	c1 e8 03             	shr    $0x3,%eax
8010164c:	83 ec 08             	sub    $0x8,%esp
8010164f:	03 05 34 4b 11 80    	add    0x80114b34,%eax
80101655:	50                   	push   %eax
80101656:	ff 33                	pushl  (%ebx)
80101658:	e8 13 eb ff ff       	call   80100170 <bread>
8010165d:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010165f:	8b 43 04             	mov    0x4(%ebx),%eax
80101662:	83 e0 07             	and    $0x7,%eax
80101665:	c1 e0 06             	shl    $0x6,%eax
80101668:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
8010166c:	0f b7 10             	movzwl (%eax),%edx
8010166f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101673:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101677:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010167b:	0f b7 50 04          	movzwl 0x4(%eax),%edx
8010167f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101683:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101687:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010168b:	8b 50 08             	mov    0x8(%eax),%edx
8010168e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101691:	83 c0 0c             	add    $0xc,%eax
80101694:	8d 53 5c             	lea    0x5c(%ebx),%edx
80101697:	83 c4 0c             	add    $0xc,%esp
8010169a:	6a 34                	push   $0x34
8010169c:	50                   	push   %eax
8010169d:	52                   	push   %edx
8010169e:	e8 36 2a 00 00       	call   801040d9 <memmove>
    brelse(bp);
801016a3:	89 34 24             	mov    %esi,(%esp)
801016a6:	e8 36 eb ff ff       	call   801001e1 <brelse>
    ip->valid = 1;
801016ab:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801016b2:	83 c4 10             	add    $0x10,%esp
801016b5:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
801016ba:	0f 85 72 ff ff ff    	jne    80101632 <ilock+0x2b>
      panic("ilock: no type");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 78 6b 10 80       	push   $0x80106b78
801016c8:	e8 8f ec ff ff       	call   8010035c <panic>

801016cd <iunlock>:
{
801016cd:	f3 0f 1e fb          	endbr32 
801016d1:	55                   	push   %ebp
801016d2:	89 e5                	mov    %esp,%ebp
801016d4:	56                   	push   %esi
801016d5:	53                   	push   %ebx
801016d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801016d9:	85 db                	test   %ebx,%ebx
801016db:	74 2c                	je     80101709 <iunlock+0x3c>
801016dd:	8d 73 0c             	lea    0xc(%ebx),%esi
801016e0:	83 ec 0c             	sub    $0xc,%esp
801016e3:	56                   	push   %esi
801016e4:	e8 41 27 00 00       	call   80103e2a <holdingsleep>
801016e9:	83 c4 10             	add    $0x10,%esp
801016ec:	85 c0                	test   %eax,%eax
801016ee:	74 19                	je     80101709 <iunlock+0x3c>
801016f0:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
801016f4:	7e 13                	jle    80101709 <iunlock+0x3c>
  releasesleep(&ip->lock);
801016f6:	83 ec 0c             	sub    $0xc,%esp
801016f9:	56                   	push   %esi
801016fa:	e8 ec 26 00 00       	call   80103deb <releasesleep>
}
801016ff:	83 c4 10             	add    $0x10,%esp
80101702:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101705:	5b                   	pop    %ebx
80101706:	5e                   	pop    %esi
80101707:	5d                   	pop    %ebp
80101708:	c3                   	ret    
    panic("iunlock");
80101709:	83 ec 0c             	sub    $0xc,%esp
8010170c:	68 87 6b 10 80       	push   $0x80106b87
80101711:	e8 46 ec ff ff       	call   8010035c <panic>

80101716 <iput>:
{
80101716:	f3 0f 1e fb          	endbr32 
8010171a:	55                   	push   %ebp
8010171b:	89 e5                	mov    %esp,%ebp
8010171d:	57                   	push   %edi
8010171e:	56                   	push   %esi
8010171f:	53                   	push   %ebx
80101720:	83 ec 18             	sub    $0x18,%esp
80101723:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101726:	8d 73 0c             	lea    0xc(%ebx),%esi
80101729:	56                   	push   %esi
8010172a:	e8 69 26 00 00       	call   80103d98 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
8010172f:	83 c4 10             	add    $0x10,%esp
80101732:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80101736:	74 07                	je     8010173f <iput+0x29>
80101738:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010173d:	74 35                	je     80101774 <iput+0x5e>
  releasesleep(&ip->lock);
8010173f:	83 ec 0c             	sub    $0xc,%esp
80101742:	56                   	push   %esi
80101743:	e8 a3 26 00 00       	call   80103deb <releasesleep>
  acquire(&icache.lock);
80101748:	c7 04 24 40 4b 11 80 	movl   $0x80114b40,(%esp)
8010174f:	e8 51 28 00 00       	call   80103fa5 <acquire>
  ip->ref--;
80101754:	8b 43 08             	mov    0x8(%ebx),%eax
80101757:	83 e8 01             	sub    $0x1,%eax
8010175a:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
8010175d:	c7 04 24 40 4b 11 80 	movl   $0x80114b40,(%esp)
80101764:	e8 a5 28 00 00       	call   8010400e <release>
}
80101769:	83 c4 10             	add    $0x10,%esp
8010176c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010176f:	5b                   	pop    %ebx
80101770:	5e                   	pop    %esi
80101771:	5f                   	pop    %edi
80101772:	5d                   	pop    %ebp
80101773:	c3                   	ret    
    acquire(&icache.lock);
80101774:	83 ec 0c             	sub    $0xc,%esp
80101777:	68 40 4b 11 80       	push   $0x80114b40
8010177c:	e8 24 28 00 00       	call   80103fa5 <acquire>
    int r = ip->ref;
80101781:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
80101784:	c7 04 24 40 4b 11 80 	movl   $0x80114b40,(%esp)
8010178b:	e8 7e 28 00 00       	call   8010400e <release>
    if(r == 1){
80101790:	83 c4 10             	add    $0x10,%esp
80101793:	83 ff 01             	cmp    $0x1,%edi
80101796:	75 a7                	jne    8010173f <iput+0x29>
      itrunc(ip);
80101798:	89 d8                	mov    %ebx,%eax
8010179a:	e8 82 fd ff ff       	call   80101521 <itrunc>
      ip->type = 0;
8010179f:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
801017a5:	83 ec 0c             	sub    $0xc,%esp
801017a8:	53                   	push   %ebx
801017a9:	e8 f0 fc ff ff       	call   8010149e <iupdate>
      ip->valid = 0;
801017ae:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801017b5:	83 c4 10             	add    $0x10,%esp
801017b8:	eb 85                	jmp    8010173f <iput+0x29>

801017ba <iunlockput>:
{
801017ba:	f3 0f 1e fb          	endbr32 
801017be:	55                   	push   %ebp
801017bf:	89 e5                	mov    %esp,%ebp
801017c1:	53                   	push   %ebx
801017c2:	83 ec 10             	sub    $0x10,%esp
801017c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801017c8:	53                   	push   %ebx
801017c9:	e8 ff fe ff ff       	call   801016cd <iunlock>
  iput(ip);
801017ce:	89 1c 24             	mov    %ebx,(%esp)
801017d1:	e8 40 ff ff ff       	call   80101716 <iput>
}
801017d6:	83 c4 10             	add    $0x10,%esp
801017d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017dc:	c9                   	leave  
801017dd:	c3                   	ret    

801017de <stati>:
{
801017de:	f3 0f 1e fb          	endbr32 
801017e2:	55                   	push   %ebp
801017e3:	89 e5                	mov    %esp,%ebp
801017e5:	8b 55 08             	mov    0x8(%ebp),%edx
801017e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801017eb:	8b 0a                	mov    (%edx),%ecx
801017ed:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801017f0:	8b 4a 04             	mov    0x4(%edx),%ecx
801017f3:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801017f6:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801017fa:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801017fd:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101801:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101805:	8b 52 58             	mov    0x58(%edx),%edx
80101808:	89 50 10             	mov    %edx,0x10(%eax)
}
8010180b:	5d                   	pop    %ebp
8010180c:	c3                   	ret    

8010180d <readi>:
{
8010180d:	f3 0f 1e fb          	endbr32 
80101811:	55                   	push   %ebp
80101812:	89 e5                	mov    %esp,%ebp
80101814:	57                   	push   %edi
80101815:	56                   	push   %esi
80101816:	53                   	push   %ebx
80101817:	83 ec 1c             	sub    $0x1c,%esp
8010181a:	8b 75 10             	mov    0x10(%ebp),%esi
  if(ip->type == T_DEV){
8010181d:	8b 45 08             	mov    0x8(%ebp),%eax
80101820:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101825:	74 2c                	je     80101853 <readi+0x46>
  if(off > ip->size || off + n < off)
80101827:	8b 45 08             	mov    0x8(%ebp),%eax
8010182a:	8b 40 58             	mov    0x58(%eax),%eax
8010182d:	39 f0                	cmp    %esi,%eax
8010182f:	0f 82 cb 00 00 00    	jb     80101900 <readi+0xf3>
80101835:	89 f2                	mov    %esi,%edx
80101837:	03 55 14             	add    0x14(%ebp),%edx
8010183a:	0f 82 c7 00 00 00    	jb     80101907 <readi+0xfa>
  if(off + n > ip->size)
80101840:	39 d0                	cmp    %edx,%eax
80101842:	73 05                	jae    80101849 <readi+0x3c>
    n = ip->size - off;
80101844:	29 f0                	sub    %esi,%eax
80101846:	89 45 14             	mov    %eax,0x14(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101849:	bf 00 00 00 00       	mov    $0x0,%edi
8010184e:	e9 8f 00 00 00       	jmp    801018e2 <readi+0xd5>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101853:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101857:	66 83 f8 09          	cmp    $0x9,%ax
8010185b:	0f 87 91 00 00 00    	ja     801018f2 <readi+0xe5>
80101861:	98                   	cwtl   
80101862:	8b 04 c5 c0 4a 11 80 	mov    -0x7feeb540(,%eax,8),%eax
80101869:	85 c0                	test   %eax,%eax
8010186b:	0f 84 88 00 00 00    	je     801018f9 <readi+0xec>
    return devsw[ip->major].read(ip, dst, n);
80101871:	83 ec 04             	sub    $0x4,%esp
80101874:	ff 75 14             	pushl  0x14(%ebp)
80101877:	ff 75 0c             	pushl  0xc(%ebp)
8010187a:	ff 75 08             	pushl  0x8(%ebp)
8010187d:	ff d0                	call   *%eax
8010187f:	83 c4 10             	add    $0x10,%esp
80101882:	eb 66                	jmp    801018ea <readi+0xdd>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101884:	89 f2                	mov    %esi,%edx
80101886:	c1 ea 09             	shr    $0x9,%edx
80101889:	8b 45 08             	mov    0x8(%ebp),%eax
8010188c:	e8 be f8 ff ff       	call   8010114f <bmap>
80101891:	83 ec 08             	sub    $0x8,%esp
80101894:	50                   	push   %eax
80101895:	8b 45 08             	mov    0x8(%ebp),%eax
80101898:	ff 30                	pushl  (%eax)
8010189a:	e8 d1 e8 ff ff       	call   80100170 <bread>
8010189f:	89 c1                	mov    %eax,%ecx
    m = min(n - tot, BSIZE - off%BSIZE);
801018a1:	89 f0                	mov    %esi,%eax
801018a3:	25 ff 01 00 00       	and    $0x1ff,%eax
801018a8:	bb 00 02 00 00       	mov    $0x200,%ebx
801018ad:	29 c3                	sub    %eax,%ebx
801018af:	8b 55 14             	mov    0x14(%ebp),%edx
801018b2:	29 fa                	sub    %edi,%edx
801018b4:	83 c4 0c             	add    $0xc,%esp
801018b7:	39 d3                	cmp    %edx,%ebx
801018b9:	0f 47 da             	cmova  %edx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801018bc:	53                   	push   %ebx
801018bd:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801018c0:	8d 44 01 5c          	lea    0x5c(%ecx,%eax,1),%eax
801018c4:	50                   	push   %eax
801018c5:	ff 75 0c             	pushl  0xc(%ebp)
801018c8:	e8 0c 28 00 00       	call   801040d9 <memmove>
    brelse(bp);
801018cd:	83 c4 04             	add    $0x4,%esp
801018d0:	ff 75 e4             	pushl  -0x1c(%ebp)
801018d3:	e8 09 e9 ff ff       	call   801001e1 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801018d8:	01 df                	add    %ebx,%edi
801018da:	01 de                	add    %ebx,%esi
801018dc:	01 5d 0c             	add    %ebx,0xc(%ebp)
801018df:	83 c4 10             	add    $0x10,%esp
801018e2:	39 7d 14             	cmp    %edi,0x14(%ebp)
801018e5:	77 9d                	ja     80101884 <readi+0x77>
  return n;
801018e7:	8b 45 14             	mov    0x14(%ebp),%eax
}
801018ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018ed:	5b                   	pop    %ebx
801018ee:	5e                   	pop    %esi
801018ef:	5f                   	pop    %edi
801018f0:	5d                   	pop    %ebp
801018f1:	c3                   	ret    
      return -1;
801018f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018f7:	eb f1                	jmp    801018ea <readi+0xdd>
801018f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018fe:	eb ea                	jmp    801018ea <readi+0xdd>
    return -1;
80101900:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101905:	eb e3                	jmp    801018ea <readi+0xdd>
80101907:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010190c:	eb dc                	jmp    801018ea <readi+0xdd>

8010190e <writei>:
{
8010190e:	f3 0f 1e fb          	endbr32 
80101912:	55                   	push   %ebp
80101913:	89 e5                	mov    %esp,%ebp
80101915:	57                   	push   %edi
80101916:	56                   	push   %esi
80101917:	53                   	push   %ebx
80101918:	83 ec 1c             	sub    $0x1c,%esp
8010191b:	8b 75 10             	mov    0x10(%ebp),%esi
  if(ip->type == T_DEV){
8010191e:	8b 45 08             	mov    0x8(%ebp),%eax
80101921:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101926:	0f 84 9b 00 00 00    	je     801019c7 <writei+0xb9>
  if(off > ip->size || off + n < off)
8010192c:	8b 45 08             	mov    0x8(%ebp),%eax
8010192f:	39 70 58             	cmp    %esi,0x58(%eax)
80101932:	0f 82 f0 00 00 00    	jb     80101a28 <writei+0x11a>
80101938:	89 f0                	mov    %esi,%eax
8010193a:	03 45 14             	add    0x14(%ebp),%eax
8010193d:	0f 82 ec 00 00 00    	jb     80101a2f <writei+0x121>
  if(off + n > MAXFILE*BSIZE)
80101943:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101948:	0f 87 e8 00 00 00    	ja     80101a36 <writei+0x128>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010194e:	bf 00 00 00 00       	mov    $0x0,%edi
80101953:	3b 7d 14             	cmp    0x14(%ebp),%edi
80101956:	0f 83 94 00 00 00    	jae    801019f0 <writei+0xe2>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010195c:	89 f2                	mov    %esi,%edx
8010195e:	c1 ea 09             	shr    $0x9,%edx
80101961:	8b 45 08             	mov    0x8(%ebp),%eax
80101964:	e8 e6 f7 ff ff       	call   8010114f <bmap>
80101969:	83 ec 08             	sub    $0x8,%esp
8010196c:	50                   	push   %eax
8010196d:	8b 45 08             	mov    0x8(%ebp),%eax
80101970:	ff 30                	pushl  (%eax)
80101972:	e8 f9 e7 ff ff       	call   80100170 <bread>
80101977:	89 c1                	mov    %eax,%ecx
    m = min(n - tot, BSIZE - off%BSIZE);
80101979:	89 f0                	mov    %esi,%eax
8010197b:	25 ff 01 00 00       	and    $0x1ff,%eax
80101980:	bb 00 02 00 00       	mov    $0x200,%ebx
80101985:	29 c3                	sub    %eax,%ebx
80101987:	8b 55 14             	mov    0x14(%ebp),%edx
8010198a:	29 fa                	sub    %edi,%edx
8010198c:	83 c4 0c             	add    $0xc,%esp
8010198f:	39 d3                	cmp    %edx,%ebx
80101991:	0f 47 da             	cmova  %edx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101994:	53                   	push   %ebx
80101995:	ff 75 0c             	pushl  0xc(%ebp)
80101998:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010199b:	8d 44 01 5c          	lea    0x5c(%ecx,%eax,1),%eax
8010199f:	50                   	push   %eax
801019a0:	e8 34 27 00 00       	call   801040d9 <memmove>
    log_write(bp);
801019a5:	83 c4 04             	add    $0x4,%esp
801019a8:	ff 75 e4             	pushl  -0x1c(%ebp)
801019ab:	e8 0d 10 00 00       	call   801029bd <log_write>
    brelse(bp);
801019b0:	83 c4 04             	add    $0x4,%esp
801019b3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019b6:	e8 26 e8 ff ff       	call   801001e1 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801019bb:	01 df                	add    %ebx,%edi
801019bd:	01 de                	add    %ebx,%esi
801019bf:	01 5d 0c             	add    %ebx,0xc(%ebp)
801019c2:	83 c4 10             	add    $0x10,%esp
801019c5:	eb 8c                	jmp    80101953 <writei+0x45>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801019c7:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801019cb:	66 83 f8 09          	cmp    $0x9,%ax
801019cf:	77 49                	ja     80101a1a <writei+0x10c>
801019d1:	98                   	cwtl   
801019d2:	8b 04 c5 c4 4a 11 80 	mov    -0x7feeb53c(,%eax,8),%eax
801019d9:	85 c0                	test   %eax,%eax
801019db:	74 44                	je     80101a21 <writei+0x113>
    return devsw[ip->major].write(ip, src, n);
801019dd:	83 ec 04             	sub    $0x4,%esp
801019e0:	ff 75 14             	pushl  0x14(%ebp)
801019e3:	ff 75 0c             	pushl  0xc(%ebp)
801019e6:	ff 75 08             	pushl  0x8(%ebp)
801019e9:	ff d0                	call   *%eax
801019eb:	83 c4 10             	add    $0x10,%esp
801019ee:	eb 11                	jmp    80101a01 <writei+0xf3>
  if(n > 0 && off > ip->size){
801019f0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801019f4:	74 08                	je     801019fe <writei+0xf0>
801019f6:	8b 45 08             	mov    0x8(%ebp),%eax
801019f9:	39 70 58             	cmp    %esi,0x58(%eax)
801019fc:	72 0b                	jb     80101a09 <writei+0xfb>
  return n;
801019fe:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101a01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a04:	5b                   	pop    %ebx
80101a05:	5e                   	pop    %esi
80101a06:	5f                   	pop    %edi
80101a07:	5d                   	pop    %ebp
80101a08:	c3                   	ret    
    ip->size = off;
80101a09:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101a0c:	83 ec 0c             	sub    $0xc,%esp
80101a0f:	50                   	push   %eax
80101a10:	e8 89 fa ff ff       	call   8010149e <iupdate>
80101a15:	83 c4 10             	add    $0x10,%esp
80101a18:	eb e4                	jmp    801019fe <writei+0xf0>
      return -1;
80101a1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a1f:	eb e0                	jmp    80101a01 <writei+0xf3>
80101a21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a26:	eb d9                	jmp    80101a01 <writei+0xf3>
    return -1;
80101a28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a2d:	eb d2                	jmp    80101a01 <writei+0xf3>
80101a2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a34:	eb cb                	jmp    80101a01 <writei+0xf3>
    return -1;
80101a36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a3b:	eb c4                	jmp    80101a01 <writei+0xf3>

80101a3d <namecmp>:
{
80101a3d:	f3 0f 1e fb          	endbr32 
80101a41:	55                   	push   %ebp
80101a42:	89 e5                	mov    %esp,%ebp
80101a44:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101a47:	6a 0e                	push   $0xe
80101a49:	ff 75 0c             	pushl  0xc(%ebp)
80101a4c:	ff 75 08             	pushl  0x8(%ebp)
80101a4f:	e8 f7 26 00 00       	call   8010414b <strncmp>
}
80101a54:	c9                   	leave  
80101a55:	c3                   	ret    

80101a56 <dirlookup>:
{
80101a56:	f3 0f 1e fb          	endbr32 
80101a5a:	55                   	push   %ebp
80101a5b:	89 e5                	mov    %esp,%ebp
80101a5d:	57                   	push   %edi
80101a5e:	56                   	push   %esi
80101a5f:	53                   	push   %ebx
80101a60:	83 ec 1c             	sub    $0x1c,%esp
80101a63:	8b 75 08             	mov    0x8(%ebp),%esi
80101a66:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(dp->type != T_DIR)
80101a69:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101a6e:	75 07                	jne    80101a77 <dirlookup+0x21>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a70:	bb 00 00 00 00       	mov    $0x0,%ebx
80101a75:	eb 1d                	jmp    80101a94 <dirlookup+0x3e>
    panic("dirlookup not DIR");
80101a77:	83 ec 0c             	sub    $0xc,%esp
80101a7a:	68 8f 6b 10 80       	push   $0x80106b8f
80101a7f:	e8 d8 e8 ff ff       	call   8010035c <panic>
      panic("dirlookup read");
80101a84:	83 ec 0c             	sub    $0xc,%esp
80101a87:	68 a1 6b 10 80       	push   $0x80106ba1
80101a8c:	e8 cb e8 ff ff       	call   8010035c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a91:	83 c3 10             	add    $0x10,%ebx
80101a94:	39 5e 58             	cmp    %ebx,0x58(%esi)
80101a97:	76 48                	jbe    80101ae1 <dirlookup+0x8b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101a99:	6a 10                	push   $0x10
80101a9b:	53                   	push   %ebx
80101a9c:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101a9f:	50                   	push   %eax
80101aa0:	56                   	push   %esi
80101aa1:	e8 67 fd ff ff       	call   8010180d <readi>
80101aa6:	83 c4 10             	add    $0x10,%esp
80101aa9:	83 f8 10             	cmp    $0x10,%eax
80101aac:	75 d6                	jne    80101a84 <dirlookup+0x2e>
    if(de.inum == 0)
80101aae:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ab3:	74 dc                	je     80101a91 <dirlookup+0x3b>
    if(namecmp(name, de.name) == 0){
80101ab5:	83 ec 08             	sub    $0x8,%esp
80101ab8:	8d 45 da             	lea    -0x26(%ebp),%eax
80101abb:	50                   	push   %eax
80101abc:	57                   	push   %edi
80101abd:	e8 7b ff ff ff       	call   80101a3d <namecmp>
80101ac2:	83 c4 10             	add    $0x10,%esp
80101ac5:	85 c0                	test   %eax,%eax
80101ac7:	75 c8                	jne    80101a91 <dirlookup+0x3b>
      if(poff)
80101ac9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80101acd:	74 05                	je     80101ad4 <dirlookup+0x7e>
        *poff = off;
80101acf:	8b 45 10             	mov    0x10(%ebp),%eax
80101ad2:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
80101ad4:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101ad8:	8b 06                	mov    (%esi),%eax
80101ada:	e8 16 f7 ff ff       	call   801011f5 <iget>
80101adf:	eb 05                	jmp    80101ae6 <dirlookup+0x90>
  return 0;
80101ae1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101ae6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ae9:	5b                   	pop    %ebx
80101aea:	5e                   	pop    %esi
80101aeb:	5f                   	pop    %edi
80101aec:	5d                   	pop    %ebp
80101aed:	c3                   	ret    

80101aee <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101aee:	55                   	push   %ebp
80101aef:	89 e5                	mov    %esp,%ebp
80101af1:	57                   	push   %edi
80101af2:	56                   	push   %esi
80101af3:	53                   	push   %ebx
80101af4:	83 ec 1c             	sub    $0x1c,%esp
80101af7:	89 c3                	mov    %eax,%ebx
80101af9:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101afc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101aff:	80 38 2f             	cmpb   $0x2f,(%eax)
80101b02:	74 17                	je     80101b1b <namex+0x2d>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101b04:	e8 32 18 00 00       	call   8010333b <myproc>
80101b09:	83 ec 0c             	sub    $0xc,%esp
80101b0c:	ff 70 68             	pushl  0x68(%eax)
80101b0f:	e8 bf fa ff ff       	call   801015d3 <idup>
80101b14:	89 c6                	mov    %eax,%esi
80101b16:	83 c4 10             	add    $0x10,%esp
80101b19:	eb 53                	jmp    80101b6e <namex+0x80>
    ip = iget(ROOTDEV, ROOTINO);
80101b1b:	ba 01 00 00 00       	mov    $0x1,%edx
80101b20:	b8 01 00 00 00       	mov    $0x1,%eax
80101b25:	e8 cb f6 ff ff       	call   801011f5 <iget>
80101b2a:	89 c6                	mov    %eax,%esi
80101b2c:	eb 40                	jmp    80101b6e <namex+0x80>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101b2e:	83 ec 0c             	sub    $0xc,%esp
80101b31:	56                   	push   %esi
80101b32:	e8 83 fc ff ff       	call   801017ba <iunlockput>
      return 0;
80101b37:	83 c4 10             	add    $0x10,%esp
80101b3a:	be 00 00 00 00       	mov    $0x0,%esi
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101b3f:	89 f0                	mov    %esi,%eax
80101b41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b44:	5b                   	pop    %ebx
80101b45:	5e                   	pop    %esi
80101b46:	5f                   	pop    %edi
80101b47:	5d                   	pop    %ebp
80101b48:	c3                   	ret    
    if((next = dirlookup(ip, name, 0)) == 0){
80101b49:	83 ec 04             	sub    $0x4,%esp
80101b4c:	6a 00                	push   $0x0
80101b4e:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b51:	56                   	push   %esi
80101b52:	e8 ff fe ff ff       	call   80101a56 <dirlookup>
80101b57:	89 c7                	mov    %eax,%edi
80101b59:	83 c4 10             	add    $0x10,%esp
80101b5c:	85 c0                	test   %eax,%eax
80101b5e:	74 4a                	je     80101baa <namex+0xbc>
    iunlockput(ip);
80101b60:	83 ec 0c             	sub    $0xc,%esp
80101b63:	56                   	push   %esi
80101b64:	e8 51 fc ff ff       	call   801017ba <iunlockput>
80101b69:	83 c4 10             	add    $0x10,%esp
    ip = next;
80101b6c:	89 fe                	mov    %edi,%esi
  while((path = skipelem(path, name)) != 0){
80101b6e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b71:	89 d8                	mov    %ebx,%eax
80101b73:	e8 3b f4 ff ff       	call   80100fb3 <skipelem>
80101b78:	89 c3                	mov    %eax,%ebx
80101b7a:	85 c0                	test   %eax,%eax
80101b7c:	74 3c                	je     80101bba <namex+0xcc>
    ilock(ip);
80101b7e:	83 ec 0c             	sub    $0xc,%esp
80101b81:	56                   	push   %esi
80101b82:	e8 80 fa ff ff       	call   80101607 <ilock>
    if(ip->type != T_DIR){
80101b87:	83 c4 10             	add    $0x10,%esp
80101b8a:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101b8f:	75 9d                	jne    80101b2e <namex+0x40>
    if(nameiparent && *path == '\0'){
80101b91:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101b95:	74 b2                	je     80101b49 <namex+0x5b>
80101b97:	80 3b 00             	cmpb   $0x0,(%ebx)
80101b9a:	75 ad                	jne    80101b49 <namex+0x5b>
      iunlock(ip);
80101b9c:	83 ec 0c             	sub    $0xc,%esp
80101b9f:	56                   	push   %esi
80101ba0:	e8 28 fb ff ff       	call   801016cd <iunlock>
      return ip;
80101ba5:	83 c4 10             	add    $0x10,%esp
80101ba8:	eb 95                	jmp    80101b3f <namex+0x51>
      iunlockput(ip);
80101baa:	83 ec 0c             	sub    $0xc,%esp
80101bad:	56                   	push   %esi
80101bae:	e8 07 fc ff ff       	call   801017ba <iunlockput>
      return 0;
80101bb3:	83 c4 10             	add    $0x10,%esp
80101bb6:	89 fe                	mov    %edi,%esi
80101bb8:	eb 85                	jmp    80101b3f <namex+0x51>
  if(nameiparent){
80101bba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101bbe:	0f 84 7b ff ff ff    	je     80101b3f <namex+0x51>
    iput(ip);
80101bc4:	83 ec 0c             	sub    $0xc,%esp
80101bc7:	56                   	push   %esi
80101bc8:	e8 49 fb ff ff       	call   80101716 <iput>
    return 0;
80101bcd:	83 c4 10             	add    $0x10,%esp
80101bd0:	89 de                	mov    %ebx,%esi
80101bd2:	e9 68 ff ff ff       	jmp    80101b3f <namex+0x51>

80101bd7 <dirlink>:
{
80101bd7:	f3 0f 1e fb          	endbr32 
80101bdb:	55                   	push   %ebp
80101bdc:	89 e5                	mov    %esp,%ebp
80101bde:	57                   	push   %edi
80101bdf:	56                   	push   %esi
80101be0:	53                   	push   %ebx
80101be1:	83 ec 20             	sub    $0x20,%esp
80101be4:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101be7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101bea:	6a 00                	push   $0x0
80101bec:	57                   	push   %edi
80101bed:	53                   	push   %ebx
80101bee:	e8 63 fe ff ff       	call   80101a56 <dirlookup>
80101bf3:	83 c4 10             	add    $0x10,%esp
80101bf6:	85 c0                	test   %eax,%eax
80101bf8:	75 07                	jne    80101c01 <dirlink+0x2a>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101bfa:	b8 00 00 00 00       	mov    $0x0,%eax
80101bff:	eb 23                	jmp    80101c24 <dirlink+0x4d>
    iput(ip);
80101c01:	83 ec 0c             	sub    $0xc,%esp
80101c04:	50                   	push   %eax
80101c05:	e8 0c fb ff ff       	call   80101716 <iput>
    return -1;
80101c0a:	83 c4 10             	add    $0x10,%esp
80101c0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c12:	eb 63                	jmp    80101c77 <dirlink+0xa0>
      panic("dirlink read");
80101c14:	83 ec 0c             	sub    $0xc,%esp
80101c17:	68 b0 6b 10 80       	push   $0x80106bb0
80101c1c:	e8 3b e7 ff ff       	call   8010035c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c21:	8d 46 10             	lea    0x10(%esi),%eax
80101c24:	89 c6                	mov    %eax,%esi
80101c26:	39 43 58             	cmp    %eax,0x58(%ebx)
80101c29:	76 1c                	jbe    80101c47 <dirlink+0x70>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c2b:	6a 10                	push   $0x10
80101c2d:	50                   	push   %eax
80101c2e:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101c31:	50                   	push   %eax
80101c32:	53                   	push   %ebx
80101c33:	e8 d5 fb ff ff       	call   8010180d <readi>
80101c38:	83 c4 10             	add    $0x10,%esp
80101c3b:	83 f8 10             	cmp    $0x10,%eax
80101c3e:	75 d4                	jne    80101c14 <dirlink+0x3d>
    if(de.inum == 0)
80101c40:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c45:	75 da                	jne    80101c21 <dirlink+0x4a>
  strncpy(de.name, name, DIRSIZ);
80101c47:	83 ec 04             	sub    $0x4,%esp
80101c4a:	6a 0e                	push   $0xe
80101c4c:	57                   	push   %edi
80101c4d:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101c50:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c53:	50                   	push   %eax
80101c54:	e8 33 25 00 00       	call   8010418c <strncpy>
  de.inum = inum;
80101c59:	8b 45 10             	mov    0x10(%ebp),%eax
80101c5c:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c60:	6a 10                	push   $0x10
80101c62:	56                   	push   %esi
80101c63:	57                   	push   %edi
80101c64:	53                   	push   %ebx
80101c65:	e8 a4 fc ff ff       	call   8010190e <writei>
80101c6a:	83 c4 20             	add    $0x20,%esp
80101c6d:	83 f8 10             	cmp    $0x10,%eax
80101c70:	75 0d                	jne    80101c7f <dirlink+0xa8>
  return 0;
80101c72:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101c77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c7a:	5b                   	pop    %ebx
80101c7b:	5e                   	pop    %esi
80101c7c:	5f                   	pop    %edi
80101c7d:	5d                   	pop    %ebp
80101c7e:	c3                   	ret    
    panic("dirlink");
80101c7f:	83 ec 0c             	sub    $0xc,%esp
80101c82:	68 14 72 10 80       	push   $0x80107214
80101c87:	e8 d0 e6 ff ff       	call   8010035c <panic>

80101c8c <namei>:

struct inode*
namei(char *path)
{
80101c8c:	f3 0f 1e fb          	endbr32 
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101c96:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101c99:	ba 00 00 00 00       	mov    $0x0,%edx
80101c9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca1:	e8 48 fe ff ff       	call   80101aee <namex>
}
80101ca6:	c9                   	leave  
80101ca7:	c3                   	ret    

80101ca8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101ca8:	f3 0f 1e fb          	endbr32 
80101cac:	55                   	push   %ebp
80101cad:	89 e5                	mov    %esp,%ebp
80101caf:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101cb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101cb5:	ba 01 00 00 00       	mov    $0x1,%edx
80101cba:	8b 45 08             	mov    0x8(%ebp),%eax
80101cbd:	e8 2c fe ff ff       	call   80101aee <namex>
}
80101cc2:	c9                   	leave  
80101cc3:	c3                   	ret    

80101cc4 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80101cc4:	89 c1                	mov    %eax,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101cc6:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ccb:	ec                   	in     (%dx),%al
80101ccc:	89 c2                	mov    %eax,%edx
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101cce:	83 e0 c0             	and    $0xffffffc0,%eax
80101cd1:	3c 40                	cmp    $0x40,%al
80101cd3:	75 f1                	jne    80101cc6 <idewait+0x2>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80101cd5:	85 c9                	test   %ecx,%ecx
80101cd7:	74 0a                	je     80101ce3 <idewait+0x1f>
80101cd9:	f6 c2 21             	test   $0x21,%dl
80101cdc:	75 08                	jne    80101ce6 <idewait+0x22>
    return -1;
  return 0;
80101cde:	b9 00 00 00 00       	mov    $0x0,%ecx
}
80101ce3:	89 c8                	mov    %ecx,%eax
80101ce5:	c3                   	ret    
    return -1;
80101ce6:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80101ceb:	eb f6                	jmp    80101ce3 <idewait+0x1f>

80101ced <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ced:	55                   	push   %ebp
80101cee:	89 e5                	mov    %esp,%ebp
80101cf0:	56                   	push   %esi
80101cf1:	53                   	push   %ebx
  if(b == 0)
80101cf2:	85 c0                	test   %eax,%eax
80101cf4:	0f 84 91 00 00 00    	je     80101d8b <idestart+0x9e>
80101cfa:	89 c6                	mov    %eax,%esi
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101cfc:	8b 58 08             	mov    0x8(%eax),%ebx
80101cff:	81 fb cf 07 00 00    	cmp    $0x7cf,%ebx
80101d05:	0f 87 8d 00 00 00    	ja     80101d98 <idestart+0xab>
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;

  if (sector_per_block > 7) panic("idestart");

  idewait(0);
80101d0b:	b8 00 00 00 00       	mov    $0x0,%eax
80101d10:	e8 af ff ff ff       	call   80101cc4 <idewait>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d15:	b8 00 00 00 00       	mov    $0x0,%eax
80101d1a:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101d1f:	ee                   	out    %al,(%dx)
80101d20:	b8 01 00 00 00       	mov    $0x1,%eax
80101d25:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101d2a:	ee                   	out    %al,(%dx)
80101d2b:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101d30:	89 d8                	mov    %ebx,%eax
80101d32:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101d33:	89 d8                	mov    %ebx,%eax
80101d35:	c1 f8 08             	sar    $0x8,%eax
80101d38:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101d3d:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80101d3e:	89 d8                	mov    %ebx,%eax
80101d40:	c1 f8 10             	sar    $0x10,%eax
80101d43:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101d48:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101d49:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101d4d:	c1 e0 04             	shl    $0x4,%eax
80101d50:	83 e0 10             	and    $0x10,%eax
80101d53:	c1 fb 18             	sar    $0x18,%ebx
80101d56:	83 e3 0f             	and    $0xf,%ebx
80101d59:	09 d8                	or     %ebx,%eax
80101d5b:	83 c8 e0             	or     $0xffffffe0,%eax
80101d5e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d63:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101d64:	f6 06 04             	testb  $0x4,(%esi)
80101d67:	74 3c                	je     80101da5 <idestart+0xb8>
80101d69:	b8 30 00 00 00       	mov    $0x30,%eax
80101d6e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d73:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101d74:	83 c6 5c             	add    $0x5c,%esi
  asm volatile("cld; rep outsl" :
80101d77:	b9 80 00 00 00       	mov    $0x80,%ecx
80101d7c:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101d81:	fc                   	cld    
80101d82:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101d84:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d87:	5b                   	pop    %ebx
80101d88:	5e                   	pop    %esi
80101d89:	5d                   	pop    %ebp
80101d8a:	c3                   	ret    
    panic("idestart");
80101d8b:	83 ec 0c             	sub    $0xc,%esp
80101d8e:	68 13 6c 10 80       	push   $0x80106c13
80101d93:	e8 c4 e5 ff ff       	call   8010035c <panic>
    panic("incorrect blockno");
80101d98:	83 ec 0c             	sub    $0xc,%esp
80101d9b:	68 1c 6c 10 80       	push   $0x80106c1c
80101da0:	e8 b7 e5 ff ff       	call   8010035c <panic>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101da5:	b8 20 00 00 00       	mov    $0x20,%eax
80101daa:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101daf:	ee                   	out    %al,(%dx)
}
80101db0:	eb d2                	jmp    80101d84 <idestart+0x97>

80101db2 <ideinit>:
{
80101db2:	f3 0f 1e fb          	endbr32 
80101db6:	55                   	push   %ebp
80101db7:	89 e5                	mov    %esp,%ebp
80101db9:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101dbc:	68 2e 6c 10 80       	push   $0x80106c2e
80101dc1:	68 80 a5 10 80       	push   $0x8010a580
80101dc6:	e8 8a 20 00 00       	call   80103e55 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101dcb:	83 c4 08             	add    $0x8,%esp
80101dce:	a1 60 6e 11 80       	mov    0x80116e60,%eax
80101dd3:	83 e8 01             	sub    $0x1,%eax
80101dd6:	50                   	push   %eax
80101dd7:	6a 0e                	push   $0xe
80101dd9:	e8 5a 02 00 00       	call   80102038 <ioapicenable>
  idewait(0);
80101dde:	b8 00 00 00 00       	mov    $0x0,%eax
80101de3:	e8 dc fe ff ff       	call   80101cc4 <idewait>
80101de8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101ded:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101df2:	ee                   	out    %al,(%dx)
  for(i=0; i<1000; i++){
80101df3:	83 c4 10             	add    $0x10,%esp
80101df6:	b9 00 00 00 00       	mov    $0x0,%ecx
80101dfb:	eb 03                	jmp    80101e00 <ideinit+0x4e>
80101dfd:	83 c1 01             	add    $0x1,%ecx
80101e00:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101e06:	7f 14                	jg     80101e1c <ideinit+0x6a>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101e08:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101e0d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101e0e:	84 c0                	test   %al,%al
80101e10:	74 eb                	je     80101dfd <ideinit+0x4b>
      havedisk1 = 1;
80101e12:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80101e19:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101e1c:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80101e21:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101e26:	ee                   	out    %al,(%dx)
}
80101e27:	c9                   	leave  
80101e28:	c3                   	ret    

80101e29 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101e29:	f3 0f 1e fb          	endbr32 
80101e2d:	55                   	push   %ebp
80101e2e:	89 e5                	mov    %esp,%ebp
80101e30:	57                   	push   %edi
80101e31:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101e32:	83 ec 0c             	sub    $0xc,%esp
80101e35:	68 80 a5 10 80       	push   $0x8010a580
80101e3a:	e8 66 21 00 00       	call   80103fa5 <acquire>

  if((b = idequeue) == 0){
80101e3f:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80101e45:	83 c4 10             	add    $0x10,%esp
80101e48:	85 db                	test   %ebx,%ebx
80101e4a:	74 48                	je     80101e94 <ideintr+0x6b>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101e4c:	8b 43 58             	mov    0x58(%ebx),%eax
80101e4f:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e54:	f6 03 04             	testb  $0x4,(%ebx)
80101e57:	74 4d                	je     80101ea6 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80101e59:	8b 03                	mov    (%ebx),%eax
80101e5b:	83 c8 02             	or     $0x2,%eax
  b->flags &= ~B_DIRTY;
80101e5e:	83 e0 fb             	and    $0xfffffffb,%eax
80101e61:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101e63:	83 ec 0c             	sub    $0xc,%esp
80101e66:	53                   	push   %ebx
80101e67:	e8 2a 1b 00 00       	call   80103996 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101e6c:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80101e71:	83 c4 10             	add    $0x10,%esp
80101e74:	85 c0                	test   %eax,%eax
80101e76:	74 05                	je     80101e7d <ideintr+0x54>
    idestart(idequeue);
80101e78:	e8 70 fe ff ff       	call   80101ced <idestart>

  release(&idelock);
80101e7d:	83 ec 0c             	sub    $0xc,%esp
80101e80:	68 80 a5 10 80       	push   $0x8010a580
80101e85:	e8 84 21 00 00       	call   8010400e <release>
80101e8a:	83 c4 10             	add    $0x10,%esp
}
80101e8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101e90:	5b                   	pop    %ebx
80101e91:	5f                   	pop    %edi
80101e92:	5d                   	pop    %ebp
80101e93:	c3                   	ret    
    release(&idelock);
80101e94:	83 ec 0c             	sub    $0xc,%esp
80101e97:	68 80 a5 10 80       	push   $0x8010a580
80101e9c:	e8 6d 21 00 00       	call   8010400e <release>
    return;
80101ea1:	83 c4 10             	add    $0x10,%esp
80101ea4:	eb e7                	jmp    80101e8d <ideintr+0x64>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101ea6:	b8 01 00 00 00       	mov    $0x1,%eax
80101eab:	e8 14 fe ff ff       	call   80101cc4 <idewait>
80101eb0:	85 c0                	test   %eax,%eax
80101eb2:	78 a5                	js     80101e59 <ideintr+0x30>
    insl(0x1f0, b->data, BSIZE/4);
80101eb4:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101eb7:	b9 80 00 00 00       	mov    $0x80,%ecx
80101ebc:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101ec1:	fc                   	cld    
80101ec2:	f3 6d                	rep insl (%dx),%es:(%edi)
}
80101ec4:	eb 93                	jmp    80101e59 <ideintr+0x30>

80101ec6 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101ec6:	f3 0f 1e fb          	endbr32 
80101eca:	55                   	push   %ebp
80101ecb:	89 e5                	mov    %esp,%ebp
80101ecd:	53                   	push   %ebx
80101ece:	83 ec 10             	sub    $0x10,%esp
80101ed1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101ed4:	8d 43 0c             	lea    0xc(%ebx),%eax
80101ed7:	50                   	push   %eax
80101ed8:	e8 4d 1f 00 00       	call   80103e2a <holdingsleep>
80101edd:	83 c4 10             	add    $0x10,%esp
80101ee0:	85 c0                	test   %eax,%eax
80101ee2:	74 37                	je     80101f1b <iderw+0x55>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101ee4:	8b 03                	mov    (%ebx),%eax
80101ee6:	83 e0 06             	and    $0x6,%eax
80101ee9:	83 f8 02             	cmp    $0x2,%eax
80101eec:	74 3a                	je     80101f28 <iderw+0x62>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101eee:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101ef2:	74 09                	je     80101efd <iderw+0x37>
80101ef4:	83 3d 60 a5 10 80 00 	cmpl   $0x0,0x8010a560
80101efb:	74 38                	je     80101f35 <iderw+0x6f>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101efd:	83 ec 0c             	sub    $0xc,%esp
80101f00:	68 80 a5 10 80       	push   $0x8010a580
80101f05:	e8 9b 20 00 00       	call   80103fa5 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101f0a:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101f11:	83 c4 10             	add    $0x10,%esp
80101f14:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80101f19:	eb 2a                	jmp    80101f45 <iderw+0x7f>
    panic("iderw: buf not locked");
80101f1b:	83 ec 0c             	sub    $0xc,%esp
80101f1e:	68 32 6c 10 80       	push   $0x80106c32
80101f23:	e8 34 e4 ff ff       	call   8010035c <panic>
    panic("iderw: nothing to do");
80101f28:	83 ec 0c             	sub    $0xc,%esp
80101f2b:	68 48 6c 10 80       	push   $0x80106c48
80101f30:	e8 27 e4 ff ff       	call   8010035c <panic>
    panic("iderw: ide disk 1 not present");
80101f35:	83 ec 0c             	sub    $0xc,%esp
80101f38:	68 5d 6c 10 80       	push   $0x80106c5d
80101f3d:	e8 1a e4 ff ff       	call   8010035c <panic>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101f42:	8d 50 58             	lea    0x58(%eax),%edx
80101f45:	8b 02                	mov    (%edx),%eax
80101f47:	85 c0                	test   %eax,%eax
80101f49:	75 f7                	jne    80101f42 <iderw+0x7c>
    ;
  *pp = b;
80101f4b:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101f4d:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80101f53:	75 1a                	jne    80101f6f <iderw+0xa9>
    idestart(b);
80101f55:	89 d8                	mov    %ebx,%eax
80101f57:	e8 91 fd ff ff       	call   80101ced <idestart>
80101f5c:	eb 11                	jmp    80101f6f <iderw+0xa9>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
80101f5e:	83 ec 08             	sub    $0x8,%esp
80101f61:	68 80 a5 10 80       	push   $0x8010a580
80101f66:	53                   	push   %ebx
80101f67:	e8 bb 18 00 00       	call   80103827 <sleep>
80101f6c:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101f6f:	8b 03                	mov    (%ebx),%eax
80101f71:	83 e0 06             	and    $0x6,%eax
80101f74:	83 f8 02             	cmp    $0x2,%eax
80101f77:	75 e5                	jne    80101f5e <iderw+0x98>
  }


  release(&idelock);
80101f79:	83 ec 0c             	sub    $0xc,%esp
80101f7c:	68 80 a5 10 80       	push   $0x8010a580
80101f81:	e8 88 20 00 00       	call   8010400e <release>
}
80101f86:	83 c4 10             	add    $0x10,%esp
80101f89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f8c:	c9                   	leave  
80101f8d:	c3                   	ret    

80101f8e <ioapicread>:
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80101f8e:	8b 15 94 67 11 80    	mov    0x80116794,%edx
80101f94:	89 02                	mov    %eax,(%edx)
  return ioapic->data;
80101f96:	a1 94 67 11 80       	mov    0x80116794,%eax
80101f9b:	8b 40 10             	mov    0x10(%eax),%eax
}
80101f9e:	c3                   	ret    

80101f9f <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80101f9f:	8b 0d 94 67 11 80    	mov    0x80116794,%ecx
80101fa5:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80101fa7:	a1 94 67 11 80       	mov    0x80116794,%eax
80101fac:	89 50 10             	mov    %edx,0x10(%eax)
}
80101faf:	c3                   	ret    

80101fb0 <ioapicinit>:

void
ioapicinit(void)
{
80101fb0:	f3 0f 1e fb          	endbr32 
80101fb4:	55                   	push   %ebp
80101fb5:	89 e5                	mov    %esp,%ebp
80101fb7:	57                   	push   %edi
80101fb8:	56                   	push   %esi
80101fb9:	53                   	push   %ebx
80101fba:	83 ec 0c             	sub    $0xc,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101fbd:	c7 05 94 67 11 80 00 	movl   $0xfec00000,0x80116794
80101fc4:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101fc7:	b8 01 00 00 00       	mov    $0x1,%eax
80101fcc:	e8 bd ff ff ff       	call   80101f8e <ioapicread>
80101fd1:	c1 e8 10             	shr    $0x10,%eax
80101fd4:	0f b6 f8             	movzbl %al,%edi
  id = ioapicread(REG_ID) >> 24;
80101fd7:	b8 00 00 00 00       	mov    $0x0,%eax
80101fdc:	e8 ad ff ff ff       	call   80101f8e <ioapicread>
80101fe1:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80101fe4:	0f b6 15 c0 68 11 80 	movzbl 0x801168c0,%edx
80101feb:	39 c2                	cmp    %eax,%edx
80101fed:	75 2f                	jne    8010201e <ioapicinit+0x6e>
{
80101fef:	bb 00 00 00 00       	mov    $0x0,%ebx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80101ff4:	39 fb                	cmp    %edi,%ebx
80101ff6:	7f 38                	jg     80102030 <ioapicinit+0x80>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80101ff8:	8d 53 20             	lea    0x20(%ebx),%edx
80101ffb:	81 ca 00 00 01 00    	or     $0x10000,%edx
80102001:	8d 74 1b 10          	lea    0x10(%ebx,%ebx,1),%esi
80102005:	89 f0                	mov    %esi,%eax
80102007:	e8 93 ff ff ff       	call   80101f9f <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
8010200c:	8d 46 01             	lea    0x1(%esi),%eax
8010200f:	ba 00 00 00 00       	mov    $0x0,%edx
80102014:	e8 86 ff ff ff       	call   80101f9f <ioapicwrite>
  for(i = 0; i <= maxintr; i++){
80102019:	83 c3 01             	add    $0x1,%ebx
8010201c:	eb d6                	jmp    80101ff4 <ioapicinit+0x44>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010201e:	83 ec 0c             	sub    $0xc,%esp
80102021:	68 7c 6c 10 80       	push   $0x80106c7c
80102026:	e8 fe e5 ff ff       	call   80100629 <cprintf>
8010202b:	83 c4 10             	add    $0x10,%esp
8010202e:	eb bf                	jmp    80101fef <ioapicinit+0x3f>
  }
}
80102030:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102033:	5b                   	pop    %ebx
80102034:	5e                   	pop    %esi
80102035:	5f                   	pop    %edi
80102036:	5d                   	pop    %ebp
80102037:	c3                   	ret    

80102038 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102038:	f3 0f 1e fb          	endbr32 
8010203c:	55                   	push   %ebp
8010203d:	89 e5                	mov    %esp,%ebp
8010203f:	53                   	push   %ebx
80102040:	83 ec 04             	sub    $0x4,%esp
80102043:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102046:	8d 50 20             	lea    0x20(%eax),%edx
80102049:	8d 5c 00 10          	lea    0x10(%eax,%eax,1),%ebx
8010204d:	89 d8                	mov    %ebx,%eax
8010204f:	e8 4b ff ff ff       	call   80101f9f <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102054:	8b 55 0c             	mov    0xc(%ebp),%edx
80102057:	c1 e2 18             	shl    $0x18,%edx
8010205a:	8d 43 01             	lea    0x1(%ebx),%eax
8010205d:	e8 3d ff ff ff       	call   80101f9f <ioapicwrite>
}
80102062:	83 c4 04             	add    $0x4,%esp
80102065:	5b                   	pop    %ebx
80102066:	5d                   	pop    %ebp
80102067:	c3                   	ret    

80102068 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102068:	f3 0f 1e fb          	endbr32 
8010206c:	55                   	push   %ebp
8010206d:	89 e5                	mov    %esp,%ebp
8010206f:	53                   	push   %ebx
80102070:	83 ec 04             	sub    $0x4,%esp
80102073:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102076:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
8010207c:	75 4c                	jne    801020ca <kfree+0x62>
8010207e:	81 fb 88 76 11 80    	cmp    $0x80117688,%ebx
80102084:	72 44                	jb     801020ca <kfree+0x62>
80102086:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010208c:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102091:	77 37                	ja     801020ca <kfree+0x62>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102093:	83 ec 04             	sub    $0x4,%esp
80102096:	68 00 10 00 00       	push   $0x1000
8010209b:	6a 01                	push   $0x1
8010209d:	53                   	push   %ebx
8010209e:	e8 b6 1f 00 00       	call   80104059 <memset>

  if(kmem.use_lock)
801020a3:	83 c4 10             	add    $0x10,%esp
801020a6:	83 3d d4 67 11 80 00 	cmpl   $0x0,0x801167d4
801020ad:	75 28                	jne    801020d7 <kfree+0x6f>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801020af:	a1 d8 67 11 80       	mov    0x801167d8,%eax
801020b4:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
801020b6:	89 1d d8 67 11 80    	mov    %ebx,0x801167d8
  if(kmem.use_lock)
801020bc:	83 3d d4 67 11 80 00 	cmpl   $0x0,0x801167d4
801020c3:	75 24                	jne    801020e9 <kfree+0x81>
    release(&kmem.lock);
}
801020c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801020c8:	c9                   	leave  
801020c9:	c3                   	ret    
    panic("kfree");
801020ca:	83 ec 0c             	sub    $0xc,%esp
801020cd:	68 ae 6c 10 80       	push   $0x80106cae
801020d2:	e8 85 e2 ff ff       	call   8010035c <panic>
    acquire(&kmem.lock);
801020d7:	83 ec 0c             	sub    $0xc,%esp
801020da:	68 a0 67 11 80       	push   $0x801167a0
801020df:	e8 c1 1e 00 00       	call   80103fa5 <acquire>
801020e4:	83 c4 10             	add    $0x10,%esp
801020e7:	eb c6                	jmp    801020af <kfree+0x47>
    release(&kmem.lock);
801020e9:	83 ec 0c             	sub    $0xc,%esp
801020ec:	68 a0 67 11 80       	push   $0x801167a0
801020f1:	e8 18 1f 00 00       	call   8010400e <release>
801020f6:	83 c4 10             	add    $0x10,%esp
}
801020f9:	eb ca                	jmp    801020c5 <kfree+0x5d>

801020fb <freerange>:
{
801020fb:	f3 0f 1e fb          	endbr32 
801020ff:	55                   	push   %ebp
80102100:	89 e5                	mov    %esp,%ebp
80102102:	56                   	push   %esi
80102103:	53                   	push   %ebx
80102104:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102107:	8b 45 08             	mov    0x8(%ebp),%eax
8010210a:	05 ff 0f 00 00       	add    $0xfff,%eax
8010210f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102114:	8d b0 00 10 00 00    	lea    0x1000(%eax),%esi
8010211a:	39 de                	cmp    %ebx,%esi
8010211c:	77 10                	ja     8010212e <freerange+0x33>
    kfree(p);
8010211e:	83 ec 0c             	sub    $0xc,%esp
80102121:	50                   	push   %eax
80102122:	e8 41 ff ff ff       	call   80102068 <kfree>
80102127:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010212a:	89 f0                	mov    %esi,%eax
8010212c:	eb e6                	jmp    80102114 <freerange+0x19>
}
8010212e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102131:	5b                   	pop    %ebx
80102132:	5e                   	pop    %esi
80102133:	5d                   	pop    %ebp
80102134:	c3                   	ret    

80102135 <kinit1>:
{
80102135:	f3 0f 1e fb          	endbr32 
80102139:	55                   	push   %ebp
8010213a:	89 e5                	mov    %esp,%ebp
8010213c:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
8010213f:	68 b4 6c 10 80       	push   $0x80106cb4
80102144:	68 a0 67 11 80       	push   $0x801167a0
80102149:	e8 07 1d 00 00       	call   80103e55 <initlock>
  kmem.use_lock = 0;
8010214e:	c7 05 d4 67 11 80 00 	movl   $0x0,0x801167d4
80102155:	00 00 00 
  freerange(vstart, vend);
80102158:	83 c4 08             	add    $0x8,%esp
8010215b:	ff 75 0c             	pushl  0xc(%ebp)
8010215e:	ff 75 08             	pushl  0x8(%ebp)
80102161:	e8 95 ff ff ff       	call   801020fb <freerange>
}
80102166:	83 c4 10             	add    $0x10,%esp
80102169:	c9                   	leave  
8010216a:	c3                   	ret    

8010216b <kinit2>:
{
8010216b:	f3 0f 1e fb          	endbr32 
8010216f:	55                   	push   %ebp
80102170:	89 e5                	mov    %esp,%ebp
80102172:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
80102175:	ff 75 0c             	pushl  0xc(%ebp)
80102178:	ff 75 08             	pushl  0x8(%ebp)
8010217b:	e8 7b ff ff ff       	call   801020fb <freerange>
  kmem.use_lock = 1;
80102180:	c7 05 d4 67 11 80 01 	movl   $0x1,0x801167d4
80102187:	00 00 00 
}
8010218a:	83 c4 10             	add    $0x10,%esp
8010218d:	c9                   	leave  
8010218e:	c3                   	ret    

8010218f <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
8010218f:	f3 0f 1e fb          	endbr32 
80102193:	55                   	push   %ebp
80102194:	89 e5                	mov    %esp,%ebp
80102196:	53                   	push   %ebx
80102197:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
8010219a:	83 3d d4 67 11 80 00 	cmpl   $0x0,0x801167d4
801021a1:	75 21                	jne    801021c4 <kalloc+0x35>
    acquire(&kmem.lock);
  r = kmem.freelist;
801021a3:	8b 1d d8 67 11 80    	mov    0x801167d8,%ebx
  if(r)
801021a9:	85 db                	test   %ebx,%ebx
801021ab:	74 07                	je     801021b4 <kalloc+0x25>
    kmem.freelist = r->next;
801021ad:	8b 03                	mov    (%ebx),%eax
801021af:	a3 d8 67 11 80       	mov    %eax,0x801167d8
  if(kmem.use_lock)
801021b4:	83 3d d4 67 11 80 00 	cmpl   $0x0,0x801167d4
801021bb:	75 19                	jne    801021d6 <kalloc+0x47>
    release(&kmem.lock);
  return (char*)r;
}
801021bd:	89 d8                	mov    %ebx,%eax
801021bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021c2:	c9                   	leave  
801021c3:	c3                   	ret    
    acquire(&kmem.lock);
801021c4:	83 ec 0c             	sub    $0xc,%esp
801021c7:	68 a0 67 11 80       	push   $0x801167a0
801021cc:	e8 d4 1d 00 00       	call   80103fa5 <acquire>
801021d1:	83 c4 10             	add    $0x10,%esp
801021d4:	eb cd                	jmp    801021a3 <kalloc+0x14>
    release(&kmem.lock);
801021d6:	83 ec 0c             	sub    $0xc,%esp
801021d9:	68 a0 67 11 80       	push   $0x801167a0
801021de:	e8 2b 1e 00 00       	call   8010400e <release>
801021e3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
801021e6:	eb d5                	jmp    801021bd <kalloc+0x2e>

801021e8 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801021e8:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ec:	ba 64 00 00 00       	mov    $0x64,%edx
801021f1:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801021f2:	a8 01                	test   $0x1,%al
801021f4:	0f 84 ad 00 00 00    	je     801022a7 <kbdgetc+0xbf>
801021fa:	ba 60 00 00 00       	mov    $0x60,%edx
801021ff:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102200:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102203:	3c e0                	cmp    $0xe0,%al
80102205:	74 5b                	je     80102262 <kbdgetc+0x7a>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102207:	84 c0                	test   %al,%al
80102209:	78 64                	js     8010226f <kbdgetc+0x87>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010220b:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
80102211:	f6 c1 40             	test   $0x40,%cl
80102214:	74 0f                	je     80102225 <kbdgetc+0x3d>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102216:	83 c8 80             	or     $0xffffff80,%eax
80102219:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
8010221c:	83 e1 bf             	and    $0xffffffbf,%ecx
8010221f:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  }

  shift |= shiftcode[data];
80102225:	0f b6 8a e0 6d 10 80 	movzbl -0x7fef9220(%edx),%ecx
8010222c:	0b 0d b4 a5 10 80    	or     0x8010a5b4,%ecx
  shift ^= togglecode[data];
80102232:	0f b6 82 e0 6c 10 80 	movzbl -0x7fef9320(%edx),%eax
80102239:	31 c1                	xor    %eax,%ecx
8010223b:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102241:	89 c8                	mov    %ecx,%eax
80102243:	83 e0 03             	and    $0x3,%eax
80102246:	8b 04 85 c0 6c 10 80 	mov    -0x7fef9340(,%eax,4),%eax
8010224d:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102251:	f6 c1 08             	test   $0x8,%cl
80102254:	74 56                	je     801022ac <kbdgetc+0xc4>
    if('a' <= c && c <= 'z')
80102256:	8d 50 9f             	lea    -0x61(%eax),%edx
80102259:	83 fa 19             	cmp    $0x19,%edx
8010225c:	77 3d                	ja     8010229b <kbdgetc+0xb3>
      c += 'A' - 'a';
8010225e:	83 e8 20             	sub    $0x20,%eax
80102261:	c3                   	ret    
    shift |= E0ESC;
80102262:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
80102269:	b8 00 00 00 00       	mov    $0x0,%eax
8010226e:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
8010226f:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
80102275:	f6 c1 40             	test   $0x40,%cl
80102278:	75 05                	jne    8010227f <kbdgetc+0x97>
8010227a:	89 c2                	mov    %eax,%edx
8010227c:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
8010227f:	0f b6 82 e0 6d 10 80 	movzbl -0x7fef9220(%edx),%eax
80102286:	83 c8 40             	or     $0x40,%eax
80102289:	0f b6 c0             	movzbl %al,%eax
8010228c:	f7 d0                	not    %eax
8010228e:	21 c8                	and    %ecx,%eax
80102290:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
80102295:	b8 00 00 00 00       	mov    $0x0,%eax
8010229a:	c3                   	ret    
    else if('A' <= c && c <= 'Z')
8010229b:	8d 50 bf             	lea    -0x41(%eax),%edx
8010229e:	83 fa 19             	cmp    $0x19,%edx
801022a1:	77 09                	ja     801022ac <kbdgetc+0xc4>
      c += 'a' - 'A';
801022a3:	83 c0 20             	add    $0x20,%eax
  }
  return c;
801022a6:	c3                   	ret    
    return -1;
801022a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801022ac:	c3                   	ret    

801022ad <kbdintr>:

void
kbdintr(void)
{
801022ad:	f3 0f 1e fb          	endbr32 
801022b1:	55                   	push   %ebp
801022b2:	89 e5                	mov    %esp,%ebp
801022b4:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801022b7:	68 e8 21 10 80       	push   $0x801021e8
801022bc:	e8 bd e4 ff ff       	call   8010077e <consoleintr>
}
801022c1:	83 c4 10             	add    $0x10,%esp
801022c4:	c9                   	leave  
801022c5:	c3                   	ret    

801022c6 <lapicw>:

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801022c6:	8b 0d dc 67 11 80    	mov    0x801167dc,%ecx
801022cc:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801022cf:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
801022d1:	a1 dc 67 11 80       	mov    0x801167dc,%eax
801022d6:	8b 40 20             	mov    0x20(%eax),%eax
}
801022d9:	c3                   	ret    

801022da <cmos_read>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022da:	ba 70 00 00 00       	mov    $0x70,%edx
801022df:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022e0:	ba 71 00 00 00       	mov    $0x71,%edx
801022e5:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
801022e6:	0f b6 c0             	movzbl %al,%eax
}
801022e9:	c3                   	ret    

801022ea <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801022ea:	55                   	push   %ebp
801022eb:	89 e5                	mov    %esp,%ebp
801022ed:	53                   	push   %ebx
801022ee:	83 ec 04             	sub    $0x4,%esp
801022f1:	89 c3                	mov    %eax,%ebx
  r->second = cmos_read(SECS);
801022f3:	b8 00 00 00 00       	mov    $0x0,%eax
801022f8:	e8 dd ff ff ff       	call   801022da <cmos_read>
801022fd:	89 03                	mov    %eax,(%ebx)
  r->minute = cmos_read(MINS);
801022ff:	b8 02 00 00 00       	mov    $0x2,%eax
80102304:	e8 d1 ff ff ff       	call   801022da <cmos_read>
80102309:	89 43 04             	mov    %eax,0x4(%ebx)
  r->hour   = cmos_read(HOURS);
8010230c:	b8 04 00 00 00       	mov    $0x4,%eax
80102311:	e8 c4 ff ff ff       	call   801022da <cmos_read>
80102316:	89 43 08             	mov    %eax,0x8(%ebx)
  r->day    = cmos_read(DAY);
80102319:	b8 07 00 00 00       	mov    $0x7,%eax
8010231e:	e8 b7 ff ff ff       	call   801022da <cmos_read>
80102323:	89 43 0c             	mov    %eax,0xc(%ebx)
  r->month  = cmos_read(MONTH);
80102326:	b8 08 00 00 00       	mov    $0x8,%eax
8010232b:	e8 aa ff ff ff       	call   801022da <cmos_read>
80102330:	89 43 10             	mov    %eax,0x10(%ebx)
  r->year   = cmos_read(YEAR);
80102333:	b8 09 00 00 00       	mov    $0x9,%eax
80102338:	e8 9d ff ff ff       	call   801022da <cmos_read>
8010233d:	89 43 14             	mov    %eax,0x14(%ebx)
}
80102340:	83 c4 04             	add    $0x4,%esp
80102343:	5b                   	pop    %ebx
80102344:	5d                   	pop    %ebp
80102345:	c3                   	ret    

80102346 <lapicinit>:
{
80102346:	f3 0f 1e fb          	endbr32 
  if(!lapic)
8010234a:	83 3d dc 67 11 80 00 	cmpl   $0x0,0x801167dc
80102351:	0f 84 fe 00 00 00    	je     80102455 <lapicinit+0x10f>
{
80102357:	55                   	push   %ebp
80102358:	89 e5                	mov    %esp,%ebp
8010235a:	83 ec 08             	sub    $0x8,%esp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
8010235d:	ba 3f 01 00 00       	mov    $0x13f,%edx
80102362:	b8 3c 00 00 00       	mov    $0x3c,%eax
80102367:	e8 5a ff ff ff       	call   801022c6 <lapicw>
  lapicw(TDCR, X1);
8010236c:	ba 0b 00 00 00       	mov    $0xb,%edx
80102371:	b8 f8 00 00 00       	mov    $0xf8,%eax
80102376:	e8 4b ff ff ff       	call   801022c6 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
8010237b:	ba 20 00 02 00       	mov    $0x20020,%edx
80102380:	b8 c8 00 00 00       	mov    $0xc8,%eax
80102385:	e8 3c ff ff ff       	call   801022c6 <lapicw>
  lapicw(TICR, 1000000);
8010238a:	ba 40 42 0f 00       	mov    $0xf4240,%edx
8010238f:	b8 e0 00 00 00       	mov    $0xe0,%eax
80102394:	e8 2d ff ff ff       	call   801022c6 <lapicw>
  lapicw(LINT0, MASKED);
80102399:	ba 00 00 01 00       	mov    $0x10000,%edx
8010239e:	b8 d4 00 00 00       	mov    $0xd4,%eax
801023a3:	e8 1e ff ff ff       	call   801022c6 <lapicw>
  lapicw(LINT1, MASKED);
801023a8:	ba 00 00 01 00       	mov    $0x10000,%edx
801023ad:	b8 d8 00 00 00       	mov    $0xd8,%eax
801023b2:	e8 0f ff ff ff       	call   801022c6 <lapicw>
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801023b7:	a1 dc 67 11 80       	mov    0x801167dc,%eax
801023bc:	8b 40 30             	mov    0x30(%eax),%eax
801023bf:	c1 e8 10             	shr    $0x10,%eax
801023c2:	a8 fc                	test   $0xfc,%al
801023c4:	75 7b                	jne    80102441 <lapicinit+0xfb>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
801023c6:	ba 33 00 00 00       	mov    $0x33,%edx
801023cb:	b8 dc 00 00 00       	mov    $0xdc,%eax
801023d0:	e8 f1 fe ff ff       	call   801022c6 <lapicw>
  lapicw(ESR, 0);
801023d5:	ba 00 00 00 00       	mov    $0x0,%edx
801023da:	b8 a0 00 00 00       	mov    $0xa0,%eax
801023df:	e8 e2 fe ff ff       	call   801022c6 <lapicw>
  lapicw(ESR, 0);
801023e4:	ba 00 00 00 00       	mov    $0x0,%edx
801023e9:	b8 a0 00 00 00       	mov    $0xa0,%eax
801023ee:	e8 d3 fe ff ff       	call   801022c6 <lapicw>
  lapicw(EOI, 0);
801023f3:	ba 00 00 00 00       	mov    $0x0,%edx
801023f8:	b8 2c 00 00 00       	mov    $0x2c,%eax
801023fd:	e8 c4 fe ff ff       	call   801022c6 <lapicw>
  lapicw(ICRHI, 0);
80102402:	ba 00 00 00 00       	mov    $0x0,%edx
80102407:	b8 c4 00 00 00       	mov    $0xc4,%eax
8010240c:	e8 b5 fe ff ff       	call   801022c6 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102411:	ba 00 85 08 00       	mov    $0x88500,%edx
80102416:	b8 c0 00 00 00       	mov    $0xc0,%eax
8010241b:	e8 a6 fe ff ff       	call   801022c6 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102420:	a1 dc 67 11 80       	mov    0x801167dc,%eax
80102425:	8b 80 00 03 00 00    	mov    0x300(%eax),%eax
8010242b:	f6 c4 10             	test   $0x10,%ah
8010242e:	75 f0                	jne    80102420 <lapicinit+0xda>
  lapicw(TPR, 0);
80102430:	ba 00 00 00 00       	mov    $0x0,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	e8 87 fe ff ff       	call   801022c6 <lapicw>
}
8010243f:	c9                   	leave  
80102440:	c3                   	ret    
    lapicw(PCINT, MASKED);
80102441:	ba 00 00 01 00       	mov    $0x10000,%edx
80102446:	b8 d0 00 00 00       	mov    $0xd0,%eax
8010244b:	e8 76 fe ff ff       	call   801022c6 <lapicw>
80102450:	e9 71 ff ff ff       	jmp    801023c6 <lapicinit+0x80>
80102455:	c3                   	ret    

80102456 <lapicid>:
{
80102456:	f3 0f 1e fb          	endbr32 
  if (!lapic)
8010245a:	a1 dc 67 11 80       	mov    0x801167dc,%eax
8010245f:	85 c0                	test   %eax,%eax
80102461:	74 07                	je     8010246a <lapicid+0x14>
  return lapic[ID] >> 24;
80102463:	8b 40 20             	mov    0x20(%eax),%eax
80102466:	c1 e8 18             	shr    $0x18,%eax
80102469:	c3                   	ret    
    return 0;
8010246a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010246f:	c3                   	ret    

80102470 <lapiceoi>:
{
80102470:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102474:	83 3d dc 67 11 80 00 	cmpl   $0x0,0x801167dc
8010247b:	74 17                	je     80102494 <lapiceoi+0x24>
{
8010247d:	55                   	push   %ebp
8010247e:	89 e5                	mov    %esp,%ebp
80102480:	83 ec 08             	sub    $0x8,%esp
    lapicw(EOI, 0);
80102483:	ba 00 00 00 00       	mov    $0x0,%edx
80102488:	b8 2c 00 00 00       	mov    $0x2c,%eax
8010248d:	e8 34 fe ff ff       	call   801022c6 <lapicw>
}
80102492:	c9                   	leave  
80102493:	c3                   	ret    
80102494:	c3                   	ret    

80102495 <microdelay>:
{
80102495:	f3 0f 1e fb          	endbr32 
}
80102499:	c3                   	ret    

8010249a <lapicstartap>:
{
8010249a:	f3 0f 1e fb          	endbr32 
8010249e:	55                   	push   %ebp
8010249f:	89 e5                	mov    %esp,%ebp
801024a1:	57                   	push   %edi
801024a2:	56                   	push   %esi
801024a3:	53                   	push   %ebx
801024a4:	83 ec 0c             	sub    $0xc,%esp
801024a7:	8b 75 08             	mov    0x8(%ebp),%esi
801024aa:	8b 7d 0c             	mov    0xc(%ebp),%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801024b2:	ba 70 00 00 00       	mov    $0x70,%edx
801024b7:	ee                   	out    %al,(%dx)
801024b8:	b8 0a 00 00 00       	mov    $0xa,%eax
801024bd:	ba 71 00 00 00       	mov    $0x71,%edx
801024c2:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
801024c3:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
801024ca:	00 00 
  wrv[1] = addr >> 4;
801024cc:	89 f8                	mov    %edi,%eax
801024ce:	c1 e8 04             	shr    $0x4,%eax
801024d1:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapicw(ICRHI, apicid<<24);
801024d7:	c1 e6 18             	shl    $0x18,%esi
801024da:	89 f2                	mov    %esi,%edx
801024dc:	b8 c4 00 00 00       	mov    $0xc4,%eax
801024e1:	e8 e0 fd ff ff       	call   801022c6 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801024e6:	ba 00 c5 00 00       	mov    $0xc500,%edx
801024eb:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024f0:	e8 d1 fd ff ff       	call   801022c6 <lapicw>
  lapicw(ICRLO, INIT | LEVEL);
801024f5:	ba 00 85 00 00       	mov    $0x8500,%edx
801024fa:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024ff:	e8 c2 fd ff ff       	call   801022c6 <lapicw>
  for(i = 0; i < 2; i++){
80102504:	bb 00 00 00 00       	mov    $0x0,%ebx
80102509:	eb 21                	jmp    8010252c <lapicstartap+0x92>
    lapicw(ICRHI, apicid<<24);
8010250b:	89 f2                	mov    %esi,%edx
8010250d:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102512:	e8 af fd ff ff       	call   801022c6 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102517:	89 fa                	mov    %edi,%edx
80102519:	c1 ea 0c             	shr    $0xc,%edx
8010251c:	80 ce 06             	or     $0x6,%dh
8010251f:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102524:	e8 9d fd ff ff       	call   801022c6 <lapicw>
  for(i = 0; i < 2; i++){
80102529:	83 c3 01             	add    $0x1,%ebx
8010252c:	83 fb 01             	cmp    $0x1,%ebx
8010252f:	7e da                	jle    8010250b <lapicstartap+0x71>
}
80102531:	83 c4 0c             	add    $0xc,%esp
80102534:	5b                   	pop    %ebx
80102535:	5e                   	pop    %esi
80102536:	5f                   	pop    %edi
80102537:	5d                   	pop    %ebp
80102538:	c3                   	ret    

80102539 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102539:	f3 0f 1e fb          	endbr32 
8010253d:	55                   	push   %ebp
8010253e:	89 e5                	mov    %esp,%ebp
80102540:	57                   	push   %edi
80102541:	56                   	push   %esi
80102542:	53                   	push   %ebx
80102543:	83 ec 3c             	sub    $0x3c,%esp
80102546:	8b 75 08             	mov    0x8(%ebp),%esi
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80102549:	b8 0b 00 00 00       	mov    $0xb,%eax
8010254e:	e8 87 fd ff ff       	call   801022da <cmos_read>

  bcd = (sb & (1 << 2)) == 0;
80102553:	83 e0 04             	and    $0x4,%eax
80102556:	89 c7                	mov    %eax,%edi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80102558:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010255b:	e8 8a fd ff ff       	call   801022ea <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102560:	b8 0a 00 00 00       	mov    $0xa,%eax
80102565:	e8 70 fd ff ff       	call   801022da <cmos_read>
8010256a:	a8 80                	test   $0x80,%al
8010256c:	75 ea                	jne    80102558 <cmostime+0x1f>
        continue;
    fill_rtcdate(&t2);
8010256e:	8d 5d b8             	lea    -0x48(%ebp),%ebx
80102571:	89 d8                	mov    %ebx,%eax
80102573:	e8 72 fd ff ff       	call   801022ea <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102578:	83 ec 04             	sub    $0x4,%esp
8010257b:	6a 18                	push   $0x18
8010257d:	53                   	push   %ebx
8010257e:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102581:	50                   	push   %eax
80102582:	e8 19 1b 00 00       	call   801040a0 <memcmp>
80102587:	83 c4 10             	add    $0x10,%esp
8010258a:	85 c0                	test   %eax,%eax
8010258c:	75 ca                	jne    80102558 <cmostime+0x1f>
      break;
  }

  // convert
  if(bcd) {
8010258e:	85 ff                	test   %edi,%edi
80102590:	75 78                	jne    8010260a <cmostime+0xd1>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102592:	8b 45 d0             	mov    -0x30(%ebp),%eax
80102595:	89 c2                	mov    %eax,%edx
80102597:	c1 ea 04             	shr    $0x4,%edx
8010259a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010259d:	83 e0 0f             	and    $0xf,%eax
801025a0:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025a3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
801025a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801025a9:	89 c2                	mov    %eax,%edx
801025ab:	c1 ea 04             	shr    $0x4,%edx
801025ae:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025b1:	83 e0 0f             	and    $0xf,%eax
801025b4:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025b7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
801025ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
801025bd:	89 c2                	mov    %eax,%edx
801025bf:	c1 ea 04             	shr    $0x4,%edx
801025c2:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025c5:	83 e0 0f             	and    $0xf,%eax
801025c8:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
801025ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
801025d1:	89 c2                	mov    %eax,%edx
801025d3:	c1 ea 04             	shr    $0x4,%edx
801025d6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025d9:	83 e0 0f             	and    $0xf,%eax
801025dc:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025df:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
801025e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801025e5:	89 c2                	mov    %eax,%edx
801025e7:	c1 ea 04             	shr    $0x4,%edx
801025ea:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025ed:	83 e0 0f             	and    $0xf,%eax
801025f0:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
801025f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801025f9:	89 c2                	mov    %eax,%edx
801025fb:	c1 ea 04             	shr    $0x4,%edx
801025fe:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102601:	83 e0 0f             	and    $0xf,%eax
80102604:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102607:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
8010260a:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010260d:	89 06                	mov    %eax,(%esi)
8010260f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80102612:	89 46 04             	mov    %eax,0x4(%esi)
80102615:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102618:	89 46 08             	mov    %eax,0x8(%esi)
8010261b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010261e:	89 46 0c             	mov    %eax,0xc(%esi)
80102621:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102624:	89 46 10             	mov    %eax,0x10(%esi)
80102627:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010262a:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
8010262d:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102634:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102637:	5b                   	pop    %ebx
80102638:	5e                   	pop    %esi
80102639:	5f                   	pop    %edi
8010263a:	5d                   	pop    %ebp
8010263b:	c3                   	ret    

8010263c <read_head>:
}

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010263c:	55                   	push   %ebp
8010263d:	89 e5                	mov    %esp,%ebp
8010263f:	53                   	push   %ebx
80102640:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102643:	ff 35 14 68 11 80    	pushl  0x80116814
80102649:	ff 35 24 68 11 80    	pushl  0x80116824
8010264f:	e8 1c db ff ff       	call   80100170 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102654:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102657:	89 1d 28 68 11 80    	mov    %ebx,0x80116828
  for (i = 0; i < log.lh.n; i++) {
8010265d:	83 c4 10             	add    $0x10,%esp
80102660:	ba 00 00 00 00       	mov    $0x0,%edx
80102665:	39 d3                	cmp    %edx,%ebx
80102667:	7e 10                	jle    80102679 <read_head+0x3d>
    log.lh.block[i] = lh->block[i];
80102669:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
8010266d:	89 0c 95 2c 68 11 80 	mov    %ecx,-0x7fee97d4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102674:	83 c2 01             	add    $0x1,%edx
80102677:	eb ec                	jmp    80102665 <read_head+0x29>
  }
  brelse(buf);
80102679:	83 ec 0c             	sub    $0xc,%esp
8010267c:	50                   	push   %eax
8010267d:	e8 5f db ff ff       	call   801001e1 <brelse>
}
80102682:	83 c4 10             	add    $0x10,%esp
80102685:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102688:	c9                   	leave  
80102689:	c3                   	ret    

8010268a <install_trans>:
{
8010268a:	55                   	push   %ebp
8010268b:	89 e5                	mov    %esp,%ebp
8010268d:	57                   	push   %edi
8010268e:	56                   	push   %esi
8010268f:	53                   	push   %ebx
80102690:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80102693:	be 00 00 00 00       	mov    $0x0,%esi
80102698:	39 35 28 68 11 80    	cmp    %esi,0x80116828
8010269e:	7e 68                	jle    80102708 <install_trans+0x7e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801026a0:	89 f0                	mov    %esi,%eax
801026a2:	03 05 14 68 11 80    	add    0x80116814,%eax
801026a8:	83 c0 01             	add    $0x1,%eax
801026ab:	83 ec 08             	sub    $0x8,%esp
801026ae:	50                   	push   %eax
801026af:	ff 35 24 68 11 80    	pushl  0x80116824
801026b5:	e8 b6 da ff ff       	call   80100170 <bread>
801026ba:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801026bc:	83 c4 08             	add    $0x8,%esp
801026bf:	ff 34 b5 2c 68 11 80 	pushl  -0x7fee97d4(,%esi,4)
801026c6:	ff 35 24 68 11 80    	pushl  0x80116824
801026cc:	e8 9f da ff ff       	call   80100170 <bread>
801026d1:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801026d3:	8d 57 5c             	lea    0x5c(%edi),%edx
801026d6:	8d 40 5c             	lea    0x5c(%eax),%eax
801026d9:	83 c4 0c             	add    $0xc,%esp
801026dc:	68 00 02 00 00       	push   $0x200
801026e1:	52                   	push   %edx
801026e2:	50                   	push   %eax
801026e3:	e8 f1 19 00 00       	call   801040d9 <memmove>
    bwrite(dbuf);  // write dst to disk
801026e8:	89 1c 24             	mov    %ebx,(%esp)
801026eb:	e8 b2 da ff ff       	call   801001a2 <bwrite>
    brelse(lbuf);
801026f0:	89 3c 24             	mov    %edi,(%esp)
801026f3:	e8 e9 da ff ff       	call   801001e1 <brelse>
    brelse(dbuf);
801026f8:	89 1c 24             	mov    %ebx,(%esp)
801026fb:	e8 e1 da ff ff       	call   801001e1 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102700:	83 c6 01             	add    $0x1,%esi
80102703:	83 c4 10             	add    $0x10,%esp
80102706:	eb 90                	jmp    80102698 <install_trans+0xe>
}
80102708:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010270b:	5b                   	pop    %ebx
8010270c:	5e                   	pop    %esi
8010270d:	5f                   	pop    %edi
8010270e:	5d                   	pop    %ebp
8010270f:	c3                   	ret    

80102710 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102710:	55                   	push   %ebp
80102711:	89 e5                	mov    %esp,%ebp
80102713:	53                   	push   %ebx
80102714:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102717:	ff 35 14 68 11 80    	pushl  0x80116814
8010271d:	ff 35 24 68 11 80    	pushl  0x80116824
80102723:	e8 48 da ff ff       	call   80100170 <bread>
80102728:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
8010272a:	8b 0d 28 68 11 80    	mov    0x80116828,%ecx
80102730:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102733:	83 c4 10             	add    $0x10,%esp
80102736:	b8 00 00 00 00       	mov    $0x0,%eax
8010273b:	39 c1                	cmp    %eax,%ecx
8010273d:	7e 10                	jle    8010274f <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
8010273f:	8b 14 85 2c 68 11 80 	mov    -0x7fee97d4(,%eax,4),%edx
80102746:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
8010274a:	83 c0 01             	add    $0x1,%eax
8010274d:	eb ec                	jmp    8010273b <write_head+0x2b>
  }
  bwrite(buf);
8010274f:	83 ec 0c             	sub    $0xc,%esp
80102752:	53                   	push   %ebx
80102753:	e8 4a da ff ff       	call   801001a2 <bwrite>
  brelse(buf);
80102758:	89 1c 24             	mov    %ebx,(%esp)
8010275b:	e8 81 da ff ff       	call   801001e1 <brelse>
}
80102760:	83 c4 10             	add    $0x10,%esp
80102763:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102766:	c9                   	leave  
80102767:	c3                   	ret    

80102768 <recover_from_log>:

static void
recover_from_log(void)
{
80102768:	55                   	push   %ebp
80102769:	89 e5                	mov    %esp,%ebp
8010276b:	83 ec 08             	sub    $0x8,%esp
  read_head();
8010276e:	e8 c9 fe ff ff       	call   8010263c <read_head>
  install_trans(); // if committed, copy from log to disk
80102773:	e8 12 ff ff ff       	call   8010268a <install_trans>
  log.lh.n = 0;
80102778:	c7 05 28 68 11 80 00 	movl   $0x0,0x80116828
8010277f:	00 00 00 
  write_head(); // clear the log
80102782:	e8 89 ff ff ff       	call   80102710 <write_head>
}
80102787:	c9                   	leave  
80102788:	c3                   	ret    

80102789 <write_log>:
}

// Copy modified blocks from cache to log.
static void
write_log(void)
{
80102789:	55                   	push   %ebp
8010278a:	89 e5                	mov    %esp,%ebp
8010278c:	57                   	push   %edi
8010278d:	56                   	push   %esi
8010278e:	53                   	push   %ebx
8010278f:	83 ec 0c             	sub    $0xc,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102792:	be 00 00 00 00       	mov    $0x0,%esi
80102797:	39 35 28 68 11 80    	cmp    %esi,0x80116828
8010279d:	7e 68                	jle    80102807 <write_log+0x7e>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010279f:	89 f0                	mov    %esi,%eax
801027a1:	03 05 14 68 11 80    	add    0x80116814,%eax
801027a7:	83 c0 01             	add    $0x1,%eax
801027aa:	83 ec 08             	sub    $0x8,%esp
801027ad:	50                   	push   %eax
801027ae:	ff 35 24 68 11 80    	pushl  0x80116824
801027b4:	e8 b7 d9 ff ff       	call   80100170 <bread>
801027b9:	89 c3                	mov    %eax,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801027bb:	83 c4 08             	add    $0x8,%esp
801027be:	ff 34 b5 2c 68 11 80 	pushl  -0x7fee97d4(,%esi,4)
801027c5:	ff 35 24 68 11 80    	pushl  0x80116824
801027cb:	e8 a0 d9 ff ff       	call   80100170 <bread>
801027d0:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801027d2:	8d 50 5c             	lea    0x5c(%eax),%edx
801027d5:	8d 43 5c             	lea    0x5c(%ebx),%eax
801027d8:	83 c4 0c             	add    $0xc,%esp
801027db:	68 00 02 00 00       	push   $0x200
801027e0:	52                   	push   %edx
801027e1:	50                   	push   %eax
801027e2:	e8 f2 18 00 00       	call   801040d9 <memmove>
    bwrite(to);  // write the log
801027e7:	89 1c 24             	mov    %ebx,(%esp)
801027ea:	e8 b3 d9 ff ff       	call   801001a2 <bwrite>
    brelse(from);
801027ef:	89 3c 24             	mov    %edi,(%esp)
801027f2:	e8 ea d9 ff ff       	call   801001e1 <brelse>
    brelse(to);
801027f7:	89 1c 24             	mov    %ebx,(%esp)
801027fa:	e8 e2 d9 ff ff       	call   801001e1 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801027ff:	83 c6 01             	add    $0x1,%esi
80102802:	83 c4 10             	add    $0x10,%esp
80102805:	eb 90                	jmp    80102797 <write_log+0xe>
  }
}
80102807:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010280a:	5b                   	pop    %ebx
8010280b:	5e                   	pop    %esi
8010280c:	5f                   	pop    %edi
8010280d:	5d                   	pop    %ebp
8010280e:	c3                   	ret    

8010280f <commit>:

static void
commit()
{
  if (log.lh.n > 0) {
8010280f:	83 3d 28 68 11 80 00 	cmpl   $0x0,0x80116828
80102816:	7f 01                	jg     80102819 <commit+0xa>
80102818:	c3                   	ret    
{
80102819:	55                   	push   %ebp
8010281a:	89 e5                	mov    %esp,%ebp
8010281c:	83 ec 08             	sub    $0x8,%esp
    write_log();     // Write modified blocks from cache to log
8010281f:	e8 65 ff ff ff       	call   80102789 <write_log>
    write_head();    // Write header to disk -- the real commit
80102824:	e8 e7 fe ff ff       	call   80102710 <write_head>
    install_trans(); // Now install writes to home locations
80102829:	e8 5c fe ff ff       	call   8010268a <install_trans>
    log.lh.n = 0;
8010282e:	c7 05 28 68 11 80 00 	movl   $0x0,0x80116828
80102835:	00 00 00 
    write_head();    // Erase the transaction from the log
80102838:	e8 d3 fe ff ff       	call   80102710 <write_head>
  }
}
8010283d:	c9                   	leave  
8010283e:	c3                   	ret    

8010283f <initlog>:
{
8010283f:	f3 0f 1e fb          	endbr32 
80102843:	55                   	push   %ebp
80102844:	89 e5                	mov    %esp,%ebp
80102846:	53                   	push   %ebx
80102847:	83 ec 2c             	sub    $0x2c,%esp
8010284a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010284d:	68 e0 6e 10 80       	push   $0x80106ee0
80102852:	68 e0 67 11 80       	push   $0x801167e0
80102857:	e8 f9 15 00 00       	call   80103e55 <initlock>
  readsb(dev, &sb);
8010285c:	83 c4 08             	add    $0x8,%esp
8010285f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102862:	50                   	push   %eax
80102863:	53                   	push   %ebx
80102864:	e8 3b ea ff ff       	call   801012a4 <readsb>
  log.start = sb.logstart;
80102869:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010286c:	a3 14 68 11 80       	mov    %eax,0x80116814
  log.size = sb.nlog;
80102871:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102874:	a3 18 68 11 80       	mov    %eax,0x80116818
  log.dev = dev;
80102879:	89 1d 24 68 11 80    	mov    %ebx,0x80116824
  recover_from_log();
8010287f:	e8 e4 fe ff ff       	call   80102768 <recover_from_log>
}
80102884:	83 c4 10             	add    $0x10,%esp
80102887:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010288a:	c9                   	leave  
8010288b:	c3                   	ret    

8010288c <begin_op>:
{
8010288c:	f3 0f 1e fb          	endbr32 
80102890:	55                   	push   %ebp
80102891:	89 e5                	mov    %esp,%ebp
80102893:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102896:	68 e0 67 11 80       	push   $0x801167e0
8010289b:	e8 05 17 00 00       	call   80103fa5 <acquire>
801028a0:	83 c4 10             	add    $0x10,%esp
801028a3:	eb 15                	jmp    801028ba <begin_op+0x2e>
      sleep(&log, &log.lock);
801028a5:	83 ec 08             	sub    $0x8,%esp
801028a8:	68 e0 67 11 80       	push   $0x801167e0
801028ad:	68 e0 67 11 80       	push   $0x801167e0
801028b2:	e8 70 0f 00 00       	call   80103827 <sleep>
801028b7:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801028ba:	83 3d 20 68 11 80 00 	cmpl   $0x0,0x80116820
801028c1:	75 e2                	jne    801028a5 <begin_op+0x19>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801028c3:	a1 1c 68 11 80       	mov    0x8011681c,%eax
801028c8:	83 c0 01             	add    $0x1,%eax
801028cb:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801028ce:	8d 14 09             	lea    (%ecx,%ecx,1),%edx
801028d1:	03 15 28 68 11 80    	add    0x80116828,%edx
801028d7:	83 fa 1e             	cmp    $0x1e,%edx
801028da:	7e 17                	jle    801028f3 <begin_op+0x67>
      sleep(&log, &log.lock);
801028dc:	83 ec 08             	sub    $0x8,%esp
801028df:	68 e0 67 11 80       	push   $0x801167e0
801028e4:	68 e0 67 11 80       	push   $0x801167e0
801028e9:	e8 39 0f 00 00       	call   80103827 <sleep>
801028ee:	83 c4 10             	add    $0x10,%esp
801028f1:	eb c7                	jmp    801028ba <begin_op+0x2e>
      log.outstanding += 1;
801028f3:	a3 1c 68 11 80       	mov    %eax,0x8011681c
      release(&log.lock);
801028f8:	83 ec 0c             	sub    $0xc,%esp
801028fb:	68 e0 67 11 80       	push   $0x801167e0
80102900:	e8 09 17 00 00       	call   8010400e <release>
}
80102905:	83 c4 10             	add    $0x10,%esp
80102908:	c9                   	leave  
80102909:	c3                   	ret    

8010290a <end_op>:
{
8010290a:	f3 0f 1e fb          	endbr32 
8010290e:	55                   	push   %ebp
8010290f:	89 e5                	mov    %esp,%ebp
80102911:	53                   	push   %ebx
80102912:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
80102915:	68 e0 67 11 80       	push   $0x801167e0
8010291a:	e8 86 16 00 00       	call   80103fa5 <acquire>
  log.outstanding -= 1;
8010291f:	a1 1c 68 11 80       	mov    0x8011681c,%eax
80102924:	83 e8 01             	sub    $0x1,%eax
80102927:	a3 1c 68 11 80       	mov    %eax,0x8011681c
  if(log.committing)
8010292c:	8b 1d 20 68 11 80    	mov    0x80116820,%ebx
80102932:	83 c4 10             	add    $0x10,%esp
80102935:	85 db                	test   %ebx,%ebx
80102937:	75 2c                	jne    80102965 <end_op+0x5b>
  if(log.outstanding == 0){
80102939:	85 c0                	test   %eax,%eax
8010293b:	75 35                	jne    80102972 <end_op+0x68>
    log.committing = 1;
8010293d:	c7 05 20 68 11 80 01 	movl   $0x1,0x80116820
80102944:	00 00 00 
    do_commit = 1;
80102947:	bb 01 00 00 00       	mov    $0x1,%ebx
  release(&log.lock);
8010294c:	83 ec 0c             	sub    $0xc,%esp
8010294f:	68 e0 67 11 80       	push   $0x801167e0
80102954:	e8 b5 16 00 00       	call   8010400e <release>
  if(do_commit){
80102959:	83 c4 10             	add    $0x10,%esp
8010295c:	85 db                	test   %ebx,%ebx
8010295e:	75 24                	jne    80102984 <end_op+0x7a>
}
80102960:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102963:	c9                   	leave  
80102964:	c3                   	ret    
    panic("log.committing");
80102965:	83 ec 0c             	sub    $0xc,%esp
80102968:	68 e4 6e 10 80       	push   $0x80106ee4
8010296d:	e8 ea d9 ff ff       	call   8010035c <panic>
    wakeup(&log);
80102972:	83 ec 0c             	sub    $0xc,%esp
80102975:	68 e0 67 11 80       	push   $0x801167e0
8010297a:	e8 17 10 00 00       	call   80103996 <wakeup>
8010297f:	83 c4 10             	add    $0x10,%esp
80102982:	eb c8                	jmp    8010294c <end_op+0x42>
    commit();
80102984:	e8 86 fe ff ff       	call   8010280f <commit>
    acquire(&log.lock);
80102989:	83 ec 0c             	sub    $0xc,%esp
8010298c:	68 e0 67 11 80       	push   $0x801167e0
80102991:	e8 0f 16 00 00       	call   80103fa5 <acquire>
    log.committing = 0;
80102996:	c7 05 20 68 11 80 00 	movl   $0x0,0x80116820
8010299d:	00 00 00 
    wakeup(&log);
801029a0:	c7 04 24 e0 67 11 80 	movl   $0x801167e0,(%esp)
801029a7:	e8 ea 0f 00 00       	call   80103996 <wakeup>
    release(&log.lock);
801029ac:	c7 04 24 e0 67 11 80 	movl   $0x801167e0,(%esp)
801029b3:	e8 56 16 00 00       	call   8010400e <release>
801029b8:	83 c4 10             	add    $0x10,%esp
}
801029bb:	eb a3                	jmp    80102960 <end_op+0x56>

801029bd <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801029bd:	f3 0f 1e fb          	endbr32 
801029c1:	55                   	push   %ebp
801029c2:	89 e5                	mov    %esp,%ebp
801029c4:	53                   	push   %ebx
801029c5:	83 ec 04             	sub    $0x4,%esp
801029c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801029cb:	8b 15 28 68 11 80    	mov    0x80116828,%edx
801029d1:	83 fa 1d             	cmp    $0x1d,%edx
801029d4:	7f 45                	jg     80102a1b <log_write+0x5e>
801029d6:	a1 18 68 11 80       	mov    0x80116818,%eax
801029db:	83 e8 01             	sub    $0x1,%eax
801029de:	39 c2                	cmp    %eax,%edx
801029e0:	7d 39                	jge    80102a1b <log_write+0x5e>
    panic("too big a transaction");
  if (log.outstanding < 1)
801029e2:	83 3d 1c 68 11 80 00 	cmpl   $0x0,0x8011681c
801029e9:	7e 3d                	jle    80102a28 <log_write+0x6b>
    panic("log_write outside of trans");

  acquire(&log.lock);
801029eb:	83 ec 0c             	sub    $0xc,%esp
801029ee:	68 e0 67 11 80       	push   $0x801167e0
801029f3:	e8 ad 15 00 00       	call   80103fa5 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801029f8:	83 c4 10             	add    $0x10,%esp
801029fb:	b8 00 00 00 00       	mov    $0x0,%eax
80102a00:	8b 15 28 68 11 80    	mov    0x80116828,%edx
80102a06:	39 c2                	cmp    %eax,%edx
80102a08:	7e 2b                	jle    80102a35 <log_write+0x78>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102a0a:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102a0d:	39 0c 85 2c 68 11 80 	cmp    %ecx,-0x7fee97d4(,%eax,4)
80102a14:	74 1f                	je     80102a35 <log_write+0x78>
  for (i = 0; i < log.lh.n; i++) {
80102a16:	83 c0 01             	add    $0x1,%eax
80102a19:	eb e5                	jmp    80102a00 <log_write+0x43>
    panic("too big a transaction");
80102a1b:	83 ec 0c             	sub    $0xc,%esp
80102a1e:	68 f3 6e 10 80       	push   $0x80106ef3
80102a23:	e8 34 d9 ff ff       	call   8010035c <panic>
    panic("log_write outside of trans");
80102a28:	83 ec 0c             	sub    $0xc,%esp
80102a2b:	68 09 6f 10 80       	push   $0x80106f09
80102a30:	e8 27 d9 ff ff       	call   8010035c <panic>
      break;
  }
  log.lh.block[i] = b->blockno;
80102a35:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102a38:	89 0c 85 2c 68 11 80 	mov    %ecx,-0x7fee97d4(,%eax,4)
  if (i == log.lh.n)
80102a3f:	39 c2                	cmp    %eax,%edx
80102a41:	74 18                	je     80102a5b <log_write+0x9e>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102a43:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102a46:	83 ec 0c             	sub    $0xc,%esp
80102a49:	68 e0 67 11 80       	push   $0x801167e0
80102a4e:	e8 bb 15 00 00       	call   8010400e <release>
}
80102a53:	83 c4 10             	add    $0x10,%esp
80102a56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a59:	c9                   	leave  
80102a5a:	c3                   	ret    
    log.lh.n++;
80102a5b:	83 c2 01             	add    $0x1,%edx
80102a5e:	89 15 28 68 11 80    	mov    %edx,0x80116828
80102a64:	eb dd                	jmp    80102a43 <log_write+0x86>

80102a66 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80102a66:	55                   	push   %ebp
80102a67:	89 e5                	mov    %esp,%ebp
80102a69:	53                   	push   %ebx
80102a6a:	83 ec 08             	sub    $0x8,%esp

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102a6d:	68 8a 00 00 00       	push   $0x8a
80102a72:	68 8c a4 10 80       	push   $0x8010a48c
80102a77:	68 00 70 00 80       	push   $0x80007000
80102a7c:	e8 58 16 00 00       	call   801040d9 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102a81:	83 c4 10             	add    $0x10,%esp
80102a84:	bb e0 68 11 80       	mov    $0x801168e0,%ebx
80102a89:	eb 47                	jmp    80102ad2 <startothers+0x6c>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102a8b:	e8 ff f6 ff ff       	call   8010218f <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102a90:	05 00 10 00 00       	add    $0x1000,%eax
80102a95:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
80102a9a:	c7 05 f8 6f 00 80 34 	movl   $0x80102b34,0x80006ff8
80102aa1:	2b 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102aa4:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102aab:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
80102aae:	83 ec 08             	sub    $0x8,%esp
80102ab1:	68 00 70 00 00       	push   $0x7000
80102ab6:	0f b6 03             	movzbl (%ebx),%eax
80102ab9:	50                   	push   %eax
80102aba:	e8 db f9 ff ff       	call   8010249a <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102abf:	83 c4 10             	add    $0x10,%esp
80102ac2:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102ac8:	85 c0                	test   %eax,%eax
80102aca:	74 f6                	je     80102ac2 <startothers+0x5c>
  for(c = cpus; c < cpus+ncpu; c++){
80102acc:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102ad2:	69 05 60 6e 11 80 b0 	imul   $0xb0,0x80116e60,%eax
80102ad9:	00 00 00 
80102adc:	05 e0 68 11 80       	add    $0x801168e0,%eax
80102ae1:	39 d8                	cmp    %ebx,%eax
80102ae3:	76 0b                	jbe    80102af0 <startothers+0x8a>
    if(c == mycpu())  // We've started already.
80102ae5:	e8 d2 07 00 00       	call   801032bc <mycpu>
80102aea:	39 c3                	cmp    %eax,%ebx
80102aec:	74 de                	je     80102acc <startothers+0x66>
80102aee:	eb 9b                	jmp    80102a8b <startothers+0x25>
      ;
  }
}
80102af0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102af3:	c9                   	leave  
80102af4:	c3                   	ret    

80102af5 <mpmain>:
{
80102af5:	55                   	push   %ebp
80102af6:	89 e5                	mov    %esp,%ebp
80102af8:	53                   	push   %ebx
80102af9:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102afc:	e8 1b 08 00 00       	call   8010331c <cpuid>
80102b01:	89 c3                	mov    %eax,%ebx
80102b03:	e8 14 08 00 00       	call   8010331c <cpuid>
80102b08:	83 ec 04             	sub    $0x4,%esp
80102b0b:	53                   	push   %ebx
80102b0c:	50                   	push   %eax
80102b0d:	68 24 6f 10 80       	push   $0x80106f24
80102b12:	e8 12 db ff ff       	call   80100629 <cprintf>
  idtinit();       // load idt register
80102b17:	e8 5e 28 00 00       	call   8010537a <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102b1c:	e8 9b 07 00 00       	call   801032bc <mycpu>
80102b21:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102b23:	b8 01 00 00 00       	mov    $0x1,%eax
80102b28:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102b2f:	e8 95 0a 00 00       	call   801035c9 <scheduler>

80102b34 <mpenter>:
{
80102b34:	f3 0f 1e fb          	endbr32 
80102b38:	55                   	push   %ebp
80102b39:	89 e5                	mov    %esp,%ebp
80102b3b:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102b3e:	e8 5e 38 00 00       	call   801063a1 <switchkvm>
  seginit();
80102b43:	e8 09 37 00 00       	call   80106251 <seginit>
  lapicinit();
80102b48:	e8 f9 f7 ff ff       	call   80102346 <lapicinit>
  mpmain();
80102b4d:	e8 a3 ff ff ff       	call   80102af5 <mpmain>

80102b52 <main>:
{
80102b52:	f3 0f 1e fb          	endbr32 
80102b56:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102b5a:	83 e4 f0             	and    $0xfffffff0,%esp
80102b5d:	ff 71 fc             	pushl  -0x4(%ecx)
80102b60:	55                   	push   %ebp
80102b61:	89 e5                	mov    %esp,%ebp
80102b63:	51                   	push   %ecx
80102b64:	83 ec 0c             	sub    $0xc,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102b67:	68 00 00 40 80       	push   $0x80400000
80102b6c:	68 88 76 11 80       	push   $0x80117688
80102b71:	e8 bf f5 ff ff       	call   80102135 <kinit1>
  kvmalloc();      // kernel page table
80102b76:	e8 c9 3c 00 00       	call   80106844 <kvmalloc>
  mpinit();        // detect other processors
80102b7b:	e8 c1 01 00 00       	call   80102d41 <mpinit>
  lapicinit();     // interrupt controller
80102b80:	e8 c1 f7 ff ff       	call   80102346 <lapicinit>
  seginit();       // segment descriptors
80102b85:	e8 c7 36 00 00       	call   80106251 <seginit>
  picinit();       // disable pic
80102b8a:	e8 8c 02 00 00       	call   80102e1b <picinit>
  ioapicinit();    // another interrupt controller
80102b8f:	e8 1c f4 ff ff       	call   80101fb0 <ioapicinit>
  consoleinit();   // console hardware
80102b94:	e8 5a dd ff ff       	call   801008f3 <consoleinit>
  uartinit();      // serial port
80102b99:	e8 9b 2a 00 00       	call   80105639 <uartinit>
  pinit();         // process table
80102b9e:	e8 fb 06 00 00       	call   8010329e <pinit>
  tvinit();        // trap vectors
80102ba3:	e8 39 27 00 00       	call   801052e1 <tvinit>
  binit();         // buffer cache
80102ba8:	e8 47 d5 ff ff       	call   801000f4 <binit>
  fileinit();      // file table
80102bad:	e8 b6 e0 ff ff       	call   80100c68 <fileinit>
  ideinit();       // disk 
80102bb2:	e8 fb f1 ff ff       	call   80101db2 <ideinit>
  startothers();   // start other processors
80102bb7:	e8 aa fe ff ff       	call   80102a66 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102bbc:	83 c4 08             	add    $0x8,%esp
80102bbf:	68 00 00 00 8e       	push   $0x8e000000
80102bc4:	68 00 00 40 80       	push   $0x80400000
80102bc9:	e8 9d f5 ff ff       	call   8010216b <kinit2>
  userinit();      // first user process
80102bce:	e8 90 07 00 00       	call   80103363 <userinit>
  mpmain();        // finish this processor's setup
80102bd3:	e8 1d ff ff ff       	call   80102af5 <mpmain>

80102bd8 <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80102bd8:	55                   	push   %ebp
80102bd9:	89 e5                	mov    %esp,%ebp
80102bdb:	56                   	push   %esi
80102bdc:	53                   	push   %ebx
80102bdd:	89 c6                	mov    %eax,%esi
  int i, sum;

  sum = 0;
80102bdf:	b8 00 00 00 00       	mov    $0x0,%eax
  for(i=0; i<len; i++)
80102be4:	b9 00 00 00 00       	mov    $0x0,%ecx
80102be9:	39 d1                	cmp    %edx,%ecx
80102beb:	7d 0b                	jge    80102bf8 <sum+0x20>
    sum += addr[i];
80102bed:	0f b6 1c 0e          	movzbl (%esi,%ecx,1),%ebx
80102bf1:	01 d8                	add    %ebx,%eax
  for(i=0; i<len; i++)
80102bf3:	83 c1 01             	add    $0x1,%ecx
80102bf6:	eb f1                	jmp    80102be9 <sum+0x11>
  return sum;
}
80102bf8:	5b                   	pop    %ebx
80102bf9:	5e                   	pop    %esi
80102bfa:	5d                   	pop    %ebp
80102bfb:	c3                   	ret    

80102bfc <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102bfc:	55                   	push   %ebp
80102bfd:	89 e5                	mov    %esp,%ebp
80102bff:	56                   	push   %esi
80102c00:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
80102c01:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80102c07:	89 f3                	mov    %esi,%ebx
  e = addr+len;
80102c09:	01 d6                	add    %edx,%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102c0b:	eb 03                	jmp    80102c10 <mpsearch1+0x14>
80102c0d:	83 c3 10             	add    $0x10,%ebx
80102c10:	39 f3                	cmp    %esi,%ebx
80102c12:	73 29                	jae    80102c3d <mpsearch1+0x41>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102c14:	83 ec 04             	sub    $0x4,%esp
80102c17:	6a 04                	push   $0x4
80102c19:	68 38 6f 10 80       	push   $0x80106f38
80102c1e:	53                   	push   %ebx
80102c1f:	e8 7c 14 00 00       	call   801040a0 <memcmp>
80102c24:	83 c4 10             	add    $0x10,%esp
80102c27:	85 c0                	test   %eax,%eax
80102c29:	75 e2                	jne    80102c0d <mpsearch1+0x11>
80102c2b:	ba 10 00 00 00       	mov    $0x10,%edx
80102c30:	89 d8                	mov    %ebx,%eax
80102c32:	e8 a1 ff ff ff       	call   80102bd8 <sum>
80102c37:	84 c0                	test   %al,%al
80102c39:	75 d2                	jne    80102c0d <mpsearch1+0x11>
80102c3b:	eb 05                	jmp    80102c42 <mpsearch1+0x46>
      return (struct mp*)p;
  return 0;
80102c3d:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80102c42:	89 d8                	mov    %ebx,%eax
80102c44:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c47:	5b                   	pop    %ebx
80102c48:	5e                   	pop    %esi
80102c49:	5d                   	pop    %ebp
80102c4a:	c3                   	ret    

80102c4b <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80102c4b:	55                   	push   %ebp
80102c4c:	89 e5                	mov    %esp,%ebp
80102c4e:	83 ec 08             	sub    $0x8,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102c51:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102c58:	c1 e0 08             	shl    $0x8,%eax
80102c5b:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102c62:	09 d0                	or     %edx,%eax
80102c64:	c1 e0 04             	shl    $0x4,%eax
80102c67:	74 1f                	je     80102c88 <mpsearch+0x3d>
    if((mp = mpsearch1(p, 1024)))
80102c69:	ba 00 04 00 00       	mov    $0x400,%edx
80102c6e:	e8 89 ff ff ff       	call   80102bfc <mpsearch1>
80102c73:	85 c0                	test   %eax,%eax
80102c75:	75 0f                	jne    80102c86 <mpsearch+0x3b>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80102c77:	ba 00 00 01 00       	mov    $0x10000,%edx
80102c7c:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102c81:	e8 76 ff ff ff       	call   80102bfc <mpsearch1>
}
80102c86:	c9                   	leave  
80102c87:	c3                   	ret    
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102c88:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102c8f:	c1 e0 08             	shl    $0x8,%eax
80102c92:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102c99:	09 d0                	or     %edx,%eax
80102c9b:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102c9e:	2d 00 04 00 00       	sub    $0x400,%eax
80102ca3:	ba 00 04 00 00       	mov    $0x400,%edx
80102ca8:	e8 4f ff ff ff       	call   80102bfc <mpsearch1>
80102cad:	85 c0                	test   %eax,%eax
80102caf:	75 d5                	jne    80102c86 <mpsearch+0x3b>
80102cb1:	eb c4                	jmp    80102c77 <mpsearch+0x2c>

80102cb3 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80102cb3:	55                   	push   %ebp
80102cb4:	89 e5                	mov    %esp,%ebp
80102cb6:	57                   	push   %edi
80102cb7:	56                   	push   %esi
80102cb8:	53                   	push   %ebx
80102cb9:	83 ec 1c             	sub    $0x1c,%esp
80102cbc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102cbf:	e8 87 ff ff ff       	call   80102c4b <mpsearch>
80102cc4:	89 c3                	mov    %eax,%ebx
80102cc6:	85 c0                	test   %eax,%eax
80102cc8:	74 5a                	je     80102d24 <mpconfig+0x71>
80102cca:	8b 70 04             	mov    0x4(%eax),%esi
80102ccd:	85 f6                	test   %esi,%esi
80102ccf:	74 57                	je     80102d28 <mpconfig+0x75>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102cd1:	8d be 00 00 00 80    	lea    -0x80000000(%esi),%edi
  if(memcmp(conf, "PCMP", 4) != 0)
80102cd7:	83 ec 04             	sub    $0x4,%esp
80102cda:	6a 04                	push   $0x4
80102cdc:	68 3d 6f 10 80       	push   $0x80106f3d
80102ce1:	57                   	push   %edi
80102ce2:	e8 b9 13 00 00       	call   801040a0 <memcmp>
80102ce7:	83 c4 10             	add    $0x10,%esp
80102cea:	85 c0                	test   %eax,%eax
80102cec:	75 3e                	jne    80102d2c <mpconfig+0x79>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80102cee:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80102cf5:	3c 01                	cmp    $0x1,%al
80102cf7:	0f 95 c2             	setne  %dl
80102cfa:	3c 04                	cmp    $0x4,%al
80102cfc:	0f 95 c0             	setne  %al
80102cff:	84 c2                	test   %al,%dl
80102d01:	75 30                	jne    80102d33 <mpconfig+0x80>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80102d03:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80102d0a:	89 f8                	mov    %edi,%eax
80102d0c:	e8 c7 fe ff ff       	call   80102bd8 <sum>
80102d11:	84 c0                	test   %al,%al
80102d13:	75 25                	jne    80102d3a <mpconfig+0x87>
    return 0;
  *pmp = mp;
80102d15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102d18:	89 18                	mov    %ebx,(%eax)
  return conf;
}
80102d1a:	89 f8                	mov    %edi,%eax
80102d1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d1f:	5b                   	pop    %ebx
80102d20:	5e                   	pop    %esi
80102d21:	5f                   	pop    %edi
80102d22:	5d                   	pop    %ebp
80102d23:	c3                   	ret    
    return 0;
80102d24:	89 c7                	mov    %eax,%edi
80102d26:	eb f2                	jmp    80102d1a <mpconfig+0x67>
80102d28:	89 f7                	mov    %esi,%edi
80102d2a:	eb ee                	jmp    80102d1a <mpconfig+0x67>
    return 0;
80102d2c:	bf 00 00 00 00       	mov    $0x0,%edi
80102d31:	eb e7                	jmp    80102d1a <mpconfig+0x67>
    return 0;
80102d33:	bf 00 00 00 00       	mov    $0x0,%edi
80102d38:	eb e0                	jmp    80102d1a <mpconfig+0x67>
    return 0;
80102d3a:	bf 00 00 00 00       	mov    $0x0,%edi
80102d3f:	eb d9                	jmp    80102d1a <mpconfig+0x67>

80102d41 <mpinit>:

void
mpinit(void)
{
80102d41:	f3 0f 1e fb          	endbr32 
80102d45:	55                   	push   %ebp
80102d46:	89 e5                	mov    %esp,%ebp
80102d48:	57                   	push   %edi
80102d49:	56                   	push   %esi
80102d4a:	53                   	push   %ebx
80102d4b:	83 ec 1c             	sub    $0x1c,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102d4e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80102d51:	e8 5d ff ff ff       	call   80102cb3 <mpconfig>
80102d56:	85 c0                	test   %eax,%eax
80102d58:	74 19                	je     80102d73 <mpinit+0x32>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102d5a:	8b 50 24             	mov    0x24(%eax),%edx
80102d5d:	89 15 dc 67 11 80    	mov    %edx,0x801167dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d63:	8d 50 2c             	lea    0x2c(%eax),%edx
80102d66:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
80102d6a:	01 c1                	add    %eax,%ecx
  ismp = 1;
80102d6c:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d71:	eb 20                	jmp    80102d93 <mpinit+0x52>
    panic("Expect to run on an SMP");
80102d73:	83 ec 0c             	sub    $0xc,%esp
80102d76:	68 42 6f 10 80       	push   $0x80106f42
80102d7b:	e8 dc d5 ff ff       	call   8010035c <panic>
    switch(*p){
80102d80:	bb 00 00 00 00       	mov    $0x0,%ebx
80102d85:	eb 0c                	jmp    80102d93 <mpinit+0x52>
80102d87:	83 e8 03             	sub    $0x3,%eax
80102d8a:	3c 01                	cmp    $0x1,%al
80102d8c:	76 1a                	jbe    80102da8 <mpinit+0x67>
80102d8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d93:	39 ca                	cmp    %ecx,%edx
80102d95:	73 4d                	jae    80102de4 <mpinit+0xa3>
    switch(*p){
80102d97:	0f b6 02             	movzbl (%edx),%eax
80102d9a:	3c 02                	cmp    $0x2,%al
80102d9c:	74 38                	je     80102dd6 <mpinit+0x95>
80102d9e:	77 e7                	ja     80102d87 <mpinit+0x46>
80102da0:	84 c0                	test   %al,%al
80102da2:	74 09                	je     80102dad <mpinit+0x6c>
80102da4:	3c 01                	cmp    $0x1,%al
80102da6:	75 d8                	jne    80102d80 <mpinit+0x3f>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102da8:	83 c2 08             	add    $0x8,%edx
      continue;
80102dab:	eb e6                	jmp    80102d93 <mpinit+0x52>
      if(ncpu < NCPU) {
80102dad:	8b 35 60 6e 11 80    	mov    0x80116e60,%esi
80102db3:	83 fe 07             	cmp    $0x7,%esi
80102db6:	7f 19                	jg     80102dd1 <mpinit+0x90>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102db8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
80102dbc:	69 fe b0 00 00 00    	imul   $0xb0,%esi,%edi
80102dc2:	88 87 e0 68 11 80    	mov    %al,-0x7fee9720(%edi)
        ncpu++;
80102dc8:	83 c6 01             	add    $0x1,%esi
80102dcb:	89 35 60 6e 11 80    	mov    %esi,0x80116e60
      p += sizeof(struct mpproc);
80102dd1:	83 c2 14             	add    $0x14,%edx
      continue;
80102dd4:	eb bd                	jmp    80102d93 <mpinit+0x52>
      ioapicid = ioapic->apicno;
80102dd6:	0f b6 42 01          	movzbl 0x1(%edx),%eax
80102dda:	a2 c0 68 11 80       	mov    %al,0x801168c0
      p += sizeof(struct mpioapic);
80102ddf:	83 c2 08             	add    $0x8,%edx
      continue;
80102de2:	eb af                	jmp    80102d93 <mpinit+0x52>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80102de4:	85 db                	test   %ebx,%ebx
80102de6:	74 26                	je     80102e0e <mpinit+0xcd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102de8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102deb:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102def:	74 15                	je     80102e06 <mpinit+0xc5>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102df1:	b8 70 00 00 00       	mov    $0x70,%eax
80102df6:	ba 22 00 00 00       	mov    $0x22,%edx
80102dfb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dfc:	ba 23 00 00 00       	mov    $0x23,%edx
80102e01:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102e02:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e05:	ee                   	out    %al,(%dx)
  }
}
80102e06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e09:	5b                   	pop    %ebx
80102e0a:	5e                   	pop    %esi
80102e0b:	5f                   	pop    %edi
80102e0c:	5d                   	pop    %ebp
80102e0d:	c3                   	ret    
    panic("Didn't find a suitable machine");
80102e0e:	83 ec 0c             	sub    $0xc,%esp
80102e11:	68 5c 6f 10 80       	push   $0x80106f5c
80102e16:	e8 41 d5 ff ff       	call   8010035c <panic>

80102e1b <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80102e1b:	f3 0f 1e fb          	endbr32 
80102e1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102e24:	ba 21 00 00 00       	mov    $0x21,%edx
80102e29:	ee                   	out    %al,(%dx)
80102e2a:	ba a1 00 00 00       	mov    $0xa1,%edx
80102e2f:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102e30:	c3                   	ret    

80102e31 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102e31:	f3 0f 1e fb          	endbr32 
80102e35:	55                   	push   %ebp
80102e36:	89 e5                	mov    %esp,%ebp
80102e38:	57                   	push   %edi
80102e39:	56                   	push   %esi
80102e3a:	53                   	push   %ebx
80102e3b:	83 ec 0c             	sub    $0xc,%esp
80102e3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e41:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102e44:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102e4a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102e50:	e8 31 de ff ff       	call   80100c86 <filealloc>
80102e55:	89 03                	mov    %eax,(%ebx)
80102e57:	85 c0                	test   %eax,%eax
80102e59:	0f 84 88 00 00 00    	je     80102ee7 <pipealloc+0xb6>
80102e5f:	e8 22 de ff ff       	call   80100c86 <filealloc>
80102e64:	89 06                	mov    %eax,(%esi)
80102e66:	85 c0                	test   %eax,%eax
80102e68:	74 7d                	je     80102ee7 <pipealloc+0xb6>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102e6a:	e8 20 f3 ff ff       	call   8010218f <kalloc>
80102e6f:	89 c7                	mov    %eax,%edi
80102e71:	85 c0                	test   %eax,%eax
80102e73:	74 72                	je     80102ee7 <pipealloc+0xb6>
    goto bad;
  p->readopen = 1;
80102e75:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102e7c:	00 00 00 
  p->writeopen = 1;
80102e7f:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102e86:	00 00 00 
  p->nwrite = 0;
80102e89:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102e90:	00 00 00 
  p->nread = 0;
80102e93:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102e9a:	00 00 00 
  initlock(&p->lock, "pipe");
80102e9d:	83 ec 08             	sub    $0x8,%esp
80102ea0:	68 7b 6f 10 80       	push   $0x80106f7b
80102ea5:	50                   	push   %eax
80102ea6:	e8 aa 0f 00 00       	call   80103e55 <initlock>
  (*f0)->type = FD_PIPE;
80102eab:	8b 03                	mov    (%ebx),%eax
80102ead:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102eb3:	8b 03                	mov    (%ebx),%eax
80102eb5:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102eb9:	8b 03                	mov    (%ebx),%eax
80102ebb:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102ebf:	8b 03                	mov    (%ebx),%eax
80102ec1:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102ec4:	8b 06                	mov    (%esi),%eax
80102ec6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102ecc:	8b 06                	mov    (%esi),%eax
80102ece:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102ed2:	8b 06                	mov    (%esi),%eax
80102ed4:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102ed8:	8b 06                	mov    (%esi),%eax
80102eda:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102edd:	83 c4 10             	add    $0x10,%esp
80102ee0:	b8 00 00 00 00       	mov    $0x0,%eax
80102ee5:	eb 29                	jmp    80102f10 <pipealloc+0xdf>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102ee7:	8b 03                	mov    (%ebx),%eax
80102ee9:	85 c0                	test   %eax,%eax
80102eeb:	74 0c                	je     80102ef9 <pipealloc+0xc8>
    fileclose(*f0);
80102eed:	83 ec 0c             	sub    $0xc,%esp
80102ef0:	50                   	push   %eax
80102ef1:	e8 3e de ff ff       	call   80100d34 <fileclose>
80102ef6:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102ef9:	8b 06                	mov    (%esi),%eax
80102efb:	85 c0                	test   %eax,%eax
80102efd:	74 19                	je     80102f18 <pipealloc+0xe7>
    fileclose(*f1);
80102eff:	83 ec 0c             	sub    $0xc,%esp
80102f02:	50                   	push   %eax
80102f03:	e8 2c de ff ff       	call   80100d34 <fileclose>
80102f08:	83 c4 10             	add    $0x10,%esp
  return -1;
80102f0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102f10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f13:	5b                   	pop    %ebx
80102f14:	5e                   	pop    %esi
80102f15:	5f                   	pop    %edi
80102f16:	5d                   	pop    %ebp
80102f17:	c3                   	ret    
  return -1;
80102f18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102f1d:	eb f1                	jmp    80102f10 <pipealloc+0xdf>

80102f1f <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102f1f:	f3 0f 1e fb          	endbr32 
80102f23:	55                   	push   %ebp
80102f24:	89 e5                	mov    %esp,%ebp
80102f26:	53                   	push   %ebx
80102f27:	83 ec 10             	sub    $0x10,%esp
80102f2a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102f2d:	53                   	push   %ebx
80102f2e:	e8 72 10 00 00       	call   80103fa5 <acquire>
  if(writable){
80102f33:	83 c4 10             	add    $0x10,%esp
80102f36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102f3a:	74 3f                	je     80102f7b <pipeclose+0x5c>
    p->writeopen = 0;
80102f3c:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102f43:	00 00 00 
    wakeup(&p->nread);
80102f46:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f4c:	83 ec 0c             	sub    $0xc,%esp
80102f4f:	50                   	push   %eax
80102f50:	e8 41 0a 00 00       	call   80103996 <wakeup>
80102f55:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102f58:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102f5f:	75 09                	jne    80102f6a <pipeclose+0x4b>
80102f61:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102f68:	74 2f                	je     80102f99 <pipeclose+0x7a>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102f6a:	83 ec 0c             	sub    $0xc,%esp
80102f6d:	53                   	push   %ebx
80102f6e:	e8 9b 10 00 00       	call   8010400e <release>
80102f73:	83 c4 10             	add    $0x10,%esp
}
80102f76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f79:	c9                   	leave  
80102f7a:	c3                   	ret    
    p->readopen = 0;
80102f7b:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102f82:	00 00 00 
    wakeup(&p->nwrite);
80102f85:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102f8b:	83 ec 0c             	sub    $0xc,%esp
80102f8e:	50                   	push   %eax
80102f8f:	e8 02 0a 00 00       	call   80103996 <wakeup>
80102f94:	83 c4 10             	add    $0x10,%esp
80102f97:	eb bf                	jmp    80102f58 <pipeclose+0x39>
    release(&p->lock);
80102f99:	83 ec 0c             	sub    $0xc,%esp
80102f9c:	53                   	push   %ebx
80102f9d:	e8 6c 10 00 00       	call   8010400e <release>
    kfree((char*)p);
80102fa2:	89 1c 24             	mov    %ebx,(%esp)
80102fa5:	e8 be f0 ff ff       	call   80102068 <kfree>
80102faa:	83 c4 10             	add    $0x10,%esp
80102fad:	eb c7                	jmp    80102f76 <pipeclose+0x57>

80102faf <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102faf:	f3 0f 1e fb          	endbr32 
80102fb3:	55                   	push   %ebp
80102fb4:	89 e5                	mov    %esp,%ebp
80102fb6:	57                   	push   %edi
80102fb7:	56                   	push   %esi
80102fb8:	53                   	push   %ebx
80102fb9:	83 ec 18             	sub    $0x18,%esp
80102fbc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80102fbf:	89 de                	mov    %ebx,%esi
80102fc1:	53                   	push   %ebx
80102fc2:	e8 de 0f 00 00       	call   80103fa5 <acquire>
  for(i = 0; i < n; i++){
80102fc7:	83 c4 10             	add    $0x10,%esp
80102fca:	bf 00 00 00 00       	mov    $0x0,%edi
80102fcf:	3b 7d 10             	cmp    0x10(%ebp),%edi
80102fd2:	7c 41                	jl     80103015 <pipewrite+0x66>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80102fd4:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102fda:	83 ec 0c             	sub    $0xc,%esp
80102fdd:	50                   	push   %eax
80102fde:	e8 b3 09 00 00       	call   80103996 <wakeup>
  release(&p->lock);
80102fe3:	89 1c 24             	mov    %ebx,(%esp)
80102fe6:	e8 23 10 00 00       	call   8010400e <release>
  return n;
80102feb:	83 c4 10             	add    $0x10,%esp
80102fee:	8b 45 10             	mov    0x10(%ebp),%eax
80102ff1:	eb 5c                	jmp    8010304f <pipewrite+0xa0>
      wakeup(&p->nread);
80102ff3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102ff9:	83 ec 0c             	sub    $0xc,%esp
80102ffc:	50                   	push   %eax
80102ffd:	e8 94 09 00 00       	call   80103996 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103002:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103008:	83 c4 08             	add    $0x8,%esp
8010300b:	56                   	push   %esi
8010300c:	50                   	push   %eax
8010300d:	e8 15 08 00 00       	call   80103827 <sleep>
80103012:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103015:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010301b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103021:	05 00 02 00 00       	add    $0x200,%eax
80103026:	39 c2                	cmp    %eax,%edx
80103028:	75 2d                	jne    80103057 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
8010302a:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80103031:	74 0b                	je     8010303e <pipewrite+0x8f>
80103033:	e8 03 03 00 00       	call   8010333b <myproc>
80103038:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010303c:	74 b5                	je     80102ff3 <pipewrite+0x44>
        release(&p->lock);
8010303e:	83 ec 0c             	sub    $0xc,%esp
80103041:	53                   	push   %ebx
80103042:	e8 c7 0f 00 00       	call   8010400e <release>
        return -1;
80103047:	83 c4 10             	add    $0x10,%esp
8010304a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010304f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103052:	5b                   	pop    %ebx
80103053:	5e                   	pop    %esi
80103054:	5f                   	pop    %edi
80103055:	5d                   	pop    %ebp
80103056:	c3                   	ret    
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103057:	8d 42 01             	lea    0x1(%edx),%eax
8010305a:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103060:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103066:	8b 45 0c             	mov    0xc(%ebp),%eax
80103069:	0f b6 04 38          	movzbl (%eax,%edi,1),%eax
8010306d:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103071:	83 c7 01             	add    $0x1,%edi
80103074:	e9 56 ff ff ff       	jmp    80102fcf <pipewrite+0x20>

80103079 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103079:	f3 0f 1e fb          	endbr32 
8010307d:	55                   	push   %ebp
8010307e:	89 e5                	mov    %esp,%ebp
80103080:	57                   	push   %edi
80103081:	56                   	push   %esi
80103082:	53                   	push   %ebx
80103083:	83 ec 18             	sub    $0x18,%esp
80103086:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103089:	89 df                	mov    %ebx,%edi
8010308b:	53                   	push   %ebx
8010308c:	e8 14 0f 00 00       	call   80103fa5 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103091:	83 c4 10             	add    $0x10,%esp
80103094:	eb 13                	jmp    801030a9 <piperead+0x30>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103096:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010309c:	83 ec 08             	sub    $0x8,%esp
8010309f:	57                   	push   %edi
801030a0:	50                   	push   %eax
801030a1:	e8 81 07 00 00       	call   80103827 <sleep>
801030a6:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801030a9:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801030af:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801030b5:	75 28                	jne    801030df <piperead+0x66>
801030b7:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
801030bd:	85 f6                	test   %esi,%esi
801030bf:	74 23                	je     801030e4 <piperead+0x6b>
    if(myproc()->killed){
801030c1:	e8 75 02 00 00       	call   8010333b <myproc>
801030c6:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801030ca:	74 ca                	je     80103096 <piperead+0x1d>
      release(&p->lock);
801030cc:	83 ec 0c             	sub    $0xc,%esp
801030cf:	53                   	push   %ebx
801030d0:	e8 39 0f 00 00       	call   8010400e <release>
      return -1;
801030d5:	83 c4 10             	add    $0x10,%esp
801030d8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801030dd:	eb 50                	jmp    8010312f <piperead+0xb6>
801030df:	be 00 00 00 00       	mov    $0x0,%esi
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801030e4:	3b 75 10             	cmp    0x10(%ebp),%esi
801030e7:	7d 2c                	jge    80103115 <piperead+0x9c>
    if(p->nread == p->nwrite)
801030e9:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801030ef:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
801030f5:	74 1e                	je     80103115 <piperead+0x9c>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801030f7:	8d 50 01             	lea    0x1(%eax),%edx
801030fa:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
80103100:	25 ff 01 00 00       	and    $0x1ff,%eax
80103105:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
8010310a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010310d:	88 04 31             	mov    %al,(%ecx,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103110:	83 c6 01             	add    $0x1,%esi
80103113:	eb cf                	jmp    801030e4 <piperead+0x6b>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103115:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010311b:	83 ec 0c             	sub    $0xc,%esp
8010311e:	50                   	push   %eax
8010311f:	e8 72 08 00 00       	call   80103996 <wakeup>
  release(&p->lock);
80103124:	89 1c 24             	mov    %ebx,(%esp)
80103127:	e8 e2 0e 00 00       	call   8010400e <release>
  return i;
8010312c:	83 c4 10             	add    $0x10,%esp
}
8010312f:	89 f0                	mov    %esi,%eax
80103131:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103134:	5b                   	pop    %ebx
80103135:	5e                   	pop    %esi
80103136:	5f                   	pop    %edi
80103137:	5d                   	pop    %ebp
80103138:	c3                   	ret    

80103139 <wakeup1>:
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103139:	ba 14 a6 10 80       	mov    $0x8010a614,%edx
8010313e:	eb 0d                	jmp    8010314d <wakeup1+0x14>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
80103140:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103147:	81 c2 04 01 00 00    	add    $0x104,%edx
8010314d:	81 fa 14 e7 10 80    	cmp    $0x8010e714,%edx
80103153:	73 0d                	jae    80103162 <wakeup1+0x29>
    if(p->state == SLEEPING && p->chan == chan)
80103155:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103159:	75 ec                	jne    80103147 <wakeup1+0xe>
8010315b:	39 42 20             	cmp    %eax,0x20(%edx)
8010315e:	75 e7                	jne    80103147 <wakeup1+0xe>
80103160:	eb de                	jmp    80103140 <wakeup1+0x7>
}
80103162:	c3                   	ret    

80103163 <allocproc>:
{
80103163:	55                   	push   %ebp
80103164:	89 e5                	mov    %esp,%ebp
80103166:	53                   	push   %ebx
80103167:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010316a:	68 e0 a5 10 80       	push   $0x8010a5e0
8010316f:	e8 31 0e 00 00       	call   80103fa5 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103174:	83 c4 10             	add    $0x10,%esp
80103177:	bb 14 a6 10 80       	mov    $0x8010a614,%ebx
8010317c:	81 fb 14 e7 10 80    	cmp    $0x8010e714,%ebx
80103182:	73 0e                	jae    80103192 <allocproc+0x2f>
    if(p->state == UNUSED) {
80103184:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
80103188:	74 0f                	je     80103199 <allocproc+0x36>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010318a:	81 c3 04 01 00 00    	add    $0x104,%ebx
80103190:	eb ea                	jmp    8010317c <allocproc+0x19>
  int found = 0;
80103192:	b8 00 00 00 00       	mov    $0x0,%eax
80103197:	eb 05                	jmp    8010319e <allocproc+0x3b>
      found = 1;
80103199:	b8 01 00 00 00       	mov    $0x1,%eax
  if (!found) {
8010319e:	85 c0                	test   %eax,%eax
801031a0:	0f 84 8a 00 00 00    	je     80103230 <allocproc+0xcd>
  p->state = EMBRYO;
801031a6:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801031ad:	a1 04 a0 10 80       	mov    0x8010a004,%eax
801031b2:	8d 50 01             	lea    0x1(%eax),%edx
801031b5:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
801031bb:	89 43 10             	mov    %eax,0x10(%ebx)
  p->priority = DEFAULTPRIORITY;
801031be:	c7 43 7c 0a 00 00 00 	movl   $0xa,0x7c(%ebx)
  release(&ptable.lock);
801031c5:	83 ec 0c             	sub    $0xc,%esp
801031c8:	68 e0 a5 10 80       	push   $0x8010a5e0
801031cd:	e8 3c 0e 00 00       	call   8010400e <release>
  if((p->kstack = kalloc()) == 0){
801031d2:	e8 b8 ef ff ff       	call   8010218f <kalloc>
801031d7:	89 43 08             	mov    %eax,0x8(%ebx)
801031da:	83 c4 10             	add    $0x10,%esp
801031dd:	85 c0                	test   %eax,%eax
801031df:	74 6b                	je     8010324c <allocproc+0xe9>
  sp -= sizeof *p->tf;
801031e1:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  p->tf = (struct trapframe*)sp;
801031e7:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801031ea:	c7 80 b0 0f 00 00 d6 	movl   $0x801052d6,0xfb0(%eax)
801031f1:	52 10 80 
  sp -= sizeof *p->context;
801031f4:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
801031f9:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801031fc:	83 ec 04             	sub    $0x4,%esp
801031ff:	6a 14                	push   $0x14
80103201:	6a 00                	push   $0x0
80103203:	50                   	push   %eax
80103204:	e8 50 0e 00 00       	call   80104059 <memset>
  p->context->eip = (uint)forkret;
80103209:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010320c:	c7 40 10 57 32 10 80 	movl   $0x80103257,0x10(%eax)
  for (int i=0; i < sizeof(p->sys_count)/sizeof(int); i++)
80103213:	83 c4 10             	add    $0x10,%esp
80103216:	b8 00 00 00 00       	mov    $0x0,%eax
8010321b:	83 f8 1c             	cmp    $0x1c,%eax
8010321e:	77 25                	ja     80103245 <allocproc+0xe2>
    p->sys_count[i] = 0;
80103220:	c7 84 83 80 00 00 00 	movl   $0x0,0x80(%ebx,%eax,4)
80103227:	00 00 00 00 
  for (int i=0; i < sizeof(p->sys_count)/sizeof(int); i++)
8010322b:	83 c0 01             	add    $0x1,%eax
8010322e:	eb eb                	jmp    8010321b <allocproc+0xb8>
    release(&ptable.lock);
80103230:	83 ec 0c             	sub    $0xc,%esp
80103233:	68 e0 a5 10 80       	push   $0x8010a5e0
80103238:	e8 d1 0d 00 00       	call   8010400e <release>
    return 0;
8010323d:	83 c4 10             	add    $0x10,%esp
80103240:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80103245:	89 d8                	mov    %ebx,%eax
80103247:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010324a:	c9                   	leave  
8010324b:	c3                   	ret    
    p->state = UNUSED;
8010324c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103253:	89 c3                	mov    %eax,%ebx
80103255:	eb ee                	jmp    80103245 <allocproc+0xe2>

80103257 <forkret>:
{
80103257:	f3 0f 1e fb          	endbr32 
8010325b:	55                   	push   %ebp
8010325c:	89 e5                	mov    %esp,%ebp
8010325e:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
80103261:	68 e0 a5 10 80       	push   $0x8010a5e0
80103266:	e8 a3 0d 00 00       	call   8010400e <release>
  if (first) {
8010326b:	83 c4 10             	add    $0x10,%esp
8010326e:	83 3d 00 a0 10 80 00 	cmpl   $0x0,0x8010a000
80103275:	75 02                	jne    80103279 <forkret+0x22>
}
80103277:	c9                   	leave  
80103278:	c3                   	ret    
    first = 0;
80103279:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103280:	00 00 00 
    iinit(ROOTDEV);
80103283:	83 ec 0c             	sub    $0xc,%esp
80103286:	6a 01                	push   $0x1
80103288:	e8 d5 e0 ff ff       	call   80101362 <iinit>
    initlog(ROOTDEV);
8010328d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103294:	e8 a6 f5 ff ff       	call   8010283f <initlog>
80103299:	83 c4 10             	add    $0x10,%esp
}
8010329c:	eb d9                	jmp    80103277 <forkret+0x20>

8010329e <pinit>:
{
8010329e:	f3 0f 1e fb          	endbr32 
801032a2:	55                   	push   %ebp
801032a3:	89 e5                	mov    %esp,%ebp
801032a5:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801032a8:	68 80 6f 10 80       	push   $0x80106f80
801032ad:	68 e0 a5 10 80       	push   $0x8010a5e0
801032b2:	e8 9e 0b 00 00       	call   80103e55 <initlock>
}
801032b7:	83 c4 10             	add    $0x10,%esp
801032ba:	c9                   	leave  
801032bb:	c3                   	ret    

801032bc <mycpu>:
{
801032bc:	f3 0f 1e fb          	endbr32 
801032c0:	55                   	push   %ebp
801032c1:	89 e5                	mov    %esp,%ebp
801032c3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801032c6:	9c                   	pushf  
801032c7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801032c8:	f6 c4 02             	test   $0x2,%ah
801032cb:	75 28                	jne    801032f5 <mycpu+0x39>
  apicid = lapicid();
801032cd:	e8 84 f1 ff ff       	call   80102456 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801032d2:	ba 00 00 00 00       	mov    $0x0,%edx
801032d7:	39 15 60 6e 11 80    	cmp    %edx,0x80116e60
801032dd:	7e 30                	jle    8010330f <mycpu+0x53>
    if (cpus[i].apicid == apicid) {
801032df:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801032e5:	0f b6 89 e0 68 11 80 	movzbl -0x7fee9720(%ecx),%ecx
801032ec:	39 c1                	cmp    %eax,%ecx
801032ee:	74 12                	je     80103302 <mycpu+0x46>
  for (i = 0; i < ncpu; ++i) {
801032f0:	83 c2 01             	add    $0x1,%edx
801032f3:	eb e2                	jmp    801032d7 <mycpu+0x1b>
    panic("mycpu called with interrupts enabled\n");
801032f5:	83 ec 0c             	sub    $0xc,%esp
801032f8:	68 8c 70 10 80       	push   $0x8010708c
801032fd:	e8 5a d0 ff ff       	call   8010035c <panic>
      return &cpus[i];
80103302:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103308:	05 e0 68 11 80       	add    $0x801168e0,%eax
}
8010330d:	c9                   	leave  
8010330e:	c3                   	ret    
  panic("unknown apicid\n");
8010330f:	83 ec 0c             	sub    $0xc,%esp
80103312:	68 87 6f 10 80       	push   $0x80106f87
80103317:	e8 40 d0 ff ff       	call   8010035c <panic>

8010331c <cpuid>:
cpuid() {
8010331c:	f3 0f 1e fb          	endbr32 
80103320:	55                   	push   %ebp
80103321:	89 e5                	mov    %esp,%ebp
80103323:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103326:	e8 91 ff ff ff       	call   801032bc <mycpu>
8010332b:	2d e0 68 11 80       	sub    $0x801168e0,%eax
80103330:	c1 f8 04             	sar    $0x4,%eax
80103333:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103339:	c9                   	leave  
8010333a:	c3                   	ret    

8010333b <myproc>:
myproc(void) {
8010333b:	f3 0f 1e fb          	endbr32 
8010333f:	55                   	push   %ebp
80103340:	89 e5                	mov    %esp,%ebp
80103342:	53                   	push   %ebx
80103343:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103346:	e8 71 0b 00 00       	call   80103ebc <pushcli>
  c = mycpu();
8010334b:	e8 6c ff ff ff       	call   801032bc <mycpu>
  p = c->proc;
80103350:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103356:	e8 a2 0b 00 00       	call   80103efd <popcli>
}
8010335b:	89 d8                	mov    %ebx,%eax
8010335d:	83 c4 04             	add    $0x4,%esp
80103360:	5b                   	pop    %ebx
80103361:	5d                   	pop    %ebp
80103362:	c3                   	ret    

80103363 <userinit>:
{
80103363:	f3 0f 1e fb          	endbr32 
80103367:	55                   	push   %ebp
80103368:	89 e5                	mov    %esp,%ebp
8010336a:	53                   	push   %ebx
8010336b:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
8010336e:	e8 f0 fd ff ff       	call   80103163 <allocproc>
80103373:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103375:	a3 c0 a5 10 80       	mov    %eax,0x8010a5c0
  if((p->pgdir = setupkvm()) == 0)
8010337a:	e8 53 34 00 00       	call   801067d2 <setupkvm>
8010337f:	89 43 04             	mov    %eax,0x4(%ebx)
80103382:	85 c0                	test   %eax,%eax
80103384:	0f 84 b8 00 00 00    	je     80103442 <userinit+0xdf>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010338a:	83 ec 04             	sub    $0x4,%esp
8010338d:	68 2c 00 00 00       	push   $0x2c
80103392:	68 60 a4 10 80       	push   $0x8010a460
80103397:	50                   	push   %eax
80103398:	e8 32 31 00 00       	call   801064cf <inituvm>
  p->sz = PGSIZE;
8010339d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801033a3:	8b 43 18             	mov    0x18(%ebx),%eax
801033a6:	83 c4 0c             	add    $0xc,%esp
801033a9:	6a 4c                	push   $0x4c
801033ab:	6a 00                	push   $0x0
801033ad:	50                   	push   %eax
801033ae:	e8 a6 0c 00 00       	call   80104059 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801033b3:	8b 43 18             	mov    0x18(%ebx),%eax
801033b6:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801033bc:	8b 43 18             	mov    0x18(%ebx),%eax
801033bf:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
801033c5:	8b 43 18             	mov    0x18(%ebx),%eax
801033c8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801033cc:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801033d0:	8b 43 18             	mov    0x18(%ebx),%eax
801033d3:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801033d7:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801033db:	8b 43 18             	mov    0x18(%ebx),%eax
801033de:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801033e5:	8b 43 18             	mov    0x18(%ebx),%eax
801033e8:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801033ef:	8b 43 18             	mov    0x18(%ebx),%eax
801033f2:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801033f9:	8d 43 6c             	lea    0x6c(%ebx),%eax
801033fc:	83 c4 0c             	add    $0xc,%esp
801033ff:	6a 10                	push   $0x10
80103401:	68 b0 6f 10 80       	push   $0x80106fb0
80103406:	50                   	push   %eax
80103407:	e8 cd 0d 00 00       	call   801041d9 <safestrcpy>
  p->cwd = namei("/");
8010340c:	c7 04 24 b9 6f 10 80 	movl   $0x80106fb9,(%esp)
80103413:	e8 74 e8 ff ff       	call   80101c8c <namei>
80103418:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
8010341b:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
80103422:	e8 7e 0b 00 00       	call   80103fa5 <acquire>
  p->state = RUNNABLE;
80103427:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010342e:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
80103435:	e8 d4 0b 00 00       	call   8010400e <release>
}
8010343a:	83 c4 10             	add    $0x10,%esp
8010343d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103440:	c9                   	leave  
80103441:	c3                   	ret    
    panic("userinit: out of memory?");
80103442:	83 ec 0c             	sub    $0xc,%esp
80103445:	68 97 6f 10 80       	push   $0x80106f97
8010344a:	e8 0d cf ff ff       	call   8010035c <panic>

8010344f <growproc>:
{
8010344f:	f3 0f 1e fb          	endbr32 
80103453:	55                   	push   %ebp
80103454:	89 e5                	mov    %esp,%ebp
80103456:	56                   	push   %esi
80103457:	53                   	push   %ebx
80103458:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
8010345b:	e8 db fe ff ff       	call   8010333b <myproc>
80103460:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103462:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103464:	85 f6                	test   %esi,%esi
80103466:	7f 1c                	jg     80103484 <growproc+0x35>
  } else if(n < 0){
80103468:	78 37                	js     801034a1 <growproc+0x52>
  curproc->sz = sz;
8010346a:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010346c:	83 ec 0c             	sub    $0xc,%esp
8010346f:	53                   	push   %ebx
80103470:	e8 3e 2f 00 00       	call   801063b3 <switchuvm>
  return 0;
80103475:	83 c4 10             	add    $0x10,%esp
80103478:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010347d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103480:	5b                   	pop    %ebx
80103481:	5e                   	pop    %esi
80103482:	5d                   	pop    %ebp
80103483:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103484:	83 ec 04             	sub    $0x4,%esp
80103487:	01 c6                	add    %eax,%esi
80103489:	56                   	push   %esi
8010348a:	50                   	push   %eax
8010348b:	ff 73 04             	pushl  0x4(%ebx)
8010348e:	e8 de 31 00 00       	call   80106671 <allocuvm>
80103493:	83 c4 10             	add    $0x10,%esp
80103496:	85 c0                	test   %eax,%eax
80103498:	75 d0                	jne    8010346a <growproc+0x1b>
      return -1;
8010349a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010349f:	eb dc                	jmp    8010347d <growproc+0x2e>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801034a1:	83 ec 04             	sub    $0x4,%esp
801034a4:	01 c6                	add    %eax,%esi
801034a6:	56                   	push   %esi
801034a7:	50                   	push   %eax
801034a8:	ff 73 04             	pushl  0x4(%ebx)
801034ab:	e8 2b 31 00 00       	call   801065db <deallocuvm>
801034b0:	83 c4 10             	add    $0x10,%esp
801034b3:	85 c0                	test   %eax,%eax
801034b5:	75 b3                	jne    8010346a <growproc+0x1b>
      return -1;
801034b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034bc:	eb bf                	jmp    8010347d <growproc+0x2e>

801034be <fork>:
{
801034be:	f3 0f 1e fb          	endbr32 
801034c2:	55                   	push   %ebp
801034c3:	89 e5                	mov    %esp,%ebp
801034c5:	57                   	push   %edi
801034c6:	56                   	push   %esi
801034c7:	53                   	push   %ebx
801034c8:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
801034cb:	e8 6b fe ff ff       	call   8010333b <myproc>
801034d0:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
801034d2:	e8 8c fc ff ff       	call   80103163 <allocproc>
801034d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801034da:	85 c0                	test   %eax,%eax
801034dc:	0f 84 e0 00 00 00    	je     801035c2 <fork+0x104>
801034e2:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801034e4:	83 ec 08             	sub    $0x8,%esp
801034e7:	ff 33                	pushl  (%ebx)
801034e9:	ff 73 04             	pushl  0x4(%ebx)
801034ec:	e8 9e 33 00 00       	call   8010688f <copyuvm>
801034f1:	89 47 04             	mov    %eax,0x4(%edi)
801034f4:	83 c4 10             	add    $0x10,%esp
801034f7:	85 c0                	test   %eax,%eax
801034f9:	74 2a                	je     80103525 <fork+0x67>
  np->sz = curproc->sz;
801034fb:	8b 03                	mov    (%ebx),%eax
801034fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103500:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103502:	89 c8                	mov    %ecx,%eax
80103504:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103507:	8b 73 18             	mov    0x18(%ebx),%esi
8010350a:	8b 79 18             	mov    0x18(%ecx),%edi
8010350d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103512:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
80103514:	8b 40 18             	mov    0x18(%eax),%eax
80103517:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
8010351e:	be 00 00 00 00       	mov    $0x0,%esi
80103523:	eb 3c                	jmp    80103561 <fork+0xa3>
    kfree(np->kstack);
80103525:	83 ec 0c             	sub    $0xc,%esp
80103528:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010352b:	ff 73 08             	pushl  0x8(%ebx)
8010352e:	e8 35 eb ff ff       	call   80102068 <kfree>
    np->kstack = 0;
80103533:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
8010353a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103541:	83 c4 10             	add    $0x10,%esp
80103544:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103549:	eb 6f                	jmp    801035ba <fork+0xfc>
      np->ofile[i] = filedup(curproc->ofile[i]);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	50                   	push   %eax
8010354f:	e8 97 d7 ff ff       	call   80100ceb <filedup>
80103554:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103557:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
8010355b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NOFILE; i++)
8010355e:	83 c6 01             	add    $0x1,%esi
80103561:	83 fe 0f             	cmp    $0xf,%esi
80103564:	7f 0a                	jg     80103570 <fork+0xb2>
    if(curproc->ofile[i])
80103566:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010356a:	85 c0                	test   %eax,%eax
8010356c:	75 dd                	jne    8010354b <fork+0x8d>
8010356e:	eb ee                	jmp    8010355e <fork+0xa0>
  np->cwd = idup(curproc->cwd);
80103570:	83 ec 0c             	sub    $0xc,%esp
80103573:	ff 73 68             	pushl  0x68(%ebx)
80103576:	e8 58 e0 ff ff       	call   801015d3 <idup>
8010357b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010357e:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103581:	83 c3 6c             	add    $0x6c,%ebx
80103584:	8d 47 6c             	lea    0x6c(%edi),%eax
80103587:	83 c4 0c             	add    $0xc,%esp
8010358a:	6a 10                	push   $0x10
8010358c:	53                   	push   %ebx
8010358d:	50                   	push   %eax
8010358e:	e8 46 0c 00 00       	call   801041d9 <safestrcpy>
  pid = np->pid;
80103593:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103596:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
8010359d:	e8 03 0a 00 00       	call   80103fa5 <acquire>
  np->state = RUNNABLE;
801035a2:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801035a9:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
801035b0:	e8 59 0a 00 00       	call   8010400e <release>
  return pid;
801035b5:	89 d8                	mov    %ebx,%eax
801035b7:	83 c4 10             	add    $0x10,%esp
}
801035ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035bd:	5b                   	pop    %ebx
801035be:	5e                   	pop    %esi
801035bf:	5f                   	pop    %edi
801035c0:	5d                   	pop    %ebp
801035c1:	c3                   	ret    
    return -1;
801035c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035c7:	eb f1                	jmp    801035ba <fork+0xfc>

801035c9 <scheduler>:
{
801035c9:	f3 0f 1e fb          	endbr32 
801035cd:	55                   	push   %ebp
801035ce:	89 e5                	mov    %esp,%ebp
801035d0:	57                   	push   %edi
801035d1:	56                   	push   %esi
801035d2:	53                   	push   %ebx
801035d3:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801035d6:	e8 e1 fc ff ff       	call   801032bc <mycpu>
801035db:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801035dd:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801035e4:	00 00 00 
801035e7:	eb 68                	jmp    80103651 <scheduler+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801035e9:	81 c3 04 01 00 00    	add    $0x104,%ebx
801035ef:	81 fb 14 e7 10 80    	cmp    $0x8010e714,%ebx
801035f5:	73 44                	jae    8010363b <scheduler+0x72>
      if(p->state != RUNNABLE)
801035f7:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801035fb:	75 ec                	jne    801035e9 <scheduler+0x20>
      c->proc = p;
801035fd:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103603:	83 ec 0c             	sub    $0xc,%esp
80103606:	53                   	push   %ebx
80103607:	e8 a7 2d 00 00       	call   801063b3 <switchuvm>
      p->state = RUNNING;
8010360c:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103613:	83 c4 08             	add    $0x8,%esp
80103616:	ff 73 1c             	pushl  0x1c(%ebx)
80103619:	8d 46 04             	lea    0x4(%esi),%eax
8010361c:	50                   	push   %eax
8010361d:	e8 14 0c 00 00       	call   80104236 <swtch>
      switchkvm();
80103622:	e8 7a 2d 00 00       	call   801063a1 <switchkvm>
      c->proc = 0;
80103627:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
8010362e:	00 00 00 
80103631:	83 c4 10             	add    $0x10,%esp
      idle = 0;  // not idle this timeslice
80103634:	bf 00 00 00 00       	mov    $0x0,%edi
80103639:	eb ae                	jmp    801035e9 <scheduler+0x20>
    release(&ptable.lock);
8010363b:	83 ec 0c             	sub    $0xc,%esp
8010363e:	68 e0 a5 10 80       	push   $0x8010a5e0
80103643:	e8 c6 09 00 00       	call   8010400e <release>
    if (idle) {
80103648:	83 c4 10             	add    $0x10,%esp
8010364b:	85 ff                	test   %edi,%edi
8010364d:	74 02                	je     80103651 <scheduler+0x88>
  asm volatile("sti");
8010364f:	fb                   	sti    

// hlt() added by Noah Zentzis, Fall 2016.
static inline void
hlt()
{
  asm volatile("hlt");
80103650:	f4                   	hlt    
80103651:	fb                   	sti    
    acquire(&ptable.lock);
80103652:	83 ec 0c             	sub    $0xc,%esp
80103655:	68 e0 a5 10 80       	push   $0x8010a5e0
8010365a:	e8 46 09 00 00       	call   80103fa5 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010365f:	83 c4 10             	add    $0x10,%esp
    idle = 1;  // assume idle unless we schedule a process
80103662:	bf 01 00 00 00       	mov    $0x1,%edi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103667:	bb 14 a6 10 80       	mov    $0x8010a614,%ebx
8010366c:	eb 81                	jmp    801035ef <scheduler+0x26>

8010366e <sched>:
{
8010366e:	f3 0f 1e fb          	endbr32 
80103672:	55                   	push   %ebp
80103673:	89 e5                	mov    %esp,%ebp
80103675:	56                   	push   %esi
80103676:	53                   	push   %ebx
  struct proc *p = myproc();
80103677:	e8 bf fc ff ff       	call   8010333b <myproc>
8010367c:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
8010367e:	83 ec 0c             	sub    $0xc,%esp
80103681:	68 e0 a5 10 80       	push   $0x8010a5e0
80103686:	e8 d6 08 00 00       	call   80103f61 <holding>
8010368b:	83 c4 10             	add    $0x10,%esp
8010368e:	85 c0                	test   %eax,%eax
80103690:	74 4f                	je     801036e1 <sched+0x73>
  if(mycpu()->ncli != 1)
80103692:	e8 25 fc ff ff       	call   801032bc <mycpu>
80103697:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010369e:	75 4e                	jne    801036ee <sched+0x80>
  if(p->state == RUNNING)
801036a0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801036a4:	74 55                	je     801036fb <sched+0x8d>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801036a6:	9c                   	pushf  
801036a7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801036a8:	f6 c4 02             	test   $0x2,%ah
801036ab:	75 5b                	jne    80103708 <sched+0x9a>
  intena = mycpu()->intena;
801036ad:	e8 0a fc ff ff       	call   801032bc <mycpu>
801036b2:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801036b8:	e8 ff fb ff ff       	call   801032bc <mycpu>
801036bd:	83 ec 08             	sub    $0x8,%esp
801036c0:	ff 70 04             	pushl  0x4(%eax)
801036c3:	83 c3 1c             	add    $0x1c,%ebx
801036c6:	53                   	push   %ebx
801036c7:	e8 6a 0b 00 00       	call   80104236 <swtch>
  mycpu()->intena = intena;
801036cc:	e8 eb fb ff ff       	call   801032bc <mycpu>
801036d1:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801036d7:	83 c4 10             	add    $0x10,%esp
801036da:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036dd:	5b                   	pop    %ebx
801036de:	5e                   	pop    %esi
801036df:	5d                   	pop    %ebp
801036e0:	c3                   	ret    
    panic("sched ptable.lock");
801036e1:	83 ec 0c             	sub    $0xc,%esp
801036e4:	68 bb 6f 10 80       	push   $0x80106fbb
801036e9:	e8 6e cc ff ff       	call   8010035c <panic>
    panic("sched locks");
801036ee:	83 ec 0c             	sub    $0xc,%esp
801036f1:	68 cd 6f 10 80       	push   $0x80106fcd
801036f6:	e8 61 cc ff ff       	call   8010035c <panic>
    panic("sched running");
801036fb:	83 ec 0c             	sub    $0xc,%esp
801036fe:	68 d9 6f 10 80       	push   $0x80106fd9
80103703:	e8 54 cc ff ff       	call   8010035c <panic>
    panic("sched interruptible");
80103708:	83 ec 0c             	sub    $0xc,%esp
8010370b:	68 e7 6f 10 80       	push   $0x80106fe7
80103710:	e8 47 cc ff ff       	call   8010035c <panic>

80103715 <exit>:
{
80103715:	f3 0f 1e fb          	endbr32 
80103719:	55                   	push   %ebp
8010371a:	89 e5                	mov    %esp,%ebp
8010371c:	56                   	push   %esi
8010371d:	53                   	push   %ebx
  struct proc *curproc = myproc();
8010371e:	e8 18 fc ff ff       	call   8010333b <myproc>
  if(curproc == initproc)
80103723:	39 05 c0 a5 10 80    	cmp    %eax,0x8010a5c0
80103729:	74 09                	je     80103734 <exit+0x1f>
8010372b:	89 c6                	mov    %eax,%esi
  for(fd = 0; fd < NOFILE; fd++){
8010372d:	bb 00 00 00 00       	mov    $0x0,%ebx
80103732:	eb 24                	jmp    80103758 <exit+0x43>
    panic("init exiting");
80103734:	83 ec 0c             	sub    $0xc,%esp
80103737:	68 fb 6f 10 80       	push   $0x80106ffb
8010373c:	e8 1b cc ff ff       	call   8010035c <panic>
      fileclose(curproc->ofile[fd]);
80103741:	83 ec 0c             	sub    $0xc,%esp
80103744:	50                   	push   %eax
80103745:	e8 ea d5 ff ff       	call   80100d34 <fileclose>
      curproc->ofile[fd] = 0;
8010374a:	c7 44 9e 28 00 00 00 	movl   $0x0,0x28(%esi,%ebx,4)
80103751:	00 
80103752:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103755:	83 c3 01             	add    $0x1,%ebx
80103758:	83 fb 0f             	cmp    $0xf,%ebx
8010375b:	7f 0a                	jg     80103767 <exit+0x52>
    if(curproc->ofile[fd]){
8010375d:	8b 44 9e 28          	mov    0x28(%esi,%ebx,4),%eax
80103761:	85 c0                	test   %eax,%eax
80103763:	75 dc                	jne    80103741 <exit+0x2c>
80103765:	eb ee                	jmp    80103755 <exit+0x40>
  begin_op();
80103767:	e8 20 f1 ff ff       	call   8010288c <begin_op>
  iput(curproc->cwd);
8010376c:	83 ec 0c             	sub    $0xc,%esp
8010376f:	ff 76 68             	pushl  0x68(%esi)
80103772:	e8 9f df ff ff       	call   80101716 <iput>
  end_op();
80103777:	e8 8e f1 ff ff       	call   8010290a <end_op>
  curproc->cwd = 0;
8010377c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103783:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
8010378a:	e8 16 08 00 00       	call   80103fa5 <acquire>
  wakeup1(curproc->parent);
8010378f:	8b 46 14             	mov    0x14(%esi),%eax
80103792:	e8 a2 f9 ff ff       	call   80103139 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103797:	83 c4 10             	add    $0x10,%esp
8010379a:	bb 14 a6 10 80       	mov    $0x8010a614,%ebx
8010379f:	eb 06                	jmp    801037a7 <exit+0x92>
801037a1:	81 c3 04 01 00 00    	add    $0x104,%ebx
801037a7:	81 fb 14 e7 10 80    	cmp    $0x8010e714,%ebx
801037ad:	73 1a                	jae    801037c9 <exit+0xb4>
    if(p->parent == curproc){
801037af:	39 73 14             	cmp    %esi,0x14(%ebx)
801037b2:	75 ed                	jne    801037a1 <exit+0x8c>
      p->parent = initproc;
801037b4:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
801037b9:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
801037bc:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801037c0:	75 df                	jne    801037a1 <exit+0x8c>
        wakeup1(initproc);
801037c2:	e8 72 f9 ff ff       	call   80103139 <wakeup1>
801037c7:	eb d8                	jmp    801037a1 <exit+0x8c>
  curproc->state = ZOMBIE;
801037c9:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  curproc->sz = 0;
801037d0:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  sched();
801037d6:	e8 93 fe ff ff       	call   8010366e <sched>
  panic("zombie exit");
801037db:	83 ec 0c             	sub    $0xc,%esp
801037de:	68 08 70 10 80       	push   $0x80107008
801037e3:	e8 74 cb ff ff       	call   8010035c <panic>

801037e8 <yield>:
{
801037e8:	f3 0f 1e fb          	endbr32 
801037ec:	55                   	push   %ebp
801037ed:	89 e5                	mov    %esp,%ebp
801037ef:	53                   	push   %ebx
801037f0:	83 ec 04             	sub    $0x4,%esp
  struct proc *curproc = myproc();
801037f3:	e8 43 fb ff ff       	call   8010333b <myproc>
801037f8:	89 c3                	mov    %eax,%ebx
  acquire(&ptable.lock);  //DOC: yieldlock
801037fa:	83 ec 0c             	sub    $0xc,%esp
801037fd:	68 e0 a5 10 80       	push   $0x8010a5e0
80103802:	e8 9e 07 00 00       	call   80103fa5 <acquire>
  curproc->state = RUNNABLE;
80103807:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010380e:	e8 5b fe ff ff       	call   8010366e <sched>
  release(&ptable.lock);
80103813:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
8010381a:	e8 ef 07 00 00       	call   8010400e <release>
}
8010381f:	83 c4 10             	add    $0x10,%esp
80103822:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103825:	c9                   	leave  
80103826:	c3                   	ret    

80103827 <sleep>:
{
80103827:	f3 0f 1e fb          	endbr32 
8010382b:	55                   	push   %ebp
8010382c:	89 e5                	mov    %esp,%ebp
8010382e:	56                   	push   %esi
8010382f:	53                   	push   %ebx
80103830:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103833:	e8 03 fb ff ff       	call   8010333b <myproc>
  if(p == 0)
80103838:	85 c0                	test   %eax,%eax
8010383a:	74 72                	je     801038ae <sleep+0x87>
8010383c:	89 c3                	mov    %eax,%ebx
  if(lk != &ptable.lock){  //DOC: sleeplock0
8010383e:	81 fe e0 a5 10 80    	cmp    $0x8010a5e0,%esi
80103844:	74 20                	je     80103866 <sleep+0x3f>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103846:	83 ec 0c             	sub    $0xc,%esp
80103849:	68 e0 a5 10 80       	push   $0x8010a5e0
8010384e:	e8 52 07 00 00       	call   80103fa5 <acquire>
    if (lk) release(lk);
80103853:	83 c4 10             	add    $0x10,%esp
80103856:	85 f6                	test   %esi,%esi
80103858:	74 0c                	je     80103866 <sleep+0x3f>
8010385a:	83 ec 0c             	sub    $0xc,%esp
8010385d:	56                   	push   %esi
8010385e:	e8 ab 07 00 00       	call   8010400e <release>
80103863:	83 c4 10             	add    $0x10,%esp
  p->chan = chan;
80103866:	8b 45 08             	mov    0x8(%ebp),%eax
80103869:	89 43 20             	mov    %eax,0x20(%ebx)
  p->state = SLEEPING;
8010386c:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103873:	e8 f6 fd ff ff       	call   8010366e <sched>
  p->chan = 0;
80103878:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if(lk != &ptable.lock){  //DOC: sleeplock2
8010387f:	81 fe e0 a5 10 80    	cmp    $0x8010a5e0,%esi
80103885:	74 20                	je     801038a7 <sleep+0x80>
    release(&ptable.lock);
80103887:	83 ec 0c             	sub    $0xc,%esp
8010388a:	68 e0 a5 10 80       	push   $0x8010a5e0
8010388f:	e8 7a 07 00 00       	call   8010400e <release>
    if (lk) acquire(lk);
80103894:	83 c4 10             	add    $0x10,%esp
80103897:	85 f6                	test   %esi,%esi
80103899:	74 0c                	je     801038a7 <sleep+0x80>
8010389b:	83 ec 0c             	sub    $0xc,%esp
8010389e:	56                   	push   %esi
8010389f:	e8 01 07 00 00       	call   80103fa5 <acquire>
801038a4:	83 c4 10             	add    $0x10,%esp
}
801038a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038aa:	5b                   	pop    %ebx
801038ab:	5e                   	pop    %esi
801038ac:	5d                   	pop    %ebp
801038ad:	c3                   	ret    
    panic("sleep");
801038ae:	83 ec 0c             	sub    $0xc,%esp
801038b1:	68 14 70 10 80       	push   $0x80107014
801038b6:	e8 a1 ca ff ff       	call   8010035c <panic>

801038bb <wait>:
{
801038bb:	f3 0f 1e fb          	endbr32 
801038bf:	55                   	push   %ebp
801038c0:	89 e5                	mov    %esp,%ebp
801038c2:	56                   	push   %esi
801038c3:	53                   	push   %ebx
  struct proc *curproc = myproc();
801038c4:	e8 72 fa ff ff       	call   8010333b <myproc>
801038c9:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
801038cb:	83 ec 0c             	sub    $0xc,%esp
801038ce:	68 e0 a5 10 80       	push   $0x8010a5e0
801038d3:	e8 cd 06 00 00       	call   80103fa5 <acquire>
801038d8:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801038db:	b8 00 00 00 00       	mov    $0x0,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038e0:	bb 14 a6 10 80       	mov    $0x8010a614,%ebx
801038e5:	eb 5e                	jmp    80103945 <wait+0x8a>
        pid = p->pid;
801038e7:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801038ea:	83 ec 0c             	sub    $0xc,%esp
801038ed:	ff 73 08             	pushl  0x8(%ebx)
801038f0:	e8 73 e7 ff ff       	call   80102068 <kfree>
        p->kstack = 0;
801038f5:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801038fc:	83 c4 04             	add    $0x4,%esp
801038ff:	ff 73 04             	pushl  0x4(%ebx)
80103902:	e8 57 2e 00 00       	call   8010675e <freevm>
        p->pid = 0;
80103907:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010390e:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103915:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103919:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103920:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103927:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
8010392e:	e8 db 06 00 00       	call   8010400e <release>
        return pid;
80103933:	89 f0                	mov    %esi,%eax
80103935:	83 c4 10             	add    $0x10,%esp
}
80103938:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010393b:	5b                   	pop    %ebx
8010393c:	5e                   	pop    %esi
8010393d:	5d                   	pop    %ebp
8010393e:	c3                   	ret    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010393f:	81 c3 04 01 00 00    	add    $0x104,%ebx
80103945:	81 fb 14 e7 10 80    	cmp    $0x8010e714,%ebx
8010394b:	73 12                	jae    8010395f <wait+0xa4>
      if(p->parent != curproc)
8010394d:	39 73 14             	cmp    %esi,0x14(%ebx)
80103950:	75 ed                	jne    8010393f <wait+0x84>
      if(p->state == ZOMBIE){
80103952:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103956:	74 8f                	je     801038e7 <wait+0x2c>
      havekids = 1;
80103958:	b8 01 00 00 00       	mov    $0x1,%eax
8010395d:	eb e0                	jmp    8010393f <wait+0x84>
    if(!havekids || curproc->killed){
8010395f:	85 c0                	test   %eax,%eax
80103961:	74 06                	je     80103969 <wait+0xae>
80103963:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
80103967:	74 17                	je     80103980 <wait+0xc5>
      release(&ptable.lock);
80103969:	83 ec 0c             	sub    $0xc,%esp
8010396c:	68 e0 a5 10 80       	push   $0x8010a5e0
80103971:	e8 98 06 00 00       	call   8010400e <release>
      return -1;
80103976:	83 c4 10             	add    $0x10,%esp
80103979:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010397e:	eb b8                	jmp    80103938 <wait+0x7d>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103980:	83 ec 08             	sub    $0x8,%esp
80103983:	68 e0 a5 10 80       	push   $0x8010a5e0
80103988:	56                   	push   %esi
80103989:	e8 99 fe ff ff       	call   80103827 <sleep>
    havekids = 0;
8010398e:	83 c4 10             	add    $0x10,%esp
80103991:	e9 45 ff ff ff       	jmp    801038db <wait+0x20>

80103996 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103996:	f3 0f 1e fb          	endbr32 
8010399a:	55                   	push   %ebp
8010399b:	89 e5                	mov    %esp,%ebp
8010399d:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801039a0:	68 e0 a5 10 80       	push   $0x8010a5e0
801039a5:	e8 fb 05 00 00       	call   80103fa5 <acquire>
  wakeup1(chan);
801039aa:	8b 45 08             	mov    0x8(%ebp),%eax
801039ad:	e8 87 f7 ff ff       	call   80103139 <wakeup1>
  release(&ptable.lock);
801039b2:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
801039b9:	e8 50 06 00 00       	call   8010400e <release>
}
801039be:	83 c4 10             	add    $0x10,%esp
801039c1:	c9                   	leave  
801039c2:	c3                   	ret    

801039c3 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801039c3:	f3 0f 1e fb          	endbr32 
801039c7:	55                   	push   %ebp
801039c8:	89 e5                	mov    %esp,%ebp
801039ca:	53                   	push   %ebx
801039cb:	83 ec 10             	sub    $0x10,%esp
801039ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801039d1:	68 e0 a5 10 80       	push   $0x8010a5e0
801039d6:	e8 ca 05 00 00       	call   80103fa5 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039db:	83 c4 10             	add    $0x10,%esp
801039de:	b8 14 a6 10 80       	mov    $0x8010a614,%eax
801039e3:	3d 14 e7 10 80       	cmp    $0x8010e714,%eax
801039e8:	73 3c                	jae    80103a26 <kill+0x63>
    if(p->pid == pid){
801039ea:	39 58 10             	cmp    %ebx,0x10(%eax)
801039ed:	74 07                	je     801039f6 <kill+0x33>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039ef:	05 04 01 00 00       	add    $0x104,%eax
801039f4:	eb ed                	jmp    801039e3 <kill+0x20>
      p->killed = 1;
801039f6:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801039fd:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103a01:	74 1a                	je     80103a1d <kill+0x5a>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103a03:	83 ec 0c             	sub    $0xc,%esp
80103a06:	68 e0 a5 10 80       	push   $0x8010a5e0
80103a0b:	e8 fe 05 00 00       	call   8010400e <release>
      return 0;
80103a10:	83 c4 10             	add    $0x10,%esp
80103a13:	b8 00 00 00 00       	mov    $0x0,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103a18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a1b:	c9                   	leave  
80103a1c:	c3                   	ret    
        p->state = RUNNABLE;
80103a1d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103a24:	eb dd                	jmp    80103a03 <kill+0x40>
  release(&ptable.lock);
80103a26:	83 ec 0c             	sub    $0xc,%esp
80103a29:	68 e0 a5 10 80       	push   $0x8010a5e0
80103a2e:	e8 db 05 00 00       	call   8010400e <release>
  return -1;
80103a33:	83 c4 10             	add    $0x10,%esp
80103a36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a3b:	eb db                	jmp    80103a18 <kill+0x55>

80103a3d <cps>:
// get the summary of the process that are
// currently available in xv6 cpu that might be 
// running, runnable or sleeping along with 
// there name, id and priority 
int cps(void)
{
80103a3d:	f3 0f 1e fb          	endbr32 
80103a41:	55                   	push   %ebp
80103a42:	89 e5                	mov    %esp,%ebp
80103a44:	53                   	push   %ebx
80103a45:	83 ec 10             	sub    $0x10,%esp
  asm volatile("sti");
80103a48:	fb                   	sti    
	struct proc *process;
  // interupt to cpu
	sti();
  // acquire the lock on table so that other processes must not access at the same time
	acquire(&ptable.lock);
80103a49:	68 e0 a5 10 80       	push   $0x8010a5e0
80103a4e:	e8 52 05 00 00       	call   80103fa5 <acquire>
	cprintf("Process Name\tpid\tPriority\tState\n");
80103a53:	c7 04 24 b4 70 10 80 	movl   $0x801070b4,(%esp)
80103a5a:	e8 ca cb ff ff       	call   80100629 <cprintf>
  // loop over the process table
	for(process = ptable.proc; process < &ptable.proc[NPROC]; process++) {
80103a5f:	83 c4 10             	add    $0x10,%esp
80103a62:	bb 14 a6 10 80       	mov    $0x8010a614,%ebx
80103a67:	eb 1d                	jmp    80103a86 <cps+0x49>
		if(process->state == SLEEPING) {
			cprintf("%s\t%d\t%d\tSLEEPING\n", process->name, process->pid, process->priority);			
80103a69:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a6c:	ff 73 7c             	pushl  0x7c(%ebx)
80103a6f:	ff 73 10             	pushl  0x10(%ebx)
80103a72:	50                   	push   %eax
80103a73:	68 1a 70 10 80       	push   $0x8010701a
80103a78:	e8 ac cb ff ff       	call   80100629 <cprintf>
80103a7d:	83 c4 10             	add    $0x10,%esp
	for(process = ptable.proc; process < &ptable.proc[NPROC]; process++) {
80103a80:	81 c3 04 01 00 00    	add    $0x104,%ebx
80103a86:	81 fb 14 e7 10 80    	cmp    $0x8010e714,%ebx
80103a8c:	73 44                	jae    80103ad2 <cps+0x95>
		if(process->state == SLEEPING) {
80103a8e:	8b 43 0c             	mov    0xc(%ebx),%eax
80103a91:	83 f8 02             	cmp    $0x2,%eax
80103a94:	74 d3                	je     80103a69 <cps+0x2c>
		}
		else if(process->state == RUNNABLE) {
80103a96:	83 f8 03             	cmp    $0x3,%eax
80103a99:	74 1e                	je     80103ab9 <cps+0x7c>
			cprintf("%s\t%d\t%d\tRUNNABLE\n", process->name, process->pid, process->priority);			
		}
		else if(process->state == RUNNING) {
80103a9b:	83 f8 04             	cmp    $0x4,%eax
80103a9e:	75 e0                	jne    80103a80 <cps+0x43>
			cprintf("%s\t%d\t%d\tRUNNING\n", process->name, process->pid, process->priority);			
80103aa0:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103aa3:	ff 73 7c             	pushl  0x7c(%ebx)
80103aa6:	ff 73 10             	pushl  0x10(%ebx)
80103aa9:	50                   	push   %eax
80103aaa:	68 40 70 10 80       	push   $0x80107040
80103aaf:	e8 75 cb ff ff       	call   80100629 <cprintf>
80103ab4:	83 c4 10             	add    $0x10,%esp
80103ab7:	eb c7                	jmp    80103a80 <cps+0x43>
			cprintf("%s\t%d\t%d\tRUNNABLE\n", process->name, process->pid, process->priority);			
80103ab9:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103abc:	ff 73 7c             	pushl  0x7c(%ebx)
80103abf:	ff 73 10             	pushl  0x10(%ebx)
80103ac2:	50                   	push   %eax
80103ac3:	68 2d 70 10 80       	push   $0x8010702d
80103ac8:	e8 5c cb ff ff       	call   80100629 <cprintf>
80103acd:	83 c4 10             	add    $0x10,%esp
80103ad0:	eb ae                	jmp    80103a80 <cps+0x43>
		}
			
	}
	release(&ptable.lock);
80103ad2:	83 ec 0c             	sub    $0xc,%esp
80103ad5:	68 e0 a5 10 80       	push   $0x8010a5e0
80103ada:	e8 2f 05 00 00       	call   8010400e <release>
	return 22;
}
80103adf:	b8 16 00 00 00       	mov    $0x16,%eax
80103ae4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ae7:	c9                   	leave  
80103ae8:	c3                   	ret    

80103ae9 <getppid>:

// get parent process id of
// currently running process
int getppid(void) {
80103ae9:	f3 0f 1e fb          	endbr32 
80103aed:	55                   	push   %ebp
80103aee:	89 e5                	mov    %esp,%ebp
80103af0:	83 ec 08             	sub    $0x8,%esp
  return myproc()->parent->pid;
80103af3:	e8 43 f8 ff ff       	call   8010333b <myproc>
80103af8:	8b 40 14             	mov    0x14(%eax),%eax
80103afb:	8b 40 10             	mov    0x10(%eax),%eax
}
80103afe:	c9                   	leave  
80103aff:	c3                   	ret    

80103b00 <getsz>:

// get the memroy size of  
// current process running 
int  getsz(void) {
80103b00:	f3 0f 1e fb          	endbr32 
80103b04:	55                   	push   %ebp
80103b05:	89 e5                	mov    %esp,%ebp
80103b07:	83 ec 08             	sub    $0x8,%esp
  return myproc()->sz;
80103b0a:	e8 2c f8 ff ff       	call   8010333b <myproc>
80103b0f:	8b 00                	mov    (%eax),%eax
}
80103b11:	c9                   	leave  
80103b12:	c3                   	ret    

80103b13 <chpr>:

// change the priority of any 
// process by using its pid.
int chpr(int pid, int priority) {
80103b13:	f3 0f 1e fb          	endbr32 
80103b17:	55                   	push   %ebp
80103b18:	89 e5                	mov    %esp,%ebp
80103b1a:	53                   	push   %ebx
80103b1b:	83 ec 10             	sub    $0x10,%esp
80103b1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *process;

  acquire(&ptable.lock);
80103b21:	68 e0 a5 10 80       	push   $0x8010a5e0
80103b26:	e8 7a 04 00 00       	call   80103fa5 <acquire>
  for (process=ptable.proc; process < &ptable.proc[NPROC]; process++) {
80103b2b:	83 c4 10             	add    $0x10,%esp
80103b2e:	b8 14 a6 10 80       	mov    $0x8010a614,%eax
80103b33:	3d 14 e7 10 80       	cmp    $0x8010e714,%eax
80103b38:	73 12                	jae    80103b4c <chpr+0x39>
    if (process->pid == pid) {
80103b3a:	39 58 10             	cmp    %ebx,0x10(%eax)
80103b3d:	74 07                	je     80103b46 <chpr+0x33>
  for (process=ptable.proc; process < &ptable.proc[NPROC]; process++) {
80103b3f:	05 04 01 00 00       	add    $0x104,%eax
80103b44:	eb ed                	jmp    80103b33 <chpr+0x20>
      process->priority = priority;
80103b46:	8b 55 0c             	mov    0xc(%ebp),%edx
80103b49:	89 50 7c             	mov    %edx,0x7c(%eax)
      break;
    }
  }
  release(&ptable.lock);
80103b4c:	83 ec 0c             	sub    $0xc,%esp
80103b4f:	68 e0 a5 10 80       	push   $0x8010a5e0
80103b54:	e8 b5 04 00 00       	call   8010400e <release>
  return pid;
}
80103b59:	89 d8                	mov    %ebx,%eax
80103b5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b5e:	c9                   	leave  
80103b5f:	c3                   	ret    

80103b60 <getcount>:

// get the count of number of times 
// a process has invoked into 
// a program based on that process 
// number which is defined in syscall.h
int getcount(int procno){  // process number in syscall.h
80103b60:	f3 0f 1e fb          	endbr32 
80103b64:	55                   	push   %ebp
80103b65:	89 e5                	mov    %esp,%ebp
80103b67:	83 ec 08             	sub    $0x8,%esp
  return myproc()->sys_count[procno - 1];    
80103b6a:	e8 cc f7 ff ff       	call   8010333b <myproc>
80103b6f:	8b 55 08             	mov    0x8(%ebp),%edx
80103b72:	8b 44 90 7c          	mov    0x7c(%eax,%edx,4),%eax
}
80103b76:	c9                   	leave  
80103b77:	c3                   	ret    

80103b78 <time>:

// get wait time and burst time of
// a process. This system call is 
// is extension of wait() system call.
int time(int *waitt, int *burstt) {
80103b78:	f3 0f 1e fb          	endbr32 
80103b7c:	55                   	push   %ebp
80103b7d:	89 e5                	mov    %esp,%ebp
80103b7f:	56                   	push   %esi
80103b80:	53                   	push   %ebx
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103b81:	e8 b5 f7 ff ff       	call   8010333b <myproc>
80103b86:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103b88:	83 ec 0c             	sub    $0xc,%esp
80103b8b:	68 e0 a5 10 80       	push   $0x8010a5e0
80103b90:	e8 10 04 00 00       	call   80103fa5 <acquire>
80103b95:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80103b98:	b8 00 00 00 00       	mov    $0x0,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b9d:	bb 14 a6 10 80       	mov    $0x8010a614,%ebx
80103ba2:	e9 86 00 00 00       	jmp    80103c2d <time+0xb5>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        // update the wait time and burst time
        *waitt = p->endt - p->arrivalt - p->burstt - p->iot;
80103ba7:	8b 83 f8 00 00 00    	mov    0xf8(%ebx),%eax
80103bad:	2b 83 f4 00 00 00    	sub    0xf4(%ebx),%eax
80103bb3:	2b 83 fc 00 00 00    	sub    0xfc(%ebx),%eax
80103bb9:	2b 83 00 01 00 00    	sub    0x100(%ebx),%eax
80103bbf:	8b 55 08             	mov    0x8(%ebp),%edx
80103bc2:	89 02                	mov    %eax,(%edx)
        *burstt = p->burstt;
80103bc4:	8b 93 fc 00 00 00    	mov    0xfc(%ebx),%edx
80103bca:	8b 45 0c             	mov    0xc(%ebp),%eax
80103bcd:	89 10                	mov    %edx,(%eax)
        pid = p->pid;
80103bcf:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103bd2:	83 ec 0c             	sub    $0xc,%esp
80103bd5:	ff 73 08             	pushl  0x8(%ebx)
80103bd8:	e8 8b e4 ff ff       	call   80102068 <kfree>
        p->kstack = 0;
80103bdd:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103be4:	83 c4 04             	add    $0x4,%esp
80103be7:	ff 73 04             	pushl  0x4(%ebx)
80103bea:	e8 6f 2b 00 00       	call   8010675e <freevm>
        p->state = UNUSED;
80103bef:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        p->pid = 0;
80103bf6:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103bfd:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103c04:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103c08:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        release(&ptable.lock);
80103c0f:	c7 04 24 e0 a5 10 80 	movl   $0x8010a5e0,(%esp)
80103c16:	e8 f3 03 00 00       	call   8010400e <release>
        return pid;
80103c1b:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103c1e:	89 f0                	mov    %esi,%eax
80103c20:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c23:	5b                   	pop    %ebx
80103c24:	5e                   	pop    %esi
80103c25:	5d                   	pop    %ebp
80103c26:	c3                   	ret    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c27:	81 c3 04 01 00 00    	add    $0x104,%ebx
80103c2d:	81 fb 14 e7 10 80    	cmp    $0x8010e714,%ebx
80103c33:	73 16                	jae    80103c4b <time+0xd3>
      if(p->parent != curproc)
80103c35:	39 73 14             	cmp    %esi,0x14(%ebx)
80103c38:	75 ed                	jne    80103c27 <time+0xaf>
      if(p->state == ZOMBIE){
80103c3a:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103c3e:	0f 84 63 ff ff ff    	je     80103ba7 <time+0x2f>
      havekids = 1;
80103c44:	b8 01 00 00 00       	mov    $0x1,%eax
80103c49:	eb dc                	jmp    80103c27 <time+0xaf>
    if(!havekids || curproc->killed){
80103c4b:	85 c0                	test   %eax,%eax
80103c4d:	74 06                	je     80103c55 <time+0xdd>
80103c4f:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
80103c53:	74 17                	je     80103c6c <time+0xf4>
      release(&ptable.lock);
80103c55:	83 ec 0c             	sub    $0xc,%esp
80103c58:	68 e0 a5 10 80       	push   $0x8010a5e0
80103c5d:	e8 ac 03 00 00       	call   8010400e <release>
      return -1;
80103c62:	83 c4 10             	add    $0x10,%esp
80103c65:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103c6a:	eb b2                	jmp    80103c1e <time+0xa6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103c6c:	83 ec 08             	sub    $0x8,%esp
80103c6f:	68 e0 a5 10 80       	push   $0x8010a5e0
80103c74:	56                   	push   %esi
80103c75:	e8 ad fb ff ff       	call   80103827 <sleep>
    havekids = 0;
80103c7a:	83 c4 10             	add    $0x10,%esp
80103c7d:	e9 16 ff ff ff       	jmp    80103b98 <time+0x20>

80103c82 <utctime>:

// return the current UTC time
int utctime(struct rtcdate *r) {
80103c82:	f3 0f 1e fb          	endbr32 
80103c86:	55                   	push   %ebp
80103c87:	89 e5                	mov    %esp,%ebp
80103c89:	83 ec 14             	sub    $0x14,%esp
  // to read the real time clock
  cmostime(r);
80103c8c:	ff 75 08             	pushl  0x8(%ebp)
80103c8f:	e8 a5 e8 ff ff       	call   80102539 <cmostime>
  return 0;
}
80103c94:	b8 00 00 00 00       	mov    $0x0,%eax
80103c99:	c9                   	leave  
80103c9a:	c3                   	ret    

80103c9b <procdump>:
}
#endif

void
procdump(void)
{
80103c9b:	f3 0f 1e fb          	endbr32 
80103c9f:	55                   	push   %ebp
80103ca0:	89 e5                	mov    %esp,%ebp
80103ca2:	56                   	push   %esi
80103ca3:	53                   	push   %ebx
80103ca4:	83 ec 3c             	sub    $0x3c,%esp
#define HEADER "\nPID\tName         Elapsed\tState\tSize\t PCs\n"
#else
#define HEADER "\n"
#endif

  cprintf(HEADER);  // not conditionally compiled as must work in all project states
80103ca7:	68 17 74 10 80       	push   $0x80107417
80103cac:	e8 78 c9 ff ff       	call   80100629 <cprintf>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cb1:	83 c4 10             	add    $0x10,%esp
80103cb4:	bb 14 a6 10 80       	mov    $0x8010a614,%ebx
80103cb9:	eb 36                	jmp    80103cf1 <procdump+0x56>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
80103cbb:	b8 52 70 10 80       	mov    $0x80107052,%eax
#elif defined(CS333_P2)
    procdumpP2(p, state);
#elif defined(CS333_P1)
    procdumpP1(p, state);
#else
    cprintf("%d\t%s\t%s\t", p->pid, p->name, state);
80103cc0:	8d 53 6c             	lea    0x6c(%ebx),%edx
80103cc3:	50                   	push   %eax
80103cc4:	52                   	push   %edx
80103cc5:	ff 73 10             	pushl  0x10(%ebx)
80103cc8:	68 56 70 10 80       	push   $0x80107056
80103ccd:	e8 57 c9 ff ff       	call   80100629 <cprintf>
#endif

    if(p->state == SLEEPING){
80103cd2:	83 c4 10             	add    $0x10,%esp
80103cd5:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103cd9:	74 3c                	je     80103d17 <procdump+0x7c>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103cdb:	83 ec 0c             	sub    $0xc,%esp
80103cde:	68 17 74 10 80       	push   $0x80107417
80103ce3:	e8 41 c9 ff ff       	call   80100629 <cprintf>
80103ce8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ceb:	81 c3 04 01 00 00    	add    $0x104,%ebx
80103cf1:	81 fb 14 e7 10 80    	cmp    $0x8010e714,%ebx
80103cf7:	73 61                	jae    80103d5a <procdump+0xbf>
    if(p->state == UNUSED)
80103cf9:	8b 43 0c             	mov    0xc(%ebx),%eax
80103cfc:	85 c0                	test   %eax,%eax
80103cfe:	74 eb                	je     80103ceb <procdump+0x50>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103d00:	83 f8 05             	cmp    $0x5,%eax
80103d03:	77 b6                	ja     80103cbb <procdump+0x20>
80103d05:	8b 04 85 d8 70 10 80 	mov    -0x7fef8f28(,%eax,4),%eax
80103d0c:	85 c0                	test   %eax,%eax
80103d0e:	75 b0                	jne    80103cc0 <procdump+0x25>
      state = "???";
80103d10:	b8 52 70 10 80       	mov    $0x80107052,%eax
80103d15:	eb a9                	jmp    80103cc0 <procdump+0x25>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103d17:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103d1a:	8b 40 0c             	mov    0xc(%eax),%eax
80103d1d:	83 c0 08             	add    $0x8,%eax
80103d20:	83 ec 08             	sub    $0x8,%esp
80103d23:	8d 55 d0             	lea    -0x30(%ebp),%edx
80103d26:	52                   	push   %edx
80103d27:	50                   	push   %eax
80103d28:	e8 47 01 00 00       	call   80103e74 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103d2d:	83 c4 10             	add    $0x10,%esp
80103d30:	be 00 00 00 00       	mov    $0x0,%esi
80103d35:	eb 14                	jmp    80103d4b <procdump+0xb0>
        cprintf(" %p", pc[i]);
80103d37:	83 ec 08             	sub    $0x8,%esp
80103d3a:	50                   	push   %eax
80103d3b:	68 81 6a 10 80       	push   $0x80106a81
80103d40:	e8 e4 c8 ff ff       	call   80100629 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103d45:	83 c6 01             	add    $0x1,%esi
80103d48:	83 c4 10             	add    $0x10,%esp
80103d4b:	83 fe 09             	cmp    $0x9,%esi
80103d4e:	7f 8b                	jg     80103cdb <procdump+0x40>
80103d50:	8b 44 b5 d0          	mov    -0x30(%ebp,%esi,4),%eax
80103d54:	85 c0                	test   %eax,%eax
80103d56:	75 df                	jne    80103d37 <procdump+0x9c>
80103d58:	eb 81                	jmp    80103cdb <procdump+0x40>
  }
#ifdef CS333_P1
  cprintf("$ ");  // simulate shell prompt
#endif // CS333_P1
}
80103d5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d5d:	5b                   	pop    %ebx
80103d5e:	5e                   	pop    %esi
80103d5f:	5d                   	pop    %ebp
80103d60:	c3                   	ret    

80103d61 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103d61:	f3 0f 1e fb          	endbr32 
80103d65:	55                   	push   %ebp
80103d66:	89 e5                	mov    %esp,%ebp
80103d68:	53                   	push   %ebx
80103d69:	83 ec 0c             	sub    $0xc,%esp
80103d6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103d6f:	68 f0 70 10 80       	push   $0x801070f0
80103d74:	8d 43 04             	lea    0x4(%ebx),%eax
80103d77:	50                   	push   %eax
80103d78:	e8 d8 00 00 00       	call   80103e55 <initlock>
  lk->name = name;
80103d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d80:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103d83:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103d89:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103d90:	83 c4 10             	add    $0x10,%esp
80103d93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d96:	c9                   	leave  
80103d97:	c3                   	ret    

80103d98 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103d98:	f3 0f 1e fb          	endbr32 
80103d9c:	55                   	push   %ebp
80103d9d:	89 e5                	mov    %esp,%ebp
80103d9f:	56                   	push   %esi
80103da0:	53                   	push   %ebx
80103da1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103da4:	8d 73 04             	lea    0x4(%ebx),%esi
80103da7:	83 ec 0c             	sub    $0xc,%esp
80103daa:	56                   	push   %esi
80103dab:	e8 f5 01 00 00       	call   80103fa5 <acquire>
  while (lk->locked) {
80103db0:	83 c4 10             	add    $0x10,%esp
80103db3:	83 3b 00             	cmpl   $0x0,(%ebx)
80103db6:	74 0f                	je     80103dc7 <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
80103db8:	83 ec 08             	sub    $0x8,%esp
80103dbb:	56                   	push   %esi
80103dbc:	53                   	push   %ebx
80103dbd:	e8 65 fa ff ff       	call   80103827 <sleep>
80103dc2:	83 c4 10             	add    $0x10,%esp
80103dc5:	eb ec                	jmp    80103db3 <acquiresleep+0x1b>
  }
  lk->locked = 1;
80103dc7:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103dcd:	e8 69 f5 ff ff       	call   8010333b <myproc>
80103dd2:	8b 40 10             	mov    0x10(%eax),%eax
80103dd5:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103dd8:	83 ec 0c             	sub    $0xc,%esp
80103ddb:	56                   	push   %esi
80103ddc:	e8 2d 02 00 00       	call   8010400e <release>
}
80103de1:	83 c4 10             	add    $0x10,%esp
80103de4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103de7:	5b                   	pop    %ebx
80103de8:	5e                   	pop    %esi
80103de9:	5d                   	pop    %ebp
80103dea:	c3                   	ret    

80103deb <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103deb:	f3 0f 1e fb          	endbr32 
80103def:	55                   	push   %ebp
80103df0:	89 e5                	mov    %esp,%ebp
80103df2:	56                   	push   %esi
80103df3:	53                   	push   %ebx
80103df4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103df7:	8d 73 04             	lea    0x4(%ebx),%esi
80103dfa:	83 ec 0c             	sub    $0xc,%esp
80103dfd:	56                   	push   %esi
80103dfe:	e8 a2 01 00 00       	call   80103fa5 <acquire>
  lk->locked = 0;
80103e03:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103e09:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103e10:	89 1c 24             	mov    %ebx,(%esp)
80103e13:	e8 7e fb ff ff       	call   80103996 <wakeup>
  release(&lk->lk);
80103e18:	89 34 24             	mov    %esi,(%esp)
80103e1b:	e8 ee 01 00 00       	call   8010400e <release>
}
80103e20:	83 c4 10             	add    $0x10,%esp
80103e23:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e26:	5b                   	pop    %ebx
80103e27:	5e                   	pop    %esi
80103e28:	5d                   	pop    %ebp
80103e29:	c3                   	ret    

80103e2a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103e2a:	f3 0f 1e fb          	endbr32 
80103e2e:	55                   	push   %ebp
80103e2f:	89 e5                	mov    %esp,%ebp
80103e31:	56                   	push   %esi
80103e32:	53                   	push   %ebx
80103e33:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80103e36:	8d 5e 04             	lea    0x4(%esi),%ebx
80103e39:	83 ec 0c             	sub    $0xc,%esp
80103e3c:	53                   	push   %ebx
80103e3d:	e8 63 01 00 00       	call   80103fa5 <acquire>
  r = lk->locked;
80103e42:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80103e44:	89 1c 24             	mov    %ebx,(%esp)
80103e47:	e8 c2 01 00 00       	call   8010400e <release>
  return r;
}
80103e4c:	89 f0                	mov    %esi,%eax
80103e4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e51:	5b                   	pop    %ebx
80103e52:	5e                   	pop    %esi
80103e53:	5d                   	pop    %ebp
80103e54:	c3                   	ret    

80103e55 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103e55:	f3 0f 1e fb          	endbr32 
80103e59:	55                   	push   %ebp
80103e5a:	89 e5                	mov    %esp,%ebp
80103e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103e5f:	8b 55 0c             	mov    0xc(%ebp),%edx
80103e62:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103e65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103e6b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103e72:	5d                   	pop    %ebp
80103e73:	c3                   	ret    

80103e74 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103e74:	f3 0f 1e fb          	endbr32 
80103e78:	55                   	push   %ebp
80103e79:	89 e5                	mov    %esp,%ebp
80103e7b:	53                   	push   %ebx
80103e7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80103e7f:	8b 45 08             	mov    0x8(%ebp),%eax
80103e82:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80103e85:	b8 00 00 00 00       	mov    $0x0,%eax
80103e8a:	83 f8 09             	cmp    $0x9,%eax
80103e8d:	7f 25                	jg     80103eb4 <getcallerpcs+0x40>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103e8f:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103e95:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103e9b:	77 17                	ja     80103eb4 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103e9d:	8b 5a 04             	mov    0x4(%edx),%ebx
80103ea0:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103ea3:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103ea5:	83 c0 01             	add    $0x1,%eax
80103ea8:	eb e0                	jmp    80103e8a <getcallerpcs+0x16>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80103eaa:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103eb1:	83 c0 01             	add    $0x1,%eax
80103eb4:	83 f8 09             	cmp    $0x9,%eax
80103eb7:	7e f1                	jle    80103eaa <getcallerpcs+0x36>
}
80103eb9:	5b                   	pop    %ebx
80103eba:	5d                   	pop    %ebp
80103ebb:	c3                   	ret    

80103ebc <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103ebc:	f3 0f 1e fb          	endbr32 
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	53                   	push   %ebx
80103ec4:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ec7:	9c                   	pushf  
80103ec8:	5b                   	pop    %ebx
  asm volatile("cli");
80103ec9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103eca:	e8 ed f3 ff ff       	call   801032bc <mycpu>
80103ecf:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103ed6:	74 12                	je     80103eea <pushcli+0x2e>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103ed8:	e8 df f3 ff ff       	call   801032bc <mycpu>
80103edd:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80103ee4:	83 c4 04             	add    $0x4,%esp
80103ee7:	5b                   	pop    %ebx
80103ee8:	5d                   	pop    %ebp
80103ee9:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80103eea:	e8 cd f3 ff ff       	call   801032bc <mycpu>
80103eef:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103ef5:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103efb:	eb db                	jmp    80103ed8 <pushcli+0x1c>

80103efd <popcli>:

void
popcli(void)
{
80103efd:	f3 0f 1e fb          	endbr32 
80103f01:	55                   	push   %ebp
80103f02:	89 e5                	mov    %esp,%ebp
80103f04:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f07:	9c                   	pushf  
80103f08:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f09:	f6 c4 02             	test   $0x2,%ah
80103f0c:	75 28                	jne    80103f36 <popcli+0x39>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103f0e:	e8 a9 f3 ff ff       	call   801032bc <mycpu>
80103f13:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103f19:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103f1c:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103f22:	85 d2                	test   %edx,%edx
80103f24:	78 1d                	js     80103f43 <popcli+0x46>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103f26:	e8 91 f3 ff ff       	call   801032bc <mycpu>
80103f2b:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103f32:	74 1c                	je     80103f50 <popcli+0x53>
    sti();
}
80103f34:	c9                   	leave  
80103f35:	c3                   	ret    
    panic("popcli - interruptible");
80103f36:	83 ec 0c             	sub    $0xc,%esp
80103f39:	68 fb 70 10 80       	push   $0x801070fb
80103f3e:	e8 19 c4 ff ff       	call   8010035c <panic>
    panic("popcli");
80103f43:	83 ec 0c             	sub    $0xc,%esp
80103f46:	68 12 71 10 80       	push   $0x80107112
80103f4b:	e8 0c c4 ff ff       	call   8010035c <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103f50:	e8 67 f3 ff ff       	call   801032bc <mycpu>
80103f55:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103f5c:	74 d6                	je     80103f34 <popcli+0x37>
  asm volatile("sti");
80103f5e:	fb                   	sti    
}
80103f5f:	eb d3                	jmp    80103f34 <popcli+0x37>

80103f61 <holding>:
{
80103f61:	f3 0f 1e fb          	endbr32 
80103f65:	55                   	push   %ebp
80103f66:	89 e5                	mov    %esp,%ebp
80103f68:	53                   	push   %ebx
80103f69:	83 ec 04             	sub    $0x4,%esp
80103f6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103f6f:	e8 48 ff ff ff       	call   80103ebc <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103f74:	83 3b 00             	cmpl   $0x0,(%ebx)
80103f77:	75 12                	jne    80103f8b <holding+0x2a>
80103f79:	bb 00 00 00 00       	mov    $0x0,%ebx
  popcli();
80103f7e:	e8 7a ff ff ff       	call   80103efd <popcli>
}
80103f83:	89 d8                	mov    %ebx,%eax
80103f85:	83 c4 04             	add    $0x4,%esp
80103f88:	5b                   	pop    %ebx
80103f89:	5d                   	pop    %ebp
80103f8a:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103f8b:	8b 5b 08             	mov    0x8(%ebx),%ebx
80103f8e:	e8 29 f3 ff ff       	call   801032bc <mycpu>
80103f93:	39 c3                	cmp    %eax,%ebx
80103f95:	74 07                	je     80103f9e <holding+0x3d>
80103f97:	bb 00 00 00 00       	mov    $0x0,%ebx
80103f9c:	eb e0                	jmp    80103f7e <holding+0x1d>
80103f9e:	bb 01 00 00 00       	mov    $0x1,%ebx
80103fa3:	eb d9                	jmp    80103f7e <holding+0x1d>

80103fa5 <acquire>:
{
80103fa5:	f3 0f 1e fb          	endbr32 
80103fa9:	55                   	push   %ebp
80103faa:	89 e5                	mov    %esp,%ebp
80103fac:	53                   	push   %ebx
80103fad:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103fb0:	e8 07 ff ff ff       	call   80103ebc <pushcli>
  if(holding(lk))
80103fb5:	83 ec 0c             	sub    $0xc,%esp
80103fb8:	ff 75 08             	pushl  0x8(%ebp)
80103fbb:	e8 a1 ff ff ff       	call   80103f61 <holding>
80103fc0:	83 c4 10             	add    $0x10,%esp
80103fc3:	85 c0                	test   %eax,%eax
80103fc5:	75 3a                	jne    80104001 <acquire+0x5c>
  while(xchg(&lk->locked, 1) != 0)
80103fc7:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80103fca:	b8 01 00 00 00       	mov    $0x1,%eax
80103fcf:	f0 87 02             	lock xchg %eax,(%edx)
80103fd2:	85 c0                	test   %eax,%eax
80103fd4:	75 f1                	jne    80103fc7 <acquire+0x22>
  __sync_synchronize();
80103fd6:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103fdb:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103fde:	e8 d9 f2 ff ff       	call   801032bc <mycpu>
80103fe3:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103fe6:	8b 45 08             	mov    0x8(%ebp),%eax
80103fe9:	83 c0 0c             	add    $0xc,%eax
80103fec:	83 ec 08             	sub    $0x8,%esp
80103fef:	50                   	push   %eax
80103ff0:	8d 45 08             	lea    0x8(%ebp),%eax
80103ff3:	50                   	push   %eax
80103ff4:	e8 7b fe ff ff       	call   80103e74 <getcallerpcs>
}
80103ff9:	83 c4 10             	add    $0x10,%esp
80103ffc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fff:	c9                   	leave  
80104000:	c3                   	ret    
    panic("acquire");
80104001:	83 ec 0c             	sub    $0xc,%esp
80104004:	68 19 71 10 80       	push   $0x80107119
80104009:	e8 4e c3 ff ff       	call   8010035c <panic>

8010400e <release>:
{
8010400e:	f3 0f 1e fb          	endbr32 
80104012:	55                   	push   %ebp
80104013:	89 e5                	mov    %esp,%ebp
80104015:	53                   	push   %ebx
80104016:	83 ec 10             	sub    $0x10,%esp
80104019:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010401c:	53                   	push   %ebx
8010401d:	e8 3f ff ff ff       	call   80103f61 <holding>
80104022:	83 c4 10             	add    $0x10,%esp
80104025:	85 c0                	test   %eax,%eax
80104027:	74 23                	je     8010404c <release+0x3e>
  lk->pcs[0] = 0;
80104029:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104030:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104037:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010403c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80104042:	e8 b6 fe ff ff       	call   80103efd <popcli>
}
80104047:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010404a:	c9                   	leave  
8010404b:	c3                   	ret    
    panic("release");
8010404c:	83 ec 0c             	sub    $0xc,%esp
8010404f:	68 21 71 10 80       	push   $0x80107121
80104054:	e8 03 c3 ff ff       	call   8010035c <panic>

80104059 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104059:	f3 0f 1e fb          	endbr32 
8010405d:	55                   	push   %ebp
8010405e:	89 e5                	mov    %esp,%ebp
80104060:	57                   	push   %edi
80104061:	53                   	push   %ebx
80104062:	8b 55 08             	mov    0x8(%ebp),%edx
80104065:	8b 45 0c             	mov    0xc(%ebp),%eax
80104068:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010406b:	f6 c2 03             	test   $0x3,%dl
8010406e:	75 25                	jne    80104095 <memset+0x3c>
80104070:	f6 c1 03             	test   $0x3,%cl
80104073:	75 20                	jne    80104095 <memset+0x3c>
    c &= 0xFF;
80104075:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104078:	c1 e9 02             	shr    $0x2,%ecx
8010407b:	c1 e0 18             	shl    $0x18,%eax
8010407e:	89 fb                	mov    %edi,%ebx
80104080:	c1 e3 10             	shl    $0x10,%ebx
80104083:	09 d8                	or     %ebx,%eax
80104085:	89 fb                	mov    %edi,%ebx
80104087:	c1 e3 08             	shl    $0x8,%ebx
8010408a:	09 d8                	or     %ebx,%eax
8010408c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010408e:	89 d7                	mov    %edx,%edi
80104090:	fc                   	cld    
80104091:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104093:	eb 05                	jmp    8010409a <memset+0x41>
  asm volatile("cld; rep stosb" :
80104095:	89 d7                	mov    %edx,%edi
80104097:	fc                   	cld    
80104098:	f3 aa                	rep stos %al,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
8010409a:	89 d0                	mov    %edx,%eax
8010409c:	5b                   	pop    %ebx
8010409d:	5f                   	pop    %edi
8010409e:	5d                   	pop    %ebp
8010409f:	c3                   	ret    

801040a0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801040a0:	f3 0f 1e fb          	endbr32 
801040a4:	55                   	push   %ebp
801040a5:	89 e5                	mov    %esp,%ebp
801040a7:	56                   	push   %esi
801040a8:	53                   	push   %ebx
801040a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801040ac:	8b 55 0c             	mov    0xc(%ebp),%edx
801040af:	8b 45 10             	mov    0x10(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801040b2:	8d 70 ff             	lea    -0x1(%eax),%esi
801040b5:	85 c0                	test   %eax,%eax
801040b7:	74 1c                	je     801040d5 <memcmp+0x35>
    if(*s1 != *s2)
801040b9:	0f b6 01             	movzbl (%ecx),%eax
801040bc:	0f b6 1a             	movzbl (%edx),%ebx
801040bf:	38 d8                	cmp    %bl,%al
801040c1:	75 0a                	jne    801040cd <memcmp+0x2d>
      return *s1 - *s2;
    s1++, s2++;
801040c3:	83 c1 01             	add    $0x1,%ecx
801040c6:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801040c9:	89 f0                	mov    %esi,%eax
801040cb:	eb e5                	jmp    801040b2 <memcmp+0x12>
      return *s1 - *s2;
801040cd:	0f b6 c0             	movzbl %al,%eax
801040d0:	0f b6 db             	movzbl %bl,%ebx
801040d3:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801040d5:	5b                   	pop    %ebx
801040d6:	5e                   	pop    %esi
801040d7:	5d                   	pop    %ebp
801040d8:	c3                   	ret    

801040d9 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801040d9:	f3 0f 1e fb          	endbr32 
801040dd:	55                   	push   %ebp
801040de:	89 e5                	mov    %esp,%ebp
801040e0:	56                   	push   %esi
801040e1:	53                   	push   %ebx
801040e2:	8b 75 08             	mov    0x8(%ebp),%esi
801040e5:	8b 55 0c             	mov    0xc(%ebp),%edx
801040e8:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801040eb:	39 f2                	cmp    %esi,%edx
801040ed:	73 3a                	jae    80104129 <memmove+0x50>
801040ef:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
801040f2:	39 f1                	cmp    %esi,%ecx
801040f4:	76 37                	jbe    8010412d <memmove+0x54>
    s += n;
    d += n;
801040f6:	8d 14 06             	lea    (%esi,%eax,1),%edx
    while(n-- > 0)
801040f9:	8d 58 ff             	lea    -0x1(%eax),%ebx
801040fc:	85 c0                	test   %eax,%eax
801040fe:	74 23                	je     80104123 <memmove+0x4a>
      *--d = *--s;
80104100:	83 e9 01             	sub    $0x1,%ecx
80104103:	83 ea 01             	sub    $0x1,%edx
80104106:	0f b6 01             	movzbl (%ecx),%eax
80104109:	88 02                	mov    %al,(%edx)
    while(n-- > 0)
8010410b:	89 d8                	mov    %ebx,%eax
8010410d:	eb ea                	jmp    801040f9 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;
8010410f:	0f b6 02             	movzbl (%edx),%eax
80104112:	88 01                	mov    %al,(%ecx)
80104114:	8d 49 01             	lea    0x1(%ecx),%ecx
80104117:	8d 52 01             	lea    0x1(%edx),%edx
    while(n-- > 0)
8010411a:	89 d8                	mov    %ebx,%eax
8010411c:	8d 58 ff             	lea    -0x1(%eax),%ebx
8010411f:	85 c0                	test   %eax,%eax
80104121:	75 ec                	jne    8010410f <memmove+0x36>

  return dst;
}
80104123:	89 f0                	mov    %esi,%eax
80104125:	5b                   	pop    %ebx
80104126:	5e                   	pop    %esi
80104127:	5d                   	pop    %ebp
80104128:	c3                   	ret    
80104129:	89 f1                	mov    %esi,%ecx
8010412b:	eb ef                	jmp    8010411c <memmove+0x43>
8010412d:	89 f1                	mov    %esi,%ecx
8010412f:	eb eb                	jmp    8010411c <memmove+0x43>

80104131 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104131:	f3 0f 1e fb          	endbr32 
80104135:	55                   	push   %ebp
80104136:	89 e5                	mov    %esp,%ebp
80104138:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
8010413b:	ff 75 10             	pushl  0x10(%ebp)
8010413e:	ff 75 0c             	pushl  0xc(%ebp)
80104141:	ff 75 08             	pushl  0x8(%ebp)
80104144:	e8 90 ff ff ff       	call   801040d9 <memmove>
}
80104149:	c9                   	leave  
8010414a:	c3                   	ret    

8010414b <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010414b:	f3 0f 1e fb          	endbr32 
8010414f:	55                   	push   %ebp
80104150:	89 e5                	mov    %esp,%ebp
80104152:	53                   	push   %ebx
80104153:	8b 55 08             	mov    0x8(%ebp),%edx
80104156:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104159:	8b 45 10             	mov    0x10(%ebp),%eax
  while(n > 0 && *p && *p == *q)
8010415c:	eb 09                	jmp    80104167 <strncmp+0x1c>
    n--, p++, q++;
8010415e:	83 e8 01             	sub    $0x1,%eax
80104161:	83 c2 01             	add    $0x1,%edx
80104164:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104167:	85 c0                	test   %eax,%eax
80104169:	74 0b                	je     80104176 <strncmp+0x2b>
8010416b:	0f b6 1a             	movzbl (%edx),%ebx
8010416e:	84 db                	test   %bl,%bl
80104170:	74 04                	je     80104176 <strncmp+0x2b>
80104172:	3a 19                	cmp    (%ecx),%bl
80104174:	74 e8                	je     8010415e <strncmp+0x13>
  if(n == 0)
80104176:	85 c0                	test   %eax,%eax
80104178:	74 0b                	je     80104185 <strncmp+0x3a>
    return 0;
  return (uchar)*p - (uchar)*q;
8010417a:	0f b6 02             	movzbl (%edx),%eax
8010417d:	0f b6 11             	movzbl (%ecx),%edx
80104180:	29 d0                	sub    %edx,%eax
}
80104182:	5b                   	pop    %ebx
80104183:	5d                   	pop    %ebp
80104184:	c3                   	ret    
    return 0;
80104185:	b8 00 00 00 00       	mov    $0x0,%eax
8010418a:	eb f6                	jmp    80104182 <strncmp+0x37>

8010418c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010418c:	f3 0f 1e fb          	endbr32 
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	57                   	push   %edi
80104194:	56                   	push   %esi
80104195:	53                   	push   %ebx
80104196:	8b 7d 08             	mov    0x8(%ebp),%edi
80104199:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010419c:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010419f:	89 fa                	mov    %edi,%edx
801041a1:	eb 04                	jmp    801041a7 <strncpy+0x1b>
801041a3:	89 f1                	mov    %esi,%ecx
801041a5:	89 da                	mov    %ebx,%edx
801041a7:	89 c3                	mov    %eax,%ebx
801041a9:	83 e8 01             	sub    $0x1,%eax
801041ac:	85 db                	test   %ebx,%ebx
801041ae:	7e 1b                	jle    801041cb <strncpy+0x3f>
801041b0:	8d 71 01             	lea    0x1(%ecx),%esi
801041b3:	8d 5a 01             	lea    0x1(%edx),%ebx
801041b6:	0f b6 09             	movzbl (%ecx),%ecx
801041b9:	88 0a                	mov    %cl,(%edx)
801041bb:	84 c9                	test   %cl,%cl
801041bd:	75 e4                	jne    801041a3 <strncpy+0x17>
801041bf:	89 da                	mov    %ebx,%edx
801041c1:	eb 08                	jmp    801041cb <strncpy+0x3f>
    ;
  while(n-- > 0)
    *s++ = 0;
801041c3:	c6 02 00             	movb   $0x0,(%edx)
  while(n-- > 0)
801041c6:	89 c8                	mov    %ecx,%eax
    *s++ = 0;
801041c8:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
801041cb:	8d 48 ff             	lea    -0x1(%eax),%ecx
801041ce:	85 c0                	test   %eax,%eax
801041d0:	7f f1                	jg     801041c3 <strncpy+0x37>
  return os;
}
801041d2:	89 f8                	mov    %edi,%eax
801041d4:	5b                   	pop    %ebx
801041d5:	5e                   	pop    %esi
801041d6:	5f                   	pop    %edi
801041d7:	5d                   	pop    %ebp
801041d8:	c3                   	ret    

801041d9 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801041d9:	f3 0f 1e fb          	endbr32 
801041dd:	55                   	push   %ebp
801041de:	89 e5                	mov    %esp,%ebp
801041e0:	57                   	push   %edi
801041e1:	56                   	push   %esi
801041e2:	53                   	push   %ebx
801041e3:	8b 7d 08             	mov    0x8(%ebp),%edi
801041e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801041e9:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801041ec:	85 c0                	test   %eax,%eax
801041ee:	7e 23                	jle    80104213 <safestrcpy+0x3a>
801041f0:	89 fa                	mov    %edi,%edx
801041f2:	eb 04                	jmp    801041f8 <safestrcpy+0x1f>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801041f4:	89 f1                	mov    %esi,%ecx
801041f6:	89 da                	mov    %ebx,%edx
801041f8:	83 e8 01             	sub    $0x1,%eax
801041fb:	85 c0                	test   %eax,%eax
801041fd:	7e 11                	jle    80104210 <safestrcpy+0x37>
801041ff:	8d 71 01             	lea    0x1(%ecx),%esi
80104202:	8d 5a 01             	lea    0x1(%edx),%ebx
80104205:	0f b6 09             	movzbl (%ecx),%ecx
80104208:	88 0a                	mov    %cl,(%edx)
8010420a:	84 c9                	test   %cl,%cl
8010420c:	75 e6                	jne    801041f4 <safestrcpy+0x1b>
8010420e:	89 da                	mov    %ebx,%edx
    ;
  *s = 0;
80104210:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104213:	89 f8                	mov    %edi,%eax
80104215:	5b                   	pop    %ebx
80104216:	5e                   	pop    %esi
80104217:	5f                   	pop    %edi
80104218:	5d                   	pop    %ebp
80104219:	c3                   	ret    

8010421a <strlen>:

int
strlen(const char *s)
{
8010421a:	f3 0f 1e fb          	endbr32 
8010421e:	55                   	push   %ebp
8010421f:	89 e5                	mov    %esp,%ebp
80104221:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104224:	b8 00 00 00 00       	mov    $0x0,%eax
80104229:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010422d:	74 05                	je     80104234 <strlen+0x1a>
8010422f:	83 c0 01             	add    $0x1,%eax
80104232:	eb f5                	jmp    80104229 <strlen+0xf>
    ;
  return n;
}
80104234:	5d                   	pop    %ebp
80104235:	c3                   	ret    

80104236 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104236:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010423a:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
8010423e:	55                   	push   %ebp
  pushl %ebx
8010423f:	53                   	push   %ebx
  pushl %esi
80104240:	56                   	push   %esi
  pushl %edi
80104241:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104242:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104244:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104246:	5f                   	pop    %edi
  popl %esi
80104247:	5e                   	pop    %esi
  popl %ebx
80104248:	5b                   	pop    %ebx
  popl %ebp
80104249:	5d                   	pop    %ebp
  ret
8010424a:	c3                   	ret    

8010424b <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010424b:	f3 0f 1e fb          	endbr32 
8010424f:	55                   	push   %ebp
80104250:	89 e5                	mov    %esp,%ebp
80104252:	53                   	push   %ebx
80104253:	83 ec 04             	sub    $0x4,%esp
80104256:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104259:	e8 dd f0 ff ff       	call   8010333b <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010425e:	8b 00                	mov    (%eax),%eax
80104260:	39 d8                	cmp    %ebx,%eax
80104262:	76 19                	jbe    8010427d <fetchint+0x32>
80104264:	8d 53 04             	lea    0x4(%ebx),%edx
80104267:	39 d0                	cmp    %edx,%eax
80104269:	72 19                	jb     80104284 <fetchint+0x39>
    return -1;
  *ip = *(int*)(addr);
8010426b:	8b 13                	mov    (%ebx),%edx
8010426d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104270:	89 10                	mov    %edx,(%eax)
  return 0;
80104272:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104277:	83 c4 04             	add    $0x4,%esp
8010427a:	5b                   	pop    %ebx
8010427b:	5d                   	pop    %ebp
8010427c:	c3                   	ret    
    return -1;
8010427d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104282:	eb f3                	jmp    80104277 <fetchint+0x2c>
80104284:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104289:	eb ec                	jmp    80104277 <fetchint+0x2c>

8010428b <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
8010428b:	f3 0f 1e fb          	endbr32 
8010428f:	55                   	push   %ebp
80104290:	89 e5                	mov    %esp,%ebp
80104292:	53                   	push   %ebx
80104293:	83 ec 04             	sub    $0x4,%esp
80104296:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104299:	e8 9d f0 ff ff       	call   8010333b <myproc>

  if(addr >= curproc->sz)
8010429e:	39 18                	cmp    %ebx,(%eax)
801042a0:	76 26                	jbe    801042c8 <fetchstr+0x3d>
    return -1;
  *pp = (char*)addr;
801042a2:	8b 55 0c             	mov    0xc(%ebp),%edx
801042a5:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801042a7:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801042a9:	89 d8                	mov    %ebx,%eax
801042ab:	39 d0                	cmp    %edx,%eax
801042ad:	73 0e                	jae    801042bd <fetchstr+0x32>
    if(*s == 0)
801042af:	80 38 00             	cmpb   $0x0,(%eax)
801042b2:	74 05                	je     801042b9 <fetchstr+0x2e>
  for(s = *pp; s < ep; s++){
801042b4:	83 c0 01             	add    $0x1,%eax
801042b7:	eb f2                	jmp    801042ab <fetchstr+0x20>
      return s - *pp;
801042b9:	29 d8                	sub    %ebx,%eax
801042bb:	eb 05                	jmp    801042c2 <fetchstr+0x37>
  }
  return -1;
801042bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801042c2:	83 c4 04             	add    $0x4,%esp
801042c5:	5b                   	pop    %ebx
801042c6:	5d                   	pop    %ebp
801042c7:	c3                   	ret    
    return -1;
801042c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042cd:	eb f3                	jmp    801042c2 <fetchstr+0x37>

801042cf <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801042cf:	f3 0f 1e fb          	endbr32 
801042d3:	55                   	push   %ebp
801042d4:	89 e5                	mov    %esp,%ebp
801042d6:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801042d9:	e8 5d f0 ff ff       	call   8010333b <myproc>
801042de:	8b 50 18             	mov    0x18(%eax),%edx
801042e1:	8b 45 08             	mov    0x8(%ebp),%eax
801042e4:	c1 e0 02             	shl    $0x2,%eax
801042e7:	03 42 44             	add    0x44(%edx),%eax
801042ea:	83 ec 08             	sub    $0x8,%esp
801042ed:	ff 75 0c             	pushl  0xc(%ebp)
801042f0:	83 c0 04             	add    $0x4,%eax
801042f3:	50                   	push   %eax
801042f4:	e8 52 ff ff ff       	call   8010424b <fetchint>
}
801042f9:	c9                   	leave  
801042fa:	c3                   	ret    

801042fb <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801042fb:	f3 0f 1e fb          	endbr32 
801042ff:	55                   	push   %ebp
80104300:	89 e5                	mov    %esp,%ebp
80104302:	56                   	push   %esi
80104303:	53                   	push   %ebx
80104304:	83 ec 10             	sub    $0x10,%esp
80104307:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010430a:	e8 2c f0 ff ff       	call   8010333b <myproc>
8010430f:	89 c6                	mov    %eax,%esi

  if(argint(n, &i) < 0)
80104311:	83 ec 08             	sub    $0x8,%esp
80104314:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104317:	50                   	push   %eax
80104318:	ff 75 08             	pushl  0x8(%ebp)
8010431b:	e8 af ff ff ff       	call   801042cf <argint>
80104320:	83 c4 10             	add    $0x10,%esp
80104323:	85 c0                	test   %eax,%eax
80104325:	78 24                	js     8010434b <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104327:	85 db                	test   %ebx,%ebx
80104329:	78 27                	js     80104352 <argptr+0x57>
8010432b:	8b 16                	mov    (%esi),%edx
8010432d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104330:	39 c2                	cmp    %eax,%edx
80104332:	76 25                	jbe    80104359 <argptr+0x5e>
80104334:	01 c3                	add    %eax,%ebx
80104336:	39 da                	cmp    %ebx,%edx
80104338:	72 26                	jb     80104360 <argptr+0x65>
    return -1;
  *pp = (char*)i;
8010433a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010433d:	89 02                	mov    %eax,(%edx)
  return 0;
8010433f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104344:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104347:	5b                   	pop    %ebx
80104348:	5e                   	pop    %esi
80104349:	5d                   	pop    %ebp
8010434a:	c3                   	ret    
    return -1;
8010434b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104350:	eb f2                	jmp    80104344 <argptr+0x49>
    return -1;
80104352:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104357:	eb eb                	jmp    80104344 <argptr+0x49>
80104359:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010435e:	eb e4                	jmp    80104344 <argptr+0x49>
80104360:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104365:	eb dd                	jmp    80104344 <argptr+0x49>

80104367 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104367:	f3 0f 1e fb          	endbr32 
8010436b:	55                   	push   %ebp
8010436c:	89 e5                	mov    %esp,%ebp
8010436e:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104371:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104374:	50                   	push   %eax
80104375:	ff 75 08             	pushl  0x8(%ebp)
80104378:	e8 52 ff ff ff       	call   801042cf <argint>
8010437d:	83 c4 10             	add    $0x10,%esp
80104380:	85 c0                	test   %eax,%eax
80104382:	78 13                	js     80104397 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104384:	83 ec 08             	sub    $0x8,%esp
80104387:	ff 75 0c             	pushl  0xc(%ebp)
8010438a:	ff 75 f4             	pushl  -0xc(%ebp)
8010438d:	e8 f9 fe ff ff       	call   8010428b <fetchstr>
80104392:	83 c4 10             	add    $0x10,%esp
}
80104395:	c9                   	leave  
80104396:	c3                   	ret    
    return -1;
80104397:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010439c:	eb f7                	jmp    80104395 <argstr+0x2e>

8010439e <syscall>:
};
#endif // PRINT_SYSCALLS

void
syscall(void)
{
8010439e:	f3 0f 1e fb          	endbr32 
801043a2:	55                   	push   %ebp
801043a3:	89 e5                	mov    %esp,%ebp
801043a5:	56                   	push   %esi
801043a6:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
801043a7:	e8 8f ef ff ff       	call   8010333b <myproc>
801043ac:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801043ae:	8b 40 18             	mov    0x18(%eax),%eax
801043b1:	8b 70 1c             	mov    0x1c(%eax),%esi
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801043b4:	8d 46 ff             	lea    -0x1(%esi),%eax
801043b7:	83 f8 1d             	cmp    $0x1d,%eax
801043ba:	77 2c                	ja     801043e8 <syscall+0x4a>
801043bc:	83 3c b5 60 71 10 80 	cmpl   $0x0,-0x7fef8ea0(,%esi,4)
801043c3:	00 
801043c4:	74 22                	je     801043e8 <syscall+0x4a>
    (myproc()->sys_count[num - 1])++;        /* ......... whenever system call is made 
801043c6:	e8 70 ef ff ff       	call   8010333b <myproc>
801043cb:	8d 4e 1f             	lea    0x1f(%esi),%ecx
801043ce:	8b 14 88             	mov    (%eax,%ecx,4),%edx
801043d1:	83 c2 01             	add    $0x1,%edx
801043d4:	89 14 88             	mov    %edx,(%eax,%ecx,4)
                                              in a process value in array corresponding 
                                              to that process number is increamented by 
                                              one thus by counting the number of time a 
                                              system call has invoked in process.... */
    curproc->tf->eax = syscalls[num]();
801043d7:	ff 14 b5 60 71 10 80 	call   *-0x7fef8ea0(,%esi,4)
801043de:	89 c2                	mov    %eax,%edx
801043e0:	8b 43 18             	mov    0x18(%ebx),%eax
801043e3:	89 50 1c             	mov    %edx,0x1c(%eax)
801043e6:	eb 1f                	jmp    80104407 <syscall+0x69>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
801043e8:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801043eb:	56                   	push   %esi
801043ec:	50                   	push   %eax
801043ed:	ff 73 10             	pushl  0x10(%ebx)
801043f0:	68 29 71 10 80       	push   $0x80107129
801043f5:	e8 2f c2 ff ff       	call   80100629 <cprintf>
    curproc->tf->eax = -1;
801043fa:	8b 43 18             	mov    0x18(%ebx),%eax
801043fd:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80104404:	83 c4 10             	add    $0x10,%esp
  }
}
80104407:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010440a:	5b                   	pop    %ebx
8010440b:	5e                   	pop    %esi
8010440c:	5d                   	pop    %ebp
8010440d:	c3                   	ret    

8010440e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
8010440e:	55                   	push   %ebp
8010440f:	89 e5                	mov    %esp,%ebp
80104411:	56                   	push   %esi
80104412:	53                   	push   %ebx
80104413:	83 ec 18             	sub    $0x18,%esp
80104416:	89 d6                	mov    %edx,%esi
80104418:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010441a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010441d:	52                   	push   %edx
8010441e:	50                   	push   %eax
8010441f:	e8 ab fe ff ff       	call   801042cf <argint>
80104424:	83 c4 10             	add    $0x10,%esp
80104427:	85 c0                	test   %eax,%eax
80104429:	78 35                	js     80104460 <argfd+0x52>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010442b:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010442f:	77 28                	ja     80104459 <argfd+0x4b>
80104431:	e8 05 ef ff ff       	call   8010333b <myproc>
80104436:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104439:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
8010443d:	85 c0                	test   %eax,%eax
8010443f:	74 18                	je     80104459 <argfd+0x4b>
    return -1;
  if(pfd)
80104441:	85 f6                	test   %esi,%esi
80104443:	74 02                	je     80104447 <argfd+0x39>
    *pfd = fd;
80104445:	89 16                	mov    %edx,(%esi)
  if(pf)
80104447:	85 db                	test   %ebx,%ebx
80104449:	74 1c                	je     80104467 <argfd+0x59>
    *pf = f;
8010444b:	89 03                	mov    %eax,(%ebx)
  return 0;
8010444d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104452:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104455:	5b                   	pop    %ebx
80104456:	5e                   	pop    %esi
80104457:	5d                   	pop    %ebp
80104458:	c3                   	ret    
    return -1;
80104459:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010445e:	eb f2                	jmp    80104452 <argfd+0x44>
    return -1;
80104460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104465:	eb eb                	jmp    80104452 <argfd+0x44>
  return 0;
80104467:	b8 00 00 00 00       	mov    $0x0,%eax
8010446c:	eb e4                	jmp    80104452 <argfd+0x44>

8010446e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010446e:	55                   	push   %ebp
8010446f:	89 e5                	mov    %esp,%ebp
80104471:	53                   	push   %ebx
80104472:	83 ec 04             	sub    $0x4,%esp
80104475:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
80104477:	e8 bf ee ff ff       	call   8010333b <myproc>
8010447c:	89 c2                	mov    %eax,%edx

  for(fd = 0; fd < NOFILE; fd++){
8010447e:	b8 00 00 00 00       	mov    $0x0,%eax
80104483:	83 f8 0f             	cmp    $0xf,%eax
80104486:	7f 12                	jg     8010449a <fdalloc+0x2c>
    if(curproc->ofile[fd] == 0){
80104488:	83 7c 82 28 00       	cmpl   $0x0,0x28(%edx,%eax,4)
8010448d:	74 05                	je     80104494 <fdalloc+0x26>
  for(fd = 0; fd < NOFILE; fd++){
8010448f:	83 c0 01             	add    $0x1,%eax
80104492:	eb ef                	jmp    80104483 <fdalloc+0x15>
      curproc->ofile[fd] = f;
80104494:	89 5c 82 28          	mov    %ebx,0x28(%edx,%eax,4)
      return fd;
80104498:	eb 05                	jmp    8010449f <fdalloc+0x31>
    }
  }
  return -1;
8010449a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010449f:	83 c4 04             	add    $0x4,%esp
801044a2:	5b                   	pop    %ebx
801044a3:	5d                   	pop    %ebp
801044a4:	c3                   	ret    

801044a5 <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801044a5:	55                   	push   %ebp
801044a6:	89 e5                	mov    %esp,%ebp
801044a8:	56                   	push   %esi
801044a9:	53                   	push   %ebx
801044aa:	83 ec 10             	sub    $0x10,%esp
801044ad:	89 c3                	mov    %eax,%ebx
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801044af:	b8 20 00 00 00       	mov    $0x20,%eax
801044b4:	89 c6                	mov    %eax,%esi
801044b6:	39 43 58             	cmp    %eax,0x58(%ebx)
801044b9:	76 2e                	jbe    801044e9 <isdirempty+0x44>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801044bb:	6a 10                	push   $0x10
801044bd:	50                   	push   %eax
801044be:	8d 45 e8             	lea    -0x18(%ebp),%eax
801044c1:	50                   	push   %eax
801044c2:	53                   	push   %ebx
801044c3:	e8 45 d3 ff ff       	call   8010180d <readi>
801044c8:	83 c4 10             	add    $0x10,%esp
801044cb:	83 f8 10             	cmp    $0x10,%eax
801044ce:	75 0c                	jne    801044dc <isdirempty+0x37>
      panic("isdirempty: readi");
    if(de.inum != 0)
801044d0:	66 83 7d e8 00       	cmpw   $0x0,-0x18(%ebp)
801044d5:	75 1e                	jne    801044f5 <isdirempty+0x50>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801044d7:	8d 46 10             	lea    0x10(%esi),%eax
801044da:	eb d8                	jmp    801044b4 <isdirempty+0xf>
      panic("isdirempty: readi");
801044dc:	83 ec 0c             	sub    $0xc,%esp
801044df:	68 dc 71 10 80       	push   $0x801071dc
801044e4:	e8 73 be ff ff       	call   8010035c <panic>
      return 0;
  }
  return 1;
801044e9:	b8 01 00 00 00       	mov    $0x1,%eax
}
801044ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044f1:	5b                   	pop    %ebx
801044f2:	5e                   	pop    %esi
801044f3:	5d                   	pop    %ebp
801044f4:	c3                   	ret    
      return 0;
801044f5:	b8 00 00 00 00       	mov    $0x0,%eax
801044fa:	eb f2                	jmp    801044ee <isdirempty+0x49>

801044fc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801044fc:	55                   	push   %ebp
801044fd:	89 e5                	mov    %esp,%ebp
801044ff:	57                   	push   %edi
80104500:	56                   	push   %esi
80104501:	53                   	push   %ebx
80104502:	83 ec 44             	sub    $0x44,%esp
80104505:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104508:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010450b:	8b 7d 08             	mov    0x8(%ebp),%edi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010450e:	8d 55 d6             	lea    -0x2a(%ebp),%edx
80104511:	52                   	push   %edx
80104512:	50                   	push   %eax
80104513:	e8 90 d7 ff ff       	call   80101ca8 <nameiparent>
80104518:	89 c6                	mov    %eax,%esi
8010451a:	83 c4 10             	add    $0x10,%esp
8010451d:	85 c0                	test   %eax,%eax
8010451f:	0f 84 35 01 00 00    	je     8010465a <create+0x15e>
    return 0;
  ilock(dp);
80104525:	83 ec 0c             	sub    $0xc,%esp
80104528:	50                   	push   %eax
80104529:	e8 d9 d0 ff ff       	call   80101607 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
8010452e:	83 c4 0c             	add    $0xc,%esp
80104531:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104534:	50                   	push   %eax
80104535:	8d 45 d6             	lea    -0x2a(%ebp),%eax
80104538:	50                   	push   %eax
80104539:	56                   	push   %esi
8010453a:	e8 17 d5 ff ff       	call   80101a56 <dirlookup>
8010453f:	89 c3                	mov    %eax,%ebx
80104541:	83 c4 10             	add    $0x10,%esp
80104544:	85 c0                	test   %eax,%eax
80104546:	74 3d                	je     80104585 <create+0x89>
    iunlockput(dp);
80104548:	83 ec 0c             	sub    $0xc,%esp
8010454b:	56                   	push   %esi
8010454c:	e8 69 d2 ff ff       	call   801017ba <iunlockput>
    ilock(ip);
80104551:	89 1c 24             	mov    %ebx,(%esp)
80104554:	e8 ae d0 ff ff       	call   80101607 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104559:	83 c4 10             	add    $0x10,%esp
8010455c:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104561:	75 07                	jne    8010456a <create+0x6e>
80104563:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104568:	74 11                	je     8010457b <create+0x7f>
      return ip;
    iunlockput(ip);
8010456a:	83 ec 0c             	sub    $0xc,%esp
8010456d:	53                   	push   %ebx
8010456e:	e8 47 d2 ff ff       	call   801017ba <iunlockput>
    return 0;
80104573:	83 c4 10             	add    $0x10,%esp
80104576:	bb 00 00 00 00       	mov    $0x0,%ebx
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010457b:	89 d8                	mov    %ebx,%eax
8010457d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104580:	5b                   	pop    %ebx
80104581:	5e                   	pop    %esi
80104582:	5f                   	pop    %edi
80104583:	5d                   	pop    %ebp
80104584:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104585:	83 ec 08             	sub    $0x8,%esp
80104588:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
8010458c:	50                   	push   %eax
8010458d:	ff 36                	pushl  (%esi)
8010458f:	e8 64 ce ff ff       	call   801013f8 <ialloc>
80104594:	89 c3                	mov    %eax,%ebx
80104596:	83 c4 10             	add    $0x10,%esp
80104599:	85 c0                	test   %eax,%eax
8010459b:	74 52                	je     801045ef <create+0xf3>
  ilock(ip);
8010459d:	83 ec 0c             	sub    $0xc,%esp
801045a0:	50                   	push   %eax
801045a1:	e8 61 d0 ff ff       	call   80101607 <ilock>
  ip->major = major;
801045a6:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801045aa:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
801045ae:	66 89 7b 54          	mov    %di,0x54(%ebx)
  ip->nlink = 1;
801045b2:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
801045b8:	89 1c 24             	mov    %ebx,(%esp)
801045bb:	e8 de ce ff ff       	call   8010149e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801045c0:	83 c4 10             	add    $0x10,%esp
801045c3:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801045c8:	74 32                	je     801045fc <create+0x100>
  if(dirlink(dp, name, ip->inum) < 0)
801045ca:	83 ec 04             	sub    $0x4,%esp
801045cd:	ff 73 04             	pushl  0x4(%ebx)
801045d0:	8d 45 d6             	lea    -0x2a(%ebp),%eax
801045d3:	50                   	push   %eax
801045d4:	56                   	push   %esi
801045d5:	e8 fd d5 ff ff       	call   80101bd7 <dirlink>
801045da:	83 c4 10             	add    $0x10,%esp
801045dd:	85 c0                	test   %eax,%eax
801045df:	78 6c                	js     8010464d <create+0x151>
  iunlockput(dp);
801045e1:	83 ec 0c             	sub    $0xc,%esp
801045e4:	56                   	push   %esi
801045e5:	e8 d0 d1 ff ff       	call   801017ba <iunlockput>
  return ip;
801045ea:	83 c4 10             	add    $0x10,%esp
801045ed:	eb 8c                	jmp    8010457b <create+0x7f>
    panic("create: ialloc");
801045ef:	83 ec 0c             	sub    $0xc,%esp
801045f2:	68 ee 71 10 80       	push   $0x801071ee
801045f7:	e8 60 bd ff ff       	call   8010035c <panic>
    dp->nlink++;  // for ".."
801045fc:	0f b7 46 56          	movzwl 0x56(%esi),%eax
80104600:	83 c0 01             	add    $0x1,%eax
80104603:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
80104607:	83 ec 0c             	sub    $0xc,%esp
8010460a:	56                   	push   %esi
8010460b:	e8 8e ce ff ff       	call   8010149e <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104610:	83 c4 0c             	add    $0xc,%esp
80104613:	ff 73 04             	pushl  0x4(%ebx)
80104616:	68 fe 71 10 80       	push   $0x801071fe
8010461b:	53                   	push   %ebx
8010461c:	e8 b6 d5 ff ff       	call   80101bd7 <dirlink>
80104621:	83 c4 10             	add    $0x10,%esp
80104624:	85 c0                	test   %eax,%eax
80104626:	78 18                	js     80104640 <create+0x144>
80104628:	83 ec 04             	sub    $0x4,%esp
8010462b:	ff 76 04             	pushl  0x4(%esi)
8010462e:	68 fd 71 10 80       	push   $0x801071fd
80104633:	53                   	push   %ebx
80104634:	e8 9e d5 ff ff       	call   80101bd7 <dirlink>
80104639:	83 c4 10             	add    $0x10,%esp
8010463c:	85 c0                	test   %eax,%eax
8010463e:	79 8a                	jns    801045ca <create+0xce>
      panic("create dots");
80104640:	83 ec 0c             	sub    $0xc,%esp
80104643:	68 00 72 10 80       	push   $0x80107200
80104648:	e8 0f bd ff ff       	call   8010035c <panic>
    panic("create: dirlink");
8010464d:	83 ec 0c             	sub    $0xc,%esp
80104650:	68 0c 72 10 80       	push   $0x8010720c
80104655:	e8 02 bd ff ff       	call   8010035c <panic>
    return 0;
8010465a:	89 c3                	mov    %eax,%ebx
8010465c:	e9 1a ff ff ff       	jmp    8010457b <create+0x7f>

80104661 <sys_dup>:
{
80104661:	f3 0f 1e fb          	endbr32 
80104665:	55                   	push   %ebp
80104666:	89 e5                	mov    %esp,%ebp
80104668:	53                   	push   %ebx
80104669:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
8010466c:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010466f:	ba 00 00 00 00       	mov    $0x0,%edx
80104674:	b8 00 00 00 00       	mov    $0x0,%eax
80104679:	e8 90 fd ff ff       	call   8010440e <argfd>
8010467e:	85 c0                	test   %eax,%eax
80104680:	78 23                	js     801046a5 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
80104682:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104685:	e8 e4 fd ff ff       	call   8010446e <fdalloc>
8010468a:	89 c3                	mov    %eax,%ebx
8010468c:	85 c0                	test   %eax,%eax
8010468e:	78 1c                	js     801046ac <sys_dup+0x4b>
  filedup(f);
80104690:	83 ec 0c             	sub    $0xc,%esp
80104693:	ff 75 f4             	pushl  -0xc(%ebp)
80104696:	e8 50 c6 ff ff       	call   80100ceb <filedup>
  return fd;
8010469b:	83 c4 10             	add    $0x10,%esp
}
8010469e:	89 d8                	mov    %ebx,%eax
801046a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046a3:	c9                   	leave  
801046a4:	c3                   	ret    
    return -1;
801046a5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801046aa:	eb f2                	jmp    8010469e <sys_dup+0x3d>
    return -1;
801046ac:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801046b1:	eb eb                	jmp    8010469e <sys_dup+0x3d>

801046b3 <sys_dup2>:
int sys_dup2(void) {
801046b3:	f3 0f 1e fb          	endbr32 
801046b7:	55                   	push   %ebp
801046b8:	89 e5                	mov    %esp,%ebp
801046ba:	56                   	push   %esi
801046bb:	53                   	push   %ebx
801046bc:	83 ec 10             	sub    $0x10,%esp
  if (argfd(0, &oldfd, &oldfile) < 0) {
801046bf:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801046c2:	8d 55 ec             	lea    -0x14(%ebp),%edx
801046c5:	b8 00 00 00 00       	mov    $0x0,%eax
801046ca:	e8 3f fd ff ff       	call   8010440e <argfd>
801046cf:	85 c0                	test   %eax,%eax
801046d1:	78 55                	js     80104728 <sys_dup2+0x75>
  if (argfd(1, &newfd, &newfile) == 0) {
801046d3:	8d 4d f0             	lea    -0x10(%ebp),%ecx
801046d6:	8d 55 e8             	lea    -0x18(%ebp),%edx
801046d9:	b8 01 00 00 00       	mov    $0x1,%eax
801046de:	e8 2b fd ff ff       	call   8010440e <argfd>
801046e3:	85 c0                	test   %eax,%eax
801046e5:	74 31                	je     80104718 <sys_dup2+0x65>
    filedup(oldfile); // increment reference count;
801046e7:	83 ec 0c             	sub    $0xc,%esp
801046ea:	ff 75 f4             	pushl  -0xc(%ebp)
801046ed:	e8 f9 c5 ff ff       	call   80100ceb <filedup>
    myproc()->ofile[newfd] = myproc()->ofile[oldfd];
801046f2:	e8 44 ec ff ff       	call   8010333b <myproc>
801046f7:	89 c3                	mov    %eax,%ebx
801046f9:	8b 75 ec             	mov    -0x14(%ebp),%esi
801046fc:	e8 3a ec ff ff       	call   8010333b <myproc>
80104701:	89 c2                	mov    %eax,%edx
80104703:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104706:	8b 4c b3 28          	mov    0x28(%ebx,%esi,4),%ecx
8010470a:	89 4c 82 28          	mov    %ecx,0x28(%edx,%eax,4)
  return newfd;
8010470e:	83 c4 10             	add    $0x10,%esp
}
80104711:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104714:	5b                   	pop    %ebx
80104715:	5e                   	pop    %esi
80104716:	5d                   	pop    %ebp
80104717:	c3                   	ret    
    fileclose(newfile);
80104718:	83 ec 0c             	sub    $0xc,%esp
8010471b:	ff 75 f0             	pushl  -0x10(%ebp)
8010471e:	e8 11 c6 ff ff       	call   80100d34 <fileclose>
80104723:	83 c4 10             	add    $0x10,%esp
80104726:	eb bf                	jmp    801046e7 <sys_dup2+0x34>
    return -1;
80104728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010472d:	eb e2                	jmp    80104711 <sys_dup2+0x5e>

8010472f <sys_read>:
{
8010472f:	f3 0f 1e fb          	endbr32 
80104733:	55                   	push   %ebp
80104734:	89 e5                	mov    %esp,%ebp
80104736:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104739:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010473c:	ba 00 00 00 00       	mov    $0x0,%edx
80104741:	b8 00 00 00 00       	mov    $0x0,%eax
80104746:	e8 c3 fc ff ff       	call   8010440e <argfd>
8010474b:	85 c0                	test   %eax,%eax
8010474d:	78 43                	js     80104792 <sys_read+0x63>
8010474f:	83 ec 08             	sub    $0x8,%esp
80104752:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104755:	50                   	push   %eax
80104756:	6a 02                	push   $0x2
80104758:	e8 72 fb ff ff       	call   801042cf <argint>
8010475d:	83 c4 10             	add    $0x10,%esp
80104760:	85 c0                	test   %eax,%eax
80104762:	78 2e                	js     80104792 <sys_read+0x63>
80104764:	83 ec 04             	sub    $0x4,%esp
80104767:	ff 75 f0             	pushl  -0x10(%ebp)
8010476a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010476d:	50                   	push   %eax
8010476e:	6a 01                	push   $0x1
80104770:	e8 86 fb ff ff       	call   801042fb <argptr>
80104775:	83 c4 10             	add    $0x10,%esp
80104778:	85 c0                	test   %eax,%eax
8010477a:	78 16                	js     80104792 <sys_read+0x63>
  return fileread(f, p, n);
8010477c:	83 ec 04             	sub    $0x4,%esp
8010477f:	ff 75 f0             	pushl  -0x10(%ebp)
80104782:	ff 75 ec             	pushl  -0x14(%ebp)
80104785:	ff 75 f4             	pushl  -0xc(%ebp)
80104788:	e8 b0 c6 ff ff       	call   80100e3d <fileread>
8010478d:	83 c4 10             	add    $0x10,%esp
}
80104790:	c9                   	leave  
80104791:	c3                   	ret    
    return -1;
80104792:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104797:	eb f7                	jmp    80104790 <sys_read+0x61>

80104799 <sys_write>:
{
80104799:	f3 0f 1e fb          	endbr32 
8010479d:	55                   	push   %ebp
8010479e:	89 e5                	mov    %esp,%ebp
801047a0:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801047a3:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801047a6:	ba 00 00 00 00       	mov    $0x0,%edx
801047ab:	b8 00 00 00 00       	mov    $0x0,%eax
801047b0:	e8 59 fc ff ff       	call   8010440e <argfd>
801047b5:	85 c0                	test   %eax,%eax
801047b7:	78 43                	js     801047fc <sys_write+0x63>
801047b9:	83 ec 08             	sub    $0x8,%esp
801047bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801047bf:	50                   	push   %eax
801047c0:	6a 02                	push   $0x2
801047c2:	e8 08 fb ff ff       	call   801042cf <argint>
801047c7:	83 c4 10             	add    $0x10,%esp
801047ca:	85 c0                	test   %eax,%eax
801047cc:	78 2e                	js     801047fc <sys_write+0x63>
801047ce:	83 ec 04             	sub    $0x4,%esp
801047d1:	ff 75 f0             	pushl  -0x10(%ebp)
801047d4:	8d 45 ec             	lea    -0x14(%ebp),%eax
801047d7:	50                   	push   %eax
801047d8:	6a 01                	push   $0x1
801047da:	e8 1c fb ff ff       	call   801042fb <argptr>
801047df:	83 c4 10             	add    $0x10,%esp
801047e2:	85 c0                	test   %eax,%eax
801047e4:	78 16                	js     801047fc <sys_write+0x63>
  return filewrite(f, p, n);
801047e6:	83 ec 04             	sub    $0x4,%esp
801047e9:	ff 75 f0             	pushl  -0x10(%ebp)
801047ec:	ff 75 ec             	pushl  -0x14(%ebp)
801047ef:	ff 75 f4             	pushl  -0xc(%ebp)
801047f2:	e8 cf c6 ff ff       	call   80100ec6 <filewrite>
801047f7:	83 c4 10             	add    $0x10,%esp
}
801047fa:	c9                   	leave  
801047fb:	c3                   	ret    
    return -1;
801047fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104801:	eb f7                	jmp    801047fa <sys_write+0x61>

80104803 <sys_close>:
{
80104803:	f3 0f 1e fb          	endbr32 
80104807:	55                   	push   %ebp
80104808:	89 e5                	mov    %esp,%ebp
8010480a:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010480d:	8d 4d f0             	lea    -0x10(%ebp),%ecx
80104810:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104813:	b8 00 00 00 00       	mov    $0x0,%eax
80104818:	e8 f1 fb ff ff       	call   8010440e <argfd>
8010481d:	85 c0                	test   %eax,%eax
8010481f:	78 25                	js     80104846 <sys_close+0x43>
  myproc()->ofile[fd] = 0;
80104821:	e8 15 eb ff ff       	call   8010333b <myproc>
80104826:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104829:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104830:	00 
  fileclose(f);
80104831:	83 ec 0c             	sub    $0xc,%esp
80104834:	ff 75 f0             	pushl  -0x10(%ebp)
80104837:	e8 f8 c4 ff ff       	call   80100d34 <fileclose>
  return 0;
8010483c:	83 c4 10             	add    $0x10,%esp
8010483f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104844:	c9                   	leave  
80104845:	c3                   	ret    
    return -1;
80104846:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010484b:	eb f7                	jmp    80104844 <sys_close+0x41>

8010484d <sys_fstat>:
{
8010484d:	f3 0f 1e fb          	endbr32 
80104851:	55                   	push   %ebp
80104852:	89 e5                	mov    %esp,%ebp
80104854:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104857:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010485a:	ba 00 00 00 00       	mov    $0x0,%edx
8010485f:	b8 00 00 00 00       	mov    $0x0,%eax
80104864:	e8 a5 fb ff ff       	call   8010440e <argfd>
80104869:	85 c0                	test   %eax,%eax
8010486b:	78 2a                	js     80104897 <sys_fstat+0x4a>
8010486d:	83 ec 04             	sub    $0x4,%esp
80104870:	6a 14                	push   $0x14
80104872:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104875:	50                   	push   %eax
80104876:	6a 01                	push   $0x1
80104878:	e8 7e fa ff ff       	call   801042fb <argptr>
8010487d:	83 c4 10             	add    $0x10,%esp
80104880:	85 c0                	test   %eax,%eax
80104882:	78 13                	js     80104897 <sys_fstat+0x4a>
  return filestat(f, st);
80104884:	83 ec 08             	sub    $0x8,%esp
80104887:	ff 75 f0             	pushl  -0x10(%ebp)
8010488a:	ff 75 f4             	pushl  -0xc(%ebp)
8010488d:	e8 60 c5 ff ff       	call   80100df2 <filestat>
80104892:	83 c4 10             	add    $0x10,%esp
}
80104895:	c9                   	leave  
80104896:	c3                   	ret    
    return -1;
80104897:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010489c:	eb f7                	jmp    80104895 <sys_fstat+0x48>

8010489e <sys_link>:
{
8010489e:	f3 0f 1e fb          	endbr32 
801048a2:	55                   	push   %ebp
801048a3:	89 e5                	mov    %esp,%ebp
801048a5:	56                   	push   %esi
801048a6:	53                   	push   %ebx
801048a7:	83 ec 28             	sub    $0x28,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801048aa:	8d 45 e0             	lea    -0x20(%ebp),%eax
801048ad:	50                   	push   %eax
801048ae:	6a 00                	push   $0x0
801048b0:	e8 b2 fa ff ff       	call   80104367 <argstr>
801048b5:	83 c4 10             	add    $0x10,%esp
801048b8:	85 c0                	test   %eax,%eax
801048ba:	0f 88 d3 00 00 00    	js     80104993 <sys_link+0xf5>
801048c0:	83 ec 08             	sub    $0x8,%esp
801048c3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801048c6:	50                   	push   %eax
801048c7:	6a 01                	push   $0x1
801048c9:	e8 99 fa ff ff       	call   80104367 <argstr>
801048ce:	83 c4 10             	add    $0x10,%esp
801048d1:	85 c0                	test   %eax,%eax
801048d3:	0f 88 ba 00 00 00    	js     80104993 <sys_link+0xf5>
  begin_op();
801048d9:	e8 ae df ff ff       	call   8010288c <begin_op>
  if((ip = namei(old)) == 0){
801048de:	83 ec 0c             	sub    $0xc,%esp
801048e1:	ff 75 e0             	pushl  -0x20(%ebp)
801048e4:	e8 a3 d3 ff ff       	call   80101c8c <namei>
801048e9:	89 c3                	mov    %eax,%ebx
801048eb:	83 c4 10             	add    $0x10,%esp
801048ee:	85 c0                	test   %eax,%eax
801048f0:	0f 84 a4 00 00 00    	je     8010499a <sys_link+0xfc>
  ilock(ip);
801048f6:	83 ec 0c             	sub    $0xc,%esp
801048f9:	50                   	push   %eax
801048fa:	e8 08 cd ff ff       	call   80101607 <ilock>
  if(ip->type == T_DIR){
801048ff:	83 c4 10             	add    $0x10,%esp
80104902:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104907:	0f 84 99 00 00 00    	je     801049a6 <sys_link+0x108>
  ip->nlink++;
8010490d:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
80104911:	83 c0 01             	add    $0x1,%eax
80104914:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104918:	83 ec 0c             	sub    $0xc,%esp
8010491b:	53                   	push   %ebx
8010491c:	e8 7d cb ff ff       	call   8010149e <iupdate>
  iunlock(ip);
80104921:	89 1c 24             	mov    %ebx,(%esp)
80104924:	e8 a4 cd ff ff       	call   801016cd <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104929:	83 c4 08             	add    $0x8,%esp
8010492c:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010492f:	50                   	push   %eax
80104930:	ff 75 e4             	pushl  -0x1c(%ebp)
80104933:	e8 70 d3 ff ff       	call   80101ca8 <nameiparent>
80104938:	89 c6                	mov    %eax,%esi
8010493a:	83 c4 10             	add    $0x10,%esp
8010493d:	85 c0                	test   %eax,%eax
8010493f:	0f 84 85 00 00 00    	je     801049ca <sys_link+0x12c>
  ilock(dp);
80104945:	83 ec 0c             	sub    $0xc,%esp
80104948:	50                   	push   %eax
80104949:	e8 b9 cc ff ff       	call   80101607 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010494e:	83 c4 10             	add    $0x10,%esp
80104951:	8b 03                	mov    (%ebx),%eax
80104953:	39 06                	cmp    %eax,(%esi)
80104955:	75 67                	jne    801049be <sys_link+0x120>
80104957:	83 ec 04             	sub    $0x4,%esp
8010495a:	ff 73 04             	pushl  0x4(%ebx)
8010495d:	8d 45 ea             	lea    -0x16(%ebp),%eax
80104960:	50                   	push   %eax
80104961:	56                   	push   %esi
80104962:	e8 70 d2 ff ff       	call   80101bd7 <dirlink>
80104967:	83 c4 10             	add    $0x10,%esp
8010496a:	85 c0                	test   %eax,%eax
8010496c:	78 50                	js     801049be <sys_link+0x120>
  iunlockput(dp);
8010496e:	83 ec 0c             	sub    $0xc,%esp
80104971:	56                   	push   %esi
80104972:	e8 43 ce ff ff       	call   801017ba <iunlockput>
  iput(ip);
80104977:	89 1c 24             	mov    %ebx,(%esp)
8010497a:	e8 97 cd ff ff       	call   80101716 <iput>
  end_op();
8010497f:	e8 86 df ff ff       	call   8010290a <end_op>
  return 0;
80104984:	83 c4 10             	add    $0x10,%esp
80104987:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010498c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010498f:	5b                   	pop    %ebx
80104990:	5e                   	pop    %esi
80104991:	5d                   	pop    %ebp
80104992:	c3                   	ret    
    return -1;
80104993:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104998:	eb f2                	jmp    8010498c <sys_link+0xee>
    end_op();
8010499a:	e8 6b df ff ff       	call   8010290a <end_op>
    return -1;
8010499f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049a4:	eb e6                	jmp    8010498c <sys_link+0xee>
    iunlockput(ip);
801049a6:	83 ec 0c             	sub    $0xc,%esp
801049a9:	53                   	push   %ebx
801049aa:	e8 0b ce ff ff       	call   801017ba <iunlockput>
    end_op();
801049af:	e8 56 df ff ff       	call   8010290a <end_op>
    return -1;
801049b4:	83 c4 10             	add    $0x10,%esp
801049b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049bc:	eb ce                	jmp    8010498c <sys_link+0xee>
    iunlockput(dp);
801049be:	83 ec 0c             	sub    $0xc,%esp
801049c1:	56                   	push   %esi
801049c2:	e8 f3 cd ff ff       	call   801017ba <iunlockput>
    goto bad;
801049c7:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801049ca:	83 ec 0c             	sub    $0xc,%esp
801049cd:	53                   	push   %ebx
801049ce:	e8 34 cc ff ff       	call   80101607 <ilock>
  ip->nlink--;
801049d3:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
801049d7:	83 e8 01             	sub    $0x1,%eax
801049da:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801049de:	89 1c 24             	mov    %ebx,(%esp)
801049e1:	e8 b8 ca ff ff       	call   8010149e <iupdate>
  iunlockput(ip);
801049e6:	89 1c 24             	mov    %ebx,(%esp)
801049e9:	e8 cc cd ff ff       	call   801017ba <iunlockput>
  end_op();
801049ee:	e8 17 df ff ff       	call   8010290a <end_op>
  return -1;
801049f3:	83 c4 10             	add    $0x10,%esp
801049f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049fb:	eb 8f                	jmp    8010498c <sys_link+0xee>

801049fd <sys_unlink>:
{
801049fd:	f3 0f 1e fb          	endbr32 
80104a01:	55                   	push   %ebp
80104a02:	89 e5                	mov    %esp,%ebp
80104a04:	57                   	push   %edi
80104a05:	56                   	push   %esi
80104a06:	53                   	push   %ebx
80104a07:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80104a0a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104a0d:	50                   	push   %eax
80104a0e:	6a 00                	push   $0x0
80104a10:	e8 52 f9 ff ff       	call   80104367 <argstr>
80104a15:	83 c4 10             	add    $0x10,%esp
80104a18:	85 c0                	test   %eax,%eax
80104a1a:	0f 88 83 01 00 00    	js     80104ba3 <sys_unlink+0x1a6>
  begin_op();
80104a20:	e8 67 de ff ff       	call   8010288c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104a25:	83 ec 08             	sub    $0x8,%esp
80104a28:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104a2b:	50                   	push   %eax
80104a2c:	ff 75 c4             	pushl  -0x3c(%ebp)
80104a2f:	e8 74 d2 ff ff       	call   80101ca8 <nameiparent>
80104a34:	89 c6                	mov    %eax,%esi
80104a36:	83 c4 10             	add    $0x10,%esp
80104a39:	85 c0                	test   %eax,%eax
80104a3b:	0f 84 ed 00 00 00    	je     80104b2e <sys_unlink+0x131>
  ilock(dp);
80104a41:	83 ec 0c             	sub    $0xc,%esp
80104a44:	50                   	push   %eax
80104a45:	e8 bd cb ff ff       	call   80101607 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104a4a:	83 c4 08             	add    $0x8,%esp
80104a4d:	68 fe 71 10 80       	push   $0x801071fe
80104a52:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104a55:	50                   	push   %eax
80104a56:	e8 e2 cf ff ff       	call   80101a3d <namecmp>
80104a5b:	83 c4 10             	add    $0x10,%esp
80104a5e:	85 c0                	test   %eax,%eax
80104a60:	0f 84 fc 00 00 00    	je     80104b62 <sys_unlink+0x165>
80104a66:	83 ec 08             	sub    $0x8,%esp
80104a69:	68 fd 71 10 80       	push   $0x801071fd
80104a6e:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104a71:	50                   	push   %eax
80104a72:	e8 c6 cf ff ff       	call   80101a3d <namecmp>
80104a77:	83 c4 10             	add    $0x10,%esp
80104a7a:	85 c0                	test   %eax,%eax
80104a7c:	0f 84 e0 00 00 00    	je     80104b62 <sys_unlink+0x165>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104a82:	83 ec 04             	sub    $0x4,%esp
80104a85:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104a88:	50                   	push   %eax
80104a89:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104a8c:	50                   	push   %eax
80104a8d:	56                   	push   %esi
80104a8e:	e8 c3 cf ff ff       	call   80101a56 <dirlookup>
80104a93:	89 c3                	mov    %eax,%ebx
80104a95:	83 c4 10             	add    $0x10,%esp
80104a98:	85 c0                	test   %eax,%eax
80104a9a:	0f 84 c2 00 00 00    	je     80104b62 <sys_unlink+0x165>
  ilock(ip);
80104aa0:	83 ec 0c             	sub    $0xc,%esp
80104aa3:	50                   	push   %eax
80104aa4:	e8 5e cb ff ff       	call   80101607 <ilock>
  if(ip->nlink < 1)
80104aa9:	83 c4 10             	add    $0x10,%esp
80104aac:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104ab1:	0f 8e 83 00 00 00    	jle    80104b3a <sys_unlink+0x13d>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104ab7:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104abc:	0f 84 85 00 00 00    	je     80104b47 <sys_unlink+0x14a>
  memset(&de, 0, sizeof(de));
80104ac2:	83 ec 04             	sub    $0x4,%esp
80104ac5:	6a 10                	push   $0x10
80104ac7:	6a 00                	push   $0x0
80104ac9:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104acc:	57                   	push   %edi
80104acd:	e8 87 f5 ff ff       	call   80104059 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104ad2:	6a 10                	push   $0x10
80104ad4:	ff 75 c0             	pushl  -0x40(%ebp)
80104ad7:	57                   	push   %edi
80104ad8:	56                   	push   %esi
80104ad9:	e8 30 ce ff ff       	call   8010190e <writei>
80104ade:	83 c4 20             	add    $0x20,%esp
80104ae1:	83 f8 10             	cmp    $0x10,%eax
80104ae4:	0f 85 90 00 00 00    	jne    80104b7a <sys_unlink+0x17d>
  if(ip->type == T_DIR){
80104aea:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104aef:	0f 84 92 00 00 00    	je     80104b87 <sys_unlink+0x18a>
  iunlockput(dp);
80104af5:	83 ec 0c             	sub    $0xc,%esp
80104af8:	56                   	push   %esi
80104af9:	e8 bc cc ff ff       	call   801017ba <iunlockput>
  ip->nlink--;
80104afe:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
80104b02:	83 e8 01             	sub    $0x1,%eax
80104b05:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104b09:	89 1c 24             	mov    %ebx,(%esp)
80104b0c:	e8 8d c9 ff ff       	call   8010149e <iupdate>
  iunlockput(ip);
80104b11:	89 1c 24             	mov    %ebx,(%esp)
80104b14:	e8 a1 cc ff ff       	call   801017ba <iunlockput>
  end_op();
80104b19:	e8 ec dd ff ff       	call   8010290a <end_op>
  return 0;
80104b1e:	83 c4 10             	add    $0x10,%esp
80104b21:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104b26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b29:	5b                   	pop    %ebx
80104b2a:	5e                   	pop    %esi
80104b2b:	5f                   	pop    %edi
80104b2c:	5d                   	pop    %ebp
80104b2d:	c3                   	ret    
    end_op();
80104b2e:	e8 d7 dd ff ff       	call   8010290a <end_op>
    return -1;
80104b33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b38:	eb ec                	jmp    80104b26 <sys_unlink+0x129>
    panic("unlink: nlink < 1");
80104b3a:	83 ec 0c             	sub    $0xc,%esp
80104b3d:	68 1c 72 10 80       	push   $0x8010721c
80104b42:	e8 15 b8 ff ff       	call   8010035c <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104b47:	89 d8                	mov    %ebx,%eax
80104b49:	e8 57 f9 ff ff       	call   801044a5 <isdirempty>
80104b4e:	85 c0                	test   %eax,%eax
80104b50:	0f 85 6c ff ff ff    	jne    80104ac2 <sys_unlink+0xc5>
    iunlockput(ip);
80104b56:	83 ec 0c             	sub    $0xc,%esp
80104b59:	53                   	push   %ebx
80104b5a:	e8 5b cc ff ff       	call   801017ba <iunlockput>
    goto bad;
80104b5f:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80104b62:	83 ec 0c             	sub    $0xc,%esp
80104b65:	56                   	push   %esi
80104b66:	e8 4f cc ff ff       	call   801017ba <iunlockput>
  end_op();
80104b6b:	e8 9a dd ff ff       	call   8010290a <end_op>
  return -1;
80104b70:	83 c4 10             	add    $0x10,%esp
80104b73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b78:	eb ac                	jmp    80104b26 <sys_unlink+0x129>
    panic("unlink: writei");
80104b7a:	83 ec 0c             	sub    $0xc,%esp
80104b7d:	68 2e 72 10 80       	push   $0x8010722e
80104b82:	e8 d5 b7 ff ff       	call   8010035c <panic>
    dp->nlink--;
80104b87:	0f b7 46 56          	movzwl 0x56(%esi),%eax
80104b8b:	83 e8 01             	sub    $0x1,%eax
80104b8e:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
80104b92:	83 ec 0c             	sub    $0xc,%esp
80104b95:	56                   	push   %esi
80104b96:	e8 03 c9 ff ff       	call   8010149e <iupdate>
80104b9b:	83 c4 10             	add    $0x10,%esp
80104b9e:	e9 52 ff ff ff       	jmp    80104af5 <sys_unlink+0xf8>
    return -1;
80104ba3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ba8:	e9 79 ff ff ff       	jmp    80104b26 <sys_unlink+0x129>

80104bad <sys_open>:

int
sys_open(void)
{
80104bad:	f3 0f 1e fb          	endbr32 
80104bb1:	55                   	push   %ebp
80104bb2:	89 e5                	mov    %esp,%ebp
80104bb4:	57                   	push   %edi
80104bb5:	56                   	push   %esi
80104bb6:	53                   	push   %ebx
80104bb7:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104bba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104bbd:	50                   	push   %eax
80104bbe:	6a 00                	push   $0x0
80104bc0:	e8 a2 f7 ff ff       	call   80104367 <argstr>
80104bc5:	83 c4 10             	add    $0x10,%esp
80104bc8:	85 c0                	test   %eax,%eax
80104bca:	0f 88 a0 00 00 00    	js     80104c70 <sys_open+0xc3>
80104bd0:	83 ec 08             	sub    $0x8,%esp
80104bd3:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104bd6:	50                   	push   %eax
80104bd7:	6a 01                	push   $0x1
80104bd9:	e8 f1 f6 ff ff       	call   801042cf <argint>
80104bde:	83 c4 10             	add    $0x10,%esp
80104be1:	85 c0                	test   %eax,%eax
80104be3:	0f 88 87 00 00 00    	js     80104c70 <sys_open+0xc3>
    return -1;

  begin_op();
80104be9:	e8 9e dc ff ff       	call   8010288c <begin_op>

  if(omode & O_CREATE){
80104bee:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
80104bf2:	0f 84 8b 00 00 00    	je     80104c83 <sys_open+0xd6>
    ip = create(path, T_FILE, 0, 0);
80104bf8:	83 ec 0c             	sub    $0xc,%esp
80104bfb:	6a 00                	push   $0x0
80104bfd:	b9 00 00 00 00       	mov    $0x0,%ecx
80104c02:	ba 02 00 00 00       	mov    $0x2,%edx
80104c07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104c0a:	e8 ed f8 ff ff       	call   801044fc <create>
80104c0f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104c11:	83 c4 10             	add    $0x10,%esp
80104c14:	85 c0                	test   %eax,%eax
80104c16:	74 5f                	je     80104c77 <sys_open+0xca>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104c18:	e8 69 c0 ff ff       	call   80100c86 <filealloc>
80104c1d:	89 c3                	mov    %eax,%ebx
80104c1f:	85 c0                	test   %eax,%eax
80104c21:	0f 84 b5 00 00 00    	je     80104cdc <sys_open+0x12f>
80104c27:	e8 42 f8 ff ff       	call   8010446e <fdalloc>
80104c2c:	89 c7                	mov    %eax,%edi
80104c2e:	85 c0                	test   %eax,%eax
80104c30:	0f 88 a6 00 00 00    	js     80104cdc <sys_open+0x12f>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104c36:	83 ec 0c             	sub    $0xc,%esp
80104c39:	56                   	push   %esi
80104c3a:	e8 8e ca ff ff       	call   801016cd <iunlock>
  end_op();
80104c3f:	e8 c6 dc ff ff       	call   8010290a <end_op>

  f->type = FD_INODE;
80104c44:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
80104c4a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104c4d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104c54:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c57:	83 c4 10             	add    $0x10,%esp
80104c5a:	a8 01                	test   $0x1,%al
80104c5c:	0f 94 43 08          	sete   0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104c60:	a8 03                	test   $0x3,%al
80104c62:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80104c66:	89 f8                	mov    %edi,%eax
80104c68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c6b:	5b                   	pop    %ebx
80104c6c:	5e                   	pop    %esi
80104c6d:	5f                   	pop    %edi
80104c6e:	5d                   	pop    %ebp
80104c6f:	c3                   	ret    
    return -1;
80104c70:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104c75:	eb ef                	jmp    80104c66 <sys_open+0xb9>
      end_op();
80104c77:	e8 8e dc ff ff       	call   8010290a <end_op>
      return -1;
80104c7c:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104c81:	eb e3                	jmp    80104c66 <sys_open+0xb9>
    if((ip = namei(path)) == 0){
80104c83:	83 ec 0c             	sub    $0xc,%esp
80104c86:	ff 75 e4             	pushl  -0x1c(%ebp)
80104c89:	e8 fe cf ff ff       	call   80101c8c <namei>
80104c8e:	89 c6                	mov    %eax,%esi
80104c90:	83 c4 10             	add    $0x10,%esp
80104c93:	85 c0                	test   %eax,%eax
80104c95:	74 39                	je     80104cd0 <sys_open+0x123>
    ilock(ip);
80104c97:	83 ec 0c             	sub    $0xc,%esp
80104c9a:	50                   	push   %eax
80104c9b:	e8 67 c9 ff ff       	call   80101607 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104ca0:	83 c4 10             	add    $0x10,%esp
80104ca3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104ca8:	0f 85 6a ff ff ff    	jne    80104c18 <sys_open+0x6b>
80104cae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104cb2:	0f 84 60 ff ff ff    	je     80104c18 <sys_open+0x6b>
      iunlockput(ip);
80104cb8:	83 ec 0c             	sub    $0xc,%esp
80104cbb:	56                   	push   %esi
80104cbc:	e8 f9 ca ff ff       	call   801017ba <iunlockput>
      end_op();
80104cc1:	e8 44 dc ff ff       	call   8010290a <end_op>
      return -1;
80104cc6:	83 c4 10             	add    $0x10,%esp
80104cc9:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104cce:	eb 96                	jmp    80104c66 <sys_open+0xb9>
      end_op();
80104cd0:	e8 35 dc ff ff       	call   8010290a <end_op>
      return -1;
80104cd5:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104cda:	eb 8a                	jmp    80104c66 <sys_open+0xb9>
    if(f)
80104cdc:	85 db                	test   %ebx,%ebx
80104cde:	74 0c                	je     80104cec <sys_open+0x13f>
      fileclose(f);
80104ce0:	83 ec 0c             	sub    $0xc,%esp
80104ce3:	53                   	push   %ebx
80104ce4:	e8 4b c0 ff ff       	call   80100d34 <fileclose>
80104ce9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104cec:	83 ec 0c             	sub    $0xc,%esp
80104cef:	56                   	push   %esi
80104cf0:	e8 c5 ca ff ff       	call   801017ba <iunlockput>
    end_op();
80104cf5:	e8 10 dc ff ff       	call   8010290a <end_op>
    return -1;
80104cfa:	83 c4 10             	add    $0x10,%esp
80104cfd:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104d02:	e9 5f ff ff ff       	jmp    80104c66 <sys_open+0xb9>

80104d07 <sys_mkdir>:

int
sys_mkdir(void)
{
80104d07:	f3 0f 1e fb          	endbr32 
80104d0b:	55                   	push   %ebp
80104d0c:	89 e5                	mov    %esp,%ebp
80104d0e:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104d11:	e8 76 db ff ff       	call   8010288c <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104d16:	83 ec 08             	sub    $0x8,%esp
80104d19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d1c:	50                   	push   %eax
80104d1d:	6a 00                	push   $0x0
80104d1f:	e8 43 f6 ff ff       	call   80104367 <argstr>
80104d24:	83 c4 10             	add    $0x10,%esp
80104d27:	85 c0                	test   %eax,%eax
80104d29:	78 36                	js     80104d61 <sys_mkdir+0x5a>
80104d2b:	83 ec 0c             	sub    $0xc,%esp
80104d2e:	6a 00                	push   $0x0
80104d30:	b9 00 00 00 00       	mov    $0x0,%ecx
80104d35:	ba 01 00 00 00       	mov    $0x1,%edx
80104d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d3d:	e8 ba f7 ff ff       	call   801044fc <create>
80104d42:	83 c4 10             	add    $0x10,%esp
80104d45:	85 c0                	test   %eax,%eax
80104d47:	74 18                	je     80104d61 <sys_mkdir+0x5a>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104d49:	83 ec 0c             	sub    $0xc,%esp
80104d4c:	50                   	push   %eax
80104d4d:	e8 68 ca ff ff       	call   801017ba <iunlockput>
  end_op();
80104d52:	e8 b3 db ff ff       	call   8010290a <end_op>
  return 0;
80104d57:	83 c4 10             	add    $0x10,%esp
80104d5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104d5f:	c9                   	leave  
80104d60:	c3                   	ret    
    end_op();
80104d61:	e8 a4 db ff ff       	call   8010290a <end_op>
    return -1;
80104d66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d6b:	eb f2                	jmp    80104d5f <sys_mkdir+0x58>

80104d6d <sys_mknod>:

int
sys_mknod(void)
{
80104d6d:	f3 0f 1e fb          	endbr32 
80104d71:	55                   	push   %ebp
80104d72:	89 e5                	mov    %esp,%ebp
80104d74:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104d77:	e8 10 db ff ff       	call   8010288c <begin_op>
  if((argstr(0, &path)) < 0 ||
80104d7c:	83 ec 08             	sub    $0x8,%esp
80104d7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d82:	50                   	push   %eax
80104d83:	6a 00                	push   $0x0
80104d85:	e8 dd f5 ff ff       	call   80104367 <argstr>
80104d8a:	83 c4 10             	add    $0x10,%esp
80104d8d:	85 c0                	test   %eax,%eax
80104d8f:	78 62                	js     80104df3 <sys_mknod+0x86>
     argint(1, &major) < 0 ||
80104d91:	83 ec 08             	sub    $0x8,%esp
80104d94:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d97:	50                   	push   %eax
80104d98:	6a 01                	push   $0x1
80104d9a:	e8 30 f5 ff ff       	call   801042cf <argint>
  if((argstr(0, &path)) < 0 ||
80104d9f:	83 c4 10             	add    $0x10,%esp
80104da2:	85 c0                	test   %eax,%eax
80104da4:	78 4d                	js     80104df3 <sys_mknod+0x86>
     argint(2, &minor) < 0 ||
80104da6:	83 ec 08             	sub    $0x8,%esp
80104da9:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104dac:	50                   	push   %eax
80104dad:	6a 02                	push   $0x2
80104daf:	e8 1b f5 ff ff       	call   801042cf <argint>
     argint(1, &major) < 0 ||
80104db4:	83 c4 10             	add    $0x10,%esp
80104db7:	85 c0                	test   %eax,%eax
80104db9:	78 38                	js     80104df3 <sys_mknod+0x86>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104dbb:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104dbf:	83 ec 0c             	sub    $0xc,%esp
80104dc2:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
80104dc6:	50                   	push   %eax
80104dc7:	ba 03 00 00 00       	mov    $0x3,%edx
80104dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dcf:	e8 28 f7 ff ff       	call   801044fc <create>
     argint(2, &minor) < 0 ||
80104dd4:	83 c4 10             	add    $0x10,%esp
80104dd7:	85 c0                	test   %eax,%eax
80104dd9:	74 18                	je     80104df3 <sys_mknod+0x86>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104ddb:	83 ec 0c             	sub    $0xc,%esp
80104dde:	50                   	push   %eax
80104ddf:	e8 d6 c9 ff ff       	call   801017ba <iunlockput>
  end_op();
80104de4:	e8 21 db ff ff       	call   8010290a <end_op>
  return 0;
80104de9:	83 c4 10             	add    $0x10,%esp
80104dec:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104df1:	c9                   	leave  
80104df2:	c3                   	ret    
    end_op();
80104df3:	e8 12 db ff ff       	call   8010290a <end_op>
    return -1;
80104df8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dfd:	eb f2                	jmp    80104df1 <sys_mknod+0x84>

80104dff <sys_chdir>:

int
sys_chdir(void)
{
80104dff:	f3 0f 1e fb          	endbr32 
80104e03:	55                   	push   %ebp
80104e04:	89 e5                	mov    %esp,%ebp
80104e06:	56                   	push   %esi
80104e07:	53                   	push   %ebx
80104e08:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104e0b:	e8 2b e5 ff ff       	call   8010333b <myproc>
80104e10:	89 c6                	mov    %eax,%esi

  begin_op();
80104e12:	e8 75 da ff ff       	call   8010288c <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104e17:	83 ec 08             	sub    $0x8,%esp
80104e1a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e1d:	50                   	push   %eax
80104e1e:	6a 00                	push   $0x0
80104e20:	e8 42 f5 ff ff       	call   80104367 <argstr>
80104e25:	83 c4 10             	add    $0x10,%esp
80104e28:	85 c0                	test   %eax,%eax
80104e2a:	78 52                	js     80104e7e <sys_chdir+0x7f>
80104e2c:	83 ec 0c             	sub    $0xc,%esp
80104e2f:	ff 75 f4             	pushl  -0xc(%ebp)
80104e32:	e8 55 ce ff ff       	call   80101c8c <namei>
80104e37:	89 c3                	mov    %eax,%ebx
80104e39:	83 c4 10             	add    $0x10,%esp
80104e3c:	85 c0                	test   %eax,%eax
80104e3e:	74 3e                	je     80104e7e <sys_chdir+0x7f>
    end_op();
    return -1;
  }
  ilock(ip);
80104e40:	83 ec 0c             	sub    $0xc,%esp
80104e43:	50                   	push   %eax
80104e44:	e8 be c7 ff ff       	call   80101607 <ilock>
  if(ip->type != T_DIR){
80104e49:	83 c4 10             	add    $0x10,%esp
80104e4c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e51:	75 37                	jne    80104e8a <sys_chdir+0x8b>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104e53:	83 ec 0c             	sub    $0xc,%esp
80104e56:	53                   	push   %ebx
80104e57:	e8 71 c8 ff ff       	call   801016cd <iunlock>
  iput(curproc->cwd);
80104e5c:	83 c4 04             	add    $0x4,%esp
80104e5f:	ff 76 68             	pushl  0x68(%esi)
80104e62:	e8 af c8 ff ff       	call   80101716 <iput>
  end_op();
80104e67:	e8 9e da ff ff       	call   8010290a <end_op>
  curproc->cwd = ip;
80104e6c:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104e6f:	83 c4 10             	add    $0x10,%esp
80104e72:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e77:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e7a:	5b                   	pop    %ebx
80104e7b:	5e                   	pop    %esi
80104e7c:	5d                   	pop    %ebp
80104e7d:	c3                   	ret    
    end_op();
80104e7e:	e8 87 da ff ff       	call   8010290a <end_op>
    return -1;
80104e83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e88:	eb ed                	jmp    80104e77 <sys_chdir+0x78>
    iunlockput(ip);
80104e8a:	83 ec 0c             	sub    $0xc,%esp
80104e8d:	53                   	push   %ebx
80104e8e:	e8 27 c9 ff ff       	call   801017ba <iunlockput>
    end_op();
80104e93:	e8 72 da ff ff       	call   8010290a <end_op>
    return -1;
80104e98:	83 c4 10             	add    $0x10,%esp
80104e9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ea0:	eb d5                	jmp    80104e77 <sys_chdir+0x78>

80104ea2 <sys_exec>:

int
sys_exec(void)
{
80104ea2:	f3 0f 1e fb          	endbr32 
80104ea6:	55                   	push   %ebp
80104ea7:	89 e5                	mov    %esp,%ebp
80104ea9:	53                   	push   %ebx
80104eaa:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104eb0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104eb3:	50                   	push   %eax
80104eb4:	6a 00                	push   $0x0
80104eb6:	e8 ac f4 ff ff       	call   80104367 <argstr>
80104ebb:	83 c4 10             	add    $0x10,%esp
80104ebe:	85 c0                	test   %eax,%eax
80104ec0:	78 38                	js     80104efa <sys_exec+0x58>
80104ec2:	83 ec 08             	sub    $0x8,%esp
80104ec5:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80104ecb:	50                   	push   %eax
80104ecc:	6a 01                	push   $0x1
80104ece:	e8 fc f3 ff ff       	call   801042cf <argint>
80104ed3:	83 c4 10             	add    $0x10,%esp
80104ed6:	85 c0                	test   %eax,%eax
80104ed8:	78 20                	js     80104efa <sys_exec+0x58>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104eda:	83 ec 04             	sub    $0x4,%esp
80104edd:	68 80 00 00 00       	push   $0x80
80104ee2:	6a 00                	push   $0x0
80104ee4:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104eea:	50                   	push   %eax
80104eeb:	e8 69 f1 ff ff       	call   80104059 <memset>
80104ef0:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80104ef3:	bb 00 00 00 00       	mov    $0x0,%ebx
80104ef8:	eb 2c                	jmp    80104f26 <sys_exec+0x84>
    return -1;
80104efa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eff:	eb 78                	jmp    80104f79 <sys_exec+0xd7>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80104f01:	c7 84 9d 74 ff ff ff 	movl   $0x0,-0x8c(%ebp,%ebx,4)
80104f08:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80104f0c:	83 ec 08             	sub    $0x8,%esp
80104f0f:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104f15:	50                   	push   %eax
80104f16:	ff 75 f4             	pushl  -0xc(%ebp)
80104f19:	e8 1d ba ff ff       	call   8010093b <exec>
80104f1e:	83 c4 10             	add    $0x10,%esp
80104f21:	eb 56                	jmp    80104f79 <sys_exec+0xd7>
  for(i=0;; i++){
80104f23:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80104f26:	83 fb 1f             	cmp    $0x1f,%ebx
80104f29:	77 49                	ja     80104f74 <sys_exec+0xd2>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104f2b:	83 ec 08             	sub    $0x8,%esp
80104f2e:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80104f34:	50                   	push   %eax
80104f35:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
80104f3b:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80104f3e:	50                   	push   %eax
80104f3f:	e8 07 f3 ff ff       	call   8010424b <fetchint>
80104f44:	83 c4 10             	add    $0x10,%esp
80104f47:	85 c0                	test   %eax,%eax
80104f49:	78 33                	js     80104f7e <sys_exec+0xdc>
    if(uarg == 0){
80104f4b:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80104f51:	85 c0                	test   %eax,%eax
80104f53:	74 ac                	je     80104f01 <sys_exec+0x5f>
    if(fetchstr(uarg, &argv[i]) < 0)
80104f55:	83 ec 08             	sub    $0x8,%esp
80104f58:	8d 94 9d 74 ff ff ff 	lea    -0x8c(%ebp,%ebx,4),%edx
80104f5f:	52                   	push   %edx
80104f60:	50                   	push   %eax
80104f61:	e8 25 f3 ff ff       	call   8010428b <fetchstr>
80104f66:	83 c4 10             	add    $0x10,%esp
80104f69:	85 c0                	test   %eax,%eax
80104f6b:	79 b6                	jns    80104f23 <sys_exec+0x81>
      return -1;
80104f6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f72:	eb 05                	jmp    80104f79 <sys_exec+0xd7>
      return -1;
80104f74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f7c:	c9                   	leave  
80104f7d:	c3                   	ret    
      return -1;
80104f7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f83:	eb f4                	jmp    80104f79 <sys_exec+0xd7>

80104f85 <sys_pipe>:

int
sys_pipe(void)
{
80104f85:	f3 0f 1e fb          	endbr32 
80104f89:	55                   	push   %ebp
80104f8a:	89 e5                	mov    %esp,%ebp
80104f8c:	53                   	push   %ebx
80104f8d:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104f90:	6a 08                	push   $0x8
80104f92:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f95:	50                   	push   %eax
80104f96:	6a 00                	push   $0x0
80104f98:	e8 5e f3 ff ff       	call   801042fb <argptr>
80104f9d:	83 c4 10             	add    $0x10,%esp
80104fa0:	85 c0                	test   %eax,%eax
80104fa2:	78 79                	js     8010501d <sys_pipe+0x98>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104fa4:	83 ec 08             	sub    $0x8,%esp
80104fa7:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104faa:	50                   	push   %eax
80104fab:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fae:	50                   	push   %eax
80104faf:	e8 7d de ff ff       	call   80102e31 <pipealloc>
80104fb4:	83 c4 10             	add    $0x10,%esp
80104fb7:	85 c0                	test   %eax,%eax
80104fb9:	78 69                	js     80105024 <sys_pipe+0x9f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104fbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fbe:	e8 ab f4 ff ff       	call   8010446e <fdalloc>
80104fc3:	89 c3                	mov    %eax,%ebx
80104fc5:	85 c0                	test   %eax,%eax
80104fc7:	78 21                	js     80104fea <sys_pipe+0x65>
80104fc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104fcc:	e8 9d f4 ff ff       	call   8010446e <fdalloc>
80104fd1:	85 c0                	test   %eax,%eax
80104fd3:	78 15                	js     80104fea <sys_pipe+0x65>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104fd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fd8:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104fda:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fdd:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104fe0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104fe5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fe8:	c9                   	leave  
80104fe9:	c3                   	ret    
    if(fd0 >= 0)
80104fea:	85 db                	test   %ebx,%ebx
80104fec:	79 20                	jns    8010500e <sys_pipe+0x89>
    fileclose(rf);
80104fee:	83 ec 0c             	sub    $0xc,%esp
80104ff1:	ff 75 f0             	pushl  -0x10(%ebp)
80104ff4:	e8 3b bd ff ff       	call   80100d34 <fileclose>
    fileclose(wf);
80104ff9:	83 c4 04             	add    $0x4,%esp
80104ffc:	ff 75 ec             	pushl  -0x14(%ebp)
80104fff:	e8 30 bd ff ff       	call   80100d34 <fileclose>
    return -1;
80105004:	83 c4 10             	add    $0x10,%esp
80105007:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010500c:	eb d7                	jmp    80104fe5 <sys_pipe+0x60>
      myproc()->ofile[fd0] = 0;
8010500e:	e8 28 e3 ff ff       	call   8010333b <myproc>
80105013:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
8010501a:	00 
8010501b:	eb d1                	jmp    80104fee <sys_pipe+0x69>
    return -1;
8010501d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105022:	eb c1                	jmp    80104fe5 <sys_pipe+0x60>
    return -1;
80105024:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105029:	eb ba                	jmp    80104fe5 <sys_pipe+0x60>

8010502b <sys_fork>:
#include "pdx-kernel.h"
#endif // PDX_XV6

int
sys_fork(void)
{
8010502b:	f3 0f 1e fb          	endbr32 
8010502f:	55                   	push   %ebp
80105030:	89 e5                	mov    %esp,%ebp
80105032:	83 ec 08             	sub    $0x8,%esp
  return fork();
80105035:	e8 84 e4 ff ff       	call   801034be <fork>
}
8010503a:	c9                   	leave  
8010503b:	c3                   	ret    

8010503c <sys_exit>:

int
sys_exit(void)
{
8010503c:	f3 0f 1e fb          	endbr32 
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	83 ec 08             	sub    $0x8,%esp
  exit();
80105046:	e8 ca e6 ff ff       	call   80103715 <exit>
  return 0;  // not reached
}
8010504b:	b8 00 00 00 00       	mov    $0x0,%eax
80105050:	c9                   	leave  
80105051:	c3                   	ret    

80105052 <sys_wait>:

int
sys_wait(void)
{
80105052:	f3 0f 1e fb          	endbr32 
80105056:	55                   	push   %ebp
80105057:	89 e5                	mov    %esp,%ebp
80105059:	83 ec 08             	sub    $0x8,%esp
  return wait();
8010505c:	e8 5a e8 ff ff       	call   801038bb <wait>
}
80105061:	c9                   	leave  
80105062:	c3                   	ret    

80105063 <sys_kill>:

int
sys_kill(void)
{
80105063:	f3 0f 1e fb          	endbr32 
80105067:	55                   	push   %ebp
80105068:	89 e5                	mov    %esp,%ebp
8010506a:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010506d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105070:	50                   	push   %eax
80105071:	6a 00                	push   $0x0
80105073:	e8 57 f2 ff ff       	call   801042cf <argint>
80105078:	83 c4 10             	add    $0x10,%esp
8010507b:	85 c0                	test   %eax,%eax
8010507d:	78 10                	js     8010508f <sys_kill+0x2c>
    return -1;
  return kill(pid);
8010507f:	83 ec 0c             	sub    $0xc,%esp
80105082:	ff 75 f4             	pushl  -0xc(%ebp)
80105085:	e8 39 e9 ff ff       	call   801039c3 <kill>
8010508a:	83 c4 10             	add    $0x10,%esp
}
8010508d:	c9                   	leave  
8010508e:	c3                   	ret    
    return -1;
8010508f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105094:	eb f7                	jmp    8010508d <sys_kill+0x2a>

80105096 <sys_getpid>:

int
sys_getpid(void)
{
80105096:	f3 0f 1e fb          	endbr32 
8010509a:	55                   	push   %ebp
8010509b:	89 e5                	mov    %esp,%ebp
8010509d:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801050a0:	e8 96 e2 ff ff       	call   8010333b <myproc>
801050a5:	8b 40 10             	mov    0x10(%eax),%eax
}
801050a8:	c9                   	leave  
801050a9:	c3                   	ret    

801050aa <sys_sbrk>:

int
sys_sbrk(void)
{
801050aa:	f3 0f 1e fb          	endbr32 
801050ae:	55                   	push   %ebp
801050af:	89 e5                	mov    %esp,%ebp
801050b1:	53                   	push   %ebx
801050b2:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801050b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050b8:	50                   	push   %eax
801050b9:	6a 00                	push   $0x0
801050bb:	e8 0f f2 ff ff       	call   801042cf <argint>
801050c0:	83 c4 10             	add    $0x10,%esp
801050c3:	85 c0                	test   %eax,%eax
801050c5:	78 20                	js     801050e7 <sys_sbrk+0x3d>
    return -1;
  addr = myproc()->sz;
801050c7:	e8 6f e2 ff ff       	call   8010333b <myproc>
801050cc:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801050ce:	83 ec 0c             	sub    $0xc,%esp
801050d1:	ff 75 f4             	pushl  -0xc(%ebp)
801050d4:	e8 76 e3 ff ff       	call   8010344f <growproc>
801050d9:	83 c4 10             	add    $0x10,%esp
801050dc:	85 c0                	test   %eax,%eax
801050de:	78 0e                	js     801050ee <sys_sbrk+0x44>
    return -1;
  return addr;
}
801050e0:	89 d8                	mov    %ebx,%eax
801050e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050e5:	c9                   	leave  
801050e6:	c3                   	ret    
    return -1;
801050e7:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801050ec:	eb f2                	jmp    801050e0 <sys_sbrk+0x36>
    return -1;
801050ee:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801050f3:	eb eb                	jmp    801050e0 <sys_sbrk+0x36>

801050f5 <sys_sleep>:

int
sys_sleep(void)
{
801050f5:	f3 0f 1e fb          	endbr32 
801050f9:	55                   	push   %ebp
801050fa:	89 e5                	mov    %esp,%ebp
801050fc:	53                   	push   %ebx
801050fd:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105100:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105103:	50                   	push   %eax
80105104:	6a 00                	push   $0x0
80105106:	e8 c4 f1 ff ff       	call   801042cf <argint>
8010510b:	83 c4 10             	add    $0x10,%esp
8010510e:	85 c0                	test   %eax,%eax
80105110:	78 3b                	js     8010514d <sys_sleep+0x58>
    return -1;
  ticks0 = ticks;
80105112:	8b 1d 80 76 11 80    	mov    0x80117680,%ebx
  while(ticks - ticks0 < n){
80105118:	a1 80 76 11 80       	mov    0x80117680,%eax
8010511d:	29 d8                	sub    %ebx,%eax
8010511f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105122:	73 1f                	jae    80105143 <sys_sleep+0x4e>
    if(myproc()->killed){
80105124:	e8 12 e2 ff ff       	call   8010333b <myproc>
80105129:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010512d:	75 25                	jne    80105154 <sys_sleep+0x5f>
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
8010512f:	83 ec 08             	sub    $0x8,%esp
80105132:	6a 00                	push   $0x0
80105134:	68 80 76 11 80       	push   $0x80117680
80105139:	e8 e9 e6 ff ff       	call   80103827 <sleep>
8010513e:	83 c4 10             	add    $0x10,%esp
80105141:	eb d5                	jmp    80105118 <sys_sleep+0x23>
  }
  return 0;
80105143:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105148:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010514b:	c9                   	leave  
8010514c:	c3                   	ret    
    return -1;
8010514d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105152:	eb f4                	jmp    80105148 <sys_sleep+0x53>
      return -1;
80105154:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105159:	eb ed                	jmp    80105148 <sys_sleep+0x53>

8010515b <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
8010515b:	f3 0f 1e fb          	endbr32 
  uint xticks;

  xticks = ticks;
  return xticks;
}
8010515f:	a1 80 76 11 80       	mov    0x80117680,%eax
80105164:	c3                   	ret    

80105165 <sys_halt>:

#ifdef PDX_XV6
// shutdown QEMU
int
sys_halt(void)
{
80105165:	f3 0f 1e fb          	endbr32 
80105169:	55                   	push   %ebp
8010516a:	89 e5                	mov    %esp,%ebp
8010516c:	83 ec 08             	sub    $0x8,%esp
  do_shutdown();  // never returns
8010516f:	e8 e5 b5 ff ff       	call   80100759 <do_shutdown>
  return 0;
}
80105174:	b8 00 00 00 00       	mov    $0x0,%eax
80105179:	c9                   	leave  
8010517a:	c3                   	ret    

8010517b <sys_cps>:
#endif // PDX_XV6

/* _________________My System Calls________________ */

int sys_cps(void) {
8010517b:	f3 0f 1e fb          	endbr32 
8010517f:	55                   	push   %ebp
80105180:	89 e5                	mov    %esp,%ebp
80105182:	83 ec 08             	sub    $0x8,%esp
  return cps();
80105185:	e8 b3 e8 ff ff       	call   80103a3d <cps>
}
8010518a:	c9                   	leave  
8010518b:	c3                   	ret    

8010518c <sys_getppid>:

int sys_getppid(void) {
8010518c:	f3 0f 1e fb          	endbr32 
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	83 ec 08             	sub    $0x8,%esp
  return getppid();
80105196:	e8 4e e9 ff ff       	call   80103ae9 <getppid>
}
8010519b:	c9                   	leave  
8010519c:	c3                   	ret    

8010519d <sys_getsz>:

int sys_getsz(void) {
8010519d:	f3 0f 1e fb          	endbr32 
801051a1:	55                   	push   %ebp
801051a2:	89 e5                	mov    %esp,%ebp
801051a4:	83 ec 08             	sub    $0x8,%esp
  return getsz();
801051a7:	e8 54 e9 ff ff       	call   80103b00 <getsz>
}
801051ac:	c9                   	leave  
801051ad:	c3                   	ret    

801051ae <sys_chpr>:

int sys_chpr(void) {
801051ae:	f3 0f 1e fb          	endbr32 
801051b2:	55                   	push   %ebp
801051b3:	89 e5                	mov    %esp,%ebp
801051b5:	83 ec 20             	sub    $0x20,%esp
  int pid, priority;
  if (argint(0, &pid) < 0)
801051b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051bb:	50                   	push   %eax
801051bc:	6a 00                	push   $0x0
801051be:	e8 0c f1 ff ff       	call   801042cf <argint>
801051c3:	83 c4 10             	add    $0x10,%esp
801051c6:	85 c0                	test   %eax,%eax
801051c8:	78 28                	js     801051f2 <sys_chpr+0x44>
    return -1;
  if (argint(1, &priority) <0 )
801051ca:	83 ec 08             	sub    $0x8,%esp
801051cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051d0:	50                   	push   %eax
801051d1:	6a 01                	push   $0x1
801051d3:	e8 f7 f0 ff ff       	call   801042cf <argint>
801051d8:	83 c4 10             	add    $0x10,%esp
801051db:	85 c0                	test   %eax,%eax
801051dd:	78 1a                	js     801051f9 <sys_chpr+0x4b>
    return -1;
  return chpr(pid, priority);
801051df:	83 ec 08             	sub    $0x8,%esp
801051e2:	ff 75 f0             	pushl  -0x10(%ebp)
801051e5:	ff 75 f4             	pushl  -0xc(%ebp)
801051e8:	e8 26 e9 ff ff       	call   80103b13 <chpr>
801051ed:	83 c4 10             	add    $0x10,%esp
}
801051f0:	c9                   	leave  
801051f1:	c3                   	ret    
    return -1;
801051f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f7:	eb f7                	jmp    801051f0 <sys_chpr+0x42>
    return -1;
801051f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051fe:	eb f0                	jmp    801051f0 <sys_chpr+0x42>

80105200 <sys_getcount>:

int sys_getcount(void) {
80105200:	f3 0f 1e fb          	endbr32 
80105204:	55                   	push   %ebp
80105205:	89 e5                	mov    %esp,%ebp
80105207:	83 ec 20             	sub    $0x20,%esp
  int procno;
  if (argint(0, &procno) < 0)
8010520a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010520d:	50                   	push   %eax
8010520e:	6a 00                	push   $0x0
80105210:	e8 ba f0 ff ff       	call   801042cf <argint>
80105215:	83 c4 10             	add    $0x10,%esp
80105218:	85 c0                	test   %eax,%eax
8010521a:	78 10                	js     8010522c <sys_getcount+0x2c>
    return -1;
  return getcount(procno);
8010521c:	83 ec 0c             	sub    $0xc,%esp
8010521f:	ff 75 f4             	pushl  -0xc(%ebp)
80105222:	e8 39 e9 ff ff       	call   80103b60 <getcount>
80105227:	83 c4 10             	add    $0x10,%esp
}
8010522a:	c9                   	leave  
8010522b:	c3                   	ret    
    return -1;
8010522c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105231:	eb f7                	jmp    8010522a <sys_getcount+0x2a>

80105233 <sys_time>:

int sys_time(void)
{
80105233:	f3 0f 1e fb          	endbr32 
80105237:	55                   	push   %ebp
80105238:	89 e5                	mov    %esp,%ebp
8010523a:	83 ec 1c             	sub    $0x1c,%esp
  int *waitt;
  int *burstt;
  
  if(argptr(0, (char**)&waitt, sizeof(int)) < 0)
8010523d:	6a 04                	push   $0x4
8010523f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105242:	50                   	push   %eax
80105243:	6a 00                	push   $0x0
80105245:	e8 b1 f0 ff ff       	call   801042fb <argptr>
8010524a:	83 c4 10             	add    $0x10,%esp
8010524d:	85 c0                	test   %eax,%eax
8010524f:	78 2a                	js     8010527b <sys_time+0x48>
    return 12;

  if(argptr(1, (char**)&burstt, sizeof(int)) < 0)
80105251:	83 ec 04             	sub    $0x4,%esp
80105254:	6a 04                	push   $0x4
80105256:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105259:	50                   	push   %eax
8010525a:	6a 01                	push   $0x1
8010525c:	e8 9a f0 ff ff       	call   801042fb <argptr>
80105261:	83 c4 10             	add    $0x10,%esp
80105264:	85 c0                	test   %eax,%eax
80105266:	78 1a                	js     80105282 <sys_time+0x4f>
    return 13;

  return time(waitt,burstt);
80105268:	83 ec 08             	sub    $0x8,%esp
8010526b:	ff 75 f0             	pushl  -0x10(%ebp)
8010526e:	ff 75 f4             	pushl  -0xc(%ebp)
80105271:	e8 02 e9 ff ff       	call   80103b78 <time>
80105276:	83 c4 10             	add    $0x10,%esp
}
80105279:	c9                   	leave  
8010527a:	c3                   	ret    
    return 12;
8010527b:	b8 0c 00 00 00       	mov    $0xc,%eax
80105280:	eb f7                	jmp    80105279 <sys_time+0x46>
    return 13;
80105282:	b8 0d 00 00 00       	mov    $0xd,%eax
80105287:	eb f0                	jmp    80105279 <sys_time+0x46>

80105289 <sys_utctime>:

int sys_utctime(void)
{
80105289:	f3 0f 1e fb          	endbr32 
8010528d:	55                   	push   %ebp
8010528e:	89 e5                	mov    %esp,%ebp
80105290:	83 ec 1c             	sub    $0x1c,%esp
  struct rtcdate *r;
  if(argptr(0, (void*)&r, sizeof(r)) < 0)
80105293:	6a 04                	push   $0x4
80105295:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105298:	50                   	push   %eax
80105299:	6a 00                	push   $0x0
8010529b:	e8 5b f0 ff ff       	call   801042fb <argptr>
801052a0:	83 c4 10             	add    $0x10,%esp
801052a3:	85 c0                	test   %eax,%eax
801052a5:	78 10                	js     801052b7 <sys_utctime+0x2e>
   return -1;
  return utctime(r);
801052a7:	83 ec 0c             	sub    $0xc,%esp
801052aa:	ff 75 f4             	pushl  -0xc(%ebp)
801052ad:	e8 d0 e9 ff ff       	call   80103c82 <utctime>
801052b2:	83 c4 10             	add    $0x10,%esp
 }
801052b5:	c9                   	leave  
801052b6:	c3                   	ret    
   return -1;
801052b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052bc:	eb f7                	jmp    801052b5 <sys_utctime+0x2c>

801052be <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801052be:	1e                   	push   %ds
  pushl %es
801052bf:	06                   	push   %es
  pushl %fs
801052c0:	0f a0                	push   %fs
  pushl %gs
801052c2:	0f a8                	push   %gs
  pushal
801052c4:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801052c5:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801052c9:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801052cb:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801052cd:	54                   	push   %esp
  call trap
801052ce:	e8 cf 00 00 00       	call   801053a2 <trap>
  addl $4, %esp
801052d3:	83 c4 04             	add    $0x4,%esp

801052d6 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801052d6:	61                   	popa   
  popl %gs
801052d7:	0f a9                	pop    %gs
  popl %fs
801052d9:	0f a1                	pop    %fs
  popl %es
801052db:	07                   	pop    %es
  popl %ds
801052dc:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801052dd:	83 c4 08             	add    $0x8,%esp
  iret
801052e0:	cf                   	iret   

801052e1 <tvinit>:
uint ticks;
#endif // PDX_XV6

void
tvinit(void)
{
801052e1:	f3 0f 1e fb          	endbr32 
  int i;

  for(i = 0; i < 256; i++)
801052e5:	b8 00 00 00 00       	mov    $0x0,%eax
801052ea:	3d ff 00 00 00       	cmp    $0xff,%eax
801052ef:	7f 4c                	jg     8010533d <tvinit+0x5c>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801052f1:	8b 0c 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%ecx
801052f8:	66 89 0c c5 80 6e 11 	mov    %cx,-0x7fee9180(,%eax,8)
801052ff:	80 
80105300:	66 c7 04 c5 82 6e 11 	movw   $0x8,-0x7fee917e(,%eax,8)
80105307:	80 08 00 
8010530a:	c6 04 c5 84 6e 11 80 	movb   $0x0,-0x7fee917c(,%eax,8)
80105311:	00 
80105312:	0f b6 14 c5 85 6e 11 	movzbl -0x7fee917b(,%eax,8),%edx
80105319:	80 
8010531a:	83 e2 f0             	and    $0xfffffff0,%edx
8010531d:	83 ca 0e             	or     $0xe,%edx
80105320:	83 e2 8f             	and    $0xffffff8f,%edx
80105323:	83 ca 80             	or     $0xffffff80,%edx
80105326:	88 14 c5 85 6e 11 80 	mov    %dl,-0x7fee917b(,%eax,8)
8010532d:	c1 e9 10             	shr    $0x10,%ecx
80105330:	66 89 0c c5 86 6e 11 	mov    %cx,-0x7fee917a(,%eax,8)
80105337:	80 
  for(i = 0; i < 256; i++)
80105338:	83 c0 01             	add    $0x1,%eax
8010533b:	eb ad                	jmp    801052ea <tvinit+0x9>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010533d:	8b 15 08 a1 10 80    	mov    0x8010a108,%edx
80105343:	66 89 15 80 70 11 80 	mov    %dx,0x80117080
8010534a:	66 c7 05 82 70 11 80 	movw   $0x8,0x80117082
80105351:	08 00 
80105353:	c6 05 84 70 11 80 00 	movb   $0x0,0x80117084
8010535a:	0f b6 05 85 70 11 80 	movzbl 0x80117085,%eax
80105361:	83 c8 0f             	or     $0xf,%eax
80105364:	83 e0 ef             	and    $0xffffffef,%eax
80105367:	83 c8 e0             	or     $0xffffffe0,%eax
8010536a:	a2 85 70 11 80       	mov    %al,0x80117085
8010536f:	c1 ea 10             	shr    $0x10,%edx
80105372:	66 89 15 86 70 11 80 	mov    %dx,0x80117086

#ifndef PDX_XV6
  initlock(&tickslock, "time");
#endif // PDX_XV6
}
80105379:	c3                   	ret    

8010537a <idtinit>:

void
idtinit(void)
{
8010537a:	f3 0f 1e fb          	endbr32 
8010537e:	55                   	push   %ebp
8010537f:	89 e5                	mov    %esp,%ebp
80105381:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80105384:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
8010538a:	b8 80 6e 11 80       	mov    $0x80116e80,%eax
8010538f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105393:	c1 e8 10             	shr    $0x10,%eax
80105396:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010539a:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010539d:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801053a0:	c9                   	leave  
801053a1:	c3                   	ret    

801053a2 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801053a2:	f3 0f 1e fb          	endbr32 
801053a6:	55                   	push   %ebp
801053a7:	89 e5                	mov    %esp,%ebp
801053a9:	57                   	push   %edi
801053aa:	56                   	push   %esi
801053ab:	53                   	push   %ebx
801053ac:	83 ec 1c             	sub    $0x1c,%esp
801053af:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801053b2:	8b 43 30             	mov    0x30(%ebx),%eax
801053b5:	83 f8 40             	cmp    $0x40,%eax
801053b8:	74 14                	je     801053ce <trap+0x2c>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801053ba:	83 e8 20             	sub    $0x20,%eax
801053bd:	83 f8 1f             	cmp    $0x1f,%eax
801053c0:	0f 87 23 01 00 00    	ja     801054e9 <trap+0x147>
801053c6:	3e ff 24 85 e0 72 10 	notrack jmp *-0x7fef8d20(,%eax,4)
801053cd:	80 
    if(myproc()->killed)
801053ce:	e8 68 df ff ff       	call   8010333b <myproc>
801053d3:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801053d7:	75 1f                	jne    801053f8 <trap+0x56>
    myproc()->tf = tf;
801053d9:	e8 5d df ff ff       	call   8010333b <myproc>
801053de:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801053e1:	e8 b8 ef ff ff       	call   8010439e <syscall>
    if(myproc()->killed)
801053e6:	e8 50 df ff ff       	call   8010333b <myproc>
801053eb:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801053ef:	74 7e                	je     8010546f <trap+0xcd>
      exit();
801053f1:	e8 1f e3 ff ff       	call   80103715 <exit>
    return;
801053f6:	eb 77                	jmp    8010546f <trap+0xcd>
      exit();
801053f8:	e8 18 e3 ff ff       	call   80103715 <exit>
801053fd:	eb da                	jmp    801053d9 <trap+0x37>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801053ff:	e8 18 df ff ff       	call   8010331c <cpuid>
80105404:	85 c0                	test   %eax,%eax
80105406:	74 6f                	je     80105477 <trap+0xd5>
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
#endif // PDX_XV6
    }
    lapiceoi();
80105408:	e8 63 d0 ff ff       	call   80102470 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010540d:	e8 29 df ff ff       	call   8010333b <myproc>
80105412:	85 c0                	test   %eax,%eax
80105414:	74 1c                	je     80105432 <trap+0x90>
80105416:	e8 20 df ff ff       	call   8010333b <myproc>
8010541b:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010541f:	74 11                	je     80105432 <trap+0x90>
80105421:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105425:	83 e0 03             	and    $0x3,%eax
80105428:	66 83 f8 03          	cmp    $0x3,%ax
8010542c:	0f 84 4a 01 00 00    	je     8010557c <trap+0x1da>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105432:	e8 04 df ff ff       	call   8010333b <myproc>
80105437:	85 c0                	test   %eax,%eax
80105439:	74 0f                	je     8010544a <trap+0xa8>
8010543b:	e8 fb de ff ff       	call   8010333b <myproc>
80105440:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105444:	0f 84 3c 01 00 00    	je     80105586 <trap+0x1e4>
    tf->trapno == T_IRQ0+IRQ_TIMER)
#endif // PDX_XV6
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010544a:	e8 ec de ff ff       	call   8010333b <myproc>
8010544f:	85 c0                	test   %eax,%eax
80105451:	74 1c                	je     8010546f <trap+0xcd>
80105453:	e8 e3 de ff ff       	call   8010333b <myproc>
80105458:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010545c:	74 11                	je     8010546f <trap+0xcd>
8010545e:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105462:	83 e0 03             	and    $0x3,%eax
80105465:	66 83 f8 03          	cmp    $0x3,%ax
80105469:	0f 84 4a 01 00 00    	je     801055b9 <trap+0x217>
    exit();
}
8010546f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105472:	5b                   	pop    %ebx
80105473:	5e                   	pop    %esi
80105474:	5f                   	pop    %edi
80105475:	5d                   	pop    %ebp
80105476:	c3                   	ret    
// atom_inc() necessary for removal of tickslock
// other atomic ops added for completeness
static inline void
atom_inc(volatile int *num)
{
  asm volatile ( "lock incl %0" : "=m" (*num));
80105477:	f0 ff 05 80 76 11 80 	lock incl 0x80117680
      wakeup(&ticks);
8010547e:	83 ec 0c             	sub    $0xc,%esp
80105481:	68 80 76 11 80       	push   $0x80117680
80105486:	e8 0b e5 ff ff       	call   80103996 <wakeup>
8010548b:	83 c4 10             	add    $0x10,%esp
8010548e:	e9 75 ff ff ff       	jmp    80105408 <trap+0x66>
    ideintr();
80105493:	e8 91 c9 ff ff       	call   80101e29 <ideintr>
    lapiceoi();
80105498:	e8 d3 cf ff ff       	call   80102470 <lapiceoi>
    break;
8010549d:	e9 6b ff ff ff       	jmp    8010540d <trap+0x6b>
    kbdintr();
801054a2:	e8 06 ce ff ff       	call   801022ad <kbdintr>
    lapiceoi();
801054a7:	e8 c4 cf ff ff       	call   80102470 <lapiceoi>
    break;
801054ac:	e9 5c ff ff ff       	jmp    8010540d <trap+0x6b>
    uartintr();
801054b1:	e8 29 02 00 00       	call   801056df <uartintr>
    lapiceoi();
801054b6:	e8 b5 cf ff ff       	call   80102470 <lapiceoi>
    break;
801054bb:	e9 4d ff ff ff       	jmp    8010540d <trap+0x6b>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801054c0:	8b 7b 38             	mov    0x38(%ebx),%edi
            cpuid(), tf->cs, tf->eip);
801054c3:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801054c7:	e8 50 de ff ff       	call   8010331c <cpuid>
801054cc:	57                   	push   %edi
801054cd:	0f b7 f6             	movzwl %si,%esi
801054d0:	56                   	push   %esi
801054d1:	50                   	push   %eax
801054d2:	68 40 72 10 80       	push   $0x80107240
801054d7:	e8 4d b1 ff ff       	call   80100629 <cprintf>
    lapiceoi();
801054dc:	e8 8f cf ff ff       	call   80102470 <lapiceoi>
    break;
801054e1:	83 c4 10             	add    $0x10,%esp
801054e4:	e9 24 ff ff ff       	jmp    8010540d <trap+0x6b>
    if(myproc() == 0 || (tf->cs&3) == 0){
801054e9:	e8 4d de ff ff       	call   8010333b <myproc>
801054ee:	85 c0                	test   %eax,%eax
801054f0:	74 5f                	je     80105551 <trap+0x1af>
801054f2:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801054f6:	74 59                	je     80105551 <trap+0x1af>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801054f8:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801054fb:	8b 43 38             	mov    0x38(%ebx),%eax
801054fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105501:	e8 16 de ff ff       	call   8010331c <cpuid>
80105506:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105509:	8b 4b 34             	mov    0x34(%ebx),%ecx
8010550c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
8010550f:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
80105512:	e8 24 de ff ff       	call   8010333b <myproc>
80105517:	8d 50 6c             	lea    0x6c(%eax),%edx
8010551a:	89 55 d8             	mov    %edx,-0x28(%ebp)
8010551d:	e8 19 de ff ff       	call   8010333b <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105522:	57                   	push   %edi
80105523:	ff 75 e4             	pushl  -0x1c(%ebp)
80105526:	ff 75 e0             	pushl  -0x20(%ebp)
80105529:	ff 75 dc             	pushl  -0x24(%ebp)
8010552c:	56                   	push   %esi
8010552d:	ff 75 d8             	pushl  -0x28(%ebp)
80105530:	ff 70 10             	pushl  0x10(%eax)
80105533:	68 98 72 10 80       	push   $0x80107298
80105538:	e8 ec b0 ff ff       	call   80100629 <cprintf>
    myproc()->killed = 1;
8010553d:	83 c4 20             	add    $0x20,%esp
80105540:	e8 f6 dd ff ff       	call   8010333b <myproc>
80105545:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010554c:	e9 bc fe ff ff       	jmp    8010540d <trap+0x6b>
80105551:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105554:	8b 73 38             	mov    0x38(%ebx),%esi
80105557:	e8 c0 dd ff ff       	call   8010331c <cpuid>
8010555c:	83 ec 0c             	sub    $0xc,%esp
8010555f:	57                   	push   %edi
80105560:	56                   	push   %esi
80105561:	50                   	push   %eax
80105562:	ff 73 30             	pushl  0x30(%ebx)
80105565:	68 64 72 10 80       	push   $0x80107264
8010556a:	e8 ba b0 ff ff       	call   80100629 <cprintf>
      panic("trap");
8010556f:	83 c4 14             	add    $0x14,%esp
80105572:	68 db 72 10 80       	push   $0x801072db
80105577:	e8 e0 ad ff ff       	call   8010035c <panic>
    exit();
8010557c:	e8 94 e1 ff ff       	call   80103715 <exit>
80105581:	e9 ac fe ff ff       	jmp    80105432 <trap+0x90>
  if(myproc() && myproc()->state == RUNNING &&
80105586:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010558a:	0f 85 ba fe ff ff    	jne    8010544a <trap+0xa8>
    tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
80105590:	8b 0d 80 76 11 80    	mov    0x80117680,%ecx
80105596:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
8010559b:	89 c8                	mov    %ecx,%eax
8010559d:	f7 e2                	mul    %edx
8010559f:	c1 ea 03             	shr    $0x3,%edx
801055a2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801055a5:	01 c0                	add    %eax,%eax
801055a7:	39 c1                	cmp    %eax,%ecx
801055a9:	0f 85 9b fe ff ff    	jne    8010544a <trap+0xa8>
    yield();
801055af:	e8 34 e2 ff ff       	call   801037e8 <yield>
801055b4:	e9 91 fe ff ff       	jmp    8010544a <trap+0xa8>
    exit();
801055b9:	e8 57 e1 ff ff       	call   80103715 <exit>
801055be:	e9 ac fe ff ff       	jmp    8010546f <trap+0xcd>

801055c3 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801055c3:	f3 0f 1e fb          	endbr32 
  if(!uart)
801055c7:	83 3d 14 e7 10 80 00 	cmpl   $0x0,0x8010e714
801055ce:	74 14                	je     801055e4 <uartgetc+0x21>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801055d0:	ba fd 03 00 00       	mov    $0x3fd,%edx
801055d5:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801055d6:	a8 01                	test   $0x1,%al
801055d8:	74 10                	je     801055ea <uartgetc+0x27>
801055da:	ba f8 03 00 00       	mov    $0x3f8,%edx
801055df:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801055e0:	0f b6 c0             	movzbl %al,%eax
801055e3:	c3                   	ret    
    return -1;
801055e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055e9:	c3                   	ret    
    return -1;
801055ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055ef:	c3                   	ret    

801055f0 <uartputc>:
{
801055f0:	f3 0f 1e fb          	endbr32 
  if(!uart)
801055f4:	83 3d 14 e7 10 80 00 	cmpl   $0x0,0x8010e714
801055fb:	74 3b                	je     80105638 <uartputc+0x48>
{
801055fd:	55                   	push   %ebp
801055fe:	89 e5                	mov    %esp,%ebp
80105600:	53                   	push   %ebx
80105601:	83 ec 04             	sub    $0x4,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105604:	bb 00 00 00 00       	mov    $0x0,%ebx
80105609:	83 fb 7f             	cmp    $0x7f,%ebx
8010560c:	7f 1c                	jg     8010562a <uartputc+0x3a>
8010560e:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105613:	ec                   	in     (%dx),%al
80105614:	a8 20                	test   $0x20,%al
80105616:	75 12                	jne    8010562a <uartputc+0x3a>
    microdelay(10);
80105618:	83 ec 0c             	sub    $0xc,%esp
8010561b:	6a 0a                	push   $0xa
8010561d:	e8 73 ce ff ff       	call   80102495 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105622:	83 c3 01             	add    $0x1,%ebx
80105625:	83 c4 10             	add    $0x10,%esp
80105628:	eb df                	jmp    80105609 <uartputc+0x19>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010562a:	8b 45 08             	mov    0x8(%ebp),%eax
8010562d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105632:	ee                   	out    %al,(%dx)
}
80105633:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105636:	c9                   	leave  
80105637:	c3                   	ret    
80105638:	c3                   	ret    

80105639 <uartinit>:
{
80105639:	f3 0f 1e fb          	endbr32 
8010563d:	55                   	push   %ebp
8010563e:	89 e5                	mov    %esp,%ebp
80105640:	56                   	push   %esi
80105641:	53                   	push   %ebx
80105642:	b9 00 00 00 00       	mov    $0x0,%ecx
80105647:	ba fa 03 00 00       	mov    $0x3fa,%edx
8010564c:	89 c8                	mov    %ecx,%eax
8010564e:	ee                   	out    %al,(%dx)
8010564f:	be fb 03 00 00       	mov    $0x3fb,%esi
80105654:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105659:	89 f2                	mov    %esi,%edx
8010565b:	ee                   	out    %al,(%dx)
8010565c:	b8 0c 00 00 00       	mov    $0xc,%eax
80105661:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105666:	ee                   	out    %al,(%dx)
80105667:	bb f9 03 00 00       	mov    $0x3f9,%ebx
8010566c:	89 c8                	mov    %ecx,%eax
8010566e:	89 da                	mov    %ebx,%edx
80105670:	ee                   	out    %al,(%dx)
80105671:	b8 03 00 00 00       	mov    $0x3,%eax
80105676:	89 f2                	mov    %esi,%edx
80105678:	ee                   	out    %al,(%dx)
80105679:	ba fc 03 00 00       	mov    $0x3fc,%edx
8010567e:	89 c8                	mov    %ecx,%eax
80105680:	ee                   	out    %al,(%dx)
80105681:	b8 01 00 00 00       	mov    $0x1,%eax
80105686:	89 da                	mov    %ebx,%edx
80105688:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105689:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010568e:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
8010568f:	3c ff                	cmp    $0xff,%al
80105691:	74 45                	je     801056d8 <uartinit+0x9f>
  uart = 1;
80105693:	c7 05 14 e7 10 80 01 	movl   $0x1,0x8010e714
8010569a:	00 00 00 
8010569d:	ba fa 03 00 00       	mov    $0x3fa,%edx
801056a2:	ec                   	in     (%dx),%al
801056a3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801056a8:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801056a9:	83 ec 08             	sub    $0x8,%esp
801056ac:	6a 00                	push   $0x0
801056ae:	6a 04                	push   $0x4
801056b0:	e8 83 c9 ff ff       	call   80102038 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801056b5:	83 c4 10             	add    $0x10,%esp
801056b8:	bb 60 73 10 80       	mov    $0x80107360,%ebx
801056bd:	eb 12                	jmp    801056d1 <uartinit+0x98>
    uartputc(*p);
801056bf:	83 ec 0c             	sub    $0xc,%esp
801056c2:	0f be c0             	movsbl %al,%eax
801056c5:	50                   	push   %eax
801056c6:	e8 25 ff ff ff       	call   801055f0 <uartputc>
  for(p="xv6...\n"; *p; p++)
801056cb:	83 c3 01             	add    $0x1,%ebx
801056ce:	83 c4 10             	add    $0x10,%esp
801056d1:	0f b6 03             	movzbl (%ebx),%eax
801056d4:	84 c0                	test   %al,%al
801056d6:	75 e7                	jne    801056bf <uartinit+0x86>
}
801056d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056db:	5b                   	pop    %ebx
801056dc:	5e                   	pop    %esi
801056dd:	5d                   	pop    %ebp
801056de:	c3                   	ret    

801056df <uartintr>:

void
uartintr(void)
{
801056df:	f3 0f 1e fb          	endbr32 
801056e3:	55                   	push   %ebp
801056e4:	89 e5                	mov    %esp,%ebp
801056e6:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801056e9:	68 c3 55 10 80       	push   $0x801055c3
801056ee:	e8 8b b0 ff ff       	call   8010077e <consoleintr>
}
801056f3:	83 c4 10             	add    $0x10,%esp
801056f6:	c9                   	leave  
801056f7:	c3                   	ret    

801056f8 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801056f8:	6a 00                	push   $0x0
  pushl $0
801056fa:	6a 00                	push   $0x0
  jmp alltraps
801056fc:	e9 bd fb ff ff       	jmp    801052be <alltraps>

80105701 <vector1>:
.globl vector1
vector1:
  pushl $0
80105701:	6a 00                	push   $0x0
  pushl $1
80105703:	6a 01                	push   $0x1
  jmp alltraps
80105705:	e9 b4 fb ff ff       	jmp    801052be <alltraps>

8010570a <vector2>:
.globl vector2
vector2:
  pushl $0
8010570a:	6a 00                	push   $0x0
  pushl $2
8010570c:	6a 02                	push   $0x2
  jmp alltraps
8010570e:	e9 ab fb ff ff       	jmp    801052be <alltraps>

80105713 <vector3>:
.globl vector3
vector3:
  pushl $0
80105713:	6a 00                	push   $0x0
  pushl $3
80105715:	6a 03                	push   $0x3
  jmp alltraps
80105717:	e9 a2 fb ff ff       	jmp    801052be <alltraps>

8010571c <vector4>:
.globl vector4
vector4:
  pushl $0
8010571c:	6a 00                	push   $0x0
  pushl $4
8010571e:	6a 04                	push   $0x4
  jmp alltraps
80105720:	e9 99 fb ff ff       	jmp    801052be <alltraps>

80105725 <vector5>:
.globl vector5
vector5:
  pushl $0
80105725:	6a 00                	push   $0x0
  pushl $5
80105727:	6a 05                	push   $0x5
  jmp alltraps
80105729:	e9 90 fb ff ff       	jmp    801052be <alltraps>

8010572e <vector6>:
.globl vector6
vector6:
  pushl $0
8010572e:	6a 00                	push   $0x0
  pushl $6
80105730:	6a 06                	push   $0x6
  jmp alltraps
80105732:	e9 87 fb ff ff       	jmp    801052be <alltraps>

80105737 <vector7>:
.globl vector7
vector7:
  pushl $0
80105737:	6a 00                	push   $0x0
  pushl $7
80105739:	6a 07                	push   $0x7
  jmp alltraps
8010573b:	e9 7e fb ff ff       	jmp    801052be <alltraps>

80105740 <vector8>:
.globl vector8
vector8:
  pushl $8
80105740:	6a 08                	push   $0x8
  jmp alltraps
80105742:	e9 77 fb ff ff       	jmp    801052be <alltraps>

80105747 <vector9>:
.globl vector9
vector9:
  pushl $0
80105747:	6a 00                	push   $0x0
  pushl $9
80105749:	6a 09                	push   $0x9
  jmp alltraps
8010574b:	e9 6e fb ff ff       	jmp    801052be <alltraps>

80105750 <vector10>:
.globl vector10
vector10:
  pushl $10
80105750:	6a 0a                	push   $0xa
  jmp alltraps
80105752:	e9 67 fb ff ff       	jmp    801052be <alltraps>

80105757 <vector11>:
.globl vector11
vector11:
  pushl $11
80105757:	6a 0b                	push   $0xb
  jmp alltraps
80105759:	e9 60 fb ff ff       	jmp    801052be <alltraps>

8010575e <vector12>:
.globl vector12
vector12:
  pushl $12
8010575e:	6a 0c                	push   $0xc
  jmp alltraps
80105760:	e9 59 fb ff ff       	jmp    801052be <alltraps>

80105765 <vector13>:
.globl vector13
vector13:
  pushl $13
80105765:	6a 0d                	push   $0xd
  jmp alltraps
80105767:	e9 52 fb ff ff       	jmp    801052be <alltraps>

8010576c <vector14>:
.globl vector14
vector14:
  pushl $14
8010576c:	6a 0e                	push   $0xe
  jmp alltraps
8010576e:	e9 4b fb ff ff       	jmp    801052be <alltraps>

80105773 <vector15>:
.globl vector15
vector15:
  pushl $0
80105773:	6a 00                	push   $0x0
  pushl $15
80105775:	6a 0f                	push   $0xf
  jmp alltraps
80105777:	e9 42 fb ff ff       	jmp    801052be <alltraps>

8010577c <vector16>:
.globl vector16
vector16:
  pushl $0
8010577c:	6a 00                	push   $0x0
  pushl $16
8010577e:	6a 10                	push   $0x10
  jmp alltraps
80105780:	e9 39 fb ff ff       	jmp    801052be <alltraps>

80105785 <vector17>:
.globl vector17
vector17:
  pushl $17
80105785:	6a 11                	push   $0x11
  jmp alltraps
80105787:	e9 32 fb ff ff       	jmp    801052be <alltraps>

8010578c <vector18>:
.globl vector18
vector18:
  pushl $0
8010578c:	6a 00                	push   $0x0
  pushl $18
8010578e:	6a 12                	push   $0x12
  jmp alltraps
80105790:	e9 29 fb ff ff       	jmp    801052be <alltraps>

80105795 <vector19>:
.globl vector19
vector19:
  pushl $0
80105795:	6a 00                	push   $0x0
  pushl $19
80105797:	6a 13                	push   $0x13
  jmp alltraps
80105799:	e9 20 fb ff ff       	jmp    801052be <alltraps>

8010579e <vector20>:
.globl vector20
vector20:
  pushl $0
8010579e:	6a 00                	push   $0x0
  pushl $20
801057a0:	6a 14                	push   $0x14
  jmp alltraps
801057a2:	e9 17 fb ff ff       	jmp    801052be <alltraps>

801057a7 <vector21>:
.globl vector21
vector21:
  pushl $0
801057a7:	6a 00                	push   $0x0
  pushl $21
801057a9:	6a 15                	push   $0x15
  jmp alltraps
801057ab:	e9 0e fb ff ff       	jmp    801052be <alltraps>

801057b0 <vector22>:
.globl vector22
vector22:
  pushl $0
801057b0:	6a 00                	push   $0x0
  pushl $22
801057b2:	6a 16                	push   $0x16
  jmp alltraps
801057b4:	e9 05 fb ff ff       	jmp    801052be <alltraps>

801057b9 <vector23>:
.globl vector23
vector23:
  pushl $0
801057b9:	6a 00                	push   $0x0
  pushl $23
801057bb:	6a 17                	push   $0x17
  jmp alltraps
801057bd:	e9 fc fa ff ff       	jmp    801052be <alltraps>

801057c2 <vector24>:
.globl vector24
vector24:
  pushl $0
801057c2:	6a 00                	push   $0x0
  pushl $24
801057c4:	6a 18                	push   $0x18
  jmp alltraps
801057c6:	e9 f3 fa ff ff       	jmp    801052be <alltraps>

801057cb <vector25>:
.globl vector25
vector25:
  pushl $0
801057cb:	6a 00                	push   $0x0
  pushl $25
801057cd:	6a 19                	push   $0x19
  jmp alltraps
801057cf:	e9 ea fa ff ff       	jmp    801052be <alltraps>

801057d4 <vector26>:
.globl vector26
vector26:
  pushl $0
801057d4:	6a 00                	push   $0x0
  pushl $26
801057d6:	6a 1a                	push   $0x1a
  jmp alltraps
801057d8:	e9 e1 fa ff ff       	jmp    801052be <alltraps>

801057dd <vector27>:
.globl vector27
vector27:
  pushl $0
801057dd:	6a 00                	push   $0x0
  pushl $27
801057df:	6a 1b                	push   $0x1b
  jmp alltraps
801057e1:	e9 d8 fa ff ff       	jmp    801052be <alltraps>

801057e6 <vector28>:
.globl vector28
vector28:
  pushl $0
801057e6:	6a 00                	push   $0x0
  pushl $28
801057e8:	6a 1c                	push   $0x1c
  jmp alltraps
801057ea:	e9 cf fa ff ff       	jmp    801052be <alltraps>

801057ef <vector29>:
.globl vector29
vector29:
  pushl $0
801057ef:	6a 00                	push   $0x0
  pushl $29
801057f1:	6a 1d                	push   $0x1d
  jmp alltraps
801057f3:	e9 c6 fa ff ff       	jmp    801052be <alltraps>

801057f8 <vector30>:
.globl vector30
vector30:
  pushl $0
801057f8:	6a 00                	push   $0x0
  pushl $30
801057fa:	6a 1e                	push   $0x1e
  jmp alltraps
801057fc:	e9 bd fa ff ff       	jmp    801052be <alltraps>

80105801 <vector31>:
.globl vector31
vector31:
  pushl $0
80105801:	6a 00                	push   $0x0
  pushl $31
80105803:	6a 1f                	push   $0x1f
  jmp alltraps
80105805:	e9 b4 fa ff ff       	jmp    801052be <alltraps>

8010580a <vector32>:
.globl vector32
vector32:
  pushl $0
8010580a:	6a 00                	push   $0x0
  pushl $32
8010580c:	6a 20                	push   $0x20
  jmp alltraps
8010580e:	e9 ab fa ff ff       	jmp    801052be <alltraps>

80105813 <vector33>:
.globl vector33
vector33:
  pushl $0
80105813:	6a 00                	push   $0x0
  pushl $33
80105815:	6a 21                	push   $0x21
  jmp alltraps
80105817:	e9 a2 fa ff ff       	jmp    801052be <alltraps>

8010581c <vector34>:
.globl vector34
vector34:
  pushl $0
8010581c:	6a 00                	push   $0x0
  pushl $34
8010581e:	6a 22                	push   $0x22
  jmp alltraps
80105820:	e9 99 fa ff ff       	jmp    801052be <alltraps>

80105825 <vector35>:
.globl vector35
vector35:
  pushl $0
80105825:	6a 00                	push   $0x0
  pushl $35
80105827:	6a 23                	push   $0x23
  jmp alltraps
80105829:	e9 90 fa ff ff       	jmp    801052be <alltraps>

8010582e <vector36>:
.globl vector36
vector36:
  pushl $0
8010582e:	6a 00                	push   $0x0
  pushl $36
80105830:	6a 24                	push   $0x24
  jmp alltraps
80105832:	e9 87 fa ff ff       	jmp    801052be <alltraps>

80105837 <vector37>:
.globl vector37
vector37:
  pushl $0
80105837:	6a 00                	push   $0x0
  pushl $37
80105839:	6a 25                	push   $0x25
  jmp alltraps
8010583b:	e9 7e fa ff ff       	jmp    801052be <alltraps>

80105840 <vector38>:
.globl vector38
vector38:
  pushl $0
80105840:	6a 00                	push   $0x0
  pushl $38
80105842:	6a 26                	push   $0x26
  jmp alltraps
80105844:	e9 75 fa ff ff       	jmp    801052be <alltraps>

80105849 <vector39>:
.globl vector39
vector39:
  pushl $0
80105849:	6a 00                	push   $0x0
  pushl $39
8010584b:	6a 27                	push   $0x27
  jmp alltraps
8010584d:	e9 6c fa ff ff       	jmp    801052be <alltraps>

80105852 <vector40>:
.globl vector40
vector40:
  pushl $0
80105852:	6a 00                	push   $0x0
  pushl $40
80105854:	6a 28                	push   $0x28
  jmp alltraps
80105856:	e9 63 fa ff ff       	jmp    801052be <alltraps>

8010585b <vector41>:
.globl vector41
vector41:
  pushl $0
8010585b:	6a 00                	push   $0x0
  pushl $41
8010585d:	6a 29                	push   $0x29
  jmp alltraps
8010585f:	e9 5a fa ff ff       	jmp    801052be <alltraps>

80105864 <vector42>:
.globl vector42
vector42:
  pushl $0
80105864:	6a 00                	push   $0x0
  pushl $42
80105866:	6a 2a                	push   $0x2a
  jmp alltraps
80105868:	e9 51 fa ff ff       	jmp    801052be <alltraps>

8010586d <vector43>:
.globl vector43
vector43:
  pushl $0
8010586d:	6a 00                	push   $0x0
  pushl $43
8010586f:	6a 2b                	push   $0x2b
  jmp alltraps
80105871:	e9 48 fa ff ff       	jmp    801052be <alltraps>

80105876 <vector44>:
.globl vector44
vector44:
  pushl $0
80105876:	6a 00                	push   $0x0
  pushl $44
80105878:	6a 2c                	push   $0x2c
  jmp alltraps
8010587a:	e9 3f fa ff ff       	jmp    801052be <alltraps>

8010587f <vector45>:
.globl vector45
vector45:
  pushl $0
8010587f:	6a 00                	push   $0x0
  pushl $45
80105881:	6a 2d                	push   $0x2d
  jmp alltraps
80105883:	e9 36 fa ff ff       	jmp    801052be <alltraps>

80105888 <vector46>:
.globl vector46
vector46:
  pushl $0
80105888:	6a 00                	push   $0x0
  pushl $46
8010588a:	6a 2e                	push   $0x2e
  jmp alltraps
8010588c:	e9 2d fa ff ff       	jmp    801052be <alltraps>

80105891 <vector47>:
.globl vector47
vector47:
  pushl $0
80105891:	6a 00                	push   $0x0
  pushl $47
80105893:	6a 2f                	push   $0x2f
  jmp alltraps
80105895:	e9 24 fa ff ff       	jmp    801052be <alltraps>

8010589a <vector48>:
.globl vector48
vector48:
  pushl $0
8010589a:	6a 00                	push   $0x0
  pushl $48
8010589c:	6a 30                	push   $0x30
  jmp alltraps
8010589e:	e9 1b fa ff ff       	jmp    801052be <alltraps>

801058a3 <vector49>:
.globl vector49
vector49:
  pushl $0
801058a3:	6a 00                	push   $0x0
  pushl $49
801058a5:	6a 31                	push   $0x31
  jmp alltraps
801058a7:	e9 12 fa ff ff       	jmp    801052be <alltraps>

801058ac <vector50>:
.globl vector50
vector50:
  pushl $0
801058ac:	6a 00                	push   $0x0
  pushl $50
801058ae:	6a 32                	push   $0x32
  jmp alltraps
801058b0:	e9 09 fa ff ff       	jmp    801052be <alltraps>

801058b5 <vector51>:
.globl vector51
vector51:
  pushl $0
801058b5:	6a 00                	push   $0x0
  pushl $51
801058b7:	6a 33                	push   $0x33
  jmp alltraps
801058b9:	e9 00 fa ff ff       	jmp    801052be <alltraps>

801058be <vector52>:
.globl vector52
vector52:
  pushl $0
801058be:	6a 00                	push   $0x0
  pushl $52
801058c0:	6a 34                	push   $0x34
  jmp alltraps
801058c2:	e9 f7 f9 ff ff       	jmp    801052be <alltraps>

801058c7 <vector53>:
.globl vector53
vector53:
  pushl $0
801058c7:	6a 00                	push   $0x0
  pushl $53
801058c9:	6a 35                	push   $0x35
  jmp alltraps
801058cb:	e9 ee f9 ff ff       	jmp    801052be <alltraps>

801058d0 <vector54>:
.globl vector54
vector54:
  pushl $0
801058d0:	6a 00                	push   $0x0
  pushl $54
801058d2:	6a 36                	push   $0x36
  jmp alltraps
801058d4:	e9 e5 f9 ff ff       	jmp    801052be <alltraps>

801058d9 <vector55>:
.globl vector55
vector55:
  pushl $0
801058d9:	6a 00                	push   $0x0
  pushl $55
801058db:	6a 37                	push   $0x37
  jmp alltraps
801058dd:	e9 dc f9 ff ff       	jmp    801052be <alltraps>

801058e2 <vector56>:
.globl vector56
vector56:
  pushl $0
801058e2:	6a 00                	push   $0x0
  pushl $56
801058e4:	6a 38                	push   $0x38
  jmp alltraps
801058e6:	e9 d3 f9 ff ff       	jmp    801052be <alltraps>

801058eb <vector57>:
.globl vector57
vector57:
  pushl $0
801058eb:	6a 00                	push   $0x0
  pushl $57
801058ed:	6a 39                	push   $0x39
  jmp alltraps
801058ef:	e9 ca f9 ff ff       	jmp    801052be <alltraps>

801058f4 <vector58>:
.globl vector58
vector58:
  pushl $0
801058f4:	6a 00                	push   $0x0
  pushl $58
801058f6:	6a 3a                	push   $0x3a
  jmp alltraps
801058f8:	e9 c1 f9 ff ff       	jmp    801052be <alltraps>

801058fd <vector59>:
.globl vector59
vector59:
  pushl $0
801058fd:	6a 00                	push   $0x0
  pushl $59
801058ff:	6a 3b                	push   $0x3b
  jmp alltraps
80105901:	e9 b8 f9 ff ff       	jmp    801052be <alltraps>

80105906 <vector60>:
.globl vector60
vector60:
  pushl $0
80105906:	6a 00                	push   $0x0
  pushl $60
80105908:	6a 3c                	push   $0x3c
  jmp alltraps
8010590a:	e9 af f9 ff ff       	jmp    801052be <alltraps>

8010590f <vector61>:
.globl vector61
vector61:
  pushl $0
8010590f:	6a 00                	push   $0x0
  pushl $61
80105911:	6a 3d                	push   $0x3d
  jmp alltraps
80105913:	e9 a6 f9 ff ff       	jmp    801052be <alltraps>

80105918 <vector62>:
.globl vector62
vector62:
  pushl $0
80105918:	6a 00                	push   $0x0
  pushl $62
8010591a:	6a 3e                	push   $0x3e
  jmp alltraps
8010591c:	e9 9d f9 ff ff       	jmp    801052be <alltraps>

80105921 <vector63>:
.globl vector63
vector63:
  pushl $0
80105921:	6a 00                	push   $0x0
  pushl $63
80105923:	6a 3f                	push   $0x3f
  jmp alltraps
80105925:	e9 94 f9 ff ff       	jmp    801052be <alltraps>

8010592a <vector64>:
.globl vector64
vector64:
  pushl $0
8010592a:	6a 00                	push   $0x0
  pushl $64
8010592c:	6a 40                	push   $0x40
  jmp alltraps
8010592e:	e9 8b f9 ff ff       	jmp    801052be <alltraps>

80105933 <vector65>:
.globl vector65
vector65:
  pushl $0
80105933:	6a 00                	push   $0x0
  pushl $65
80105935:	6a 41                	push   $0x41
  jmp alltraps
80105937:	e9 82 f9 ff ff       	jmp    801052be <alltraps>

8010593c <vector66>:
.globl vector66
vector66:
  pushl $0
8010593c:	6a 00                	push   $0x0
  pushl $66
8010593e:	6a 42                	push   $0x42
  jmp alltraps
80105940:	e9 79 f9 ff ff       	jmp    801052be <alltraps>

80105945 <vector67>:
.globl vector67
vector67:
  pushl $0
80105945:	6a 00                	push   $0x0
  pushl $67
80105947:	6a 43                	push   $0x43
  jmp alltraps
80105949:	e9 70 f9 ff ff       	jmp    801052be <alltraps>

8010594e <vector68>:
.globl vector68
vector68:
  pushl $0
8010594e:	6a 00                	push   $0x0
  pushl $68
80105950:	6a 44                	push   $0x44
  jmp alltraps
80105952:	e9 67 f9 ff ff       	jmp    801052be <alltraps>

80105957 <vector69>:
.globl vector69
vector69:
  pushl $0
80105957:	6a 00                	push   $0x0
  pushl $69
80105959:	6a 45                	push   $0x45
  jmp alltraps
8010595b:	e9 5e f9 ff ff       	jmp    801052be <alltraps>

80105960 <vector70>:
.globl vector70
vector70:
  pushl $0
80105960:	6a 00                	push   $0x0
  pushl $70
80105962:	6a 46                	push   $0x46
  jmp alltraps
80105964:	e9 55 f9 ff ff       	jmp    801052be <alltraps>

80105969 <vector71>:
.globl vector71
vector71:
  pushl $0
80105969:	6a 00                	push   $0x0
  pushl $71
8010596b:	6a 47                	push   $0x47
  jmp alltraps
8010596d:	e9 4c f9 ff ff       	jmp    801052be <alltraps>

80105972 <vector72>:
.globl vector72
vector72:
  pushl $0
80105972:	6a 00                	push   $0x0
  pushl $72
80105974:	6a 48                	push   $0x48
  jmp alltraps
80105976:	e9 43 f9 ff ff       	jmp    801052be <alltraps>

8010597b <vector73>:
.globl vector73
vector73:
  pushl $0
8010597b:	6a 00                	push   $0x0
  pushl $73
8010597d:	6a 49                	push   $0x49
  jmp alltraps
8010597f:	e9 3a f9 ff ff       	jmp    801052be <alltraps>

80105984 <vector74>:
.globl vector74
vector74:
  pushl $0
80105984:	6a 00                	push   $0x0
  pushl $74
80105986:	6a 4a                	push   $0x4a
  jmp alltraps
80105988:	e9 31 f9 ff ff       	jmp    801052be <alltraps>

8010598d <vector75>:
.globl vector75
vector75:
  pushl $0
8010598d:	6a 00                	push   $0x0
  pushl $75
8010598f:	6a 4b                	push   $0x4b
  jmp alltraps
80105991:	e9 28 f9 ff ff       	jmp    801052be <alltraps>

80105996 <vector76>:
.globl vector76
vector76:
  pushl $0
80105996:	6a 00                	push   $0x0
  pushl $76
80105998:	6a 4c                	push   $0x4c
  jmp alltraps
8010599a:	e9 1f f9 ff ff       	jmp    801052be <alltraps>

8010599f <vector77>:
.globl vector77
vector77:
  pushl $0
8010599f:	6a 00                	push   $0x0
  pushl $77
801059a1:	6a 4d                	push   $0x4d
  jmp alltraps
801059a3:	e9 16 f9 ff ff       	jmp    801052be <alltraps>

801059a8 <vector78>:
.globl vector78
vector78:
  pushl $0
801059a8:	6a 00                	push   $0x0
  pushl $78
801059aa:	6a 4e                	push   $0x4e
  jmp alltraps
801059ac:	e9 0d f9 ff ff       	jmp    801052be <alltraps>

801059b1 <vector79>:
.globl vector79
vector79:
  pushl $0
801059b1:	6a 00                	push   $0x0
  pushl $79
801059b3:	6a 4f                	push   $0x4f
  jmp alltraps
801059b5:	e9 04 f9 ff ff       	jmp    801052be <alltraps>

801059ba <vector80>:
.globl vector80
vector80:
  pushl $0
801059ba:	6a 00                	push   $0x0
  pushl $80
801059bc:	6a 50                	push   $0x50
  jmp alltraps
801059be:	e9 fb f8 ff ff       	jmp    801052be <alltraps>

801059c3 <vector81>:
.globl vector81
vector81:
  pushl $0
801059c3:	6a 00                	push   $0x0
  pushl $81
801059c5:	6a 51                	push   $0x51
  jmp alltraps
801059c7:	e9 f2 f8 ff ff       	jmp    801052be <alltraps>

801059cc <vector82>:
.globl vector82
vector82:
  pushl $0
801059cc:	6a 00                	push   $0x0
  pushl $82
801059ce:	6a 52                	push   $0x52
  jmp alltraps
801059d0:	e9 e9 f8 ff ff       	jmp    801052be <alltraps>

801059d5 <vector83>:
.globl vector83
vector83:
  pushl $0
801059d5:	6a 00                	push   $0x0
  pushl $83
801059d7:	6a 53                	push   $0x53
  jmp alltraps
801059d9:	e9 e0 f8 ff ff       	jmp    801052be <alltraps>

801059de <vector84>:
.globl vector84
vector84:
  pushl $0
801059de:	6a 00                	push   $0x0
  pushl $84
801059e0:	6a 54                	push   $0x54
  jmp alltraps
801059e2:	e9 d7 f8 ff ff       	jmp    801052be <alltraps>

801059e7 <vector85>:
.globl vector85
vector85:
  pushl $0
801059e7:	6a 00                	push   $0x0
  pushl $85
801059e9:	6a 55                	push   $0x55
  jmp alltraps
801059eb:	e9 ce f8 ff ff       	jmp    801052be <alltraps>

801059f0 <vector86>:
.globl vector86
vector86:
  pushl $0
801059f0:	6a 00                	push   $0x0
  pushl $86
801059f2:	6a 56                	push   $0x56
  jmp alltraps
801059f4:	e9 c5 f8 ff ff       	jmp    801052be <alltraps>

801059f9 <vector87>:
.globl vector87
vector87:
  pushl $0
801059f9:	6a 00                	push   $0x0
  pushl $87
801059fb:	6a 57                	push   $0x57
  jmp alltraps
801059fd:	e9 bc f8 ff ff       	jmp    801052be <alltraps>

80105a02 <vector88>:
.globl vector88
vector88:
  pushl $0
80105a02:	6a 00                	push   $0x0
  pushl $88
80105a04:	6a 58                	push   $0x58
  jmp alltraps
80105a06:	e9 b3 f8 ff ff       	jmp    801052be <alltraps>

80105a0b <vector89>:
.globl vector89
vector89:
  pushl $0
80105a0b:	6a 00                	push   $0x0
  pushl $89
80105a0d:	6a 59                	push   $0x59
  jmp alltraps
80105a0f:	e9 aa f8 ff ff       	jmp    801052be <alltraps>

80105a14 <vector90>:
.globl vector90
vector90:
  pushl $0
80105a14:	6a 00                	push   $0x0
  pushl $90
80105a16:	6a 5a                	push   $0x5a
  jmp alltraps
80105a18:	e9 a1 f8 ff ff       	jmp    801052be <alltraps>

80105a1d <vector91>:
.globl vector91
vector91:
  pushl $0
80105a1d:	6a 00                	push   $0x0
  pushl $91
80105a1f:	6a 5b                	push   $0x5b
  jmp alltraps
80105a21:	e9 98 f8 ff ff       	jmp    801052be <alltraps>

80105a26 <vector92>:
.globl vector92
vector92:
  pushl $0
80105a26:	6a 00                	push   $0x0
  pushl $92
80105a28:	6a 5c                	push   $0x5c
  jmp alltraps
80105a2a:	e9 8f f8 ff ff       	jmp    801052be <alltraps>

80105a2f <vector93>:
.globl vector93
vector93:
  pushl $0
80105a2f:	6a 00                	push   $0x0
  pushl $93
80105a31:	6a 5d                	push   $0x5d
  jmp alltraps
80105a33:	e9 86 f8 ff ff       	jmp    801052be <alltraps>

80105a38 <vector94>:
.globl vector94
vector94:
  pushl $0
80105a38:	6a 00                	push   $0x0
  pushl $94
80105a3a:	6a 5e                	push   $0x5e
  jmp alltraps
80105a3c:	e9 7d f8 ff ff       	jmp    801052be <alltraps>

80105a41 <vector95>:
.globl vector95
vector95:
  pushl $0
80105a41:	6a 00                	push   $0x0
  pushl $95
80105a43:	6a 5f                	push   $0x5f
  jmp alltraps
80105a45:	e9 74 f8 ff ff       	jmp    801052be <alltraps>

80105a4a <vector96>:
.globl vector96
vector96:
  pushl $0
80105a4a:	6a 00                	push   $0x0
  pushl $96
80105a4c:	6a 60                	push   $0x60
  jmp alltraps
80105a4e:	e9 6b f8 ff ff       	jmp    801052be <alltraps>

80105a53 <vector97>:
.globl vector97
vector97:
  pushl $0
80105a53:	6a 00                	push   $0x0
  pushl $97
80105a55:	6a 61                	push   $0x61
  jmp alltraps
80105a57:	e9 62 f8 ff ff       	jmp    801052be <alltraps>

80105a5c <vector98>:
.globl vector98
vector98:
  pushl $0
80105a5c:	6a 00                	push   $0x0
  pushl $98
80105a5e:	6a 62                	push   $0x62
  jmp alltraps
80105a60:	e9 59 f8 ff ff       	jmp    801052be <alltraps>

80105a65 <vector99>:
.globl vector99
vector99:
  pushl $0
80105a65:	6a 00                	push   $0x0
  pushl $99
80105a67:	6a 63                	push   $0x63
  jmp alltraps
80105a69:	e9 50 f8 ff ff       	jmp    801052be <alltraps>

80105a6e <vector100>:
.globl vector100
vector100:
  pushl $0
80105a6e:	6a 00                	push   $0x0
  pushl $100
80105a70:	6a 64                	push   $0x64
  jmp alltraps
80105a72:	e9 47 f8 ff ff       	jmp    801052be <alltraps>

80105a77 <vector101>:
.globl vector101
vector101:
  pushl $0
80105a77:	6a 00                	push   $0x0
  pushl $101
80105a79:	6a 65                	push   $0x65
  jmp alltraps
80105a7b:	e9 3e f8 ff ff       	jmp    801052be <alltraps>

80105a80 <vector102>:
.globl vector102
vector102:
  pushl $0
80105a80:	6a 00                	push   $0x0
  pushl $102
80105a82:	6a 66                	push   $0x66
  jmp alltraps
80105a84:	e9 35 f8 ff ff       	jmp    801052be <alltraps>

80105a89 <vector103>:
.globl vector103
vector103:
  pushl $0
80105a89:	6a 00                	push   $0x0
  pushl $103
80105a8b:	6a 67                	push   $0x67
  jmp alltraps
80105a8d:	e9 2c f8 ff ff       	jmp    801052be <alltraps>

80105a92 <vector104>:
.globl vector104
vector104:
  pushl $0
80105a92:	6a 00                	push   $0x0
  pushl $104
80105a94:	6a 68                	push   $0x68
  jmp alltraps
80105a96:	e9 23 f8 ff ff       	jmp    801052be <alltraps>

80105a9b <vector105>:
.globl vector105
vector105:
  pushl $0
80105a9b:	6a 00                	push   $0x0
  pushl $105
80105a9d:	6a 69                	push   $0x69
  jmp alltraps
80105a9f:	e9 1a f8 ff ff       	jmp    801052be <alltraps>

80105aa4 <vector106>:
.globl vector106
vector106:
  pushl $0
80105aa4:	6a 00                	push   $0x0
  pushl $106
80105aa6:	6a 6a                	push   $0x6a
  jmp alltraps
80105aa8:	e9 11 f8 ff ff       	jmp    801052be <alltraps>

80105aad <vector107>:
.globl vector107
vector107:
  pushl $0
80105aad:	6a 00                	push   $0x0
  pushl $107
80105aaf:	6a 6b                	push   $0x6b
  jmp alltraps
80105ab1:	e9 08 f8 ff ff       	jmp    801052be <alltraps>

80105ab6 <vector108>:
.globl vector108
vector108:
  pushl $0
80105ab6:	6a 00                	push   $0x0
  pushl $108
80105ab8:	6a 6c                	push   $0x6c
  jmp alltraps
80105aba:	e9 ff f7 ff ff       	jmp    801052be <alltraps>

80105abf <vector109>:
.globl vector109
vector109:
  pushl $0
80105abf:	6a 00                	push   $0x0
  pushl $109
80105ac1:	6a 6d                	push   $0x6d
  jmp alltraps
80105ac3:	e9 f6 f7 ff ff       	jmp    801052be <alltraps>

80105ac8 <vector110>:
.globl vector110
vector110:
  pushl $0
80105ac8:	6a 00                	push   $0x0
  pushl $110
80105aca:	6a 6e                	push   $0x6e
  jmp alltraps
80105acc:	e9 ed f7 ff ff       	jmp    801052be <alltraps>

80105ad1 <vector111>:
.globl vector111
vector111:
  pushl $0
80105ad1:	6a 00                	push   $0x0
  pushl $111
80105ad3:	6a 6f                	push   $0x6f
  jmp alltraps
80105ad5:	e9 e4 f7 ff ff       	jmp    801052be <alltraps>

80105ada <vector112>:
.globl vector112
vector112:
  pushl $0
80105ada:	6a 00                	push   $0x0
  pushl $112
80105adc:	6a 70                	push   $0x70
  jmp alltraps
80105ade:	e9 db f7 ff ff       	jmp    801052be <alltraps>

80105ae3 <vector113>:
.globl vector113
vector113:
  pushl $0
80105ae3:	6a 00                	push   $0x0
  pushl $113
80105ae5:	6a 71                	push   $0x71
  jmp alltraps
80105ae7:	e9 d2 f7 ff ff       	jmp    801052be <alltraps>

80105aec <vector114>:
.globl vector114
vector114:
  pushl $0
80105aec:	6a 00                	push   $0x0
  pushl $114
80105aee:	6a 72                	push   $0x72
  jmp alltraps
80105af0:	e9 c9 f7 ff ff       	jmp    801052be <alltraps>

80105af5 <vector115>:
.globl vector115
vector115:
  pushl $0
80105af5:	6a 00                	push   $0x0
  pushl $115
80105af7:	6a 73                	push   $0x73
  jmp alltraps
80105af9:	e9 c0 f7 ff ff       	jmp    801052be <alltraps>

80105afe <vector116>:
.globl vector116
vector116:
  pushl $0
80105afe:	6a 00                	push   $0x0
  pushl $116
80105b00:	6a 74                	push   $0x74
  jmp alltraps
80105b02:	e9 b7 f7 ff ff       	jmp    801052be <alltraps>

80105b07 <vector117>:
.globl vector117
vector117:
  pushl $0
80105b07:	6a 00                	push   $0x0
  pushl $117
80105b09:	6a 75                	push   $0x75
  jmp alltraps
80105b0b:	e9 ae f7 ff ff       	jmp    801052be <alltraps>

80105b10 <vector118>:
.globl vector118
vector118:
  pushl $0
80105b10:	6a 00                	push   $0x0
  pushl $118
80105b12:	6a 76                	push   $0x76
  jmp alltraps
80105b14:	e9 a5 f7 ff ff       	jmp    801052be <alltraps>

80105b19 <vector119>:
.globl vector119
vector119:
  pushl $0
80105b19:	6a 00                	push   $0x0
  pushl $119
80105b1b:	6a 77                	push   $0x77
  jmp alltraps
80105b1d:	e9 9c f7 ff ff       	jmp    801052be <alltraps>

80105b22 <vector120>:
.globl vector120
vector120:
  pushl $0
80105b22:	6a 00                	push   $0x0
  pushl $120
80105b24:	6a 78                	push   $0x78
  jmp alltraps
80105b26:	e9 93 f7 ff ff       	jmp    801052be <alltraps>

80105b2b <vector121>:
.globl vector121
vector121:
  pushl $0
80105b2b:	6a 00                	push   $0x0
  pushl $121
80105b2d:	6a 79                	push   $0x79
  jmp alltraps
80105b2f:	e9 8a f7 ff ff       	jmp    801052be <alltraps>

80105b34 <vector122>:
.globl vector122
vector122:
  pushl $0
80105b34:	6a 00                	push   $0x0
  pushl $122
80105b36:	6a 7a                	push   $0x7a
  jmp alltraps
80105b38:	e9 81 f7 ff ff       	jmp    801052be <alltraps>

80105b3d <vector123>:
.globl vector123
vector123:
  pushl $0
80105b3d:	6a 00                	push   $0x0
  pushl $123
80105b3f:	6a 7b                	push   $0x7b
  jmp alltraps
80105b41:	e9 78 f7 ff ff       	jmp    801052be <alltraps>

80105b46 <vector124>:
.globl vector124
vector124:
  pushl $0
80105b46:	6a 00                	push   $0x0
  pushl $124
80105b48:	6a 7c                	push   $0x7c
  jmp alltraps
80105b4a:	e9 6f f7 ff ff       	jmp    801052be <alltraps>

80105b4f <vector125>:
.globl vector125
vector125:
  pushl $0
80105b4f:	6a 00                	push   $0x0
  pushl $125
80105b51:	6a 7d                	push   $0x7d
  jmp alltraps
80105b53:	e9 66 f7 ff ff       	jmp    801052be <alltraps>

80105b58 <vector126>:
.globl vector126
vector126:
  pushl $0
80105b58:	6a 00                	push   $0x0
  pushl $126
80105b5a:	6a 7e                	push   $0x7e
  jmp alltraps
80105b5c:	e9 5d f7 ff ff       	jmp    801052be <alltraps>

80105b61 <vector127>:
.globl vector127
vector127:
  pushl $0
80105b61:	6a 00                	push   $0x0
  pushl $127
80105b63:	6a 7f                	push   $0x7f
  jmp alltraps
80105b65:	e9 54 f7 ff ff       	jmp    801052be <alltraps>

80105b6a <vector128>:
.globl vector128
vector128:
  pushl $0
80105b6a:	6a 00                	push   $0x0
  pushl $128
80105b6c:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105b71:	e9 48 f7 ff ff       	jmp    801052be <alltraps>

80105b76 <vector129>:
.globl vector129
vector129:
  pushl $0
80105b76:	6a 00                	push   $0x0
  pushl $129
80105b78:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105b7d:	e9 3c f7 ff ff       	jmp    801052be <alltraps>

80105b82 <vector130>:
.globl vector130
vector130:
  pushl $0
80105b82:	6a 00                	push   $0x0
  pushl $130
80105b84:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105b89:	e9 30 f7 ff ff       	jmp    801052be <alltraps>

80105b8e <vector131>:
.globl vector131
vector131:
  pushl $0
80105b8e:	6a 00                	push   $0x0
  pushl $131
80105b90:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105b95:	e9 24 f7 ff ff       	jmp    801052be <alltraps>

80105b9a <vector132>:
.globl vector132
vector132:
  pushl $0
80105b9a:	6a 00                	push   $0x0
  pushl $132
80105b9c:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105ba1:	e9 18 f7 ff ff       	jmp    801052be <alltraps>

80105ba6 <vector133>:
.globl vector133
vector133:
  pushl $0
80105ba6:	6a 00                	push   $0x0
  pushl $133
80105ba8:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105bad:	e9 0c f7 ff ff       	jmp    801052be <alltraps>

80105bb2 <vector134>:
.globl vector134
vector134:
  pushl $0
80105bb2:	6a 00                	push   $0x0
  pushl $134
80105bb4:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105bb9:	e9 00 f7 ff ff       	jmp    801052be <alltraps>

80105bbe <vector135>:
.globl vector135
vector135:
  pushl $0
80105bbe:	6a 00                	push   $0x0
  pushl $135
80105bc0:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105bc5:	e9 f4 f6 ff ff       	jmp    801052be <alltraps>

80105bca <vector136>:
.globl vector136
vector136:
  pushl $0
80105bca:	6a 00                	push   $0x0
  pushl $136
80105bcc:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105bd1:	e9 e8 f6 ff ff       	jmp    801052be <alltraps>

80105bd6 <vector137>:
.globl vector137
vector137:
  pushl $0
80105bd6:	6a 00                	push   $0x0
  pushl $137
80105bd8:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105bdd:	e9 dc f6 ff ff       	jmp    801052be <alltraps>

80105be2 <vector138>:
.globl vector138
vector138:
  pushl $0
80105be2:	6a 00                	push   $0x0
  pushl $138
80105be4:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105be9:	e9 d0 f6 ff ff       	jmp    801052be <alltraps>

80105bee <vector139>:
.globl vector139
vector139:
  pushl $0
80105bee:	6a 00                	push   $0x0
  pushl $139
80105bf0:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105bf5:	e9 c4 f6 ff ff       	jmp    801052be <alltraps>

80105bfa <vector140>:
.globl vector140
vector140:
  pushl $0
80105bfa:	6a 00                	push   $0x0
  pushl $140
80105bfc:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105c01:	e9 b8 f6 ff ff       	jmp    801052be <alltraps>

80105c06 <vector141>:
.globl vector141
vector141:
  pushl $0
80105c06:	6a 00                	push   $0x0
  pushl $141
80105c08:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105c0d:	e9 ac f6 ff ff       	jmp    801052be <alltraps>

80105c12 <vector142>:
.globl vector142
vector142:
  pushl $0
80105c12:	6a 00                	push   $0x0
  pushl $142
80105c14:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105c19:	e9 a0 f6 ff ff       	jmp    801052be <alltraps>

80105c1e <vector143>:
.globl vector143
vector143:
  pushl $0
80105c1e:	6a 00                	push   $0x0
  pushl $143
80105c20:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105c25:	e9 94 f6 ff ff       	jmp    801052be <alltraps>

80105c2a <vector144>:
.globl vector144
vector144:
  pushl $0
80105c2a:	6a 00                	push   $0x0
  pushl $144
80105c2c:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105c31:	e9 88 f6 ff ff       	jmp    801052be <alltraps>

80105c36 <vector145>:
.globl vector145
vector145:
  pushl $0
80105c36:	6a 00                	push   $0x0
  pushl $145
80105c38:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105c3d:	e9 7c f6 ff ff       	jmp    801052be <alltraps>

80105c42 <vector146>:
.globl vector146
vector146:
  pushl $0
80105c42:	6a 00                	push   $0x0
  pushl $146
80105c44:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105c49:	e9 70 f6 ff ff       	jmp    801052be <alltraps>

80105c4e <vector147>:
.globl vector147
vector147:
  pushl $0
80105c4e:	6a 00                	push   $0x0
  pushl $147
80105c50:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105c55:	e9 64 f6 ff ff       	jmp    801052be <alltraps>

80105c5a <vector148>:
.globl vector148
vector148:
  pushl $0
80105c5a:	6a 00                	push   $0x0
  pushl $148
80105c5c:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105c61:	e9 58 f6 ff ff       	jmp    801052be <alltraps>

80105c66 <vector149>:
.globl vector149
vector149:
  pushl $0
80105c66:	6a 00                	push   $0x0
  pushl $149
80105c68:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105c6d:	e9 4c f6 ff ff       	jmp    801052be <alltraps>

80105c72 <vector150>:
.globl vector150
vector150:
  pushl $0
80105c72:	6a 00                	push   $0x0
  pushl $150
80105c74:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105c79:	e9 40 f6 ff ff       	jmp    801052be <alltraps>

80105c7e <vector151>:
.globl vector151
vector151:
  pushl $0
80105c7e:	6a 00                	push   $0x0
  pushl $151
80105c80:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105c85:	e9 34 f6 ff ff       	jmp    801052be <alltraps>

80105c8a <vector152>:
.globl vector152
vector152:
  pushl $0
80105c8a:	6a 00                	push   $0x0
  pushl $152
80105c8c:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105c91:	e9 28 f6 ff ff       	jmp    801052be <alltraps>

80105c96 <vector153>:
.globl vector153
vector153:
  pushl $0
80105c96:	6a 00                	push   $0x0
  pushl $153
80105c98:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105c9d:	e9 1c f6 ff ff       	jmp    801052be <alltraps>

80105ca2 <vector154>:
.globl vector154
vector154:
  pushl $0
80105ca2:	6a 00                	push   $0x0
  pushl $154
80105ca4:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105ca9:	e9 10 f6 ff ff       	jmp    801052be <alltraps>

80105cae <vector155>:
.globl vector155
vector155:
  pushl $0
80105cae:	6a 00                	push   $0x0
  pushl $155
80105cb0:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105cb5:	e9 04 f6 ff ff       	jmp    801052be <alltraps>

80105cba <vector156>:
.globl vector156
vector156:
  pushl $0
80105cba:	6a 00                	push   $0x0
  pushl $156
80105cbc:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105cc1:	e9 f8 f5 ff ff       	jmp    801052be <alltraps>

80105cc6 <vector157>:
.globl vector157
vector157:
  pushl $0
80105cc6:	6a 00                	push   $0x0
  pushl $157
80105cc8:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105ccd:	e9 ec f5 ff ff       	jmp    801052be <alltraps>

80105cd2 <vector158>:
.globl vector158
vector158:
  pushl $0
80105cd2:	6a 00                	push   $0x0
  pushl $158
80105cd4:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105cd9:	e9 e0 f5 ff ff       	jmp    801052be <alltraps>

80105cde <vector159>:
.globl vector159
vector159:
  pushl $0
80105cde:	6a 00                	push   $0x0
  pushl $159
80105ce0:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105ce5:	e9 d4 f5 ff ff       	jmp    801052be <alltraps>

80105cea <vector160>:
.globl vector160
vector160:
  pushl $0
80105cea:	6a 00                	push   $0x0
  pushl $160
80105cec:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105cf1:	e9 c8 f5 ff ff       	jmp    801052be <alltraps>

80105cf6 <vector161>:
.globl vector161
vector161:
  pushl $0
80105cf6:	6a 00                	push   $0x0
  pushl $161
80105cf8:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105cfd:	e9 bc f5 ff ff       	jmp    801052be <alltraps>

80105d02 <vector162>:
.globl vector162
vector162:
  pushl $0
80105d02:	6a 00                	push   $0x0
  pushl $162
80105d04:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105d09:	e9 b0 f5 ff ff       	jmp    801052be <alltraps>

80105d0e <vector163>:
.globl vector163
vector163:
  pushl $0
80105d0e:	6a 00                	push   $0x0
  pushl $163
80105d10:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105d15:	e9 a4 f5 ff ff       	jmp    801052be <alltraps>

80105d1a <vector164>:
.globl vector164
vector164:
  pushl $0
80105d1a:	6a 00                	push   $0x0
  pushl $164
80105d1c:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105d21:	e9 98 f5 ff ff       	jmp    801052be <alltraps>

80105d26 <vector165>:
.globl vector165
vector165:
  pushl $0
80105d26:	6a 00                	push   $0x0
  pushl $165
80105d28:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105d2d:	e9 8c f5 ff ff       	jmp    801052be <alltraps>

80105d32 <vector166>:
.globl vector166
vector166:
  pushl $0
80105d32:	6a 00                	push   $0x0
  pushl $166
80105d34:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105d39:	e9 80 f5 ff ff       	jmp    801052be <alltraps>

80105d3e <vector167>:
.globl vector167
vector167:
  pushl $0
80105d3e:	6a 00                	push   $0x0
  pushl $167
80105d40:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105d45:	e9 74 f5 ff ff       	jmp    801052be <alltraps>

80105d4a <vector168>:
.globl vector168
vector168:
  pushl $0
80105d4a:	6a 00                	push   $0x0
  pushl $168
80105d4c:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105d51:	e9 68 f5 ff ff       	jmp    801052be <alltraps>

80105d56 <vector169>:
.globl vector169
vector169:
  pushl $0
80105d56:	6a 00                	push   $0x0
  pushl $169
80105d58:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105d5d:	e9 5c f5 ff ff       	jmp    801052be <alltraps>

80105d62 <vector170>:
.globl vector170
vector170:
  pushl $0
80105d62:	6a 00                	push   $0x0
  pushl $170
80105d64:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105d69:	e9 50 f5 ff ff       	jmp    801052be <alltraps>

80105d6e <vector171>:
.globl vector171
vector171:
  pushl $0
80105d6e:	6a 00                	push   $0x0
  pushl $171
80105d70:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105d75:	e9 44 f5 ff ff       	jmp    801052be <alltraps>

80105d7a <vector172>:
.globl vector172
vector172:
  pushl $0
80105d7a:	6a 00                	push   $0x0
  pushl $172
80105d7c:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105d81:	e9 38 f5 ff ff       	jmp    801052be <alltraps>

80105d86 <vector173>:
.globl vector173
vector173:
  pushl $0
80105d86:	6a 00                	push   $0x0
  pushl $173
80105d88:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105d8d:	e9 2c f5 ff ff       	jmp    801052be <alltraps>

80105d92 <vector174>:
.globl vector174
vector174:
  pushl $0
80105d92:	6a 00                	push   $0x0
  pushl $174
80105d94:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105d99:	e9 20 f5 ff ff       	jmp    801052be <alltraps>

80105d9e <vector175>:
.globl vector175
vector175:
  pushl $0
80105d9e:	6a 00                	push   $0x0
  pushl $175
80105da0:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105da5:	e9 14 f5 ff ff       	jmp    801052be <alltraps>

80105daa <vector176>:
.globl vector176
vector176:
  pushl $0
80105daa:	6a 00                	push   $0x0
  pushl $176
80105dac:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105db1:	e9 08 f5 ff ff       	jmp    801052be <alltraps>

80105db6 <vector177>:
.globl vector177
vector177:
  pushl $0
80105db6:	6a 00                	push   $0x0
  pushl $177
80105db8:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105dbd:	e9 fc f4 ff ff       	jmp    801052be <alltraps>

80105dc2 <vector178>:
.globl vector178
vector178:
  pushl $0
80105dc2:	6a 00                	push   $0x0
  pushl $178
80105dc4:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105dc9:	e9 f0 f4 ff ff       	jmp    801052be <alltraps>

80105dce <vector179>:
.globl vector179
vector179:
  pushl $0
80105dce:	6a 00                	push   $0x0
  pushl $179
80105dd0:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105dd5:	e9 e4 f4 ff ff       	jmp    801052be <alltraps>

80105dda <vector180>:
.globl vector180
vector180:
  pushl $0
80105dda:	6a 00                	push   $0x0
  pushl $180
80105ddc:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105de1:	e9 d8 f4 ff ff       	jmp    801052be <alltraps>

80105de6 <vector181>:
.globl vector181
vector181:
  pushl $0
80105de6:	6a 00                	push   $0x0
  pushl $181
80105de8:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105ded:	e9 cc f4 ff ff       	jmp    801052be <alltraps>

80105df2 <vector182>:
.globl vector182
vector182:
  pushl $0
80105df2:	6a 00                	push   $0x0
  pushl $182
80105df4:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105df9:	e9 c0 f4 ff ff       	jmp    801052be <alltraps>

80105dfe <vector183>:
.globl vector183
vector183:
  pushl $0
80105dfe:	6a 00                	push   $0x0
  pushl $183
80105e00:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105e05:	e9 b4 f4 ff ff       	jmp    801052be <alltraps>

80105e0a <vector184>:
.globl vector184
vector184:
  pushl $0
80105e0a:	6a 00                	push   $0x0
  pushl $184
80105e0c:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105e11:	e9 a8 f4 ff ff       	jmp    801052be <alltraps>

80105e16 <vector185>:
.globl vector185
vector185:
  pushl $0
80105e16:	6a 00                	push   $0x0
  pushl $185
80105e18:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105e1d:	e9 9c f4 ff ff       	jmp    801052be <alltraps>

80105e22 <vector186>:
.globl vector186
vector186:
  pushl $0
80105e22:	6a 00                	push   $0x0
  pushl $186
80105e24:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105e29:	e9 90 f4 ff ff       	jmp    801052be <alltraps>

80105e2e <vector187>:
.globl vector187
vector187:
  pushl $0
80105e2e:	6a 00                	push   $0x0
  pushl $187
80105e30:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105e35:	e9 84 f4 ff ff       	jmp    801052be <alltraps>

80105e3a <vector188>:
.globl vector188
vector188:
  pushl $0
80105e3a:	6a 00                	push   $0x0
  pushl $188
80105e3c:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105e41:	e9 78 f4 ff ff       	jmp    801052be <alltraps>

80105e46 <vector189>:
.globl vector189
vector189:
  pushl $0
80105e46:	6a 00                	push   $0x0
  pushl $189
80105e48:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105e4d:	e9 6c f4 ff ff       	jmp    801052be <alltraps>

80105e52 <vector190>:
.globl vector190
vector190:
  pushl $0
80105e52:	6a 00                	push   $0x0
  pushl $190
80105e54:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105e59:	e9 60 f4 ff ff       	jmp    801052be <alltraps>

80105e5e <vector191>:
.globl vector191
vector191:
  pushl $0
80105e5e:	6a 00                	push   $0x0
  pushl $191
80105e60:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105e65:	e9 54 f4 ff ff       	jmp    801052be <alltraps>

80105e6a <vector192>:
.globl vector192
vector192:
  pushl $0
80105e6a:	6a 00                	push   $0x0
  pushl $192
80105e6c:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105e71:	e9 48 f4 ff ff       	jmp    801052be <alltraps>

80105e76 <vector193>:
.globl vector193
vector193:
  pushl $0
80105e76:	6a 00                	push   $0x0
  pushl $193
80105e78:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105e7d:	e9 3c f4 ff ff       	jmp    801052be <alltraps>

80105e82 <vector194>:
.globl vector194
vector194:
  pushl $0
80105e82:	6a 00                	push   $0x0
  pushl $194
80105e84:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105e89:	e9 30 f4 ff ff       	jmp    801052be <alltraps>

80105e8e <vector195>:
.globl vector195
vector195:
  pushl $0
80105e8e:	6a 00                	push   $0x0
  pushl $195
80105e90:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105e95:	e9 24 f4 ff ff       	jmp    801052be <alltraps>

80105e9a <vector196>:
.globl vector196
vector196:
  pushl $0
80105e9a:	6a 00                	push   $0x0
  pushl $196
80105e9c:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105ea1:	e9 18 f4 ff ff       	jmp    801052be <alltraps>

80105ea6 <vector197>:
.globl vector197
vector197:
  pushl $0
80105ea6:	6a 00                	push   $0x0
  pushl $197
80105ea8:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105ead:	e9 0c f4 ff ff       	jmp    801052be <alltraps>

80105eb2 <vector198>:
.globl vector198
vector198:
  pushl $0
80105eb2:	6a 00                	push   $0x0
  pushl $198
80105eb4:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105eb9:	e9 00 f4 ff ff       	jmp    801052be <alltraps>

80105ebe <vector199>:
.globl vector199
vector199:
  pushl $0
80105ebe:	6a 00                	push   $0x0
  pushl $199
80105ec0:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105ec5:	e9 f4 f3 ff ff       	jmp    801052be <alltraps>

80105eca <vector200>:
.globl vector200
vector200:
  pushl $0
80105eca:	6a 00                	push   $0x0
  pushl $200
80105ecc:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105ed1:	e9 e8 f3 ff ff       	jmp    801052be <alltraps>

80105ed6 <vector201>:
.globl vector201
vector201:
  pushl $0
80105ed6:	6a 00                	push   $0x0
  pushl $201
80105ed8:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105edd:	e9 dc f3 ff ff       	jmp    801052be <alltraps>

80105ee2 <vector202>:
.globl vector202
vector202:
  pushl $0
80105ee2:	6a 00                	push   $0x0
  pushl $202
80105ee4:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105ee9:	e9 d0 f3 ff ff       	jmp    801052be <alltraps>

80105eee <vector203>:
.globl vector203
vector203:
  pushl $0
80105eee:	6a 00                	push   $0x0
  pushl $203
80105ef0:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105ef5:	e9 c4 f3 ff ff       	jmp    801052be <alltraps>

80105efa <vector204>:
.globl vector204
vector204:
  pushl $0
80105efa:	6a 00                	push   $0x0
  pushl $204
80105efc:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105f01:	e9 b8 f3 ff ff       	jmp    801052be <alltraps>

80105f06 <vector205>:
.globl vector205
vector205:
  pushl $0
80105f06:	6a 00                	push   $0x0
  pushl $205
80105f08:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105f0d:	e9 ac f3 ff ff       	jmp    801052be <alltraps>

80105f12 <vector206>:
.globl vector206
vector206:
  pushl $0
80105f12:	6a 00                	push   $0x0
  pushl $206
80105f14:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105f19:	e9 a0 f3 ff ff       	jmp    801052be <alltraps>

80105f1e <vector207>:
.globl vector207
vector207:
  pushl $0
80105f1e:	6a 00                	push   $0x0
  pushl $207
80105f20:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105f25:	e9 94 f3 ff ff       	jmp    801052be <alltraps>

80105f2a <vector208>:
.globl vector208
vector208:
  pushl $0
80105f2a:	6a 00                	push   $0x0
  pushl $208
80105f2c:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105f31:	e9 88 f3 ff ff       	jmp    801052be <alltraps>

80105f36 <vector209>:
.globl vector209
vector209:
  pushl $0
80105f36:	6a 00                	push   $0x0
  pushl $209
80105f38:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105f3d:	e9 7c f3 ff ff       	jmp    801052be <alltraps>

80105f42 <vector210>:
.globl vector210
vector210:
  pushl $0
80105f42:	6a 00                	push   $0x0
  pushl $210
80105f44:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105f49:	e9 70 f3 ff ff       	jmp    801052be <alltraps>

80105f4e <vector211>:
.globl vector211
vector211:
  pushl $0
80105f4e:	6a 00                	push   $0x0
  pushl $211
80105f50:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105f55:	e9 64 f3 ff ff       	jmp    801052be <alltraps>

80105f5a <vector212>:
.globl vector212
vector212:
  pushl $0
80105f5a:	6a 00                	push   $0x0
  pushl $212
80105f5c:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105f61:	e9 58 f3 ff ff       	jmp    801052be <alltraps>

80105f66 <vector213>:
.globl vector213
vector213:
  pushl $0
80105f66:	6a 00                	push   $0x0
  pushl $213
80105f68:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105f6d:	e9 4c f3 ff ff       	jmp    801052be <alltraps>

80105f72 <vector214>:
.globl vector214
vector214:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $214
80105f74:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105f79:	e9 40 f3 ff ff       	jmp    801052be <alltraps>

80105f7e <vector215>:
.globl vector215
vector215:
  pushl $0
80105f7e:	6a 00                	push   $0x0
  pushl $215
80105f80:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105f85:	e9 34 f3 ff ff       	jmp    801052be <alltraps>

80105f8a <vector216>:
.globl vector216
vector216:
  pushl $0
80105f8a:	6a 00                	push   $0x0
  pushl $216
80105f8c:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105f91:	e9 28 f3 ff ff       	jmp    801052be <alltraps>

80105f96 <vector217>:
.globl vector217
vector217:
  pushl $0
80105f96:	6a 00                	push   $0x0
  pushl $217
80105f98:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105f9d:	e9 1c f3 ff ff       	jmp    801052be <alltraps>

80105fa2 <vector218>:
.globl vector218
vector218:
  pushl $0
80105fa2:	6a 00                	push   $0x0
  pushl $218
80105fa4:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105fa9:	e9 10 f3 ff ff       	jmp    801052be <alltraps>

80105fae <vector219>:
.globl vector219
vector219:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $219
80105fb0:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105fb5:	e9 04 f3 ff ff       	jmp    801052be <alltraps>

80105fba <vector220>:
.globl vector220
vector220:
  pushl $0
80105fba:	6a 00                	push   $0x0
  pushl $220
80105fbc:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105fc1:	e9 f8 f2 ff ff       	jmp    801052be <alltraps>

80105fc6 <vector221>:
.globl vector221
vector221:
  pushl $0
80105fc6:	6a 00                	push   $0x0
  pushl $221
80105fc8:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105fcd:	e9 ec f2 ff ff       	jmp    801052be <alltraps>

80105fd2 <vector222>:
.globl vector222
vector222:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $222
80105fd4:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105fd9:	e9 e0 f2 ff ff       	jmp    801052be <alltraps>

80105fde <vector223>:
.globl vector223
vector223:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $223
80105fe0:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80105fe5:	e9 d4 f2 ff ff       	jmp    801052be <alltraps>

80105fea <vector224>:
.globl vector224
vector224:
  pushl $0
80105fea:	6a 00                	push   $0x0
  pushl $224
80105fec:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80105ff1:	e9 c8 f2 ff ff       	jmp    801052be <alltraps>

80105ff6 <vector225>:
.globl vector225
vector225:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $225
80105ff8:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80105ffd:	e9 bc f2 ff ff       	jmp    801052be <alltraps>

80106002 <vector226>:
.globl vector226
vector226:
  pushl $0
80106002:	6a 00                	push   $0x0
  pushl $226
80106004:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106009:	e9 b0 f2 ff ff       	jmp    801052be <alltraps>

8010600e <vector227>:
.globl vector227
vector227:
  pushl $0
8010600e:	6a 00                	push   $0x0
  pushl $227
80106010:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106015:	e9 a4 f2 ff ff       	jmp    801052be <alltraps>

8010601a <vector228>:
.globl vector228
vector228:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $228
8010601c:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106021:	e9 98 f2 ff ff       	jmp    801052be <alltraps>

80106026 <vector229>:
.globl vector229
vector229:
  pushl $0
80106026:	6a 00                	push   $0x0
  pushl $229
80106028:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010602d:	e9 8c f2 ff ff       	jmp    801052be <alltraps>

80106032 <vector230>:
.globl vector230
vector230:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $230
80106034:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106039:	e9 80 f2 ff ff       	jmp    801052be <alltraps>

8010603e <vector231>:
.globl vector231
vector231:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $231
80106040:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106045:	e9 74 f2 ff ff       	jmp    801052be <alltraps>

8010604a <vector232>:
.globl vector232
vector232:
  pushl $0
8010604a:	6a 00                	push   $0x0
  pushl $232
8010604c:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106051:	e9 68 f2 ff ff       	jmp    801052be <alltraps>

80106056 <vector233>:
.globl vector233
vector233:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $233
80106058:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010605d:	e9 5c f2 ff ff       	jmp    801052be <alltraps>

80106062 <vector234>:
.globl vector234
vector234:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $234
80106064:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106069:	e9 50 f2 ff ff       	jmp    801052be <alltraps>

8010606e <vector235>:
.globl vector235
vector235:
  pushl $0
8010606e:	6a 00                	push   $0x0
  pushl $235
80106070:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106075:	e9 44 f2 ff ff       	jmp    801052be <alltraps>

8010607a <vector236>:
.globl vector236
vector236:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $236
8010607c:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106081:	e9 38 f2 ff ff       	jmp    801052be <alltraps>

80106086 <vector237>:
.globl vector237
vector237:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $237
80106088:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010608d:	e9 2c f2 ff ff       	jmp    801052be <alltraps>

80106092 <vector238>:
.globl vector238
vector238:
  pushl $0
80106092:	6a 00                	push   $0x0
  pushl $238
80106094:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106099:	e9 20 f2 ff ff       	jmp    801052be <alltraps>

8010609e <vector239>:
.globl vector239
vector239:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $239
801060a0:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801060a5:	e9 14 f2 ff ff       	jmp    801052be <alltraps>

801060aa <vector240>:
.globl vector240
vector240:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $240
801060ac:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801060b1:	e9 08 f2 ff ff       	jmp    801052be <alltraps>

801060b6 <vector241>:
.globl vector241
vector241:
  pushl $0
801060b6:	6a 00                	push   $0x0
  pushl $241
801060b8:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801060bd:	e9 fc f1 ff ff       	jmp    801052be <alltraps>

801060c2 <vector242>:
.globl vector242
vector242:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $242
801060c4:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801060c9:	e9 f0 f1 ff ff       	jmp    801052be <alltraps>

801060ce <vector243>:
.globl vector243
vector243:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $243
801060d0:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801060d5:	e9 e4 f1 ff ff       	jmp    801052be <alltraps>

801060da <vector244>:
.globl vector244
vector244:
  pushl $0
801060da:	6a 00                	push   $0x0
  pushl $244
801060dc:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801060e1:	e9 d8 f1 ff ff       	jmp    801052be <alltraps>

801060e6 <vector245>:
.globl vector245
vector245:
  pushl $0
801060e6:	6a 00                	push   $0x0
  pushl $245
801060e8:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801060ed:	e9 cc f1 ff ff       	jmp    801052be <alltraps>

801060f2 <vector246>:
.globl vector246
vector246:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $246
801060f4:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801060f9:	e9 c0 f1 ff ff       	jmp    801052be <alltraps>

801060fe <vector247>:
.globl vector247
vector247:
  pushl $0
801060fe:	6a 00                	push   $0x0
  pushl $247
80106100:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106105:	e9 b4 f1 ff ff       	jmp    801052be <alltraps>

8010610a <vector248>:
.globl vector248
vector248:
  pushl $0
8010610a:	6a 00                	push   $0x0
  pushl $248
8010610c:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106111:	e9 a8 f1 ff ff       	jmp    801052be <alltraps>

80106116 <vector249>:
.globl vector249
vector249:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $249
80106118:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010611d:	e9 9c f1 ff ff       	jmp    801052be <alltraps>

80106122 <vector250>:
.globl vector250
vector250:
  pushl $0
80106122:	6a 00                	push   $0x0
  pushl $250
80106124:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106129:	e9 90 f1 ff ff       	jmp    801052be <alltraps>

8010612e <vector251>:
.globl vector251
vector251:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $251
80106130:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106135:	e9 84 f1 ff ff       	jmp    801052be <alltraps>

8010613a <vector252>:
.globl vector252
vector252:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $252
8010613c:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106141:	e9 78 f1 ff ff       	jmp    801052be <alltraps>

80106146 <vector253>:
.globl vector253
vector253:
  pushl $0
80106146:	6a 00                	push   $0x0
  pushl $253
80106148:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010614d:	e9 6c f1 ff ff       	jmp    801052be <alltraps>

80106152 <vector254>:
.globl vector254
vector254:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $254
80106154:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106159:	e9 60 f1 ff ff       	jmp    801052be <alltraps>

8010615e <vector255>:
.globl vector255
vector255:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $255
80106160:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106165:	e9 54 f1 ff ff       	jmp    801052be <alltraps>

8010616a <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010616a:	55                   	push   %ebp
8010616b:	89 e5                	mov    %esp,%ebp
8010616d:	57                   	push   %edi
8010616e:	56                   	push   %esi
8010616f:	53                   	push   %ebx
80106170:	83 ec 0c             	sub    $0xc,%esp
80106173:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106175:	c1 ea 16             	shr    $0x16,%edx
80106178:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
8010617b:	8b 37                	mov    (%edi),%esi
8010617d:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106183:	74 20                	je     801061a5 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106185:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
8010618b:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106191:	c1 eb 0c             	shr    $0xc,%ebx
80106194:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
8010619a:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
}
8010619d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061a0:	5b                   	pop    %ebx
801061a1:	5e                   	pop    %esi
801061a2:	5f                   	pop    %edi
801061a3:	5d                   	pop    %ebp
801061a4:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801061a5:	85 c9                	test   %ecx,%ecx
801061a7:	74 2b                	je     801061d4 <walkpgdir+0x6a>
801061a9:	e8 e1 bf ff ff       	call   8010218f <kalloc>
801061ae:	89 c6                	mov    %eax,%esi
801061b0:	85 c0                	test   %eax,%eax
801061b2:	74 20                	je     801061d4 <walkpgdir+0x6a>
    memset(pgtab, 0, PGSIZE);
801061b4:	83 ec 04             	sub    $0x4,%esp
801061b7:	68 00 10 00 00       	push   $0x1000
801061bc:	6a 00                	push   $0x0
801061be:	50                   	push   %eax
801061bf:	e8 95 de ff ff       	call   80104059 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801061c4:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801061ca:	83 c8 07             	or     $0x7,%eax
801061cd:	89 07                	mov    %eax,(%edi)
801061cf:	83 c4 10             	add    $0x10,%esp
801061d2:	eb bd                	jmp    80106191 <walkpgdir+0x27>
      return 0;
801061d4:	b8 00 00 00 00       	mov    $0x0,%eax
801061d9:	eb c2                	jmp    8010619d <walkpgdir+0x33>

801061db <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801061db:	55                   	push   %ebp
801061dc:	89 e5                	mov    %esp,%ebp
801061de:	57                   	push   %edi
801061df:	56                   	push   %esi
801061e0:	53                   	push   %ebx
801061e1:	83 ec 1c             	sub    $0x1c,%esp
801061e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801061e7:	8b 75 08             	mov    0x8(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801061ea:	89 d3                	mov    %edx,%ebx
801061ec:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801061f2:	8d 7c 0a ff          	lea    -0x1(%edx,%ecx,1),%edi
801061f6:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801061fc:	b9 01 00 00 00       	mov    $0x1,%ecx
80106201:	89 da                	mov    %ebx,%edx
80106203:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106206:	e8 5f ff ff ff       	call   8010616a <walkpgdir>
8010620b:	85 c0                	test   %eax,%eax
8010620d:	74 2e                	je     8010623d <mappages+0x62>
      return -1;
    if(*pte & PTE_P)
8010620f:	f6 00 01             	testb  $0x1,(%eax)
80106212:	75 1c                	jne    80106230 <mappages+0x55>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106214:	89 f2                	mov    %esi,%edx
80106216:	0b 55 0c             	or     0xc(%ebp),%edx
80106219:	83 ca 01             	or     $0x1,%edx
8010621c:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010621e:	39 fb                	cmp    %edi,%ebx
80106220:	74 28                	je     8010624a <mappages+0x6f>
      break;
    a += PGSIZE;
80106222:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
80106228:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010622e:	eb cc                	jmp    801061fc <mappages+0x21>
      panic("remap");
80106230:	83 ec 0c             	sub    $0xc,%esp
80106233:	68 68 73 10 80       	push   $0x80107368
80106238:	e8 1f a1 ff ff       	call   8010035c <panic>
      return -1;
8010623d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106242:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106245:	5b                   	pop    %ebx
80106246:	5e                   	pop    %esi
80106247:	5f                   	pop    %edi
80106248:	5d                   	pop    %ebp
80106249:	c3                   	ret    
  return 0;
8010624a:	b8 00 00 00 00       	mov    $0x0,%eax
8010624f:	eb f1                	jmp    80106242 <mappages+0x67>

80106251 <seginit>:
{
80106251:	f3 0f 1e fb          	endbr32 
80106255:	55                   	push   %ebp
80106256:	89 e5                	mov    %esp,%ebp
80106258:	53                   	push   %ebx
80106259:	83 ec 14             	sub    $0x14,%esp
  c = &cpus[cpuid()];
8010625c:	e8 bb d0 ff ff       	call   8010331c <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106261:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106267:	66 c7 80 58 69 11 80 	movw   $0xffff,-0x7fee96a8(%eax)
8010626e:	ff ff 
80106270:	66 c7 80 5a 69 11 80 	movw   $0x0,-0x7fee96a6(%eax)
80106277:	00 00 
80106279:	c6 80 5c 69 11 80 00 	movb   $0x0,-0x7fee96a4(%eax)
80106280:	0f b6 88 5d 69 11 80 	movzbl -0x7fee96a3(%eax),%ecx
80106287:	83 e1 f0             	and    $0xfffffff0,%ecx
8010628a:	83 c9 1a             	or     $0x1a,%ecx
8010628d:	83 e1 9f             	and    $0xffffff9f,%ecx
80106290:	83 c9 80             	or     $0xffffff80,%ecx
80106293:	88 88 5d 69 11 80    	mov    %cl,-0x7fee96a3(%eax)
80106299:	0f b6 88 5e 69 11 80 	movzbl -0x7fee96a2(%eax),%ecx
801062a0:	83 c9 0f             	or     $0xf,%ecx
801062a3:	83 e1 cf             	and    $0xffffffcf,%ecx
801062a6:	83 c9 c0             	or     $0xffffffc0,%ecx
801062a9:	88 88 5e 69 11 80    	mov    %cl,-0x7fee96a2(%eax)
801062af:	c6 80 5f 69 11 80 00 	movb   $0x0,-0x7fee96a1(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801062b6:	66 c7 80 60 69 11 80 	movw   $0xffff,-0x7fee96a0(%eax)
801062bd:	ff ff 
801062bf:	66 c7 80 62 69 11 80 	movw   $0x0,-0x7fee969e(%eax)
801062c6:	00 00 
801062c8:	c6 80 64 69 11 80 00 	movb   $0x0,-0x7fee969c(%eax)
801062cf:	0f b6 88 65 69 11 80 	movzbl -0x7fee969b(%eax),%ecx
801062d6:	83 e1 f0             	and    $0xfffffff0,%ecx
801062d9:	83 c9 12             	or     $0x12,%ecx
801062dc:	83 e1 9f             	and    $0xffffff9f,%ecx
801062df:	83 c9 80             	or     $0xffffff80,%ecx
801062e2:	88 88 65 69 11 80    	mov    %cl,-0x7fee969b(%eax)
801062e8:	0f b6 88 66 69 11 80 	movzbl -0x7fee969a(%eax),%ecx
801062ef:	83 c9 0f             	or     $0xf,%ecx
801062f2:	83 e1 cf             	and    $0xffffffcf,%ecx
801062f5:	83 c9 c0             	or     $0xffffffc0,%ecx
801062f8:	88 88 66 69 11 80    	mov    %cl,-0x7fee969a(%eax)
801062fe:	c6 80 67 69 11 80 00 	movb   $0x0,-0x7fee9699(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106305:	66 c7 80 68 69 11 80 	movw   $0xffff,-0x7fee9698(%eax)
8010630c:	ff ff 
8010630e:	66 c7 80 6a 69 11 80 	movw   $0x0,-0x7fee9696(%eax)
80106315:	00 00 
80106317:	c6 80 6c 69 11 80 00 	movb   $0x0,-0x7fee9694(%eax)
8010631e:	c6 80 6d 69 11 80 fa 	movb   $0xfa,-0x7fee9693(%eax)
80106325:	0f b6 88 6e 69 11 80 	movzbl -0x7fee9692(%eax),%ecx
8010632c:	83 c9 0f             	or     $0xf,%ecx
8010632f:	83 e1 cf             	and    $0xffffffcf,%ecx
80106332:	83 c9 c0             	or     $0xffffffc0,%ecx
80106335:	88 88 6e 69 11 80    	mov    %cl,-0x7fee9692(%eax)
8010633b:	c6 80 6f 69 11 80 00 	movb   $0x0,-0x7fee9691(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106342:	66 c7 80 70 69 11 80 	movw   $0xffff,-0x7fee9690(%eax)
80106349:	ff ff 
8010634b:	66 c7 80 72 69 11 80 	movw   $0x0,-0x7fee968e(%eax)
80106352:	00 00 
80106354:	c6 80 74 69 11 80 00 	movb   $0x0,-0x7fee968c(%eax)
8010635b:	c6 80 75 69 11 80 f2 	movb   $0xf2,-0x7fee968b(%eax)
80106362:	0f b6 88 76 69 11 80 	movzbl -0x7fee968a(%eax),%ecx
80106369:	83 c9 0f             	or     $0xf,%ecx
8010636c:	83 e1 cf             	and    $0xffffffcf,%ecx
8010636f:	83 c9 c0             	or     $0xffffffc0,%ecx
80106372:	88 88 76 69 11 80    	mov    %cl,-0x7fee968a(%eax)
80106378:	c6 80 77 69 11 80 00 	movb   $0x0,-0x7fee9689(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010637f:	05 50 69 11 80       	add    $0x80116950,%eax
  pd[0] = size-1;
80106384:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
8010638a:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
8010638e:	c1 e8 10             	shr    $0x10,%eax
80106391:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106395:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106398:	0f 01 10             	lgdtl  (%eax)
}
8010639b:	83 c4 14             	add    $0x14,%esp
8010639e:	5b                   	pop    %ebx
8010639f:	5d                   	pop    %ebp
801063a0:	c3                   	ret    

801063a1 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801063a1:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801063a5:	a1 84 76 11 80       	mov    0x80117684,%eax
801063aa:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801063af:	0f 22 d8             	mov    %eax,%cr3
}
801063b2:	c3                   	ret    

801063b3 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801063b3:	f3 0f 1e fb          	endbr32 
801063b7:	55                   	push   %ebp
801063b8:	89 e5                	mov    %esp,%ebp
801063ba:	57                   	push   %edi
801063bb:	56                   	push   %esi
801063bc:	53                   	push   %ebx
801063bd:	83 ec 1c             	sub    $0x1c,%esp
801063c0:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801063c3:	85 f6                	test   %esi,%esi
801063c5:	0f 84 dd 00 00 00    	je     801064a8 <switchuvm+0xf5>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801063cb:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
801063cf:	0f 84 e0 00 00 00    	je     801064b5 <switchuvm+0x102>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801063d5:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
801063d9:	0f 84 e3 00 00 00    	je     801064c2 <switchuvm+0x10f>
    panic("switchuvm: no pgdir");

  pushcli();
801063df:	e8 d8 da ff ff       	call   80103ebc <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801063e4:	e8 d3 ce ff ff       	call   801032bc <mycpu>
801063e9:	89 c3                	mov    %eax,%ebx
801063eb:	e8 cc ce ff ff       	call   801032bc <mycpu>
801063f0:	8d 78 08             	lea    0x8(%eax),%edi
801063f3:	e8 c4 ce ff ff       	call   801032bc <mycpu>
801063f8:	83 c0 08             	add    $0x8,%eax
801063fb:	c1 e8 10             	shr    $0x10,%eax
801063fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106401:	e8 b6 ce ff ff       	call   801032bc <mycpu>
80106406:	83 c0 08             	add    $0x8,%eax
80106409:	c1 e8 18             	shr    $0x18,%eax
8010640c:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80106413:	67 00 
80106415:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010641c:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
80106420:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106426:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
8010642d:	83 e2 f0             	and    $0xfffffff0,%edx
80106430:	83 ca 19             	or     $0x19,%edx
80106433:	83 e2 9f             	and    $0xffffff9f,%edx
80106436:	83 ca 80             	or     $0xffffff80,%edx
80106439:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
8010643f:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106446:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010644c:	e8 6b ce ff ff       	call   801032bc <mycpu>
80106451:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80106458:	83 e2 ef             	and    $0xffffffef,%edx
8010645b:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106461:	e8 56 ce ff ff       	call   801032bc <mycpu>
80106466:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010646c:	8b 5e 08             	mov    0x8(%esi),%ebx
8010646f:	e8 48 ce ff ff       	call   801032bc <mycpu>
80106474:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010647a:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010647d:	e8 3a ce ff ff       	call   801032bc <mycpu>
80106482:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106488:	b8 28 00 00 00       	mov    $0x28,%eax
8010648d:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106490:	8b 46 04             	mov    0x4(%esi),%eax
80106493:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106498:	0f 22 d8             	mov    %eax,%cr3
  popcli();
8010649b:	e8 5d da ff ff       	call   80103efd <popcli>
}
801064a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064a3:	5b                   	pop    %ebx
801064a4:	5e                   	pop    %esi
801064a5:	5f                   	pop    %edi
801064a6:	5d                   	pop    %ebp
801064a7:	c3                   	ret    
    panic("switchuvm: no process");
801064a8:	83 ec 0c             	sub    $0xc,%esp
801064ab:	68 6e 73 10 80       	push   $0x8010736e
801064b0:	e8 a7 9e ff ff       	call   8010035c <panic>
    panic("switchuvm: no kstack");
801064b5:	83 ec 0c             	sub    $0xc,%esp
801064b8:	68 84 73 10 80       	push   $0x80107384
801064bd:	e8 9a 9e ff ff       	call   8010035c <panic>
    panic("switchuvm: no pgdir");
801064c2:	83 ec 0c             	sub    $0xc,%esp
801064c5:	68 99 73 10 80       	push   $0x80107399
801064ca:	e8 8d 9e ff ff       	call   8010035c <panic>

801064cf <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801064cf:	f3 0f 1e fb          	endbr32 
801064d3:	55                   	push   %ebp
801064d4:	89 e5                	mov    %esp,%ebp
801064d6:	56                   	push   %esi
801064d7:	53                   	push   %ebx
801064d8:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
801064db:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801064e1:	77 4c                	ja     8010652f <inituvm+0x60>
    panic("inituvm: more than a page");
  mem = kalloc();
801064e3:	e8 a7 bc ff ff       	call   8010218f <kalloc>
801064e8:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801064ea:	83 ec 04             	sub    $0x4,%esp
801064ed:	68 00 10 00 00       	push   $0x1000
801064f2:	6a 00                	push   $0x0
801064f4:	50                   	push   %eax
801064f5:	e8 5f db ff ff       	call   80104059 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801064fa:	83 c4 08             	add    $0x8,%esp
801064fd:	6a 06                	push   $0x6
801064ff:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106505:	50                   	push   %eax
80106506:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010650b:	ba 00 00 00 00       	mov    $0x0,%edx
80106510:	8b 45 08             	mov    0x8(%ebp),%eax
80106513:	e8 c3 fc ff ff       	call   801061db <mappages>
  memmove(mem, init, sz);
80106518:	83 c4 0c             	add    $0xc,%esp
8010651b:	56                   	push   %esi
8010651c:	ff 75 0c             	pushl  0xc(%ebp)
8010651f:	53                   	push   %ebx
80106520:	e8 b4 db ff ff       	call   801040d9 <memmove>
}
80106525:	83 c4 10             	add    $0x10,%esp
80106528:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010652b:	5b                   	pop    %ebx
8010652c:	5e                   	pop    %esi
8010652d:	5d                   	pop    %ebp
8010652e:	c3                   	ret    
    panic("inituvm: more than a page");
8010652f:	83 ec 0c             	sub    $0xc,%esp
80106532:	68 ad 73 10 80       	push   $0x801073ad
80106537:	e8 20 9e ff ff       	call   8010035c <panic>

8010653c <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010653c:	f3 0f 1e fb          	endbr32 
80106540:	55                   	push   %ebp
80106541:	89 e5                	mov    %esp,%ebp
80106543:	57                   	push   %edi
80106544:	56                   	push   %esi
80106545:	53                   	push   %ebx
80106546:	83 ec 0c             	sub    $0xc,%esp
80106549:	8b 7d 18             	mov    0x18(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
8010654c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010654f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80106555:	74 3c                	je     80106593 <loaduvm+0x57>
    panic("loaduvm: addr must be page aligned");
80106557:	83 ec 0c             	sub    $0xc,%esp
8010655a:	68 68 74 10 80       	push   $0x80107468
8010655f:	e8 f8 9d ff ff       	call   8010035c <panic>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106564:	83 ec 0c             	sub    $0xc,%esp
80106567:	68 c7 73 10 80       	push   $0x801073c7
8010656c:	e8 eb 9d ff ff       	call   8010035c <panic>
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106571:	05 00 00 00 80       	add    $0x80000000,%eax
80106576:	56                   	push   %esi
80106577:	89 da                	mov    %ebx,%edx
80106579:	03 55 14             	add    0x14(%ebp),%edx
8010657c:	52                   	push   %edx
8010657d:	50                   	push   %eax
8010657e:	ff 75 10             	pushl  0x10(%ebp)
80106581:	e8 87 b2 ff ff       	call   8010180d <readi>
80106586:	83 c4 10             	add    $0x10,%esp
80106589:	39 f0                	cmp    %esi,%eax
8010658b:	75 47                	jne    801065d4 <loaduvm+0x98>
  for(i = 0; i < sz; i += PGSIZE){
8010658d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106593:	39 fb                	cmp    %edi,%ebx
80106595:	73 30                	jae    801065c7 <loaduvm+0x8b>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106597:	89 da                	mov    %ebx,%edx
80106599:	03 55 0c             	add    0xc(%ebp),%edx
8010659c:	b9 00 00 00 00       	mov    $0x0,%ecx
801065a1:	8b 45 08             	mov    0x8(%ebp),%eax
801065a4:	e8 c1 fb ff ff       	call   8010616a <walkpgdir>
801065a9:	85 c0                	test   %eax,%eax
801065ab:	74 b7                	je     80106564 <loaduvm+0x28>
    pa = PTE_ADDR(*pte);
801065ad:	8b 00                	mov    (%eax),%eax
801065af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801065b4:	89 fe                	mov    %edi,%esi
801065b6:	29 de                	sub    %ebx,%esi
801065b8:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801065be:	76 b1                	jbe    80106571 <loaduvm+0x35>
      n = PGSIZE;
801065c0:	be 00 10 00 00       	mov    $0x1000,%esi
801065c5:	eb aa                	jmp    80106571 <loaduvm+0x35>
      return -1;
  }
  return 0;
801065c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801065cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065cf:	5b                   	pop    %ebx
801065d0:	5e                   	pop    %esi
801065d1:	5f                   	pop    %edi
801065d2:	5d                   	pop    %ebp
801065d3:	c3                   	ret    
      return -1;
801065d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065d9:	eb f1                	jmp    801065cc <loaduvm+0x90>

801065db <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801065db:	f3 0f 1e fb          	endbr32 
801065df:	55                   	push   %ebp
801065e0:	89 e5                	mov    %esp,%ebp
801065e2:	57                   	push   %edi
801065e3:	56                   	push   %esi
801065e4:	53                   	push   %ebx
801065e5:	83 ec 0c             	sub    $0xc,%esp
801065e8:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801065eb:	39 7d 10             	cmp    %edi,0x10(%ebp)
801065ee:	73 11                	jae    80106601 <deallocuvm+0x26>
    return oldsz;

  a = PGROUNDUP(newsz);
801065f0:	8b 45 10             	mov    0x10(%ebp),%eax
801065f3:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801065f9:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801065ff:	eb 19                	jmp    8010661a <deallocuvm+0x3f>
    return oldsz;
80106601:	89 f8                	mov    %edi,%eax
80106603:	eb 64                	jmp    80106669 <deallocuvm+0x8e>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106605:	c1 eb 16             	shr    $0x16,%ebx
80106608:	83 c3 01             	add    $0x1,%ebx
8010660b:	c1 e3 16             	shl    $0x16,%ebx
8010660e:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106614:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010661a:	39 fb                	cmp    %edi,%ebx
8010661c:	73 48                	jae    80106666 <deallocuvm+0x8b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010661e:	b9 00 00 00 00       	mov    $0x0,%ecx
80106623:	89 da                	mov    %ebx,%edx
80106625:	8b 45 08             	mov    0x8(%ebp),%eax
80106628:	e8 3d fb ff ff       	call   8010616a <walkpgdir>
8010662d:	89 c6                	mov    %eax,%esi
    if(!pte)
8010662f:	85 c0                	test   %eax,%eax
80106631:	74 d2                	je     80106605 <deallocuvm+0x2a>
    else if((*pte & PTE_P) != 0){
80106633:	8b 00                	mov    (%eax),%eax
80106635:	a8 01                	test   $0x1,%al
80106637:	74 db                	je     80106614 <deallocuvm+0x39>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106639:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010663e:	74 19                	je     80106659 <deallocuvm+0x7e>
        panic("kfree");
      char *v = P2V(pa);
80106640:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106645:	83 ec 0c             	sub    $0xc,%esp
80106648:	50                   	push   %eax
80106649:	e8 1a ba ff ff       	call   80102068 <kfree>
      *pte = 0;
8010664e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80106654:	83 c4 10             	add    $0x10,%esp
80106657:	eb bb                	jmp    80106614 <deallocuvm+0x39>
        panic("kfree");
80106659:	83 ec 0c             	sub    $0xc,%esp
8010665c:	68 ae 6c 10 80       	push   $0x80106cae
80106661:	e8 f6 9c ff ff       	call   8010035c <panic>
    }
  }
  return newsz;
80106666:	8b 45 10             	mov    0x10(%ebp),%eax
}
80106669:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010666c:	5b                   	pop    %ebx
8010666d:	5e                   	pop    %esi
8010666e:	5f                   	pop    %edi
8010666f:	5d                   	pop    %ebp
80106670:	c3                   	ret    

80106671 <allocuvm>:
{
80106671:	f3 0f 1e fb          	endbr32 
80106675:	55                   	push   %ebp
80106676:	89 e5                	mov    %esp,%ebp
80106678:	57                   	push   %edi
80106679:	56                   	push   %esi
8010667a:	53                   	push   %ebx
8010667b:	83 ec 1c             	sub    $0x1c,%esp
8010667e:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
80106681:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106684:	85 ff                	test   %edi,%edi
80106686:	0f 88 c0 00 00 00    	js     8010674c <allocuvm+0xdb>
  if(newsz < oldsz)
8010668c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
8010668f:	72 11                	jb     801066a2 <allocuvm+0x31>
  a = PGROUNDUP(oldsz);
80106691:	8b 45 0c             	mov    0xc(%ebp),%eax
80106694:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010669a:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801066a0:	eb 39                	jmp    801066db <allocuvm+0x6a>
    return oldsz;
801066a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801066a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801066a8:	e9 a6 00 00 00       	jmp    80106753 <allocuvm+0xe2>
      cprintf("allocuvm out of memory\n");
801066ad:	83 ec 0c             	sub    $0xc,%esp
801066b0:	68 e5 73 10 80       	push   $0x801073e5
801066b5:	e8 6f 9f ff ff       	call   80100629 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801066ba:	83 c4 0c             	add    $0xc,%esp
801066bd:	ff 75 0c             	pushl  0xc(%ebp)
801066c0:	57                   	push   %edi
801066c1:	ff 75 08             	pushl  0x8(%ebp)
801066c4:	e8 12 ff ff ff       	call   801065db <deallocuvm>
      return 0;
801066c9:	83 c4 10             	add    $0x10,%esp
801066cc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801066d3:	eb 7e                	jmp    80106753 <allocuvm+0xe2>
  for(; a < newsz; a += PGSIZE){
801066d5:	81 c6 00 10 00 00    	add    $0x1000,%esi
801066db:	39 fe                	cmp    %edi,%esi
801066dd:	73 74                	jae    80106753 <allocuvm+0xe2>
    mem = kalloc();
801066df:	e8 ab ba ff ff       	call   8010218f <kalloc>
801066e4:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801066e6:	85 c0                	test   %eax,%eax
801066e8:	74 c3                	je     801066ad <allocuvm+0x3c>
    memset(mem, 0, PGSIZE);
801066ea:	83 ec 04             	sub    $0x4,%esp
801066ed:	68 00 10 00 00       	push   $0x1000
801066f2:	6a 00                	push   $0x0
801066f4:	50                   	push   %eax
801066f5:	e8 5f d9 ff ff       	call   80104059 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801066fa:	83 c4 08             	add    $0x8,%esp
801066fd:	6a 06                	push   $0x6
801066ff:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106705:	50                   	push   %eax
80106706:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010670b:	89 f2                	mov    %esi,%edx
8010670d:	8b 45 08             	mov    0x8(%ebp),%eax
80106710:	e8 c6 fa ff ff       	call   801061db <mappages>
80106715:	83 c4 10             	add    $0x10,%esp
80106718:	85 c0                	test   %eax,%eax
8010671a:	79 b9                	jns    801066d5 <allocuvm+0x64>
      cprintf("allocuvm out of memory (2)\n");
8010671c:	83 ec 0c             	sub    $0xc,%esp
8010671f:	68 fd 73 10 80       	push   $0x801073fd
80106724:	e8 00 9f ff ff       	call   80100629 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106729:	83 c4 0c             	add    $0xc,%esp
8010672c:	ff 75 0c             	pushl  0xc(%ebp)
8010672f:	57                   	push   %edi
80106730:	ff 75 08             	pushl  0x8(%ebp)
80106733:	e8 a3 fe ff ff       	call   801065db <deallocuvm>
      kfree(mem);
80106738:	89 1c 24             	mov    %ebx,(%esp)
8010673b:	e8 28 b9 ff ff       	call   80102068 <kfree>
      return 0;
80106740:	83 c4 10             	add    $0x10,%esp
80106743:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010674a:	eb 07                	jmp    80106753 <allocuvm+0xe2>
    return 0;
8010674c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106753:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106756:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106759:	5b                   	pop    %ebx
8010675a:	5e                   	pop    %esi
8010675b:	5f                   	pop    %edi
8010675c:	5d                   	pop    %ebp
8010675d:	c3                   	ret    

8010675e <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010675e:	f3 0f 1e fb          	endbr32 
80106762:	55                   	push   %ebp
80106763:	89 e5                	mov    %esp,%ebp
80106765:	56                   	push   %esi
80106766:	53                   	push   %ebx
80106767:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010676a:	85 f6                	test   %esi,%esi
8010676c:	74 1a                	je     80106788 <freevm+0x2a>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
8010676e:	83 ec 04             	sub    $0x4,%esp
80106771:	6a 00                	push   $0x0
80106773:	68 00 00 00 80       	push   $0x80000000
80106778:	56                   	push   %esi
80106779:	e8 5d fe ff ff       	call   801065db <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
8010677e:	83 c4 10             	add    $0x10,%esp
80106781:	bb 00 00 00 00       	mov    $0x0,%ebx
80106786:	eb 26                	jmp    801067ae <freevm+0x50>
    panic("freevm: no pgdir");
80106788:	83 ec 0c             	sub    $0xc,%esp
8010678b:	68 19 74 10 80       	push   $0x80107419
80106790:	e8 c7 9b ff ff       	call   8010035c <panic>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106795:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010679a:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010679f:	83 ec 0c             	sub    $0xc,%esp
801067a2:	50                   	push   %eax
801067a3:	e8 c0 b8 ff ff       	call   80102068 <kfree>
801067a8:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801067ab:	83 c3 01             	add    $0x1,%ebx
801067ae:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
801067b4:	77 09                	ja     801067bf <freevm+0x61>
    if(pgdir[i] & PTE_P){
801067b6:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
801067b9:	a8 01                	test   $0x1,%al
801067bb:	74 ee                	je     801067ab <freevm+0x4d>
801067bd:	eb d6                	jmp    80106795 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801067bf:	83 ec 0c             	sub    $0xc,%esp
801067c2:	56                   	push   %esi
801067c3:	e8 a0 b8 ff ff       	call   80102068 <kfree>
}
801067c8:	83 c4 10             	add    $0x10,%esp
801067cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
801067ce:	5b                   	pop    %ebx
801067cf:	5e                   	pop    %esi
801067d0:	5d                   	pop    %ebp
801067d1:	c3                   	ret    

801067d2 <setupkvm>:
{
801067d2:	f3 0f 1e fb          	endbr32 
801067d6:	55                   	push   %ebp
801067d7:	89 e5                	mov    %esp,%ebp
801067d9:	56                   	push   %esi
801067da:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801067db:	e8 af b9 ff ff       	call   8010218f <kalloc>
801067e0:	89 c6                	mov    %eax,%esi
801067e2:	85 c0                	test   %eax,%eax
801067e4:	74 55                	je     8010683b <setupkvm+0x69>
  memset(pgdir, 0, PGSIZE);
801067e6:	83 ec 04             	sub    $0x4,%esp
801067e9:	68 00 10 00 00       	push   $0x1000
801067ee:	6a 00                	push   $0x0
801067f0:	50                   	push   %eax
801067f1:	e8 63 d8 ff ff       	call   80104059 <memset>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801067f6:	83 c4 10             	add    $0x10,%esp
801067f9:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
801067fe:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106804:	73 35                	jae    8010683b <setupkvm+0x69>
                (uint)k->phys_start, k->perm) < 0) {
80106806:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106809:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010680c:	29 c1                	sub    %eax,%ecx
8010680e:	83 ec 08             	sub    $0x8,%esp
80106811:	ff 73 0c             	pushl  0xc(%ebx)
80106814:	50                   	push   %eax
80106815:	8b 13                	mov    (%ebx),%edx
80106817:	89 f0                	mov    %esi,%eax
80106819:	e8 bd f9 ff ff       	call   801061db <mappages>
8010681e:	83 c4 10             	add    $0x10,%esp
80106821:	85 c0                	test   %eax,%eax
80106823:	78 05                	js     8010682a <setupkvm+0x58>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106825:	83 c3 10             	add    $0x10,%ebx
80106828:	eb d4                	jmp    801067fe <setupkvm+0x2c>
      freevm(pgdir);
8010682a:	83 ec 0c             	sub    $0xc,%esp
8010682d:	56                   	push   %esi
8010682e:	e8 2b ff ff ff       	call   8010675e <freevm>
      return 0;
80106833:	83 c4 10             	add    $0x10,%esp
80106836:	be 00 00 00 00       	mov    $0x0,%esi
}
8010683b:	89 f0                	mov    %esi,%eax
8010683d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106840:	5b                   	pop    %ebx
80106841:	5e                   	pop    %esi
80106842:	5d                   	pop    %ebp
80106843:	c3                   	ret    

80106844 <kvmalloc>:
{
80106844:	f3 0f 1e fb          	endbr32 
80106848:	55                   	push   %ebp
80106849:	89 e5                	mov    %esp,%ebp
8010684b:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010684e:	e8 7f ff ff ff       	call   801067d2 <setupkvm>
80106853:	a3 84 76 11 80       	mov    %eax,0x80117684
  switchkvm();
80106858:	e8 44 fb ff ff       	call   801063a1 <switchkvm>
}
8010685d:	c9                   	leave  
8010685e:	c3                   	ret    

8010685f <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010685f:	f3 0f 1e fb          	endbr32 
80106863:	55                   	push   %ebp
80106864:	89 e5                	mov    %esp,%ebp
80106866:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106869:	b9 00 00 00 00       	mov    $0x0,%ecx
8010686e:	8b 55 0c             	mov    0xc(%ebp),%edx
80106871:	8b 45 08             	mov    0x8(%ebp),%eax
80106874:	e8 f1 f8 ff ff       	call   8010616a <walkpgdir>
  if(pte == 0)
80106879:	85 c0                	test   %eax,%eax
8010687b:	74 05                	je     80106882 <clearpteu+0x23>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010687d:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106880:	c9                   	leave  
80106881:	c3                   	ret    
    panic("clearpteu");
80106882:	83 ec 0c             	sub    $0xc,%esp
80106885:	68 2a 74 10 80       	push   $0x8010742a
8010688a:	e8 cd 9a ff ff       	call   8010035c <panic>

8010688f <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010688f:	f3 0f 1e fb          	endbr32 
80106893:	55                   	push   %ebp
80106894:	89 e5                	mov    %esp,%ebp
80106896:	57                   	push   %edi
80106897:	56                   	push   %esi
80106898:	53                   	push   %ebx
80106899:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010689c:	e8 31 ff ff ff       	call   801067d2 <setupkvm>
801068a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
801068a4:	85 c0                	test   %eax,%eax
801068a6:	0f 84 b8 00 00 00    	je     80106964 <copyuvm+0xd5>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801068ac:	bf 00 00 00 00       	mov    $0x0,%edi
801068b1:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801068b4:	0f 83 aa 00 00 00    	jae    80106964 <copyuvm+0xd5>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801068ba:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801068bd:	b9 00 00 00 00       	mov    $0x0,%ecx
801068c2:	89 fa                	mov    %edi,%edx
801068c4:	8b 45 08             	mov    0x8(%ebp),%eax
801068c7:	e8 9e f8 ff ff       	call   8010616a <walkpgdir>
801068cc:	85 c0                	test   %eax,%eax
801068ce:	74 65                	je     80106935 <copyuvm+0xa6>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
801068d0:	8b 00                	mov    (%eax),%eax
801068d2:	a8 01                	test   $0x1,%al
801068d4:	74 6c                	je     80106942 <copyuvm+0xb3>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801068d6:	89 c6                	mov    %eax,%esi
801068d8:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
801068de:	25 ff 0f 00 00       	and    $0xfff,%eax
801068e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
801068e6:	e8 a4 b8 ff ff       	call   8010218f <kalloc>
801068eb:	89 c3                	mov    %eax,%ebx
801068ed:	85 c0                	test   %eax,%eax
801068ef:	74 5e                	je     8010694f <copyuvm+0xc0>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801068f1:	81 c6 00 00 00 80    	add    $0x80000000,%esi
801068f7:	83 ec 04             	sub    $0x4,%esp
801068fa:	68 00 10 00 00       	push   $0x1000
801068ff:	56                   	push   %esi
80106900:	50                   	push   %eax
80106901:	e8 d3 d7 ff ff       	call   801040d9 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106906:	83 c4 08             	add    $0x8,%esp
80106909:	ff 75 e0             	pushl  -0x20(%ebp)
8010690c:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106912:	53                   	push   %ebx
80106913:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106918:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010691b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010691e:	e8 b8 f8 ff ff       	call   801061db <mappages>
80106923:	83 c4 10             	add    $0x10,%esp
80106926:	85 c0                	test   %eax,%eax
80106928:	78 25                	js     8010694f <copyuvm+0xc0>
  for(i = 0; i < sz; i += PGSIZE){
8010692a:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106930:	e9 7c ff ff ff       	jmp    801068b1 <copyuvm+0x22>
      panic("copyuvm: pte should exist");
80106935:	83 ec 0c             	sub    $0xc,%esp
80106938:	68 34 74 10 80       	push   $0x80107434
8010693d:	e8 1a 9a ff ff       	call   8010035c <panic>
      panic("copyuvm: page not present");
80106942:	83 ec 0c             	sub    $0xc,%esp
80106945:	68 4e 74 10 80       	push   $0x8010744e
8010694a:	e8 0d 9a ff ff       	call   8010035c <panic>
      goto bad;
  }
  return d;

bad:
  freevm(d);
8010694f:	83 ec 0c             	sub    $0xc,%esp
80106952:	ff 75 dc             	pushl  -0x24(%ebp)
80106955:	e8 04 fe ff ff       	call   8010675e <freevm>
  return 0;
8010695a:	83 c4 10             	add    $0x10,%esp
8010695d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
80106964:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106967:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010696a:	5b                   	pop    %ebx
8010696b:	5e                   	pop    %esi
8010696c:	5f                   	pop    %edi
8010696d:	5d                   	pop    %ebp
8010696e:	c3                   	ret    

8010696f <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010696f:	f3 0f 1e fb          	endbr32 
80106973:	55                   	push   %ebp
80106974:	89 e5                	mov    %esp,%ebp
80106976:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106979:	b9 00 00 00 00       	mov    $0x0,%ecx
8010697e:	8b 55 0c             	mov    0xc(%ebp),%edx
80106981:	8b 45 08             	mov    0x8(%ebp),%eax
80106984:	e8 e1 f7 ff ff       	call   8010616a <walkpgdir>
  if((*pte & PTE_P) == 0)
80106989:	8b 00                	mov    (%eax),%eax
8010698b:	a8 01                	test   $0x1,%al
8010698d:	74 10                	je     8010699f <uva2ka+0x30>
    return 0;
  if((*pte & PTE_U) == 0)
8010698f:	a8 04                	test   $0x4,%al
80106991:	74 13                	je     801069a6 <uva2ka+0x37>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106993:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106998:	05 00 00 00 80       	add    $0x80000000,%eax
}
8010699d:	c9                   	leave  
8010699e:	c3                   	ret    
    return 0;
8010699f:	b8 00 00 00 00       	mov    $0x0,%eax
801069a4:	eb f7                	jmp    8010699d <uva2ka+0x2e>
    return 0;
801069a6:	b8 00 00 00 00       	mov    $0x0,%eax
801069ab:	eb f0                	jmp    8010699d <uva2ka+0x2e>

801069ad <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801069ad:	f3 0f 1e fb          	endbr32 
801069b1:	55                   	push   %ebp
801069b2:	89 e5                	mov    %esp,%ebp
801069b4:	57                   	push   %edi
801069b5:	56                   	push   %esi
801069b6:	53                   	push   %ebx
801069b7:	83 ec 0c             	sub    $0xc,%esp
801069ba:	8b 7d 14             	mov    0x14(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801069bd:	eb 25                	jmp    801069e4 <copyout+0x37>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801069bf:	8b 55 0c             	mov    0xc(%ebp),%edx
801069c2:	29 f2                	sub    %esi,%edx
801069c4:	01 d0                	add    %edx,%eax
801069c6:	83 ec 04             	sub    $0x4,%esp
801069c9:	53                   	push   %ebx
801069ca:	ff 75 10             	pushl  0x10(%ebp)
801069cd:	50                   	push   %eax
801069ce:	e8 06 d7 ff ff       	call   801040d9 <memmove>
    len -= n;
801069d3:	29 df                	sub    %ebx,%edi
    buf += n;
801069d5:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801069d8:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
801069de:	89 45 0c             	mov    %eax,0xc(%ebp)
801069e1:	83 c4 10             	add    $0x10,%esp
  while(len > 0){
801069e4:	85 ff                	test   %edi,%edi
801069e6:	74 2f                	je     80106a17 <copyout+0x6a>
    va0 = (uint)PGROUNDDOWN(va);
801069e8:	8b 75 0c             	mov    0xc(%ebp),%esi
801069eb:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801069f1:	83 ec 08             	sub    $0x8,%esp
801069f4:	56                   	push   %esi
801069f5:	ff 75 08             	pushl  0x8(%ebp)
801069f8:	e8 72 ff ff ff       	call   8010696f <uva2ka>
    if(pa0 == 0)
801069fd:	83 c4 10             	add    $0x10,%esp
80106a00:	85 c0                	test   %eax,%eax
80106a02:	74 20                	je     80106a24 <copyout+0x77>
    n = PGSIZE - (va - va0);
80106a04:	89 f3                	mov    %esi,%ebx
80106a06:	2b 5d 0c             	sub    0xc(%ebp),%ebx
80106a09:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80106a0f:	39 df                	cmp    %ebx,%edi
80106a11:	73 ac                	jae    801069bf <copyout+0x12>
      n = len;
80106a13:	89 fb                	mov    %edi,%ebx
80106a15:	eb a8                	jmp    801069bf <copyout+0x12>
  }
  return 0;
80106a17:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a1f:	5b                   	pop    %ebx
80106a20:	5e                   	pop    %esi
80106a21:	5f                   	pop    %edi
80106a22:	5d                   	pop    %ebp
80106a23:	c3                   	ret    
      return -1;
80106a24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a29:	eb f1                	jmp    80106a1c <copyout+0x6f>
