
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "pdx.h"
#endif // PDX_XV6

int
main(int argc, char **argv)
{
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
  18:	8b 31                	mov    (%ecx),%esi
  1a:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
  1d:	83 fe 01             	cmp    $0x1,%esi
  20:	7e 07                	jle    29 <main+0x29>
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  22:	bb 01 00 00 00       	mov    $0x1,%ebx
  27:	eb 2d                	jmp    56 <main+0x56>
    printf(2, "usage: kill pid...\n");
  29:	83 ec 08             	sub    $0x8,%esp
  2c:	68 3c 07 00 00       	push   $0x73c
  31:	6a 02                	push   $0x2
  33:	e8 46 04 00 00       	call   47e <printf>
    exit();
  38:	e8 b8 02 00 00       	call   2f5 <exit>
    kill(atoi(argv[i]));
  3d:	83 ec 0c             	sub    $0xc,%esp
  40:	ff 34 9f             	pushl  (%edi,%ebx,4)
  43:	e8 6a 01 00 00       	call   1b2 <atoi>
  48:	89 04 24             	mov    %eax,(%esp)
  4b:	e8 d5 02 00 00       	call   325 <kill>
  for(i=1; i<argc; i++)
  50:	83 c3 01             	add    $0x1,%ebx
  53:	83 c4 10             	add    $0x10,%esp
  56:	39 f3                	cmp    %esi,%ebx
  58:	7c e3                	jl     3d <main+0x3d>
  exit();
  5a:	e8 96 02 00 00       	call   2f5 <exit>

0000005f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  5f:	f3 0f 1e fb          	endbr32 
  63:	55                   	push   %ebp
  64:	89 e5                	mov    %esp,%ebp
  66:	56                   	push   %esi
  67:	53                   	push   %ebx
  68:	8b 75 08             	mov    0x8(%ebp),%esi
  6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6e:	89 f0                	mov    %esi,%eax
  70:	89 d1                	mov    %edx,%ecx
  72:	83 c2 01             	add    $0x1,%edx
  75:	89 c3                	mov    %eax,%ebx
  77:	83 c0 01             	add    $0x1,%eax
  7a:	0f b6 09             	movzbl (%ecx),%ecx
  7d:	88 0b                	mov    %cl,(%ebx)
  7f:	84 c9                	test   %cl,%cl
  81:	75 ed                	jne    70 <strcpy+0x11>
    ;
  return os;
}
  83:	89 f0                	mov    %esi,%eax
  85:	5b                   	pop    %ebx
  86:	5e                   	pop    %esi
  87:	5d                   	pop    %ebp
  88:	c3                   	ret    

00000089 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  89:	f3 0f 1e fb          	endbr32 
  8d:	55                   	push   %ebp
  8e:	89 e5                	mov    %esp,%ebp
  90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  93:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  96:	0f b6 01             	movzbl (%ecx),%eax
  99:	84 c0                	test   %al,%al
  9b:	74 0c                	je     a9 <strcmp+0x20>
  9d:	3a 02                	cmp    (%edx),%al
  9f:	75 08                	jne    a9 <strcmp+0x20>
    p++, q++;
  a1:	83 c1 01             	add    $0x1,%ecx
  a4:	83 c2 01             	add    $0x1,%edx
  a7:	eb ed                	jmp    96 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  a9:	0f b6 c0             	movzbl %al,%eax
  ac:	0f b6 12             	movzbl (%edx),%edx
  af:	29 d0                	sub    %edx,%eax
}
  b1:	5d                   	pop    %ebp
  b2:	c3                   	ret    

000000b3 <strlen>:

uint
strlen(char *s)
{
  b3:	f3 0f 1e fb          	endbr32 
  b7:	55                   	push   %ebp
  b8:	89 e5                	mov    %esp,%ebp
  ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  bd:	b8 00 00 00 00       	mov    $0x0,%eax
  c2:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  c6:	74 05                	je     cd <strlen+0x1a>
  c8:	83 c0 01             	add    $0x1,%eax
  cb:	eb f5                	jmp    c2 <strlen+0xf>
    ;
  return n;
}
  cd:	5d                   	pop    %ebp
  ce:	c3                   	ret    

000000cf <memset>:

