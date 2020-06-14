
_test_getsz:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char *argv[]){
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 04             	sub    $0x4,%esp
	int size;
	size = getsz();
  15:	e8 63 03 00 00       	call   37d <getsz>
	printf(1, "%d\n", size);
  1a:	83 ec 04             	sub    $0x4,%esp
  1d:	50                   	push   %eax
  1e:	68 0c 07 00 00       	push   $0x70c
  23:	6a 01                	push   $0x1
  25:	e8 24 04 00 00       	call   44e <printf>
	exit();
  2a:	e8 96 02 00 00       	call   2c5 <exit>

0000002f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  2f:	f3 0f 1e fb          	endbr32 
  33:	55                   	push   %ebp
  34:	89 e5                	mov    %esp,%ebp
  36:	56                   	push   %esi
  37:	53                   	push   %ebx
  38:	8b 75 08             	mov    0x8(%ebp),%esi
  3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  3e:	89 f0                	mov    %esi,%eax
  40:	89 d1                	mov    %edx,%ecx
  42:	83 c2 01             	add    $0x1,%edx
  45:	89 c3                	mov    %eax,%ebx
  47:	83 c0 01             	add    $0x1,%eax
  4a:	0f b6 09             	movzbl (%ecx),%ecx
  4d:	88 0b                	mov    %cl,(%ebx)
  4f:	84 c9                	test   %cl,%cl
  51:	75 ed                	jne    40 <strcpy+0x11>
    ;
  return os;
}
  53:	89 f0                	mov    %esi,%eax
  55:	5b                   	pop    %ebx
  56:	5e                   	pop    %esi
  57:	5d                   	pop    %ebp
  58:	c3                   	ret    

00000059 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  59:	f3 0f 1e fb          	endbr32 
  5d:	55                   	push   %ebp
  5e:	89 e5                	mov    %esp,%ebp
  60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  63:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  66:	0f b6 01             	movzbl (%ecx),%eax
  69:	84 c0                	test   %al,%al
  6b:	74 0c                	je     79 <strcmp+0x20>
  6d:	3a 02                	cmp    (%edx),%al
  6f:	75 08                	jne    79 <strcmp+0x20>
    p++, q++;
  71:	83 c1 01             	add    $0x1,%ecx
  74:	83 c2 01             	add    $0x1,%edx
  77:	eb ed                	jmp    66 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  79:	0f b6 c0             	movzbl %al,%eax
  7c:	0f b6 12             	movzbl (%edx),%edx
  7f:	29 d0                	sub    %edx,%eax
}
  81:	5d                   	pop    %ebp
  82:	c3                   	ret    

00000083 <strlen>:

uint
strlen(char *s)
{
  83:	f3 0f 1e fb          	endbr32 
  87:	55                   	push   %ebp
  88:	89 e5                	mov    %esp,%ebp
  8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  8d:	b8 00 00 00 00       	mov    $0x0,%eax
  92:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  96:	74 05                	je     9d <strlen+0x1a>
  98:	83 c0 01             	add    $0x1,%eax
  9b:	eb f5                	jmp    92 <strlen+0xf>
    ;
  return n;
}
  9d:	5d                   	pop    %ebp
  9e:	c3                   	ret    

0000009f <memset>:

void*
memset(void *dst, int c, uint n)
{
  9f:	f3 0f 1e fb          	endbr32 
  a3:	55                   	push   %ebp
  a4:	89 e5                	mov    %esp,%ebp
  a6:	57                   	push   %edi
  a7:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  aa:	89 d7                	mov    %edx,%edi
  ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  af:	8b 45 0c             	mov    0xc(%ebp),%eax
  b2:	fc                   	cld    
  b3:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  b5:	89 d0                	mov    %edx,%eax
  b7:	5f                   	pop    %edi
  b8:	5d                   	pop    %ebp
  b9:	c3                   	ret    

000000ba <strchr>:

char*
strchr(const char *s, char c)
{
  ba:	f3 0f 1e fb          	endbr32 
  be:	55                   	push   %ebp
  bf:	89 e5                	mov    %esp,%ebp
  c1:	8b 45 08             	mov    0x8(%ebp),%eax
  c4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  c8:	0f b6 10             	movzbl (%eax),%edx
  cb:	84 d2                	test   %dl,%dl
  cd:	74 09                	je     d8 <strchr+0x1e>
    if(*s == c)
  cf:	38 ca                	cmp    %cl,%dl
  d1:	74 0a                	je     dd <strchr+0x23>
  for(; *s; s++)
  d3:	83 c0 01             	add    $0x1,%eax
  d6:	eb f0                	jmp    c8 <strchr+0xe>
      return (char*)s;
  return 0;
  d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  dd:	5d                   	pop    %ebp
  de:	c3                   	ret    

000000df <gets>:

char*
gets(char *buf, int max)
{
  df:	f3 0f 1e fb          	endbr32 
  e3:	55                   	push   %ebp
  e4:	89 e5                	mov    %esp,%ebp
  e6:	57                   	push   %edi
  e7:	56                   	push   %esi
  e8:	53                   	push   %ebx
  e9:	83 ec 1c             	sub    $0x1c,%esp
  ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  f4:	89 de                	mov    %ebx,%esi
  f6:	83 c3 01             	add    $0x1,%ebx
  f9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  fc:	7d 2e                	jge    12c <gets+0x4d>
    cc = read(0, &c, 1);
  fe:	83 ec 04             	sub    $0x4,%esp
 101:	6a 01                	push   $0x1
 103:	8d 45 e7             	lea    -0x19(%ebp),%eax
 106:	50                   	push   %eax
 107:	6a 00                	push   $0x0
 109:	e8 cf 01 00 00       	call   2dd <read>
    if(cc < 1)
 10e:	83 c4 10             	add    $0x10,%esp
 111:	85 c0                	test   %eax,%eax
 113:	7e 17                	jle    12c <gets+0x4d>
      break;
    buf[i++] = c;
 115:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 119:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 11c:	3c 0a                	cmp    $0xa,%al
 11e:	0f 94 c2             	sete   %dl
 121:	3c 0d                	cmp    $0xd,%al
 123:	0f 94 c0             	sete   %al
 126:	08 c2                	or     %al,%dl
 128:	74 ca                	je     f4 <gets+0x15>
    buf[i++] = c;
 12a:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 12c:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 130:	89 f8                	mov    %edi,%eax
 132:	8d 65 f4             	lea    -0xc(%ebp),%esp
 135:	5b                   	pop    %ebx
 136:	5e                   	pop    %esi
 137:	5f                   	pop    %edi
 138:	5d                   	pop    %ebp
 139:	c3                   	ret    

0000013a <stat>:

int
stat(char *n, struct stat *st)
{
 13a:	f3 0f 1e fb          	endbr32 
 13e:	55                   	push   %ebp
 13f:	89 e5                	mov    %esp,%ebp
 141:	56                   	push   %esi
 142:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 143:	83 ec 08             	sub    $0x8,%esp
 146:	6a 00                	push   $0x0
 148:	ff 75 08             	pushl  0x8(%ebp)
 14b:	e8 b5 01 00 00       	call   305 <open>
  if(fd < 0)
 150:	83 c4 10             	add    $0x10,%esp
 153:	85 c0                	test   %eax,%eax
 155:	78 24                	js     17b <stat+0x41>
 157:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 159:	83 ec 08             	sub    $0x8,%esp
 15c:	ff 75 0c             	pushl  0xc(%ebp)
 15f:	50                   	push   %eax
 160:	e8 b8 01 00 00       	call   31d <fstat>
 165:	89 c6                	mov    %eax,%esi
  close(fd);
 167:	89 1c 24             	mov    %ebx,(%esp)
 16a:	e8 7e 01 00 00       	call   2ed <close>
  return r;
 16f:	83 c4 10             	add    $0x10,%esp
}
 172:	89 f0                	mov    %esi,%eax
 174:	8d 65 f8             	lea    -0x8(%ebp),%esp
 177:	5b                   	pop    %ebx
 178:	5e                   	pop    %esi
 179:	5d                   	pop    %ebp
 17a:	c3                   	ret    
    return -1;
 17b:	be ff ff ff ff       	mov    $0xffffffff,%esi
 180:	eb f0                	jmp    172 <stat+0x38>

00000182 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 182:	f3 0f 1e fb          	endbr32 
 186:	55                   	push   %ebp
 187:	89 e5                	mov    %esp,%ebp
 189:	57                   	push   %edi
 18a:	56                   	push   %esi
 18b:	53                   	push   %ebx
 18c:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 18f:	0f b6 02             	movzbl (%edx),%eax
 192:	3c 20                	cmp    $0x20,%al
 194:	75 05                	jne    19b <atoi+0x19>
 196:	83 c2 01             	add    $0x1,%edx
 199:	eb f4                	jmp    18f <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 19b:	3c 2d                	cmp    $0x2d,%al
 19d:	74 1d                	je     1bc <atoi+0x3a>
 19f:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 1a4:	3c 2b                	cmp    $0x2b,%al
 1a6:	0f 94 c1             	sete   %cl
 1a9:	3c 2d                	cmp    $0x2d,%al
 1ab:	0f 94 c0             	sete   %al
 1ae:	08 c1                	or     %al,%cl
 1b0:	74 03                	je     1b5 <atoi+0x33>
    s++;
 1b2:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 1b5:	b8 00 00 00 00       	mov    $0x0,%eax
 1ba:	eb 17                	jmp    1d3 <atoi+0x51>
 1bc:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 1c1:	eb e1                	jmp    1a4 <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 1c3:	8d 34 80             	lea    (%eax,%eax,4),%esi
 1c6:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 1c9:	83 c2 01             	add    $0x1,%edx
 1cc:	0f be c9             	movsbl %cl,%ecx
 1cf:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 1d3:	0f b6 0a             	movzbl (%edx),%ecx
 1d6:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 1d9:	80 fb 09             	cmp    $0x9,%bl
 1dc:	76 e5                	jbe    1c3 <atoi+0x41>
  return sign*n;
 1de:	0f af c7             	imul   %edi,%eax
}
 1e1:	5b                   	pop    %ebx
 1e2:	5e                   	pop    %esi
 1e3:	5f                   	pop    %edi
 1e4:	5d                   	pop    %ebp
 1e5:	c3                   	ret    

000001e6 <atoo>:

int
atoo(const char *s)
{
 1e6:	f3 0f 1e fb          	endbr32 
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	57                   	push   %edi
 1ee:	56                   	push   %esi
 1ef:	53                   	push   %ebx
 1f0:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1f3:	0f b6 0a             	movzbl (%edx),%ecx
 1f6:	80 f9 20             	cmp    $0x20,%cl
 1f9:	75 05                	jne    200 <atoo+0x1a>
 1fb:	83 c2 01             	add    $0x1,%edx
 1fe:	eb f3                	jmp    1f3 <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 200:	80 f9 2d             	cmp    $0x2d,%cl
 203:	74 23                	je     228 <atoo+0x42>
 205:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 20a:	80 f9 2b             	cmp    $0x2b,%cl
 20d:	0f 94 c0             	sete   %al
 210:	89 c6                	mov    %eax,%esi
 212:	80 f9 2d             	cmp    $0x2d,%cl
 215:	0f 94 c0             	sete   %al
 218:	89 f3                	mov    %esi,%ebx
 21a:	08 c3                	or     %al,%bl
 21c:	74 03                	je     221 <atoo+0x3b>
    s++;
 21e:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 221:	b8 00 00 00 00       	mov    $0x0,%eax
 226:	eb 11                	jmp    239 <atoo+0x53>
 228:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 22d:	eb db                	jmp    20a <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 22f:	83 c2 01             	add    $0x1,%edx
 232:	0f be c9             	movsbl %cl,%ecx
 235:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 239:	0f b6 0a             	movzbl (%edx),%ecx
 23c:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 23f:	80 fb 07             	cmp    $0x7,%bl
 242:	76 eb                	jbe    22f <atoo+0x49>
  return sign*n;
 244:	0f af c7             	imul   %edi,%eax
}
 247:	5b                   	pop    %ebx
 248:	5e                   	pop    %esi
 249:	5f                   	pop    %edi
 24a:	5d                   	pop    %ebp
 24b:	c3                   	ret    

0000024c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 24c:	f3 0f 1e fb          	endbr32 
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	53                   	push   %ebx
 254:	8b 55 08             	mov    0x8(%ebp),%edx
 257:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 25a:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 25d:	eb 09                	jmp    268 <strncmp+0x1c>
      n--, p++, q++;
 25f:	83 e8 01             	sub    $0x1,%eax
 262:	83 c2 01             	add    $0x1,%edx
 265:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 268:	85 c0                	test   %eax,%eax
 26a:	74 0b                	je     277 <strncmp+0x2b>
 26c:	0f b6 1a             	movzbl (%edx),%ebx
 26f:	84 db                	test   %bl,%bl
 271:	74 04                	je     277 <strncmp+0x2b>
 273:	3a 19                	cmp    (%ecx),%bl
 275:	74 e8                	je     25f <strncmp+0x13>
    if(n == 0)
 277:	85 c0                	test   %eax,%eax
 279:	74 0b                	je     286 <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 27b:	0f b6 02             	movzbl (%edx),%eax
 27e:	0f b6 11             	movzbl (%ecx),%edx
 281:	29 d0                	sub    %edx,%eax
}
 283:	5b                   	pop    %ebx
 284:	5d                   	pop    %ebp
 285:	c3                   	ret    
      return 0;
 286:	b8 00 00 00 00       	mov    $0x0,%eax
 28b:	eb f6                	jmp    283 <strncmp+0x37>

0000028d <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 28d:	f3 0f 1e fb          	endbr32 
 291:	55                   	push   %ebp
 292:	89 e5                	mov    %esp,%ebp
 294:	56                   	push   %esi
 295:	53                   	push   %ebx
 296:	8b 75 08             	mov    0x8(%ebp),%esi
 299:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 29c:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 29f:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 2a1:	8d 58 ff             	lea    -0x1(%eax),%ebx
 2a4:	85 c0                	test   %eax,%eax
 2a6:	7e 0f                	jle    2b7 <memmove+0x2a>
    *dst++ = *src++;
 2a8:	0f b6 01             	movzbl (%ecx),%eax
 2ab:	88 02                	mov    %al,(%edx)
 2ad:	8d 49 01             	lea    0x1(%ecx),%ecx
 2b0:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 2b3:	89 d8                	mov    %ebx,%eax
 2b5:	eb ea                	jmp    2a1 <memmove+0x14>
  return vdst;
}
 2b7:	89 f0                	mov    %esi,%eax
 2b9:	5b                   	pop    %ebx
 2ba:	5e                   	pop    %esi
 2bb:	5d                   	pop    %ebp
 2bc:	c3                   	ret    

