
user/_forkbench:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <compute_workload>:
#include "user/user.h"

#define NUM_FORKS 1000   // Reduce if system slows down
#define WORKLOAD  50000 // Per-child computation size

void compute_workload() {
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
   6:	67b1                	lui	a5,0xc
   8:	35078793          	addi	a5,a5,848 # c350 <base+0xb340>
    int sum = 0;
    for (int i = 0; i < WORKLOAD; i++) {
   c:	37fd                	addiw	a5,a5,-1
   e:	fffd                	bnez	a5,c <compute_workload+0xc>
        sum += (i * i) % 97;  // Arbitrary arithmetic
    }
}
  10:	6422                	ld	s0,8(sp)
  12:	0141                	addi	sp,sp,16
  14:	8082                	ret

0000000000000016 <io_workload>:

void io_workload(int child_id) {
    if (child_id % 50 == 0) {  // Occasionally print
  16:	03200793          	li	a5,50
  1a:	02f567bb          	remw	a5,a0,a5
  1e:	c391                	beqz	a5,22 <io_workload+0xc>
  20:	8082                	ret
void io_workload(int child_id) {
  22:	1141                	addi	sp,sp,-16
  24:	e406                	sd	ra,8(sp)
  26:	e022                	sd	s0,0(sp)
  28:	0800                	addi	s0,sp,16
        printf("Child %d finished workload.\n", child_id);
  2a:	85aa                	mv	a1,a0
  2c:	00001517          	auipc	a0,0x1
  30:	8c450513          	addi	a0,a0,-1852 # 8f0 <malloc+0xea>
  34:	00000097          	auipc	ra,0x0
  38:	714080e7          	jalr	1812(ra) # 748 <printf>
    }
}
  3c:	60a2                	ld	ra,8(sp)
  3e:	6402                	ld	s0,0(sp)
  40:	0141                	addi	sp,sp,16
  42:	8082                	ret

0000000000000044 <main>:

int main(int argc, char *argv[]) {
  44:	7179                	addi	sp,sp,-48
  46:	f406                	sd	ra,40(sp)
  48:	f022                	sd	s0,32(sp)
  4a:	ec26                	sd	s1,24(sp)
  4c:	e84a                	sd	s2,16(sp)
  4e:	e44e                	sd	s3,8(sp)
  50:	1800                	addi	s0,sp,48
    int start_ticks, end_ticks;
    int pid;

    start_ticks = uptime();
  52:	00000097          	auipc	ra,0x0
  56:	3e6080e7          	jalr	998(ra) # 438 <uptime>
  5a:	89aa                	mv	s3,a0

    for (int i = 0; i < NUM_FORKS; i++) {
  5c:	4481                	li	s1,0
  5e:	3e800913          	li	s2,1000
        pid = fork();
  62:	00000097          	auipc	ra,0x0
  66:	336080e7          	jalr	822(ra) # 398 <fork>
        if (pid < 0) {
  6a:	06054f63          	bltz	a0,e8 <main+0xa4>
            printf("Fork failed at iteration %d\n", i);
            exit(1);
        } 
        else if (pid == 0) {
  6e:	c959                	beqz	a0,104 <main+0xc0>
            compute_workload();
            io_workload(i);
            exit(0);
        } 
        else {
            wait(0);
  70:	4501                	li	a0,0
  72:	00000097          	auipc	ra,0x0
  76:	336080e7          	jalr	822(ra) # 3a8 <wait>
    for (int i = 0; i < NUM_FORKS; i++) {
  7a:	2485                	addiw	s1,s1,1
  7c:	ff2493e3          	bne	s1,s2,62 <main+0x1e>
        }
    }

    end_ticks = uptime();
  80:	00000097          	auipc	ra,0x0
  84:	3b8080e7          	jalr	952(ra) # 438 <uptime>
    int total_ticks = end_ticks - start_ticks;
  88:	413509bb          	subw	s3,a0,s3
  8c:	0009849b          	sext.w	s1,s3

    printf("\n--- Realistic Fork Benchmark Results ---\n");
  90:	00001517          	auipc	a0,0x1
  94:	8a050513          	addi	a0,a0,-1888 # 930 <malloc+0x12a>
  98:	00000097          	auipc	ra,0x0
  9c:	6b0080e7          	jalr	1712(ra) # 748 <printf>
    printf("Total forks: %d\n", NUM_FORKS);
  a0:	3e800593          	li	a1,1000
  a4:	00001517          	auipc	a0,0x1
  a8:	8bc50513          	addi	a0,a0,-1860 # 960 <malloc+0x15a>
  ac:	00000097          	auipc	ra,0x0
  b0:	69c080e7          	jalr	1692(ra) # 748 <printf>
    printf("Total time in ticks: %d\n", total_ticks);
  b4:	85a6                	mv	a1,s1
  b6:	00001517          	auipc	a0,0x1
  ba:	8c250513          	addi	a0,a0,-1854 # 978 <malloc+0x172>
  be:	00000097          	auipc	ra,0x0
  c2:	68a080e7          	jalr	1674(ra) # 748 <printf>
    printf("Average time per fork: %d ticks\n", total_ticks / NUM_FORKS);
  c6:	3e800593          	li	a1,1000
  ca:	02b9c5bb          	divw	a1,s3,a1
  ce:	00001517          	auipc	a0,0x1
  d2:	8ca50513          	addi	a0,a0,-1846 # 998 <malloc+0x192>
  d6:	00000097          	auipc	ra,0x0
  da:	672080e7          	jalr	1650(ra) # 748 <printf>
    exit(0);
  de:	4501                	li	a0,0
  e0:	00000097          	auipc	ra,0x0
  e4:	2c0080e7          	jalr	704(ra) # 3a0 <exit>
            printf("Fork failed at iteration %d\n", i);
  e8:	85a6                	mv	a1,s1
  ea:	00001517          	auipc	a0,0x1
  ee:	82650513          	addi	a0,a0,-2010 # 910 <malloc+0x10a>
  f2:	00000097          	auipc	ra,0x0
  f6:	656080e7          	jalr	1622(ra) # 748 <printf>
            exit(1);
  fa:	4505                	li	a0,1
  fc:	00000097          	auipc	ra,0x0
 100:	2a4080e7          	jalr	676(ra) # 3a0 <exit>
            io_workload(i);
 104:	8526                	mv	a0,s1
 106:	00000097          	auipc	ra,0x0
 10a:	f10080e7          	jalr	-240(ra) # 16 <io_workload>
            exit(0);
 10e:	4501                	li	a0,0
 110:	00000097          	auipc	ra,0x0
 114:	290080e7          	jalr	656(ra) # 3a0 <exit>

0000000000000118 <_main>:

//
// wrapper so that it's OK if main() does not call exit().
//
void _main()
{
 118:	1141                	addi	sp,sp,-16
 11a:	e406                	sd	ra,8(sp)
 11c:	e022                	sd	s0,0(sp)
 11e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 120:	00000097          	auipc	ra,0x0
 124:	f24080e7          	jalr	-220(ra) # 44 <main>
  exit(0);
 128:	4501                	li	a0,0
 12a:	00000097          	auipc	ra,0x0
 12e:	276080e7          	jalr	630(ra) # 3a0 <exit>

0000000000000132 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 132:	1141                	addi	sp,sp,-16
 134:	e422                	sd	s0,8(sp)
 136:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 138:	87aa                	mv	a5,a0
 13a:	0585                	addi	a1,a1,1
 13c:	0785                	addi	a5,a5,1
 13e:	fff5c703          	lbu	a4,-1(a1)
 142:	fee78fa3          	sb	a4,-1(a5)
 146:	fb75                	bnez	a4,13a <strcpy+0x8>
    ;
  return os;
}
 148:	6422                	ld	s0,8(sp)
 14a:	0141                	addi	sp,sp,16
 14c:	8082                	ret

000000000000014e <strcmp>:

int strcmp(const char *p, const char *q)
{
 14e:	1141                	addi	sp,sp,-16
 150:	e422                	sd	s0,8(sp)
 152:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 154:	00054783          	lbu	a5,0(a0)
 158:	cb91                	beqz	a5,16c <strcmp+0x1e>
 15a:	0005c703          	lbu	a4,0(a1)
 15e:	00f71763          	bne	a4,a5,16c <strcmp+0x1e>
    p++, q++;
 162:	0505                	addi	a0,a0,1
 164:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 166:	00054783          	lbu	a5,0(a0)
 16a:	fbe5                	bnez	a5,15a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 16c:	0005c503          	lbu	a0,0(a1)
}
 170:	40a7853b          	subw	a0,a5,a0
 174:	6422                	ld	s0,8(sp)
 176:	0141                	addi	sp,sp,16
 178:	8082                	ret

000000000000017a <strlen>:

uint strlen(const char *s)
{
 17a:	1141                	addi	sp,sp,-16
 17c:	e422                	sd	s0,8(sp)
 17e:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 180:	00054783          	lbu	a5,0(a0)
 184:	cf91                	beqz	a5,1a0 <strlen+0x26>
 186:	0505                	addi	a0,a0,1
 188:	87aa                	mv	a5,a0
 18a:	4685                	li	a3,1
 18c:	9e89                	subw	a3,a3,a0
 18e:	00f6853b          	addw	a0,a3,a5
 192:	0785                	addi	a5,a5,1
 194:	fff7c703          	lbu	a4,-1(a5)
 198:	fb7d                	bnez	a4,18e <strlen+0x14>
    ;
  return n;
}
 19a:	6422                	ld	s0,8(sp)
 19c:	0141                	addi	sp,sp,16
 19e:	8082                	ret
  for (n = 0; s[n]; n++)
 1a0:	4501                	li	a0,0
 1a2:	bfe5                	j	19a <strlen+0x20>

00000000000001a4 <memset>:

void *
memset(void *dst, int c, uint n)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++)
 1aa:	ca19                	beqz	a2,1c0 <memset+0x1c>
 1ac:	87aa                	mv	a5,a0
 1ae:	1602                	slli	a2,a2,0x20
 1b0:	9201                	srli	a2,a2,0x20
 1b2:	00a60733          	add	a4,a2,a0
  {
    cdst[i] = c;
 1b6:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++)
 1ba:	0785                	addi	a5,a5,1
 1bc:	fee79de3          	bne	a5,a4,1b6 <memset+0x12>
  }
  return dst;
}
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret

