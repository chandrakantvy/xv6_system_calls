
_test_chpr:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char *argv[]) {
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	56                   	push   %esi
  12:	53                   	push   %ebx
  13:	51                   	push   %ecx
  14:	83 ec 0c             	sub    $0xc,%esp
  17:	8b 59 04             	mov    0x4(%ecx),%ebx
	int priority, pid;
	if (argc < 3) {
  1a:	83 39 02             	cmpl   $0x2,(%ecx)
  1d:	7f 14                	jg     33 <main+0x33>
		printf(2, "Usage: test_chpr pid priority\n");
  1f:	83 ec 08             	sub    $0x8,%esp
  22:	68 54 07 00 00       	push   $0x754
  27:	6a 02                	push   $0x2
  29:	e8 69 04 00 00       	call   497 <printf>
		exit();
  2e:	e8 db 02 00 00       	call   30e <exit>
	}
	// string to integer conversion
	pid = atoi(argv[1]);
  33:	83 ec 0c             	sub    $0xc,%esp
  36:	ff 73 04             	pushl  0x4(%ebx)
  39:	e8 8d 01 00 00       	call   1cb <atoi>
  3e:	89 c6                	mov    %eax,%esi
	priority = atoi(argv[2]);
  40:	83 c4 04             	add    $0x4,%esp
  43:	ff 73 08             	pushl  0x8(%ebx)
  46:	e8 80 01 00 00       	call   1cb <atoi>
  4b:	89 c3                	mov    %eax,%ebx
	if (priority < 0 || priority > 20) {
  4d:	83 c4 10             	add    $0x10,%esp
  50:	83 f8 14             	cmp    $0x14,%eax
  53:	77 0f                	ja     64 <main+0x64>
		printf(2, "priority is not between 0-20\n");
	} 
	chpr(pid, priority);
  55:	83 ec 08             	sub    $0x8,%esp
  58:	53                   	push   %ebx
  59:	56                   	push   %esi
  5a:	e8 6f 03 00 00       	call   3ce <chpr>
	exit();
  5f:	e8 aa 02 00 00       	call   30e <exit>
		printf(2, "priority is not between 0-20\n");
  64:	83 ec 08             	sub    $0x8,%esp
  67:	68 73 07 00 00       	push   $0x773
  6c:	6a 02                	push   $0x2
  6e:	e8 24 04 00 00       	call   497 <printf>
  73:	83 c4 10             	add    $0x10,%esp
  76:	eb dd                	jmp    55 <main+0x55>

00000078 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  78:	f3 0f 1e fb          	endbr32 
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  7f:	56                   	push   %esi
  80:	53                   	push   %ebx
  81:	8b 75 08             	mov    0x8(%ebp),%esi
  84:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  87:	89 f0                	mov    %esi,%eax
  89:	89 d1                	mov    %edx,%ecx
  8b:	83 c2 01             	add    $0x1,%edx
  8e:	89 c3                	mov    %eax,%ebx
  90:	83 c0 01             	add    $0x1,%eax
  93:	0f b6 09             	movzbl (%ecx),%ecx
  96:	88 0b                	mov    %cl,(%ebx)
  98:	84 c9                	test   %cl,%cl
  9a:	75 ed                	jne    89 <strcpy+0x11>
    ;
  return os;
}
  9c:	89 f0                	mov    %esi,%eax
  9e:	5b                   	pop    %ebx
  9f:	5e                   	pop    %esi
  a0:	5d                   	pop    %ebp
  a1:	c3                   	ret    

000000a2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a2:	f3 0f 1e fb          	endbr32 
  a6:	55                   	push   %ebp
  a7:	89 e5                	mov    %esp,%ebp
  a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  af:	0f b6 01             	movzbl (%ecx),%eax
  b2:	84 c0                	test   %al,%al
  b4:	74 0c                	je     c2 <strcmp+0x20>
  b6:	3a 02                	cmp    (%edx),%al
  b8:	75 08                	jne    c2 <strcmp+0x20>
    p++, q++;
  ba:	83 c1 01             	add    $0x1,%ecx
  bd:	83 c2 01             	add    $0x1,%edx
  c0:	eb ed                	jmp    af <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  c2:	0f b6 c0             	movzbl %al,%eax
  c5:	0f b6 12             	movzbl (%edx),%edx
  c8:	29 d0                	sub    %edx,%eax
}
  ca:	5d                   	pop    %ebp
  cb:	c3                   	ret    

000000cc <strlen>:

