
_test_getppid:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
*/

#include "types.h"
#include "user.h"

int main(void) {
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	53                   	push   %ebx
  14:	51                   	push   %ecx
  15:	83 ec 08             	sub    $0x8,%esp
    int parent = getpid();
  18:	e8 73 03 00 00       	call   390 <getpid>
  1d:	89 c6                	mov    %eax,%esi
    int child = fork();                  // replicate the current process
  1f:	e8 e4 02 00 00       	call   308 <fork>
  24:	89 c3                	mov    %eax,%ebx
    if(child == 0) {
  26:	85 c0                	test   %eax,%eax
  28:	75 27                	jne    51 <main+0x51>
        printf(1, "child: parent=%d child=%d getpid()=%d getppid()=%d\n",
  2a:	e8 91 03 00 00       	call   3c0 <getppid>
  2f:	89 c7                	mov    %eax,%edi
  31:	e8 5a 03 00 00       	call   390 <getpid>
  36:	83 ec 08             	sub    $0x8,%esp
  39:	57                   	push   %edi
  3a:	50                   	push   %eax
  3b:	53                   	push   %ebx
  3c:	56                   	push   %esi
  3d:	68 58 07 00 00       	push   $0x758
  42:	6a 01                	push   $0x1
  44:	e8 50 04 00 00       	call   499 <printf>
  49:	83 c4 20             	add    $0x20,%esp
    } else {
        wait();
        printf(1, "parent: parent=%d child=%d getpid()=%d getppid()=%d\n",
                parent, child, getpid(), getppid());
    }
    exit();
  4c:	e8 bf 02 00 00       	call   310 <exit>
        wait();
  51:	e8 c2 02 00 00       	call   318 <wait>
        printf(1, "parent: parent=%d child=%d getpid()=%d getppid()=%d\n",
  56:	e8 65 03 00 00       	call   3c0 <getppid>
  5b:	89 c7                	mov    %eax,%edi
  5d:	e8 2e 03 00 00       	call   390 <getpid>
  62:	83 ec 08             	sub    $0x8,%esp
  65:	57                   	push   %edi
  66:	50                   	push   %eax
  67:	53                   	push   %ebx
  68:	56                   	push   %esi
  69:	68 8c 07 00 00       	push   $0x78c
  6e:	6a 01                	push   $0x1
  70:	e8 24 04 00 00       	call   499 <printf>
  75:	83 c4 20             	add    $0x20,%esp
  78:	eb d2                	jmp    4c <main+0x4c>

0000007a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  7a:	f3 0f 1e fb          	endbr32 
  7e:	55                   	push   %ebp
  7f:	89 e5                	mov    %esp,%ebp
  81:	56                   	push   %esi
  82:	53                   	push   %ebx
  83:	8b 75 08             	mov    0x8(%ebp),%esi
  86:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  89:	89 f0                	mov    %esi,%eax
  8b:	89 d1                	mov    %edx,%ecx
  8d:	83 c2 01             	add    $0x1,%edx
  90:	89 c3                	mov    %eax,%ebx
  92:	83 c0 01             	add    $0x1,%eax
  95:	0f b6 09             	movzbl (%ecx),%ecx
  98:	88 0b                	mov    %cl,(%ebx)
  9a:	84 c9                	test   %cl,%cl
  9c:	75 ed                	jne    8b <strcpy+0x11>
    ;
  return os;
}
  9e:	89 f0                	mov    %esi,%eax
  a0:	5b                   	pop    %ebx
  a1:	5e                   	pop    %esi
  a2:	5d                   	pop    %ebp
  a3:	c3                   	ret    

000000a4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a4:	f3 0f 1e fb          	endbr32 
  a8:	55                   	push   %ebp
  a9:	89 e5                	mov    %esp,%ebp
  ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  b1:	0f b6 01             	movzbl (%ecx),%eax
  b4:	84 c0                	test   %al,%al
  b6:	74 0c                	je     c4 <strcmp+0x20>
  b8:	3a 02                	cmp    (%edx),%al
  ba:	75 08                	jne    c4 <strcmp+0x20>
    p++, q++;
  bc:	83 c1 01             	add    $0x1,%ecx
  bf:	83 c2 01             	add    $0x1,%edx
  c2:	eb ed                	jmp    b1 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  c4:	0f b6 c0             	movzbl %al,%eax
  c7:	0f b6 12             	movzbl (%edx),%edx
  ca:	29 d0                	sub    %edx,%eax
}
  cc:	5d                   	pop    %ebp
  cd:	c3                   	ret    

000000ce <strlen>:

uint
strlen(char *s)
{
  ce:	f3 0f 1e fb          	endbr32 
  d2:	55                   	push   %ebp
  d3:	89 e5                	mov    %esp,%ebp
  d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  d8:	b8 00 00 00 00       	mov    $0x0,%eax
  dd:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  e1:	74 05                	je     e8 <strlen+0x1a>
  e3:	83 c0 01             	add    $0x1,%eax
  e6:	eb f5                	jmp    dd <strlen+0xf>
    ;
  return n;
}
  e8:	5d                   	pop    %ebp
  e9:	c3                   	ret    

000000ea <memset>:

void*
memset(void *dst, int c, uint n)
{
  ea:	f3 0f 1e fb          	endbr32 
  ee:	55                   	push   %ebp
  ef:	89 e5                	mov    %esp,%ebp
  f1:	57                   	push   %edi
  f2:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  f5:	89 d7                	mov    %edx,%edi
  f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	fc                   	cld    
  fe:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 100:	89 d0                	mov    %edx,%eax
 102:	5f                   	pop    %edi
 103:	5d                   	pop    %ebp
 104:	c3                   	ret    

00000105 <strchr>:

char*
strchr(const char *s, char c)
{
 105:	f3 0f 1e fb          	endbr32 
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	8b 45 08             	mov    0x8(%ebp),%eax
 10f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 113:	0f b6 10             	movzbl (%eax),%edx
 116:	84 d2                	test   %dl,%dl
 118:	74 09                	je     123 <strchr+0x1e>
    if(*s == c)
 11a:	38 ca                	cmp    %cl,%dl
 11c:	74 0a                	je     128 <strchr+0x23>
  for(; *s; s++)
 11e:	83 c0 01             	add    $0x1,%eax
 121:	eb f0                	jmp    113 <strchr+0xe>
      return (char*)s;
  return 0;
 123:	b8 00 00 00 00       	mov    $0x0,%eax
}
 128:	5d                   	pop    %ebp
 129:	c3                   	ret    

0000012a <gets>:

char*
gets(char *buf, int max)
{
 12a:	f3 0f 1e fb          	endbr32 
 12e:	55                   	push   %ebp
 12f:	89 e5                	mov    %esp,%ebp
 131:	57                   	push   %edi
 132:	56                   	push   %esi
 133:	53                   	push   %ebx
 134:	83 ec 1c             	sub    $0x1c,%esp
 137:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13a:	bb 00 00 00 00       	mov    $0x0,%ebx
 13f:	89 de                	mov    %ebx,%esi
 141:	83 c3 01             	add    $0x1,%ebx
 144:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 147:	7d 2e                	jge    177 <gets+0x4d>
    cc = read(0, &c, 1);
 149:	83 ec 04             	sub    $0x4,%esp
 14c:	6a 01                	push   $0x1
 14e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 151:	50                   	push   %eax
 152:	6a 00                	push   $0x0
 154:	e8 cf 01 00 00       	call   328 <read>
    if(cc < 1)
 159:	83 c4 10             	add    $0x10,%esp
 15c:	85 c0                	test   %eax,%eax
 15e:	7e 17                	jle    177 <gets+0x4d>
      break;
    buf[i++] = c;
 160:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 164:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 167:	3c 0a                	cmp    $0xa,%al
 169:	0f 94 c2             	sete   %dl
 16c:	3c 0d                	cmp    $0xd,%al
 16e:	0f 94 c0             	sete   %al
 171:	08 c2                	or     %al,%dl
 173:	74 ca                	je     13f <gets+0x15>
    buf[i++] = c;
 175:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 177:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 17b:	89 f8                	mov    %edi,%eax
 17d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 180:	5b                   	pop    %ebx
 181:	5e                   	pop    %esi
 182:	5f                   	pop    %edi
 183:	5d                   	pop    %ebp
 184:	c3                   	ret    

00000185 <stat>:

int
stat(char *n, struct stat *st)
{
 185:	f3 0f 1e fb          	endbr32 
 189:	55                   	push   %ebp
 18a:	89 e5                	mov    %esp,%ebp
 18c:	56                   	push   %esi
 18d:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18e:	83 ec 08             	sub    $0x8,%esp
 191:	6a 00                	push   $0x0
 193:	ff 75 08             	pushl  0x8(%ebp)
 196:	e8 b5 01 00 00       	call   350 <open>
  if(fd < 0)
 19b:	83 c4 10             	add    $0x10,%esp
 19e:	85 c0                	test   %eax,%eax
 1a0:	78 24                	js     1c6 <stat+0x41>
 1a2:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1a4:	83 ec 08             	sub    $0x8,%esp
 1a7:	ff 75 0c             	pushl  0xc(%ebp)
 1aa:	50                   	push   %eax
 1ab:	e8 b8 01 00 00       	call   368 <fstat>
 1b0:	89 c6                	mov    %eax,%esi
  close(fd);
 1b2:	89 1c 24             	mov    %ebx,(%esp)
 1b5:	e8 7e 01 00 00       	call   338 <close>
  return r;
 1ba:	83 c4 10             	add    $0x10,%esp
}
 1bd:	89 f0                	mov    %esi,%eax
 1bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1c2:	5b                   	pop    %ebx
 1c3:	5e                   	pop    %esi
 1c4:	5d                   	pop    %ebp
 1c5:	c3                   	ret    
    return -1;
 1c6:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1cb:	eb f0                	jmp    1bd <stat+0x38>

000001cd <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 1cd:	f3 0f 1e fb          	endbr32 
 1d1:	55                   	push   %ebp
 1d2:	89 e5                	mov    %esp,%ebp
 1d4:	57                   	push   %edi
 1d5:	56                   	push   %esi
 1d6:	53                   	push   %ebx
 1d7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1da:	0f b6 02             	movzbl (%edx),%eax
 1dd:	3c 20                	cmp    $0x20,%al
 1df:	75 05                	jne    1e6 <atoi+0x19>
 1e1:	83 c2 01             	add    $0x1,%edx
 1e4:	eb f4                	jmp    1da <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 1e6:	3c 2d                	cmp    $0x2d,%al
 1e8:	74 1d                	je     207 <atoi+0x3a>
 1ea:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 1ef:	3c 2b                	cmp    $0x2b,%al
 1f1:	0f 94 c1             	sete   %cl
 1f4:	3c 2d                	cmp    $0x2d,%al
 1f6:	0f 94 c0             	sete   %al
 1f9:	08 c1                	or     %al,%cl
 1fb:	74 03                	je     200 <atoi+0x33>
    s++;
 1fd:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 200:	b8 00 00 00 00       	mov    $0x0,%eax
 205:	eb 17                	jmp    21e <atoi+0x51>
 207:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 20c:	eb e1                	jmp    1ef <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 20e:	8d 34 80             	lea    (%eax,%eax,4),%esi
 211:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 214:	83 c2 01             	add    $0x1,%edx
 217:	0f be c9             	movsbl %cl,%ecx
 21a:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 21e:	0f b6 0a             	movzbl (%edx),%ecx
 221:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 224:	80 fb 09             	cmp    $0x9,%bl
 227:	76 e5                	jbe    20e <atoi+0x41>
  return sign*n;
 229:	0f af c7             	imul   %edi,%eax
}
 22c:	5b                   	pop    %ebx
 22d:	5e                   	pop    %esi
 22e:	5f                   	pop    %edi
 22f:	5d                   	pop    %ebp
 230:	c3                   	ret    

00000231 <atoo>:

int
atoo(const char *s)
{
 231:	f3 0f 1e fb          	endbr32 
 235:	55                   	push   %ebp
 236:	89 e5                	mov    %esp,%ebp
 238:	57                   	push   %edi
 239:	56                   	push   %esi
 23a:	53                   	push   %ebx
 23b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 23e:	0f b6 0a             	movzbl (%edx),%ecx
 241:	80 f9 20             	cmp    $0x20,%cl
 244:	75 05                	jne    24b <atoo+0x1a>
 246:	83 c2 01             	add    $0x1,%edx
 249:	eb f3                	jmp    23e <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 24b:	80 f9 2d             	cmp    $0x2d,%cl
 24e:	74 23                	je     273 <atoo+0x42>
 250:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 255:	80 f9 2b             	cmp    $0x2b,%cl
 258:	0f 94 c0             	sete   %al
 25b:	89 c6                	mov    %eax,%esi
 25d:	80 f9 2d             	cmp    $0x2d,%cl
 260:	0f 94 c0             	sete   %al
 263:	89 f3                	mov    %esi,%ebx
 265:	08 c3                	or     %al,%bl
 267:	74 03                	je     26c <atoo+0x3b>
    s++;
 269:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 26c:	b8 00 00 00 00       	mov    $0x0,%eax
 271:	eb 11                	jmp    284 <atoo+0x53>
 273:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 278:	eb db                	jmp    255 <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 27a:	83 c2 01             	add    $0x1,%edx
 27d:	0f be c9             	movsbl %cl,%ecx
 280:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 284:	0f b6 0a             	movzbl (%edx),%ecx
 287:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 28a:	80 fb 07             	cmp    $0x7,%bl
 28d:	76 eb                	jbe    27a <atoo+0x49>
  return sign*n;
 28f:	0f af c7             	imul   %edi,%eax
}
 292:	5b                   	pop    %ebx
 293:	5e                   	pop    %esi
 294:	5f                   	pop    %edi
 295:	5d                   	pop    %ebp
 296:	c3                   	ret    

00000297 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 297:	f3 0f 1e fb          	endbr32 
 29b:	55                   	push   %ebp
 29c:	89 e5                	mov    %esp,%ebp
 29e:	53                   	push   %ebx
 29f:	8b 55 08             	mov    0x8(%ebp),%edx
 2a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2a5:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 2a8:	eb 09                	jmp    2b3 <strncmp+0x1c>
      n--, p++, q++;
 2aa:	83 e8 01             	sub    $0x1,%eax
 2ad:	83 c2 01             	add    $0x1,%edx
 2b0:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 2b3:	85 c0                	test   %eax,%eax
 2b5:	74 0b                	je     2c2 <strncmp+0x2b>
 2b7:	0f b6 1a             	movzbl (%edx),%ebx
 2ba:	84 db                	test   %bl,%bl
 2bc:	74 04                	je     2c2 <strncmp+0x2b>
 2be:	3a 19                	cmp    (%ecx),%bl
 2c0:	74 e8                	je     2aa <strncmp+0x13>
    if(n == 0)
 2c2:	85 c0                	test   %eax,%eax
 2c4:	74 0b                	je     2d1 <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 2c6:	0f b6 02             	movzbl (%edx),%eax
 2c9:	0f b6 11             	movzbl (%ecx),%edx
 2cc:	29 d0                	sub    %edx,%eax
}
 2ce:	5b                   	pop    %ebx
 2cf:	5d                   	pop    %ebp
 2d0:	c3                   	ret    
      return 0;
 2d1:	b8 00 00 00 00       	mov    $0x0,%eax
 2d6:	eb f6                	jmp    2ce <strncmp+0x37>

000002d8 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 2d8:	f3 0f 1e fb          	endbr32 
 2dc:	55                   	push   %ebp
 2dd:	89 e5                	mov    %esp,%ebp
 2df:	56                   	push   %esi
 2e0:	53                   	push   %ebx
 2e1:	8b 75 08             	mov    0x8(%ebp),%esi
 2e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2e7:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 2ea:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 2ec:	8d 58 ff             	lea    -0x1(%eax),%ebx
 2ef:	85 c0                	test   %eax,%eax
 2f1:	7e 0f                	jle    302 <memmove+0x2a>
    *dst++ = *src++;
 2f3:	0f b6 01             	movzbl (%ecx),%eax
 2f6:	88 02                	mov    %al,(%edx)
 2f8:	8d 49 01             	lea    0x1(%ecx),%ecx
 2fb:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 2fe:	89 d8                	mov    %ebx,%eax
 300:	eb ea                	jmp    2ec <memmove+0x14>
  return vdst;
}
 302:	89 f0                	mov    %esi,%eax
 304:	5b                   	pop    %ebx
 305:	5e                   	pop    %esi
 306:	5d                   	pop    %ebp
 307:	c3                   	ret    