00000000000001c6 <strchr>:

char *
strchr(const char *s, char c)
{
 1c6:	1141                	addi	sp,sp,-16
 1c8:	e422                	sd	s0,8(sp)
 1ca:	0800                	addi	s0,sp,16
  for (; *s; s++)
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	cb99                	beqz	a5,1e6 <strchr+0x20>
    if (*s == c)
 1d2:	00f58763          	beq	a1,a5,1e0 <strchr+0x1a>
  for (; *s; s++)
 1d6:	0505                	addi	a0,a0,1
 1d8:	00054783          	lbu	a5,0(a0)
 1dc:	fbfd                	bnez	a5,1d2 <strchr+0xc>
      return (char *)s;
  return 0;
 1de:	4501                	li	a0,0
}
 1e0:	6422                	ld	s0,8(sp)
 1e2:	0141                	addi	sp,sp,16
 1e4:	8082                	ret
  return 0;
 1e6:	4501                	li	a0,0
 1e8:	bfe5                	j	1e0 <strchr+0x1a>

00000000000001ea <gets>:

char *
gets(char *buf, int max)
{
 1ea:	711d                	addi	sp,sp,-96
 1ec:	ec86                	sd	ra,88(sp)
 1ee:	e8a2                	sd	s0,80(sp)
 1f0:	e4a6                	sd	s1,72(sp)
 1f2:	e0ca                	sd	s2,64(sp)
 1f4:	fc4e                	sd	s3,56(sp)
 1f6:	f852                	sd	s4,48(sp)
 1f8:	f456                	sd	s5,40(sp)
 1fa:	f05a                	sd	s6,32(sp)
 1fc:	ec5e                	sd	s7,24(sp)
 1fe:	1080                	addi	s0,sp,96
 200:	8baa                	mv	s7,a0
 202:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;)
 204:	892a                	mv	s2,a0
 206:	4481                	li	s1,0
  {
    cc = read(0, &c, 1);
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 208:	4aa9                	li	s5,10
 20a:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;)
 20c:	89a6                	mv	s3,s1
 20e:	2485                	addiw	s1,s1,1
 210:	0344d863          	bge	s1,s4,240 <gets+0x56>
    cc = read(0, &c, 1);
 214:	4605                	li	a2,1
 216:	faf40593          	addi	a1,s0,-81
 21a:	4501                	li	a0,0
 21c:	00000097          	auipc	ra,0x0
 220:	19c080e7          	jalr	412(ra) # 3b8 <read>
    if (cc < 1)
 224:	00a05e63          	blez	a0,240 <gets+0x56>
    buf[i++] = c;
 228:	faf44783          	lbu	a5,-81(s0)
 22c:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 230:	01578763          	beq	a5,s5,23e <gets+0x54>
 234:	0905                	addi	s2,s2,1
 236:	fd679be3          	bne	a5,s6,20c <gets+0x22>
  for (i = 0; i + 1 < max;)
 23a:	89a6                	mv	s3,s1
 23c:	a011                	j	240 <gets+0x56>
 23e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 240:	99de                	add	s3,s3,s7
 242:	00098023          	sb	zero,0(s3)
  return buf;
}
 246:	855e                	mv	a0,s7
 248:	60e6                	ld	ra,88(sp)
 24a:	6446                	ld	s0,80(sp)
 24c:	64a6                	ld	s1,72(sp)
 24e:	6906                	ld	s2,64(sp)
 250:	79e2                	ld	s3,56(sp)
 252:	7a42                	ld	s4,48(sp)
 254:	7aa2                	ld	s5,40(sp)
 256:	7b02                	ld	s6,32(sp)
 258:	6be2                	ld	s7,24(sp)
 25a:	6125                	addi	sp,sp,96
 25c:	8082                	ret

