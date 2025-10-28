
user/_alarmtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <periodic>:
}

volatile static int count;

void periodic()
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    count = count + 1;
   8:	00001797          	auipc	a5,0x1
   c:	ff87a783          	lw	a5,-8(a5) # 1000 <count>
  10:	2785                	addiw	a5,a5,1
  12:	00001717          	auipc	a4,0x1
  16:	fef72723          	sw	a5,-18(a4) # 1000 <count>
    printf("alarm!\n");
  1a:	00001517          	auipc	a0,0x1
  1e:	c3650513          	addi	a0,a0,-970 # c50 <malloc+0xee>
  22:	00001097          	auipc	ra,0x1
  26:	a82080e7          	jalr	-1406(ra) # aa4 <printf>
    sigreturn();
  2a:	00000097          	auipc	ra,0x0
  2e:	77a080e7          	jalr	1914(ra) # 7a4 <sigreturn>
}
  32:	60a2                	ld	ra,8(sp)
  34:	6402                	ld	s0,0(sp)
  36:	0141                	addi	sp,sp,16
  38:	8082                	ret

000000000000003a <slow_handler>:
        printf("test2 passed\n");
    }
}

void slow_handler()
{
  3a:	1101                	addi	sp,sp,-32
  3c:	ec06                	sd	ra,24(sp)
  3e:	e822                	sd	s0,16(sp)
  40:	e426                	sd	s1,8(sp)
  42:	1000                	addi	s0,sp,32
    count++;
  44:	00001497          	auipc	s1,0x1
  48:	fbc48493          	addi	s1,s1,-68 # 1000 <count>
  4c:	00001797          	auipc	a5,0x1
  50:	fb47a783          	lw	a5,-76(a5) # 1000 <count>
  54:	2785                	addiw	a5,a5,1
  56:	c09c                	sw	a5,0(s1)
    printf("alarm!\n");
  58:	00001517          	auipc	a0,0x1
  5c:	bf850513          	addi	a0,a0,-1032 # c50 <malloc+0xee>
  60:	00001097          	auipc	ra,0x1
  64:	a44080e7          	jalr	-1468(ra) # aa4 <printf>
    if (count > 1)
  68:	4098                	lw	a4,0(s1)
  6a:	2701                	sext.w	a4,a4
  6c:	4685                	li	a3,1
  6e:	1dcd67b7          	lui	a5,0x1dcd6
  72:	50078793          	addi	a5,a5,1280 # 1dcd6500 <base+0x1dcd54f0>
  76:	02e6c463          	blt	a3,a4,9e <slow_handler+0x64>
        printf("test2 failed: alarm handler called more than once\n");
        exit(1);
    }
    for (int i = 0; i < 1000 * 500000; i++)
    {
        asm volatile("nop"); // avoid compiler optimizing away loop
  7a:	0001                	nop
    for (int i = 0; i < 1000 * 500000; i++)
  7c:	37fd                	addiw	a5,a5,-1
  7e:	fff5                	bnez	a5,7a <slow_handler+0x40>
    }
    sigalarm(0, 0);
  80:	4581                	li	a1,0
  82:	4501                	li	a0,0
  84:	00000097          	auipc	ra,0x0
  88:	728080e7          	jalr	1832(ra) # 7ac <sigalarm>
    sigreturn();
  8c:	00000097          	auipc	ra,0x0
  90:	718080e7          	jalr	1816(ra) # 7a4 <sigreturn>
}
  94:	60e2                	ld	ra,24(sp)
  96:	6442                	ld	s0,16(sp)
  98:	64a2                	ld	s1,8(sp)
  9a:	6105                	addi	sp,sp,32
  9c:	8082                	ret
        printf("test2 failed: alarm handler called more than once\n");
  9e:	00001517          	auipc	a0,0x1
  a2:	bba50513          	addi	a0,a0,-1094 # c58 <malloc+0xf6>
  a6:	00001097          	auipc	ra,0x1
  aa:	9fe080e7          	jalr	-1538(ra) # aa4 <printf>
        exit(1);
  ae:	4505                	li	a0,1
  b0:	00000097          	auipc	ra,0x0
  b4:	64c080e7          	jalr	1612(ra) # 6fc <exit>

00000000000000b8 <dummy_handler>:

//
// dummy alarm handler; after running immediately uninstall
// itself and finish signal handling
void dummy_handler()
{
  b8:	1141                	addi	sp,sp,-16
  ba:	e406                	sd	ra,8(sp)
  bc:	e022                	sd	s0,0(sp)
  be:	0800                	addi	s0,sp,16
    sigalarm(0, 0);
  c0:	4581                	li	a1,0
  c2:	4501                	li	a0,0
  c4:	00000097          	auipc	ra,0x0
  c8:	6e8080e7          	jalr	1768(ra) # 7ac <sigalarm>
    sigreturn();
  cc:	00000097          	auipc	ra,0x0
  d0:	6d8080e7          	jalr	1752(ra) # 7a4 <sigreturn>
}
  d4:	60a2                	ld	ra,8(sp)
  d6:	6402                	ld	s0,0(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret

00000000000000dc <test0>:
{
  dc:	7139                	addi	sp,sp,-64
  de:	fc06                	sd	ra,56(sp)
  e0:	f822                	sd	s0,48(sp)
  e2:	f426                	sd	s1,40(sp)
  e4:	f04a                	sd	s2,32(sp)
  e6:	ec4e                	sd	s3,24(sp)
  e8:	e852                	sd	s4,16(sp)
  ea:	e456                	sd	s5,8(sp)
  ec:	0080                	addi	s0,sp,64
    printf("test0 start\n");
  ee:	00001517          	auipc	a0,0x1
  f2:	ba250513          	addi	a0,a0,-1118 # c90 <malloc+0x12e>
  f6:	00001097          	auipc	ra,0x1
  fa:	9ae080e7          	jalr	-1618(ra) # aa4 <printf>
    count = 0;
  fe:	00001797          	auipc	a5,0x1
 102:	f007a123          	sw	zero,-254(a5) # 1000 <count>
    sigalarm(2, periodic);
 106:	00000597          	auipc	a1,0x0
 10a:	efa58593          	addi	a1,a1,-262 # 0 <periodic>
 10e:	4509                	li	a0,2
 110:	00000097          	auipc	ra,0x0
 114:	69c080e7          	jalr	1692(ra) # 7ac <sigalarm>
    for (i = 0; i < 1000 * 500000; i++)
 118:	4481                	li	s1,0
        if ((i % 1000000) == 0)
 11a:	000f4937          	lui	s2,0xf4
 11e:	2409091b          	addiw	s2,s2,576
            write(2, ".", 1);
 122:	00001a97          	auipc	s5,0x1
 126:	b7ea8a93          	addi	s5,s5,-1154 # ca0 <malloc+0x13e>
        if (count > 0)
 12a:	00001a17          	auipc	s4,0x1
 12e:	ed6a0a13          	addi	s4,s4,-298 # 1000 <count>
    for (i = 0; i < 1000 * 500000; i++)
 132:	1dcd69b7          	lui	s3,0x1dcd6
 136:	50098993          	addi	s3,s3,1280 # 1dcd6500 <base+0x1dcd54f0>
 13a:	a809                	j	14c <test0+0x70>
        if (count > 0)
 13c:	000a2783          	lw	a5,0(s4)
 140:	2781                	sext.w	a5,a5
 142:	02f04063          	bgtz	a5,162 <test0+0x86>
    for (i = 0; i < 1000 * 500000; i++)
 146:	2485                	addiw	s1,s1,1
 148:	01348d63          	beq	s1,s3,162 <test0+0x86>
        if ((i % 1000000) == 0)
 14c:	0324e7bb          	remw	a5,s1,s2
 150:	f7f5                	bnez	a5,13c <test0+0x60>
            write(2, ".", 1);
 152:	4605                	li	a2,1
 154:	85d6                	mv	a1,s5
 156:	4509                	li	a0,2
 158:	00000097          	auipc	ra,0x0
 15c:	5c4080e7          	jalr	1476(ra) # 71c <write>
 160:	bff1                	j	13c <test0+0x60>
    sigalarm(0, 0);
 162:	4581                	li	a1,0
 164:	4501                	li	a0,0
 166:	00000097          	auipc	ra,0x0
 16a:	646080e7          	jalr	1606(ra) # 7ac <sigalarm>
    if (count > 0)
 16e:	00001797          	auipc	a5,0x1
 172:	e927a783          	lw	a5,-366(a5) # 1000 <count>
 176:	02f05363          	blez	a5,19c <test0+0xc0>
        printf("test0 passed\n");
 17a:	00001517          	auipc	a0,0x1
 17e:	b2e50513          	addi	a0,a0,-1234 # ca8 <malloc+0x146>
 182:	00001097          	auipc	ra,0x1
 186:	922080e7          	jalr	-1758(ra) # aa4 <printf>
}
 18a:	70e2                	ld	ra,56(sp)
 18c:	7442                	ld	s0,48(sp)
 18e:	74a2                	ld	s1,40(sp)
 190:	7902                	ld	s2,32(sp)
 192:	69e2                	ld	s3,24(sp)
 194:	6a42                	ld	s4,16(sp)
 196:	6aa2                	ld	s5,8(sp)
 198:	6121                	addi	sp,sp,64
 19a:	8082                	ret
        printf("\ntest0 failed: the kernel never called the alarm handler\n");
 19c:	00001517          	auipc	a0,0x1
 1a0:	b1c50513          	addi	a0,a0,-1252 # cb8 <malloc+0x156>
 1a4:	00001097          	auipc	ra,0x1
 1a8:	900080e7          	jalr	-1792(ra) # aa4 <printf>
}
 1ac:	bff9                	j	18a <test0+0xae>

