
_test_cps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "fcntl.h"

int 
main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 e4 f0             	and    $0xfffffff0,%esp
	// call to cps() system call
	cps();
   a:	e8 43 03 00 00       	call   352 <cps>
	exit();
   f:	e8 96 02 00 00       	call   2aa <exit>

00000014 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  14:	f3 0f 1e fb          	endbr32 
  18:	55                   	push   %ebp
  19:	89 e5                	mov    %esp,%ebp
  1b:	56                   	push   %esi
  1c:	53                   	push   %ebx
  1d:	8b 75 08             	mov    0x8(%ebp),%esi
  20:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  23:	89 f0                	mov    %esi,%eax
  25:	89 d1                	mov    %edx,%ecx
  27:	83 c2 01             	add    $0x1,%edx
  2a:	89 c3                	mov    %eax,%ebx
  2c:	83 c0 01             	add    $0x1,%eax
  2f:	0f b6 09             	movzbl (%ecx),%ecx
  32:	88 0b                	mov    %cl,(%ebx)
  34:	84 c9                	test   %cl,%cl
  36:	75 ed                	jne    25 <strcpy+0x11>
    ;
  return os;
}
  38:	89 f0                	mov    %esi,%eax
  3a:	5b                   	pop    %ebx
  3b:	5e                   	pop    %esi
  3c:	5d                   	pop    %ebp
  3d:	c3                   	ret    

0000003e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  3e:	f3 0f 1e fb          	endbr32 
  42:	55                   	push   %ebp
  43:	89 e5                	mov    %esp,%ebp
  45:	8b 4d 08             	mov    0x8(%ebp),%ecx
  48:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  4b:	0f b6 01             	movzbl (%ecx),%eax
  4e:	84 c0                	test   %al,%al
  50:	74 0c                	je     5e <strcmp+0x20>
  52:	3a 02                	cmp    (%edx),%al
  54:	75 08                	jne    5e <strcmp+0x20>
    p++, q++;
  56:	83 c1 01             	add    $0x1,%ecx
  59:	83 c2 01             	add    $0x1,%edx
  5c:	eb ed                	jmp    4b <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  5e:	0f b6 c0             	movzbl %al,%eax
  61:	0f b6 12             	movzbl (%edx),%edx
  64:	29 d0                	sub    %edx,%eax
}
  66:	5d                   	pop    %ebp
  67:	c3                   	ret    

00000068 <strlen>:

uint
strlen(char *s)
{
  68:	f3 0f 1e fb          	endbr32 
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  72:	b8 00 00 00 00       	mov    $0x0,%eax
  77:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  7b:	74 05                	je     82 <strlen+0x1a>
  7d:	83 c0 01             	add    $0x1,%eax
  80:	eb f5                	jmp    77 <strlen+0xf>
    ;
  return n;
}
  82:	5d                   	pop    %ebp
  83:	c3                   	ret    

00000084 <memset>:

void*
memset(void *dst, int c, uint n)
{
  84:	f3 0f 1e fb          	endbr32 
  88:	55                   	push   %ebp
  89:	89 e5                	mov    %esp,%ebp
  8b:	57                   	push   %edi
  8c:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  8f:	89 d7                	mov    %edx,%edi
  91:	8b 4d 10             	mov    0x10(%ebp),%ecx
  94:	8b 45 0c             	mov    0xc(%ebp),%eax
  97:	fc                   	cld    
  98:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  9a:	89 d0                	mov    %edx,%eax
  9c:	5f                   	pop    %edi
  9d:	5d                   	pop    %ebp
  9e:	c3                   	ret    

0000009f <strchr>:

char*
strchr(const char *s, char c)
{
  9f:	f3 0f 1e fb          	endbr32 
  a3:	55                   	push   %ebp
  a4:	89 e5                	mov    %esp,%ebp
  a6:	8b 45 08             	mov    0x8(%ebp),%eax
  a9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  ad:	0f b6 10             	movzbl (%eax),%edx
  b0:	84 d2                	test   %dl,%dl
  b2:	74 09                	je     bd <strchr+0x1e>
    if(*s == c)
  b4:	38 ca                	cmp    %cl,%dl
  b6:	74 0a                	je     c2 <strchr+0x23>
  for(; *s; s++)
  b8:	83 c0 01             	add    $0x1,%eax
  bb:	eb f0                	jmp    ad <strchr+0xe>
      return (char*)s;
  return 0;
  bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  c2:	5d                   	pop    %ebp
  c3:	c3                   	ret    

000000c4 <gets>:

char*
gets(char *buf, int max)
{
  c4:	f3 0f 1e fb          	endbr32 
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  cb:	57                   	push   %edi
  cc:	56                   	push   %esi
  cd:	53                   	push   %ebx
  ce:	83 ec 1c             	sub    $0x1c,%esp
  d1:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  d4:	bb 00 00 00 00       	mov    $0x0,%ebx
  d9:	89 de                	mov    %ebx,%esi
  db:	83 c3 01             	add    $0x1,%ebx
  de:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  e1:	7d 2e                	jge    111 <gets+0x4d>
    cc = read(0, &c, 1);
  e3:	83 ec 04             	sub    $0x4,%esp
  e6:	6a 01                	push   $0x1
  e8:	8d 45 e7             	lea    -0x19(%ebp),%eax
  eb:	50                   	push   %eax
  ec:	6a 00                	push   $0x0
  ee:	e8 cf 01 00 00       	call   2c2 <read>
    if(cc < 1)
  f3:	83 c4 10             	add    $0x10,%esp
  f6:	85 c0                	test   %eax,%eax
  f8:	7e 17                	jle    111 <gets+0x4d>
      break;
    buf[i++] = c;
  fa:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  fe:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 101:	3c 0a                	cmp    $0xa,%al
 103:	0f 94 c2             	sete   %dl
 106:	3c 0d                	cmp    $0xd,%al
 108:	0f 94 c0             	sete   %al
 10b:	08 c2                	or     %al,%dl
 10d:	74 ca                	je     d9 <gets+0x15>
    buf[i++] = c;
 10f:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 111:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 115:	89 f8                	mov    %edi,%eax
 117:	8d 65 f4             	lea    -0xc(%ebp),%esp
 11a:	5b                   	pop    %ebx
 11b:	5e                   	pop    %esi
 11c:	5f                   	pop    %edi
 11d:	5d                   	pop    %ebp
 11e:	c3                   	ret    

0000011f <stat>:

int
stat(char *n, struct stat *st)
{
 11f:	f3 0f 1e fb          	endbr32 
 123:	55                   	push   %ebp
 124:	89 e5                	mov    %esp,%ebp
 126:	56                   	push   %esi
 127:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 128:	83 ec 08             	sub    $0x8,%esp
 12b:	6a 00                	push   $0x0
 12d:	ff 75 08             	pushl  0x8(%ebp)
 130:	e8 b5 01 00 00       	call   2ea <open>
  if(fd < 0)
 135:	83 c4 10             	add    $0x10,%esp
 138:	85 c0                	test   %eax,%eax
 13a:	78 24                	js     160 <stat+0x41>
 13c:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 13e:	83 ec 08             	sub    $0x8,%esp
 141:	ff 75 0c             	pushl  0xc(%ebp)
 144:	50                   	push   %eax
 145:	e8 b8 01 00 00       	call   302 <fstat>
 14a:	89 c6                	mov    %eax,%esi
  close(fd);
 14c:	89 1c 24             	mov    %ebx,(%esp)
 14f:	e8 7e 01 00 00       	call   2d2 <close>
  return r;
 154:	83 c4 10             	add    $0x10,%esp
}
 157:	89 f0                	mov    %esi,%eax
 159:	8d 65 f8             	lea    -0x8(%ebp),%esp
 15c:	5b                   	pop    %ebx
 15d:	5e                   	pop    %esi
 15e:	5d                   	pop    %ebp
 15f:	c3                   	ret    
    return -1;
 160:	be ff ff ff ff       	mov    $0xffffffff,%esi
 165:	eb f0                	jmp    157 <stat+0x38>

00000167 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 167:	f3 0f 1e fb          	endbr32 
 16b:	55                   	push   %ebp
 16c:	89 e5                	mov    %esp,%ebp
 16e:	57                   	push   %edi
 16f:	56                   	push   %esi
 170:	53                   	push   %ebx
 171:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 174:	0f b6 02             	movzbl (%edx),%eax
 177:	3c 20                	cmp    $0x20,%al
 179:	75 05                	jne    180 <atoi+0x19>
 17b:	83 c2 01             	add    $0x1,%edx
 17e:	eb f4                	jmp    174 <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 180:	3c 2d                	cmp    $0x2d,%al
 182:	74 1d                	je     1a1 <atoi+0x3a>
 184:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 189:	3c 2b                	cmp    $0x2b,%al
 18b:	0f 94 c1             	sete   %cl
 18e:	3c 2d                	cmp    $0x2d,%al
 190:	0f 94 c0             	sete   %al
 193:	08 c1                	or     %al,%cl
 195:	74 03                	je     19a <atoi+0x33>
    s++;
 197:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 19a:	b8 00 00 00 00       	mov    $0x0,%eax
 19f:	eb 17                	jmp    1b8 <atoi+0x51>
 1a1:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 1a6:	eb e1                	jmp    189 <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 1a8:	8d 34 80             	lea    (%eax,%eax,4),%esi
 1ab:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 1ae:	83 c2 01             	add    $0x1,%edx
 1b1:	0f be c9             	movsbl %cl,%ecx
 1b4:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 1b8:	0f b6 0a             	movzbl (%edx),%ecx
 1bb:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 1be:	80 fb 09             	cmp    $0x9,%bl
 1c1:	76 e5                	jbe    1a8 <atoi+0x41>
  return sign*n;
 1c3:	0f af c7             	imul   %edi,%eax
}
 1c6:	5b                   	pop    %ebx
 1c7:	5e                   	pop    %esi
 1c8:	5f                   	pop    %edi
 1c9:	5d                   	pop    %ebp
 1ca:	c3                   	ret    

000001cb <atoo>:

int
atoo(const char *s)
{
 1cb:	f3 0f 1e fb          	endbr32 
 1cf:	55                   	push   %ebp
 1d0:	89 e5                	mov    %esp,%ebp
 1d2:	57                   	push   %edi
 1d3:	56                   	push   %esi
 1d4:	53                   	push   %ebx
 1d5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1d8:	0f b6 0a             	movzbl (%edx),%ecx
 1db:	80 f9 20             	cmp    $0x20,%cl
 1de:	75 05                	jne    1e5 <atoo+0x1a>
 1e0:	83 c2 01             	add    $0x1,%edx
 1e3:	eb f3                	jmp    1d8 <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 1e5:	80 f9 2d             	cmp    $0x2d,%cl
 1e8:	74 23                	je     20d <atoo+0x42>
 1ea:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 1ef:	80 f9 2b             	cmp    $0x2b,%cl
 1f2:	0f 94 c0             	sete   %al
 1f5:	89 c6                	mov    %eax,%esi
 1f7:	80 f9 2d             	cmp    $0x2d,%cl
 1fa:	0f 94 c0             	sete   %al
 1fd:	89 f3                	mov    %esi,%ebx
 1ff:	08 c3                	or     %al,%bl
 201:	74 03                	je     206 <atoo+0x3b>
    s++;
 203:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 206:	b8 00 00 00 00       	mov    $0x0,%eax
 20b:	eb 11                	jmp    21e <atoo+0x53>
 20d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 212:	eb db                	jmp    1ef <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 214:	83 c2 01             	add    $0x1,%edx
 217:	0f be c9             	movsbl %cl,%ecx
 21a:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 21e:	0f b6 0a             	movzbl (%edx),%ecx
 221:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 224:	80 fb 07             	cmp    $0x7,%bl
 227:	76 eb                	jbe    214 <atoo+0x49>
  return sign*n;
 229:	0f af c7             	imul   %edi,%eax
}
 22c:	5b                   	pop    %ebx
 22d:	5e                   	pop    %esi
 22e:	5f                   	pop    %edi
 22f:	5d                   	pop    %ebp
 230:	c3                   	ret    

00000231 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 231:	f3 0f 1e fb          	endbr32 
 235:	55                   	push   %ebp
 236:	89 e5                	mov    %esp,%ebp
 238:	53                   	push   %ebx
 239:	8b 55 08             	mov    0x8(%ebp),%edx
 23c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 23f:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 242:	eb 09                	jmp    24d <strncmp+0x1c>
      n--, p++, q++;
 244:	83 e8 01             	sub    $0x1,%eax
 247:	83 c2 01             	add    $0x1,%edx
 24a:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 24d:	85 c0                	test   %eax,%eax
 24f:	74 0b                	je     25c <strncmp+0x2b>
 251:	0f b6 1a             	movzbl (%edx),%ebx
 254:	84 db                	test   %bl,%bl
 256:	74 04                	je     25c <strncmp+0x2b>
 258:	3a 19                	cmp    (%ecx),%bl
 25a:	74 e8                	je     244 <strncmp+0x13>
    if(n == 0)
 25c:	85 c0                	test   %eax,%eax
 25e:	74 0b                	je     26b <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 260:	0f b6 02             	movzbl (%edx),%eax
 263:	0f b6 11             	movzbl (%ecx),%edx
 266:	29 d0                	sub    %edx,%eax
}
 268:	5b                   	pop    %ebx
 269:	5d                   	pop    %ebp
 26a:	c3                   	ret    
      return 0;
 26b:	b8 00 00 00 00       	mov    $0x0,%eax
 270:	eb f6                	jmp    268 <strncmp+0x37>

00000272 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 272:	f3 0f 1e fb          	endbr32 
 276:	55                   	push   %ebp
 277:	89 e5                	mov    %esp,%ebp
 279:	56                   	push   %esi
 27a:	53                   	push   %ebx
 27b:	8b 75 08             	mov    0x8(%ebp),%esi
 27e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 281:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 284:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 286:	8d 58 ff             	lea    -0x1(%eax),%ebx
 289:	85 c0                	test   %eax,%eax
 28b:	7e 0f                	jle    29c <memmove+0x2a>
    *dst++ = *src++;
 28d:	0f b6 01             	movzbl (%ecx),%eax
 290:	88 02                	mov    %al,(%edx)
 292:	8d 49 01             	lea    0x1(%ecx),%ecx
 295:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 298:	89 d8                	mov    %ebx,%eax
 29a:	eb ea                	jmp    286 <memmove+0x14>
  return vdst;
}
 29c:	89 f0                	mov    %esi,%eax
 29e:	5b                   	pop    %ebx
 29f:	5e                   	pop    %esi
 2a0:	5d                   	pop    %ebp
 2a1:	c3                   	ret    

