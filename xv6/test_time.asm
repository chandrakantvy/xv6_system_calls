
_test_time:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"
#include "fs.h"

int main (int argc,char *argv[])
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
  14:	83 ec 1c             	sub    $0x1c,%esp
  17:	8b 71 04             	mov    0x4(%ecx),%esi

 int pid;
 int status = 0, a = 3, b = 4;	
  1a:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
  21:	c7 45 e0 04 00 00 00 	movl   $0x4,-0x20(%ebp)
 pid = fork ();
  28:	e8 ea 02 00 00       	call   317 <fork>
 if (pid == 0)
  2d:	85 c0                	test   %eax,%eax
  2f:	75 41                	jne    72 <main+0x72>
  31:	89 c3                	mov    %eax,%ebx
   {	
   exec(argv[1],argv);
  33:	83 ec 08             	sub    $0x8,%esp
  36:	56                   	push   %esi
  37:	ff 76 04             	pushl  0x4(%esi)
  3a:	e8 18 03 00 00       	call   357 <exec>
    printf(1, "exec %s failed\n", argv[1]);
  3f:	83 c4 0c             	add    $0xc,%esp
  42:	ff 76 04             	pushl  0x4(%esi)
  45:	68 68 07 00 00       	push   $0x768
  4a:	6a 01                	push   $0x1
  4c:	e8 57 04 00 00       	call   4a8 <printf>
  51:	83 c4 10             	add    $0x10,%esp
    }
  else
 {
    status = time(&a,&b);
 }  
 printf(1, "Wait Time = %d\n Run Time = %d with Status %d \n",a,b,status); 
  54:	83 ec 0c             	sub    $0xc,%esp
  57:	53                   	push   %ebx
  58:	ff 75 e0             	pushl  -0x20(%ebp)
  5b:	ff 75 e4             	pushl  -0x1c(%ebp)
  5e:	68 78 07 00 00       	push   $0x778
  63:	6a 01                	push   $0x1
  65:	e8 3e 04 00 00       	call   4a8 <printf>
 exit();
  6a:	83 c4 20             	add    $0x20,%esp
  6d:	e8 ad 02 00 00       	call   31f <exit>
    status = time(&a,&b);
  72:	83 ec 08             	sub    $0x8,%esp
  75:	8d 45 e0             	lea    -0x20(%ebp),%eax
  78:	50                   	push   %eax
  79:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  7c:	50                   	push   %eax
  7d:	e8 6d 03 00 00       	call   3ef <time>
  82:	89 c3                	mov    %eax,%ebx
  84:	83 c4 10             	add    $0x10,%esp
  87:	eb cb                	jmp    54 <main+0x54>

00000089 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  89:	f3 0f 1e fb          	endbr32 
  8d:	55                   	push   %ebp
  8e:	89 e5                	mov    %esp,%ebp
  90:	56                   	push   %esi
  91:	53                   	push   %ebx
  92:	8b 75 08             	mov    0x8(%ebp),%esi
  95:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  98:	89 f0                	mov    %esi,%eax
  9a:	89 d1                	mov    %edx,%ecx
  9c:	83 c2 01             	add    $0x1,%edx
  9f:	89 c3                	mov    %eax,%ebx
  a1:	83 c0 01             	add    $0x1,%eax
  a4:	0f b6 09             	movzbl (%ecx),%ecx
  a7:	88 0b                	mov    %cl,(%ebx)
  a9:	84 c9                	test   %cl,%cl
  ab:	75 ed                	jne    9a <strcpy+0x11>
    ;
  return os;
}
  ad:	89 f0                	mov    %esi,%eax
  af:	5b                   	pop    %ebx
  b0:	5e                   	pop    %esi
  b1:	5d                   	pop    %ebp
  b2:	c3                   	ret    

000000b3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b3:	f3 0f 1e fb          	endbr32 
  b7:	55                   	push   %ebp
  b8:	89 e5                	mov    %esp,%ebp
  ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  c0:	0f b6 01             	movzbl (%ecx),%eax
  c3:	84 c0                	test   %al,%al
  c5:	74 0c                	je     d3 <strcmp+0x20>
  c7:	3a 02                	cmp    (%edx),%al
  c9:	75 08                	jne    d3 <strcmp+0x20>
    p++, q++;
  cb:	83 c1 01             	add    $0x1,%ecx
  ce:	83 c2 01             	add    $0x1,%edx
  d1:	eb ed                	jmp    c0 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  d3:	0f b6 c0             	movzbl %al,%eax
  d6:	0f b6 12             	movzbl (%edx),%edx
  d9:	29 d0                	sub    %edx,%eax
}
  db:	5d                   	pop    %ebp
  dc:	c3                   	ret    