00000000000001ae <foo>:
{
 1ae:	1101                	addi	sp,sp,-32
 1b0:	ec06                	sd	ra,24(sp)
 1b2:	e822                	sd	s0,16(sp)
 1b4:	e426                	sd	s1,8(sp)
 1b6:	1000                	addi	s0,sp,32
 1b8:	84ae                	mv	s1,a1
    if ((i % 25000000) == 0)
 1ba:	017d87b7          	lui	a5,0x17d8
 1be:	8407879b          	addiw	a5,a5,-1984
 1c2:	02f5653b          	remw	a0,a0,a5
 1c6:	c909                	beqz	a0,1d8 <foo+0x2a>
    *j += 1;
 1c8:	409c                	lw	a5,0(s1)
 1ca:	2785                	addiw	a5,a5,1
 1cc:	c09c                	sw	a5,0(s1)
}
 1ce:	60e2                	ld	ra,24(sp)
 1d0:	6442                	ld	s0,16(sp)
 1d2:	64a2                	ld	s1,8(sp)
 1d4:	6105                	addi	sp,sp,32
 1d6:	8082                	ret
        write(2, ".", 1);
 1d8:	4605                	li	a2,1
 1da:	00001597          	auipc	a1,0x1
 1de:	ac658593          	addi	a1,a1,-1338 # ca0 <malloc+0x13e>
 1e2:	4509                	li	a0,2
 1e4:	00000097          	auipc	ra,0x0
 1e8:	538080e7          	jalr	1336(ra) # 71c <write>
 1ec:	bff1                	j	1c8 <foo+0x1a>

00000000000001ee <test1>:
{
 1ee:	7139                	addi	sp,sp,-64
 1f0:	fc06                	sd	ra,56(sp)
 1f2:	f822                	sd	s0,48(sp)
 1f4:	f426                	sd	s1,40(sp)
 1f6:	f04a                	sd	s2,32(sp)
 1f8:	ec4e                	sd	s3,24(sp)
 1fa:	e852                	sd	s4,16(sp)
 1fc:	0080                	addi	s0,sp,64
    printf("test1 start\n");
 1fe:	00001517          	auipc	a0,0x1
 202:	afa50513          	addi	a0,a0,-1286 # cf8 <malloc+0x196>
 206:	00001097          	auipc	ra,0x1
 20a:	89e080e7          	jalr	-1890(ra) # aa4 <printf>
    count = 0;
 20e:	00001797          	auipc	a5,0x1
 212:	de07a923          	sw	zero,-526(a5) # 1000 <count>
    j = 0;
 216:	fc042623          	sw	zero,-52(s0)
    sigalarm(2, periodic);
 21a:	00000597          	auipc	a1,0x0
 21e:	de658593          	addi	a1,a1,-538 # 0 <periodic>
 222:	4509                	li	a0,2
 224:	00000097          	auipc	ra,0x0
 228:	588080e7          	jalr	1416(ra) # 7ac <sigalarm>
    for (i = 0; i < 500000000; i++)
 22c:	4481                	li	s1,0
        if (count >= 10)
 22e:	00001a17          	auipc	s4,0x1
 232:	dd2a0a13          	addi	s4,s4,-558 # 1000 <count>
 236:	49a5                	li	s3,9
    for (i = 0; i < 500000000; i++)
 238:	1dcd6937          	lui	s2,0x1dcd6
 23c:	50090913          	addi	s2,s2,1280 # 1dcd6500 <base+0x1dcd54f0>
        if (count >= 10)
 240:	000a2783          	lw	a5,0(s4)
 244:	2781                	sext.w	a5,a5
 246:	00f9cc63          	blt	s3,a5,25e <test1+0x70>
        foo(i, &j);
 24a:	fcc40593          	addi	a1,s0,-52
 24e:	8526                	mv	a0,s1
 250:	00000097          	auipc	ra,0x0
 254:	f5e080e7          	jalr	-162(ra) # 1ae <foo>
    for (i = 0; i < 500000000; i++)
 258:	2485                	addiw	s1,s1,1
 25a:	ff2493e3          	bne	s1,s2,240 <test1+0x52>
    printf("done\n");
 25e:	00001517          	auipc	a0,0x1
 262:	aaa50513          	addi	a0,a0,-1366 # d08 <malloc+0x1a6>
 266:	00001097          	auipc	ra,0x1
 26a:	83e080e7          	jalr	-1986(ra) # aa4 <printf>
    if (count < 10)
 26e:	00001717          	auipc	a4,0x1
 272:	d9272703          	lw	a4,-622(a4) # 1000 <count>
 276:	47a5                	li	a5,9
 278:	02e7d663          	bge	a5,a4,2a4 <test1+0xb6>
    else if (i != j)
 27c:	fcc42783          	lw	a5,-52(s0)
 280:	02978b63          	beq	a5,s1,2b6 <test1+0xc8>
        printf("\ntest1 failed: foo() executed fewer times than it was called\n");
 284:	00001517          	auipc	a0,0x1
 288:	abc50513          	addi	a0,a0,-1348 # d40 <malloc+0x1de>
 28c:	00001097          	auipc	ra,0x1
 290:	818080e7          	jalr	-2024(ra) # aa4 <printf>
}
 294:	70e2                	ld	ra,56(sp)
 296:	7442                	ld	s0,48(sp)
 298:	74a2                	ld	s1,40(sp)
 29a:	7902                	ld	s2,32(sp)
 29c:	69e2                	ld	s3,24(sp)
 29e:	6a42                	ld	s4,16(sp)
 2a0:	6121                	addi	sp,sp,64
 2a2:	8082                	ret
        printf("\ntest1 failed: too few calls to the handler\n");
 2a4:	00001517          	auipc	a0,0x1
 2a8:	a6c50513          	addi	a0,a0,-1428 # d10 <malloc+0x1ae>
 2ac:	00000097          	auipc	ra,0x0
 2b0:	7f8080e7          	jalr	2040(ra) # aa4 <printf>
 2b4:	b7c5                	j	294 <test1+0xa6>
        printf("test1 passed\n");
 2b6:	00001517          	auipc	a0,0x1
 2ba:	aca50513          	addi	a0,a0,-1334 # d80 <malloc+0x21e>
 2be:	00000097          	auipc	ra,0x0
 2c2:	7e6080e7          	jalr	2022(ra) # aa4 <printf>
}
 2c6:	b7f9                	j	294 <test1+0xa6>

