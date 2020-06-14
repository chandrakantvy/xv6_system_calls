
_proc_creater:     file format elf32-i386


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
  17:	8b 41 04             	mov    0x4(%ecx),%eax
	int n, id, p=1;
	// n is for number of children to be produced
	if (argc < 2)
  1a:	83 39 01             	cmpl   $0x1,(%ecx)
  1d:	7f 16                	jg     35 <main+0x35>
		n = 1;
  1f:	be 01 00 00 00       	mov    $0x1,%esi
	else
		n = atoi(argv[1]);
	if (n < 0 || n > 20)
  24:	83 fe 14             	cmp    $0x14,%esi
  27:	76 05                	jbe    2e <main+0x2e>
		n = 2;
  29:	be 02 00 00 00       	mov    $0x2,%esi

	id = 0;
	for(int i = 0; i < n; i++) {
  2e:	bb 00 00 00 00       	mov    $0x0,%ebx
  33:	eb 2d                	jmp    62 <main+0x62>
		n = atoi(argv[1]);
  35:	83 ec 0c             	sub    $0xc,%esp
  38:	ff 70 04             	pushl  0x4(%eax)
  3b:	e8 d1 01 00 00       	call   211 <atoi>
  40:	89 c6                	mov    %eax,%esi
  42:	83 c4 10             	add    $0x10,%esp
  45:	eb dd                	jmp    24 <main+0x24>
		id = fork();
		if (id < 0) 
			printf(1, "%d couldn't create child\n", getpid());
  47:	e8 88 03 00 00       	call   3d4 <getpid>
  4c:	83 ec 04             	sub    $0x4,%esp
  4f:	50                   	push   %eax
  50:	68 9c 07 00 00       	push   $0x79c
  55:	6a 01                	push   $0x1
  57:	e8 81 04 00 00       	call   4dd <printf>
  5c:	83 c4 10             	add    $0x10,%esp
	for(int i = 0; i < n; i++) {
  5f:	83 c3 01             	add    $0x1,%ebx
  62:	39 de                	cmp    %ebx,%esi
  64:	7e 53                	jle    b9 <main+0xb9>
		id = fork();
  66:	e8 e1 02 00 00       	call   34c <fork>
		if (id < 0) 
  6b:	85 c0                	test   %eax,%eax
  6d:	78 d8                	js     47 <main+0x47>
		else if (id > 0){
  6f:	7e 1f                	jle    90 <main+0x90>
			printf(1, "parent = %d\n", getpid());
  71:	e8 5e 03 00 00       	call   3d4 <getpid>
  76:	83 ec 04             	sub    $0x4,%esp
  79:	50                   	push   %eax
  7a:	68 b6 07 00 00       	push   $0x7b6
  7f:	6a 01                	push   $0x1
  81:	e8 57 04 00 00       	call   4dd <printf>
			wait();
  86:	e8 d1 02 00 00       	call   35c <wait>
  8b:	83 c4 10             	add    $0x10,%esp
  8e:	eb cf                	jmp    5f <main+0x5f>
		} 
		else {
			printf(1, "Child = %d\n",getpid());
  90:	e8 3f 03 00 00       	call   3d4 <getpid>
  95:	83 ec 04             	sub    $0x4,%esp
  98:	50                   	push   %eax
  99:	68 c3 07 00 00       	push   $0x7c3
  9e:	6a 01                	push   $0x1
  a0:	e8 38 04 00 00       	call   4dd <printf>
			for(int j = 1; j < 1000000000; j++)
  a5:	83 c4 10             	add    $0x10,%esp
  a8:	b8 01 00 00 00       	mov    $0x1,%eax
  ad:	3d ff c9 9a 3b       	cmp    $0x3b9ac9ff,%eax
  b2:	7f 05                	jg     b9 <main+0xb9>
  b4:	83 c0 01             	add    $0x1,%eax
  b7:	eb f4                	jmp    ad <main+0xad>
			break;
		}
	}
	// test_cps() => use this call here to current 
	// process status along with there priority
	exit();
  b9:	e8 96 02 00 00       	call   354 <exit>

000000be <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  be:	f3 0f 1e fb          	endbr32 
  c2:	55                   	push   %ebp
  c3:	89 e5                	mov    %esp,%ebp
  c5:	56                   	push   %esi
  c6:	53                   	push   %ebx
  c7:	8b 75 08             	mov    0x8(%ebp),%esi
  ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  cd:	89 f0                	mov    %esi,%eax
  cf:	89 d1                	mov    %edx,%ecx
  d1:	83 c2 01             	add    $0x1,%edx
  d4:	89 c3                	mov    %eax,%ebx
  d6:	83 c0 01             	add    $0x1,%eax
  d9:	0f b6 09             	movzbl (%ecx),%ecx
  dc:	88 0b                	mov    %cl,(%ebx)
  de:	84 c9                	test   %cl,%cl
  e0:	75 ed                	jne    cf <strcpy+0x11>
    ;
  return os;
}
  e2:	89 f0                	mov    %esi,%eax
  e4:	5b                   	pop    %ebx
  e5:	5e                   	pop    %esi
  e6:	5d                   	pop    %ebp
  e7:	c3                   	ret    

