
_test_utctime:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"
#include "date.h"

int main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 30             	sub    $0x30,%esp
  struct rtcdate r;

  if (utctime(&r)) {
  15:	8d 45 e0             	lea    -0x20(%ebp),%eax
  18:	50                   	push   %eax
  19:	e8 d0 03 00 00       	call   3ee <utctime>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	74 14                	je     39 <main+0x39>
    printf(2, "date failed\n");
  25:	83 ec 08             	sub    $0x8,%esp
  28:	68 5c 07 00 00       	push   $0x75c
  2d:	6a 02                	push   $0x2
  2f:	e8 6b 04 00 00       	call   49f <printf>
    exit();
  34:	e8 dd 02 00 00       	call   316 <exit>
  }
  printf(1, "Current UTC Time: ");
  39:	83 ec 08             	sub    $0x8,%esp
  3c:	68 69 07 00 00       	push   $0x769
  41:	6a 01                	push   $0x1
  43:	e8 57 04 00 00       	call   49f <printf>
  printf(1, "%d:%d:%d ", r.hour, r.minute, r.second);
  48:	83 c4 04             	add    $0x4,%esp
  4b:	ff 75 e0             	pushl  -0x20(%ebp)
  4e:	ff 75 e4             	pushl  -0x1c(%ebp)
  51:	ff 75 e8             	pushl  -0x18(%ebp)
  54:	68 7c 07 00 00       	push   $0x77c
  59:	6a 01                	push   $0x1
  5b:	e8 3f 04 00 00       	call   49f <printf>
  printf(1, "%d-%d-%d\n",  r.day, r.month, r.year);
  60:	83 c4 14             	add    $0x14,%esp
  63:	ff 75 f4             	pushl  -0xc(%ebp)
  66:	ff 75 f0             	pushl  -0x10(%ebp)
  69:	ff 75 ec             	pushl  -0x14(%ebp)
  6c:	68 86 07 00 00       	push   $0x786
  71:	6a 01                	push   $0x1
  73:	e8 27 04 00 00       	call   49f <printf>

  exit();
  78:	83 c4 20             	add    $0x20,%esp
  7b:	e8 96 02 00 00       	call   316 <exit>

00000080 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  80:	f3 0f 1e fb          	endbr32 
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	56                   	push   %esi
  88:	53                   	push   %ebx
  89:	8b 75 08             	mov    0x8(%ebp),%esi
  8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  8f:	89 f0                	mov    %esi,%eax
  91:	89 d1                	mov    %edx,%ecx
  93:	83 c2 01             	add    $0x1,%edx
  96:	89 c3                	mov    %eax,%ebx
  98:	83 c0 01             	add    $0x1,%eax
  9b:	0f b6 09             	movzbl (%ecx),%ecx
  9e:	88 0b                	mov    %cl,(%ebx)
  a0:	84 c9                	test   %cl,%cl
  a2:	75 ed                	jne    91 <strcpy+0x11>
    ;
  return os;
}
  a4:	89 f0                	mov    %esi,%eax
  a6:	5b                   	pop    %ebx
  a7:	5e                   	pop    %esi
  a8:	5d                   	pop    %ebp
  a9:	c3                   	ret    

000000aa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  aa:	f3 0f 1e fb          	endbr32 
  ae:	55                   	push   %ebp
  af:	89 e5                	mov    %esp,%ebp
  b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  b7:	0f b6 01             	movzbl (%ecx),%eax
  ba:	84 c0                	test   %al,%al
  bc:	74 0c                	je     ca <strcmp+0x20>
  be:	3a 02                	cmp    (%edx),%al
  c0:	75 08                	jne    ca <strcmp+0x20>
    p++, q++;
  c2:	83 c1 01             	add    $0x1,%ecx
  c5:	83 c2 01             	add    $0x1,%edx
  c8:	eb ed                	jmp    b7 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  ca:	0f b6 c0             	movzbl %al,%eax
  cd:	0f b6 12             	movzbl (%edx),%edx
  d0:	29 d0                	sub    %edx,%eax
}
  d2:	5d                   	pop    %ebp
  d3:	c3                   	ret    

000000d4 <strlen>:

uint
strlen(char *s)
{
  d4:	f3 0f 1e fb          	endbr32 
  d8:	55                   	push   %ebp
  d9:	89 e5                	mov    %esp,%ebp
  db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  de:	b8 00 00 00 00       	mov    $0x0,%eax
  e3:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  e7:	74 05                	je     ee <strlen+0x1a>
  e9:	83 c0 01             	add    $0x1,%eax
  ec:	eb f5                	jmp    e3 <strlen+0xf>
    ;
  return n;
}
  ee:	5d                   	pop    %ebp
  ef:	c3                   	ret    