00000000000002c8 <test2>:
{
 2c8:	715d                	addi	sp,sp,-80
 2ca:	e486                	sd	ra,72(sp)
 2cc:	e0a2                	sd	s0,64(sp)
 2ce:	fc26                	sd	s1,56(sp)
 2d0:	f84a                	sd	s2,48(sp)
 2d2:	f44e                	sd	s3,40(sp)
 2d4:	f052                	sd	s4,32(sp)
 2d6:	ec56                	sd	s5,24(sp)
 2d8:	0880                	addi	s0,sp,80
    printf("test2 start\n");
 2da:	00001517          	auipc	a0,0x1
 2de:	ab650513          	addi	a0,a0,-1354 # d90 <malloc+0x22e>
 2e2:	00000097          	auipc	ra,0x0
 2e6:	7c2080e7          	jalr	1986(ra) # aa4 <printf>
    if ((pid = fork()) < 0)
 2ea:	00000097          	auipc	ra,0x0
 2ee:	40a080e7          	jalr	1034(ra) # 6f4 <fork>
 2f2:	04054263          	bltz	a0,336 <test2+0x6e>
 2f6:	84aa                	mv	s1,a0
    if (pid == 0)
 2f8:	e539                	bnez	a0,346 <test2+0x7e>
        count = 0;
 2fa:	00001797          	auipc	a5,0x1
 2fe:	d007a323          	sw	zero,-762(a5) # 1000 <count>
        sigalarm(2, slow_handler);
 302:	00000597          	auipc	a1,0x0
 306:	d3858593          	addi	a1,a1,-712 # 3a <slow_handler>
 30a:	4509                	li	a0,2
 30c:	00000097          	auipc	ra,0x0
 310:	4a0080e7          	jalr	1184(ra) # 7ac <sigalarm>
            if ((i % 1000000) == 0)
 314:	000f4937          	lui	s2,0xf4
 318:	2409091b          	addiw	s2,s2,576
                write(2, ".", 1);
 31c:	00001a97          	auipc	s5,0x1
 320:	984a8a93          	addi	s5,s5,-1660 # ca0 <malloc+0x13e>
            if (count > 0)
 324:	00001a17          	auipc	s4,0x1
 328:	cdca0a13          	addi	s4,s4,-804 # 1000 <count>
        for (i = 0; i < 1000 * 500000; i++)
 32c:	1dcd69b7          	lui	s3,0x1dcd6
 330:	50098993          	addi	s3,s3,1280 # 1dcd6500 <base+0x1dcd54f0>
 334:	a099                	j	37a <test2+0xb2>
        printf("test2: fork failed\n");
 336:	00001517          	auipc	a0,0x1
 33a:	a6a50513          	addi	a0,a0,-1430 # da0 <malloc+0x23e>
 33e:	00000097          	auipc	ra,0x0
 342:	766080e7          	jalr	1894(ra) # aa4 <printf>
    wait(&status);
 346:	fbc40513          	addi	a0,s0,-68
 34a:	00000097          	auipc	ra,0x0
 34e:	3ba080e7          	jalr	954(ra) # 704 <wait>
    if (status == 0)
 352:	fbc42783          	lw	a5,-68(s0)
 356:	c7a5                	beqz	a5,3be <test2+0xf6>
}
 358:	60a6                	ld	ra,72(sp)
 35a:	6406                	ld	s0,64(sp)
 35c:	74e2                	ld	s1,56(sp)
 35e:	7942                	ld	s2,48(sp)
 360:	79a2                	ld	s3,40(sp)
 362:	7a02                	ld	s4,32(sp)
 364:	6ae2                	ld	s5,24(sp)
 366:	6161                	addi	sp,sp,80
 368:	8082                	ret
            if (count > 0)
 36a:	000a2783          	lw	a5,0(s4)
 36e:	2781                	sext.w	a5,a5
 370:	02f04063          	bgtz	a5,390 <test2+0xc8>
        for (i = 0; i < 1000 * 500000; i++)
 374:	2485                	addiw	s1,s1,1
 376:	01348d63          	beq	s1,s3,390 <test2+0xc8>
            if ((i % 1000000) == 0)
 37a:	0324e7bb          	remw	a5,s1,s2
 37e:	f7f5                	bnez	a5,36a <test2+0xa2>
                write(2, ".", 1);
 380:	4605                	li	a2,1
 382:	85d6                	mv	a1,s5
 384:	4509                	li	a0,2
 386:	00000097          	auipc	ra,0x0
 38a:	396080e7          	jalr	918(ra) # 71c <write>
 38e:	bff1                	j	36a <test2+0xa2>
        if (count == 0)
 390:	00001797          	auipc	a5,0x1
 394:	c707a783          	lw	a5,-912(a5) # 1000 <count>
 398:	ef91                	bnez	a5,3b4 <test2+0xec>
            printf("\ntest2 failed: alarm not called\n");
 39a:	00001517          	auipc	a0,0x1
 39e:	a1e50513          	addi	a0,a0,-1506 # db8 <malloc+0x256>
 3a2:	00000097          	auipc	ra,0x0
 3a6:	702080e7          	jalr	1794(ra) # aa4 <printf>
            exit(1);
 3aa:	4505                	li	a0,1
 3ac:	00000097          	auipc	ra,0x0
 3b0:	350080e7          	jalr	848(ra) # 6fc <exit>
        exit(0);
 3b4:	4501                	li	a0,0
 3b6:	00000097          	auipc	ra,0x0
 3ba:	346080e7          	jalr	838(ra) # 6fc <exit>
        printf("test2 passed\n");
 3be:	00001517          	auipc	a0,0x1
 3c2:	a2250513          	addi	a0,a0,-1502 # de0 <malloc+0x27e>
 3c6:	00000097          	auipc	ra,0x0
 3ca:	6de080e7          	jalr	1758(ra) # aa4 <printf>
}
 3ce:	b769                	j	358 <test2+0x90>

00000000000003d0 <test3>:

//
// tests that the return from sys_sigreturn() does not
// modify the a0 register
void test3()
{
 3d0:	1141                	addi	sp,sp,-16
 3d2:	e406                	sd	ra,8(sp)
 3d4:	e022                	sd	s0,0(sp)
 3d6:	0800                	addi	s0,sp,16
    uint64 a0;

    sigalarm(1, dummy_handler);
 3d8:	00000597          	auipc	a1,0x0
 3dc:	ce058593          	addi	a1,a1,-800 # b8 <dummy_handler>
 3e0:	4505                	li	a0,1
 3e2:	00000097          	auipc	ra,0x0
 3e6:	3ca080e7          	jalr	970(ra) # 7ac <sigalarm>
    printf("test3 start\n");
 3ea:	00001517          	auipc	a0,0x1
 3ee:	a0650513          	addi	a0,a0,-1530 # df0 <malloc+0x28e>
 3f2:	00000097          	auipc	ra,0x0
 3f6:	6b2080e7          	jalr	1714(ra) # aa4 <printf>

    asm volatile("lui a5, 0");
 3fa:	000007b7          	lui	a5,0x0
    asm volatile("addi a0, a5, 0xac"
 3fe:	0ac78513          	addi	a0,a5,172 # ac <slow_handler+0x72>
 402:	1dcd67b7          	lui	a5,0x1dcd6
 406:	50078793          	addi	a5,a5,1280 # 1dcd6500 <base+0x1dcd54f0>
                 :
                 :
                 : "a0");
    for (int i = 0; i < 500000000; i++)
 40a:	37fd                	addiw	a5,a5,-1
 40c:	fffd                	bnez	a5,40a <test3+0x3a>
        ;
    asm volatile("mv %0, a0"
 40e:	872a                	mv	a4,a0
                 : "=r"(a0));

    if (a0 != 0xac)
 410:	0ac00793          	li	a5,172
 414:	00f70e63          	beq	a4,a5,430 <test3+0x60>
        printf("test3 failed: register a0 changed\n");
 418:	00001517          	auipc	a0,0x1
 41c:	9e850513          	addi	a0,a0,-1560 # e00 <malloc+0x29e>
 420:	00000097          	auipc	ra,0x0
 424:	684080e7          	jalr	1668(ra) # aa4 <printf>
    else
        printf("test3 passed\n");
}
 428:	60a2                	ld	ra,8(sp)
 42a:	6402                	ld	s0,0(sp)
 42c:	0141                	addi	sp,sp,16
 42e:	8082                	ret
        printf("test3 passed\n");
 430:	00001517          	auipc	a0,0x1
 434:	9f850513          	addi	a0,a0,-1544 # e28 <malloc+0x2c6>
 438:	00000097          	auipc	ra,0x0
 43c:	66c080e7          	jalr	1644(ra) # aa4 <printf>
}
 440:	b7e5                	j	428 <test3+0x58>