000000000000025e <stat>:

int stat(const char *n, struct stat *st)
{
 25e:	1101                	addi	sp,sp,-32
 260:	ec06                	sd	ra,24(sp)
 262:	e822                	sd	s0,16(sp)
 264:	e426                	sd	s1,8(sp)
 266:	e04a                	sd	s2,0(sp)
 268:	1000                	addi	s0,sp,32
 26a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 26c:	4581                	li	a1,0
 26e:	00000097          	auipc	ra,0x0
 272:	172080e7          	jalr	370(ra) # 3e0 <open>
  if (fd < 0)
 276:	02054563          	bltz	a0,2a0 <stat+0x42>
 27a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 27c:	85ca                	mv	a1,s2
 27e:	00000097          	auipc	ra,0x0
 282:	17a080e7          	jalr	378(ra) # 3f8 <fstat>
 286:	892a                	mv	s2,a0
  close(fd);
 288:	8526                	mv	a0,s1
 28a:	00000097          	auipc	ra,0x0
 28e:	13e080e7          	jalr	318(ra) # 3c8 <close>
  return r;
}
 292:	854a                	mv	a0,s2
 294:	60e2                	ld	ra,24(sp)
 296:	6442                	ld	s0,16(sp)
 298:	64a2                	ld	s1,8(sp)
 29a:	6902                	ld	s2,0(sp)
 29c:	6105                	addi	sp,sp,32
 29e:	8082                	ret
    return -1;
 2a0:	597d                	li	s2,-1
 2a2:	bfc5                	j	292 <stat+0x34>

00000000000002a4 <atoi>:

int atoi(const char *s)
{
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e422                	sd	s0,8(sp)
 2a8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 2aa:	00054603          	lbu	a2,0(a0)
 2ae:	fd06079b          	addiw	a5,a2,-48
 2b2:	0ff7f793          	andi	a5,a5,255
 2b6:	4725                	li	a4,9
 2b8:	02f76963          	bltu	a4,a5,2ea <atoi+0x46>
 2bc:	86aa                	mv	a3,a0
  n = 0;
 2be:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9')
 2c0:	45a5                	li	a1,9
    n = n * 10 + *s++ - '0';
 2c2:	0685                	addi	a3,a3,1
 2c4:	0025179b          	slliw	a5,a0,0x2
 2c8:	9fa9                	addw	a5,a5,a0
 2ca:	0017979b          	slliw	a5,a5,0x1
 2ce:	9fb1                	addw	a5,a5,a2
 2d0:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 2d4:	0006c603          	lbu	a2,0(a3)
 2d8:	fd06071b          	addiw	a4,a2,-48
 2dc:	0ff77713          	andi	a4,a4,255
 2e0:	fee5f1e3          	bgeu	a1,a4,2c2 <atoi+0x1e>
  return n;
}
 2e4:	6422                	ld	s0,8(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret
  n = 0;
 2ea:	4501                	li	a0,0
 2ec:	bfe5                	j	2e4 <atoi+0x40>

00000000000002ee <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2ee:	1141                	addi	sp,sp,-16
 2f0:	e422                	sd	s0,8(sp)
 2f2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst)
 2f4:	02b57463          	bgeu	a0,a1,31c <memmove+0x2e>
  {
    while (n-- > 0)
 2f8:	00c05f63          	blez	a2,316 <memmove+0x28>
 2fc:	1602                	slli	a2,a2,0x20
 2fe:	9201                	srli	a2,a2,0x20
 300:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 304:	872a                	mv	a4,a0
      *dst++ = *src++;
 306:	0585                	addi	a1,a1,1
 308:	0705                	addi	a4,a4,1
 30a:	fff5c683          	lbu	a3,-1(a1)
 30e:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 312:	fee79ae3          	bne	a5,a4,306 <memmove+0x18>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 316:	6422                	ld	s0,8(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret
    dst += n;
 31c:	00c50733          	add	a4,a0,a2
    src += n;
 320:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 322:	fec05ae3          	blez	a2,316 <memmove+0x28>
 326:	fff6079b          	addiw	a5,a2,-1
 32a:	1782                	slli	a5,a5,0x20
 32c:	9381                	srli	a5,a5,0x20
 32e:	fff7c793          	not	a5,a5
 332:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 334:	15fd                	addi	a1,a1,-1
 336:	177d                	addi	a4,a4,-1
 338:	0005c683          	lbu	a3,0(a1)
 33c:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 340:	fee79ae3          	bne	a5,a4,334 <memmove+0x46>
 344:	bfc9                	j	316 <memmove+0x28>

0000000000000346 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 346:	1141                	addi	sp,sp,-16
 348:	e422                	sd	s0,8(sp)
 34a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0)
 34c:	ca05                	beqz	a2,37c <memcmp+0x36>
 34e:	fff6069b          	addiw	a3,a2,-1
 352:	1682                	slli	a3,a3,0x20
 354:	9281                	srli	a3,a3,0x20
 356:	0685                	addi	a3,a3,1
 358:	96aa                	add	a3,a3,a0
  {
    if (*p1 != *p2)
 35a:	00054783          	lbu	a5,0(a0)
 35e:	0005c703          	lbu	a4,0(a1)
 362:	00e79863          	bne	a5,a4,372 <memcmp+0x2c>
    {
      return *p1 - *p2;
    }
    p1++;
 366:	0505                	addi	a0,a0,1
    p2++;
 368:	0585                	addi	a1,a1,1
  while (n-- > 0)
 36a:	fed518e3          	bne	a0,a3,35a <memcmp+0x14>
  }
  return 0;
 36e:	4501                	li	a0,0
 370:	a019                	j	376 <memcmp+0x30>
      return *p1 - *p2;
 372:	40e7853b          	subw	a0,a5,a4
}
 376:	6422                	ld	s0,8(sp)
 378:	0141                	addi	sp,sp,16
 37a:	8082                	ret
  return 0;
 37c:	4501                	li	a0,0
 37e:	bfe5                	j	376 <memcmp+0x30>

0000000000000380 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 380:	1141                	addi	sp,sp,-16
 382:	e406                	sd	ra,8(sp)
 384:	e022                	sd	s0,0(sp)
 386:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 388:	00000097          	auipc	ra,0x0
 38c:	f66080e7          	jalr	-154(ra) # 2ee <memmove>
}
 390:	60a2                	ld	ra,8(sp)
 392:	6402                	ld	s0,0(sp)
 394:	0141                	addi	sp,sp,16
 396:	8082                	ret

0000000000000398 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 398:	4885                	li	a7,1
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3a0:	4889                	li	a7,2
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3a8:	488d                	li	a7,3
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3b0:	4891                	li	a7,4
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <read>:
.global read
read:
 li a7, SYS_read
 3b8:	4895                	li	a7,5
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <write>:
.global write
write:
 li a7, SYS_write
 3c0:	48c1                	li	a7,16
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <close>:
.global close
close:
 li a7, SYS_close
 3c8:	48d5                	li	a7,21
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3d0:	4899                	li	a7,6
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3d8:	489d                	li	a7,7
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <open>:
.global open
open:
 li a7, SYS_open
 3e0:	48bd                	li	a7,15
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3e8:	48c5                	li	a7,17
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3f0:	48c9                	li	a7,18
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3f8:	48a1                	li	a7,8
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <link>:
.global link
link:
 li a7, SYS_link
 400:	48cd                	li	a7,19
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 408:	48d1                	li	a7,20
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 410:	48a5                	li	a7,9
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <dup>:
.global dup
dup:
 li a7, SYS_dup
 418:	48a9                	li	a7,10
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 420:	48ad                	li	a7,11
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 428:	48b1                	li	a7,12
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 430:	48b5                	li	a7,13
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 438:	48b9                	li	a7,14
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <trace>:
.global trace
trace:
 li a7, SYS_trace
 440:	48d9                	li	a7,22
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 448:	48e5                	li	a7,25
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 450:	48e1                	li	a7,24
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 458:	48e9                	li	a7,26
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 460:	48ed                	li	a7,27
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 468:	48dd                	li	a7,23
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 470:	1101                	addi	sp,sp,-32
 472:	ec06                	sd	ra,24(sp)
 474:	e822                	sd	s0,16(sp)
 476:	1000                	addi	s0,sp,32
 478:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 47c:	4605                	li	a2,1
 47e:	fef40593          	addi	a1,s0,-17
 482:	00000097          	auipc	ra,0x0
 486:	f3e080e7          	jalr	-194(ra) # 3c0 <write>
}
 48a:	60e2                	ld	ra,24(sp)
 48c:	6442                	ld	s0,16(sp)
 48e:	6105                	addi	sp,sp,32
 490:	8082                	ret