000000dd <strlen>:

uint
strlen(char *s)
{
  dd:	f3 0f 1e fb          	endbr32 
  e1:	55                   	push   %ebp
  e2:	89 e5                	mov    %esp,%ebp
  e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  e7:	b8 00 00 00 00       	mov    $0x0,%eax
  ec:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  f0:	74 05                	je     f7 <strlen+0x1a>
  f2:	83 c0 01             	add    $0x1,%eax
  f5:	eb f5                	jmp    ec <strlen+0xf>
    ;
  return n;
}
  f7:	5d                   	pop    %ebp
  f8:	c3                   	ret    

000000f9 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f9:	f3 0f 1e fb          	endbr32 
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	57                   	push   %edi
 101:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 104:	89 d7                	mov    %edx,%edi
 106:	8b 4d 10             	mov    0x10(%ebp),%ecx
 109:	8b 45 0c             	mov    0xc(%ebp),%eax
 10c:	fc                   	cld    
 10d:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 10f:	89 d0                	mov    %edx,%eax
 111:	5f                   	pop    %edi
 112:	5d                   	pop    %ebp
 113:	c3                   	ret    

00000114 <strchr>:

char*
strchr(const char *s, char c)
{
 114:	f3 0f 1e fb          	endbr32 
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 122:	0f b6 10             	movzbl (%eax),%edx
 125:	84 d2                	test   %dl,%dl
 127:	74 09                	je     132 <strchr+0x1e>
    if(*s == c)
 129:	38 ca                	cmp    %cl,%dl
 12b:	74 0a                	je     137 <strchr+0x23>
  for(; *s; s++)
 12d:	83 c0 01             	add    $0x1,%eax
 130:	eb f0                	jmp    122 <strchr+0xe>
      return (char*)s;
  return 0;
 132:	b8 00 00 00 00       	mov    $0x0,%eax
}
 137:	5d                   	pop    %ebp
 138:	c3                   	ret    

00000139 <gets>:

char*
gets(char *buf, int max)
{
 139:	f3 0f 1e fb          	endbr32 
 13d:	55                   	push   %ebp
 13e:	89 e5                	mov    %esp,%ebp
 140:	57                   	push   %edi
 141:	56                   	push   %esi
 142:	53                   	push   %ebx
 143:	83 ec 1c             	sub    $0x1c,%esp
 146:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 149:	bb 00 00 00 00       	mov    $0x0,%ebx
 14e:	89 de                	mov    %ebx,%esi
 150:	83 c3 01             	add    $0x1,%ebx
 153:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 156:	7d 2e                	jge    186 <gets+0x4d>
    cc = read(0, &c, 1);
 158:	83 ec 04             	sub    $0x4,%esp
 15b:	6a 01                	push   $0x1
 15d:	8d 45 e7             	lea    -0x19(%ebp),%eax
 160:	50                   	push   %eax
 161:	6a 00                	push   $0x0
 163:	e8 cf 01 00 00       	call   337 <read>
    if(cc < 1)
 168:	83 c4 10             	add    $0x10,%esp
 16b:	85 c0                	test   %eax,%eax
 16d:	7e 17                	jle    186 <gets+0x4d>
      break;
    buf[i++] = c;
 16f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 173:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 176:	3c 0a                	cmp    $0xa,%al
 178:	0f 94 c2             	sete   %dl
 17b:	3c 0d                	cmp    $0xd,%al
 17d:	0f 94 c0             	sete   %al
 180:	08 c2                	or     %al,%dl
 182:	74 ca                	je     14e <gets+0x15>
    buf[i++] = c;
 184:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 186:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 18a:	89 f8                	mov    %edi,%eax
 18c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 18f:	5b                   	pop    %ebx
 190:	5e                   	pop    %esi
 191:	5f                   	pop    %edi
 192:	5d                   	pop    %ebp
 193:	c3                   	ret    

00000194 <stat>:

int
stat(char *n, struct stat *st)
{
 194:	f3 0f 1e fb          	endbr32 
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	56                   	push   %esi
 19c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19d:	83 ec 08             	sub    $0x8,%esp
 1a0:	6a 00                	push   $0x0
 1a2:	ff 75 08             	pushl  0x8(%ebp)
 1a5:	e8 b5 01 00 00       	call   35f <open>
  if(fd < 0)
 1aa:	83 c4 10             	add    $0x10,%esp
 1ad:	85 c0                	test   %eax,%eax
 1af:	78 24                	js     1d5 <stat+0x41>
 1b1:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1b3:	83 ec 08             	sub    $0x8,%esp
 1b6:	ff 75 0c             	pushl  0xc(%ebp)
 1b9:	50                   	push   %eax
 1ba:	e8 b8 01 00 00       	call   377 <fstat>
 1bf:	89 c6                	mov    %eax,%esi
  close(fd);
 1c1:	89 1c 24             	mov    %ebx,(%esp)
 1c4:	e8 7e 01 00 00       	call   347 <close>
  return r;
 1c9:	83 c4 10             	add    $0x10,%esp
}
 1cc:	89 f0                	mov    %esi,%eax
 1ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1d1:	5b                   	pop    %ebx
 1d2:	5e                   	pop    %esi
 1d3:	5d                   	pop    %ebp
 1d4:	c3                   	ret    
    return -1;
 1d5:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1da:	eb f0                	jmp    1cc <stat+0x38>

000001dc <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 1dc:	f3 0f 1e fb          	endbr32 
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	57                   	push   %edi
 1e4:	56                   	push   %esi
 1e5:	53                   	push   %ebx
 1e6:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1e9:	0f b6 02             	movzbl (%edx),%eax
 1ec:	3c 20                	cmp    $0x20,%al
 1ee:	75 05                	jne    1f5 <atoi+0x19>
 1f0:	83 c2 01             	add    $0x1,%edx
 1f3:	eb f4                	jmp    1e9 <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 1f5:	3c 2d                	cmp    $0x2d,%al
 1f7:	74 1d                	je     216 <atoi+0x3a>
 1f9:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 1fe:	3c 2b                	cmp    $0x2b,%al
 200:	0f 94 c1             	sete   %cl
 203:	3c 2d                	cmp    $0x2d,%al
 205:	0f 94 c0             	sete   %al
 208:	08 c1                	or     %al,%cl
 20a:	74 03                	je     20f <atoi+0x33>
    s++;
 20c:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 20f:	b8 00 00 00 00       	mov    $0x0,%eax
 214:	eb 17                	jmp    22d <atoi+0x51>
 216:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 21b:	eb e1                	jmp    1fe <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 21d:	8d 34 80             	lea    (%eax,%eax,4),%esi
 220:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 223:	83 c2 01             	add    $0x1,%edx
 226:	0f be c9             	movsbl %cl,%ecx
 229:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 22d:	0f b6 0a             	movzbl (%edx),%ecx
 230:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 233:	80 fb 09             	cmp    $0x9,%bl
 236:	76 e5                	jbe    21d <atoi+0x41>
  return sign*n;
 238:	0f af c7             	imul   %edi,%eax
}
 23b:	5b                   	pop    %ebx
 23c:	5e                   	pop    %esi
 23d:	5f                   	pop    %edi
 23e:	5d                   	pop    %ebp
 23f:	c3                   	ret    

00000240 <atoo>:

int
atoo(const char *s)
{
 240:	f3 0f 1e fb          	endbr32 
 244:	55                   	push   %ebp
 245:	89 e5                	mov    %esp,%ebp
 247:	57                   	push   %edi
 248:	56                   	push   %esi
 249:	53                   	push   %ebx
 24a:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 24d:	0f b6 0a             	movzbl (%edx),%ecx
 250:	80 f9 20             	cmp    $0x20,%cl
 253:	75 05                	jne    25a <atoo+0x1a>
 255:	83 c2 01             	add    $0x1,%edx
 258:	eb f3                	jmp    24d <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 25a:	80 f9 2d             	cmp    $0x2d,%cl
 25d:	74 23                	je     282 <atoo+0x42>
 25f:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 264:	80 f9 2b             	cmp    $0x2b,%cl
 267:	0f 94 c0             	sete   %al
 26a:	89 c6                	mov    %eax,%esi
 26c:	80 f9 2d             	cmp    $0x2d,%cl
 26f:	0f 94 c0             	sete   %al
 272:	89 f3                	mov    %esi,%ebx
 274:	08 c3                	or     %al,%bl
 276:	74 03                	je     27b <atoo+0x3b>
    s++;
 278:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 27b:	b8 00 00 00 00       	mov    $0x0,%eax
 280:	eb 11                	jmp    293 <atoo+0x53>
 282:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 287:	eb db                	jmp    264 <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 289:	83 c2 01             	add    $0x1,%edx
 28c:	0f be c9             	movsbl %cl,%ecx
 28f:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 293:	0f b6 0a             	movzbl (%edx),%ecx
 296:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 299:	80 fb 07             	cmp    $0x7,%bl
 29c:	76 eb                	jbe    289 <atoo+0x49>
  return sign*n;
 29e:	0f af c7             	imul   %edi,%eax
}
 2a1:	5b                   	pop    %ebx
 2a2:	5e                   	pop    %esi
 2a3:	5f                   	pop    %edi
 2a4:	5d                   	pop    %ebp
 2a5:	c3                   	ret    