void*
memset(void *dst, int c, uint n)
{
  cf:	f3 0f 1e fb          	endbr32 
  d3:	55                   	push   %ebp
  d4:	89 e5                	mov    %esp,%ebp
  d6:	57                   	push   %edi
  d7:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  da:	89 d7                	mov    %edx,%edi
  dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  df:	8b 45 0c             	mov    0xc(%ebp),%eax
  e2:	fc                   	cld    
  e3:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  e5:	89 d0                	mov    %edx,%eax
  e7:	5f                   	pop    %edi
  e8:	5d                   	pop    %ebp
  e9:	c3                   	ret    

000000ea <strchr>:

char*
strchr(const char *s, char c)
{
  ea:	f3 0f 1e fb          	endbr32 
  ee:	55                   	push   %ebp
  ef:	89 e5                	mov    %esp,%ebp
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  f8:	0f b6 10             	movzbl (%eax),%edx
  fb:	84 d2                	test   %dl,%dl
  fd:	74 09                	je     108 <strchr+0x1e>
    if(*s == c)
  ff:	38 ca                	cmp    %cl,%dl
 101:	74 0a                	je     10d <strchr+0x23>
  for(; *s; s++)
 103:	83 c0 01             	add    $0x1,%eax
 106:	eb f0                	jmp    f8 <strchr+0xe>
      return (char*)s;
  return 0;
 108:	b8 00 00 00 00       	mov    $0x0,%eax
}
 10d:	5d                   	pop    %ebp
 10e:	c3                   	ret    

0000010f <gets>:

char*
gets(char *buf, int max)
{
 10f:	f3 0f 1e fb          	endbr32 
 113:	55                   	push   %ebp
 114:	89 e5                	mov    %esp,%ebp
 116:	57                   	push   %edi
 117:	56                   	push   %esi
 118:	53                   	push   %ebx
 119:	83 ec 1c             	sub    $0x1c,%esp
 11c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 11f:	bb 00 00 00 00       	mov    $0x0,%ebx
 124:	89 de                	mov    %ebx,%esi
 126:	83 c3 01             	add    $0x1,%ebx
 129:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 12c:	7d 2e                	jge    15c <gets+0x4d>
    cc = read(0, &c, 1);
 12e:	83 ec 04             	sub    $0x4,%esp
 131:	6a 01                	push   $0x1
 133:	8d 45 e7             	lea    -0x19(%ebp),%eax
 136:	50                   	push   %eax
 137:	6a 00                	push   $0x0
 139:	e8 cf 01 00 00       	call   30d <read>
    if(cc < 1)
 13e:	83 c4 10             	add    $0x10,%esp
 141:	85 c0                	test   %eax,%eax
 143:	7e 17                	jle    15c <gets+0x4d>
      break;
    buf[i++] = c;
 145:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 149:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 14c:	3c 0a                	cmp    $0xa,%al
 14e:	0f 94 c2             	sete   %dl
 151:	3c 0d                	cmp    $0xd,%al
 153:	0f 94 c0             	sete   %al
 156:	08 c2                	or     %al,%dl
 158:	74 ca                	je     124 <gets+0x15>
    buf[i++] = c;
 15a:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 15c:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 160:	89 f8                	mov    %edi,%eax
 162:	8d 65 f4             	lea    -0xc(%ebp),%esp
 165:	5b                   	pop    %ebx
 166:	5e                   	pop    %esi
 167:	5f                   	pop    %edi
 168:	5d                   	pop    %ebp
 169:	c3                   	ret    

0000016a <stat>:

int
stat(char *n, struct stat *st)
{
 16a:	f3 0f 1e fb          	endbr32 
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	56                   	push   %esi
 172:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 173:	83 ec 08             	sub    $0x8,%esp
 176:	6a 00                	push   $0x0
 178:	ff 75 08             	pushl  0x8(%ebp)
 17b:	e8 b5 01 00 00       	call   335 <open>
  if(fd < 0)
 180:	83 c4 10             	add    $0x10,%esp
 183:	85 c0                	test   %eax,%eax
 185:	78 24                	js     1ab <stat+0x41>
 187:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 189:	83 ec 08             	sub    $0x8,%esp
 18c:	ff 75 0c             	pushl  0xc(%ebp)
 18f:	50                   	push   %eax
 190:	e8 b8 01 00 00       	call   34d <fstat>
 195:	89 c6                	mov    %eax,%esi
  close(fd);
 197:	89 1c 24             	mov    %ebx,(%esp)
 19a:	e8 7e 01 00 00       	call   31d <close>
  return r;
 19f:	83 c4 10             	add    $0x10,%esp
}
 1a2:	89 f0                	mov    %esi,%eax
 1a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1a7:	5b                   	pop    %ebx
 1a8:	5e                   	pop    %esi
 1a9:	5d                   	pop    %ebp
 1aa:	c3                   	ret    
    return -1;
 1ab:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1b0:	eb f0                	jmp    1a2 <stat+0x38>

000001b2 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 1b2:	f3 0f 1e fb          	endbr32 
 1b6:	55                   	push   %ebp
 1b7:	89 e5                	mov    %esp,%ebp
 1b9:	57                   	push   %edi
 1ba:	56                   	push   %esi
 1bb:	53                   	push   %ebx
 1bc:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1bf:	0f b6 02             	movzbl (%edx),%eax
 1c2:	3c 20                	cmp    $0x20,%al
 1c4:	75 05                	jne    1cb <atoi+0x19>
 1c6:	83 c2 01             	add    $0x1,%edx
 1c9:	eb f4                	jmp    1bf <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 1cb:	3c 2d                	cmp    $0x2d,%al
 1cd:	74 1d                	je     1ec <atoi+0x3a>
 1cf:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 1d4:	3c 2b                	cmp    $0x2b,%al
 1d6:	0f 94 c1             	sete   %cl
 1d9:	3c 2d                	cmp    $0x2d,%al
 1db:	0f 94 c0             	sete   %al
 1de:	08 c1                	or     %al,%cl
 1e0:	74 03                	je     1e5 <atoi+0x33>
    s++;
 1e2:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 1e5:	b8 00 00 00 00       	mov    $0x0,%eax
 1ea:	eb 17                	jmp    203 <atoi+0x51>
 1ec:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 1f1:	eb e1                	jmp    1d4 <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 1f3:	8d 34 80             	lea    (%eax,%eax,4),%esi
 1f6:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 1f9:	83 c2 01             	add    $0x1,%edx
 1fc:	0f be c9             	movsbl %cl,%ecx
 1ff:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 203:	0f b6 0a             	movzbl (%edx),%ecx
 206:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 209:	80 fb 09             	cmp    $0x9,%bl
 20c:	76 e5                	jbe    1f3 <atoi+0x41>
  return sign*n;
 20e:	0f af c7             	imul   %edi,%eax
}
 211:	5b                   	pop    %ebx
 212:	5e                   	pop    %esi
 213:	5f                   	pop    %edi
 214:	5d                   	pop    %ebp
 215:	c3                   	ret    

00000216 <atoo>:

int
atoo(const char *s)
{
 216:	f3 0f 1e fb          	endbr32 
 21a:	55                   	push   %ebp
 21b:	89 e5                	mov    %esp,%ebp
 21d:	57                   	push   %edi
 21e:	56                   	push   %esi
 21f:	53                   	push   %ebx
 220:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 223:	0f b6 0a             	movzbl (%edx),%ecx
 226:	80 f9 20             	cmp    $0x20,%cl
 229:	75 05                	jne    230 <atoo+0x1a>
 22b:	83 c2 01             	add    $0x1,%edx
 22e:	eb f3                	jmp    223 <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 230:	80 f9 2d             	cmp    $0x2d,%cl
 233:	74 23                	je     258 <atoo+0x42>
 235:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 23a:	80 f9 2b             	cmp    $0x2b,%cl
 23d:	0f 94 c0             	sete   %al
 240:	89 c6                	mov    %eax,%esi
 242:	80 f9 2d             	cmp    $0x2d,%cl
 245:	0f 94 c0             	sete   %al
 248:	89 f3                	mov    %esi,%ebx
 24a:	08 c3                	or     %al,%bl
 24c:	74 03                	je     251 <atoo+0x3b>
    s++;
 24e:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 251:	b8 00 00 00 00       	mov    $0x0,%eax
 256:	eb 11                	jmp    269 <atoo+0x53>
 258:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 25d:	eb db                	jmp    23a <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 25f:	83 c2 01             	add    $0x1,%edx
 262:	0f be c9             	movsbl %cl,%ecx
 265:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 269:	0f b6 0a             	movzbl (%edx),%ecx
 26c:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 26f:	80 fb 07             	cmp    $0x7,%bl
 272:	76 eb                	jbe    25f <atoo+0x49>
  return sign*n;
 274:	0f af c7             	imul   %edi,%eax
}
 277:	5b                   	pop    %ebx
 278:	5e                   	pop    %esi
 279:	5f                   	pop    %edi
 27a:	5d                   	pop    %ebp
 27b:	c3                   	ret    

0000027c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 27c:	f3 0f 1e fb          	endbr32 
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	53                   	push   %ebx
 284:	8b 55 08             	mov    0x8(%ebp),%edx
 287:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 28a:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 28d:	eb 09                	jmp    298 <strncmp+0x1c>
      n--, p++, q++;
 28f:	83 e8 01             	sub    $0x1,%eax
 292:	83 c2 01             	add    $0x1,%edx
 295:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 298:	85 c0                	test   %eax,%eax
 29a:	74 0b                	je     2a7 <strncmp+0x2b>
 29c:	0f b6 1a             	movzbl (%edx),%ebx
 29f:	84 db                	test   %bl,%bl
 2a1:	74 04                	je     2a7 <strncmp+0x2b>
 2a3:	3a 19                	cmp    (%ecx),%bl
 2a5:	74 e8                	je     28f <strncmp+0x13>
    if(n == 0)
 2a7:	85 c0                	test   %eax,%eax
 2a9:	74 0b                	je     2b6 <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 2ab:	0f b6 02             	movzbl (%edx),%eax
 2ae:	0f b6 11             	movzbl (%ecx),%edx
 2b1:	29 d0                	sub    %edx,%eax
}
 2b3:	5b                   	pop    %ebx
 2b4:	5d                   	pop    %ebp
 2b5:	c3                   	ret    
      return 0;
 2b6:	b8 00 00 00 00       	mov    $0x0,%eax
 2bb:	eb f6                	jmp    2b3 <strncmp+0x37>

