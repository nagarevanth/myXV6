
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
  }
}

// what if you pass ridiculous string pointers to system calls?
void copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16

  for (int ai = 0; ai < 2; ai++)
  {
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE | O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	b9a080e7          	jalr	-1126(ra) # 5baa <open>
    if (fd >= 0)
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE | O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	b88080e7          	jalr	-1144(ra) # 5baa <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if (fd >= 0)
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
    {
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	0a250513          	addi	a0,a0,162 # 60e0 <malloc+0x110>
      46:	00006097          	auipc	ra,0x6
      4a:	ecc080e7          	jalr	-308(ra) # 5f12 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	b1a080e7          	jalr	-1254(ra) # 5b6a <exit>

0000000000000058 <bsstest>:
char uninit[10000];
void bsstest(char *s)
{
  int i;

  for (i = 0; i < sizeof(uninit); i++)
      58:	0000a797          	auipc	a5,0xa
      5c:	51078793          	addi	a5,a5,1296 # a568 <uninit>
      60:	0000d697          	auipc	a3,0xd
      64:	c1868693          	addi	a3,a3,-1000 # cc78 <buf>
  {
    if (uninit[i] != '\0')
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for (i = 0; i < sizeof(uninit); i++)
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
    {
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	08050513          	addi	a0,a0,128 # 6100 <malloc+0x130>
      88:	00006097          	auipc	ra,0x6
      8c:	e8a080e7          	jalr	-374(ra) # 5f12 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	ad8080e7          	jalr	-1320(ra) # 5b6a <exit>

000000000000009a <textwrite>:
    exit(xstatus);
}

// check that writes to text segment fault
void textwrite(char *s)
{
      9a:	1141                	addi	sp,sp,-16
      9c:	e406                	sd	ra,8(sp)
      9e:	e022                	sd	s0,0(sp)
      a0:	0800                	addi	s0,sp,16
  exit(0);
      a2:	4501                	li	a0,0
      a4:	00006097          	auipc	ra,0x6
      a8:	ac6080e7          	jalr	-1338(ra) # 5b6a <exit>

00000000000000ac <opentest>:
{
      ac:	1101                	addi	sp,sp,-32
      ae:	ec06                	sd	ra,24(sp)
      b0:	e822                	sd	s0,16(sp)
      b2:	e426                	sd	s1,8(sp)
      b4:	1000                	addi	s0,sp,32
      b6:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      b8:	4581                	li	a1,0
      ba:	00006517          	auipc	a0,0x6
      be:	05e50513          	addi	a0,a0,94 # 6118 <malloc+0x148>
      c2:	00006097          	auipc	ra,0x6
      c6:	ae8080e7          	jalr	-1304(ra) # 5baa <open>
  if (fd < 0)
      ca:	02054663          	bltz	a0,f6 <opentest+0x4a>
  close(fd);
      ce:	00006097          	auipc	ra,0x6
      d2:	ac4080e7          	jalr	-1340(ra) # 5b92 <close>
  fd = open("doesnotexist", 0);
      d6:	4581                	li	a1,0
      d8:	00006517          	auipc	a0,0x6
      dc:	06050513          	addi	a0,a0,96 # 6138 <malloc+0x168>
      e0:	00006097          	auipc	ra,0x6
      e4:	aca080e7          	jalr	-1334(ra) # 5baa <open>
  if (fd >= 0)
      e8:	02055563          	bgez	a0,112 <opentest+0x66>
}
      ec:	60e2                	ld	ra,24(sp)
      ee:	6442                	ld	s0,16(sp)
      f0:	64a2                	ld	s1,8(sp)
      f2:	6105                	addi	sp,sp,32
      f4:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f6:	85a6                	mv	a1,s1
      f8:	00006517          	auipc	a0,0x6
      fc:	02850513          	addi	a0,a0,40 # 6120 <malloc+0x150>
     100:	00006097          	auipc	ra,0x6
     104:	e12080e7          	jalr	-494(ra) # 5f12 <printf>
    exit(1);
     108:	4505                	li	a0,1
     10a:	00006097          	auipc	ra,0x6
     10e:	a60080e7          	jalr	-1440(ra) # 5b6a <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     112:	85a6                	mv	a1,s1
     114:	00006517          	auipc	a0,0x6
     118:	03450513          	addi	a0,a0,52 # 6148 <malloc+0x178>
     11c:	00006097          	auipc	ra,0x6
     120:	df6080e7          	jalr	-522(ra) # 5f12 <printf>
    exit(1);
     124:	4505                	li	a0,1
     126:	00006097          	auipc	ra,0x6
     12a:	a44080e7          	jalr	-1468(ra) # 5b6a <exit>

000000000000012e <truncate2>:
{
     12e:	7179                	addi	sp,sp,-48
     130:	f406                	sd	ra,40(sp)
     132:	f022                	sd	s0,32(sp)
     134:	ec26                	sd	s1,24(sp)
     136:	e84a                	sd	s2,16(sp)
     138:	e44e                	sd	s3,8(sp)
     13a:	1800                	addi	s0,sp,48
     13c:	89aa                	mv	s3,a0
  unlink("truncfile");
     13e:	00006517          	auipc	a0,0x6
     142:	03250513          	addi	a0,a0,50 # 6170 <malloc+0x1a0>
     146:	00006097          	auipc	ra,0x6
     14a:	a74080e7          	jalr	-1420(ra) # 5bba <unlink>
  int fd1 = open("truncfile", O_CREATE | O_TRUNC | O_WRONLY);
     14e:	60100593          	li	a1,1537
     152:	00006517          	auipc	a0,0x6
     156:	01e50513          	addi	a0,a0,30 # 6170 <malloc+0x1a0>
     15a:	00006097          	auipc	ra,0x6
     15e:	a50080e7          	jalr	-1456(ra) # 5baa <open>
     162:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     164:	4611                	li	a2,4
     166:	00006597          	auipc	a1,0x6
     16a:	01a58593          	addi	a1,a1,26 # 6180 <malloc+0x1b0>
     16e:	00006097          	auipc	ra,0x6
     172:	a1c080e7          	jalr	-1508(ra) # 5b8a <write>
  int fd2 = open("truncfile", O_TRUNC | O_WRONLY);
     176:	40100593          	li	a1,1025
     17a:	00006517          	auipc	a0,0x6
     17e:	ff650513          	addi	a0,a0,-10 # 6170 <malloc+0x1a0>
     182:	00006097          	auipc	ra,0x6
     186:	a28080e7          	jalr	-1496(ra) # 5baa <open>
     18a:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     18c:	4605                	li	a2,1
     18e:	00006597          	auipc	a1,0x6
     192:	ffa58593          	addi	a1,a1,-6 # 6188 <malloc+0x1b8>
     196:	8526                	mv	a0,s1
     198:	00006097          	auipc	ra,0x6
     19c:	9f2080e7          	jalr	-1550(ra) # 5b8a <write>
  if (n != -1)
     1a0:	57fd                	li	a5,-1
     1a2:	02f51b63          	bne	a0,a5,1d8 <truncate2+0xaa>
  unlink("truncfile");
     1a6:	00006517          	auipc	a0,0x6
     1aa:	fca50513          	addi	a0,a0,-54 # 6170 <malloc+0x1a0>
     1ae:	00006097          	auipc	ra,0x6
     1b2:	a0c080e7          	jalr	-1524(ra) # 5bba <unlink>
  close(fd1);
     1b6:	8526                	mv	a0,s1
     1b8:	00006097          	auipc	ra,0x6
     1bc:	9da080e7          	jalr	-1574(ra) # 5b92 <close>
  close(fd2);
     1c0:	854a                	mv	a0,s2
     1c2:	00006097          	auipc	ra,0x6
     1c6:	9d0080e7          	jalr	-1584(ra) # 5b92 <close>
}
     1ca:	70a2                	ld	ra,40(sp)
     1cc:	7402                	ld	s0,32(sp)
     1ce:	64e2                	ld	s1,24(sp)
     1d0:	6942                	ld	s2,16(sp)
     1d2:	69a2                	ld	s3,8(sp)
     1d4:	6145                	addi	sp,sp,48
     1d6:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1d8:	862a                	mv	a2,a0
     1da:	85ce                	mv	a1,s3
     1dc:	00006517          	auipc	a0,0x6
     1e0:	fb450513          	addi	a0,a0,-76 # 6190 <malloc+0x1c0>
     1e4:	00006097          	auipc	ra,0x6
     1e8:	d2e080e7          	jalr	-722(ra) # 5f12 <printf>
    exit(1);
     1ec:	4505                	li	a0,1
     1ee:	00006097          	auipc	ra,0x6
     1f2:	97c080e7          	jalr	-1668(ra) # 5b6a <exit>

00000000000001f6 <createtest>:
{
     1f6:	7179                	addi	sp,sp,-48
     1f8:	f406                	sd	ra,40(sp)
     1fa:	f022                	sd	s0,32(sp)
     1fc:	ec26                	sd	s1,24(sp)
     1fe:	e84a                	sd	s2,16(sp)
     200:	1800                	addi	s0,sp,48
  name[0] = 'a';
     202:	06100793          	li	a5,97
     206:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     20a:	fc040d23          	sb	zero,-38(s0)
     20e:	03000493          	li	s1,48
  for (i = 0; i < N; i++)
     212:	06400913          	li	s2,100
    name[1] = '0' + i;
     216:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE | O_RDWR);
     21a:	20200593          	li	a1,514
     21e:	fd840513          	addi	a0,s0,-40
     222:	00006097          	auipc	ra,0x6
     226:	988080e7          	jalr	-1656(ra) # 5baa <open>
    close(fd);
     22a:	00006097          	auipc	ra,0x6
     22e:	968080e7          	jalr	-1688(ra) # 5b92 <close>
  for (i = 0; i < N; i++)
     232:	2485                	addiw	s1,s1,1
     234:	0ff4f493          	andi	s1,s1,255
     238:	fd249fe3          	bne	s1,s2,216 <createtest+0x20>
  name[0] = 'a';
     23c:	06100793          	li	a5,97
     240:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     244:	fc040d23          	sb	zero,-38(s0)
     248:	03000493          	li	s1,48
  for (i = 0; i < N; i++)
     24c:	06400913          	li	s2,100
    name[1] = '0' + i;
     250:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     254:	fd840513          	addi	a0,s0,-40
     258:	00006097          	auipc	ra,0x6
     25c:	962080e7          	jalr	-1694(ra) # 5bba <unlink>
  for (i = 0; i < N; i++)
     260:	2485                	addiw	s1,s1,1
     262:	0ff4f493          	andi	s1,s1,255
     266:	ff2495e3          	bne	s1,s2,250 <createtest+0x5a>
}
     26a:	70a2                	ld	ra,40(sp)
     26c:	7402                	ld	s0,32(sp)
     26e:	64e2                	ld	s1,24(sp)
     270:	6942                	ld	s2,16(sp)
     272:	6145                	addi	sp,sp,48
     274:	8082                	ret

0000000000000276 <bigwrite>:
{
     276:	715d                	addi	sp,sp,-80
     278:	e486                	sd	ra,72(sp)
     27a:	e0a2                	sd	s0,64(sp)
     27c:	fc26                	sd	s1,56(sp)
     27e:	f84a                	sd	s2,48(sp)
     280:	f44e                	sd	s3,40(sp)
     282:	f052                	sd	s4,32(sp)
     284:	ec56                	sd	s5,24(sp)
     286:	e85a                	sd	s6,16(sp)
     288:	e45e                	sd	s7,8(sp)
     28a:	0880                	addi	s0,sp,80
     28c:	8baa                	mv	s7,a0
  unlink("bigwrite");
     28e:	00006517          	auipc	a0,0x6
     292:	f2a50513          	addi	a0,a0,-214 # 61b8 <malloc+0x1e8>
     296:	00006097          	auipc	ra,0x6
     29a:	924080e7          	jalr	-1756(ra) # 5bba <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471)
     29e:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a2:	00006a97          	auipc	s5,0x6
     2a6:	f16a8a93          	addi	s5,s5,-234 # 61b8 <malloc+0x1e8>
      int cc = write(fd, buf, sz);
     2aa:	0000da17          	auipc	s4,0xd
     2ae:	9cea0a13          	addi	s4,s4,-1586 # cc78 <buf>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471)
     2b2:	6b0d                	lui	s6,0x3
     2b4:	1c9b0b13          	addi	s6,s6,457 # 31c9 <diskfull+0x5d>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2b8:	20200593          	li	a1,514
     2bc:	8556                	mv	a0,s5
     2be:	00006097          	auipc	ra,0x6
     2c2:	8ec080e7          	jalr	-1812(ra) # 5baa <open>
     2c6:	892a                	mv	s2,a0
    if (fd < 0)
     2c8:	04054d63          	bltz	a0,322 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	00006097          	auipc	ra,0x6
     2d4:	8ba080e7          	jalr	-1862(ra) # 5b8a <write>
     2d8:	89aa                	mv	s3,a0
      if (cc != sz)
     2da:	06a49463          	bne	s1,a0,342 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2de:	8626                	mv	a2,s1
     2e0:	85d2                	mv	a1,s4
     2e2:	854a                	mv	a0,s2
     2e4:	00006097          	auipc	ra,0x6
     2e8:	8a6080e7          	jalr	-1882(ra) # 5b8a <write>
      if (cc != sz)
     2ec:	04951963          	bne	a0,s1,33e <bigwrite+0xc8>
    close(fd);
     2f0:	854a                	mv	a0,s2
     2f2:	00006097          	auipc	ra,0x6
     2f6:	8a0080e7          	jalr	-1888(ra) # 5b92 <close>
    unlink("bigwrite");
     2fa:	8556                	mv	a0,s5
     2fc:	00006097          	auipc	ra,0x6
     300:	8be080e7          	jalr	-1858(ra) # 5bba <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471)
     304:	1d74849b          	addiw	s1,s1,471
     308:	fb6498e3          	bne	s1,s6,2b8 <bigwrite+0x42>
}
     30c:	60a6                	ld	ra,72(sp)
     30e:	6406                	ld	s0,64(sp)
     310:	74e2                	ld	s1,56(sp)
     312:	7942                	ld	s2,48(sp)
     314:	79a2                	ld	s3,40(sp)
     316:	7a02                	ld	s4,32(sp)
     318:	6ae2                	ld	s5,24(sp)
     31a:	6b42                	ld	s6,16(sp)
     31c:	6ba2                	ld	s7,8(sp)
     31e:	6161                	addi	sp,sp,80
     320:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     322:	85de                	mv	a1,s7
     324:	00006517          	auipc	a0,0x6
     328:	ea450513          	addi	a0,a0,-348 # 61c8 <malloc+0x1f8>
     32c:	00006097          	auipc	ra,0x6
     330:	be6080e7          	jalr	-1050(ra) # 5f12 <printf>
      exit(1);
     334:	4505                	li	a0,1
     336:	00006097          	auipc	ra,0x6
     33a:	834080e7          	jalr	-1996(ra) # 5b6a <exit>
     33e:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     340:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     342:	86ce                	mv	a3,s3
     344:	8626                	mv	a2,s1
     346:	85de                	mv	a1,s7
     348:	00006517          	auipc	a0,0x6
     34c:	ea050513          	addi	a0,a0,-352 # 61e8 <malloc+0x218>
     350:	00006097          	auipc	ra,0x6
     354:	bc2080e7          	jalr	-1086(ra) # 5f12 <printf>
        exit(1);
     358:	4505                	li	a0,1
     35a:	00006097          	auipc	ra,0x6
     35e:	810080e7          	jalr	-2032(ra) # 5b6a <exit>

0000000000000362 <badwrite>:
// a block to be allocated for a file that is then not freed when the
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void badwrite(char *s)
{
     362:	7179                	addi	sp,sp,-48
     364:	f406                	sd	ra,40(sp)
     366:	f022                	sd	s0,32(sp)
     368:	ec26                	sd	s1,24(sp)
     36a:	e84a                	sd	s2,16(sp)
     36c:	e44e                	sd	s3,8(sp)
     36e:	e052                	sd	s4,0(sp)
     370:	1800                	addi	s0,sp,48
  int assumed_free = 600;

  unlink("junk");
     372:	00006517          	auipc	a0,0x6
     376:	e8e50513          	addi	a0,a0,-370 # 6200 <malloc+0x230>
     37a:	00006097          	auipc	ra,0x6
     37e:	840080e7          	jalr	-1984(ra) # 5bba <unlink>
     382:	25800913          	li	s2,600
  for (int i = 0; i < assumed_free; i++)
  {
    int fd = open("junk", O_CREATE | O_WRONLY);
     386:	00006997          	auipc	s3,0x6
     38a:	e7a98993          	addi	s3,s3,-390 # 6200 <malloc+0x230>
    if (fd < 0)
    {
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char *)0xffffffffffL, 1);
     38e:	5a7d                	li	s4,-1
     390:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE | O_WRONLY);
     394:	20100593          	li	a1,513
     398:	854e                	mv	a0,s3
     39a:	00006097          	auipc	ra,0x6
     39e:	810080e7          	jalr	-2032(ra) # 5baa <open>
     3a2:	84aa                	mv	s1,a0
    if (fd < 0)
     3a4:	06054b63          	bltz	a0,41a <badwrite+0xb8>
    write(fd, (char *)0xffffffffffL, 1);
     3a8:	4605                	li	a2,1
     3aa:	85d2                	mv	a1,s4
     3ac:	00005097          	auipc	ra,0x5
     3b0:	7de080e7          	jalr	2014(ra) # 5b8a <write>
    close(fd);
     3b4:	8526                	mv	a0,s1
     3b6:	00005097          	auipc	ra,0x5
     3ba:	7dc080e7          	jalr	2012(ra) # 5b92 <close>
    unlink("junk");
     3be:	854e                	mv	a0,s3
     3c0:	00005097          	auipc	ra,0x5
     3c4:	7fa080e7          	jalr	2042(ra) # 5bba <unlink>
  for (int i = 0; i < assumed_free; i++)
     3c8:	397d                	addiw	s2,s2,-1
     3ca:	fc0915e3          	bnez	s2,394 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE | O_WRONLY);
     3ce:	20100593          	li	a1,513
     3d2:	00006517          	auipc	a0,0x6
     3d6:	e2e50513          	addi	a0,a0,-466 # 6200 <malloc+0x230>
     3da:	00005097          	auipc	ra,0x5
     3de:	7d0080e7          	jalr	2000(ra) # 5baa <open>
     3e2:	84aa                	mv	s1,a0
  if (fd < 0)
     3e4:	04054863          	bltz	a0,434 <badwrite+0xd2>
  {
    printf("open junk failed\n");
    exit(1);
  }
  if (write(fd, "x", 1) != 1)
     3e8:	4605                	li	a2,1
     3ea:	00006597          	auipc	a1,0x6
     3ee:	d9e58593          	addi	a1,a1,-610 # 6188 <malloc+0x1b8>
     3f2:	00005097          	auipc	ra,0x5
     3f6:	798080e7          	jalr	1944(ra) # 5b8a <write>
     3fa:	4785                	li	a5,1
     3fc:	04f50963          	beq	a0,a5,44e <badwrite+0xec>
  {
    printf("write failed\n");
     400:	00006517          	auipc	a0,0x6
     404:	e2050513          	addi	a0,a0,-480 # 6220 <malloc+0x250>
     408:	00006097          	auipc	ra,0x6
     40c:	b0a080e7          	jalr	-1270(ra) # 5f12 <printf>
    exit(1);
     410:	4505                	li	a0,1
     412:	00005097          	auipc	ra,0x5
     416:	758080e7          	jalr	1880(ra) # 5b6a <exit>
      printf("open junk failed\n");
     41a:	00006517          	auipc	a0,0x6
     41e:	dee50513          	addi	a0,a0,-530 # 6208 <malloc+0x238>
     422:	00006097          	auipc	ra,0x6
     426:	af0080e7          	jalr	-1296(ra) # 5f12 <printf>
      exit(1);
     42a:	4505                	li	a0,1
     42c:	00005097          	auipc	ra,0x5
     430:	73e080e7          	jalr	1854(ra) # 5b6a <exit>
    printf("open junk failed\n");
     434:	00006517          	auipc	a0,0x6
     438:	dd450513          	addi	a0,a0,-556 # 6208 <malloc+0x238>
     43c:	00006097          	auipc	ra,0x6
     440:	ad6080e7          	jalr	-1322(ra) # 5f12 <printf>
    exit(1);
     444:	4505                	li	a0,1
     446:	00005097          	auipc	ra,0x5
     44a:	724080e7          	jalr	1828(ra) # 5b6a <exit>
  }
  close(fd);
     44e:	8526                	mv	a0,s1
     450:	00005097          	auipc	ra,0x5
     454:	742080e7          	jalr	1858(ra) # 5b92 <close>
  unlink("junk");
     458:	00006517          	auipc	a0,0x6
     45c:	da850513          	addi	a0,a0,-600 # 6200 <malloc+0x230>
     460:	00005097          	auipc	ra,0x5
     464:	75a080e7          	jalr	1882(ra) # 5bba <unlink>

  exit(0);
     468:	4501                	li	a0,0
     46a:	00005097          	auipc	ra,0x5
     46e:	700080e7          	jalr	1792(ra) # 5b6a <exit>

0000000000000472 <outofinodes>:
    unlink(name);
  }
}

void outofinodes(char *s)
{
     472:	715d                	addi	sp,sp,-80
     474:	e486                	sd	ra,72(sp)
     476:	e0a2                	sd	s0,64(sp)
     478:	fc26                	sd	s1,56(sp)
     47a:	f84a                	sd	s2,48(sp)
     47c:	f44e                	sd	s3,40(sp)
     47e:	0880                	addi	s0,sp,80
  int nzz = 32 * 32;
  for (int i = 0; i < nzz; i++)
     480:	4481                	li	s1,0
  {
    char name[32];
    name[0] = 'z';
     482:	07a00913          	li	s2,122
  for (int i = 0; i < nzz; i++)
     486:	40000993          	li	s3,1024
    name[0] = 'z';
     48a:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     48e:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     492:	41f4d79b          	sraiw	a5,s1,0x1f
     496:	01b7d71b          	srliw	a4,a5,0x1b
     49a:	009707bb          	addw	a5,a4,s1
     49e:	4057d69b          	sraiw	a3,a5,0x5
     4a2:	0306869b          	addiw	a3,a3,48
     4a6:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     4aa:	8bfd                	andi	a5,a5,31
     4ac:	9f99                	subw	a5,a5,a4
     4ae:	0307879b          	addiw	a5,a5,48
     4b2:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4b6:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4ba:	fb040513          	addi	a0,s0,-80
     4be:	00005097          	auipc	ra,0x5
     4c2:	6fc080e7          	jalr	1788(ra) # 5bba <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
     4c6:	60200593          	li	a1,1538
     4ca:	fb040513          	addi	a0,s0,-80
     4ce:	00005097          	auipc	ra,0x5
     4d2:	6dc080e7          	jalr	1756(ra) # 5baa <open>
    if (fd < 0)
     4d6:	00054963          	bltz	a0,4e8 <outofinodes+0x76>
    {
      // failure is eventually expected.
      break;
    }
    close(fd);
     4da:	00005097          	auipc	ra,0x5
     4de:	6b8080e7          	jalr	1720(ra) # 5b92 <close>
  for (int i = 0; i < nzz; i++)
     4e2:	2485                	addiw	s1,s1,1
     4e4:	fb3493e3          	bne	s1,s3,48a <outofinodes+0x18>
     4e8:	4481                	li	s1,0
  }

  for (int i = 0; i < nzz; i++)
  {
    char name[32];
    name[0] = 'z';
     4ea:	07a00913          	li	s2,122
  for (int i = 0; i < nzz; i++)
     4ee:	40000993          	li	s3,1024
    name[0] = 'z';
     4f2:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4f6:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4fa:	41f4d79b          	sraiw	a5,s1,0x1f
     4fe:	01b7d71b          	srliw	a4,a5,0x1b
     502:	009707bb          	addw	a5,a4,s1
     506:	4057d69b          	sraiw	a3,a5,0x5
     50a:	0306869b          	addiw	a3,a3,48
     50e:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     512:	8bfd                	andi	a5,a5,31
     514:	9f99                	subw	a5,a5,a4
     516:	0307879b          	addiw	a5,a5,48
     51a:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     51e:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     522:	fb040513          	addi	a0,s0,-80
     526:	00005097          	auipc	ra,0x5
     52a:	694080e7          	jalr	1684(ra) # 5bba <unlink>
  for (int i = 0; i < nzz; i++)
     52e:	2485                	addiw	s1,s1,1
     530:	fd3491e3          	bne	s1,s3,4f2 <outofinodes+0x80>
  }
}
     534:	60a6                	ld	ra,72(sp)
     536:	6406                	ld	s0,64(sp)
     538:	74e2                	ld	s1,56(sp)
     53a:	7942                	ld	s2,48(sp)
     53c:	79a2                	ld	s3,40(sp)
     53e:	6161                	addi	sp,sp,80
     540:	8082                	ret

0000000000000542 <copyin>:
{
     542:	715d                	addi	sp,sp,-80
     544:	e486                	sd	ra,72(sp)
     546:	e0a2                	sd	s0,64(sp)
     548:	fc26                	sd	s1,56(sp)
     54a:	f84a                	sd	s2,48(sp)
     54c:	f44e                	sd	s3,40(sp)
     54e:	f052                	sd	s4,32(sp)
     550:	0880                	addi	s0,sp,80
  uint64 addrs[] = {0x80000000LL, 0xffffffffffffffff};
     552:	4785                	li	a5,1
     554:	07fe                	slli	a5,a5,0x1f
     556:	fcf43023          	sd	a5,-64(s0)
     55a:	57fd                	li	a5,-1
     55c:	fcf43423          	sd	a5,-56(s0)
  for (int ai = 0; ai < 2; ai++)
     560:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     564:	00006a17          	auipc	s4,0x6
     568:	ccca0a13          	addi	s4,s4,-820 # 6230 <malloc+0x260>
    uint64 addr = addrs[ai];
     56c:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     570:	20100593          	li	a1,513
     574:	8552                	mv	a0,s4
     576:	00005097          	auipc	ra,0x5
     57a:	634080e7          	jalr	1588(ra) # 5baa <open>
     57e:	84aa                	mv	s1,a0
    if (fd < 0)
     580:	08054863          	bltz	a0,610 <copyin+0xce>
    int n = write(fd, (void *)addr, 8192);
     584:	6609                	lui	a2,0x2
     586:	85ce                	mv	a1,s3
     588:	00005097          	auipc	ra,0x5
     58c:	602080e7          	jalr	1538(ra) # 5b8a <write>
    if (n >= 0)
     590:	08055d63          	bgez	a0,62a <copyin+0xe8>
    close(fd);
     594:	8526                	mv	a0,s1
     596:	00005097          	auipc	ra,0x5
     59a:	5fc080e7          	jalr	1532(ra) # 5b92 <close>
    unlink("copyin1");
     59e:	8552                	mv	a0,s4
     5a0:	00005097          	auipc	ra,0x5
     5a4:	61a080e7          	jalr	1562(ra) # 5bba <unlink>
    n = write(1, (char *)addr, 8192);
     5a8:	6609                	lui	a2,0x2
     5aa:	85ce                	mv	a1,s3
     5ac:	4505                	li	a0,1
     5ae:	00005097          	auipc	ra,0x5
     5b2:	5dc080e7          	jalr	1500(ra) # 5b8a <write>
    if (n > 0)
     5b6:	08a04963          	bgtz	a0,648 <copyin+0x106>
    if (pipe(fds) < 0)
     5ba:	fb840513          	addi	a0,s0,-72
     5be:	00005097          	auipc	ra,0x5
     5c2:	5bc080e7          	jalr	1468(ra) # 5b7a <pipe>
     5c6:	0a054063          	bltz	a0,666 <copyin+0x124>
    n = write(fds[1], (char *)addr, 8192);
     5ca:	6609                	lui	a2,0x2
     5cc:	85ce                	mv	a1,s3
     5ce:	fbc42503          	lw	a0,-68(s0)
     5d2:	00005097          	auipc	ra,0x5
     5d6:	5b8080e7          	jalr	1464(ra) # 5b8a <write>
    if (n > 0)
     5da:	0aa04363          	bgtz	a0,680 <copyin+0x13e>
    close(fds[0]);
     5de:	fb842503          	lw	a0,-72(s0)
     5e2:	00005097          	auipc	ra,0x5
     5e6:	5b0080e7          	jalr	1456(ra) # 5b92 <close>
    close(fds[1]);
     5ea:	fbc42503          	lw	a0,-68(s0)
     5ee:	00005097          	auipc	ra,0x5
     5f2:	5a4080e7          	jalr	1444(ra) # 5b92 <close>
  for (int ai = 0; ai < 2; ai++)
     5f6:	0921                	addi	s2,s2,8
     5f8:	fd040793          	addi	a5,s0,-48
     5fc:	f6f918e3          	bne	s2,a5,56c <copyin+0x2a>
}
     600:	60a6                	ld	ra,72(sp)
     602:	6406                	ld	s0,64(sp)
     604:	74e2                	ld	s1,56(sp)
     606:	7942                	ld	s2,48(sp)
     608:	79a2                	ld	s3,40(sp)
     60a:	7a02                	ld	s4,32(sp)
     60c:	6161                	addi	sp,sp,80
     60e:	8082                	ret
      printf("open(copyin1) failed\n");
     610:	00006517          	auipc	a0,0x6
     614:	c2850513          	addi	a0,a0,-984 # 6238 <malloc+0x268>
     618:	00006097          	auipc	ra,0x6
     61c:	8fa080e7          	jalr	-1798(ra) # 5f12 <printf>
      exit(1);
     620:	4505                	li	a0,1
     622:	00005097          	auipc	ra,0x5
     626:	548080e7          	jalr	1352(ra) # 5b6a <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     62a:	862a                	mv	a2,a0
     62c:	85ce                	mv	a1,s3
     62e:	00006517          	auipc	a0,0x6
     632:	c2250513          	addi	a0,a0,-990 # 6250 <malloc+0x280>
     636:	00006097          	auipc	ra,0x6
     63a:	8dc080e7          	jalr	-1828(ra) # 5f12 <printf>
      exit(1);
     63e:	4505                	li	a0,1
     640:	00005097          	auipc	ra,0x5
     644:	52a080e7          	jalr	1322(ra) # 5b6a <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     648:	862a                	mv	a2,a0
     64a:	85ce                	mv	a1,s3
     64c:	00006517          	auipc	a0,0x6
     650:	c3450513          	addi	a0,a0,-972 # 6280 <malloc+0x2b0>
     654:	00006097          	auipc	ra,0x6
     658:	8be080e7          	jalr	-1858(ra) # 5f12 <printf>
      exit(1);
     65c:	4505                	li	a0,1
     65e:	00005097          	auipc	ra,0x5
     662:	50c080e7          	jalr	1292(ra) # 5b6a <exit>
      printf("pipe() failed\n");
     666:	00006517          	auipc	a0,0x6
     66a:	c4a50513          	addi	a0,a0,-950 # 62b0 <malloc+0x2e0>
     66e:	00006097          	auipc	ra,0x6
     672:	8a4080e7          	jalr	-1884(ra) # 5f12 <printf>
      exit(1);
     676:	4505                	li	a0,1
     678:	00005097          	auipc	ra,0x5
     67c:	4f2080e7          	jalr	1266(ra) # 5b6a <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     680:	862a                	mv	a2,a0
     682:	85ce                	mv	a1,s3
     684:	00006517          	auipc	a0,0x6
     688:	c3c50513          	addi	a0,a0,-964 # 62c0 <malloc+0x2f0>
     68c:	00006097          	auipc	ra,0x6
     690:	886080e7          	jalr	-1914(ra) # 5f12 <printf>
      exit(1);
     694:	4505                	li	a0,1
     696:	00005097          	auipc	ra,0x5
     69a:	4d4080e7          	jalr	1236(ra) # 5b6a <exit>

000000000000069e <copyout>:
{
     69e:	711d                	addi	sp,sp,-96
     6a0:	ec86                	sd	ra,88(sp)
     6a2:	e8a2                	sd	s0,80(sp)
     6a4:	e4a6                	sd	s1,72(sp)
     6a6:	e0ca                	sd	s2,64(sp)
     6a8:	fc4e                	sd	s3,56(sp)
     6aa:	f852                	sd	s4,48(sp)
     6ac:	f456                	sd	s5,40(sp)
     6ae:	1080                	addi	s0,sp,96
  uint64 addrs[] = {0x80000000LL, 0xffffffffffffffff};
     6b0:	4785                	li	a5,1
     6b2:	07fe                	slli	a5,a5,0x1f
     6b4:	faf43823          	sd	a5,-80(s0)
     6b8:	57fd                	li	a5,-1
     6ba:	faf43c23          	sd	a5,-72(s0)
  for (int ai = 0; ai < 2; ai++)
     6be:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     6c2:	00006a17          	auipc	s4,0x6
     6c6:	c2ea0a13          	addi	s4,s4,-978 # 62f0 <malloc+0x320>
    n = write(fds[1], "x", 1);
     6ca:	00006a97          	auipc	s5,0x6
     6ce:	abea8a93          	addi	s5,s5,-1346 # 6188 <malloc+0x1b8>
    uint64 addr = addrs[ai];
     6d2:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     6d6:	4581                	li	a1,0
     6d8:	8552                	mv	a0,s4
     6da:	00005097          	auipc	ra,0x5
     6de:	4d0080e7          	jalr	1232(ra) # 5baa <open>
     6e2:	84aa                	mv	s1,a0
    if (fd < 0)
     6e4:	08054663          	bltz	a0,770 <copyout+0xd2>
    int n = read(fd, (void *)addr, 8192);
     6e8:	6609                	lui	a2,0x2
     6ea:	85ce                	mv	a1,s3
     6ec:	00005097          	auipc	ra,0x5
     6f0:	496080e7          	jalr	1174(ra) # 5b82 <read>
    if (n > 0)
     6f4:	08a04b63          	bgtz	a0,78a <copyout+0xec>
    close(fd);
     6f8:	8526                	mv	a0,s1
     6fa:	00005097          	auipc	ra,0x5
     6fe:	498080e7          	jalr	1176(ra) # 5b92 <close>
    if (pipe(fds) < 0)
     702:	fa840513          	addi	a0,s0,-88
     706:	00005097          	auipc	ra,0x5
     70a:	474080e7          	jalr	1140(ra) # 5b7a <pipe>
     70e:	08054d63          	bltz	a0,7a8 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     712:	4605                	li	a2,1
     714:	85d6                	mv	a1,s5
     716:	fac42503          	lw	a0,-84(s0)
     71a:	00005097          	auipc	ra,0x5
     71e:	470080e7          	jalr	1136(ra) # 5b8a <write>
    if (n != 1)
     722:	4785                	li	a5,1
     724:	08f51f63          	bne	a0,a5,7c2 <copyout+0x124>
    n = read(fds[0], (void *)addr, 8192);
     728:	6609                	lui	a2,0x2
     72a:	85ce                	mv	a1,s3
     72c:	fa842503          	lw	a0,-88(s0)
     730:	00005097          	auipc	ra,0x5
     734:	452080e7          	jalr	1106(ra) # 5b82 <read>
    if (n > 0)
     738:	0aa04263          	bgtz	a0,7dc <copyout+0x13e>
    close(fds[0]);
     73c:	fa842503          	lw	a0,-88(s0)
     740:	00005097          	auipc	ra,0x5
     744:	452080e7          	jalr	1106(ra) # 5b92 <close>
    close(fds[1]);
     748:	fac42503          	lw	a0,-84(s0)
     74c:	00005097          	auipc	ra,0x5
     750:	446080e7          	jalr	1094(ra) # 5b92 <close>
  for (int ai = 0; ai < 2; ai++)
     754:	0921                	addi	s2,s2,8
     756:	fc040793          	addi	a5,s0,-64
     75a:	f6f91ce3          	bne	s2,a5,6d2 <copyout+0x34>
}
     75e:	60e6                	ld	ra,88(sp)
     760:	6446                	ld	s0,80(sp)
     762:	64a6                	ld	s1,72(sp)
     764:	6906                	ld	s2,64(sp)
     766:	79e2                	ld	s3,56(sp)
     768:	7a42                	ld	s4,48(sp)
     76a:	7aa2                	ld	s5,40(sp)
     76c:	6125                	addi	sp,sp,96
     76e:	8082                	ret
      printf("open(README) failed\n");
     770:	00006517          	auipc	a0,0x6
     774:	b8850513          	addi	a0,a0,-1144 # 62f8 <malloc+0x328>
     778:	00005097          	auipc	ra,0x5
     77c:	79a080e7          	jalr	1946(ra) # 5f12 <printf>
      exit(1);
     780:	4505                	li	a0,1
     782:	00005097          	auipc	ra,0x5
     786:	3e8080e7          	jalr	1000(ra) # 5b6a <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     78a:	862a                	mv	a2,a0
     78c:	85ce                	mv	a1,s3
     78e:	00006517          	auipc	a0,0x6
     792:	b8250513          	addi	a0,a0,-1150 # 6310 <malloc+0x340>
     796:	00005097          	auipc	ra,0x5
     79a:	77c080e7          	jalr	1916(ra) # 5f12 <printf>
      exit(1);
     79e:	4505                	li	a0,1
     7a0:	00005097          	auipc	ra,0x5
     7a4:	3ca080e7          	jalr	970(ra) # 5b6a <exit>
      printf("pipe() failed\n");
     7a8:	00006517          	auipc	a0,0x6
     7ac:	b0850513          	addi	a0,a0,-1272 # 62b0 <malloc+0x2e0>
     7b0:	00005097          	auipc	ra,0x5
     7b4:	762080e7          	jalr	1890(ra) # 5f12 <printf>
      exit(1);
     7b8:	4505                	li	a0,1
     7ba:	00005097          	auipc	ra,0x5
     7be:	3b0080e7          	jalr	944(ra) # 5b6a <exit>
      printf("pipe write failed\n");
     7c2:	00006517          	auipc	a0,0x6
     7c6:	b7e50513          	addi	a0,a0,-1154 # 6340 <malloc+0x370>
     7ca:	00005097          	auipc	ra,0x5
     7ce:	748080e7          	jalr	1864(ra) # 5f12 <printf>
      exit(1);
     7d2:	4505                	li	a0,1
     7d4:	00005097          	auipc	ra,0x5
     7d8:	396080e7          	jalr	918(ra) # 5b6a <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7dc:	862a                	mv	a2,a0
     7de:	85ce                	mv	a1,s3
     7e0:	00006517          	auipc	a0,0x6
     7e4:	b7850513          	addi	a0,a0,-1160 # 6358 <malloc+0x388>
     7e8:	00005097          	auipc	ra,0x5
     7ec:	72a080e7          	jalr	1834(ra) # 5f12 <printf>
      exit(1);
     7f0:	4505                	li	a0,1
     7f2:	00005097          	auipc	ra,0x5
     7f6:	378080e7          	jalr	888(ra) # 5b6a <exit>

00000000000007fa <truncate1>:
{
     7fa:	711d                	addi	sp,sp,-96
     7fc:	ec86                	sd	ra,88(sp)
     7fe:	e8a2                	sd	s0,80(sp)
     800:	e4a6                	sd	s1,72(sp)
     802:	e0ca                	sd	s2,64(sp)
     804:	fc4e                	sd	s3,56(sp)
     806:	f852                	sd	s4,48(sp)
     808:	f456                	sd	s5,40(sp)
     80a:	1080                	addi	s0,sp,96
     80c:	8aaa                	mv	s5,a0
  unlink("truncfile");
     80e:	00006517          	auipc	a0,0x6
     812:	96250513          	addi	a0,a0,-1694 # 6170 <malloc+0x1a0>
     816:	00005097          	auipc	ra,0x5
     81a:	3a4080e7          	jalr	932(ra) # 5bba <unlink>
  int fd1 = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
     81e:	60100593          	li	a1,1537
     822:	00006517          	auipc	a0,0x6
     826:	94e50513          	addi	a0,a0,-1714 # 6170 <malloc+0x1a0>
     82a:	00005097          	auipc	ra,0x5
     82e:	380080e7          	jalr	896(ra) # 5baa <open>
     832:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     834:	4611                	li	a2,4
     836:	00006597          	auipc	a1,0x6
     83a:	94a58593          	addi	a1,a1,-1718 # 6180 <malloc+0x1b0>
     83e:	00005097          	auipc	ra,0x5
     842:	34c080e7          	jalr	844(ra) # 5b8a <write>
  close(fd1);
     846:	8526                	mv	a0,s1
     848:	00005097          	auipc	ra,0x5
     84c:	34a080e7          	jalr	842(ra) # 5b92 <close>
  int fd2 = open("truncfile", O_RDONLY);
     850:	4581                	li	a1,0
     852:	00006517          	auipc	a0,0x6
     856:	91e50513          	addi	a0,a0,-1762 # 6170 <malloc+0x1a0>
     85a:	00005097          	auipc	ra,0x5
     85e:	350080e7          	jalr	848(ra) # 5baa <open>
     862:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     864:	02000613          	li	a2,32
     868:	fa040593          	addi	a1,s0,-96
     86c:	00005097          	auipc	ra,0x5
     870:	316080e7          	jalr	790(ra) # 5b82 <read>
  if (n != 4)
     874:	4791                	li	a5,4
     876:	0cf51e63          	bne	a0,a5,952 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY | O_TRUNC);
     87a:	40100593          	li	a1,1025
     87e:	00006517          	auipc	a0,0x6
     882:	8f250513          	addi	a0,a0,-1806 # 6170 <malloc+0x1a0>
     886:	00005097          	auipc	ra,0x5
     88a:	324080e7          	jalr	804(ra) # 5baa <open>
     88e:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     890:	4581                	li	a1,0
     892:	00006517          	auipc	a0,0x6
     896:	8de50513          	addi	a0,a0,-1826 # 6170 <malloc+0x1a0>
     89a:	00005097          	auipc	ra,0x5
     89e:	310080e7          	jalr	784(ra) # 5baa <open>
     8a2:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     8a4:	02000613          	li	a2,32
     8a8:	fa040593          	addi	a1,s0,-96
     8ac:	00005097          	auipc	ra,0x5
     8b0:	2d6080e7          	jalr	726(ra) # 5b82 <read>
     8b4:	8a2a                	mv	s4,a0
  if (n != 0)
     8b6:	ed4d                	bnez	a0,970 <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     8b8:	02000613          	li	a2,32
     8bc:	fa040593          	addi	a1,s0,-96
     8c0:	8526                	mv	a0,s1
     8c2:	00005097          	auipc	ra,0x5
     8c6:	2c0080e7          	jalr	704(ra) # 5b82 <read>
     8ca:	8a2a                	mv	s4,a0
  if (n != 0)
     8cc:	e971                	bnez	a0,9a0 <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     8ce:	4619                	li	a2,6
     8d0:	00006597          	auipc	a1,0x6
     8d4:	b1858593          	addi	a1,a1,-1256 # 63e8 <malloc+0x418>
     8d8:	854e                	mv	a0,s3
     8da:	00005097          	auipc	ra,0x5
     8de:	2b0080e7          	jalr	688(ra) # 5b8a <write>
  n = read(fd3, buf, sizeof(buf));
     8e2:	02000613          	li	a2,32
     8e6:	fa040593          	addi	a1,s0,-96
     8ea:	854a                	mv	a0,s2
     8ec:	00005097          	auipc	ra,0x5
     8f0:	296080e7          	jalr	662(ra) # 5b82 <read>
  if (n != 6)
     8f4:	4799                	li	a5,6
     8f6:	0cf51d63          	bne	a0,a5,9d0 <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     8fa:	02000613          	li	a2,32
     8fe:	fa040593          	addi	a1,s0,-96
     902:	8526                	mv	a0,s1
     904:	00005097          	auipc	ra,0x5
     908:	27e080e7          	jalr	638(ra) # 5b82 <read>
  if (n != 2)
     90c:	4789                	li	a5,2
     90e:	0ef51063          	bne	a0,a5,9ee <truncate1+0x1f4>
  unlink("truncfile");
     912:	00006517          	auipc	a0,0x6
     916:	85e50513          	addi	a0,a0,-1954 # 6170 <malloc+0x1a0>
     91a:	00005097          	auipc	ra,0x5
     91e:	2a0080e7          	jalr	672(ra) # 5bba <unlink>
  close(fd1);
     922:	854e                	mv	a0,s3
     924:	00005097          	auipc	ra,0x5
     928:	26e080e7          	jalr	622(ra) # 5b92 <close>
  close(fd2);
     92c:	8526                	mv	a0,s1
     92e:	00005097          	auipc	ra,0x5
     932:	264080e7          	jalr	612(ra) # 5b92 <close>
  close(fd3);
     936:	854a                	mv	a0,s2
     938:	00005097          	auipc	ra,0x5
     93c:	25a080e7          	jalr	602(ra) # 5b92 <close>
}
     940:	60e6                	ld	ra,88(sp)
     942:	6446                	ld	s0,80(sp)
     944:	64a6                	ld	s1,72(sp)
     946:	6906                	ld	s2,64(sp)
     948:	79e2                	ld	s3,56(sp)
     94a:	7a42                	ld	s4,48(sp)
     94c:	7aa2                	ld	s5,40(sp)
     94e:	6125                	addi	sp,sp,96
     950:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     952:	862a                	mv	a2,a0
     954:	85d6                	mv	a1,s5
     956:	00006517          	auipc	a0,0x6
     95a:	a3250513          	addi	a0,a0,-1486 # 6388 <malloc+0x3b8>
     95e:	00005097          	auipc	ra,0x5
     962:	5b4080e7          	jalr	1460(ra) # 5f12 <printf>
    exit(1);
     966:	4505                	li	a0,1
     968:	00005097          	auipc	ra,0x5
     96c:	202080e7          	jalr	514(ra) # 5b6a <exit>
    printf("aaa fd3=%d\n", fd3);
     970:	85ca                	mv	a1,s2
     972:	00006517          	auipc	a0,0x6
     976:	a3650513          	addi	a0,a0,-1482 # 63a8 <malloc+0x3d8>
     97a:	00005097          	auipc	ra,0x5
     97e:	598080e7          	jalr	1432(ra) # 5f12 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     982:	8652                	mv	a2,s4
     984:	85d6                	mv	a1,s5
     986:	00006517          	auipc	a0,0x6
     98a:	a3250513          	addi	a0,a0,-1486 # 63b8 <malloc+0x3e8>
     98e:	00005097          	auipc	ra,0x5
     992:	584080e7          	jalr	1412(ra) # 5f12 <printf>
    exit(1);
     996:	4505                	li	a0,1
     998:	00005097          	auipc	ra,0x5
     99c:	1d2080e7          	jalr	466(ra) # 5b6a <exit>
    printf("bbb fd2=%d\n", fd2);
     9a0:	85a6                	mv	a1,s1
     9a2:	00006517          	auipc	a0,0x6
     9a6:	a3650513          	addi	a0,a0,-1482 # 63d8 <malloc+0x408>
     9aa:	00005097          	auipc	ra,0x5
     9ae:	568080e7          	jalr	1384(ra) # 5f12 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     9b2:	8652                	mv	a2,s4
     9b4:	85d6                	mv	a1,s5
     9b6:	00006517          	auipc	a0,0x6
     9ba:	a0250513          	addi	a0,a0,-1534 # 63b8 <malloc+0x3e8>
     9be:	00005097          	auipc	ra,0x5
     9c2:	554080e7          	jalr	1364(ra) # 5f12 <printf>
    exit(1);
     9c6:	4505                	li	a0,1
     9c8:	00005097          	auipc	ra,0x5
     9cc:	1a2080e7          	jalr	418(ra) # 5b6a <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     9d0:	862a                	mv	a2,a0
     9d2:	85d6                	mv	a1,s5
     9d4:	00006517          	auipc	a0,0x6
     9d8:	a1c50513          	addi	a0,a0,-1508 # 63f0 <malloc+0x420>
     9dc:	00005097          	auipc	ra,0x5
     9e0:	536080e7          	jalr	1334(ra) # 5f12 <printf>
    exit(1);
     9e4:	4505                	li	a0,1
     9e6:	00005097          	auipc	ra,0x5
     9ea:	184080e7          	jalr	388(ra) # 5b6a <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     9ee:	862a                	mv	a2,a0
     9f0:	85d6                	mv	a1,s5
     9f2:	00006517          	auipc	a0,0x6
     9f6:	a1e50513          	addi	a0,a0,-1506 # 6410 <malloc+0x440>
     9fa:	00005097          	auipc	ra,0x5
     9fe:	518080e7          	jalr	1304(ra) # 5f12 <printf>
    exit(1);
     a02:	4505                	li	a0,1
     a04:	00005097          	auipc	ra,0x5
     a08:	166080e7          	jalr	358(ra) # 5b6a <exit>

0000000000000a0c <writetest>:
{
     a0c:	7139                	addi	sp,sp,-64
     a0e:	fc06                	sd	ra,56(sp)
     a10:	f822                	sd	s0,48(sp)
     a12:	f426                	sd	s1,40(sp)
     a14:	f04a                	sd	s2,32(sp)
     a16:	ec4e                	sd	s3,24(sp)
     a18:	e852                	sd	s4,16(sp)
     a1a:	e456                	sd	s5,8(sp)
     a1c:	e05a                	sd	s6,0(sp)
     a1e:	0080                	addi	s0,sp,64
     a20:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE | O_RDWR);
     a22:	20200593          	li	a1,514
     a26:	00006517          	auipc	a0,0x6
     a2a:	a0a50513          	addi	a0,a0,-1526 # 6430 <malloc+0x460>
     a2e:	00005097          	auipc	ra,0x5
     a32:	17c080e7          	jalr	380(ra) # 5baa <open>
  if (fd < 0)
     a36:	0a054d63          	bltz	a0,af0 <writetest+0xe4>
     a3a:	892a                	mv	s2,a0
     a3c:	4481                	li	s1,0
    if (write(fd, "aaaaaaaaaa", SZ) != SZ)
     a3e:	00006997          	auipc	s3,0x6
     a42:	a1a98993          	addi	s3,s3,-1510 # 6458 <malloc+0x488>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ)
     a46:	00006a97          	auipc	s5,0x6
     a4a:	a4aa8a93          	addi	s5,s5,-1462 # 6490 <malloc+0x4c0>
  for (i = 0; i < N; i++)
     a4e:	06400a13          	li	s4,100
    if (write(fd, "aaaaaaaaaa", SZ) != SZ)
     a52:	4629                	li	a2,10
     a54:	85ce                	mv	a1,s3
     a56:	854a                	mv	a0,s2
     a58:	00005097          	auipc	ra,0x5
     a5c:	132080e7          	jalr	306(ra) # 5b8a <write>
     a60:	47a9                	li	a5,10
     a62:	0af51563          	bne	a0,a5,b0c <writetest+0x100>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ)
     a66:	4629                	li	a2,10
     a68:	85d6                	mv	a1,s5
     a6a:	854a                	mv	a0,s2
     a6c:	00005097          	auipc	ra,0x5
     a70:	11e080e7          	jalr	286(ra) # 5b8a <write>
     a74:	47a9                	li	a5,10
     a76:	0af51a63          	bne	a0,a5,b2a <writetest+0x11e>
  for (i = 0; i < N; i++)
     a7a:	2485                	addiw	s1,s1,1
     a7c:	fd449be3          	bne	s1,s4,a52 <writetest+0x46>
  close(fd);
     a80:	854a                	mv	a0,s2
     a82:	00005097          	auipc	ra,0x5
     a86:	110080e7          	jalr	272(ra) # 5b92 <close>
  fd = open("small", O_RDONLY);
     a8a:	4581                	li	a1,0
     a8c:	00006517          	auipc	a0,0x6
     a90:	9a450513          	addi	a0,a0,-1628 # 6430 <malloc+0x460>
     a94:	00005097          	auipc	ra,0x5
     a98:	116080e7          	jalr	278(ra) # 5baa <open>
     a9c:	84aa                	mv	s1,a0
  if (fd < 0)
     a9e:	0a054563          	bltz	a0,b48 <writetest+0x13c>
  i = read(fd, buf, N * SZ * 2);
     aa2:	7d000613          	li	a2,2000
     aa6:	0000c597          	auipc	a1,0xc
     aaa:	1d258593          	addi	a1,a1,466 # cc78 <buf>
     aae:	00005097          	auipc	ra,0x5
     ab2:	0d4080e7          	jalr	212(ra) # 5b82 <read>
  if (i != N * SZ * 2)
     ab6:	7d000793          	li	a5,2000
     aba:	0af51563          	bne	a0,a5,b64 <writetest+0x158>
  close(fd);
     abe:	8526                	mv	a0,s1
     ac0:	00005097          	auipc	ra,0x5
     ac4:	0d2080e7          	jalr	210(ra) # 5b92 <close>
  if (unlink("small") < 0)
     ac8:	00006517          	auipc	a0,0x6
     acc:	96850513          	addi	a0,a0,-1688 # 6430 <malloc+0x460>
     ad0:	00005097          	auipc	ra,0x5
     ad4:	0ea080e7          	jalr	234(ra) # 5bba <unlink>
     ad8:	0a054463          	bltz	a0,b80 <writetest+0x174>
}
     adc:	70e2                	ld	ra,56(sp)
     ade:	7442                	ld	s0,48(sp)
     ae0:	74a2                	ld	s1,40(sp)
     ae2:	7902                	ld	s2,32(sp)
     ae4:	69e2                	ld	s3,24(sp)
     ae6:	6a42                	ld	s4,16(sp)
     ae8:	6aa2                	ld	s5,8(sp)
     aea:	6b02                	ld	s6,0(sp)
     aec:	6121                	addi	sp,sp,64
     aee:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     af0:	85da                	mv	a1,s6
     af2:	00006517          	auipc	a0,0x6
     af6:	94650513          	addi	a0,a0,-1722 # 6438 <malloc+0x468>
     afa:	00005097          	auipc	ra,0x5
     afe:	418080e7          	jalr	1048(ra) # 5f12 <printf>
    exit(1);
     b02:	4505                	li	a0,1
     b04:	00005097          	auipc	ra,0x5
     b08:	066080e7          	jalr	102(ra) # 5b6a <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     b0c:	8626                	mv	a2,s1
     b0e:	85da                	mv	a1,s6
     b10:	00006517          	auipc	a0,0x6
     b14:	95850513          	addi	a0,a0,-1704 # 6468 <malloc+0x498>
     b18:	00005097          	auipc	ra,0x5
     b1c:	3fa080e7          	jalr	1018(ra) # 5f12 <printf>
      exit(1);
     b20:	4505                	li	a0,1
     b22:	00005097          	auipc	ra,0x5
     b26:	048080e7          	jalr	72(ra) # 5b6a <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b2a:	8626                	mv	a2,s1
     b2c:	85da                	mv	a1,s6
     b2e:	00006517          	auipc	a0,0x6
     b32:	97250513          	addi	a0,a0,-1678 # 64a0 <malloc+0x4d0>
     b36:	00005097          	auipc	ra,0x5
     b3a:	3dc080e7          	jalr	988(ra) # 5f12 <printf>
      exit(1);
     b3e:	4505                	li	a0,1
     b40:	00005097          	auipc	ra,0x5
     b44:	02a080e7          	jalr	42(ra) # 5b6a <exit>
    printf("%s: error: open small failed!\n", s);
     b48:	85da                	mv	a1,s6
     b4a:	00006517          	auipc	a0,0x6
     b4e:	97e50513          	addi	a0,a0,-1666 # 64c8 <malloc+0x4f8>
     b52:	00005097          	auipc	ra,0x5
     b56:	3c0080e7          	jalr	960(ra) # 5f12 <printf>
    exit(1);
     b5a:	4505                	li	a0,1
     b5c:	00005097          	auipc	ra,0x5
     b60:	00e080e7          	jalr	14(ra) # 5b6a <exit>
    printf("%s: read failed\n", s);
     b64:	85da                	mv	a1,s6
     b66:	00006517          	auipc	a0,0x6
     b6a:	98250513          	addi	a0,a0,-1662 # 64e8 <malloc+0x518>
     b6e:	00005097          	auipc	ra,0x5
     b72:	3a4080e7          	jalr	932(ra) # 5f12 <printf>
    exit(1);
     b76:	4505                	li	a0,1
     b78:	00005097          	auipc	ra,0x5
     b7c:	ff2080e7          	jalr	-14(ra) # 5b6a <exit>
    printf("%s: unlink small failed\n", s);
     b80:	85da                	mv	a1,s6
     b82:	00006517          	auipc	a0,0x6
     b86:	97e50513          	addi	a0,a0,-1666 # 6500 <malloc+0x530>
     b8a:	00005097          	auipc	ra,0x5
     b8e:	388080e7          	jalr	904(ra) # 5f12 <printf>
    exit(1);
     b92:	4505                	li	a0,1
     b94:	00005097          	auipc	ra,0x5
     b98:	fd6080e7          	jalr	-42(ra) # 5b6a <exit>

0000000000000b9c <writebig>:
{
     b9c:	7139                	addi	sp,sp,-64
     b9e:	fc06                	sd	ra,56(sp)
     ba0:	f822                	sd	s0,48(sp)
     ba2:	f426                	sd	s1,40(sp)
     ba4:	f04a                	sd	s2,32(sp)
     ba6:	ec4e                	sd	s3,24(sp)
     ba8:	e852                	sd	s4,16(sp)
     baa:	e456                	sd	s5,8(sp)
     bac:	0080                	addi	s0,sp,64
     bae:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE | O_RDWR);
     bb0:	20200593          	li	a1,514
     bb4:	00006517          	auipc	a0,0x6
     bb8:	96c50513          	addi	a0,a0,-1684 # 6520 <malloc+0x550>
     bbc:	00005097          	auipc	ra,0x5
     bc0:	fee080e7          	jalr	-18(ra) # 5baa <open>
     bc4:	89aa                	mv	s3,a0
  for (i = 0; i < MAXFILE; i++)
     bc6:	4481                	li	s1,0
    ((int *)buf)[0] = i;
     bc8:	0000c917          	auipc	s2,0xc
     bcc:	0b090913          	addi	s2,s2,176 # cc78 <buf>
  for (i = 0; i < MAXFILE; i++)
     bd0:	10c00a13          	li	s4,268
  if (fd < 0)
     bd4:	06054c63          	bltz	a0,c4c <writebig+0xb0>
    ((int *)buf)[0] = i;
     bd8:	00992023          	sw	s1,0(s2)
    if (write(fd, buf, BSIZE) != BSIZE)
     bdc:	40000613          	li	a2,1024
     be0:	85ca                	mv	a1,s2
     be2:	854e                	mv	a0,s3
     be4:	00005097          	auipc	ra,0x5
     be8:	fa6080e7          	jalr	-90(ra) # 5b8a <write>
     bec:	40000793          	li	a5,1024
     bf0:	06f51c63          	bne	a0,a5,c68 <writebig+0xcc>
  for (i = 0; i < MAXFILE; i++)
     bf4:	2485                	addiw	s1,s1,1
     bf6:	ff4491e3          	bne	s1,s4,bd8 <writebig+0x3c>
  close(fd);
     bfa:	854e                	mv	a0,s3
     bfc:	00005097          	auipc	ra,0x5
     c00:	f96080e7          	jalr	-106(ra) # 5b92 <close>
  fd = open("big", O_RDONLY);
     c04:	4581                	li	a1,0
     c06:	00006517          	auipc	a0,0x6
     c0a:	91a50513          	addi	a0,a0,-1766 # 6520 <malloc+0x550>
     c0e:	00005097          	auipc	ra,0x5
     c12:	f9c080e7          	jalr	-100(ra) # 5baa <open>
     c16:	89aa                	mv	s3,a0
  n = 0;
     c18:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c1a:	0000c917          	auipc	s2,0xc
     c1e:	05e90913          	addi	s2,s2,94 # cc78 <buf>
  if (fd < 0)
     c22:	06054263          	bltz	a0,c86 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     c26:	40000613          	li	a2,1024
     c2a:	85ca                	mv	a1,s2
     c2c:	854e                	mv	a0,s3
     c2e:	00005097          	auipc	ra,0x5
     c32:	f54080e7          	jalr	-172(ra) # 5b82 <read>
    if (i == 0)
     c36:	c535                	beqz	a0,ca2 <writebig+0x106>
    else if (i != BSIZE)
     c38:	40000793          	li	a5,1024
     c3c:	0af51f63          	bne	a0,a5,cfa <writebig+0x15e>
    if (((int *)buf)[0] != n)
     c40:	00092683          	lw	a3,0(s2)
     c44:	0c969a63          	bne	a3,s1,d18 <writebig+0x17c>
    n++;
     c48:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c4a:	bff1                	j	c26 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     c4c:	85d6                	mv	a1,s5
     c4e:	00006517          	auipc	a0,0x6
     c52:	8da50513          	addi	a0,a0,-1830 # 6528 <malloc+0x558>
     c56:	00005097          	auipc	ra,0x5
     c5a:	2bc080e7          	jalr	700(ra) # 5f12 <printf>
    exit(1);
     c5e:	4505                	li	a0,1
     c60:	00005097          	auipc	ra,0x5
     c64:	f0a080e7          	jalr	-246(ra) # 5b6a <exit>
      printf("%s: error: write big file failed\n", s, i);
     c68:	8626                	mv	a2,s1
     c6a:	85d6                	mv	a1,s5
     c6c:	00006517          	auipc	a0,0x6
     c70:	8dc50513          	addi	a0,a0,-1828 # 6548 <malloc+0x578>
     c74:	00005097          	auipc	ra,0x5
     c78:	29e080e7          	jalr	670(ra) # 5f12 <printf>
      exit(1);
     c7c:	4505                	li	a0,1
     c7e:	00005097          	auipc	ra,0x5
     c82:	eec080e7          	jalr	-276(ra) # 5b6a <exit>
    printf("%s: error: open big failed!\n", s);
     c86:	85d6                	mv	a1,s5
     c88:	00006517          	auipc	a0,0x6
     c8c:	8e850513          	addi	a0,a0,-1816 # 6570 <malloc+0x5a0>
     c90:	00005097          	auipc	ra,0x5
     c94:	282080e7          	jalr	642(ra) # 5f12 <printf>
    exit(1);
     c98:	4505                	li	a0,1
     c9a:	00005097          	auipc	ra,0x5
     c9e:	ed0080e7          	jalr	-304(ra) # 5b6a <exit>
      if (n == MAXFILE - 1)
     ca2:	10b00793          	li	a5,267
     ca6:	02f48a63          	beq	s1,a5,cda <writebig+0x13e>
  close(fd);
     caa:	854e                	mv	a0,s3
     cac:	00005097          	auipc	ra,0x5
     cb0:	ee6080e7          	jalr	-282(ra) # 5b92 <close>
  if (unlink("big") < 0)
     cb4:	00006517          	auipc	a0,0x6
     cb8:	86c50513          	addi	a0,a0,-1940 # 6520 <malloc+0x550>
     cbc:	00005097          	auipc	ra,0x5
     cc0:	efe080e7          	jalr	-258(ra) # 5bba <unlink>
     cc4:	06054963          	bltz	a0,d36 <writebig+0x19a>
}
     cc8:	70e2                	ld	ra,56(sp)
     cca:	7442                	ld	s0,48(sp)
     ccc:	74a2                	ld	s1,40(sp)
     cce:	7902                	ld	s2,32(sp)
     cd0:	69e2                	ld	s3,24(sp)
     cd2:	6a42                	ld	s4,16(sp)
     cd4:	6aa2                	ld	s5,8(sp)
     cd6:	6121                	addi	sp,sp,64
     cd8:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     cda:	10b00613          	li	a2,267
     cde:	85d6                	mv	a1,s5
     ce0:	00006517          	auipc	a0,0x6
     ce4:	8b050513          	addi	a0,a0,-1872 # 6590 <malloc+0x5c0>
     ce8:	00005097          	auipc	ra,0x5
     cec:	22a080e7          	jalr	554(ra) # 5f12 <printf>
        exit(1);
     cf0:	4505                	li	a0,1
     cf2:	00005097          	auipc	ra,0x5
     cf6:	e78080e7          	jalr	-392(ra) # 5b6a <exit>
      printf("%s: read failed %d\n", s, i);
     cfa:	862a                	mv	a2,a0
     cfc:	85d6                	mv	a1,s5
     cfe:	00006517          	auipc	a0,0x6
     d02:	8ba50513          	addi	a0,a0,-1862 # 65b8 <malloc+0x5e8>
     d06:	00005097          	auipc	ra,0x5
     d0a:	20c080e7          	jalr	524(ra) # 5f12 <printf>
      exit(1);
     d0e:	4505                	li	a0,1
     d10:	00005097          	auipc	ra,0x5
     d14:	e5a080e7          	jalr	-422(ra) # 5b6a <exit>
      printf("%s: read content of block %d is %d\n", s,
     d18:	8626                	mv	a2,s1
     d1a:	85d6                	mv	a1,s5
     d1c:	00006517          	auipc	a0,0x6
     d20:	8b450513          	addi	a0,a0,-1868 # 65d0 <malloc+0x600>
     d24:	00005097          	auipc	ra,0x5
     d28:	1ee080e7          	jalr	494(ra) # 5f12 <printf>
      exit(1);
     d2c:	4505                	li	a0,1
     d2e:	00005097          	auipc	ra,0x5
     d32:	e3c080e7          	jalr	-452(ra) # 5b6a <exit>
    printf("%s: unlink big failed\n", s);
     d36:	85d6                	mv	a1,s5
     d38:	00006517          	auipc	a0,0x6
     d3c:	8c050513          	addi	a0,a0,-1856 # 65f8 <malloc+0x628>
     d40:	00005097          	auipc	ra,0x5
     d44:	1d2080e7          	jalr	466(ra) # 5f12 <printf>
    exit(1);
     d48:	4505                	li	a0,1
     d4a:	00005097          	auipc	ra,0x5
     d4e:	e20080e7          	jalr	-480(ra) # 5b6a <exit>

0000000000000d52 <unlinkread>:
{
     d52:	7179                	addi	sp,sp,-48
     d54:	f406                	sd	ra,40(sp)
     d56:	f022                	sd	s0,32(sp)
     d58:	ec26                	sd	s1,24(sp)
     d5a:	e84a                	sd	s2,16(sp)
     d5c:	e44e                	sd	s3,8(sp)
     d5e:	1800                	addi	s0,sp,48
     d60:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     d62:	20200593          	li	a1,514
     d66:	00006517          	auipc	a0,0x6
     d6a:	8aa50513          	addi	a0,a0,-1878 # 6610 <malloc+0x640>
     d6e:	00005097          	auipc	ra,0x5
     d72:	e3c080e7          	jalr	-452(ra) # 5baa <open>
  if (fd < 0)
     d76:	0e054563          	bltz	a0,e60 <unlinkread+0x10e>
     d7a:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     d7c:	4615                	li	a2,5
     d7e:	00006597          	auipc	a1,0x6
     d82:	8c258593          	addi	a1,a1,-1854 # 6640 <malloc+0x670>
     d86:	00005097          	auipc	ra,0x5
     d8a:	e04080e7          	jalr	-508(ra) # 5b8a <write>
  close(fd);
     d8e:	8526                	mv	a0,s1
     d90:	00005097          	auipc	ra,0x5
     d94:	e02080e7          	jalr	-510(ra) # 5b92 <close>
  fd = open("unlinkread", O_RDWR);
     d98:	4589                	li	a1,2
     d9a:	00006517          	auipc	a0,0x6
     d9e:	87650513          	addi	a0,a0,-1930 # 6610 <malloc+0x640>
     da2:	00005097          	auipc	ra,0x5
     da6:	e08080e7          	jalr	-504(ra) # 5baa <open>
     daa:	84aa                	mv	s1,a0
  if (fd < 0)
     dac:	0c054863          	bltz	a0,e7c <unlinkread+0x12a>
  if (unlink("unlinkread") != 0)
     db0:	00006517          	auipc	a0,0x6
     db4:	86050513          	addi	a0,a0,-1952 # 6610 <malloc+0x640>
     db8:	00005097          	auipc	ra,0x5
     dbc:	e02080e7          	jalr	-510(ra) # 5bba <unlink>
     dc0:	ed61                	bnez	a0,e98 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     dc2:	20200593          	li	a1,514
     dc6:	00006517          	auipc	a0,0x6
     dca:	84a50513          	addi	a0,a0,-1974 # 6610 <malloc+0x640>
     dce:	00005097          	auipc	ra,0x5
     dd2:	ddc080e7          	jalr	-548(ra) # 5baa <open>
     dd6:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     dd8:	460d                	li	a2,3
     dda:	00006597          	auipc	a1,0x6
     dde:	8ae58593          	addi	a1,a1,-1874 # 6688 <malloc+0x6b8>
     de2:	00005097          	auipc	ra,0x5
     de6:	da8080e7          	jalr	-600(ra) # 5b8a <write>
  close(fd1);
     dea:	854a                	mv	a0,s2
     dec:	00005097          	auipc	ra,0x5
     df0:	da6080e7          	jalr	-602(ra) # 5b92 <close>
  if (read(fd, buf, sizeof(buf)) != SZ)
     df4:	660d                	lui	a2,0x3
     df6:	0000c597          	auipc	a1,0xc
     dfa:	e8258593          	addi	a1,a1,-382 # cc78 <buf>
     dfe:	8526                	mv	a0,s1
     e00:	00005097          	auipc	ra,0x5
     e04:	d82080e7          	jalr	-638(ra) # 5b82 <read>
     e08:	4795                	li	a5,5
     e0a:	0af51563          	bne	a0,a5,eb4 <unlinkread+0x162>
  if (buf[0] != 'h')
     e0e:	0000c717          	auipc	a4,0xc
     e12:	e6a74703          	lbu	a4,-406(a4) # cc78 <buf>
     e16:	06800793          	li	a5,104
     e1a:	0af71b63          	bne	a4,a5,ed0 <unlinkread+0x17e>
  if (write(fd, buf, 10) != 10)
     e1e:	4629                	li	a2,10
     e20:	0000c597          	auipc	a1,0xc
     e24:	e5858593          	addi	a1,a1,-424 # cc78 <buf>
     e28:	8526                	mv	a0,s1
     e2a:	00005097          	auipc	ra,0x5
     e2e:	d60080e7          	jalr	-672(ra) # 5b8a <write>
     e32:	47a9                	li	a5,10
     e34:	0af51c63          	bne	a0,a5,eec <unlinkread+0x19a>
  close(fd);
     e38:	8526                	mv	a0,s1
     e3a:	00005097          	auipc	ra,0x5
     e3e:	d58080e7          	jalr	-680(ra) # 5b92 <close>
  unlink("unlinkread");
     e42:	00005517          	auipc	a0,0x5
     e46:	7ce50513          	addi	a0,a0,1998 # 6610 <malloc+0x640>
     e4a:	00005097          	auipc	ra,0x5
     e4e:	d70080e7          	jalr	-656(ra) # 5bba <unlink>
}
     e52:	70a2                	ld	ra,40(sp)
     e54:	7402                	ld	s0,32(sp)
     e56:	64e2                	ld	s1,24(sp)
     e58:	6942                	ld	s2,16(sp)
     e5a:	69a2                	ld	s3,8(sp)
     e5c:	6145                	addi	sp,sp,48
     e5e:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     e60:	85ce                	mv	a1,s3
     e62:	00005517          	auipc	a0,0x5
     e66:	7be50513          	addi	a0,a0,1982 # 6620 <malloc+0x650>
     e6a:	00005097          	auipc	ra,0x5
     e6e:	0a8080e7          	jalr	168(ra) # 5f12 <printf>
    exit(1);
     e72:	4505                	li	a0,1
     e74:	00005097          	auipc	ra,0x5
     e78:	cf6080e7          	jalr	-778(ra) # 5b6a <exit>
    printf("%s: open unlinkread failed\n", s);
     e7c:	85ce                	mv	a1,s3
     e7e:	00005517          	auipc	a0,0x5
     e82:	7ca50513          	addi	a0,a0,1994 # 6648 <malloc+0x678>
     e86:	00005097          	auipc	ra,0x5
     e8a:	08c080e7          	jalr	140(ra) # 5f12 <printf>
    exit(1);
     e8e:	4505                	li	a0,1
     e90:	00005097          	auipc	ra,0x5
     e94:	cda080e7          	jalr	-806(ra) # 5b6a <exit>
    printf("%s: unlink unlinkread failed\n", s);
     e98:	85ce                	mv	a1,s3
     e9a:	00005517          	auipc	a0,0x5
     e9e:	7ce50513          	addi	a0,a0,1998 # 6668 <malloc+0x698>
     ea2:	00005097          	auipc	ra,0x5
     ea6:	070080e7          	jalr	112(ra) # 5f12 <printf>
    exit(1);
     eaa:	4505                	li	a0,1
     eac:	00005097          	auipc	ra,0x5
     eb0:	cbe080e7          	jalr	-834(ra) # 5b6a <exit>
    printf("%s: unlinkread read failed", s);
     eb4:	85ce                	mv	a1,s3
     eb6:	00005517          	auipc	a0,0x5
     eba:	7da50513          	addi	a0,a0,2010 # 6690 <malloc+0x6c0>
     ebe:	00005097          	auipc	ra,0x5
     ec2:	054080e7          	jalr	84(ra) # 5f12 <printf>
    exit(1);
     ec6:	4505                	li	a0,1
     ec8:	00005097          	auipc	ra,0x5
     ecc:	ca2080e7          	jalr	-862(ra) # 5b6a <exit>
    printf("%s: unlinkread wrong data\n", s);
     ed0:	85ce                	mv	a1,s3
     ed2:	00005517          	auipc	a0,0x5
     ed6:	7de50513          	addi	a0,a0,2014 # 66b0 <malloc+0x6e0>
     eda:	00005097          	auipc	ra,0x5
     ede:	038080e7          	jalr	56(ra) # 5f12 <printf>
    exit(1);
     ee2:	4505                	li	a0,1
     ee4:	00005097          	auipc	ra,0x5
     ee8:	c86080e7          	jalr	-890(ra) # 5b6a <exit>
    printf("%s: unlinkread write failed\n", s);
     eec:	85ce                	mv	a1,s3
     eee:	00005517          	auipc	a0,0x5
     ef2:	7e250513          	addi	a0,a0,2018 # 66d0 <malloc+0x700>
     ef6:	00005097          	auipc	ra,0x5
     efa:	01c080e7          	jalr	28(ra) # 5f12 <printf>
    exit(1);
     efe:	4505                	li	a0,1
     f00:	00005097          	auipc	ra,0x5
     f04:	c6a080e7          	jalr	-918(ra) # 5b6a <exit>

0000000000000f08 <linktest>:
{
     f08:	1101                	addi	sp,sp,-32
     f0a:	ec06                	sd	ra,24(sp)
     f0c:	e822                	sd	s0,16(sp)
     f0e:	e426                	sd	s1,8(sp)
     f10:	e04a                	sd	s2,0(sp)
     f12:	1000                	addi	s0,sp,32
     f14:	892a                	mv	s2,a0
  unlink("lf1");
     f16:	00005517          	auipc	a0,0x5
     f1a:	7da50513          	addi	a0,a0,2010 # 66f0 <malloc+0x720>
     f1e:	00005097          	auipc	ra,0x5
     f22:	c9c080e7          	jalr	-868(ra) # 5bba <unlink>
  unlink("lf2");
     f26:	00005517          	auipc	a0,0x5
     f2a:	7d250513          	addi	a0,a0,2002 # 66f8 <malloc+0x728>
     f2e:	00005097          	auipc	ra,0x5
     f32:	c8c080e7          	jalr	-884(ra) # 5bba <unlink>
  fd = open("lf1", O_CREATE | O_RDWR);
     f36:	20200593          	li	a1,514
     f3a:	00005517          	auipc	a0,0x5
     f3e:	7b650513          	addi	a0,a0,1974 # 66f0 <malloc+0x720>
     f42:	00005097          	auipc	ra,0x5
     f46:	c68080e7          	jalr	-920(ra) # 5baa <open>
  if (fd < 0)
     f4a:	10054763          	bltz	a0,1058 <linktest+0x150>
     f4e:	84aa                	mv	s1,a0
  if (write(fd, "hello", SZ) != SZ)
     f50:	4615                	li	a2,5
     f52:	00005597          	auipc	a1,0x5
     f56:	6ee58593          	addi	a1,a1,1774 # 6640 <malloc+0x670>
     f5a:	00005097          	auipc	ra,0x5
     f5e:	c30080e7          	jalr	-976(ra) # 5b8a <write>
     f62:	4795                	li	a5,5
     f64:	10f51863          	bne	a0,a5,1074 <linktest+0x16c>
  close(fd);
     f68:	8526                	mv	a0,s1
     f6a:	00005097          	auipc	ra,0x5
     f6e:	c28080e7          	jalr	-984(ra) # 5b92 <close>
  if (link("lf1", "lf2") < 0)
     f72:	00005597          	auipc	a1,0x5
     f76:	78658593          	addi	a1,a1,1926 # 66f8 <malloc+0x728>
     f7a:	00005517          	auipc	a0,0x5
     f7e:	77650513          	addi	a0,a0,1910 # 66f0 <malloc+0x720>
     f82:	00005097          	auipc	ra,0x5
     f86:	c48080e7          	jalr	-952(ra) # 5bca <link>
     f8a:	10054363          	bltz	a0,1090 <linktest+0x188>
  unlink("lf1");
     f8e:	00005517          	auipc	a0,0x5
     f92:	76250513          	addi	a0,a0,1890 # 66f0 <malloc+0x720>
     f96:	00005097          	auipc	ra,0x5
     f9a:	c24080e7          	jalr	-988(ra) # 5bba <unlink>
  if (open("lf1", 0) >= 0)
     f9e:	4581                	li	a1,0
     fa0:	00005517          	auipc	a0,0x5
     fa4:	75050513          	addi	a0,a0,1872 # 66f0 <malloc+0x720>
     fa8:	00005097          	auipc	ra,0x5
     fac:	c02080e7          	jalr	-1022(ra) # 5baa <open>
     fb0:	0e055e63          	bgez	a0,10ac <linktest+0x1a4>
  fd = open("lf2", 0);
     fb4:	4581                	li	a1,0
     fb6:	00005517          	auipc	a0,0x5
     fba:	74250513          	addi	a0,a0,1858 # 66f8 <malloc+0x728>
     fbe:	00005097          	auipc	ra,0x5
     fc2:	bec080e7          	jalr	-1044(ra) # 5baa <open>
     fc6:	84aa                	mv	s1,a0
  if (fd < 0)
     fc8:	10054063          	bltz	a0,10c8 <linktest+0x1c0>
  if (read(fd, buf, sizeof(buf)) != SZ)
     fcc:	660d                	lui	a2,0x3
     fce:	0000c597          	auipc	a1,0xc
     fd2:	caa58593          	addi	a1,a1,-854 # cc78 <buf>
     fd6:	00005097          	auipc	ra,0x5
     fda:	bac080e7          	jalr	-1108(ra) # 5b82 <read>
     fde:	4795                	li	a5,5
     fe0:	10f51263          	bne	a0,a5,10e4 <linktest+0x1dc>
  close(fd);
     fe4:	8526                	mv	a0,s1
     fe6:	00005097          	auipc	ra,0x5
     fea:	bac080e7          	jalr	-1108(ra) # 5b92 <close>
  if (link("lf2", "lf2") >= 0)
     fee:	00005597          	auipc	a1,0x5
     ff2:	70a58593          	addi	a1,a1,1802 # 66f8 <malloc+0x728>
     ff6:	852e                	mv	a0,a1
     ff8:	00005097          	auipc	ra,0x5
     ffc:	bd2080e7          	jalr	-1070(ra) # 5bca <link>
    1000:	10055063          	bgez	a0,1100 <linktest+0x1f8>
  unlink("lf2");
    1004:	00005517          	auipc	a0,0x5
    1008:	6f450513          	addi	a0,a0,1780 # 66f8 <malloc+0x728>
    100c:	00005097          	auipc	ra,0x5
    1010:	bae080e7          	jalr	-1106(ra) # 5bba <unlink>
  if (link("lf2", "lf1") >= 0)
    1014:	00005597          	auipc	a1,0x5
    1018:	6dc58593          	addi	a1,a1,1756 # 66f0 <malloc+0x720>
    101c:	00005517          	auipc	a0,0x5
    1020:	6dc50513          	addi	a0,a0,1756 # 66f8 <malloc+0x728>
    1024:	00005097          	auipc	ra,0x5
    1028:	ba6080e7          	jalr	-1114(ra) # 5bca <link>
    102c:	0e055863          	bgez	a0,111c <linktest+0x214>
  if (link(".", "lf1") >= 0)
    1030:	00005597          	auipc	a1,0x5
    1034:	6c058593          	addi	a1,a1,1728 # 66f0 <malloc+0x720>
    1038:	00005517          	auipc	a0,0x5
    103c:	7c850513          	addi	a0,a0,1992 # 6800 <malloc+0x830>
    1040:	00005097          	auipc	ra,0x5
    1044:	b8a080e7          	jalr	-1142(ra) # 5bca <link>
    1048:	0e055863          	bgez	a0,1138 <linktest+0x230>
}
    104c:	60e2                	ld	ra,24(sp)
    104e:	6442                	ld	s0,16(sp)
    1050:	64a2                	ld	s1,8(sp)
    1052:	6902                	ld	s2,0(sp)
    1054:	6105                	addi	sp,sp,32
    1056:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    1058:	85ca                	mv	a1,s2
    105a:	00005517          	auipc	a0,0x5
    105e:	6a650513          	addi	a0,a0,1702 # 6700 <malloc+0x730>
    1062:	00005097          	auipc	ra,0x5
    1066:	eb0080e7          	jalr	-336(ra) # 5f12 <printf>
    exit(1);
    106a:	4505                	li	a0,1
    106c:	00005097          	auipc	ra,0x5
    1070:	afe080e7          	jalr	-1282(ra) # 5b6a <exit>
    printf("%s: write lf1 failed\n", s);
    1074:	85ca                	mv	a1,s2
    1076:	00005517          	auipc	a0,0x5
    107a:	6a250513          	addi	a0,a0,1698 # 6718 <malloc+0x748>
    107e:	00005097          	auipc	ra,0x5
    1082:	e94080e7          	jalr	-364(ra) # 5f12 <printf>
    exit(1);
    1086:	4505                	li	a0,1
    1088:	00005097          	auipc	ra,0x5
    108c:	ae2080e7          	jalr	-1310(ra) # 5b6a <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    1090:	85ca                	mv	a1,s2
    1092:	00005517          	auipc	a0,0x5
    1096:	69e50513          	addi	a0,a0,1694 # 6730 <malloc+0x760>
    109a:	00005097          	auipc	ra,0x5
    109e:	e78080e7          	jalr	-392(ra) # 5f12 <printf>
    exit(1);
    10a2:	4505                	li	a0,1
    10a4:	00005097          	auipc	ra,0x5
    10a8:	ac6080e7          	jalr	-1338(ra) # 5b6a <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    10ac:	85ca                	mv	a1,s2
    10ae:	00005517          	auipc	a0,0x5
    10b2:	6a250513          	addi	a0,a0,1698 # 6750 <malloc+0x780>
    10b6:	00005097          	auipc	ra,0x5
    10ba:	e5c080e7          	jalr	-420(ra) # 5f12 <printf>
    exit(1);
    10be:	4505                	li	a0,1
    10c0:	00005097          	auipc	ra,0x5
    10c4:	aaa080e7          	jalr	-1366(ra) # 5b6a <exit>
    printf("%s: open lf2 failed\n", s);
    10c8:	85ca                	mv	a1,s2
    10ca:	00005517          	auipc	a0,0x5
    10ce:	6b650513          	addi	a0,a0,1718 # 6780 <malloc+0x7b0>
    10d2:	00005097          	auipc	ra,0x5
    10d6:	e40080e7          	jalr	-448(ra) # 5f12 <printf>
    exit(1);
    10da:	4505                	li	a0,1
    10dc:	00005097          	auipc	ra,0x5
    10e0:	a8e080e7          	jalr	-1394(ra) # 5b6a <exit>
    printf("%s: read lf2 failed\n", s);
    10e4:	85ca                	mv	a1,s2
    10e6:	00005517          	auipc	a0,0x5
    10ea:	6b250513          	addi	a0,a0,1714 # 6798 <malloc+0x7c8>
    10ee:	00005097          	auipc	ra,0x5
    10f2:	e24080e7          	jalr	-476(ra) # 5f12 <printf>
    exit(1);
    10f6:	4505                	li	a0,1
    10f8:	00005097          	auipc	ra,0x5
    10fc:	a72080e7          	jalr	-1422(ra) # 5b6a <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    1100:	85ca                	mv	a1,s2
    1102:	00005517          	auipc	a0,0x5
    1106:	6ae50513          	addi	a0,a0,1710 # 67b0 <malloc+0x7e0>
    110a:	00005097          	auipc	ra,0x5
    110e:	e08080e7          	jalr	-504(ra) # 5f12 <printf>
    exit(1);
    1112:	4505                	li	a0,1
    1114:	00005097          	auipc	ra,0x5
    1118:	a56080e7          	jalr	-1450(ra) # 5b6a <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    111c:	85ca                	mv	a1,s2
    111e:	00005517          	auipc	a0,0x5
    1122:	6ba50513          	addi	a0,a0,1722 # 67d8 <malloc+0x808>
    1126:	00005097          	auipc	ra,0x5
    112a:	dec080e7          	jalr	-532(ra) # 5f12 <printf>
    exit(1);
    112e:	4505                	li	a0,1
    1130:	00005097          	auipc	ra,0x5
    1134:	a3a080e7          	jalr	-1478(ra) # 5b6a <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    1138:	85ca                	mv	a1,s2
    113a:	00005517          	auipc	a0,0x5
    113e:	6ce50513          	addi	a0,a0,1742 # 6808 <malloc+0x838>
    1142:	00005097          	auipc	ra,0x5
    1146:	dd0080e7          	jalr	-560(ra) # 5f12 <printf>
    exit(1);
    114a:	4505                	li	a0,1
    114c:	00005097          	auipc	ra,0x5
    1150:	a1e080e7          	jalr	-1506(ra) # 5b6a <exit>

0000000000001154 <validatetest>:
{
    1154:	7139                	addi	sp,sp,-64
    1156:	fc06                	sd	ra,56(sp)
    1158:	f822                	sd	s0,48(sp)
    115a:	f426                	sd	s1,40(sp)
    115c:	f04a                	sd	s2,32(sp)
    115e:	ec4e                	sd	s3,24(sp)
    1160:	e852                	sd	s4,16(sp)
    1162:	e456                	sd	s5,8(sp)
    1164:	e05a                	sd	s6,0(sp)
    1166:	0080                	addi	s0,sp,64
    1168:	8b2a                	mv	s6,a0
  for (p = 0; p <= (uint)hi; p += PGSIZE)
    116a:	4481                	li	s1,0
    if (link("nosuchfile", (char *)p) != -1)
    116c:	00005997          	auipc	s3,0x5
    1170:	6bc98993          	addi	s3,s3,1724 # 6828 <malloc+0x858>
    1174:	597d                	li	s2,-1
  for (p = 0; p <= (uint)hi; p += PGSIZE)
    1176:	6a85                	lui	s5,0x1
    1178:	00114a37          	lui	s4,0x114
    if (link("nosuchfile", (char *)p) != -1)
    117c:	85a6                	mv	a1,s1
    117e:	854e                	mv	a0,s3
    1180:	00005097          	auipc	ra,0x5
    1184:	a4a080e7          	jalr	-1462(ra) # 5bca <link>
    1188:	01251f63          	bne	a0,s2,11a6 <validatetest+0x52>
  for (p = 0; p <= (uint)hi; p += PGSIZE)
    118c:	94d6                	add	s1,s1,s5
    118e:	ff4497e3          	bne	s1,s4,117c <validatetest+0x28>
}
    1192:	70e2                	ld	ra,56(sp)
    1194:	7442                	ld	s0,48(sp)
    1196:	74a2                	ld	s1,40(sp)
    1198:	7902                	ld	s2,32(sp)
    119a:	69e2                	ld	s3,24(sp)
    119c:	6a42                	ld	s4,16(sp)
    119e:	6aa2                	ld	s5,8(sp)
    11a0:	6b02                	ld	s6,0(sp)
    11a2:	6121                	addi	sp,sp,64
    11a4:	8082                	ret
      printf("%s: link should not succeed\n", s);
    11a6:	85da                	mv	a1,s6
    11a8:	00005517          	auipc	a0,0x5
    11ac:	69050513          	addi	a0,a0,1680 # 6838 <malloc+0x868>
    11b0:	00005097          	auipc	ra,0x5
    11b4:	d62080e7          	jalr	-670(ra) # 5f12 <printf>
      exit(1);
    11b8:	4505                	li	a0,1
    11ba:	00005097          	auipc	ra,0x5
    11be:	9b0080e7          	jalr	-1616(ra) # 5b6a <exit>

00000000000011c2 <bigdir>:
{
    11c2:	715d                	addi	sp,sp,-80
    11c4:	e486                	sd	ra,72(sp)
    11c6:	e0a2                	sd	s0,64(sp)
    11c8:	fc26                	sd	s1,56(sp)
    11ca:	f84a                	sd	s2,48(sp)
    11cc:	f44e                	sd	s3,40(sp)
    11ce:	f052                	sd	s4,32(sp)
    11d0:	ec56                	sd	s5,24(sp)
    11d2:	e85a                	sd	s6,16(sp)
    11d4:	0880                	addi	s0,sp,80
    11d6:	89aa                	mv	s3,a0
  unlink("bd");
    11d8:	00005517          	auipc	a0,0x5
    11dc:	68050513          	addi	a0,a0,1664 # 6858 <malloc+0x888>
    11e0:	00005097          	auipc	ra,0x5
    11e4:	9da080e7          	jalr	-1574(ra) # 5bba <unlink>
  fd = open("bd", O_CREATE);
    11e8:	20000593          	li	a1,512
    11ec:	00005517          	auipc	a0,0x5
    11f0:	66c50513          	addi	a0,a0,1644 # 6858 <malloc+0x888>
    11f4:	00005097          	auipc	ra,0x5
    11f8:	9b6080e7          	jalr	-1610(ra) # 5baa <open>
  if (fd < 0)
    11fc:	0c054963          	bltz	a0,12ce <bigdir+0x10c>
  close(fd);
    1200:	00005097          	auipc	ra,0x5
    1204:	992080e7          	jalr	-1646(ra) # 5b92 <close>
  for (i = 0; i < N; i++)
    1208:	4901                	li	s2,0
    name[0] = 'x';
    120a:	07800a93          	li	s5,120
    if (link("bd", name) != 0)
    120e:	00005a17          	auipc	s4,0x5
    1212:	64aa0a13          	addi	s4,s4,1610 # 6858 <malloc+0x888>
  for (i = 0; i < N; i++)
    1216:	1f400b13          	li	s6,500
    name[0] = 'x';
    121a:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    121e:	41f9579b          	sraiw	a5,s2,0x1f
    1222:	01a7d71b          	srliw	a4,a5,0x1a
    1226:	012707bb          	addw	a5,a4,s2
    122a:	4067d69b          	sraiw	a3,a5,0x6
    122e:	0306869b          	addiw	a3,a3,48
    1232:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1236:	03f7f793          	andi	a5,a5,63
    123a:	9f99                	subw	a5,a5,a4
    123c:	0307879b          	addiw	a5,a5,48
    1240:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1244:	fa0409a3          	sb	zero,-77(s0)
    if (link("bd", name) != 0)
    1248:	fb040593          	addi	a1,s0,-80
    124c:	8552                	mv	a0,s4
    124e:	00005097          	auipc	ra,0x5
    1252:	97c080e7          	jalr	-1668(ra) # 5bca <link>
    1256:	84aa                	mv	s1,a0
    1258:	e949                	bnez	a0,12ea <bigdir+0x128>
  for (i = 0; i < N; i++)
    125a:	2905                	addiw	s2,s2,1
    125c:	fb691fe3          	bne	s2,s6,121a <bigdir+0x58>
  unlink("bd");
    1260:	00005517          	auipc	a0,0x5
    1264:	5f850513          	addi	a0,a0,1528 # 6858 <malloc+0x888>
    1268:	00005097          	auipc	ra,0x5
    126c:	952080e7          	jalr	-1710(ra) # 5bba <unlink>
    name[0] = 'x';
    1270:	07800913          	li	s2,120
  for (i = 0; i < N; i++)
    1274:	1f400a13          	li	s4,500
    name[0] = 'x';
    1278:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    127c:	41f4d79b          	sraiw	a5,s1,0x1f
    1280:	01a7d71b          	srliw	a4,a5,0x1a
    1284:	009707bb          	addw	a5,a4,s1
    1288:	4067d69b          	sraiw	a3,a5,0x6
    128c:	0306869b          	addiw	a3,a3,48
    1290:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1294:	03f7f793          	andi	a5,a5,63
    1298:	9f99                	subw	a5,a5,a4
    129a:	0307879b          	addiw	a5,a5,48
    129e:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    12a2:	fa0409a3          	sb	zero,-77(s0)
    if (unlink(name) != 0)
    12a6:	fb040513          	addi	a0,s0,-80
    12aa:	00005097          	auipc	ra,0x5
    12ae:	910080e7          	jalr	-1776(ra) # 5bba <unlink>
    12b2:	ed21                	bnez	a0,130a <bigdir+0x148>
  for (i = 0; i < N; i++)
    12b4:	2485                	addiw	s1,s1,1
    12b6:	fd4491e3          	bne	s1,s4,1278 <bigdir+0xb6>
}
    12ba:	60a6                	ld	ra,72(sp)
    12bc:	6406                	ld	s0,64(sp)
    12be:	74e2                	ld	s1,56(sp)
    12c0:	7942                	ld	s2,48(sp)
    12c2:	79a2                	ld	s3,40(sp)
    12c4:	7a02                	ld	s4,32(sp)
    12c6:	6ae2                	ld	s5,24(sp)
    12c8:	6b42                	ld	s6,16(sp)
    12ca:	6161                	addi	sp,sp,80
    12cc:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    12ce:	85ce                	mv	a1,s3
    12d0:	00005517          	auipc	a0,0x5
    12d4:	59050513          	addi	a0,a0,1424 # 6860 <malloc+0x890>
    12d8:	00005097          	auipc	ra,0x5
    12dc:	c3a080e7          	jalr	-966(ra) # 5f12 <printf>
    exit(1);
    12e0:	4505                	li	a0,1
    12e2:	00005097          	auipc	ra,0x5
    12e6:	888080e7          	jalr	-1912(ra) # 5b6a <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    12ea:	fb040613          	addi	a2,s0,-80
    12ee:	85ce                	mv	a1,s3
    12f0:	00005517          	auipc	a0,0x5
    12f4:	59050513          	addi	a0,a0,1424 # 6880 <malloc+0x8b0>
    12f8:	00005097          	auipc	ra,0x5
    12fc:	c1a080e7          	jalr	-998(ra) # 5f12 <printf>
      exit(1);
    1300:	4505                	li	a0,1
    1302:	00005097          	auipc	ra,0x5
    1306:	868080e7          	jalr	-1944(ra) # 5b6a <exit>
      printf("%s: bigdir unlink failed", s);
    130a:	85ce                	mv	a1,s3
    130c:	00005517          	auipc	a0,0x5
    1310:	59450513          	addi	a0,a0,1428 # 68a0 <malloc+0x8d0>
    1314:	00005097          	auipc	ra,0x5
    1318:	bfe080e7          	jalr	-1026(ra) # 5f12 <printf>
      exit(1);
    131c:	4505                	li	a0,1
    131e:	00005097          	auipc	ra,0x5
    1322:	84c080e7          	jalr	-1972(ra) # 5b6a <exit>

0000000000001326 <pgbug>:
{
    1326:	7179                	addi	sp,sp,-48
    1328:	f406                	sd	ra,40(sp)
    132a:	f022                	sd	s0,32(sp)
    132c:	ec26                	sd	s1,24(sp)
    132e:	1800                	addi	s0,sp,48
  argv[0] = 0;
    1330:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1334:	00008497          	auipc	s1,0x8
    1338:	ccc48493          	addi	s1,s1,-820 # 9000 <big>
    133c:	fd840593          	addi	a1,s0,-40
    1340:	6088                	ld	a0,0(s1)
    1342:	00005097          	auipc	ra,0x5
    1346:	860080e7          	jalr	-1952(ra) # 5ba2 <exec>
  pipe(big);
    134a:	6088                	ld	a0,0(s1)
    134c:	00005097          	auipc	ra,0x5
    1350:	82e080e7          	jalr	-2002(ra) # 5b7a <pipe>
  exit(0);
    1354:	4501                	li	a0,0
    1356:	00005097          	auipc	ra,0x5
    135a:	814080e7          	jalr	-2028(ra) # 5b6a <exit>

000000000000135e <badarg>:
{
    135e:	7139                	addi	sp,sp,-64
    1360:	fc06                	sd	ra,56(sp)
    1362:	f822                	sd	s0,48(sp)
    1364:	f426                	sd	s1,40(sp)
    1366:	f04a                	sd	s2,32(sp)
    1368:	ec4e                	sd	s3,24(sp)
    136a:	0080                	addi	s0,sp,64
    136c:	64b1                	lui	s1,0xc
    136e:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1de8>
    argv[0] = (char *)0xffffffff;
    1372:	597d                	li	s2,-1
    1374:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    1378:	00005997          	auipc	s3,0x5
    137c:	da098993          	addi	s3,s3,-608 # 6118 <malloc+0x148>
    argv[0] = (char *)0xffffffff;
    1380:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1384:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1388:	fc040593          	addi	a1,s0,-64
    138c:	854e                	mv	a0,s3
    138e:	00005097          	auipc	ra,0x5
    1392:	814080e7          	jalr	-2028(ra) # 5ba2 <exec>
  for (int i = 0; i < 50000; i++)
    1396:	34fd                	addiw	s1,s1,-1
    1398:	f4e5                	bnez	s1,1380 <badarg+0x22>
  exit(0);
    139a:	4501                	li	a0,0
    139c:	00004097          	auipc	ra,0x4
    13a0:	7ce080e7          	jalr	1998(ra) # 5b6a <exit>

00000000000013a4 <copyinstr2>:
{
    13a4:	7155                	addi	sp,sp,-208
    13a6:	e586                	sd	ra,200(sp)
    13a8:	e1a2                	sd	s0,192(sp)
    13aa:	0980                	addi	s0,sp,208
  for (int i = 0; i < MAXPATH; i++)
    13ac:	f6840793          	addi	a5,s0,-152
    13b0:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    13b4:	07800713          	li	a4,120
    13b8:	00e78023          	sb	a4,0(a5)
  for (int i = 0; i < MAXPATH; i++)
    13bc:	0785                	addi	a5,a5,1
    13be:	fed79de3          	bne	a5,a3,13b8 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    13c2:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    13c6:	f6840513          	addi	a0,s0,-152
    13ca:	00004097          	auipc	ra,0x4
    13ce:	7f0080e7          	jalr	2032(ra) # 5bba <unlink>
  if (ret != -1)
    13d2:	57fd                	li	a5,-1
    13d4:	0ef51063          	bne	a0,a5,14b4 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    13d8:	20100593          	li	a1,513
    13dc:	f6840513          	addi	a0,s0,-152
    13e0:	00004097          	auipc	ra,0x4
    13e4:	7ca080e7          	jalr	1994(ra) # 5baa <open>
  if (fd != -1)
    13e8:	57fd                	li	a5,-1
    13ea:	0ef51563          	bne	a0,a5,14d4 <copyinstr2+0x130>
  ret = link(b, b);
    13ee:	f6840593          	addi	a1,s0,-152
    13f2:	852e                	mv	a0,a1
    13f4:	00004097          	auipc	ra,0x4
    13f8:	7d6080e7          	jalr	2006(ra) # 5bca <link>
  if (ret != -1)
    13fc:	57fd                	li	a5,-1
    13fe:	0ef51b63          	bne	a0,a5,14f4 <copyinstr2+0x150>
  char *args[] = {"xx", 0};
    1402:	00006797          	auipc	a5,0x6
    1406:	6f678793          	addi	a5,a5,1782 # 7af8 <malloc+0x1b28>
    140a:	f4f43c23          	sd	a5,-168(s0)
    140e:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1412:	f5840593          	addi	a1,s0,-168
    1416:	f6840513          	addi	a0,s0,-152
    141a:	00004097          	auipc	ra,0x4
    141e:	788080e7          	jalr	1928(ra) # 5ba2 <exec>
  if (ret != -1)
    1422:	57fd                	li	a5,-1
    1424:	0ef51963          	bne	a0,a5,1516 <copyinstr2+0x172>
  int pid = fork();
    1428:	00004097          	auipc	ra,0x4
    142c:	73a080e7          	jalr	1850(ra) # 5b62 <fork>
  if (pid < 0)
    1430:	10054363          	bltz	a0,1536 <copyinstr2+0x192>
  if (pid == 0)
    1434:	12051463          	bnez	a0,155c <copyinstr2+0x1b8>
    1438:	00008797          	auipc	a5,0x8
    143c:	12878793          	addi	a5,a5,296 # 9560 <big.0>
    1440:	00009697          	auipc	a3,0x9
    1444:	12068693          	addi	a3,a3,288 # a560 <big.0+0x1000>
      big[i] = 'x';
    1448:	07800713          	li	a4,120
    144c:	00e78023          	sb	a4,0(a5)
    for (int i = 0; i < PGSIZE; i++)
    1450:	0785                	addi	a5,a5,1
    1452:	fed79de3          	bne	a5,a3,144c <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1456:	00009797          	auipc	a5,0x9
    145a:	10078523          	sb	zero,266(a5) # a560 <big.0+0x1000>
    char *args2[] = {big, big, big, 0};
    145e:	00007797          	auipc	a5,0x7
    1462:	0ba78793          	addi	a5,a5,186 # 8518 <malloc+0x2548>
    1466:	6390                	ld	a2,0(a5)
    1468:	6794                	ld	a3,8(a5)
    146a:	6b98                	ld	a4,16(a5)
    146c:	6f9c                	ld	a5,24(a5)
    146e:	f2c43823          	sd	a2,-208(s0)
    1472:	f2d43c23          	sd	a3,-200(s0)
    1476:	f4e43023          	sd	a4,-192(s0)
    147a:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    147e:	f3040593          	addi	a1,s0,-208
    1482:	00005517          	auipc	a0,0x5
    1486:	c9650513          	addi	a0,a0,-874 # 6118 <malloc+0x148>
    148a:	00004097          	auipc	ra,0x4
    148e:	718080e7          	jalr	1816(ra) # 5ba2 <exec>
    if (ret != -1)
    1492:	57fd                	li	a5,-1
    1494:	0af50e63          	beq	a0,a5,1550 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1498:	55fd                	li	a1,-1
    149a:	00005517          	auipc	a0,0x5
    149e:	4ae50513          	addi	a0,a0,1198 # 6948 <malloc+0x978>
    14a2:	00005097          	auipc	ra,0x5
    14a6:	a70080e7          	jalr	-1424(ra) # 5f12 <printf>
      exit(1);
    14aa:	4505                	li	a0,1
    14ac:	00004097          	auipc	ra,0x4
    14b0:	6be080e7          	jalr	1726(ra) # 5b6a <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    14b4:	862a                	mv	a2,a0
    14b6:	f6840593          	addi	a1,s0,-152
    14ba:	00005517          	auipc	a0,0x5
    14be:	40650513          	addi	a0,a0,1030 # 68c0 <malloc+0x8f0>
    14c2:	00005097          	auipc	ra,0x5
    14c6:	a50080e7          	jalr	-1456(ra) # 5f12 <printf>
    exit(1);
    14ca:	4505                	li	a0,1
    14cc:	00004097          	auipc	ra,0x4
    14d0:	69e080e7          	jalr	1694(ra) # 5b6a <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    14d4:	862a                	mv	a2,a0
    14d6:	f6840593          	addi	a1,s0,-152
    14da:	00005517          	auipc	a0,0x5
    14de:	40650513          	addi	a0,a0,1030 # 68e0 <malloc+0x910>
    14e2:	00005097          	auipc	ra,0x5
    14e6:	a30080e7          	jalr	-1488(ra) # 5f12 <printf>
    exit(1);
    14ea:	4505                	li	a0,1
    14ec:	00004097          	auipc	ra,0x4
    14f0:	67e080e7          	jalr	1662(ra) # 5b6a <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    14f4:	86aa                	mv	a3,a0
    14f6:	f6840613          	addi	a2,s0,-152
    14fa:	85b2                	mv	a1,a2
    14fc:	00005517          	auipc	a0,0x5
    1500:	40450513          	addi	a0,a0,1028 # 6900 <malloc+0x930>
    1504:	00005097          	auipc	ra,0x5
    1508:	a0e080e7          	jalr	-1522(ra) # 5f12 <printf>
    exit(1);
    150c:	4505                	li	a0,1
    150e:	00004097          	auipc	ra,0x4
    1512:	65c080e7          	jalr	1628(ra) # 5b6a <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1516:	567d                	li	a2,-1
    1518:	f6840593          	addi	a1,s0,-152
    151c:	00005517          	auipc	a0,0x5
    1520:	40c50513          	addi	a0,a0,1036 # 6928 <malloc+0x958>
    1524:	00005097          	auipc	ra,0x5
    1528:	9ee080e7          	jalr	-1554(ra) # 5f12 <printf>
    exit(1);
    152c:	4505                	li	a0,1
    152e:	00004097          	auipc	ra,0x4
    1532:	63c080e7          	jalr	1596(ra) # 5b6a <exit>
    printf("fork failed\n");
    1536:	00006517          	auipc	a0,0x6
    153a:	87250513          	addi	a0,a0,-1934 # 6da8 <malloc+0xdd8>
    153e:	00005097          	auipc	ra,0x5
    1542:	9d4080e7          	jalr	-1580(ra) # 5f12 <printf>
    exit(1);
    1546:	4505                	li	a0,1
    1548:	00004097          	auipc	ra,0x4
    154c:	622080e7          	jalr	1570(ra) # 5b6a <exit>
    exit(747); // OK
    1550:	2eb00513          	li	a0,747
    1554:	00004097          	auipc	ra,0x4
    1558:	616080e7          	jalr	1558(ra) # 5b6a <exit>
  int st = 0;
    155c:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1560:	f5440513          	addi	a0,s0,-172
    1564:	00004097          	auipc	ra,0x4
    1568:	60e080e7          	jalr	1550(ra) # 5b72 <wait>
  if (st != 747)
    156c:	f5442703          	lw	a4,-172(s0)
    1570:	2eb00793          	li	a5,747
    1574:	00f71663          	bne	a4,a5,1580 <copyinstr2+0x1dc>
}
    1578:	60ae                	ld	ra,200(sp)
    157a:	640e                	ld	s0,192(sp)
    157c:	6169                	addi	sp,sp,208
    157e:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1580:	00005517          	auipc	a0,0x5
    1584:	3f050513          	addi	a0,a0,1008 # 6970 <malloc+0x9a0>
    1588:	00005097          	auipc	ra,0x5
    158c:	98a080e7          	jalr	-1654(ra) # 5f12 <printf>
    exit(1);
    1590:	4505                	li	a0,1
    1592:	00004097          	auipc	ra,0x4
    1596:	5d8080e7          	jalr	1496(ra) # 5b6a <exit>

000000000000159a <truncate3>:
{
    159a:	7159                	addi	sp,sp,-112
    159c:	f486                	sd	ra,104(sp)
    159e:	f0a2                	sd	s0,96(sp)
    15a0:	eca6                	sd	s1,88(sp)
    15a2:	e8ca                	sd	s2,80(sp)
    15a4:	e4ce                	sd	s3,72(sp)
    15a6:	e0d2                	sd	s4,64(sp)
    15a8:	fc56                	sd	s5,56(sp)
    15aa:	1880                	addi	s0,sp,112
    15ac:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE | O_TRUNC | O_WRONLY));
    15ae:	60100593          	li	a1,1537
    15b2:	00005517          	auipc	a0,0x5
    15b6:	bbe50513          	addi	a0,a0,-1090 # 6170 <malloc+0x1a0>
    15ba:	00004097          	auipc	ra,0x4
    15be:	5f0080e7          	jalr	1520(ra) # 5baa <open>
    15c2:	00004097          	auipc	ra,0x4
    15c6:	5d0080e7          	jalr	1488(ra) # 5b92 <close>
  pid = fork();
    15ca:	00004097          	auipc	ra,0x4
    15ce:	598080e7          	jalr	1432(ra) # 5b62 <fork>
  if (pid < 0)
    15d2:	08054063          	bltz	a0,1652 <truncate3+0xb8>
  if (pid == 0)
    15d6:	e969                	bnez	a0,16a8 <truncate3+0x10e>
    15d8:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    15dc:	00005a17          	auipc	s4,0x5
    15e0:	b94a0a13          	addi	s4,s4,-1132 # 6170 <malloc+0x1a0>
      int n = write(fd, "1234567890", 10);
    15e4:	00005a97          	auipc	s5,0x5
    15e8:	3eca8a93          	addi	s5,s5,1004 # 69d0 <malloc+0xa00>
      int fd = open("truncfile", O_WRONLY);
    15ec:	4585                	li	a1,1
    15ee:	8552                	mv	a0,s4
    15f0:	00004097          	auipc	ra,0x4
    15f4:	5ba080e7          	jalr	1466(ra) # 5baa <open>
    15f8:	84aa                	mv	s1,a0
      if (fd < 0)
    15fa:	06054a63          	bltz	a0,166e <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    15fe:	4629                	li	a2,10
    1600:	85d6                	mv	a1,s5
    1602:	00004097          	auipc	ra,0x4
    1606:	588080e7          	jalr	1416(ra) # 5b8a <write>
      if (n != 10)
    160a:	47a9                	li	a5,10
    160c:	06f51f63          	bne	a0,a5,168a <truncate3+0xf0>
      close(fd);
    1610:	8526                	mv	a0,s1
    1612:	00004097          	auipc	ra,0x4
    1616:	580080e7          	jalr	1408(ra) # 5b92 <close>
      fd = open("truncfile", O_RDONLY);
    161a:	4581                	li	a1,0
    161c:	8552                	mv	a0,s4
    161e:	00004097          	auipc	ra,0x4
    1622:	58c080e7          	jalr	1420(ra) # 5baa <open>
    1626:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1628:	02000613          	li	a2,32
    162c:	f9840593          	addi	a1,s0,-104
    1630:	00004097          	auipc	ra,0x4
    1634:	552080e7          	jalr	1362(ra) # 5b82 <read>
      close(fd);
    1638:	8526                	mv	a0,s1
    163a:	00004097          	auipc	ra,0x4
    163e:	558080e7          	jalr	1368(ra) # 5b92 <close>
    for (int i = 0; i < 100; i++)
    1642:	39fd                	addiw	s3,s3,-1
    1644:	fa0994e3          	bnez	s3,15ec <truncate3+0x52>
    exit(0);
    1648:	4501                	li	a0,0
    164a:	00004097          	auipc	ra,0x4
    164e:	520080e7          	jalr	1312(ra) # 5b6a <exit>
    printf("%s: fork failed\n", s);
    1652:	85ca                	mv	a1,s2
    1654:	00005517          	auipc	a0,0x5
    1658:	34c50513          	addi	a0,a0,844 # 69a0 <malloc+0x9d0>
    165c:	00005097          	auipc	ra,0x5
    1660:	8b6080e7          	jalr	-1866(ra) # 5f12 <printf>
    exit(1);
    1664:	4505                	li	a0,1
    1666:	00004097          	auipc	ra,0x4
    166a:	504080e7          	jalr	1284(ra) # 5b6a <exit>
        printf("%s: open failed\n", s);
    166e:	85ca                	mv	a1,s2
    1670:	00005517          	auipc	a0,0x5
    1674:	34850513          	addi	a0,a0,840 # 69b8 <malloc+0x9e8>
    1678:	00005097          	auipc	ra,0x5
    167c:	89a080e7          	jalr	-1894(ra) # 5f12 <printf>
        exit(1);
    1680:	4505                	li	a0,1
    1682:	00004097          	auipc	ra,0x4
    1686:	4e8080e7          	jalr	1256(ra) # 5b6a <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    168a:	862a                	mv	a2,a0
    168c:	85ca                	mv	a1,s2
    168e:	00005517          	auipc	a0,0x5
    1692:	35250513          	addi	a0,a0,850 # 69e0 <malloc+0xa10>
    1696:	00005097          	auipc	ra,0x5
    169a:	87c080e7          	jalr	-1924(ra) # 5f12 <printf>
        exit(1);
    169e:	4505                	li	a0,1
    16a0:	00004097          	auipc	ra,0x4
    16a4:	4ca080e7          	jalr	1226(ra) # 5b6a <exit>
    16a8:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    16ac:	00005a17          	auipc	s4,0x5
    16b0:	ac4a0a13          	addi	s4,s4,-1340 # 6170 <malloc+0x1a0>
    int n = write(fd, "xxx", 3);
    16b4:	00005a97          	auipc	s5,0x5
    16b8:	34ca8a93          	addi	s5,s5,844 # 6a00 <malloc+0xa30>
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    16bc:	60100593          	li	a1,1537
    16c0:	8552                	mv	a0,s4
    16c2:	00004097          	auipc	ra,0x4
    16c6:	4e8080e7          	jalr	1256(ra) # 5baa <open>
    16ca:	84aa                	mv	s1,a0
    if (fd < 0)
    16cc:	04054763          	bltz	a0,171a <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    16d0:	460d                	li	a2,3
    16d2:	85d6                	mv	a1,s5
    16d4:	00004097          	auipc	ra,0x4
    16d8:	4b6080e7          	jalr	1206(ra) # 5b8a <write>
    if (n != 3)
    16dc:	478d                	li	a5,3
    16de:	04f51c63          	bne	a0,a5,1736 <truncate3+0x19c>
    close(fd);
    16e2:	8526                	mv	a0,s1
    16e4:	00004097          	auipc	ra,0x4
    16e8:	4ae080e7          	jalr	1198(ra) # 5b92 <close>
  for (int i = 0; i < 150; i++)
    16ec:	39fd                	addiw	s3,s3,-1
    16ee:	fc0997e3          	bnez	s3,16bc <truncate3+0x122>
  wait(&xstatus);
    16f2:	fbc40513          	addi	a0,s0,-68
    16f6:	00004097          	auipc	ra,0x4
    16fa:	47c080e7          	jalr	1148(ra) # 5b72 <wait>
  unlink("truncfile");
    16fe:	00005517          	auipc	a0,0x5
    1702:	a7250513          	addi	a0,a0,-1422 # 6170 <malloc+0x1a0>
    1706:	00004097          	auipc	ra,0x4
    170a:	4b4080e7          	jalr	1204(ra) # 5bba <unlink>
  exit(xstatus);
    170e:	fbc42503          	lw	a0,-68(s0)
    1712:	00004097          	auipc	ra,0x4
    1716:	458080e7          	jalr	1112(ra) # 5b6a <exit>
      printf("%s: open failed\n", s);
    171a:	85ca                	mv	a1,s2
    171c:	00005517          	auipc	a0,0x5
    1720:	29c50513          	addi	a0,a0,668 # 69b8 <malloc+0x9e8>
    1724:	00004097          	auipc	ra,0x4
    1728:	7ee080e7          	jalr	2030(ra) # 5f12 <printf>
      exit(1);
    172c:	4505                	li	a0,1
    172e:	00004097          	auipc	ra,0x4
    1732:	43c080e7          	jalr	1084(ra) # 5b6a <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1736:	862a                	mv	a2,a0
    1738:	85ca                	mv	a1,s2
    173a:	00005517          	auipc	a0,0x5
    173e:	2ce50513          	addi	a0,a0,718 # 6a08 <malloc+0xa38>
    1742:	00004097          	auipc	ra,0x4
    1746:	7d0080e7          	jalr	2000(ra) # 5f12 <printf>
      exit(1);
    174a:	4505                	li	a0,1
    174c:	00004097          	auipc	ra,0x4
    1750:	41e080e7          	jalr	1054(ra) # 5b6a <exit>

0000000000001754 <exectest>:
{
    1754:	715d                	addi	sp,sp,-80
    1756:	e486                	sd	ra,72(sp)
    1758:	e0a2                	sd	s0,64(sp)
    175a:	fc26                	sd	s1,56(sp)
    175c:	f84a                	sd	s2,48(sp)
    175e:	0880                	addi	s0,sp,80
    1760:	892a                	mv	s2,a0
  char *echoargv[] = {"echo", "OK", 0};
    1762:	00005797          	auipc	a5,0x5
    1766:	9b678793          	addi	a5,a5,-1610 # 6118 <malloc+0x148>
    176a:	fcf43023          	sd	a5,-64(s0)
    176e:	00005797          	auipc	a5,0x5
    1772:	2ba78793          	addi	a5,a5,698 # 6a28 <malloc+0xa58>
    1776:	fcf43423          	sd	a5,-56(s0)
    177a:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    177e:	00005517          	auipc	a0,0x5
    1782:	2b250513          	addi	a0,a0,690 # 6a30 <malloc+0xa60>
    1786:	00004097          	auipc	ra,0x4
    178a:	434080e7          	jalr	1076(ra) # 5bba <unlink>
  pid = fork();
    178e:	00004097          	auipc	ra,0x4
    1792:	3d4080e7          	jalr	980(ra) # 5b62 <fork>
  if (pid < 0)
    1796:	04054663          	bltz	a0,17e2 <exectest+0x8e>
    179a:	84aa                	mv	s1,a0
  if (pid == 0)
    179c:	e959                	bnez	a0,1832 <exectest+0xde>
    close(1);
    179e:	4505                	li	a0,1
    17a0:	00004097          	auipc	ra,0x4
    17a4:	3f2080e7          	jalr	1010(ra) # 5b92 <close>
    fd = open("echo-ok", O_CREATE | O_WRONLY);
    17a8:	20100593          	li	a1,513
    17ac:	00005517          	auipc	a0,0x5
    17b0:	28450513          	addi	a0,a0,644 # 6a30 <malloc+0xa60>
    17b4:	00004097          	auipc	ra,0x4
    17b8:	3f6080e7          	jalr	1014(ra) # 5baa <open>
    if (fd < 0)
    17bc:	04054163          	bltz	a0,17fe <exectest+0xaa>
    if (fd != 1)
    17c0:	4785                	li	a5,1
    17c2:	04f50c63          	beq	a0,a5,181a <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    17c6:	85ca                	mv	a1,s2
    17c8:	00005517          	auipc	a0,0x5
    17cc:	28850513          	addi	a0,a0,648 # 6a50 <malloc+0xa80>
    17d0:	00004097          	auipc	ra,0x4
    17d4:	742080e7          	jalr	1858(ra) # 5f12 <printf>
      exit(1);
    17d8:	4505                	li	a0,1
    17da:	00004097          	auipc	ra,0x4
    17de:	390080e7          	jalr	912(ra) # 5b6a <exit>
    printf("%s: fork failed\n", s);
    17e2:	85ca                	mv	a1,s2
    17e4:	00005517          	auipc	a0,0x5
    17e8:	1bc50513          	addi	a0,a0,444 # 69a0 <malloc+0x9d0>
    17ec:	00004097          	auipc	ra,0x4
    17f0:	726080e7          	jalr	1830(ra) # 5f12 <printf>
    exit(1);
    17f4:	4505                	li	a0,1
    17f6:	00004097          	auipc	ra,0x4
    17fa:	374080e7          	jalr	884(ra) # 5b6a <exit>
      printf("%s: create failed\n", s);
    17fe:	85ca                	mv	a1,s2
    1800:	00005517          	auipc	a0,0x5
    1804:	23850513          	addi	a0,a0,568 # 6a38 <malloc+0xa68>
    1808:	00004097          	auipc	ra,0x4
    180c:	70a080e7          	jalr	1802(ra) # 5f12 <printf>
      exit(1);
    1810:	4505                	li	a0,1
    1812:	00004097          	auipc	ra,0x4
    1816:	358080e7          	jalr	856(ra) # 5b6a <exit>
    if (exec("echo", echoargv) < 0)
    181a:	fc040593          	addi	a1,s0,-64
    181e:	00005517          	auipc	a0,0x5
    1822:	8fa50513          	addi	a0,a0,-1798 # 6118 <malloc+0x148>
    1826:	00004097          	auipc	ra,0x4
    182a:	37c080e7          	jalr	892(ra) # 5ba2 <exec>
    182e:	02054163          	bltz	a0,1850 <exectest+0xfc>
  if (wait(&xstatus) != pid)
    1832:	fdc40513          	addi	a0,s0,-36
    1836:	00004097          	auipc	ra,0x4
    183a:	33c080e7          	jalr	828(ra) # 5b72 <wait>
    183e:	02951763          	bne	a0,s1,186c <exectest+0x118>
  if (xstatus != 0)
    1842:	fdc42503          	lw	a0,-36(s0)
    1846:	cd0d                	beqz	a0,1880 <exectest+0x12c>
    exit(xstatus);
    1848:	00004097          	auipc	ra,0x4
    184c:	322080e7          	jalr	802(ra) # 5b6a <exit>
      printf("%s: exec echo failed\n", s);
    1850:	85ca                	mv	a1,s2
    1852:	00005517          	auipc	a0,0x5
    1856:	20e50513          	addi	a0,a0,526 # 6a60 <malloc+0xa90>
    185a:	00004097          	auipc	ra,0x4
    185e:	6b8080e7          	jalr	1720(ra) # 5f12 <printf>
      exit(1);
    1862:	4505                	li	a0,1
    1864:	00004097          	auipc	ra,0x4
    1868:	306080e7          	jalr	774(ra) # 5b6a <exit>
    printf("%s: wait failed!\n", s);
    186c:	85ca                	mv	a1,s2
    186e:	00005517          	auipc	a0,0x5
    1872:	20a50513          	addi	a0,a0,522 # 6a78 <malloc+0xaa8>
    1876:	00004097          	auipc	ra,0x4
    187a:	69c080e7          	jalr	1692(ra) # 5f12 <printf>
    187e:	b7d1                	j	1842 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    1880:	4581                	li	a1,0
    1882:	00005517          	auipc	a0,0x5
    1886:	1ae50513          	addi	a0,a0,430 # 6a30 <malloc+0xa60>
    188a:	00004097          	auipc	ra,0x4
    188e:	320080e7          	jalr	800(ra) # 5baa <open>
  if (fd < 0)
    1892:	02054a63          	bltz	a0,18c6 <exectest+0x172>
  if (read(fd, buf, 2) != 2)
    1896:	4609                	li	a2,2
    1898:	fb840593          	addi	a1,s0,-72
    189c:	00004097          	auipc	ra,0x4
    18a0:	2e6080e7          	jalr	742(ra) # 5b82 <read>
    18a4:	4789                	li	a5,2
    18a6:	02f50e63          	beq	a0,a5,18e2 <exectest+0x18e>
    printf("%s: read failed\n", s);
    18aa:	85ca                	mv	a1,s2
    18ac:	00005517          	auipc	a0,0x5
    18b0:	c3c50513          	addi	a0,a0,-964 # 64e8 <malloc+0x518>
    18b4:	00004097          	auipc	ra,0x4
    18b8:	65e080e7          	jalr	1630(ra) # 5f12 <printf>
    exit(1);
    18bc:	4505                	li	a0,1
    18be:	00004097          	auipc	ra,0x4
    18c2:	2ac080e7          	jalr	684(ra) # 5b6a <exit>
    printf("%s: open failed\n", s);
    18c6:	85ca                	mv	a1,s2
    18c8:	00005517          	auipc	a0,0x5
    18cc:	0f050513          	addi	a0,a0,240 # 69b8 <malloc+0x9e8>
    18d0:	00004097          	auipc	ra,0x4
    18d4:	642080e7          	jalr	1602(ra) # 5f12 <printf>
    exit(1);
    18d8:	4505                	li	a0,1
    18da:	00004097          	auipc	ra,0x4
    18de:	290080e7          	jalr	656(ra) # 5b6a <exit>
  unlink("echo-ok");
    18e2:	00005517          	auipc	a0,0x5
    18e6:	14e50513          	addi	a0,a0,334 # 6a30 <malloc+0xa60>
    18ea:	00004097          	auipc	ra,0x4
    18ee:	2d0080e7          	jalr	720(ra) # 5bba <unlink>
  if (buf[0] == 'O' && buf[1] == 'K')
    18f2:	fb844703          	lbu	a4,-72(s0)
    18f6:	04f00793          	li	a5,79
    18fa:	00f71863          	bne	a4,a5,190a <exectest+0x1b6>
    18fe:	fb944703          	lbu	a4,-71(s0)
    1902:	04b00793          	li	a5,75
    1906:	02f70063          	beq	a4,a5,1926 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    190a:	85ca                	mv	a1,s2
    190c:	00005517          	auipc	a0,0x5
    1910:	18450513          	addi	a0,a0,388 # 6a90 <malloc+0xac0>
    1914:	00004097          	auipc	ra,0x4
    1918:	5fe080e7          	jalr	1534(ra) # 5f12 <printf>
    exit(1);
    191c:	4505                	li	a0,1
    191e:	00004097          	auipc	ra,0x4
    1922:	24c080e7          	jalr	588(ra) # 5b6a <exit>
    exit(0);
    1926:	4501                	li	a0,0
    1928:	00004097          	auipc	ra,0x4
    192c:	242080e7          	jalr	578(ra) # 5b6a <exit>

0000000000001930 <pipe1>:
{
    1930:	711d                	addi	sp,sp,-96
    1932:	ec86                	sd	ra,88(sp)
    1934:	e8a2                	sd	s0,80(sp)
    1936:	e4a6                	sd	s1,72(sp)
    1938:	e0ca                	sd	s2,64(sp)
    193a:	fc4e                	sd	s3,56(sp)
    193c:	f852                	sd	s4,48(sp)
    193e:	f456                	sd	s5,40(sp)
    1940:	f05a                	sd	s6,32(sp)
    1942:	ec5e                	sd	s7,24(sp)
    1944:	1080                	addi	s0,sp,96
    1946:	892a                	mv	s2,a0
  if (pipe(fds) != 0)
    1948:	fa840513          	addi	a0,s0,-88
    194c:	00004097          	auipc	ra,0x4
    1950:	22e080e7          	jalr	558(ra) # 5b7a <pipe>
    1954:	ed25                	bnez	a0,19cc <pipe1+0x9c>
    1956:	84aa                	mv	s1,a0
  pid = fork();
    1958:	00004097          	auipc	ra,0x4
    195c:	20a080e7          	jalr	522(ra) # 5b62 <fork>
    1960:	8a2a                	mv	s4,a0
  if (pid == 0)
    1962:	c159                	beqz	a0,19e8 <pipe1+0xb8>
  else if (pid > 0)
    1964:	16a05e63          	blez	a0,1ae0 <pipe1+0x1b0>
    close(fds[1]);
    1968:	fac42503          	lw	a0,-84(s0)
    196c:	00004097          	auipc	ra,0x4
    1970:	226080e7          	jalr	550(ra) # 5b92 <close>
    total = 0;
    1974:	8a26                	mv	s4,s1
    cc = 1;
    1976:	4985                	li	s3,1
    while ((n = read(fds[0], buf, cc)) > 0)
    1978:	0000ba97          	auipc	s5,0xb
    197c:	300a8a93          	addi	s5,s5,768 # cc78 <buf>
      if (cc > sizeof(buf))
    1980:	6b0d                	lui	s6,0x3
    while ((n = read(fds[0], buf, cc)) > 0)
    1982:	864e                	mv	a2,s3
    1984:	85d6                	mv	a1,s5
    1986:	fa842503          	lw	a0,-88(s0)
    198a:	00004097          	auipc	ra,0x4
    198e:	1f8080e7          	jalr	504(ra) # 5b82 <read>
    1992:	10a05263          	blez	a0,1a96 <pipe1+0x166>
      for (i = 0; i < n; i++)
    1996:	0000b717          	auipc	a4,0xb
    199a:	2e270713          	addi	a4,a4,738 # cc78 <buf>
    199e:	00a4863b          	addw	a2,s1,a0
        if ((buf[i] & 0xff) != (seq++ & 0xff))
    19a2:	00074683          	lbu	a3,0(a4)
    19a6:	0ff4f793          	andi	a5,s1,255
    19aa:	2485                	addiw	s1,s1,1
    19ac:	0cf69163          	bne	a3,a5,1a6e <pipe1+0x13e>
      for (i = 0; i < n; i++)
    19b0:	0705                	addi	a4,a4,1
    19b2:	fec498e3          	bne	s1,a2,19a2 <pipe1+0x72>
      total += n;
    19b6:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    19ba:	0019979b          	slliw	a5,s3,0x1
    19be:	0007899b          	sext.w	s3,a5
      if (cc > sizeof(buf))
    19c2:	013b7363          	bgeu	s6,s3,19c8 <pipe1+0x98>
        cc = sizeof(buf);
    19c6:	89da                	mv	s3,s6
        if ((buf[i] & 0xff) != (seq++ & 0xff))
    19c8:	84b2                	mv	s1,a2
    19ca:	bf65                	j	1982 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    19cc:	85ca                	mv	a1,s2
    19ce:	00005517          	auipc	a0,0x5
    19d2:	0da50513          	addi	a0,a0,218 # 6aa8 <malloc+0xad8>
    19d6:	00004097          	auipc	ra,0x4
    19da:	53c080e7          	jalr	1340(ra) # 5f12 <printf>
    exit(1);
    19de:	4505                	li	a0,1
    19e0:	00004097          	auipc	ra,0x4
    19e4:	18a080e7          	jalr	394(ra) # 5b6a <exit>
    close(fds[0]);
    19e8:	fa842503          	lw	a0,-88(s0)
    19ec:	00004097          	auipc	ra,0x4
    19f0:	1a6080e7          	jalr	422(ra) # 5b92 <close>
    for (n = 0; n < N; n++)
    19f4:	0000bb17          	auipc	s6,0xb
    19f8:	284b0b13          	addi	s6,s6,644 # cc78 <buf>
    19fc:	416004bb          	negw	s1,s6
    1a00:	0ff4f493          	andi	s1,s1,255
    1a04:	409b0993          	addi	s3,s6,1033
      if (write(fds[1], buf, SZ) != SZ)
    1a08:	8bda                	mv	s7,s6
    for (n = 0; n < N; n++)
    1a0a:	6a85                	lui	s5,0x1
    1a0c:	42da8a93          	addi	s5,s5,1069 # 142d <copyinstr2+0x89>
{
    1a10:	87da                	mv	a5,s6
        buf[i] = seq++;
    1a12:	0097873b          	addw	a4,a5,s1
    1a16:	00e78023          	sb	a4,0(a5)
      for (i = 0; i < SZ; i++)
    1a1a:	0785                	addi	a5,a5,1
    1a1c:	fef99be3          	bne	s3,a5,1a12 <pipe1+0xe2>
        buf[i] = seq++;
    1a20:	409a0a1b          	addiw	s4,s4,1033
      if (write(fds[1], buf, SZ) != SZ)
    1a24:	40900613          	li	a2,1033
    1a28:	85de                	mv	a1,s7
    1a2a:	fac42503          	lw	a0,-84(s0)
    1a2e:	00004097          	auipc	ra,0x4
    1a32:	15c080e7          	jalr	348(ra) # 5b8a <write>
    1a36:	40900793          	li	a5,1033
    1a3a:	00f51c63          	bne	a0,a5,1a52 <pipe1+0x122>
    for (n = 0; n < N; n++)
    1a3e:	24a5                	addiw	s1,s1,9
    1a40:	0ff4f493          	andi	s1,s1,255
    1a44:	fd5a16e3          	bne	s4,s5,1a10 <pipe1+0xe0>
    exit(0);
    1a48:	4501                	li	a0,0
    1a4a:	00004097          	auipc	ra,0x4
    1a4e:	120080e7          	jalr	288(ra) # 5b6a <exit>
        printf("%s: pipe1 oops 1\n", s);
    1a52:	85ca                	mv	a1,s2
    1a54:	00005517          	auipc	a0,0x5
    1a58:	06c50513          	addi	a0,a0,108 # 6ac0 <malloc+0xaf0>
    1a5c:	00004097          	auipc	ra,0x4
    1a60:	4b6080e7          	jalr	1206(ra) # 5f12 <printf>
        exit(1);
    1a64:	4505                	li	a0,1
    1a66:	00004097          	auipc	ra,0x4
    1a6a:	104080e7          	jalr	260(ra) # 5b6a <exit>
          printf("%s: pipe1 oops 2\n", s);
    1a6e:	85ca                	mv	a1,s2
    1a70:	00005517          	auipc	a0,0x5
    1a74:	06850513          	addi	a0,a0,104 # 6ad8 <malloc+0xb08>
    1a78:	00004097          	auipc	ra,0x4
    1a7c:	49a080e7          	jalr	1178(ra) # 5f12 <printf>
}
    1a80:	60e6                	ld	ra,88(sp)
    1a82:	6446                	ld	s0,80(sp)
    1a84:	64a6                	ld	s1,72(sp)
    1a86:	6906                	ld	s2,64(sp)
    1a88:	79e2                	ld	s3,56(sp)
    1a8a:	7a42                	ld	s4,48(sp)
    1a8c:	7aa2                	ld	s5,40(sp)
    1a8e:	7b02                	ld	s6,32(sp)
    1a90:	6be2                	ld	s7,24(sp)
    1a92:	6125                	addi	sp,sp,96
    1a94:	8082                	ret
    if (total != N * SZ)
    1a96:	6785                	lui	a5,0x1
    1a98:	42d78793          	addi	a5,a5,1069 # 142d <copyinstr2+0x89>
    1a9c:	02fa0063          	beq	s4,a5,1abc <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1aa0:	85d2                	mv	a1,s4
    1aa2:	00005517          	auipc	a0,0x5
    1aa6:	04e50513          	addi	a0,a0,78 # 6af0 <malloc+0xb20>
    1aaa:	00004097          	auipc	ra,0x4
    1aae:	468080e7          	jalr	1128(ra) # 5f12 <printf>
      exit(1);
    1ab2:	4505                	li	a0,1
    1ab4:	00004097          	auipc	ra,0x4
    1ab8:	0b6080e7          	jalr	182(ra) # 5b6a <exit>
    close(fds[0]);
    1abc:	fa842503          	lw	a0,-88(s0)
    1ac0:	00004097          	auipc	ra,0x4
    1ac4:	0d2080e7          	jalr	210(ra) # 5b92 <close>
    wait(&xstatus);
    1ac8:	fa440513          	addi	a0,s0,-92
    1acc:	00004097          	auipc	ra,0x4
    1ad0:	0a6080e7          	jalr	166(ra) # 5b72 <wait>
    exit(xstatus);
    1ad4:	fa442503          	lw	a0,-92(s0)
    1ad8:	00004097          	auipc	ra,0x4
    1adc:	092080e7          	jalr	146(ra) # 5b6a <exit>
    printf("%s: fork() failed\n", s);
    1ae0:	85ca                	mv	a1,s2
    1ae2:	00005517          	auipc	a0,0x5
    1ae6:	02e50513          	addi	a0,a0,46 # 6b10 <malloc+0xb40>
    1aea:	00004097          	auipc	ra,0x4
    1aee:	428080e7          	jalr	1064(ra) # 5f12 <printf>
    exit(1);
    1af2:	4505                	li	a0,1
    1af4:	00004097          	auipc	ra,0x4
    1af8:	076080e7          	jalr	118(ra) # 5b6a <exit>

0000000000001afc <exitwait>:
{
    1afc:	7139                	addi	sp,sp,-64
    1afe:	fc06                	sd	ra,56(sp)
    1b00:	f822                	sd	s0,48(sp)
    1b02:	f426                	sd	s1,40(sp)
    1b04:	f04a                	sd	s2,32(sp)
    1b06:	ec4e                	sd	s3,24(sp)
    1b08:	e852                	sd	s4,16(sp)
    1b0a:	0080                	addi	s0,sp,64
    1b0c:	8a2a                	mv	s4,a0
  for (i = 0; i < 100; i++)
    1b0e:	4901                	li	s2,0
    1b10:	06400993          	li	s3,100
    pid = fork();
    1b14:	00004097          	auipc	ra,0x4
    1b18:	04e080e7          	jalr	78(ra) # 5b62 <fork>
    1b1c:	84aa                	mv	s1,a0
    if (pid < 0)
    1b1e:	02054a63          	bltz	a0,1b52 <exitwait+0x56>
    if (pid)
    1b22:	c151                	beqz	a0,1ba6 <exitwait+0xaa>
      if (wait(&xstate) != pid)
    1b24:	fcc40513          	addi	a0,s0,-52
    1b28:	00004097          	auipc	ra,0x4
    1b2c:	04a080e7          	jalr	74(ra) # 5b72 <wait>
    1b30:	02951f63          	bne	a0,s1,1b6e <exitwait+0x72>
      if (i != xstate)
    1b34:	fcc42783          	lw	a5,-52(s0)
    1b38:	05279963          	bne	a5,s2,1b8a <exitwait+0x8e>
  for (i = 0; i < 100; i++)
    1b3c:	2905                	addiw	s2,s2,1
    1b3e:	fd391be3          	bne	s2,s3,1b14 <exitwait+0x18>
}
    1b42:	70e2                	ld	ra,56(sp)
    1b44:	7442                	ld	s0,48(sp)
    1b46:	74a2                	ld	s1,40(sp)
    1b48:	7902                	ld	s2,32(sp)
    1b4a:	69e2                	ld	s3,24(sp)
    1b4c:	6a42                	ld	s4,16(sp)
    1b4e:	6121                	addi	sp,sp,64
    1b50:	8082                	ret
      printf("%s: fork failed\n", s);
    1b52:	85d2                	mv	a1,s4
    1b54:	00005517          	auipc	a0,0x5
    1b58:	e4c50513          	addi	a0,a0,-436 # 69a0 <malloc+0x9d0>
    1b5c:	00004097          	auipc	ra,0x4
    1b60:	3b6080e7          	jalr	950(ra) # 5f12 <printf>
      exit(1);
    1b64:	4505                	li	a0,1
    1b66:	00004097          	auipc	ra,0x4
    1b6a:	004080e7          	jalr	4(ra) # 5b6a <exit>
        printf("%s: wait wrong pid\n", s);
    1b6e:	85d2                	mv	a1,s4
    1b70:	00005517          	auipc	a0,0x5
    1b74:	fb850513          	addi	a0,a0,-72 # 6b28 <malloc+0xb58>
    1b78:	00004097          	auipc	ra,0x4
    1b7c:	39a080e7          	jalr	922(ra) # 5f12 <printf>
        exit(1);
    1b80:	4505                	li	a0,1
    1b82:	00004097          	auipc	ra,0x4
    1b86:	fe8080e7          	jalr	-24(ra) # 5b6a <exit>
        printf("%s: wait wrong exit status\n", s);
    1b8a:	85d2                	mv	a1,s4
    1b8c:	00005517          	auipc	a0,0x5
    1b90:	fb450513          	addi	a0,a0,-76 # 6b40 <malloc+0xb70>
    1b94:	00004097          	auipc	ra,0x4
    1b98:	37e080e7          	jalr	894(ra) # 5f12 <printf>
        exit(1);
    1b9c:	4505                	li	a0,1
    1b9e:	00004097          	auipc	ra,0x4
    1ba2:	fcc080e7          	jalr	-52(ra) # 5b6a <exit>
      exit(i);
    1ba6:	854a                	mv	a0,s2
    1ba8:	00004097          	auipc	ra,0x4
    1bac:	fc2080e7          	jalr	-62(ra) # 5b6a <exit>

0000000000001bb0 <twochildren>:
{
    1bb0:	1101                	addi	sp,sp,-32
    1bb2:	ec06                	sd	ra,24(sp)
    1bb4:	e822                	sd	s0,16(sp)
    1bb6:	e426                	sd	s1,8(sp)
    1bb8:	e04a                	sd	s2,0(sp)
    1bba:	1000                	addi	s0,sp,32
    1bbc:	892a                	mv	s2,a0
    1bbe:	3e800493          	li	s1,1000
    int pid1 = fork();
    1bc2:	00004097          	auipc	ra,0x4
    1bc6:	fa0080e7          	jalr	-96(ra) # 5b62 <fork>
    if (pid1 < 0)
    1bca:	02054c63          	bltz	a0,1c02 <twochildren+0x52>
    if (pid1 == 0)
    1bce:	c921                	beqz	a0,1c1e <twochildren+0x6e>
      int pid2 = fork();
    1bd0:	00004097          	auipc	ra,0x4
    1bd4:	f92080e7          	jalr	-110(ra) # 5b62 <fork>
      if (pid2 < 0)
    1bd8:	04054763          	bltz	a0,1c26 <twochildren+0x76>
      if (pid2 == 0)
    1bdc:	c13d                	beqz	a0,1c42 <twochildren+0x92>
        wait(0);
    1bde:	4501                	li	a0,0
    1be0:	00004097          	auipc	ra,0x4
    1be4:	f92080e7          	jalr	-110(ra) # 5b72 <wait>
        wait(0);
    1be8:	4501                	li	a0,0
    1bea:	00004097          	auipc	ra,0x4
    1bee:	f88080e7          	jalr	-120(ra) # 5b72 <wait>
  for (int i = 0; i < 1000; i++)
    1bf2:	34fd                	addiw	s1,s1,-1
    1bf4:	f4f9                	bnez	s1,1bc2 <twochildren+0x12>
}
    1bf6:	60e2                	ld	ra,24(sp)
    1bf8:	6442                	ld	s0,16(sp)
    1bfa:	64a2                	ld	s1,8(sp)
    1bfc:	6902                	ld	s2,0(sp)
    1bfe:	6105                	addi	sp,sp,32
    1c00:	8082                	ret
      printf("%s: fork failed\n", s);
    1c02:	85ca                	mv	a1,s2
    1c04:	00005517          	auipc	a0,0x5
    1c08:	d9c50513          	addi	a0,a0,-612 # 69a0 <malloc+0x9d0>
    1c0c:	00004097          	auipc	ra,0x4
    1c10:	306080e7          	jalr	774(ra) # 5f12 <printf>
      exit(1);
    1c14:	4505                	li	a0,1
    1c16:	00004097          	auipc	ra,0x4
    1c1a:	f54080e7          	jalr	-172(ra) # 5b6a <exit>
      exit(0);
    1c1e:	00004097          	auipc	ra,0x4
    1c22:	f4c080e7          	jalr	-180(ra) # 5b6a <exit>
        printf("%s: fork failed\n", s);
    1c26:	85ca                	mv	a1,s2
    1c28:	00005517          	auipc	a0,0x5
    1c2c:	d7850513          	addi	a0,a0,-648 # 69a0 <malloc+0x9d0>
    1c30:	00004097          	auipc	ra,0x4
    1c34:	2e2080e7          	jalr	738(ra) # 5f12 <printf>
        exit(1);
    1c38:	4505                	li	a0,1
    1c3a:	00004097          	auipc	ra,0x4
    1c3e:	f30080e7          	jalr	-208(ra) # 5b6a <exit>
        exit(0);
    1c42:	00004097          	auipc	ra,0x4
    1c46:	f28080e7          	jalr	-216(ra) # 5b6a <exit>

0000000000001c4a <forkfork>:
{
    1c4a:	7179                	addi	sp,sp,-48
    1c4c:	f406                	sd	ra,40(sp)
    1c4e:	f022                	sd	s0,32(sp)
    1c50:	ec26                	sd	s1,24(sp)
    1c52:	1800                	addi	s0,sp,48
    1c54:	84aa                	mv	s1,a0
    int pid = fork();
    1c56:	00004097          	auipc	ra,0x4
    1c5a:	f0c080e7          	jalr	-244(ra) # 5b62 <fork>
    if (pid < 0)
    1c5e:	04054163          	bltz	a0,1ca0 <forkfork+0x56>
    if (pid == 0)
    1c62:	cd29                	beqz	a0,1cbc <forkfork+0x72>
    int pid = fork();
    1c64:	00004097          	auipc	ra,0x4
    1c68:	efe080e7          	jalr	-258(ra) # 5b62 <fork>
    if (pid < 0)
    1c6c:	02054a63          	bltz	a0,1ca0 <forkfork+0x56>
    if (pid == 0)
    1c70:	c531                	beqz	a0,1cbc <forkfork+0x72>
    wait(&xstatus);
    1c72:	fdc40513          	addi	a0,s0,-36
    1c76:	00004097          	auipc	ra,0x4
    1c7a:	efc080e7          	jalr	-260(ra) # 5b72 <wait>
    if (xstatus != 0)
    1c7e:	fdc42783          	lw	a5,-36(s0)
    1c82:	ebbd                	bnez	a5,1cf8 <forkfork+0xae>
    wait(&xstatus);
    1c84:	fdc40513          	addi	a0,s0,-36
    1c88:	00004097          	auipc	ra,0x4
    1c8c:	eea080e7          	jalr	-278(ra) # 5b72 <wait>
    if (xstatus != 0)
    1c90:	fdc42783          	lw	a5,-36(s0)
    1c94:	e3b5                	bnez	a5,1cf8 <forkfork+0xae>
}
    1c96:	70a2                	ld	ra,40(sp)
    1c98:	7402                	ld	s0,32(sp)
    1c9a:	64e2                	ld	s1,24(sp)
    1c9c:	6145                	addi	sp,sp,48
    1c9e:	8082                	ret
      printf("%s: fork failed", s);
    1ca0:	85a6                	mv	a1,s1
    1ca2:	00005517          	auipc	a0,0x5
    1ca6:	ebe50513          	addi	a0,a0,-322 # 6b60 <malloc+0xb90>
    1caa:	00004097          	auipc	ra,0x4
    1cae:	268080e7          	jalr	616(ra) # 5f12 <printf>
      exit(1);
    1cb2:	4505                	li	a0,1
    1cb4:	00004097          	auipc	ra,0x4
    1cb8:	eb6080e7          	jalr	-330(ra) # 5b6a <exit>
{
    1cbc:	0c800493          	li	s1,200
        int pid1 = fork();
    1cc0:	00004097          	auipc	ra,0x4
    1cc4:	ea2080e7          	jalr	-350(ra) # 5b62 <fork>
        if (pid1 < 0)
    1cc8:	00054f63          	bltz	a0,1ce6 <forkfork+0x9c>
        if (pid1 == 0)
    1ccc:	c115                	beqz	a0,1cf0 <forkfork+0xa6>
        wait(0);
    1cce:	4501                	li	a0,0
    1cd0:	00004097          	auipc	ra,0x4
    1cd4:	ea2080e7          	jalr	-350(ra) # 5b72 <wait>
      for (int j = 0; j < 200; j++)
    1cd8:	34fd                	addiw	s1,s1,-1
    1cda:	f0fd                	bnez	s1,1cc0 <forkfork+0x76>
      exit(0);
    1cdc:	4501                	li	a0,0
    1cde:	00004097          	auipc	ra,0x4
    1ce2:	e8c080e7          	jalr	-372(ra) # 5b6a <exit>
          exit(1);
    1ce6:	4505                	li	a0,1
    1ce8:	00004097          	auipc	ra,0x4
    1cec:	e82080e7          	jalr	-382(ra) # 5b6a <exit>
          exit(0);
    1cf0:	00004097          	auipc	ra,0x4
    1cf4:	e7a080e7          	jalr	-390(ra) # 5b6a <exit>
      printf("%s: fork in child failed", s);
    1cf8:	85a6                	mv	a1,s1
    1cfa:	00005517          	auipc	a0,0x5
    1cfe:	e7650513          	addi	a0,a0,-394 # 6b70 <malloc+0xba0>
    1d02:	00004097          	auipc	ra,0x4
    1d06:	210080e7          	jalr	528(ra) # 5f12 <printf>
      exit(1);
    1d0a:	4505                	li	a0,1
    1d0c:	00004097          	auipc	ra,0x4
    1d10:	e5e080e7          	jalr	-418(ra) # 5b6a <exit>

0000000000001d14 <reparent2>:
{
    1d14:	1101                	addi	sp,sp,-32
    1d16:	ec06                	sd	ra,24(sp)
    1d18:	e822                	sd	s0,16(sp)
    1d1a:	e426                	sd	s1,8(sp)
    1d1c:	1000                	addi	s0,sp,32
    1d1e:	32000493          	li	s1,800
    int pid1 = fork();
    1d22:	00004097          	auipc	ra,0x4
    1d26:	e40080e7          	jalr	-448(ra) # 5b62 <fork>
    if (pid1 < 0)
    1d2a:	00054f63          	bltz	a0,1d48 <reparent2+0x34>
    if (pid1 == 0)
    1d2e:	c915                	beqz	a0,1d62 <reparent2+0x4e>
    wait(0);
    1d30:	4501                	li	a0,0
    1d32:	00004097          	auipc	ra,0x4
    1d36:	e40080e7          	jalr	-448(ra) # 5b72 <wait>
  for (int i = 0; i < 800; i++)
    1d3a:	34fd                	addiw	s1,s1,-1
    1d3c:	f0fd                	bnez	s1,1d22 <reparent2+0xe>
  exit(0);
    1d3e:	4501                	li	a0,0
    1d40:	00004097          	auipc	ra,0x4
    1d44:	e2a080e7          	jalr	-470(ra) # 5b6a <exit>
      printf("fork failed\n");
    1d48:	00005517          	auipc	a0,0x5
    1d4c:	06050513          	addi	a0,a0,96 # 6da8 <malloc+0xdd8>
    1d50:	00004097          	auipc	ra,0x4
    1d54:	1c2080e7          	jalr	450(ra) # 5f12 <printf>
      exit(1);
    1d58:	4505                	li	a0,1
    1d5a:	00004097          	auipc	ra,0x4
    1d5e:	e10080e7          	jalr	-496(ra) # 5b6a <exit>
      fork();
    1d62:	00004097          	auipc	ra,0x4
    1d66:	e00080e7          	jalr	-512(ra) # 5b62 <fork>
      fork();
    1d6a:	00004097          	auipc	ra,0x4
    1d6e:	df8080e7          	jalr	-520(ra) # 5b62 <fork>
      exit(0);
    1d72:	4501                	li	a0,0
    1d74:	00004097          	auipc	ra,0x4
    1d78:	df6080e7          	jalr	-522(ra) # 5b6a <exit>

0000000000001d7c <createdelete>:
{
    1d7c:	7175                	addi	sp,sp,-144
    1d7e:	e506                	sd	ra,136(sp)
    1d80:	e122                	sd	s0,128(sp)
    1d82:	fca6                	sd	s1,120(sp)
    1d84:	f8ca                	sd	s2,112(sp)
    1d86:	f4ce                	sd	s3,104(sp)
    1d88:	f0d2                	sd	s4,96(sp)
    1d8a:	ecd6                	sd	s5,88(sp)
    1d8c:	e8da                	sd	s6,80(sp)
    1d8e:	e4de                	sd	s7,72(sp)
    1d90:	e0e2                	sd	s8,64(sp)
    1d92:	fc66                	sd	s9,56(sp)
    1d94:	0900                	addi	s0,sp,144
    1d96:	8caa                	mv	s9,a0
  for (pi = 0; pi < NCHILD; pi++)
    1d98:	4901                	li	s2,0
    1d9a:	4991                	li	s3,4
    pid = fork();
    1d9c:	00004097          	auipc	ra,0x4
    1da0:	dc6080e7          	jalr	-570(ra) # 5b62 <fork>
    1da4:	84aa                	mv	s1,a0
    if (pid < 0)
    1da6:	02054f63          	bltz	a0,1de4 <createdelete+0x68>
    if (pid == 0)
    1daa:	c939                	beqz	a0,1e00 <createdelete+0x84>
  for (pi = 0; pi < NCHILD; pi++)
    1dac:	2905                	addiw	s2,s2,1
    1dae:	ff3917e3          	bne	s2,s3,1d9c <createdelete+0x20>
    1db2:	4491                	li	s1,4
    wait(&xstatus);
    1db4:	f7c40513          	addi	a0,s0,-132
    1db8:	00004097          	auipc	ra,0x4
    1dbc:	dba080e7          	jalr	-582(ra) # 5b72 <wait>
    if (xstatus != 0)
    1dc0:	f7c42903          	lw	s2,-132(s0)
    1dc4:	0e091263          	bnez	s2,1ea8 <createdelete+0x12c>
  for (pi = 0; pi < NCHILD; pi++)
    1dc8:	34fd                	addiw	s1,s1,-1
    1dca:	f4ed                	bnez	s1,1db4 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1dcc:	f8040123          	sb	zero,-126(s0)
    1dd0:	03000993          	li	s3,48
    1dd4:	5a7d                	li	s4,-1
    1dd6:	07000c13          	li	s8,112
      else if ((i >= 1 && i < N / 2) && fd >= 0)
    1dda:	4b21                	li	s6,8
      if ((i == 0 || i >= N / 2) && fd < 0)
    1ddc:	4ba5                	li	s7,9
    for (pi = 0; pi < NCHILD; pi++)
    1dde:	07400a93          	li	s5,116
    1de2:	a29d                	j	1f48 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1de4:	85e6                	mv	a1,s9
    1de6:	00005517          	auipc	a0,0x5
    1dea:	fc250513          	addi	a0,a0,-62 # 6da8 <malloc+0xdd8>
    1dee:	00004097          	auipc	ra,0x4
    1df2:	124080e7          	jalr	292(ra) # 5f12 <printf>
      exit(1);
    1df6:	4505                	li	a0,1
    1df8:	00004097          	auipc	ra,0x4
    1dfc:	d72080e7          	jalr	-654(ra) # 5b6a <exit>
      name[0] = 'p' + pi;
    1e00:	0709091b          	addiw	s2,s2,112
    1e04:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1e08:	f8040123          	sb	zero,-126(s0)
      for (i = 0; i < N; i++)
    1e0c:	4951                	li	s2,20
    1e0e:	a015                	j	1e32 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1e10:	85e6                	mv	a1,s9
    1e12:	00005517          	auipc	a0,0x5
    1e16:	c2650513          	addi	a0,a0,-986 # 6a38 <malloc+0xa68>
    1e1a:	00004097          	auipc	ra,0x4
    1e1e:	0f8080e7          	jalr	248(ra) # 5f12 <printf>
          exit(1);
    1e22:	4505                	li	a0,1
    1e24:	00004097          	auipc	ra,0x4
    1e28:	d46080e7          	jalr	-698(ra) # 5b6a <exit>
      for (i = 0; i < N; i++)
    1e2c:	2485                	addiw	s1,s1,1
    1e2e:	07248863          	beq	s1,s2,1e9e <createdelete+0x122>
        name[1] = '0' + i;
    1e32:	0304879b          	addiw	a5,s1,48
    1e36:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1e3a:	20200593          	li	a1,514
    1e3e:	f8040513          	addi	a0,s0,-128
    1e42:	00004097          	auipc	ra,0x4
    1e46:	d68080e7          	jalr	-664(ra) # 5baa <open>
        if (fd < 0)
    1e4a:	fc0543e3          	bltz	a0,1e10 <createdelete+0x94>
        close(fd);
    1e4e:	00004097          	auipc	ra,0x4
    1e52:	d44080e7          	jalr	-700(ra) # 5b92 <close>
        if (i > 0 && (i % 2) == 0)
    1e56:	fc905be3          	blez	s1,1e2c <createdelete+0xb0>
    1e5a:	0014f793          	andi	a5,s1,1
    1e5e:	f7f9                	bnez	a5,1e2c <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1e60:	01f4d79b          	srliw	a5,s1,0x1f
    1e64:	9fa5                	addw	a5,a5,s1
    1e66:	4017d79b          	sraiw	a5,a5,0x1
    1e6a:	0307879b          	addiw	a5,a5,48
    1e6e:	f8f400a3          	sb	a5,-127(s0)
          if (unlink(name) < 0)
    1e72:	f8040513          	addi	a0,s0,-128
    1e76:	00004097          	auipc	ra,0x4
    1e7a:	d44080e7          	jalr	-700(ra) # 5bba <unlink>
    1e7e:	fa0557e3          	bgez	a0,1e2c <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1e82:	85e6                	mv	a1,s9
    1e84:	00005517          	auipc	a0,0x5
    1e88:	d0c50513          	addi	a0,a0,-756 # 6b90 <malloc+0xbc0>
    1e8c:	00004097          	auipc	ra,0x4
    1e90:	086080e7          	jalr	134(ra) # 5f12 <printf>
            exit(1);
    1e94:	4505                	li	a0,1
    1e96:	00004097          	auipc	ra,0x4
    1e9a:	cd4080e7          	jalr	-812(ra) # 5b6a <exit>
      exit(0);
    1e9e:	4501                	li	a0,0
    1ea0:	00004097          	auipc	ra,0x4
    1ea4:	cca080e7          	jalr	-822(ra) # 5b6a <exit>
      exit(1);
    1ea8:	4505                	li	a0,1
    1eaa:	00004097          	auipc	ra,0x4
    1eae:	cc0080e7          	jalr	-832(ra) # 5b6a <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1eb2:	f8040613          	addi	a2,s0,-128
    1eb6:	85e6                	mv	a1,s9
    1eb8:	00005517          	auipc	a0,0x5
    1ebc:	cf050513          	addi	a0,a0,-784 # 6ba8 <malloc+0xbd8>
    1ec0:	00004097          	auipc	ra,0x4
    1ec4:	052080e7          	jalr	82(ra) # 5f12 <printf>
        exit(1);
    1ec8:	4505                	li	a0,1
    1eca:	00004097          	auipc	ra,0x4
    1ece:	ca0080e7          	jalr	-864(ra) # 5b6a <exit>
      else if ((i >= 1 && i < N / 2) && fd >= 0)
    1ed2:	054b7163          	bgeu	s6,s4,1f14 <createdelete+0x198>
      if (fd >= 0)
    1ed6:	02055a63          	bgez	a0,1f0a <createdelete+0x18e>
    for (pi = 0; pi < NCHILD; pi++)
    1eda:	2485                	addiw	s1,s1,1
    1edc:	0ff4f493          	andi	s1,s1,255
    1ee0:	05548c63          	beq	s1,s5,1f38 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1ee4:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1ee8:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1eec:	4581                	li	a1,0
    1eee:	f8040513          	addi	a0,s0,-128
    1ef2:	00004097          	auipc	ra,0x4
    1ef6:	cb8080e7          	jalr	-840(ra) # 5baa <open>
      if ((i == 0 || i >= N / 2) && fd < 0)
    1efa:	00090463          	beqz	s2,1f02 <createdelete+0x186>
    1efe:	fd2bdae3          	bge	s7,s2,1ed2 <createdelete+0x156>
    1f02:	fa0548e3          	bltz	a0,1eb2 <createdelete+0x136>
      else if ((i >= 1 && i < N / 2) && fd >= 0)
    1f06:	014b7963          	bgeu	s6,s4,1f18 <createdelete+0x19c>
        close(fd);
    1f0a:	00004097          	auipc	ra,0x4
    1f0e:	c88080e7          	jalr	-888(ra) # 5b92 <close>
    1f12:	b7e1                	j	1eda <createdelete+0x15e>
      else if ((i >= 1 && i < N / 2) && fd >= 0)
    1f14:	fc0543e3          	bltz	a0,1eda <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1f18:	f8040613          	addi	a2,s0,-128
    1f1c:	85e6                	mv	a1,s9
    1f1e:	00005517          	auipc	a0,0x5
    1f22:	cb250513          	addi	a0,a0,-846 # 6bd0 <malloc+0xc00>
    1f26:	00004097          	auipc	ra,0x4
    1f2a:	fec080e7          	jalr	-20(ra) # 5f12 <printf>
        exit(1);
    1f2e:	4505                	li	a0,1
    1f30:	00004097          	auipc	ra,0x4
    1f34:	c3a080e7          	jalr	-966(ra) # 5b6a <exit>
  for (i = 0; i < N; i++)
    1f38:	2905                	addiw	s2,s2,1
    1f3a:	2a05                	addiw	s4,s4,1
    1f3c:	2985                	addiw	s3,s3,1
    1f3e:	0ff9f993          	andi	s3,s3,255
    1f42:	47d1                	li	a5,20
    1f44:	02f90a63          	beq	s2,a5,1f78 <createdelete+0x1fc>
    for (pi = 0; pi < NCHILD; pi++)
    1f48:	84e2                	mv	s1,s8
    1f4a:	bf69                	j	1ee4 <createdelete+0x168>
  for (i = 0; i < N; i++)
    1f4c:	2905                	addiw	s2,s2,1
    1f4e:	0ff97913          	andi	s2,s2,255
    1f52:	2985                	addiw	s3,s3,1
    1f54:	0ff9f993          	andi	s3,s3,255
    1f58:	03490863          	beq	s2,s4,1f88 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1f5c:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1f5e:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1f62:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1f66:	f8040513          	addi	a0,s0,-128
    1f6a:	00004097          	auipc	ra,0x4
    1f6e:	c50080e7          	jalr	-944(ra) # 5bba <unlink>
    for (pi = 0; pi < NCHILD; pi++)
    1f72:	34fd                	addiw	s1,s1,-1
    1f74:	f4ed                	bnez	s1,1f5e <createdelete+0x1e2>
    1f76:	bfd9                	j	1f4c <createdelete+0x1d0>
    1f78:	03000993          	li	s3,48
    1f7c:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1f80:	4a91                	li	s5,4
  for (i = 0; i < N; i++)
    1f82:	08400a13          	li	s4,132
    1f86:	bfd9                	j	1f5c <createdelete+0x1e0>
}
    1f88:	60aa                	ld	ra,136(sp)
    1f8a:	640a                	ld	s0,128(sp)
    1f8c:	74e6                	ld	s1,120(sp)
    1f8e:	7946                	ld	s2,112(sp)
    1f90:	79a6                	ld	s3,104(sp)
    1f92:	7a06                	ld	s4,96(sp)
    1f94:	6ae6                	ld	s5,88(sp)
    1f96:	6b46                	ld	s6,80(sp)
    1f98:	6ba6                	ld	s7,72(sp)
    1f9a:	6c06                	ld	s8,64(sp)
    1f9c:	7ce2                	ld	s9,56(sp)
    1f9e:	6149                	addi	sp,sp,144
    1fa0:	8082                	ret

0000000000001fa2 <linkunlink>:
{
    1fa2:	711d                	addi	sp,sp,-96
    1fa4:	ec86                	sd	ra,88(sp)
    1fa6:	e8a2                	sd	s0,80(sp)
    1fa8:	e4a6                	sd	s1,72(sp)
    1faa:	e0ca                	sd	s2,64(sp)
    1fac:	fc4e                	sd	s3,56(sp)
    1fae:	f852                	sd	s4,48(sp)
    1fb0:	f456                	sd	s5,40(sp)
    1fb2:	f05a                	sd	s6,32(sp)
    1fb4:	ec5e                	sd	s7,24(sp)
    1fb6:	e862                	sd	s8,16(sp)
    1fb8:	e466                	sd	s9,8(sp)
    1fba:	1080                	addi	s0,sp,96
    1fbc:	84aa                	mv	s1,a0
  unlink("x");
    1fbe:	00004517          	auipc	a0,0x4
    1fc2:	1ca50513          	addi	a0,a0,458 # 6188 <malloc+0x1b8>
    1fc6:	00004097          	auipc	ra,0x4
    1fca:	bf4080e7          	jalr	-1036(ra) # 5bba <unlink>
  pid = fork();
    1fce:	00004097          	auipc	ra,0x4
    1fd2:	b94080e7          	jalr	-1132(ra) # 5b62 <fork>
  if (pid < 0)
    1fd6:	02054b63          	bltz	a0,200c <linkunlink+0x6a>
    1fda:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1fdc:	4c85                	li	s9,1
    1fde:	e119                	bnez	a0,1fe4 <linkunlink+0x42>
    1fe0:	06100c93          	li	s9,97
    1fe4:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1fe8:	41c659b7          	lui	s3,0x41c65
    1fec:	e6d9899b          	addiw	s3,s3,-403
    1ff0:	690d                	lui	s2,0x3
    1ff2:	0399091b          	addiw	s2,s2,57
    if ((x % 3) == 0)
    1ff6:	4a0d                	li	s4,3
    else if ((x % 3) == 1)
    1ff8:	4b05                	li	s6,1
      unlink("x");
    1ffa:	00004a97          	auipc	s5,0x4
    1ffe:	18ea8a93          	addi	s5,s5,398 # 6188 <malloc+0x1b8>
      link("cat", "x");
    2002:	00005b97          	auipc	s7,0x5
    2006:	bf6b8b93          	addi	s7,s7,-1034 # 6bf8 <malloc+0xc28>
    200a:	a825                	j	2042 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    200c:	85a6                	mv	a1,s1
    200e:	00005517          	auipc	a0,0x5
    2012:	99250513          	addi	a0,a0,-1646 # 69a0 <malloc+0x9d0>
    2016:	00004097          	auipc	ra,0x4
    201a:	efc080e7          	jalr	-260(ra) # 5f12 <printf>
    exit(1);
    201e:	4505                	li	a0,1
    2020:	00004097          	auipc	ra,0x4
    2024:	b4a080e7          	jalr	-1206(ra) # 5b6a <exit>
      close(open("x", O_RDWR | O_CREATE));
    2028:	20200593          	li	a1,514
    202c:	8556                	mv	a0,s5
    202e:	00004097          	auipc	ra,0x4
    2032:	b7c080e7          	jalr	-1156(ra) # 5baa <open>
    2036:	00004097          	auipc	ra,0x4
    203a:	b5c080e7          	jalr	-1188(ra) # 5b92 <close>
  for (i = 0; i < 100; i++)
    203e:	34fd                	addiw	s1,s1,-1
    2040:	c88d                	beqz	s1,2072 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    2042:	033c87bb          	mulw	a5,s9,s3
    2046:	012787bb          	addw	a5,a5,s2
    204a:	00078c9b          	sext.w	s9,a5
    if ((x % 3) == 0)
    204e:	0347f7bb          	remuw	a5,a5,s4
    2052:	dbf9                	beqz	a5,2028 <linkunlink+0x86>
    else if ((x % 3) == 1)
    2054:	01678863          	beq	a5,s6,2064 <linkunlink+0xc2>
      unlink("x");
    2058:	8556                	mv	a0,s5
    205a:	00004097          	auipc	ra,0x4
    205e:	b60080e7          	jalr	-1184(ra) # 5bba <unlink>
    2062:	bff1                	j	203e <linkunlink+0x9c>
      link("cat", "x");
    2064:	85d6                	mv	a1,s5
    2066:	855e                	mv	a0,s7
    2068:	00004097          	auipc	ra,0x4
    206c:	b62080e7          	jalr	-1182(ra) # 5bca <link>
    2070:	b7f9                	j	203e <linkunlink+0x9c>
  if (pid)
    2072:	020c0463          	beqz	s8,209a <linkunlink+0xf8>
    wait(0);
    2076:	4501                	li	a0,0
    2078:	00004097          	auipc	ra,0x4
    207c:	afa080e7          	jalr	-1286(ra) # 5b72 <wait>
}
    2080:	60e6                	ld	ra,88(sp)
    2082:	6446                	ld	s0,80(sp)
    2084:	64a6                	ld	s1,72(sp)
    2086:	6906                	ld	s2,64(sp)
    2088:	79e2                	ld	s3,56(sp)
    208a:	7a42                	ld	s4,48(sp)
    208c:	7aa2                	ld	s5,40(sp)
    208e:	7b02                	ld	s6,32(sp)
    2090:	6be2                	ld	s7,24(sp)
    2092:	6c42                	ld	s8,16(sp)
    2094:	6ca2                	ld	s9,8(sp)
    2096:	6125                	addi	sp,sp,96
    2098:	8082                	ret
    exit(0);
    209a:	4501                	li	a0,0
    209c:	00004097          	auipc	ra,0x4
    20a0:	ace080e7          	jalr	-1330(ra) # 5b6a <exit>

00000000000020a4 <forktest>:
{
    20a4:	7179                	addi	sp,sp,-48
    20a6:	f406                	sd	ra,40(sp)
    20a8:	f022                	sd	s0,32(sp)
    20aa:	ec26                	sd	s1,24(sp)
    20ac:	e84a                	sd	s2,16(sp)
    20ae:	e44e                	sd	s3,8(sp)
    20b0:	1800                	addi	s0,sp,48
    20b2:	89aa                	mv	s3,a0
  for (n = 0; n < N; n++)
    20b4:	4481                	li	s1,0
    20b6:	3e800913          	li	s2,1000
    pid = fork();
    20ba:	00004097          	auipc	ra,0x4
    20be:	aa8080e7          	jalr	-1368(ra) # 5b62 <fork>
    if (pid < 0)
    20c2:	02054863          	bltz	a0,20f2 <forktest+0x4e>
    if (pid == 0)
    20c6:	c115                	beqz	a0,20ea <forktest+0x46>
  for (n = 0; n < N; n++)
    20c8:	2485                	addiw	s1,s1,1
    20ca:	ff2498e3          	bne	s1,s2,20ba <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    20ce:	85ce                	mv	a1,s3
    20d0:	00005517          	auipc	a0,0x5
    20d4:	b4850513          	addi	a0,a0,-1208 # 6c18 <malloc+0xc48>
    20d8:	00004097          	auipc	ra,0x4
    20dc:	e3a080e7          	jalr	-454(ra) # 5f12 <printf>
    exit(1);
    20e0:	4505                	li	a0,1
    20e2:	00004097          	auipc	ra,0x4
    20e6:	a88080e7          	jalr	-1400(ra) # 5b6a <exit>
      exit(0);
    20ea:	00004097          	auipc	ra,0x4
    20ee:	a80080e7          	jalr	-1408(ra) # 5b6a <exit>
  if (n == 0)
    20f2:	cc9d                	beqz	s1,2130 <forktest+0x8c>
  if (n == N)
    20f4:	3e800793          	li	a5,1000
    20f8:	fcf48be3          	beq	s1,a5,20ce <forktest+0x2a>
  for (; n > 0; n--)
    20fc:	00905b63          	blez	s1,2112 <forktest+0x6e>
    if (wait(0) < 0)
    2100:	4501                	li	a0,0
    2102:	00004097          	auipc	ra,0x4
    2106:	a70080e7          	jalr	-1424(ra) # 5b72 <wait>
    210a:	04054163          	bltz	a0,214c <forktest+0xa8>
  for (; n > 0; n--)
    210e:	34fd                	addiw	s1,s1,-1
    2110:	f8e5                	bnez	s1,2100 <forktest+0x5c>
  if (wait(0) != -1)
    2112:	4501                	li	a0,0
    2114:	00004097          	auipc	ra,0x4
    2118:	a5e080e7          	jalr	-1442(ra) # 5b72 <wait>
    211c:	57fd                	li	a5,-1
    211e:	04f51563          	bne	a0,a5,2168 <forktest+0xc4>
}
    2122:	70a2                	ld	ra,40(sp)
    2124:	7402                	ld	s0,32(sp)
    2126:	64e2                	ld	s1,24(sp)
    2128:	6942                	ld	s2,16(sp)
    212a:	69a2                	ld	s3,8(sp)
    212c:	6145                	addi	sp,sp,48
    212e:	8082                	ret
    printf("%s: no fork at all!\n", s);
    2130:	85ce                	mv	a1,s3
    2132:	00005517          	auipc	a0,0x5
    2136:	ace50513          	addi	a0,a0,-1330 # 6c00 <malloc+0xc30>
    213a:	00004097          	auipc	ra,0x4
    213e:	dd8080e7          	jalr	-552(ra) # 5f12 <printf>
    exit(1);
    2142:	4505                	li	a0,1
    2144:	00004097          	auipc	ra,0x4
    2148:	a26080e7          	jalr	-1498(ra) # 5b6a <exit>
      printf("%s: wait stopped early\n", s);
    214c:	85ce                	mv	a1,s3
    214e:	00005517          	auipc	a0,0x5
    2152:	af250513          	addi	a0,a0,-1294 # 6c40 <malloc+0xc70>
    2156:	00004097          	auipc	ra,0x4
    215a:	dbc080e7          	jalr	-580(ra) # 5f12 <printf>
      exit(1);
    215e:	4505                	li	a0,1
    2160:	00004097          	auipc	ra,0x4
    2164:	a0a080e7          	jalr	-1526(ra) # 5b6a <exit>
    printf("%s: wait got too many\n", s);
    2168:	85ce                	mv	a1,s3
    216a:	00005517          	auipc	a0,0x5
    216e:	aee50513          	addi	a0,a0,-1298 # 6c58 <malloc+0xc88>
    2172:	00004097          	auipc	ra,0x4
    2176:	da0080e7          	jalr	-608(ra) # 5f12 <printf>
    exit(1);
    217a:	4505                	li	a0,1
    217c:	00004097          	auipc	ra,0x4
    2180:	9ee080e7          	jalr	-1554(ra) # 5b6a <exit>

0000000000002184 <kernmem>:
{
    2184:	715d                	addi	sp,sp,-80
    2186:	e486                	sd	ra,72(sp)
    2188:	e0a2                	sd	s0,64(sp)
    218a:	fc26                	sd	s1,56(sp)
    218c:	f84a                	sd	s2,48(sp)
    218e:	f44e                	sd	s3,40(sp)
    2190:	f052                	sd	s4,32(sp)
    2192:	ec56                	sd	s5,24(sp)
    2194:	0880                	addi	s0,sp,80
    2196:	8a2a                	mv	s4,a0
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000)
    2198:	4485                	li	s1,1
    219a:	04fe                	slli	s1,s1,0x1f
    if (xstatus != -1) // did kernel kill child?
    219c:	5afd                	li	s5,-1
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000)
    219e:	69b1                	lui	s3,0xc
    21a0:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1de8>
    21a4:	1003d937          	lui	s2,0x1003d
    21a8:	090e                	slli	s2,s2,0x3
    21aa:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d808>
    pid = fork();
    21ae:	00004097          	auipc	ra,0x4
    21b2:	9b4080e7          	jalr	-1612(ra) # 5b62 <fork>
    if (pid < 0)
    21b6:	02054963          	bltz	a0,21e8 <kernmem+0x64>
    if (pid == 0)
    21ba:	c529                	beqz	a0,2204 <kernmem+0x80>
    wait(&xstatus);
    21bc:	fbc40513          	addi	a0,s0,-68
    21c0:	00004097          	auipc	ra,0x4
    21c4:	9b2080e7          	jalr	-1614(ra) # 5b72 <wait>
    if (xstatus != -1) // did kernel kill child?
    21c8:	fbc42783          	lw	a5,-68(s0)
    21cc:	05579d63          	bne	a5,s5,2226 <kernmem+0xa2>
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000)
    21d0:	94ce                	add	s1,s1,s3
    21d2:	fd249ee3          	bne	s1,s2,21ae <kernmem+0x2a>
}
    21d6:	60a6                	ld	ra,72(sp)
    21d8:	6406                	ld	s0,64(sp)
    21da:	74e2                	ld	s1,56(sp)
    21dc:	7942                	ld	s2,48(sp)
    21de:	79a2                	ld	s3,40(sp)
    21e0:	7a02                	ld	s4,32(sp)
    21e2:	6ae2                	ld	s5,24(sp)
    21e4:	6161                	addi	sp,sp,80
    21e6:	8082                	ret
      printf("%s: fork failed\n", s);
    21e8:	85d2                	mv	a1,s4
    21ea:	00004517          	auipc	a0,0x4
    21ee:	7b650513          	addi	a0,a0,1974 # 69a0 <malloc+0x9d0>
    21f2:	00004097          	auipc	ra,0x4
    21f6:	d20080e7          	jalr	-736(ra) # 5f12 <printf>
      exit(1);
    21fa:	4505                	li	a0,1
    21fc:	00004097          	auipc	ra,0x4
    2200:	96e080e7          	jalr	-1682(ra) # 5b6a <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    2204:	0004c683          	lbu	a3,0(s1)
    2208:	8626                	mv	a2,s1
    220a:	85d2                	mv	a1,s4
    220c:	00005517          	auipc	a0,0x5
    2210:	a6450513          	addi	a0,a0,-1436 # 6c70 <malloc+0xca0>
    2214:	00004097          	auipc	ra,0x4
    2218:	cfe080e7          	jalr	-770(ra) # 5f12 <printf>
      exit(1);
    221c:	4505                	li	a0,1
    221e:	00004097          	auipc	ra,0x4
    2222:	94c080e7          	jalr	-1716(ra) # 5b6a <exit>
      exit(1);
    2226:	4505                	li	a0,1
    2228:	00004097          	auipc	ra,0x4
    222c:	942080e7          	jalr	-1726(ra) # 5b6a <exit>

0000000000002230 <MAXVAplus>:
{
    2230:	7179                	addi	sp,sp,-48
    2232:	f406                	sd	ra,40(sp)
    2234:	f022                	sd	s0,32(sp)
    2236:	ec26                	sd	s1,24(sp)
    2238:	e84a                	sd	s2,16(sp)
    223a:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    223c:	4785                	li	a5,1
    223e:	179a                	slli	a5,a5,0x26
    2240:	fcf43c23          	sd	a5,-40(s0)
  for (; a != 0; a <<= 1)
    2244:	fd843783          	ld	a5,-40(s0)
    2248:	cf85                	beqz	a5,2280 <MAXVAplus+0x50>
    224a:	892a                	mv	s2,a0
    if (xstatus != -1) // did kernel kill child?
    224c:	54fd                	li	s1,-1
    pid = fork();
    224e:	00004097          	auipc	ra,0x4
    2252:	914080e7          	jalr	-1772(ra) # 5b62 <fork>
    if (pid < 0)
    2256:	02054b63          	bltz	a0,228c <MAXVAplus+0x5c>
    if (pid == 0)
    225a:	c539                	beqz	a0,22a8 <MAXVAplus+0x78>
    wait(&xstatus);
    225c:	fd440513          	addi	a0,s0,-44
    2260:	00004097          	auipc	ra,0x4
    2264:	912080e7          	jalr	-1774(ra) # 5b72 <wait>
    if (xstatus != -1) // did kernel kill child?
    2268:	fd442783          	lw	a5,-44(s0)
    226c:	06979463          	bne	a5,s1,22d4 <MAXVAplus+0xa4>
  for (; a != 0; a <<= 1)
    2270:	fd843783          	ld	a5,-40(s0)
    2274:	0786                	slli	a5,a5,0x1
    2276:	fcf43c23          	sd	a5,-40(s0)
    227a:	fd843783          	ld	a5,-40(s0)
    227e:	fbe1                	bnez	a5,224e <MAXVAplus+0x1e>
}
    2280:	70a2                	ld	ra,40(sp)
    2282:	7402                	ld	s0,32(sp)
    2284:	64e2                	ld	s1,24(sp)
    2286:	6942                	ld	s2,16(sp)
    2288:	6145                	addi	sp,sp,48
    228a:	8082                	ret
      printf("%s: fork failed\n", s);
    228c:	85ca                	mv	a1,s2
    228e:	00004517          	auipc	a0,0x4
    2292:	71250513          	addi	a0,a0,1810 # 69a0 <malloc+0x9d0>
    2296:	00004097          	auipc	ra,0x4
    229a:	c7c080e7          	jalr	-900(ra) # 5f12 <printf>
      exit(1);
    229e:	4505                	li	a0,1
    22a0:	00004097          	auipc	ra,0x4
    22a4:	8ca080e7          	jalr	-1846(ra) # 5b6a <exit>
      *(char *)a = 99;
    22a8:	fd843783          	ld	a5,-40(s0)
    22ac:	06300713          	li	a4,99
    22b0:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    22b4:	fd843603          	ld	a2,-40(s0)
    22b8:	85ca                	mv	a1,s2
    22ba:	00005517          	auipc	a0,0x5
    22be:	9d650513          	addi	a0,a0,-1578 # 6c90 <malloc+0xcc0>
    22c2:	00004097          	auipc	ra,0x4
    22c6:	c50080e7          	jalr	-944(ra) # 5f12 <printf>
      exit(1);
    22ca:	4505                	li	a0,1
    22cc:	00004097          	auipc	ra,0x4
    22d0:	89e080e7          	jalr	-1890(ra) # 5b6a <exit>
      exit(1);
    22d4:	4505                	li	a0,1
    22d6:	00004097          	auipc	ra,0x4
    22da:	894080e7          	jalr	-1900(ra) # 5b6a <exit>

00000000000022de <bigargtest>:
{
    22de:	7179                	addi	sp,sp,-48
    22e0:	f406                	sd	ra,40(sp)
    22e2:	f022                	sd	s0,32(sp)
    22e4:	ec26                	sd	s1,24(sp)
    22e6:	1800                	addi	s0,sp,48
    22e8:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    22ea:	00005517          	auipc	a0,0x5
    22ee:	9be50513          	addi	a0,a0,-1602 # 6ca8 <malloc+0xcd8>
    22f2:	00004097          	auipc	ra,0x4
    22f6:	8c8080e7          	jalr	-1848(ra) # 5bba <unlink>
  pid = fork();
    22fa:	00004097          	auipc	ra,0x4
    22fe:	868080e7          	jalr	-1944(ra) # 5b62 <fork>
  if (pid == 0)
    2302:	c121                	beqz	a0,2342 <bigargtest+0x64>
  else if (pid < 0)
    2304:	0a054063          	bltz	a0,23a4 <bigargtest+0xc6>
  wait(&xstatus);
    2308:	fdc40513          	addi	a0,s0,-36
    230c:	00004097          	auipc	ra,0x4
    2310:	866080e7          	jalr	-1946(ra) # 5b72 <wait>
  if (xstatus != 0)
    2314:	fdc42503          	lw	a0,-36(s0)
    2318:	e545                	bnez	a0,23c0 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    231a:	4581                	li	a1,0
    231c:	00005517          	auipc	a0,0x5
    2320:	98c50513          	addi	a0,a0,-1652 # 6ca8 <malloc+0xcd8>
    2324:	00004097          	auipc	ra,0x4
    2328:	886080e7          	jalr	-1914(ra) # 5baa <open>
  if (fd < 0)
    232c:	08054e63          	bltz	a0,23c8 <bigargtest+0xea>
  close(fd);
    2330:	00004097          	auipc	ra,0x4
    2334:	862080e7          	jalr	-1950(ra) # 5b92 <close>
}
    2338:	70a2                	ld	ra,40(sp)
    233a:	7402                	ld	s0,32(sp)
    233c:	64e2                	ld	s1,24(sp)
    233e:	6145                	addi	sp,sp,48
    2340:	8082                	ret
    2342:	00007797          	auipc	a5,0x7
    2346:	11e78793          	addi	a5,a5,286 # 9460 <args.1>
    234a:	00007697          	auipc	a3,0x7
    234e:	20e68693          	addi	a3,a3,526 # 9558 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2352:	00005717          	auipc	a4,0x5
    2356:	96670713          	addi	a4,a4,-1690 # 6cb8 <malloc+0xce8>
    235a:	e398                	sd	a4,0(a5)
    for (i = 0; i < MAXARG - 1; i++)
    235c:	07a1                	addi	a5,a5,8
    235e:	fed79ee3          	bne	a5,a3,235a <bigargtest+0x7c>
    args[MAXARG - 1] = 0;
    2362:	00007597          	auipc	a1,0x7
    2366:	0fe58593          	addi	a1,a1,254 # 9460 <args.1>
    236a:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    236e:	00004517          	auipc	a0,0x4
    2372:	daa50513          	addi	a0,a0,-598 # 6118 <malloc+0x148>
    2376:	00004097          	auipc	ra,0x4
    237a:	82c080e7          	jalr	-2004(ra) # 5ba2 <exec>
    fd = open("bigarg-ok", O_CREATE);
    237e:	20000593          	li	a1,512
    2382:	00005517          	auipc	a0,0x5
    2386:	92650513          	addi	a0,a0,-1754 # 6ca8 <malloc+0xcd8>
    238a:	00004097          	auipc	ra,0x4
    238e:	820080e7          	jalr	-2016(ra) # 5baa <open>
    close(fd);
    2392:	00004097          	auipc	ra,0x4
    2396:	800080e7          	jalr	-2048(ra) # 5b92 <close>
    exit(0);
    239a:	4501                	li	a0,0
    239c:	00003097          	auipc	ra,0x3
    23a0:	7ce080e7          	jalr	1998(ra) # 5b6a <exit>
    printf("%s: bigargtest: fork failed\n", s);
    23a4:	85a6                	mv	a1,s1
    23a6:	00005517          	auipc	a0,0x5
    23aa:	9f250513          	addi	a0,a0,-1550 # 6d98 <malloc+0xdc8>
    23ae:	00004097          	auipc	ra,0x4
    23b2:	b64080e7          	jalr	-1180(ra) # 5f12 <printf>
    exit(1);
    23b6:	4505                	li	a0,1
    23b8:	00003097          	auipc	ra,0x3
    23bc:	7b2080e7          	jalr	1970(ra) # 5b6a <exit>
    exit(xstatus);
    23c0:	00003097          	auipc	ra,0x3
    23c4:	7aa080e7          	jalr	1962(ra) # 5b6a <exit>
    printf("%s: bigarg test failed!\n", s);
    23c8:	85a6                	mv	a1,s1
    23ca:	00005517          	auipc	a0,0x5
    23ce:	9ee50513          	addi	a0,a0,-1554 # 6db8 <malloc+0xde8>
    23d2:	00004097          	auipc	ra,0x4
    23d6:	b40080e7          	jalr	-1216(ra) # 5f12 <printf>
    exit(1);
    23da:	4505                	li	a0,1
    23dc:	00003097          	auipc	ra,0x3
    23e0:	78e080e7          	jalr	1934(ra) # 5b6a <exit>

00000000000023e4 <stacktest>:
{
    23e4:	7179                	addi	sp,sp,-48
    23e6:	f406                	sd	ra,40(sp)
    23e8:	f022                	sd	s0,32(sp)
    23ea:	ec26                	sd	s1,24(sp)
    23ec:	1800                	addi	s0,sp,48
    23ee:	84aa                	mv	s1,a0
  pid = fork();
    23f0:	00003097          	auipc	ra,0x3
    23f4:	772080e7          	jalr	1906(ra) # 5b62 <fork>
  if (pid == 0)
    23f8:	c115                	beqz	a0,241c <stacktest+0x38>
  else if (pid < 0)
    23fa:	04054463          	bltz	a0,2442 <stacktest+0x5e>
  wait(&xstatus);
    23fe:	fdc40513          	addi	a0,s0,-36
    2402:	00003097          	auipc	ra,0x3
    2406:	770080e7          	jalr	1904(ra) # 5b72 <wait>
  if (xstatus == -1) // kernel killed child?
    240a:	fdc42503          	lw	a0,-36(s0)
    240e:	57fd                	li	a5,-1
    2410:	04f50763          	beq	a0,a5,245e <stacktest+0x7a>
    exit(xstatus);
    2414:	00003097          	auipc	ra,0x3
    2418:	756080e7          	jalr	1878(ra) # 5b6a <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp"
    241c:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    241e:	77fd                	lui	a5,0xfffff
    2420:	97ba                	add	a5,a5,a4
    2422:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef388>
    2426:	85a6                	mv	a1,s1
    2428:	00005517          	auipc	a0,0x5
    242c:	9b050513          	addi	a0,a0,-1616 # 6dd8 <malloc+0xe08>
    2430:	00004097          	auipc	ra,0x4
    2434:	ae2080e7          	jalr	-1310(ra) # 5f12 <printf>
    exit(1);
    2438:	4505                	li	a0,1
    243a:	00003097          	auipc	ra,0x3
    243e:	730080e7          	jalr	1840(ra) # 5b6a <exit>
    printf("%s: fork failed\n", s);
    2442:	85a6                	mv	a1,s1
    2444:	00004517          	auipc	a0,0x4
    2448:	55c50513          	addi	a0,a0,1372 # 69a0 <malloc+0x9d0>
    244c:	00004097          	auipc	ra,0x4
    2450:	ac6080e7          	jalr	-1338(ra) # 5f12 <printf>
    exit(1);
    2454:	4505                	li	a0,1
    2456:	00003097          	auipc	ra,0x3
    245a:	714080e7          	jalr	1812(ra) # 5b6a <exit>
    exit(0);
    245e:	4501                	li	a0,0
    2460:	00003097          	auipc	ra,0x3
    2464:	70a080e7          	jalr	1802(ra) # 5b6a <exit>

0000000000002468 <manywrites>:
{
    2468:	711d                	addi	sp,sp,-96
    246a:	ec86                	sd	ra,88(sp)
    246c:	e8a2                	sd	s0,80(sp)
    246e:	e4a6                	sd	s1,72(sp)
    2470:	e0ca                	sd	s2,64(sp)
    2472:	fc4e                	sd	s3,56(sp)
    2474:	f852                	sd	s4,48(sp)
    2476:	f456                	sd	s5,40(sp)
    2478:	f05a                	sd	s6,32(sp)
    247a:	ec5e                	sd	s7,24(sp)
    247c:	1080                	addi	s0,sp,96
    247e:	8aaa                	mv	s5,a0
  for (int ci = 0; ci < nchildren; ci++)
    2480:	4981                	li	s3,0
    2482:	4911                	li	s2,4
    int pid = fork();
    2484:	00003097          	auipc	ra,0x3
    2488:	6de080e7          	jalr	1758(ra) # 5b62 <fork>
    248c:	84aa                	mv	s1,a0
    if (pid < 0)
    248e:	02054963          	bltz	a0,24c0 <manywrites+0x58>
    if (pid == 0)
    2492:	c521                	beqz	a0,24da <manywrites+0x72>
  for (int ci = 0; ci < nchildren; ci++)
    2494:	2985                	addiw	s3,s3,1
    2496:	ff2997e3          	bne	s3,s2,2484 <manywrites+0x1c>
    249a:	4491                	li	s1,4
    int st = 0;
    249c:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    24a0:	fa840513          	addi	a0,s0,-88
    24a4:	00003097          	auipc	ra,0x3
    24a8:	6ce080e7          	jalr	1742(ra) # 5b72 <wait>
    if (st != 0)
    24ac:	fa842503          	lw	a0,-88(s0)
    24b0:	ed6d                	bnez	a0,25aa <manywrites+0x142>
  for (int ci = 0; ci < nchildren; ci++)
    24b2:	34fd                	addiw	s1,s1,-1
    24b4:	f4e5                	bnez	s1,249c <manywrites+0x34>
  exit(0);
    24b6:	4501                	li	a0,0
    24b8:	00003097          	auipc	ra,0x3
    24bc:	6b2080e7          	jalr	1714(ra) # 5b6a <exit>
      printf("fork failed\n");
    24c0:	00005517          	auipc	a0,0x5
    24c4:	8e850513          	addi	a0,a0,-1816 # 6da8 <malloc+0xdd8>
    24c8:	00004097          	auipc	ra,0x4
    24cc:	a4a080e7          	jalr	-1462(ra) # 5f12 <printf>
      exit(1);
    24d0:	4505                	li	a0,1
    24d2:	00003097          	auipc	ra,0x3
    24d6:	698080e7          	jalr	1688(ra) # 5b6a <exit>
      name[0] = 'b';
    24da:	06200793          	li	a5,98
    24de:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    24e2:	0619879b          	addiw	a5,s3,97
    24e6:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    24ea:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    24ee:	fa840513          	addi	a0,s0,-88
    24f2:	00003097          	auipc	ra,0x3
    24f6:	6c8080e7          	jalr	1736(ra) # 5bba <unlink>
    24fa:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    24fc:	0000ab17          	auipc	s6,0xa
    2500:	77cb0b13          	addi	s6,s6,1916 # cc78 <buf>
        for (int i = 0; i < ci + 1; i++)
    2504:	8a26                	mv	s4,s1
    2506:	0209ce63          	bltz	s3,2542 <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    250a:	20200593          	li	a1,514
    250e:	fa840513          	addi	a0,s0,-88
    2512:	00003097          	auipc	ra,0x3
    2516:	698080e7          	jalr	1688(ra) # 5baa <open>
    251a:	892a                	mv	s2,a0
          if (fd < 0)
    251c:	04054763          	bltz	a0,256a <manywrites+0x102>
          int cc = write(fd, buf, sz);
    2520:	660d                	lui	a2,0x3
    2522:	85da                	mv	a1,s6
    2524:	00003097          	auipc	ra,0x3
    2528:	666080e7          	jalr	1638(ra) # 5b8a <write>
          if (cc != sz)
    252c:	678d                	lui	a5,0x3
    252e:	04f51e63          	bne	a0,a5,258a <manywrites+0x122>
          close(fd);
    2532:	854a                	mv	a0,s2
    2534:	00003097          	auipc	ra,0x3
    2538:	65e080e7          	jalr	1630(ra) # 5b92 <close>
        for (int i = 0; i < ci + 1; i++)
    253c:	2a05                	addiw	s4,s4,1
    253e:	fd49d6e3          	bge	s3,s4,250a <manywrites+0xa2>
        unlink(name);
    2542:	fa840513          	addi	a0,s0,-88
    2546:	00003097          	auipc	ra,0x3
    254a:	674080e7          	jalr	1652(ra) # 5bba <unlink>
      for (int iters = 0; iters < howmany; iters++)
    254e:	3bfd                	addiw	s7,s7,-1
    2550:	fa0b9ae3          	bnez	s7,2504 <manywrites+0x9c>
      unlink(name);
    2554:	fa840513          	addi	a0,s0,-88
    2558:	00003097          	auipc	ra,0x3
    255c:	662080e7          	jalr	1634(ra) # 5bba <unlink>
      exit(0);
    2560:	4501                	li	a0,0
    2562:	00003097          	auipc	ra,0x3
    2566:	608080e7          	jalr	1544(ra) # 5b6a <exit>
            printf("%s: cannot create %s\n", s, name);
    256a:	fa840613          	addi	a2,s0,-88
    256e:	85d6                	mv	a1,s5
    2570:	00005517          	auipc	a0,0x5
    2574:	89050513          	addi	a0,a0,-1904 # 6e00 <malloc+0xe30>
    2578:	00004097          	auipc	ra,0x4
    257c:	99a080e7          	jalr	-1638(ra) # 5f12 <printf>
            exit(1);
    2580:	4505                	li	a0,1
    2582:	00003097          	auipc	ra,0x3
    2586:	5e8080e7          	jalr	1512(ra) # 5b6a <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    258a:	86aa                	mv	a3,a0
    258c:	660d                	lui	a2,0x3
    258e:	85d6                	mv	a1,s5
    2590:	00004517          	auipc	a0,0x4
    2594:	c5850513          	addi	a0,a0,-936 # 61e8 <malloc+0x218>
    2598:	00004097          	auipc	ra,0x4
    259c:	97a080e7          	jalr	-1670(ra) # 5f12 <printf>
            exit(1);
    25a0:	4505                	li	a0,1
    25a2:	00003097          	auipc	ra,0x3
    25a6:	5c8080e7          	jalr	1480(ra) # 5b6a <exit>
      exit(st);
    25aa:	00003097          	auipc	ra,0x3
    25ae:	5c0080e7          	jalr	1472(ra) # 5b6a <exit>

00000000000025b2 <copyinstr3>:
{
    25b2:	7179                	addi	sp,sp,-48
    25b4:	f406                	sd	ra,40(sp)
    25b6:	f022                	sd	s0,32(sp)
    25b8:	ec26                	sd	s1,24(sp)
    25ba:	1800                	addi	s0,sp,48
  sbrk(8192);
    25bc:	6509                	lui	a0,0x2
    25be:	00003097          	auipc	ra,0x3
    25c2:	634080e7          	jalr	1588(ra) # 5bf2 <sbrk>
  uint64 top = (uint64)sbrk(0);
    25c6:	4501                	li	a0,0
    25c8:	00003097          	auipc	ra,0x3
    25cc:	62a080e7          	jalr	1578(ra) # 5bf2 <sbrk>
  if ((top % PGSIZE) != 0)
    25d0:	03451793          	slli	a5,a0,0x34
    25d4:	e3c9                	bnez	a5,2656 <copyinstr3+0xa4>
  top = (uint64)sbrk(0);
    25d6:	4501                	li	a0,0
    25d8:	00003097          	auipc	ra,0x3
    25dc:	61a080e7          	jalr	1562(ra) # 5bf2 <sbrk>
  if (top % PGSIZE)
    25e0:	03451793          	slli	a5,a0,0x34
    25e4:	e3d9                	bnez	a5,266a <copyinstr3+0xb8>
  char *b = (char *)(top - 1);
    25e6:	fff50493          	addi	s1,a0,-1 # 1fff <linkunlink+0x5d>
  *b = 'x';
    25ea:	07800793          	li	a5,120
    25ee:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    25f2:	8526                	mv	a0,s1
    25f4:	00003097          	auipc	ra,0x3
    25f8:	5c6080e7          	jalr	1478(ra) # 5bba <unlink>
  if (ret != -1)
    25fc:	57fd                	li	a5,-1
    25fe:	08f51363          	bne	a0,a5,2684 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2602:	20100593          	li	a1,513
    2606:	8526                	mv	a0,s1
    2608:	00003097          	auipc	ra,0x3
    260c:	5a2080e7          	jalr	1442(ra) # 5baa <open>
  if (fd != -1)
    2610:	57fd                	li	a5,-1
    2612:	08f51863          	bne	a0,a5,26a2 <copyinstr3+0xf0>
  ret = link(b, b);
    2616:	85a6                	mv	a1,s1
    2618:	8526                	mv	a0,s1
    261a:	00003097          	auipc	ra,0x3
    261e:	5b0080e7          	jalr	1456(ra) # 5bca <link>
  if (ret != -1)
    2622:	57fd                	li	a5,-1
    2624:	08f51e63          	bne	a0,a5,26c0 <copyinstr3+0x10e>
  char *args[] = {"xx", 0};
    2628:	00005797          	auipc	a5,0x5
    262c:	4d078793          	addi	a5,a5,1232 # 7af8 <malloc+0x1b28>
    2630:	fcf43823          	sd	a5,-48(s0)
    2634:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2638:	fd040593          	addi	a1,s0,-48
    263c:	8526                	mv	a0,s1
    263e:	00003097          	auipc	ra,0x3
    2642:	564080e7          	jalr	1380(ra) # 5ba2 <exec>
  if (ret != -1)
    2646:	57fd                	li	a5,-1
    2648:	08f51c63          	bne	a0,a5,26e0 <copyinstr3+0x12e>
}
    264c:	70a2                	ld	ra,40(sp)
    264e:	7402                	ld	s0,32(sp)
    2650:	64e2                	ld	s1,24(sp)
    2652:	6145                	addi	sp,sp,48
    2654:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2656:	0347d513          	srli	a0,a5,0x34
    265a:	6785                	lui	a5,0x1
    265c:	40a7853b          	subw	a0,a5,a0
    2660:	00003097          	auipc	ra,0x3
    2664:	592080e7          	jalr	1426(ra) # 5bf2 <sbrk>
    2668:	b7bd                	j	25d6 <copyinstr3+0x24>
    printf("oops\n");
    266a:	00004517          	auipc	a0,0x4
    266e:	7ae50513          	addi	a0,a0,1966 # 6e18 <malloc+0xe48>
    2672:	00004097          	auipc	ra,0x4
    2676:	8a0080e7          	jalr	-1888(ra) # 5f12 <printf>
    exit(1);
    267a:	4505                	li	a0,1
    267c:	00003097          	auipc	ra,0x3
    2680:	4ee080e7          	jalr	1262(ra) # 5b6a <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2684:	862a                	mv	a2,a0
    2686:	85a6                	mv	a1,s1
    2688:	00004517          	auipc	a0,0x4
    268c:	23850513          	addi	a0,a0,568 # 68c0 <malloc+0x8f0>
    2690:	00004097          	auipc	ra,0x4
    2694:	882080e7          	jalr	-1918(ra) # 5f12 <printf>
    exit(1);
    2698:	4505                	li	a0,1
    269a:	00003097          	auipc	ra,0x3
    269e:	4d0080e7          	jalr	1232(ra) # 5b6a <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    26a2:	862a                	mv	a2,a0
    26a4:	85a6                	mv	a1,s1
    26a6:	00004517          	auipc	a0,0x4
    26aa:	23a50513          	addi	a0,a0,570 # 68e0 <malloc+0x910>
    26ae:	00004097          	auipc	ra,0x4
    26b2:	864080e7          	jalr	-1948(ra) # 5f12 <printf>
    exit(1);
    26b6:	4505                	li	a0,1
    26b8:	00003097          	auipc	ra,0x3
    26bc:	4b2080e7          	jalr	1202(ra) # 5b6a <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    26c0:	86aa                	mv	a3,a0
    26c2:	8626                	mv	a2,s1
    26c4:	85a6                	mv	a1,s1
    26c6:	00004517          	auipc	a0,0x4
    26ca:	23a50513          	addi	a0,a0,570 # 6900 <malloc+0x930>
    26ce:	00004097          	auipc	ra,0x4
    26d2:	844080e7          	jalr	-1980(ra) # 5f12 <printf>
    exit(1);
    26d6:	4505                	li	a0,1
    26d8:	00003097          	auipc	ra,0x3
    26dc:	492080e7          	jalr	1170(ra) # 5b6a <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    26e0:	567d                	li	a2,-1
    26e2:	85a6                	mv	a1,s1
    26e4:	00004517          	auipc	a0,0x4
    26e8:	24450513          	addi	a0,a0,580 # 6928 <malloc+0x958>
    26ec:	00004097          	auipc	ra,0x4
    26f0:	826080e7          	jalr	-2010(ra) # 5f12 <printf>
    exit(1);
    26f4:	4505                	li	a0,1
    26f6:	00003097          	auipc	ra,0x3
    26fa:	474080e7          	jalr	1140(ra) # 5b6a <exit>

00000000000026fe <rwsbrk>:
{
    26fe:	1101                	addi	sp,sp,-32
    2700:	ec06                	sd	ra,24(sp)
    2702:	e822                	sd	s0,16(sp)
    2704:	e426                	sd	s1,8(sp)
    2706:	e04a                	sd	s2,0(sp)
    2708:	1000                	addi	s0,sp,32
  uint64 a = (uint64)sbrk(8192);
    270a:	6509                	lui	a0,0x2
    270c:	00003097          	auipc	ra,0x3
    2710:	4e6080e7          	jalr	1254(ra) # 5bf2 <sbrk>
  if (a == 0xffffffffffffffffLL)
    2714:	57fd                	li	a5,-1
    2716:	06f50363          	beq	a0,a5,277c <rwsbrk+0x7e>
    271a:	84aa                	mv	s1,a0
  if ((uint64)sbrk(-8192) == 0xffffffffffffffffLL)
    271c:	7579                	lui	a0,0xffffe
    271e:	00003097          	auipc	ra,0x3
    2722:	4d4080e7          	jalr	1236(ra) # 5bf2 <sbrk>
    2726:	57fd                	li	a5,-1
    2728:	06f50763          	beq	a0,a5,2796 <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE | O_WRONLY);
    272c:	20100593          	li	a1,513
    2730:	00004517          	auipc	a0,0x4
    2734:	72850513          	addi	a0,a0,1832 # 6e58 <malloc+0xe88>
    2738:	00003097          	auipc	ra,0x3
    273c:	472080e7          	jalr	1138(ra) # 5baa <open>
    2740:	892a                	mv	s2,a0
  if (fd < 0)
    2742:	06054763          	bltz	a0,27b0 <rwsbrk+0xb2>
  n = write(fd, (void *)(a + 4096), 1024);
    2746:	6505                	lui	a0,0x1
    2748:	94aa                	add	s1,s1,a0
    274a:	40000613          	li	a2,1024
    274e:	85a6                	mv	a1,s1
    2750:	854a                	mv	a0,s2
    2752:	00003097          	auipc	ra,0x3
    2756:	438080e7          	jalr	1080(ra) # 5b8a <write>
    275a:	862a                	mv	a2,a0
  if (n >= 0)
    275c:	06054763          	bltz	a0,27ca <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a + 4096, n);
    2760:	85a6                	mv	a1,s1
    2762:	00004517          	auipc	a0,0x4
    2766:	71650513          	addi	a0,a0,1814 # 6e78 <malloc+0xea8>
    276a:	00003097          	auipc	ra,0x3
    276e:	7a8080e7          	jalr	1960(ra) # 5f12 <printf>
    exit(1);
    2772:	4505                	li	a0,1
    2774:	00003097          	auipc	ra,0x3
    2778:	3f6080e7          	jalr	1014(ra) # 5b6a <exit>
    printf("sbrk(rwsbrk) failed\n");
    277c:	00004517          	auipc	a0,0x4
    2780:	6a450513          	addi	a0,a0,1700 # 6e20 <malloc+0xe50>
    2784:	00003097          	auipc	ra,0x3
    2788:	78e080e7          	jalr	1934(ra) # 5f12 <printf>
    exit(1);
    278c:	4505                	li	a0,1
    278e:	00003097          	auipc	ra,0x3
    2792:	3dc080e7          	jalr	988(ra) # 5b6a <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    2796:	00004517          	auipc	a0,0x4
    279a:	6a250513          	addi	a0,a0,1698 # 6e38 <malloc+0xe68>
    279e:	00003097          	auipc	ra,0x3
    27a2:	774080e7          	jalr	1908(ra) # 5f12 <printf>
    exit(1);
    27a6:	4505                	li	a0,1
    27a8:	00003097          	auipc	ra,0x3
    27ac:	3c2080e7          	jalr	962(ra) # 5b6a <exit>
    printf("open(rwsbrk) failed\n");
    27b0:	00004517          	auipc	a0,0x4
    27b4:	6b050513          	addi	a0,a0,1712 # 6e60 <malloc+0xe90>
    27b8:	00003097          	auipc	ra,0x3
    27bc:	75a080e7          	jalr	1882(ra) # 5f12 <printf>
    exit(1);
    27c0:	4505                	li	a0,1
    27c2:	00003097          	auipc	ra,0x3
    27c6:	3a8080e7          	jalr	936(ra) # 5b6a <exit>
  close(fd);
    27ca:	854a                	mv	a0,s2
    27cc:	00003097          	auipc	ra,0x3
    27d0:	3c6080e7          	jalr	966(ra) # 5b92 <close>
  unlink("rwsbrk");
    27d4:	00004517          	auipc	a0,0x4
    27d8:	68450513          	addi	a0,a0,1668 # 6e58 <malloc+0xe88>
    27dc:	00003097          	auipc	ra,0x3
    27e0:	3de080e7          	jalr	990(ra) # 5bba <unlink>
  fd = open("README", O_RDONLY);
    27e4:	4581                	li	a1,0
    27e6:	00004517          	auipc	a0,0x4
    27ea:	b0a50513          	addi	a0,a0,-1270 # 62f0 <malloc+0x320>
    27ee:	00003097          	auipc	ra,0x3
    27f2:	3bc080e7          	jalr	956(ra) # 5baa <open>
    27f6:	892a                	mv	s2,a0
  if (fd < 0)
    27f8:	02054963          	bltz	a0,282a <rwsbrk+0x12c>
  n = read(fd, (void *)(a + 4096), 10);
    27fc:	4629                	li	a2,10
    27fe:	85a6                	mv	a1,s1
    2800:	00003097          	auipc	ra,0x3
    2804:	382080e7          	jalr	898(ra) # 5b82 <read>
    2808:	862a                	mv	a2,a0
  if (n >= 0)
    280a:	02054d63          	bltz	a0,2844 <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a + 4096, n);
    280e:	85a6                	mv	a1,s1
    2810:	00004517          	auipc	a0,0x4
    2814:	69850513          	addi	a0,a0,1688 # 6ea8 <malloc+0xed8>
    2818:	00003097          	auipc	ra,0x3
    281c:	6fa080e7          	jalr	1786(ra) # 5f12 <printf>
    exit(1);
    2820:	4505                	li	a0,1
    2822:	00003097          	auipc	ra,0x3
    2826:	348080e7          	jalr	840(ra) # 5b6a <exit>
    printf("open(rwsbrk) failed\n");
    282a:	00004517          	auipc	a0,0x4
    282e:	63650513          	addi	a0,a0,1590 # 6e60 <malloc+0xe90>
    2832:	00003097          	auipc	ra,0x3
    2836:	6e0080e7          	jalr	1760(ra) # 5f12 <printf>
    exit(1);
    283a:	4505                	li	a0,1
    283c:	00003097          	auipc	ra,0x3
    2840:	32e080e7          	jalr	814(ra) # 5b6a <exit>
  close(fd);
    2844:	854a                	mv	a0,s2
    2846:	00003097          	auipc	ra,0x3
    284a:	34c080e7          	jalr	844(ra) # 5b92 <close>
  exit(0);
    284e:	4501                	li	a0,0
    2850:	00003097          	auipc	ra,0x3
    2854:	31a080e7          	jalr	794(ra) # 5b6a <exit>

0000000000002858 <sbrkbasic>:
{
    2858:	7139                	addi	sp,sp,-64
    285a:	fc06                	sd	ra,56(sp)
    285c:	f822                	sd	s0,48(sp)
    285e:	f426                	sd	s1,40(sp)
    2860:	f04a                	sd	s2,32(sp)
    2862:	ec4e                	sd	s3,24(sp)
    2864:	e852                	sd	s4,16(sp)
    2866:	0080                	addi	s0,sp,64
    2868:	8a2a                	mv	s4,a0
  pid = fork();
    286a:	00003097          	auipc	ra,0x3
    286e:	2f8080e7          	jalr	760(ra) # 5b62 <fork>
  if (pid < 0)
    2872:	02054c63          	bltz	a0,28aa <sbrkbasic+0x52>
  if (pid == 0)
    2876:	ed21                	bnez	a0,28ce <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    2878:	40000537          	lui	a0,0x40000
    287c:	00003097          	auipc	ra,0x3
    2880:	376080e7          	jalr	886(ra) # 5bf2 <sbrk>
    if (a == (char *)0xffffffffffffffffL)
    2884:	57fd                	li	a5,-1
    2886:	02f50f63          	beq	a0,a5,28c4 <sbrkbasic+0x6c>
    for (b = a; b < a + TOOMUCH; b += 4096)
    288a:	400007b7          	lui	a5,0x40000
    288e:	97aa                	add	a5,a5,a0
      *b = 99;
    2890:	06300693          	li	a3,99
    for (b = a; b < a + TOOMUCH; b += 4096)
    2894:	6705                	lui	a4,0x1
      *b = 99;
    2896:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0388>
    for (b = a; b < a + TOOMUCH; b += 4096)
    289a:	953a                	add	a0,a0,a4
    289c:	fef51de3          	bne	a0,a5,2896 <sbrkbasic+0x3e>
    exit(1);
    28a0:	4505                	li	a0,1
    28a2:	00003097          	auipc	ra,0x3
    28a6:	2c8080e7          	jalr	712(ra) # 5b6a <exit>
    printf("fork failed in sbrkbasic\n");
    28aa:	00004517          	auipc	a0,0x4
    28ae:	62650513          	addi	a0,a0,1574 # 6ed0 <malloc+0xf00>
    28b2:	00003097          	auipc	ra,0x3
    28b6:	660080e7          	jalr	1632(ra) # 5f12 <printf>
    exit(1);
    28ba:	4505                	li	a0,1
    28bc:	00003097          	auipc	ra,0x3
    28c0:	2ae080e7          	jalr	686(ra) # 5b6a <exit>
      exit(0);
    28c4:	4501                	li	a0,0
    28c6:	00003097          	auipc	ra,0x3
    28ca:	2a4080e7          	jalr	676(ra) # 5b6a <exit>
  wait(&xstatus);
    28ce:	fcc40513          	addi	a0,s0,-52
    28d2:	00003097          	auipc	ra,0x3
    28d6:	2a0080e7          	jalr	672(ra) # 5b72 <wait>
  if (xstatus == 1)
    28da:	fcc42703          	lw	a4,-52(s0)
    28de:	4785                	li	a5,1
    28e0:	00f70d63          	beq	a4,a5,28fa <sbrkbasic+0xa2>
  a = sbrk(0);
    28e4:	4501                	li	a0,0
    28e6:	00003097          	auipc	ra,0x3
    28ea:	30c080e7          	jalr	780(ra) # 5bf2 <sbrk>
    28ee:	84aa                	mv	s1,a0
  for (i = 0; i < 5000; i++)
    28f0:	4901                	li	s2,0
    28f2:	6985                	lui	s3,0x1
    28f4:	38898993          	addi	s3,s3,904 # 1388 <badarg+0x2a>
    28f8:	a005                	j	2918 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    28fa:	85d2                	mv	a1,s4
    28fc:	00004517          	auipc	a0,0x4
    2900:	5f450513          	addi	a0,a0,1524 # 6ef0 <malloc+0xf20>
    2904:	00003097          	auipc	ra,0x3
    2908:	60e080e7          	jalr	1550(ra) # 5f12 <printf>
    exit(1);
    290c:	4505                	li	a0,1
    290e:	00003097          	auipc	ra,0x3
    2912:	25c080e7          	jalr	604(ra) # 5b6a <exit>
    a = b + 1;
    2916:	84be                	mv	s1,a5
    b = sbrk(1);
    2918:	4505                	li	a0,1
    291a:	00003097          	auipc	ra,0x3
    291e:	2d8080e7          	jalr	728(ra) # 5bf2 <sbrk>
    if (b != a)
    2922:	04951c63          	bne	a0,s1,297a <sbrkbasic+0x122>
    *b = 1;
    2926:	4785                	li	a5,1
    2928:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    292c:	00148793          	addi	a5,s1,1
  for (i = 0; i < 5000; i++)
    2930:	2905                	addiw	s2,s2,1
    2932:	ff3912e3          	bne	s2,s3,2916 <sbrkbasic+0xbe>
  pid = fork();
    2936:	00003097          	auipc	ra,0x3
    293a:	22c080e7          	jalr	556(ra) # 5b62 <fork>
    293e:	892a                	mv	s2,a0
  if (pid < 0)
    2940:	04054e63          	bltz	a0,299c <sbrkbasic+0x144>
  c = sbrk(1);
    2944:	4505                	li	a0,1
    2946:	00003097          	auipc	ra,0x3
    294a:	2ac080e7          	jalr	684(ra) # 5bf2 <sbrk>
  c = sbrk(1);
    294e:	4505                	li	a0,1
    2950:	00003097          	auipc	ra,0x3
    2954:	2a2080e7          	jalr	674(ra) # 5bf2 <sbrk>
  if (c != a + 1)
    2958:	0489                	addi	s1,s1,2
    295a:	04a48f63          	beq	s1,a0,29b8 <sbrkbasic+0x160>
    printf("%s: sbrk test failed post-fork\n", s);
    295e:	85d2                	mv	a1,s4
    2960:	00004517          	auipc	a0,0x4
    2964:	5f050513          	addi	a0,a0,1520 # 6f50 <malloc+0xf80>
    2968:	00003097          	auipc	ra,0x3
    296c:	5aa080e7          	jalr	1450(ra) # 5f12 <printf>
    exit(1);
    2970:	4505                	li	a0,1
    2972:	00003097          	auipc	ra,0x3
    2976:	1f8080e7          	jalr	504(ra) # 5b6a <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    297a:	872a                	mv	a4,a0
    297c:	86a6                	mv	a3,s1
    297e:	864a                	mv	a2,s2
    2980:	85d2                	mv	a1,s4
    2982:	00004517          	auipc	a0,0x4
    2986:	58e50513          	addi	a0,a0,1422 # 6f10 <malloc+0xf40>
    298a:	00003097          	auipc	ra,0x3
    298e:	588080e7          	jalr	1416(ra) # 5f12 <printf>
      exit(1);
    2992:	4505                	li	a0,1
    2994:	00003097          	auipc	ra,0x3
    2998:	1d6080e7          	jalr	470(ra) # 5b6a <exit>
    printf("%s: sbrk test fork failed\n", s);
    299c:	85d2                	mv	a1,s4
    299e:	00004517          	auipc	a0,0x4
    29a2:	59250513          	addi	a0,a0,1426 # 6f30 <malloc+0xf60>
    29a6:	00003097          	auipc	ra,0x3
    29aa:	56c080e7          	jalr	1388(ra) # 5f12 <printf>
    exit(1);
    29ae:	4505                	li	a0,1
    29b0:	00003097          	auipc	ra,0x3
    29b4:	1ba080e7          	jalr	442(ra) # 5b6a <exit>
  if (pid == 0)
    29b8:	00091763          	bnez	s2,29c6 <sbrkbasic+0x16e>
    exit(0);
    29bc:	4501                	li	a0,0
    29be:	00003097          	auipc	ra,0x3
    29c2:	1ac080e7          	jalr	428(ra) # 5b6a <exit>
  wait(&xstatus);
    29c6:	fcc40513          	addi	a0,s0,-52
    29ca:	00003097          	auipc	ra,0x3
    29ce:	1a8080e7          	jalr	424(ra) # 5b72 <wait>
  exit(xstatus);
    29d2:	fcc42503          	lw	a0,-52(s0)
    29d6:	00003097          	auipc	ra,0x3
    29da:	194080e7          	jalr	404(ra) # 5b6a <exit>

00000000000029de <sbrkmuch>:
{
    29de:	7179                	addi	sp,sp,-48
    29e0:	f406                	sd	ra,40(sp)
    29e2:	f022                	sd	s0,32(sp)
    29e4:	ec26                	sd	s1,24(sp)
    29e6:	e84a                	sd	s2,16(sp)
    29e8:	e44e                	sd	s3,8(sp)
    29ea:	e052                	sd	s4,0(sp)
    29ec:	1800                	addi	s0,sp,48
    29ee:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    29f0:	4501                	li	a0,0
    29f2:	00003097          	auipc	ra,0x3
    29f6:	200080e7          	jalr	512(ra) # 5bf2 <sbrk>
    29fa:	892a                	mv	s2,a0
  a = sbrk(0);
    29fc:	4501                	li	a0,0
    29fe:	00003097          	auipc	ra,0x3
    2a02:	1f4080e7          	jalr	500(ra) # 5bf2 <sbrk>
    2a06:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2a08:	06400537          	lui	a0,0x6400
    2a0c:	9d05                	subw	a0,a0,s1
    2a0e:	00003097          	auipc	ra,0x3
    2a12:	1e4080e7          	jalr	484(ra) # 5bf2 <sbrk>
  if (p != a)
    2a16:	0ca49863          	bne	s1,a0,2ae6 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2a1a:	4501                	li	a0,0
    2a1c:	00003097          	auipc	ra,0x3
    2a20:	1d6080e7          	jalr	470(ra) # 5bf2 <sbrk>
    2a24:	87aa                	mv	a5,a0
  for (char *pp = a; pp < eee; pp += 4096)
    2a26:	00a4f963          	bgeu	s1,a0,2a38 <sbrkmuch+0x5a>
    *pp = 1;
    2a2a:	4685                	li	a3,1
  for (char *pp = a; pp < eee; pp += 4096)
    2a2c:	6705                	lui	a4,0x1
    *pp = 1;
    2a2e:	00d48023          	sb	a3,0(s1)
  for (char *pp = a; pp < eee; pp += 4096)
    2a32:	94ba                	add	s1,s1,a4
    2a34:	fef4ede3          	bltu	s1,a5,2a2e <sbrkmuch+0x50>
  *lastaddr = 99;
    2a38:	064007b7          	lui	a5,0x6400
    2a3c:	06300713          	li	a4,99
    2a40:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0387>
  a = sbrk(0);
    2a44:	4501                	li	a0,0
    2a46:	00003097          	auipc	ra,0x3
    2a4a:	1ac080e7          	jalr	428(ra) # 5bf2 <sbrk>
    2a4e:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2a50:	757d                	lui	a0,0xfffff
    2a52:	00003097          	auipc	ra,0x3
    2a56:	1a0080e7          	jalr	416(ra) # 5bf2 <sbrk>
  if (c == (char *)0xffffffffffffffffL)
    2a5a:	57fd                	li	a5,-1
    2a5c:	0af50363          	beq	a0,a5,2b02 <sbrkmuch+0x124>
  c = sbrk(0);
    2a60:	4501                	li	a0,0
    2a62:	00003097          	auipc	ra,0x3
    2a66:	190080e7          	jalr	400(ra) # 5bf2 <sbrk>
  if (c != a - PGSIZE)
    2a6a:	77fd                	lui	a5,0xfffff
    2a6c:	97a6                	add	a5,a5,s1
    2a6e:	0af51863          	bne	a0,a5,2b1e <sbrkmuch+0x140>
  a = sbrk(0);
    2a72:	4501                	li	a0,0
    2a74:	00003097          	auipc	ra,0x3
    2a78:	17e080e7          	jalr	382(ra) # 5bf2 <sbrk>
    2a7c:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2a7e:	6505                	lui	a0,0x1
    2a80:	00003097          	auipc	ra,0x3
    2a84:	172080e7          	jalr	370(ra) # 5bf2 <sbrk>
    2a88:	8a2a                	mv	s4,a0
  if (c != a || sbrk(0) != a + PGSIZE)
    2a8a:	0aa49a63          	bne	s1,a0,2b3e <sbrkmuch+0x160>
    2a8e:	4501                	li	a0,0
    2a90:	00003097          	auipc	ra,0x3
    2a94:	162080e7          	jalr	354(ra) # 5bf2 <sbrk>
    2a98:	6785                	lui	a5,0x1
    2a9a:	97a6                	add	a5,a5,s1
    2a9c:	0af51163          	bne	a0,a5,2b3e <sbrkmuch+0x160>
  if (*lastaddr == 99)
    2aa0:	064007b7          	lui	a5,0x6400
    2aa4:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0387>
    2aa8:	06300793          	li	a5,99
    2aac:	0af70963          	beq	a4,a5,2b5e <sbrkmuch+0x180>
  a = sbrk(0);
    2ab0:	4501                	li	a0,0
    2ab2:	00003097          	auipc	ra,0x3
    2ab6:	140080e7          	jalr	320(ra) # 5bf2 <sbrk>
    2aba:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2abc:	4501                	li	a0,0
    2abe:	00003097          	auipc	ra,0x3
    2ac2:	134080e7          	jalr	308(ra) # 5bf2 <sbrk>
    2ac6:	40a9053b          	subw	a0,s2,a0
    2aca:	00003097          	auipc	ra,0x3
    2ace:	128080e7          	jalr	296(ra) # 5bf2 <sbrk>
  if (c != a)
    2ad2:	0aa49463          	bne	s1,a0,2b7a <sbrkmuch+0x19c>
}
    2ad6:	70a2                	ld	ra,40(sp)
    2ad8:	7402                	ld	s0,32(sp)
    2ada:	64e2                	ld	s1,24(sp)
    2adc:	6942                	ld	s2,16(sp)
    2ade:	69a2                	ld	s3,8(sp)
    2ae0:	6a02                	ld	s4,0(sp)
    2ae2:	6145                	addi	sp,sp,48
    2ae4:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2ae6:	85ce                	mv	a1,s3
    2ae8:	00004517          	auipc	a0,0x4
    2aec:	48850513          	addi	a0,a0,1160 # 6f70 <malloc+0xfa0>
    2af0:	00003097          	auipc	ra,0x3
    2af4:	422080e7          	jalr	1058(ra) # 5f12 <printf>
    exit(1);
    2af8:	4505                	li	a0,1
    2afa:	00003097          	auipc	ra,0x3
    2afe:	070080e7          	jalr	112(ra) # 5b6a <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2b02:	85ce                	mv	a1,s3
    2b04:	00004517          	auipc	a0,0x4
    2b08:	4b450513          	addi	a0,a0,1204 # 6fb8 <malloc+0xfe8>
    2b0c:	00003097          	auipc	ra,0x3
    2b10:	406080e7          	jalr	1030(ra) # 5f12 <printf>
    exit(1);
    2b14:	4505                	li	a0,1
    2b16:	00003097          	auipc	ra,0x3
    2b1a:	054080e7          	jalr	84(ra) # 5b6a <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2b1e:	86aa                	mv	a3,a0
    2b20:	8626                	mv	a2,s1
    2b22:	85ce                	mv	a1,s3
    2b24:	00004517          	auipc	a0,0x4
    2b28:	4b450513          	addi	a0,a0,1204 # 6fd8 <malloc+0x1008>
    2b2c:	00003097          	auipc	ra,0x3
    2b30:	3e6080e7          	jalr	998(ra) # 5f12 <printf>
    exit(1);
    2b34:	4505                	li	a0,1
    2b36:	00003097          	auipc	ra,0x3
    2b3a:	034080e7          	jalr	52(ra) # 5b6a <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2b3e:	86d2                	mv	a3,s4
    2b40:	8626                	mv	a2,s1
    2b42:	85ce                	mv	a1,s3
    2b44:	00004517          	auipc	a0,0x4
    2b48:	4d450513          	addi	a0,a0,1236 # 7018 <malloc+0x1048>
    2b4c:	00003097          	auipc	ra,0x3
    2b50:	3c6080e7          	jalr	966(ra) # 5f12 <printf>
    exit(1);
    2b54:	4505                	li	a0,1
    2b56:	00003097          	auipc	ra,0x3
    2b5a:	014080e7          	jalr	20(ra) # 5b6a <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2b5e:	85ce                	mv	a1,s3
    2b60:	00004517          	auipc	a0,0x4
    2b64:	4e850513          	addi	a0,a0,1256 # 7048 <malloc+0x1078>
    2b68:	00003097          	auipc	ra,0x3
    2b6c:	3aa080e7          	jalr	938(ra) # 5f12 <printf>
    exit(1);
    2b70:	4505                	li	a0,1
    2b72:	00003097          	auipc	ra,0x3
    2b76:	ff8080e7          	jalr	-8(ra) # 5b6a <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2b7a:	86aa                	mv	a3,a0
    2b7c:	8626                	mv	a2,s1
    2b7e:	85ce                	mv	a1,s3
    2b80:	00004517          	auipc	a0,0x4
    2b84:	50050513          	addi	a0,a0,1280 # 7080 <malloc+0x10b0>
    2b88:	00003097          	auipc	ra,0x3
    2b8c:	38a080e7          	jalr	906(ra) # 5f12 <printf>
    exit(1);
    2b90:	4505                	li	a0,1
    2b92:	00003097          	auipc	ra,0x3
    2b96:	fd8080e7          	jalr	-40(ra) # 5b6a <exit>

0000000000002b9a <sbrkarg>:
{
    2b9a:	7179                	addi	sp,sp,-48
    2b9c:	f406                	sd	ra,40(sp)
    2b9e:	f022                	sd	s0,32(sp)
    2ba0:	ec26                	sd	s1,24(sp)
    2ba2:	e84a                	sd	s2,16(sp)
    2ba4:	e44e                	sd	s3,8(sp)
    2ba6:	1800                	addi	s0,sp,48
    2ba8:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2baa:	6505                	lui	a0,0x1
    2bac:	00003097          	auipc	ra,0x3
    2bb0:	046080e7          	jalr	70(ra) # 5bf2 <sbrk>
    2bb4:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE | O_WRONLY);
    2bb6:	20100593          	li	a1,513
    2bba:	00004517          	auipc	a0,0x4
    2bbe:	4ee50513          	addi	a0,a0,1262 # 70a8 <malloc+0x10d8>
    2bc2:	00003097          	auipc	ra,0x3
    2bc6:	fe8080e7          	jalr	-24(ra) # 5baa <open>
    2bca:	84aa                	mv	s1,a0
  unlink("sbrk");
    2bcc:	00004517          	auipc	a0,0x4
    2bd0:	4dc50513          	addi	a0,a0,1244 # 70a8 <malloc+0x10d8>
    2bd4:	00003097          	auipc	ra,0x3
    2bd8:	fe6080e7          	jalr	-26(ra) # 5bba <unlink>
  if (fd < 0)
    2bdc:	0404c163          	bltz	s1,2c1e <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0)
    2be0:	6605                	lui	a2,0x1
    2be2:	85ca                	mv	a1,s2
    2be4:	8526                	mv	a0,s1
    2be6:	00003097          	auipc	ra,0x3
    2bea:	fa4080e7          	jalr	-92(ra) # 5b8a <write>
    2bee:	04054663          	bltz	a0,2c3a <sbrkarg+0xa0>
  close(fd);
    2bf2:	8526                	mv	a0,s1
    2bf4:	00003097          	auipc	ra,0x3
    2bf8:	f9e080e7          	jalr	-98(ra) # 5b92 <close>
  a = sbrk(PGSIZE);
    2bfc:	6505                	lui	a0,0x1
    2bfe:	00003097          	auipc	ra,0x3
    2c02:	ff4080e7          	jalr	-12(ra) # 5bf2 <sbrk>
  if (pipe((int *)a) != 0)
    2c06:	00003097          	auipc	ra,0x3
    2c0a:	f74080e7          	jalr	-140(ra) # 5b7a <pipe>
    2c0e:	e521                	bnez	a0,2c56 <sbrkarg+0xbc>
}
    2c10:	70a2                	ld	ra,40(sp)
    2c12:	7402                	ld	s0,32(sp)
    2c14:	64e2                	ld	s1,24(sp)
    2c16:	6942                	ld	s2,16(sp)
    2c18:	69a2                	ld	s3,8(sp)
    2c1a:	6145                	addi	sp,sp,48
    2c1c:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2c1e:	85ce                	mv	a1,s3
    2c20:	00004517          	auipc	a0,0x4
    2c24:	49050513          	addi	a0,a0,1168 # 70b0 <malloc+0x10e0>
    2c28:	00003097          	auipc	ra,0x3
    2c2c:	2ea080e7          	jalr	746(ra) # 5f12 <printf>
    exit(1);
    2c30:	4505                	li	a0,1
    2c32:	00003097          	auipc	ra,0x3
    2c36:	f38080e7          	jalr	-200(ra) # 5b6a <exit>
    printf("%s: write sbrk failed\n", s);
    2c3a:	85ce                	mv	a1,s3
    2c3c:	00004517          	auipc	a0,0x4
    2c40:	48c50513          	addi	a0,a0,1164 # 70c8 <malloc+0x10f8>
    2c44:	00003097          	auipc	ra,0x3
    2c48:	2ce080e7          	jalr	718(ra) # 5f12 <printf>
    exit(1);
    2c4c:	4505                	li	a0,1
    2c4e:	00003097          	auipc	ra,0x3
    2c52:	f1c080e7          	jalr	-228(ra) # 5b6a <exit>
    printf("%s: pipe() failed\n", s);
    2c56:	85ce                	mv	a1,s3
    2c58:	00004517          	auipc	a0,0x4
    2c5c:	e5050513          	addi	a0,a0,-432 # 6aa8 <malloc+0xad8>
    2c60:	00003097          	auipc	ra,0x3
    2c64:	2b2080e7          	jalr	690(ra) # 5f12 <printf>
    exit(1);
    2c68:	4505                	li	a0,1
    2c6a:	00003097          	auipc	ra,0x3
    2c6e:	f00080e7          	jalr	-256(ra) # 5b6a <exit>

0000000000002c72 <argptest>:
{
    2c72:	1101                	addi	sp,sp,-32
    2c74:	ec06                	sd	ra,24(sp)
    2c76:	e822                	sd	s0,16(sp)
    2c78:	e426                	sd	s1,8(sp)
    2c7a:	e04a                	sd	s2,0(sp)
    2c7c:	1000                	addi	s0,sp,32
    2c7e:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2c80:	4581                	li	a1,0
    2c82:	00004517          	auipc	a0,0x4
    2c86:	45e50513          	addi	a0,a0,1118 # 70e0 <malloc+0x1110>
    2c8a:	00003097          	auipc	ra,0x3
    2c8e:	f20080e7          	jalr	-224(ra) # 5baa <open>
  if (fd < 0)
    2c92:	02054b63          	bltz	a0,2cc8 <argptest+0x56>
    2c96:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2c98:	4501                	li	a0,0
    2c9a:	00003097          	auipc	ra,0x3
    2c9e:	f58080e7          	jalr	-168(ra) # 5bf2 <sbrk>
    2ca2:	567d                	li	a2,-1
    2ca4:	fff50593          	addi	a1,a0,-1
    2ca8:	8526                	mv	a0,s1
    2caa:	00003097          	auipc	ra,0x3
    2cae:	ed8080e7          	jalr	-296(ra) # 5b82 <read>
  close(fd);
    2cb2:	8526                	mv	a0,s1
    2cb4:	00003097          	auipc	ra,0x3
    2cb8:	ede080e7          	jalr	-290(ra) # 5b92 <close>
}
    2cbc:	60e2                	ld	ra,24(sp)
    2cbe:	6442                	ld	s0,16(sp)
    2cc0:	64a2                	ld	s1,8(sp)
    2cc2:	6902                	ld	s2,0(sp)
    2cc4:	6105                	addi	sp,sp,32
    2cc6:	8082                	ret
    printf("%s: open failed\n", s);
    2cc8:	85ca                	mv	a1,s2
    2cca:	00004517          	auipc	a0,0x4
    2cce:	cee50513          	addi	a0,a0,-786 # 69b8 <malloc+0x9e8>
    2cd2:	00003097          	auipc	ra,0x3
    2cd6:	240080e7          	jalr	576(ra) # 5f12 <printf>
    exit(1);
    2cda:	4505                	li	a0,1
    2cdc:	00003097          	auipc	ra,0x3
    2ce0:	e8e080e7          	jalr	-370(ra) # 5b6a <exit>

0000000000002ce4 <sbrkbugs>:
{
    2ce4:	1141                	addi	sp,sp,-16
    2ce6:	e406                	sd	ra,8(sp)
    2ce8:	e022                	sd	s0,0(sp)
    2cea:	0800                	addi	s0,sp,16
  int pid = fork();
    2cec:	00003097          	auipc	ra,0x3
    2cf0:	e76080e7          	jalr	-394(ra) # 5b62 <fork>
  if (pid < 0)
    2cf4:	02054263          	bltz	a0,2d18 <sbrkbugs+0x34>
  if (pid == 0)
    2cf8:	ed0d                	bnez	a0,2d32 <sbrkbugs+0x4e>
    int sz = (uint64)sbrk(0);
    2cfa:	00003097          	auipc	ra,0x3
    2cfe:	ef8080e7          	jalr	-264(ra) # 5bf2 <sbrk>
    sbrk(-sz);
    2d02:	40a0053b          	negw	a0,a0
    2d06:	00003097          	auipc	ra,0x3
    2d0a:	eec080e7          	jalr	-276(ra) # 5bf2 <sbrk>
    exit(0);
    2d0e:	4501                	li	a0,0
    2d10:	00003097          	auipc	ra,0x3
    2d14:	e5a080e7          	jalr	-422(ra) # 5b6a <exit>
    printf("fork failed\n");
    2d18:	00004517          	auipc	a0,0x4
    2d1c:	09050513          	addi	a0,a0,144 # 6da8 <malloc+0xdd8>
    2d20:	00003097          	auipc	ra,0x3
    2d24:	1f2080e7          	jalr	498(ra) # 5f12 <printf>
    exit(1);
    2d28:	4505                	li	a0,1
    2d2a:	00003097          	auipc	ra,0x3
    2d2e:	e40080e7          	jalr	-448(ra) # 5b6a <exit>
  wait(0);
    2d32:	4501                	li	a0,0
    2d34:	00003097          	auipc	ra,0x3
    2d38:	e3e080e7          	jalr	-450(ra) # 5b72 <wait>
  pid = fork();
    2d3c:	00003097          	auipc	ra,0x3
    2d40:	e26080e7          	jalr	-474(ra) # 5b62 <fork>
  if (pid < 0)
    2d44:	02054563          	bltz	a0,2d6e <sbrkbugs+0x8a>
  if (pid == 0)
    2d48:	e121                	bnez	a0,2d88 <sbrkbugs+0xa4>
    int sz = (uint64)sbrk(0);
    2d4a:	00003097          	auipc	ra,0x3
    2d4e:	ea8080e7          	jalr	-344(ra) # 5bf2 <sbrk>
    sbrk(-(sz - 3500));
    2d52:	6785                	lui	a5,0x1
    2d54:	dac7879b          	addiw	a5,a5,-596
    2d58:	40a7853b          	subw	a0,a5,a0
    2d5c:	00003097          	auipc	ra,0x3
    2d60:	e96080e7          	jalr	-362(ra) # 5bf2 <sbrk>
    exit(0);
    2d64:	4501                	li	a0,0
    2d66:	00003097          	auipc	ra,0x3
    2d6a:	e04080e7          	jalr	-508(ra) # 5b6a <exit>
    printf("fork failed\n");
    2d6e:	00004517          	auipc	a0,0x4
    2d72:	03a50513          	addi	a0,a0,58 # 6da8 <malloc+0xdd8>
    2d76:	00003097          	auipc	ra,0x3
    2d7a:	19c080e7          	jalr	412(ra) # 5f12 <printf>
    exit(1);
    2d7e:	4505                	li	a0,1
    2d80:	00003097          	auipc	ra,0x3
    2d84:	dea080e7          	jalr	-534(ra) # 5b6a <exit>
  wait(0);
    2d88:	4501                	li	a0,0
    2d8a:	00003097          	auipc	ra,0x3
    2d8e:	de8080e7          	jalr	-536(ra) # 5b72 <wait>
  pid = fork();
    2d92:	00003097          	auipc	ra,0x3
    2d96:	dd0080e7          	jalr	-560(ra) # 5b62 <fork>
  if (pid < 0)
    2d9a:	02054a63          	bltz	a0,2dce <sbrkbugs+0xea>
  if (pid == 0)
    2d9e:	e529                	bnez	a0,2de8 <sbrkbugs+0x104>
    sbrk((10 * 4096 + 2048) - (uint64)sbrk(0));
    2da0:	00003097          	auipc	ra,0x3
    2da4:	e52080e7          	jalr	-430(ra) # 5bf2 <sbrk>
    2da8:	67ad                	lui	a5,0xb
    2daa:	8007879b          	addiw	a5,a5,-2048
    2dae:	40a7853b          	subw	a0,a5,a0
    2db2:	00003097          	auipc	ra,0x3
    2db6:	e40080e7          	jalr	-448(ra) # 5bf2 <sbrk>
    sbrk(-10);
    2dba:	5559                	li	a0,-10
    2dbc:	00003097          	auipc	ra,0x3
    2dc0:	e36080e7          	jalr	-458(ra) # 5bf2 <sbrk>
    exit(0);
    2dc4:	4501                	li	a0,0
    2dc6:	00003097          	auipc	ra,0x3
    2dca:	da4080e7          	jalr	-604(ra) # 5b6a <exit>
    printf("fork failed\n");
    2dce:	00004517          	auipc	a0,0x4
    2dd2:	fda50513          	addi	a0,a0,-38 # 6da8 <malloc+0xdd8>
    2dd6:	00003097          	auipc	ra,0x3
    2dda:	13c080e7          	jalr	316(ra) # 5f12 <printf>
    exit(1);
    2dde:	4505                	li	a0,1
    2de0:	00003097          	auipc	ra,0x3
    2de4:	d8a080e7          	jalr	-630(ra) # 5b6a <exit>
  wait(0);
    2de8:	4501                	li	a0,0
    2dea:	00003097          	auipc	ra,0x3
    2dee:	d88080e7          	jalr	-632(ra) # 5b72 <wait>
  exit(0);
    2df2:	4501                	li	a0,0
    2df4:	00003097          	auipc	ra,0x3
    2df8:	d76080e7          	jalr	-650(ra) # 5b6a <exit>

0000000000002dfc <sbrklast>:
{
    2dfc:	7179                	addi	sp,sp,-48
    2dfe:	f406                	sd	ra,40(sp)
    2e00:	f022                	sd	s0,32(sp)
    2e02:	ec26                	sd	s1,24(sp)
    2e04:	e84a                	sd	s2,16(sp)
    2e06:	e44e                	sd	s3,8(sp)
    2e08:	e052                	sd	s4,0(sp)
    2e0a:	1800                	addi	s0,sp,48
  uint64 top = (uint64)sbrk(0);
    2e0c:	4501                	li	a0,0
    2e0e:	00003097          	auipc	ra,0x3
    2e12:	de4080e7          	jalr	-540(ra) # 5bf2 <sbrk>
  if ((top % 4096) != 0)
    2e16:	03451793          	slli	a5,a0,0x34
    2e1a:	ebd9                	bnez	a5,2eb0 <sbrklast+0xb4>
  sbrk(4096);
    2e1c:	6505                	lui	a0,0x1
    2e1e:	00003097          	auipc	ra,0x3
    2e22:	dd4080e7          	jalr	-556(ra) # 5bf2 <sbrk>
  sbrk(10);
    2e26:	4529                	li	a0,10
    2e28:	00003097          	auipc	ra,0x3
    2e2c:	dca080e7          	jalr	-566(ra) # 5bf2 <sbrk>
  sbrk(-20);
    2e30:	5531                	li	a0,-20
    2e32:	00003097          	auipc	ra,0x3
    2e36:	dc0080e7          	jalr	-576(ra) # 5bf2 <sbrk>
  top = (uint64)sbrk(0);
    2e3a:	4501                	li	a0,0
    2e3c:	00003097          	auipc	ra,0x3
    2e40:	db6080e7          	jalr	-586(ra) # 5bf2 <sbrk>
    2e44:	84aa                	mv	s1,a0
  char *p = (char *)(top - 64);
    2e46:	fc050913          	addi	s2,a0,-64 # fc0 <linktest+0xb8>
  p[0] = 'x';
    2e4a:	07800a13          	li	s4,120
    2e4e:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2e52:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR | O_CREATE);
    2e56:	20200593          	li	a1,514
    2e5a:	854a                	mv	a0,s2
    2e5c:	00003097          	auipc	ra,0x3
    2e60:	d4e080e7          	jalr	-690(ra) # 5baa <open>
    2e64:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2e66:	4605                	li	a2,1
    2e68:	85ca                	mv	a1,s2
    2e6a:	00003097          	auipc	ra,0x3
    2e6e:	d20080e7          	jalr	-736(ra) # 5b8a <write>
  close(fd);
    2e72:	854e                	mv	a0,s3
    2e74:	00003097          	auipc	ra,0x3
    2e78:	d1e080e7          	jalr	-738(ra) # 5b92 <close>
  fd = open(p, O_RDWR);
    2e7c:	4589                	li	a1,2
    2e7e:	854a                	mv	a0,s2
    2e80:	00003097          	auipc	ra,0x3
    2e84:	d2a080e7          	jalr	-726(ra) # 5baa <open>
  p[0] = '\0';
    2e88:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2e8c:	4605                	li	a2,1
    2e8e:	85ca                	mv	a1,s2
    2e90:	00003097          	auipc	ra,0x3
    2e94:	cf2080e7          	jalr	-782(ra) # 5b82 <read>
  if (p[0] != 'x')
    2e98:	fc04c783          	lbu	a5,-64(s1)
    2e9c:	03479463          	bne	a5,s4,2ec4 <sbrklast+0xc8>
}
    2ea0:	70a2                	ld	ra,40(sp)
    2ea2:	7402                	ld	s0,32(sp)
    2ea4:	64e2                	ld	s1,24(sp)
    2ea6:	6942                	ld	s2,16(sp)
    2ea8:	69a2                	ld	s3,8(sp)
    2eaa:	6a02                	ld	s4,0(sp)
    2eac:	6145                	addi	sp,sp,48
    2eae:	8082                	ret
    sbrk(4096 - (top % 4096));
    2eb0:	0347d513          	srli	a0,a5,0x34
    2eb4:	6785                	lui	a5,0x1
    2eb6:	40a7853b          	subw	a0,a5,a0
    2eba:	00003097          	auipc	ra,0x3
    2ebe:	d38080e7          	jalr	-712(ra) # 5bf2 <sbrk>
    2ec2:	bfa9                	j	2e1c <sbrklast+0x20>
    exit(1);
    2ec4:	4505                	li	a0,1
    2ec6:	00003097          	auipc	ra,0x3
    2eca:	ca4080e7          	jalr	-860(ra) # 5b6a <exit>

0000000000002ece <sbrk8000>:
{
    2ece:	1141                	addi	sp,sp,-16
    2ed0:	e406                	sd	ra,8(sp)
    2ed2:	e022                	sd	s0,0(sp)
    2ed4:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2ed6:	80000537          	lui	a0,0x80000
    2eda:	0511                	addi	a0,a0,4
    2edc:	00003097          	auipc	ra,0x3
    2ee0:	d16080e7          	jalr	-746(ra) # 5bf2 <sbrk>
  volatile char *top = sbrk(0);
    2ee4:	4501                	li	a0,0
    2ee6:	00003097          	auipc	ra,0x3
    2eea:	d0c080e7          	jalr	-756(ra) # 5bf2 <sbrk>
  *(top - 1) = *(top - 1) + 1;
    2eee:	fff54783          	lbu	a5,-1(a0) # ffffffff7fffffff <base+0xffffffff7fff0387>
    2ef2:	0785                	addi	a5,a5,1
    2ef4:	0ff7f793          	andi	a5,a5,255
    2ef8:	fef50fa3          	sb	a5,-1(a0)
}
    2efc:	60a2                	ld	ra,8(sp)
    2efe:	6402                	ld	s0,0(sp)
    2f00:	0141                	addi	sp,sp,16
    2f02:	8082                	ret

0000000000002f04 <execout>:
{
    2f04:	715d                	addi	sp,sp,-80
    2f06:	e486                	sd	ra,72(sp)
    2f08:	e0a2                	sd	s0,64(sp)
    2f0a:	fc26                	sd	s1,56(sp)
    2f0c:	f84a                	sd	s2,48(sp)
    2f0e:	f44e                	sd	s3,40(sp)
    2f10:	f052                	sd	s4,32(sp)
    2f12:	0880                	addi	s0,sp,80
  for (int avail = 0; avail < 15; avail++)
    2f14:	4901                	li	s2,0
    2f16:	49bd                	li	s3,15
    int pid = fork();
    2f18:	00003097          	auipc	ra,0x3
    2f1c:	c4a080e7          	jalr	-950(ra) # 5b62 <fork>
    2f20:	84aa                	mv	s1,a0
    if (pid < 0)
    2f22:	02054063          	bltz	a0,2f42 <execout+0x3e>
    else if (pid == 0)
    2f26:	c91d                	beqz	a0,2f5c <execout+0x58>
      wait((int *)0);
    2f28:	4501                	li	a0,0
    2f2a:	00003097          	auipc	ra,0x3
    2f2e:	c48080e7          	jalr	-952(ra) # 5b72 <wait>
  for (int avail = 0; avail < 15; avail++)
    2f32:	2905                	addiw	s2,s2,1
    2f34:	ff3912e3          	bne	s2,s3,2f18 <execout+0x14>
  exit(0);
    2f38:	4501                	li	a0,0
    2f3a:	00003097          	auipc	ra,0x3
    2f3e:	c30080e7          	jalr	-976(ra) # 5b6a <exit>
      printf("fork failed\n");
    2f42:	00004517          	auipc	a0,0x4
    2f46:	e6650513          	addi	a0,a0,-410 # 6da8 <malloc+0xdd8>
    2f4a:	00003097          	auipc	ra,0x3
    2f4e:	fc8080e7          	jalr	-56(ra) # 5f12 <printf>
      exit(1);
    2f52:	4505                	li	a0,1
    2f54:	00003097          	auipc	ra,0x3
    2f58:	c16080e7          	jalr	-1002(ra) # 5b6a <exit>
        if (a == 0xffffffffffffffffLL)
    2f5c:	59fd                	li	s3,-1
        *(char *)(a + 4096 - 1) = 1;
    2f5e:	4a05                	li	s4,1
        uint64 a = (uint64)sbrk(4096);
    2f60:	6505                	lui	a0,0x1
    2f62:	00003097          	auipc	ra,0x3
    2f66:	c90080e7          	jalr	-880(ra) # 5bf2 <sbrk>
        if (a == 0xffffffffffffffffLL)
    2f6a:	01350763          	beq	a0,s3,2f78 <execout+0x74>
        *(char *)(a + 4096 - 1) = 1;
    2f6e:	6785                	lui	a5,0x1
    2f70:	953e                	add	a0,a0,a5
    2f72:	ff450fa3          	sb	s4,-1(a0) # fff <linktest+0xf7>
      {
    2f76:	b7ed                	j	2f60 <execout+0x5c>
      for (int i = 0; i < avail; i++)
    2f78:	01205a63          	blez	s2,2f8c <execout+0x88>
        sbrk(-4096);
    2f7c:	757d                	lui	a0,0xfffff
    2f7e:	00003097          	auipc	ra,0x3
    2f82:	c74080e7          	jalr	-908(ra) # 5bf2 <sbrk>
      for (int i = 0; i < avail; i++)
    2f86:	2485                	addiw	s1,s1,1
    2f88:	ff249ae3          	bne	s1,s2,2f7c <execout+0x78>
      close(1);
    2f8c:	4505                	li	a0,1
    2f8e:	00003097          	auipc	ra,0x3
    2f92:	c04080e7          	jalr	-1020(ra) # 5b92 <close>
      char *args[] = {"echo", "x", 0};
    2f96:	00003517          	auipc	a0,0x3
    2f9a:	18250513          	addi	a0,a0,386 # 6118 <malloc+0x148>
    2f9e:	faa43c23          	sd	a0,-72(s0)
    2fa2:	00003797          	auipc	a5,0x3
    2fa6:	1e678793          	addi	a5,a5,486 # 6188 <malloc+0x1b8>
    2faa:	fcf43023          	sd	a5,-64(s0)
    2fae:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2fb2:	fb840593          	addi	a1,s0,-72
    2fb6:	00003097          	auipc	ra,0x3
    2fba:	bec080e7          	jalr	-1044(ra) # 5ba2 <exec>
      exit(0);
    2fbe:	4501                	li	a0,0
    2fc0:	00003097          	auipc	ra,0x3
    2fc4:	baa080e7          	jalr	-1110(ra) # 5b6a <exit>

0000000000002fc8 <fourteen>:
{
    2fc8:	1101                	addi	sp,sp,-32
    2fca:	ec06                	sd	ra,24(sp)
    2fcc:	e822                	sd	s0,16(sp)
    2fce:	e426                	sd	s1,8(sp)
    2fd0:	1000                	addi	s0,sp,32
    2fd2:	84aa                	mv	s1,a0
  if (mkdir("12345678901234") != 0)
    2fd4:	00004517          	auipc	a0,0x4
    2fd8:	2e450513          	addi	a0,a0,740 # 72b8 <malloc+0x12e8>
    2fdc:	00003097          	auipc	ra,0x3
    2fe0:	bf6080e7          	jalr	-1034(ra) # 5bd2 <mkdir>
    2fe4:	e165                	bnez	a0,30c4 <fourteen+0xfc>
  if (mkdir("12345678901234/123456789012345") != 0)
    2fe6:	00004517          	auipc	a0,0x4
    2fea:	12a50513          	addi	a0,a0,298 # 7110 <malloc+0x1140>
    2fee:	00003097          	auipc	ra,0x3
    2ff2:	be4080e7          	jalr	-1052(ra) # 5bd2 <mkdir>
    2ff6:	e56d                	bnez	a0,30e0 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2ff8:	20000593          	li	a1,512
    2ffc:	00004517          	auipc	a0,0x4
    3000:	16c50513          	addi	a0,a0,364 # 7168 <malloc+0x1198>
    3004:	00003097          	auipc	ra,0x3
    3008:	ba6080e7          	jalr	-1114(ra) # 5baa <open>
  if (fd < 0)
    300c:	0e054863          	bltz	a0,30fc <fourteen+0x134>
  close(fd);
    3010:	00003097          	auipc	ra,0x3
    3014:	b82080e7          	jalr	-1150(ra) # 5b92 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    3018:	4581                	li	a1,0
    301a:	00004517          	auipc	a0,0x4
    301e:	1c650513          	addi	a0,a0,454 # 71e0 <malloc+0x1210>
    3022:	00003097          	auipc	ra,0x3
    3026:	b88080e7          	jalr	-1144(ra) # 5baa <open>
  if (fd < 0)
    302a:	0e054763          	bltz	a0,3118 <fourteen+0x150>
  close(fd);
    302e:	00003097          	auipc	ra,0x3
    3032:	b64080e7          	jalr	-1180(ra) # 5b92 <close>
  if (mkdir("12345678901234/12345678901234") == 0)
    3036:	00004517          	auipc	a0,0x4
    303a:	21a50513          	addi	a0,a0,538 # 7250 <malloc+0x1280>
    303e:	00003097          	auipc	ra,0x3
    3042:	b94080e7          	jalr	-1132(ra) # 5bd2 <mkdir>
    3046:	c57d                	beqz	a0,3134 <fourteen+0x16c>
  if (mkdir("123456789012345/12345678901234") == 0)
    3048:	00004517          	auipc	a0,0x4
    304c:	26050513          	addi	a0,a0,608 # 72a8 <malloc+0x12d8>
    3050:	00003097          	auipc	ra,0x3
    3054:	b82080e7          	jalr	-1150(ra) # 5bd2 <mkdir>
    3058:	cd65                	beqz	a0,3150 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    305a:	00004517          	auipc	a0,0x4
    305e:	24e50513          	addi	a0,a0,590 # 72a8 <malloc+0x12d8>
    3062:	00003097          	auipc	ra,0x3
    3066:	b58080e7          	jalr	-1192(ra) # 5bba <unlink>
  unlink("12345678901234/12345678901234");
    306a:	00004517          	auipc	a0,0x4
    306e:	1e650513          	addi	a0,a0,486 # 7250 <malloc+0x1280>
    3072:	00003097          	auipc	ra,0x3
    3076:	b48080e7          	jalr	-1208(ra) # 5bba <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    307a:	00004517          	auipc	a0,0x4
    307e:	16650513          	addi	a0,a0,358 # 71e0 <malloc+0x1210>
    3082:	00003097          	auipc	ra,0x3
    3086:	b38080e7          	jalr	-1224(ra) # 5bba <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    308a:	00004517          	auipc	a0,0x4
    308e:	0de50513          	addi	a0,a0,222 # 7168 <malloc+0x1198>
    3092:	00003097          	auipc	ra,0x3
    3096:	b28080e7          	jalr	-1240(ra) # 5bba <unlink>
  unlink("12345678901234/123456789012345");
    309a:	00004517          	auipc	a0,0x4
    309e:	07650513          	addi	a0,a0,118 # 7110 <malloc+0x1140>
    30a2:	00003097          	auipc	ra,0x3
    30a6:	b18080e7          	jalr	-1256(ra) # 5bba <unlink>
  unlink("12345678901234");
    30aa:	00004517          	auipc	a0,0x4
    30ae:	20e50513          	addi	a0,a0,526 # 72b8 <malloc+0x12e8>
    30b2:	00003097          	auipc	ra,0x3
    30b6:	b08080e7          	jalr	-1272(ra) # 5bba <unlink>
}
    30ba:	60e2                	ld	ra,24(sp)
    30bc:	6442                	ld	s0,16(sp)
    30be:	64a2                	ld	s1,8(sp)
    30c0:	6105                	addi	sp,sp,32
    30c2:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    30c4:	85a6                	mv	a1,s1
    30c6:	00004517          	auipc	a0,0x4
    30ca:	02250513          	addi	a0,a0,34 # 70e8 <malloc+0x1118>
    30ce:	00003097          	auipc	ra,0x3
    30d2:	e44080e7          	jalr	-444(ra) # 5f12 <printf>
    exit(1);
    30d6:	4505                	li	a0,1
    30d8:	00003097          	auipc	ra,0x3
    30dc:	a92080e7          	jalr	-1390(ra) # 5b6a <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    30e0:	85a6                	mv	a1,s1
    30e2:	00004517          	auipc	a0,0x4
    30e6:	04e50513          	addi	a0,a0,78 # 7130 <malloc+0x1160>
    30ea:	00003097          	auipc	ra,0x3
    30ee:	e28080e7          	jalr	-472(ra) # 5f12 <printf>
    exit(1);
    30f2:	4505                	li	a0,1
    30f4:	00003097          	auipc	ra,0x3
    30f8:	a76080e7          	jalr	-1418(ra) # 5b6a <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    30fc:	85a6                	mv	a1,s1
    30fe:	00004517          	auipc	a0,0x4
    3102:	09a50513          	addi	a0,a0,154 # 7198 <malloc+0x11c8>
    3106:	00003097          	auipc	ra,0x3
    310a:	e0c080e7          	jalr	-500(ra) # 5f12 <printf>
    exit(1);
    310e:	4505                	li	a0,1
    3110:	00003097          	auipc	ra,0x3
    3114:	a5a080e7          	jalr	-1446(ra) # 5b6a <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    3118:	85a6                	mv	a1,s1
    311a:	00004517          	auipc	a0,0x4
    311e:	0f650513          	addi	a0,a0,246 # 7210 <malloc+0x1240>
    3122:	00003097          	auipc	ra,0x3
    3126:	df0080e7          	jalr	-528(ra) # 5f12 <printf>
    exit(1);
    312a:	4505                	li	a0,1
    312c:	00003097          	auipc	ra,0x3
    3130:	a3e080e7          	jalr	-1474(ra) # 5b6a <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    3134:	85a6                	mv	a1,s1
    3136:	00004517          	auipc	a0,0x4
    313a:	13a50513          	addi	a0,a0,314 # 7270 <malloc+0x12a0>
    313e:	00003097          	auipc	ra,0x3
    3142:	dd4080e7          	jalr	-556(ra) # 5f12 <printf>
    exit(1);
    3146:	4505                	li	a0,1
    3148:	00003097          	auipc	ra,0x3
    314c:	a22080e7          	jalr	-1502(ra) # 5b6a <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    3150:	85a6                	mv	a1,s1
    3152:	00004517          	auipc	a0,0x4
    3156:	17650513          	addi	a0,a0,374 # 72c8 <malloc+0x12f8>
    315a:	00003097          	auipc	ra,0x3
    315e:	db8080e7          	jalr	-584(ra) # 5f12 <printf>
    exit(1);
    3162:	4505                	li	a0,1
    3164:	00003097          	auipc	ra,0x3
    3168:	a06080e7          	jalr	-1530(ra) # 5b6a <exit>

000000000000316c <diskfull>:
{
    316c:	b9010113          	addi	sp,sp,-1136
    3170:	46113423          	sd	ra,1128(sp)
    3174:	46813023          	sd	s0,1120(sp)
    3178:	44913c23          	sd	s1,1112(sp)
    317c:	45213823          	sd	s2,1104(sp)
    3180:	45313423          	sd	s3,1096(sp)
    3184:	45413023          	sd	s4,1088(sp)
    3188:	43513c23          	sd	s5,1080(sp)
    318c:	43613823          	sd	s6,1072(sp)
    3190:	43713423          	sd	s7,1064(sp)
    3194:	43813023          	sd	s8,1056(sp)
    3198:	47010413          	addi	s0,sp,1136
    319c:	8c2a                	mv	s8,a0
  unlink("diskfulldir");
    319e:	00004517          	auipc	a0,0x4
    31a2:	16250513          	addi	a0,a0,354 # 7300 <malloc+0x1330>
    31a6:	00003097          	auipc	ra,0x3
    31aa:	a14080e7          	jalr	-1516(ra) # 5bba <unlink>
  for (fi = 0; done == 0; fi++)
    31ae:	4a01                	li	s4,0
    name[0] = 'b';
    31b0:	06200b13          	li	s6,98
    name[1] = 'i';
    31b4:	06900a93          	li	s5,105
    name[2] = 'g';
    31b8:	06700993          	li	s3,103
    31bc:	10c00b93          	li	s7,268
    31c0:	aabd                	j	333e <diskfull+0x1d2>
      printf("%s: could not create file %s\n", s, name);
    31c2:	b9040613          	addi	a2,s0,-1136
    31c6:	85e2                	mv	a1,s8
    31c8:	00004517          	auipc	a0,0x4
    31cc:	14850513          	addi	a0,a0,328 # 7310 <malloc+0x1340>
    31d0:	00003097          	auipc	ra,0x3
    31d4:	d42080e7          	jalr	-702(ra) # 5f12 <printf>
      break;
    31d8:	a821                	j	31f0 <diskfull+0x84>
        close(fd);
    31da:	854a                	mv	a0,s2
    31dc:	00003097          	auipc	ra,0x3
    31e0:	9b6080e7          	jalr	-1610(ra) # 5b92 <close>
    close(fd);
    31e4:	854a                	mv	a0,s2
    31e6:	00003097          	auipc	ra,0x3
    31ea:	9ac080e7          	jalr	-1620(ra) # 5b92 <close>
  for (fi = 0; done == 0; fi++)
    31ee:	2a05                	addiw	s4,s4,1
  for (int i = 0; i < nzz; i++)
    31f0:	4481                	li	s1,0
    name[0] = 'z';
    31f2:	07a00913          	li	s2,122
  for (int i = 0; i < nzz; i++)
    31f6:	08000993          	li	s3,128
    name[0] = 'z';
    31fa:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    31fe:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    3202:	41f4d79b          	sraiw	a5,s1,0x1f
    3206:	01b7d71b          	srliw	a4,a5,0x1b
    320a:	009707bb          	addw	a5,a4,s1
    320e:	4057d69b          	sraiw	a3,a5,0x5
    3212:	0306869b          	addiw	a3,a3,48
    3216:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    321a:	8bfd                	andi	a5,a5,31
    321c:	9f99                	subw	a5,a5,a4
    321e:	0307879b          	addiw	a5,a5,48
    3222:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3226:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    322a:	bb040513          	addi	a0,s0,-1104
    322e:	00003097          	auipc	ra,0x3
    3232:	98c080e7          	jalr	-1652(ra) # 5bba <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    3236:	60200593          	li	a1,1538
    323a:	bb040513          	addi	a0,s0,-1104
    323e:	00003097          	auipc	ra,0x3
    3242:	96c080e7          	jalr	-1684(ra) # 5baa <open>
    if (fd < 0)
    3246:	00054963          	bltz	a0,3258 <diskfull+0xec>
    close(fd);
    324a:	00003097          	auipc	ra,0x3
    324e:	948080e7          	jalr	-1720(ra) # 5b92 <close>
  for (int i = 0; i < nzz; i++)
    3252:	2485                	addiw	s1,s1,1
    3254:	fb3493e3          	bne	s1,s3,31fa <diskfull+0x8e>
  if (mkdir("diskfulldir") == 0)
    3258:	00004517          	auipc	a0,0x4
    325c:	0a850513          	addi	a0,a0,168 # 7300 <malloc+0x1330>
    3260:	00003097          	auipc	ra,0x3
    3264:	972080e7          	jalr	-1678(ra) # 5bd2 <mkdir>
    3268:	12050963          	beqz	a0,339a <diskfull+0x22e>
  unlink("diskfulldir");
    326c:	00004517          	auipc	a0,0x4
    3270:	09450513          	addi	a0,a0,148 # 7300 <malloc+0x1330>
    3274:	00003097          	auipc	ra,0x3
    3278:	946080e7          	jalr	-1722(ra) # 5bba <unlink>
  for (int i = 0; i < nzz; i++)
    327c:	4481                	li	s1,0
    name[0] = 'z';
    327e:	07a00913          	li	s2,122
  for (int i = 0; i < nzz; i++)
    3282:	08000993          	li	s3,128
    name[0] = 'z';
    3286:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    328a:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    328e:	41f4d79b          	sraiw	a5,s1,0x1f
    3292:	01b7d71b          	srliw	a4,a5,0x1b
    3296:	009707bb          	addw	a5,a4,s1
    329a:	4057d69b          	sraiw	a3,a5,0x5
    329e:	0306869b          	addiw	a3,a3,48
    32a2:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    32a6:	8bfd                	andi	a5,a5,31
    32a8:	9f99                	subw	a5,a5,a4
    32aa:	0307879b          	addiw	a5,a5,48
    32ae:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    32b2:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    32b6:	bb040513          	addi	a0,s0,-1104
    32ba:	00003097          	auipc	ra,0x3
    32be:	900080e7          	jalr	-1792(ra) # 5bba <unlink>
  for (int i = 0; i < nzz; i++)
    32c2:	2485                	addiw	s1,s1,1
    32c4:	fd3491e3          	bne	s1,s3,3286 <diskfull+0x11a>
  for (int i = 0; i < fi; i++)
    32c8:	03405e63          	blez	s4,3304 <diskfull+0x198>
    32cc:	4481                	li	s1,0
    name[0] = 'b';
    32ce:	06200a93          	li	s5,98
    name[1] = 'i';
    32d2:	06900993          	li	s3,105
    name[2] = 'g';
    32d6:	06700913          	li	s2,103
    name[0] = 'b';
    32da:	bb540823          	sb	s5,-1104(s0)
    name[1] = 'i';
    32de:	bb3408a3          	sb	s3,-1103(s0)
    name[2] = 'g';
    32e2:	bb240923          	sb	s2,-1102(s0)
    name[3] = '0' + i;
    32e6:	0304879b          	addiw	a5,s1,48
    32ea:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    32ee:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    32f2:	bb040513          	addi	a0,s0,-1104
    32f6:	00003097          	auipc	ra,0x3
    32fa:	8c4080e7          	jalr	-1852(ra) # 5bba <unlink>
  for (int i = 0; i < fi; i++)
    32fe:	2485                	addiw	s1,s1,1
    3300:	fd449de3          	bne	s1,s4,32da <diskfull+0x16e>
}
    3304:	46813083          	ld	ra,1128(sp)
    3308:	46013403          	ld	s0,1120(sp)
    330c:	45813483          	ld	s1,1112(sp)
    3310:	45013903          	ld	s2,1104(sp)
    3314:	44813983          	ld	s3,1096(sp)
    3318:	44013a03          	ld	s4,1088(sp)
    331c:	43813a83          	ld	s5,1080(sp)
    3320:	43013b03          	ld	s6,1072(sp)
    3324:	42813b83          	ld	s7,1064(sp)
    3328:	42013c03          	ld	s8,1056(sp)
    332c:	47010113          	addi	sp,sp,1136
    3330:	8082                	ret
    close(fd);
    3332:	854a                	mv	a0,s2
    3334:	00003097          	auipc	ra,0x3
    3338:	85e080e7          	jalr	-1954(ra) # 5b92 <close>
  for (fi = 0; done == 0; fi++)
    333c:	2a05                	addiw	s4,s4,1
    name[0] = 'b';
    333e:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    3342:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    3346:	b9340923          	sb	s3,-1134(s0)
    name[3] = '0' + fi;
    334a:	030a079b          	addiw	a5,s4,48
    334e:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    3352:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    3356:	b9040513          	addi	a0,s0,-1136
    335a:	00003097          	auipc	ra,0x3
    335e:	860080e7          	jalr	-1952(ra) # 5bba <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    3362:	60200593          	li	a1,1538
    3366:	b9040513          	addi	a0,s0,-1136
    336a:	00003097          	auipc	ra,0x3
    336e:	840080e7          	jalr	-1984(ra) # 5baa <open>
    3372:	892a                	mv	s2,a0
    if (fd < 0)
    3374:	e40547e3          	bltz	a0,31c2 <diskfull+0x56>
    3378:	84de                	mv	s1,s7
      if (write(fd, buf, BSIZE) != BSIZE)
    337a:	40000613          	li	a2,1024
    337e:	bb040593          	addi	a1,s0,-1104
    3382:	854a                	mv	a0,s2
    3384:	00003097          	auipc	ra,0x3
    3388:	806080e7          	jalr	-2042(ra) # 5b8a <write>
    338c:	40000793          	li	a5,1024
    3390:	e4f515e3          	bne	a0,a5,31da <diskfull+0x6e>
    for (int i = 0; i < MAXFILE; i++)
    3394:	34fd                	addiw	s1,s1,-1
    3396:	f0f5                	bnez	s1,337a <diskfull+0x20e>
    3398:	bf69                	j	3332 <diskfull+0x1c6>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    339a:	00004517          	auipc	a0,0x4
    339e:	f9650513          	addi	a0,a0,-106 # 7330 <malloc+0x1360>
    33a2:	00003097          	auipc	ra,0x3
    33a6:	b70080e7          	jalr	-1168(ra) # 5f12 <printf>
    33aa:	b5c9                	j	326c <diskfull+0x100>

00000000000033ac <iputtest>:
{
    33ac:	1101                	addi	sp,sp,-32
    33ae:	ec06                	sd	ra,24(sp)
    33b0:	e822                	sd	s0,16(sp)
    33b2:	e426                	sd	s1,8(sp)
    33b4:	1000                	addi	s0,sp,32
    33b6:	84aa                	mv	s1,a0
  if (mkdir("iputdir") < 0)
    33b8:	00004517          	auipc	a0,0x4
    33bc:	fa850513          	addi	a0,a0,-88 # 7360 <malloc+0x1390>
    33c0:	00003097          	auipc	ra,0x3
    33c4:	812080e7          	jalr	-2030(ra) # 5bd2 <mkdir>
    33c8:	04054563          	bltz	a0,3412 <iputtest+0x66>
  if (chdir("iputdir") < 0)
    33cc:	00004517          	auipc	a0,0x4
    33d0:	f9450513          	addi	a0,a0,-108 # 7360 <malloc+0x1390>
    33d4:	00003097          	auipc	ra,0x3
    33d8:	806080e7          	jalr	-2042(ra) # 5bda <chdir>
    33dc:	04054963          	bltz	a0,342e <iputtest+0x82>
  if (unlink("../iputdir") < 0)
    33e0:	00004517          	auipc	a0,0x4
    33e4:	fc050513          	addi	a0,a0,-64 # 73a0 <malloc+0x13d0>
    33e8:	00002097          	auipc	ra,0x2
    33ec:	7d2080e7          	jalr	2002(ra) # 5bba <unlink>
    33f0:	04054d63          	bltz	a0,344a <iputtest+0x9e>
  if (chdir("/") < 0)
    33f4:	00004517          	auipc	a0,0x4
    33f8:	fdc50513          	addi	a0,a0,-36 # 73d0 <malloc+0x1400>
    33fc:	00002097          	auipc	ra,0x2
    3400:	7de080e7          	jalr	2014(ra) # 5bda <chdir>
    3404:	06054163          	bltz	a0,3466 <iputtest+0xba>
}
    3408:	60e2                	ld	ra,24(sp)
    340a:	6442                	ld	s0,16(sp)
    340c:	64a2                	ld	s1,8(sp)
    340e:	6105                	addi	sp,sp,32
    3410:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3412:	85a6                	mv	a1,s1
    3414:	00004517          	auipc	a0,0x4
    3418:	f5450513          	addi	a0,a0,-172 # 7368 <malloc+0x1398>
    341c:	00003097          	auipc	ra,0x3
    3420:	af6080e7          	jalr	-1290(ra) # 5f12 <printf>
    exit(1);
    3424:	4505                	li	a0,1
    3426:	00002097          	auipc	ra,0x2
    342a:	744080e7          	jalr	1860(ra) # 5b6a <exit>
    printf("%s: chdir iputdir failed\n", s);
    342e:	85a6                	mv	a1,s1
    3430:	00004517          	auipc	a0,0x4
    3434:	f5050513          	addi	a0,a0,-176 # 7380 <malloc+0x13b0>
    3438:	00003097          	auipc	ra,0x3
    343c:	ada080e7          	jalr	-1318(ra) # 5f12 <printf>
    exit(1);
    3440:	4505                	li	a0,1
    3442:	00002097          	auipc	ra,0x2
    3446:	728080e7          	jalr	1832(ra) # 5b6a <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    344a:	85a6                	mv	a1,s1
    344c:	00004517          	auipc	a0,0x4
    3450:	f6450513          	addi	a0,a0,-156 # 73b0 <malloc+0x13e0>
    3454:	00003097          	auipc	ra,0x3
    3458:	abe080e7          	jalr	-1346(ra) # 5f12 <printf>
    exit(1);
    345c:	4505                	li	a0,1
    345e:	00002097          	auipc	ra,0x2
    3462:	70c080e7          	jalr	1804(ra) # 5b6a <exit>
    printf("%s: chdir / failed\n", s);
    3466:	85a6                	mv	a1,s1
    3468:	00004517          	auipc	a0,0x4
    346c:	f7050513          	addi	a0,a0,-144 # 73d8 <malloc+0x1408>
    3470:	00003097          	auipc	ra,0x3
    3474:	aa2080e7          	jalr	-1374(ra) # 5f12 <printf>
    exit(1);
    3478:	4505                	li	a0,1
    347a:	00002097          	auipc	ra,0x2
    347e:	6f0080e7          	jalr	1776(ra) # 5b6a <exit>

0000000000003482 <exitiputtest>:
{
    3482:	7179                	addi	sp,sp,-48
    3484:	f406                	sd	ra,40(sp)
    3486:	f022                	sd	s0,32(sp)
    3488:	ec26                	sd	s1,24(sp)
    348a:	1800                	addi	s0,sp,48
    348c:	84aa                	mv	s1,a0
  pid = fork();
    348e:	00002097          	auipc	ra,0x2
    3492:	6d4080e7          	jalr	1748(ra) # 5b62 <fork>
  if (pid < 0)
    3496:	04054663          	bltz	a0,34e2 <exitiputtest+0x60>
  if (pid == 0)
    349a:	ed45                	bnez	a0,3552 <exitiputtest+0xd0>
    if (mkdir("iputdir") < 0)
    349c:	00004517          	auipc	a0,0x4
    34a0:	ec450513          	addi	a0,a0,-316 # 7360 <malloc+0x1390>
    34a4:	00002097          	auipc	ra,0x2
    34a8:	72e080e7          	jalr	1838(ra) # 5bd2 <mkdir>
    34ac:	04054963          	bltz	a0,34fe <exitiputtest+0x7c>
    if (chdir("iputdir") < 0)
    34b0:	00004517          	auipc	a0,0x4
    34b4:	eb050513          	addi	a0,a0,-336 # 7360 <malloc+0x1390>
    34b8:	00002097          	auipc	ra,0x2
    34bc:	722080e7          	jalr	1826(ra) # 5bda <chdir>
    34c0:	04054d63          	bltz	a0,351a <exitiputtest+0x98>
    if (unlink("../iputdir") < 0)
    34c4:	00004517          	auipc	a0,0x4
    34c8:	edc50513          	addi	a0,a0,-292 # 73a0 <malloc+0x13d0>
    34cc:	00002097          	auipc	ra,0x2
    34d0:	6ee080e7          	jalr	1774(ra) # 5bba <unlink>
    34d4:	06054163          	bltz	a0,3536 <exitiputtest+0xb4>
    exit(0);
    34d8:	4501                	li	a0,0
    34da:	00002097          	auipc	ra,0x2
    34de:	690080e7          	jalr	1680(ra) # 5b6a <exit>
    printf("%s: fork failed\n", s);
    34e2:	85a6                	mv	a1,s1
    34e4:	00003517          	auipc	a0,0x3
    34e8:	4bc50513          	addi	a0,a0,1212 # 69a0 <malloc+0x9d0>
    34ec:	00003097          	auipc	ra,0x3
    34f0:	a26080e7          	jalr	-1498(ra) # 5f12 <printf>
    exit(1);
    34f4:	4505                	li	a0,1
    34f6:	00002097          	auipc	ra,0x2
    34fa:	674080e7          	jalr	1652(ra) # 5b6a <exit>
      printf("%s: mkdir failed\n", s);
    34fe:	85a6                	mv	a1,s1
    3500:	00004517          	auipc	a0,0x4
    3504:	e6850513          	addi	a0,a0,-408 # 7368 <malloc+0x1398>
    3508:	00003097          	auipc	ra,0x3
    350c:	a0a080e7          	jalr	-1526(ra) # 5f12 <printf>
      exit(1);
    3510:	4505                	li	a0,1
    3512:	00002097          	auipc	ra,0x2
    3516:	658080e7          	jalr	1624(ra) # 5b6a <exit>
      printf("%s: child chdir failed\n", s);
    351a:	85a6                	mv	a1,s1
    351c:	00004517          	auipc	a0,0x4
    3520:	ed450513          	addi	a0,a0,-300 # 73f0 <malloc+0x1420>
    3524:	00003097          	auipc	ra,0x3
    3528:	9ee080e7          	jalr	-1554(ra) # 5f12 <printf>
      exit(1);
    352c:	4505                	li	a0,1
    352e:	00002097          	auipc	ra,0x2
    3532:	63c080e7          	jalr	1596(ra) # 5b6a <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    3536:	85a6                	mv	a1,s1
    3538:	00004517          	auipc	a0,0x4
    353c:	e7850513          	addi	a0,a0,-392 # 73b0 <malloc+0x13e0>
    3540:	00003097          	auipc	ra,0x3
    3544:	9d2080e7          	jalr	-1582(ra) # 5f12 <printf>
      exit(1);
    3548:	4505                	li	a0,1
    354a:	00002097          	auipc	ra,0x2
    354e:	620080e7          	jalr	1568(ra) # 5b6a <exit>
  wait(&xstatus);
    3552:	fdc40513          	addi	a0,s0,-36
    3556:	00002097          	auipc	ra,0x2
    355a:	61c080e7          	jalr	1564(ra) # 5b72 <wait>
  exit(xstatus);
    355e:	fdc42503          	lw	a0,-36(s0)
    3562:	00002097          	auipc	ra,0x2
    3566:	608080e7          	jalr	1544(ra) # 5b6a <exit>

000000000000356a <dirtest>:
{
    356a:	1101                	addi	sp,sp,-32
    356c:	ec06                	sd	ra,24(sp)
    356e:	e822                	sd	s0,16(sp)
    3570:	e426                	sd	s1,8(sp)
    3572:	1000                	addi	s0,sp,32
    3574:	84aa                	mv	s1,a0
  if (mkdir("dir0") < 0)
    3576:	00004517          	auipc	a0,0x4
    357a:	e9250513          	addi	a0,a0,-366 # 7408 <malloc+0x1438>
    357e:	00002097          	auipc	ra,0x2
    3582:	654080e7          	jalr	1620(ra) # 5bd2 <mkdir>
    3586:	04054563          	bltz	a0,35d0 <dirtest+0x66>
  if (chdir("dir0") < 0)
    358a:	00004517          	auipc	a0,0x4
    358e:	e7e50513          	addi	a0,a0,-386 # 7408 <malloc+0x1438>
    3592:	00002097          	auipc	ra,0x2
    3596:	648080e7          	jalr	1608(ra) # 5bda <chdir>
    359a:	04054963          	bltz	a0,35ec <dirtest+0x82>
  if (chdir("..") < 0)
    359e:	00004517          	auipc	a0,0x4
    35a2:	e8a50513          	addi	a0,a0,-374 # 7428 <malloc+0x1458>
    35a6:	00002097          	auipc	ra,0x2
    35aa:	634080e7          	jalr	1588(ra) # 5bda <chdir>
    35ae:	04054d63          	bltz	a0,3608 <dirtest+0x9e>
  if (unlink("dir0") < 0)
    35b2:	00004517          	auipc	a0,0x4
    35b6:	e5650513          	addi	a0,a0,-426 # 7408 <malloc+0x1438>
    35ba:	00002097          	auipc	ra,0x2
    35be:	600080e7          	jalr	1536(ra) # 5bba <unlink>
    35c2:	06054163          	bltz	a0,3624 <dirtest+0xba>
}
    35c6:	60e2                	ld	ra,24(sp)
    35c8:	6442                	ld	s0,16(sp)
    35ca:	64a2                	ld	s1,8(sp)
    35cc:	6105                	addi	sp,sp,32
    35ce:	8082                	ret
    printf("%s: mkdir failed\n", s);
    35d0:	85a6                	mv	a1,s1
    35d2:	00004517          	auipc	a0,0x4
    35d6:	d9650513          	addi	a0,a0,-618 # 7368 <malloc+0x1398>
    35da:	00003097          	auipc	ra,0x3
    35de:	938080e7          	jalr	-1736(ra) # 5f12 <printf>
    exit(1);
    35e2:	4505                	li	a0,1
    35e4:	00002097          	auipc	ra,0x2
    35e8:	586080e7          	jalr	1414(ra) # 5b6a <exit>
    printf("%s: chdir dir0 failed\n", s);
    35ec:	85a6                	mv	a1,s1
    35ee:	00004517          	auipc	a0,0x4
    35f2:	e2250513          	addi	a0,a0,-478 # 7410 <malloc+0x1440>
    35f6:	00003097          	auipc	ra,0x3
    35fa:	91c080e7          	jalr	-1764(ra) # 5f12 <printf>
    exit(1);
    35fe:	4505                	li	a0,1
    3600:	00002097          	auipc	ra,0x2
    3604:	56a080e7          	jalr	1386(ra) # 5b6a <exit>
    printf("%s: chdir .. failed\n", s);
    3608:	85a6                	mv	a1,s1
    360a:	00004517          	auipc	a0,0x4
    360e:	e2650513          	addi	a0,a0,-474 # 7430 <malloc+0x1460>
    3612:	00003097          	auipc	ra,0x3
    3616:	900080e7          	jalr	-1792(ra) # 5f12 <printf>
    exit(1);
    361a:	4505                	li	a0,1
    361c:	00002097          	auipc	ra,0x2
    3620:	54e080e7          	jalr	1358(ra) # 5b6a <exit>
    printf("%s: unlink dir0 failed\n", s);
    3624:	85a6                	mv	a1,s1
    3626:	00004517          	auipc	a0,0x4
    362a:	e2250513          	addi	a0,a0,-478 # 7448 <malloc+0x1478>
    362e:	00003097          	auipc	ra,0x3
    3632:	8e4080e7          	jalr	-1820(ra) # 5f12 <printf>
    exit(1);
    3636:	4505                	li	a0,1
    3638:	00002097          	auipc	ra,0x2
    363c:	532080e7          	jalr	1330(ra) # 5b6a <exit>

0000000000003640 <subdir>:
{
    3640:	1101                	addi	sp,sp,-32
    3642:	ec06                	sd	ra,24(sp)
    3644:	e822                	sd	s0,16(sp)
    3646:	e426                	sd	s1,8(sp)
    3648:	e04a                	sd	s2,0(sp)
    364a:	1000                	addi	s0,sp,32
    364c:	892a                	mv	s2,a0
  unlink("ff");
    364e:	00004517          	auipc	a0,0x4
    3652:	f4250513          	addi	a0,a0,-190 # 7590 <malloc+0x15c0>
    3656:	00002097          	auipc	ra,0x2
    365a:	564080e7          	jalr	1380(ra) # 5bba <unlink>
  if (mkdir("dd") != 0)
    365e:	00004517          	auipc	a0,0x4
    3662:	e0250513          	addi	a0,a0,-510 # 7460 <malloc+0x1490>
    3666:	00002097          	auipc	ra,0x2
    366a:	56c080e7          	jalr	1388(ra) # 5bd2 <mkdir>
    366e:	38051663          	bnez	a0,39fa <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    3672:	20200593          	li	a1,514
    3676:	00004517          	auipc	a0,0x4
    367a:	e0a50513          	addi	a0,a0,-502 # 7480 <malloc+0x14b0>
    367e:	00002097          	auipc	ra,0x2
    3682:	52c080e7          	jalr	1324(ra) # 5baa <open>
    3686:	84aa                	mv	s1,a0
  if (fd < 0)
    3688:	38054763          	bltz	a0,3a16 <subdir+0x3d6>
  write(fd, "ff", 2);
    368c:	4609                	li	a2,2
    368e:	00004597          	auipc	a1,0x4
    3692:	f0258593          	addi	a1,a1,-254 # 7590 <malloc+0x15c0>
    3696:	00002097          	auipc	ra,0x2
    369a:	4f4080e7          	jalr	1268(ra) # 5b8a <write>
  close(fd);
    369e:	8526                	mv	a0,s1
    36a0:	00002097          	auipc	ra,0x2
    36a4:	4f2080e7          	jalr	1266(ra) # 5b92 <close>
  if (unlink("dd") >= 0)
    36a8:	00004517          	auipc	a0,0x4
    36ac:	db850513          	addi	a0,a0,-584 # 7460 <malloc+0x1490>
    36b0:	00002097          	auipc	ra,0x2
    36b4:	50a080e7          	jalr	1290(ra) # 5bba <unlink>
    36b8:	36055d63          	bgez	a0,3a32 <subdir+0x3f2>
  if (mkdir("/dd/dd") != 0)
    36bc:	00004517          	auipc	a0,0x4
    36c0:	e1c50513          	addi	a0,a0,-484 # 74d8 <malloc+0x1508>
    36c4:	00002097          	auipc	ra,0x2
    36c8:	50e080e7          	jalr	1294(ra) # 5bd2 <mkdir>
    36cc:	38051163          	bnez	a0,3a4e <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    36d0:	20200593          	li	a1,514
    36d4:	00004517          	auipc	a0,0x4
    36d8:	e2c50513          	addi	a0,a0,-468 # 7500 <malloc+0x1530>
    36dc:	00002097          	auipc	ra,0x2
    36e0:	4ce080e7          	jalr	1230(ra) # 5baa <open>
    36e4:	84aa                	mv	s1,a0
  if (fd < 0)
    36e6:	38054263          	bltz	a0,3a6a <subdir+0x42a>
  write(fd, "FF", 2);
    36ea:	4609                	li	a2,2
    36ec:	00004597          	auipc	a1,0x4
    36f0:	e4458593          	addi	a1,a1,-444 # 7530 <malloc+0x1560>
    36f4:	00002097          	auipc	ra,0x2
    36f8:	496080e7          	jalr	1174(ra) # 5b8a <write>
  close(fd);
    36fc:	8526                	mv	a0,s1
    36fe:	00002097          	auipc	ra,0x2
    3702:	494080e7          	jalr	1172(ra) # 5b92 <close>
  fd = open("dd/dd/../ff", 0);
    3706:	4581                	li	a1,0
    3708:	00004517          	auipc	a0,0x4
    370c:	e3050513          	addi	a0,a0,-464 # 7538 <malloc+0x1568>
    3710:	00002097          	auipc	ra,0x2
    3714:	49a080e7          	jalr	1178(ra) # 5baa <open>
    3718:	84aa                	mv	s1,a0
  if (fd < 0)
    371a:	36054663          	bltz	a0,3a86 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    371e:	660d                	lui	a2,0x3
    3720:	00009597          	auipc	a1,0x9
    3724:	55858593          	addi	a1,a1,1368 # cc78 <buf>
    3728:	00002097          	auipc	ra,0x2
    372c:	45a080e7          	jalr	1114(ra) # 5b82 <read>
  if (cc != 2 || buf[0] != 'f')
    3730:	4789                	li	a5,2
    3732:	36f51863          	bne	a0,a5,3aa2 <subdir+0x462>
    3736:	00009717          	auipc	a4,0x9
    373a:	54274703          	lbu	a4,1346(a4) # cc78 <buf>
    373e:	06600793          	li	a5,102
    3742:	36f71063          	bne	a4,a5,3aa2 <subdir+0x462>
  close(fd);
    3746:	8526                	mv	a0,s1
    3748:	00002097          	auipc	ra,0x2
    374c:	44a080e7          	jalr	1098(ra) # 5b92 <close>
  if (link("dd/dd/ff", "dd/dd/ffff") != 0)
    3750:	00004597          	auipc	a1,0x4
    3754:	e3858593          	addi	a1,a1,-456 # 7588 <malloc+0x15b8>
    3758:	00004517          	auipc	a0,0x4
    375c:	da850513          	addi	a0,a0,-600 # 7500 <malloc+0x1530>
    3760:	00002097          	auipc	ra,0x2
    3764:	46a080e7          	jalr	1130(ra) # 5bca <link>
    3768:	34051b63          	bnez	a0,3abe <subdir+0x47e>
  if (unlink("dd/dd/ff") != 0)
    376c:	00004517          	auipc	a0,0x4
    3770:	d9450513          	addi	a0,a0,-620 # 7500 <malloc+0x1530>
    3774:	00002097          	auipc	ra,0x2
    3778:	446080e7          	jalr	1094(ra) # 5bba <unlink>
    377c:	34051f63          	bnez	a0,3ada <subdir+0x49a>
  if (open("dd/dd/ff", O_RDONLY) >= 0)
    3780:	4581                	li	a1,0
    3782:	00004517          	auipc	a0,0x4
    3786:	d7e50513          	addi	a0,a0,-642 # 7500 <malloc+0x1530>
    378a:	00002097          	auipc	ra,0x2
    378e:	420080e7          	jalr	1056(ra) # 5baa <open>
    3792:	36055263          	bgez	a0,3af6 <subdir+0x4b6>
  if (chdir("dd") != 0)
    3796:	00004517          	auipc	a0,0x4
    379a:	cca50513          	addi	a0,a0,-822 # 7460 <malloc+0x1490>
    379e:	00002097          	auipc	ra,0x2
    37a2:	43c080e7          	jalr	1084(ra) # 5bda <chdir>
    37a6:	36051663          	bnez	a0,3b12 <subdir+0x4d2>
  if (chdir("dd/../../dd") != 0)
    37aa:	00004517          	auipc	a0,0x4
    37ae:	e7650513          	addi	a0,a0,-394 # 7620 <malloc+0x1650>
    37b2:	00002097          	auipc	ra,0x2
    37b6:	428080e7          	jalr	1064(ra) # 5bda <chdir>
    37ba:	36051a63          	bnez	a0,3b2e <subdir+0x4ee>
  if (chdir("dd/../../../dd") != 0)
    37be:	00004517          	auipc	a0,0x4
    37c2:	e9250513          	addi	a0,a0,-366 # 7650 <malloc+0x1680>
    37c6:	00002097          	auipc	ra,0x2
    37ca:	414080e7          	jalr	1044(ra) # 5bda <chdir>
    37ce:	36051e63          	bnez	a0,3b4a <subdir+0x50a>
  if (chdir("./..") != 0)
    37d2:	00004517          	auipc	a0,0x4
    37d6:	eae50513          	addi	a0,a0,-338 # 7680 <malloc+0x16b0>
    37da:	00002097          	auipc	ra,0x2
    37de:	400080e7          	jalr	1024(ra) # 5bda <chdir>
    37e2:	38051263          	bnez	a0,3b66 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    37e6:	4581                	li	a1,0
    37e8:	00004517          	auipc	a0,0x4
    37ec:	da050513          	addi	a0,a0,-608 # 7588 <malloc+0x15b8>
    37f0:	00002097          	auipc	ra,0x2
    37f4:	3ba080e7          	jalr	954(ra) # 5baa <open>
    37f8:	84aa                	mv	s1,a0
  if (fd < 0)
    37fa:	38054463          	bltz	a0,3b82 <subdir+0x542>
  if (read(fd, buf, sizeof(buf)) != 2)
    37fe:	660d                	lui	a2,0x3
    3800:	00009597          	auipc	a1,0x9
    3804:	47858593          	addi	a1,a1,1144 # cc78 <buf>
    3808:	00002097          	auipc	ra,0x2
    380c:	37a080e7          	jalr	890(ra) # 5b82 <read>
    3810:	4789                	li	a5,2
    3812:	38f51663          	bne	a0,a5,3b9e <subdir+0x55e>
  close(fd);
    3816:	8526                	mv	a0,s1
    3818:	00002097          	auipc	ra,0x2
    381c:	37a080e7          	jalr	890(ra) # 5b92 <close>
  if (open("dd/dd/ff", O_RDONLY) >= 0)
    3820:	4581                	li	a1,0
    3822:	00004517          	auipc	a0,0x4
    3826:	cde50513          	addi	a0,a0,-802 # 7500 <malloc+0x1530>
    382a:	00002097          	auipc	ra,0x2
    382e:	380080e7          	jalr	896(ra) # 5baa <open>
    3832:	38055463          	bgez	a0,3bba <subdir+0x57a>
  if (open("dd/ff/ff", O_CREATE | O_RDWR) >= 0)
    3836:	20200593          	li	a1,514
    383a:	00004517          	auipc	a0,0x4
    383e:	ed650513          	addi	a0,a0,-298 # 7710 <malloc+0x1740>
    3842:	00002097          	auipc	ra,0x2
    3846:	368080e7          	jalr	872(ra) # 5baa <open>
    384a:	38055663          	bgez	a0,3bd6 <subdir+0x596>
  if (open("dd/xx/ff", O_CREATE | O_RDWR) >= 0)
    384e:	20200593          	li	a1,514
    3852:	00004517          	auipc	a0,0x4
    3856:	eee50513          	addi	a0,a0,-274 # 7740 <malloc+0x1770>
    385a:	00002097          	auipc	ra,0x2
    385e:	350080e7          	jalr	848(ra) # 5baa <open>
    3862:	38055863          	bgez	a0,3bf2 <subdir+0x5b2>
  if (open("dd", O_CREATE) >= 0)
    3866:	20000593          	li	a1,512
    386a:	00004517          	auipc	a0,0x4
    386e:	bf650513          	addi	a0,a0,-1034 # 7460 <malloc+0x1490>
    3872:	00002097          	auipc	ra,0x2
    3876:	338080e7          	jalr	824(ra) # 5baa <open>
    387a:	38055a63          	bgez	a0,3c0e <subdir+0x5ce>
  if (open("dd", O_RDWR) >= 0)
    387e:	4589                	li	a1,2
    3880:	00004517          	auipc	a0,0x4
    3884:	be050513          	addi	a0,a0,-1056 # 7460 <malloc+0x1490>
    3888:	00002097          	auipc	ra,0x2
    388c:	322080e7          	jalr	802(ra) # 5baa <open>
    3890:	38055d63          	bgez	a0,3c2a <subdir+0x5ea>
  if (open("dd", O_WRONLY) >= 0)
    3894:	4585                	li	a1,1
    3896:	00004517          	auipc	a0,0x4
    389a:	bca50513          	addi	a0,a0,-1078 # 7460 <malloc+0x1490>
    389e:	00002097          	auipc	ra,0x2
    38a2:	30c080e7          	jalr	780(ra) # 5baa <open>
    38a6:	3a055063          	bgez	a0,3c46 <subdir+0x606>
  if (link("dd/ff/ff", "dd/dd/xx") == 0)
    38aa:	00004597          	auipc	a1,0x4
    38ae:	f2658593          	addi	a1,a1,-218 # 77d0 <malloc+0x1800>
    38b2:	00004517          	auipc	a0,0x4
    38b6:	e5e50513          	addi	a0,a0,-418 # 7710 <malloc+0x1740>
    38ba:	00002097          	auipc	ra,0x2
    38be:	310080e7          	jalr	784(ra) # 5bca <link>
    38c2:	3a050063          	beqz	a0,3c62 <subdir+0x622>
  if (link("dd/xx/ff", "dd/dd/xx") == 0)
    38c6:	00004597          	auipc	a1,0x4
    38ca:	f0a58593          	addi	a1,a1,-246 # 77d0 <malloc+0x1800>
    38ce:	00004517          	auipc	a0,0x4
    38d2:	e7250513          	addi	a0,a0,-398 # 7740 <malloc+0x1770>
    38d6:	00002097          	auipc	ra,0x2
    38da:	2f4080e7          	jalr	756(ra) # 5bca <link>
    38de:	3a050063          	beqz	a0,3c7e <subdir+0x63e>
  if (link("dd/ff", "dd/dd/ffff") == 0)
    38e2:	00004597          	auipc	a1,0x4
    38e6:	ca658593          	addi	a1,a1,-858 # 7588 <malloc+0x15b8>
    38ea:	00004517          	auipc	a0,0x4
    38ee:	b9650513          	addi	a0,a0,-1130 # 7480 <malloc+0x14b0>
    38f2:	00002097          	auipc	ra,0x2
    38f6:	2d8080e7          	jalr	728(ra) # 5bca <link>
    38fa:	3a050063          	beqz	a0,3c9a <subdir+0x65a>
  if (mkdir("dd/ff/ff") == 0)
    38fe:	00004517          	auipc	a0,0x4
    3902:	e1250513          	addi	a0,a0,-494 # 7710 <malloc+0x1740>
    3906:	00002097          	auipc	ra,0x2
    390a:	2cc080e7          	jalr	716(ra) # 5bd2 <mkdir>
    390e:	3a050463          	beqz	a0,3cb6 <subdir+0x676>
  if (mkdir("dd/xx/ff") == 0)
    3912:	00004517          	auipc	a0,0x4
    3916:	e2e50513          	addi	a0,a0,-466 # 7740 <malloc+0x1770>
    391a:	00002097          	auipc	ra,0x2
    391e:	2b8080e7          	jalr	696(ra) # 5bd2 <mkdir>
    3922:	3a050863          	beqz	a0,3cd2 <subdir+0x692>
  if (mkdir("dd/dd/ffff") == 0)
    3926:	00004517          	auipc	a0,0x4
    392a:	c6250513          	addi	a0,a0,-926 # 7588 <malloc+0x15b8>
    392e:	00002097          	auipc	ra,0x2
    3932:	2a4080e7          	jalr	676(ra) # 5bd2 <mkdir>
    3936:	3a050c63          	beqz	a0,3cee <subdir+0x6ae>
  if (unlink("dd/xx/ff") == 0)
    393a:	00004517          	auipc	a0,0x4
    393e:	e0650513          	addi	a0,a0,-506 # 7740 <malloc+0x1770>
    3942:	00002097          	auipc	ra,0x2
    3946:	278080e7          	jalr	632(ra) # 5bba <unlink>
    394a:	3c050063          	beqz	a0,3d0a <subdir+0x6ca>
  if (unlink("dd/ff/ff") == 0)
    394e:	00004517          	auipc	a0,0x4
    3952:	dc250513          	addi	a0,a0,-574 # 7710 <malloc+0x1740>
    3956:	00002097          	auipc	ra,0x2
    395a:	264080e7          	jalr	612(ra) # 5bba <unlink>
    395e:	3c050463          	beqz	a0,3d26 <subdir+0x6e6>
  if (chdir("dd/ff") == 0)
    3962:	00004517          	auipc	a0,0x4
    3966:	b1e50513          	addi	a0,a0,-1250 # 7480 <malloc+0x14b0>
    396a:	00002097          	auipc	ra,0x2
    396e:	270080e7          	jalr	624(ra) # 5bda <chdir>
    3972:	3c050863          	beqz	a0,3d42 <subdir+0x702>
  if (chdir("dd/xx") == 0)
    3976:	00004517          	auipc	a0,0x4
    397a:	faa50513          	addi	a0,a0,-86 # 7920 <malloc+0x1950>
    397e:	00002097          	auipc	ra,0x2
    3982:	25c080e7          	jalr	604(ra) # 5bda <chdir>
    3986:	3c050c63          	beqz	a0,3d5e <subdir+0x71e>
  if (unlink("dd/dd/ffff") != 0)
    398a:	00004517          	auipc	a0,0x4
    398e:	bfe50513          	addi	a0,a0,-1026 # 7588 <malloc+0x15b8>
    3992:	00002097          	auipc	ra,0x2
    3996:	228080e7          	jalr	552(ra) # 5bba <unlink>
    399a:	3e051063          	bnez	a0,3d7a <subdir+0x73a>
  if (unlink("dd/ff") != 0)
    399e:	00004517          	auipc	a0,0x4
    39a2:	ae250513          	addi	a0,a0,-1310 # 7480 <malloc+0x14b0>
    39a6:	00002097          	auipc	ra,0x2
    39aa:	214080e7          	jalr	532(ra) # 5bba <unlink>
    39ae:	3e051463          	bnez	a0,3d96 <subdir+0x756>
  if (unlink("dd") == 0)
    39b2:	00004517          	auipc	a0,0x4
    39b6:	aae50513          	addi	a0,a0,-1362 # 7460 <malloc+0x1490>
    39ba:	00002097          	auipc	ra,0x2
    39be:	200080e7          	jalr	512(ra) # 5bba <unlink>
    39c2:	3e050863          	beqz	a0,3db2 <subdir+0x772>
  if (unlink("dd/dd") < 0)
    39c6:	00004517          	auipc	a0,0x4
    39ca:	fca50513          	addi	a0,a0,-54 # 7990 <malloc+0x19c0>
    39ce:	00002097          	auipc	ra,0x2
    39d2:	1ec080e7          	jalr	492(ra) # 5bba <unlink>
    39d6:	3e054c63          	bltz	a0,3dce <subdir+0x78e>
  if (unlink("dd") < 0)
    39da:	00004517          	auipc	a0,0x4
    39de:	a8650513          	addi	a0,a0,-1402 # 7460 <malloc+0x1490>
    39e2:	00002097          	auipc	ra,0x2
    39e6:	1d8080e7          	jalr	472(ra) # 5bba <unlink>
    39ea:	40054063          	bltz	a0,3dea <subdir+0x7aa>
}
    39ee:	60e2                	ld	ra,24(sp)
    39f0:	6442                	ld	s0,16(sp)
    39f2:	64a2                	ld	s1,8(sp)
    39f4:	6902                	ld	s2,0(sp)
    39f6:	6105                	addi	sp,sp,32
    39f8:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    39fa:	85ca                	mv	a1,s2
    39fc:	00004517          	auipc	a0,0x4
    3a00:	a6c50513          	addi	a0,a0,-1428 # 7468 <malloc+0x1498>
    3a04:	00002097          	auipc	ra,0x2
    3a08:	50e080e7          	jalr	1294(ra) # 5f12 <printf>
    exit(1);
    3a0c:	4505                	li	a0,1
    3a0e:	00002097          	auipc	ra,0x2
    3a12:	15c080e7          	jalr	348(ra) # 5b6a <exit>
    printf("%s: create dd/ff failed\n", s);
    3a16:	85ca                	mv	a1,s2
    3a18:	00004517          	auipc	a0,0x4
    3a1c:	a7050513          	addi	a0,a0,-1424 # 7488 <malloc+0x14b8>
    3a20:	00002097          	auipc	ra,0x2
    3a24:	4f2080e7          	jalr	1266(ra) # 5f12 <printf>
    exit(1);
    3a28:	4505                	li	a0,1
    3a2a:	00002097          	auipc	ra,0x2
    3a2e:	140080e7          	jalr	320(ra) # 5b6a <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3a32:	85ca                	mv	a1,s2
    3a34:	00004517          	auipc	a0,0x4
    3a38:	a7450513          	addi	a0,a0,-1420 # 74a8 <malloc+0x14d8>
    3a3c:	00002097          	auipc	ra,0x2
    3a40:	4d6080e7          	jalr	1238(ra) # 5f12 <printf>
    exit(1);
    3a44:	4505                	li	a0,1
    3a46:	00002097          	auipc	ra,0x2
    3a4a:	124080e7          	jalr	292(ra) # 5b6a <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3a4e:	85ca                	mv	a1,s2
    3a50:	00004517          	auipc	a0,0x4
    3a54:	a9050513          	addi	a0,a0,-1392 # 74e0 <malloc+0x1510>
    3a58:	00002097          	auipc	ra,0x2
    3a5c:	4ba080e7          	jalr	1210(ra) # 5f12 <printf>
    exit(1);
    3a60:	4505                	li	a0,1
    3a62:	00002097          	auipc	ra,0x2
    3a66:	108080e7          	jalr	264(ra) # 5b6a <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3a6a:	85ca                	mv	a1,s2
    3a6c:	00004517          	auipc	a0,0x4
    3a70:	aa450513          	addi	a0,a0,-1372 # 7510 <malloc+0x1540>
    3a74:	00002097          	auipc	ra,0x2
    3a78:	49e080e7          	jalr	1182(ra) # 5f12 <printf>
    exit(1);
    3a7c:	4505                	li	a0,1
    3a7e:	00002097          	auipc	ra,0x2
    3a82:	0ec080e7          	jalr	236(ra) # 5b6a <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3a86:	85ca                	mv	a1,s2
    3a88:	00004517          	auipc	a0,0x4
    3a8c:	ac050513          	addi	a0,a0,-1344 # 7548 <malloc+0x1578>
    3a90:	00002097          	auipc	ra,0x2
    3a94:	482080e7          	jalr	1154(ra) # 5f12 <printf>
    exit(1);
    3a98:	4505                	li	a0,1
    3a9a:	00002097          	auipc	ra,0x2
    3a9e:	0d0080e7          	jalr	208(ra) # 5b6a <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3aa2:	85ca                	mv	a1,s2
    3aa4:	00004517          	auipc	a0,0x4
    3aa8:	ac450513          	addi	a0,a0,-1340 # 7568 <malloc+0x1598>
    3aac:	00002097          	auipc	ra,0x2
    3ab0:	466080e7          	jalr	1126(ra) # 5f12 <printf>
    exit(1);
    3ab4:	4505                	li	a0,1
    3ab6:	00002097          	auipc	ra,0x2
    3aba:	0b4080e7          	jalr	180(ra) # 5b6a <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3abe:	85ca                	mv	a1,s2
    3ac0:	00004517          	auipc	a0,0x4
    3ac4:	ad850513          	addi	a0,a0,-1320 # 7598 <malloc+0x15c8>
    3ac8:	00002097          	auipc	ra,0x2
    3acc:	44a080e7          	jalr	1098(ra) # 5f12 <printf>
    exit(1);
    3ad0:	4505                	li	a0,1
    3ad2:	00002097          	auipc	ra,0x2
    3ad6:	098080e7          	jalr	152(ra) # 5b6a <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3ada:	85ca                	mv	a1,s2
    3adc:	00004517          	auipc	a0,0x4
    3ae0:	ae450513          	addi	a0,a0,-1308 # 75c0 <malloc+0x15f0>
    3ae4:	00002097          	auipc	ra,0x2
    3ae8:	42e080e7          	jalr	1070(ra) # 5f12 <printf>
    exit(1);
    3aec:	4505                	li	a0,1
    3aee:	00002097          	auipc	ra,0x2
    3af2:	07c080e7          	jalr	124(ra) # 5b6a <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3af6:	85ca                	mv	a1,s2
    3af8:	00004517          	auipc	a0,0x4
    3afc:	ae850513          	addi	a0,a0,-1304 # 75e0 <malloc+0x1610>
    3b00:	00002097          	auipc	ra,0x2
    3b04:	412080e7          	jalr	1042(ra) # 5f12 <printf>
    exit(1);
    3b08:	4505                	li	a0,1
    3b0a:	00002097          	auipc	ra,0x2
    3b0e:	060080e7          	jalr	96(ra) # 5b6a <exit>
    printf("%s: chdir dd failed\n", s);
    3b12:	85ca                	mv	a1,s2
    3b14:	00004517          	auipc	a0,0x4
    3b18:	af450513          	addi	a0,a0,-1292 # 7608 <malloc+0x1638>
    3b1c:	00002097          	auipc	ra,0x2
    3b20:	3f6080e7          	jalr	1014(ra) # 5f12 <printf>
    exit(1);
    3b24:	4505                	li	a0,1
    3b26:	00002097          	auipc	ra,0x2
    3b2a:	044080e7          	jalr	68(ra) # 5b6a <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3b2e:	85ca                	mv	a1,s2
    3b30:	00004517          	auipc	a0,0x4
    3b34:	b0050513          	addi	a0,a0,-1280 # 7630 <malloc+0x1660>
    3b38:	00002097          	auipc	ra,0x2
    3b3c:	3da080e7          	jalr	986(ra) # 5f12 <printf>
    exit(1);
    3b40:	4505                	li	a0,1
    3b42:	00002097          	auipc	ra,0x2
    3b46:	028080e7          	jalr	40(ra) # 5b6a <exit>
    printf("chdir dd/../../dd failed\n", s);
    3b4a:	85ca                	mv	a1,s2
    3b4c:	00004517          	auipc	a0,0x4
    3b50:	b1450513          	addi	a0,a0,-1260 # 7660 <malloc+0x1690>
    3b54:	00002097          	auipc	ra,0x2
    3b58:	3be080e7          	jalr	958(ra) # 5f12 <printf>
    exit(1);
    3b5c:	4505                	li	a0,1
    3b5e:	00002097          	auipc	ra,0x2
    3b62:	00c080e7          	jalr	12(ra) # 5b6a <exit>
    printf("%s: chdir ./.. failed\n", s);
    3b66:	85ca                	mv	a1,s2
    3b68:	00004517          	auipc	a0,0x4
    3b6c:	b2050513          	addi	a0,a0,-1248 # 7688 <malloc+0x16b8>
    3b70:	00002097          	auipc	ra,0x2
    3b74:	3a2080e7          	jalr	930(ra) # 5f12 <printf>
    exit(1);
    3b78:	4505                	li	a0,1
    3b7a:	00002097          	auipc	ra,0x2
    3b7e:	ff0080e7          	jalr	-16(ra) # 5b6a <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3b82:	85ca                	mv	a1,s2
    3b84:	00004517          	auipc	a0,0x4
    3b88:	b1c50513          	addi	a0,a0,-1252 # 76a0 <malloc+0x16d0>
    3b8c:	00002097          	auipc	ra,0x2
    3b90:	386080e7          	jalr	902(ra) # 5f12 <printf>
    exit(1);
    3b94:	4505                	li	a0,1
    3b96:	00002097          	auipc	ra,0x2
    3b9a:	fd4080e7          	jalr	-44(ra) # 5b6a <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3b9e:	85ca                	mv	a1,s2
    3ba0:	00004517          	auipc	a0,0x4
    3ba4:	b2050513          	addi	a0,a0,-1248 # 76c0 <malloc+0x16f0>
    3ba8:	00002097          	auipc	ra,0x2
    3bac:	36a080e7          	jalr	874(ra) # 5f12 <printf>
    exit(1);
    3bb0:	4505                	li	a0,1
    3bb2:	00002097          	auipc	ra,0x2
    3bb6:	fb8080e7          	jalr	-72(ra) # 5b6a <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3bba:	85ca                	mv	a1,s2
    3bbc:	00004517          	auipc	a0,0x4
    3bc0:	b2450513          	addi	a0,a0,-1244 # 76e0 <malloc+0x1710>
    3bc4:	00002097          	auipc	ra,0x2
    3bc8:	34e080e7          	jalr	846(ra) # 5f12 <printf>
    exit(1);
    3bcc:	4505                	li	a0,1
    3bce:	00002097          	auipc	ra,0x2
    3bd2:	f9c080e7          	jalr	-100(ra) # 5b6a <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3bd6:	85ca                	mv	a1,s2
    3bd8:	00004517          	auipc	a0,0x4
    3bdc:	b4850513          	addi	a0,a0,-1208 # 7720 <malloc+0x1750>
    3be0:	00002097          	auipc	ra,0x2
    3be4:	332080e7          	jalr	818(ra) # 5f12 <printf>
    exit(1);
    3be8:	4505                	li	a0,1
    3bea:	00002097          	auipc	ra,0x2
    3bee:	f80080e7          	jalr	-128(ra) # 5b6a <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3bf2:	85ca                	mv	a1,s2
    3bf4:	00004517          	auipc	a0,0x4
    3bf8:	b5c50513          	addi	a0,a0,-1188 # 7750 <malloc+0x1780>
    3bfc:	00002097          	auipc	ra,0x2
    3c00:	316080e7          	jalr	790(ra) # 5f12 <printf>
    exit(1);
    3c04:	4505                	li	a0,1
    3c06:	00002097          	auipc	ra,0x2
    3c0a:	f64080e7          	jalr	-156(ra) # 5b6a <exit>
    printf("%s: create dd succeeded!\n", s);
    3c0e:	85ca                	mv	a1,s2
    3c10:	00004517          	auipc	a0,0x4
    3c14:	b6050513          	addi	a0,a0,-1184 # 7770 <malloc+0x17a0>
    3c18:	00002097          	auipc	ra,0x2
    3c1c:	2fa080e7          	jalr	762(ra) # 5f12 <printf>
    exit(1);
    3c20:	4505                	li	a0,1
    3c22:	00002097          	auipc	ra,0x2
    3c26:	f48080e7          	jalr	-184(ra) # 5b6a <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3c2a:	85ca                	mv	a1,s2
    3c2c:	00004517          	auipc	a0,0x4
    3c30:	b6450513          	addi	a0,a0,-1180 # 7790 <malloc+0x17c0>
    3c34:	00002097          	auipc	ra,0x2
    3c38:	2de080e7          	jalr	734(ra) # 5f12 <printf>
    exit(1);
    3c3c:	4505                	li	a0,1
    3c3e:	00002097          	auipc	ra,0x2
    3c42:	f2c080e7          	jalr	-212(ra) # 5b6a <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3c46:	85ca                	mv	a1,s2
    3c48:	00004517          	auipc	a0,0x4
    3c4c:	b6850513          	addi	a0,a0,-1176 # 77b0 <malloc+0x17e0>
    3c50:	00002097          	auipc	ra,0x2
    3c54:	2c2080e7          	jalr	706(ra) # 5f12 <printf>
    exit(1);
    3c58:	4505                	li	a0,1
    3c5a:	00002097          	auipc	ra,0x2
    3c5e:	f10080e7          	jalr	-240(ra) # 5b6a <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3c62:	85ca                	mv	a1,s2
    3c64:	00004517          	auipc	a0,0x4
    3c68:	b7c50513          	addi	a0,a0,-1156 # 77e0 <malloc+0x1810>
    3c6c:	00002097          	auipc	ra,0x2
    3c70:	2a6080e7          	jalr	678(ra) # 5f12 <printf>
    exit(1);
    3c74:	4505                	li	a0,1
    3c76:	00002097          	auipc	ra,0x2
    3c7a:	ef4080e7          	jalr	-268(ra) # 5b6a <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3c7e:	85ca                	mv	a1,s2
    3c80:	00004517          	auipc	a0,0x4
    3c84:	b8850513          	addi	a0,a0,-1144 # 7808 <malloc+0x1838>
    3c88:	00002097          	auipc	ra,0x2
    3c8c:	28a080e7          	jalr	650(ra) # 5f12 <printf>
    exit(1);
    3c90:	4505                	li	a0,1
    3c92:	00002097          	auipc	ra,0x2
    3c96:	ed8080e7          	jalr	-296(ra) # 5b6a <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3c9a:	85ca                	mv	a1,s2
    3c9c:	00004517          	auipc	a0,0x4
    3ca0:	b9450513          	addi	a0,a0,-1132 # 7830 <malloc+0x1860>
    3ca4:	00002097          	auipc	ra,0x2
    3ca8:	26e080e7          	jalr	622(ra) # 5f12 <printf>
    exit(1);
    3cac:	4505                	li	a0,1
    3cae:	00002097          	auipc	ra,0x2
    3cb2:	ebc080e7          	jalr	-324(ra) # 5b6a <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3cb6:	85ca                	mv	a1,s2
    3cb8:	00004517          	auipc	a0,0x4
    3cbc:	ba050513          	addi	a0,a0,-1120 # 7858 <malloc+0x1888>
    3cc0:	00002097          	auipc	ra,0x2
    3cc4:	252080e7          	jalr	594(ra) # 5f12 <printf>
    exit(1);
    3cc8:	4505                	li	a0,1
    3cca:	00002097          	auipc	ra,0x2
    3cce:	ea0080e7          	jalr	-352(ra) # 5b6a <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3cd2:	85ca                	mv	a1,s2
    3cd4:	00004517          	auipc	a0,0x4
    3cd8:	ba450513          	addi	a0,a0,-1116 # 7878 <malloc+0x18a8>
    3cdc:	00002097          	auipc	ra,0x2
    3ce0:	236080e7          	jalr	566(ra) # 5f12 <printf>
    exit(1);
    3ce4:	4505                	li	a0,1
    3ce6:	00002097          	auipc	ra,0x2
    3cea:	e84080e7          	jalr	-380(ra) # 5b6a <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3cee:	85ca                	mv	a1,s2
    3cf0:	00004517          	auipc	a0,0x4
    3cf4:	ba850513          	addi	a0,a0,-1112 # 7898 <malloc+0x18c8>
    3cf8:	00002097          	auipc	ra,0x2
    3cfc:	21a080e7          	jalr	538(ra) # 5f12 <printf>
    exit(1);
    3d00:	4505                	li	a0,1
    3d02:	00002097          	auipc	ra,0x2
    3d06:	e68080e7          	jalr	-408(ra) # 5b6a <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3d0a:	85ca                	mv	a1,s2
    3d0c:	00004517          	auipc	a0,0x4
    3d10:	bb450513          	addi	a0,a0,-1100 # 78c0 <malloc+0x18f0>
    3d14:	00002097          	auipc	ra,0x2
    3d18:	1fe080e7          	jalr	510(ra) # 5f12 <printf>
    exit(1);
    3d1c:	4505                	li	a0,1
    3d1e:	00002097          	auipc	ra,0x2
    3d22:	e4c080e7          	jalr	-436(ra) # 5b6a <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3d26:	85ca                	mv	a1,s2
    3d28:	00004517          	auipc	a0,0x4
    3d2c:	bb850513          	addi	a0,a0,-1096 # 78e0 <malloc+0x1910>
    3d30:	00002097          	auipc	ra,0x2
    3d34:	1e2080e7          	jalr	482(ra) # 5f12 <printf>
    exit(1);
    3d38:	4505                	li	a0,1
    3d3a:	00002097          	auipc	ra,0x2
    3d3e:	e30080e7          	jalr	-464(ra) # 5b6a <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3d42:	85ca                	mv	a1,s2
    3d44:	00004517          	auipc	a0,0x4
    3d48:	bbc50513          	addi	a0,a0,-1092 # 7900 <malloc+0x1930>
    3d4c:	00002097          	auipc	ra,0x2
    3d50:	1c6080e7          	jalr	454(ra) # 5f12 <printf>
    exit(1);
    3d54:	4505                	li	a0,1
    3d56:	00002097          	auipc	ra,0x2
    3d5a:	e14080e7          	jalr	-492(ra) # 5b6a <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3d5e:	85ca                	mv	a1,s2
    3d60:	00004517          	auipc	a0,0x4
    3d64:	bc850513          	addi	a0,a0,-1080 # 7928 <malloc+0x1958>
    3d68:	00002097          	auipc	ra,0x2
    3d6c:	1aa080e7          	jalr	426(ra) # 5f12 <printf>
    exit(1);
    3d70:	4505                	li	a0,1
    3d72:	00002097          	auipc	ra,0x2
    3d76:	df8080e7          	jalr	-520(ra) # 5b6a <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3d7a:	85ca                	mv	a1,s2
    3d7c:	00004517          	auipc	a0,0x4
    3d80:	84450513          	addi	a0,a0,-1980 # 75c0 <malloc+0x15f0>
    3d84:	00002097          	auipc	ra,0x2
    3d88:	18e080e7          	jalr	398(ra) # 5f12 <printf>
    exit(1);
    3d8c:	4505                	li	a0,1
    3d8e:	00002097          	auipc	ra,0x2
    3d92:	ddc080e7          	jalr	-548(ra) # 5b6a <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3d96:	85ca                	mv	a1,s2
    3d98:	00004517          	auipc	a0,0x4
    3d9c:	bb050513          	addi	a0,a0,-1104 # 7948 <malloc+0x1978>
    3da0:	00002097          	auipc	ra,0x2
    3da4:	172080e7          	jalr	370(ra) # 5f12 <printf>
    exit(1);
    3da8:	4505                	li	a0,1
    3daa:	00002097          	auipc	ra,0x2
    3dae:	dc0080e7          	jalr	-576(ra) # 5b6a <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3db2:	85ca                	mv	a1,s2
    3db4:	00004517          	auipc	a0,0x4
    3db8:	bb450513          	addi	a0,a0,-1100 # 7968 <malloc+0x1998>
    3dbc:	00002097          	auipc	ra,0x2
    3dc0:	156080e7          	jalr	342(ra) # 5f12 <printf>
    exit(1);
    3dc4:	4505                	li	a0,1
    3dc6:	00002097          	auipc	ra,0x2
    3dca:	da4080e7          	jalr	-604(ra) # 5b6a <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3dce:	85ca                	mv	a1,s2
    3dd0:	00004517          	auipc	a0,0x4
    3dd4:	bc850513          	addi	a0,a0,-1080 # 7998 <malloc+0x19c8>
    3dd8:	00002097          	auipc	ra,0x2
    3ddc:	13a080e7          	jalr	314(ra) # 5f12 <printf>
    exit(1);
    3de0:	4505                	li	a0,1
    3de2:	00002097          	auipc	ra,0x2
    3de6:	d88080e7          	jalr	-632(ra) # 5b6a <exit>
    printf("%s: unlink dd failed\n", s);
    3dea:	85ca                	mv	a1,s2
    3dec:	00004517          	auipc	a0,0x4
    3df0:	bcc50513          	addi	a0,a0,-1076 # 79b8 <malloc+0x19e8>
    3df4:	00002097          	auipc	ra,0x2
    3df8:	11e080e7          	jalr	286(ra) # 5f12 <printf>
    exit(1);
    3dfc:	4505                	li	a0,1
    3dfe:	00002097          	auipc	ra,0x2
    3e02:	d6c080e7          	jalr	-660(ra) # 5b6a <exit>

0000000000003e06 <rmdot>:
{
    3e06:	1101                	addi	sp,sp,-32
    3e08:	ec06                	sd	ra,24(sp)
    3e0a:	e822                	sd	s0,16(sp)
    3e0c:	e426                	sd	s1,8(sp)
    3e0e:	1000                	addi	s0,sp,32
    3e10:	84aa                	mv	s1,a0
  if (mkdir("dots") != 0)
    3e12:	00004517          	auipc	a0,0x4
    3e16:	bbe50513          	addi	a0,a0,-1090 # 79d0 <malloc+0x1a00>
    3e1a:	00002097          	auipc	ra,0x2
    3e1e:	db8080e7          	jalr	-584(ra) # 5bd2 <mkdir>
    3e22:	e549                	bnez	a0,3eac <rmdot+0xa6>
  if (chdir("dots") != 0)
    3e24:	00004517          	auipc	a0,0x4
    3e28:	bac50513          	addi	a0,a0,-1108 # 79d0 <malloc+0x1a00>
    3e2c:	00002097          	auipc	ra,0x2
    3e30:	dae080e7          	jalr	-594(ra) # 5bda <chdir>
    3e34:	e951                	bnez	a0,3ec8 <rmdot+0xc2>
  if (unlink(".") == 0)
    3e36:	00003517          	auipc	a0,0x3
    3e3a:	9ca50513          	addi	a0,a0,-1590 # 6800 <malloc+0x830>
    3e3e:	00002097          	auipc	ra,0x2
    3e42:	d7c080e7          	jalr	-644(ra) # 5bba <unlink>
    3e46:	cd59                	beqz	a0,3ee4 <rmdot+0xde>
  if (unlink("..") == 0)
    3e48:	00003517          	auipc	a0,0x3
    3e4c:	5e050513          	addi	a0,a0,1504 # 7428 <malloc+0x1458>
    3e50:	00002097          	auipc	ra,0x2
    3e54:	d6a080e7          	jalr	-662(ra) # 5bba <unlink>
    3e58:	c545                	beqz	a0,3f00 <rmdot+0xfa>
  if (chdir("/") != 0)
    3e5a:	00003517          	auipc	a0,0x3
    3e5e:	57650513          	addi	a0,a0,1398 # 73d0 <malloc+0x1400>
    3e62:	00002097          	auipc	ra,0x2
    3e66:	d78080e7          	jalr	-648(ra) # 5bda <chdir>
    3e6a:	e94d                	bnez	a0,3f1c <rmdot+0x116>
  if (unlink("dots/.") == 0)
    3e6c:	00004517          	auipc	a0,0x4
    3e70:	bcc50513          	addi	a0,a0,-1076 # 7a38 <malloc+0x1a68>
    3e74:	00002097          	auipc	ra,0x2
    3e78:	d46080e7          	jalr	-698(ra) # 5bba <unlink>
    3e7c:	cd55                	beqz	a0,3f38 <rmdot+0x132>
  if (unlink("dots/..") == 0)
    3e7e:	00004517          	auipc	a0,0x4
    3e82:	be250513          	addi	a0,a0,-1054 # 7a60 <malloc+0x1a90>
    3e86:	00002097          	auipc	ra,0x2
    3e8a:	d34080e7          	jalr	-716(ra) # 5bba <unlink>
    3e8e:	c179                	beqz	a0,3f54 <rmdot+0x14e>
  if (unlink("dots") != 0)
    3e90:	00004517          	auipc	a0,0x4
    3e94:	b4050513          	addi	a0,a0,-1216 # 79d0 <malloc+0x1a00>
    3e98:	00002097          	auipc	ra,0x2
    3e9c:	d22080e7          	jalr	-734(ra) # 5bba <unlink>
    3ea0:	e961                	bnez	a0,3f70 <rmdot+0x16a>
}
    3ea2:	60e2                	ld	ra,24(sp)
    3ea4:	6442                	ld	s0,16(sp)
    3ea6:	64a2                	ld	s1,8(sp)
    3ea8:	6105                	addi	sp,sp,32
    3eaa:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3eac:	85a6                	mv	a1,s1
    3eae:	00004517          	auipc	a0,0x4
    3eb2:	b2a50513          	addi	a0,a0,-1238 # 79d8 <malloc+0x1a08>
    3eb6:	00002097          	auipc	ra,0x2
    3eba:	05c080e7          	jalr	92(ra) # 5f12 <printf>
    exit(1);
    3ebe:	4505                	li	a0,1
    3ec0:	00002097          	auipc	ra,0x2
    3ec4:	caa080e7          	jalr	-854(ra) # 5b6a <exit>
    printf("%s: chdir dots failed\n", s);
    3ec8:	85a6                	mv	a1,s1
    3eca:	00004517          	auipc	a0,0x4
    3ece:	b2650513          	addi	a0,a0,-1242 # 79f0 <malloc+0x1a20>
    3ed2:	00002097          	auipc	ra,0x2
    3ed6:	040080e7          	jalr	64(ra) # 5f12 <printf>
    exit(1);
    3eda:	4505                	li	a0,1
    3edc:	00002097          	auipc	ra,0x2
    3ee0:	c8e080e7          	jalr	-882(ra) # 5b6a <exit>
    printf("%s: rm . worked!\n", s);
    3ee4:	85a6                	mv	a1,s1
    3ee6:	00004517          	auipc	a0,0x4
    3eea:	b2250513          	addi	a0,a0,-1246 # 7a08 <malloc+0x1a38>
    3eee:	00002097          	auipc	ra,0x2
    3ef2:	024080e7          	jalr	36(ra) # 5f12 <printf>
    exit(1);
    3ef6:	4505                	li	a0,1
    3ef8:	00002097          	auipc	ra,0x2
    3efc:	c72080e7          	jalr	-910(ra) # 5b6a <exit>
    printf("%s: rm .. worked!\n", s);
    3f00:	85a6                	mv	a1,s1
    3f02:	00004517          	auipc	a0,0x4
    3f06:	b1e50513          	addi	a0,a0,-1250 # 7a20 <malloc+0x1a50>
    3f0a:	00002097          	auipc	ra,0x2
    3f0e:	008080e7          	jalr	8(ra) # 5f12 <printf>
    exit(1);
    3f12:	4505                	li	a0,1
    3f14:	00002097          	auipc	ra,0x2
    3f18:	c56080e7          	jalr	-938(ra) # 5b6a <exit>
    printf("%s: chdir / failed\n", s);
    3f1c:	85a6                	mv	a1,s1
    3f1e:	00003517          	auipc	a0,0x3
    3f22:	4ba50513          	addi	a0,a0,1210 # 73d8 <malloc+0x1408>
    3f26:	00002097          	auipc	ra,0x2
    3f2a:	fec080e7          	jalr	-20(ra) # 5f12 <printf>
    exit(1);
    3f2e:	4505                	li	a0,1
    3f30:	00002097          	auipc	ra,0x2
    3f34:	c3a080e7          	jalr	-966(ra) # 5b6a <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3f38:	85a6                	mv	a1,s1
    3f3a:	00004517          	auipc	a0,0x4
    3f3e:	b0650513          	addi	a0,a0,-1274 # 7a40 <malloc+0x1a70>
    3f42:	00002097          	auipc	ra,0x2
    3f46:	fd0080e7          	jalr	-48(ra) # 5f12 <printf>
    exit(1);
    3f4a:	4505                	li	a0,1
    3f4c:	00002097          	auipc	ra,0x2
    3f50:	c1e080e7          	jalr	-994(ra) # 5b6a <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3f54:	85a6                	mv	a1,s1
    3f56:	00004517          	auipc	a0,0x4
    3f5a:	b1250513          	addi	a0,a0,-1262 # 7a68 <malloc+0x1a98>
    3f5e:	00002097          	auipc	ra,0x2
    3f62:	fb4080e7          	jalr	-76(ra) # 5f12 <printf>
    exit(1);
    3f66:	4505                	li	a0,1
    3f68:	00002097          	auipc	ra,0x2
    3f6c:	c02080e7          	jalr	-1022(ra) # 5b6a <exit>
    printf("%s: unlink dots failed!\n", s);
    3f70:	85a6                	mv	a1,s1
    3f72:	00004517          	auipc	a0,0x4
    3f76:	b1650513          	addi	a0,a0,-1258 # 7a88 <malloc+0x1ab8>
    3f7a:	00002097          	auipc	ra,0x2
    3f7e:	f98080e7          	jalr	-104(ra) # 5f12 <printf>
    exit(1);
    3f82:	4505                	li	a0,1
    3f84:	00002097          	auipc	ra,0x2
    3f88:	be6080e7          	jalr	-1050(ra) # 5b6a <exit>

0000000000003f8c <dirfile>:
{
    3f8c:	1101                	addi	sp,sp,-32
    3f8e:	ec06                	sd	ra,24(sp)
    3f90:	e822                	sd	s0,16(sp)
    3f92:	e426                	sd	s1,8(sp)
    3f94:	e04a                	sd	s2,0(sp)
    3f96:	1000                	addi	s0,sp,32
    3f98:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3f9a:	20000593          	li	a1,512
    3f9e:	00004517          	auipc	a0,0x4
    3fa2:	b0a50513          	addi	a0,a0,-1270 # 7aa8 <malloc+0x1ad8>
    3fa6:	00002097          	auipc	ra,0x2
    3faa:	c04080e7          	jalr	-1020(ra) # 5baa <open>
  if (fd < 0)
    3fae:	0e054d63          	bltz	a0,40a8 <dirfile+0x11c>
  close(fd);
    3fb2:	00002097          	auipc	ra,0x2
    3fb6:	be0080e7          	jalr	-1056(ra) # 5b92 <close>
  if (chdir("dirfile") == 0)
    3fba:	00004517          	auipc	a0,0x4
    3fbe:	aee50513          	addi	a0,a0,-1298 # 7aa8 <malloc+0x1ad8>
    3fc2:	00002097          	auipc	ra,0x2
    3fc6:	c18080e7          	jalr	-1000(ra) # 5bda <chdir>
    3fca:	cd6d                	beqz	a0,40c4 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3fcc:	4581                	li	a1,0
    3fce:	00004517          	auipc	a0,0x4
    3fd2:	b2250513          	addi	a0,a0,-1246 # 7af0 <malloc+0x1b20>
    3fd6:	00002097          	auipc	ra,0x2
    3fda:	bd4080e7          	jalr	-1068(ra) # 5baa <open>
  if (fd >= 0)
    3fde:	10055163          	bgez	a0,40e0 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    3fe2:	20000593          	li	a1,512
    3fe6:	00004517          	auipc	a0,0x4
    3fea:	b0a50513          	addi	a0,a0,-1270 # 7af0 <malloc+0x1b20>
    3fee:	00002097          	auipc	ra,0x2
    3ff2:	bbc080e7          	jalr	-1092(ra) # 5baa <open>
  if (fd >= 0)
    3ff6:	10055363          	bgez	a0,40fc <dirfile+0x170>
  if (mkdir("dirfile/xx") == 0)
    3ffa:	00004517          	auipc	a0,0x4
    3ffe:	af650513          	addi	a0,a0,-1290 # 7af0 <malloc+0x1b20>
    4002:	00002097          	auipc	ra,0x2
    4006:	bd0080e7          	jalr	-1072(ra) # 5bd2 <mkdir>
    400a:	10050763          	beqz	a0,4118 <dirfile+0x18c>
  if (unlink("dirfile/xx") == 0)
    400e:	00004517          	auipc	a0,0x4
    4012:	ae250513          	addi	a0,a0,-1310 # 7af0 <malloc+0x1b20>
    4016:	00002097          	auipc	ra,0x2
    401a:	ba4080e7          	jalr	-1116(ra) # 5bba <unlink>
    401e:	10050b63          	beqz	a0,4134 <dirfile+0x1a8>
  if (link("README", "dirfile/xx") == 0)
    4022:	00004597          	auipc	a1,0x4
    4026:	ace58593          	addi	a1,a1,-1330 # 7af0 <malloc+0x1b20>
    402a:	00002517          	auipc	a0,0x2
    402e:	2c650513          	addi	a0,a0,710 # 62f0 <malloc+0x320>
    4032:	00002097          	auipc	ra,0x2
    4036:	b98080e7          	jalr	-1128(ra) # 5bca <link>
    403a:	10050b63          	beqz	a0,4150 <dirfile+0x1c4>
  if (unlink("dirfile") != 0)
    403e:	00004517          	auipc	a0,0x4
    4042:	a6a50513          	addi	a0,a0,-1430 # 7aa8 <malloc+0x1ad8>
    4046:	00002097          	auipc	ra,0x2
    404a:	b74080e7          	jalr	-1164(ra) # 5bba <unlink>
    404e:	10051f63          	bnez	a0,416c <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    4052:	4589                	li	a1,2
    4054:	00002517          	auipc	a0,0x2
    4058:	7ac50513          	addi	a0,a0,1964 # 6800 <malloc+0x830>
    405c:	00002097          	auipc	ra,0x2
    4060:	b4e080e7          	jalr	-1202(ra) # 5baa <open>
  if (fd >= 0)
    4064:	12055263          	bgez	a0,4188 <dirfile+0x1fc>
  fd = open(".", 0);
    4068:	4581                	li	a1,0
    406a:	00002517          	auipc	a0,0x2
    406e:	79650513          	addi	a0,a0,1942 # 6800 <malloc+0x830>
    4072:	00002097          	auipc	ra,0x2
    4076:	b38080e7          	jalr	-1224(ra) # 5baa <open>
    407a:	84aa                	mv	s1,a0
  if (write(fd, "x", 1) > 0)
    407c:	4605                	li	a2,1
    407e:	00002597          	auipc	a1,0x2
    4082:	10a58593          	addi	a1,a1,266 # 6188 <malloc+0x1b8>
    4086:	00002097          	auipc	ra,0x2
    408a:	b04080e7          	jalr	-1276(ra) # 5b8a <write>
    408e:	10a04b63          	bgtz	a0,41a4 <dirfile+0x218>
  close(fd);
    4092:	8526                	mv	a0,s1
    4094:	00002097          	auipc	ra,0x2
    4098:	afe080e7          	jalr	-1282(ra) # 5b92 <close>
}
    409c:	60e2                	ld	ra,24(sp)
    409e:	6442                	ld	s0,16(sp)
    40a0:	64a2                	ld	s1,8(sp)
    40a2:	6902                	ld	s2,0(sp)
    40a4:	6105                	addi	sp,sp,32
    40a6:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    40a8:	85ca                	mv	a1,s2
    40aa:	00004517          	auipc	a0,0x4
    40ae:	a0650513          	addi	a0,a0,-1530 # 7ab0 <malloc+0x1ae0>
    40b2:	00002097          	auipc	ra,0x2
    40b6:	e60080e7          	jalr	-416(ra) # 5f12 <printf>
    exit(1);
    40ba:	4505                	li	a0,1
    40bc:	00002097          	auipc	ra,0x2
    40c0:	aae080e7          	jalr	-1362(ra) # 5b6a <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    40c4:	85ca                	mv	a1,s2
    40c6:	00004517          	auipc	a0,0x4
    40ca:	a0a50513          	addi	a0,a0,-1526 # 7ad0 <malloc+0x1b00>
    40ce:	00002097          	auipc	ra,0x2
    40d2:	e44080e7          	jalr	-444(ra) # 5f12 <printf>
    exit(1);
    40d6:	4505                	li	a0,1
    40d8:	00002097          	auipc	ra,0x2
    40dc:	a92080e7          	jalr	-1390(ra) # 5b6a <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    40e0:	85ca                	mv	a1,s2
    40e2:	00004517          	auipc	a0,0x4
    40e6:	a1e50513          	addi	a0,a0,-1506 # 7b00 <malloc+0x1b30>
    40ea:	00002097          	auipc	ra,0x2
    40ee:	e28080e7          	jalr	-472(ra) # 5f12 <printf>
    exit(1);
    40f2:	4505                	li	a0,1
    40f4:	00002097          	auipc	ra,0x2
    40f8:	a76080e7          	jalr	-1418(ra) # 5b6a <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    40fc:	85ca                	mv	a1,s2
    40fe:	00004517          	auipc	a0,0x4
    4102:	a0250513          	addi	a0,a0,-1534 # 7b00 <malloc+0x1b30>
    4106:	00002097          	auipc	ra,0x2
    410a:	e0c080e7          	jalr	-500(ra) # 5f12 <printf>
    exit(1);
    410e:	4505                	li	a0,1
    4110:	00002097          	auipc	ra,0x2
    4114:	a5a080e7          	jalr	-1446(ra) # 5b6a <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4118:	85ca                	mv	a1,s2
    411a:	00004517          	auipc	a0,0x4
    411e:	a0e50513          	addi	a0,a0,-1522 # 7b28 <malloc+0x1b58>
    4122:	00002097          	auipc	ra,0x2
    4126:	df0080e7          	jalr	-528(ra) # 5f12 <printf>
    exit(1);
    412a:	4505                	li	a0,1
    412c:	00002097          	auipc	ra,0x2
    4130:	a3e080e7          	jalr	-1474(ra) # 5b6a <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    4134:	85ca                	mv	a1,s2
    4136:	00004517          	auipc	a0,0x4
    413a:	a1a50513          	addi	a0,a0,-1510 # 7b50 <malloc+0x1b80>
    413e:	00002097          	auipc	ra,0x2
    4142:	dd4080e7          	jalr	-556(ra) # 5f12 <printf>
    exit(1);
    4146:	4505                	li	a0,1
    4148:	00002097          	auipc	ra,0x2
    414c:	a22080e7          	jalr	-1502(ra) # 5b6a <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    4150:	85ca                	mv	a1,s2
    4152:	00004517          	auipc	a0,0x4
    4156:	a2650513          	addi	a0,a0,-1498 # 7b78 <malloc+0x1ba8>
    415a:	00002097          	auipc	ra,0x2
    415e:	db8080e7          	jalr	-584(ra) # 5f12 <printf>
    exit(1);
    4162:	4505                	li	a0,1
    4164:	00002097          	auipc	ra,0x2
    4168:	a06080e7          	jalr	-1530(ra) # 5b6a <exit>
    printf("%s: unlink dirfile failed!\n", s);
    416c:	85ca                	mv	a1,s2
    416e:	00004517          	auipc	a0,0x4
    4172:	a3250513          	addi	a0,a0,-1486 # 7ba0 <malloc+0x1bd0>
    4176:	00002097          	auipc	ra,0x2
    417a:	d9c080e7          	jalr	-612(ra) # 5f12 <printf>
    exit(1);
    417e:	4505                	li	a0,1
    4180:	00002097          	auipc	ra,0x2
    4184:	9ea080e7          	jalr	-1558(ra) # 5b6a <exit>
    printf("%s: open . for writing succeeded!\n", s);
    4188:	85ca                	mv	a1,s2
    418a:	00004517          	auipc	a0,0x4
    418e:	a3650513          	addi	a0,a0,-1482 # 7bc0 <malloc+0x1bf0>
    4192:	00002097          	auipc	ra,0x2
    4196:	d80080e7          	jalr	-640(ra) # 5f12 <printf>
    exit(1);
    419a:	4505                	li	a0,1
    419c:	00002097          	auipc	ra,0x2
    41a0:	9ce080e7          	jalr	-1586(ra) # 5b6a <exit>
    printf("%s: write . succeeded!\n", s);
    41a4:	85ca                	mv	a1,s2
    41a6:	00004517          	auipc	a0,0x4
    41aa:	a4250513          	addi	a0,a0,-1470 # 7be8 <malloc+0x1c18>
    41ae:	00002097          	auipc	ra,0x2
    41b2:	d64080e7          	jalr	-668(ra) # 5f12 <printf>
    exit(1);
    41b6:	4505                	li	a0,1
    41b8:	00002097          	auipc	ra,0x2
    41bc:	9b2080e7          	jalr	-1614(ra) # 5b6a <exit>

00000000000041c0 <iref>:
{
    41c0:	7139                	addi	sp,sp,-64
    41c2:	fc06                	sd	ra,56(sp)
    41c4:	f822                	sd	s0,48(sp)
    41c6:	f426                	sd	s1,40(sp)
    41c8:	f04a                	sd	s2,32(sp)
    41ca:	ec4e                	sd	s3,24(sp)
    41cc:	e852                	sd	s4,16(sp)
    41ce:	e456                	sd	s5,8(sp)
    41d0:	e05a                	sd	s6,0(sp)
    41d2:	0080                	addi	s0,sp,64
    41d4:	8b2a                	mv	s6,a0
    41d6:	03300913          	li	s2,51
    if (mkdir("irefd") != 0)
    41da:	00004a17          	auipc	s4,0x4
    41de:	a26a0a13          	addi	s4,s4,-1498 # 7c00 <malloc+0x1c30>
    mkdir("");
    41e2:	00003497          	auipc	s1,0x3
    41e6:	52648493          	addi	s1,s1,1318 # 7708 <malloc+0x1738>
    link("README", "");
    41ea:	00002a97          	auipc	s5,0x2
    41ee:	106a8a93          	addi	s5,s5,262 # 62f0 <malloc+0x320>
    fd = open("xx", O_CREATE);
    41f2:	00004997          	auipc	s3,0x4
    41f6:	90698993          	addi	s3,s3,-1786 # 7af8 <malloc+0x1b28>
    41fa:	a891                	j	424e <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    41fc:	85da                	mv	a1,s6
    41fe:	00004517          	auipc	a0,0x4
    4202:	a0a50513          	addi	a0,a0,-1526 # 7c08 <malloc+0x1c38>
    4206:	00002097          	auipc	ra,0x2
    420a:	d0c080e7          	jalr	-756(ra) # 5f12 <printf>
      exit(1);
    420e:	4505                	li	a0,1
    4210:	00002097          	auipc	ra,0x2
    4214:	95a080e7          	jalr	-1702(ra) # 5b6a <exit>
      printf("%s: chdir irefd failed\n", s);
    4218:	85da                	mv	a1,s6
    421a:	00004517          	auipc	a0,0x4
    421e:	a0650513          	addi	a0,a0,-1530 # 7c20 <malloc+0x1c50>
    4222:	00002097          	auipc	ra,0x2
    4226:	cf0080e7          	jalr	-784(ra) # 5f12 <printf>
      exit(1);
    422a:	4505                	li	a0,1
    422c:	00002097          	auipc	ra,0x2
    4230:	93e080e7          	jalr	-1730(ra) # 5b6a <exit>
      close(fd);
    4234:	00002097          	auipc	ra,0x2
    4238:	95e080e7          	jalr	-1698(ra) # 5b92 <close>
    423c:	a889                	j	428e <iref+0xce>
    unlink("xx");
    423e:	854e                	mv	a0,s3
    4240:	00002097          	auipc	ra,0x2
    4244:	97a080e7          	jalr	-1670(ra) # 5bba <unlink>
  for (i = 0; i < NINODE + 1; i++)
    4248:	397d                	addiw	s2,s2,-1
    424a:	06090063          	beqz	s2,42aa <iref+0xea>
    if (mkdir("irefd") != 0)
    424e:	8552                	mv	a0,s4
    4250:	00002097          	auipc	ra,0x2
    4254:	982080e7          	jalr	-1662(ra) # 5bd2 <mkdir>
    4258:	f155                	bnez	a0,41fc <iref+0x3c>
    if (chdir("irefd") != 0)
    425a:	8552                	mv	a0,s4
    425c:	00002097          	auipc	ra,0x2
    4260:	97e080e7          	jalr	-1666(ra) # 5bda <chdir>
    4264:	f955                	bnez	a0,4218 <iref+0x58>
    mkdir("");
    4266:	8526                	mv	a0,s1
    4268:	00002097          	auipc	ra,0x2
    426c:	96a080e7          	jalr	-1686(ra) # 5bd2 <mkdir>
    link("README", "");
    4270:	85a6                	mv	a1,s1
    4272:	8556                	mv	a0,s5
    4274:	00002097          	auipc	ra,0x2
    4278:	956080e7          	jalr	-1706(ra) # 5bca <link>
    fd = open("", O_CREATE);
    427c:	20000593          	li	a1,512
    4280:	8526                	mv	a0,s1
    4282:	00002097          	auipc	ra,0x2
    4286:	928080e7          	jalr	-1752(ra) # 5baa <open>
    if (fd >= 0)
    428a:	fa0555e3          	bgez	a0,4234 <iref+0x74>
    fd = open("xx", O_CREATE);
    428e:	20000593          	li	a1,512
    4292:	854e                	mv	a0,s3
    4294:	00002097          	auipc	ra,0x2
    4298:	916080e7          	jalr	-1770(ra) # 5baa <open>
    if (fd >= 0)
    429c:	fa0541e3          	bltz	a0,423e <iref+0x7e>
      close(fd);
    42a0:	00002097          	auipc	ra,0x2
    42a4:	8f2080e7          	jalr	-1806(ra) # 5b92 <close>
    42a8:	bf59                	j	423e <iref+0x7e>
    42aa:	03300493          	li	s1,51
    chdir("..");
    42ae:	00003997          	auipc	s3,0x3
    42b2:	17a98993          	addi	s3,s3,378 # 7428 <malloc+0x1458>
    unlink("irefd");
    42b6:	00004917          	auipc	s2,0x4
    42ba:	94a90913          	addi	s2,s2,-1718 # 7c00 <malloc+0x1c30>
    chdir("..");
    42be:	854e                	mv	a0,s3
    42c0:	00002097          	auipc	ra,0x2
    42c4:	91a080e7          	jalr	-1766(ra) # 5bda <chdir>
    unlink("irefd");
    42c8:	854a                	mv	a0,s2
    42ca:	00002097          	auipc	ra,0x2
    42ce:	8f0080e7          	jalr	-1808(ra) # 5bba <unlink>
  for (i = 0; i < NINODE + 1; i++)
    42d2:	34fd                	addiw	s1,s1,-1
    42d4:	f4ed                	bnez	s1,42be <iref+0xfe>
  chdir("/");
    42d6:	00003517          	auipc	a0,0x3
    42da:	0fa50513          	addi	a0,a0,250 # 73d0 <malloc+0x1400>
    42de:	00002097          	auipc	ra,0x2
    42e2:	8fc080e7          	jalr	-1796(ra) # 5bda <chdir>
}
    42e6:	70e2                	ld	ra,56(sp)
    42e8:	7442                	ld	s0,48(sp)
    42ea:	74a2                	ld	s1,40(sp)
    42ec:	7902                	ld	s2,32(sp)
    42ee:	69e2                	ld	s3,24(sp)
    42f0:	6a42                	ld	s4,16(sp)
    42f2:	6aa2                	ld	s5,8(sp)
    42f4:	6b02                	ld	s6,0(sp)
    42f6:	6121                	addi	sp,sp,64
    42f8:	8082                	ret

00000000000042fa <openiputtest>:
{
    42fa:	7179                	addi	sp,sp,-48
    42fc:	f406                	sd	ra,40(sp)
    42fe:	f022                	sd	s0,32(sp)
    4300:	ec26                	sd	s1,24(sp)
    4302:	1800                	addi	s0,sp,48
    4304:	84aa                	mv	s1,a0
  if (mkdir("oidir") < 0)
    4306:	00004517          	auipc	a0,0x4
    430a:	93250513          	addi	a0,a0,-1742 # 7c38 <malloc+0x1c68>
    430e:	00002097          	auipc	ra,0x2
    4312:	8c4080e7          	jalr	-1852(ra) # 5bd2 <mkdir>
    4316:	04054263          	bltz	a0,435a <openiputtest+0x60>
  pid = fork();
    431a:	00002097          	auipc	ra,0x2
    431e:	848080e7          	jalr	-1976(ra) # 5b62 <fork>
  if (pid < 0)
    4322:	04054a63          	bltz	a0,4376 <openiputtest+0x7c>
  if (pid == 0)
    4326:	e93d                	bnez	a0,439c <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    4328:	4589                	li	a1,2
    432a:	00004517          	auipc	a0,0x4
    432e:	90e50513          	addi	a0,a0,-1778 # 7c38 <malloc+0x1c68>
    4332:	00002097          	auipc	ra,0x2
    4336:	878080e7          	jalr	-1928(ra) # 5baa <open>
    if (fd >= 0)
    433a:	04054c63          	bltz	a0,4392 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    433e:	85a6                	mv	a1,s1
    4340:	00004517          	auipc	a0,0x4
    4344:	91850513          	addi	a0,a0,-1768 # 7c58 <malloc+0x1c88>
    4348:	00002097          	auipc	ra,0x2
    434c:	bca080e7          	jalr	-1078(ra) # 5f12 <printf>
      exit(1);
    4350:	4505                	li	a0,1
    4352:	00002097          	auipc	ra,0x2
    4356:	818080e7          	jalr	-2024(ra) # 5b6a <exit>
    printf("%s: mkdir oidir failed\n", s);
    435a:	85a6                	mv	a1,s1
    435c:	00004517          	auipc	a0,0x4
    4360:	8e450513          	addi	a0,a0,-1820 # 7c40 <malloc+0x1c70>
    4364:	00002097          	auipc	ra,0x2
    4368:	bae080e7          	jalr	-1106(ra) # 5f12 <printf>
    exit(1);
    436c:	4505                	li	a0,1
    436e:	00001097          	auipc	ra,0x1
    4372:	7fc080e7          	jalr	2044(ra) # 5b6a <exit>
    printf("%s: fork failed\n", s);
    4376:	85a6                	mv	a1,s1
    4378:	00002517          	auipc	a0,0x2
    437c:	62850513          	addi	a0,a0,1576 # 69a0 <malloc+0x9d0>
    4380:	00002097          	auipc	ra,0x2
    4384:	b92080e7          	jalr	-1134(ra) # 5f12 <printf>
    exit(1);
    4388:	4505                	li	a0,1
    438a:	00001097          	auipc	ra,0x1
    438e:	7e0080e7          	jalr	2016(ra) # 5b6a <exit>
    exit(0);
    4392:	4501                	li	a0,0
    4394:	00001097          	auipc	ra,0x1
    4398:	7d6080e7          	jalr	2006(ra) # 5b6a <exit>
  sleep(1);
    439c:	4505                	li	a0,1
    439e:	00002097          	auipc	ra,0x2
    43a2:	85c080e7          	jalr	-1956(ra) # 5bfa <sleep>
  if (unlink("oidir") != 0)
    43a6:	00004517          	auipc	a0,0x4
    43aa:	89250513          	addi	a0,a0,-1902 # 7c38 <malloc+0x1c68>
    43ae:	00002097          	auipc	ra,0x2
    43b2:	80c080e7          	jalr	-2036(ra) # 5bba <unlink>
    43b6:	cd19                	beqz	a0,43d4 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    43b8:	85a6                	mv	a1,s1
    43ba:	00002517          	auipc	a0,0x2
    43be:	7d650513          	addi	a0,a0,2006 # 6b90 <malloc+0xbc0>
    43c2:	00002097          	auipc	ra,0x2
    43c6:	b50080e7          	jalr	-1200(ra) # 5f12 <printf>
    exit(1);
    43ca:	4505                	li	a0,1
    43cc:	00001097          	auipc	ra,0x1
    43d0:	79e080e7          	jalr	1950(ra) # 5b6a <exit>
  wait(&xstatus);
    43d4:	fdc40513          	addi	a0,s0,-36
    43d8:	00001097          	auipc	ra,0x1
    43dc:	79a080e7          	jalr	1946(ra) # 5b72 <wait>
  exit(xstatus);
    43e0:	fdc42503          	lw	a0,-36(s0)
    43e4:	00001097          	auipc	ra,0x1
    43e8:	786080e7          	jalr	1926(ra) # 5b6a <exit>

00000000000043ec <forkforkfork>:
{
    43ec:	1101                	addi	sp,sp,-32
    43ee:	ec06                	sd	ra,24(sp)
    43f0:	e822                	sd	s0,16(sp)
    43f2:	e426                	sd	s1,8(sp)
    43f4:	1000                	addi	s0,sp,32
    43f6:	84aa                	mv	s1,a0
  unlink("stopforking");
    43f8:	00004517          	auipc	a0,0x4
    43fc:	88850513          	addi	a0,a0,-1912 # 7c80 <malloc+0x1cb0>
    4400:	00001097          	auipc	ra,0x1
    4404:	7ba080e7          	jalr	1978(ra) # 5bba <unlink>
  int pid = fork();
    4408:	00001097          	auipc	ra,0x1
    440c:	75a080e7          	jalr	1882(ra) # 5b62 <fork>
  if (pid < 0)
    4410:	04054563          	bltz	a0,445a <forkforkfork+0x6e>
  if (pid == 0)
    4414:	c12d                	beqz	a0,4476 <forkforkfork+0x8a>
  sleep(20); // two seconds
    4416:	4551                	li	a0,20
    4418:	00001097          	auipc	ra,0x1
    441c:	7e2080e7          	jalr	2018(ra) # 5bfa <sleep>
  close(open("stopforking", O_CREATE | O_RDWR));
    4420:	20200593          	li	a1,514
    4424:	00004517          	auipc	a0,0x4
    4428:	85c50513          	addi	a0,a0,-1956 # 7c80 <malloc+0x1cb0>
    442c:	00001097          	auipc	ra,0x1
    4430:	77e080e7          	jalr	1918(ra) # 5baa <open>
    4434:	00001097          	auipc	ra,0x1
    4438:	75e080e7          	jalr	1886(ra) # 5b92 <close>
  wait(0);
    443c:	4501                	li	a0,0
    443e:	00001097          	auipc	ra,0x1
    4442:	734080e7          	jalr	1844(ra) # 5b72 <wait>
  sleep(10); // one second
    4446:	4529                	li	a0,10
    4448:	00001097          	auipc	ra,0x1
    444c:	7b2080e7          	jalr	1970(ra) # 5bfa <sleep>
}
    4450:	60e2                	ld	ra,24(sp)
    4452:	6442                	ld	s0,16(sp)
    4454:	64a2                	ld	s1,8(sp)
    4456:	6105                	addi	sp,sp,32
    4458:	8082                	ret
    printf("%s: fork failed", s);
    445a:	85a6                	mv	a1,s1
    445c:	00002517          	auipc	a0,0x2
    4460:	70450513          	addi	a0,a0,1796 # 6b60 <malloc+0xb90>
    4464:	00002097          	auipc	ra,0x2
    4468:	aae080e7          	jalr	-1362(ra) # 5f12 <printf>
    exit(1);
    446c:	4505                	li	a0,1
    446e:	00001097          	auipc	ra,0x1
    4472:	6fc080e7          	jalr	1788(ra) # 5b6a <exit>
      int fd = open("stopforking", 0);
    4476:	00004497          	auipc	s1,0x4
    447a:	80a48493          	addi	s1,s1,-2038 # 7c80 <malloc+0x1cb0>
    447e:	4581                	li	a1,0
    4480:	8526                	mv	a0,s1
    4482:	00001097          	auipc	ra,0x1
    4486:	728080e7          	jalr	1832(ra) # 5baa <open>
      if (fd >= 0)
    448a:	02055463          	bgez	a0,44b2 <forkforkfork+0xc6>
      if (fork() < 0)
    448e:	00001097          	auipc	ra,0x1
    4492:	6d4080e7          	jalr	1748(ra) # 5b62 <fork>
    4496:	fe0554e3          	bgez	a0,447e <forkforkfork+0x92>
        close(open("stopforking", O_CREATE | O_RDWR));
    449a:	20200593          	li	a1,514
    449e:	8526                	mv	a0,s1
    44a0:	00001097          	auipc	ra,0x1
    44a4:	70a080e7          	jalr	1802(ra) # 5baa <open>
    44a8:	00001097          	auipc	ra,0x1
    44ac:	6ea080e7          	jalr	1770(ra) # 5b92 <close>
    44b0:	b7f9                	j	447e <forkforkfork+0x92>
        exit(0);
    44b2:	4501                	li	a0,0
    44b4:	00001097          	auipc	ra,0x1
    44b8:	6b6080e7          	jalr	1718(ra) # 5b6a <exit>

00000000000044bc <killstatus>:
{
    44bc:	7139                	addi	sp,sp,-64
    44be:	fc06                	sd	ra,56(sp)
    44c0:	f822                	sd	s0,48(sp)
    44c2:	f426                	sd	s1,40(sp)
    44c4:	f04a                	sd	s2,32(sp)
    44c6:	ec4e                	sd	s3,24(sp)
    44c8:	e852                	sd	s4,16(sp)
    44ca:	0080                	addi	s0,sp,64
    44cc:	8a2a                	mv	s4,a0
    44ce:	06400913          	li	s2,100
    if (xst != -1)
    44d2:	59fd                	li	s3,-1
    int pid1 = fork();
    44d4:	00001097          	auipc	ra,0x1
    44d8:	68e080e7          	jalr	1678(ra) # 5b62 <fork>
    44dc:	84aa                	mv	s1,a0
    if (pid1 < 0)
    44de:	02054f63          	bltz	a0,451c <killstatus+0x60>
    if (pid1 == 0)
    44e2:	c939                	beqz	a0,4538 <killstatus+0x7c>
    sleep(1);
    44e4:	4505                	li	a0,1
    44e6:	00001097          	auipc	ra,0x1
    44ea:	714080e7          	jalr	1812(ra) # 5bfa <sleep>
    kill(pid1);
    44ee:	8526                	mv	a0,s1
    44f0:	00001097          	auipc	ra,0x1
    44f4:	6aa080e7          	jalr	1706(ra) # 5b9a <kill>
    wait(&xst);
    44f8:	fcc40513          	addi	a0,s0,-52
    44fc:	00001097          	auipc	ra,0x1
    4500:	676080e7          	jalr	1654(ra) # 5b72 <wait>
    if (xst != -1)
    4504:	fcc42783          	lw	a5,-52(s0)
    4508:	03379d63          	bne	a5,s3,4542 <killstatus+0x86>
  for (int i = 0; i < 100; i++)
    450c:	397d                	addiw	s2,s2,-1
    450e:	fc0913e3          	bnez	s2,44d4 <killstatus+0x18>
  exit(0);
    4512:	4501                	li	a0,0
    4514:	00001097          	auipc	ra,0x1
    4518:	656080e7          	jalr	1622(ra) # 5b6a <exit>
      printf("%s: fork failed\n", s);
    451c:	85d2                	mv	a1,s4
    451e:	00002517          	auipc	a0,0x2
    4522:	48250513          	addi	a0,a0,1154 # 69a0 <malloc+0x9d0>
    4526:	00002097          	auipc	ra,0x2
    452a:	9ec080e7          	jalr	-1556(ra) # 5f12 <printf>
      exit(1);
    452e:	4505                	li	a0,1
    4530:	00001097          	auipc	ra,0x1
    4534:	63a080e7          	jalr	1594(ra) # 5b6a <exit>
        getpid();
    4538:	00001097          	auipc	ra,0x1
    453c:	6b2080e7          	jalr	1714(ra) # 5bea <getpid>
      while (1)
    4540:	bfe5                	j	4538 <killstatus+0x7c>
      printf("%s: status should be -1\n", s);
    4542:	85d2                	mv	a1,s4
    4544:	00003517          	auipc	a0,0x3
    4548:	74c50513          	addi	a0,a0,1868 # 7c90 <malloc+0x1cc0>
    454c:	00002097          	auipc	ra,0x2
    4550:	9c6080e7          	jalr	-1594(ra) # 5f12 <printf>
      exit(1);
    4554:	4505                	li	a0,1
    4556:	00001097          	auipc	ra,0x1
    455a:	614080e7          	jalr	1556(ra) # 5b6a <exit>

000000000000455e <preempt>:
{
    455e:	7139                	addi	sp,sp,-64
    4560:	fc06                	sd	ra,56(sp)
    4562:	f822                	sd	s0,48(sp)
    4564:	f426                	sd	s1,40(sp)
    4566:	f04a                	sd	s2,32(sp)
    4568:	ec4e                	sd	s3,24(sp)
    456a:	e852                	sd	s4,16(sp)
    456c:	0080                	addi	s0,sp,64
    456e:	892a                	mv	s2,a0
  pid1 = fork();
    4570:	00001097          	auipc	ra,0x1
    4574:	5f2080e7          	jalr	1522(ra) # 5b62 <fork>
  if (pid1 < 0)
    4578:	00054563          	bltz	a0,4582 <preempt+0x24>
    457c:	84aa                	mv	s1,a0
  if (pid1 == 0)
    457e:	e105                	bnez	a0,459e <preempt+0x40>
    for (;;)
    4580:	a001                	j	4580 <preempt+0x22>
    printf("%s: fork failed", s);
    4582:	85ca                	mv	a1,s2
    4584:	00002517          	auipc	a0,0x2
    4588:	5dc50513          	addi	a0,a0,1500 # 6b60 <malloc+0xb90>
    458c:	00002097          	auipc	ra,0x2
    4590:	986080e7          	jalr	-1658(ra) # 5f12 <printf>
    exit(1);
    4594:	4505                	li	a0,1
    4596:	00001097          	auipc	ra,0x1
    459a:	5d4080e7          	jalr	1492(ra) # 5b6a <exit>
  pid2 = fork();
    459e:	00001097          	auipc	ra,0x1
    45a2:	5c4080e7          	jalr	1476(ra) # 5b62 <fork>
    45a6:	89aa                	mv	s3,a0
  if (pid2 < 0)
    45a8:	00054463          	bltz	a0,45b0 <preempt+0x52>
  if (pid2 == 0)
    45ac:	e105                	bnez	a0,45cc <preempt+0x6e>
    for (;;)
    45ae:	a001                	j	45ae <preempt+0x50>
    printf("%s: fork failed\n", s);
    45b0:	85ca                	mv	a1,s2
    45b2:	00002517          	auipc	a0,0x2
    45b6:	3ee50513          	addi	a0,a0,1006 # 69a0 <malloc+0x9d0>
    45ba:	00002097          	auipc	ra,0x2
    45be:	958080e7          	jalr	-1704(ra) # 5f12 <printf>
    exit(1);
    45c2:	4505                	li	a0,1
    45c4:	00001097          	auipc	ra,0x1
    45c8:	5a6080e7          	jalr	1446(ra) # 5b6a <exit>
  pipe(pfds);
    45cc:	fc840513          	addi	a0,s0,-56
    45d0:	00001097          	auipc	ra,0x1
    45d4:	5aa080e7          	jalr	1450(ra) # 5b7a <pipe>
  pid3 = fork();
    45d8:	00001097          	auipc	ra,0x1
    45dc:	58a080e7          	jalr	1418(ra) # 5b62 <fork>
    45e0:	8a2a                	mv	s4,a0
  if (pid3 < 0)
    45e2:	02054e63          	bltz	a0,461e <preempt+0xc0>
  if (pid3 == 0)
    45e6:	e525                	bnez	a0,464e <preempt+0xf0>
    close(pfds[0]);
    45e8:	fc842503          	lw	a0,-56(s0)
    45ec:	00001097          	auipc	ra,0x1
    45f0:	5a6080e7          	jalr	1446(ra) # 5b92 <close>
    if (write(pfds[1], "x", 1) != 1)
    45f4:	4605                	li	a2,1
    45f6:	00002597          	auipc	a1,0x2
    45fa:	b9258593          	addi	a1,a1,-1134 # 6188 <malloc+0x1b8>
    45fe:	fcc42503          	lw	a0,-52(s0)
    4602:	00001097          	auipc	ra,0x1
    4606:	588080e7          	jalr	1416(ra) # 5b8a <write>
    460a:	4785                	li	a5,1
    460c:	02f51763          	bne	a0,a5,463a <preempt+0xdc>
    close(pfds[1]);
    4610:	fcc42503          	lw	a0,-52(s0)
    4614:	00001097          	auipc	ra,0x1
    4618:	57e080e7          	jalr	1406(ra) # 5b92 <close>
    for (;;)
    461c:	a001                	j	461c <preempt+0xbe>
    printf("%s: fork failed\n", s);
    461e:	85ca                	mv	a1,s2
    4620:	00002517          	auipc	a0,0x2
    4624:	38050513          	addi	a0,a0,896 # 69a0 <malloc+0x9d0>
    4628:	00002097          	auipc	ra,0x2
    462c:	8ea080e7          	jalr	-1814(ra) # 5f12 <printf>
    exit(1);
    4630:	4505                	li	a0,1
    4632:	00001097          	auipc	ra,0x1
    4636:	538080e7          	jalr	1336(ra) # 5b6a <exit>
      printf("%s: preempt write error", s);
    463a:	85ca                	mv	a1,s2
    463c:	00003517          	auipc	a0,0x3
    4640:	67450513          	addi	a0,a0,1652 # 7cb0 <malloc+0x1ce0>
    4644:	00002097          	auipc	ra,0x2
    4648:	8ce080e7          	jalr	-1842(ra) # 5f12 <printf>
    464c:	b7d1                	j	4610 <preempt+0xb2>
  close(pfds[1]);
    464e:	fcc42503          	lw	a0,-52(s0)
    4652:	00001097          	auipc	ra,0x1
    4656:	540080e7          	jalr	1344(ra) # 5b92 <close>
  if (read(pfds[0], buf, sizeof(buf)) != 1)
    465a:	660d                	lui	a2,0x3
    465c:	00008597          	auipc	a1,0x8
    4660:	61c58593          	addi	a1,a1,1564 # cc78 <buf>
    4664:	fc842503          	lw	a0,-56(s0)
    4668:	00001097          	auipc	ra,0x1
    466c:	51a080e7          	jalr	1306(ra) # 5b82 <read>
    4670:	4785                	li	a5,1
    4672:	02f50363          	beq	a0,a5,4698 <preempt+0x13a>
    printf("%s: preempt read error", s);
    4676:	85ca                	mv	a1,s2
    4678:	00003517          	auipc	a0,0x3
    467c:	65050513          	addi	a0,a0,1616 # 7cc8 <malloc+0x1cf8>
    4680:	00002097          	auipc	ra,0x2
    4684:	892080e7          	jalr	-1902(ra) # 5f12 <printf>
}
    4688:	70e2                	ld	ra,56(sp)
    468a:	7442                	ld	s0,48(sp)
    468c:	74a2                	ld	s1,40(sp)
    468e:	7902                	ld	s2,32(sp)
    4690:	69e2                	ld	s3,24(sp)
    4692:	6a42                	ld	s4,16(sp)
    4694:	6121                	addi	sp,sp,64
    4696:	8082                	ret
  close(pfds[0]);
    4698:	fc842503          	lw	a0,-56(s0)
    469c:	00001097          	auipc	ra,0x1
    46a0:	4f6080e7          	jalr	1270(ra) # 5b92 <close>
  printf("kill... ");
    46a4:	00003517          	auipc	a0,0x3
    46a8:	63c50513          	addi	a0,a0,1596 # 7ce0 <malloc+0x1d10>
    46ac:	00002097          	auipc	ra,0x2
    46b0:	866080e7          	jalr	-1946(ra) # 5f12 <printf>
  kill(pid1);
    46b4:	8526                	mv	a0,s1
    46b6:	00001097          	auipc	ra,0x1
    46ba:	4e4080e7          	jalr	1252(ra) # 5b9a <kill>
  kill(pid2);
    46be:	854e                	mv	a0,s3
    46c0:	00001097          	auipc	ra,0x1
    46c4:	4da080e7          	jalr	1242(ra) # 5b9a <kill>
  kill(pid3);
    46c8:	8552                	mv	a0,s4
    46ca:	00001097          	auipc	ra,0x1
    46ce:	4d0080e7          	jalr	1232(ra) # 5b9a <kill>
  printf("wait... ");
    46d2:	00003517          	auipc	a0,0x3
    46d6:	61e50513          	addi	a0,a0,1566 # 7cf0 <malloc+0x1d20>
    46da:	00002097          	auipc	ra,0x2
    46de:	838080e7          	jalr	-1992(ra) # 5f12 <printf>
  wait(0);
    46e2:	4501                	li	a0,0
    46e4:	00001097          	auipc	ra,0x1
    46e8:	48e080e7          	jalr	1166(ra) # 5b72 <wait>
  wait(0);
    46ec:	4501                	li	a0,0
    46ee:	00001097          	auipc	ra,0x1
    46f2:	484080e7          	jalr	1156(ra) # 5b72 <wait>
  wait(0);
    46f6:	4501                	li	a0,0
    46f8:	00001097          	auipc	ra,0x1
    46fc:	47a080e7          	jalr	1146(ra) # 5b72 <wait>
    4700:	b761                	j	4688 <preempt+0x12a>

0000000000004702 <reparent>:
{
    4702:	7179                	addi	sp,sp,-48
    4704:	f406                	sd	ra,40(sp)
    4706:	f022                	sd	s0,32(sp)
    4708:	ec26                	sd	s1,24(sp)
    470a:	e84a                	sd	s2,16(sp)
    470c:	e44e                	sd	s3,8(sp)
    470e:	e052                	sd	s4,0(sp)
    4710:	1800                	addi	s0,sp,48
    4712:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4714:	00001097          	auipc	ra,0x1
    4718:	4d6080e7          	jalr	1238(ra) # 5bea <getpid>
    471c:	8a2a                	mv	s4,a0
    471e:	0c800913          	li	s2,200
    int pid = fork();
    4722:	00001097          	auipc	ra,0x1
    4726:	440080e7          	jalr	1088(ra) # 5b62 <fork>
    472a:	84aa                	mv	s1,a0
    if (pid < 0)
    472c:	02054263          	bltz	a0,4750 <reparent+0x4e>
    if (pid)
    4730:	cd21                	beqz	a0,4788 <reparent+0x86>
      if (wait(0) != pid)
    4732:	4501                	li	a0,0
    4734:	00001097          	auipc	ra,0x1
    4738:	43e080e7          	jalr	1086(ra) # 5b72 <wait>
    473c:	02951863          	bne	a0,s1,476c <reparent+0x6a>
  for (int i = 0; i < 200; i++)
    4740:	397d                	addiw	s2,s2,-1
    4742:	fe0910e3          	bnez	s2,4722 <reparent+0x20>
  exit(0);
    4746:	4501                	li	a0,0
    4748:	00001097          	auipc	ra,0x1
    474c:	422080e7          	jalr	1058(ra) # 5b6a <exit>
      printf("%s: fork failed\n", s);
    4750:	85ce                	mv	a1,s3
    4752:	00002517          	auipc	a0,0x2
    4756:	24e50513          	addi	a0,a0,590 # 69a0 <malloc+0x9d0>
    475a:	00001097          	auipc	ra,0x1
    475e:	7b8080e7          	jalr	1976(ra) # 5f12 <printf>
      exit(1);
    4762:	4505                	li	a0,1
    4764:	00001097          	auipc	ra,0x1
    4768:	406080e7          	jalr	1030(ra) # 5b6a <exit>
        printf("%s: wait wrong pid\n", s);
    476c:	85ce                	mv	a1,s3
    476e:	00002517          	auipc	a0,0x2
    4772:	3ba50513          	addi	a0,a0,954 # 6b28 <malloc+0xb58>
    4776:	00001097          	auipc	ra,0x1
    477a:	79c080e7          	jalr	1948(ra) # 5f12 <printf>
        exit(1);
    477e:	4505                	li	a0,1
    4780:	00001097          	auipc	ra,0x1
    4784:	3ea080e7          	jalr	1002(ra) # 5b6a <exit>
      int pid2 = fork();
    4788:	00001097          	auipc	ra,0x1
    478c:	3da080e7          	jalr	986(ra) # 5b62 <fork>
      if (pid2 < 0)
    4790:	00054763          	bltz	a0,479e <reparent+0x9c>
      exit(0);
    4794:	4501                	li	a0,0
    4796:	00001097          	auipc	ra,0x1
    479a:	3d4080e7          	jalr	980(ra) # 5b6a <exit>
        kill(master_pid);
    479e:	8552                	mv	a0,s4
    47a0:	00001097          	auipc	ra,0x1
    47a4:	3fa080e7          	jalr	1018(ra) # 5b9a <kill>
        exit(1);
    47a8:	4505                	li	a0,1
    47aa:	00001097          	auipc	ra,0x1
    47ae:	3c0080e7          	jalr	960(ra) # 5b6a <exit>

00000000000047b2 <sbrkfail>:
{
    47b2:	7119                	addi	sp,sp,-128
    47b4:	fc86                	sd	ra,120(sp)
    47b6:	f8a2                	sd	s0,112(sp)
    47b8:	f4a6                	sd	s1,104(sp)
    47ba:	f0ca                	sd	s2,96(sp)
    47bc:	ecce                	sd	s3,88(sp)
    47be:	e8d2                	sd	s4,80(sp)
    47c0:	e4d6                	sd	s5,72(sp)
    47c2:	0100                	addi	s0,sp,128
    47c4:	8aaa                	mv	s5,a0
  if (pipe(fds) != 0)
    47c6:	fb040513          	addi	a0,s0,-80
    47ca:	00001097          	auipc	ra,0x1
    47ce:	3b0080e7          	jalr	944(ra) # 5b7a <pipe>
    47d2:	e901                	bnez	a0,47e2 <sbrkfail+0x30>
    47d4:	f8040493          	addi	s1,s0,-128
    47d8:	fa840993          	addi	s3,s0,-88
    47dc:	8926                	mv	s2,s1
    if (pids[i] != -1)
    47de:	5a7d                	li	s4,-1
    47e0:	a085                	j	4840 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    47e2:	85d6                	mv	a1,s5
    47e4:	00002517          	auipc	a0,0x2
    47e8:	2c450513          	addi	a0,a0,708 # 6aa8 <malloc+0xad8>
    47ec:	00001097          	auipc	ra,0x1
    47f0:	726080e7          	jalr	1830(ra) # 5f12 <printf>
    exit(1);
    47f4:	4505                	li	a0,1
    47f6:	00001097          	auipc	ra,0x1
    47fa:	374080e7          	jalr	884(ra) # 5b6a <exit>
      sbrk(BIG - (uint64)sbrk(0));
    47fe:	00001097          	auipc	ra,0x1
    4802:	3f4080e7          	jalr	1012(ra) # 5bf2 <sbrk>
    4806:	064007b7          	lui	a5,0x6400
    480a:	40a7853b          	subw	a0,a5,a0
    480e:	00001097          	auipc	ra,0x1
    4812:	3e4080e7          	jalr	996(ra) # 5bf2 <sbrk>
      write(fds[1], "x", 1);
    4816:	4605                	li	a2,1
    4818:	00002597          	auipc	a1,0x2
    481c:	97058593          	addi	a1,a1,-1680 # 6188 <malloc+0x1b8>
    4820:	fb442503          	lw	a0,-76(s0)
    4824:	00001097          	auipc	ra,0x1
    4828:	366080e7          	jalr	870(ra) # 5b8a <write>
        sleep(1000);
    482c:	3e800513          	li	a0,1000
    4830:	00001097          	auipc	ra,0x1
    4834:	3ca080e7          	jalr	970(ra) # 5bfa <sleep>
      for (;;)
    4838:	bfd5                	j	482c <sbrkfail+0x7a>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++)
    483a:	0911                	addi	s2,s2,4
    483c:	03390563          	beq	s2,s3,4866 <sbrkfail+0xb4>
    if ((pids[i] = fork()) == 0)
    4840:	00001097          	auipc	ra,0x1
    4844:	322080e7          	jalr	802(ra) # 5b62 <fork>
    4848:	00a92023          	sw	a0,0(s2)
    484c:	d94d                	beqz	a0,47fe <sbrkfail+0x4c>
    if (pids[i] != -1)
    484e:	ff4506e3          	beq	a0,s4,483a <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    4852:	4605                	li	a2,1
    4854:	faf40593          	addi	a1,s0,-81
    4858:	fb042503          	lw	a0,-80(s0)
    485c:	00001097          	auipc	ra,0x1
    4860:	326080e7          	jalr	806(ra) # 5b82 <read>
    4864:	bfd9                	j	483a <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    4866:	6505                	lui	a0,0x1
    4868:	00001097          	auipc	ra,0x1
    486c:	38a080e7          	jalr	906(ra) # 5bf2 <sbrk>
    4870:	8a2a                	mv	s4,a0
    if (pids[i] == -1)
    4872:	597d                	li	s2,-1
    4874:	a021                	j	487c <sbrkfail+0xca>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++)
    4876:	0491                	addi	s1,s1,4
    4878:	01348f63          	beq	s1,s3,4896 <sbrkfail+0xe4>
    if (pids[i] == -1)
    487c:	4088                	lw	a0,0(s1)
    487e:	ff250ce3          	beq	a0,s2,4876 <sbrkfail+0xc4>
    kill(pids[i]);
    4882:	00001097          	auipc	ra,0x1
    4886:	318080e7          	jalr	792(ra) # 5b9a <kill>
    wait(0);
    488a:	4501                	li	a0,0
    488c:	00001097          	auipc	ra,0x1
    4890:	2e6080e7          	jalr	742(ra) # 5b72 <wait>
    4894:	b7cd                	j	4876 <sbrkfail+0xc4>
  if (c == (char *)0xffffffffffffffffL)
    4896:	57fd                	li	a5,-1
    4898:	04fa0163          	beq	s4,a5,48da <sbrkfail+0x128>
  pid = fork();
    489c:	00001097          	auipc	ra,0x1
    48a0:	2c6080e7          	jalr	710(ra) # 5b62 <fork>
    48a4:	84aa                	mv	s1,a0
  if (pid < 0)
    48a6:	04054863          	bltz	a0,48f6 <sbrkfail+0x144>
  if (pid == 0)
    48aa:	c525                	beqz	a0,4912 <sbrkfail+0x160>
  wait(&xstatus);
    48ac:	fbc40513          	addi	a0,s0,-68
    48b0:	00001097          	auipc	ra,0x1
    48b4:	2c2080e7          	jalr	706(ra) # 5b72 <wait>
  if (xstatus != -1 && xstatus != 2)
    48b8:	fbc42783          	lw	a5,-68(s0)
    48bc:	577d                	li	a4,-1
    48be:	00e78563          	beq	a5,a4,48c8 <sbrkfail+0x116>
    48c2:	4709                	li	a4,2
    48c4:	08e79d63          	bne	a5,a4,495e <sbrkfail+0x1ac>
}
    48c8:	70e6                	ld	ra,120(sp)
    48ca:	7446                	ld	s0,112(sp)
    48cc:	74a6                	ld	s1,104(sp)
    48ce:	7906                	ld	s2,96(sp)
    48d0:	69e6                	ld	s3,88(sp)
    48d2:	6a46                	ld	s4,80(sp)
    48d4:	6aa6                	ld	s5,72(sp)
    48d6:	6109                	addi	sp,sp,128
    48d8:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    48da:	85d6                	mv	a1,s5
    48dc:	00003517          	auipc	a0,0x3
    48e0:	42450513          	addi	a0,a0,1060 # 7d00 <malloc+0x1d30>
    48e4:	00001097          	auipc	ra,0x1
    48e8:	62e080e7          	jalr	1582(ra) # 5f12 <printf>
    exit(1);
    48ec:	4505                	li	a0,1
    48ee:	00001097          	auipc	ra,0x1
    48f2:	27c080e7          	jalr	636(ra) # 5b6a <exit>
    printf("%s: fork failed\n", s);
    48f6:	85d6                	mv	a1,s5
    48f8:	00002517          	auipc	a0,0x2
    48fc:	0a850513          	addi	a0,a0,168 # 69a0 <malloc+0x9d0>
    4900:	00001097          	auipc	ra,0x1
    4904:	612080e7          	jalr	1554(ra) # 5f12 <printf>
    exit(1);
    4908:	4505                	li	a0,1
    490a:	00001097          	auipc	ra,0x1
    490e:	260080e7          	jalr	608(ra) # 5b6a <exit>
    a = sbrk(0);
    4912:	4501                	li	a0,0
    4914:	00001097          	auipc	ra,0x1
    4918:	2de080e7          	jalr	734(ra) # 5bf2 <sbrk>
    491c:	892a                	mv	s2,a0
    sbrk(10 * BIG);
    491e:	3e800537          	lui	a0,0x3e800
    4922:	00001097          	auipc	ra,0x1
    4926:	2d0080e7          	jalr	720(ra) # 5bf2 <sbrk>
    for (i = 0; i < 10 * BIG; i += PGSIZE)
    492a:	87ca                	mv	a5,s2
    492c:	3e800737          	lui	a4,0x3e800
    4930:	993a                	add	s2,s2,a4
    4932:	6705                	lui	a4,0x1
      n += *(a + i);
    4934:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f0388>
    4938:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10 * BIG; i += PGSIZE)
    493a:	97ba                	add	a5,a5,a4
    493c:	ff279ce3          	bne	a5,s2,4934 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4940:	8626                	mv	a2,s1
    4942:	85d6                	mv	a1,s5
    4944:	00003517          	auipc	a0,0x3
    4948:	3dc50513          	addi	a0,a0,988 # 7d20 <malloc+0x1d50>
    494c:	00001097          	auipc	ra,0x1
    4950:	5c6080e7          	jalr	1478(ra) # 5f12 <printf>
    exit(1);
    4954:	4505                	li	a0,1
    4956:	00001097          	auipc	ra,0x1
    495a:	214080e7          	jalr	532(ra) # 5b6a <exit>
    exit(1);
    495e:	4505                	li	a0,1
    4960:	00001097          	auipc	ra,0x1
    4964:	20a080e7          	jalr	522(ra) # 5b6a <exit>

0000000000004968 <mem>:
{
    4968:	7139                	addi	sp,sp,-64
    496a:	fc06                	sd	ra,56(sp)
    496c:	f822                	sd	s0,48(sp)
    496e:	f426                	sd	s1,40(sp)
    4970:	f04a                	sd	s2,32(sp)
    4972:	ec4e                	sd	s3,24(sp)
    4974:	0080                	addi	s0,sp,64
    4976:	89aa                	mv	s3,a0
  if ((pid = fork()) == 0)
    4978:	00001097          	auipc	ra,0x1
    497c:	1ea080e7          	jalr	490(ra) # 5b62 <fork>
    m1 = 0;
    4980:	4481                	li	s1,0
    while ((m2 = malloc(10001)) != 0)
    4982:	6909                	lui	s2,0x2
    4984:	71190913          	addi	s2,s2,1809 # 2711 <rwsbrk+0x13>
  if ((pid = fork()) == 0)
    4988:	c115                	beqz	a0,49ac <mem+0x44>
    wait(&xstatus);
    498a:	fcc40513          	addi	a0,s0,-52
    498e:	00001097          	auipc	ra,0x1
    4992:	1e4080e7          	jalr	484(ra) # 5b72 <wait>
    if (xstatus == -1)
    4996:	fcc42503          	lw	a0,-52(s0)
    499a:	57fd                	li	a5,-1
    499c:	06f50363          	beq	a0,a5,4a02 <mem+0x9a>
    exit(xstatus);
    49a0:	00001097          	auipc	ra,0x1
    49a4:	1ca080e7          	jalr	458(ra) # 5b6a <exit>
      *(char **)m2 = m1;
    49a8:	e104                	sd	s1,0(a0)
      m1 = m2;
    49aa:	84aa                	mv	s1,a0
    while ((m2 = malloc(10001)) != 0)
    49ac:	854a                	mv	a0,s2
    49ae:	00001097          	auipc	ra,0x1
    49b2:	622080e7          	jalr	1570(ra) # 5fd0 <malloc>
    49b6:	f96d                	bnez	a0,49a8 <mem+0x40>
    while (m1)
    49b8:	c881                	beqz	s1,49c8 <mem+0x60>
      m2 = *(char **)m1;
    49ba:	8526                	mv	a0,s1
    49bc:	6084                	ld	s1,0(s1)
      free(m1);
    49be:	00001097          	auipc	ra,0x1
    49c2:	58a080e7          	jalr	1418(ra) # 5f48 <free>
    while (m1)
    49c6:	f8f5                	bnez	s1,49ba <mem+0x52>
    m1 = malloc(1024 * 20);
    49c8:	6515                	lui	a0,0x5
    49ca:	00001097          	auipc	ra,0x1
    49ce:	606080e7          	jalr	1542(ra) # 5fd0 <malloc>
    if (m1 == 0)
    49d2:	c911                	beqz	a0,49e6 <mem+0x7e>
    free(m1);
    49d4:	00001097          	auipc	ra,0x1
    49d8:	574080e7          	jalr	1396(ra) # 5f48 <free>
    exit(0);
    49dc:	4501                	li	a0,0
    49de:	00001097          	auipc	ra,0x1
    49e2:	18c080e7          	jalr	396(ra) # 5b6a <exit>
      printf("couldn't allocate mem?!!\n", s);
    49e6:	85ce                	mv	a1,s3
    49e8:	00003517          	auipc	a0,0x3
    49ec:	36850513          	addi	a0,a0,872 # 7d50 <malloc+0x1d80>
    49f0:	00001097          	auipc	ra,0x1
    49f4:	522080e7          	jalr	1314(ra) # 5f12 <printf>
      exit(1);
    49f8:	4505                	li	a0,1
    49fa:	00001097          	auipc	ra,0x1
    49fe:	170080e7          	jalr	368(ra) # 5b6a <exit>
      exit(0);
    4a02:	4501                	li	a0,0
    4a04:	00001097          	auipc	ra,0x1
    4a08:	166080e7          	jalr	358(ra) # 5b6a <exit>

0000000000004a0c <sharedfd>:
{
    4a0c:	7159                	addi	sp,sp,-112
    4a0e:	f486                	sd	ra,104(sp)
    4a10:	f0a2                	sd	s0,96(sp)
    4a12:	eca6                	sd	s1,88(sp)
    4a14:	e8ca                	sd	s2,80(sp)
    4a16:	e4ce                	sd	s3,72(sp)
    4a18:	e0d2                	sd	s4,64(sp)
    4a1a:	fc56                	sd	s5,56(sp)
    4a1c:	f85a                	sd	s6,48(sp)
    4a1e:	f45e                	sd	s7,40(sp)
    4a20:	1880                	addi	s0,sp,112
    4a22:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4a24:	00003517          	auipc	a0,0x3
    4a28:	34c50513          	addi	a0,a0,844 # 7d70 <malloc+0x1da0>
    4a2c:	00001097          	auipc	ra,0x1
    4a30:	18e080e7          	jalr	398(ra) # 5bba <unlink>
  fd = open("sharedfd", O_CREATE | O_RDWR);
    4a34:	20200593          	li	a1,514
    4a38:	00003517          	auipc	a0,0x3
    4a3c:	33850513          	addi	a0,a0,824 # 7d70 <malloc+0x1da0>
    4a40:	00001097          	auipc	ra,0x1
    4a44:	16a080e7          	jalr	362(ra) # 5baa <open>
  if (fd < 0)
    4a48:	04054a63          	bltz	a0,4a9c <sharedfd+0x90>
    4a4c:	892a                	mv	s2,a0
  pid = fork();
    4a4e:	00001097          	auipc	ra,0x1
    4a52:	114080e7          	jalr	276(ra) # 5b62 <fork>
    4a56:	89aa                	mv	s3,a0
  memset(buf, pid == 0 ? 'c' : 'p', sizeof(buf));
    4a58:	06300593          	li	a1,99
    4a5c:	c119                	beqz	a0,4a62 <sharedfd+0x56>
    4a5e:	07000593          	li	a1,112
    4a62:	4629                	li	a2,10
    4a64:	fa040513          	addi	a0,s0,-96
    4a68:	00001097          	auipc	ra,0x1
    4a6c:	f06080e7          	jalr	-250(ra) # 596e <memset>
    4a70:	3e800493          	li	s1,1000
    if (write(fd, buf, sizeof(buf)) != sizeof(buf))
    4a74:	4629                	li	a2,10
    4a76:	fa040593          	addi	a1,s0,-96
    4a7a:	854a                	mv	a0,s2
    4a7c:	00001097          	auipc	ra,0x1
    4a80:	10e080e7          	jalr	270(ra) # 5b8a <write>
    4a84:	47a9                	li	a5,10
    4a86:	02f51963          	bne	a0,a5,4ab8 <sharedfd+0xac>
  for (i = 0; i < N; i++)
    4a8a:	34fd                	addiw	s1,s1,-1
    4a8c:	f4e5                	bnez	s1,4a74 <sharedfd+0x68>
  if (pid == 0)
    4a8e:	04099363          	bnez	s3,4ad4 <sharedfd+0xc8>
    exit(0);
    4a92:	4501                	li	a0,0
    4a94:	00001097          	auipc	ra,0x1
    4a98:	0d6080e7          	jalr	214(ra) # 5b6a <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4a9c:	85d2                	mv	a1,s4
    4a9e:	00003517          	auipc	a0,0x3
    4aa2:	2e250513          	addi	a0,a0,738 # 7d80 <malloc+0x1db0>
    4aa6:	00001097          	auipc	ra,0x1
    4aaa:	46c080e7          	jalr	1132(ra) # 5f12 <printf>
    exit(1);
    4aae:	4505                	li	a0,1
    4ab0:	00001097          	auipc	ra,0x1
    4ab4:	0ba080e7          	jalr	186(ra) # 5b6a <exit>
      printf("%s: write sharedfd failed\n", s);
    4ab8:	85d2                	mv	a1,s4
    4aba:	00003517          	auipc	a0,0x3
    4abe:	2ee50513          	addi	a0,a0,750 # 7da8 <malloc+0x1dd8>
    4ac2:	00001097          	auipc	ra,0x1
    4ac6:	450080e7          	jalr	1104(ra) # 5f12 <printf>
      exit(1);
    4aca:	4505                	li	a0,1
    4acc:	00001097          	auipc	ra,0x1
    4ad0:	09e080e7          	jalr	158(ra) # 5b6a <exit>
    wait(&xstatus);
    4ad4:	f9c40513          	addi	a0,s0,-100
    4ad8:	00001097          	auipc	ra,0x1
    4adc:	09a080e7          	jalr	154(ra) # 5b72 <wait>
    if (xstatus != 0)
    4ae0:	f9c42983          	lw	s3,-100(s0)
    4ae4:	00098763          	beqz	s3,4af2 <sharedfd+0xe6>
      exit(xstatus);
    4ae8:	854e                	mv	a0,s3
    4aea:	00001097          	auipc	ra,0x1
    4aee:	080080e7          	jalr	128(ra) # 5b6a <exit>
  close(fd);
    4af2:	854a                	mv	a0,s2
    4af4:	00001097          	auipc	ra,0x1
    4af8:	09e080e7          	jalr	158(ra) # 5b92 <close>
  fd = open("sharedfd", 0);
    4afc:	4581                	li	a1,0
    4afe:	00003517          	auipc	a0,0x3
    4b02:	27250513          	addi	a0,a0,626 # 7d70 <malloc+0x1da0>
    4b06:	00001097          	auipc	ra,0x1
    4b0a:	0a4080e7          	jalr	164(ra) # 5baa <open>
    4b0e:	8baa                	mv	s7,a0
  nc = np = 0;
    4b10:	8ace                	mv	s5,s3
  if (fd < 0)
    4b12:	02054563          	bltz	a0,4b3c <sharedfd+0x130>
    4b16:	faa40913          	addi	s2,s0,-86
      if (buf[i] == 'c')
    4b1a:	06300493          	li	s1,99
      if (buf[i] == 'p')
    4b1e:	07000b13          	li	s6,112
  while ((n = read(fd, buf, sizeof(buf))) > 0)
    4b22:	4629                	li	a2,10
    4b24:	fa040593          	addi	a1,s0,-96
    4b28:	855e                	mv	a0,s7
    4b2a:	00001097          	auipc	ra,0x1
    4b2e:	058080e7          	jalr	88(ra) # 5b82 <read>
    4b32:	02a05f63          	blez	a0,4b70 <sharedfd+0x164>
    4b36:	fa040793          	addi	a5,s0,-96
    4b3a:	a01d                	j	4b60 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4b3c:	85d2                	mv	a1,s4
    4b3e:	00003517          	auipc	a0,0x3
    4b42:	28a50513          	addi	a0,a0,650 # 7dc8 <malloc+0x1df8>
    4b46:	00001097          	auipc	ra,0x1
    4b4a:	3cc080e7          	jalr	972(ra) # 5f12 <printf>
    exit(1);
    4b4e:	4505                	li	a0,1
    4b50:	00001097          	auipc	ra,0x1
    4b54:	01a080e7          	jalr	26(ra) # 5b6a <exit>
        nc++;
    4b58:	2985                	addiw	s3,s3,1
    for (i = 0; i < sizeof(buf); i++)
    4b5a:	0785                	addi	a5,a5,1
    4b5c:	fd2783e3          	beq	a5,s2,4b22 <sharedfd+0x116>
      if (buf[i] == 'c')
    4b60:	0007c703          	lbu	a4,0(a5)
    4b64:	fe970ae3          	beq	a4,s1,4b58 <sharedfd+0x14c>
      if (buf[i] == 'p')
    4b68:	ff6719e3          	bne	a4,s6,4b5a <sharedfd+0x14e>
        np++;
    4b6c:	2a85                	addiw	s5,s5,1
    4b6e:	b7f5                	j	4b5a <sharedfd+0x14e>
  close(fd);
    4b70:	855e                	mv	a0,s7
    4b72:	00001097          	auipc	ra,0x1
    4b76:	020080e7          	jalr	32(ra) # 5b92 <close>
  unlink("sharedfd");
    4b7a:	00003517          	auipc	a0,0x3
    4b7e:	1f650513          	addi	a0,a0,502 # 7d70 <malloc+0x1da0>
    4b82:	00001097          	auipc	ra,0x1
    4b86:	038080e7          	jalr	56(ra) # 5bba <unlink>
  if (nc == N * SZ && np == N * SZ)
    4b8a:	6789                	lui	a5,0x2
    4b8c:	71078793          	addi	a5,a5,1808 # 2710 <rwsbrk+0x12>
    4b90:	00f99763          	bne	s3,a5,4b9e <sharedfd+0x192>
    4b94:	6789                	lui	a5,0x2
    4b96:	71078793          	addi	a5,a5,1808 # 2710 <rwsbrk+0x12>
    4b9a:	02fa8063          	beq	s5,a5,4bba <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4b9e:	85d2                	mv	a1,s4
    4ba0:	00003517          	auipc	a0,0x3
    4ba4:	25050513          	addi	a0,a0,592 # 7df0 <malloc+0x1e20>
    4ba8:	00001097          	auipc	ra,0x1
    4bac:	36a080e7          	jalr	874(ra) # 5f12 <printf>
    exit(1);
    4bb0:	4505                	li	a0,1
    4bb2:	00001097          	auipc	ra,0x1
    4bb6:	fb8080e7          	jalr	-72(ra) # 5b6a <exit>
    exit(0);
    4bba:	4501                	li	a0,0
    4bbc:	00001097          	auipc	ra,0x1
    4bc0:	fae080e7          	jalr	-82(ra) # 5b6a <exit>

0000000000004bc4 <fourfiles>:
{
    4bc4:	7171                	addi	sp,sp,-176
    4bc6:	f506                	sd	ra,168(sp)
    4bc8:	f122                	sd	s0,160(sp)
    4bca:	ed26                	sd	s1,152(sp)
    4bcc:	e94a                	sd	s2,144(sp)
    4bce:	e54e                	sd	s3,136(sp)
    4bd0:	e152                	sd	s4,128(sp)
    4bd2:	fcd6                	sd	s5,120(sp)
    4bd4:	f8da                	sd	s6,112(sp)
    4bd6:	f4de                	sd	s7,104(sp)
    4bd8:	f0e2                	sd	s8,96(sp)
    4bda:	ece6                	sd	s9,88(sp)
    4bdc:	e8ea                	sd	s10,80(sp)
    4bde:	e4ee                	sd	s11,72(sp)
    4be0:	1900                	addi	s0,sp,176
    4be2:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = {"f0", "f1", "f2", "f3"};
    4be6:	00001797          	auipc	a5,0x1
    4bea:	4da78793          	addi	a5,a5,1242 # 60c0 <malloc+0xf0>
    4bee:	f6f43823          	sd	a5,-144(s0)
    4bf2:	00001797          	auipc	a5,0x1
    4bf6:	4d678793          	addi	a5,a5,1238 # 60c8 <malloc+0xf8>
    4bfa:	f6f43c23          	sd	a5,-136(s0)
    4bfe:	00001797          	auipc	a5,0x1
    4c02:	4d278793          	addi	a5,a5,1234 # 60d0 <malloc+0x100>
    4c06:	f8f43023          	sd	a5,-128(s0)
    4c0a:	00001797          	auipc	a5,0x1
    4c0e:	4ce78793          	addi	a5,a5,1230 # 60d8 <malloc+0x108>
    4c12:	f8f43423          	sd	a5,-120(s0)
  for (pi = 0; pi < NCHILD; pi++)
    4c16:	f7040c13          	addi	s8,s0,-144
  char *names[] = {"f0", "f1", "f2", "f3"};
    4c1a:	8962                	mv	s2,s8
  for (pi = 0; pi < NCHILD; pi++)
    4c1c:	4481                	li	s1,0
    4c1e:	4a11                	li	s4,4
    fname = names[pi];
    4c20:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4c24:	854e                	mv	a0,s3
    4c26:	00001097          	auipc	ra,0x1
    4c2a:	f94080e7          	jalr	-108(ra) # 5bba <unlink>
    pid = fork();
    4c2e:	00001097          	auipc	ra,0x1
    4c32:	f34080e7          	jalr	-204(ra) # 5b62 <fork>
    if (pid < 0)
    4c36:	04054463          	bltz	a0,4c7e <fourfiles+0xba>
    if (pid == 0)
    4c3a:	c12d                	beqz	a0,4c9c <fourfiles+0xd8>
  for (pi = 0; pi < NCHILD; pi++)
    4c3c:	2485                	addiw	s1,s1,1
    4c3e:	0921                	addi	s2,s2,8
    4c40:	ff4490e3          	bne	s1,s4,4c20 <fourfiles+0x5c>
    4c44:	4491                	li	s1,4
    wait(&xstatus);
    4c46:	f6c40513          	addi	a0,s0,-148
    4c4a:	00001097          	auipc	ra,0x1
    4c4e:	f28080e7          	jalr	-216(ra) # 5b72 <wait>
    if (xstatus != 0)
    4c52:	f6c42b03          	lw	s6,-148(s0)
    4c56:	0c0b1e63          	bnez	s6,4d32 <fourfiles+0x16e>
  for (pi = 0; pi < NCHILD; pi++)
    4c5a:	34fd                	addiw	s1,s1,-1
    4c5c:	f4ed                	bnez	s1,4c46 <fourfiles+0x82>
    4c5e:	03000b93          	li	s7,48
    while ((n = read(fd, buf, sizeof(buf))) > 0)
    4c62:	00008a17          	auipc	s4,0x8
    4c66:	016a0a13          	addi	s4,s4,22 # cc78 <buf>
    4c6a:	00008a97          	auipc	s5,0x8
    4c6e:	00fa8a93          	addi	s5,s5,15 # cc79 <buf+0x1>
    if (total != N * SZ)
    4c72:	6d85                	lui	s11,0x1
    4c74:	770d8d93          	addi	s11,s11,1904 # 1770 <exectest+0x1c>
  for (i = 0; i < NCHILD; i++)
    4c78:	03400d13          	li	s10,52
    4c7c:	aa1d                	j	4db2 <fourfiles+0x1ee>
      printf("fork failed\n", s);
    4c7e:	f5843583          	ld	a1,-168(s0)
    4c82:	00002517          	auipc	a0,0x2
    4c86:	12650513          	addi	a0,a0,294 # 6da8 <malloc+0xdd8>
    4c8a:	00001097          	auipc	ra,0x1
    4c8e:	288080e7          	jalr	648(ra) # 5f12 <printf>
      exit(1);
    4c92:	4505                	li	a0,1
    4c94:	00001097          	auipc	ra,0x1
    4c98:	ed6080e7          	jalr	-298(ra) # 5b6a <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4c9c:	20200593          	li	a1,514
    4ca0:	854e                	mv	a0,s3
    4ca2:	00001097          	auipc	ra,0x1
    4ca6:	f08080e7          	jalr	-248(ra) # 5baa <open>
    4caa:	892a                	mv	s2,a0
      if (fd < 0)
    4cac:	04054763          	bltz	a0,4cfa <fourfiles+0x136>
      memset(buf, '0' + pi, SZ);
    4cb0:	1f400613          	li	a2,500
    4cb4:	0304859b          	addiw	a1,s1,48
    4cb8:	00008517          	auipc	a0,0x8
    4cbc:	fc050513          	addi	a0,a0,-64 # cc78 <buf>
    4cc0:	00001097          	auipc	ra,0x1
    4cc4:	cae080e7          	jalr	-850(ra) # 596e <memset>
    4cc8:	44b1                	li	s1,12
        if ((n = write(fd, buf, SZ)) != SZ)
    4cca:	00008997          	auipc	s3,0x8
    4cce:	fae98993          	addi	s3,s3,-82 # cc78 <buf>
    4cd2:	1f400613          	li	a2,500
    4cd6:	85ce                	mv	a1,s3
    4cd8:	854a                	mv	a0,s2
    4cda:	00001097          	auipc	ra,0x1
    4cde:	eb0080e7          	jalr	-336(ra) # 5b8a <write>
    4ce2:	85aa                	mv	a1,a0
    4ce4:	1f400793          	li	a5,500
    4ce8:	02f51863          	bne	a0,a5,4d18 <fourfiles+0x154>
      for (i = 0; i < N; i++)
    4cec:	34fd                	addiw	s1,s1,-1
    4cee:	f0f5                	bnez	s1,4cd2 <fourfiles+0x10e>
      exit(0);
    4cf0:	4501                	li	a0,0
    4cf2:	00001097          	auipc	ra,0x1
    4cf6:	e78080e7          	jalr	-392(ra) # 5b6a <exit>
        printf("create failed\n", s);
    4cfa:	f5843583          	ld	a1,-168(s0)
    4cfe:	00003517          	auipc	a0,0x3
    4d02:	10a50513          	addi	a0,a0,266 # 7e08 <malloc+0x1e38>
    4d06:	00001097          	auipc	ra,0x1
    4d0a:	20c080e7          	jalr	524(ra) # 5f12 <printf>
        exit(1);
    4d0e:	4505                	li	a0,1
    4d10:	00001097          	auipc	ra,0x1
    4d14:	e5a080e7          	jalr	-422(ra) # 5b6a <exit>
          printf("write failed %d\n", n);
    4d18:	00003517          	auipc	a0,0x3
    4d1c:	10050513          	addi	a0,a0,256 # 7e18 <malloc+0x1e48>
    4d20:	00001097          	auipc	ra,0x1
    4d24:	1f2080e7          	jalr	498(ra) # 5f12 <printf>
          exit(1);
    4d28:	4505                	li	a0,1
    4d2a:	00001097          	auipc	ra,0x1
    4d2e:	e40080e7          	jalr	-448(ra) # 5b6a <exit>
      exit(xstatus);
    4d32:	855a                	mv	a0,s6
    4d34:	00001097          	auipc	ra,0x1
    4d38:	e36080e7          	jalr	-458(ra) # 5b6a <exit>
          printf("wrong char\n", s);
    4d3c:	f5843583          	ld	a1,-168(s0)
    4d40:	00003517          	auipc	a0,0x3
    4d44:	0f050513          	addi	a0,a0,240 # 7e30 <malloc+0x1e60>
    4d48:	00001097          	auipc	ra,0x1
    4d4c:	1ca080e7          	jalr	458(ra) # 5f12 <printf>
          exit(1);
    4d50:	4505                	li	a0,1
    4d52:	00001097          	auipc	ra,0x1
    4d56:	e18080e7          	jalr	-488(ra) # 5b6a <exit>
      total += n;
    4d5a:	00a9093b          	addw	s2,s2,a0
    while ((n = read(fd, buf, sizeof(buf))) > 0)
    4d5e:	660d                	lui	a2,0x3
    4d60:	85d2                	mv	a1,s4
    4d62:	854e                	mv	a0,s3
    4d64:	00001097          	auipc	ra,0x1
    4d68:	e1e080e7          	jalr	-482(ra) # 5b82 <read>
    4d6c:	02a05363          	blez	a0,4d92 <fourfiles+0x1ce>
    4d70:	00008797          	auipc	a5,0x8
    4d74:	f0878793          	addi	a5,a5,-248 # cc78 <buf>
    4d78:	fff5069b          	addiw	a3,a0,-1
    4d7c:	1682                	slli	a3,a3,0x20
    4d7e:	9281                	srli	a3,a3,0x20
    4d80:	96d6                	add	a3,a3,s5
        if (buf[j] != '0' + i)
    4d82:	0007c703          	lbu	a4,0(a5)
    4d86:	fa971be3          	bne	a4,s1,4d3c <fourfiles+0x178>
      for (j = 0; j < n; j++)
    4d8a:	0785                	addi	a5,a5,1
    4d8c:	fed79be3          	bne	a5,a3,4d82 <fourfiles+0x1be>
    4d90:	b7e9                	j	4d5a <fourfiles+0x196>
    close(fd);
    4d92:	854e                	mv	a0,s3
    4d94:	00001097          	auipc	ra,0x1
    4d98:	dfe080e7          	jalr	-514(ra) # 5b92 <close>
    if (total != N * SZ)
    4d9c:	03b91863          	bne	s2,s11,4dcc <fourfiles+0x208>
    unlink(fname);
    4da0:	8566                	mv	a0,s9
    4da2:	00001097          	auipc	ra,0x1
    4da6:	e18080e7          	jalr	-488(ra) # 5bba <unlink>
  for (i = 0; i < NCHILD; i++)
    4daa:	0c21                	addi	s8,s8,8
    4dac:	2b85                	addiw	s7,s7,1
    4dae:	03ab8d63          	beq	s7,s10,4de8 <fourfiles+0x224>
    fname = names[i];
    4db2:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    4db6:	4581                	li	a1,0
    4db8:	8566                	mv	a0,s9
    4dba:	00001097          	auipc	ra,0x1
    4dbe:	df0080e7          	jalr	-528(ra) # 5baa <open>
    4dc2:	89aa                	mv	s3,a0
    total = 0;
    4dc4:	895a                	mv	s2,s6
        if (buf[j] != '0' + i)
    4dc6:	000b849b          	sext.w	s1,s7
    while ((n = read(fd, buf, sizeof(buf))) > 0)
    4dca:	bf51                	j	4d5e <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    4dcc:	85ca                	mv	a1,s2
    4dce:	00003517          	auipc	a0,0x3
    4dd2:	07250513          	addi	a0,a0,114 # 7e40 <malloc+0x1e70>
    4dd6:	00001097          	auipc	ra,0x1
    4dda:	13c080e7          	jalr	316(ra) # 5f12 <printf>
      exit(1);
    4dde:	4505                	li	a0,1
    4de0:	00001097          	auipc	ra,0x1
    4de4:	d8a080e7          	jalr	-630(ra) # 5b6a <exit>
}
    4de8:	70aa                	ld	ra,168(sp)
    4dea:	740a                	ld	s0,160(sp)
    4dec:	64ea                	ld	s1,152(sp)
    4dee:	694a                	ld	s2,144(sp)
    4df0:	69aa                	ld	s3,136(sp)
    4df2:	6a0a                	ld	s4,128(sp)
    4df4:	7ae6                	ld	s5,120(sp)
    4df6:	7b46                	ld	s6,112(sp)
    4df8:	7ba6                	ld	s7,104(sp)
    4dfa:	7c06                	ld	s8,96(sp)
    4dfc:	6ce6                	ld	s9,88(sp)
    4dfe:	6d46                	ld	s10,80(sp)
    4e00:	6da6                	ld	s11,72(sp)
    4e02:	614d                	addi	sp,sp,176
    4e04:	8082                	ret

0000000000004e06 <concreate>:
{
    4e06:	7135                	addi	sp,sp,-160
    4e08:	ed06                	sd	ra,152(sp)
    4e0a:	e922                	sd	s0,144(sp)
    4e0c:	e526                	sd	s1,136(sp)
    4e0e:	e14a                	sd	s2,128(sp)
    4e10:	fcce                	sd	s3,120(sp)
    4e12:	f8d2                	sd	s4,112(sp)
    4e14:	f4d6                	sd	s5,104(sp)
    4e16:	f0da                	sd	s6,96(sp)
    4e18:	ecde                	sd	s7,88(sp)
    4e1a:	1100                	addi	s0,sp,160
    4e1c:	89aa                	mv	s3,a0
  file[0] = 'C';
    4e1e:	04300793          	li	a5,67
    4e22:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4e26:	fa040523          	sb	zero,-86(s0)
  for (i = 0; i < N; i++)
    4e2a:	4901                	li	s2,0
    if (pid && (i % 3) == 1)
    4e2c:	4b0d                	li	s6,3
    4e2e:	4a85                	li	s5,1
      link("C0", file);
    4e30:	00003b97          	auipc	s7,0x3
    4e34:	028b8b93          	addi	s7,s7,40 # 7e58 <malloc+0x1e88>
  for (i = 0; i < N; i++)
    4e38:	02800a13          	li	s4,40
    4e3c:	acc1                	j	510c <concreate+0x306>
      link("C0", file);
    4e3e:	fa840593          	addi	a1,s0,-88
    4e42:	855e                	mv	a0,s7
    4e44:	00001097          	auipc	ra,0x1
    4e48:	d86080e7          	jalr	-634(ra) # 5bca <link>
    if (pid == 0)
    4e4c:	a45d                	j	50f2 <concreate+0x2ec>
    else if (pid == 0 && (i % 5) == 1)
    4e4e:	4795                	li	a5,5
    4e50:	02f9693b          	remw	s2,s2,a5
    4e54:	4785                	li	a5,1
    4e56:	02f90b63          	beq	s2,a5,4e8c <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4e5a:	20200593          	li	a1,514
    4e5e:	fa840513          	addi	a0,s0,-88
    4e62:	00001097          	auipc	ra,0x1
    4e66:	d48080e7          	jalr	-696(ra) # 5baa <open>
      if (fd < 0)
    4e6a:	26055b63          	bgez	a0,50e0 <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    4e6e:	fa840593          	addi	a1,s0,-88
    4e72:	00003517          	auipc	a0,0x3
    4e76:	fee50513          	addi	a0,a0,-18 # 7e60 <malloc+0x1e90>
    4e7a:	00001097          	auipc	ra,0x1
    4e7e:	098080e7          	jalr	152(ra) # 5f12 <printf>
        exit(1);
    4e82:	4505                	li	a0,1
    4e84:	00001097          	auipc	ra,0x1
    4e88:	ce6080e7          	jalr	-794(ra) # 5b6a <exit>
      link("C0", file);
    4e8c:	fa840593          	addi	a1,s0,-88
    4e90:	00003517          	auipc	a0,0x3
    4e94:	fc850513          	addi	a0,a0,-56 # 7e58 <malloc+0x1e88>
    4e98:	00001097          	auipc	ra,0x1
    4e9c:	d32080e7          	jalr	-718(ra) # 5bca <link>
      exit(0);
    4ea0:	4501                	li	a0,0
    4ea2:	00001097          	auipc	ra,0x1
    4ea6:	cc8080e7          	jalr	-824(ra) # 5b6a <exit>
        exit(1);
    4eaa:	4505                	li	a0,1
    4eac:	00001097          	auipc	ra,0x1
    4eb0:	cbe080e7          	jalr	-834(ra) # 5b6a <exit>
  memset(fa, 0, sizeof(fa));
    4eb4:	02800613          	li	a2,40
    4eb8:	4581                	li	a1,0
    4eba:	f8040513          	addi	a0,s0,-128
    4ebe:	00001097          	auipc	ra,0x1
    4ec2:	ab0080e7          	jalr	-1360(ra) # 596e <memset>
  fd = open(".", 0);
    4ec6:	4581                	li	a1,0
    4ec8:	00002517          	auipc	a0,0x2
    4ecc:	93850513          	addi	a0,a0,-1736 # 6800 <malloc+0x830>
    4ed0:	00001097          	auipc	ra,0x1
    4ed4:	cda080e7          	jalr	-806(ra) # 5baa <open>
    4ed8:	892a                	mv	s2,a0
  n = 0;
    4eda:	8aa6                	mv	s5,s1
    if (de.name[0] == 'C' && de.name[2] == '\0')
    4edc:	04300a13          	li	s4,67
      if (i < 0 || i >= sizeof(fa))
    4ee0:	02700b13          	li	s6,39
      fa[i] = 1;
    4ee4:	4b85                	li	s7,1
  while (read(fd, &de, sizeof(de)) > 0)
    4ee6:	4641                	li	a2,16
    4ee8:	f7040593          	addi	a1,s0,-144
    4eec:	854a                	mv	a0,s2
    4eee:	00001097          	auipc	ra,0x1
    4ef2:	c94080e7          	jalr	-876(ra) # 5b82 <read>
    4ef6:	08a05163          	blez	a0,4f78 <concreate+0x172>
    if (de.inum == 0)
    4efa:	f7045783          	lhu	a5,-144(s0)
    4efe:	d7e5                	beqz	a5,4ee6 <concreate+0xe0>
    if (de.name[0] == 'C' && de.name[2] == '\0')
    4f00:	f7244783          	lbu	a5,-142(s0)
    4f04:	ff4791e3          	bne	a5,s4,4ee6 <concreate+0xe0>
    4f08:	f7444783          	lbu	a5,-140(s0)
    4f0c:	ffe9                	bnez	a5,4ee6 <concreate+0xe0>
      i = de.name[1] - '0';
    4f0e:	f7344783          	lbu	a5,-141(s0)
    4f12:	fd07879b          	addiw	a5,a5,-48
    4f16:	0007871b          	sext.w	a4,a5
      if (i < 0 || i >= sizeof(fa))
    4f1a:	00eb6f63          	bltu	s6,a4,4f38 <concreate+0x132>
      if (fa[i])
    4f1e:	fb040793          	addi	a5,s0,-80
    4f22:	97ba                	add	a5,a5,a4
    4f24:	fd07c783          	lbu	a5,-48(a5)
    4f28:	eb85                	bnez	a5,4f58 <concreate+0x152>
      fa[i] = 1;
    4f2a:	fb040793          	addi	a5,s0,-80
    4f2e:	973e                	add	a4,a4,a5
    4f30:	fd770823          	sb	s7,-48(a4) # fd0 <linktest+0xc8>
      n++;
    4f34:	2a85                	addiw	s5,s5,1
    4f36:	bf45                	j	4ee6 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4f38:	f7240613          	addi	a2,s0,-142
    4f3c:	85ce                	mv	a1,s3
    4f3e:	00003517          	auipc	a0,0x3
    4f42:	f4250513          	addi	a0,a0,-190 # 7e80 <malloc+0x1eb0>
    4f46:	00001097          	auipc	ra,0x1
    4f4a:	fcc080e7          	jalr	-52(ra) # 5f12 <printf>
        exit(1);
    4f4e:	4505                	li	a0,1
    4f50:	00001097          	auipc	ra,0x1
    4f54:	c1a080e7          	jalr	-998(ra) # 5b6a <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4f58:	f7240613          	addi	a2,s0,-142
    4f5c:	85ce                	mv	a1,s3
    4f5e:	00003517          	auipc	a0,0x3
    4f62:	f4250513          	addi	a0,a0,-190 # 7ea0 <malloc+0x1ed0>
    4f66:	00001097          	auipc	ra,0x1
    4f6a:	fac080e7          	jalr	-84(ra) # 5f12 <printf>
        exit(1);
    4f6e:	4505                	li	a0,1
    4f70:	00001097          	auipc	ra,0x1
    4f74:	bfa080e7          	jalr	-1030(ra) # 5b6a <exit>
  close(fd);
    4f78:	854a                	mv	a0,s2
    4f7a:	00001097          	auipc	ra,0x1
    4f7e:	c18080e7          	jalr	-1000(ra) # 5b92 <close>
  if (n != N)
    4f82:	02800793          	li	a5,40
    4f86:	00fa9763          	bne	s5,a5,4f94 <concreate+0x18e>
    if (((i % 3) == 0 && pid == 0) ||
    4f8a:	4a8d                	li	s5,3
    4f8c:	4b05                	li	s6,1
  for (i = 0; i < N; i++)
    4f8e:	02800a13          	li	s4,40
    4f92:	a8c9                	j	5064 <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    4f94:	85ce                	mv	a1,s3
    4f96:	00003517          	auipc	a0,0x3
    4f9a:	f3250513          	addi	a0,a0,-206 # 7ec8 <malloc+0x1ef8>
    4f9e:	00001097          	auipc	ra,0x1
    4fa2:	f74080e7          	jalr	-140(ra) # 5f12 <printf>
    exit(1);
    4fa6:	4505                	li	a0,1
    4fa8:	00001097          	auipc	ra,0x1
    4fac:	bc2080e7          	jalr	-1086(ra) # 5b6a <exit>
      printf("%s: fork failed\n", s);
    4fb0:	85ce                	mv	a1,s3
    4fb2:	00002517          	auipc	a0,0x2
    4fb6:	9ee50513          	addi	a0,a0,-1554 # 69a0 <malloc+0x9d0>
    4fba:	00001097          	auipc	ra,0x1
    4fbe:	f58080e7          	jalr	-168(ra) # 5f12 <printf>
      exit(1);
    4fc2:	4505                	li	a0,1
    4fc4:	00001097          	auipc	ra,0x1
    4fc8:	ba6080e7          	jalr	-1114(ra) # 5b6a <exit>
      close(open(file, 0));
    4fcc:	4581                	li	a1,0
    4fce:	fa840513          	addi	a0,s0,-88
    4fd2:	00001097          	auipc	ra,0x1
    4fd6:	bd8080e7          	jalr	-1064(ra) # 5baa <open>
    4fda:	00001097          	auipc	ra,0x1
    4fde:	bb8080e7          	jalr	-1096(ra) # 5b92 <close>
      close(open(file, 0));
    4fe2:	4581                	li	a1,0
    4fe4:	fa840513          	addi	a0,s0,-88
    4fe8:	00001097          	auipc	ra,0x1
    4fec:	bc2080e7          	jalr	-1086(ra) # 5baa <open>
    4ff0:	00001097          	auipc	ra,0x1
    4ff4:	ba2080e7          	jalr	-1118(ra) # 5b92 <close>
      close(open(file, 0));
    4ff8:	4581                	li	a1,0
    4ffa:	fa840513          	addi	a0,s0,-88
    4ffe:	00001097          	auipc	ra,0x1
    5002:	bac080e7          	jalr	-1108(ra) # 5baa <open>
    5006:	00001097          	auipc	ra,0x1
    500a:	b8c080e7          	jalr	-1140(ra) # 5b92 <close>
      close(open(file, 0));
    500e:	4581                	li	a1,0
    5010:	fa840513          	addi	a0,s0,-88
    5014:	00001097          	auipc	ra,0x1
    5018:	b96080e7          	jalr	-1130(ra) # 5baa <open>
    501c:	00001097          	auipc	ra,0x1
    5020:	b76080e7          	jalr	-1162(ra) # 5b92 <close>
      close(open(file, 0));
    5024:	4581                	li	a1,0
    5026:	fa840513          	addi	a0,s0,-88
    502a:	00001097          	auipc	ra,0x1
    502e:	b80080e7          	jalr	-1152(ra) # 5baa <open>
    5032:	00001097          	auipc	ra,0x1
    5036:	b60080e7          	jalr	-1184(ra) # 5b92 <close>
      close(open(file, 0));
    503a:	4581                	li	a1,0
    503c:	fa840513          	addi	a0,s0,-88
    5040:	00001097          	auipc	ra,0x1
    5044:	b6a080e7          	jalr	-1174(ra) # 5baa <open>
    5048:	00001097          	auipc	ra,0x1
    504c:	b4a080e7          	jalr	-1206(ra) # 5b92 <close>
    if (pid == 0)
    5050:	08090363          	beqz	s2,50d6 <concreate+0x2d0>
      wait(0);
    5054:	4501                	li	a0,0
    5056:	00001097          	auipc	ra,0x1
    505a:	b1c080e7          	jalr	-1252(ra) # 5b72 <wait>
  for (i = 0; i < N; i++)
    505e:	2485                	addiw	s1,s1,1
    5060:	0f448563          	beq	s1,s4,514a <concreate+0x344>
    file[1] = '0' + i;
    5064:	0304879b          	addiw	a5,s1,48
    5068:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    506c:	00001097          	auipc	ra,0x1
    5070:	af6080e7          	jalr	-1290(ra) # 5b62 <fork>
    5074:	892a                	mv	s2,a0
    if (pid < 0)
    5076:	f2054de3          	bltz	a0,4fb0 <concreate+0x1aa>
    if (((i % 3) == 0 && pid == 0) ||
    507a:	0354e73b          	remw	a4,s1,s5
    507e:	00a767b3          	or	a5,a4,a0
    5082:	2781                	sext.w	a5,a5
    5084:	d7a1                	beqz	a5,4fcc <concreate+0x1c6>
    5086:	01671363          	bne	a4,s6,508c <concreate+0x286>
        ((i % 3) == 1 && pid != 0))
    508a:	f129                	bnez	a0,4fcc <concreate+0x1c6>
      unlink(file);
    508c:	fa840513          	addi	a0,s0,-88
    5090:	00001097          	auipc	ra,0x1
    5094:	b2a080e7          	jalr	-1238(ra) # 5bba <unlink>
      unlink(file);
    5098:	fa840513          	addi	a0,s0,-88
    509c:	00001097          	auipc	ra,0x1
    50a0:	b1e080e7          	jalr	-1250(ra) # 5bba <unlink>
      unlink(file);
    50a4:	fa840513          	addi	a0,s0,-88
    50a8:	00001097          	auipc	ra,0x1
    50ac:	b12080e7          	jalr	-1262(ra) # 5bba <unlink>
      unlink(file);
    50b0:	fa840513          	addi	a0,s0,-88
    50b4:	00001097          	auipc	ra,0x1
    50b8:	b06080e7          	jalr	-1274(ra) # 5bba <unlink>
      unlink(file);
    50bc:	fa840513          	addi	a0,s0,-88
    50c0:	00001097          	auipc	ra,0x1
    50c4:	afa080e7          	jalr	-1286(ra) # 5bba <unlink>
      unlink(file);
    50c8:	fa840513          	addi	a0,s0,-88
    50cc:	00001097          	auipc	ra,0x1
    50d0:	aee080e7          	jalr	-1298(ra) # 5bba <unlink>
    50d4:	bfb5                	j	5050 <concreate+0x24a>
      exit(0);
    50d6:	4501                	li	a0,0
    50d8:	00001097          	auipc	ra,0x1
    50dc:	a92080e7          	jalr	-1390(ra) # 5b6a <exit>
      close(fd);
    50e0:	00001097          	auipc	ra,0x1
    50e4:	ab2080e7          	jalr	-1358(ra) # 5b92 <close>
    if (pid == 0)
    50e8:	bb65                	j	4ea0 <concreate+0x9a>
      close(fd);
    50ea:	00001097          	auipc	ra,0x1
    50ee:	aa8080e7          	jalr	-1368(ra) # 5b92 <close>
      wait(&xstatus);
    50f2:	f6c40513          	addi	a0,s0,-148
    50f6:	00001097          	auipc	ra,0x1
    50fa:	a7c080e7          	jalr	-1412(ra) # 5b72 <wait>
      if (xstatus != 0)
    50fe:	f6c42483          	lw	s1,-148(s0)
    5102:	da0494e3          	bnez	s1,4eaa <concreate+0xa4>
  for (i = 0; i < N; i++)
    5106:	2905                	addiw	s2,s2,1
    5108:	db4906e3          	beq	s2,s4,4eb4 <concreate+0xae>
    file[1] = '0' + i;
    510c:	0309079b          	addiw	a5,s2,48
    5110:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    5114:	fa840513          	addi	a0,s0,-88
    5118:	00001097          	auipc	ra,0x1
    511c:	aa2080e7          	jalr	-1374(ra) # 5bba <unlink>
    pid = fork();
    5120:	00001097          	auipc	ra,0x1
    5124:	a42080e7          	jalr	-1470(ra) # 5b62 <fork>
    if (pid && (i % 3) == 1)
    5128:	d20503e3          	beqz	a0,4e4e <concreate+0x48>
    512c:	036967bb          	remw	a5,s2,s6
    5130:	d15787e3          	beq	a5,s5,4e3e <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    5134:	20200593          	li	a1,514
    5138:	fa840513          	addi	a0,s0,-88
    513c:	00001097          	auipc	ra,0x1
    5140:	a6e080e7          	jalr	-1426(ra) # 5baa <open>
      if (fd < 0)
    5144:	fa0553e3          	bgez	a0,50ea <concreate+0x2e4>
    5148:	b31d                	j	4e6e <concreate+0x68>
}
    514a:	60ea                	ld	ra,152(sp)
    514c:	644a                	ld	s0,144(sp)
    514e:	64aa                	ld	s1,136(sp)
    5150:	690a                	ld	s2,128(sp)
    5152:	79e6                	ld	s3,120(sp)
    5154:	7a46                	ld	s4,112(sp)
    5156:	7aa6                	ld	s5,104(sp)
    5158:	7b06                	ld	s6,96(sp)
    515a:	6be6                	ld	s7,88(sp)
    515c:	610d                	addi	sp,sp,160
    515e:	8082                	ret

0000000000005160 <bigfile>:
{
    5160:	7139                	addi	sp,sp,-64
    5162:	fc06                	sd	ra,56(sp)
    5164:	f822                	sd	s0,48(sp)
    5166:	f426                	sd	s1,40(sp)
    5168:	f04a                	sd	s2,32(sp)
    516a:	ec4e                	sd	s3,24(sp)
    516c:	e852                	sd	s4,16(sp)
    516e:	e456                	sd	s5,8(sp)
    5170:	0080                	addi	s0,sp,64
    5172:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    5174:	00003517          	auipc	a0,0x3
    5178:	d8c50513          	addi	a0,a0,-628 # 7f00 <malloc+0x1f30>
    517c:	00001097          	auipc	ra,0x1
    5180:	a3e080e7          	jalr	-1474(ra) # 5bba <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    5184:	20200593          	li	a1,514
    5188:	00003517          	auipc	a0,0x3
    518c:	d7850513          	addi	a0,a0,-648 # 7f00 <malloc+0x1f30>
    5190:	00001097          	auipc	ra,0x1
    5194:	a1a080e7          	jalr	-1510(ra) # 5baa <open>
    5198:	89aa                	mv	s3,a0
  for (i = 0; i < N; i++)
    519a:	4481                	li	s1,0
    memset(buf, i, SZ);
    519c:	00008917          	auipc	s2,0x8
    51a0:	adc90913          	addi	s2,s2,-1316 # cc78 <buf>
  for (i = 0; i < N; i++)
    51a4:	4a51                	li	s4,20
  if (fd < 0)
    51a6:	0a054063          	bltz	a0,5246 <bigfile+0xe6>
    memset(buf, i, SZ);
    51aa:	25800613          	li	a2,600
    51ae:	85a6                	mv	a1,s1
    51b0:	854a                	mv	a0,s2
    51b2:	00000097          	auipc	ra,0x0
    51b6:	7bc080e7          	jalr	1980(ra) # 596e <memset>
    if (write(fd, buf, SZ) != SZ)
    51ba:	25800613          	li	a2,600
    51be:	85ca                	mv	a1,s2
    51c0:	854e                	mv	a0,s3
    51c2:	00001097          	auipc	ra,0x1
    51c6:	9c8080e7          	jalr	-1592(ra) # 5b8a <write>
    51ca:	25800793          	li	a5,600
    51ce:	08f51a63          	bne	a0,a5,5262 <bigfile+0x102>
  for (i = 0; i < N; i++)
    51d2:	2485                	addiw	s1,s1,1
    51d4:	fd449be3          	bne	s1,s4,51aa <bigfile+0x4a>
  close(fd);
    51d8:	854e                	mv	a0,s3
    51da:	00001097          	auipc	ra,0x1
    51de:	9b8080e7          	jalr	-1608(ra) # 5b92 <close>
  fd = open("bigfile.dat", 0);
    51e2:	4581                	li	a1,0
    51e4:	00003517          	auipc	a0,0x3
    51e8:	d1c50513          	addi	a0,a0,-740 # 7f00 <malloc+0x1f30>
    51ec:	00001097          	auipc	ra,0x1
    51f0:	9be080e7          	jalr	-1602(ra) # 5baa <open>
    51f4:	8a2a                	mv	s4,a0
  total = 0;
    51f6:	4981                	li	s3,0
  for (i = 0;; i++)
    51f8:	4481                	li	s1,0
    cc = read(fd, buf, SZ / 2);
    51fa:	00008917          	auipc	s2,0x8
    51fe:	a7e90913          	addi	s2,s2,-1410 # cc78 <buf>
  if (fd < 0)
    5202:	06054e63          	bltz	a0,527e <bigfile+0x11e>
    cc = read(fd, buf, SZ / 2);
    5206:	12c00613          	li	a2,300
    520a:	85ca                	mv	a1,s2
    520c:	8552                	mv	a0,s4
    520e:	00001097          	auipc	ra,0x1
    5212:	974080e7          	jalr	-1676(ra) # 5b82 <read>
    if (cc < 0)
    5216:	08054263          	bltz	a0,529a <bigfile+0x13a>
    if (cc == 0)
    521a:	c971                	beqz	a0,52ee <bigfile+0x18e>
    if (cc != SZ / 2)
    521c:	12c00793          	li	a5,300
    5220:	08f51b63          	bne	a0,a5,52b6 <bigfile+0x156>
    if (buf[0] != i / 2 || buf[SZ / 2 - 1] != i / 2)
    5224:	01f4d79b          	srliw	a5,s1,0x1f
    5228:	9fa5                	addw	a5,a5,s1
    522a:	4017d79b          	sraiw	a5,a5,0x1
    522e:	00094703          	lbu	a4,0(s2)
    5232:	0af71063          	bne	a4,a5,52d2 <bigfile+0x172>
    5236:	12b94703          	lbu	a4,299(s2)
    523a:	08f71c63          	bne	a4,a5,52d2 <bigfile+0x172>
    total += cc;
    523e:	12c9899b          	addiw	s3,s3,300
  for (i = 0;; i++)
    5242:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ / 2);
    5244:	b7c9                	j	5206 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    5246:	85d6                	mv	a1,s5
    5248:	00003517          	auipc	a0,0x3
    524c:	cc850513          	addi	a0,a0,-824 # 7f10 <malloc+0x1f40>
    5250:	00001097          	auipc	ra,0x1
    5254:	cc2080e7          	jalr	-830(ra) # 5f12 <printf>
    exit(1);
    5258:	4505                	li	a0,1
    525a:	00001097          	auipc	ra,0x1
    525e:	910080e7          	jalr	-1776(ra) # 5b6a <exit>
      printf("%s: write bigfile failed\n", s);
    5262:	85d6                	mv	a1,s5
    5264:	00003517          	auipc	a0,0x3
    5268:	ccc50513          	addi	a0,a0,-820 # 7f30 <malloc+0x1f60>
    526c:	00001097          	auipc	ra,0x1
    5270:	ca6080e7          	jalr	-858(ra) # 5f12 <printf>
      exit(1);
    5274:	4505                	li	a0,1
    5276:	00001097          	auipc	ra,0x1
    527a:	8f4080e7          	jalr	-1804(ra) # 5b6a <exit>
    printf("%s: cannot open bigfile\n", s);
    527e:	85d6                	mv	a1,s5
    5280:	00003517          	auipc	a0,0x3
    5284:	cd050513          	addi	a0,a0,-816 # 7f50 <malloc+0x1f80>
    5288:	00001097          	auipc	ra,0x1
    528c:	c8a080e7          	jalr	-886(ra) # 5f12 <printf>
    exit(1);
    5290:	4505                	li	a0,1
    5292:	00001097          	auipc	ra,0x1
    5296:	8d8080e7          	jalr	-1832(ra) # 5b6a <exit>
      printf("%s: read bigfile failed\n", s);
    529a:	85d6                	mv	a1,s5
    529c:	00003517          	auipc	a0,0x3
    52a0:	cd450513          	addi	a0,a0,-812 # 7f70 <malloc+0x1fa0>
    52a4:	00001097          	auipc	ra,0x1
    52a8:	c6e080e7          	jalr	-914(ra) # 5f12 <printf>
      exit(1);
    52ac:	4505                	li	a0,1
    52ae:	00001097          	auipc	ra,0x1
    52b2:	8bc080e7          	jalr	-1860(ra) # 5b6a <exit>
      printf("%s: short read bigfile\n", s);
    52b6:	85d6                	mv	a1,s5
    52b8:	00003517          	auipc	a0,0x3
    52bc:	cd850513          	addi	a0,a0,-808 # 7f90 <malloc+0x1fc0>
    52c0:	00001097          	auipc	ra,0x1
    52c4:	c52080e7          	jalr	-942(ra) # 5f12 <printf>
      exit(1);
    52c8:	4505                	li	a0,1
    52ca:	00001097          	auipc	ra,0x1
    52ce:	8a0080e7          	jalr	-1888(ra) # 5b6a <exit>
      printf("%s: read bigfile wrong data\n", s);
    52d2:	85d6                	mv	a1,s5
    52d4:	00003517          	auipc	a0,0x3
    52d8:	cd450513          	addi	a0,a0,-812 # 7fa8 <malloc+0x1fd8>
    52dc:	00001097          	auipc	ra,0x1
    52e0:	c36080e7          	jalr	-970(ra) # 5f12 <printf>
      exit(1);
    52e4:	4505                	li	a0,1
    52e6:	00001097          	auipc	ra,0x1
    52ea:	884080e7          	jalr	-1916(ra) # 5b6a <exit>
  close(fd);
    52ee:	8552                	mv	a0,s4
    52f0:	00001097          	auipc	ra,0x1
    52f4:	8a2080e7          	jalr	-1886(ra) # 5b92 <close>
  if (total != N * SZ)
    52f8:	678d                	lui	a5,0x3
    52fa:	ee078793          	addi	a5,a5,-288 # 2ee0 <sbrk8000+0x12>
    52fe:	02f99363          	bne	s3,a5,5324 <bigfile+0x1c4>
  unlink("bigfile.dat");
    5302:	00003517          	auipc	a0,0x3
    5306:	bfe50513          	addi	a0,a0,-1026 # 7f00 <malloc+0x1f30>
    530a:	00001097          	auipc	ra,0x1
    530e:	8b0080e7          	jalr	-1872(ra) # 5bba <unlink>
}
    5312:	70e2                	ld	ra,56(sp)
    5314:	7442                	ld	s0,48(sp)
    5316:	74a2                	ld	s1,40(sp)
    5318:	7902                	ld	s2,32(sp)
    531a:	69e2                	ld	s3,24(sp)
    531c:	6a42                	ld	s4,16(sp)
    531e:	6aa2                	ld	s5,8(sp)
    5320:	6121                	addi	sp,sp,64
    5322:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    5324:	85d6                	mv	a1,s5
    5326:	00003517          	auipc	a0,0x3
    532a:	ca250513          	addi	a0,a0,-862 # 7fc8 <malloc+0x1ff8>
    532e:	00001097          	auipc	ra,0x1
    5332:	be4080e7          	jalr	-1052(ra) # 5f12 <printf>
    exit(1);
    5336:	4505                	li	a0,1
    5338:	00001097          	auipc	ra,0x1
    533c:	832080e7          	jalr	-1998(ra) # 5b6a <exit>

0000000000005340 <fsfull>:
{
    5340:	7171                	addi	sp,sp,-176
    5342:	f506                	sd	ra,168(sp)
    5344:	f122                	sd	s0,160(sp)
    5346:	ed26                	sd	s1,152(sp)
    5348:	e94a                	sd	s2,144(sp)
    534a:	e54e                	sd	s3,136(sp)
    534c:	e152                	sd	s4,128(sp)
    534e:	fcd6                	sd	s5,120(sp)
    5350:	f8da                	sd	s6,112(sp)
    5352:	f4de                	sd	s7,104(sp)
    5354:	f0e2                	sd	s8,96(sp)
    5356:	ece6                	sd	s9,88(sp)
    5358:	e8ea                	sd	s10,80(sp)
    535a:	e4ee                	sd	s11,72(sp)
    535c:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    535e:	00003517          	auipc	a0,0x3
    5362:	c8a50513          	addi	a0,a0,-886 # 7fe8 <malloc+0x2018>
    5366:	00001097          	auipc	ra,0x1
    536a:	bac080e7          	jalr	-1108(ra) # 5f12 <printf>
  for (nfiles = 0;; nfiles++)
    536e:	4481                	li	s1,0
    name[0] = 'f';
    5370:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    5374:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5378:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    537c:	4b29                	li	s6,10
    printf("writing %s\n", name);
    537e:	00003c97          	auipc	s9,0x3
    5382:	c7ac8c93          	addi	s9,s9,-902 # 7ff8 <malloc+0x2028>
    int total = 0;
    5386:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    5388:	00008a17          	auipc	s4,0x8
    538c:	8f0a0a13          	addi	s4,s4,-1808 # cc78 <buf>
    name[0] = 'f';
    5390:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    5394:	0384c7bb          	divw	a5,s1,s8
    5398:	0307879b          	addiw	a5,a5,48
    539c:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    53a0:	0384e7bb          	remw	a5,s1,s8
    53a4:	0377c7bb          	divw	a5,a5,s7
    53a8:	0307879b          	addiw	a5,a5,48
    53ac:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    53b0:	0374e7bb          	remw	a5,s1,s7
    53b4:	0367c7bb          	divw	a5,a5,s6
    53b8:	0307879b          	addiw	a5,a5,48
    53bc:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    53c0:	0364e7bb          	remw	a5,s1,s6
    53c4:	0307879b          	addiw	a5,a5,48
    53c8:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    53cc:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    53d0:	f5040593          	addi	a1,s0,-176
    53d4:	8566                	mv	a0,s9
    53d6:	00001097          	auipc	ra,0x1
    53da:	b3c080e7          	jalr	-1220(ra) # 5f12 <printf>
    int fd = open(name, O_CREATE | O_RDWR);
    53de:	20200593          	li	a1,514
    53e2:	f5040513          	addi	a0,s0,-176
    53e6:	00000097          	auipc	ra,0x0
    53ea:	7c4080e7          	jalr	1988(ra) # 5baa <open>
    53ee:	892a                	mv	s2,a0
    if (fd < 0)
    53f0:	0a055663          	bgez	a0,549c <fsfull+0x15c>
      printf("open %s failed\n", name);
    53f4:	f5040593          	addi	a1,s0,-176
    53f8:	00003517          	auipc	a0,0x3
    53fc:	c1050513          	addi	a0,a0,-1008 # 8008 <malloc+0x2038>
    5400:	00001097          	auipc	ra,0x1
    5404:	b12080e7          	jalr	-1262(ra) # 5f12 <printf>
  while (nfiles >= 0)
    5408:	0604c363          	bltz	s1,546e <fsfull+0x12e>
    name[0] = 'f';
    540c:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    5410:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5414:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    5418:	4929                	li	s2,10
  while (nfiles >= 0)
    541a:	5afd                	li	s5,-1
    name[0] = 'f';
    541c:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    5420:	0344c7bb          	divw	a5,s1,s4
    5424:	0307879b          	addiw	a5,a5,48
    5428:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    542c:	0344e7bb          	remw	a5,s1,s4
    5430:	0337c7bb          	divw	a5,a5,s3
    5434:	0307879b          	addiw	a5,a5,48
    5438:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    543c:	0334e7bb          	remw	a5,s1,s3
    5440:	0327c7bb          	divw	a5,a5,s2
    5444:	0307879b          	addiw	a5,a5,48
    5448:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    544c:	0324e7bb          	remw	a5,s1,s2
    5450:	0307879b          	addiw	a5,a5,48
    5454:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    5458:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    545c:	f5040513          	addi	a0,s0,-176
    5460:	00000097          	auipc	ra,0x0
    5464:	75a080e7          	jalr	1882(ra) # 5bba <unlink>
    nfiles--;
    5468:	34fd                	addiw	s1,s1,-1
  while (nfiles >= 0)
    546a:	fb5499e3          	bne	s1,s5,541c <fsfull+0xdc>
  printf("fsfull test finished\n");
    546e:	00003517          	auipc	a0,0x3
    5472:	bba50513          	addi	a0,a0,-1094 # 8028 <malloc+0x2058>
    5476:	00001097          	auipc	ra,0x1
    547a:	a9c080e7          	jalr	-1380(ra) # 5f12 <printf>
}
    547e:	70aa                	ld	ra,168(sp)
    5480:	740a                	ld	s0,160(sp)
    5482:	64ea                	ld	s1,152(sp)
    5484:	694a                	ld	s2,144(sp)
    5486:	69aa                	ld	s3,136(sp)
    5488:	6a0a                	ld	s4,128(sp)
    548a:	7ae6                	ld	s5,120(sp)
    548c:	7b46                	ld	s6,112(sp)
    548e:	7ba6                	ld	s7,104(sp)
    5490:	7c06                	ld	s8,96(sp)
    5492:	6ce6                	ld	s9,88(sp)
    5494:	6d46                	ld	s10,80(sp)
    5496:	6da6                	ld	s11,72(sp)
    5498:	614d                	addi	sp,sp,176
    549a:	8082                	ret
    int total = 0;
    549c:	89ee                	mv	s3,s11
      if (cc < BSIZE)
    549e:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    54a2:	40000613          	li	a2,1024
    54a6:	85d2                	mv	a1,s4
    54a8:	854a                	mv	a0,s2
    54aa:	00000097          	auipc	ra,0x0
    54ae:	6e0080e7          	jalr	1760(ra) # 5b8a <write>
      if (cc < BSIZE)
    54b2:	00aad563          	bge	s5,a0,54bc <fsfull+0x17c>
      total += cc;
    54b6:	00a989bb          	addw	s3,s3,a0
    {
    54ba:	b7e5                	j	54a2 <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    54bc:	85ce                	mv	a1,s3
    54be:	00003517          	auipc	a0,0x3
    54c2:	b5a50513          	addi	a0,a0,-1190 # 8018 <malloc+0x2048>
    54c6:	00001097          	auipc	ra,0x1
    54ca:	a4c080e7          	jalr	-1460(ra) # 5f12 <printf>
    close(fd);
    54ce:	854a                	mv	a0,s2
    54d0:	00000097          	auipc	ra,0x0
    54d4:	6c2080e7          	jalr	1730(ra) # 5b92 <close>
    if (total == 0)
    54d8:	f20988e3          	beqz	s3,5408 <fsfull+0xc8>
  for (nfiles = 0;; nfiles++)
    54dc:	2485                	addiw	s1,s1,1
  {
    54de:	bd4d                	j	5390 <fsfull+0x50>

00000000000054e0 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int run(void f(char *), char *s)
{
    54e0:	7179                	addi	sp,sp,-48
    54e2:	f406                	sd	ra,40(sp)
    54e4:	f022                	sd	s0,32(sp)
    54e6:	ec26                	sd	s1,24(sp)
    54e8:	e84a                	sd	s2,16(sp)
    54ea:	1800                	addi	s0,sp,48
    54ec:	84aa                	mv	s1,a0
    54ee:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    54f0:	00003517          	auipc	a0,0x3
    54f4:	b5050513          	addi	a0,a0,-1200 # 8040 <malloc+0x2070>
    54f8:	00001097          	auipc	ra,0x1
    54fc:	a1a080e7          	jalr	-1510(ra) # 5f12 <printf>
  if ((pid = fork()) < 0)
    5500:	00000097          	auipc	ra,0x0
    5504:	662080e7          	jalr	1634(ra) # 5b62 <fork>
    5508:	02054e63          	bltz	a0,5544 <run+0x64>
  {
    printf("runtest: fork error\n");
    exit(1);
  }
  if (pid == 0)
    550c:	c929                	beqz	a0,555e <run+0x7e>
    f(s);
    exit(0);
  }
  else
  {
    wait(&xstatus);
    550e:	fdc40513          	addi	a0,s0,-36
    5512:	00000097          	auipc	ra,0x0
    5516:	660080e7          	jalr	1632(ra) # 5b72 <wait>
    if (xstatus != 0)
    551a:	fdc42783          	lw	a5,-36(s0)
    551e:	c7b9                	beqz	a5,556c <run+0x8c>
      printf("FAILED\n");
    5520:	00003517          	auipc	a0,0x3
    5524:	b4850513          	addi	a0,a0,-1208 # 8068 <malloc+0x2098>
    5528:	00001097          	auipc	ra,0x1
    552c:	9ea080e7          	jalr	-1558(ra) # 5f12 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    5530:	fdc42503          	lw	a0,-36(s0)
  }
}
    5534:	00153513          	seqz	a0,a0
    5538:	70a2                	ld	ra,40(sp)
    553a:	7402                	ld	s0,32(sp)
    553c:	64e2                	ld	s1,24(sp)
    553e:	6942                	ld	s2,16(sp)
    5540:	6145                	addi	sp,sp,48
    5542:	8082                	ret
    printf("runtest: fork error\n");
    5544:	00003517          	auipc	a0,0x3
    5548:	b0c50513          	addi	a0,a0,-1268 # 8050 <malloc+0x2080>
    554c:	00001097          	auipc	ra,0x1
    5550:	9c6080e7          	jalr	-1594(ra) # 5f12 <printf>
    exit(1);
    5554:	4505                	li	a0,1
    5556:	00000097          	auipc	ra,0x0
    555a:	614080e7          	jalr	1556(ra) # 5b6a <exit>
    f(s);
    555e:	854a                	mv	a0,s2
    5560:	9482                	jalr	s1
    exit(0);
    5562:	4501                	li	a0,0
    5564:	00000097          	auipc	ra,0x0
    5568:	606080e7          	jalr	1542(ra) # 5b6a <exit>
      printf("OK\n");
    556c:	00003517          	auipc	a0,0x3
    5570:	b0450513          	addi	a0,a0,-1276 # 8070 <malloc+0x20a0>
    5574:	00001097          	auipc	ra,0x1
    5578:	99e080e7          	jalr	-1634(ra) # 5f12 <printf>
    557c:	bf55                	j	5530 <run+0x50>

000000000000557e <runtests>:

int runtests(struct test *tests, char *justone)
{
    557e:	1101                	addi	sp,sp,-32
    5580:	ec06                	sd	ra,24(sp)
    5582:	e822                	sd	s0,16(sp)
    5584:	e426                	sd	s1,8(sp)
    5586:	e04a                	sd	s2,0(sp)
    5588:	1000                	addi	s0,sp,32
    558a:	84aa                	mv	s1,a0
    558c:	892e                	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++)
    558e:	6508                	ld	a0,8(a0)
    5590:	ed09                	bnez	a0,55aa <runtests+0x2c>
        printf("SOME TESTS FAILED\n");
        return 1;
      }
    }
  }
  return 0;
    5592:	4501                	li	a0,0
    5594:	a82d                	j	55ce <runtests+0x50>
      if (!run(t->f, t->s))
    5596:	648c                	ld	a1,8(s1)
    5598:	6088                	ld	a0,0(s1)
    559a:	00000097          	auipc	ra,0x0
    559e:	f46080e7          	jalr	-186(ra) # 54e0 <run>
    55a2:	cd09                	beqz	a0,55bc <runtests+0x3e>
  for (struct test *t = tests; t->s != 0; t++)
    55a4:	04c1                	addi	s1,s1,16
    55a6:	6488                	ld	a0,8(s1)
    55a8:	c11d                	beqz	a0,55ce <runtests+0x50>
    if ((justone == 0) || strcmp(t->s, justone) == 0)
    55aa:	fe0906e3          	beqz	s2,5596 <runtests+0x18>
    55ae:	85ca                	mv	a1,s2
    55b0:	00000097          	auipc	ra,0x0
    55b4:	368080e7          	jalr	872(ra) # 5918 <strcmp>
    55b8:	f575                	bnez	a0,55a4 <runtests+0x26>
    55ba:	bff1                	j	5596 <runtests+0x18>
        printf("SOME TESTS FAILED\n");
    55bc:	00003517          	auipc	a0,0x3
    55c0:	abc50513          	addi	a0,a0,-1348 # 8078 <malloc+0x20a8>
    55c4:	00001097          	auipc	ra,0x1
    55c8:	94e080e7          	jalr	-1714(ra) # 5f12 <printf>
        return 1;
    55cc:	4505                	li	a0,1
}
    55ce:	60e2                	ld	ra,24(sp)
    55d0:	6442                	ld	s0,16(sp)
    55d2:	64a2                	ld	s1,8(sp)
    55d4:	6902                	ld	s2,0(sp)
    55d6:	6105                	addi	sp,sp,32
    55d8:	8082                	ret

00000000000055da <countfree>:
// touches the pages to force allocation.
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int countfree()
{
    55da:	7139                	addi	sp,sp,-64
    55dc:	fc06                	sd	ra,56(sp)
    55de:	f822                	sd	s0,48(sp)
    55e0:	f426                	sd	s1,40(sp)
    55e2:	f04a                	sd	s2,32(sp)
    55e4:	ec4e                	sd	s3,24(sp)
    55e6:	0080                	addi	s0,sp,64
  int fds[2];

  if (pipe(fds) < 0)
    55e8:	fc840513          	addi	a0,s0,-56
    55ec:	00000097          	auipc	ra,0x0
    55f0:	58e080e7          	jalr	1422(ra) # 5b7a <pipe>
    55f4:	06054763          	bltz	a0,5662 <countfree+0x88>
  {
    printf("pipe() failed in countfree()\n");
    exit(1);
  }

  int pid = fork();
    55f8:	00000097          	auipc	ra,0x0
    55fc:	56a080e7          	jalr	1386(ra) # 5b62 <fork>

  if (pid < 0)
    5600:	06054e63          	bltz	a0,567c <countfree+0xa2>
  {
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if (pid == 0)
    5604:	ed51                	bnez	a0,56a0 <countfree+0xc6>
  {
    close(fds[0]);
    5606:	fc842503          	lw	a0,-56(s0)
    560a:	00000097          	auipc	ra,0x0
    560e:	588080e7          	jalr	1416(ra) # 5b92 <close>

    while (1)
    {
      uint64 a = (uint64)sbrk(4096);
      if (a == 0xffffffffffffffff)
    5612:	597d                	li	s2,-1
      {
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    5614:	4485                	li	s1,1

      // report back one more page.
      if (write(fds[1], "x", 1) != 1)
    5616:	00001997          	auipc	s3,0x1
    561a:	b7298993          	addi	s3,s3,-1166 # 6188 <malloc+0x1b8>
      uint64 a = (uint64)sbrk(4096);
    561e:	6505                	lui	a0,0x1
    5620:	00000097          	auipc	ra,0x0
    5624:	5d2080e7          	jalr	1490(ra) # 5bf2 <sbrk>
      if (a == 0xffffffffffffffff)
    5628:	07250763          	beq	a0,s2,5696 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    562c:	6785                	lui	a5,0x1
    562e:	953e                	add	a0,a0,a5
    5630:	fe950fa3          	sb	s1,-1(a0) # fff <linktest+0xf7>
      if (write(fds[1], "x", 1) != 1)
    5634:	8626                	mv	a2,s1
    5636:	85ce                	mv	a1,s3
    5638:	fcc42503          	lw	a0,-52(s0)
    563c:	00000097          	auipc	ra,0x0
    5640:	54e080e7          	jalr	1358(ra) # 5b8a <write>
    5644:	fc950de3          	beq	a0,s1,561e <countfree+0x44>
      {
        printf("write() failed in countfree()\n");
    5648:	00003517          	auipc	a0,0x3
    564c:	a8850513          	addi	a0,a0,-1400 # 80d0 <malloc+0x2100>
    5650:	00001097          	auipc	ra,0x1
    5654:	8c2080e7          	jalr	-1854(ra) # 5f12 <printf>
        exit(1);
    5658:	4505                	li	a0,1
    565a:	00000097          	auipc	ra,0x0
    565e:	510080e7          	jalr	1296(ra) # 5b6a <exit>
    printf("pipe() failed in countfree()\n");
    5662:	00003517          	auipc	a0,0x3
    5666:	a2e50513          	addi	a0,a0,-1490 # 8090 <malloc+0x20c0>
    566a:	00001097          	auipc	ra,0x1
    566e:	8a8080e7          	jalr	-1880(ra) # 5f12 <printf>
    exit(1);
    5672:	4505                	li	a0,1
    5674:	00000097          	auipc	ra,0x0
    5678:	4f6080e7          	jalr	1270(ra) # 5b6a <exit>
    printf("fork failed in countfree()\n");
    567c:	00003517          	auipc	a0,0x3
    5680:	a3450513          	addi	a0,a0,-1484 # 80b0 <malloc+0x20e0>
    5684:	00001097          	auipc	ra,0x1
    5688:	88e080e7          	jalr	-1906(ra) # 5f12 <printf>
    exit(1);
    568c:	4505                	li	a0,1
    568e:	00000097          	auipc	ra,0x0
    5692:	4dc080e7          	jalr	1244(ra) # 5b6a <exit>
      }
    }

    exit(0);
    5696:	4501                	li	a0,0
    5698:	00000097          	auipc	ra,0x0
    569c:	4d2080e7          	jalr	1234(ra) # 5b6a <exit>
  }

  close(fds[1]);
    56a0:	fcc42503          	lw	a0,-52(s0)
    56a4:	00000097          	auipc	ra,0x0
    56a8:	4ee080e7          	jalr	1262(ra) # 5b92 <close>

  int n = 0;
    56ac:	4481                	li	s1,0
  while (1)
  {
    char c;
    int cc = read(fds[0], &c, 1);
    56ae:	4605                	li	a2,1
    56b0:	fc740593          	addi	a1,s0,-57
    56b4:	fc842503          	lw	a0,-56(s0)
    56b8:	00000097          	auipc	ra,0x0
    56bc:	4ca080e7          	jalr	1226(ra) # 5b82 <read>
    if (cc < 0)
    56c0:	00054563          	bltz	a0,56ca <countfree+0xf0>
    {
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if (cc == 0)
    56c4:	c105                	beqz	a0,56e4 <countfree+0x10a>
      break;
    n += 1;
    56c6:	2485                	addiw	s1,s1,1
  {
    56c8:	b7dd                	j	56ae <countfree+0xd4>
      printf("read() failed in countfree()\n");
    56ca:	00003517          	auipc	a0,0x3
    56ce:	a2650513          	addi	a0,a0,-1498 # 80f0 <malloc+0x2120>
    56d2:	00001097          	auipc	ra,0x1
    56d6:	840080e7          	jalr	-1984(ra) # 5f12 <printf>
      exit(1);
    56da:	4505                	li	a0,1
    56dc:	00000097          	auipc	ra,0x0
    56e0:	48e080e7          	jalr	1166(ra) # 5b6a <exit>
  }

  close(fds[0]);
    56e4:	fc842503          	lw	a0,-56(s0)
    56e8:	00000097          	auipc	ra,0x0
    56ec:	4aa080e7          	jalr	1194(ra) # 5b92 <close>
  wait((int *)0);
    56f0:	4501                	li	a0,0
    56f2:	00000097          	auipc	ra,0x0
    56f6:	480080e7          	jalr	1152(ra) # 5b72 <wait>

  return n;
}
    56fa:	8526                	mv	a0,s1
    56fc:	70e2                	ld	ra,56(sp)
    56fe:	7442                	ld	s0,48(sp)
    5700:	74a2                	ld	s1,40(sp)
    5702:	7902                	ld	s2,32(sp)
    5704:	69e2                	ld	s3,24(sp)
    5706:	6121                	addi	sp,sp,64
    5708:	8082                	ret

000000000000570a <drivetests>:

int drivetests(int quick, int continuous, char *justone)
{
    570a:	711d                	addi	sp,sp,-96
    570c:	ec86                	sd	ra,88(sp)
    570e:	e8a2                	sd	s0,80(sp)
    5710:	e4a6                	sd	s1,72(sp)
    5712:	e0ca                	sd	s2,64(sp)
    5714:	fc4e                	sd	s3,56(sp)
    5716:	f852                	sd	s4,48(sp)
    5718:	f456                	sd	s5,40(sp)
    571a:	f05a                	sd	s6,32(sp)
    571c:	ec5e                	sd	s7,24(sp)
    571e:	e862                	sd	s8,16(sp)
    5720:	e466                	sd	s9,8(sp)
    5722:	e06a                	sd	s10,0(sp)
    5724:	1080                	addi	s0,sp,96
    5726:	8a2a                	mv	s4,a0
    5728:	89ae                	mv	s3,a1
    572a:	8932                	mv	s2,a2
  do
  {
    printf("usertests starting\n");
    572c:	00003b97          	auipc	s7,0x3
    5730:	9e4b8b93          	addi	s7,s7,-1564 # 8110 <malloc+0x2140>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone))
    5734:	00004b17          	auipc	s6,0x4
    5738:	8dcb0b13          	addi	s6,s6,-1828 # 9010 <quicktests>
    {
      if (continuous != 2)
    573c:	4a89                	li	s5,2
        }
      }
    }
    if ((free1 = countfree()) < free0)
    {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    573e:	00003c97          	auipc	s9,0x3
    5742:	a0ac8c93          	addi	s9,s9,-1526 # 8148 <malloc+0x2178>
      if (runtests(slowtests, justone))
    5746:	00004c17          	auipc	s8,0x4
    574a:	c9ac0c13          	addi	s8,s8,-870 # 93e0 <slowtests>
        printf("usertests slow tests starting\n");
    574e:	00003d17          	auipc	s10,0x3
    5752:	9dad0d13          	addi	s10,s10,-1574 # 8128 <malloc+0x2158>
    5756:	a839                	j	5774 <drivetests+0x6a>
    5758:	856a                	mv	a0,s10
    575a:	00000097          	auipc	ra,0x0
    575e:	7b8080e7          	jalr	1976(ra) # 5f12 <printf>
    5762:	a081                	j	57a2 <drivetests+0x98>
    if ((free1 = countfree()) < free0)
    5764:	00000097          	auipc	ra,0x0
    5768:	e76080e7          	jalr	-394(ra) # 55da <countfree>
    576c:	06954263          	blt	a0,s1,57d0 <drivetests+0xc6>
      if (continuous != 2)
      {
        return 1;
      }
    }
  } while (continuous);
    5770:	06098f63          	beqz	s3,57ee <drivetests+0xe4>
    printf("usertests starting\n");
    5774:	855e                	mv	a0,s7
    5776:	00000097          	auipc	ra,0x0
    577a:	79c080e7          	jalr	1948(ra) # 5f12 <printf>
    int free0 = countfree();
    577e:	00000097          	auipc	ra,0x0
    5782:	e5c080e7          	jalr	-420(ra) # 55da <countfree>
    5786:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone))
    5788:	85ca                	mv	a1,s2
    578a:	855a                	mv	a0,s6
    578c:	00000097          	auipc	ra,0x0
    5790:	df2080e7          	jalr	-526(ra) # 557e <runtests>
    5794:	c119                	beqz	a0,579a <drivetests+0x90>
      if (continuous != 2)
    5796:	05599863          	bne	s3,s5,57e6 <drivetests+0xdc>
    if (!quick)
    579a:	fc0a15e3          	bnez	s4,5764 <drivetests+0x5a>
      if (justone == 0)
    579e:	fa090de3          	beqz	s2,5758 <drivetests+0x4e>
      if (runtests(slowtests, justone))
    57a2:	85ca                	mv	a1,s2
    57a4:	8562                	mv	a0,s8
    57a6:	00000097          	auipc	ra,0x0
    57aa:	dd8080e7          	jalr	-552(ra) # 557e <runtests>
    57ae:	d95d                	beqz	a0,5764 <drivetests+0x5a>
        if (continuous != 2)
    57b0:	03599d63          	bne	s3,s5,57ea <drivetests+0xe0>
    if ((free1 = countfree()) < free0)
    57b4:	00000097          	auipc	ra,0x0
    57b8:	e26080e7          	jalr	-474(ra) # 55da <countfree>
    57bc:	fa955ae3          	bge	a0,s1,5770 <drivetests+0x66>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    57c0:	8626                	mv	a2,s1
    57c2:	85aa                	mv	a1,a0
    57c4:	8566                	mv	a0,s9
    57c6:	00000097          	auipc	ra,0x0
    57ca:	74c080e7          	jalr	1868(ra) # 5f12 <printf>
      if (continuous != 2)
    57ce:	b75d                	j	5774 <drivetests+0x6a>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    57d0:	8626                	mv	a2,s1
    57d2:	85aa                	mv	a1,a0
    57d4:	8566                	mv	a0,s9
    57d6:	00000097          	auipc	ra,0x0
    57da:	73c080e7          	jalr	1852(ra) # 5f12 <printf>
      if (continuous != 2)
    57de:	f9598be3          	beq	s3,s5,5774 <drivetests+0x6a>
        return 1;
    57e2:	4505                	li	a0,1
    57e4:	a031                	j	57f0 <drivetests+0xe6>
        return 1;
    57e6:	4505                	li	a0,1
    57e8:	a021                	j	57f0 <drivetests+0xe6>
          return 1;
    57ea:	4505                	li	a0,1
    57ec:	a011                	j	57f0 <drivetests+0xe6>
  return 0;
    57ee:	854e                	mv	a0,s3
}
    57f0:	60e6                	ld	ra,88(sp)
    57f2:	6446                	ld	s0,80(sp)
    57f4:	64a6                	ld	s1,72(sp)
    57f6:	6906                	ld	s2,64(sp)
    57f8:	79e2                	ld	s3,56(sp)
    57fa:	7a42                	ld	s4,48(sp)
    57fc:	7aa2                	ld	s5,40(sp)
    57fe:	7b02                	ld	s6,32(sp)
    5800:	6be2                	ld	s7,24(sp)
    5802:	6c42                	ld	s8,16(sp)
    5804:	6ca2                	ld	s9,8(sp)
    5806:	6d02                	ld	s10,0(sp)
    5808:	6125                	addi	sp,sp,96
    580a:	8082                	ret

000000000000580c <main>:

int main(int argc, char *argv[])
{
    580c:	1101                	addi	sp,sp,-32
    580e:	ec06                	sd	ra,24(sp)
    5810:	e822                	sd	s0,16(sp)
    5812:	e426                	sd	s1,8(sp)
    5814:	e04a                	sd	s2,0(sp)
    5816:	1000                	addi	s0,sp,32
    5818:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if (argc == 2 && strcmp(argv[1], "-q") == 0)
    581a:	4789                	li	a5,2
    581c:	02f50363          	beq	a0,a5,5842 <main+0x36>
  }
  else if (argc == 2 && argv[1][0] != '-')
  {
    justone = argv[1];
  }
  else if (argc > 1)
    5820:	4785                	li	a5,1
    5822:	06a7cd63          	blt	a5,a0,589c <main+0x90>
  char *justone = 0;
    5826:	4601                	li	a2,0
  int quick = 0;
    5828:	4501                	li	a0,0
  int continuous = 0;
    582a:	4481                	li	s1,0
  {
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone))
    582c:	85a6                	mv	a1,s1
    582e:	00000097          	auipc	ra,0x0
    5832:	edc080e7          	jalr	-292(ra) # 570a <drivetests>
    5836:	c949                	beqz	a0,58c8 <main+0xbc>
  {
    exit(1);
    5838:	4505                	li	a0,1
    583a:	00000097          	auipc	ra,0x0
    583e:	330080e7          	jalr	816(ra) # 5b6a <exit>
    5842:	892e                	mv	s2,a1
  if (argc == 2 && strcmp(argv[1], "-q") == 0)
    5844:	00003597          	auipc	a1,0x3
    5848:	93458593          	addi	a1,a1,-1740 # 8178 <malloc+0x21a8>
    584c:	00893503          	ld	a0,8(s2)
    5850:	00000097          	auipc	ra,0x0
    5854:	0c8080e7          	jalr	200(ra) # 5918 <strcmp>
    5858:	cd39                	beqz	a0,58b6 <main+0xaa>
  else if (argc == 2 && strcmp(argv[1], "-c") == 0)
    585a:	00003597          	auipc	a1,0x3
    585e:	97658593          	addi	a1,a1,-1674 # 81d0 <malloc+0x2200>
    5862:	00893503          	ld	a0,8(s2)
    5866:	00000097          	auipc	ra,0x0
    586a:	0b2080e7          	jalr	178(ra) # 5918 <strcmp>
    586e:	c931                	beqz	a0,58c2 <main+0xb6>
  else if (argc == 2 && strcmp(argv[1], "-C") == 0)
    5870:	00003597          	auipc	a1,0x3
    5874:	95858593          	addi	a1,a1,-1704 # 81c8 <malloc+0x21f8>
    5878:	00893503          	ld	a0,8(s2)
    587c:	00000097          	auipc	ra,0x0
    5880:	09c080e7          	jalr	156(ra) # 5918 <strcmp>
    5884:	cd0d                	beqz	a0,58be <main+0xb2>
  else if (argc == 2 && argv[1][0] != '-')
    5886:	00893603          	ld	a2,8(s2)
    588a:	00064703          	lbu	a4,0(a2) # 3000 <fourteen+0x38>
    588e:	02d00793          	li	a5,45
    5892:	00f70563          	beq	a4,a5,589c <main+0x90>
  int quick = 0;
    5896:	4501                	li	a0,0
  int continuous = 0;
    5898:	4481                	li	s1,0
    589a:	bf49                	j	582c <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    589c:	00003517          	auipc	a0,0x3
    58a0:	8e450513          	addi	a0,a0,-1820 # 8180 <malloc+0x21b0>
    58a4:	00000097          	auipc	ra,0x0
    58a8:	66e080e7          	jalr	1646(ra) # 5f12 <printf>
    exit(1);
    58ac:	4505                	li	a0,1
    58ae:	00000097          	auipc	ra,0x0
    58b2:	2bc080e7          	jalr	700(ra) # 5b6a <exit>
  int continuous = 0;
    58b6:	84aa                	mv	s1,a0
  char *justone = 0;
    58b8:	4601                	li	a2,0
    quick = 1;
    58ba:	4505                	li	a0,1
    58bc:	bf85                	j	582c <main+0x20>
  char *justone = 0;
    58be:	4601                	li	a2,0
    58c0:	b7b5                	j	582c <main+0x20>
    58c2:	4601                	li	a2,0
    continuous = 1;
    58c4:	4485                	li	s1,1
    58c6:	b79d                	j	582c <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    58c8:	00003517          	auipc	a0,0x3
    58cc:	8e850513          	addi	a0,a0,-1816 # 81b0 <malloc+0x21e0>
    58d0:	00000097          	auipc	ra,0x0
    58d4:	642080e7          	jalr	1602(ra) # 5f12 <printf>
  exit(0);
    58d8:	4501                	li	a0,0
    58da:	00000097          	auipc	ra,0x0
    58de:	290080e7          	jalr	656(ra) # 5b6a <exit>

00000000000058e2 <_main>:

//
// wrapper so that it's OK if main() does not call exit().
//
void _main()
{
    58e2:	1141                	addi	sp,sp,-16
    58e4:	e406                	sd	ra,8(sp)
    58e6:	e022                	sd	s0,0(sp)
    58e8:	0800                	addi	s0,sp,16
  extern int main();
  main();
    58ea:	00000097          	auipc	ra,0x0
    58ee:	f22080e7          	jalr	-222(ra) # 580c <main>
  exit(0);
    58f2:	4501                	li	a0,0
    58f4:	00000097          	auipc	ra,0x0
    58f8:	276080e7          	jalr	630(ra) # 5b6a <exit>

00000000000058fc <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
    58fc:	1141                	addi	sp,sp,-16
    58fe:	e422                	sd	s0,8(sp)
    5900:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
    5902:	87aa                	mv	a5,a0
    5904:	0585                	addi	a1,a1,1
    5906:	0785                	addi	a5,a5,1
    5908:	fff5c703          	lbu	a4,-1(a1)
    590c:	fee78fa3          	sb	a4,-1(a5) # fff <linktest+0xf7>
    5910:	fb75                	bnez	a4,5904 <strcpy+0x8>
    ;
  return os;
}
    5912:	6422                	ld	s0,8(sp)
    5914:	0141                	addi	sp,sp,16
    5916:	8082                	ret

0000000000005918 <strcmp>:

int strcmp(const char *p, const char *q)
{
    5918:	1141                	addi	sp,sp,-16
    591a:	e422                	sd	s0,8(sp)
    591c:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
    591e:	00054783          	lbu	a5,0(a0)
    5922:	cb91                	beqz	a5,5936 <strcmp+0x1e>
    5924:	0005c703          	lbu	a4,0(a1)
    5928:	00f71763          	bne	a4,a5,5936 <strcmp+0x1e>
    p++, q++;
    592c:	0505                	addi	a0,a0,1
    592e:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
    5930:	00054783          	lbu	a5,0(a0)
    5934:	fbe5                	bnez	a5,5924 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5936:	0005c503          	lbu	a0,0(a1)
}
    593a:	40a7853b          	subw	a0,a5,a0
    593e:	6422                	ld	s0,8(sp)
    5940:	0141                	addi	sp,sp,16
    5942:	8082                	ret

0000000000005944 <strlen>:

uint strlen(const char *s)
{
    5944:	1141                	addi	sp,sp,-16
    5946:	e422                	sd	s0,8(sp)
    5948:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    594a:	00054783          	lbu	a5,0(a0)
    594e:	cf91                	beqz	a5,596a <strlen+0x26>
    5950:	0505                	addi	a0,a0,1
    5952:	87aa                	mv	a5,a0
    5954:	4685                	li	a3,1
    5956:	9e89                	subw	a3,a3,a0
    5958:	00f6853b          	addw	a0,a3,a5
    595c:	0785                	addi	a5,a5,1
    595e:	fff7c703          	lbu	a4,-1(a5)
    5962:	fb7d                	bnez	a4,5958 <strlen+0x14>
    ;
  return n;
}
    5964:	6422                	ld	s0,8(sp)
    5966:	0141                	addi	sp,sp,16
    5968:	8082                	ret
  for (n = 0; s[n]; n++)
    596a:	4501                	li	a0,0
    596c:	bfe5                	j	5964 <strlen+0x20>

000000000000596e <memset>:

void *
memset(void *dst, int c, uint n)
{
    596e:	1141                	addi	sp,sp,-16
    5970:	e422                	sd	s0,8(sp)
    5972:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++)
    5974:	ca19                	beqz	a2,598a <memset+0x1c>
    5976:	87aa                	mv	a5,a0
    5978:	1602                	slli	a2,a2,0x20
    597a:	9201                	srli	a2,a2,0x20
    597c:	00a60733          	add	a4,a2,a0
  {
    cdst[i] = c;
    5980:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++)
    5984:	0785                	addi	a5,a5,1
    5986:	fee79de3          	bne	a5,a4,5980 <memset+0x12>
  }
  return dst;
}
    598a:	6422                	ld	s0,8(sp)
    598c:	0141                	addi	sp,sp,16
    598e:	8082                	ret

0000000000005990 <strchr>:

char *
strchr(const char *s, char c)
{
    5990:	1141                	addi	sp,sp,-16
    5992:	e422                	sd	s0,8(sp)
    5994:	0800                	addi	s0,sp,16
  for (; *s; s++)
    5996:	00054783          	lbu	a5,0(a0)
    599a:	cb99                	beqz	a5,59b0 <strchr+0x20>
    if (*s == c)
    599c:	00f58763          	beq	a1,a5,59aa <strchr+0x1a>
  for (; *s; s++)
    59a0:	0505                	addi	a0,a0,1
    59a2:	00054783          	lbu	a5,0(a0)
    59a6:	fbfd                	bnez	a5,599c <strchr+0xc>
      return (char *)s;
  return 0;
    59a8:	4501                	li	a0,0
}
    59aa:	6422                	ld	s0,8(sp)
    59ac:	0141                	addi	sp,sp,16
    59ae:	8082                	ret
  return 0;
    59b0:	4501                	li	a0,0
    59b2:	bfe5                	j	59aa <strchr+0x1a>

00000000000059b4 <gets>:

char *
gets(char *buf, int max)
{
    59b4:	711d                	addi	sp,sp,-96
    59b6:	ec86                	sd	ra,88(sp)
    59b8:	e8a2                	sd	s0,80(sp)
    59ba:	e4a6                	sd	s1,72(sp)
    59bc:	e0ca                	sd	s2,64(sp)
    59be:	fc4e                	sd	s3,56(sp)
    59c0:	f852                	sd	s4,48(sp)
    59c2:	f456                	sd	s5,40(sp)
    59c4:	f05a                	sd	s6,32(sp)
    59c6:	ec5e                	sd	s7,24(sp)
    59c8:	1080                	addi	s0,sp,96
    59ca:	8baa                	mv	s7,a0
    59cc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;)
    59ce:	892a                	mv	s2,a0
    59d0:	4481                	li	s1,0
  {
    cc = read(0, &c, 1);
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
    59d2:	4aa9                	li	s5,10
    59d4:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;)
    59d6:	89a6                	mv	s3,s1
    59d8:	2485                	addiw	s1,s1,1
    59da:	0344d863          	bge	s1,s4,5a0a <gets+0x56>
    cc = read(0, &c, 1);
    59de:	4605                	li	a2,1
    59e0:	faf40593          	addi	a1,s0,-81
    59e4:	4501                	li	a0,0
    59e6:	00000097          	auipc	ra,0x0
    59ea:	19c080e7          	jalr	412(ra) # 5b82 <read>
    if (cc < 1)
    59ee:	00a05e63          	blez	a0,5a0a <gets+0x56>
    buf[i++] = c;
    59f2:	faf44783          	lbu	a5,-81(s0)
    59f6:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
    59fa:	01578763          	beq	a5,s5,5a08 <gets+0x54>
    59fe:	0905                	addi	s2,s2,1
    5a00:	fd679be3          	bne	a5,s6,59d6 <gets+0x22>
  for (i = 0; i + 1 < max;)
    5a04:	89a6                	mv	s3,s1
    5a06:	a011                	j	5a0a <gets+0x56>
    5a08:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5a0a:	99de                	add	s3,s3,s7
    5a0c:	00098023          	sb	zero,0(s3)
  return buf;
}
    5a10:	855e                	mv	a0,s7
    5a12:	60e6                	ld	ra,88(sp)
    5a14:	6446                	ld	s0,80(sp)
    5a16:	64a6                	ld	s1,72(sp)
    5a18:	6906                	ld	s2,64(sp)
    5a1a:	79e2                	ld	s3,56(sp)
    5a1c:	7a42                	ld	s4,48(sp)
    5a1e:	7aa2                	ld	s5,40(sp)
    5a20:	7b02                	ld	s6,32(sp)
    5a22:	6be2                	ld	s7,24(sp)
    5a24:	6125                	addi	sp,sp,96
    5a26:	8082                	ret

0000000000005a28 <stat>:

int stat(const char *n, struct stat *st)
{
    5a28:	1101                	addi	sp,sp,-32
    5a2a:	ec06                	sd	ra,24(sp)
    5a2c:	e822                	sd	s0,16(sp)
    5a2e:	e426                	sd	s1,8(sp)
    5a30:	e04a                	sd	s2,0(sp)
    5a32:	1000                	addi	s0,sp,32
    5a34:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5a36:	4581                	li	a1,0
    5a38:	00000097          	auipc	ra,0x0
    5a3c:	172080e7          	jalr	370(ra) # 5baa <open>
  if (fd < 0)
    5a40:	02054563          	bltz	a0,5a6a <stat+0x42>
    5a44:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5a46:	85ca                	mv	a1,s2
    5a48:	00000097          	auipc	ra,0x0
    5a4c:	17a080e7          	jalr	378(ra) # 5bc2 <fstat>
    5a50:	892a                	mv	s2,a0
  close(fd);
    5a52:	8526                	mv	a0,s1
    5a54:	00000097          	auipc	ra,0x0
    5a58:	13e080e7          	jalr	318(ra) # 5b92 <close>
  return r;
}
    5a5c:	854a                	mv	a0,s2
    5a5e:	60e2                	ld	ra,24(sp)
    5a60:	6442                	ld	s0,16(sp)
    5a62:	64a2                	ld	s1,8(sp)
    5a64:	6902                	ld	s2,0(sp)
    5a66:	6105                	addi	sp,sp,32
    5a68:	8082                	ret
    return -1;
    5a6a:	597d                	li	s2,-1
    5a6c:	bfc5                	j	5a5c <stat+0x34>

0000000000005a6e <atoi>:

int atoi(const char *s)
{
    5a6e:	1141                	addi	sp,sp,-16
    5a70:	e422                	sd	s0,8(sp)
    5a72:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
    5a74:	00054603          	lbu	a2,0(a0)
    5a78:	fd06079b          	addiw	a5,a2,-48
    5a7c:	0ff7f793          	andi	a5,a5,255
    5a80:	4725                	li	a4,9
    5a82:	02f76963          	bltu	a4,a5,5ab4 <atoi+0x46>
    5a86:	86aa                	mv	a3,a0
  n = 0;
    5a88:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9')
    5a8a:	45a5                	li	a1,9
    n = n * 10 + *s++ - '0';
    5a8c:	0685                	addi	a3,a3,1
    5a8e:	0025179b          	slliw	a5,a0,0x2
    5a92:	9fa9                	addw	a5,a5,a0
    5a94:	0017979b          	slliw	a5,a5,0x1
    5a98:	9fb1                	addw	a5,a5,a2
    5a9a:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
    5a9e:	0006c603          	lbu	a2,0(a3)
    5aa2:	fd06071b          	addiw	a4,a2,-48
    5aa6:	0ff77713          	andi	a4,a4,255
    5aaa:	fee5f1e3          	bgeu	a1,a4,5a8c <atoi+0x1e>
  return n;
}
    5aae:	6422                	ld	s0,8(sp)
    5ab0:	0141                	addi	sp,sp,16
    5ab2:	8082                	ret
  n = 0;
    5ab4:	4501                	li	a0,0
    5ab6:	bfe5                	j	5aae <atoi+0x40>

0000000000005ab8 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
    5ab8:	1141                	addi	sp,sp,-16
    5aba:	e422                	sd	s0,8(sp)
    5abc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst)
    5abe:	02b57463          	bgeu	a0,a1,5ae6 <memmove+0x2e>
  {
    while (n-- > 0)
    5ac2:	00c05f63          	blez	a2,5ae0 <memmove+0x28>
    5ac6:	1602                	slli	a2,a2,0x20
    5ac8:	9201                	srli	a2,a2,0x20
    5aca:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5ace:	872a                	mv	a4,a0
      *dst++ = *src++;
    5ad0:	0585                	addi	a1,a1,1
    5ad2:	0705                	addi	a4,a4,1
    5ad4:	fff5c683          	lbu	a3,-1(a1)
    5ad8:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    5adc:	fee79ae3          	bne	a5,a4,5ad0 <memmove+0x18>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5ae0:	6422                	ld	s0,8(sp)
    5ae2:	0141                	addi	sp,sp,16
    5ae4:	8082                	ret
    dst += n;
    5ae6:	00c50733          	add	a4,a0,a2
    src += n;
    5aea:	95b2                	add	a1,a1,a2
    while (n-- > 0)
    5aec:	fec05ae3          	blez	a2,5ae0 <memmove+0x28>
    5af0:	fff6079b          	addiw	a5,a2,-1
    5af4:	1782                	slli	a5,a5,0x20
    5af6:	9381                	srli	a5,a5,0x20
    5af8:	fff7c793          	not	a5,a5
    5afc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5afe:	15fd                	addi	a1,a1,-1
    5b00:	177d                	addi	a4,a4,-1
    5b02:	0005c683          	lbu	a3,0(a1)
    5b06:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
    5b0a:	fee79ae3          	bne	a5,a4,5afe <memmove+0x46>
    5b0e:	bfc9                	j	5ae0 <memmove+0x28>

0000000000005b10 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
    5b10:	1141                	addi	sp,sp,-16
    5b12:	e422                	sd	s0,8(sp)
    5b14:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0)
    5b16:	ca05                	beqz	a2,5b46 <memcmp+0x36>
    5b18:	fff6069b          	addiw	a3,a2,-1
    5b1c:	1682                	slli	a3,a3,0x20
    5b1e:	9281                	srli	a3,a3,0x20
    5b20:	0685                	addi	a3,a3,1
    5b22:	96aa                	add	a3,a3,a0
  {
    if (*p1 != *p2)
    5b24:	00054783          	lbu	a5,0(a0)
    5b28:	0005c703          	lbu	a4,0(a1)
    5b2c:	00e79863          	bne	a5,a4,5b3c <memcmp+0x2c>
    {
      return *p1 - *p2;
    }
    p1++;
    5b30:	0505                	addi	a0,a0,1
    p2++;
    5b32:	0585                	addi	a1,a1,1
  while (n-- > 0)
    5b34:	fed518e3          	bne	a0,a3,5b24 <memcmp+0x14>
  }
  return 0;
    5b38:	4501                	li	a0,0
    5b3a:	a019                	j	5b40 <memcmp+0x30>
      return *p1 - *p2;
    5b3c:	40e7853b          	subw	a0,a5,a4
}
    5b40:	6422                	ld	s0,8(sp)
    5b42:	0141                	addi	sp,sp,16
    5b44:	8082                	ret
  return 0;
    5b46:	4501                	li	a0,0
    5b48:	bfe5                	j	5b40 <memcmp+0x30>

0000000000005b4a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5b4a:	1141                	addi	sp,sp,-16
    5b4c:	e406                	sd	ra,8(sp)
    5b4e:	e022                	sd	s0,0(sp)
    5b50:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5b52:	00000097          	auipc	ra,0x0
    5b56:	f66080e7          	jalr	-154(ra) # 5ab8 <memmove>
}
    5b5a:	60a2                	ld	ra,8(sp)
    5b5c:	6402                	ld	s0,0(sp)
    5b5e:	0141                	addi	sp,sp,16
    5b60:	8082                	ret

0000000000005b62 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5b62:	4885                	li	a7,1
 ecall
    5b64:	00000073          	ecall
 ret
    5b68:	8082                	ret

0000000000005b6a <exit>:
.global exit
exit:
 li a7, SYS_exit
    5b6a:	4889                	li	a7,2
 ecall
    5b6c:	00000073          	ecall
 ret
    5b70:	8082                	ret

0000000000005b72 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5b72:	488d                	li	a7,3
 ecall
    5b74:	00000073          	ecall
 ret
    5b78:	8082                	ret

0000000000005b7a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5b7a:	4891                	li	a7,4
 ecall
    5b7c:	00000073          	ecall
 ret
    5b80:	8082                	ret

0000000000005b82 <read>:
.global read
read:
 li a7, SYS_read
    5b82:	4895                	li	a7,5
 ecall
    5b84:	00000073          	ecall
 ret
    5b88:	8082                	ret

0000000000005b8a <write>:
.global write
write:
 li a7, SYS_write
    5b8a:	48c1                	li	a7,16
 ecall
    5b8c:	00000073          	ecall
 ret
    5b90:	8082                	ret

0000000000005b92 <close>:
.global close
close:
 li a7, SYS_close
    5b92:	48d5                	li	a7,21
 ecall
    5b94:	00000073          	ecall
 ret
    5b98:	8082                	ret

0000000000005b9a <kill>:
.global kill
kill:
 li a7, SYS_kill
    5b9a:	4899                	li	a7,6
 ecall
    5b9c:	00000073          	ecall
 ret
    5ba0:	8082                	ret

0000000000005ba2 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5ba2:	489d                	li	a7,7
 ecall
    5ba4:	00000073          	ecall
 ret
    5ba8:	8082                	ret

0000000000005baa <open>:
.global open
open:
 li a7, SYS_open
    5baa:	48bd                	li	a7,15
 ecall
    5bac:	00000073          	ecall
 ret
    5bb0:	8082                	ret

0000000000005bb2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5bb2:	48c5                	li	a7,17
 ecall
    5bb4:	00000073          	ecall
 ret
    5bb8:	8082                	ret

0000000000005bba <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5bba:	48c9                	li	a7,18
 ecall
    5bbc:	00000073          	ecall
 ret
    5bc0:	8082                	ret

0000000000005bc2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5bc2:	48a1                	li	a7,8
 ecall
    5bc4:	00000073          	ecall
 ret
    5bc8:	8082                	ret

0000000000005bca <link>:
.global link
link:
 li a7, SYS_link
    5bca:	48cd                	li	a7,19
 ecall
    5bcc:	00000073          	ecall
 ret
    5bd0:	8082                	ret

0000000000005bd2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5bd2:	48d1                	li	a7,20
 ecall
    5bd4:	00000073          	ecall
 ret
    5bd8:	8082                	ret

0000000000005bda <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5bda:	48a5                	li	a7,9
 ecall
    5bdc:	00000073          	ecall
 ret
    5be0:	8082                	ret

0000000000005be2 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5be2:	48a9                	li	a7,10
 ecall
    5be4:	00000073          	ecall
 ret
    5be8:	8082                	ret

0000000000005bea <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5bea:	48ad                	li	a7,11
 ecall
    5bec:	00000073          	ecall
 ret
    5bf0:	8082                	ret

0000000000005bf2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5bf2:	48b1                	li	a7,12
 ecall
    5bf4:	00000073          	ecall
 ret
    5bf8:	8082                	ret

0000000000005bfa <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5bfa:	48b5                	li	a7,13
 ecall
    5bfc:	00000073          	ecall
 ret
    5c00:	8082                	ret

0000000000005c02 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5c02:	48b9                	li	a7,14
 ecall
    5c04:	00000073          	ecall
 ret
    5c08:	8082                	ret

0000000000005c0a <trace>:
.global trace
trace:
 li a7, SYS_trace
    5c0a:	48d9                	li	a7,22
 ecall
    5c0c:	00000073          	ecall
 ret
    5c10:	8082                	ret

0000000000005c12 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
    5c12:	48e5                	li	a7,25
 ecall
    5c14:	00000073          	ecall
 ret
    5c18:	8082                	ret

0000000000005c1a <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
    5c1a:	48e1                	li	a7,24
 ecall
    5c1c:	00000073          	ecall
 ret
    5c20:	8082                	ret

0000000000005c22 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
    5c22:	48e9                	li	a7,26
 ecall
    5c24:	00000073          	ecall
 ret
    5c28:	8082                	ret

0000000000005c2a <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
    5c2a:	48ed                	li	a7,27
 ecall
    5c2c:	00000073          	ecall
 ret
    5c30:	8082                	ret

0000000000005c32 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
    5c32:	48dd                	li	a7,23
 ecall
    5c34:	00000073          	ecall
 ret
    5c38:	8082                	ret

0000000000005c3a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5c3a:	1101                	addi	sp,sp,-32
    5c3c:	ec06                	sd	ra,24(sp)
    5c3e:	e822                	sd	s0,16(sp)
    5c40:	1000                	addi	s0,sp,32
    5c42:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5c46:	4605                	li	a2,1
    5c48:	fef40593          	addi	a1,s0,-17
    5c4c:	00000097          	auipc	ra,0x0
    5c50:	f3e080e7          	jalr	-194(ra) # 5b8a <write>
}
    5c54:	60e2                	ld	ra,24(sp)
    5c56:	6442                	ld	s0,16(sp)
    5c58:	6105                	addi	sp,sp,32
    5c5a:	8082                	ret

0000000000005c5c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5c5c:	7139                	addi	sp,sp,-64
    5c5e:	fc06                	sd	ra,56(sp)
    5c60:	f822                	sd	s0,48(sp)
    5c62:	f426                	sd	s1,40(sp)
    5c64:	f04a                	sd	s2,32(sp)
    5c66:	ec4e                	sd	s3,24(sp)
    5c68:	0080                	addi	s0,sp,64
    5c6a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0)
    5c6c:	c299                	beqz	a3,5c72 <printint+0x16>
    5c6e:	0805c863          	bltz	a1,5cfe <printint+0xa2>
    neg = 1;
    x = -xx;
  }
  else
  {
    x = xx;
    5c72:	2581                	sext.w	a1,a1
  neg = 0;
    5c74:	4881                	li	a7,0
    5c76:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5c7a:	4701                	li	a4,0
  do
  {
    buf[i++] = digits[x % base];
    5c7c:	2601                	sext.w	a2,a2
    5c7e:	00003517          	auipc	a0,0x3
    5c82:	8c250513          	addi	a0,a0,-1854 # 8540 <digits>
    5c86:	883a                	mv	a6,a4
    5c88:	2705                	addiw	a4,a4,1
    5c8a:	02c5f7bb          	remuw	a5,a1,a2
    5c8e:	1782                	slli	a5,a5,0x20
    5c90:	9381                	srli	a5,a5,0x20
    5c92:	97aa                	add	a5,a5,a0
    5c94:	0007c783          	lbu	a5,0(a5)
    5c98:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    5c9c:	0005879b          	sext.w	a5,a1
    5ca0:	02c5d5bb          	divuw	a1,a1,a2
    5ca4:	0685                	addi	a3,a3,1
    5ca6:	fec7f0e3          	bgeu	a5,a2,5c86 <printint+0x2a>
  if (neg)
    5caa:	00088b63          	beqz	a7,5cc0 <printint+0x64>
    buf[i++] = '-';
    5cae:	fd040793          	addi	a5,s0,-48
    5cb2:	973e                	add	a4,a4,a5
    5cb4:	02d00793          	li	a5,45
    5cb8:	fef70823          	sb	a5,-16(a4)
    5cbc:	0028071b          	addiw	a4,a6,2

  while (--i >= 0)
    5cc0:	02e05863          	blez	a4,5cf0 <printint+0x94>
    5cc4:	fc040793          	addi	a5,s0,-64
    5cc8:	00e78933          	add	s2,a5,a4
    5ccc:	fff78993          	addi	s3,a5,-1
    5cd0:	99ba                	add	s3,s3,a4
    5cd2:	377d                	addiw	a4,a4,-1
    5cd4:	1702                	slli	a4,a4,0x20
    5cd6:	9301                	srli	a4,a4,0x20
    5cd8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5cdc:	fff94583          	lbu	a1,-1(s2)
    5ce0:	8526                	mv	a0,s1
    5ce2:	00000097          	auipc	ra,0x0
    5ce6:	f58080e7          	jalr	-168(ra) # 5c3a <putc>
  while (--i >= 0)
    5cea:	197d                	addi	s2,s2,-1
    5cec:	ff3918e3          	bne	s2,s3,5cdc <printint+0x80>
}
    5cf0:	70e2                	ld	ra,56(sp)
    5cf2:	7442                	ld	s0,48(sp)
    5cf4:	74a2                	ld	s1,40(sp)
    5cf6:	7902                	ld	s2,32(sp)
    5cf8:	69e2                	ld	s3,24(sp)
    5cfa:	6121                	addi	sp,sp,64
    5cfc:	8082                	ret
    x = -xx;
    5cfe:	40b005bb          	negw	a1,a1
    neg = 1;
    5d02:	4885                	li	a7,1
    x = -xx;
    5d04:	bf8d                	j	5c76 <printint+0x1a>

0000000000005d06 <vprintf>:
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap)
{
    5d06:	7119                	addi	sp,sp,-128
    5d08:	fc86                	sd	ra,120(sp)
    5d0a:	f8a2                	sd	s0,112(sp)
    5d0c:	f4a6                	sd	s1,104(sp)
    5d0e:	f0ca                	sd	s2,96(sp)
    5d10:	ecce                	sd	s3,88(sp)
    5d12:	e8d2                	sd	s4,80(sp)
    5d14:	e4d6                	sd	s5,72(sp)
    5d16:	e0da                	sd	s6,64(sp)
    5d18:	fc5e                	sd	s7,56(sp)
    5d1a:	f862                	sd	s8,48(sp)
    5d1c:	f466                	sd	s9,40(sp)
    5d1e:	f06a                	sd	s10,32(sp)
    5d20:	ec6e                	sd	s11,24(sp)
    5d22:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++)
    5d24:	0005c903          	lbu	s2,0(a1)
    5d28:	18090f63          	beqz	s2,5ec6 <vprintf+0x1c0>
    5d2c:	8aaa                	mv	s5,a0
    5d2e:	8b32                	mv	s6,a2
    5d30:	00158493          	addi	s1,a1,1
  state = 0;
    5d34:	4981                	li	s3,0
      else
      {
        putc(fd, c);
      }
    }
    else if (state == '%')
    5d36:	02500a13          	li	s4,37
    {
      if (c == 'd')
    5d3a:	06400c13          	li	s8,100
      {
        printint(fd, va_arg(ap, int), 10, 1);
      }
      else if (c == 'l')
    5d3e:	06c00c93          	li	s9,108
      {
        printint(fd, va_arg(ap, uint64), 10, 0);
      }
      else if (c == 'x')
    5d42:	07800d13          	li	s10,120
      {
        printint(fd, va_arg(ap, int), 16, 0);
      }
      else if (c == 'p')
    5d46:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5d4a:	00002b97          	auipc	s7,0x2
    5d4e:	7f6b8b93          	addi	s7,s7,2038 # 8540 <digits>
    5d52:	a839                	j	5d70 <vprintf+0x6a>
        putc(fd, c);
    5d54:	85ca                	mv	a1,s2
    5d56:	8556                	mv	a0,s5
    5d58:	00000097          	auipc	ra,0x0
    5d5c:	ee2080e7          	jalr	-286(ra) # 5c3a <putc>
    5d60:	a019                	j	5d66 <vprintf+0x60>
    else if (state == '%')
    5d62:	01498f63          	beq	s3,s4,5d80 <vprintf+0x7a>
  for (i = 0; fmt[i]; i++)
    5d66:	0485                	addi	s1,s1,1
    5d68:	fff4c903          	lbu	s2,-1(s1)
    5d6c:	14090d63          	beqz	s2,5ec6 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    5d70:	0009079b          	sext.w	a5,s2
    if (state == 0)
    5d74:	fe0997e3          	bnez	s3,5d62 <vprintf+0x5c>
      if (c == '%')
    5d78:	fd479ee3          	bne	a5,s4,5d54 <vprintf+0x4e>
        state = '%';
    5d7c:	89be                	mv	s3,a5
    5d7e:	b7e5                	j	5d66 <vprintf+0x60>
      if (c == 'd')
    5d80:	05878063          	beq	a5,s8,5dc0 <vprintf+0xba>
      else if (c == 'l')
    5d84:	05978c63          	beq	a5,s9,5ddc <vprintf+0xd6>
      else if (c == 'x')
    5d88:	07a78863          	beq	a5,s10,5df8 <vprintf+0xf2>
      else if (c == 'p')
    5d8c:	09b78463          	beq	a5,s11,5e14 <vprintf+0x10e>
      {
        printptr(fd, va_arg(ap, uint64));
      }
      else if (c == 's')
    5d90:	07300713          	li	a4,115
    5d94:	0ce78663          	beq	a5,a4,5e60 <vprintf+0x15a>
        {
          putc(fd, *s);
          s++;
        }
      }
      else if (c == 'c')
    5d98:	06300713          	li	a4,99
    5d9c:	0ee78e63          	beq	a5,a4,5e98 <vprintf+0x192>
      {
        putc(fd, va_arg(ap, uint));
      }
      else if (c == '%')
    5da0:	11478863          	beq	a5,s4,5eb0 <vprintf+0x1aa>
        putc(fd, c);
      }
      else
      {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    5da4:	85d2                	mv	a1,s4
    5da6:	8556                	mv	a0,s5
    5da8:	00000097          	auipc	ra,0x0
    5dac:	e92080e7          	jalr	-366(ra) # 5c3a <putc>
        putc(fd, c);
    5db0:	85ca                	mv	a1,s2
    5db2:	8556                	mv	a0,s5
    5db4:	00000097          	auipc	ra,0x0
    5db8:	e86080e7          	jalr	-378(ra) # 5c3a <putc>
      }
      state = 0;
    5dbc:	4981                	li	s3,0
    5dbe:	b765                	j	5d66 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    5dc0:	008b0913          	addi	s2,s6,8
    5dc4:	4685                	li	a3,1
    5dc6:	4629                	li	a2,10
    5dc8:	000b2583          	lw	a1,0(s6)
    5dcc:	8556                	mv	a0,s5
    5dce:	00000097          	auipc	ra,0x0
    5dd2:	e8e080e7          	jalr	-370(ra) # 5c5c <printint>
    5dd6:	8b4a                	mv	s6,s2
      state = 0;
    5dd8:	4981                	li	s3,0
    5dda:	b771                	j	5d66 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5ddc:	008b0913          	addi	s2,s6,8
    5de0:	4681                	li	a3,0
    5de2:	4629                	li	a2,10
    5de4:	000b2583          	lw	a1,0(s6)
    5de8:	8556                	mv	a0,s5
    5dea:	00000097          	auipc	ra,0x0
    5dee:	e72080e7          	jalr	-398(ra) # 5c5c <printint>
    5df2:	8b4a                	mv	s6,s2
      state = 0;
    5df4:	4981                	li	s3,0
    5df6:	bf85                	j	5d66 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5df8:	008b0913          	addi	s2,s6,8
    5dfc:	4681                	li	a3,0
    5dfe:	4641                	li	a2,16
    5e00:	000b2583          	lw	a1,0(s6)
    5e04:	8556                	mv	a0,s5
    5e06:	00000097          	auipc	ra,0x0
    5e0a:	e56080e7          	jalr	-426(ra) # 5c5c <printint>
    5e0e:	8b4a                	mv	s6,s2
      state = 0;
    5e10:	4981                	li	s3,0
    5e12:	bf91                	j	5d66 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5e14:	008b0793          	addi	a5,s6,8
    5e18:	f8f43423          	sd	a5,-120(s0)
    5e1c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5e20:	03000593          	li	a1,48
    5e24:	8556                	mv	a0,s5
    5e26:	00000097          	auipc	ra,0x0
    5e2a:	e14080e7          	jalr	-492(ra) # 5c3a <putc>
  putc(fd, 'x');
    5e2e:	85ea                	mv	a1,s10
    5e30:	8556                	mv	a0,s5
    5e32:	00000097          	auipc	ra,0x0
    5e36:	e08080e7          	jalr	-504(ra) # 5c3a <putc>
    5e3a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5e3c:	03c9d793          	srli	a5,s3,0x3c
    5e40:	97de                	add	a5,a5,s7
    5e42:	0007c583          	lbu	a1,0(a5)
    5e46:	8556                	mv	a0,s5
    5e48:	00000097          	auipc	ra,0x0
    5e4c:	df2080e7          	jalr	-526(ra) # 5c3a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5e50:	0992                	slli	s3,s3,0x4
    5e52:	397d                	addiw	s2,s2,-1
    5e54:	fe0914e3          	bnez	s2,5e3c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5e58:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5e5c:	4981                	li	s3,0
    5e5e:	b721                	j	5d66 <vprintf+0x60>
        s = va_arg(ap, char *);
    5e60:	008b0993          	addi	s3,s6,8
    5e64:	000b3903          	ld	s2,0(s6)
        if (s == 0)
    5e68:	02090163          	beqz	s2,5e8a <vprintf+0x184>
        while (*s != 0)
    5e6c:	00094583          	lbu	a1,0(s2)
    5e70:	c9a1                	beqz	a1,5ec0 <vprintf+0x1ba>
          putc(fd, *s);
    5e72:	8556                	mv	a0,s5
    5e74:	00000097          	auipc	ra,0x0
    5e78:	dc6080e7          	jalr	-570(ra) # 5c3a <putc>
          s++;
    5e7c:	0905                	addi	s2,s2,1
        while (*s != 0)
    5e7e:	00094583          	lbu	a1,0(s2)
    5e82:	f9e5                	bnez	a1,5e72 <vprintf+0x16c>
        s = va_arg(ap, char *);
    5e84:	8b4e                	mv	s6,s3
      state = 0;
    5e86:	4981                	li	s3,0
    5e88:	bdf9                	j	5d66 <vprintf+0x60>
          s = "(null)";
    5e8a:	00002917          	auipc	s2,0x2
    5e8e:	6ae90913          	addi	s2,s2,1710 # 8538 <malloc+0x2568>
        while (*s != 0)
    5e92:	02800593          	li	a1,40
    5e96:	bff1                	j	5e72 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    5e98:	008b0913          	addi	s2,s6,8
    5e9c:	000b4583          	lbu	a1,0(s6)
    5ea0:	8556                	mv	a0,s5
    5ea2:	00000097          	auipc	ra,0x0
    5ea6:	d98080e7          	jalr	-616(ra) # 5c3a <putc>
    5eaa:	8b4a                	mv	s6,s2
      state = 0;
    5eac:	4981                	li	s3,0
    5eae:	bd65                	j	5d66 <vprintf+0x60>
        putc(fd, c);
    5eb0:	85d2                	mv	a1,s4
    5eb2:	8556                	mv	a0,s5
    5eb4:	00000097          	auipc	ra,0x0
    5eb8:	d86080e7          	jalr	-634(ra) # 5c3a <putc>
      state = 0;
    5ebc:	4981                	li	s3,0
    5ebe:	b565                	j	5d66 <vprintf+0x60>
        s = va_arg(ap, char *);
    5ec0:	8b4e                	mv	s6,s3
      state = 0;
    5ec2:	4981                	li	s3,0
    5ec4:	b54d                	j	5d66 <vprintf+0x60>
    }
  }
}
    5ec6:	70e6                	ld	ra,120(sp)
    5ec8:	7446                	ld	s0,112(sp)
    5eca:	74a6                	ld	s1,104(sp)
    5ecc:	7906                	ld	s2,96(sp)
    5ece:	69e6                	ld	s3,88(sp)
    5ed0:	6a46                	ld	s4,80(sp)
    5ed2:	6aa6                	ld	s5,72(sp)
    5ed4:	6b06                	ld	s6,64(sp)
    5ed6:	7be2                	ld	s7,56(sp)
    5ed8:	7c42                	ld	s8,48(sp)
    5eda:	7ca2                	ld	s9,40(sp)
    5edc:	7d02                	ld	s10,32(sp)
    5ede:	6de2                	ld	s11,24(sp)
    5ee0:	6109                	addi	sp,sp,128
    5ee2:	8082                	ret

0000000000005ee4 <fprintf>:

void fprintf(int fd, const char *fmt, ...)
{
    5ee4:	715d                	addi	sp,sp,-80
    5ee6:	ec06                	sd	ra,24(sp)
    5ee8:	e822                	sd	s0,16(sp)
    5eea:	1000                	addi	s0,sp,32
    5eec:	e010                	sd	a2,0(s0)
    5eee:	e414                	sd	a3,8(s0)
    5ef0:	e818                	sd	a4,16(s0)
    5ef2:	ec1c                	sd	a5,24(s0)
    5ef4:	03043023          	sd	a6,32(s0)
    5ef8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5efc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5f00:	8622                	mv	a2,s0
    5f02:	00000097          	auipc	ra,0x0
    5f06:	e04080e7          	jalr	-508(ra) # 5d06 <vprintf>
}
    5f0a:	60e2                	ld	ra,24(sp)
    5f0c:	6442                	ld	s0,16(sp)
    5f0e:	6161                	addi	sp,sp,80
    5f10:	8082                	ret

0000000000005f12 <printf>:

void printf(const char *fmt, ...)
{
    5f12:	711d                	addi	sp,sp,-96
    5f14:	ec06                	sd	ra,24(sp)
    5f16:	e822                	sd	s0,16(sp)
    5f18:	1000                	addi	s0,sp,32
    5f1a:	e40c                	sd	a1,8(s0)
    5f1c:	e810                	sd	a2,16(s0)
    5f1e:	ec14                	sd	a3,24(s0)
    5f20:	f018                	sd	a4,32(s0)
    5f22:	f41c                	sd	a5,40(s0)
    5f24:	03043823          	sd	a6,48(s0)
    5f28:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5f2c:	00840613          	addi	a2,s0,8
    5f30:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5f34:	85aa                	mv	a1,a0
    5f36:	4505                	li	a0,1
    5f38:	00000097          	auipc	ra,0x0
    5f3c:	dce080e7          	jalr	-562(ra) # 5d06 <vprintf>
}
    5f40:	60e2                	ld	ra,24(sp)
    5f42:	6442                	ld	s0,16(sp)
    5f44:	6125                	addi	sp,sp,96
    5f46:	8082                	ret

0000000000005f48 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
    5f48:	1141                	addi	sp,sp,-16
    5f4a:	e422                	sd	s0,8(sp)
    5f4c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
    5f4e:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5f52:	00003797          	auipc	a5,0x3
    5f56:	4fe7b783          	ld	a5,1278(a5) # 9450 <freep>
    5f5a:	a805                	j	5f8a <free+0x42>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr)
  {
    bp->s.size += p->s.ptr->s.size;
    5f5c:	4618                	lw	a4,8(a2)
    5f5e:	9db9                	addw	a1,a1,a4
    5f60:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5f64:	6398                	ld	a4,0(a5)
    5f66:	6318                	ld	a4,0(a4)
    5f68:	fee53823          	sd	a4,-16(a0)
    5f6c:	a091                	j	5fb0 <free+0x68>
  }
  else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp)
  {
    p->s.size += bp->s.size;
    5f6e:	ff852703          	lw	a4,-8(a0)
    5f72:	9e39                	addw	a2,a2,a4
    5f74:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5f76:	ff053703          	ld	a4,-16(a0)
    5f7a:	e398                	sd	a4,0(a5)
    5f7c:	a099                	j	5fc2 <free+0x7a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5f7e:	6398                	ld	a4,0(a5)
    5f80:	00e7e463          	bltu	a5,a4,5f88 <free+0x40>
    5f84:	00e6ea63          	bltu	a3,a4,5f98 <free+0x50>
{
    5f88:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5f8a:	fed7fae3          	bgeu	a5,a3,5f7e <free+0x36>
    5f8e:	6398                	ld	a4,0(a5)
    5f90:	00e6e463          	bltu	a3,a4,5f98 <free+0x50>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5f94:	fee7eae3          	bltu	a5,a4,5f88 <free+0x40>
  if (bp + bp->s.size == p->s.ptr)
    5f98:	ff852583          	lw	a1,-8(a0)
    5f9c:	6390                	ld	a2,0(a5)
    5f9e:	02059713          	slli	a4,a1,0x20
    5fa2:	9301                	srli	a4,a4,0x20
    5fa4:	0712                	slli	a4,a4,0x4
    5fa6:	9736                	add	a4,a4,a3
    5fa8:	fae60ae3          	beq	a2,a4,5f5c <free+0x14>
    bp->s.ptr = p->s.ptr;
    5fac:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp)
    5fb0:	4790                	lw	a2,8(a5)
    5fb2:	02061713          	slli	a4,a2,0x20
    5fb6:	9301                	srli	a4,a4,0x20
    5fb8:	0712                	slli	a4,a4,0x4
    5fba:	973e                	add	a4,a4,a5
    5fbc:	fae689e3          	beq	a3,a4,5f6e <free+0x26>
  }
  else
    p->s.ptr = bp;
    5fc0:	e394                	sd	a3,0(a5)
  freep = p;
    5fc2:	00003717          	auipc	a4,0x3
    5fc6:	48f73723          	sd	a5,1166(a4) # 9450 <freep>
}
    5fca:	6422                	ld	s0,8(sp)
    5fcc:	0141                	addi	sp,sp,16
    5fce:	8082                	ret

0000000000005fd0 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
    5fd0:	7139                	addi	sp,sp,-64
    5fd2:	fc06                	sd	ra,56(sp)
    5fd4:	f822                	sd	s0,48(sp)
    5fd6:	f426                	sd	s1,40(sp)
    5fd8:	f04a                	sd	s2,32(sp)
    5fda:	ec4e                	sd	s3,24(sp)
    5fdc:	e852                	sd	s4,16(sp)
    5fde:	e456                	sd	s5,8(sp)
    5fe0:	e05a                	sd	s6,0(sp)
    5fe2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    5fe4:	02051493          	slli	s1,a0,0x20
    5fe8:	9081                	srli	s1,s1,0x20
    5fea:	04bd                	addi	s1,s1,15
    5fec:	8091                	srli	s1,s1,0x4
    5fee:	0014899b          	addiw	s3,s1,1
    5ff2:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0)
    5ff4:	00003517          	auipc	a0,0x3
    5ff8:	45c53503          	ld	a0,1116(a0) # 9450 <freep>
    5ffc:	c515                	beqz	a0,6028 <malloc+0x58>
  {
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    5ffe:	611c                	ld	a5,0(a0)
  {
    if (p->s.size >= nunits)
    6000:	4798                	lw	a4,8(a5)
    6002:	02977f63          	bgeu	a4,s1,6040 <malloc+0x70>
    6006:	8a4e                	mv	s4,s3
    6008:	0009871b          	sext.w	a4,s3
    600c:	6685                	lui	a3,0x1
    600e:	00d77363          	bgeu	a4,a3,6014 <malloc+0x44>
    6012:	6a05                	lui	s4,0x1
    6014:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    6018:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
    601c:	00003917          	auipc	s2,0x3
    6020:	43490913          	addi	s2,s2,1076 # 9450 <freep>
  if (p == (char *)-1)
    6024:	5afd                	li	s5,-1
    6026:	a88d                	j	6098 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    6028:	0000a797          	auipc	a5,0xa
    602c:	c5078793          	addi	a5,a5,-944 # fc78 <base>
    6030:	00003717          	auipc	a4,0x3
    6034:	42f73023          	sd	a5,1056(a4) # 9450 <freep>
    6038:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    603a:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits)
    603e:	b7e1                	j	6006 <malloc+0x36>
      if (p->s.size == nunits)
    6040:	02e48b63          	beq	s1,a4,6076 <malloc+0xa6>
        p->s.size -= nunits;
    6044:	4137073b          	subw	a4,a4,s3
    6048:	c798                	sw	a4,8(a5)
        p += p->s.size;
    604a:	1702                	slli	a4,a4,0x20
    604c:	9301                	srli	a4,a4,0x20
    604e:	0712                	slli	a4,a4,0x4
    6050:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    6052:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    6056:	00003717          	auipc	a4,0x3
    605a:	3ea73d23          	sd	a0,1018(a4) # 9450 <freep>
      return (void *)(p + 1);
    605e:	01078513          	addi	a0,a5,16
      if ((p = morecore(nunits)) == 0)
        return 0;
  }
}
    6062:	70e2                	ld	ra,56(sp)
    6064:	7442                	ld	s0,48(sp)
    6066:	74a2                	ld	s1,40(sp)
    6068:	7902                	ld	s2,32(sp)
    606a:	69e2                	ld	s3,24(sp)
    606c:	6a42                	ld	s4,16(sp)
    606e:	6aa2                	ld	s5,8(sp)
    6070:	6b02                	ld	s6,0(sp)
    6072:	6121                	addi	sp,sp,64
    6074:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    6076:	6398                	ld	a4,0(a5)
    6078:	e118                	sd	a4,0(a0)
    607a:	bff1                	j	6056 <malloc+0x86>
  hp->s.size = nu;
    607c:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
    6080:	0541                	addi	a0,a0,16
    6082:	00000097          	auipc	ra,0x0
    6086:	ec6080e7          	jalr	-314(ra) # 5f48 <free>
  return freep;
    608a:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
    608e:	d971                	beqz	a0,6062 <malloc+0x92>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    6090:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits)
    6092:	4798                	lw	a4,8(a5)
    6094:	fa9776e3          	bgeu	a4,s1,6040 <malloc+0x70>
    if (p == freep)
    6098:	00093703          	ld	a4,0(s2)
    609c:	853e                	mv	a0,a5
    609e:	fef719e3          	bne	a4,a5,6090 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    60a2:	8552                	mv	a0,s4
    60a4:	00000097          	auipc	ra,0x0
    60a8:	b4e080e7          	jalr	-1202(ra) # 5bf2 <sbrk>
  if (p == (char *)-1)
    60ac:	fd5518e3          	bne	a0,s5,607c <malloc+0xac>
        return 0;
    60b0:	4501                	li	a0,0
    60b2:	bf45                	j	6062 <malloc+0x92>