000002a2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2a2:	b8 01 00 00 00       	mov    $0x1,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <exit>:
SYSCALL(exit)
 2aa:	b8 02 00 00 00       	mov    $0x2,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <wait>:
SYSCALL(wait)
 2b2:	b8 03 00 00 00       	mov    $0x3,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <pipe>:
SYSCALL(pipe)
 2ba:	b8 04 00 00 00       	mov    $0x4,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <read>:
SYSCALL(read)
 2c2:	b8 05 00 00 00       	mov    $0x5,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <write>:
SYSCALL(write)
 2ca:	b8 10 00 00 00       	mov    $0x10,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <close>:
SYSCALL(close)
 2d2:	b8 15 00 00 00       	mov    $0x15,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <kill>:
SYSCALL(kill)
 2da:	b8 06 00 00 00       	mov    $0x6,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <exec>:
SYSCALL(exec)
 2e2:	b8 07 00 00 00       	mov    $0x7,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <open>:
SYSCALL(open)
 2ea:	b8 0f 00 00 00       	mov    $0xf,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <mknod>:
SYSCALL(mknod)
 2f2:	b8 11 00 00 00       	mov    $0x11,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <unlink>:
SYSCALL(unlink)
 2fa:	b8 12 00 00 00       	mov    $0x12,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <fstat>:
SYSCALL(fstat)
 302:	b8 08 00 00 00       	mov    $0x8,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <link>:
SYSCALL(link)
 30a:	b8 13 00 00 00       	mov    $0x13,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <mkdir>:
SYSCALL(mkdir)
 312:	b8 14 00 00 00       	mov    $0x14,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <chdir>:
SYSCALL(chdir)
 31a:	b8 09 00 00 00       	mov    $0x9,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <dup>:
SYSCALL(dup)
 322:	b8 0a 00 00 00       	mov    $0xa,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <getpid>:
SYSCALL(getpid)
 32a:	b8 0b 00 00 00       	mov    $0xb,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <sbrk>:
SYSCALL(sbrk)
 332:	b8 0c 00 00 00       	mov    $0xc,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <sleep>:
SYSCALL(sleep)
 33a:	b8 0d 00 00 00       	mov    $0xd,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <uptime>:
SYSCALL(uptime)
 342:	b8 0e 00 00 00       	mov    $0xe,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <halt>:
SYSCALL(halt)
 34a:	b8 16 00 00 00       	mov    $0x16,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <cps>:
/* ____My changes____ */
SYSCALL(cps)
 352:	b8 17 00 00 00       	mov    $0x17,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <getppid>:
SYSCALL(getppid)
 35a:	b8 18 00 00 00       	mov    $0x18,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <getsz>:
SYSCALL(getsz)
 362:	b8 19 00 00 00       	mov    $0x19,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <chpr>:
SYSCALL(chpr)
 36a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <getcount>:
SYSCALL(getcount)
 372:	b8 1b 00 00 00       	mov    $0x1b,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <time>:
SYSCALL(time)
 37a:	b8 1c 00 00 00       	mov    $0x1c,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <utctime>:
SYSCALL(utctime)
 382:	b8 1d 00 00 00       	mov    $0x1d,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <dup2>:
SYSCALL(dup2)
 38a:	b8 1e 00 00 00       	mov    $0x1e,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 392:	55                   	push   %ebp
 393:	89 e5                	mov    %esp,%ebp
 395:	83 ec 1c             	sub    $0x1c,%esp
 398:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 39b:	6a 01                	push   $0x1
 39d:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3a0:	52                   	push   %edx
 3a1:	50                   	push   %eax
 3a2:	e8 23 ff ff ff       	call   2ca <write>
}
 3a7:	83 c4 10             	add    $0x10,%esp
 3aa:	c9                   	leave  
 3ab:	c3                   	ret    

000003ac <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ac:	55                   	push   %ebp
 3ad:	89 e5                	mov    %esp,%ebp
 3af:	57                   	push   %edi
 3b0:	56                   	push   %esi
 3b1:	53                   	push   %ebx
 3b2:	83 ec 2c             	sub    $0x2c,%esp
 3b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
 3b8:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3be:	0f 95 c2             	setne  %dl
 3c1:	89 f0                	mov    %esi,%eax
 3c3:	c1 e8 1f             	shr    $0x1f,%eax
 3c6:	84 c2                	test   %al,%dl
 3c8:	74 42                	je     40c <printint+0x60>
    neg = 1;
    x = -xx;
 3ca:	f7 de                	neg    %esi
    neg = 1;
 3cc:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3d8:	89 f0                	mov    %esi,%eax
 3da:	ba 00 00 00 00       	mov    $0x0,%edx
 3df:	f7 f1                	div    %ecx
 3e1:	89 df                	mov    %ebx,%edi
 3e3:	83 c3 01             	add    $0x1,%ebx
 3e6:	0f b6 92 f8 06 00 00 	movzbl 0x6f8(%edx),%edx
 3ed:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3f1:	89 f2                	mov    %esi,%edx
 3f3:	89 c6                	mov    %eax,%esi
 3f5:	39 d1                	cmp    %edx,%ecx
 3f7:	76 df                	jbe    3d8 <printint+0x2c>
  if(neg)
 3f9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3fd:	74 2f                	je     42e <printint+0x82>
    buf[i++] = '-';
 3ff:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 404:	8d 5f 02             	lea    0x2(%edi),%ebx
 407:	8b 75 d0             	mov    -0x30(%ebp),%esi
 40a:	eb 15                	jmp    421 <printint+0x75>
  neg = 0;
 40c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 413:	eb be                	jmp    3d3 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 415:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 41a:	89 f0                	mov    %esi,%eax
 41c:	e8 71 ff ff ff       	call   392 <putc>
  while(--i >= 0)
 421:	83 eb 01             	sub    $0x1,%ebx
 424:	79 ef                	jns    415 <printint+0x69>
}
 426:	83 c4 2c             	add    $0x2c,%esp
 429:	5b                   	pop    %ebx
 42a:	5e                   	pop    %esi
 42b:	5f                   	pop    %edi
 42c:	5d                   	pop    %ebp
 42d:	c3                   	ret    
 42e:	8b 75 d0             	mov    -0x30(%ebp),%esi
 431:	eb ee                	jmp    421 <printint+0x75>

