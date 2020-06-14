
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	57                   	push   %edi
   8:	56                   	push   %esi
   9:	53                   	push   %ebx
   a:	83 ec 1c             	sub    $0x1c,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
   d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  l = w = c = 0;
  14:	be 00 00 00 00       	mov    $0x0,%esi
  19:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  20:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	68 00 02 00 00       	push   $0x200
  2f:	68 e0 0b 00 00       	push   $0xbe0
  34:	ff 75 08             	pushl  0x8(%ebp)
  37:	e8 dc 03 00 00       	call   418 <read>
  3c:	89 c7                	mov    %eax,%edi
  3e:	83 c4 10             	add    $0x10,%esp
  41:	85 c0                	test   %eax,%eax
  43:	7e 54                	jle    99 <wc+0x99>
    for(i=0; i<n; i++){
  45:	bb 00 00 00 00       	mov    $0x0,%ebx
  4a:	eb 22                	jmp    6e <wc+0x6e>
      c++;
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  4c:	83 ec 08             	sub    $0x8,%esp
  4f:	0f be c0             	movsbl %al,%eax
  52:	50                   	push   %eax
  53:	68 48 08 00 00       	push   $0x848
  58:	e8 98 01 00 00       	call   1f5 <strchr>
  5d:	83 c4 10             	add    $0x10,%esp
  60:	85 c0                	test   %eax,%eax
  62:	74 22                	je     86 <wc+0x86>
        inword = 0;
  64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    for(i=0; i<n; i++){
  6b:	83 c3 01             	add    $0x1,%ebx
  6e:	39 fb                	cmp    %edi,%ebx
  70:	7d b5                	jge    27 <wc+0x27>
      c++;
  72:	83 c6 01             	add    $0x1,%esi
      if(buf[i] == '\n')
  75:	0f b6 83 e0 0b 00 00 	movzbl 0xbe0(%ebx),%eax
  7c:	3c 0a                	cmp    $0xa,%al
  7e:	75 cc                	jne    4c <wc+0x4c>
        l++;
  80:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  84:	eb c6                	jmp    4c <wc+0x4c>
      else if(!inword){
  86:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8a:	75 df                	jne    6b <wc+0x6b>
        w++;
  8c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
        inword = 1;
  90:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  97:	eb d2                	jmp    6b <wc+0x6b>
      }
    }
  }
  if(n < 0){
  99:	78 24                	js     bf <wc+0xbf>
    printf(1, "wc: read error\n");
    exit();
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  9b:	83 ec 08             	sub    $0x8,%esp
  9e:	ff 75 0c             	pushl  0xc(%ebp)
  a1:	56                   	push   %esi
  a2:	ff 75 dc             	pushl  -0x24(%ebp)
  a5:	ff 75 e0             	pushl  -0x20(%ebp)
  a8:	68 5e 08 00 00       	push   $0x85e
  ad:	6a 01                	push   $0x1
  af:	e8 d5 04 00 00       	call   589 <printf>
}
  b4:	83 c4 20             	add    $0x20,%esp
  b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ba:	5b                   	pop    %ebx
  bb:	5e                   	pop    %esi
  bc:	5f                   	pop    %edi
  bd:	5d                   	pop    %ebp
  be:	c3                   	ret    
    printf(1, "wc: read error\n");
  bf:	83 ec 08             	sub    $0x8,%esp
  c2:	68 4e 08 00 00       	push   $0x84e
  c7:	6a 01                	push   $0x1
  c9:	e8 bb 04 00 00       	call   589 <printf>
    exit();
  ce:	e8 2d 03 00 00       	call   400 <exit>

000000d3 <main>:

int
main(int argc, char *argv[])
{
  d3:	f3 0f 1e fb          	endbr32 
  d7:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  db:	83 e4 f0             	and    $0xfffffff0,%esp
  de:	ff 71 fc             	pushl  -0x4(%ecx)
  e1:	55                   	push   %ebp
  e2:	89 e5                	mov    %esp,%ebp
  e4:	57                   	push   %edi
  e5:	56                   	push   %esi
  e6:	53                   	push   %ebx
  e7:	51                   	push   %ecx
  e8:	83 ec 18             	sub    $0x18,%esp
  eb:	8b 01                	mov    (%ecx),%eax
  ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  f0:	8b 51 04             	mov    0x4(%ecx),%edx
  f3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  int fd, i;

  if(argc <= 1){
  f6:	83 f8 01             	cmp    $0x1,%eax
  f9:	7e 40                	jle    13b <main+0x68>
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
  fb:	be 01 00 00 00       	mov    $0x1,%esi
 100:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
 103:	7d 60                	jge    165 <main+0x92>
    if((fd = open(argv[i], 0)) < 0){
 105:	8b 45 e0             	mov    -0x20(%ebp),%eax
 108:	8d 3c b0             	lea    (%eax,%esi,4),%edi
 10b:	83 ec 08             	sub    $0x8,%esp
 10e:	6a 00                	push   $0x0
 110:	ff 37                	pushl  (%edi)
 112:	e8 29 03 00 00       	call   440 <open>
 117:	89 c3                	mov    %eax,%ebx
 119:	83 c4 10             	add    $0x10,%esp
 11c:	85 c0                	test   %eax,%eax
 11e:	78 2f                	js     14f <main+0x7c>
      printf(1, "wc: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
 120:	83 ec 08             	sub    $0x8,%esp
 123:	ff 37                	pushl  (%edi)
 125:	50                   	push   %eax
 126:	e8 d5 fe ff ff       	call   0 <wc>
    close(fd);
 12b:	89 1c 24             	mov    %ebx,(%esp)
 12e:	e8 f5 02 00 00       	call   428 <close>
  for(i = 1; i < argc; i++){
 133:	83 c6 01             	add    $0x1,%esi
 136:	83 c4 10             	add    $0x10,%esp
 139:	eb c5                	jmp    100 <main+0x2d>
    wc(0, "");
 13b:	83 ec 08             	sub    $0x8,%esp
 13e:	68 5d 08 00 00       	push   $0x85d
 143:	6a 00                	push   $0x0
 145:	e8 b6 fe ff ff       	call   0 <wc>
    exit();
 14a:	e8 b1 02 00 00       	call   400 <exit>
      printf(1, "wc: cannot open %s\n", argv[i]);
 14f:	83 ec 04             	sub    $0x4,%esp
 152:	ff 37                	pushl  (%edi)
 154:	68 6b 08 00 00       	push   $0x86b
 159:	6a 01                	push   $0x1
 15b:	e8 29 04 00 00       	call   589 <printf>
      exit();
 160:	e8 9b 02 00 00       	call   400 <exit>
  }
  exit();
 165:	e8 96 02 00 00       	call   400 <exit>

0000016a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 16a:	f3 0f 1e fb          	endbr32 
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	56                   	push   %esi
 172:	53                   	push   %ebx
 173:	8b 75 08             	mov    0x8(%ebp),%esi
 176:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 179:	89 f0                	mov    %esi,%eax
 17b:	89 d1                	mov    %edx,%ecx
 17d:	83 c2 01             	add    $0x1,%edx
 180:	89 c3                	mov    %eax,%ebx
 182:	83 c0 01             	add    $0x1,%eax
 185:	0f b6 09             	movzbl (%ecx),%ecx
 188:	88 0b                	mov    %cl,(%ebx)
 18a:	84 c9                	test   %cl,%cl
 18c:	75 ed                	jne    17b <strcpy+0x11>
    ;
  return os;
}
 18e:	89 f0                	mov    %esi,%eax
 190:	5b                   	pop    %ebx
 191:	5e                   	pop    %esi
 192:	5d                   	pop    %ebp
 193:	c3                   	ret    

00000194 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 194:	f3 0f 1e fb          	endbr32 
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 19e:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 1a1:	0f b6 01             	movzbl (%ecx),%eax
 1a4:	84 c0                	test   %al,%al
 1a6:	74 0c                	je     1b4 <strcmp+0x20>
 1a8:	3a 02                	cmp    (%edx),%al
 1aa:	75 08                	jne    1b4 <strcmp+0x20>
    p++, q++;
 1ac:	83 c1 01             	add    $0x1,%ecx
 1af:	83 c2 01             	add    $0x1,%edx
 1b2:	eb ed                	jmp    1a1 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 1b4:	0f b6 c0             	movzbl %al,%eax
 1b7:	0f b6 12             	movzbl (%edx),%edx
 1ba:	29 d0                	sub    %edx,%eax
}
 1bc:	5d                   	pop    %ebp
 1bd:	c3                   	ret    

000001be <strlen>:

uint
strlen(char *s)
{
 1be:	f3 0f 1e fb          	endbr32 
 1c2:	55                   	push   %ebp
 1c3:	89 e5                	mov    %esp,%ebp
 1c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1c8:	b8 00 00 00 00       	mov    $0x0,%eax
 1cd:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 1d1:	74 05                	je     1d8 <strlen+0x1a>
 1d3:	83 c0 01             	add    $0x1,%eax
 1d6:	eb f5                	jmp    1cd <strlen+0xf>
    ;
  return n;
}
 1d8:	5d                   	pop    %ebp
 1d9:	c3                   	ret    

000001da <memset>:

void*
memset(void *dst, int c, uint n)
{
 1da:	f3 0f 1e fb          	endbr32 
 1de:	55                   	push   %ebp
 1df:	89 e5                	mov    %esp,%ebp
 1e1:	57                   	push   %edi
 1e2:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1e5:	89 d7                	mov    %edx,%edi
 1e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ed:	fc                   	cld    
 1ee:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1f0:	89 d0                	mov    %edx,%eax
 1f2:	5f                   	pop    %edi
 1f3:	5d                   	pop    %ebp
 1f4:	c3                   	ret    

000001f5 <strchr>:

char*
strchr(const char *s, char c)
{
 1f5:	f3 0f 1e fb          	endbr32 
 1f9:	55                   	push   %ebp
 1fa:	89 e5                	mov    %esp,%ebp
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
 1ff:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 203:	0f b6 10             	movzbl (%eax),%edx
 206:	84 d2                	test   %dl,%dl
 208:	74 09                	je     213 <strchr+0x1e>
    if(*s == c)
 20a:	38 ca                	cmp    %cl,%dl
 20c:	74 0a                	je     218 <strchr+0x23>
  for(; *s; s++)
 20e:	83 c0 01             	add    $0x1,%eax
 211:	eb f0                	jmp    203 <strchr+0xe>
      return (char*)s;
  return 0;
 213:	b8 00 00 00 00       	mov    $0x0,%eax
}
 218:	5d                   	pop    %ebp
 219:	c3                   	ret    

0000021a <gets>:

char*
gets(char *buf, int max)
{
 21a:	f3 0f 1e fb          	endbr32 
 21e:	55                   	push   %ebp
 21f:	89 e5                	mov    %esp,%ebp
 221:	57                   	push   %edi
 222:	56                   	push   %esi
 223:	53                   	push   %ebx
 224:	83 ec 1c             	sub    $0x1c,%esp
 227:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22a:	bb 00 00 00 00       	mov    $0x0,%ebx
 22f:	89 de                	mov    %ebx,%esi
 231:	83 c3 01             	add    $0x1,%ebx
 234:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 237:	7d 2e                	jge    267 <gets+0x4d>
    cc = read(0, &c, 1);
 239:	83 ec 04             	sub    $0x4,%esp
 23c:	6a 01                	push   $0x1
 23e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 241:	50                   	push   %eax
 242:	6a 00                	push   $0x0
 244:	e8 cf 01 00 00       	call   418 <read>
    if(cc < 1)
 249:	83 c4 10             	add    $0x10,%esp
 24c:	85 c0                	test   %eax,%eax
 24e:	7e 17                	jle    267 <gets+0x4d>
      break;
    buf[i++] = c;
 250:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 254:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 257:	3c 0a                	cmp    $0xa,%al
 259:	0f 94 c2             	sete   %dl
 25c:	3c 0d                	cmp    $0xd,%al
 25e:	0f 94 c0             	sete   %al
 261:	08 c2                	or     %al,%dl
 263:	74 ca                	je     22f <gets+0x15>
    buf[i++] = c;
 265:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 267:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 26b:	89 f8                	mov    %edi,%eax
 26d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 270:	5b                   	pop    %ebx
 271:	5e                   	pop    %esi
 272:	5f                   	pop    %edi
 273:	5d                   	pop    %ebp
 274:	c3                   	ret    

00000275 <stat>:

int
stat(char *n, struct stat *st)
{
 275:	f3 0f 1e fb          	endbr32 
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
 27c:	56                   	push   %esi
 27d:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27e:	83 ec 08             	sub    $0x8,%esp
 281:	6a 00                	push   $0x0
 283:	ff 75 08             	pushl  0x8(%ebp)
 286:	e8 b5 01 00 00       	call   440 <open>
  if(fd < 0)
 28b:	83 c4 10             	add    $0x10,%esp
 28e:	85 c0                	test   %eax,%eax
 290:	78 24                	js     2b6 <stat+0x41>
 292:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 294:	83 ec 08             	sub    $0x8,%esp
 297:	ff 75 0c             	pushl  0xc(%ebp)
 29a:	50                   	push   %eax
 29b:	e8 b8 01 00 00       	call   458 <fstat>
 2a0:	89 c6                	mov    %eax,%esi
  close(fd);
 2a2:	89 1c 24             	mov    %ebx,(%esp)
 2a5:	e8 7e 01 00 00       	call   428 <close>
  return r;
 2aa:	83 c4 10             	add    $0x10,%esp
}
 2ad:	89 f0                	mov    %esi,%eax
 2af:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2b2:	5b                   	pop    %ebx
 2b3:	5e                   	pop    %esi
 2b4:	5d                   	pop    %ebp
 2b5:	c3                   	ret    
    return -1;
 2b6:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2bb:	eb f0                	jmp    2ad <stat+0x38>

000002bd <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 2bd:	f3 0f 1e fb          	endbr32 
 2c1:	55                   	push   %ebp
 2c2:	89 e5                	mov    %esp,%ebp
 2c4:	57                   	push   %edi
 2c5:	56                   	push   %esi
 2c6:	53                   	push   %ebx
 2c7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 2ca:	0f b6 02             	movzbl (%edx),%eax
 2cd:	3c 20                	cmp    $0x20,%al
 2cf:	75 05                	jne    2d6 <atoi+0x19>
 2d1:	83 c2 01             	add    $0x1,%edx
 2d4:	eb f4                	jmp    2ca <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 2d6:	3c 2d                	cmp    $0x2d,%al
 2d8:	74 1d                	je     2f7 <atoi+0x3a>
 2da:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 2df:	3c 2b                	cmp    $0x2b,%al
 2e1:	0f 94 c1             	sete   %cl
 2e4:	3c 2d                	cmp    $0x2d,%al
 2e6:	0f 94 c0             	sete   %al
 2e9:	08 c1                	or     %al,%cl
 2eb:	74 03                	je     2f0 <atoi+0x33>
    s++;
 2ed:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 2f0:	b8 00 00 00 00       	mov    $0x0,%eax
 2f5:	eb 17                	jmp    30e <atoi+0x51>
 2f7:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 2fc:	eb e1                	jmp    2df <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 2fe:	8d 34 80             	lea    (%eax,%eax,4),%esi
 301:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 304:	83 c2 01             	add    $0x1,%edx
 307:	0f be c9             	movsbl %cl,%ecx
 30a:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 30e:	0f b6 0a             	movzbl (%edx),%ecx
 311:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 314:	80 fb 09             	cmp    $0x9,%bl
 317:	76 e5                	jbe    2fe <atoi+0x41>
  return sign*n;
 319:	0f af c7             	imul   %edi,%eax
}
 31c:	5b                   	pop    %ebx
 31d:	5e                   	pop    %esi
 31e:	5f                   	pop    %edi
 31f:	5d                   	pop    %ebp
 320:	c3                   	ret    

00000321 <atoo>:

int
atoo(const char *s)
{
 321:	f3 0f 1e fb          	endbr32 
 325:	55                   	push   %ebp
 326:	89 e5                	mov    %esp,%ebp
 328:	57                   	push   %edi
 329:	56                   	push   %esi
 32a:	53                   	push   %ebx
 32b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 32e:	0f b6 0a             	movzbl (%edx),%ecx
 331:	80 f9 20             	cmp    $0x20,%cl
 334:	75 05                	jne    33b <atoo+0x1a>
 336:	83 c2 01             	add    $0x1,%edx
 339:	eb f3                	jmp    32e <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 33b:	80 f9 2d             	cmp    $0x2d,%cl
 33e:	74 23                	je     363 <atoo+0x42>
 340:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 345:	80 f9 2b             	cmp    $0x2b,%cl
 348:	0f 94 c0             	sete   %al
 34b:	89 c6                	mov    %eax,%esi
 34d:	80 f9 2d             	cmp    $0x2d,%cl
 350:	0f 94 c0             	sete   %al
 353:	89 f3                	mov    %esi,%ebx
 355:	08 c3                	or     %al,%bl
 357:	74 03                	je     35c <atoo+0x3b>
    s++;
 359:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 35c:	b8 00 00 00 00       	mov    $0x0,%eax
 361:	eb 11                	jmp    374 <atoo+0x53>
 363:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 368:	eb db                	jmp    345 <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 36a:	83 c2 01             	add    $0x1,%edx
 36d:	0f be c9             	movsbl %cl,%ecx
 370:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 374:	0f b6 0a             	movzbl (%edx),%ecx
 377:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 37a:	80 fb 07             	cmp    $0x7,%bl
 37d:	76 eb                	jbe    36a <atoo+0x49>
  return sign*n;
 37f:	0f af c7             	imul   %edi,%eax
}
 382:	5b                   	pop    %ebx
 383:	5e                   	pop    %esi
 384:	5f                   	pop    %edi
 385:	5d                   	pop    %ebp
 386:	c3                   	ret    

00000387 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 387:	f3 0f 1e fb          	endbr32 
 38b:	55                   	push   %ebp
 38c:	89 e5                	mov    %esp,%ebp
 38e:	53                   	push   %ebx
 38f:	8b 55 08             	mov    0x8(%ebp),%edx
 392:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 395:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 398:	eb 09                	jmp    3a3 <strncmp+0x1c>
      n--, p++, q++;
 39a:	83 e8 01             	sub    $0x1,%eax
 39d:	83 c2 01             	add    $0x1,%edx
 3a0:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 3a3:	85 c0                	test   %eax,%eax
 3a5:	74 0b                	je     3b2 <strncmp+0x2b>
 3a7:	0f b6 1a             	movzbl (%edx),%ebx
 3aa:	84 db                	test   %bl,%bl
 3ac:	74 04                	je     3b2 <strncmp+0x2b>
 3ae:	3a 19                	cmp    (%ecx),%bl
 3b0:	74 e8                	je     39a <strncmp+0x13>
    if(n == 0)
 3b2:	85 c0                	test   %eax,%eax
 3b4:	74 0b                	je     3c1 <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 3b6:	0f b6 02             	movzbl (%edx),%eax
 3b9:	0f b6 11             	movzbl (%ecx),%edx
 3bc:	29 d0                	sub    %edx,%eax
}
 3be:	5b                   	pop    %ebx
 3bf:	5d                   	pop    %ebp
 3c0:	c3                   	ret    
      return 0;
 3c1:	b8 00 00 00 00       	mov    $0x0,%eax
 3c6:	eb f6                	jmp    3be <strncmp+0x37>

000003c8 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 3c8:	f3 0f 1e fb          	endbr32 
 3cc:	55                   	push   %ebp
 3cd:	89 e5                	mov    %esp,%ebp
 3cf:	56                   	push   %esi
 3d0:	53                   	push   %ebx
 3d1:	8b 75 08             	mov    0x8(%ebp),%esi
 3d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 3d7:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 3da:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 3dc:	8d 58 ff             	lea    -0x1(%eax),%ebx
 3df:	85 c0                	test   %eax,%eax
 3e1:	7e 0f                	jle    3f2 <memmove+0x2a>
    *dst++ = *src++;
 3e3:	0f b6 01             	movzbl (%ecx),%eax
 3e6:	88 02                	mov    %al,(%edx)
 3e8:	8d 49 01             	lea    0x1(%ecx),%ecx
 3eb:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 3ee:	89 d8                	mov    %ebx,%eax
 3f0:	eb ea                	jmp    3dc <memmove+0x14>
  return vdst;
}
 3f2:	89 f0                	mov    %esi,%eax
 3f4:	5b                   	pop    %ebx
 3f5:	5e                   	pop    %esi
 3f6:	5d                   	pop    %ebp
 3f7:	c3                   	ret    

000003f8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3f8:	b8 01 00 00 00       	mov    $0x1,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <exit>:
SYSCALL(exit)
 400:	b8 02 00 00 00       	mov    $0x2,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <wait>:
SYSCALL(wait)
 408:	b8 03 00 00 00       	mov    $0x3,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <pipe>:
SYSCALL(pipe)
 410:	b8 04 00 00 00       	mov    $0x4,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <read>:
SYSCALL(read)
 418:	b8 05 00 00 00       	mov    $0x5,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <write>:
SYSCALL(write)
 420:	b8 10 00 00 00       	mov    $0x10,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <close>:
SYSCALL(close)
 428:	b8 15 00 00 00       	mov    $0x15,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <kill>:
SYSCALL(kill)
 430:	b8 06 00 00 00       	mov    $0x6,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <exec>:
SYSCALL(exec)
 438:	b8 07 00 00 00       	mov    $0x7,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <open>:
SYSCALL(open)
 440:	b8 0f 00 00 00       	mov    $0xf,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <mknod>:
SYSCALL(mknod)
 448:	b8 11 00 00 00       	mov    $0x11,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <unlink>:
SYSCALL(unlink)
 450:	b8 12 00 00 00       	mov    $0x12,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <fstat>:
SYSCALL(fstat)
 458:	b8 08 00 00 00       	mov    $0x8,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <link>:
SYSCALL(link)
 460:	b8 13 00 00 00       	mov    $0x13,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <mkdir>:
SYSCALL(mkdir)
 468:	b8 14 00 00 00       	mov    $0x14,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <chdir>:
SYSCALL(chdir)
 470:	b8 09 00 00 00       	mov    $0x9,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <dup>:
SYSCALL(dup)
 478:	b8 0a 00 00 00       	mov    $0xa,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <getpid>:
SYSCALL(getpid)
 480:	b8 0b 00 00 00       	mov    $0xb,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <sbrk>:
SYSCALL(sbrk)
 488:	b8 0c 00 00 00       	mov    $0xc,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <sleep>:
SYSCALL(sleep)
 490:	b8 0d 00 00 00       	mov    $0xd,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <uptime>:
SYSCALL(uptime)
 498:	b8 0e 00 00 00       	mov    $0xe,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <halt>:
SYSCALL(halt)
 4a0:	b8 16 00 00 00       	mov    $0x16,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <cps>:
/* ____My changes____ */
SYSCALL(cps)
 4a8:	b8 17 00 00 00       	mov    $0x17,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <getppid>:
SYSCALL(getppid)
 4b0:	b8 18 00 00 00       	mov    $0x18,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <getsz>:
SYSCALL(getsz)
 4b8:	b8 19 00 00 00       	mov    $0x19,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <chpr>:
SYSCALL(chpr)
 4c0:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <getcount>:
SYSCALL(getcount)
 4c8:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <time>:
SYSCALL(time)
 4d0:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <utctime>:
SYSCALL(utctime)
 4d8:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <dup2>:
SYSCALL(dup2)
 4e0:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4e8:	55                   	push   %ebp
 4e9:	89 e5                	mov    %esp,%ebp
 4eb:	83 ec 1c             	sub    $0x1c,%esp
 4ee:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 4f1:	6a 01                	push   $0x1
 4f3:	8d 55 f4             	lea    -0xc(%ebp),%edx
 4f6:	52                   	push   %edx
 4f7:	50                   	push   %eax
 4f8:	e8 23 ff ff ff       	call   420 <write>
}
 4fd:	83 c4 10             	add    $0x10,%esp
 500:	c9                   	leave  
 501:	c3                   	ret    