00000308 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 308:	b8 01 00 00 00       	mov    $0x1,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <exit>:
SYSCALL(exit)
 310:	b8 02 00 00 00       	mov    $0x2,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <wait>:
SYSCALL(wait)
 318:	b8 03 00 00 00       	mov    $0x3,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <pipe>:
SYSCALL(pipe)
 320:	b8 04 00 00 00       	mov    $0x4,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <read>:
SYSCALL(read)
 328:	b8 05 00 00 00       	mov    $0x5,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <write>:
SYSCALL(write)
 330:	b8 10 00 00 00       	mov    $0x10,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <close>:
SYSCALL(close)
 338:	b8 15 00 00 00       	mov    $0x15,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <kill>:
SYSCALL(kill)
 340:	b8 06 00 00 00       	mov    $0x6,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <exec>:
SYSCALL(exec)
 348:	b8 07 00 00 00       	mov    $0x7,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <open>:
SYSCALL(open)
 350:	b8 0f 00 00 00       	mov    $0xf,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <mknod>:
SYSCALL(mknod)
 358:	b8 11 00 00 00       	mov    $0x11,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <unlink>:
SYSCALL(unlink)
 360:	b8 12 00 00 00       	mov    $0x12,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <fstat>:
SYSCALL(fstat)
 368:	b8 08 00 00 00       	mov    $0x8,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <link>:
SYSCALL(link)
 370:	b8 13 00 00 00       	mov    $0x13,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <mkdir>:
SYSCALL(mkdir)
 378:	b8 14 00 00 00       	mov    $0x14,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <chdir>:
SYSCALL(chdir)
 380:	b8 09 00 00 00       	mov    $0x9,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <dup>:
SYSCALL(dup)
 388:	b8 0a 00 00 00       	mov    $0xa,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <getpid>:
SYSCALL(getpid)
 390:	b8 0b 00 00 00       	mov    $0xb,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <sbrk>:
SYSCALL(sbrk)
 398:	b8 0c 00 00 00       	mov    $0xc,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <sleep>:
SYSCALL(sleep)
 3a0:	b8 0d 00 00 00       	mov    $0xd,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <uptime>:
SYSCALL(uptime)
 3a8:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <halt>:
SYSCALL(halt)
 3b0:	b8 16 00 00 00       	mov    $0x16,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <cps>:
/* ____My changes____ */
SYSCALL(cps)
 3b8:	b8 17 00 00 00       	mov    $0x17,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <getppid>:
SYSCALL(getppid)
 3c0:	b8 18 00 00 00       	mov    $0x18,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <getsz>:
SYSCALL(getsz)
 3c8:	b8 19 00 00 00       	mov    $0x19,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <chpr>:
SYSCALL(chpr)
 3d0:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <getcount>:
SYSCALL(getcount)
 3d8:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <time>:
SYSCALL(time)
 3e0:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <utctime>:
SYSCALL(utctime)
 3e8:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <dup2>:
SYSCALL(dup2)
 3f0:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3f8:	55                   	push   %ebp
 3f9:	89 e5                	mov    %esp,%ebp
 3fb:	83 ec 1c             	sub    $0x1c,%esp
 3fe:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 401:	6a 01                	push   $0x1
 403:	8d 55 f4             	lea    -0xc(%ebp),%edx
 406:	52                   	push   %edx
 407:	50                   	push   %eax
 408:	e8 23 ff ff ff       	call   330 <write>
}
 40d:	83 c4 10             	add    $0x10,%esp
 410:	c9                   	leave  
 411:	c3                   	ret    

00000412 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 412:	55                   	push   %ebp
 413:	89 e5                	mov    %esp,%ebp
 415:	57                   	push   %edi
 416:	56                   	push   %esi
 417:	53                   	push   %ebx
 418:	83 ec 2c             	sub    $0x2c,%esp
 41b:	89 45 d0             	mov    %eax,-0x30(%ebp)
 41e:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 420:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 424:	0f 95 c2             	setne  %dl
 427:	89 f0                	mov    %esi,%eax
 429:	c1 e8 1f             	shr    $0x1f,%eax
 42c:	84 c2                	test   %al,%dl
 42e:	74 42                	je     472 <printint+0x60>
    neg = 1;
    x = -xx;
 430:	f7 de                	neg    %esi
    neg = 1;
 432:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 439:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 43e:	89 f0                	mov    %esi,%eax
 440:	ba 00 00 00 00       	mov    $0x0,%edx
 445:	f7 f1                	div    %ecx
 447:	89 df                	mov    %ebx,%edi
 449:	83 c3 01             	add    $0x1,%ebx
 44c:	0f b6 92 c8 07 00 00 	movzbl 0x7c8(%edx),%edx
 453:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 457:	89 f2                	mov    %esi,%edx
 459:	89 c6                	mov    %eax,%esi
 45b:	39 d1                	cmp    %edx,%ecx
 45d:	76 df                	jbe    43e <printint+0x2c>
  if(neg)
 45f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 463:	74 2f                	je     494 <printint+0x82>
    buf[i++] = '-';
 465:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 46a:	8d 5f 02             	lea    0x2(%edi),%ebx
 46d:	8b 75 d0             	mov    -0x30(%ebp),%esi
 470:	eb 15                	jmp    487 <printint+0x75>
  neg = 0;
 472:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 479:	eb be                	jmp    439 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 47b:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 480:	89 f0                	mov    %esi,%eax
 482:	e8 71 ff ff ff       	call   3f8 <putc>
  while(--i >= 0)
 487:	83 eb 01             	sub    $0x1,%ebx
 48a:	79 ef                	jns    47b <printint+0x69>
}
 48c:	83 c4 2c             	add    $0x2c,%esp
 48f:	5b                   	pop    %ebx
 490:	5e                   	pop    %esi
 491:	5f                   	pop    %edi
 492:	5d                   	pop    %ebp
 493:	c3                   	ret    
 494:	8b 75 d0             	mov    -0x30(%ebp),%esi
 497:	eb ee                	jmp    487 <printint+0x75>