000000e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e8:	f3 0f 1e fb          	endbr32 
  ec:	55                   	push   %ebp
  ed:	89 e5                	mov    %esp,%ebp
  ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  f5:	0f b6 01             	movzbl (%ecx),%eax
  f8:	84 c0                	test   %al,%al
  fa:	74 0c                	je     108 <strcmp+0x20>
  fc:	3a 02                	cmp    (%edx),%al
  fe:	75 08                	jne    108 <strcmp+0x20>
    p++, q++;
 100:	83 c1 01             	add    $0x1,%ecx
 103:	83 c2 01             	add    $0x1,%edx
 106:	eb ed                	jmp    f5 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 108:	0f b6 c0             	movzbl %al,%eax
 10b:	0f b6 12             	movzbl (%edx),%edx
 10e:	29 d0                	sub    %edx,%eax
}
 110:	5d                   	pop    %ebp
 111:	c3                   	ret    

00000112 <strlen>:

uint
strlen(char *s)
{
 112:	f3 0f 1e fb          	endbr32 
 116:	55                   	push   %ebp
 117:	89 e5                	mov    %esp,%ebp
 119:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 11c:	b8 00 00 00 00       	mov    $0x0,%eax
 121:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 125:	74 05                	je     12c <strlen+0x1a>
 127:	83 c0 01             	add    $0x1,%eax
 12a:	eb f5                	jmp    121 <strlen+0xf>
    ;
  return n;
}
 12c:	5d                   	pop    %ebp
 12d:	c3                   	ret    

0000012e <memset>:

void*
memset(void *dst, int c, uint n)
{
 12e:	f3 0f 1e fb          	endbr32 
 132:	55                   	push   %ebp
 133:	89 e5                	mov    %esp,%ebp
 135:	57                   	push   %edi
 136:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 139:	89 d7                	mov    %edx,%edi
 13b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 13e:	8b 45 0c             	mov    0xc(%ebp),%eax
 141:	fc                   	cld    
 142:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 144:	89 d0                	mov    %edx,%eax
 146:	5f                   	pop    %edi
 147:	5d                   	pop    %ebp
 148:	c3                   	ret    

00000149 <strchr>:

char*
strchr(const char *s, char c)
{
 149:	f3 0f 1e fb          	endbr32 
 14d:	55                   	push   %ebp
 14e:	89 e5                	mov    %esp,%ebp
 150:	8b 45 08             	mov    0x8(%ebp),%eax
 153:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 157:	0f b6 10             	movzbl (%eax),%edx
 15a:	84 d2                	test   %dl,%dl
 15c:	74 09                	je     167 <strchr+0x1e>
    if(*s == c)
 15e:	38 ca                	cmp    %cl,%dl
 160:	74 0a                	je     16c <strchr+0x23>
  for(; *s; s++)
 162:	83 c0 01             	add    $0x1,%eax
 165:	eb f0                	jmp    157 <strchr+0xe>
      return (char*)s;
  return 0;
 167:	b8 00 00 00 00       	mov    $0x0,%eax
}
 16c:	5d                   	pop    %ebp
 16d:	c3                   	ret    

0000016e <gets>:

char*
gets(char *buf, int max)
{
 16e:	f3 0f 1e fb          	endbr32 
 172:	55                   	push   %ebp
 173:	89 e5                	mov    %esp,%ebp
 175:	57                   	push   %edi
 176:	56                   	push   %esi
 177:	53                   	push   %ebx
 178:	83 ec 1c             	sub    $0x1c,%esp
 17b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17e:	bb 00 00 00 00       	mov    $0x0,%ebx
 183:	89 de                	mov    %ebx,%esi
 185:	83 c3 01             	add    $0x1,%ebx
 188:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 18b:	7d 2e                	jge    1bb <gets+0x4d>
    cc = read(0, &c, 1);
 18d:	83 ec 04             	sub    $0x4,%esp
 190:	6a 01                	push   $0x1
 192:	8d 45 e7             	lea    -0x19(%ebp),%eax
 195:	50                   	push   %eax
 196:	6a 00                	push   $0x0
 198:	e8 cf 01 00 00       	call   36c <read>
    if(cc < 1)
 19d:	83 c4 10             	add    $0x10,%esp
 1a0:	85 c0                	test   %eax,%eax
 1a2:	7e 17                	jle    1bb <gets+0x4d>
      break;
    buf[i++] = c;
 1a4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1a8:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 1ab:	3c 0a                	cmp    $0xa,%al
 1ad:	0f 94 c2             	sete   %dl
 1b0:	3c 0d                	cmp    $0xd,%al
 1b2:	0f 94 c0             	sete   %al
 1b5:	08 c2                	or     %al,%dl
 1b7:	74 ca                	je     183 <gets+0x15>
    buf[i++] = c;
 1b9:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1bb:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 1bf:	89 f8                	mov    %edi,%eax
 1c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1c4:	5b                   	pop    %ebx
 1c5:	5e                   	pop    %esi
 1c6:	5f                   	pop    %edi
 1c7:	5d                   	pop    %ebp
 1c8:	c3                   	ret    

000001c9 <stat>:

int
stat(char *n, struct stat *st)
{
 1c9:	f3 0f 1e fb          	endbr32 
 1cd:	55                   	push   %ebp
 1ce:	89 e5                	mov    %esp,%ebp
 1d0:	56                   	push   %esi
 1d1:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d2:	83 ec 08             	sub    $0x8,%esp
 1d5:	6a 00                	push   $0x0
 1d7:	ff 75 08             	pushl  0x8(%ebp)
 1da:	e8 b5 01 00 00       	call   394 <open>
  if(fd < 0)
 1df:	83 c4 10             	add    $0x10,%esp
 1e2:	85 c0                	test   %eax,%eax
 1e4:	78 24                	js     20a <stat+0x41>
 1e6:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1e8:	83 ec 08             	sub    $0x8,%esp
 1eb:	ff 75 0c             	pushl  0xc(%ebp)
 1ee:	50                   	push   %eax
 1ef:	e8 b8 01 00 00       	call   3ac <fstat>
 1f4:	89 c6                	mov    %eax,%esi
  close(fd);
 1f6:	89 1c 24             	mov    %ebx,(%esp)
 1f9:	e8 7e 01 00 00       	call   37c <close>
  return r;
 1fe:	83 c4 10             	add    $0x10,%esp
}
 201:	89 f0                	mov    %esi,%eax
 203:	8d 65 f8             	lea    -0x8(%ebp),%esp
 206:	5b                   	pop    %ebx
 207:	5e                   	pop    %esi
 208:	5d                   	pop    %ebp
 209:	c3                   	ret    
    return -1;
 20a:	be ff ff ff ff       	mov    $0xffffffff,%esi
 20f:	eb f0                	jmp    201 <stat+0x38>

00000211 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 211:	f3 0f 1e fb          	endbr32 
 215:	55                   	push   %ebp
 216:	89 e5                	mov    %esp,%ebp
 218:	57                   	push   %edi
 219:	56                   	push   %esi
 21a:	53                   	push   %ebx
 21b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 21e:	0f b6 02             	movzbl (%edx),%eax
 221:	3c 20                	cmp    $0x20,%al
 223:	75 05                	jne    22a <atoi+0x19>
 225:	83 c2 01             	add    $0x1,%edx
 228:	eb f4                	jmp    21e <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 22a:	3c 2d                	cmp    $0x2d,%al
 22c:	74 1d                	je     24b <atoi+0x3a>
 22e:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 233:	3c 2b                	cmp    $0x2b,%al
 235:	0f 94 c1             	sete   %cl
 238:	3c 2d                	cmp    $0x2d,%al
 23a:	0f 94 c0             	sete   %al
 23d:	08 c1                	or     %al,%cl
 23f:	74 03                	je     244 <atoi+0x33>
    s++;
 241:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 244:	b8 00 00 00 00       	mov    $0x0,%eax
 249:	eb 17                	jmp    262 <atoi+0x51>
 24b:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 250:	eb e1                	jmp    233 <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 252:	8d 34 80             	lea    (%eax,%eax,4),%esi
 255:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 258:	83 c2 01             	add    $0x1,%edx
 25b:	0f be c9             	movsbl %cl,%ecx
 25e:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 262:	0f b6 0a             	movzbl (%edx),%ecx
 265:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 268:	80 fb 09             	cmp    $0x9,%bl
 26b:	76 e5                	jbe    252 <atoi+0x41>
  return sign*n;
 26d:	0f af c7             	imul   %edi,%eax
}
 270:	5b                   	pop    %ebx
 271:	5e                   	pop    %esi
 272:	5f                   	pop    %edi
 273:	5d                   	pop    %ebp
 274:	c3                   	ret    

00000275 <atoo>:

int
atoo(const char *s)
{
 275:	f3 0f 1e fb          	endbr32 
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
 27c:	57                   	push   %edi
 27d:	56                   	push   %esi
 27e:	53                   	push   %ebx
 27f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 282:	0f b6 0a             	movzbl (%edx),%ecx
 285:	80 f9 20             	cmp    $0x20,%cl
 288:	75 05                	jne    28f <atoo+0x1a>
 28a:	83 c2 01             	add    $0x1,%edx
 28d:	eb f3                	jmp    282 <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 28f:	80 f9 2d             	cmp    $0x2d,%cl
 292:	74 23                	je     2b7 <atoo+0x42>
 294:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 299:	80 f9 2b             	cmp    $0x2b,%cl
 29c:	0f 94 c0             	sete   %al
 29f:	89 c6                	mov    %eax,%esi
 2a1:	80 f9 2d             	cmp    $0x2d,%cl
 2a4:	0f 94 c0             	sete   %al
 2a7:	89 f3                	mov    %esi,%ebx
 2a9:	08 c3                	or     %al,%bl
 2ab:	74 03                	je     2b0 <atoo+0x3b>
    s++;
 2ad:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 2b0:	b8 00 00 00 00       	mov    $0x0,%eax
 2b5:	eb 11                	jmp    2c8 <atoo+0x53>
 2b7:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 2bc:	eb db                	jmp    299 <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 2be:	83 c2 01             	add    $0x1,%edx
 2c1:	0f be c9             	movsbl %cl,%ecx
 2c4:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 2c8:	0f b6 0a             	movzbl (%edx),%ecx
 2cb:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 2ce:	80 fb 07             	cmp    $0x7,%bl
 2d1:	76 eb                	jbe    2be <atoo+0x49>
  return sign*n;
 2d3:	0f af c7             	imul   %edi,%eax
}
 2d6:	5b                   	pop    %ebx
 2d7:	5e                   	pop    %esi
 2d8:	5f                   	pop    %edi
 2d9:	5d                   	pop    %ebp
 2da:	c3                   	ret    

000002db <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 2db:	f3 0f 1e fb          	endbr32 
 2df:	55                   	push   %ebp
 2e0:	89 e5                	mov    %esp,%ebp
 2e2:	53                   	push   %ebx
 2e3:	8b 55 08             	mov    0x8(%ebp),%edx
 2e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2e9:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 2ec:	eb 09                	jmp    2f7 <strncmp+0x1c>
      n--, p++, q++;
 2ee:	83 e8 01             	sub    $0x1,%eax
 2f1:	83 c2 01             	add    $0x1,%edx
 2f4:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 2f7:	85 c0                	test   %eax,%eax
 2f9:	74 0b                	je     306 <strncmp+0x2b>
 2fb:	0f b6 1a             	movzbl (%edx),%ebx
 2fe:	84 db                	test   %bl,%bl
 300:	74 04                	je     306 <strncmp+0x2b>
 302:	3a 19                	cmp    (%ecx),%bl
 304:	74 e8                	je     2ee <strncmp+0x13>
    if(n == 0)
 306:	85 c0                	test   %eax,%eax
 308:	74 0b                	je     315 <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 30a:	0f b6 02             	movzbl (%edx),%eax
 30d:	0f b6 11             	movzbl (%ecx),%edx
 310:	29 d0                	sub    %edx,%eax
}
 312:	5b                   	pop    %ebx
 313:	5d                   	pop    %ebp
 314:	c3                   	ret    
      return 0;
 315:	b8 00 00 00 00       	mov    $0x0,%eax
 31a:	eb f6                	jmp    312 <strncmp+0x37>