000002a6 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 2a6:	f3 0f 1e fb          	endbr32 
 2aa:	55                   	push   %ebp
 2ab:	89 e5                	mov    %esp,%ebp
 2ad:	53                   	push   %ebx
 2ae:	8b 55 08             	mov    0x8(%ebp),%edx
 2b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2b4:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 2b7:	eb 09                	jmp    2c2 <strncmp+0x1c>
      n--, p++, q++;
 2b9:	83 e8 01             	sub    $0x1,%eax
 2bc:	83 c2 01             	add    $0x1,%edx
 2bf:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 2c2:	85 c0                	test   %eax,%eax
 2c4:	74 0b                	je     2d1 <strncmp+0x2b>
 2c6:	0f b6 1a             	movzbl (%edx),%ebx
 2c9:	84 db                	test   %bl,%bl
 2cb:	74 04                	je     2d1 <strncmp+0x2b>
 2cd:	3a 19                	cmp    (%ecx),%bl
 2cf:	74 e8                	je     2b9 <strncmp+0x13>
    if(n == 0)
 2d1:	85 c0                	test   %eax,%eax
 2d3:	74 0b                	je     2e0 <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 2d5:	0f b6 02             	movzbl (%edx),%eax
 2d8:	0f b6 11             	movzbl (%ecx),%edx
 2db:	29 d0                	sub    %edx,%eax
}
 2dd:	5b                   	pop    %ebx
 2de:	5d                   	pop    %ebp
 2df:	c3                   	ret    
      return 0;
 2e0:	b8 00 00 00 00       	mov    $0x0,%eax
 2e5:	eb f6                	jmp    2dd <strncmp+0x37>

000002e7 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 2e7:	f3 0f 1e fb          	endbr32 
 2eb:	55                   	push   %ebp
 2ec:	89 e5                	mov    %esp,%ebp
 2ee:	56                   	push   %esi
 2ef:	53                   	push   %ebx
 2f0:	8b 75 08             	mov    0x8(%ebp),%esi
 2f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2f6:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 2f9:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 2fb:	8d 58 ff             	lea    -0x1(%eax),%ebx
 2fe:	85 c0                	test   %eax,%eax
 300:	7e 0f                	jle    311 <memmove+0x2a>
    *dst++ = *src++;
 302:	0f b6 01             	movzbl (%ecx),%eax
 305:	88 02                	mov    %al,(%edx)
 307:	8d 49 01             	lea    0x1(%ecx),%ecx
 30a:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 30d:	89 d8                	mov    %ebx,%eax
 30f:	eb ea                	jmp    2fb <memmove+0x14>
  return vdst;
}
 311:	89 f0                	mov    %esi,%eax
 313:	5b                   	pop    %ebx
 314:	5e                   	pop    %esi
 315:	5d                   	pop    %ebp
 316:	c3                   	ret    

00000317 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 317:	b8 01 00 00 00       	mov    $0x1,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <exit>:
SYSCALL(exit)
 31f:	b8 02 00 00 00       	mov    $0x2,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <wait>:
SYSCALL(wait)
 327:	b8 03 00 00 00       	mov    $0x3,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <pipe>:
SYSCALL(pipe)
 32f:	b8 04 00 00 00       	mov    $0x4,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <read>:
SYSCALL(read)
 337:	b8 05 00 00 00       	mov    $0x5,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <write>:
SYSCALL(write)
 33f:	b8 10 00 00 00       	mov    $0x10,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <close>:
SYSCALL(close)
 347:	b8 15 00 00 00       	mov    $0x15,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <kill>:
SYSCALL(kill)
 34f:	b8 06 00 00 00       	mov    $0x6,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <exec>:
SYSCALL(exec)
 357:	b8 07 00 00 00       	mov    $0x7,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <open>:
SYSCALL(open)
 35f:	b8 0f 00 00 00       	mov    $0xf,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <mknod>:
SYSCALL(mknod)
 367:	b8 11 00 00 00       	mov    $0x11,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <unlink>:
SYSCALL(unlink)
 36f:	b8 12 00 00 00       	mov    $0x12,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <fstat>:
SYSCALL(fstat)
 377:	b8 08 00 00 00       	mov    $0x8,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <link>:
SYSCALL(link)
 37f:	b8 13 00 00 00       	mov    $0x13,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <mkdir>:
SYSCALL(mkdir)
 387:	b8 14 00 00 00       	mov    $0x14,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <chdir>:
SYSCALL(chdir)
 38f:	b8 09 00 00 00       	mov    $0x9,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <dup>:
SYSCALL(dup)
 397:	b8 0a 00 00 00       	mov    $0xa,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <getpid>:
SYSCALL(getpid)
 39f:	b8 0b 00 00 00       	mov    $0xb,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <sbrk>:
SYSCALL(sbrk)
 3a7:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <sleep>:
SYSCALL(sleep)
 3af:	b8 0d 00 00 00       	mov    $0xd,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <uptime>:
SYSCALL(uptime)
 3b7:	b8 0e 00 00 00       	mov    $0xe,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <halt>:
SYSCALL(halt)
 3bf:	b8 16 00 00 00       	mov    $0x16,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <cps>:
/* ____My changes____ */
SYSCALL(cps)
 3c7:	b8 17 00 00 00       	mov    $0x17,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <getppid>:
SYSCALL(getppid)
 3cf:	b8 18 00 00 00       	mov    $0x18,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <getsz>:
SYSCALL(getsz)
 3d7:	b8 19 00 00 00       	mov    $0x19,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <chpr>:
SYSCALL(chpr)
 3df:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <getcount>:
SYSCALL(getcount)
 3e7:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <time>:
SYSCALL(time)
 3ef:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <utctime>:
SYSCALL(utctime)
 3f7:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret    

000003ff <dup2>:
SYSCALL(dup2)
 3ff:	b8 1e 00 00 00       	mov    $0x1e,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret    

00000407 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 407:	55                   	push   %ebp
 408:	89 e5                	mov    %esp,%ebp
 40a:	83 ec 1c             	sub    $0x1c,%esp
 40d:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 410:	6a 01                	push   $0x1
 412:	8d 55 f4             	lea    -0xc(%ebp),%edx
 415:	52                   	push   %edx
 416:	50                   	push   %eax
 417:	e8 23 ff ff ff       	call   33f <write>
}
 41c:	83 c4 10             	add    $0x10,%esp
 41f:	c9                   	leave  
 420:	c3                   	ret    

00000421 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 421:	55                   	push   %ebp
 422:	89 e5                	mov    %esp,%ebp
 424:	57                   	push   %edi
 425:	56                   	push   %esi
 426:	53                   	push   %ebx
 427:	83 ec 2c             	sub    $0x2c,%esp
 42a:	89 45 d0             	mov    %eax,-0x30(%ebp)
 42d:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 42f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 433:	0f 95 c2             	setne  %dl
 436:	89 f0                	mov    %esi,%eax
 438:	c1 e8 1f             	shr    $0x1f,%eax
 43b:	84 c2                	test   %al,%dl
 43d:	74 42                	je     481 <printint+0x60>
    neg = 1;
    x = -xx;
 43f:	f7 de                	neg    %esi
    neg = 1;
 441:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 448:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 44d:	89 f0                	mov    %esi,%eax
 44f:	ba 00 00 00 00       	mov    $0x0,%edx
 454:	f7 f1                	div    %ecx
 456:	89 df                	mov    %ebx,%edi
 458:	83 c3 01             	add    $0x1,%ebx
 45b:	0f b6 92 b0 07 00 00 	movzbl 0x7b0(%edx),%edx
 462:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 466:	89 f2                	mov    %esi,%edx
 468:	89 c6                	mov    %eax,%esi
 46a:	39 d1                	cmp    %edx,%ecx
 46c:	76 df                	jbe    44d <printint+0x2c>
  if(neg)
 46e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 472:	74 2f                	je     4a3 <printint+0x82>
    buf[i++] = '-';
 474:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 479:	8d 5f 02             	lea    0x2(%edi),%ebx
 47c:	8b 75 d0             	mov    -0x30(%ebp),%esi
 47f:	eb 15                	jmp    496 <printint+0x75>
  neg = 0;
 481:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 488:	eb be                	jmp    448 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 48a:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 48f:	89 f0                	mov    %esi,%eax
 491:	e8 71 ff ff ff       	call   407 <putc>
  while(--i >= 0)
 496:	83 eb 01             	sub    $0x1,%ebx
 499:	79 ef                	jns    48a <printint+0x69>
}
 49b:	83 c4 2c             	add    $0x2c,%esp
 49e:	5b                   	pop    %ebx
 49f:	5e                   	pop    %esi
 4a0:	5f                   	pop    %edi
 4a1:	5d                   	pop    %ebp
 4a2:	c3                   	ret    
 4a3:	8b 75 d0             	mov    -0x30(%ebp),%esi
 4a6:	eb ee                	jmp    496 <printint+0x75>