00000433 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 433:	f3 0f 1e fb          	endbr32 
 437:	55                   	push   %ebp
 438:	89 e5                	mov    %esp,%ebp
 43a:	57                   	push   %edi
 43b:	56                   	push   %esi
 43c:	53                   	push   %ebx
 43d:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 440:	8d 45 10             	lea    0x10(%ebp),%eax
 443:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 446:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 44b:	bb 00 00 00 00       	mov    $0x0,%ebx
 450:	eb 14                	jmp    466 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 452:	89 fa                	mov    %edi,%edx
 454:	8b 45 08             	mov    0x8(%ebp),%eax
 457:	e8 36 ff ff ff       	call   392 <putc>
 45c:	eb 05                	jmp    463 <printf+0x30>
      }
    } else if(state == '%'){
 45e:	83 fe 25             	cmp    $0x25,%esi
 461:	74 25                	je     488 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 463:	83 c3 01             	add    $0x1,%ebx
 466:	8b 45 0c             	mov    0xc(%ebp),%eax
 469:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 46d:	84 c0                	test   %al,%al
 46f:	0f 84 23 01 00 00    	je     598 <printf+0x165>
    c = fmt[i] & 0xff;
 475:	0f be f8             	movsbl %al,%edi
 478:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 47b:	85 f6                	test   %esi,%esi
 47d:	75 df                	jne    45e <printf+0x2b>
      if(c == '%'){
 47f:	83 f8 25             	cmp    $0x25,%eax
 482:	75 ce                	jne    452 <printf+0x1f>
        state = '%';
 484:	89 c6                	mov    %eax,%esi
 486:	eb db                	jmp    463 <printf+0x30>
      if(c == 'd'){
 488:	83 f8 64             	cmp    $0x64,%eax
 48b:	74 49                	je     4d6 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 48d:	83 f8 78             	cmp    $0x78,%eax
 490:	0f 94 c1             	sete   %cl
 493:	83 f8 70             	cmp    $0x70,%eax
 496:	0f 94 c2             	sete   %dl
 499:	08 d1                	or     %dl,%cl
 49b:	75 63                	jne    500 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 49d:	83 f8 73             	cmp    $0x73,%eax
 4a0:	0f 84 84 00 00 00    	je     52a <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4a6:	83 f8 63             	cmp    $0x63,%eax
 4a9:	0f 84 b7 00 00 00    	je     566 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4af:	83 f8 25             	cmp    $0x25,%eax
 4b2:	0f 84 cc 00 00 00    	je     584 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4b8:	ba 25 00 00 00       	mov    $0x25,%edx
 4bd:	8b 45 08             	mov    0x8(%ebp),%eax
 4c0:	e8 cd fe ff ff       	call   392 <putc>
        putc(fd, c);
 4c5:	89 fa                	mov    %edi,%edx
 4c7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ca:	e8 c3 fe ff ff       	call   392 <putc>
      }
      state = 0;
 4cf:	be 00 00 00 00       	mov    $0x0,%esi
 4d4:	eb 8d                	jmp    463 <printf+0x30>
        printint(fd, *ap, 10, 1);
 4d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4d9:	8b 17                	mov    (%edi),%edx
 4db:	83 ec 0c             	sub    $0xc,%esp
 4de:	6a 01                	push   $0x1
 4e0:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4e5:	8b 45 08             	mov    0x8(%ebp),%eax
 4e8:	e8 bf fe ff ff       	call   3ac <printint>
        ap++;
 4ed:	83 c7 04             	add    $0x4,%edi
 4f0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4f3:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4f6:	be 00 00 00 00       	mov    $0x0,%esi
 4fb:	e9 63 ff ff ff       	jmp    463 <printf+0x30>
        printint(fd, *ap, 16, 0);
 500:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 503:	8b 17                	mov    (%edi),%edx
 505:	83 ec 0c             	sub    $0xc,%esp
 508:	6a 00                	push   $0x0
 50a:	b9 10 00 00 00       	mov    $0x10,%ecx
 50f:	8b 45 08             	mov    0x8(%ebp),%eax
 512:	e8 95 fe ff ff       	call   3ac <printint>
        ap++;
 517:	83 c7 04             	add    $0x4,%edi
 51a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 51d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 520:	be 00 00 00 00       	mov    $0x0,%esi
 525:	e9 39 ff ff ff       	jmp    463 <printf+0x30>
        s = (char*)*ap;
 52a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 52d:	8b 30                	mov    (%eax),%esi
        ap++;
 52f:	83 c0 04             	add    $0x4,%eax
 532:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 535:	85 f6                	test   %esi,%esi
 537:	75 28                	jne    561 <printf+0x12e>
          s = "(null)";
 539:	be f0 06 00 00       	mov    $0x6f0,%esi
 53e:	8b 7d 08             	mov    0x8(%ebp),%edi
 541:	eb 0d                	jmp    550 <printf+0x11d>
          putc(fd, *s);
 543:	0f be d2             	movsbl %dl,%edx
 546:	89 f8                	mov    %edi,%eax
 548:	e8 45 fe ff ff       	call   392 <putc>
          s++;
 54d:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 550:	0f b6 16             	movzbl (%esi),%edx
 553:	84 d2                	test   %dl,%dl
 555:	75 ec                	jne    543 <printf+0x110>
      state = 0;
 557:	be 00 00 00 00       	mov    $0x0,%esi
 55c:	e9 02 ff ff ff       	jmp    463 <printf+0x30>
 561:	8b 7d 08             	mov    0x8(%ebp),%edi
 564:	eb ea                	jmp    550 <printf+0x11d>
        putc(fd, *ap);
 566:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 569:	0f be 17             	movsbl (%edi),%edx
 56c:	8b 45 08             	mov    0x8(%ebp),%eax
 56f:	e8 1e fe ff ff       	call   392 <putc>
        ap++;
 574:	83 c7 04             	add    $0x4,%edi
 577:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 57a:	be 00 00 00 00       	mov    $0x0,%esi
 57f:	e9 df fe ff ff       	jmp    463 <printf+0x30>
        putc(fd, c);
 584:	89 fa                	mov    %edi,%edx
 586:	8b 45 08             	mov    0x8(%ebp),%eax
 589:	e8 04 fe ff ff       	call   392 <putc>
      state = 0;
 58e:	be 00 00 00 00       	mov    $0x0,%esi
 593:	e9 cb fe ff ff       	jmp    463 <printf+0x30>
    }
  }
}
 598:	8d 65 f4             	lea    -0xc(%ebp),%esp
 59b:	5b                   	pop    %ebx
 59c:	5e                   	pop    %esi
 59d:	5f                   	pop    %edi
 59e:	5d                   	pop    %ebp
 59f:	c3                   	ret    

