
_test_getcount:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "syscall.h"

int
main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 10             	sub    $0x10,%esp
    printf(1, "initial fork count %d\n", getcount(SYS_fork));
  15:	6a 01                	push   $0x1
  17:	e8 12 04 00 00       	call   42e <getcount>
  1c:	83 c4 0c             	add    $0xc,%esp
  1f:	50                   	push   %eax
  20:	68 ac 07 00 00       	push   $0x7ac
  25:	6a 01                	push   $0x1
  27:	e8 c3 04 00 00       	call   4ef <printf>
    if (fork() == 0) {
  2c:	e8 2d 03 00 00       	call   35e <fork>
  31:	83 c4 10             	add    $0x10,%esp
  34:	85 c0                	test   %eax,%eax
  36:	75 58                	jne    90 <main+0x90>
        printf(1, "child fork count %d\n", getcount(SYS_fork));
  38:	83 ec 0c             	sub    $0xc,%esp
  3b:	6a 01                	push   $0x1
  3d:	e8 ec 03 00 00       	call   42e <getcount>
  42:	83 c4 0c             	add    $0xc,%esp
  45:	50                   	push   %eax
  46:	68 c3 07 00 00       	push   $0x7c3
  4b:	6a 01                	push   $0x1
  4d:	e8 9d 04 00 00       	call   4ef <printf>
        printf(1, "child write count %d\n", getcount(SYS_write));
  52:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
  59:	e8 d0 03 00 00       	call   42e <getcount>
  5e:	83 c4 0c             	add    $0xc,%esp
  61:	50                   	push   %eax
  62:	68 d8 07 00 00       	push   $0x7d8
  67:	6a 01                	push   $0x1
  69:	e8 81 04 00 00       	call   4ef <printf>
  6e:	83 c4 10             	add    $0x10,%esp
    } else {
        wait();
        printf(1, "parent fork count %d\n", getcount(SYS_fork));
        printf(1, "parent write count %d\n", getcount(SYS_write));
    }
    printf(1, "wait count %d\n", getcount(SYS_wait));
  71:	83 ec 0c             	sub    $0xc,%esp
  74:	6a 03                	push   $0x3
  76:	e8 b3 03 00 00       	call   42e <getcount>
  7b:	83 c4 0c             	add    $0xc,%esp
  7e:	50                   	push   %eax
  7f:	68 1b 08 00 00       	push   $0x81b
  84:	6a 01                	push   $0x1
  86:	e8 64 04 00 00       	call   4ef <printf>
    exit();
  8b:	e8 d6 02 00 00       	call   366 <exit>
        wait();
  90:	e8 d9 02 00 00       	call   36e <wait>
        printf(1, "parent fork count %d\n", getcount(SYS_fork));
  95:	83 ec 0c             	sub    $0xc,%esp
  98:	6a 01                	push   $0x1
  9a:	e8 8f 03 00 00       	call   42e <getcount>
  9f:	83 c4 0c             	add    $0xc,%esp
  a2:	50                   	push   %eax
  a3:	68 ee 07 00 00       	push   $0x7ee
  a8:	6a 01                	push   $0x1
  aa:	e8 40 04 00 00       	call   4ef <printf>
        printf(1, "parent write count %d\n", getcount(SYS_write));
  af:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
  b6:	e8 73 03 00 00       	call   42e <getcount>
  bb:	83 c4 0c             	add    $0xc,%esp
  be:	50                   	push   %eax
  bf:	68 04 08 00 00       	push   $0x804
  c4:	6a 01                	push   $0x1
  c6:	e8 24 04 00 00       	call   4ef <printf>
  cb:	83 c4 10             	add    $0x10,%esp
  ce:	eb a1                	jmp    71 <main+0x71>

000000d0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  d0:	f3 0f 1e fb          	endbr32 
  d4:	55                   	push   %ebp
  d5:	89 e5                	mov    %esp,%ebp
  d7:	56                   	push   %esi
  d8:	53                   	push   %ebx
  d9:	8b 75 08             	mov    0x8(%ebp),%esi
  dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  df:	89 f0                	mov    %esi,%eax
  e1:	89 d1                	mov    %edx,%ecx
  e3:	83 c2 01             	add    $0x1,%edx
  e6:	89 c3                	mov    %eax,%ebx
  e8:	83 c0 01             	add    $0x1,%eax
  eb:	0f b6 09             	movzbl (%ecx),%ecx
  ee:	88 0b                	mov    %cl,(%ebx)
  f0:	84 c9                	test   %cl,%cl
  f2:	75 ed                	jne    e1 <strcpy+0x11>
    ;
  return os;
}
  f4:	89 f0                	mov    %esi,%eax
  f6:	5b                   	pop    %ebx
  f7:	5e                   	pop    %esi
  f8:	5d                   	pop    %ebp
  f9:	c3                   	ret    