uint
strlen(char *s)
{
  cc:	f3 0f 1e fb          	endbr32 
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  d6:	b8 00 00 00 00       	mov    $0x0,%eax
  db:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  df:	74 05                	je     e6 <strlen+0x1a>
  e1:	83 c0 01             	add    $0x1,%eax
  e4:	eb f5                	jmp    db <strlen+0xf>
    ;
  return n;
}
  e6:	5d                   	pop    %ebp
  e7:	c3                   	ret    

000000e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e8:	f3 0f 1e fb          	endbr32 
  ec:	55                   	push   %ebp
  ed:	89 e5                	mov    %esp,%ebp
  ef:	57                   	push   %edi
  f0:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  f3:	89 d7                	mov    %edx,%edi
  f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  fb:	fc                   	cld    
  fc:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  fe:	89 d0                	mov    %edx,%eax
 100:	5f                   	pop    %edi
 101:	5d                   	pop    %ebp
 102:	c3                   	ret    

00000103 <strchr>:

char*
strchr(const char *s, char c)
{
 103:	f3 0f 1e fb          	endbr32 
 107:	55                   	push   %ebp
 108:	89 e5                	mov    %esp,%ebp
 10a:	8b 45 08             	mov    0x8(%ebp),%eax
 10d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 111:	0f b6 10             	movzbl (%eax),%edx
 114:	84 d2                	test   %dl,%dl
 116:	74 09                	je     121 <strchr+0x1e>
    if(*s == c)
 118:	38 ca                	cmp    %cl,%dl
 11a:	74 0a                	je     126 <strchr+0x23>
  for(; *s; s++)
 11c:	83 c0 01             	add    $0x1,%eax
 11f:	eb f0                	jmp    111 <strchr+0xe>
      return (char*)s;
  return 0;
 121:	b8 00 00 00 00       	mov    $0x0,%eax
}
 126:	5d                   	pop    %ebp
 127:	c3                   	ret    

00000128 <gets>:

char*
gets(char *buf, int max)
{
 128:	f3 0f 1e fb          	endbr32 
 12c:	55                   	push   %ebp
 12d:	89 e5                	mov    %esp,%ebp
 12f:	57                   	push   %edi
 130:	56                   	push   %esi
 131:	53                   	push   %ebx
 132:	83 ec 1c             	sub    $0x1c,%esp
 135:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 138:	bb 00 00 00 00       	mov    $0x0,%ebx
 13d:	89 de                	mov    %ebx,%esi
 13f:	83 c3 01             	add    $0x1,%ebx
 142:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 145:	7d 2e                	jge    175 <gets+0x4d>
    cc = read(0, &c, 1);
 147:	83 ec 04             	sub    $0x4,%esp
 14a:	6a 01                	push   $0x1
 14c:	8d 45 e7             	lea    -0x19(%ebp),%eax
 14f:	50                   	push   %eax
 150:	6a 00                	push   $0x0
 152:	e8 cf 01 00 00       	call   326 <read>
    if(cc < 1)
 157:	83 c4 10             	add    $0x10,%esp
 15a:	85 c0                	test   %eax,%eax
 15c:	7e 17                	jle    175 <gets+0x4d>
      break;
    buf[i++] = c;
 15e:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 162:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 165:	3c 0a                	cmp    $0xa,%al
 167:	0f 94 c2             	sete   %dl
 16a:	3c 0d                	cmp    $0xd,%al
 16c:	0f 94 c0             	sete   %al
 16f:	08 c2                	or     %al,%dl
 171:	74 ca                	je     13d <gets+0x15>
    buf[i++] = c;
 173:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 175:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 179:	89 f8                	mov    %edi,%eax
 17b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 17e:	5b                   	pop    %ebx
 17f:	5e                   	pop    %esi
 180:	5f                   	pop    %edi
 181:	5d                   	pop    %ebp
 182:	c3                   	ret    

00000183 <stat>:

int
stat(char *n, struct stat *st)
{
 183:	f3 0f 1e fb          	endbr32 
 187:	55                   	push   %ebp
 188:	89 e5                	mov    %esp,%ebp
 18a:	56                   	push   %esi
 18b:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18c:	83 ec 08             	sub    $0x8,%esp
 18f:	6a 00                	push   $0x0
 191:	ff 75 08             	pushl  0x8(%ebp)
 194:	e8 b5 01 00 00       	call   34e <open>
  if(fd < 0)
 199:	83 c4 10             	add    $0x10,%esp
 19c:	85 c0                	test   %eax,%eax
 19e:	78 24                	js     1c4 <stat+0x41>
 1a0:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1a2:	83 ec 08             	sub    $0x8,%esp
 1a5:	ff 75 0c             	pushl  0xc(%ebp)
 1a8:	50                   	push   %eax
 1a9:	e8 b8 01 00 00       	call   366 <fstat>
 1ae:	89 c6                	mov    %eax,%esi
  close(fd);
 1b0:	89 1c 24             	mov    %ebx,(%esp)
 1b3:	e8 7e 01 00 00       	call   336 <close>
  return r;
 1b8:	83 c4 10             	add    $0x10,%esp
}
 1bb:	89 f0                	mov    %esi,%eax
 1bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1c0:	5b                   	pop    %ebx
 1c1:	5e                   	pop    %esi
 1c2:	5d                   	pop    %ebp
 1c3:	c3                   	ret    
    return -1;
 1c4:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1c9:	eb f0                	jmp    1bb <stat+0x38>

000001cb <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
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
 1d8:	0f b6 02             	movzbl (%edx),%eax
 1db:	3c 20                	cmp    $0x20,%al
 1dd:	75 05                	jne    1e4 <atoi+0x19>
 1df:	83 c2 01             	add    $0x1,%edx
 1e2:	eb f4                	jmp    1d8 <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 1e4:	3c 2d                	cmp    $0x2d,%al
 1e6:	74 1d                	je     205 <atoi+0x3a>
 1e8:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 1ed:	3c 2b                	cmp    $0x2b,%al
 1ef:	0f 94 c1             	sete   %cl
 1f2:	3c 2d                	cmp    $0x2d,%al
 1f4:	0f 94 c0             	sete   %al
 1f7:	08 c1                	or     %al,%cl
 1f9:	74 03                	je     1fe <atoi+0x33>
    s++;
 1fb:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 1fe:	b8 00 00 00 00       	mov    $0x0,%eax
 203:	eb 17                	jmp    21c <atoi+0x51>
 205:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 20a:	eb e1                	jmp    1ed <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 20c:	8d 34 80             	lea    (%eax,%eax,4),%esi
 20f:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 212:	83 c2 01             	add    $0x1,%edx
 215:	0f be c9             	movsbl %cl,%ecx
 218:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 21c:	0f b6 0a             	movzbl (%edx),%ecx
 21f:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 222:	80 fb 09             	cmp    $0x9,%bl
 225:	76 e5                	jbe    20c <atoi+0x41>
  return sign*n;
 227:	0f af c7             	imul   %edi,%eax
}
 22a:	5b                   	pop    %ebx
 22b:	5e                   	pop    %esi
 22c:	5f                   	pop    %edi
 22d:	5d                   	pop    %ebp
 22e:	c3                   	ret    