00000499 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 499:	f3 0f 1e fb          	endbr32 
 49d:	55                   	push   %ebp
 49e:	89 e5                	mov    %esp,%ebp
 4a0:	57                   	push   %edi
 4a1:	56                   	push   %esi
 4a2:	53                   	push   %ebx
 4a3:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4a6:	8d 45 10             	lea    0x10(%ebp),%eax
 4a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 4ac:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 4b1:	bb 00 00 00 00       	mov    $0x0,%ebx
 4b6:	eb 14                	jmp    4cc <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4b8:	89 fa                	mov    %edi,%edx
 4ba:	8b 45 08             	mov    0x8(%ebp),%eax
 4bd:	e8 36 ff ff ff       	call   3f8 <putc>
 4c2:	eb 05                	jmp    4c9 <printf+0x30>
      }
    } else if(state == '%'){
 4c4:	83 fe 25             	cmp    $0x25,%esi
 4c7:	74 25                	je     4ee <printf+0x55>
  for(i = 0; fmt[i]; i++){
 4c9:	83 c3 01             	add    $0x1,%ebx
 4cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 4cf:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 4d3:	84 c0                	test   %al,%al
 4d5:	0f 84 23 01 00 00    	je     5fe <printf+0x165>
    c = fmt[i] & 0xff;
 4db:	0f be f8             	movsbl %al,%edi
 4de:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 4e1:	85 f6                	test   %esi,%esi
 4e3:	75 df                	jne    4c4 <printf+0x2b>
      if(c == '%'){
 4e5:	83 f8 25             	cmp    $0x25,%eax
 4e8:	75 ce                	jne    4b8 <printf+0x1f>
        state = '%';
 4ea:	89 c6                	mov    %eax,%esi
 4ec:	eb db                	jmp    4c9 <printf+0x30>
      if(c == 'd'){
 4ee:	83 f8 64             	cmp    $0x64,%eax
 4f1:	74 49                	je     53c <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4f3:	83 f8 78             	cmp    $0x78,%eax
 4f6:	0f 94 c1             	sete   %cl
 4f9:	83 f8 70             	cmp    $0x70,%eax
 4fc:	0f 94 c2             	sete   %dl
 4ff:	08 d1                	or     %dl,%cl
 501:	75 63                	jne    566 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 503:	83 f8 73             	cmp    $0x73,%eax
 506:	0f 84 84 00 00 00    	je     590 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 50c:	83 f8 63             	cmp    $0x63,%eax
 50f:	0f 84 b7 00 00 00    	je     5cc <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 515:	83 f8 25             	cmp    $0x25,%eax
 518:	0f 84 cc 00 00 00    	je     5ea <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 51e:	ba 25 00 00 00       	mov    $0x25,%edx
 523:	8b 45 08             	mov    0x8(%ebp),%eax
 526:	e8 cd fe ff ff       	call   3f8 <putc>
        putc(fd, c);
 52b:	89 fa                	mov    %edi,%edx
 52d:	8b 45 08             	mov    0x8(%ebp),%eax
 530:	e8 c3 fe ff ff       	call   3f8 <putc>
      }
      state = 0;
 535:	be 00 00 00 00       	mov    $0x0,%esi
 53a:	eb 8d                	jmp    4c9 <printf+0x30>
        printint(fd, *ap, 10, 1);
 53c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 53f:	8b 17                	mov    (%edi),%edx
 541:	83 ec 0c             	sub    $0xc,%esp
 544:	6a 01                	push   $0x1
 546:	b9 0a 00 00 00       	mov    $0xa,%ecx
 54b:	8b 45 08             	mov    0x8(%ebp),%eax
 54e:	e8 bf fe ff ff       	call   412 <printint>
        ap++;
 553:	83 c7 04             	add    $0x4,%edi
 556:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 559:	83 c4 10             	add    $0x10,%esp
      state = 0;
 55c:	be 00 00 00 00       	mov    $0x0,%esi
 561:	e9 63 ff ff ff       	jmp    4c9 <printf+0x30>
        printint(fd, *ap, 16, 0);
 566:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 569:	8b 17                	mov    (%edi),%edx
 56b:	83 ec 0c             	sub    $0xc,%esp
 56e:	6a 00                	push   $0x0
 570:	b9 10 00 00 00       	mov    $0x10,%ecx
 575:	8b 45 08             	mov    0x8(%ebp),%eax
 578:	e8 95 fe ff ff       	call   412 <printint>
        ap++;
 57d:	83 c7 04             	add    $0x4,%edi
 580:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 583:	83 c4 10             	add    $0x10,%esp
      state = 0;
 586:	be 00 00 00 00       	mov    $0x0,%esi
 58b:	e9 39 ff ff ff       	jmp    4c9 <printf+0x30>
        s = (char*)*ap;
 590:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 593:	8b 30                	mov    (%eax),%esi
        ap++;
 595:	83 c0 04             	add    $0x4,%eax
 598:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 59b:	85 f6                	test   %esi,%esi
 59d:	75 28                	jne    5c7 <printf+0x12e>
          s = "(null)";
 59f:	be c1 07 00 00       	mov    $0x7c1,%esi
 5a4:	8b 7d 08             	mov    0x8(%ebp),%edi
 5a7:	eb 0d                	jmp    5b6 <printf+0x11d>
          putc(fd, *s);
 5a9:	0f be d2             	movsbl %dl,%edx
 5ac:	89 f8                	mov    %edi,%eax
 5ae:	e8 45 fe ff ff       	call   3f8 <putc>
          s++;
 5b3:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 5b6:	0f b6 16             	movzbl (%esi),%edx
 5b9:	84 d2                	test   %dl,%dl
 5bb:	75 ec                	jne    5a9 <printf+0x110>
      state = 0;
 5bd:	be 00 00 00 00       	mov    $0x0,%esi
 5c2:	e9 02 ff ff ff       	jmp    4c9 <printf+0x30>
 5c7:	8b 7d 08             	mov    0x8(%ebp),%edi
 5ca:	eb ea                	jmp    5b6 <printf+0x11d>
        putc(fd, *ap);
 5cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5cf:	0f be 17             	movsbl (%edi),%edx
 5d2:	8b 45 08             	mov    0x8(%ebp),%eax
 5d5:	e8 1e fe ff ff       	call   3f8 <putc>
        ap++;
 5da:	83 c7 04             	add    $0x4,%edi
 5dd:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 5e0:	be 00 00 00 00       	mov    $0x0,%esi
 5e5:	e9 df fe ff ff       	jmp    4c9 <printf+0x30>
        putc(fd, c);
 5ea:	89 fa                	mov    %edi,%edx
 5ec:	8b 45 08             	mov    0x8(%ebp),%eax
 5ef:	e8 04 fe ff ff       	call   3f8 <putc>
      state = 0;
 5f4:	be 00 00 00 00       	mov    $0x0,%esi
 5f9:	e9 cb fe ff ff       	jmp    4c9 <printf+0x30>
    }
  }
}
 5fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
 601:	5b                   	pop    %ebx
 602:	5e                   	pop    %esi
 603:	5f                   	pop    %edi
 604:	5d                   	pop    %ebp
 605:	c3                   	ret    

