
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	56                   	push   %esi
   8:	53                   	push   %ebx
   9:	8b 75 08             	mov    0x8(%ebp),%esi
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   c:	83 ec 04             	sub    $0x4,%esp
   f:	68 00 02 00 00       	push   $0x200
  14:	68 80 0b 00 00       	push   $0xb80
  19:	56                   	push   %esi
  1a:	e8 8f 03 00 00       	call   3ae <read>
  1f:	89 c3                	mov    %eax,%ebx
  21:	83 c4 10             	add    $0x10,%esp
  24:	85 c0                	test   %eax,%eax
  26:	7e 2b                	jle    53 <cat+0x53>
    if (write(1, buf, n) != n) {
  28:	83 ec 04             	sub    $0x4,%esp
  2b:	53                   	push   %ebx
  2c:	68 80 0b 00 00       	push   $0xb80
  31:	6a 01                	push   $0x1
  33:	e8 7e 03 00 00       	call   3b6 <write>
  38:	83 c4 10             	add    $0x10,%esp
  3b:	39 d8                	cmp    %ebx,%eax
  3d:	74 cd                	je     c <cat+0xc>
      printf(1, "cat: write error\n");
  3f:	83 ec 08             	sub    $0x8,%esp
  42:	68 dc 07 00 00       	push   $0x7dc
  47:	6a 01                	push   $0x1
  49:	e8 d1 04 00 00       	call   51f <printf>
      exit();
  4e:	e8 43 03 00 00       	call   396 <exit>
    }
  }
  if(n < 0){
  53:	78 07                	js     5c <cat+0x5c>
    printf(1, "cat: read error\n");
    exit();
  }
}
  55:	8d 65 f8             	lea    -0x8(%ebp),%esp
  58:	5b                   	pop    %ebx
  59:	5e                   	pop    %esi
  5a:	5d                   	pop    %ebp
  5b:	c3                   	ret    
    printf(1, "cat: read error\n");
  5c:	83 ec 08             	sub    $0x8,%esp
  5f:	68 ee 07 00 00       	push   $0x7ee
  64:	6a 01                	push   $0x1
  66:	e8 b4 04 00 00       	call   51f <printf>
    exit();
  6b:	e8 26 03 00 00       	call   396 <exit>

00000070 <main>:

int
main(int argc, char *argv[])
{
  70:	f3 0f 1e fb          	endbr32 
  74:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  78:	83 e4 f0             	and    $0xfffffff0,%esp
  7b:	ff 71 fc             	pushl  -0x4(%ecx)
  7e:	55                   	push   %ebp
  7f:	89 e5                	mov    %esp,%ebp
  81:	57                   	push   %edi
  82:	56                   	push   %esi
  83:	53                   	push   %ebx
  84:	51                   	push   %ecx
  85:	83 ec 18             	sub    $0x18,%esp
  88:	8b 01                	mov    (%ecx),%eax
  8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8d:	8b 51 04             	mov    0x4(%ecx),%edx
  90:	89 55 e0             	mov    %edx,-0x20(%ebp)
  int fd, i;

  if(argc <= 1){
  93:	83 f8 01             	cmp    $0x1,%eax
  96:	7e 3e                	jle    d6 <main+0x66>
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  98:	be 01 00 00 00       	mov    $0x1,%esi
  9d:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  a0:	7d 59                	jge    fb <main+0x8b>
    if((fd = open(argv[i], 0)) < 0){
  a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  a5:	8d 3c b0             	lea    (%eax,%esi,4),%edi
  a8:	83 ec 08             	sub    $0x8,%esp
  ab:	6a 00                	push   $0x0
  ad:	ff 37                	pushl  (%edi)
  af:	e8 22 03 00 00       	call   3d6 <open>
  b4:	89 c3                	mov    %eax,%ebx
  b6:	83 c4 10             	add    $0x10,%esp
  b9:	85 c0                	test   %eax,%eax
  bb:	78 28                	js     e5 <main+0x75>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  bd:	83 ec 0c             	sub    $0xc,%esp
  c0:	50                   	push   %eax
  c1:	e8 3a ff ff ff       	call   0 <cat>
    close(fd);
  c6:	89 1c 24             	mov    %ebx,(%esp)
  c9:	e8 f0 02 00 00       	call   3be <close>
  for(i = 1; i < argc; i++){
  ce:	83 c6 01             	add    $0x1,%esi
  d1:	83 c4 10             	add    $0x10,%esp
  d4:	eb c7                	jmp    9d <main+0x2d>
    cat(0);
  d6:	83 ec 0c             	sub    $0xc,%esp
  d9:	6a 00                	push   $0x0
  db:	e8 20 ff ff ff       	call   0 <cat>
    exit();
  e0:	e8 b1 02 00 00       	call   396 <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
  e5:	83 ec 04             	sub    $0x4,%esp
  e8:	ff 37                	pushl  (%edi)
  ea:	68 ff 07 00 00       	push   $0x7ff
  ef:	6a 01                	push   $0x1
  f1:	e8 29 04 00 00       	call   51f <printf>
      exit();
  f6:	e8 9b 02 00 00       	call   396 <exit>
  }
  exit();
  fb:	e8 96 02 00 00       	call   396 <exit>

00000100 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 100:	f3 0f 1e fb          	endbr32 
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	56                   	push   %esi
 108:	53                   	push   %ebx
 109:	8b 75 08             	mov    0x8(%ebp),%esi
 10c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 10f:	89 f0                	mov    %esi,%eax
 111:	89 d1                	mov    %edx,%ecx
 113:	83 c2 01             	add    $0x1,%edx
 116:	89 c3                	mov    %eax,%ebx
 118:	83 c0 01             	add    $0x1,%eax
 11b:	0f b6 09             	movzbl (%ecx),%ecx
 11e:	88 0b                	mov    %cl,(%ebx)
 120:	84 c9                	test   %cl,%cl
 122:	75 ed                	jne    111 <strcpy+0x11>
    ;
  return os;
}
 124:	89 f0                	mov    %esi,%eax
 126:	5b                   	pop    %ebx
 127:	5e                   	pop    %esi
 128:	5d                   	pop    %ebp
 129:	c3                   	ret    

0000012a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12a:	f3 0f 1e fb          	endbr32 
 12e:	55                   	push   %ebp
 12f:	89 e5                	mov    %esp,%ebp
 131:	8b 4d 08             	mov    0x8(%ebp),%ecx
 134:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 137:	0f b6 01             	movzbl (%ecx),%eax
 13a:	84 c0                	test   %al,%al
 13c:	74 0c                	je     14a <strcmp+0x20>
 13e:	3a 02                	cmp    (%edx),%al
 140:	75 08                	jne    14a <strcmp+0x20>
    p++, q++;
 142:	83 c1 01             	add    $0x1,%ecx
 145:	83 c2 01             	add    $0x1,%edx
 148:	eb ed                	jmp    137 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 14a:	0f b6 c0             	movzbl %al,%eax
 14d:	0f b6 12             	movzbl (%edx),%edx
 150:	29 d0                	sub    %edx,%eax
}
 152:	5d                   	pop    %ebp
 153:	c3                   	ret    

00000154 <strlen>:

uint
strlen(char *s)
{
 154:	f3 0f 1e fb          	endbr32 
 158:	55                   	push   %ebp
 159:	89 e5                	mov    %esp,%ebp
 15b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 15e:	b8 00 00 00 00       	mov    $0x0,%eax
 163:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 167:	74 05                	je     16e <strlen+0x1a>
 169:	83 c0 01             	add    $0x1,%eax
 16c:	eb f5                	jmp    163 <strlen+0xf>
    ;
  return n;
}
 16e:	5d                   	pop    %ebp
 16f:	c3                   	ret    

00000170 <memset>:

void*
memset(void *dst, int c, uint n)
{
 170:	f3 0f 1e fb          	endbr32 
 174:	55                   	push   %ebp
 175:	89 e5                	mov    %esp,%ebp
 177:	57                   	push   %edi
 178:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 17b:	89 d7                	mov    %edx,%edi
 17d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 180:	8b 45 0c             	mov    0xc(%ebp),%eax
 183:	fc                   	cld    
 184:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 186:	89 d0                	mov    %edx,%eax
 188:	5f                   	pop    %edi
 189:	5d                   	pop    %ebp
 18a:	c3                   	ret    

0000018b <strchr>:

char*
strchr(const char *s, char c)
{
 18b:	f3 0f 1e fb          	endbr32 
 18f:	55                   	push   %ebp
 190:	89 e5                	mov    %esp,%ebp
 192:	8b 45 08             	mov    0x8(%ebp),%eax
 195:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 199:	0f b6 10             	movzbl (%eax),%edx
 19c:	84 d2                	test   %dl,%dl
 19e:	74 09                	je     1a9 <strchr+0x1e>
    if(*s == c)
 1a0:	38 ca                	cmp    %cl,%dl
 1a2:	74 0a                	je     1ae <strchr+0x23>
  for(; *s; s++)
 1a4:	83 c0 01             	add    $0x1,%eax
 1a7:	eb f0                	jmp    199 <strchr+0xe>
      return (char*)s;
  return 0;
 1a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1ae:	5d                   	pop    %ebp
 1af:	c3                   	ret    

000001b0 <gets>:

char*
gets(char *buf, int max)
{
 1b0:	f3 0f 1e fb          	endbr32 
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	57                   	push   %edi
 1b8:	56                   	push   %esi
 1b9:	53                   	push   %ebx
 1ba:	83 ec 1c             	sub    $0x1c,%esp
 1bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c0:	bb 00 00 00 00       	mov    $0x0,%ebx
 1c5:	89 de                	mov    %ebx,%esi
 1c7:	83 c3 01             	add    $0x1,%ebx
 1ca:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1cd:	7d 2e                	jge    1fd <gets+0x4d>
    cc = read(0, &c, 1);
 1cf:	83 ec 04             	sub    $0x4,%esp
 1d2:	6a 01                	push   $0x1
 1d4:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1d7:	50                   	push   %eax
 1d8:	6a 00                	push   $0x0
 1da:	e8 cf 01 00 00       	call   3ae <read>
    if(cc < 1)
 1df:	83 c4 10             	add    $0x10,%esp
 1e2:	85 c0                	test   %eax,%eax
 1e4:	7e 17                	jle    1fd <gets+0x4d>
      break;
    buf[i++] = c;
 1e6:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1ea:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 1ed:	3c 0a                	cmp    $0xa,%al
 1ef:	0f 94 c2             	sete   %dl
 1f2:	3c 0d                	cmp    $0xd,%al
 1f4:	0f 94 c0             	sete   %al
 1f7:	08 c2                	or     %al,%dl
 1f9:	74 ca                	je     1c5 <gets+0x15>
    buf[i++] = c;
 1fb:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1fd:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 201:	89 f8                	mov    %edi,%eax
 203:	8d 65 f4             	lea    -0xc(%ebp),%esp
 206:	5b                   	pop    %ebx
 207:	5e                   	pop    %esi
 208:	5f                   	pop    %edi
 209:	5d                   	pop    %ebp
 20a:	c3                   	ret    

0000020b <stat>:

int
stat(char *n, struct stat *st)
{
 20b:	f3 0f 1e fb          	endbr32 
 20f:	55                   	push   %ebp
 210:	89 e5                	mov    %esp,%ebp
 212:	56                   	push   %esi
 213:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 214:	83 ec 08             	sub    $0x8,%esp
 217:	6a 00                	push   $0x0
 219:	ff 75 08             	pushl  0x8(%ebp)
 21c:	e8 b5 01 00 00       	call   3d6 <open>
  if(fd < 0)
 221:	83 c4 10             	add    $0x10,%esp
 224:	85 c0                	test   %eax,%eax
 226:	78 24                	js     24c <stat+0x41>
 228:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 22a:	83 ec 08             	sub    $0x8,%esp
 22d:	ff 75 0c             	pushl  0xc(%ebp)
 230:	50                   	push   %eax
 231:	e8 b8 01 00 00       	call   3ee <fstat>
 236:	89 c6                	mov    %eax,%esi
  close(fd);
 238:	89 1c 24             	mov    %ebx,(%esp)
 23b:	e8 7e 01 00 00       	call   3be <close>
  return r;
 240:	83 c4 10             	add    $0x10,%esp
}
 243:	89 f0                	mov    %esi,%eax
 245:	8d 65 f8             	lea    -0x8(%ebp),%esp
 248:	5b                   	pop    %ebx
 249:	5e                   	pop    %esi
 24a:	5d                   	pop    %ebp
 24b:	c3                   	ret    
    return -1;
 24c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 251:	eb f0                	jmp    243 <stat+0x38>

00000253 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 253:	f3 0f 1e fb          	endbr32 
 257:	55                   	push   %ebp
 258:	89 e5                	mov    %esp,%ebp
 25a:	57                   	push   %edi
 25b:	56                   	push   %esi
 25c:	53                   	push   %ebx
 25d:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 260:	0f b6 02             	movzbl (%edx),%eax
 263:	3c 20                	cmp    $0x20,%al
 265:	75 05                	jne    26c <atoi+0x19>
 267:	83 c2 01             	add    $0x1,%edx
 26a:	eb f4                	jmp    260 <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 26c:	3c 2d                	cmp    $0x2d,%al
 26e:	74 1d                	je     28d <atoi+0x3a>
 270:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 275:	3c 2b                	cmp    $0x2b,%al
 277:	0f 94 c1             	sete   %cl
 27a:	3c 2d                	cmp    $0x2d,%al
 27c:	0f 94 c0             	sete   %al
 27f:	08 c1                	or     %al,%cl
 281:	74 03                	je     286 <atoi+0x33>
    s++;
 283:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 286:	b8 00 00 00 00       	mov    $0x0,%eax
 28b:	eb 17                	jmp    2a4 <atoi+0x51>
 28d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 292:	eb e1                	jmp    275 <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 294:	8d 34 80             	lea    (%eax,%eax,4),%esi
 297:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 29a:	83 c2 01             	add    $0x1,%edx
 29d:	0f be c9             	movsbl %cl,%ecx
 2a0:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 2a4:	0f b6 0a             	movzbl (%edx),%ecx
 2a7:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 2aa:	80 fb 09             	cmp    $0x9,%bl
 2ad:	76 e5                	jbe    294 <atoi+0x41>
  return sign*n;
 2af:	0f af c7             	imul   %edi,%eax
}
 2b2:	5b                   	pop    %ebx
 2b3:	5e                   	pop    %esi
 2b4:	5f                   	pop    %edi
 2b5:	5d                   	pop    %ebp
 2b6:	c3                   	ret    

000002b7 <atoo>:

int
atoo(const char *s)
{
 2b7:	f3 0f 1e fb          	endbr32 
 2bb:	55                   	push   %ebp
 2bc:	89 e5                	mov    %esp,%ebp
 2be:	57                   	push   %edi
 2bf:	56                   	push   %esi
 2c0:	53                   	push   %ebx
 2c1:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 2c4:	0f b6 0a             	movzbl (%edx),%ecx
 2c7:	80 f9 20             	cmp    $0x20,%cl
 2ca:	75 05                	jne    2d1 <atoo+0x1a>
 2cc:	83 c2 01             	add    $0x1,%edx
 2cf:	eb f3                	jmp    2c4 <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 2d1:	80 f9 2d             	cmp    $0x2d,%cl
 2d4:	74 23                	je     2f9 <atoo+0x42>
 2d6:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 2db:	80 f9 2b             	cmp    $0x2b,%cl
 2de:	0f 94 c0             	sete   %al
 2e1:	89 c6                	mov    %eax,%esi
 2e3:	80 f9 2d             	cmp    $0x2d,%cl
 2e6:	0f 94 c0             	sete   %al
 2e9:	89 f3                	mov    %esi,%ebx
 2eb:	08 c3                	or     %al,%bl
 2ed:	74 03                	je     2f2 <atoo+0x3b>
    s++;
 2ef:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 2f2:	b8 00 00 00 00       	mov    $0x0,%eax
 2f7:	eb 11                	jmp    30a <atoo+0x53>
 2f9:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 2fe:	eb db                	jmp    2db <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 300:	83 c2 01             	add    $0x1,%edx
 303:	0f be c9             	movsbl %cl,%ecx
 306:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 30a:	0f b6 0a             	movzbl (%edx),%ecx
 30d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 310:	80 fb 07             	cmp    $0x7,%bl
 313:	76 eb                	jbe    300 <atoo+0x49>
  return sign*n;
 315:	0f af c7             	imul   %edi,%eax
}
 318:	5b                   	pop    %ebx
 319:	5e                   	pop    %esi
 31a:	5f                   	pop    %edi
 31b:	5d                   	pop    %ebp
 31c:	c3                   	ret    

0000031d <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 31d:	f3 0f 1e fb          	endbr32 
 321:	55                   	push   %ebp
 322:	89 e5                	mov    %esp,%ebp
 324:	53                   	push   %ebx
 325:	8b 55 08             	mov    0x8(%ebp),%edx
 328:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 32b:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 32e:	eb 09                	jmp    339 <strncmp+0x1c>
      n--, p++, q++;
 330:	83 e8 01             	sub    $0x1,%eax
 333:	83 c2 01             	add    $0x1,%edx
 336:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 339:	85 c0                	test   %eax,%eax
 33b:	74 0b                	je     348 <strncmp+0x2b>
 33d:	0f b6 1a             	movzbl (%edx),%ebx
 340:	84 db                	test   %bl,%bl
 342:	74 04                	je     348 <strncmp+0x2b>
 344:	3a 19                	cmp    (%ecx),%bl
 346:	74 e8                	je     330 <strncmp+0x13>
    if(n == 0)
 348:	85 c0                	test   %eax,%eax
 34a:	74 0b                	je     357 <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 34c:	0f b6 02             	movzbl (%edx),%eax
 34f:	0f b6 11             	movzbl (%ecx),%edx
 352:	29 d0                	sub    %edx,%eax
}
 354:	5b                   	pop    %ebx
 355:	5d                   	pop    %ebp
 356:	c3                   	ret    
      return 0;
 357:	b8 00 00 00 00       	mov    $0x0,%eax
 35c:	eb f6                	jmp    354 <strncmp+0x37>

0000035e <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 35e:	f3 0f 1e fb          	endbr32 
 362:	55                   	push   %ebp
 363:	89 e5                	mov    %esp,%ebp
 365:	56                   	push   %esi
 366:	53                   	push   %ebx
 367:	8b 75 08             	mov    0x8(%ebp),%esi
 36a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 36d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 370:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 372:	8d 58 ff             	lea    -0x1(%eax),%ebx
 375:	85 c0                	test   %eax,%eax
 377:	7e 0f                	jle    388 <memmove+0x2a>
    *dst++ = *src++;
 379:	0f b6 01             	movzbl (%ecx),%eax
 37c:	88 02                	mov    %al,(%edx)
 37e:	8d 49 01             	lea    0x1(%ecx),%ecx
 381:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 384:	89 d8                	mov    %ebx,%eax
 386:	eb ea                	jmp    372 <memmove+0x14>
  return vdst;
}
 388:	89 f0                	mov    %esi,%eax
 38a:	5b                   	pop    %ebx
 38b:	5e                   	pop    %esi
 38c:	5d                   	pop    %ebp
 38d:	c3                   	ret    

0000038e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 38e:	b8 01 00 00 00       	mov    $0x1,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <exit>:
SYSCALL(exit)
 396:	b8 02 00 00 00       	mov    $0x2,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <wait>:
SYSCALL(wait)
 39e:	b8 03 00 00 00       	mov    $0x3,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <pipe>:
SYSCALL(pipe)
 3a6:	b8 04 00 00 00       	mov    $0x4,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <read>:
SYSCALL(read)
 3ae:	b8 05 00 00 00       	mov    $0x5,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <write>:
SYSCALL(write)
 3b6:	b8 10 00 00 00       	mov    $0x10,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <close>:
SYSCALL(close)
 3be:	b8 15 00 00 00       	mov    $0x15,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <kill>:
SYSCALL(kill)
 3c6:	b8 06 00 00 00       	mov    $0x6,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <exec>:
SYSCALL(exec)
 3ce:	b8 07 00 00 00       	mov    $0x7,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <open>:
SYSCALL(open)
 3d6:	b8 0f 00 00 00       	mov    $0xf,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <mknod>:
SYSCALL(mknod)
 3de:	b8 11 00 00 00       	mov    $0x11,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <unlink>:
SYSCALL(unlink)
 3e6:	b8 12 00 00 00       	mov    $0x12,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <fstat>:
SYSCALL(fstat)
 3ee:	b8 08 00 00 00       	mov    $0x8,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <link>:
SYSCALL(link)
 3f6:	b8 13 00 00 00       	mov    $0x13,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <mkdir>:
SYSCALL(mkdir)
 3fe:	b8 14 00 00 00       	mov    $0x14,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <chdir>:
SYSCALL(chdir)
 406:	b8 09 00 00 00       	mov    $0x9,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <dup>:
SYSCALL(dup)
 40e:	b8 0a 00 00 00       	mov    $0xa,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <getpid>:
SYSCALL(getpid)
 416:	b8 0b 00 00 00       	mov    $0xb,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <sbrk>:
SYSCALL(sbrk)
 41e:	b8 0c 00 00 00       	mov    $0xc,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <sleep>:
SYSCALL(sleep)
 426:	b8 0d 00 00 00       	mov    $0xd,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <uptime>:
SYSCALL(uptime)
 42e:	b8 0e 00 00 00       	mov    $0xe,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <halt>:
SYSCALL(halt)
 436:	b8 16 00 00 00       	mov    $0x16,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <cps>:
/* ____My changes____ */
SYSCALL(cps)
 43e:	b8 17 00 00 00       	mov    $0x17,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <getppid>:
SYSCALL(getppid)
 446:	b8 18 00 00 00       	mov    $0x18,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <getsz>:
SYSCALL(getsz)
 44e:	b8 19 00 00 00       	mov    $0x19,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <chpr>:
SYSCALL(chpr)
 456:	b8 1a 00 00 00       	mov    $0x1a,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <getcount>:
SYSCALL(getcount)
 45e:	b8 1b 00 00 00       	mov    $0x1b,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <time>:
SYSCALL(time)
 466:	b8 1c 00 00 00       	mov    $0x1c,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <utctime>:
SYSCALL(utctime)
 46e:	b8 1d 00 00 00       	mov    $0x1d,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <dup2>:
SYSCALL(dup2)
 476:	b8 1e 00 00 00       	mov    $0x1e,%eax
 47b:	cd 40                	int    $0x40
 47d:	c3                   	ret    

0000047e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 47e:	55                   	push   %ebp
 47f:	89 e5                	mov    %esp,%ebp
 481:	83 ec 1c             	sub    $0x1c,%esp
 484:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 487:	6a 01                	push   $0x1
 489:	8d 55 f4             	lea    -0xc(%ebp),%edx
 48c:	52                   	push   %edx
 48d:	50                   	push   %eax
 48e:	e8 23 ff ff ff       	call   3b6 <write>
}
 493:	83 c4 10             	add    $0x10,%esp
 496:	c9                   	leave  
 497:	c3                   	ret    