0000022f <atoo>:

int
atoo(const char *s)
{
 22f:	f3 0f 1e fb          	endbr32 
 233:	55                   	push   %ebp
 234:	89 e5                	mov    %esp,%ebp
 236:	57                   	push   %edi
 237:	56                   	push   %esi
 238:	53                   	push   %ebx
 239:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 23c:	0f b6 0a             	movzbl (%edx),%ecx
 23f:	80 f9 20             	cmp    $0x20,%cl
 242:	75 05                	jne    249 <atoo+0x1a>
 244:	83 c2 01             	add    $0x1,%edx
 247:	eb f3                	jmp    23c <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 249:	80 f9 2d             	cmp    $0x2d,%cl
 24c:	74 23                	je     271 <atoo+0x42>
 24e:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 253:	80 f9 2b             	cmp    $0x2b,%cl
 256:	0f 94 c0             	sete   %al
 259:	89 c6                	mov    %eax,%esi
 25b:	80 f9 2d             	cmp    $0x2d,%cl
 25e:	0f 94 c0             	sete   %al
 261:	89 f3                	mov    %esi,%ebx
 263:	08 c3                	or     %al,%bl
 265:	74 03                	je     26a <atoo+0x3b>
    s++;
 267:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 26a:	b8 00 00 00 00       	mov    $0x0,%eax
 26f:	eb 11                	jmp    282 <atoo+0x53>
 271:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 276:	eb db                	jmp    253 <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 278:	83 c2 01             	add    $0x1,%edx
 27b:	0f be c9             	movsbl %cl,%ecx
 27e:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 282:	0f b6 0a             	movzbl (%edx),%ecx
 285:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 288:	80 fb 07             	cmp    $0x7,%bl
 28b:	76 eb                	jbe    278 <atoo+0x49>
  return sign*n;
 28d:	0f af c7             	imul   %edi,%eax
}
 290:	5b                   	pop    %ebx
 291:	5e                   	pop    %esi
 292:	5f                   	pop    %edi
 293:	5d                   	pop    %ebp
 294:	c3                   	ret    