000000f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f0:	f3 0f 1e fb          	endbr32 
  f4:	55                   	push   %ebp
  f5:	89 e5                	mov    %esp,%ebp
  f7:	57                   	push   %edi
  f8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  fb:	89 d7                	mov    %edx,%edi
  fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
 100:	8b 45 0c             	mov    0xc(%ebp),%eax
 103:	fc                   	cld    
 104:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 106:	89 d0                	mov    %edx,%eax
 108:	5f                   	pop    %edi
 109:	5d                   	pop    %ebp
 10a:	c3                   	ret    

0000010b <strchr>:

char*
strchr(const char *s, char c)
{
 10b:	f3 0f 1e fb          	endbr32 
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	8b 45 08             	mov    0x8(%ebp),%eax
 115:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 119:	0f b6 10             	movzbl (%eax),%edx
 11c:	84 d2                	test   %dl,%dl
 11e:	74 09                	je     129 <strchr+0x1e>
    if(*s == c)
 120:	38 ca                	cmp    %cl,%dl
 122:	74 0a                	je     12e <strchr+0x23>
  for(; *s; s++)
 124:	83 c0 01             	add    $0x1,%eax
 127:	eb f0                	jmp    119 <strchr+0xe>
      return (char*)s;
  return 0;
 129:	b8 00 00 00 00       	mov    $0x0,%eax
}
 12e:	5d                   	pop    %ebp
 12f:	c3                   	ret    

00000130 <gets>:

char*
gets(char *buf, int max)
{
 130:	f3 0f 1e fb          	endbr32 
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	57                   	push   %edi
 138:	56                   	push   %esi
 139:	53                   	push   %ebx
 13a:	83 ec 1c             	sub    $0x1c,%esp
 13d:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 140:	bb 00 00 00 00       	mov    $0x0,%ebx
 145:	89 de                	mov    %ebx,%esi
 147:	83 c3 01             	add    $0x1,%ebx
 14a:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 14d:	7d 2e                	jge    17d <gets+0x4d>
    cc = read(0, &c, 1);
 14f:	83 ec 04             	sub    $0x4,%esp
 152:	6a 01                	push   $0x1
 154:	8d 45 e7             	lea    -0x19(%ebp),%eax
 157:	50                   	push   %eax
 158:	6a 00                	push   $0x0
 15a:	e8 cf 01 00 00       	call   32e <read>
    if(cc < 1)
 15f:	83 c4 10             	add    $0x10,%esp
 162:	85 c0                	test   %eax,%eax
 164:	7e 17                	jle    17d <gets+0x4d>
      break;
    buf[i++] = c;
 166:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 16a:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 16d:	3c 0a                	cmp    $0xa,%al
 16f:	0f 94 c2             	sete   %dl
 172:	3c 0d                	cmp    $0xd,%al
 174:	0f 94 c0             	sete   %al
 177:	08 c2                	or     %al,%dl
 179:	74 ca                	je     145 <gets+0x15>
    buf[i++] = c;
 17b:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 17d:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 181:	89 f8                	mov    %edi,%eax
 183:	8d 65 f4             	lea    -0xc(%ebp),%esp
 186:	5b                   	pop    %ebx
 187:	5e                   	pop    %esi
 188:	5f                   	pop    %edi
 189:	5d                   	pop    %ebp
 18a:	c3                   	ret    

0000018b <stat>:

int
stat(char *n, struct stat *st)
{
 18b:	f3 0f 1e fb          	endbr32 
 18f:	55                   	push   %ebp
 190:	89 e5                	mov    %esp,%ebp
 192:	56                   	push   %esi
 193:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 194:	83 ec 08             	sub    $0x8,%esp
 197:	6a 00                	push   $0x0
 199:	ff 75 08             	pushl  0x8(%ebp)
 19c:	e8 b5 01 00 00       	call   356 <open>
  if(fd < 0)
 1a1:	83 c4 10             	add    $0x10,%esp
 1a4:	85 c0                	test   %eax,%eax
 1a6:	78 24                	js     1cc <stat+0x41>
 1a8:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1aa:	83 ec 08             	sub    $0x8,%esp
 1ad:	ff 75 0c             	pushl  0xc(%ebp)
 1b0:	50                   	push   %eax
 1b1:	e8 b8 01 00 00       	call   36e <fstat>
 1b6:	89 c6                	mov    %eax,%esi
  close(fd);
 1b8:	89 1c 24             	mov    %ebx,(%esp)
 1bb:	e8 7e 01 00 00       	call   33e <close>
  return r;
 1c0:	83 c4 10             	add    $0x10,%esp
}
 1c3:	89 f0                	mov    %esi,%eax
 1c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1c8:	5b                   	pop    %ebx
 1c9:	5e                   	pop    %esi
 1ca:	5d                   	pop    %ebp
 1cb:	c3                   	ret    
    return -1;
 1cc:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1d1:	eb f0                	jmp    1c3 <stat+0x38>

000001d3 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 1d3:	f3 0f 1e fb          	endbr32 
 1d7:	55                   	push   %ebp
 1d8:	89 e5                	mov    %esp,%ebp
 1da:	57                   	push   %edi
 1db:	56                   	push   %esi
 1dc:	53                   	push   %ebx
 1dd:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1e0:	0f b6 02             	movzbl (%edx),%eax
 1e3:	3c 20                	cmp    $0x20,%al
 1e5:	75 05                	jne    1ec <atoi+0x19>
 1e7:	83 c2 01             	add    $0x1,%edx
 1ea:	eb f4                	jmp    1e0 <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 1ec:	3c 2d                	cmp    $0x2d,%al
 1ee:	74 1d                	je     20d <atoi+0x3a>
 1f0:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 1f5:	3c 2b                	cmp    $0x2b,%al
 1f7:	0f 94 c1             	sete   %cl
 1fa:	3c 2d                	cmp    $0x2d,%al
 1fc:	0f 94 c0             	sete   %al
 1ff:	08 c1                	or     %al,%cl
 201:	74 03                	je     206 <atoi+0x33>
    s++;
 203:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 206:	b8 00 00 00 00       	mov    $0x0,%eax
 20b:	eb 17                	jmp    224 <atoi+0x51>
 20d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 212:	eb e1                	jmp    1f5 <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 214:	8d 34 80             	lea    (%eax,%eax,4),%esi
 217:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 21a:	83 c2 01             	add    $0x1,%edx
 21d:	0f be c9             	movsbl %cl,%ecx
 220:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 224:	0f b6 0a             	movzbl (%edx),%ecx
 227:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 22a:	80 fb 09             	cmp    $0x9,%bl
 22d:	76 e5                	jbe    214 <atoi+0x41>
  return sign*n;
 22f:	0f af c7             	imul   %edi,%eax
}
 232:	5b                   	pop    %ebx
 233:	5e                   	pop    %esi
 234:	5f                   	pop    %edi
 235:	5d                   	pop    %ebp
 236:	c3                   	ret    