0000000000000492 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 492:	7139                	addi	sp,sp,-64
 494:	fc06                	sd	ra,56(sp)
 496:	f822                	sd	s0,48(sp)
 498:	f426                	sd	s1,40(sp)
 49a:	f04a                	sd	s2,32(sp)
 49c:	ec4e                	sd	s3,24(sp)
 49e:	0080                	addi	s0,sp,64
 4a0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0)
 4a2:	c299                	beqz	a3,4a8 <printint+0x16>
 4a4:	0805c863          	bltz	a1,534 <printint+0xa2>
    neg = 1;
    x = -xx;
  }
  else
  {
    x = xx;
 4a8:	2581                	sext.w	a1,a1
  neg = 0;
 4aa:	4881                	li	a7,0
 4ac:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4b0:	4701                	li	a4,0
  do
  {
    buf[i++] = digits[x % base];
 4b2:	2601                	sext.w	a2,a2
 4b4:	00000517          	auipc	a0,0x0
 4b8:	51450513          	addi	a0,a0,1300 # 9c8 <digits>
 4bc:	883a                	mv	a6,a4
 4be:	2705                	addiw	a4,a4,1
 4c0:	02c5f7bb          	remuw	a5,a1,a2
 4c4:	1782                	slli	a5,a5,0x20
 4c6:	9381                	srli	a5,a5,0x20
 4c8:	97aa                	add	a5,a5,a0
 4ca:	0007c783          	lbu	a5,0(a5)
 4ce:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 4d2:	0005879b          	sext.w	a5,a1
 4d6:	02c5d5bb          	divuw	a1,a1,a2
 4da:	0685                	addi	a3,a3,1
 4dc:	fec7f0e3          	bgeu	a5,a2,4bc <printint+0x2a>
  if (neg)
 4e0:	00088b63          	beqz	a7,4f6 <printint+0x64>
    buf[i++] = '-';
 4e4:	fd040793          	addi	a5,s0,-48
 4e8:	973e                	add	a4,a4,a5
 4ea:	02d00793          	li	a5,45
 4ee:	fef70823          	sb	a5,-16(a4)
 4f2:	0028071b          	addiw	a4,a6,2

  while (--i >= 0)
 4f6:	02e05863          	blez	a4,526 <printint+0x94>
 4fa:	fc040793          	addi	a5,s0,-64
 4fe:	00e78933          	add	s2,a5,a4
 502:	fff78993          	addi	s3,a5,-1
 506:	99ba                	add	s3,s3,a4
 508:	377d                	addiw	a4,a4,-1
 50a:	1702                	slli	a4,a4,0x20
 50c:	9301                	srli	a4,a4,0x20
 50e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 512:	fff94583          	lbu	a1,-1(s2)
 516:	8526                	mv	a0,s1
 518:	00000097          	auipc	ra,0x0
 51c:	f58080e7          	jalr	-168(ra) # 470 <putc>
  while (--i >= 0)
 520:	197d                	addi	s2,s2,-1
 522:	ff3918e3          	bne	s2,s3,512 <printint+0x80>
}
 526:	70e2                	ld	ra,56(sp)
 528:	7442                	ld	s0,48(sp)
 52a:	74a2                	ld	s1,40(sp)
 52c:	7902                	ld	s2,32(sp)
 52e:	69e2                	ld	s3,24(sp)
 530:	6121                	addi	sp,sp,64
 532:	8082                	ret
    x = -xx;
 534:	40b005bb          	negw	a1,a1
    neg = 1;
 538:	4885                	li	a7,1
    x = -xx;
 53a:	bf8d                	j	4ac <printint+0x1a>

000000000000053c <vprintf>:
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap)
{
 53c:	7119                	addi	sp,sp,-128
 53e:	fc86                	sd	ra,120(sp)
 540:	f8a2                	sd	s0,112(sp)
 542:	f4a6                	sd	s1,104(sp)
 544:	f0ca                	sd	s2,96(sp)
 546:	ecce                	sd	s3,88(sp)
 548:	e8d2                	sd	s4,80(sp)
 54a:	e4d6                	sd	s5,72(sp)
 54c:	e0da                	sd	s6,64(sp)
 54e:	fc5e                	sd	s7,56(sp)
 550:	f862                	sd	s8,48(sp)
 552:	f466                	sd	s9,40(sp)
 554:	f06a                	sd	s10,32(sp)
 556:	ec6e                	sd	s11,24(sp)
 558:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++)
 55a:	0005c903          	lbu	s2,0(a1)
 55e:	18090f63          	beqz	s2,6fc <vprintf+0x1c0>
 562:	8aaa                	mv	s5,a0
 564:	8b32                	mv	s6,a2
 566:	00158493          	addi	s1,a1,1
  state = 0;
 56a:	4981                	li	s3,0
      else
      {
        putc(fd, c);
      }
    }
    else if (state == '%')
 56c:	02500a13          	li	s4,37
    {
      if (c == 'd')
 570:	06400c13          	li	s8,100
      {
        printint(fd, va_arg(ap, int), 10, 1);
      }
      else if (c == 'l')
 574:	06c00c93          	li	s9,108
      {
        printint(fd, va_arg(ap, uint64), 10, 0);
      }
      else if (c == 'x')
 578:	07800d13          	li	s10,120
      {
        printint(fd, va_arg(ap, int), 16, 0);
      }
      else if (c == 'p')
 57c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 580:	00000b97          	auipc	s7,0x0
 584:	448b8b93          	addi	s7,s7,1096 # 9c8 <digits>
 588:	a839                	j	5a6 <vprintf+0x6a>
        putc(fd, c);
 58a:	85ca                	mv	a1,s2
 58c:	8556                	mv	a0,s5
 58e:	00000097          	auipc	ra,0x0
 592:	ee2080e7          	jalr	-286(ra) # 470 <putc>
 596:	a019                	j	59c <vprintf+0x60>
    else if (state == '%')
 598:	01498f63          	beq	s3,s4,5b6 <vprintf+0x7a>
  for (i = 0; fmt[i]; i++)
 59c:	0485                	addi	s1,s1,1
 59e:	fff4c903          	lbu	s2,-1(s1)
 5a2:	14090d63          	beqz	s2,6fc <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5a6:	0009079b          	sext.w	a5,s2
    if (state == 0)
 5aa:	fe0997e3          	bnez	s3,598 <vprintf+0x5c>
      if (c == '%')
 5ae:	fd479ee3          	bne	a5,s4,58a <vprintf+0x4e>
        state = '%';
 5b2:	89be                	mv	s3,a5
 5b4:	b7e5                	j	59c <vprintf+0x60>
      if (c == 'd')
 5b6:	05878063          	beq	a5,s8,5f6 <vprintf+0xba>
      else if (c == 'l')
 5ba:	05978c63          	beq	a5,s9,612 <vprintf+0xd6>
      else if (c == 'x')
 5be:	07a78863          	beq	a5,s10,62e <vprintf+0xf2>
      else if (c == 'p')
 5c2:	09b78463          	beq	a5,s11,64a <vprintf+0x10e>
      {
        printptr(fd, va_arg(ap, uint64));
      }
      else if (c == 's')
 5c6:	07300713          	li	a4,115
 5ca:	0ce78663          	beq	a5,a4,696 <vprintf+0x15a>
        {
          putc(fd, *s);
          s++;
        }
      }
      else if (c == 'c')
 5ce:	06300713          	li	a4,99
 5d2:	0ee78e63          	beq	a5,a4,6ce <vprintf+0x192>
      {
        putc(fd, va_arg(ap, uint));
      }
      else if (c == '%')
 5d6:	11478863          	beq	a5,s4,6e6 <vprintf+0x1aa>
        putc(fd, c);
      }
      else
      {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5da:	85d2                	mv	a1,s4
 5dc:	8556                	mv	a0,s5
 5de:	00000097          	auipc	ra,0x0
 5e2:	e92080e7          	jalr	-366(ra) # 470 <putc>
        putc(fd, c);
 5e6:	85ca                	mv	a1,s2
 5e8:	8556                	mv	a0,s5
 5ea:	00000097          	auipc	ra,0x0
 5ee:	e86080e7          	jalr	-378(ra) # 470 <putc>
      }
      state = 0;
 5f2:	4981                	li	s3,0
 5f4:	b765                	j	59c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5f6:	008b0913          	addi	s2,s6,8
 5fa:	4685                	li	a3,1
 5fc:	4629                	li	a2,10
 5fe:	000b2583          	lw	a1,0(s6)
 602:	8556                	mv	a0,s5
 604:	00000097          	auipc	ra,0x0
 608:	e8e080e7          	jalr	-370(ra) # 492 <printint>
 60c:	8b4a                	mv	s6,s2
      state = 0;
 60e:	4981                	li	s3,0
 610:	b771                	j	59c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 612:	008b0913          	addi	s2,s6,8
 616:	4681                	li	a3,0
 618:	4629                	li	a2,10
 61a:	000b2583          	lw	a1,0(s6)
 61e:	8556                	mv	a0,s5
 620:	00000097          	auipc	ra,0x0
 624:	e72080e7          	jalr	-398(ra) # 492 <printint>
 628:	8b4a                	mv	s6,s2
      state = 0;
 62a:	4981                	li	s3,0
 62c:	bf85                	j	59c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 62e:	008b0913          	addi	s2,s6,8
 632:	4681                	li	a3,0
 634:	4641                	li	a2,16
 636:	000b2583          	lw	a1,0(s6)
 63a:	8556                	mv	a0,s5
 63c:	00000097          	auipc	ra,0x0
 640:	e56080e7          	jalr	-426(ra) # 492 <printint>
 644:	8b4a                	mv	s6,s2
      state = 0;
 646:	4981                	li	s3,0
 648:	bf91                	j	59c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 64a:	008b0793          	addi	a5,s6,8
 64e:	f8f43423          	sd	a5,-120(s0)
 652:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 656:	03000593          	li	a1,48
 65a:	8556                	mv	a0,s5
 65c:	00000097          	auipc	ra,0x0
 660:	e14080e7          	jalr	-492(ra) # 470 <putc>
  putc(fd, 'x');
 664:	85ea                	mv	a1,s10
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	e08080e7          	jalr	-504(ra) # 470 <putc>
 670:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 672:	03c9d793          	srli	a5,s3,0x3c
 676:	97de                	add	a5,a5,s7
 678:	0007c583          	lbu	a1,0(a5)
 67c:	8556                	mv	a0,s5
 67e:	00000097          	auipc	ra,0x0
 682:	df2080e7          	jalr	-526(ra) # 470 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 686:	0992                	slli	s3,s3,0x4
 688:	397d                	addiw	s2,s2,-1
 68a:	fe0914e3          	bnez	s2,672 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 68e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 692:	4981                	li	s3,0
 694:	b721                	j	59c <vprintf+0x60>
        s = va_arg(ap, char *);
 696:	008b0993          	addi	s3,s6,8
 69a:	000b3903          	ld	s2,0(s6)
        if (s == 0)
 69e:	02090163          	beqz	s2,6c0 <vprintf+0x184>
        while (*s != 0)
 6a2:	00094583          	lbu	a1,0(s2)
 6a6:	c9a1                	beqz	a1,6f6 <vprintf+0x1ba>
          putc(fd, *s);
 6a8:	8556                	mv	a0,s5
 6aa:	00000097          	auipc	ra,0x0
 6ae:	dc6080e7          	jalr	-570(ra) # 470 <putc>
          s++;
 6b2:	0905                	addi	s2,s2,1
        while (*s != 0)
 6b4:	00094583          	lbu	a1,0(s2)
 6b8:	f9e5                	bnez	a1,6a8 <vprintf+0x16c>
        s = va_arg(ap, char *);
 6ba:	8b4e                	mv	s6,s3
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	bdf9                	j	59c <vprintf+0x60>
          s = "(null)";
 6c0:	00000917          	auipc	s2,0x0
 6c4:	30090913          	addi	s2,s2,768 # 9c0 <malloc+0x1ba>
        while (*s != 0)
 6c8:	02800593          	li	a1,40
 6cc:	bff1                	j	6a8 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6ce:	008b0913          	addi	s2,s6,8
 6d2:	000b4583          	lbu	a1,0(s6)
 6d6:	8556                	mv	a0,s5
 6d8:	00000097          	auipc	ra,0x0
 6dc:	d98080e7          	jalr	-616(ra) # 470 <putc>
 6e0:	8b4a                	mv	s6,s2
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	bd65                	j	59c <vprintf+0x60>
        putc(fd, c);
 6e6:	85d2                	mv	a1,s4
 6e8:	8556                	mv	a0,s5
 6ea:	00000097          	auipc	ra,0x0
 6ee:	d86080e7          	jalr	-634(ra) # 470 <putc>
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	b565                	j	59c <vprintf+0x60>
        s = va_arg(ap, char *);
 6f6:	8b4e                	mv	s6,s3
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	b54d                	j	59c <vprintf+0x60>
    }
  }
}
 6fc:	70e6                	ld	ra,120(sp)
 6fe:	7446                	ld	s0,112(sp)
 700:	74a6                	ld	s1,104(sp)
 702:	7906                	ld	s2,96(sp)
 704:	69e6                	ld	s3,88(sp)
 706:	6a46                	ld	s4,80(sp)
 708:	6aa6                	ld	s5,72(sp)
 70a:	6b06                	ld	s6,64(sp)
 70c:	7be2                	ld	s7,56(sp)
 70e:	7c42                	ld	s8,48(sp)
 710:	7ca2                	ld	s9,40(sp)
 712:	7d02                	ld	s10,32(sp)
 714:	6de2                	ld	s11,24(sp)
 716:	6109                	addi	sp,sp,128
 718:	8082                	ret