0000031c <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 31c:	f3 0f 1e fb          	endbr32 
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	56                   	push   %esi
 324:	53                   	push   %ebx
 325:	8b 75 08             	mov    0x8(%ebp),%esi
 328:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 32b:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 32e:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 330:	8d 58 ff             	lea    -0x1(%eax),%ebx
 333:	85 c0                	test   %eax,%eax
 335:	7e 0f                	jle    346 <memmove+0x2a>
    *dst++ = *src++;
 337:	0f b6 01             	movzbl (%ecx),%eax
 33a:	88 02                	mov    %al,(%edx)
 33c:	8d 49 01             	lea    0x1(%ecx),%ecx
 33f:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 342:	89 d8                	mov    %ebx,%eax
 344:	eb ea                	jmp    330 <memmove+0x14>
  return vdst;
}
 346:	89 f0                	mov    %esi,%eax
 348:	5b                   	pop    %ebx
 349:	5e                   	pop    %esi
 34a:	5d                   	pop    %ebp
 34b:	c3                   	ret    

0000034c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 34c:	b8 01 00 00 00       	mov    $0x1,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <exit>:
SYSCALL(exit)
 354:	b8 02 00 00 00       	mov    $0x2,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <wait>:
SYSCALL(wait)
 35c:	b8 03 00 00 00       	mov    $0x3,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <pipe>:
SYSCALL(pipe)
 364:	b8 04 00 00 00       	mov    $0x4,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <read>:
SYSCALL(read)
 36c:	b8 05 00 00 00       	mov    $0x5,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <write>:
SYSCALL(write)
 374:	b8 10 00 00 00       	mov    $0x10,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <close>:
SYSCALL(close)
 37c:	b8 15 00 00 00       	mov    $0x15,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <kill>:
SYSCALL(kill)
 384:	b8 06 00 00 00       	mov    $0x6,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <exec>:
SYSCALL(exec)
 38c:	b8 07 00 00 00       	mov    $0x7,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <open>:
SYSCALL(open)
 394:	b8 0f 00 00 00       	mov    $0xf,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <mknod>:
SYSCALL(mknod)
 39c:	b8 11 00 00 00       	mov    $0x11,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <unlink>:
SYSCALL(unlink)
 3a4:	b8 12 00 00 00       	mov    $0x12,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <fstat>:
SYSCALL(fstat)
 3ac:	b8 08 00 00 00       	mov    $0x8,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <link>:
SYSCALL(link)
 3b4:	b8 13 00 00 00       	mov    $0x13,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <mkdir>:
SYSCALL(mkdir)
 3bc:	b8 14 00 00 00       	mov    $0x14,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <chdir>:
SYSCALL(chdir)
 3c4:	b8 09 00 00 00       	mov    $0x9,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <dup>:
SYSCALL(dup)
 3cc:	b8 0a 00 00 00       	mov    $0xa,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <getpid>:
SYSCALL(getpid)
 3d4:	b8 0b 00 00 00       	mov    $0xb,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <sbrk>:
SYSCALL(sbrk)
 3dc:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <sleep>:
SYSCALL(sleep)
 3e4:	b8 0d 00 00 00       	mov    $0xd,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <uptime>:
SYSCALL(uptime)
 3ec:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <halt>:
SYSCALL(halt)
 3f4:	b8 16 00 00 00       	mov    $0x16,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <cps>:
/* ____My changes____ */
SYSCALL(cps)
 3fc:	b8 17 00 00 00       	mov    $0x17,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <getppid>:
SYSCALL(getppid)
 404:	b8 18 00 00 00       	mov    $0x18,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <getsz>:
SYSCALL(getsz)
 40c:	b8 19 00 00 00       	mov    $0x19,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <chpr>:
SYSCALL(chpr)
 414:	b8 1a 00 00 00       	mov    $0x1a,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <getcount>:
SYSCALL(getcount)
 41c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <time>:
SYSCALL(time)
 424:	b8 1c 00 00 00       	mov    $0x1c,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <utctime>:
SYSCALL(utctime)
 42c:	b8 1d 00 00 00       	mov    $0x1d,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <dup2>:
SYSCALL(dup2)
 434:	b8 1e 00 00 00       	mov    $0x1e,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 43c:	55                   	push   %ebp
 43d:	89 e5                	mov    %esp,%ebp
 43f:	83 ec 1c             	sub    $0x1c,%esp
 442:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 445:	6a 01                	push   $0x1
 447:	8d 55 f4             	lea    -0xc(%ebp),%edx
 44a:	52                   	push   %edx
 44b:	50                   	push   %eax
 44c:	e8 23 ff ff ff       	call   374 <write>
}
 451:	83 c4 10             	add    $0x10,%esp
 454:	c9                   	leave  
 455:	c3                   	ret    

00000456 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 456:	55                   	push   %ebp
 457:	89 e5                	mov    %esp,%ebp
 459:	57                   	push   %edi
 45a:	56                   	push   %esi
 45b:	53                   	push   %ebx
 45c:	83 ec 2c             	sub    $0x2c,%esp
 45f:	89 45 d0             	mov    %eax,-0x30(%ebp)
 462:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 464:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 468:	0f 95 c2             	setne  %dl
 46b:	89 f0                	mov    %esi,%eax
 46d:	c1 e8 1f             	shr    $0x1f,%eax
 470:	84 c2                	test   %al,%dl
 472:	74 42                	je     4b6 <printint+0x60>
    neg = 1;
    x = -xx;
 474:	f7 de                	neg    %esi
    neg = 1;
 476:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 47d:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 482:	89 f0                	mov    %esi,%eax
 484:	ba 00 00 00 00       	mov    $0x0,%edx
 489:	f7 f1                	div    %ecx
 48b:	89 df                	mov    %ebx,%edi
 48d:	83 c3 01             	add    $0x1,%ebx
 490:	0f b6 92 d8 07 00 00 	movzbl 0x7d8(%edx),%edx
 497:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 49b:	89 f2                	mov    %esi,%edx
 49d:	89 c6                	mov    %eax,%esi
 49f:	39 d1                	cmp    %edx,%ecx
 4a1:	76 df                	jbe    482 <printint+0x2c>
  if(neg)
 4a3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 4a7:	74 2f                	je     4d8 <printint+0x82>
    buf[i++] = '-';
 4a9:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 4ae:	8d 5f 02             	lea    0x2(%edi),%ebx
 4b1:	8b 75 d0             	mov    -0x30(%ebp),%esi
 4b4:	eb 15                	jmp    4cb <printint+0x75>
  neg = 0;
 4b6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 4bd:	eb be                	jmp    47d <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 4bf:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 4c4:	89 f0                	mov    %esi,%eax
 4c6:	e8 71 ff ff ff       	call   43c <putc>
  while(--i >= 0)
 4cb:	83 eb 01             	sub    $0x1,%ebx
 4ce:	79 ef                	jns    4bf <printint+0x69>
}
 4d0:	83 c4 2c             	add    $0x2c,%esp
 4d3:	5b                   	pop    %ebx
 4d4:	5e                   	pop    %esi
 4d5:	5f                   	pop    %edi
 4d6:	5d                   	pop    %ebp
 4d7:	c3                   	ret    
 4d8:	8b 75 d0             	mov    -0x30(%ebp),%esi
 4db:	eb ee                	jmp    4cb <printint+0x75>