000000fa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  fa:	f3 0f 1e fb          	endbr32 
  fe:	55                   	push   %ebp
  ff:	89 e5                	mov    %esp,%ebp
 101:	8b 4d 08             	mov    0x8(%ebp),%ecx
 104:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 107:	0f b6 01             	movzbl (%ecx),%eax
 10a:	84 c0                	test   %al,%al
 10c:	74 0c                	je     11a <strcmp+0x20>
 10e:	3a 02                	cmp    (%edx),%al
 110:	75 08                	jne    11a <strcmp+0x20>
    p++, q++;
 112:	83 c1 01             	add    $0x1,%ecx
 115:	83 c2 01             	add    $0x1,%edx
 118:	eb ed                	jmp    107 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 11a:	0f b6 c0             	movzbl %al,%eax
 11d:	0f b6 12             	movzbl (%edx),%edx
 120:	29 d0                	sub    %edx,%eax
}
 122:	5d                   	pop    %ebp
 123:	c3                   	ret    

00000124 <strlen>:

uint
strlen(char *s)
{
 124:	f3 0f 1e fb          	endbr32 
 128:	55                   	push   %ebp
 129:	89 e5                	mov    %esp,%ebp
 12b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 12e:	b8 00 00 00 00       	mov    $0x0,%eax
 133:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 137:	74 05                	je     13e <strlen+0x1a>
 139:	83 c0 01             	add    $0x1,%eax
 13c:	eb f5                	jmp    133 <strlen+0xf>
    ;
  return n;
}
 13e:	5d                   	pop    %ebp
 13f:	c3                   	ret    

00000140 <memset>:

void*
memset(void *dst, int c, uint n)
{
 140:	f3 0f 1e fb          	endbr32 
 144:	55                   	push   %ebp
 145:	89 e5                	mov    %esp,%ebp
 147:	57                   	push   %edi
 148:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 14b:	89 d7                	mov    %edx,%edi
 14d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 150:	8b 45 0c             	mov    0xc(%ebp),%eax
 153:	fc                   	cld    
 154:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 156:	89 d0                	mov    %edx,%eax
 158:	5f                   	pop    %edi
 159:	5d                   	pop    %ebp
 15a:	c3                   	ret    

0000015b <strchr>:

char*
strchr(const char *s, char c)
{
 15b:	f3 0f 1e fb          	endbr32 
 15f:	55                   	push   %ebp
 160:	89 e5                	mov    %esp,%ebp
 162:	8b 45 08             	mov    0x8(%ebp),%eax
 165:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 169:	0f b6 10             	movzbl (%eax),%edx
 16c:	84 d2                	test   %dl,%dl
 16e:	74 09                	je     179 <strchr+0x1e>
    if(*s == c)
 170:	38 ca                	cmp    %cl,%dl
 172:	74 0a                	je     17e <strchr+0x23>
  for(; *s; s++)
 174:	83 c0 01             	add    $0x1,%eax
 177:	eb f0                	jmp    169 <strchr+0xe>
      return (char*)s;
  return 0;
 179:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17e:	5d                   	pop    %ebp
 17f:	c3                   	ret    

00000180 <gets>:

char*
gets(char *buf, int max)
{
 180:	f3 0f 1e fb          	endbr32 
 184:	55                   	push   %ebp
 185:	89 e5                	mov    %esp,%ebp
 187:	57                   	push   %edi
 188:	56                   	push   %esi
 189:	53                   	push   %ebx
 18a:	83 ec 1c             	sub    $0x1c,%esp
 18d:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 190:	bb 00 00 00 00       	mov    $0x0,%ebx
 195:	89 de                	mov    %ebx,%esi
 197:	83 c3 01             	add    $0x1,%ebx
 19a:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 19d:	7d 2e                	jge    1cd <gets+0x4d>
    cc = read(0, &c, 1);
 19f:	83 ec 04             	sub    $0x4,%esp
 1a2:	6a 01                	push   $0x1
 1a4:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1a7:	50                   	push   %eax
 1a8:	6a 00                	push   $0x0
 1aa:	e8 cf 01 00 00       	call   37e <read>
    if(cc < 1)
 1af:	83 c4 10             	add    $0x10,%esp
 1b2:	85 c0                	test   %eax,%eax
 1b4:	7e 17                	jle    1cd <gets+0x4d>
      break;
    buf[i++] = c;
 1b6:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1ba:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 1bd:	3c 0a                	cmp    $0xa,%al
 1bf:	0f 94 c2             	sete   %dl
 1c2:	3c 0d                	cmp    $0xd,%al
 1c4:	0f 94 c0             	sete   %al
 1c7:	08 c2                	or     %al,%dl
 1c9:	74 ca                	je     195 <gets+0x15>
    buf[i++] = c;
 1cb:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1cd:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 1d1:	89 f8                	mov    %edi,%eax
 1d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1d6:	5b                   	pop    %ebx
 1d7:	5e                   	pop    %esi
 1d8:	5f                   	pop    %edi
 1d9:	5d                   	pop    %ebp
 1da:	c3                   	ret    

000001db <stat>:

int
stat(char *n, struct stat *st)
{
 1db:	f3 0f 1e fb          	endbr32 
 1df:	55                   	push   %ebp
 1e0:	89 e5                	mov    %esp,%ebp
 1e2:	56                   	push   %esi
 1e3:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e4:	83 ec 08             	sub    $0x8,%esp
 1e7:	6a 00                	push   $0x0
 1e9:	ff 75 08             	pushl  0x8(%ebp)
 1ec:	e8 b5 01 00 00       	call   3a6 <open>
  if(fd < 0)
 1f1:	83 c4 10             	add    $0x10,%esp
 1f4:	85 c0                	test   %eax,%eax
 1f6:	78 24                	js     21c <stat+0x41>
 1f8:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1fa:	83 ec 08             	sub    $0x8,%esp
 1fd:	ff 75 0c             	pushl  0xc(%ebp)
 200:	50                   	push   %eax
 201:	e8 b8 01 00 00       	call   3be <fstat>
 206:	89 c6                	mov    %eax,%esi
  close(fd);
 208:	89 1c 24             	mov    %ebx,(%esp)
 20b:	e8 7e 01 00 00       	call   38e <close>
  return r;
 210:	83 c4 10             	add    $0x10,%esp
}
 213:	89 f0                	mov    %esi,%eax
 215:	8d 65 f8             	lea    -0x8(%ebp),%esp
 218:	5b                   	pop    %ebx
 219:	5e                   	pop    %esi
 21a:	5d                   	pop    %ebp
 21b:	c3                   	ret    
    return -1;
 21c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 221:	eb f0                	jmp    213 <stat+0x38>

00000223 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 223:	f3 0f 1e fb          	endbr32 
 227:	55                   	push   %ebp
 228:	89 e5                	mov    %esp,%ebp
 22a:	57                   	push   %edi
 22b:	56                   	push   %esi
 22c:	53                   	push   %ebx
 22d:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 230:	0f b6 02             	movzbl (%edx),%eax
 233:	3c 20                	cmp    $0x20,%al
 235:	75 05                	jne    23c <atoi+0x19>
 237:	83 c2 01             	add    $0x1,%edx
 23a:	eb f4                	jmp    230 <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 23c:	3c 2d                	cmp    $0x2d,%al
 23e:	74 1d                	je     25d <atoi+0x3a>
 240:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 245:	3c 2b                	cmp    $0x2b,%al
 247:	0f 94 c1             	sete   %cl
 24a:	3c 2d                	cmp    $0x2d,%al
 24c:	0f 94 c0             	sete   %al
 24f:	08 c1                	or     %al,%cl
 251:	74 03                	je     256 <atoi+0x33>
    s++;
 253:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 256:	b8 00 00 00 00       	mov    $0x0,%eax
 25b:	eb 17                	jmp    274 <atoi+0x51>
 25d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 262:	eb e1                	jmp    245 <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 264:	8d 34 80             	lea    (%eax,%eax,4),%esi
 267:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 26a:	83 c2 01             	add    $0x1,%edx
 26d:	0f be c9             	movsbl %cl,%ecx
 270:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 274:	0f b6 0a             	movzbl (%edx),%ecx
 277:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 27a:	80 fb 09             	cmp    $0x9,%bl
 27d:	76 e5                	jbe    264 <atoi+0x41>
  return sign*n;
 27f:	0f af c7             	imul   %edi,%eax
}
 282:	5b                   	pop    %ebx
 283:	5e                   	pop    %esi
 284:	5f                   	pop    %edi
 285:	5d                   	pop    %ebp
 286:	c3                   	ret    

00000287 <atoo>:

int
atoo(const char *s)
{
 287:	f3 0f 1e fb          	endbr32 
 28b:	55                   	push   %ebp
 28c:	89 e5                	mov    %esp,%ebp
 28e:	57                   	push   %edi
 28f:	56                   	push   %esi
 290:	53                   	push   %ebx
 291:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 294:	0f b6 0a             	movzbl (%edx),%ecx
 297:	80 f9 20             	cmp    $0x20,%cl
 29a:	75 05                	jne    2a1 <atoo+0x1a>
 29c:	83 c2 01             	add    $0x1,%edx
 29f:	eb f3                	jmp    294 <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 2a1:	80 f9 2d             	cmp    $0x2d,%cl
 2a4:	74 23                	je     2c9 <atoo+0x42>
 2a6:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 2ab:	80 f9 2b             	cmp    $0x2b,%cl
 2ae:	0f 94 c0             	sete   %al
 2b1:	89 c6                	mov    %eax,%esi
 2b3:	80 f9 2d             	cmp    $0x2d,%cl
 2b6:	0f 94 c0             	sete   %al
 2b9:	89 f3                	mov    %esi,%ebx
 2bb:	08 c3                	or     %al,%bl
 2bd:	74 03                	je     2c2 <atoo+0x3b>
    s++;
 2bf:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 2c2:	b8 00 00 00 00       	mov    $0x0,%eax
 2c7:	eb 11                	jmp    2da <atoo+0x53>
 2c9:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 2ce:	eb db                	jmp    2ab <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 2d0:	83 c2 01             	add    $0x1,%edx
 2d3:	0f be c9             	movsbl %cl,%ecx
 2d6:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 2da:	0f b6 0a             	movzbl (%edx),%ecx
 2dd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 2e0:	80 fb 07             	cmp    $0x7,%bl
 2e3:	76 eb                	jbe    2d0 <atoo+0x49>
  return sign*n;
 2e5:	0f af c7             	imul   %edi,%eax
}
 2e8:	5b                   	pop    %ebx
 2e9:	5e                   	pop    %esi
 2ea:	5f                   	pop    %edi
 2eb:	5d                   	pop    %ebp
 2ec:	c3                   	ret    

000002ed <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 2ed:	f3 0f 1e fb          	endbr32 
 2f1:	55                   	push   %ebp
 2f2:	89 e5                	mov    %esp,%ebp
 2f4:	53                   	push   %ebx
 2f5:	8b 55 08             	mov    0x8(%ebp),%edx
 2f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2fb:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 2fe:	eb 09                	jmp    309 <strncmp+0x1c>
      n--, p++, q++;
 300:	83 e8 01             	sub    $0x1,%eax
 303:	83 c2 01             	add    $0x1,%edx
 306:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 309:	85 c0                	test   %eax,%eax
 30b:	74 0b                	je     318 <strncmp+0x2b>
 30d:	0f b6 1a             	movzbl (%edx),%ebx
 310:	84 db                	test   %bl,%bl
 312:	74 04                	je     318 <strncmp+0x2b>
 314:	3a 19                	cmp    (%ecx),%bl
 316:	74 e8                	je     300 <strncmp+0x13>
    if(n == 0)
 318:	85 c0                	test   %eax,%eax
 31a:	74 0b                	je     327 <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 31c:	0f b6 02             	movzbl (%edx),%eax
 31f:	0f b6 11             	movzbl (%ecx),%edx
 322:	29 d0                	sub    %edx,%eax
}
 324:	5b                   	pop    %ebx
 325:	5d                   	pop    %ebp
 326:	c3                   	ret    
      return 0;
 327:	b8 00 00 00 00       	mov    $0x0,%eax
 32c:	eb f6                	jmp    324 <strncmp+0x37>

0000032e <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 32e:	f3 0f 1e fb          	endbr32 
 332:	55                   	push   %ebp
 333:	89 e5                	mov    %esp,%ebp
 335:	56                   	push   %esi
 336:	53                   	push   %ebx
 337:	8b 75 08             	mov    0x8(%ebp),%esi
 33a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 33d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 340:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 342:	8d 58 ff             	lea    -0x1(%eax),%ebx
 345:	85 c0                	test   %eax,%eax
 347:	7e 0f                	jle    358 <memmove+0x2a>
    *dst++ = *src++;
 349:	0f b6 01             	movzbl (%ecx),%eax
 34c:	88 02                	mov    %al,(%edx)
 34e:	8d 49 01             	lea    0x1(%ecx),%ecx
 351:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 354:	89 d8                	mov    %ebx,%eax
 356:	eb ea                	jmp    342 <memmove+0x14>
  return vdst;
}
 358:	89 f0                	mov    %esi,%eax
 35a:	5b                   	pop    %ebx
 35b:	5e                   	pop    %esi
 35c:	5d                   	pop    %ebp
 35d:	c3                   	ret    