00000237 <atoo>:

int
atoo(const char *s)
{
 237:	f3 0f 1e fb          	endbr32 
 23b:	55                   	push   %ebp
 23c:	89 e5                	mov    %esp,%ebp
 23e:	57                   	push   %edi
 23f:	56                   	push   %esi
 240:	53                   	push   %ebx
 241:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 244:	0f b6 0a             	movzbl (%edx),%ecx
 247:	80 f9 20             	cmp    $0x20,%cl
 24a:	75 05                	jne    251 <atoo+0x1a>
 24c:	83 c2 01             	add    $0x1,%edx
 24f:	eb f3                	jmp    244 <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 251:	80 f9 2d             	cmp    $0x2d,%cl
 254:	74 23                	je     279 <atoo+0x42>
 256:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 25b:	80 f9 2b             	cmp    $0x2b,%cl
 25e:	0f 94 c0             	sete   %al
 261:	89 c6                	mov    %eax,%esi
 263:	80 f9 2d             	cmp    $0x2d,%cl
 266:	0f 94 c0             	sete   %al
 269:	89 f3                	mov    %esi,%ebx
 26b:	08 c3                	or     %al,%bl
 26d:	74 03                	je     272 <atoo+0x3b>
    s++;
 26f:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 272:	b8 00 00 00 00       	mov    $0x0,%eax
 277:	eb 11                	jmp    28a <atoo+0x53>
 279:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 27e:	eb db                	jmp    25b <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 280:	83 c2 01             	add    $0x1,%edx
 283:	0f be c9             	movsbl %cl,%ecx
 286:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 28a:	0f b6 0a             	movzbl (%edx),%ecx
 28d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 290:	80 fb 07             	cmp    $0x7,%bl
 293:	76 eb                	jbe    280 <atoo+0x49>
  return sign*n;
 295:	0f af c7             	imul   %edi,%eax
}
 298:	5b                   	pop    %ebx
 299:	5e                   	pop    %esi
 29a:	5f                   	pop    %edi
 29b:	5d                   	pop    %ebp
 29c:	c3                   	ret    

