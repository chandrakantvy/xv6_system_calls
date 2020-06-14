
_test_dup2:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	56                   	push   %esi
  12:	53                   	push   %ebx
  13:	51                   	push   %ecx
  14:	83 ec 24             	sub    $0x24,%esp
  char *grep_args[] = {"grep", "xv6", (void*)0};
  17:	c7 45 dc 6c 07 00 00 	movl   $0x76c,-0x24(%ebp)
  1e:	c7 45 e0 71 07 00 00 	movl   $0x771,-0x20(%ebp)
  25:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  int in, out;
  in = open ("README", O_RDONLY);
  2c:	6a 00                	push   $0x0
  2e:	68 75 07 00 00       	push   $0x775
  33:	e8 2e 03 00 00       	call   366 <open>
  38:	89 c6                	mov    %eax,%esi
  out = open ("out", O_WRONLY);
  3a:	83 c4 08             	add    $0x8,%esp
  3d:	6a 01                	push   $0x1
  3f:	68 7c 07 00 00       	push   $0x77c
  44:	e8 1d 03 00 00       	call   366 <open>
  49:	89 c3                	mov    %eax,%ebx

  // duplicate the file descriptor
  dup2(in, 0);
  4b:	83 c4 08             	add    $0x8,%esp
  4e:	6a 00                	push   $0x0
  50:	56                   	push   %esi
  51:	e8 b0 03 00 00       	call   406 <dup2>
  dup2(out, 0);
  56:	83 c4 08             	add    $0x8,%esp
  59:	6a 00                	push   $0x0
  5b:	53                   	push   %ebx
  5c:	e8 a5 03 00 00       	call   406 <dup2>

  close(in);
  61:	89 34 24             	mov    %esi,(%esp)
  64:	e8 e5 02 00 00       	call   34e <close>
  close(out);
  69:	89 1c 24             	mov    %ebx,(%esp)
  6c:	e8 dd 02 00 00       	call   34e <close>
  exec(grep_args[0], grep_args);
  71:	83 c4 08             	add    $0x8,%esp
  74:	8d 45 dc             	lea    -0x24(%ebp),%eax
  77:	50                   	push   %eax
  78:	ff 75 dc             	pushl  -0x24(%ebp)
  7b:	e8 de 02 00 00       	call   35e <exec>
  return 0;
  80:	b8 00 00 00 00       	mov    $0x0,%eax
  85:	8d 65 f4             	lea    -0xc(%ebp),%esp
  88:	59                   	pop    %ecx
  89:	5b                   	pop    %ebx
  8a:	5e                   	pop    %esi
  8b:	5d                   	pop    %ebp
  8c:	8d 61 fc             	lea    -0x4(%ecx),%esp
  8f:	c3                   	ret    

00000090 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  90:	f3 0f 1e fb          	endbr32 
  94:	55                   	push   %ebp
  95:	89 e5                	mov    %esp,%ebp
  97:	56                   	push   %esi
  98:	53                   	push   %ebx
  99:	8b 75 08             	mov    0x8(%ebp),%esi
  9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  9f:	89 f0                	mov    %esi,%eax
  a1:	89 d1                	mov    %edx,%ecx
  a3:	83 c2 01             	add    $0x1,%edx
  a6:	89 c3                	mov    %eax,%ebx
  a8:	83 c0 01             	add    $0x1,%eax
  ab:	0f b6 09             	movzbl (%ecx),%ecx
  ae:	88 0b                	mov    %cl,(%ebx)
  b0:	84 c9                	test   %cl,%cl
  b2:	75 ed                	jne    a1 <strcpy+0x11>
    ;
  return os;
}
  b4:	89 f0                	mov    %esi,%eax
  b6:	5b                   	pop    %ebx
  b7:	5e                   	pop    %esi
  b8:	5d                   	pop    %ebp
  b9:	c3                   	ret    

000000ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ba:	f3 0f 1e fb          	endbr32 
  be:	55                   	push   %ebp
  bf:	89 e5                	mov    %esp,%ebp
  c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  c7:	0f b6 01             	movzbl (%ecx),%eax
  ca:	84 c0                	test   %al,%al
  cc:	74 0c                	je     da <strcmp+0x20>
  ce:	3a 02                	cmp    (%edx),%al
  d0:	75 08                	jne    da <strcmp+0x20>
    p++, q++;
  d2:	83 c1 01             	add    $0x1,%ecx
  d5:	83 c2 01             	add    $0x1,%edx
  d8:	eb ed                	jmp    c7 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  da:	0f b6 c0             	movzbl %al,%eax
  dd:	0f b6 12             	movzbl (%edx),%edx
  e0:	29 d0                	sub    %edx,%eax
}
  e2:	5d                   	pop    %ebp
  e3:	c3                   	ret    