0000035e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 35e:	b8 01 00 00 00       	mov    $0x1,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <exit>:
SYSCALL(exit)
 366:	b8 02 00 00 00       	mov    $0x2,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <wait>:
SYSCALL(wait)
 36e:	b8 03 00 00 00       	mov    $0x3,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <pipe>:
SYSCALL(pipe)
 376:	b8 04 00 00 00       	mov    $0x4,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <read>:
SYSCALL(read)
 37e:	b8 05 00 00 00       	mov    $0x5,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <write>:
SYSCALL(write)
 386:	b8 10 00 00 00       	mov    $0x10,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <close>:
SYSCALL(close)
 38e:	b8 15 00 00 00       	mov    $0x15,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <kill>:
SYSCALL(kill)
 396:	b8 06 00 00 00       	mov    $0x6,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <exec>:
SYSCALL(exec)
 39e:	b8 07 00 00 00       	mov    $0x7,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <open>:
SYSCALL(open)
 3a6:	b8 0f 00 00 00       	mov    $0xf,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <mknod>:
SYSCALL(mknod)
 3ae:	b8 11 00 00 00       	mov    $0x11,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <unlink>:
SYSCALL(unlink)
 3b6:	b8 12 00 00 00       	mov    $0x12,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <fstat>:
SYSCALL(fstat)
 3be:	b8 08 00 00 00       	mov    $0x8,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <link>:
SYSCALL(link)
 3c6:	b8 13 00 00 00       	mov    $0x13,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <mkdir>:
SYSCALL(mkdir)
 3ce:	b8 14 00 00 00       	mov    $0x14,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <chdir>:
SYSCALL(chdir)
 3d6:	b8 09 00 00 00       	mov    $0x9,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <dup>:
SYSCALL(dup)
 3de:	b8 0a 00 00 00       	mov    $0xa,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <getpid>:
SYSCALL(getpid)
 3e6:	b8 0b 00 00 00       	mov    $0xb,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <sbrk>:
SYSCALL(sbrk)
 3ee:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <sleep>:
SYSCALL(sleep)
 3f6:	b8 0d 00 00 00       	mov    $0xd,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <uptime>:
SYSCALL(uptime)
 3fe:	b8 0e 00 00 00       	mov    $0xe,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <halt>:
SYSCALL(halt)
 406:	b8 16 00 00 00       	mov    $0x16,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <cps>:
/* ____My changes____ */
SYSCALL(cps)
 40e:	b8 17 00 00 00       	mov    $0x17,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <getppid>:
SYSCALL(getppid)
 416:	b8 18 00 00 00       	mov    $0x18,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <getsz>:
SYSCALL(getsz)
 41e:	b8 19 00 00 00       	mov    $0x19,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <chpr>:
SYSCALL(chpr)
 426:	b8 1a 00 00 00       	mov    $0x1a,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <getcount>:
SYSCALL(getcount)
 42e:	b8 1b 00 00 00       	mov    $0x1b,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <time>:
SYSCALL(time)
 436:	b8 1c 00 00 00       	mov    $0x1c,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <utctime>:
SYSCALL(utctime)
 43e:	b8 1d 00 00 00       	mov    $0x1d,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <dup2>:
SYSCALL(dup2)
 446:	b8 1e 00 00 00       	mov    $0x1e,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 44e:	55                   	push   %ebp
 44f:	89 e5                	mov    %esp,%ebp
 451:	83 ec 1c             	sub    $0x1c,%esp
 454:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 457:	6a 01                	push   $0x1
 459:	8d 55 f4             	lea    -0xc(%ebp),%edx
 45c:	52                   	push   %edx
 45d:	50                   	push   %eax
 45e:	e8 23 ff ff ff       	call   386 <write>
}
 463:	83 c4 10             	add    $0x10,%esp
 466:	c9                   	leave  
 467:	c3                   	ret    

00000468 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 468:	55                   	push   %ebp
 469:	89 e5                	mov    %esp,%ebp
 46b:	57                   	push   %edi
 46c:	56                   	push   %esi
 46d:	53                   	push   %ebx
 46e:	83 ec 2c             	sub    $0x2c,%esp
 471:	89 45 d0             	mov    %eax,-0x30(%ebp)
 474:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 476:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 47a:	0f 95 c2             	setne  %dl
 47d:	89 f0                	mov    %esi,%eax
 47f:	c1 e8 1f             	shr    $0x1f,%eax
 482:	84 c2                	test   %al,%dl
 484:	74 42                	je     4c8 <printint+0x60>
    neg = 1;
    x = -xx;
 486:	f7 de                	neg    %esi
    neg = 1;
 488:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 48f:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 494:	89 f0                	mov    %esi,%eax
 496:	ba 00 00 00 00       	mov    $0x0,%edx
 49b:	f7 f1                	div    %ecx
 49d:	89 df                	mov    %ebx,%edi
 49f:	83 c3 01             	add    $0x1,%ebx
 4a2:	0f b6 92 34 08 00 00 	movzbl 0x834(%edx),%edx
 4a9:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 4ad:	89 f2                	mov    %esi,%edx
 4af:	89 c6                	mov    %eax,%esi
 4b1:	39 d1                	cmp    %edx,%ecx
 4b3:	76 df                	jbe    494 <printint+0x2c>
  if(neg)
 4b5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 4b9:	74 2f                	je     4ea <printint+0x82>
    buf[i++] = '-';
 4bb:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 4c0:	8d 5f 02             	lea    0x2(%edi),%ebx
 4c3:	8b 75 d0             	mov    -0x30(%ebp),%esi
 4c6:	eb 15                	jmp    4dd <printint+0x75>
  neg = 0;
 4c8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 4cf:	eb be                	jmp    48f <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 4d1:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 4d6:	89 f0                	mov    %esi,%eax
 4d8:	e8 71 ff ff ff       	call   44e <putc>
  while(--i >= 0)
 4dd:	83 eb 01             	sub    $0x1,%ebx
 4e0:	79 ef                	jns    4d1 <printint+0x69>
}
 4e2:	83 c4 2c             	add    $0x2c,%esp
 4e5:	5b                   	pop    %ebx
 4e6:	5e                   	pop    %esi
 4e7:	5f                   	pop    %edi
 4e8:	5d                   	pop    %ebp
 4e9:	c3                   	ret    
 4ea:	8b 75 d0             	mov    -0x30(%ebp),%esi
 4ed:	eb ee                	jmp    4dd <printint+0x75>