00000295 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 295:	f3 0f 1e fb          	endbr32 
 299:	55                   	push   %ebp
 29a:	89 e5                	mov    %esp,%ebp
 29c:	53                   	push   %ebx
 29d:	8b 55 08             	mov    0x8(%ebp),%edx
 2a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2a3:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 2a6:	eb 09                	jmp    2b1 <strncmp+0x1c>
      n--, p++, q++;
 2a8:	83 e8 01             	sub    $0x1,%eax
 2ab:	83 c2 01             	add    $0x1,%edx
 2ae:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 2b1:	85 c0                	test   %eax,%eax
 2b3:	74 0b                	je     2c0 <strncmp+0x2b>
 2b5:	0f b6 1a             	movzbl (%edx),%ebx
 2b8:	84 db                	test   %bl,%bl
 2ba:	74 04                	je     2c0 <strncmp+0x2b>
 2bc:	3a 19                	cmp    (%ecx),%bl
 2be:	74 e8                	je     2a8 <strncmp+0x13>
    if(n == 0)
 2c0:	85 c0                	test   %eax,%eax
 2c2:	74 0b                	je     2cf <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 2c4:	0f b6 02             	movzbl (%edx),%eax
 2c7:	0f b6 11             	movzbl (%ecx),%edx
 2ca:	29 d0                	sub    %edx,%eax
}
 2cc:	5b                   	pop    %ebx
 2cd:	5d                   	pop    %ebp
 2ce:	c3                   	ret    
      return 0;
 2cf:	b8 00 00 00 00       	mov    $0x0,%eax
 2d4:	eb f6                	jmp    2cc <strncmp+0x37>

000002d6 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 2d6:	f3 0f 1e fb          	endbr32 
 2da:	55                   	push   %ebp
 2db:	89 e5                	mov    %esp,%ebp
 2dd:	56                   	push   %esi
 2de:	53                   	push   %ebx
 2df:	8b 75 08             	mov    0x8(%ebp),%esi
 2e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2e5:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 2e8:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 2ea:	8d 58 ff             	lea    -0x1(%eax),%ebx
 2ed:	85 c0                	test   %eax,%eax
 2ef:	7e 0f                	jle    300 <memmove+0x2a>
    *dst++ = *src++;
 2f1:	0f b6 01             	movzbl (%ecx),%eax
 2f4:	88 02                	mov    %al,(%edx)
 2f6:	8d 49 01             	lea    0x1(%ecx),%ecx
 2f9:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 2fc:	89 d8                	mov    %ebx,%eax
 2fe:	eb ea                	jmp    2ea <memmove+0x14>
  return vdst;
}
 300:	89 f0                	mov    %esi,%eax
 302:	5b                   	pop    %ebx
 303:	5e                   	pop    %esi
 304:	5d                   	pop    %ebp
 305:	c3                   	ret    

00000306 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 306:	b8 01 00 00 00       	mov    $0x1,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <exit>:
SYSCALL(exit)
 30e:	b8 02 00 00 00       	mov    $0x2,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <wait>:
SYSCALL(wait)
 316:	b8 03 00 00 00       	mov    $0x3,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <pipe>:
SYSCALL(pipe)
 31e:	b8 04 00 00 00       	mov    $0x4,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <read>:
SYSCALL(read)
 326:	b8 05 00 00 00       	mov    $0x5,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <write>:
SYSCALL(write)
 32e:	b8 10 00 00 00       	mov    $0x10,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <close>:
SYSCALL(close)
 336:	b8 15 00 00 00       	mov    $0x15,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <kill>:
SYSCALL(kill)
 33e:	b8 06 00 00 00       	mov    $0x6,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <exec>:
SYSCALL(exec)
 346:	b8 07 00 00 00       	mov    $0x7,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <open>:
SYSCALL(open)
 34e:	b8 0f 00 00 00       	mov    $0xf,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <mknod>:
SYSCALL(mknod)
 356:	b8 11 00 00 00       	mov    $0x11,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <unlink>:
SYSCALL(unlink)
 35e:	b8 12 00 00 00       	mov    $0x12,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <fstat>:
SYSCALL(fstat)
 366:	b8 08 00 00 00       	mov    $0x8,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <link>:
SYSCALL(link)
 36e:	b8 13 00 00 00       	mov    $0x13,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <mkdir>:
SYSCALL(mkdir)
 376:	b8 14 00 00 00       	mov    $0x14,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <chdir>:
SYSCALL(chdir)
 37e:	b8 09 00 00 00       	mov    $0x9,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <dup>:
SYSCALL(dup)
 386:	b8 0a 00 00 00       	mov    $0xa,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <getpid>:
SYSCALL(getpid)
 38e:	b8 0b 00 00 00       	mov    $0xb,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <sbrk>:
SYSCALL(sbrk)
 396:	b8 0c 00 00 00       	mov    $0xc,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <sleep>:
SYSCALL(sleep)
 39e:	b8 0d 00 00 00       	mov    $0xd,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <uptime>:
SYSCALL(uptime)
 3a6:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <halt>:
SYSCALL(halt)
 3ae:	b8 16 00 00 00       	mov    $0x16,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <cps>:
/* ____My changes____ */
SYSCALL(cps)
 3b6:	b8 17 00 00 00       	mov    $0x17,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <getppid>:
SYSCALL(getppid)
 3be:	b8 18 00 00 00       	mov    $0x18,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <getsz>:
SYSCALL(getsz)
 3c6:	b8 19 00 00 00       	mov    $0x19,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <chpr>:
SYSCALL(chpr)
 3ce:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <getcount>:
SYSCALL(getcount)
 3d6:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <time>:
SYSCALL(time)
 3de:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <utctime>:
SYSCALL(utctime)
 3e6:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <dup2>:
SYSCALL(dup2)
 3ee:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3f6:	55                   	push   %ebp
 3f7:	89 e5                	mov    %esp,%ebp
 3f9:	83 ec 1c             	sub    $0x1c,%esp
 3fc:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 3ff:	6a 01                	push   $0x1
 401:	8d 55 f4             	lea    -0xc(%ebp),%edx
 404:	52                   	push   %edx
 405:	50                   	push   %eax
 406:	e8 23 ff ff ff       	call   32e <write>
}
 40b:	83 c4 10             	add    $0x10,%esp
 40e:	c9                   	leave  
 40f:	c3                   	ret    

00000410 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	57                   	push   %edi
 414:	56                   	push   %esi
 415:	53                   	push   %ebx
 416:	83 ec 2c             	sub    $0x2c,%esp
 419:	89 45 d0             	mov    %eax,-0x30(%ebp)
 41c:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 41e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 422:	0f 95 c2             	setne  %dl
 425:	89 f0                	mov    %esi,%eax
 427:	c1 e8 1f             	shr    $0x1f,%eax
 42a:	84 c2                	test   %al,%dl
 42c:	74 42                	je     470 <printint+0x60>
    neg = 1;
    x = -xx;
 42e:	f7 de                	neg    %esi
    neg = 1;
 430:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 437:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 43c:	89 f0                	mov    %esi,%eax
 43e:	ba 00 00 00 00       	mov    $0x0,%edx
 443:	f7 f1                	div    %ecx
 445:	89 df                	mov    %ebx,%edi
 447:	83 c3 01             	add    $0x1,%ebx
 44a:	0f b6 92 98 07 00 00 	movzbl 0x798(%edx),%edx
 451:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 455:	89 f2                	mov    %esi,%edx
 457:	89 c6                	mov    %eax,%esi
 459:	39 d1                	cmp    %edx,%ecx
 45b:	76 df                	jbe    43c <printint+0x2c>
  if(neg)
 45d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 461:	74 2f                	je     492 <printint+0x82>
    buf[i++] = '-';
 463:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 468:	8d 5f 02             	lea    0x2(%edi),%ebx
 46b:	8b 75 d0             	mov    -0x30(%ebp),%esi
 46e:	eb 15                	jmp    485 <printint+0x75>
  neg = 0;
 470:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 477:	eb be                	jmp    437 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 479:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 47e:	89 f0                	mov    %esi,%eax
 480:	e8 71 ff ff ff       	call   3f6 <putc>
  while(--i >= 0)
 485:	83 eb 01             	sub    $0x1,%ebx
 488:	79 ef                	jns    479 <printint+0x69>
}
 48a:	83 c4 2c             	add    $0x2c,%esp
 48d:	5b                   	pop    %ebx
 48e:	5e                   	pop    %esi
 48f:	5f                   	pop    %edi
 490:	5d                   	pop    %ebp
 491:	c3                   	ret    
 492:	8b 75 d0             	mov    -0x30(%ebp),%esi
 495:	eb ee                	jmp    485 <printint+0x75>