000002bd <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2bd:	b8 01 00 00 00       	mov    $0x1,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <exit>:
SYSCALL(exit)
 2c5:	b8 02 00 00 00       	mov    $0x2,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    

000002cd <wait>:
SYSCALL(wait)
 2cd:	b8 03 00 00 00       	mov    $0x3,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	ret    

000002d5 <pipe>:
SYSCALL(pipe)
 2d5:	b8 04 00 00 00       	mov    $0x4,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <read>:
SYSCALL(read)
 2dd:	b8 05 00 00 00       	mov    $0x5,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <write>:
SYSCALL(write)
 2e5:	b8 10 00 00 00       	mov    $0x10,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <close>:
SYSCALL(close)
 2ed:	b8 15 00 00 00       	mov    $0x15,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <kill>:
SYSCALL(kill)
 2f5:	b8 06 00 00 00       	mov    $0x6,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <exec>:
SYSCALL(exec)
 2fd:	b8 07 00 00 00       	mov    $0x7,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <open>:
SYSCALL(open)
 305:	b8 0f 00 00 00       	mov    $0xf,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <mknod>:
SYSCALL(mknod)
 30d:	b8 11 00 00 00       	mov    $0x11,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <unlink>:
SYSCALL(unlink)
 315:	b8 12 00 00 00       	mov    $0x12,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <fstat>:
SYSCALL(fstat)
 31d:	b8 08 00 00 00       	mov    $0x8,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <link>:
SYSCALL(link)
 325:	b8 13 00 00 00       	mov    $0x13,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <mkdir>:
SYSCALL(mkdir)
 32d:	b8 14 00 00 00       	mov    $0x14,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <chdir>:
SYSCALL(chdir)
 335:	b8 09 00 00 00       	mov    $0x9,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <dup>:
SYSCALL(dup)
 33d:	b8 0a 00 00 00       	mov    $0xa,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <getpid>:
SYSCALL(getpid)
 345:	b8 0b 00 00 00       	mov    $0xb,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <sbrk>:
SYSCALL(sbrk)
 34d:	b8 0c 00 00 00       	mov    $0xc,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <sleep>:
SYSCALL(sleep)
 355:	b8 0d 00 00 00       	mov    $0xd,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <uptime>:
SYSCALL(uptime)
 35d:	b8 0e 00 00 00       	mov    $0xe,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <halt>:
SYSCALL(halt)
 365:	b8 16 00 00 00       	mov    $0x16,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <cps>:
/* ____My changes____ */
SYSCALL(cps)
 36d:	b8 17 00 00 00       	mov    $0x17,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <getppid>:
SYSCALL(getppid)
 375:	b8 18 00 00 00       	mov    $0x18,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <getsz>:
SYSCALL(getsz)
 37d:	b8 19 00 00 00       	mov    $0x19,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <chpr>:
SYSCALL(chpr)
 385:	b8 1a 00 00 00       	mov    $0x1a,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <getcount>:
SYSCALL(getcount)
 38d:	b8 1b 00 00 00       	mov    $0x1b,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <time>:
SYSCALL(time)
 395:	b8 1c 00 00 00       	mov    $0x1c,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <utctime>:
SYSCALL(utctime)
 39d:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <dup2>:
SYSCALL(dup2)
 3a5:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3ad:	55                   	push   %ebp
 3ae:	89 e5                	mov    %esp,%ebp
 3b0:	83 ec 1c             	sub    $0x1c,%esp
 3b3:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 3b6:	6a 01                	push   $0x1
 3b8:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3bb:	52                   	push   %edx
 3bc:	50                   	push   %eax
 3bd:	e8 23 ff ff ff       	call   2e5 <write>
}
 3c2:	83 c4 10             	add    $0x10,%esp
 3c5:	c9                   	leave  
 3c6:	c3                   	ret    

000003c7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c7:	55                   	push   %ebp
 3c8:	89 e5                	mov    %esp,%ebp
 3ca:	57                   	push   %edi
 3cb:	56                   	push   %esi
 3cc:	53                   	push   %ebx
 3cd:	83 ec 2c             	sub    $0x2c,%esp
 3d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 3d3:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3d9:	0f 95 c2             	setne  %dl
 3dc:	89 f0                	mov    %esi,%eax
 3de:	c1 e8 1f             	shr    $0x1f,%eax
 3e1:	84 c2                	test   %al,%dl
 3e3:	74 42                	je     427 <printint+0x60>
    neg = 1;
    x = -xx;
 3e5:	f7 de                	neg    %esi
    neg = 1;
 3e7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3f3:	89 f0                	mov    %esi,%eax
 3f5:	ba 00 00 00 00       	mov    $0x0,%edx
 3fa:	f7 f1                	div    %ecx
 3fc:	89 df                	mov    %ebx,%edi
 3fe:	83 c3 01             	add    $0x1,%ebx
 401:	0f b6 92 18 07 00 00 	movzbl 0x718(%edx),%edx
 408:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 40c:	89 f2                	mov    %esi,%edx
 40e:	89 c6                	mov    %eax,%esi
 410:	39 d1                	cmp    %edx,%ecx
 412:	76 df                	jbe    3f3 <printint+0x2c>
  if(neg)
 414:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 418:	74 2f                	je     449 <printint+0x82>
    buf[i++] = '-';
 41a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 41f:	8d 5f 02             	lea    0x2(%edi),%ebx
 422:	8b 75 d0             	mov    -0x30(%ebp),%esi
 425:	eb 15                	jmp    43c <printint+0x75>
  neg = 0;
 427:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 42e:	eb be                	jmp    3ee <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 430:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 435:	89 f0                	mov    %esi,%eax
 437:	e8 71 ff ff ff       	call   3ad <putc>
  while(--i >= 0)
 43c:	83 eb 01             	sub    $0x1,%ebx
 43f:	79 ef                	jns    430 <printint+0x69>
}
 441:	83 c4 2c             	add    $0x2c,%esp
 444:	5b                   	pop    %ebx
 445:	5e                   	pop    %esi
 446:	5f                   	pop    %edi
 447:	5d                   	pop    %ebp
 448:	c3                   	ret    
 449:	8b 75 d0             	mov    -0x30(%ebp),%esi
 44c:	eb ee                	jmp    43c <printint+0x75>