000004dd <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4dd:	f3 0f 1e fb          	endbr32 
 4e1:	55                   	push   %ebp
 4e2:	89 e5                	mov    %esp,%ebp
 4e4:	57                   	push   %edi
 4e5:	56                   	push   %esi
 4e6:	53                   	push   %ebx
 4e7:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4ea:	8d 45 10             	lea    0x10(%ebp),%eax
 4ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 4f0:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 4f5:	bb 00 00 00 00       	mov    $0x0,%ebx
 4fa:	eb 14                	jmp    510 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4fc:	89 fa                	mov    %edi,%edx
 4fe:	8b 45 08             	mov    0x8(%ebp),%eax
 501:	e8 36 ff ff ff       	call   43c <putc>
 506:	eb 05                	jmp    50d <printf+0x30>
      }
    } else if(state == '%'){
 508:	83 fe 25             	cmp    $0x25,%esi
 50b:	74 25                	je     532 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 50d:	83 c3 01             	add    $0x1,%ebx
 510:	8b 45 0c             	mov    0xc(%ebp),%eax
 513:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 517:	84 c0                	test   %al,%al
 519:	0f 84 23 01 00 00    	je     642 <printf+0x165>
    c = fmt[i] & 0xff;
 51f:	0f be f8             	movsbl %al,%edi
 522:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 525:	85 f6                	test   %esi,%esi
 527:	75 df                	jne    508 <printf+0x2b>
      if(c == '%'){
 529:	83 f8 25             	cmp    $0x25,%eax
 52c:	75 ce                	jne    4fc <printf+0x1f>
        state = '%';
 52e:	89 c6                	mov    %eax,%esi
 530:	eb db                	jmp    50d <printf+0x30>
      if(c == 'd'){
 532:	83 f8 64             	cmp    $0x64,%eax
 535:	74 49                	je     580 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 537:	83 f8 78             	cmp    $0x78,%eax
 53a:	0f 94 c1             	sete   %cl
 53d:	83 f8 70             	cmp    $0x70,%eax
 540:	0f 94 c2             	sete   %dl
 543:	08 d1                	or     %dl,%cl
 545:	75 63                	jne    5aa <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 547:	83 f8 73             	cmp    $0x73,%eax
 54a:	0f 84 84 00 00 00    	je     5d4 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 550:	83 f8 63             	cmp    $0x63,%eax
 553:	0f 84 b7 00 00 00    	je     610 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 559:	83 f8 25             	cmp    $0x25,%eax
 55c:	0f 84 cc 00 00 00    	je     62e <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 562:	ba 25 00 00 00       	mov    $0x25,%edx
 567:	8b 45 08             	mov    0x8(%ebp),%eax
 56a:	e8 cd fe ff ff       	call   43c <putc>
        putc(fd, c);
 56f:	89 fa                	mov    %edi,%edx
 571:	8b 45 08             	mov    0x8(%ebp),%eax
 574:	e8 c3 fe ff ff       	call   43c <putc>
      }
      state = 0;
 579:	be 00 00 00 00       	mov    $0x0,%esi
 57e:	eb 8d                	jmp    50d <printf+0x30>
        printint(fd, *ap, 10, 1);
 580:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 583:	8b 17                	mov    (%edi),%edx
 585:	83 ec 0c             	sub    $0xc,%esp
 588:	6a 01                	push   $0x1
 58a:	b9 0a 00 00 00       	mov    $0xa,%ecx
 58f:	8b 45 08             	mov    0x8(%ebp),%eax
 592:	e8 bf fe ff ff       	call   456 <printint>
        ap++;
 597:	83 c7 04             	add    $0x4,%edi
 59a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 59d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5a0:	be 00 00 00 00       	mov    $0x0,%esi
 5a5:	e9 63 ff ff ff       	jmp    50d <printf+0x30>
        printint(fd, *ap, 16, 0);
 5aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5ad:	8b 17                	mov    (%edi),%edx
 5af:	83 ec 0c             	sub    $0xc,%esp
 5b2:	6a 00                	push   $0x0
 5b4:	b9 10 00 00 00       	mov    $0x10,%ecx
 5b9:	8b 45 08             	mov    0x8(%ebp),%eax
 5bc:	e8 95 fe ff ff       	call   456 <printint>
        ap++;
 5c1:	83 c7 04             	add    $0x4,%edi
 5c4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 5c7:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5ca:	be 00 00 00 00       	mov    $0x0,%esi
 5cf:	e9 39 ff ff ff       	jmp    50d <printf+0x30>
        s = (char*)*ap;
 5d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d7:	8b 30                	mov    (%eax),%esi
        ap++;
 5d9:	83 c0 04             	add    $0x4,%eax
 5dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 5df:	85 f6                	test   %esi,%esi
 5e1:	75 28                	jne    60b <printf+0x12e>
          s = "(null)";
 5e3:	be cf 07 00 00       	mov    $0x7cf,%esi
 5e8:	8b 7d 08             	mov    0x8(%ebp),%edi
 5eb:	eb 0d                	jmp    5fa <printf+0x11d>
          putc(fd, *s);
 5ed:	0f be d2             	movsbl %dl,%edx
 5f0:	89 f8                	mov    %edi,%eax
 5f2:	e8 45 fe ff ff       	call   43c <putc>
          s++;
 5f7:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 5fa:	0f b6 16             	movzbl (%esi),%edx
 5fd:	84 d2                	test   %dl,%dl
 5ff:	75 ec                	jne    5ed <printf+0x110>
      state = 0;
 601:	be 00 00 00 00       	mov    $0x0,%esi
 606:	e9 02 ff ff ff       	jmp    50d <printf+0x30>
 60b:	8b 7d 08             	mov    0x8(%ebp),%edi
 60e:	eb ea                	jmp    5fa <printf+0x11d>
        putc(fd, *ap);
 610:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 613:	0f be 17             	movsbl (%edi),%edx
 616:	8b 45 08             	mov    0x8(%ebp),%eax
 619:	e8 1e fe ff ff       	call   43c <putc>
        ap++;
 61e:	83 c7 04             	add    $0x4,%edi
 621:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 624:	be 00 00 00 00       	mov    $0x0,%esi
 629:	e9 df fe ff ff       	jmp    50d <printf+0x30>
        putc(fd, c);
 62e:	89 fa                	mov    %edi,%edx
 630:	8b 45 08             	mov    0x8(%ebp),%eax
 633:	e8 04 fe ff ff       	call   43c <putc>
      state = 0;
 638:	be 00 00 00 00       	mov    $0x0,%esi
 63d:	e9 cb fe ff ff       	jmp    50d <printf+0x30>
    }
  }
}
 642:	8d 65 f4             	lea    -0xc(%ebp),%esp
 645:	5b                   	pop    %ebx
 646:	5e                   	pop    %esi
 647:	5f                   	pop    %edi
 648:	5d                   	pop    %ebp
 649:	c3                   	ret    