00000497 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 497:	f3 0f 1e fb          	endbr32 
 49b:	55                   	push   %ebp
 49c:	89 e5                	mov    %esp,%ebp
 49e:	57                   	push   %edi
 49f:	56                   	push   %esi
 4a0:	53                   	push   %ebx
 4a1:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4a4:	8d 45 10             	lea    0x10(%ebp),%eax
 4a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 4aa:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 4af:	bb 00 00 00 00       	mov    $0x0,%ebx
 4b4:	eb 14                	jmp    4ca <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4b6:	89 fa                	mov    %edi,%edx
 4b8:	8b 45 08             	mov    0x8(%ebp),%eax
 4bb:	e8 36 ff ff ff       	call   3f6 <putc>
 4c0:	eb 05                	jmp    4c7 <printf+0x30>
      }
    } else if(state == '%'){
 4c2:	83 fe 25             	cmp    $0x25,%esi
 4c5:	74 25                	je     4ec <printf+0x55>
  for(i = 0; fmt[i]; i++){
 4c7:	83 c3 01             	add    $0x1,%ebx
 4ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 4cd:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 4d1:	84 c0                	test   %al,%al
 4d3:	0f 84 23 01 00 00    	je     5fc <printf+0x165>
    c = fmt[i] & 0xff;
 4d9:	0f be f8             	movsbl %al,%edi
 4dc:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 4df:	85 f6                	test   %esi,%esi
 4e1:	75 df                	jne    4c2 <printf+0x2b>
      if(c == '%'){
 4e3:	83 f8 25             	cmp    $0x25,%eax
 4e6:	75 ce                	jne    4b6 <printf+0x1f>
        state = '%';
 4e8:	89 c6                	mov    %eax,%esi
 4ea:	eb db                	jmp    4c7 <printf+0x30>
      if(c == 'd'){
 4ec:	83 f8 64             	cmp    $0x64,%eax
 4ef:	74 49                	je     53a <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4f1:	83 f8 78             	cmp    $0x78,%eax
 4f4:	0f 94 c1             	sete   %cl
 4f7:	83 f8 70             	cmp    $0x70,%eax
 4fa:	0f 94 c2             	sete   %dl
 4fd:	08 d1                	or     %dl,%cl
 4ff:	75 63                	jne    564 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 501:	83 f8 73             	cmp    $0x73,%eax
 504:	0f 84 84 00 00 00    	je     58e <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 50a:	83 f8 63             	cmp    $0x63,%eax
 50d:	0f 84 b7 00 00 00    	je     5ca <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 513:	83 f8 25             	cmp    $0x25,%eax
 516:	0f 84 cc 00 00 00    	je     5e8 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 51c:	ba 25 00 00 00       	mov    $0x25,%edx
 521:	8b 45 08             	mov    0x8(%ebp),%eax
 524:	e8 cd fe ff ff       	call   3f6 <putc>
        putc(fd, c);
 529:	89 fa                	mov    %edi,%edx
 52b:	8b 45 08             	mov    0x8(%ebp),%eax
 52e:	e8 c3 fe ff ff       	call   3f6 <putc>
      }
      state = 0;
 533:	be 00 00 00 00       	mov    $0x0,%esi
 538:	eb 8d                	jmp    4c7 <printf+0x30>
        printint(fd, *ap, 10, 1);
 53a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 53d:	8b 17                	mov    (%edi),%edx
 53f:	83 ec 0c             	sub    $0xc,%esp
 542:	6a 01                	push   $0x1
 544:	b9 0a 00 00 00       	mov    $0xa,%ecx
 549:	8b 45 08             	mov    0x8(%ebp),%eax
 54c:	e8 bf fe ff ff       	call   410 <printint>
        ap++;
 551:	83 c7 04             	add    $0x4,%edi
 554:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 557:	83 c4 10             	add    $0x10,%esp
      state = 0;
 55a:	be 00 00 00 00       	mov    $0x0,%esi
 55f:	e9 63 ff ff ff       	jmp    4c7 <printf+0x30>
        printint(fd, *ap, 16, 0);
 564:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 567:	8b 17                	mov    (%edi),%edx
 569:	83 ec 0c             	sub    $0xc,%esp
 56c:	6a 00                	push   $0x0
 56e:	b9 10 00 00 00       	mov    $0x10,%ecx
 573:	8b 45 08             	mov    0x8(%ebp),%eax
 576:	e8 95 fe ff ff       	call   410 <printint>
        ap++;
 57b:	83 c7 04             	add    $0x4,%edi
 57e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 581:	83 c4 10             	add    $0x10,%esp
      state = 0;
 584:	be 00 00 00 00       	mov    $0x0,%esi
 589:	e9 39 ff ff ff       	jmp    4c7 <printf+0x30>
        s = (char*)*ap;
 58e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 591:	8b 30                	mov    (%eax),%esi
        ap++;
 593:	83 c0 04             	add    $0x4,%eax
 596:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 599:	85 f6                	test   %esi,%esi
 59b:	75 28                	jne    5c5 <printf+0x12e>
          s = "(null)";
 59d:	be 91 07 00 00       	mov    $0x791,%esi
 5a2:	8b 7d 08             	mov    0x8(%ebp),%edi
 5a5:	eb 0d                	jmp    5b4 <printf+0x11d>
          putc(fd, *s);
 5a7:	0f be d2             	movsbl %dl,%edx
 5aa:	89 f8                	mov    %edi,%eax
 5ac:	e8 45 fe ff ff       	call   3f6 <putc>
          s++;
 5b1:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 5b4:	0f b6 16             	movzbl (%esi),%edx
 5b7:	84 d2                	test   %dl,%dl
 5b9:	75 ec                	jne    5a7 <printf+0x110>
      state = 0;
 5bb:	be 00 00 00 00       	mov    $0x0,%esi
 5c0:	e9 02 ff ff ff       	jmp    4c7 <printf+0x30>
 5c5:	8b 7d 08             	mov    0x8(%ebp),%edi
 5c8:	eb ea                	jmp    5b4 <printf+0x11d>
        putc(fd, *ap);
 5ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5cd:	0f be 17             	movsbl (%edi),%edx
 5d0:	8b 45 08             	mov    0x8(%ebp),%eax
 5d3:	e8 1e fe ff ff       	call   3f6 <putc>
        ap++;
 5d8:	83 c7 04             	add    $0x4,%edi
 5db:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 5de:	be 00 00 00 00       	mov    $0x0,%esi
 5e3:	e9 df fe ff ff       	jmp    4c7 <printf+0x30>
        putc(fd, c);
 5e8:	89 fa                	mov    %edi,%edx
 5ea:	8b 45 08             	mov    0x8(%ebp),%eax
 5ed:	e8 04 fe ff ff       	call   3f6 <putc>
      state = 0;
 5f2:	be 00 00 00 00       	mov    $0x0,%esi
 5f7:	e9 cb fe ff ff       	jmp    4c7 <printf+0x30>
    }
  }
}
 5fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ff:	5b                   	pop    %ebx
 600:	5e                   	pop    %esi
 601:	5f                   	pop    %edi
 602:	5d                   	pop    %ebp
 603:	c3                   	ret    