00000606 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 606:	f3 0f 1e fb          	endbr32 
 60a:	55                   	push   %ebp
 60b:	89 e5                	mov    %esp,%ebp
 60d:	57                   	push   %edi
 60e:	56                   	push   %esi
 60f:	53                   	push   %ebx
 610:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 613:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 616:	a1 d0 0a 00 00       	mov    0xad0,%eax
 61b:	eb 02                	jmp    61f <free+0x19>
 61d:	89 d0                	mov    %edx,%eax
 61f:	39 c8                	cmp    %ecx,%eax
 621:	73 04                	jae    627 <free+0x21>
 623:	39 08                	cmp    %ecx,(%eax)
 625:	77 12                	ja     639 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 627:	8b 10                	mov    (%eax),%edx
 629:	39 c2                	cmp    %eax,%edx
 62b:	77 f0                	ja     61d <free+0x17>
 62d:	39 c8                	cmp    %ecx,%eax
 62f:	72 08                	jb     639 <free+0x33>
 631:	39 ca                	cmp    %ecx,%edx
 633:	77 04                	ja     639 <free+0x33>
 635:	89 d0                	mov    %edx,%eax
 637:	eb e6                	jmp    61f <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 639:	8b 73 fc             	mov    -0x4(%ebx),%esi
 63c:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 63f:	8b 10                	mov    (%eax),%edx
 641:	39 d7                	cmp    %edx,%edi
 643:	74 19                	je     65e <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 645:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 648:	8b 50 04             	mov    0x4(%eax),%edx
 64b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 64e:	39 ce                	cmp    %ecx,%esi
 650:	74 1b                	je     66d <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 652:	89 08                	mov    %ecx,(%eax)
  freep = p;
 654:	a3 d0 0a 00 00       	mov    %eax,0xad0
}
 659:	5b                   	pop    %ebx
 65a:	5e                   	pop    %esi
 65b:	5f                   	pop    %edi
 65c:	5d                   	pop    %ebp
 65d:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 65e:	03 72 04             	add    0x4(%edx),%esi
 661:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 664:	8b 10                	mov    (%eax),%edx
 666:	8b 12                	mov    (%edx),%edx
 668:	89 53 f8             	mov    %edx,-0x8(%ebx)
 66b:	eb db                	jmp    648 <free+0x42>
    p->s.size += bp->s.size;
 66d:	03 53 fc             	add    -0x4(%ebx),%edx
 670:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 673:	8b 53 f8             	mov    -0x8(%ebx),%edx
 676:	89 10                	mov    %edx,(%eax)
 678:	eb da                	jmp    654 <free+0x4e>

