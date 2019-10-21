
_userRR:     file format elf32-i386


Disassembly of section .text:

00000000 <roundRobin>:
#include "proc.h"
#include "pstat.h"

int status;

void roundRobin(int timeslice, int iterations, char *job, int jobcount){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 ec 18             	sub    $0x18,%esp
   9:	8b 7d 14             	mov    0x14(%ebp),%edi


    char **ptr = &job;
    struct pstat *pstat = malloc(sizeof(struct pstat));
   c:	68 00 0c 00 00       	push   $0xc00
  11:	e8 62 06 00 00       	call   678 <malloc>
  16:	89 c3                	mov    %eax,%ebx
    int jcount = 0;

    while ( jcount < jobcount ) {
  18:	83 c4 10             	add    $0x10,%esp
    int jcount = 0;
  1b:	be 00 00 00 00       	mov    $0x0,%esi
    while ( jcount < jobcount ) {
  20:	eb 08                	jmp    2a <roundRobin+0x2a>
        int pid = fork2(2);
        if (pid < 0) {
            exit();
  22:	e8 ce 02 00 00       	call   2f5 <exit>
        } else if (pid == 0) {
            exec(job, ptr);
        } else if (pid > 0) {
            // getpinfo(pstat);
        }
        jcount++;
  27:	83 c6 01             	add    $0x1,%esi
    while ( jcount < jobcount ) {
  2a:	39 fe                	cmp    %edi,%esi
  2c:	7d 29                	jge    57 <roundRobin+0x57>
        int pid = fork2(2);
  2e:	83 ec 0c             	sub    $0xc,%esp
  31:	6a 02                	push   $0x2
  33:	e8 6d 03 00 00       	call   3a5 <fork2>
        if (pid < 0) {
  38:	83 c4 10             	add    $0x10,%esp
  3b:	85 c0                	test   %eax,%eax
  3d:	78 e3                	js     22 <roundRobin+0x22>
        } else if (pid == 0) {
  3f:	85 c0                	test   %eax,%eax
  41:	75 e4                	jne    27 <roundRobin+0x27>
            exec(job, ptr);
  43:	83 ec 08             	sub    $0x8,%esp
  46:	8d 45 10             	lea    0x10(%ebp),%eax
  49:	50                   	push   %eax
  4a:	ff 75 10             	pushl  0x10(%ebp)
  4d:	e8 db 02 00 00       	call   32d <exec>
  52:	83 c4 10             	add    $0x10,%esp
  55:	eb d0                	jmp    27 <roundRobin+0x27>
    }

    for (int i = 0; i < iterations; i++){
  57:	be 00 00 00 00       	mov    $0x0,%esi
  5c:	eb 19                	jmp    77 <roundRobin+0x77>
        getpinfo(pstat);
        for(int j = 0; j < NPROC; j++) {
  5e:	83 c0 01             	add    $0x1,%eax
  61:	83 f8 3f             	cmp    $0x3f,%eax
  64:	7e f8                	jle    5e <roundRobin+0x5e>
            if (pstat->priority[j] == 2) {
//                int pri = getpri(pstat->pid[j]);
                //setpri(pstat->pid[j], 3);
            }
        }
        sleep(timeslice);
  66:	83 ec 0c             	sub    $0xc,%esp
  69:	ff 75 08             	pushl  0x8(%ebp)
  6c:	e8 14 03 00 00       	call   385 <sleep>
    for (int i = 0; i < iterations; i++){
  71:	83 c6 01             	add    $0x1,%esi
  74:	83 c4 10             	add    $0x10,%esp
  77:	3b 75 0c             	cmp    0xc(%ebp),%esi
  7a:	7d 13                	jge    8f <roundRobin+0x8f>
        getpinfo(pstat);
  7c:	83 ec 0c             	sub    $0xc,%esp
  7f:	53                   	push   %ebx
  80:	e8 28 03 00 00       	call   3ad <getpinfo>
        for(int j = 0; j < NPROC; j++) {
  85:	83 c4 10             	add    $0x10,%esp
  88:	b8 00 00 00 00       	mov    $0x0,%eax
  8d:	eb d2                	jmp    61 <roundRobin+0x61>
    }



    //wait();
    getpinfo(pstat);
  8f:	83 ec 0c             	sub    $0xc,%esp
  92:	53                   	push   %ebx
  93:	e8 15 03 00 00       	call   3ad <getpinfo>
    for (int i = 0; i < NPROC; i++) {
  98:	83 c4 10             	add    $0x10,%esp
  9b:	be 00 00 00 00       	mov    $0x0,%esi
  a0:	eb 15                	jmp    b7 <roundRobin+0xb7>
        for (int k = 0; k < 4; k++){
  a2:	83 c0 01             	add    $0x1,%eax
  a5:	83 f8 03             	cmp    $0x3,%eax
  a8:	7e f8                	jle    a2 <roundRobin+0xa2>
            // printf(1, "IS IN-USE %d XV6_SCHEDULER\t \t level %d ticks used %d\n", pstat->inuse[i], k, pstat->ticks[i][k]);
            // printf(1, "XV6_SCHEDULER\t \t level %d ticks used %d\n", k, pstat->ticks[i][k]);
        }

        if (pstat->pid[i] > 3) {
  aa:	83 bc b3 00 01 00 00 	cmpl   $0x3,0x100(%ebx,%esi,4)
  b1:	03 
  b2:	7f 0f                	jg     c3 <roundRobin+0xc3>
    for (int i = 0; i < NPROC; i++) {
  b4:	83 c6 01             	add    $0x1,%esi
  b7:	83 fe 3f             	cmp    $0x3f,%esi
  ba:	7f 20                	jg     dc <roundRobin+0xdc>
        for (int k = 0; k < 4; k++){
  bc:	b8 00 00 00 00       	mov    $0x0,%eax
  c1:	eb e2                	jmp    a5 <roundRobin+0xa5>
            //printf(1, "%s\n", "entered");

            //printf(1, "%s\n", "here");
            wait();
  c3:	e8 35 02 00 00       	call   2fd <wait>
            kill(pstat->pid[i]);
  c8:	83 ec 0c             	sub    $0xc,%esp
  cb:	ff b4 b3 00 01 00 00 	pushl  0x100(%ebx,%esi,4)
  d2:	e8 4e 02 00 00       	call   325 <kill>
  d7:	83 c4 10             	add    $0x10,%esp
  da:	eb d8                	jmp    b4 <roundRobin+0xb4>
        }
    }


}
  dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  df:	5b                   	pop    %ebx
  e0:	5e                   	pop    %esi
  e1:	5f                   	pop    %edi
  e2:	5d                   	pop    %ebp
  e3:	c3                   	ret    

000000e4 <main>:

int main(int argc, char *argv[]) {
  e4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  e8:	83 e4 f0             	and    $0xfffffff0,%esp
  eb:	ff 71 fc             	pushl  -0x4(%ecx)
  ee:	55                   	push   %ebp
  ef:	89 e5                	mov    %esp,%ebp
  f1:	57                   	push   %edi
  f2:	56                   	push   %esi
  f3:	53                   	push   %ebx
  f4:	51                   	push   %ecx
  f5:	83 ec 18             	sub    $0x18,%esp
  f8:	8b 59 04             	mov    0x4(%ecx),%ebx
    if(argc != 5) {
  fb:	83 39 05             	cmpl   $0x5,(%ecx)
  fe:	74 05                	je     105 <main+0x21>
        // TODO: print error message
        exit();
 100:	e8 f0 01 00 00       	call   2f5 <exit>
    }

    int timeslice = atoi(argv[1]);
 105:	83 ec 0c             	sub    $0xc,%esp
 108:	ff 73 04             	pushl  0x4(%ebx)
 10b:	e8 87 01 00 00       	call   297 <atoi>
 110:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    int iterations = atoi(argv[2]);
 113:	83 c4 04             	add    $0x4,%esp
 116:	ff 73 08             	pushl  0x8(%ebx)
 119:	e8 79 01 00 00       	call   297 <atoi>
 11e:	89 c7                	mov    %eax,%edi
    char *job = malloc(sizeof(char) * (strlen(argv[3]) + 1));
 120:	83 c4 04             	add    $0x4,%esp
 123:	ff 73 0c             	pushl  0xc(%ebx)
 126:	e8 81 00 00 00       	call   1ac <strlen>
 12b:	83 c0 01             	add    $0x1,%eax
 12e:	89 04 24             	mov    %eax,(%esp)
 131:	e8 42 05 00 00       	call   678 <malloc>
 136:	89 c6                	mov    %eax,%esi
    strcpy(job, argv[3]);
 138:	83 c4 08             	add    $0x8,%esp
 13b:	ff 73 0c             	pushl  0xc(%ebx)
 13e:	50                   	push   %eax
 13f:	e8 24 00 00 00       	call   168 <strcpy>
    int jobcount = atoi(argv[4]);
 144:	83 c4 04             	add    $0x4,%esp
 147:	ff 73 10             	pushl  0x10(%ebx)
 14a:	e8 48 01 00 00       	call   297 <atoi>

    roundRobin(timeslice, iterations, job, jobcount);
 14f:	50                   	push   %eax
 150:	56                   	push   %esi
 151:	57                   	push   %edi
 152:	ff 75 e4             	pushl  -0x1c(%ebp)
 155:	e8 a6 fe ff ff       	call   0 <roundRobin>
    free(job);
 15a:	83 c4 14             	add    $0x14,%esp
 15d:	56                   	push   %esi
 15e:	e8 55 04 00 00       	call   5b8 <free>
    exit();
 163:	e8 8d 01 00 00       	call   2f5 <exit>

00000168 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 168:	55                   	push   %ebp
 169:	89 e5                	mov    %esp,%ebp
 16b:	53                   	push   %ebx
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 172:	89 c2                	mov    %eax,%edx
 174:	0f b6 19             	movzbl (%ecx),%ebx
 177:	88 1a                	mov    %bl,(%edx)
 179:	8d 52 01             	lea    0x1(%edx),%edx
 17c:	8d 49 01             	lea    0x1(%ecx),%ecx
 17f:	84 db                	test   %bl,%bl
 181:	75 f1                	jne    174 <strcpy+0xc>
    ;
  return os;
}
 183:	5b                   	pop    %ebx
 184:	5d                   	pop    %ebp
 185:	c3                   	ret    

00000186 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 186:	55                   	push   %ebp
 187:	89 e5                	mov    %esp,%ebp
 189:	8b 4d 08             	mov    0x8(%ebp),%ecx
 18c:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 18f:	eb 06                	jmp    197 <strcmp+0x11>
    p++, q++;
 191:	83 c1 01             	add    $0x1,%ecx
 194:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 197:	0f b6 01             	movzbl (%ecx),%eax
 19a:	84 c0                	test   %al,%al
 19c:	74 04                	je     1a2 <strcmp+0x1c>
 19e:	3a 02                	cmp    (%edx),%al
 1a0:	74 ef                	je     191 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 1a2:	0f b6 c0             	movzbl %al,%eax
 1a5:	0f b6 12             	movzbl (%edx),%edx
 1a8:	29 d0                	sub    %edx,%eax
}
 1aa:	5d                   	pop    %ebp
 1ab:	c3                   	ret    

000001ac <strlen>:

uint
strlen(const char *s)
{
 1ac:	55                   	push   %ebp
 1ad:	89 e5                	mov    %esp,%ebp
 1af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1b2:	ba 00 00 00 00       	mov    $0x0,%edx
 1b7:	eb 03                	jmp    1bc <strlen+0x10>
 1b9:	83 c2 01             	add    $0x1,%edx
 1bc:	89 d0                	mov    %edx,%eax
 1be:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1c2:	75 f5                	jne    1b9 <strlen+0xd>
    ;
  return n;
}
 1c4:	5d                   	pop    %ebp
 1c5:	c3                   	ret    

000001c6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c6:	55                   	push   %ebp
 1c7:	89 e5                	mov    %esp,%ebp
 1c9:	57                   	push   %edi
 1ca:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1cd:	89 d7                	mov    %edx,%edi
 1cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d5:	fc                   	cld    
 1d6:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1d8:	89 d0                	mov    %edx,%eax
 1da:	5f                   	pop    %edi
 1db:	5d                   	pop    %ebp
 1dc:	c3                   	ret    

000001dd <strchr>:

char*
strchr(const char *s, char c)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1e7:	0f b6 10             	movzbl (%eax),%edx
 1ea:	84 d2                	test   %dl,%dl
 1ec:	74 09                	je     1f7 <strchr+0x1a>
    if(*s == c)
 1ee:	38 ca                	cmp    %cl,%dl
 1f0:	74 0a                	je     1fc <strchr+0x1f>
  for(; *s; s++)
 1f2:	83 c0 01             	add    $0x1,%eax
 1f5:	eb f0                	jmp    1e7 <strchr+0xa>
      return (char*)s;
  return 0;
 1f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1fc:	5d                   	pop    %ebp
 1fd:	c3                   	ret    

000001fe <gets>:

char*
gets(char *buf, int max)
{
 1fe:	55                   	push   %ebp
 1ff:	89 e5                	mov    %esp,%ebp
 201:	57                   	push   %edi
 202:	56                   	push   %esi
 203:	53                   	push   %ebx
 204:	83 ec 1c             	sub    $0x1c,%esp
 207:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20a:	bb 00 00 00 00       	mov    $0x0,%ebx
 20f:	8d 73 01             	lea    0x1(%ebx),%esi
 212:	3b 75 0c             	cmp    0xc(%ebp),%esi
 215:	7d 2e                	jge    245 <gets+0x47>
    cc = read(0, &c, 1);
 217:	83 ec 04             	sub    $0x4,%esp
 21a:	6a 01                	push   $0x1
 21c:	8d 45 e7             	lea    -0x19(%ebp),%eax
 21f:	50                   	push   %eax
 220:	6a 00                	push   $0x0
 222:	e8 e6 00 00 00       	call   30d <read>
    if(cc < 1)
 227:	83 c4 10             	add    $0x10,%esp
 22a:	85 c0                	test   %eax,%eax
 22c:	7e 17                	jle    245 <gets+0x47>
      break;
    buf[i++] = c;
 22e:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 232:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 235:	3c 0a                	cmp    $0xa,%al
 237:	0f 94 c2             	sete   %dl
 23a:	3c 0d                	cmp    $0xd,%al
 23c:	0f 94 c0             	sete   %al
    buf[i++] = c;
 23f:	89 f3                	mov    %esi,%ebx
    if(c == '\n' || c == '\r')
 241:	08 c2                	or     %al,%dl
 243:	74 ca                	je     20f <gets+0x11>
      break;
  }
  buf[i] = '\0';
 245:	c6 04 1f 00          	movb   $0x0,(%edi,%ebx,1)
  return buf;
}
 249:	89 f8                	mov    %edi,%eax
 24b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 24e:	5b                   	pop    %ebx
 24f:	5e                   	pop    %esi
 250:	5f                   	pop    %edi
 251:	5d                   	pop    %ebp
 252:	c3                   	ret    

00000253 <stat>:

int
stat(const char *n, struct stat *st)
{
 253:	55                   	push   %ebp
 254:	89 e5                	mov    %esp,%ebp
 256:	56                   	push   %esi
 257:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 258:	83 ec 08             	sub    $0x8,%esp
 25b:	6a 00                	push   $0x0
 25d:	ff 75 08             	pushl  0x8(%ebp)
 260:	e8 d0 00 00 00       	call   335 <open>
  if(fd < 0)
 265:	83 c4 10             	add    $0x10,%esp
 268:	85 c0                	test   %eax,%eax
 26a:	78 24                	js     290 <stat+0x3d>
 26c:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 26e:	83 ec 08             	sub    $0x8,%esp
 271:	ff 75 0c             	pushl  0xc(%ebp)
 274:	50                   	push   %eax
 275:	e8 d3 00 00 00       	call   34d <fstat>
 27a:	89 c6                	mov    %eax,%esi
  close(fd);
 27c:	89 1c 24             	mov    %ebx,(%esp)
 27f:	e8 99 00 00 00       	call   31d <close>
  return r;
 284:	83 c4 10             	add    $0x10,%esp
}
 287:	89 f0                	mov    %esi,%eax
 289:	8d 65 f8             	lea    -0x8(%ebp),%esp
 28c:	5b                   	pop    %ebx
 28d:	5e                   	pop    %esi
 28e:	5d                   	pop    %ebp
 28f:	c3                   	ret    
    return -1;
 290:	be ff ff ff ff       	mov    $0xffffffff,%esi
 295:	eb f0                	jmp    287 <stat+0x34>

00000297 <atoi>:

int
atoi(const char *s)
{
 297:	55                   	push   %ebp
 298:	89 e5                	mov    %esp,%ebp
 29a:	53                   	push   %ebx
 29b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 29e:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 2a3:	eb 10                	jmp    2b5 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 2a5:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
 2a8:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
 2ab:	83 c1 01             	add    $0x1,%ecx
 2ae:	0f be d2             	movsbl %dl,%edx
 2b1:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
  while('0' <= *s && *s <= '9')
 2b5:	0f b6 11             	movzbl (%ecx),%edx
 2b8:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2bb:	80 fb 09             	cmp    $0x9,%bl
 2be:	76 e5                	jbe    2a5 <atoi+0xe>
  return n;
}
 2c0:	5b                   	pop    %ebx
 2c1:	5d                   	pop    %ebp
 2c2:	c3                   	ret    

000002c3 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c3:	55                   	push   %ebp
 2c4:	89 e5                	mov    %esp,%ebp
 2c6:	56                   	push   %esi
 2c7:	53                   	push   %ebx
 2c8:	8b 45 08             	mov    0x8(%ebp),%eax
 2cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 2ce:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 2d1:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 2d3:	eb 0d                	jmp    2e2 <memmove+0x1f>
    *dst++ = *src++;
 2d5:	0f b6 13             	movzbl (%ebx),%edx
 2d8:	88 11                	mov    %dl,(%ecx)
 2da:	8d 5b 01             	lea    0x1(%ebx),%ebx
 2dd:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 2e0:	89 f2                	mov    %esi,%edx
 2e2:	8d 72 ff             	lea    -0x1(%edx),%esi
 2e5:	85 d2                	test   %edx,%edx
 2e7:	7f ec                	jg     2d5 <memmove+0x12>
  return vdst;
}
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

00000395 <setpri>:
// adding sys calls
SYSCALL(setpri)
 395:	b8 16 00 00 00       	mov    $0x16,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <getpri>:
SYSCALL(getpri)
 39d:	b8 17 00 00 00       	mov    $0x17,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <fork2>:
SYSCALL(fork2)
 3a5:	b8 18 00 00 00       	mov    $0x18,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <getpinfo>:
SYSCALL(getpinfo)
 3ad:	b8 19 00 00 00       	mov    $0x19,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3b5:	55                   	push   %ebp
 3b6:	89 e5                	mov    %esp,%ebp
 3b8:	83 ec 1c             	sub    $0x1c,%esp
 3bb:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 3be:	6a 01                	push   $0x1
 3c0:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3c3:	52                   	push   %edx
 3c4:	50                   	push   %eax
 3c5:	e8 4b ff ff ff       	call   315 <write>
}
 3ca:	83 c4 10             	add    $0x10,%esp
 3cd:	c9                   	leave  
 3ce:	c3                   	ret    

000003cf <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3cf:	55                   	push   %ebp
 3d0:	89 e5                	mov    %esp,%ebp
 3d2:	57                   	push   %edi
 3d3:	56                   	push   %esi
 3d4:	53                   	push   %ebx
 3d5:	83 ec 2c             	sub    $0x2c,%esp
 3d8:	89 c7                	mov    %eax,%edi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3de:	0f 95 c3             	setne  %bl
 3e1:	89 d0                	mov    %edx,%eax
 3e3:	c1 e8 1f             	shr    $0x1f,%eax
 3e6:	84 c3                	test   %al,%bl
 3e8:	74 10                	je     3fa <printint+0x2b>
    neg = 1;
    x = -xx;
 3ea:	f7 da                	neg    %edx
    neg = 1;
 3ec:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3f3:	be 00 00 00 00       	mov    $0x0,%esi
 3f8:	eb 0b                	jmp    405 <printint+0x36>
  neg = 0;
 3fa:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 401:	eb f0                	jmp    3f3 <printint+0x24>
  do{
    buf[i++] = digits[x % base];
 403:	89 c6                	mov    %eax,%esi
 405:	89 d0                	mov    %edx,%eax
 407:	ba 00 00 00 00       	mov    $0x0,%edx
 40c:	f7 f1                	div    %ecx
 40e:	89 c3                	mov    %eax,%ebx
 410:	8d 46 01             	lea    0x1(%esi),%eax
 413:	0f b6 92 10 07 00 00 	movzbl 0x710(%edx),%edx
 41a:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
 41e:	89 da                	mov    %ebx,%edx
 420:	85 db                	test   %ebx,%ebx
 422:	75 df                	jne    403 <printint+0x34>
 424:	89 c3                	mov    %eax,%ebx
  if(neg)
 426:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 42a:	74 16                	je     442 <printint+0x73>
    buf[i++] = '-';
 42c:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
 431:	8d 5e 02             	lea    0x2(%esi),%ebx
 434:	eb 0c                	jmp    442 <printint+0x73>

  while(--i >= 0)
    putc(fd, buf[i]);
 436:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 43b:	89 f8                	mov    %edi,%eax
 43d:	e8 73 ff ff ff       	call   3b5 <putc>
  while(--i >= 0)
 442:	83 eb 01             	sub    $0x1,%ebx
 445:	79 ef                	jns    436 <printint+0x67>
}
 447:	83 c4 2c             	add    $0x2c,%esp
 44a:	5b                   	pop    %ebx
 44b:	5e                   	pop    %esi
 44c:	5f                   	pop    %edi
 44d:	5d                   	pop    %ebp
 44e:	c3                   	ret    

0000044f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 44f:	55                   	push   %ebp
 450:	89 e5                	mov    %esp,%ebp
 452:	57                   	push   %edi
 453:	56                   	push   %esi
 454:	53                   	push   %ebx
 455:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 458:	8d 45 10             	lea    0x10(%ebp),%eax
 45b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 45e:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 463:	bb 00 00 00 00       	mov    $0x0,%ebx
 468:	eb 14                	jmp    47e <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 46a:	89 fa                	mov    %edi,%edx
 46c:	8b 45 08             	mov    0x8(%ebp),%eax
 46f:	e8 41 ff ff ff       	call   3b5 <putc>
 474:	eb 05                	jmp    47b <printf+0x2c>
      }
    } else if(state == '%'){
 476:	83 fe 25             	cmp    $0x25,%esi
 479:	74 25                	je     4a0 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 47b:	83 c3 01             	add    $0x1,%ebx
 47e:	8b 45 0c             	mov    0xc(%ebp),%eax
 481:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 485:	84 c0                	test   %al,%al
 487:	0f 84 23 01 00 00    	je     5b0 <printf+0x161>
    c = fmt[i] & 0xff;
 48d:	0f be f8             	movsbl %al,%edi
 490:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 493:	85 f6                	test   %esi,%esi
 495:	75 df                	jne    476 <printf+0x27>
      if(c == '%'){
 497:	83 f8 25             	cmp    $0x25,%eax
 49a:	75 ce                	jne    46a <printf+0x1b>
        state = '%';
 49c:	89 c6                	mov    %eax,%esi
 49e:	eb db                	jmp    47b <printf+0x2c>
      if(c == 'd'){
 4a0:	83 f8 64             	cmp    $0x64,%eax
 4a3:	74 49                	je     4ee <printf+0x9f>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4a5:	83 f8 78             	cmp    $0x78,%eax
 4a8:	0f 94 c1             	sete   %cl
 4ab:	83 f8 70             	cmp    $0x70,%eax
 4ae:	0f 94 c2             	sete   %dl
 4b1:	08 d1                	or     %dl,%cl
 4b3:	75 63                	jne    518 <printf+0xc9>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4b5:	83 f8 73             	cmp    $0x73,%eax
 4b8:	0f 84 84 00 00 00    	je     542 <printf+0xf3>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4be:	83 f8 63             	cmp    $0x63,%eax
 4c1:	0f 84 b7 00 00 00    	je     57e <printf+0x12f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4c7:	83 f8 25             	cmp    $0x25,%eax
 4ca:	0f 84 cc 00 00 00    	je     59c <printf+0x14d>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4d0:	ba 25 00 00 00       	mov    $0x25,%edx
 4d5:	8b 45 08             	mov    0x8(%ebp),%eax
 4d8:	e8 d8 fe ff ff       	call   3b5 <putc>
        putc(fd, c);
 4dd:	89 fa                	mov    %edi,%edx
 4df:	8b 45 08             	mov    0x8(%ebp),%eax
 4e2:	e8 ce fe ff ff       	call   3b5 <putc>
      }
      state = 0;
 4e7:	be 00 00 00 00       	mov    $0x0,%esi
 4ec:	eb 8d                	jmp    47b <printf+0x2c>
        printint(fd, *ap, 10, 1);
 4ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4f1:	8b 17                	mov    (%edi),%edx
 4f3:	83 ec 0c             	sub    $0xc,%esp
 4f6:	6a 01                	push   $0x1
 4f8:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4fd:	8b 45 08             	mov    0x8(%ebp),%eax
 500:	e8 ca fe ff ff       	call   3cf <printint>
        ap++;
 505:	83 c7 04             	add    $0x4,%edi
 508:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 50b:	83 c4 10             	add    $0x10,%esp
      state = 0;
 50e:	be 00 00 00 00       	mov    $0x0,%esi
 513:	e9 63 ff ff ff       	jmp    47b <printf+0x2c>
        printint(fd, *ap, 16, 0);
 518:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 51b:	8b 17                	mov    (%edi),%edx
 51d:	83 ec 0c             	sub    $0xc,%esp
 520:	6a 00                	push   $0x0
 522:	b9 10 00 00 00       	mov    $0x10,%ecx
 527:	8b 45 08             	mov    0x8(%ebp),%eax
 52a:	e8 a0 fe ff ff       	call   3cf <printint>
        ap++;
 52f:	83 c7 04             	add    $0x4,%edi
 532:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 535:	83 c4 10             	add    $0x10,%esp
      state = 0;
 538:	be 00 00 00 00       	mov    $0x0,%esi
 53d:	e9 39 ff ff ff       	jmp    47b <printf+0x2c>
        s = (char*)*ap;
 542:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 545:	8b 30                	mov    (%eax),%esi
        ap++;
 547:	83 c0 04             	add    $0x4,%eax
 54a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 54d:	85 f6                	test   %esi,%esi
 54f:	75 28                	jne    579 <printf+0x12a>
          s = "(null)";
 551:	be 08 07 00 00       	mov    $0x708,%esi
 556:	8b 7d 08             	mov    0x8(%ebp),%edi
 559:	eb 0d                	jmp    568 <printf+0x119>
          putc(fd, *s);
 55b:	0f be d2             	movsbl %dl,%edx
 55e:	89 f8                	mov    %edi,%eax
 560:	e8 50 fe ff ff       	call   3b5 <putc>
          s++;
 565:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 568:	0f b6 16             	movzbl (%esi),%edx
 56b:	84 d2                	test   %dl,%dl
 56d:	75 ec                	jne    55b <printf+0x10c>
      state = 0;
 56f:	be 00 00 00 00       	mov    $0x0,%esi
 574:	e9 02 ff ff ff       	jmp    47b <printf+0x2c>
 579:	8b 7d 08             	mov    0x8(%ebp),%edi
 57c:	eb ea                	jmp    568 <printf+0x119>
        putc(fd, *ap);
 57e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 581:	0f be 17             	movsbl (%edi),%edx
 584:	8b 45 08             	mov    0x8(%ebp),%eax
 587:	e8 29 fe ff ff       	call   3b5 <putc>
        ap++;
 58c:	83 c7 04             	add    $0x4,%edi
 58f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 592:	be 00 00 00 00       	mov    $0x0,%esi
 597:	e9 df fe ff ff       	jmp    47b <printf+0x2c>
        putc(fd, c);
 59c:	89 fa                	mov    %edi,%edx
 59e:	8b 45 08             	mov    0x8(%ebp),%eax
 5a1:	e8 0f fe ff ff       	call   3b5 <putc>
      state = 0;
 5a6:	be 00 00 00 00       	mov    $0x0,%esi
 5ab:	e9 cb fe ff ff       	jmp    47b <printf+0x2c>
    }
  }
}
 5b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5b3:	5b                   	pop    %ebx
 5b4:	5e                   	pop    %esi
 5b5:	5f                   	pop    %edi
 5b6:	5d                   	pop    %ebp
 5b7:	c3                   	ret    