0000000000000442 <main>:
{
 442:	1141                	addi	sp,sp,-16
 444:	e406                	sd	ra,8(sp)
 446:	e022                	sd	s0,0(sp)
 448:	0800                	addi	s0,sp,16
    test0();
 44a:	00000097          	auipc	ra,0x0
 44e:	c92080e7          	jalr	-878(ra) # dc <test0>
    test1();
 452:	00000097          	auipc	ra,0x0
 456:	d9c080e7          	jalr	-612(ra) # 1ee <test1>
    test2();
 45a:	00000097          	auipc	ra,0x0
 45e:	e6e080e7          	jalr	-402(ra) # 2c8 <test2>
    test3();
 462:	00000097          	auipc	ra,0x0
 466:	f6e080e7          	jalr	-146(ra) # 3d0 <test3>
    exit(0);
 46a:	4501                	li	a0,0
 46c:	00000097          	auipc	ra,0x0
 470:	290080e7          	jalr	656(ra) # 6fc <exit>

0000000000000474 <_main>:

//
// wrapper so that it's OK if main() does not call exit().
//
void _main()
{
 474:	1141                	addi	sp,sp,-16
 476:	e406                	sd	ra,8(sp)
 478:	e022                	sd	s0,0(sp)
 47a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 47c:	00000097          	auipc	ra,0x0
 480:	fc6080e7          	jalr	-58(ra) # 442 <main>
  exit(0);
 484:	4501                	li	a0,0
 486:	00000097          	auipc	ra,0x0
 48a:	276080e7          	jalr	630(ra) # 6fc <exit>

000000000000048e <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 48e:	1141                	addi	sp,sp,-16
 490:	e422                	sd	s0,8(sp)
 492:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 494:	87aa                	mv	a5,a0
 496:	0585                	addi	a1,a1,1
 498:	0785                	addi	a5,a5,1
 49a:	fff5c703          	lbu	a4,-1(a1)
 49e:	fee78fa3          	sb	a4,-1(a5)
 4a2:	fb75                	bnez	a4,496 <strcpy+0x8>
    ;
  return os;
}
 4a4:	6422                	ld	s0,8(sp)
 4a6:	0141                	addi	sp,sp,16
 4a8:	8082                	ret

00000000000004aa <strcmp>:

int strcmp(const char *p, const char *q)
{
 4aa:	1141                	addi	sp,sp,-16
 4ac:	e422                	sd	s0,8(sp)
 4ae:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 4b0:	00054783          	lbu	a5,0(a0)
 4b4:	cb91                	beqz	a5,4c8 <strcmp+0x1e>
 4b6:	0005c703          	lbu	a4,0(a1)
 4ba:	00f71763          	bne	a4,a5,4c8 <strcmp+0x1e>
    p++, q++;
 4be:	0505                	addi	a0,a0,1
 4c0:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 4c2:	00054783          	lbu	a5,0(a0)
 4c6:	fbe5                	bnez	a5,4b6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4c8:	0005c503          	lbu	a0,0(a1)
}
 4cc:	40a7853b          	subw	a0,a5,a0
 4d0:	6422                	ld	s0,8(sp)
 4d2:	0141                	addi	sp,sp,16
 4d4:	8082                	ret

00000000000004d6 <strlen>:

uint strlen(const char *s)
{
 4d6:	1141                	addi	sp,sp,-16
 4d8:	e422                	sd	s0,8(sp)
 4da:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 4dc:	00054783          	lbu	a5,0(a0)
 4e0:	cf91                	beqz	a5,4fc <strlen+0x26>
 4e2:	0505                	addi	a0,a0,1
 4e4:	87aa                	mv	a5,a0
 4e6:	4685                	li	a3,1
 4e8:	9e89                	subw	a3,a3,a0
 4ea:	00f6853b          	addw	a0,a3,a5
 4ee:	0785                	addi	a5,a5,1
 4f0:	fff7c703          	lbu	a4,-1(a5)
 4f4:	fb7d                	bnez	a4,4ea <strlen+0x14>
    ;
  return n;
}
 4f6:	6422                	ld	s0,8(sp)
 4f8:	0141                	addi	sp,sp,16
 4fa:	8082                	ret
  for (n = 0; s[n]; n++)
 4fc:	4501                	li	a0,0
 4fe:	bfe5                	j	4f6 <strlen+0x20>

0000000000000500 <memset>:

void *
memset(void *dst, int c, uint n)
{
 500:	1141                	addi	sp,sp,-16
 502:	e422                	sd	s0,8(sp)
 504:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++)
 506:	ca19                	beqz	a2,51c <memset+0x1c>
 508:	87aa                	mv	a5,a0
 50a:	1602                	slli	a2,a2,0x20
 50c:	9201                	srli	a2,a2,0x20
 50e:	00a60733          	add	a4,a2,a0
  {
    cdst[i] = c;
 512:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++)
 516:	0785                	addi	a5,a5,1
 518:	fee79de3          	bne	a5,a4,512 <memset+0x12>
  }
  return dst;
}
 51c:	6422                	ld	s0,8(sp)
 51e:	0141                	addi	sp,sp,16
 520:	8082                	ret

0000000000000522 <strchr>:

char *
strchr(const char *s, char c)
{
 522:	1141                	addi	sp,sp,-16
 524:	e422                	sd	s0,8(sp)
 526:	0800                	addi	s0,sp,16
  for (; *s; s++)
 528:	00054783          	lbu	a5,0(a0)
 52c:	cb99                	beqz	a5,542 <strchr+0x20>
    if (*s == c)
 52e:	00f58763          	beq	a1,a5,53c <strchr+0x1a>
  for (; *s; s++)
 532:	0505                	addi	a0,a0,1
 534:	00054783          	lbu	a5,0(a0)
 538:	fbfd                	bnez	a5,52e <strchr+0xc>
      return (char *)s;
  return 0;
 53a:	4501                	li	a0,0
}
 53c:	6422                	ld	s0,8(sp)
 53e:	0141                	addi	sp,sp,16
 540:	8082                	ret
  return 0;
 542:	4501                	li	a0,0
 544:	bfe5                	j	53c <strchr+0x1a>

0000000000000546 <gets>:

char *
gets(char *buf, int max)
{
 546:	711d                	addi	sp,sp,-96
 548:	ec86                	sd	ra,88(sp)
 54a:	e8a2                	sd	s0,80(sp)
 54c:	e4a6                	sd	s1,72(sp)
 54e:	e0ca                	sd	s2,64(sp)
 550:	fc4e                	sd	s3,56(sp)
 552:	f852                	sd	s4,48(sp)
 554:	f456                	sd	s5,40(sp)
 556:	f05a                	sd	s6,32(sp)
 558:	ec5e                	sd	s7,24(sp)
 55a:	1080                	addi	s0,sp,96
 55c:	8baa                	mv	s7,a0
 55e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;)
 560:	892a                	mv	s2,a0
 562:	4481                	li	s1,0
  {
    cc = read(0, &c, 1);
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 564:	4aa9                	li	s5,10
 566:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;)
 568:	89a6                	mv	s3,s1
 56a:	2485                	addiw	s1,s1,1
 56c:	0344d863          	bge	s1,s4,59c <gets+0x56>
    cc = read(0, &c, 1);
 570:	4605                	li	a2,1
 572:	faf40593          	addi	a1,s0,-81
 576:	4501                	li	a0,0
 578:	00000097          	auipc	ra,0x0
 57c:	19c080e7          	jalr	412(ra) # 714 <read>
    if (cc < 1)
 580:	00a05e63          	blez	a0,59c <gets+0x56>
    buf[i++] = c;
 584:	faf44783          	lbu	a5,-81(s0)
 588:	00f90023          	sb	a5,0(s2) # f4000 <base+0xf2ff0>
    if (c == '\n' || c == '\r')
 58c:	01578763          	beq	a5,s5,59a <gets+0x54>
 590:	0905                	addi	s2,s2,1
 592:	fd679be3          	bne	a5,s6,568 <gets+0x22>
  for (i = 0; i + 1 < max;)
 596:	89a6                	mv	s3,s1
 598:	a011                	j	59c <gets+0x56>
 59a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 59c:	99de                	add	s3,s3,s7
 59e:	00098023          	sb	zero,0(s3)
  return buf;
}
 5a2:	855e                	mv	a0,s7
 5a4:	60e6                	ld	ra,88(sp)
 5a6:	6446                	ld	s0,80(sp)
 5a8:	64a6                	ld	s1,72(sp)
 5aa:	6906                	ld	s2,64(sp)
 5ac:	79e2                	ld	s3,56(sp)
 5ae:	7a42                	ld	s4,48(sp)
 5b0:	7aa2                	ld	s5,40(sp)
 5b2:	7b02                	ld	s6,32(sp)
 5b4:	6be2                	ld	s7,24(sp)
 5b6:	6125                	addi	sp,sp,96
 5b8:	8082                	ret

00000000000005ba <stat>:

int stat(const char *n, struct stat *st)
{
 5ba:	1101                	addi	sp,sp,-32
 5bc:	ec06                	sd	ra,24(sp)
 5be:	e822                	sd	s0,16(sp)
 5c0:	e426                	sd	s1,8(sp)
 5c2:	e04a                	sd	s2,0(sp)
 5c4:	1000                	addi	s0,sp,32
 5c6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5c8:	4581                	li	a1,0
 5ca:	00000097          	auipc	ra,0x0
 5ce:	172080e7          	jalr	370(ra) # 73c <open>
  if (fd < 0)
 5d2:	02054563          	bltz	a0,5fc <stat+0x42>
 5d6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5d8:	85ca                	mv	a1,s2
 5da:	00000097          	auipc	ra,0x0
 5de:	17a080e7          	jalr	378(ra) # 754 <fstat>
 5e2:	892a                	mv	s2,a0
  close(fd);
 5e4:	8526                	mv	a0,s1
 5e6:	00000097          	auipc	ra,0x0
 5ea:	13e080e7          	jalr	318(ra) # 724 <close>
  return r;
}
 5ee:	854a                	mv	a0,s2
 5f0:	60e2                	ld	ra,24(sp)
 5f2:	6442                	ld	s0,16(sp)
 5f4:	64a2                	ld	s1,8(sp)
 5f6:	6902                	ld	s2,0(sp)
 5f8:	6105                	addi	sp,sp,32
 5fa:	8082                	ret
    return -1;
 5fc:	597d                	li	s2,-1
 5fe:	bfc5                	j	5ee <stat+0x34>