0000067a <morecore>:

static Header*
morecore(uint nu)
{
 67a:	55                   	push   %ebp
 67b:	89 e5                	mov    %esp,%ebp
 67d:	53                   	push   %ebx
 67e:	83 ec 04             	sub    $0x4,%esp
 681:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 683:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 688:	77 05                	ja     68f <morecore+0x15>
    nu = 4096;
 68a:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 68f:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 696:	83 ec 0c             	sub    $0xc,%esp
 699:	50                   	push   %eax
 69a:	e8 f9 fc ff ff       	call   398 <sbrk>
  if(p == (char*)-1)
 69f:	83 c4 10             	add    $0x10,%esp
 6a2:	83 f8 ff             	cmp    $0xffffffff,%eax
 6a5:	74 1c                	je     6c3 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6a7:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6aa:	83 c0 08             	add    $0x8,%eax
 6ad:	83 ec 0c             	sub    $0xc,%esp
 6b0:	50                   	push   %eax
 6b1:	e8 50 ff ff ff       	call   606 <free>
  return freep;
 6b6:	a1 d0 0a 00 00       	mov    0xad0,%eax
 6bb:	83 c4 10             	add    $0x10,%esp
}
 6be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6c1:	c9                   	leave  
 6c2:	c3                   	ret    
    return 0;
 6c3:	b8 00 00 00 00       	mov    $0x0,%eax
 6c8:	eb f4                	jmp    6be <morecore+0x44>