000005b8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5b8:	55                   	push   %ebp
 5b9:	89 e5                	mov    %esp,%ebp
 5bb:	57                   	push   %edi
 5bc:	56                   	push   %esi
 5bd:	53                   	push   %ebx
 5be:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5c1:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c4:	a1 e0 09 00 00       	mov    0x9e0,%eax
 5c9:	eb 02                	jmp    5cd <free+0x15>
 5cb:	89 d0                	mov    %edx,%eax
 5cd:	39 c8                	cmp    %ecx,%eax
 5cf:	73 04                	jae    5d5 <free+0x1d>
 5d1:	39 08                	cmp    %ecx,(%eax)
 5d3:	77 12                	ja     5e7 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d5:	8b 10                	mov    (%eax),%edx
 5d7:	39 c2                	cmp    %eax,%edx
 5d9:	77 f0                	ja     5cb <free+0x13>
 5db:	39 c8                	cmp    %ecx,%eax
 5dd:	72 08                	jb     5e7 <free+0x2f>
 5df:	39 ca                	cmp    %ecx,%edx
 5e1:	77 04                	ja     5e7 <free+0x2f>
 5e3:	89 d0                	mov    %edx,%eax
 5e5:	eb e6                	jmp    5cd <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5e7:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5ea:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5ed:	8b 10                	mov    (%eax),%edx
 5ef:	39 d7                	cmp    %edx,%edi
 5f1:	74 19                	je     60c <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5f3:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5f6:	8b 50 04             	mov    0x4(%eax),%edx
 5f9:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5fc:	39 ce                	cmp    %ecx,%esi
 5fe:	74 1b                	je     61b <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 600:	89 08                	mov    %ecx,(%eax)
  freep = p;
 602:	a3 e0 09 00 00       	mov    %eax,0x9e0
}
 607:	5b                   	pop    %ebx
 608:	5e                   	pop    %esi
 609:	5f                   	pop    %edi
 60a:	5d                   	pop    %ebp
 60b:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 60c:	03 72 04             	add    0x4(%edx),%esi
 60f:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 612:	8b 10                	mov    (%eax),%edx
 614:	8b 12                	mov    (%edx),%edx
 616:	89 53 f8             	mov    %edx,-0x8(%ebx)
 619:	eb db                	jmp    5f6 <free+0x3e>
    p->s.size += bp->s.size;
 61b:	03 53 fc             	add    -0x4(%ebx),%edx
 61e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 621:	8b 53 f8             	mov    -0x8(%ebx),%edx
 624:	89 10                	mov    %edx,(%eax)
 626:	eb da                	jmp    602 <free+0x4a>