0000000000000600 <atoi>:

int atoi(const char *s)
{
 600:	1141                	addi	sp,sp,-16
 602:	e422                	sd	s0,8(sp)
 604:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 606:	00054603          	lbu	a2,0(a0)
 60a:	fd06079b          	addiw	a5,a2,-48
 60e:	0ff7f793          	andi	a5,a5,255
 612:	4725                	li	a4,9
 614:	02f76963          	bltu	a4,a5,646 <atoi+0x46>
 618:	86aa                	mv	a3,a0
  n = 0;
 61a:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9')
 61c:	45a5                	li	a1,9
    n = n * 10 + *s++ - '0';
 61e:	0685                	addi	a3,a3,1
 620:	0025179b          	slliw	a5,a0,0x2
 624:	9fa9                	addw	a5,a5,a0
 626:	0017979b          	slliw	a5,a5,0x1
 62a:	9fb1                	addw	a5,a5,a2
 62c:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 630:	0006c603          	lbu	a2,0(a3)
 634:	fd06071b          	addiw	a4,a2,-48
 638:	0ff77713          	andi	a4,a4,255
 63c:	fee5f1e3          	bgeu	a1,a4,61e <atoi+0x1e>
  return n;
}
 640:	6422                	ld	s0,8(sp)
 642:	0141                	addi	sp,sp,16
 644:	8082                	ret
  n = 0;
 646:	4501                	li	a0,0
 648:	bfe5                	j	640 <atoi+0x40>

000000000000064a <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 64a:	1141                	addi	sp,sp,-16
 64c:	e422                	sd	s0,8(sp)
 64e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst)
 650:	02b57463          	bgeu	a0,a1,678 <memmove+0x2e>
  {
    while (n-- > 0)
 654:	00c05f63          	blez	a2,672 <memmove+0x28>
 658:	1602                	slli	a2,a2,0x20
 65a:	9201                	srli	a2,a2,0x20
 65c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 660:	872a                	mv	a4,a0
      *dst++ = *src++;
 662:	0585                	addi	a1,a1,1
 664:	0705                	addi	a4,a4,1
 666:	fff5c683          	lbu	a3,-1(a1)
 66a:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 66e:	fee79ae3          	bne	a5,a4,662 <memmove+0x18>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 672:	6422                	ld	s0,8(sp)
 674:	0141                	addi	sp,sp,16
 676:	8082                	ret
    dst += n;
 678:	00c50733          	add	a4,a0,a2
    src += n;
 67c:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 67e:	fec05ae3          	blez	a2,672 <memmove+0x28>
 682:	fff6079b          	addiw	a5,a2,-1
 686:	1782                	slli	a5,a5,0x20
 688:	9381                	srli	a5,a5,0x20
 68a:	fff7c793          	not	a5,a5
 68e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 690:	15fd                	addi	a1,a1,-1
 692:	177d                	addi	a4,a4,-1
 694:	0005c683          	lbu	a3,0(a1)
 698:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 69c:	fee79ae3          	bne	a5,a4,690 <memmove+0x46>
 6a0:	bfc9                	j	672 <memmove+0x28>

00000000000006a2 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 6a2:	1141                	addi	sp,sp,-16
 6a4:	e422                	sd	s0,8(sp)
 6a6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0)
 6a8:	ca05                	beqz	a2,6d8 <memcmp+0x36>
 6aa:	fff6069b          	addiw	a3,a2,-1
 6ae:	1682                	slli	a3,a3,0x20
 6b0:	9281                	srli	a3,a3,0x20
 6b2:	0685                	addi	a3,a3,1
 6b4:	96aa                	add	a3,a3,a0
  {
    if (*p1 != *p2)
 6b6:	00054783          	lbu	a5,0(a0)
 6ba:	0005c703          	lbu	a4,0(a1)
 6be:	00e79863          	bne	a5,a4,6ce <memcmp+0x2c>
    {
      return *p1 - *p2;
    }
    p1++;
 6c2:	0505                	addi	a0,a0,1
    p2++;
 6c4:	0585                	addi	a1,a1,1
  while (n-- > 0)
 6c6:	fed518e3          	bne	a0,a3,6b6 <memcmp+0x14>
  }
  return 0;
 6ca:	4501                	li	a0,0
 6cc:	a019                	j	6d2 <memcmp+0x30>
      return *p1 - *p2;
 6ce:	40e7853b          	subw	a0,a5,a4
}
 6d2:	6422                	ld	s0,8(sp)
 6d4:	0141                	addi	sp,sp,16
 6d6:	8082                	ret
  return 0;
 6d8:	4501                	li	a0,0
 6da:	bfe5                	j	6d2 <memcmp+0x30>

00000000000006dc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6dc:	1141                	addi	sp,sp,-16
 6de:	e406                	sd	ra,8(sp)
 6e0:	e022                	sd	s0,0(sp)
 6e2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 6e4:	00000097          	auipc	ra,0x0
 6e8:	f66080e7          	jalr	-154(ra) # 64a <memmove>
}
 6ec:	60a2                	ld	ra,8(sp)
 6ee:	6402                	ld	s0,0(sp)
 6f0:	0141                	addi	sp,sp,16
 6f2:	8082                	ret

00000000000006f4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6f4:	4885                	li	a7,1
 ecall
 6f6:	00000073          	ecall
 ret
 6fa:	8082                	ret

00000000000006fc <exit>:
.global exit
exit:
 li a7, SYS_exit
 6fc:	4889                	li	a7,2
 ecall
 6fe:	00000073          	ecall
 ret
 702:	8082                	ret

0000000000000704 <wait>:
.global wait
wait:
 li a7, SYS_wait
 704:	488d                	li	a7,3
 ecall
 706:	00000073          	ecall
 ret
 70a:	8082                	ret

000000000000070c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 70c:	4891                	li	a7,4
 ecall
 70e:	00000073          	ecall
 ret
 712:	8082                	ret

0000000000000714 <read>:
.global read
read:
 li a7, SYS_read
 714:	4895                	li	a7,5
 ecall
 716:	00000073          	ecall
 ret
 71a:	8082                	ret

000000000000071c <write>:
.global write
write:
 li a7, SYS_write
 71c:	48c1                	li	a7,16
 ecall
 71e:	00000073          	ecall
 ret
 722:	8082                	ret

0000000000000724 <close>:
.global close
close:
 li a7, SYS_close
 724:	48d5                	li	a7,21
 ecall
 726:	00000073          	ecall
 ret
 72a:	8082                	ret

000000000000072c <kill>:
.global kill
kill:
 li a7, SYS_kill
 72c:	4899                	li	a7,6
 ecall
 72e:	00000073          	ecall
 ret
 732:	8082                	ret

0000000000000734 <exec>:
.global exec
exec:
 li a7, SYS_exec
 734:	489d                	li	a7,7
 ecall
 736:	00000073          	ecall
 ret
 73a:	8082                	ret

000000000000073c <open>:
.global open
open:
 li a7, SYS_open
 73c:	48bd                	li	a7,15
 ecall
 73e:	00000073          	ecall
 ret
 742:	8082                	ret

0000000000000744 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 744:	48c5                	li	a7,17
 ecall
 746:	00000073          	ecall
 ret
 74a:	8082                	ret

000000000000074c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 74c:	48c9                	li	a7,18
 ecall
 74e:	00000073          	ecall
 ret
 752:	8082                	ret

0000000000000754 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 754:	48a1                	li	a7,8
 ecall
 756:	00000073          	ecall
 ret
 75a:	8082                	ret

000000000000075c <link>:
.global link
link:
 li a7, SYS_link
 75c:	48cd                	li	a7,19
 ecall
 75e:	00000073          	ecall
 ret
 762:	8082                	ret

0000000000000764 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 764:	48d1                	li	a7,20
 ecall
 766:	00000073          	ecall
 ret
 76a:	8082                	ret

000000000000076c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 76c:	48a5                	li	a7,9
 ecall
 76e:	00000073          	ecall
 ret
 772:	8082                	ret

0000000000000774 <dup>:
.global dup
dup:
 li a7, SYS_dup
 774:	48a9                	li	a7,10
 ecall
 776:	00000073          	ecall
 ret
 77a:	8082                	ret

000000000000077c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 77c:	48ad                	li	a7,11
 ecall
 77e:	00000073          	ecall
 ret
 782:	8082                	ret