000004ef <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4ef:	f3 0f 1e fb          	endbr32 
 4f3:	55                   	push   %ebp
 4f4:	89 e5                	mov    %esp,%ebp
 4f6:	57                   	push   %edi
 4f7:	56                   	push   %esi
 4f8:	53                   	push   %ebx
 4f9:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4fc:	8d 45 10             	lea    0x10(%ebp),%eax
 4ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 502:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 507:	bb 00 00 00 00       	mov    $0x0,%ebx
 50c:	eb 14                	jmp    522 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 50e:	89 fa                	mov    %edi,%edx
 510:	8b 45 08             	mov    0x8(%ebp),%eax
 513:	e8 36 ff ff ff       	call   44e <putc>
 518:	eb 05                	jmp    51f <printf+0x30>
      }
    } else if(state == '%'){
 51a:	83 fe 25             	cmp    $0x25,%esi
 51d:	74 25                	je     544 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 51f:	83 c3 01             	add    $0x1,%ebx
 522:	8b 45 0c             	mov    0xc(%ebp),%eax
 525:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 529:	84 c0                	test   %al,%al
 52b:	0f 84 23 01 00 00    	je     654 <printf+0x165>
    c = fmt[i] & 0xff;
 531:	0f be f8             	movsbl %al,%edi
 534:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 537:	85 f6                	test   %esi,%esi
 539:	75 df                	jne    51a <printf+0x2b>
      if(c == '%'){
 53b:	83 f8 25             	cmp    $0x25,%eax
 53e:	75 ce                	jne    50e <printf+0x1f>
        state = '%';
 540:	89 c6                	mov    %eax,%esi
 542:	eb db                	jmp    51f <printf+0x30>
      if(c == 'd'){
 544:	83 f8 64             	cmp    $0x64,%eax
 547:	74 49                	je     592 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 549:	83 f8 78             	cmp    $0x78,%eax
 54c:	0f 94 c1             	sete   %cl
 54f:	83 f8 70             	cmp    $0x70,%eax
 552:	0f 94 c2             	sete   %dl
 555:	08 d1                	or     %dl,%cl
 557:	75 63                	jne    5bc <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 559:	83 f8 73             	cmp    $0x73,%eax
 55c:	0f 84 84 00 00 00    	je     5e6 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 562:	83 f8 63             	cmp    $0x63,%eax
 565:	0f 84 b7 00 00 00    	je     622 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 56b:	83 f8 25             	cmp    $0x25,%eax
 56e:	0f 84 cc 00 00 00    	je     640 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 574:	ba 25 00 00 00       	mov    $0x25,%edx
 579:	8b 45 08             	mov    0x8(%ebp),%eax
 57c:	e8 cd fe ff ff       	call   44e <putc>
        putc(fd, c);
 581:	89 fa                	mov    %edi,%edx
 583:	8b 45 08             	mov    0x8(%ebp),%eax
 586:	e8 c3 fe ff ff       	call   44e <putc>
      }
      state = 0;
 58b:	be 00 00 00 00       	mov    $0x0,%esi
 590:	eb 8d                	jmp    51f <printf+0x30>
        printint(fd, *ap, 10, 1);
 592:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 595:	8b 17                	mov    (%edi),%edx
 597:	83 ec 0c             	sub    $0xc,%esp
 59a:	6a 01                	push   $0x1
 59c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5a1:	8b 45 08             	mov    0x8(%ebp),%eax
 5a4:	e8 bf fe ff ff       	call   468 <printint>
        ap++;
 5a9:	83 c7 04             	add    $0x4,%edi
 5ac:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 5af:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5b2:	be 00 00 00 00       	mov    $0x0,%esi
 5b7:	e9 63 ff ff ff       	jmp    51f <printf+0x30>
        printint(fd, *ap, 16, 0);
 5bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5bf:	8b 17                	mov    (%edi),%edx
 5c1:	83 ec 0c             	sub    $0xc,%esp
 5c4:	6a 00                	push   $0x0
 5c6:	b9 10 00 00 00       	mov    $0x10,%ecx
 5cb:	8b 45 08             	mov    0x8(%ebp),%eax
 5ce:	e8 95 fe ff ff       	call   468 <printint>
        ap++;
 5d3:	83 c7 04             	add    $0x4,%edi
 5d6:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 5d9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5dc:	be 00 00 00 00       	mov    $0x0,%esi
 5e1:	e9 39 ff ff ff       	jmp    51f <printf+0x30>
        s = (char*)*ap;
 5e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e9:	8b 30                	mov    (%eax),%esi
        ap++;
 5eb:	83 c0 04             	add    $0x4,%eax
 5ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 5f1:	85 f6                	test   %esi,%esi
 5f3:	75 28                	jne    61d <printf+0x12e>
          s = "(null)";
 5f5:	be 2a 08 00 00       	mov    $0x82a,%esi
 5fa:	8b 7d 08             	mov    0x8(%ebp),%edi
 5fd:	eb 0d                	jmp    60c <printf+0x11d>
          putc(fd, *s);
 5ff:	0f be d2             	movsbl %dl,%edx
 602:	89 f8                	mov    %edi,%eax
 604:	e8 45 fe ff ff       	call   44e <putc>
          s++;
 609:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 60c:	0f b6 16             	movzbl (%esi),%edx
 60f:	84 d2                	test   %dl,%dl
 611:	75 ec                	jne    5ff <printf+0x110>
      state = 0;
 613:	be 00 00 00 00       	mov    $0x0,%esi
 618:	e9 02 ff ff ff       	jmp    51f <printf+0x30>
 61d:	8b 7d 08             	mov    0x8(%ebp),%edi
 620:	eb ea                	jmp    60c <printf+0x11d>
        putc(fd, *ap);
 622:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 625:	0f be 17             	movsbl (%edi),%edx
 628:	8b 45 08             	mov    0x8(%ebp),%eax
 62b:	e8 1e fe ff ff       	call   44e <putc>
        ap++;
 630:	83 c7 04             	add    $0x4,%edi
 633:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 636:	be 00 00 00 00       	mov    $0x0,%esi
 63b:	e9 df fe ff ff       	jmp    51f <printf+0x30>
        putc(fd, c);
 640:	89 fa                	mov    %edi,%edx
 642:	8b 45 08             	mov    0x8(%ebp),%eax
 645:	e8 04 fe ff ff       	call   44e <putc>
      state = 0;
 64a:	be 00 00 00 00       	mov    $0x0,%esi
 64f:	e9 cb fe ff ff       	jmp    51f <printf+0x30>
    }
  }
}
 654:	8d 65 f4             	lea    -0xc(%ebp),%esp
 657:	5b                   	pop    %ebx
 658:	5e                   	pop    %esi
 659:	5f                   	pop    %edi
 65a:	5d                   	pop    %ebp
 65b:	c3                   	ret    