0000044e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 44e:	f3 0f 1e fb          	endbr32 
 452:	55                   	push   %ebp
 453:	89 e5                	mov    %esp,%ebp
 455:	57                   	push   %edi
 456:	56                   	push   %esi
 457:	53                   	push   %ebx
 458:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 45b:	8d 45 10             	lea    0x10(%ebp),%eax
 45e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 461:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 466:	bb 00 00 00 00       	mov    $0x0,%ebx
 46b:	eb 14                	jmp    481 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 46d:	89 fa                	mov    %edi,%edx
 46f:	8b 45 08             	mov    0x8(%ebp),%eax
 472:	e8 36 ff ff ff       	call   3ad <putc>
 477:	eb 05                	jmp    47e <printf+0x30>
      }
    } else if(state == '%'){
 479:	83 fe 25             	cmp    $0x25,%esi
 47c:	74 25                	je     4a3 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 47e:	83 c3 01             	add    $0x1,%ebx
 481:	8b 45 0c             	mov    0xc(%ebp),%eax
 484:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 488:	84 c0                	test   %al,%al
 48a:	0f 84 23 01 00 00    	je     5b3 <printf+0x165>
    c = fmt[i] & 0xff;
 490:	0f be f8             	movsbl %al,%edi
 493:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 496:	85 f6                	test   %esi,%esi
 498:	75 df                	jne    479 <printf+0x2b>
      if(c == '%'){
 49a:	83 f8 25             	cmp    $0x25,%eax
 49d:	75 ce                	jne    46d <printf+0x1f>
        state = '%';
 49f:	89 c6                	mov    %eax,%esi
 4a1:	eb db                	jmp    47e <printf+0x30>
      if(c == 'd'){
 4a3:	83 f8 64             	cmp    $0x64,%eax
 4a6:	74 49                	je     4f1 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4a8:	83 f8 78             	cmp    $0x78,%eax
 4ab:	0f 94 c1             	sete   %cl
 4ae:	83 f8 70             	cmp    $0x70,%eax
 4b1:	0f 94 c2             	sete   %dl
 4b4:	08 d1                	or     %dl,%cl
 4b6:	75 63                	jne    51b <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4b8:	83 f8 73             	cmp    $0x73,%eax
 4bb:	0f 84 84 00 00 00    	je     545 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4c1:	83 f8 63             	cmp    $0x63,%eax
 4c4:	0f 84 b7 00 00 00    	je     581 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4ca:	83 f8 25             	cmp    $0x25,%eax
 4cd:	0f 84 cc 00 00 00    	je     59f <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4d3:	ba 25 00 00 00       	mov    $0x25,%edx
 4d8:	8b 45 08             	mov    0x8(%ebp),%eax
 4db:	e8 cd fe ff ff       	call   3ad <putc>
        putc(fd, c);
 4e0:	89 fa                	mov    %edi,%edx
 4e2:	8b 45 08             	mov    0x8(%ebp),%eax
 4e5:	e8 c3 fe ff ff       	call   3ad <putc>
      }
      state = 0;
 4ea:	be 00 00 00 00       	mov    $0x0,%esi
 4ef:	eb 8d                	jmp    47e <printf+0x30>
        printint(fd, *ap, 10, 1);
 4f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4f4:	8b 17                	mov    (%edi),%edx
 4f6:	83 ec 0c             	sub    $0xc,%esp
 4f9:	6a 01                	push   $0x1
 4fb:	b9 0a 00 00 00       	mov    $0xa,%ecx
 500:	8b 45 08             	mov    0x8(%ebp),%eax
 503:	e8 bf fe ff ff       	call   3c7 <printint>
        ap++;
 508:	83 c7 04             	add    $0x4,%edi
 50b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 50e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 511:	be 00 00 00 00       	mov    $0x0,%esi
 516:	e9 63 ff ff ff       	jmp    47e <printf+0x30>
        printint(fd, *ap, 16, 0);
 51b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 51e:	8b 17                	mov    (%edi),%edx
 520:	83 ec 0c             	sub    $0xc,%esp
 523:	6a 00                	push   $0x0
 525:	b9 10 00 00 00       	mov    $0x10,%ecx
 52a:	8b 45 08             	mov    0x8(%ebp),%eax
 52d:	e8 95 fe ff ff       	call   3c7 <printint>
        ap++;
 532:	83 c7 04             	add    $0x4,%edi
 535:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 538:	83 c4 10             	add    $0x10,%esp
      state = 0;
 53b:	be 00 00 00 00       	mov    $0x0,%esi
 540:	e9 39 ff ff ff       	jmp    47e <printf+0x30>
        s = (char*)*ap;
 545:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 548:	8b 30                	mov    (%eax),%esi
        ap++;
 54a:	83 c0 04             	add    $0x4,%eax
 54d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 550:	85 f6                	test   %esi,%esi
 552:	75 28                	jne    57c <printf+0x12e>
          s = "(null)";
 554:	be 10 07 00 00       	mov    $0x710,%esi
 559:	8b 7d 08             	mov    0x8(%ebp),%edi
 55c:	eb 0d                	jmp    56b <printf+0x11d>
          putc(fd, *s);
 55e:	0f be d2             	movsbl %dl,%edx
 561:	89 f8                	mov    %edi,%eax
 563:	e8 45 fe ff ff       	call   3ad <putc>
          s++;
 568:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 56b:	0f b6 16             	movzbl (%esi),%edx
 56e:	84 d2                	test   %dl,%dl
 570:	75 ec                	jne    55e <printf+0x110>
      state = 0;
 572:	be 00 00 00 00       	mov    $0x0,%esi
 577:	e9 02 ff ff ff       	jmp    47e <printf+0x30>
 57c:	8b 7d 08             	mov    0x8(%ebp),%edi
 57f:	eb ea                	jmp    56b <printf+0x11d>
        putc(fd, *ap);
 581:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 584:	0f be 17             	movsbl (%edi),%edx
 587:	8b 45 08             	mov    0x8(%ebp),%eax
 58a:	e8 1e fe ff ff       	call   3ad <putc>
        ap++;
 58f:	83 c7 04             	add    $0x4,%edi
 592:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 595:	be 00 00 00 00       	mov    $0x0,%esi
 59a:	e9 df fe ff ff       	jmp    47e <printf+0x30>
        putc(fd, c);
 59f:	89 fa                	mov    %edi,%edx
 5a1:	8b 45 08             	mov    0x8(%ebp),%eax
 5a4:	e8 04 fe ff ff       	call   3ad <putc>
      state = 0;
 5a9:	be 00 00 00 00       	mov    $0x0,%esi
 5ae:	e9 cb fe ff ff       	jmp    47e <printf+0x30>
    }
  }
}
 5b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5b6:	5b                   	pop    %ebx
 5b7:	5e                   	pop    %esi
 5b8:	5f                   	pop    %edi
 5b9:	5d                   	pop    %ebp
 5ba:	c3                   	ret    