00000502 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 502:	55                   	push   %ebp
 503:	89 e5                	mov    %esp,%ebp
 505:	57                   	push   %edi
 506:	56                   	push   %esi
 507:	53                   	push   %ebx
 508:	83 ec 2c             	sub    $0x2c,%esp
 50b:	89 45 d0             	mov    %eax,-0x30(%ebp)
 50e:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 510:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 514:	0f 95 c2             	setne  %dl
 517:	89 f0                	mov    %esi,%eax
 519:	c1 e8 1f             	shr    $0x1f,%eax
 51c:	84 c2                	test   %al,%dl
 51e:	74 42                	je     562 <printint+0x60>
    neg = 1;
    x = -xx;
 520:	f7 de                	neg    %esi
    neg = 1;
 522:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 529:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 52e:	89 f0                	mov    %esi,%eax
 530:	ba 00 00 00 00       	mov    $0x0,%edx
 535:	f7 f1                	div    %ecx
 537:	89 df                	mov    %ebx,%edi
 539:	83 c3 01             	add    $0x1,%ebx
 53c:	0f b6 92 88 08 00 00 	movzbl 0x888(%edx),%edx
 543:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 547:	89 f2                	mov    %esi,%edx
 549:	89 c6                	mov    %eax,%esi
 54b:	39 d1                	cmp    %edx,%ecx
 54d:	76 df                	jbe    52e <printint+0x2c>
  if(neg)
 54f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 553:	74 2f                	je     584 <printint+0x82>
    buf[i++] = '-';
 555:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 55a:	8d 5f 02             	lea    0x2(%edi),%ebx
 55d:	8b 75 d0             	mov    -0x30(%ebp),%esi
 560:	eb 15                	jmp    577 <printint+0x75>
  neg = 0;
 562:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 569:	eb be                	jmp    529 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 56b:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 570:	89 f0                	mov    %esi,%eax
 572:	e8 71 ff ff ff       	call   4e8 <putc>
  while(--i >= 0)
 577:	83 eb 01             	sub    $0x1,%ebx
 57a:	79 ef                	jns    56b <printint+0x69>
}
 57c:	83 c4 2c             	add    $0x2c,%esp
 57f:	5b                   	pop    %ebx
 580:	5e                   	pop    %esi
 581:	5f                   	pop    %edi
 582:	5d                   	pop    %ebp
 583:	c3                   	ret    
 584:	8b 75 d0             	mov    -0x30(%ebp),%esi
 587:	eb ee                	jmp    577 <printint+0x75>