000002bd <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 2bd:	f3 0f 1e fb          	endbr32 
 2c1:	55                   	push   %ebp
 2c2:	89 e5                	mov    %esp,%ebp
 2c4:	56                   	push   %esi
 2c5:	53                   	push   %ebx
 2c6:	8b 75 08             	mov    0x8(%ebp),%esi
 2c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2cc:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 2cf:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 2d1:	8d 58 ff             	lea    -0x1(%eax),%ebx
 2d4:	85 c0                	test   %eax,%eax
 2d6:	7e 0f                	jle    2e7 <memmove+0x2a>
    *dst++ = *src++;
 2d8:	0f b6 01             	movzbl (%ecx),%eax
 2db:	88 02                	mov    %al,(%edx)
 2dd:	8d 49 01             	lea    0x1(%ecx),%ecx
 2e0:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 2e3:	89 d8                	mov    %ebx,%eax
 2e5:	eb ea                	jmp    2d1 <memmove+0x14>
  return vdst;
}
 2e7:	89 f0                	mov    %esi,%eax
 2e9:	5b                   	pop    %ebx
 2ea:	5e                   	pop    %esi
 2eb:	5d                   	pop    %ebp
 2ec:	c3                   	ret    

000002ed <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ed:	b8 01 00 00 00       	mov    $0x1,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <exit>:
SYSCALL(exit)
 2f5:	b8 02 00 00 00       	mov    $0x2,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <wait>:
SYSCALL(wait)
 2fd:	b8 03 00 00 00       	mov    $0x3,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <pipe>:
SYSCALL(pipe)
 305:	b8 04 00 00 00       	mov    $0x4,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <read>:
SYSCALL(read)
 30d:	b8 05 00 00 00       	mov    $0x5,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <write>:
SYSCALL(write)
 315:	b8 10 00 00 00       	mov    $0x10,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <close>:
SYSCALL(close)
 31d:	b8 15 00 00 00       	mov    $0x15,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <kill>:
SYSCALL(kill)
 325:	b8 06 00 00 00       	mov    $0x6,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <exec>:
SYSCALL(exec)
 32d:	b8 07 00 00 00       	mov    $0x7,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <open>:
SYSCALL(open)
 335:	b8 0f 00 00 00       	mov    $0xf,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <mknod>:
SYSCALL(mknod)
 33d:	b8 11 00 00 00       	mov    $0x11,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <unlink>:
SYSCALL(unlink)
 345:	b8 12 00 00 00       	mov    $0x12,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <fstat>:
SYSCALL(fstat)
 34d:	b8 08 00 00 00       	mov    $0x8,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <link>:
SYSCALL(link)
 355:	b8 13 00 00 00       	mov    $0x13,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <mkdir>:
SYSCALL(mkdir)
 35d:	b8 14 00 00 00       	mov    $0x14,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <chdir>:
SYSCALL(chdir)
 365:	b8 09 00 00 00       	mov    $0x9,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <dup>:
SYSCALL(dup)
 36d:	b8 0a 00 00 00       	mov    $0xa,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <getpid>:
SYSCALL(getpid)
 375:	b8 0b 00 00 00       	mov    $0xb,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <sbrk>:
SYSCALL(sbrk)
 37d:	b8 0c 00 00 00       	mov    $0xc,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <sleep>:
SYSCALL(sleep)
 385:	b8 0d 00 00 00       	mov    $0xd,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <uptime>:
SYSCALL(uptime)
 38d:	b8 0e 00 00 00       	mov    $0xe,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <halt>:
SYSCALL(halt)
 395:	b8 16 00 00 00       	mov    $0x16,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <cps>:
/* ____My changes____ */
SYSCALL(cps)
 39d:	b8 17 00 00 00       	mov    $0x17,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <getppid>:
SYSCALL(getppid)
 3a5:	b8 18 00 00 00       	mov    $0x18,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <getsz>:
SYSCALL(getsz)
 3ad:	b8 19 00 00 00       	mov    $0x19,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <chpr>:
SYSCALL(chpr)
 3b5:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <getcount>:
SYSCALL(getcount)
 3bd:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <time>:
SYSCALL(time)
 3c5:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <utctime>:
SYSCALL(utctime)
 3cd:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <dup2>:
SYSCALL(dup2)
 3d5:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3dd:	55                   	push   %ebp
 3de:	89 e5                	mov    %esp,%ebp
 3e0:	83 ec 1c             	sub    $0x1c,%esp
 3e3:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 3e6:	6a 01                	push   $0x1
 3e8:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3eb:	52                   	push   %edx
 3ec:	50                   	push   %eax
 3ed:	e8 23 ff ff ff       	call   315 <write>
}
 3f2:	83 c4 10             	add    $0x10,%esp
 3f5:	c9                   	leave  
 3f6:	c3                   	ret    

000003f7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f7:	55                   	push   %ebp
 3f8:	89 e5                	mov    %esp,%ebp
 3fa:	57                   	push   %edi
 3fb:	56                   	push   %esi
 3fc:	53                   	push   %ebx
 3fd:	83 ec 2c             	sub    $0x2c,%esp
 400:	89 45 d0             	mov    %eax,-0x30(%ebp)
 403:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 405:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 409:	0f 95 c2             	setne  %dl
 40c:	89 f0                	mov    %esi,%eax
 40e:	c1 e8 1f             	shr    $0x1f,%eax
 411:	84 c2                	test   %al,%dl
 413:	74 42                	je     457 <printint+0x60>
    neg = 1;
    x = -xx;
 415:	f7 de                	neg    %esi
    neg = 1;
 417:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 41e:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 423:	89 f0                	mov    %esi,%eax
 425:	ba 00 00 00 00       	mov    $0x0,%edx
 42a:	f7 f1                	div    %ecx
 42c:	89 df                	mov    %ebx,%edi
 42e:	83 c3 01             	add    $0x1,%ebx
 431:	0f b6 92 58 07 00 00 	movzbl 0x758(%edx),%edx
 438:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 43c:	89 f2                	mov    %esi,%edx
 43e:	89 c6                	mov    %eax,%esi
 440:	39 d1                	cmp    %edx,%ecx
 442:	76 df                	jbe    423 <printint+0x2c>
  if(neg)
 444:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 448:	74 2f                	je     479 <printint+0x82>
    buf[i++] = '-';
 44a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 44f:	8d 5f 02             	lea    0x2(%edi),%ebx
 452:	8b 75 d0             	mov    -0x30(%ebp),%esi
 455:	eb 15                	jmp    46c <printint+0x75>
  neg = 0;
 457:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 45e:	eb be                	jmp    41e <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 460:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 465:	89 f0                	mov    %esi,%eax
 467:	e8 71 ff ff ff       	call   3dd <putc>
  while(--i >= 0)
 46c:	83 eb 01             	sub    $0x1,%ebx
 46f:	79 ef                	jns    460 <printint+0x69>
}
 471:	83 c4 2c             	add    $0x2c,%esp
 474:	5b                   	pop    %ebx
 475:	5e                   	pop    %esi
 476:	5f                   	pop    %edi
 477:	5d                   	pop    %ebp
 478:	c3                   	ret    
 479:	8b 75 d0             	mov    -0x30(%ebp),%esi
 47c:	eb ee                	jmp    46c <printint+0x75>