000005bb <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5bb:	f3 0f 1e fb          	endbr32 
 5bf:	55                   	push   %ebp
 5c0:	89 e5                	mov    %esp,%ebp
 5c2:	57                   	push   %edi
 5c3:	56                   	push   %esi
 5c4:	53                   	push   %ebx
 5c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5c8:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5cb:	a1 14 0a 00 00       	mov    0xa14,%eax
 5d0:	eb 02                	jmp    5d4 <free+0x19>
 5d2:	89 d0                	mov    %edx,%eax
 5d4:	39 c8                	cmp    %ecx,%eax
 5d6:	73 04                	jae    5dc <free+0x21>
 5d8:	39 08                	cmp    %ecx,(%eax)
 5da:	77 12                	ja     5ee <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5dc:	8b 10                	mov    (%eax),%edx
 5de:	39 c2                	cmp    %eax,%edx
 5e0:	77 f0                	ja     5d2 <free+0x17>
 5e2:	39 c8                	cmp    %ecx,%eax
 5e4:	72 08                	jb     5ee <free+0x33>
 5e6:	39 ca                	cmp    %ecx,%edx
 5e8:	77 04                	ja     5ee <free+0x33>
 5ea:	89 d0                	mov    %edx,%eax
 5ec:	eb e6                	jmp    5d4 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5ee:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5f1:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5f4:	8b 10                	mov    (%eax),%edx
 5f6:	39 d7                	cmp    %edx,%edi
 5f8:	74 19                	je     613 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5fa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5fd:	8b 50 04             	mov    0x4(%eax),%edx
 600:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 603:	39 ce                	cmp    %ecx,%esi
 605:	74 1b                	je     622 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 607:	89 08                	mov    %ecx,(%eax)
  freep = p;
 609:	a3 14 0a 00 00       	mov    %eax,0xa14
}
 60e:	5b                   	pop    %ebx
 60f:	5e                   	pop    %esi
 610:	5f                   	pop    %edi
 611:	5d                   	pop    %ebp
 612:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 613:	03 72 04             	add    0x4(%edx),%esi
 616:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 619:	8b 10                	mov    (%eax),%edx
 61b:	8b 12                	mov    (%edx),%edx
 61d:	89 53 f8             	mov    %edx,-0x8(%ebx)
 620:	eb db                	jmp    5fd <free+0x42>
    p->s.size += bp->s.size;
 622:	03 53 fc             	add    -0x4(%ebx),%edx
 625:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 628:	8b 53 f8             	mov    -0x8(%ebx),%edx
 62b:	89 10                	mov    %edx,(%eax)
 62d:	eb da                	jmp    609 <free+0x4e>