00000589 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 589:	f3 0f 1e fb          	endbr32 
 58d:	55                   	push   %ebp
 58e:	89 e5                	mov    %esp,%ebp
 590:	57                   	push   %edi
 591:	56                   	push   %esi
 592:	53                   	push   %ebx
 593:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 596:	8d 45 10             	lea    0x10(%ebp),%eax
 599:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 59c:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 5a1:	bb 00 00 00 00       	mov    $0x0,%ebx
 5a6:	eb 14                	jmp    5bc <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 5a8:	89 fa                	mov    %edi,%edx
 5aa:	8b 45 08             	mov    0x8(%ebp),%eax
 5ad:	e8 36 ff ff ff       	call   4e8 <putc>
 5b2:	eb 05                	jmp    5b9 <printf+0x30>
      }
    } else if(state == '%'){
 5b4:	83 fe 25             	cmp    $0x25,%esi
 5b7:	74 25                	je     5de <printf+0x55>
  for(i = 0; fmt[i]; i++){
 5b9:	83 c3 01             	add    $0x1,%ebx
 5bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 5bf:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 5c3:	84 c0                	test   %al,%al
 5c5:	0f 84 23 01 00 00    	je     6ee <printf+0x165>
    c = fmt[i] & 0xff;
 5cb:	0f be f8             	movsbl %al,%edi
 5ce:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 5d1:	85 f6                	test   %esi,%esi
 5d3:	75 df                	jne    5b4 <printf+0x2b>
      if(c == '%'){
 5d5:	83 f8 25             	cmp    $0x25,%eax
 5d8:	75 ce                	jne    5a8 <printf+0x1f>
        state = '%';
 5da:	89 c6                	mov    %eax,%esi
 5dc:	eb db                	jmp    5b9 <printf+0x30>
      if(c == 'd'){
 5de:	83 f8 64             	cmp    $0x64,%eax
 5e1:	74 49                	je     62c <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5e3:	83 f8 78             	cmp    $0x78,%eax
 5e6:	0f 94 c1             	sete   %cl
 5e9:	83 f8 70             	cmp    $0x70,%eax
 5ec:	0f 94 c2             	sete   %dl
 5ef:	08 d1                	or     %dl,%cl
 5f1:	75 63                	jne    656 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5f3:	83 f8 73             	cmp    $0x73,%eax
 5f6:	0f 84 84 00 00 00    	je     680 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5fc:	83 f8 63             	cmp    $0x63,%eax
 5ff:	0f 84 b7 00 00 00    	je     6bc <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 605:	83 f8 25             	cmp    $0x25,%eax
 608:	0f 84 cc 00 00 00    	je     6da <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 60e:	ba 25 00 00 00       	mov    $0x25,%edx
 613:	8b 45 08             	mov    0x8(%ebp),%eax
 616:	e8 cd fe ff ff       	call   4e8 <putc>
        putc(fd, c);
 61b:	89 fa                	mov    %edi,%edx
 61d:	8b 45 08             	mov    0x8(%ebp),%eax
 620:	e8 c3 fe ff ff       	call   4e8 <putc>
      }
      state = 0;
 625:	be 00 00 00 00       	mov    $0x0,%esi
 62a:	eb 8d                	jmp    5b9 <printf+0x30>
        printint(fd, *ap, 10, 1);
 62c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 62f:	8b 17                	mov    (%edi),%edx
 631:	83 ec 0c             	sub    $0xc,%esp
 634:	6a 01                	push   $0x1
 636:	b9 0a 00 00 00       	mov    $0xa,%ecx
 63b:	8b 45 08             	mov    0x8(%ebp),%eax
 63e:	e8 bf fe ff ff       	call   502 <printint>
        ap++;
 643:	83 c7 04             	add    $0x4,%edi
 646:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 649:	83 c4 10             	add    $0x10,%esp
      state = 0;
 64c:	be 00 00 00 00       	mov    $0x0,%esi
 651:	e9 63 ff ff ff       	jmp    5b9 <printf+0x30>
        printint(fd, *ap, 16, 0);
 656:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 659:	8b 17                	mov    (%edi),%edx
 65b:	83 ec 0c             	sub    $0xc,%esp
 65e:	6a 00                	push   $0x0
 660:	b9 10 00 00 00       	mov    $0x10,%ecx
 665:	8b 45 08             	mov    0x8(%ebp),%eax
 668:	e8 95 fe ff ff       	call   502 <printint>
        ap++;
 66d:	83 c7 04             	add    $0x4,%edi
 670:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 673:	83 c4 10             	add    $0x10,%esp
      state = 0;
 676:	be 00 00 00 00       	mov    $0x0,%esi
 67b:	e9 39 ff ff ff       	jmp    5b9 <printf+0x30>
        s = (char*)*ap;
 680:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 683:	8b 30                	mov    (%eax),%esi
        ap++;
 685:	83 c0 04             	add    $0x4,%eax
 688:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 68b:	85 f6                	test   %esi,%esi
 68d:	75 28                	jne    6b7 <printf+0x12e>
          s = "(null)";
 68f:	be 7f 08 00 00       	mov    $0x87f,%esi
 694:	8b 7d 08             	mov    0x8(%ebp),%edi
 697:	eb 0d                	jmp    6a6 <printf+0x11d>
          putc(fd, *s);
 699:	0f be d2             	movsbl %dl,%edx
 69c:	89 f8                	mov    %edi,%eax
 69e:	e8 45 fe ff ff       	call   4e8 <putc>
          s++;
 6a3:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 6a6:	0f b6 16             	movzbl (%esi),%edx
 6a9:	84 d2                	test   %dl,%dl
 6ab:	75 ec                	jne    699 <printf+0x110>
      state = 0;
 6ad:	be 00 00 00 00       	mov    $0x0,%esi
 6b2:	e9 02 ff ff ff       	jmp    5b9 <printf+0x30>
 6b7:	8b 7d 08             	mov    0x8(%ebp),%edi
 6ba:	eb ea                	jmp    6a6 <printf+0x11d>
        putc(fd, *ap);
 6bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 6bf:	0f be 17             	movsbl (%edi),%edx
 6c2:	8b 45 08             	mov    0x8(%ebp),%eax
 6c5:	e8 1e fe ff ff       	call   4e8 <putc>
        ap++;
 6ca:	83 c7 04             	add    $0x4,%edi
 6cd:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 6d0:	be 00 00 00 00       	mov    $0x0,%esi
 6d5:	e9 df fe ff ff       	jmp    5b9 <printf+0x30>
        putc(fd, c);
 6da:	89 fa                	mov    %edi,%edx
 6dc:	8b 45 08             	mov    0x8(%ebp),%eax
 6df:	e8 04 fe ff ff       	call   4e8 <putc>
      state = 0;
 6e4:	be 00 00 00 00       	mov    $0x0,%esi
 6e9:	e9 cb fe ff ff       	jmp    5b9 <printf+0x30>
    }
  }
}
 6ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6f1:	5b                   	pop    %ebx
 6f2:	5e                   	pop    %esi
 6f3:	5f                   	pop    %edi
 6f4:	5d                   	pop    %ebp
 6f5:	c3                   	ret    