0000065c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 65c:	f3 0f 1e fb          	endbr32 
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	57                   	push   %edi
 664:	56                   	push   %esi
 665:	53                   	push   %ebx
 666:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 669:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66c:	a1 30 0b 00 00       	mov    0xb30,%eax
 671:	eb 02                	jmp    675 <free+0x19>
 673:	89 d0                	mov    %edx,%eax
 675:	39 c8                	cmp    %ecx,%eax
 677:	73 04                	jae    67d <free+0x21>
 679:	39 08                	cmp    %ecx,(%eax)
 67b:	77 12                	ja     68f <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67d:	8b 10                	mov    (%eax),%edx
 67f:	39 c2                	cmp    %eax,%edx
 681:	77 f0                	ja     673 <free+0x17>
 683:	39 c8                	cmp    %ecx,%eax
 685:	72 08                	jb     68f <free+0x33>
 687:	39 ca                	cmp    %ecx,%edx
 689:	77 04                	ja     68f <free+0x33>
 68b:	89 d0                	mov    %edx,%eax
 68d:	eb e6                	jmp    675 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 68f:	8b 73 fc             	mov    -0x4(%ebx),%esi
 692:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 695:	8b 10                	mov    (%eax),%edx
 697:	39 d7                	cmp    %edx,%edi
 699:	74 19                	je     6b4 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 69b:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 69e:	8b 50 04             	mov    0x4(%eax),%edx
 6a1:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6a4:	39 ce                	cmp    %ecx,%esi
 6a6:	74 1b                	je     6c3 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6a8:	89 08                	mov    %ecx,(%eax)
  freep = p;
 6aa:	a3 30 0b 00 00       	mov    %eax,0xb30
}
 6af:	5b                   	pop    %ebx
 6b0:	5e                   	pop    %esi
 6b1:	5f                   	pop    %edi
 6b2:	5d                   	pop    %ebp
 6b3:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 6b4:	03 72 04             	add    0x4(%edx),%esi
 6b7:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ba:	8b 10                	mov    (%eax),%edx
 6bc:	8b 12                	mov    (%edx),%edx
 6be:	89 53 f8             	mov    %edx,-0x8(%ebx)
 6c1:	eb db                	jmp    69e <free+0x42>
    p->s.size += bp->s.size;
 6c3:	03 53 fc             	add    -0x4(%ebx),%edx
 6c6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6c9:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6cc:	89 10                	mov    %edx,(%eax)
 6ce:	eb da                	jmp    6aa <free+0x4e>