0000064a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 64a:	f3 0f 1e fb          	endbr32 
 64e:	55                   	push   %ebp
 64f:	89 e5                	mov    %esp,%ebp
 651:	57                   	push   %edi
 652:	56                   	push   %esi
 653:	53                   	push   %ebx
 654:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 657:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65a:	a1 dc 0a 00 00       	mov    0xadc,%eax
 65f:	eb 02                	jmp    663 <free+0x19>
 661:	89 d0                	mov    %edx,%eax
 663:	39 c8                	cmp    %ecx,%eax
 665:	73 04                	jae    66b <free+0x21>
 667:	39 08                	cmp    %ecx,(%eax)
 669:	77 12                	ja     67d <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 66b:	8b 10                	mov    (%eax),%edx
 66d:	39 c2                	cmp    %eax,%edx
 66f:	77 f0                	ja     661 <free+0x17>
 671:	39 c8                	cmp    %ecx,%eax
 673:	72 08                	jb     67d <free+0x33>
 675:	39 ca                	cmp    %ecx,%edx
 677:	77 04                	ja     67d <free+0x33>
 679:	89 d0                	mov    %edx,%eax
 67b:	eb e6                	jmp    663 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 67d:	8b 73 fc             	mov    -0x4(%ebx),%esi
 680:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 683:	8b 10                	mov    (%eax),%edx
 685:	39 d7                	cmp    %edx,%edi
 687:	74 19                	je     6a2 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 689:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 68c:	8b 50 04             	mov    0x4(%eax),%edx
 68f:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 692:	39 ce                	cmp    %ecx,%esi
 694:	74 1b                	je     6b1 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 696:	89 08                	mov    %ecx,(%eax)
  freep = p;
 698:	a3 dc 0a 00 00       	mov    %eax,0xadc
}
 69d:	5b                   	pop    %ebx
 69e:	5e                   	pop    %esi
 69f:	5f                   	pop    %edi
 6a0:	5d                   	pop    %ebp
 6a1:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 6a2:	03 72 04             	add    0x4(%edx),%esi
 6a5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a8:	8b 10                	mov    (%eax),%edx
 6aa:	8b 12                	mov    (%edx),%edx
 6ac:	89 53 f8             	mov    %edx,-0x8(%ebx)
 6af:	eb db                	jmp    68c <free+0x42>
    p->s.size += bp->s.size;
 6b1:	03 53 fc             	add    -0x4(%ebx),%edx
 6b4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6b7:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6ba:	89 10                	mov    %edx,(%eax)
 6bc:	eb da                	jmp    698 <free+0x4e>