000004a8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4a8:	f3 0f 1e fb          	endbr32 
 4ac:	55                   	push   %ebp
 4ad:	89 e5                	mov    %esp,%ebp
 4af:	57                   	push   %edi
 4b0:	56                   	push   %esi
 4b1:	53                   	push   %ebx
 4b2:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4b5:	8d 45 10             	lea    0x10(%ebp),%eax
 4b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 4bb:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 4c0:	bb 00 00 00 00       	mov    $0x0,%ebx
 4c5:	eb 14                	jmp    4db <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4c7:	89 fa                	mov    %edi,%edx
 4c9:	8b 45 08             	mov    0x8(%ebp),%eax
 4cc:	e8 36 ff ff ff       	call   407 <putc>
 4d1:	eb 05                	jmp    4d8 <printf+0x30>
      }
    } else if(state == '%'){
 4d3:	83 fe 25             	cmp    $0x25,%esi
 4d6:	74 25                	je     4fd <printf+0x55>
  for(i = 0; fmt[i]; i++){
 4d8:	83 c3 01             	add    $0x1,%ebx
 4db:	8b 45 0c             	mov    0xc(%ebp),%eax
 4de:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 4e2:	84 c0                	test   %al,%al
 4e4:	0f 84 23 01 00 00    	je     60d <printf+0x165>
    c = fmt[i] & 0xff;
 4ea:	0f be f8             	movsbl %al,%edi
 4ed:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 4f0:	85 f6                	test   %esi,%esi
 4f2:	75 df                	jne    4d3 <printf+0x2b>
      if(c == '%'){
 4f4:	83 f8 25             	cmp    $0x25,%eax
 4f7:	75 ce                	jne    4c7 <printf+0x1f>
        state = '%';
 4f9:	89 c6                	mov    %eax,%esi
 4fb:	eb db                	jmp    4d8 <printf+0x30>
      if(c == 'd'){
 4fd:	83 f8 64             	cmp    $0x64,%eax
 500:	74 49                	je     54b <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 502:	83 f8 78             	cmp    $0x78,%eax
 505:	0f 94 c1             	sete   %cl
 508:	83 f8 70             	cmp    $0x70,%eax
 50b:	0f 94 c2             	sete   %dl
 50e:	08 d1                	or     %dl,%cl
 510:	75 63                	jne    575 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 512:	83 f8 73             	cmp    $0x73,%eax
 515:	0f 84 84 00 00 00    	je     59f <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 51b:	83 f8 63             	cmp    $0x63,%eax
 51e:	0f 84 b7 00 00 00    	je     5db <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 524:	83 f8 25             	cmp    $0x25,%eax
 527:	0f 84 cc 00 00 00    	je     5f9 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 52d:	ba 25 00 00 00       	mov    $0x25,%edx
 532:	8b 45 08             	mov    0x8(%ebp),%eax
 535:	e8 cd fe ff ff       	call   407 <putc>
        putc(fd, c);
 53a:	89 fa                	mov    %edi,%edx
 53c:	8b 45 08             	mov    0x8(%ebp),%eax
 53f:	e8 c3 fe ff ff       	call   407 <putc>
      }
      state = 0;
 544:	be 00 00 00 00       	mov    $0x0,%esi
 549:	eb 8d                	jmp    4d8 <printf+0x30>
        printint(fd, *ap, 10, 1);
 54b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 54e:	8b 17                	mov    (%edi),%edx
 550:	83 ec 0c             	sub    $0xc,%esp
 553:	6a 01                	push   $0x1
 555:	b9 0a 00 00 00       	mov    $0xa,%ecx
 55a:	8b 45 08             	mov    0x8(%ebp),%eax
 55d:	e8 bf fe ff ff       	call   421 <printint>
        ap++;
 562:	83 c7 04             	add    $0x4,%edi
 565:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 568:	83 c4 10             	add    $0x10,%esp
      state = 0;
 56b:	be 00 00 00 00       	mov    $0x0,%esi
 570:	e9 63 ff ff ff       	jmp    4d8 <printf+0x30>
        printint(fd, *ap, 16, 0);
 575:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 578:	8b 17                	mov    (%edi),%edx
 57a:	83 ec 0c             	sub    $0xc,%esp
 57d:	6a 00                	push   $0x0
 57f:	b9 10 00 00 00       	mov    $0x10,%ecx
 584:	8b 45 08             	mov    0x8(%ebp),%eax
 587:	e8 95 fe ff ff       	call   421 <printint>
        ap++;
 58c:	83 c7 04             	add    $0x4,%edi
 58f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 592:	83 c4 10             	add    $0x10,%esp
      state = 0;
 595:	be 00 00 00 00       	mov    $0x0,%esi
 59a:	e9 39 ff ff ff       	jmp    4d8 <printf+0x30>
        s = (char*)*ap;
 59f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a2:	8b 30                	mov    (%eax),%esi
        ap++;
 5a4:	83 c0 04             	add    $0x4,%eax
 5a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 5aa:	85 f6                	test   %esi,%esi
 5ac:	75 28                	jne    5d6 <printf+0x12e>
          s = "(null)";
 5ae:	be a7 07 00 00       	mov    $0x7a7,%esi
 5b3:	8b 7d 08             	mov    0x8(%ebp),%edi
 5b6:	eb 0d                	jmp    5c5 <printf+0x11d>
          putc(fd, *s);
 5b8:	0f be d2             	movsbl %dl,%edx
 5bb:	89 f8                	mov    %edi,%eax
 5bd:	e8 45 fe ff ff       	call   407 <putc>
          s++;
 5c2:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 5c5:	0f b6 16             	movzbl (%esi),%edx
 5c8:	84 d2                	test   %dl,%dl
 5ca:	75 ec                	jne    5b8 <printf+0x110>
      state = 0;
 5cc:	be 00 00 00 00       	mov    $0x0,%esi
 5d1:	e9 02 ff ff ff       	jmp    4d8 <printf+0x30>
 5d6:	8b 7d 08             	mov    0x8(%ebp),%edi
 5d9:	eb ea                	jmp    5c5 <printf+0x11d>
        putc(fd, *ap);
 5db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5de:	0f be 17             	movsbl (%edi),%edx
 5e1:	8b 45 08             	mov    0x8(%ebp),%eax
 5e4:	e8 1e fe ff ff       	call   407 <putc>
        ap++;
 5e9:	83 c7 04             	add    $0x4,%edi
 5ec:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 5ef:	be 00 00 00 00       	mov    $0x0,%esi
 5f4:	e9 df fe ff ff       	jmp    4d8 <printf+0x30>
        putc(fd, c);
 5f9:	89 fa                	mov    %edi,%edx
 5fb:	8b 45 08             	mov    0x8(%ebp),%eax
 5fe:	e8 04 fe ff ff       	call   407 <putc>
      state = 0;
 603:	be 00 00 00 00       	mov    $0x0,%esi
 608:	e9 cb fe ff ff       	jmp    4d8 <printf+0x30>
    }
  }
}
 60d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 610:	5b                   	pop    %ebx
 611:	5e                   	pop    %esi
 612:	5f                   	pop    %edi
 613:	5d                   	pop    %ebp
 614:	c3                   	ret    