000000e4 <strlen>:

uint
strlen(char *s)
{
  e4:	f3 0f 1e fb          	endbr32 
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  ee:	b8 00 00 00 00       	mov    $0x0,%eax
  f3:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  f7:	74 05                	je     fe <strlen+0x1a>
  f9:	83 c0 01             	add    $0x1,%eax
  fc:	eb f5                	jmp    f3 <strlen+0xf>
    ;
  return n;
}
  fe:	5d                   	pop    %ebp
  ff:	c3                   	ret    

00000100 <memset>:

void*
memset(void *dst, int c, uint n)
{
 100:	f3 0f 1e fb          	endbr32 
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	57                   	push   %edi
 108:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 10b:	89 d7                	mov    %edx,%edi
 10d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 110:	8b 45 0c             	mov    0xc(%ebp),%eax
 113:	fc                   	cld    
 114:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 116:	89 d0                	mov    %edx,%eax
 118:	5f                   	pop    %edi
 119:	5d                   	pop    %ebp
 11a:	c3                   	ret    

0000011b <strchr>:

char*
strchr(const char *s, char c)
{
 11b:	f3 0f 1e fb          	endbr32 
 11f:	55                   	push   %ebp
 120:	89 e5                	mov    %esp,%ebp
 122:	8b 45 08             	mov    0x8(%ebp),%eax
 125:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 129:	0f b6 10             	movzbl (%eax),%edx
 12c:	84 d2                	test   %dl,%dl
 12e:	74 09                	je     139 <strchr+0x1e>
    if(*s == c)
 130:	38 ca                	cmp    %cl,%dl
 132:	74 0a                	je     13e <strchr+0x23>
  for(; *s; s++)
 134:	83 c0 01             	add    $0x1,%eax
 137:	eb f0                	jmp    129 <strchr+0xe>
      return (char*)s;
  return 0;
 139:	b8 00 00 00 00       	mov    $0x0,%eax
}
 13e:	5d                   	pop    %ebp
 13f:	c3                   	ret    

00000140 <gets>:

char*
gets(char *buf, int max)
{
 140:	f3 0f 1e fb          	endbr32 
 144:	55                   	push   %ebp
 145:	89 e5                	mov    %esp,%ebp
 147:	57                   	push   %edi
 148:	56                   	push   %esi
 149:	53                   	push   %ebx
 14a:	83 ec 1c             	sub    $0x1c,%esp
 14d:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 150:	bb 00 00 00 00       	mov    $0x0,%ebx
 155:	89 de                	mov    %ebx,%esi
 157:	83 c3 01             	add    $0x1,%ebx
 15a:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 15d:	7d 2e                	jge    18d <gets+0x4d>
    cc = read(0, &c, 1);
 15f:	83 ec 04             	sub    $0x4,%esp
 162:	6a 01                	push   $0x1
 164:	8d 45 e7             	lea    -0x19(%ebp),%eax
 167:	50                   	push   %eax
 168:	6a 00                	push   $0x0
 16a:	e8 cf 01 00 00       	call   33e <read>
    if(cc < 1)
 16f:	83 c4 10             	add    $0x10,%esp
 172:	85 c0                	test   %eax,%eax
 174:	7e 17                	jle    18d <gets+0x4d>
      break;
    buf[i++] = c;
 176:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 17a:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 17d:	3c 0a                	cmp    $0xa,%al
 17f:	0f 94 c2             	sete   %dl
 182:	3c 0d                	cmp    $0xd,%al
 184:	0f 94 c0             	sete   %al
 187:	08 c2                	or     %al,%dl
 189:	74 ca                	je     155 <gets+0x15>
    buf[i++] = c;
 18b:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 18d:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 191:	89 f8                	mov    %edi,%eax
 193:	8d 65 f4             	lea    -0xc(%ebp),%esp
 196:	5b                   	pop    %ebx
 197:	5e                   	pop    %esi
 198:	5f                   	pop    %edi
 199:	5d                   	pop    %ebp
 19a:	c3                   	ret    

0000019b <stat>:

int
stat(char *n, struct stat *st)
{
 19b:	f3 0f 1e fb          	endbr32 
 19f:	55                   	push   %ebp
 1a0:	89 e5                	mov    %esp,%ebp
 1a2:	56                   	push   %esi
 1a3:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a4:	83 ec 08             	sub    $0x8,%esp
 1a7:	6a 00                	push   $0x0
 1a9:	ff 75 08             	pushl  0x8(%ebp)
 1ac:	e8 b5 01 00 00       	call   366 <open>
  if(fd < 0)
 1b1:	83 c4 10             	add    $0x10,%esp
 1b4:	85 c0                	test   %eax,%eax
 1b6:	78 24                	js     1dc <stat+0x41>
 1b8:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1ba:	83 ec 08             	sub    $0x8,%esp
 1bd:	ff 75 0c             	pushl  0xc(%ebp)
 1c0:	50                   	push   %eax
 1c1:	e8 b8 01 00 00       	call   37e <fstat>
 1c6:	89 c6                	mov    %eax,%esi
  close(fd);
 1c8:	89 1c 24             	mov    %ebx,(%esp)
 1cb:	e8 7e 01 00 00       	call   34e <close>
  return r;
 1d0:	83 c4 10             	add    $0x10,%esp
}
 1d3:	89 f0                	mov    %esi,%eax
 1d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1d8:	5b                   	pop    %ebx
 1d9:	5e                   	pop    %esi
 1da:	5d                   	pop    %ebp
 1db:	c3                   	ret    
    return -1;
 1dc:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1e1:	eb f0                	jmp    1d3 <stat+0x38>

000001e3 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 1e3:	f3 0f 1e fb          	endbr32 
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
 1ea:	57                   	push   %edi
 1eb:	56                   	push   %esi
 1ec:	53                   	push   %ebx
 1ed:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1f0:	0f b6 02             	movzbl (%edx),%eax
 1f3:	3c 20                	cmp    $0x20,%al
 1f5:	75 05                	jne    1fc <atoi+0x19>
 1f7:	83 c2 01             	add    $0x1,%edx
 1fa:	eb f4                	jmp    1f0 <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 1fc:	3c 2d                	cmp    $0x2d,%al
 1fe:	74 1d                	je     21d <atoi+0x3a>
 200:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 205:	3c 2b                	cmp    $0x2b,%al
 207:	0f 94 c1             	sete   %cl
 20a:	3c 2d                	cmp    $0x2d,%al
 20c:	0f 94 c0             	sete   %al
 20f:	08 c1                	or     %al,%cl
 211:	74 03                	je     216 <atoi+0x33>
    s++;
 213:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 216:	b8 00 00 00 00       	mov    $0x0,%eax
 21b:	eb 17                	jmp    234 <atoi+0x51>
 21d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 222:	eb e1                	jmp    205 <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 224:	8d 34 80             	lea    (%eax,%eax,4),%esi
 227:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 22a:	83 c2 01             	add    $0x1,%edx
 22d:	0f be c9             	movsbl %cl,%ecx
 230:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 234:	0f b6 0a             	movzbl (%edx),%ecx
 237:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 23a:	80 fb 09             	cmp    $0x9,%bl
 23d:	76 e5                	jbe    224 <atoi+0x41>
  return sign*n;
 23f:	0f af c7             	imul   %edi,%eax
}
 242:	5b                   	pop    %ebx
 243:	5e                   	pop    %esi
 244:	5f                   	pop    %edi
 245:	5d                   	pop    %ebp
 246:	c3                   	ret    

00000247 <atoo>:

int
atoo(const char *s)
{
 247:	f3 0f 1e fb          	endbr32 
 24b:	55                   	push   %ebp
 24c:	89 e5                	mov    %esp,%ebp
 24e:	57                   	push   %edi
 24f:	56                   	push   %esi
 250:	53                   	push   %ebx
 251:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 254:	0f b6 0a             	movzbl (%edx),%ecx
 257:	80 f9 20             	cmp    $0x20,%cl
 25a:	75 05                	jne    261 <atoo+0x1a>
 25c:	83 c2 01             	add    $0x1,%edx
 25f:	eb f3                	jmp    254 <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 261:	80 f9 2d             	cmp    $0x2d,%cl
 264:	74 23                	je     289 <atoo+0x42>
 266:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 26b:	80 f9 2b             	cmp    $0x2b,%cl
 26e:	0f 94 c0             	sete   %al
 271:	89 c6                	mov    %eax,%esi
 273:	80 f9 2d             	cmp    $0x2d,%cl
 276:	0f 94 c0             	sete   %al
 279:	89 f3                	mov    %esi,%ebx
 27b:	08 c3                	or     %al,%bl
 27d:	74 03                	je     282 <atoo+0x3b>
    s++;
 27f:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 282:	b8 00 00 00 00       	mov    $0x0,%eax
 287:	eb 11                	jmp    29a <atoo+0x53>
 289:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 28e:	eb db                	jmp    26b <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 290:	83 c2 01             	add    $0x1,%edx
 293:	0f be c9             	movsbl %cl,%ecx
 296:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 29a:	0f b6 0a             	movzbl (%edx),%ecx
 29d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 2a0:	80 fb 07             	cmp    $0x7,%bl
 2a3:	76 eb                	jbe    290 <atoo+0x49>
  return sign*n;
 2a5:	0f af c7             	imul   %edi,%eax
}
 2a8:	5b                   	pop    %ebx
 2a9:	5e                   	pop    %esi
 2aa:	5f                   	pop    %edi
 2ab:	5d                   	pop    %ebp
 2ac:	c3                   	ret    

000002ad <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 2ad:	f3 0f 1e fb          	endbr32 
 2b1:	55                   	push   %ebp
 2b2:	89 e5                	mov    %esp,%ebp
 2b4:	53                   	push   %ebx
 2b5:	8b 55 08             	mov    0x8(%ebp),%edx
 2b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2bb:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 2be:	eb 09                	jmp    2c9 <strncmp+0x1c>
      n--, p++, q++;
 2c0:	83 e8 01             	sub    $0x1,%eax
 2c3:	83 c2 01             	add    $0x1,%edx
 2c6:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 2c9:	85 c0                	test   %eax,%eax
 2cb:	74 0b                	je     2d8 <strncmp+0x2b>
 2cd:	0f b6 1a             	movzbl (%edx),%ebx
 2d0:	84 db                	test   %bl,%bl
 2d2:	74 04                	je     2d8 <strncmp+0x2b>
 2d4:	3a 19                	cmp    (%ecx),%bl
 2d6:	74 e8                	je     2c0 <strncmp+0x13>
    if(n == 0)
 2d8:	85 c0                	test   %eax,%eax
 2da:	74 0b                	je     2e7 <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 2dc:	0f b6 02             	movzbl (%edx),%eax
 2df:	0f b6 11             	movzbl (%ecx),%edx
 2e2:	29 d0                	sub    %edx,%eax
}
 2e4:	5b                   	pop    %ebx
 2e5:	5d                   	pop    %ebp
 2e6:	c3                   	ret    
      return 0;
 2e7:	b8 00 00 00 00       	mov    $0x0,%eax
 2ec:	eb f6                	jmp    2e4 <strncmp+0x37>