0000029d <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 29d:	f3 0f 1e fb          	endbr32 
 2a1:	55                   	push   %ebp
 2a2:	89 e5                	mov    %esp,%ebp
 2a4:	53                   	push   %ebx
 2a5:	8b 55 08             	mov    0x8(%ebp),%edx
 2a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2ab:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 2ae:	eb 09                	jmp    2b9 <strncmp+0x1c>
      n--, p++, q++;
 2b0:	83 e8 01             	sub    $0x1,%eax
 2b3:	83 c2 01             	add    $0x1,%edx
 2b6:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 2b9:	85 c0                	test   %eax,%eax
 2bb:	74 0b                	je     2c8 <strncmp+0x2b>
 2bd:	0f b6 1a             	movzbl (%edx),%ebx
 2c0:	84 db                	test   %bl,%bl
 2c2:	74 04                	je     2c8 <strncmp+0x2b>
 2c4:	3a 19                	cmp    (%ecx),%bl
 2c6:	74 e8                	je     2b0 <strncmp+0x13>
    if(n == 0)
 2c8:	85 c0                	test   %eax,%eax
 2ca:	74 0b                	je     2d7 <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 2cc:	0f b6 02             	movzbl (%edx),%eax
 2cf:	0f b6 11             	movzbl (%ecx),%edx
 2d2:	29 d0                	sub    %edx,%eax
}
 2d4:	5b                   	pop    %ebx
 2d5:	5d                   	pop    %ebp
 2d6:	c3                   	ret    
      return 0;
 2d7:	b8 00 00 00 00       	mov    $0x0,%eax
 2dc:	eb f6                	jmp    2d4 <strncmp+0x37>

000002de <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 2de:	f3 0f 1e fb          	endbr32 
 2e2:	55                   	push   %ebp
 2e3:	89 e5                	mov    %esp,%ebp
 2e5:	56                   	push   %esi
 2e6:	53                   	push   %ebx
 2e7:	8b 75 08             	mov    0x8(%ebp),%esi
 2ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2ed:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 2f0:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 2f2:	8d 58 ff             	lea    -0x1(%eax),%ebx
 2f5:	85 c0                	test   %eax,%eax
 2f7:	7e 0f                	jle    308 <memmove+0x2a>
    *dst++ = *src++;
 2f9:	0f b6 01             	movzbl (%ecx),%eax
 2fc:	88 02                	mov    %al,(%edx)
 2fe:	8d 49 01             	lea    0x1(%ecx),%ecx
 301:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 304:	89 d8                	mov    %ebx,%eax
 306:	eb ea                	jmp    2f2 <memmove+0x14>
  return vdst;
}
 308:	89 f0                	mov    %esi,%eax
 30a:	5b                   	pop    %ebx
 30b:	5e                   	pop    %esi
 30c:	5d                   	pop    %ebp
 30d:	c3                   	ret    

0000030e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 30e:	b8 01 00 00 00       	mov    $0x1,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <exit>:
SYSCALL(exit)
 316:	b8 02 00 00 00       	mov    $0x2,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <wait>:
SYSCALL(wait)
 31e:	b8 03 00 00 00       	mov    $0x3,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <pipe>:
SYSCALL(pipe)
 326:	b8 04 00 00 00       	mov    $0x4,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <read>:
SYSCALL(read)
 32e:	b8 05 00 00 00       	mov    $0x5,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <write>:
SYSCALL(write)
 336:	b8 10 00 00 00       	mov    $0x10,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <close>:
SYSCALL(close)
 33e:	b8 15 00 00 00       	mov    $0x15,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <kill>:
SYSCALL(kill)
 346:	b8 06 00 00 00       	mov    $0x6,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <exec>:
SYSCALL(exec)
 34e:	b8 07 00 00 00       	mov    $0x7,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <open>:
SYSCALL(open)
 356:	b8 0f 00 00 00       	mov    $0xf,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <mknod>:
SYSCALL(mknod)
 35e:	b8 11 00 00 00       	mov    $0x11,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <unlink>:
SYSCALL(unlink)
 366:	b8 12 00 00 00       	mov    $0x12,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <fstat>:
SYSCALL(fstat)
 36e:	b8 08 00 00 00       	mov    $0x8,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <link>:
SYSCALL(link)
 376:	b8 13 00 00 00       	mov    $0x13,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <mkdir>:
SYSCALL(mkdir)
 37e:	b8 14 00 00 00       	mov    $0x14,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <chdir>:
SYSCALL(chdir)
 386:	b8 09 00 00 00       	mov    $0x9,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <dup>:
SYSCALL(dup)
 38e:	b8 0a 00 00 00       	mov    $0xa,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <getpid>:
SYSCALL(getpid)
 396:	b8 0b 00 00 00       	mov    $0xb,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <sbrk>:
SYSCALL(sbrk)
 39e:	b8 0c 00 00 00       	mov    $0xc,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <sleep>:
SYSCALL(sleep)
 3a6:	b8 0d 00 00 00       	mov    $0xd,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <uptime>:
SYSCALL(uptime)
 3ae:	b8 0e 00 00 00       	mov    $0xe,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <halt>:
SYSCALL(halt)
 3b6:	b8 16 00 00 00       	mov    $0x16,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <cps>:
/* ____My changes____ */
SYSCALL(cps)
 3be:	b8 17 00 00 00       	mov    $0x17,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <getppid>:
SYSCALL(getppid)
 3c6:	b8 18 00 00 00       	mov    $0x18,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <getsz>:
SYSCALL(getsz)
 3ce:	b8 19 00 00 00       	mov    $0x19,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <chpr>:
SYSCALL(chpr)
 3d6:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <getcount>:
SYSCALL(getcount)
 3de:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <time>:
SYSCALL(time)
 3e6:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <utctime>:
SYSCALL(utctime)
 3ee:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <dup2>:
SYSCALL(dup2)
 3f6:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3fe:	55                   	push   %ebp
 3ff:	89 e5                	mov    %esp,%ebp
 401:	83 ec 1c             	sub    $0x1c,%esp
 404:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 407:	6a 01                	push   $0x1
 409:	8d 55 f4             	lea    -0xc(%ebp),%edx
 40c:	52                   	push   %edx
 40d:	50                   	push   %eax
 40e:	e8 23 ff ff ff       	call   336 <write>
}
 413:	83 c4 10             	add    $0x10,%esp
 416:	c9                   	leave  
 417:	c3                   	ret    

00000418 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 418:	55                   	push   %ebp
 419:	89 e5                	mov    %esp,%ebp
 41b:	57                   	push   %edi
 41c:	56                   	push   %esi
 41d:	53                   	push   %ebx
 41e:	83 ec 2c             	sub    $0x2c,%esp
 421:	89 45 d0             	mov    %eax,-0x30(%ebp)
 424:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 426:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 42a:	0f 95 c2             	setne  %dl
 42d:	89 f0                	mov    %esi,%eax
 42f:	c1 e8 1f             	shr    $0x1f,%eax
 432:	84 c2                	test   %al,%dl
 434:	74 42                	je     478 <printint+0x60>
    neg = 1;
    x = -xx;
 436:	f7 de                	neg    %esi
    neg = 1;
 438:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 43f:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 444:	89 f0                	mov    %esi,%eax
 446:	ba 00 00 00 00       	mov    $0x0,%edx
 44b:	f7 f1                	div    %ecx
 44d:	89 df                	mov    %ebx,%edi
 44f:	83 c3 01             	add    $0x1,%ebx
 452:	0f b6 92 98 07 00 00 	movzbl 0x798(%edx),%edx
 459:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 45d:	89 f2                	mov    %esi,%edx
 45f:	89 c6                	mov    %eax,%esi
 461:	39 d1                	cmp    %edx,%ecx
 463:	76 df                	jbe    444 <printint+0x2c>
  if(neg)
 465:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 469:	74 2f                	je     49a <printint+0x82>
    buf[i++] = '-';
 46b:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 470:	8d 5f 02             	lea    0x2(%edi),%ebx
 473:	8b 75 d0             	mov    -0x30(%ebp),%esi
 476:	eb 15                	jmp    48d <printint+0x75>
  neg = 0;
 478:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 47f:	eb be                	jmp    43f <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 481:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 486:	89 f0                	mov    %esi,%eax
 488:	e8 71 ff ff ff       	call   3fe <putc>
  while(--i >= 0)
 48d:	83 eb 01             	sub    $0x1,%ebx
 490:	79 ef                	jns    481 <printint+0x69>
}
 492:	83 c4 2c             	add    $0x2c,%esp
 495:	5b                   	pop    %ebx
 496:	5e                   	pop    %esi
 497:	5f                   	pop    %edi
 498:	5d                   	pop    %ebp
 499:	c3                   	ret    
 49a:	8b 75 d0             	mov    -0x30(%ebp),%esi
 49d:	eb ee                	jmp    48d <printint+0x75>