000000000000071a <fprintf>:

void fprintf(int fd, const char *fmt, ...)
{
 71a:	715d                	addi	sp,sp,-80
 71c:	ec06                	sd	ra,24(sp)
 71e:	e822                	sd	s0,16(sp)
 720:	1000                	addi	s0,sp,32
 722:	e010                	sd	a2,0(s0)
 724:	e414                	sd	a3,8(s0)
 726:	e818                	sd	a4,16(s0)
 728:	ec1c                	sd	a5,24(s0)
 72a:	03043023          	sd	a6,32(s0)
 72e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 732:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 736:	8622                	mv	a2,s0
 738:	00000097          	auipc	ra,0x0
 73c:	e04080e7          	jalr	-508(ra) # 53c <vprintf>
}
 740:	60e2                	ld	ra,24(sp)
 742:	6442                	ld	s0,16(sp)
 744:	6161                	addi	sp,sp,80
 746:	8082                	ret

0000000000000748 <printf>:

void printf(const char *fmt, ...)
{
 748:	711d                	addi	sp,sp,-96
 74a:	ec06                	sd	ra,24(sp)
 74c:	e822                	sd	s0,16(sp)
 74e:	1000                	addi	s0,sp,32
 750:	e40c                	sd	a1,8(s0)
 752:	e810                	sd	a2,16(s0)
 754:	ec14                	sd	a3,24(s0)
 756:	f018                	sd	a4,32(s0)
 758:	f41c                	sd	a5,40(s0)
 75a:	03043823          	sd	a6,48(s0)
 75e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 762:	00840613          	addi	a2,s0,8
 766:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 76a:	85aa                	mv	a1,a0
 76c:	4505                	li	a0,1
 76e:	00000097          	auipc	ra,0x0
 772:	dce080e7          	jalr	-562(ra) # 53c <vprintf>
}
 776:	60e2                	ld	ra,24(sp)
 778:	6442                	ld	s0,16(sp)
 77a:	6125                	addi	sp,sp,96
 77c:	8082                	ret