000006d0 <morecore>:

static Header*
morecore(uint nu)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	53                   	push   %ebx
 6d4:	83 ec 04             	sub    $0x4,%esp
 6d7:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 6d9:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 6de:	77 05                	ja     6e5 <morecore+0x15>
    nu = 4096;
 6e0:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 6e5:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 6ec:	83 ec 0c             	sub    $0xc,%esp
 6ef:	50                   	push   %eax
 6f0:	e8 f9 fc ff ff       	call   3ee <sbrk>
  if(p == (char*)-1)
 6f5:	83 c4 10             	add    $0x10,%esp
 6f8:	83 f8 ff             	cmp    $0xffffffff,%eax
 6fb:	74 1c                	je     719 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6fd:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 700:	83 c0 08             	add    $0x8,%eax
 703:	83 ec 0c             	sub    $0xc,%esp
 706:	50                   	push   %eax
 707:	e8 50 ff ff ff       	call   65c <free>
  return freep;
 70c:	a1 30 0b 00 00       	mov    0xb30,%eax
 711:	83 c4 10             	add    $0x10,%esp
}
 714:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 717:	c9                   	leave  
 718:	c3                   	ret    
    return 0;
 719:	b8 00 00 00 00       	mov    $0x0,%eax
 71e:	eb f4                	jmp    714 <morecore+0x44>

00000720 <malloc>:

void*
malloc(uint nbytes)
{
 720:	f3 0f 1e fb          	endbr32 
 724:	55                   	push   %ebp
 725:	89 e5                	mov    %esp,%ebp
 727:	53                   	push   %ebx
 728:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 72b:	8b 45 08             	mov    0x8(%ebp),%eax
 72e:	8d 58 07             	lea    0x7(%eax),%ebx
 731:	c1 eb 03             	shr    $0x3,%ebx
 734:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 737:	8b 0d 30 0b 00 00    	mov    0xb30,%ecx
 73d:	85 c9                	test   %ecx,%ecx
 73f:	74 04                	je     745 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 741:	8b 01                	mov    (%ecx),%eax
 743:	eb 4b                	jmp    790 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 745:	c7 05 30 0b 00 00 34 	movl   $0xb34,0xb30
 74c:	0b 00 00 
 74f:	c7 05 34 0b 00 00 34 	movl   $0xb34,0xb34
 756:	0b 00 00 
    base.s.size = 0;
 759:	c7 05 38 0b 00 00 00 	movl   $0x0,0xb38
 760:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 763:	b9 34 0b 00 00       	mov    $0xb34,%ecx
 768:	eb d7                	jmp    741 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 76a:	74 1a                	je     786 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 76c:	29 da                	sub    %ebx,%edx
 76e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 771:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 774:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 777:	89 0d 30 0b 00 00    	mov    %ecx,0xb30
      return (void*)(p + 1);
 77d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 780:	83 c4 04             	add    $0x4,%esp
 783:	5b                   	pop    %ebx
 784:	5d                   	pop    %ebp
 785:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 786:	8b 10                	mov    (%eax),%edx
 788:	89 11                	mov    %edx,(%ecx)
 78a:	eb eb                	jmp    777 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78c:	89 c1                	mov    %eax,%ecx
 78e:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 790:	8b 50 04             	mov    0x4(%eax),%edx
 793:	39 da                	cmp    %ebx,%edx
 795:	73 d3                	jae    76a <malloc+0x4a>
    if(p == freep)
 797:	39 05 30 0b 00 00    	cmp    %eax,0xb30
 79d:	75 ed                	jne    78c <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 79f:	89 d8                	mov    %ebx,%eax
 7a1:	e8 2a ff ff ff       	call   6d0 <morecore>
 7a6:	85 c0                	test   %eax,%eax
 7a8:	75 e2                	jne    78c <malloc+0x6c>
 7aa:	eb d4                	jmp    780 <malloc+0x60>