000006be <morecore>:

static Header*
morecore(uint nu)
{
 6be:	55                   	push   %ebp
 6bf:	89 e5                	mov    %esp,%ebp
 6c1:	53                   	push   %ebx
 6c2:	83 ec 04             	sub    $0x4,%esp
 6c5:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 6c7:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 6cc:	77 05                	ja     6d3 <morecore+0x15>
    nu = 4096;
 6ce:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 6d3:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 6da:	83 ec 0c             	sub    $0xc,%esp
 6dd:	50                   	push   %eax
 6de:	e8 f9 fc ff ff       	call   3dc <sbrk>
  if(p == (char*)-1)
 6e3:	83 c4 10             	add    $0x10,%esp
 6e6:	83 f8 ff             	cmp    $0xffffffff,%eax
 6e9:	74 1c                	je     707 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6eb:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6ee:	83 c0 08             	add    $0x8,%eax
 6f1:	83 ec 0c             	sub    $0xc,%esp
 6f4:	50                   	push   %eax
 6f5:	e8 50 ff ff ff       	call   64a <free>
  return freep;
 6fa:	a1 dc 0a 00 00       	mov    0xadc,%eax
 6ff:	83 c4 10             	add    $0x10,%esp
}
 702:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 705:	c9                   	leave  
 706:	c3                   	ret    
    return 0;
 707:	b8 00 00 00 00       	mov    $0x0,%eax
 70c:	eb f4                	jmp    702 <morecore+0x44>

0000070e <malloc>:

void*
malloc(uint nbytes)
{
 70e:	f3 0f 1e fb          	endbr32 
 712:	55                   	push   %ebp
 713:	89 e5                	mov    %esp,%ebp
 715:	53                   	push   %ebx
 716:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 719:	8b 45 08             	mov    0x8(%ebp),%eax
 71c:	8d 58 07             	lea    0x7(%eax),%ebx
 71f:	c1 eb 03             	shr    $0x3,%ebx
 722:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 725:	8b 0d dc 0a 00 00    	mov    0xadc,%ecx
 72b:	85 c9                	test   %ecx,%ecx
 72d:	74 04                	je     733 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 72f:	8b 01                	mov    (%ecx),%eax
 731:	eb 4b                	jmp    77e <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 733:	c7 05 dc 0a 00 00 e0 	movl   $0xae0,0xadc
 73a:	0a 00 00 
 73d:	c7 05 e0 0a 00 00 e0 	movl   $0xae0,0xae0
 744:	0a 00 00 
    base.s.size = 0;
 747:	c7 05 e4 0a 00 00 00 	movl   $0x0,0xae4
 74e:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 751:	b9 e0 0a 00 00       	mov    $0xae0,%ecx
 756:	eb d7                	jmp    72f <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 758:	74 1a                	je     774 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 75a:	29 da                	sub    %ebx,%edx
 75c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 75f:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 762:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 765:	89 0d dc 0a 00 00    	mov    %ecx,0xadc
      return (void*)(p + 1);
 76b:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 76e:	83 c4 04             	add    $0x4,%esp
 771:	5b                   	pop    %ebx
 772:	5d                   	pop    %ebp
 773:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 774:	8b 10                	mov    (%eax),%edx
 776:	89 11                	mov    %edx,(%ecx)
 778:	eb eb                	jmp    765 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 77a:	89 c1                	mov    %eax,%ecx
 77c:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 77e:	8b 50 04             	mov    0x4(%eax),%edx
 781:	39 da                	cmp    %ebx,%edx
 783:	73 d3                	jae    758 <malloc+0x4a>
    if(p == freep)
 785:	39 05 dc 0a 00 00    	cmp    %eax,0xadc
 78b:	75 ed                	jne    77a <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 78d:	89 d8                	mov    %ebx,%eax
 78f:	e8 2a ff ff ff       	call   6be <morecore>
 794:	85 c0                	test   %eax,%eax
 796:	75 e2                	jne    77a <malloc+0x6c>
 798:	eb d4                	jmp    76e <malloc+0x60>