00000498 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 498:	55                   	push   %ebp
 499:	89 e5                	mov    %esp,%ebp
 49b:	57                   	push   %edi
 49c:	56                   	push   %esi
 49d:	53                   	push   %ebx
 49e:	83 ec 2c             	sub    $0x2c,%esp
 4a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4a4:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 4aa:	0f 95 c2             	setne  %dl
 4ad:	89 f0                	mov    %esi,%eax
 4af:	c1 e8 1f             	shr    $0x1f,%eax
 4b2:	84 c2                	test   %al,%dl
 4b4:	74 42                	je     4f8 <printint+0x60>
    neg = 1;
    x = -xx;
 4b6:	f7 de                	neg    %esi
    neg = 1;
 4b8:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 4bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 4c4:	89 f0                	mov    %esi,%eax
 4c6:	ba 00 00 00 00       	mov    $0x0,%edx
 4cb:	f7 f1                	div    %ecx
 4cd:	89 df                	mov    %ebx,%edi
 4cf:	83 c3 01             	add    $0x1,%ebx
 4d2:	0f b6 92 1c 08 00 00 	movzbl 0x81c(%edx),%edx
 4d9:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 4dd:	89 f2                	mov    %esi,%edx
 4df:	89 c6                	mov    %eax,%esi
 4e1:	39 d1                	cmp    %edx,%ecx
 4e3:	76 df                	jbe    4c4 <printint+0x2c>
  if(neg)
 4e5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 4e9:	74 2f                	je     51a <printint+0x82>
    buf[i++] = '-';
 4eb:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 4f0:	8d 5f 02             	lea    0x2(%edi),%ebx
 4f3:	8b 75 d0             	mov    -0x30(%ebp),%esi
 4f6:	eb 15                	jmp    50d <printint+0x75>
  neg = 0;
 4f8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 4ff:	eb be                	jmp    4bf <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 501:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 506:	89 f0                	mov    %esi,%eax
 508:	e8 71 ff ff ff       	call   47e <putc>
  while(--i >= 0)
 50d:	83 eb 01             	sub    $0x1,%ebx
 510:	79 ef                	jns    501 <printint+0x69>
}
 512:	83 c4 2c             	add    $0x2c,%esp
 515:	5b                   	pop    %ebx
 516:	5e                   	pop    %esi
 517:	5f                   	pop    %edi
 518:	5d                   	pop    %ebp
 519:	c3                   	ret    
 51a:	8b 75 d0             	mov    -0x30(%ebp),%esi
 51d:	eb ee                	jmp    50d <printint+0x75>