0000049f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 49f:	f3 0f 1e fb          	endbr32 
 4a3:	55                   	push   %ebp
 4a4:	89 e5                	mov    %esp,%ebp
 4a6:	57                   	push   %edi
 4a7:	56                   	push   %esi
 4a8:	53                   	push   %ebx
 4a9:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4ac:	8d 45 10             	lea    0x10(%ebp),%eax
 4af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 4b2:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 4b7:	bb 00 00 00 00       	mov    $0x0,%ebx
 4bc:	eb 14                	jmp    4d2 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4be:	89 fa                	mov    %edi,%edx
 4c0:	8b 45 08             	mov    0x8(%ebp),%eax
 4c3:	e8 36 ff ff ff       	call   3fe <putc>
 4c8:	eb 05                	jmp    4cf <printf+0x30>
      }
    } else if(state == '%'){
 4ca:	83 fe 25             	cmp    $0x25,%esi
 4cd:	74 25                	je     4f4 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 4cf:	83 c3 01             	add    $0x1,%ebx
 4d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d5:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 4d9:	84 c0                	test   %al,%al
 4db:	0f 84 23 01 00 00    	je     604 <printf+0x165>
    c = fmt[i] & 0xff;
 4e1:	0f be f8             	movsbl %al,%edi
 4e4:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 4e7:	85 f6                	test   %esi,%esi
 4e9:	75 df                	jne    4ca <printf+0x2b>
      if(c == '%'){
 4eb:	83 f8 25             	cmp    $0x25,%eax
 4ee:	75 ce                	jne    4be <printf+0x1f>
        state = '%';
 4f0:	89 c6                	mov    %eax,%esi
 4f2:	eb db                	jmp    4cf <printf+0x30>
      if(c == 'd'){
 4f4:	83 f8 64             	cmp    $0x64,%eax
 4f7:	74 49                	je     542 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4f9:	83 f8 78             	cmp    $0x78,%eax
 4fc:	0f 94 c1             	sete   %cl
 4ff:	83 f8 70             	cmp    $0x70,%eax
 502:	0f 94 c2             	sete   %dl
 505:	08 d1                	or     %dl,%cl
 507:	75 63                	jne    56c <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 509:	83 f8 73             	cmp    $0x73,%eax
 50c:	0f 84 84 00 00 00    	je     596 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 512:	83 f8 63             	cmp    $0x63,%eax
 515:	0f 84 b7 00 00 00    	je     5d2 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 51b:	83 f8 25             	cmp    $0x25,%eax
 51e:	0f 84 cc 00 00 00    	je     5f0 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 524:	ba 25 00 00 00       	mov    $0x25,%edx
 529:	8b 45 08             	mov    0x8(%ebp),%eax
 52c:	e8 cd fe ff ff       	call   3fe <putc>
        putc(fd, c);
 531:	89 fa                	mov    %edi,%edx
 533:	8b 45 08             	mov    0x8(%ebp),%eax
 536:	e8 c3 fe ff ff       	call   3fe <putc>
      }
      state = 0;
 53b:	be 00 00 00 00       	mov    $0x0,%esi
 540:	eb 8d                	jmp    4cf <printf+0x30>
        printint(fd, *ap, 10, 1);
 542:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 545:	8b 17                	mov    (%edi),%edx
 547:	83 ec 0c             	sub    $0xc,%esp
 54a:	6a 01                	push   $0x1
 54c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 551:	8b 45 08             	mov    0x8(%ebp),%eax
 554:	e8 bf fe ff ff       	call   418 <printint>
        ap++;
 559:	83 c7 04             	add    $0x4,%edi
 55c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 55f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 562:	be 00 00 00 00       	mov    $0x0,%esi
 567:	e9 63 ff ff ff       	jmp    4cf <printf+0x30>
        printint(fd, *ap, 16, 0);
 56c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 56f:	8b 17                	mov    (%edi),%edx
 571:	83 ec 0c             	sub    $0xc,%esp
 574:	6a 00                	push   $0x0
 576:	b9 10 00 00 00       	mov    $0x10,%ecx
 57b:	8b 45 08             	mov    0x8(%ebp),%eax
 57e:	e8 95 fe ff ff       	call   418 <printint>
        ap++;
 583:	83 c7 04             	add    $0x4,%edi
 586:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 589:	83 c4 10             	add    $0x10,%esp
      state = 0;
 58c:	be 00 00 00 00       	mov    $0x0,%esi
 591:	e9 39 ff ff ff       	jmp    4cf <printf+0x30>
        s = (char*)*ap;
 596:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 599:	8b 30                	mov    (%eax),%esi
        ap++;
 59b:	83 c0 04             	add    $0x4,%eax
 59e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 5a1:	85 f6                	test   %esi,%esi
 5a3:	75 28                	jne    5cd <printf+0x12e>
          s = "(null)";
 5a5:	be 90 07 00 00       	mov    $0x790,%esi
 5aa:	8b 7d 08             	mov    0x8(%ebp),%edi
 5ad:	eb 0d                	jmp    5bc <printf+0x11d>
          putc(fd, *s);
 5af:	0f be d2             	movsbl %dl,%edx
 5b2:	89 f8                	mov    %edi,%eax
 5b4:	e8 45 fe ff ff       	call   3fe <putc>
          s++;
 5b9:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 5bc:	0f b6 16             	movzbl (%esi),%edx
 5bf:	84 d2                	test   %dl,%dl
 5c1:	75 ec                	jne    5af <printf+0x110>
      state = 0;
 5c3:	be 00 00 00 00       	mov    $0x0,%esi
 5c8:	e9 02 ff ff ff       	jmp    4cf <printf+0x30>
 5cd:	8b 7d 08             	mov    0x8(%ebp),%edi
 5d0:	eb ea                	jmp    5bc <printf+0x11d>
        putc(fd, *ap);
 5d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5d5:	0f be 17             	movsbl (%edi),%edx
 5d8:	8b 45 08             	mov    0x8(%ebp),%eax
 5db:	e8 1e fe ff ff       	call   3fe <putc>
        ap++;
 5e0:	83 c7 04             	add    $0x4,%edi
 5e3:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 5e6:	be 00 00 00 00       	mov    $0x0,%esi
 5eb:	e9 df fe ff ff       	jmp    4cf <printf+0x30>
        putc(fd, c);
 5f0:	89 fa                	mov    %edi,%edx
 5f2:	8b 45 08             	mov    0x8(%ebp),%eax
 5f5:	e8 04 fe ff ff       	call   3fe <putc>
      state = 0;
 5fa:	be 00 00 00 00       	mov    $0x0,%esi
 5ff:	e9 cb fe ff ff       	jmp    4cf <printf+0x30>
    }
  }
}
 604:	8d 65 f4             	lea    -0xc(%ebp),%esp
 607:	5b                   	pop    %ebx
 608:	5e                   	pop    %esi
 609:	5f                   	pop    %edi
 60a:	5d                   	pop    %ebp
 60b:	c3                   	ret    