000002ee <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 2ee:	f3 0f 1e fb          	endbr32 
 2f2:	55                   	push   %ebp
 2f3:	89 e5                	mov    %esp,%ebp
 2f5:	56                   	push   %esi
 2f6:	53                   	push   %ebx
 2f7:	8b 75 08             	mov    0x8(%ebp),%esi
 2fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2fd:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 300:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 302:	8d 58 ff             	lea    -0x1(%eax),%ebx
 305:	85 c0                	test   %eax,%eax
 307:	7e 0f                	jle    318 <memmove+0x2a>
    *dst++ = *src++;
 309:	0f b6 01             	movzbl (%ecx),%eax
 30c:	88 02                	mov    %al,(%edx)
 30e:	8d 49 01             	lea    0x1(%ecx),%ecx
 311:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 314:	89 d8                	mov    %ebx,%eax
 316:	eb ea                	jmp    302 <memmove+0x14>
  return vdst;
}
 318:	89 f0                	mov    %esi,%eax
 31a:	5b                   	pop    %ebx
 31b:	5e                   	pop    %esi
 31c:	5d                   	pop    %ebp
 31d:	c3                   	ret    

0000031e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 31e:	b8 01 00 00 00       	mov    $0x1,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <exit>:
SYSCALL(exit)
 326:	b8 02 00 00 00       	mov    $0x2,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <wait>:
SYSCALL(wait)
 32e:	b8 03 00 00 00       	mov    $0x3,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <pipe>:
SYSCALL(pipe)
 336:	b8 04 00 00 00       	mov    $0x4,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <read>:
SYSCALL(read)
 33e:	b8 05 00 00 00       	mov    $0x5,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <write>:
SYSCALL(write)
 346:	b8 10 00 00 00       	mov    $0x10,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <close>:
SYSCALL(close)
 34e:	b8 15 00 00 00       	mov    $0x15,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <kill>:
SYSCALL(kill)
 356:	b8 06 00 00 00       	mov    $0x6,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <exec>:
SYSCALL(exec)
 35e:	b8 07 00 00 00       	mov    $0x7,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <open>:
SYSCALL(open)
 366:	b8 0f 00 00 00       	mov    $0xf,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <mknod>:
SYSCALL(mknod)
 36e:	b8 11 00 00 00       	mov    $0x11,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <unlink>:
SYSCALL(unlink)
 376:	b8 12 00 00 00       	mov    $0x12,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <fstat>:
SYSCALL(fstat)
 37e:	b8 08 00 00 00       	mov    $0x8,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <link>:
SYSCALL(link)
 386:	b8 13 00 00 00       	mov    $0x13,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <mkdir>:
SYSCALL(mkdir)
 38e:	b8 14 00 00 00       	mov    $0x14,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <chdir>:
SYSCALL(chdir)
 396:	b8 09 00 00 00       	mov    $0x9,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <dup>:
SYSCALL(dup)
 39e:	b8 0a 00 00 00       	mov    $0xa,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <getpid>:
SYSCALL(getpid)
 3a6:	b8 0b 00 00 00       	mov    $0xb,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <sbrk>:
SYSCALL(sbrk)
 3ae:	b8 0c 00 00 00       	mov    $0xc,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <sleep>:
SYSCALL(sleep)
 3b6:	b8 0d 00 00 00       	mov    $0xd,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <uptime>:
SYSCALL(uptime)
 3be:	b8 0e 00 00 00       	mov    $0xe,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <halt>:
SYSCALL(halt)
 3c6:	b8 16 00 00 00       	mov    $0x16,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <cps>:
/* ____My changes____ */
SYSCALL(cps)
 3ce:	b8 17 00 00 00       	mov    $0x17,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <getppid>:
SYSCALL(getppid)
 3d6:	b8 18 00 00 00       	mov    $0x18,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <getsz>:
SYSCALL(getsz)
 3de:	b8 19 00 00 00       	mov    $0x19,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <chpr>:
SYSCALL(chpr)
 3e6:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <getcount>:
SYSCALL(getcount)
 3ee:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <time>:
SYSCALL(time)
 3f6:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <utctime>:
SYSCALL(utctime)
 3fe:	b8 1d 00 00 00       	mov    $0x1d,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <dup2>:
SYSCALL(dup2)
 406:	b8 1e 00 00 00       	mov    $0x1e,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 40e:	55                   	push   %ebp
 40f:	89 e5                	mov    %esp,%ebp
 411:	83 ec 1c             	sub    $0x1c,%esp
 414:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 417:	6a 01                	push   $0x1
 419:	8d 55 f4             	lea    -0xc(%ebp),%edx
 41c:	52                   	push   %edx
 41d:	50                   	push   %eax
 41e:	e8 23 ff ff ff       	call   346 <write>
}
 423:	83 c4 10             	add    $0x10,%esp
 426:	c9                   	leave  
 427:	c3                   	ret    

00000428 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 428:	55                   	push   %ebp
 429:	89 e5                	mov    %esp,%ebp
 42b:	57                   	push   %edi
 42c:	56                   	push   %esi
 42d:	53                   	push   %ebx
 42e:	83 ec 2c             	sub    $0x2c,%esp
 431:	89 45 d0             	mov    %eax,-0x30(%ebp)
 434:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 436:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 43a:	0f 95 c2             	setne  %dl
 43d:	89 f0                	mov    %esi,%eax
 43f:	c1 e8 1f             	shr    $0x1f,%eax
 442:	84 c2                	test   %al,%dl
 444:	74 42                	je     488 <printint+0x60>
    neg = 1;
    x = -xx;
 446:	f7 de                	neg    %esi
    neg = 1;
 448:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 44f:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 454:	89 f0                	mov    %esi,%eax
 456:	ba 00 00 00 00       	mov    $0x0,%edx
 45b:	f7 f1                	div    %ecx
 45d:	89 df                	mov    %ebx,%edi
 45f:	83 c3 01             	add    $0x1,%ebx
 462:	0f b6 92 88 07 00 00 	movzbl 0x788(%edx),%edx
 469:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 46d:	89 f2                	mov    %esi,%edx
 46f:	89 c6                	mov    %eax,%esi
 471:	39 d1                	cmp    %edx,%ecx
 473:	76 df                	jbe    454 <printint+0x2c>
  if(neg)
 475:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 479:	74 2f                	je     4aa <printint+0x82>
    buf[i++] = '-';
 47b:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 480:	8d 5f 02             	lea    0x2(%edi),%ebx
 483:	8b 75 d0             	mov    -0x30(%ebp),%esi
 486:	eb 15                	jmp    49d <printint+0x75>
  neg = 0;
 488:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 48f:	eb be                	jmp    44f <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 491:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 496:	89 f0                	mov    %esi,%eax
 498:	e8 71 ff ff ff       	call   40e <putc>
  while(--i >= 0)
 49d:	83 eb 01             	sub    $0x1,%ebx
 4a0:	79 ef                	jns    491 <printint+0x69>
}
 4a2:	83 c4 2c             	add    $0x2c,%esp
 4a5:	5b                   	pop    %ebx
 4a6:	5e                   	pop    %esi
 4a7:	5f                   	pop    %edi
 4a8:	5d                   	pop    %ebp
 4a9:	c3                   	ret    
 4aa:	8b 75 d0             	mov    -0x30(%ebp),%esi
 4ad:	eb ee                	jmp    49d <printint+0x75>