0000051f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 51f:	f3 0f 1e fb          	endbr32 
 523:	55                   	push   %ebp
 524:	89 e5                	mov    %esp,%ebp
 526:	57                   	push   %edi
 527:	56                   	push   %esi
 528:	53                   	push   %ebx
 529:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 52c:	8d 45 10             	lea    0x10(%ebp),%eax
 52f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 532:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 537:	bb 00 00 00 00       	mov    $0x0,%ebx
 53c:	eb 14                	jmp    552 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 53e:	89 fa                	mov    %edi,%edx
 540:	8b 45 08             	mov    0x8(%ebp),%eax
 543:	e8 36 ff ff ff       	call   47e <putc>
 548:	eb 05                	jmp    54f <printf+0x30>
      }
    } else if(state == '%'){
 54a:	83 fe 25             	cmp    $0x25,%esi
 54d:	74 25                	je     574 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 54f:	83 c3 01             	add    $0x1,%ebx
 552:	8b 45 0c             	mov    0xc(%ebp),%eax
 555:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 559:	84 c0                	test   %al,%al
 55b:	0f 84 23 01 00 00    	je     684 <printf+0x165>
    c = fmt[i] & 0xff;
 561:	0f be f8             	movsbl %al,%edi
 564:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 567:	85 f6                	test   %esi,%esi
 569:	75 df                	jne    54a <printf+0x2b>
      if(c == '%'){
 56b:	83 f8 25             	cmp    $0x25,%eax
 56e:	75 ce                	jne    53e <printf+0x1f>
        state = '%';
 570:	89 c6                	mov    %eax,%esi
 572:	eb db                	jmp    54f <printf+0x30>
      if(c == 'd'){
 574:	83 f8 64             	cmp    $0x64,%eax
 577:	74 49                	je     5c2 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 579:	83 f8 78             	cmp    $0x78,%eax
 57c:	0f 94 c1             	sete   %cl
 57f:	83 f8 70             	cmp    $0x70,%eax
 582:	0f 94 c2             	sete   %dl
 585:	08 d1                	or     %dl,%cl
 587:	75 63                	jne    5ec <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 589:	83 f8 73             	cmp    $0x73,%eax
 58c:	0f 84 84 00 00 00    	je     616 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 592:	83 f8 63             	cmp    $0x63,%eax
 595:	0f 84 b7 00 00 00    	je     652 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 59b:	83 f8 25             	cmp    $0x25,%eax
 59e:	0f 84 cc 00 00 00    	je     670 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5a4:	ba 25 00 00 00       	mov    $0x25,%edx
 5a9:	8b 45 08             	mov    0x8(%ebp),%eax
 5ac:	e8 cd fe ff ff       	call   47e <putc>
        putc(fd, c);
 5b1:	89 fa                	mov    %edi,%edx
 5b3:	8b 45 08             	mov    0x8(%ebp),%eax
 5b6:	e8 c3 fe ff ff       	call   47e <putc>
      }
      state = 0;
 5bb:	be 00 00 00 00       	mov    $0x0,%esi
 5c0:	eb 8d                	jmp    54f <printf+0x30>
        printint(fd, *ap, 10, 1);
 5c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5c5:	8b 17                	mov    (%edi),%edx
 5c7:	83 ec 0c             	sub    $0xc,%esp
 5ca:	6a 01                	push   $0x1
 5cc:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5d1:	8b 45 08             	mov    0x8(%ebp),%eax
 5d4:	e8 bf fe ff ff       	call   498 <printint>
        ap++;
 5d9:	83 c7 04             	add    $0x4,%edi
 5dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 5df:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5e2:	be 00 00 00 00       	mov    $0x0,%esi
 5e7:	e9 63 ff ff ff       	jmp    54f <printf+0x30>
        printint(fd, *ap, 16, 0);
 5ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5ef:	8b 17                	mov    (%edi),%edx
 5f1:	83 ec 0c             	sub    $0xc,%esp
 5f4:	6a 00                	push   $0x0
 5f6:	b9 10 00 00 00       	mov    $0x10,%ecx
 5fb:	8b 45 08             	mov    0x8(%ebp),%eax
 5fe:	e8 95 fe ff ff       	call   498 <printint>
        ap++;
 603:	83 c7 04             	add    $0x4,%edi
 606:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 609:	83 c4 10             	add    $0x10,%esp
      state = 0;
 60c:	be 00 00 00 00       	mov    $0x0,%esi
 611:	e9 39 ff ff ff       	jmp    54f <printf+0x30>
        s = (char*)*ap;
 616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 619:	8b 30                	mov    (%eax),%esi
        ap++;
 61b:	83 c0 04             	add    $0x4,%eax
 61e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 621:	85 f6                	test   %esi,%esi
 623:	75 28                	jne    64d <printf+0x12e>
          s = "(null)";
 625:	be 14 08 00 00       	mov    $0x814,%esi
 62a:	8b 7d 08             	mov    0x8(%ebp),%edi
 62d:	eb 0d                	jmp    63c <printf+0x11d>
          putc(fd, *s);
 62f:	0f be d2             	movsbl %dl,%edx
 632:	89 f8                	mov    %edi,%eax
 634:	e8 45 fe ff ff       	call   47e <putc>
          s++;
 639:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 63c:	0f b6 16             	movzbl (%esi),%edx
 63f:	84 d2                	test   %dl,%dl
 641:	75 ec                	jne    62f <printf+0x110>
      state = 0;
 643:	be 00 00 00 00       	mov    $0x0,%esi
 648:	e9 02 ff ff ff       	jmp    54f <printf+0x30>
 64d:	8b 7d 08             	mov    0x8(%ebp),%edi
 650:	eb ea                	jmp    63c <printf+0x11d>
        putc(fd, *ap);
 652:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 655:	0f be 17             	movsbl (%edi),%edx
 658:	8b 45 08             	mov    0x8(%ebp),%eax
 65b:	e8 1e fe ff ff       	call   47e <putc>
        ap++;
 660:	83 c7 04             	add    $0x4,%edi
 663:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 666:	be 00 00 00 00       	mov    $0x0,%esi
 66b:	e9 df fe ff ff       	jmp    54f <printf+0x30>
        putc(fd, c);
 670:	89 fa                	mov    %edi,%edx
 672:	8b 45 08             	mov    0x8(%ebp),%eax
 675:	e8 04 fe ff ff       	call   47e <putc>
      state = 0;
 67a:	be 00 00 00 00       	mov    $0x0,%esi
 67f:	e9 cb fe ff ff       	jmp    54f <printf+0x30>
    }
  }
}
 684:	8d 65 f4             	lea    -0xc(%ebp),%esp
 687:	5b                   	pop    %ebx
 688:	5e                   	pop    %esi
 689:	5f                   	pop    %edi
 68a:	5d                   	pop    %ebp
 68b:	c3                   	ret    