00000604 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 604:	f3 0f 1e fb          	endbr32 
 608:	55                   	push   %ebp
 609:	89 e5                	mov    %esp,%ebp
 60b:	57                   	push   %edi
 60c:	56                   	push   %esi
 60d:	53                   	push   %ebx
 60e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 611:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 614:	a1 9c 0a 00 00       	mov    0xa9c,%eax
 619:	eb 02                	jmp    61d <free+0x19>
 61b:	89 d0                	mov    %edx,%eax
 61d:	39 c8                	cmp    %ecx,%eax
 61f:	73 04                	jae    625 <free+0x21>
 621:	39 08                	cmp    %ecx,(%eax)
 623:	77 12                	ja     637 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 625:	8b 10                	mov    (%eax),%edx
 627:	39 c2                	cmp    %eax,%edx
 629:	77 f0                	ja     61b <free+0x17>
 62b:	39 c8                	cmp    %ecx,%eax
 62d:	72 08                	jb     637 <free+0x33>
 62f:	39 ca                	cmp    %ecx,%edx
 631:	77 04                	ja     637 <free+0x33>
 633:	89 d0                	mov    %edx,%eax
 635:	eb e6                	jmp    61d <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 637:	8b 73 fc             	mov    -0x4(%ebx),%esi
 63a:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 63d:	8b 10                	mov    (%eax),%edx
 63f:	39 d7                	cmp    %edx,%edi
 641:	74 19                	je     65c <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 643:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 646:	8b 50 04             	mov    0x4(%eax),%edx
 649:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 64c:	39 ce                	cmp    %ecx,%esi
 64e:	74 1b                	je     66b <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 650:	89 08                	mov    %ecx,(%eax)
  freep = p;
 652:	a3 9c 0a 00 00       	mov    %eax,0xa9c
}
 657:	5b                   	pop    %ebx
 658:	5e                   	pop    %esi
 659:	5f                   	pop    %edi
 65a:	5d                   	pop    %ebp
 65b:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 65c:	03 72 04             	add    0x4(%edx),%esi
 65f:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 662:	8b 10                	mov    (%eax),%edx
 664:	8b 12                	mov    (%edx),%edx
 666:	89 53 f8             	mov    %edx,-0x8(%ebx)
 669:	eb db                	jmp    646 <free+0x42>
    p->s.size += bp->s.size;
 66b:	03 53 fc             	add    -0x4(%ebx),%edx
 66e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 671:	8b 53 f8             	mov    -0x8(%ebx),%edx
 674:	89 10                	mov    %edx,(%eax)
 676:	eb da                	jmp    652 <free+0x4e>