0000047e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 47e:	f3 0f 1e fb          	endbr32 
 482:	55                   	push   %ebp
 483:	89 e5                	mov    %esp,%ebp
 485:	57                   	push   %edi
 486:	56                   	push   %esi
 487:	53                   	push   %ebx
 488:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 48b:	8d 45 10             	lea    0x10(%ebp),%eax
 48e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 491:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 496:	bb 00 00 00 00       	mov    $0x0,%ebx
 49b:	eb 14                	jmp    4b1 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 49d:	89 fa                	mov    %edi,%edx
 49f:	8b 45 08             	mov    0x8(%ebp),%eax
 4a2:	e8 36 ff ff ff       	call   3dd <putc>
 4a7:	eb 05                	jmp    4ae <printf+0x30>
      }
    } else if(state == '%'){
 4a9:	83 fe 25             	cmp    $0x25,%esi
 4ac:	74 25                	je     4d3 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 4ae:	83 c3 01             	add    $0x1,%ebx
 4b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b4:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 4b8:	84 c0                	test   %al,%al
 4ba:	0f 84 23 01 00 00    	je     5e3 <printf+0x165>
    c = fmt[i] & 0xff;
 4c0:	0f be f8             	movsbl %al,%edi
 4c3:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 4c6:	85 f6                	test   %esi,%esi
 4c8:	75 df                	jne    4a9 <printf+0x2b>
      if(c == '%'){
 4ca:	83 f8 25             	cmp    $0x25,%eax
 4cd:	75 ce                	jne    49d <printf+0x1f>
        state = '%';
 4cf:	89 c6                	mov    %eax,%esi
 4d1:	eb db                	jmp    4ae <printf+0x30>
      if(c == 'd'){
 4d3:	83 f8 64             	cmp    $0x64,%eax
 4d6:	74 49                	je     521 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4d8:	83 f8 78             	cmp    $0x78,%eax
 4db:	0f 94 c1             	sete   %cl
 4de:	83 f8 70             	cmp    $0x70,%eax
 4e1:	0f 94 c2             	sete   %dl
 4e4:	08 d1                	or     %dl,%cl
 4e6:	75 63                	jne    54b <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4e8:	83 f8 73             	cmp    $0x73,%eax
 4eb:	0f 84 84 00 00 00    	je     575 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4f1:	83 f8 63             	cmp    $0x63,%eax
 4f4:	0f 84 b7 00 00 00    	je     5b1 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4fa:	83 f8 25             	cmp    $0x25,%eax
 4fd:	0f 84 cc 00 00 00    	je     5cf <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 503:	ba 25 00 00 00       	mov    $0x25,%edx
 508:	8b 45 08             	mov    0x8(%ebp),%eax
 50b:	e8 cd fe ff ff       	call   3dd <putc>
        putc(fd, c);
 510:	89 fa                	mov    %edi,%edx
 512:	8b 45 08             	mov    0x8(%ebp),%eax
 515:	e8 c3 fe ff ff       	call   3dd <putc>
      }
      state = 0;
 51a:	be 00 00 00 00       	mov    $0x0,%esi
 51f:	eb 8d                	jmp    4ae <printf+0x30>
        printint(fd, *ap, 10, 1);
 521:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 524:	8b 17                	mov    (%edi),%edx
 526:	83 ec 0c             	sub    $0xc,%esp
 529:	6a 01                	push   $0x1
 52b:	b9 0a 00 00 00       	mov    $0xa,%ecx
 530:	8b 45 08             	mov    0x8(%ebp),%eax
 533:	e8 bf fe ff ff       	call   3f7 <printint>
        ap++;
 538:	83 c7 04             	add    $0x4,%edi
 53b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 53e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 541:	be 00 00 00 00       	mov    $0x0,%esi
 546:	e9 63 ff ff ff       	jmp    4ae <printf+0x30>
        printint(fd, *ap, 16, 0);
 54b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 54e:	8b 17                	mov    (%edi),%edx
 550:	83 ec 0c             	sub    $0xc,%esp
 553:	6a 00                	push   $0x0
 555:	b9 10 00 00 00       	mov    $0x10,%ecx
 55a:	8b 45 08             	mov    0x8(%ebp),%eax
 55d:	e8 95 fe ff ff       	call   3f7 <printint>
        ap++;
 562:	83 c7 04             	add    $0x4,%edi
 565:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 568:	83 c4 10             	add    $0x10,%esp
      state = 0;
 56b:	be 00 00 00 00       	mov    $0x0,%esi
 570:	e9 39 ff ff ff       	jmp    4ae <printf+0x30>
        s = (char*)*ap;
 575:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 578:	8b 30                	mov    (%eax),%esi
        ap++;
 57a:	83 c0 04             	add    $0x4,%eax
 57d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 580:	85 f6                	test   %esi,%esi
 582:	75 28                	jne    5ac <printf+0x12e>
          s = "(null)";
 584:	be 50 07 00 00       	mov    $0x750,%esi
 589:	8b 7d 08             	mov    0x8(%ebp),%edi
 58c:	eb 0d                	jmp    59b <printf+0x11d>
          putc(fd, *s);
 58e:	0f be d2             	movsbl %dl,%edx
 591:	89 f8                	mov    %edi,%eax
 593:	e8 45 fe ff ff       	call   3dd <putc>
          s++;
 598:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 59b:	0f b6 16             	movzbl (%esi),%edx
 59e:	84 d2                	test   %dl,%dl
 5a0:	75 ec                	jne    58e <printf+0x110>
      state = 0;
 5a2:	be 00 00 00 00       	mov    $0x0,%esi
 5a7:	e9 02 ff ff ff       	jmp    4ae <printf+0x30>
 5ac:	8b 7d 08             	mov    0x8(%ebp),%edi
 5af:	eb ea                	jmp    59b <printf+0x11d>
        putc(fd, *ap);
 5b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5b4:	0f be 17             	movsbl (%edi),%edx
 5b7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ba:	e8 1e fe ff ff       	call   3dd <putc>
        ap++;
 5bf:	83 c7 04             	add    $0x4,%edi
 5c2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 5c5:	be 00 00 00 00       	mov    $0x0,%esi
 5ca:	e9 df fe ff ff       	jmp    4ae <printf+0x30>
        putc(fd, c);
 5cf:	89 fa                	mov    %edi,%edx
 5d1:	8b 45 08             	mov    0x8(%ebp),%eax
 5d4:	e8 04 fe ff ff       	call   3dd <putc>
      state = 0;
 5d9:	be 00 00 00 00       	mov    $0x0,%esi
 5de:	e9 cb fe ff ff       	jmp    4ae <printf+0x30>
    }
  }
}
 5e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5e6:	5b                   	pop    %ebx
 5e7:	5e                   	pop    %esi
 5e8:	5f                   	pop    %edi
 5e9:	5d                   	pop    %ebp
 5ea:	c3                   	ret    