0000068c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 68c:	f3 0f 1e fb          	endbr32 
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	57                   	push   %edi
 694:	56                   	push   %esi
 695:	53                   	push   %ebx
 696:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 699:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69c:	a1 60 0b 00 00       	mov    0xb60,%eax
 6a1:	eb 02                	jmp    6a5 <free+0x19>
 6a3:	89 d0                	mov    %edx,%eax
 6a5:	39 c8                	cmp    %ecx,%eax
 6a7:	73 04                	jae    6ad <free+0x21>
 6a9:	39 08                	cmp    %ecx,(%eax)
 6ab:	77 12                	ja     6bf <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ad:	8b 10                	mov    (%eax),%edx
 6af:	39 c2                	cmp    %eax,%edx
 6b1:	77 f0                	ja     6a3 <free+0x17>
 6b3:	39 c8                	cmp    %ecx,%eax
 6b5:	72 08                	jb     6bf <free+0x33>
 6b7:	39 ca                	cmp    %ecx,%edx
 6b9:	77 04                	ja     6bf <free+0x33>
 6bb:	89 d0                	mov    %edx,%eax
 6bd:	eb e6                	jmp    6a5 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6bf:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6c2:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6c5:	8b 10                	mov    (%eax),%edx
 6c7:	39 d7                	cmp    %edx,%edi
 6c9:	74 19                	je     6e4 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6cb:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6ce:	8b 50 04             	mov    0x4(%eax),%edx
 6d1:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6d4:	39 ce                	cmp    %ecx,%esi
 6d6:	74 1b                	je     6f3 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6d8:	89 08                	mov    %ecx,(%eax)
  freep = p;
 6da:	a3 60 0b 00 00       	mov    %eax,0xb60
}
 6df:	5b                   	pop    %ebx
 6e0:	5e                   	pop    %esi
 6e1:	5f                   	pop    %edi
 6e2:	5d                   	pop    %ebp
 6e3:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 6e4:	03 72 04             	add    0x4(%edx),%esi
 6e7:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ea:	8b 10                	mov    (%eax),%edx
 6ec:	8b 12                	mov    (%edx),%edx
 6ee:	89 53 f8             	mov    %edx,-0x8(%ebx)
 6f1:	eb db                	jmp    6ce <free+0x42>
    p->s.size += bp->s.size;
 6f3:	03 53 fc             	add    -0x4(%ebx),%edx
 6f6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6f9:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6fc:	89 10                	mov    %edx,(%eax)
 6fe:	eb da                	jmp    6da <free+0x4e>