00000615 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 615:	f3 0f 1e fb          	endbr32 
 619:	55                   	push   %ebp
 61a:	89 e5                	mov    %esp,%ebp
 61c:	57                   	push   %edi
 61d:	56                   	push   %esi
 61e:	53                   	push   %ebx
 61f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 622:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 625:	a1 b4 0a 00 00       	mov    0xab4,%eax
 62a:	eb 02                	jmp    62e <free+0x19>
 62c:	89 d0                	mov    %edx,%eax
 62e:	39 c8                	cmp    %ecx,%eax
 630:	73 04                	jae    636 <free+0x21>
 632:	39 08                	cmp    %ecx,(%eax)
 634:	77 12                	ja     648 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 636:	8b 10                	mov    (%eax),%edx
 638:	39 c2                	cmp    %eax,%edx
 63a:	77 f0                	ja     62c <free+0x17>
 63c:	39 c8                	cmp    %ecx,%eax
 63e:	72 08                	jb     648 <free+0x33>
 640:	39 ca                	cmp    %ecx,%edx
 642:	77 04                	ja     648 <free+0x33>
 644:	89 d0                	mov    %edx,%eax
 646:	eb e6                	jmp    62e <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 648:	8b 73 fc             	mov    -0x4(%ebx),%esi
 64b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 64e:	8b 10                	mov    (%eax),%edx
 650:	39 d7                	cmp    %edx,%edi
 652:	74 19                	je     66d <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 654:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 657:	8b 50 04             	mov    0x4(%eax),%edx
 65a:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 65d:	39 ce                	cmp    %ecx,%esi
 65f:	74 1b                	je     67c <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 661:	89 08                	mov    %ecx,(%eax)
  freep = p;
 663:	a3 b4 0a 00 00       	mov    %eax,0xab4
}
 668:	5b                   	pop    %ebx
 669:	5e                   	pop    %esi
 66a:	5f                   	pop    %edi
 66b:	5d                   	pop    %ebp
 66c:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 66d:	03 72 04             	add    0x4(%edx),%esi
 670:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 673:	8b 10                	mov    (%eax),%edx
 675:	8b 12                	mov    (%edx),%edx
 677:	89 53 f8             	mov    %edx,-0x8(%ebx)
 67a:	eb db                	jmp    657 <free+0x42>
    p->s.size += bp->s.size;
 67c:	03 53 fc             	add    -0x4(%ebx),%edx
 67f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 682:	8b 53 f8             	mov    -0x8(%ebx),%edx
 685:	89 10                	mov    %edx,(%eax)
 687:	eb da                	jmp    663 <free+0x4e>