000005eb <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5eb:	f3 0f 1e fb          	endbr32 
 5ef:	55                   	push   %ebp
 5f0:	89 e5                	mov    %esp,%ebp
 5f2:	57                   	push   %edi
 5f3:	56                   	push   %esi
 5f4:	53                   	push   %ebx
 5f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5f8:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fb:	a1 60 0a 00 00       	mov    0xa60,%eax
 600:	eb 02                	jmp    604 <free+0x19>
 602:	89 d0                	mov    %edx,%eax
 604:	39 c8                	cmp    %ecx,%eax
 606:	73 04                	jae    60c <free+0x21>
 608:	39 08                	cmp    %ecx,(%eax)
 60a:	77 12                	ja     61e <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 60c:	8b 10                	mov    (%eax),%edx
 60e:	39 c2                	cmp    %eax,%edx
 610:	77 f0                	ja     602 <free+0x17>
 612:	39 c8                	cmp    %ecx,%eax
 614:	72 08                	jb     61e <free+0x33>
 616:	39 ca                	cmp    %ecx,%edx
 618:	77 04                	ja     61e <free+0x33>
 61a:	89 d0                	mov    %edx,%eax
 61c:	eb e6                	jmp    604 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 61e:	8b 73 fc             	mov    -0x4(%ebx),%esi
 621:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 624:	8b 10                	mov    (%eax),%edx
 626:	39 d7                	cmp    %edx,%edi
 628:	74 19                	je     643 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 62a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 62d:	8b 50 04             	mov    0x4(%eax),%edx
 630:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 633:	39 ce                	cmp    %ecx,%esi
 635:	74 1b                	je     652 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 637:	89 08                	mov    %ecx,(%eax)
  freep = p;
 639:	a3 60 0a 00 00       	mov    %eax,0xa60
}
 63e:	5b                   	pop    %ebx
 63f:	5e                   	pop    %esi
 640:	5f                   	pop    %edi
 641:	5d                   	pop    %ebp
 642:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 643:	03 72 04             	add    0x4(%edx),%esi
 646:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 649:	8b 10                	mov    (%eax),%edx
 64b:	8b 12                	mov    (%edx),%edx
 64d:	89 53 f8             	mov    %edx,-0x8(%ebx)
 650:	eb db                	jmp    62d <free+0x42>
    p->s.size += bp->s.size;
 652:	03 53 fc             	add    -0x4(%ebx),%edx
 655:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 658:	8b 53 f8             	mov    -0x8(%ebx),%edx
 65b:	89 10                	mov    %edx,(%eax)
 65d:	eb da                	jmp    639 <free+0x4e>