000006f6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f6:	f3 0f 1e fb          	endbr32 
 6fa:	55                   	push   %ebp
 6fb:	89 e5                	mov    %esp,%ebp
 6fd:	57                   	push   %edi
 6fe:	56                   	push   %esi
 6ff:	53                   	push   %ebx
 700:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 703:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 706:	a1 c0 0b 00 00       	mov    0xbc0,%eax
 70b:	eb 02                	jmp    70f <free+0x19>
 70d:	89 d0                	mov    %edx,%eax
 70f:	39 c8                	cmp    %ecx,%eax
 711:	73 04                	jae    717 <free+0x21>
 713:	39 08                	cmp    %ecx,(%eax)
 715:	77 12                	ja     729 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 717:	8b 10                	mov    (%eax),%edx
 719:	39 c2                	cmp    %eax,%edx
 71b:	77 f0                	ja     70d <free+0x17>
 71d:	39 c8                	cmp    %ecx,%eax
 71f:	72 08                	jb     729 <free+0x33>
 721:	39 ca                	cmp    %ecx,%edx
 723:	77 04                	ja     729 <free+0x33>
 725:	89 d0                	mov    %edx,%eax
 727:	eb e6                	jmp    70f <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 729:	8b 73 fc             	mov    -0x4(%ebx),%esi
 72c:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 72f:	8b 10                	mov    (%eax),%edx
 731:	39 d7                	cmp    %edx,%edi
 733:	74 19                	je     74e <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 735:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 738:	8b 50 04             	mov    0x4(%eax),%edx
 73b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 73e:	39 ce                	cmp    %ecx,%esi
 740:	74 1b                	je     75d <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 742:	89 08                	mov    %ecx,(%eax)
  freep = p;
 744:	a3 c0 0b 00 00       	mov    %eax,0xbc0
}
 749:	5b                   	pop    %ebx
 74a:	5e                   	pop    %esi
 74b:	5f                   	pop    %edi
 74c:	5d                   	pop    %ebp
 74d:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 74e:	03 72 04             	add    0x4(%edx),%esi
 751:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 754:	8b 10                	mov    (%eax),%edx
 756:	8b 12                	mov    (%edx),%edx
 758:	89 53 f8             	mov    %edx,-0x8(%ebx)
 75b:	eb db                	jmp    738 <free+0x42>
    p->s.size += bp->s.size;
 75d:	03 53 fc             	add    -0x4(%ebx),%edx
 760:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 763:	8b 53 f8             	mov    -0x8(%ebx),%edx
 766:	89 10                	mov    %edx,(%eax)
 768:	eb da                	jmp    744 <free+0x4e>