0000000000000784 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 784:	48b1                	li	a7,12
 ecall
 786:	00000073          	ecall
 ret
 78a:	8082                	ret

000000000000078c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 78c:	48b5                	li	a7,13
 ecall
 78e:	00000073          	ecall
 ret
 792:	8082                	ret

0000000000000794 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 794:	48b9                	li	a7,14
 ecall
 796:	00000073          	ecall
 ret
 79a:	8082                	ret

000000000000079c <trace>:
.global trace
trace:
 li a7, SYS_trace
 79c:	48d9                	li	a7,22
 ecall
 79e:	00000073          	ecall
 ret
 7a2:	8082                	ret

00000000000007a4 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 7a4:	48e5                	li	a7,25
 ecall
 7a6:	00000073          	ecall
 ret
 7aa:	8082                	ret

00000000000007ac <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 7ac:	48e1                	li	a7,24
 ecall
 7ae:	00000073          	ecall
 ret
 7b2:	8082                	ret

00000000000007b4 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 7b4:	48e9                	li	a7,26
 ecall
 7b6:	00000073          	ecall
 ret
 7ba:	8082                	ret

00000000000007bc <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 7bc:	48ed                	li	a7,27
 ecall
 7be:	00000073          	ecall
 ret
 7c2:	8082                	ret

00000000000007c4 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 7c4:	48dd                	li	a7,23
 ecall
 7c6:	00000073          	ecall
 ret
 7ca:	8082                	ret

00000000000007cc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7cc:	1101                	addi	sp,sp,-32
 7ce:	ec06                	sd	ra,24(sp)
 7d0:	e822                	sd	s0,16(sp)
 7d2:	1000                	addi	s0,sp,32
 7d4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7d8:	4605                	li	a2,1
 7da:	fef40593          	addi	a1,s0,-17
 7de:	00000097          	auipc	ra,0x0
 7e2:	f3e080e7          	jalr	-194(ra) # 71c <write>
}
 7e6:	60e2                	ld	ra,24(sp)
 7e8:	6442                	ld	s0,16(sp)
 7ea:	6105                	addi	sp,sp,32
 7ec:	8082                	ret