0000065f <morecore>:

static Header*
morecore(uint nu)
{
 65f:	55                   	push   %ebp
 660:	89 e5                	mov    %esp,%ebp
 662:	53                   	push   %ebx
 663:	83 ec 04             	sub    $0x4,%esp
 666:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 668:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 66d:	77 05                	ja     674 <morecore+0x15>
    nu = 4096;
 66f:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 674:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 67b:	83 ec 0c             	sub    $0xc,%esp
 67e:	50                   	push   %eax
 67f:	e8 f9 fc ff ff       	call   37d <sbrk>
  if(p == (char*)-1)
 684:	83 c4 10             	add    $0x10,%esp
 687:	83 f8 ff             	cmp    $0xffffffff,%eax
 68a:	74 1c                	je     6a8 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 68c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 68f:	83 c0 08             	add    $0x8,%eax
 692:	83 ec 0c             	sub    $0xc,%esp
 695:	50                   	push   %eax
 696:	e8 50 ff ff ff       	call   5eb <free>
  return freep;
 69b:	a1 60 0a 00 00       	mov    0xa60,%eax
 6a0:	83 c4 10             	add    $0x10,%esp
}
 6a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6a6:	c9                   	leave  
 6a7:	c3                   	ret    
    return 0;
 6a8:	b8 00 00 00 00       	mov    $0x0,%eax
 6ad:	eb f4                	jmp    6a3 <morecore+0x44>

000006af <malloc>:

void*
malloc(uint nbytes)
{
 6af:	f3 0f 1e fb          	endbr32 
 6b3:	55                   	push   %ebp
 6b4:	89 e5                	mov    %esp,%ebp
 6b6:	53                   	push   %ebx
 6b7:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6ba:	8b 45 08             	mov    0x8(%ebp),%eax
 6bd:	8d 58 07             	lea    0x7(%eax),%ebx
 6c0:	c1 eb 03             	shr    $0x3,%ebx
 6c3:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6c6:	8b 0d 60 0a 00 00    	mov    0xa60,%ecx
 6cc:	85 c9                	test   %ecx,%ecx
 6ce:	74 04                	je     6d4 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d0:	8b 01                	mov    (%ecx),%eax
 6d2:	eb 4b                	jmp    71f <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 6d4:	c7 05 60 0a 00 00 64 	movl   $0xa64,0xa60
 6db:	0a 00 00 
 6de:	c7 05 64 0a 00 00 64 	movl   $0xa64,0xa64
 6e5:	0a 00 00 
    base.s.size = 0;
 6e8:	c7 05 68 0a 00 00 00 	movl   $0x0,0xa68
 6ef:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6f2:	b9 64 0a 00 00       	mov    $0xa64,%ecx
 6f7:	eb d7                	jmp    6d0 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 6f9:	74 1a                	je     715 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6fb:	29 da                	sub    %ebx,%edx
 6fd:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 700:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 703:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 706:	89 0d 60 0a 00 00    	mov    %ecx,0xa60
      return (void*)(p + 1);
 70c:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 70f:	83 c4 04             	add    $0x4,%esp
 712:	5b                   	pop    %ebx
 713:	5d                   	pop    %ebp
 714:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 715:	8b 10                	mov    (%eax),%edx
 717:	89 11                	mov    %edx,(%ecx)
 719:	eb eb                	jmp    706 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 71b:	89 c1                	mov    %eax,%ecx
 71d:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 71f:	8b 50 04             	mov    0x4(%eax),%edx
 722:	39 da                	cmp    %ebx,%edx
 724:	73 d3                	jae    6f9 <malloc+0x4a>
    if(p == freep)
 726:	39 05 60 0a 00 00    	cmp    %eax,0xa60
 72c:	75 ed                	jne    71b <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 72e:	89 d8                	mov    %ebx,%eax
 730:	e8 2a ff ff ff       	call   65f <morecore>
 735:	85 c0                	test   %eax,%eax
 737:	75 e2                	jne    71b <malloc+0x6c>
 739:	eb d4                	jmp    70f <malloc+0x60>