0000076a <morecore>:

static Header*
morecore(uint nu)
{
 76a:	55                   	push   %ebp
 76b:	89 e5                	mov    %esp,%ebp
 76d:	53                   	push   %ebx
 76e:	83 ec 04             	sub    $0x4,%esp
 771:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 773:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 778:	77 05                	ja     77f <morecore+0x15>
    nu = 4096;
 77a:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 77f:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 786:	83 ec 0c             	sub    $0xc,%esp
 789:	50                   	push   %eax
 78a:	e8 f9 fc ff ff       	call   488 <sbrk>
  if(p == (char*)-1)
 78f:	83 c4 10             	add    $0x10,%esp
 792:	83 f8 ff             	cmp    $0xffffffff,%eax
 795:	74 1c                	je     7b3 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 797:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 79a:	83 c0 08             	add    $0x8,%eax
 79d:	83 ec 0c             	sub    $0xc,%esp
 7a0:	50                   	push   %eax
 7a1:	e8 50 ff ff ff       	call   6f6 <free>
  return freep;
 7a6:	a1 c0 0b 00 00       	mov    0xbc0,%eax
 7ab:	83 c4 10             	add    $0x10,%esp
}
 7ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 7b1:	c9                   	leave  
 7b2:	c3                   	ret    
    return 0;
 7b3:	b8 00 00 00 00       	mov    $0x0,%eax
 7b8:	eb f4                	jmp    7ae <morecore+0x44>