000006ca <malloc>:

void*
malloc(uint nbytes)
{
 6ca:	f3 0f 1e fb          	endbr32 
 6ce:	55                   	push   %ebp
 6cf:	89 e5                	mov    %esp,%ebp
 6d1:	53                   	push   %ebx
 6d2:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6d5:	8b 45 08             	mov    0x8(%ebp),%eax
 6d8:	8d 58 07             	lea    0x7(%eax),%ebx
 6db:	c1 eb 03             	shr    $0x3,%ebx
 6de:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6e1:	8b 0d d0 0a 00 00    	mov    0xad0,%ecx
 6e7:	85 c9                	test   %ecx,%ecx
 6e9:	74 04                	je     6ef <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6eb:	8b 01                	mov    (%ecx),%eax
 6ed:	eb 4b                	jmp    73a <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 6ef:	c7 05 d0 0a 00 00 d4 	movl   $0xad4,0xad0
 6f6:	0a 00 00 
 6f9:	c7 05 d4 0a 00 00 d4 	movl   $0xad4,0xad4
 700:	0a 00 00 
    base.s.size = 0;
 703:	c7 05 d8 0a 00 00 00 	movl   $0x0,0xad8
 70a:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 70d:	b9 d4 0a 00 00       	mov    $0xad4,%ecx
 712:	eb d7                	jmp    6eb <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 714:	74 1a                	je     730 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 716:	29 da                	sub    %ebx,%edx
 718:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 71b:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 71e:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 721:	89 0d d0 0a 00 00    	mov    %ecx,0xad0
      return (void*)(p + 1);
 727:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 72a:	83 c4 04             	add    $0x4,%esp
 72d:	5b                   	pop    %ebx
 72e:	5d                   	pop    %ebp
 72f:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 730:	8b 10                	mov    (%eax),%edx
 732:	89 11                	mov    %edx,(%ecx)
 734:	eb eb                	jmp    721 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 736:	89 c1                	mov    %eax,%ecx
 738:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 73a:	8b 50 04             	mov    0x4(%eax),%edx
 73d:	39 da                	cmp    %ebx,%edx
 73f:	73 d3                	jae    714 <malloc+0x4a>
    if(p == freep)
 741:	39 05 d0 0a 00 00    	cmp    %eax,0xad0
 747:	75 ed                	jne    736 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 749:	89 d8                	mov    %ebx,%eax
 74b:	e8 2a ff ff ff       	call   67a <morecore>
 750:	85 c0                	test   %eax,%eax
 752:	75 e2                	jne    736 <malloc+0x6c>
 754:	eb d4                	jmp    72a <malloc+0x60>