00000689 <morecore>:

static Header*
morecore(uint nu)
{
 689:	55                   	push   %ebp
 68a:	89 e5                	mov    %esp,%ebp
 68c:	53                   	push   %ebx
 68d:	83 ec 04             	sub    $0x4,%esp
 690:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 692:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 697:	77 05                	ja     69e <morecore+0x15>
    nu = 4096;
 699:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 69e:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 6a5:	83 ec 0c             	sub    $0xc,%esp
 6a8:	50                   	push   %eax
 6a9:	e8 f9 fc ff ff       	call   3a7 <sbrk>
  if(p == (char*)-1)
 6ae:	83 c4 10             	add    $0x10,%esp
 6b1:	83 f8 ff             	cmp    $0xffffffff,%eax
 6b4:	74 1c                	je     6d2 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6b6:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6b9:	83 c0 08             	add    $0x8,%eax
 6bc:	83 ec 0c             	sub    $0xc,%esp
 6bf:	50                   	push   %eax
 6c0:	e8 50 ff ff ff       	call   615 <free>
  return freep;
 6c5:	a1 b4 0a 00 00       	mov    0xab4,%eax
 6ca:	83 c4 10             	add    $0x10,%esp
}
 6cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6d0:	c9                   	leave  
 6d1:	c3                   	ret    
    return 0;
 6d2:	b8 00 00 00 00       	mov    $0x0,%eax
 6d7:	eb f4                	jmp    6cd <morecore+0x44>

000006d9 <malloc>:

void*
malloc(uint nbytes)
{
 6d9:	f3 0f 1e fb          	endbr32 
 6dd:	55                   	push   %ebp
 6de:	89 e5                	mov    %esp,%ebp
 6e0:	53                   	push   %ebx
 6e1:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e4:	8b 45 08             	mov    0x8(%ebp),%eax
 6e7:	8d 58 07             	lea    0x7(%eax),%ebx
 6ea:	c1 eb 03             	shr    $0x3,%ebx
 6ed:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6f0:	8b 0d b4 0a 00 00    	mov    0xab4,%ecx
 6f6:	85 c9                	test   %ecx,%ecx
 6f8:	74 04                	je     6fe <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6fa:	8b 01                	mov    (%ecx),%eax
 6fc:	eb 4b                	jmp    749 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 6fe:	c7 05 b4 0a 00 00 b8 	movl   $0xab8,0xab4
 705:	0a 00 00 
 708:	c7 05 b8 0a 00 00 b8 	movl   $0xab8,0xab8
 70f:	0a 00 00 
    base.s.size = 0;
 712:	c7 05 bc 0a 00 00 00 	movl   $0x0,0xabc
 719:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 71c:	b9 b8 0a 00 00       	mov    $0xab8,%ecx
 721:	eb d7                	jmp    6fa <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 723:	74 1a                	je     73f <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 725:	29 da                	sub    %ebx,%edx
 727:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 72a:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 72d:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 730:	89 0d b4 0a 00 00    	mov    %ecx,0xab4
      return (void*)(p + 1);
 736:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 739:	83 c4 04             	add    $0x4,%esp
 73c:	5b                   	pop    %ebx
 73d:	5d                   	pop    %ebp
 73e:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 73f:	8b 10                	mov    (%eax),%edx
 741:	89 11                	mov    %edx,(%ecx)
 743:	eb eb                	jmp    730 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 745:	89 c1                	mov    %eax,%ecx
 747:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 749:	8b 50 04             	mov    0x4(%eax),%edx
 74c:	39 da                	cmp    %ebx,%edx
 74e:	73 d3                	jae    723 <malloc+0x4a>
    if(p == freep)
 750:	39 05 b4 0a 00 00    	cmp    %eax,0xab4
 756:	75 ed                	jne    745 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 758:	89 d8                	mov    %ebx,%eax
 75a:	e8 2a ff ff ff       	call   689 <morecore>
 75f:	85 c0                	test   %eax,%eax
 761:	75 e2                	jne    745 <malloc+0x6c>
 763:	eb d4                	jmp    739 <malloc+0x60>