0000060c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 60c:	f3 0f 1e fb          	endbr32 
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	57                   	push   %edi
 614:	56                   	push   %esi
 615:	53                   	push   %ebx
 616:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 619:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61c:	a1 94 0a 00 00       	mov    0xa94,%eax
 621:	eb 02                	jmp    625 <free+0x19>
 623:	89 d0                	mov    %edx,%eax
 625:	39 c8                	cmp    %ecx,%eax
 627:	73 04                	jae    62d <free+0x21>
 629:	39 08                	cmp    %ecx,(%eax)
 62b:	77 12                	ja     63f <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 62d:	8b 10                	mov    (%eax),%edx
 62f:	39 c2                	cmp    %eax,%edx
 631:	77 f0                	ja     623 <free+0x17>
 633:	39 c8                	cmp    %ecx,%eax
 635:	72 08                	jb     63f <free+0x33>
 637:	39 ca                	cmp    %ecx,%edx
 639:	77 04                	ja     63f <free+0x33>
 63b:	89 d0                	mov    %edx,%eax
 63d:	eb e6                	jmp    625 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 63f:	8b 73 fc             	mov    -0x4(%ebx),%esi
 642:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 645:	8b 10                	mov    (%eax),%edx
 647:	39 d7                	cmp    %edx,%edi
 649:	74 19                	je     664 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 64b:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 64e:	8b 50 04             	mov    0x4(%eax),%edx
 651:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 654:	39 ce                	cmp    %ecx,%esi
 656:	74 1b                	je     673 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 658:	89 08                	mov    %ecx,(%eax)
  freep = p;
 65a:	a3 94 0a 00 00       	mov    %eax,0xa94
}
 65f:	5b                   	pop    %ebx
 660:	5e                   	pop    %esi
 661:	5f                   	pop    %edi
 662:	5d                   	pop    %ebp
 663:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 664:	03 72 04             	add    0x4(%edx),%esi
 667:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 66a:	8b 10                	mov    (%eax),%edx
 66c:	8b 12                	mov    (%edx),%edx
 66e:	89 53 f8             	mov    %edx,-0x8(%ebx)
 671:	eb db                	jmp    64e <free+0x42>
    p->s.size += bp->s.size;
 673:	03 53 fc             	add    -0x4(%ebx),%edx
 676:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 679:	8b 53 f8             	mov    -0x8(%ebx),%edx
 67c:	89 10                	mov    %edx,(%eax)
 67e:	eb da                	jmp    65a <free+0x4e>