000000000000077e <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 77e:	1141                	addi	sp,sp,-16
 780:	e422                	sd	s0,8(sp)
 782:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 784:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 788:	00001797          	auipc	a5,0x1
 78c:	8787b783          	ld	a5,-1928(a5) # 1000 <freep>
 790:	a805                	j	7c0 <free+0x42>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr)
  {
    bp->s.size += p->s.ptr->s.size;
 792:	4618                	lw	a4,8(a2)
 794:	9db9                	addw	a1,a1,a4
 796:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 79a:	6398                	ld	a4,0(a5)
 79c:	6318                	ld	a4,0(a4)
 79e:	fee53823          	sd	a4,-16(a0)
 7a2:	a091                	j	7e6 <free+0x68>
  }
  else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp)
  {
    p->s.size += bp->s.size;
 7a4:	ff852703          	lw	a4,-8(a0)
 7a8:	9e39                	addw	a2,a2,a4
 7aa:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7ac:	ff053703          	ld	a4,-16(a0)
 7b0:	e398                	sd	a4,0(a5)
 7b2:	a099                	j	7f8 <free+0x7a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b4:	6398                	ld	a4,0(a5)
 7b6:	00e7e463          	bltu	a5,a4,7be <free+0x40>
 7ba:	00e6ea63          	bltu	a3,a4,7ce <free+0x50>
{
 7be:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c0:	fed7fae3          	bgeu	a5,a3,7b4 <free+0x36>
 7c4:	6398                	ld	a4,0(a5)
 7c6:	00e6e463          	bltu	a3,a4,7ce <free+0x50>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ca:	fee7eae3          	bltu	a5,a4,7be <free+0x40>
  if (bp + bp->s.size == p->s.ptr)
 7ce:	ff852583          	lw	a1,-8(a0)
 7d2:	6390                	ld	a2,0(a5)
 7d4:	02059713          	slli	a4,a1,0x20
 7d8:	9301                	srli	a4,a4,0x20
 7da:	0712                	slli	a4,a4,0x4
 7dc:	9736                	add	a4,a4,a3
 7de:	fae60ae3          	beq	a2,a4,792 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7e2:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp)
 7e6:	4790                	lw	a2,8(a5)
 7e8:	02061713          	slli	a4,a2,0x20
 7ec:	9301                	srli	a4,a4,0x20
 7ee:	0712                	slli	a4,a4,0x4
 7f0:	973e                	add	a4,a4,a5
 7f2:	fae689e3          	beq	a3,a4,7a4 <free+0x26>
  }
  else
    p->s.ptr = bp;
 7f6:	e394                	sd	a3,0(a5)
  freep = p;
 7f8:	00001717          	auipc	a4,0x1
 7fc:	80f73423          	sd	a5,-2040(a4) # 1000 <freep>
}
 800:	6422                	ld	s0,8(sp)
 802:	0141                	addi	sp,sp,16
 804:	8082                	ret