00000628 <morecore>:

static Header*
morecore(uint nu)
{
 628:	55                   	push   %ebp
 629:	89 e5                	mov    %esp,%ebp
 62b:	53                   	push   %ebx
 62c:	83 ec 04             	sub    $0x4,%esp
 62f:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 631:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 636:	77 05                	ja     63d <morecore+0x15>
    nu = 4096;
 638:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 63d:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 644:	83 ec 0c             	sub    $0xc,%esp
 647:	50                   	push   %eax
 648:	e8 30 fd ff ff       	call   37d <sbrk>
  if(p == (char*)-1)
 64d:	83 c4 10             	add    $0x10,%esp
 650:	83 f8 ff             	cmp    $0xffffffff,%eax
 653:	74 1c                	je     671 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 655:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 658:	83 c0 08             	add    $0x8,%eax
 65b:	83 ec 0c             	sub    $0xc,%esp
 65e:	50                   	push   %eax
 65f:	e8 54 ff ff ff       	call   5b8 <free>
  return freep;
 664:	a1 e0 09 00 00       	mov    0x9e0,%eax
 669:	83 c4 10             	add    $0x10,%esp
}
 66c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 66f:	c9                   	leave  
 670:	c3                   	ret    
    return 0;
 671:	b8 00 00 00 00       	mov    $0x0,%eax
 676:	eb f4                	jmp    66c <morecore+0x44>