000004af <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4af:	f3 0f 1e fb          	endbr32 
 4b3:	55                   	push   %ebp
 4b4:	89 e5                	mov    %esp,%ebp
 4b6:	57                   	push   %edi
 4b7:	56                   	push   %esi
 4b8:	53                   	push   %ebx
 4b9:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4bc:	8d 45 10             	lea    0x10(%ebp),%eax
 4bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 4c2:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 4c7:	bb 00 00 00 00       	mov    $0x0,%ebx
 4cc:	eb 14                	jmp    4e2 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4ce:	89 fa                	mov    %edi,%edx
 4d0:	8b 45 08             	mov    0x8(%ebp),%eax
 4d3:	e8 36 ff ff ff       	call   40e <putc>
 4d8:	eb 05                	jmp    4df <printf+0x30>
      }
    } else if(state == '%'){
 4da:	83 fe 25             	cmp    $0x25,%esi
 4dd:	74 25                	je     504 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 4df:	83 c3 01             	add    $0x1,%ebx
 4e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e5:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 4e9:	84 c0                	test   %al,%al
 4eb:	0f 84 23 01 00 00    	je     614 <printf+0x165>
    c = fmt[i] & 0xff;
 4f1:	0f be f8             	movsbl %al,%edi
 4f4:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 4f7:	85 f6                	test   %esi,%esi
 4f9:	75 df                	jne    4da <printf+0x2b>
      if(c == '%'){
 4fb:	83 f8 25             	cmp    $0x25,%eax
 4fe:	75 ce                	jne    4ce <printf+0x1f>
        state = '%';
 500:	89 c6                	mov    %eax,%esi
 502:	eb db                	jmp    4df <printf+0x30>
      if(c == 'd'){
 504:	83 f8 64             	cmp    $0x64,%eax
 507:	74 49                	je     552 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 509:	83 f8 78             	cmp    $0x78,%eax
 50c:	0f 94 c1             	sete   %cl
 50f:	83 f8 70             	cmp    $0x70,%eax
 512:	0f 94 c2             	sete   %dl
 515:	08 d1                	or     %dl,%cl
 517:	75 63                	jne    57c <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 519:	83 f8 73             	cmp    $0x73,%eax
 51c:	0f 84 84 00 00 00    	je     5a6 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 522:	83 f8 63             	cmp    $0x63,%eax
 525:	0f 84 b7 00 00 00    	je     5e2 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 52b:	83 f8 25             	cmp    $0x25,%eax
 52e:	0f 84 cc 00 00 00    	je     600 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 534:	ba 25 00 00 00       	mov    $0x25,%edx
 539:	8b 45 08             	mov    0x8(%ebp),%eax
 53c:	e8 cd fe ff ff       	call   40e <putc>
        putc(fd, c);
 541:	89 fa                	mov    %edi,%edx
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	e8 c3 fe ff ff       	call   40e <putc>
      }
      state = 0;
 54b:	be 00 00 00 00       	mov    $0x0,%esi
 550:	eb 8d                	jmp    4df <printf+0x30>
        printint(fd, *ap, 10, 1);
 552:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 555:	8b 17                	mov    (%edi),%edx
 557:	83 ec 0c             	sub    $0xc,%esp
 55a:	6a 01                	push   $0x1
 55c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 561:	8b 45 08             	mov    0x8(%ebp),%eax
 564:	e8 bf fe ff ff       	call   428 <printint>
        ap++;
 569:	83 c7 04             	add    $0x4,%edi
 56c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 56f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 572:	be 00 00 00 00       	mov    $0x0,%esi
 577:	e9 63 ff ff ff       	jmp    4df <printf+0x30>
        printint(fd, *ap, 16, 0);
 57c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 57f:	8b 17                	mov    (%edi),%edx
 581:	83 ec 0c             	sub    $0xc,%esp
 584:	6a 00                	push   $0x0
 586:	b9 10 00 00 00       	mov    $0x10,%ecx
 58b:	8b 45 08             	mov    0x8(%ebp),%eax
 58e:	e8 95 fe ff ff       	call   428 <printint>
        ap++;
 593:	83 c7 04             	add    $0x4,%edi
 596:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 599:	83 c4 10             	add    $0x10,%esp
      state = 0;
 59c:	be 00 00 00 00       	mov    $0x0,%esi
 5a1:	e9 39 ff ff ff       	jmp    4df <printf+0x30>
        s = (char*)*ap;
 5a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a9:	8b 30                	mov    (%eax),%esi
        ap++;
 5ab:	83 c0 04             	add    $0x4,%eax
 5ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 5b1:	85 f6                	test   %esi,%esi
 5b3:	75 28                	jne    5dd <printf+0x12e>
          s = "(null)";
 5b5:	be 80 07 00 00       	mov    $0x780,%esi
 5ba:	8b 7d 08             	mov    0x8(%ebp),%edi
 5bd:	eb 0d                	jmp    5cc <printf+0x11d>
          putc(fd, *s);
 5bf:	0f be d2             	movsbl %dl,%edx
 5c2:	89 f8                	mov    %edi,%eax
 5c4:	e8 45 fe ff ff       	call   40e <putc>
          s++;
 5c9:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 5cc:	0f b6 16             	movzbl (%esi),%edx
 5cf:	84 d2                	test   %dl,%dl
 5d1:	75 ec                	jne    5bf <printf+0x110>
      state = 0;
 5d3:	be 00 00 00 00       	mov    $0x0,%esi
 5d8:	e9 02 ff ff ff       	jmp    4df <printf+0x30>
 5dd:	8b 7d 08             	mov    0x8(%ebp),%edi
 5e0:	eb ea                	jmp    5cc <printf+0x11d>
        putc(fd, *ap);
 5e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5e5:	0f be 17             	movsbl (%edi),%edx
 5e8:	8b 45 08             	mov    0x8(%ebp),%eax
 5eb:	e8 1e fe ff ff       	call   40e <putc>
        ap++;
 5f0:	83 c7 04             	add    $0x4,%edi
 5f3:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 5f6:	be 00 00 00 00       	mov    $0x0,%esi
 5fb:	e9 df fe ff ff       	jmp    4df <printf+0x30>
        putc(fd, c);
 600:	89 fa                	mov    %edi,%edx
 602:	8b 45 08             	mov    0x8(%ebp),%eax
 605:	e8 04 fe ff ff       	call   40e <putc>
      state = 0;
 60a:	be 00 00 00 00       	mov    $0x0,%esi
 60f:	e9 cb fe ff ff       	jmp    4df <printf+0x30>
    }
  }
}
 614:	8d 65 f4             	lea    -0xc(%ebp),%esp
 617:	5b                   	pop    %ebx
 618:	5e                   	pop    %esi
 619:	5f                   	pop    %edi
 61a:	5d                   	pop    %ebp
 61b:	c3                   	ret    