00000000000007ee <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7ee:	7139                	addi	sp,sp,-64
 7f0:	fc06                	sd	ra,56(sp)
 7f2:	f822                	sd	s0,48(sp)
 7f4:	f426                	sd	s1,40(sp)
 7f6:	f04a                	sd	s2,32(sp)
 7f8:	ec4e                	sd	s3,24(sp)
 7fa:	0080                	addi	s0,sp,64
 7fc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0)
 7fe:	c299                	beqz	a3,804 <printint+0x16>
 800:	0805c863          	bltz	a1,890 <printint+0xa2>
    neg = 1;
    x = -xx;
  }
  else
  {
    x = xx;
 804:	2581                	sext.w	a1,a1
  neg = 0;
 806:	4881                	li	a7,0
 808:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 80c:	4701                	li	a4,0
  do
  {
    buf[i++] = digits[x % base];
 80e:	2601                	sext.w	a2,a2
 810:	00000517          	auipc	a0,0x0
 814:	63050513          	addi	a0,a0,1584 # e40 <digits>
 818:	883a                	mv	a6,a4
 81a:	2705                	addiw	a4,a4,1
 81c:	02c5f7bb          	remuw	a5,a1,a2
 820:	1782                	slli	a5,a5,0x20
 822:	9381                	srli	a5,a5,0x20
 824:	97aa                	add	a5,a5,a0
 826:	0007c783          	lbu	a5,0(a5)
 82a:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 82e:	0005879b          	sext.w	a5,a1
 832:	02c5d5bb          	divuw	a1,a1,a2
 836:	0685                	addi	a3,a3,1
 838:	fec7f0e3          	bgeu	a5,a2,818 <printint+0x2a>
  if (neg)
 83c:	00088b63          	beqz	a7,852 <printint+0x64>
    buf[i++] = '-';
 840:	fd040793          	addi	a5,s0,-48
 844:	973e                	add	a4,a4,a5
 846:	02d00793          	li	a5,45
 84a:	fef70823          	sb	a5,-16(a4)
 84e:	0028071b          	addiw	a4,a6,2

  while (--i >= 0)
 852:	02e05863          	blez	a4,882 <printint+0x94>
 856:	fc040793          	addi	a5,s0,-64
 85a:	00e78933          	add	s2,a5,a4
 85e:	fff78993          	addi	s3,a5,-1
 862:	99ba                	add	s3,s3,a4
 864:	377d                	addiw	a4,a4,-1
 866:	1702                	slli	a4,a4,0x20
 868:	9301                	srli	a4,a4,0x20
 86a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 86e:	fff94583          	lbu	a1,-1(s2)
 872:	8526                	mv	a0,s1
 874:	00000097          	auipc	ra,0x0
 878:	f58080e7          	jalr	-168(ra) # 7cc <putc>
  while (--i >= 0)
 87c:	197d                	addi	s2,s2,-1
 87e:	ff3918e3          	bne	s2,s3,86e <printint+0x80>
}
 882:	70e2                	ld	ra,56(sp)
 884:	7442                	ld	s0,48(sp)
 886:	74a2                	ld	s1,40(sp)
 888:	7902                	ld	s2,32(sp)
 88a:	69e2                	ld	s3,24(sp)
 88c:	6121                	addi	sp,sp,64
 88e:	8082                	ret
    x = -xx;
 890:	40b005bb          	negw	a1,a1
    neg = 1;
 894:	4885                	li	a7,1
    x = -xx;
 896:	bf8d                	j	808 <printint+0x1a>

0000000000000898 <vprintf>:
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap)
{
 898:	7119                	addi	sp,sp,-128
 89a:	fc86                	sd	ra,120(sp)
 89c:	f8a2                	sd	s0,112(sp)
 89e:	f4a6                	sd	s1,104(sp)
 8a0:	f0ca                	sd	s2,96(sp)
 8a2:	ecce                	sd	s3,88(sp)
 8a4:	e8d2                	sd	s4,80(sp)
 8a6:	e4d6                	sd	s5,72(sp)
 8a8:	e0da                	sd	s6,64(sp)
 8aa:	fc5e                	sd	s7,56(sp)
 8ac:	f862                	sd	s8,48(sp)
 8ae:	f466                	sd	s9,40(sp)
 8b0:	f06a                	sd	s10,32(sp)
 8b2:	ec6e                	sd	s11,24(sp)
 8b4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++)
 8b6:	0005c903          	lbu	s2,0(a1)
 8ba:	18090f63          	beqz	s2,a58 <vprintf+0x1c0>
 8be:	8aaa                	mv	s5,a0
 8c0:	8b32                	mv	s6,a2
 8c2:	00158493          	addi	s1,a1,1
  state = 0;
 8c6:	4981                	li	s3,0
      else
      {
        putc(fd, c);
      }
    }
    else if (state == '%')
 8c8:	02500a13          	li	s4,37
    {
      if (c == 'd')
 8cc:	06400c13          	li	s8,100
      {
        printint(fd, va_arg(ap, int), 10, 1);
      }
      else if (c == 'l')
 8d0:	06c00c93          	li	s9,108
      {
        printint(fd, va_arg(ap, uint64), 10, 0);
      }
      else if (c == 'x')
 8d4:	07800d13          	li	s10,120
      {
        printint(fd, va_arg(ap, int), 16, 0);
      }
      else if (c == 'p')
 8d8:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8dc:	00000b97          	auipc	s7,0x0
 8e0:	564b8b93          	addi	s7,s7,1380 # e40 <digits>
 8e4:	a839                	j	902 <vprintf+0x6a>
        putc(fd, c);
 8e6:	85ca                	mv	a1,s2
 8e8:	8556                	mv	a0,s5
 8ea:	00000097          	auipc	ra,0x0
 8ee:	ee2080e7          	jalr	-286(ra) # 7cc <putc>
 8f2:	a019                	j	8f8 <vprintf+0x60>
    else if (state == '%')
 8f4:	01498f63          	beq	s3,s4,912 <vprintf+0x7a>
  for (i = 0; fmt[i]; i++)
 8f8:	0485                	addi	s1,s1,1
 8fa:	fff4c903          	lbu	s2,-1(s1)
 8fe:	14090d63          	beqz	s2,a58 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 902:	0009079b          	sext.w	a5,s2
    if (state == 0)
 906:	fe0997e3          	bnez	s3,8f4 <vprintf+0x5c>
      if (c == '%')
 90a:	fd479ee3          	bne	a5,s4,8e6 <vprintf+0x4e>
        state = '%';
 90e:	89be                	mv	s3,a5
 910:	b7e5                	j	8f8 <vprintf+0x60>
      if (c == 'd')
 912:	05878063          	beq	a5,s8,952 <vprintf+0xba>
      else if (c == 'l')
 916:	05978c63          	beq	a5,s9,96e <vprintf+0xd6>
      else if (c == 'x')
 91a:	07a78863          	beq	a5,s10,98a <vprintf+0xf2>
      else if (c == 'p')
 91e:	09b78463          	beq	a5,s11,9a6 <vprintf+0x10e>
      {
        printptr(fd, va_arg(ap, uint64));
      }
      else if (c == 's')
 922:	07300713          	li	a4,115
 926:	0ce78663          	beq	a5,a4,9f2 <vprintf+0x15a>
        {
          putc(fd, *s);
          s++;
        }
      }
      else if (c == 'c')
 92a:	06300713          	li	a4,99
 92e:	0ee78e63          	beq	a5,a4,a2a <vprintf+0x192>
      {
        putc(fd, va_arg(ap, uint));
      }
      else if (c == '%')
 932:	11478863          	beq	a5,s4,a42 <vprintf+0x1aa>
        putc(fd, c);
      }
      else
      {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 936:	85d2                	mv	a1,s4
 938:	8556                	mv	a0,s5
 93a:	00000097          	auipc	ra,0x0
 93e:	e92080e7          	jalr	-366(ra) # 7cc <putc>
        putc(fd, c);
 942:	85ca                	mv	a1,s2
 944:	8556                	mv	a0,s5
 946:	00000097          	auipc	ra,0x0
 94a:	e86080e7          	jalr	-378(ra) # 7cc <putc>
      }
      state = 0;
 94e:	4981                	li	s3,0
 950:	b765                	j	8f8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 952:	008b0913          	addi	s2,s6,8
 956:	4685                	li	a3,1
 958:	4629                	li	a2,10
 95a:	000b2583          	lw	a1,0(s6)
 95e:	8556                	mv	a0,s5
 960:	00000097          	auipc	ra,0x0
 964:	e8e080e7          	jalr	-370(ra) # 7ee <printint>
 968:	8b4a                	mv	s6,s2
      state = 0;
 96a:	4981                	li	s3,0
 96c:	b771                	j	8f8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 96e:	008b0913          	addi	s2,s6,8
 972:	4681                	li	a3,0
 974:	4629                	li	a2,10
 976:	000b2583          	lw	a1,0(s6)
 97a:	8556                	mv	a0,s5
 97c:	00000097          	auipc	ra,0x0
 980:	e72080e7          	jalr	-398(ra) # 7ee <printint>
 984:	8b4a                	mv	s6,s2
      state = 0;
 986:	4981                	li	s3,0
 988:	bf85                	j	8f8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 98a:	008b0913          	addi	s2,s6,8
 98e:	4681                	li	a3,0
 990:	4641                	li	a2,16
 992:	000b2583          	lw	a1,0(s6)
 996:	8556                	mv	a0,s5
 998:	00000097          	auipc	ra,0x0
 99c:	e56080e7          	jalr	-426(ra) # 7ee <printint>
 9a0:	8b4a                	mv	s6,s2
      state = 0;
 9a2:	4981                	li	s3,0
 9a4:	bf91                	j	8f8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 9a6:	008b0793          	addi	a5,s6,8
 9aa:	f8f43423          	sd	a5,-120(s0)
 9ae:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 9b2:	03000593          	li	a1,48
 9b6:	8556                	mv	a0,s5
 9b8:	00000097          	auipc	ra,0x0
 9bc:	e14080e7          	jalr	-492(ra) # 7cc <putc>
  putc(fd, 'x');
 9c0:	85ea                	mv	a1,s10
 9c2:	8556                	mv	a0,s5
 9c4:	00000097          	auipc	ra,0x0
 9c8:	e08080e7          	jalr	-504(ra) # 7cc <putc>
 9cc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9ce:	03c9d793          	srli	a5,s3,0x3c
 9d2:	97de                	add	a5,a5,s7
 9d4:	0007c583          	lbu	a1,0(a5)
 9d8:	8556                	mv	a0,s5
 9da:	00000097          	auipc	ra,0x0
 9de:	df2080e7          	jalr	-526(ra) # 7cc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9e2:	0992                	slli	s3,s3,0x4
 9e4:	397d                	addiw	s2,s2,-1
 9e6:	fe0914e3          	bnez	s2,9ce <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 9ea:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 9ee:	4981                	li	s3,0
 9f0:	b721                	j	8f8 <vprintf+0x60>
        s = va_arg(ap, char *);
 9f2:	008b0993          	addi	s3,s6,8
 9f6:	000b3903          	ld	s2,0(s6)
        if (s == 0)
 9fa:	02090163          	beqz	s2,a1c <vprintf+0x184>
        while (*s != 0)
 9fe:	00094583          	lbu	a1,0(s2)
 a02:	c9a1                	beqz	a1,a52 <vprintf+0x1ba>
          putc(fd, *s);
 a04:	8556                	mv	a0,s5
 a06:	00000097          	auipc	ra,0x0
 a0a:	dc6080e7          	jalr	-570(ra) # 7cc <putc>
          s++;
 a0e:	0905                	addi	s2,s2,1
        while (*s != 0)
 a10:	00094583          	lbu	a1,0(s2)
 a14:	f9e5                	bnez	a1,a04 <vprintf+0x16c>
        s = va_arg(ap, char *);
 a16:	8b4e                	mv	s6,s3
      state = 0;
 a18:	4981                	li	s3,0
 a1a:	bdf9                	j	8f8 <vprintf+0x60>
          s = "(null)";
 a1c:	00000917          	auipc	s2,0x0
 a20:	41c90913          	addi	s2,s2,1052 # e38 <malloc+0x2d6>
        while (*s != 0)
 a24:	02800593          	li	a1,40
 a28:	bff1                	j	a04 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 a2a:	008b0913          	addi	s2,s6,8
 a2e:	000b4583          	lbu	a1,0(s6)
 a32:	8556                	mv	a0,s5
 a34:	00000097          	auipc	ra,0x0
 a38:	d98080e7          	jalr	-616(ra) # 7cc <putc>
 a3c:	8b4a                	mv	s6,s2
      state = 0;
 a3e:	4981                	li	s3,0
 a40:	bd65                	j	8f8 <vprintf+0x60>
        putc(fd, c);
 a42:	85d2                	mv	a1,s4
 a44:	8556                	mv	a0,s5
 a46:	00000097          	auipc	ra,0x0
 a4a:	d86080e7          	jalr	-634(ra) # 7cc <putc>
      state = 0;
 a4e:	4981                	li	s3,0
 a50:	b565                	j	8f8 <vprintf+0x60>
        s = va_arg(ap, char *);
 a52:	8b4e                	mv	s6,s3
      state = 0;
 a54:	4981                	li	s3,0
 a56:	b54d                	j	8f8 <vprintf+0x60>
    }
  }
}
 a58:	70e6                	ld	ra,120(sp)
 a5a:	7446                	ld	s0,112(sp)
 a5c:	74a6                	ld	s1,104(sp)
 a5e:	7906                	ld	s2,96(sp)
 a60:	69e6                	ld	s3,88(sp)
 a62:	6a46                	ld	s4,80(sp)
 a64:	6aa6                	ld	s5,72(sp)
 a66:	6b06                	ld	s6,64(sp)
 a68:	7be2                	ld	s7,56(sp)
 a6a:	7c42                	ld	s8,48(sp)
 a6c:	7ca2                	ld	s9,40(sp)
 a6e:	7d02                	ld	s10,32(sp)
 a70:	6de2                	ld	s11,24(sp)
 a72:	6109                	addi	sp,sp,128
 a74:	8082                	ret

0000000000000a76 <fprintf>:

void fprintf(int fd, const char *fmt, ...)
{
 a76:	715d                	addi	sp,sp,-80
 a78:	ec06                	sd	ra,24(sp)
 a7a:	e822                	sd	s0,16(sp)
 a7c:	1000                	addi	s0,sp,32
 a7e:	e010                	sd	a2,0(s0)
 a80:	e414                	sd	a3,8(s0)
 a82:	e818                	sd	a4,16(s0)
 a84:	ec1c                	sd	a5,24(s0)
 a86:	03043023          	sd	a6,32(s0)
 a8a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a8e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a92:	8622                	mv	a2,s0
 a94:	00000097          	auipc	ra,0x0
 a98:	e04080e7          	jalr	-508(ra) # 898 <vprintf>
}
 a9c:	60e2                	ld	ra,24(sp)
 a9e:	6442                	ld	s0,16(sp)
 aa0:	6161                	addi	sp,sp,80
 aa2:	8082                	ret

0000000000000aa4 <printf>:

void printf(const char *fmt, ...)
{
 aa4:	711d                	addi	sp,sp,-96
 aa6:	ec06                	sd	ra,24(sp)
 aa8:	e822                	sd	s0,16(sp)
 aaa:	1000                	addi	s0,sp,32
 aac:	e40c                	sd	a1,8(s0)
 aae:	e810                	sd	a2,16(s0)
 ab0:	ec14                	sd	a3,24(s0)
 ab2:	f018                	sd	a4,32(s0)
 ab4:	f41c                	sd	a5,40(s0)
 ab6:	03043823          	sd	a6,48(s0)
 aba:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 abe:	00840613          	addi	a2,s0,8
 ac2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ac6:	85aa                	mv	a1,a0
 ac8:	4505                	li	a0,1
 aca:	00000097          	auipc	ra,0x0
 ace:	dce080e7          	jalr	-562(ra) # 898 <vprintf>
}
 ad2:	60e2                	ld	ra,24(sp)
 ad4:	6442                	ld	s0,16(sp)
 ad6:	6125                	addi	sp,sp,96
 ad8:	8082                	ret

0000000000000ada <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 ada:	1141                	addi	sp,sp,-16
 adc:	e422                	sd	s0,8(sp)
 ade:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 ae0:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ae4:	00000797          	auipc	a5,0x0
 ae8:	5247b783          	ld	a5,1316(a5) # 1008 <freep>
 aec:	a805                	j	b1c <free+0x42>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr)
  {
    bp->s.size += p->s.ptr->s.size;
 aee:	4618                	lw	a4,8(a2)
 af0:	9db9                	addw	a1,a1,a4
 af2:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 af6:	6398                	ld	a4,0(a5)
 af8:	6318                	ld	a4,0(a4)
 afa:	fee53823          	sd	a4,-16(a0)
 afe:	a091                	j	b42 <free+0x68>
  }
  else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp)
  {
    p->s.size += bp->s.size;
 b00:	ff852703          	lw	a4,-8(a0)
 b04:	9e39                	addw	a2,a2,a4
 b06:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 b08:	ff053703          	ld	a4,-16(a0)
 b0c:	e398                	sd	a4,0(a5)
 b0e:	a099                	j	b54 <free+0x7a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b10:	6398                	ld	a4,0(a5)
 b12:	00e7e463          	bltu	a5,a4,b1a <free+0x40>
 b16:	00e6ea63          	bltu	a3,a4,b2a <free+0x50>
{
 b1a:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b1c:	fed7fae3          	bgeu	a5,a3,b10 <free+0x36>
 b20:	6398                	ld	a4,0(a5)
 b22:	00e6e463          	bltu	a3,a4,b2a <free+0x50>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b26:	fee7eae3          	bltu	a5,a4,b1a <free+0x40>
  if (bp + bp->s.size == p->s.ptr)
 b2a:	ff852583          	lw	a1,-8(a0)
 b2e:	6390                	ld	a2,0(a5)
 b30:	02059713          	slli	a4,a1,0x20
 b34:	9301                	srli	a4,a4,0x20
 b36:	0712                	slli	a4,a4,0x4
 b38:	9736                	add	a4,a4,a3
 b3a:	fae60ae3          	beq	a2,a4,aee <free+0x14>
    bp->s.ptr = p->s.ptr;
 b3e:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp)
 b42:	4790                	lw	a2,8(a5)
 b44:	02061713          	slli	a4,a2,0x20
 b48:	9301                	srli	a4,a4,0x20
 b4a:	0712                	slli	a4,a4,0x4
 b4c:	973e                	add	a4,a4,a5
 b4e:	fae689e3          	beq	a3,a4,b00 <free+0x26>
  }
  else
    p->s.ptr = bp;
 b52:	e394                	sd	a3,0(a5)
  freep = p;
 b54:	00000717          	auipc	a4,0x0
 b58:	4af73a23          	sd	a5,1204(a4) # 1008 <freep>
}
 b5c:	6422                	ld	s0,8(sp)
 b5e:	0141                	addi	sp,sp,16
 b60:	8082                	ret

0000000000000b62 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 b62:	7139                	addi	sp,sp,-64
 b64:	fc06                	sd	ra,56(sp)
 b66:	f822                	sd	s0,48(sp)
 b68:	f426                	sd	s1,40(sp)
 b6a:	f04a                	sd	s2,32(sp)
 b6c:	ec4e                	sd	s3,24(sp)
 b6e:	e852                	sd	s4,16(sp)
 b70:	e456                	sd	s5,8(sp)
 b72:	e05a                	sd	s6,0(sp)
 b74:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 b76:	02051493          	slli	s1,a0,0x20
 b7a:	9081                	srli	s1,s1,0x20
 b7c:	04bd                	addi	s1,s1,15
 b7e:	8091                	srli	s1,s1,0x4
 b80:	0014899b          	addiw	s3,s1,1
 b84:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0)
 b86:	00000517          	auipc	a0,0x0
 b8a:	48253503          	ld	a0,1154(a0) # 1008 <freep>
 b8e:	c515                	beqz	a0,bba <malloc+0x58>
  {
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 b90:	611c                	ld	a5,0(a0)
  {
    if (p->s.size >= nunits)
 b92:	4798                	lw	a4,8(a5)
 b94:	02977f63          	bgeu	a4,s1,bd2 <malloc+0x70>
 b98:	8a4e                	mv	s4,s3
 b9a:	0009871b          	sext.w	a4,s3
 b9e:	6685                	lui	a3,0x1
 ba0:	00d77363          	bgeu	a4,a3,ba6 <malloc+0x44>
 ba4:	6a05                	lui	s4,0x1
 ba6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 baa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 bae:	00000917          	auipc	s2,0x0
 bb2:	45a90913          	addi	s2,s2,1114 # 1008 <freep>
  if (p == (char *)-1)
 bb6:	5afd                	li	s5,-1
 bb8:	a88d                	j	c2a <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 bba:	00000797          	auipc	a5,0x0
 bbe:	45678793          	addi	a5,a5,1110 # 1010 <base>
 bc2:	00000717          	auipc	a4,0x0
 bc6:	44f73323          	sd	a5,1094(a4) # 1008 <freep>
 bca:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 bcc:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits)
 bd0:	b7e1                	j	b98 <malloc+0x36>
      if (p->s.size == nunits)
 bd2:	02e48b63          	beq	s1,a4,c08 <malloc+0xa6>
        p->s.size -= nunits;
 bd6:	4137073b          	subw	a4,a4,s3
 bda:	c798                	sw	a4,8(a5)
        p += p->s.size;
 bdc:	1702                	slli	a4,a4,0x20
 bde:	9301                	srli	a4,a4,0x20
 be0:	0712                	slli	a4,a4,0x4
 be2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 be4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 be8:	00000717          	auipc	a4,0x0
 bec:	42a73023          	sd	a0,1056(a4) # 1008 <freep>
      return (void *)(p + 1);
 bf0:	01078513          	addi	a0,a5,16
      if ((p = morecore(nunits)) == 0)
        return 0;
  }
}
 bf4:	70e2                	ld	ra,56(sp)
 bf6:	7442                	ld	s0,48(sp)
 bf8:	74a2                	ld	s1,40(sp)
 bfa:	7902                	ld	s2,32(sp)
 bfc:	69e2                	ld	s3,24(sp)
 bfe:	6a42                	ld	s4,16(sp)
 c00:	6aa2                	ld	s5,8(sp)
 c02:	6b02                	ld	s6,0(sp)
 c04:	6121                	addi	sp,sp,64
 c06:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 c08:	6398                	ld	a4,0(a5)
 c0a:	e118                	sd	a4,0(a0)
 c0c:	bff1                	j	be8 <malloc+0x86>
  hp->s.size = nu;
 c0e:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 c12:	0541                	addi	a0,a0,16
 c14:	00000097          	auipc	ra,0x0
 c18:	ec6080e7          	jalr	-314(ra) # ada <free>
  return freep;
 c1c:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 c20:	d971                	beqz	a0,bf4 <malloc+0x92>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 c22:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits)
 c24:	4798                	lw	a4,8(a5)
 c26:	fa9776e3          	bgeu	a4,s1,bd2 <malloc+0x70>
    if (p == freep)
 c2a:	00093703          	ld	a4,0(s2)
 c2e:	853e                	mv	a0,a5
 c30:	fef719e3          	bne	a4,a5,c22 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 c34:	8552                	mv	a0,s4
 c36:	00000097          	auipc	ra,0x0
 c3a:	b4e080e7          	jalr	-1202(ra) # 784 <sbrk>
  if (p == (char *)-1)
 c3e:	fd5518e3          	bne	a0,s5,c0e <malloc+0xac>
        return 0;
 c42:	4501                	li	a0,0
 c44:	bf45                	j	bf4 <malloc+0x92>