000005a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5a0:	f3 0f 1e fb          	endbr32 
 5a4:	55                   	push   %ebp
 5a5:	89 e5                	mov    %esp,%ebp
 5a7:	57                   	push   %edi
 5a8:	56                   	push   %esi
 5a9:	53                   	push   %ebx
 5aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ad:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b0:	a1 ec 09 00 00       	mov    0x9ec,%eax
 5b5:	eb 02                	jmp    5b9 <free+0x19>
 5b7:	89 d0                	mov    %edx,%eax
 5b9:	39 c8                	cmp    %ecx,%eax
 5bb:	73 04                	jae    5c1 <free+0x21>
 5bd:	39 08                	cmp    %ecx,(%eax)
 5bf:	77 12                	ja     5d3 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5c1:	8b 10                	mov    (%eax),%edx
 5c3:	39 c2                	cmp    %eax,%edx
 5c5:	77 f0                	ja     5b7 <free+0x17>
 5c7:	39 c8                	cmp    %ecx,%eax
 5c9:	72 08                	jb     5d3 <free+0x33>
 5cb:	39 ca                	cmp    %ecx,%edx
 5cd:	77 04                	ja     5d3 <free+0x33>
 5cf:	89 d0                	mov    %edx,%eax
 5d1:	eb e6                	jmp    5b9 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5d3:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5d6:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5d9:	8b 10                	mov    (%eax),%edx
 5db:	39 d7                	cmp    %edx,%edi
 5dd:	74 19                	je     5f8 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5df:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5e2:	8b 50 04             	mov    0x4(%eax),%edx
 5e5:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5e8:	39 ce                	cmp    %ecx,%esi
 5ea:	74 1b                	je     607 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5ec:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5ee:	a3 ec 09 00 00       	mov    %eax,0x9ec
}
 5f3:	5b                   	pop    %ebx
 5f4:	5e                   	pop    %esi
 5f5:	5f                   	pop    %edi
 5f6:	5d                   	pop    %ebp
 5f7:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5f8:	03 72 04             	add    0x4(%edx),%esi
 5fb:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5fe:	8b 10                	mov    (%eax),%edx
 600:	8b 12                	mov    (%edx),%edx
 602:	89 53 f8             	mov    %edx,-0x8(%ebx)
 605:	eb db                	jmp    5e2 <free+0x42>
    p->s.size += bp->s.size;
 607:	03 53 fc             	add    -0x4(%ebx),%edx
 60a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 60d:	8b 53 f8             	mov    -0x8(%ebx),%edx
 610:	89 10                	mov    %edx,(%eax)
 612:	eb da                	jmp    5ee <free+0x4e>