0000061c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 61c:	f3 0f 1e fb          	endbr32 
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	57                   	push   %edi
 624:	56                   	push   %esi
 625:	53                   	push   %ebx
 626:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 629:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62c:	a1 9c 0a 00 00       	mov    0xa9c,%eax
 631:	eb 02                	jmp    635 <free+0x19>
 633:	89 d0                	mov    %edx,%eax
 635:	39 c8                	cmp    %ecx,%eax
 637:	73 04                	jae    63d <free+0x21>
 639:	39 08                	cmp    %ecx,(%eax)
 63b:	77 12                	ja     64f <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 63d:	8b 10                	mov    (%eax),%edx
 63f:	39 c2                	cmp    %eax,%edx
 641:	77 f0                	ja     633 <free+0x17>
 643:	39 c8                	cmp    %ecx,%eax
 645:	72 08                	jb     64f <free+0x33>
 647:	39 ca                	cmp    %ecx,%edx
 649:	77 04                	ja     64f <free+0x33>
 64b:	89 d0                	mov    %edx,%eax
 64d:	eb e6                	jmp    635 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 64f:	8b 73 fc             	mov    -0x4(%ebx),%esi
 652:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 655:	8b 10                	mov    (%eax),%edx
 657:	39 d7                	cmp    %edx,%edi
 659:	74 19                	je     674 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 65b:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 65e:	8b 50 04             	mov    0x4(%eax),%edx
 661:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 664:	39 ce                	cmp    %ecx,%esi
 666:	74 1b                	je     683 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 668:	89 08                	mov    %ecx,(%eax)
  freep = p;
 66a:	a3 9c 0a 00 00       	mov    %eax,0xa9c
}
 66f:	5b                   	pop    %ebx
 670:	5e                   	pop    %esi
 671:	5f                   	pop    %edi
 672:	5d                   	pop    %ebp
 673:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 674:	03 72 04             	add    0x4(%edx),%esi
 677:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 67a:	8b 10                	mov    (%eax),%edx
 67c:	8b 12                	mov    (%edx),%edx
 67e:	89 53 f8             	mov    %edx,-0x8(%ebx)
 681:	eb db                	jmp    65e <free+0x42>
    p->s.size += bp->s.size;
 683:	03 53 fc             	add    -0x4(%ebx),%edx
 686:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 689:	8b 53 f8             	mov    -0x8(%ebx),%edx
 68c:	89 10                	mov    %edx,(%eax)
 68e:	eb da                	jmp    66a <free+0x4e>