0000062f <morecore>:

static Header*
morecore(uint nu)
{
 62f:	55                   	push   %ebp
 630:	89 e5                	mov    %esp,%ebp
 632:	53                   	push   %ebx
 633:	83 ec 04             	sub    $0x4,%esp
 636:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 638:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 63d:	77 05                	ja     644 <morecore+0x15>
    nu = 4096;
 63f:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 644:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 64b:	83 ec 0c             	sub    $0xc,%esp
 64e:	50                   	push   %eax
 64f:	e8 f9 fc ff ff       	call   34d <sbrk>
  if(p == (char*)-1)
 654:	83 c4 10             	add    $0x10,%esp
 657:	83 f8 ff             	cmp    $0xffffffff,%eax
 65a:	74 1c                	je     678 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 65c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 65f:	83 c0 08             	add    $0x8,%eax
 662:	83 ec 0c             	sub    $0xc,%esp
 665:	50                   	push   %eax
 666:	e8 50 ff ff ff       	call   5bb <free>
  return freep;
 66b:	a1 14 0a 00 00       	mov    0xa14,%eax
 670:	83 c4 10             	add    $0x10,%esp
}
 673:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 676:	c9                   	leave  
 677:	c3                   	ret    
    return 0;
 678:	b8 00 00 00 00       	mov    $0x0,%eax
 67d:	eb f4                	jmp    673 <morecore+0x44>

0000067f <malloc>:

void*
malloc(uint nbytes)
{
 67f:	f3 0f 1e fb          	endbr32 
 683:	55                   	push   %ebp
 684:	89 e5                	mov    %esp,%ebp
 686:	53                   	push   %ebx
 687:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 68a:	8b 45 08             	mov    0x8(%ebp),%eax
 68d:	8d 58 07             	lea    0x7(%eax),%ebx
 690:	c1 eb 03             	shr    $0x3,%ebx
 693:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 696:	8b 0d 14 0a 00 00    	mov    0xa14,%ecx
 69c:	85 c9                	test   %ecx,%ecx
 69e:	74 04                	je     6a4 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6a0:	8b 01                	mov    (%ecx),%eax
 6a2:	eb 4b                	jmp    6ef <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 6a4:	c7 05 14 0a 00 00 18 	movl   $0xa18,0xa14
 6ab:	0a 00 00 
 6ae:	c7 05 18 0a 00 00 18 	movl   $0xa18,0xa18
 6b5:	0a 00 00 
    base.s.size = 0;
 6b8:	c7 05 1c 0a 00 00 00 	movl   $0x0,0xa1c
 6bf:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6c2:	b9 18 0a 00 00       	mov    $0xa18,%ecx
 6c7:	eb d7                	jmp    6a0 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 6c9:	74 1a                	je     6e5 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6cb:	29 da                	sub    %ebx,%edx
 6cd:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 6d0:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 6d3:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6d6:	89 0d 14 0a 00 00    	mov    %ecx,0xa14
      return (void*)(p + 1);
 6dc:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6df:	83 c4 04             	add    $0x4,%esp
 6e2:	5b                   	pop    %ebx
 6e3:	5d                   	pop    %ebp
 6e4:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6e5:	8b 10                	mov    (%eax),%edx
 6e7:	89 11                	mov    %edx,(%ecx)
 6e9:	eb eb                	jmp    6d6 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6eb:	89 c1                	mov    %eax,%ecx
 6ed:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 6ef:	8b 50 04             	mov    0x4(%eax),%edx
 6f2:	39 da                	cmp    %ebx,%edx
 6f4:	73 d3                	jae    6c9 <malloc+0x4a>
    if(p == freep)
 6f6:	39 05 14 0a 00 00    	cmp    %eax,0xa14
 6fc:	75 ed                	jne    6eb <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 6fe:	89 d8                	mov    %ebx,%eax
 700:	e8 2a ff ff ff       	call   62f <morecore>
 705:	85 c0                	test   %eax,%eax
 707:	75 e2                	jne    6eb <malloc+0x6c>
 709:	eb d4                	jmp    6df <malloc+0x60>