0000000000000806 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 806:	7139                	addi	sp,sp,-64
 808:	fc06                	sd	ra,56(sp)
 80a:	f822                	sd	s0,48(sp)
 80c:	f426                	sd	s1,40(sp)
 80e:	f04a                	sd	s2,32(sp)
 810:	ec4e                	sd	s3,24(sp)
 812:	e852                	sd	s4,16(sp)
 814:	e456                	sd	s5,8(sp)
 816:	e05a                	sd	s6,0(sp)
 818:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 81a:	02051493          	slli	s1,a0,0x20
 81e:	9081                	srli	s1,s1,0x20
 820:	04bd                	addi	s1,s1,15
 822:	8091                	srli	s1,s1,0x4
 824:	0014899b          	addiw	s3,s1,1
 828:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0)
 82a:	00000517          	auipc	a0,0x0
 82e:	7d653503          	ld	a0,2006(a0) # 1000 <freep>
 832:	c515                	beqz	a0,85e <malloc+0x58>
  {
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 834:	611c                	ld	a5,0(a0)
  {
    if (p->s.size >= nunits)
 836:	4798                	lw	a4,8(a5)
 838:	02977f63          	bgeu	a4,s1,876 <malloc+0x70>
 83c:	8a4e                	mv	s4,s3
 83e:	0009871b          	sext.w	a4,s3
 842:	6685                	lui	a3,0x1
 844:	00d77363          	bgeu	a4,a3,84a <malloc+0x44>
 848:	6a05                	lui	s4,0x1
 84a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 84e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 852:	00000917          	auipc	s2,0x0
 856:	7ae90913          	addi	s2,s2,1966 # 1000 <freep>
  if (p == (char *)-1)
 85a:	5afd                	li	s5,-1
 85c:	a88d                	j	8ce <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 85e:	00000797          	auipc	a5,0x0
 862:	7b278793          	addi	a5,a5,1970 # 1010 <base>
 866:	00000717          	auipc	a4,0x0
 86a:	78f73d23          	sd	a5,1946(a4) # 1000 <freep>
 86e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 870:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits)
 874:	b7e1                	j	83c <malloc+0x36>
      if (p->s.size == nunits)
 876:	02e48b63          	beq	s1,a4,8ac <malloc+0xa6>
        p->s.size -= nunits;
 87a:	4137073b          	subw	a4,a4,s3
 87e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 880:	1702                	slli	a4,a4,0x20
 882:	9301                	srli	a4,a4,0x20
 884:	0712                	slli	a4,a4,0x4
 886:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 888:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 88c:	00000717          	auipc	a4,0x0
 890:	76a73a23          	sd	a0,1908(a4) # 1000 <freep>
      return (void *)(p + 1);
 894:	01078513          	addi	a0,a5,16
      if ((p = morecore(nunits)) == 0)
        return 0;
  }
}
 898:	70e2                	ld	ra,56(sp)
 89a:	7442                	ld	s0,48(sp)
 89c:	74a2                	ld	s1,40(sp)
 89e:	7902                	ld	s2,32(sp)
 8a0:	69e2                	ld	s3,24(sp)
 8a2:	6a42                	ld	s4,16(sp)
 8a4:	6aa2                	ld	s5,8(sp)
 8a6:	6b02                	ld	s6,0(sp)
 8a8:	6121                	addi	sp,sp,64
 8aa:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8ac:	6398                	ld	a4,0(a5)
 8ae:	e118                	sd	a4,0(a0)
 8b0:	bff1                	j	88c <malloc+0x86>
  hp->s.size = nu;
 8b2:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8b6:	0541                	addi	a0,a0,16
 8b8:	00000097          	auipc	ra,0x0
 8bc:	ec6080e7          	jalr	-314(ra) # 77e <free>
  return freep;
 8c0:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 8c4:	d971                	beqz	a0,898 <malloc+0x92>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 8c6:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits)
 8c8:	4798                	lw	a4,8(a5)
 8ca:	fa9776e3          	bgeu	a4,s1,876 <malloc+0x70>
    if (p == freep)
 8ce:	00093703          	ld	a4,0(s2)
 8d2:	853e                	mv	a0,a5
 8d4:	fef719e3          	bne	a4,a5,8c6 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 8d8:	8552                	mv	a0,s4
 8da:	00000097          	auipc	ra,0x0
 8de:	b4e080e7          	jalr	-1202(ra) # 428 <sbrk>
  if (p == (char *)-1)
 8e2:	fd5518e3          	bne	a0,s5,8b2 <malloc+0xac>
        return 0;
 8e6:	4501                	li	a0,0
 8e8:	bf45                	j	898 <malloc+0x92>