00000700 <morecore>:

static Header*
morecore(uint nu)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	53                   	push   %ebx
 704:	83 ec 04             	sub    $0x4,%esp
 707:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 709:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 70e:	77 05                	ja     715 <morecore+0x15>
    nu = 4096;
 710:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 715:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 71c:	83 ec 0c             	sub    $0xc,%esp
 71f:	50                   	push   %eax
 720:	e8 f9 fc ff ff       	call   41e <sbrk>
  if(p == (char*)-1)
 725:	83 c4 10             	add    $0x10,%esp
 728:	83 f8 ff             	cmp    $0xffffffff,%eax
 72b:	74 1c                	je     749 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 72d:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 730:	83 c0 08             	add    $0x8,%eax
 733:	83 ec 0c             	sub    $0xc,%esp
 736:	50                   	push   %eax
 737:	e8 50 ff ff ff       	call   68c <free>
  return freep;
 73c:	a1 60 0b 00 00       	mov    0xb60,%eax
 741:	83 c4 10             	add    $0x10,%esp
}
 744:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 747:	c9                   	leave  
 748:	c3                   	ret    
    return 0;
 749:	b8 00 00 00 00       	mov    $0x0,%eax
 74e:	eb f4                	jmp    744 <morecore+0x44>

00000750 <malloc>:

void*
malloc(uint nbytes)
{
 750:	f3 0f 1e fb          	endbr32 
 754:	55                   	push   %ebp
 755:	89 e5                	mov    %esp,%ebp
 757:	53                   	push   %ebx
 758:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 75b:	8b 45 08             	mov    0x8(%ebp),%eax
 75e:	8d 58 07             	lea    0x7(%eax),%ebx
 761:	c1 eb 03             	shr    $0x3,%ebx
 764:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 767:	8b 0d 60 0b 00 00    	mov    0xb60,%ecx
 76d:	85 c9                	test   %ecx,%ecx
 76f:	74 04                	je     775 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 771:	8b 01                	mov    (%ecx),%eax
 773:	eb 4b                	jmp    7c0 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 775:	c7 05 60 0b 00 00 64 	movl   $0xb64,0xb60
 77c:	0b 00 00 
 77f:	c7 05 64 0b 00 00 64 	movl   $0xb64,0xb64
 786:	0b 00 00 
    base.s.size = 0;
 789:	c7 05 68 0b 00 00 00 	movl   $0x0,0xb68
 790:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 793:	b9 64 0b 00 00       	mov    $0xb64,%ecx
 798:	eb d7                	jmp    771 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 79a:	74 1a                	je     7b6 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 79c:	29 da                	sub    %ebx,%edx
 79e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7a1:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 7a4:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 7a7:	89 0d 60 0b 00 00    	mov    %ecx,0xb60
      return (void*)(p + 1);
 7ad:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7b0:	83 c4 04             	add    $0x4,%esp
 7b3:	5b                   	pop    %ebx
 7b4:	5d                   	pop    %ebp
 7b5:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 7b6:	8b 10                	mov    (%eax),%edx
 7b8:	89 11                	mov    %edx,(%ecx)
 7ba:	eb eb                	jmp    7a7 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7bc:	89 c1                	mov    %eax,%ecx
 7be:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 7c0:	8b 50 04             	mov    0x4(%eax),%edx
 7c3:	39 da                	cmp    %ebx,%edx
 7c5:	73 d3                	jae    79a <malloc+0x4a>
    if(p == freep)
 7c7:	39 05 60 0b 00 00    	cmp    %eax,0xb60
 7cd:	75 ed                	jne    7bc <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 7cf:	89 d8                	mov    %ebx,%eax
 7d1:	e8 2a ff ff ff       	call   700 <morecore>
 7d6:	85 c0                	test   %eax,%eax
 7d8:	75 e2                	jne    7bc <malloc+0x6c>
 7da:	eb d4                	jmp    7b0 <malloc+0x60>