00000614 <morecore>:

static Header*
morecore(uint nu)
{
 614:	55                   	push   %ebp
 615:	89 e5                	mov    %esp,%ebp
 617:	53                   	push   %ebx
 618:	83 ec 04             	sub    $0x4,%esp
 61b:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 61d:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 622:	77 05                	ja     629 <morecore+0x15>
    nu = 4096;
 624:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 629:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 630:	83 ec 0c             	sub    $0xc,%esp
 633:	50                   	push   %eax
 634:	e8 f9 fc ff ff       	call   332 <sbrk>
  if(p == (char*)-1)
 639:	83 c4 10             	add    $0x10,%esp
 63c:	83 f8 ff             	cmp    $0xffffffff,%eax
 63f:	74 1c                	je     65d <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 641:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 644:	83 c0 08             	add    $0x8,%eax
 647:	83 ec 0c             	sub    $0xc,%esp
 64a:	50                   	push   %eax
 64b:	e8 50 ff ff ff       	call   5a0 <free>
  return freep;
 650:	a1 ec 09 00 00       	mov    0x9ec,%eax
 655:	83 c4 10             	add    $0x10,%esp
}
 658:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 65b:	c9                   	leave  
 65c:	c3                   	ret    
    return 0;
 65d:	b8 00 00 00 00       	mov    $0x0,%eax
 662:	eb f4                	jmp    658 <morecore+0x44>

00000664 <malloc>:

void*
malloc(uint nbytes)
{
 664:	f3 0f 1e fb          	endbr32 
 668:	55                   	push   %ebp
 669:	89 e5                	mov    %esp,%ebp
 66b:	53                   	push   %ebx
 66c:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 66f:	8b 45 08             	mov    0x8(%ebp),%eax
 672:	8d 58 07             	lea    0x7(%eax),%ebx
 675:	c1 eb 03             	shr    $0x3,%ebx
 678:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 67b:	8b 0d ec 09 00 00    	mov    0x9ec,%ecx
 681:	85 c9                	test   %ecx,%ecx
 683:	74 04                	je     689 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 685:	8b 01                	mov    (%ecx),%eax
 687:	eb 4b                	jmp    6d4 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 689:	c7 05 ec 09 00 00 f0 	movl   $0x9f0,0x9ec
 690:	09 00 00 
 693:	c7 05 f0 09 00 00 f0 	movl   $0x9f0,0x9f0
 69a:	09 00 00 
    base.s.size = 0;
 69d:	c7 05 f4 09 00 00 00 	movl   $0x0,0x9f4
 6a4:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6a7:	b9 f0 09 00 00       	mov    $0x9f0,%ecx
 6ac:	eb d7                	jmp    685 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 6ae:	74 1a                	je     6ca <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6b0:	29 da                	sub    %ebx,%edx
 6b2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 6b5:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 6b8:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6bb:	89 0d ec 09 00 00    	mov    %ecx,0x9ec
      return (void*)(p + 1);
 6c1:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6c4:	83 c4 04             	add    $0x4,%esp
 6c7:	5b                   	pop    %ebx
 6c8:	5d                   	pop    %ebp
 6c9:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6ca:	8b 10                	mov    (%eax),%edx
 6cc:	89 11                	mov    %edx,(%ecx)
 6ce:	eb eb                	jmp    6bb <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d0:	89 c1                	mov    %eax,%ecx
 6d2:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 6d4:	8b 50 04             	mov    0x4(%eax),%edx
 6d7:	39 da                	cmp    %ebx,%edx
 6d9:	73 d3                	jae    6ae <malloc+0x4a>
    if(p == freep)
 6db:	39 05 ec 09 00 00    	cmp    %eax,0x9ec
 6e1:	75 ed                	jne    6d0 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 6e3:	89 d8                	mov    %ebx,%eax
 6e5:	e8 2a ff ff ff       	call   614 <morecore>
 6ea:	85 c0                	test   %eax,%eax
 6ec:	75 e2                	jne    6d0 <malloc+0x6c>
 6ee:	eb d4                	jmp    6c4 <malloc+0x60>