00000680 <morecore>:

static Header*
morecore(uint nu)
{
 680:	55                   	push   %ebp
 681:	89 e5                	mov    %esp,%ebp
 683:	53                   	push   %ebx
 684:	83 ec 04             	sub    $0x4,%esp
 687:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 689:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 68e:	77 05                	ja     695 <morecore+0x15>
    nu = 4096;
 690:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 695:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 69c:	83 ec 0c             	sub    $0xc,%esp
 69f:	50                   	push   %eax
 6a0:	e8 f9 fc ff ff       	call   39e <sbrk>
  if(p == (char*)-1)
 6a5:	83 c4 10             	add    $0x10,%esp
 6a8:	83 f8 ff             	cmp    $0xffffffff,%eax
 6ab:	74 1c                	je     6c9 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6ad:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6b0:	83 c0 08             	add    $0x8,%eax
 6b3:	83 ec 0c             	sub    $0xc,%esp
 6b6:	50                   	push   %eax
 6b7:	e8 50 ff ff ff       	call   60c <free>
  return freep;
 6bc:	a1 94 0a 00 00       	mov    0xa94,%eax
 6c1:	83 c4 10             	add    $0x10,%esp
}
 6c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6c7:	c9                   	leave  
 6c8:	c3                   	ret    
    return 0;
 6c9:	b8 00 00 00 00       	mov    $0x0,%eax
 6ce:	eb f4                	jmp    6c4 <morecore+0x44>

000006d0 <malloc>:

void*
malloc(uint nbytes)
{
 6d0:	f3 0f 1e fb          	endbr32 
 6d4:	55                   	push   %ebp
 6d5:	89 e5                	mov    %esp,%ebp
 6d7:	53                   	push   %ebx
 6d8:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6db:	8b 45 08             	mov    0x8(%ebp),%eax
 6de:	8d 58 07             	lea    0x7(%eax),%ebx
 6e1:	c1 eb 03             	shr    $0x3,%ebx
 6e4:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6e7:	8b 0d 94 0a 00 00    	mov    0xa94,%ecx
 6ed:	85 c9                	test   %ecx,%ecx
 6ef:	74 04                	je     6f5 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f1:	8b 01                	mov    (%ecx),%eax
 6f3:	eb 4b                	jmp    740 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 6f5:	c7 05 94 0a 00 00 98 	movl   $0xa98,0xa94
 6fc:	0a 00 00 
 6ff:	c7 05 98 0a 00 00 98 	movl   $0xa98,0xa98
 706:	0a 00 00 
    base.s.size = 0;
 709:	c7 05 9c 0a 00 00 00 	movl   $0x0,0xa9c
 710:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 713:	b9 98 0a 00 00       	mov    $0xa98,%ecx
 718:	eb d7                	jmp    6f1 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 71a:	74 1a                	je     736 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 71c:	29 da                	sub    %ebx,%edx
 71e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 721:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 724:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 727:	89 0d 94 0a 00 00    	mov    %ecx,0xa94
      return (void*)(p + 1);
 72d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 730:	83 c4 04             	add    $0x4,%esp
 733:	5b                   	pop    %ebx
 734:	5d                   	pop    %ebp
 735:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 736:	8b 10                	mov    (%eax),%edx
 738:	89 11                	mov    %edx,(%ecx)
 73a:	eb eb                	jmp    727 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 73c:	89 c1                	mov    %eax,%ecx
 73e:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 740:	8b 50 04             	mov    0x4(%eax),%edx
 743:	39 da                	cmp    %ebx,%edx
 745:	73 d3                	jae    71a <malloc+0x4a>
    if(p == freep)
 747:	39 05 94 0a 00 00    	cmp    %eax,0xa94
 74d:	75 ed                	jne    73c <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 74f:	89 d8                	mov    %ebx,%eax
 751:	e8 2a ff ff ff       	call   680 <morecore>
 756:	85 c0                	test   %eax,%eax
 758:	75 e2                	jne    73c <malloc+0x6c>
 75a:	eb d4                	jmp    730 <malloc+0x60>