00000690 <morecore>:

static Header*
morecore(uint nu)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	53                   	push   %ebx
 694:	83 ec 04             	sub    $0x4,%esp
 697:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 699:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 69e:	77 05                	ja     6a5 <morecore+0x15>
    nu = 4096;
 6a0:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 6a5:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 6ac:	83 ec 0c             	sub    $0xc,%esp
 6af:	50                   	push   %eax
 6b0:	e8 f9 fc ff ff       	call   3ae <sbrk>
  if(p == (char*)-1)
 6b5:	83 c4 10             	add    $0x10,%esp
 6b8:	83 f8 ff             	cmp    $0xffffffff,%eax
 6bb:	74 1c                	je     6d9 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6bd:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6c0:	83 c0 08             	add    $0x8,%eax
 6c3:	83 ec 0c             	sub    $0xc,%esp
 6c6:	50                   	push   %eax
 6c7:	e8 50 ff ff ff       	call   61c <free>
  return freep;
 6cc:	a1 9c 0a 00 00       	mov    0xa9c,%eax
 6d1:	83 c4 10             	add    $0x10,%esp
}
 6d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6d7:	c9                   	leave  
 6d8:	c3                   	ret    
    return 0;
 6d9:	b8 00 00 00 00       	mov    $0x0,%eax
 6de:	eb f4                	jmp    6d4 <morecore+0x44>

000006e0 <malloc>:

void*
malloc(uint nbytes)
{
 6e0:	f3 0f 1e fb          	endbr32 
 6e4:	55                   	push   %ebp
 6e5:	89 e5                	mov    %esp,%ebp
 6e7:	53                   	push   %ebx
 6e8:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6eb:	8b 45 08             	mov    0x8(%ebp),%eax
 6ee:	8d 58 07             	lea    0x7(%eax),%ebx
 6f1:	c1 eb 03             	shr    $0x3,%ebx
 6f4:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6f7:	8b 0d 9c 0a 00 00    	mov    0xa9c,%ecx
 6fd:	85 c9                	test   %ecx,%ecx
 6ff:	74 04                	je     705 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 701:	8b 01                	mov    (%ecx),%eax
 703:	eb 4b                	jmp    750 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 705:	c7 05 9c 0a 00 00 a0 	movl   $0xaa0,0xa9c
 70c:	0a 00 00 
 70f:	c7 05 a0 0a 00 00 a0 	movl   $0xaa0,0xaa0
 716:	0a 00 00 
    base.s.size = 0;
 719:	c7 05 a4 0a 00 00 00 	movl   $0x0,0xaa4
 720:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 723:	b9 a0 0a 00 00       	mov    $0xaa0,%ecx
 728:	eb d7                	jmp    701 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 72a:	74 1a                	je     746 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 72c:	29 da                	sub    %ebx,%edx
 72e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 731:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 734:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 737:	89 0d 9c 0a 00 00    	mov    %ecx,0xa9c
      return (void*)(p + 1);
 73d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 740:	83 c4 04             	add    $0x4,%esp
 743:	5b                   	pop    %ebx
 744:	5d                   	pop    %ebp
 745:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 746:	8b 10                	mov    (%eax),%edx
 748:	89 11                	mov    %edx,(%ecx)
 74a:	eb eb                	jmp    737 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 74c:	89 c1                	mov    %eax,%ecx
 74e:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 750:	8b 50 04             	mov    0x4(%eax),%edx
 753:	39 da                	cmp    %ebx,%edx
 755:	73 d3                	jae    72a <malloc+0x4a>
    if(p == freep)
 757:	39 05 9c 0a 00 00    	cmp    %eax,0xa9c
 75d:	75 ed                	jne    74c <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 75f:	89 d8                	mov    %ebx,%eax
 761:	e8 2a ff ff ff       	call   690 <morecore>
 766:	85 c0                	test   %eax,%eax
 768:	75 e2                	jne    74c <malloc+0x6c>
 76a:	eb d4                	jmp    740 <malloc+0x60>