000007ba <malloc>:

void*
malloc(uint nbytes)
{
 7ba:	f3 0f 1e fb          	endbr32 
 7be:	55                   	push   %ebp
 7bf:	89 e5                	mov    %esp,%ebp
 7c1:	53                   	push   %ebx
 7c2:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c5:	8b 45 08             	mov    0x8(%ebp),%eax
 7c8:	8d 58 07             	lea    0x7(%eax),%ebx
 7cb:	c1 eb 03             	shr    $0x3,%ebx
 7ce:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 7d1:	8b 0d c0 0b 00 00    	mov    0xbc0,%ecx
 7d7:	85 c9                	test   %ecx,%ecx
 7d9:	74 04                	je     7df <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7db:	8b 01                	mov    (%ecx),%eax
 7dd:	eb 4b                	jmp    82a <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 7df:	c7 05 c0 0b 00 00 c4 	movl   $0xbc4,0xbc0
 7e6:	0b 00 00 
 7e9:	c7 05 c4 0b 00 00 c4 	movl   $0xbc4,0xbc4
 7f0:	0b 00 00 
    base.s.size = 0;
 7f3:	c7 05 c8 0b 00 00 00 	movl   $0x0,0xbc8
 7fa:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 7fd:	b9 c4 0b 00 00       	mov    $0xbc4,%ecx
 802:	eb d7                	jmp    7db <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 804:	74 1a                	je     820 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 806:	29 da                	sub    %ebx,%edx
 808:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 80b:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 80e:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 811:	89 0d c0 0b 00 00    	mov    %ecx,0xbc0
      return (void*)(p + 1);
 817:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 81a:	83 c4 04             	add    $0x4,%esp
 81d:	5b                   	pop    %ebx
 81e:	5d                   	pop    %ebp
 81f:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 820:	8b 10                	mov    (%eax),%edx
 822:	89 11                	mov    %edx,(%ecx)
 824:	eb eb                	jmp    811 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 826:	89 c1                	mov    %eax,%ecx
 828:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 82a:	8b 50 04             	mov    0x4(%eax),%edx
 82d:	39 da                	cmp    %ebx,%edx
 82f:	73 d3                	jae    804 <malloc+0x4a>
    if(p == freep)
 831:	39 05 c0 0b 00 00    	cmp    %eax,0xbc0
 837:	75 ed                	jne    826 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 839:	89 d8                	mov    %ebx,%eax
 83b:	e8 2a ff ff ff       	call   76a <morecore>
 840:	85 c0                	test   %eax,%eax
 842:	75 e2                	jne    826 <malloc+0x6c>
 844:	eb d4                	jmp    81a <malloc+0x60>