00000678 <malloc>:

void*
malloc(uint nbytes)
{
 678:	55                   	push   %ebp
 679:	89 e5                	mov    %esp,%ebp
 67b:	53                   	push   %ebx
 67c:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 67f:	8b 45 08             	mov    0x8(%ebp),%eax
 682:	8d 58 07             	lea    0x7(%eax),%ebx
 685:	c1 eb 03             	shr    $0x3,%ebx
 688:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 68b:	8b 0d e0 09 00 00    	mov    0x9e0,%ecx
 691:	85 c9                	test   %ecx,%ecx
 693:	74 04                	je     699 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 695:	8b 01                	mov    (%ecx),%eax
 697:	eb 4d                	jmp    6e6 <malloc+0x6e>
    base.s.ptr = freep = prevp = &base;
 699:	c7 05 e0 09 00 00 e4 	movl   $0x9e4,0x9e0
 6a0:	09 00 00 
 6a3:	c7 05 e4 09 00 00 e4 	movl   $0x9e4,0x9e4
 6aa:	09 00 00 
    base.s.size = 0;
 6ad:	c7 05 e8 09 00 00 00 	movl   $0x0,0x9e8
 6b4:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6b7:	b9 e4 09 00 00       	mov    $0x9e4,%ecx
 6bc:	eb d7                	jmp    695 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 6be:	39 da                	cmp    %ebx,%edx
 6c0:	74 1a                	je     6dc <malloc+0x64>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6c2:	29 da                	sub    %ebx,%edx
 6c4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 6c7:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 6ca:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6cd:	89 0d e0 09 00 00    	mov    %ecx,0x9e0
      return (void*)(p + 1);
 6d3:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6d6:	83 c4 04             	add    $0x4,%esp
 6d9:	5b                   	pop    %ebx
 6da:	5d                   	pop    %ebp
 6db:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6dc:	8b 10                	mov    (%eax),%edx
 6de:	89 11                	mov    %edx,(%ecx)
 6e0:	eb eb                	jmp    6cd <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6e2:	89 c1                	mov    %eax,%ecx
 6e4:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 6e6:	8b 50 04             	mov    0x4(%eax),%edx
 6e9:	39 da                	cmp    %ebx,%edx
 6eb:	73 d1                	jae    6be <malloc+0x46>
    if(p == freep)
 6ed:	39 05 e0 09 00 00    	cmp    %eax,0x9e0
 6f3:	75 ed                	jne    6e2 <malloc+0x6a>
      if((p = morecore(nunits)) == 0)
 6f5:	89 d8                	mov    %ebx,%eax
 6f7:	e8 2c ff ff ff       	call   628 <morecore>
 6fc:	85 c0                	test   %eax,%eax
 6fe:	75 e2                	jne    6e2 <malloc+0x6a>
        return 0;
 700:	b8 00 00 00 00       	mov    $0x0,%eax
 705:	eb cf                	jmp    6d6 <malloc+0x5e>