00000678 <morecore>:

static Header*
morecore(uint nu)
{
 678:	55                   	push   %ebp
 679:	89 e5                	mov    %esp,%ebp
 67b:	53                   	push   %ebx
 67c:	83 ec 04             	sub    $0x4,%esp
 67f:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 681:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 686:	77 05                	ja     68d <morecore+0x15>
    nu = 4096;
 688:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 68d:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 694:	83 ec 0c             	sub    $0xc,%esp
 697:	50                   	push   %eax
 698:	e8 f9 fc ff ff       	call   396 <sbrk>
  if(p == (char*)-1)
 69d:	83 c4 10             	add    $0x10,%esp
 6a0:	83 f8 ff             	cmp    $0xffffffff,%eax
 6a3:	74 1c                	je     6c1 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6a5:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6a8:	83 c0 08             	add    $0x8,%eax
 6ab:	83 ec 0c             	sub    $0xc,%esp
 6ae:	50                   	push   %eax
 6af:	e8 50 ff ff ff       	call   604 <free>
  return freep;
 6b4:	a1 9c 0a 00 00       	mov    0xa9c,%eax
 6b9:	83 c4 10             	add    $0x10,%esp
}
 6bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6bf:	c9                   	leave  
 6c0:	c3                   	ret    
    return 0;
 6c1:	b8 00 00 00 00       	mov    $0x0,%eax
 6c6:	eb f4                	jmp    6bc <morecore+0x44>

000006c8 <malloc>:

void*
malloc(uint nbytes)
{
 6c8:	f3 0f 1e fb          	endbr32 
 6cc:	55                   	push   %ebp
 6cd:	89 e5                	mov    %esp,%ebp
 6cf:	53                   	push   %ebx
 6d0:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6d3:	8b 45 08             	mov    0x8(%ebp),%eax
 6d6:	8d 58 07             	lea    0x7(%eax),%ebx
 6d9:	c1 eb 03             	shr    $0x3,%ebx
 6dc:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6df:	8b 0d 9c 0a 00 00    	mov    0xa9c,%ecx
 6e5:	85 c9                	test   %ecx,%ecx
 6e7:	74 04                	je     6ed <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6e9:	8b 01                	mov    (%ecx),%eax
 6eb:	eb 4b                	jmp    738 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 6ed:	c7 05 9c 0a 00 00 a0 	movl   $0xaa0,0xa9c
 6f4:	0a 00 00 
 6f7:	c7 05 a0 0a 00 00 a0 	movl   $0xaa0,0xaa0
 6fe:	0a 00 00 
    base.s.size = 0;
 701:	c7 05 a4 0a 00 00 00 	movl   $0x0,0xaa4
 708:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 70b:	b9 a0 0a 00 00       	mov    $0xaa0,%ecx
 710:	eb d7                	jmp    6e9 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 712:	74 1a                	je     72e <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 714:	29 da                	sub    %ebx,%edx
 716:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 719:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 71c:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 71f:	89 0d 9c 0a 00 00    	mov    %ecx,0xa9c
      return (void*)(p + 1);
 725:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 728:	83 c4 04             	add    $0x4,%esp
 72b:	5b                   	pop    %ebx
 72c:	5d                   	pop    %ebp
 72d:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 72e:	8b 10                	mov    (%eax),%edx
 730:	89 11                	mov    %edx,(%ecx)
 732:	eb eb                	jmp    71f <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 734:	89 c1                	mov    %eax,%ecx
 736:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 738:	8b 50 04             	mov    0x4(%eax),%edx
 73b:	39 da                	cmp    %ebx,%edx
 73d:	73 d3                	jae    712 <malloc+0x4a>
    if(p == freep)
 73f:	39 05 9c 0a 00 00    	cmp    %eax,0xa9c
 745:	75 ed                	jne    734 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 747:	89 d8                	mov    %ebx,%eax
 749:	e8 2a ff ff ff       	call   678 <morecore>
 74e:	85 c0                	test   %eax,%eax
 750:	75 e2                	jne    734 <malloc+0x6c>
 752:	eb d4                	jmp    728 <malloc+0x60>
