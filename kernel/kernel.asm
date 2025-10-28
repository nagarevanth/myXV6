
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	cb010113          	addi	sp,sp,-848 # 80009cb0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	078000ef          	jal	ra,8000008e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// they will arrive in machine mode at
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid"
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64 *)CLINT_MTIMECMP(id) = *(uint64 *)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	95b2                	add	a1,a1,a2
    80000046:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00269713          	slli	a4,a3,0x2
    8000004c:	9736                	add	a4,a4,a3
    8000004e:	00371693          	slli	a3,a4,0x3
    80000052:	0000a717          	auipc	a4,0xa
    80000056:	b1e70713          	addi	a4,a4,-1250 # 80009b70 <timer_scratch>
    8000005a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005e:	f310                	sd	a2,32(a4)
}

static inline void
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0"
    80000060:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0"
    80000064:	00006797          	auipc	a5,0x6
    80000068:	66c78793          	addi	a5,a5,1644 # 800066d0 <timervec>
    8000006c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus"
    80000070:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000074:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0"
    80000078:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie"
    8000007c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000080:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0"
    80000084:	30479073          	csrw	mie,a5
}
    80000088:	6422                	ld	s0,8(sp)
    8000008a:	0141                	addi	sp,sp,16
    8000008c:	8082                	ret

000000008000008e <start>:
{
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus"
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdb83e7>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0"
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0"
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	f8678793          	addi	a5,a5,-122 # 80001034 <main>
    800000b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0"
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0"
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1
    800000c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0"
    800000c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie"
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0"
    800000d4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0"
    800000d8:	57fd                	li	a5,-1
    800000da:	83a9                	srli	a5,a5,0xa
    800000dc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0"
    800000e0:	47bd                	li	a5,15
    800000e2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e6:	00000097          	auipc	ra,0x0
    800000ea:	f36080e7          	jalr	-202(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid"
    800000ee:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f2:	2781                	sext.w	a5,a5
}

static inline void
w_tp(uint64 x)
{
  asm volatile("mv tp, %0"
    800000f4:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f6:	30200073          	mret
}
    800000fa:	60a2                	ld	ra,8(sp)
    800000fc:	6402                	ld	s0,0(sp)
    800000fe:	0141                	addi	sp,sp,16
    80000100:	8082                	ret

0000000080000102 <consolewrite>:

//
// user write()s to the console go here.
//
int consolewrite(int user_src, uint64 src, int n)
{
    80000102:	715d                	addi	sp,sp,-80
    80000104:	e486                	sd	ra,72(sp)
    80000106:	e0a2                	sd	s0,64(sp)
    80000108:	fc26                	sd	s1,56(sp)
    8000010a:	f84a                	sd	s2,48(sp)
    8000010c:	f44e                	sd	s3,40(sp)
    8000010e:	f052                	sd	s4,32(sp)
    80000110:	ec56                	sd	s5,24(sp)
    80000112:	0880                	addi	s0,sp,80
  int i;

  for (i = 0; i < n; i++)
    80000114:	04c05663          	blez	a2,80000160 <consolewrite+0x5e>
    80000118:	8a2a                	mv	s4,a0
    8000011a:	84ae                	mv	s1,a1
    8000011c:	89b2                	mv	s3,a2
    8000011e:	4901                	li	s2,0
  {
    char c;
    if (either_copyin(&c, user_src, src + i, 1) == -1)
    80000120:	5afd                	li	s5,-1
    80000122:	4685                	li	a3,1
    80000124:	8626                	mv	a2,s1
    80000126:	85d2                	mv	a1,s4
    80000128:	fbf40513          	addi	a0,s0,-65
    8000012c:	00003097          	auipc	ra,0x3
    80000130:	a1c080e7          	jalr	-1508(ra) # 80002b48 <either_copyin>
    80000134:	01550c63          	beq	a0,s5,8000014c <consolewrite+0x4a>
      break;
    uartputc(c);
    80000138:	fbf44503          	lbu	a0,-65(s0)
    8000013c:	00000097          	auipc	ra,0x0
    80000140:	780080e7          	jalr	1920(ra) # 800008bc <uartputc>
  for (i = 0; i < n; i++)
    80000144:	2905                	addiw	s2,s2,1
    80000146:	0485                	addi	s1,s1,1
    80000148:	fd299de3          	bne	s3,s2,80000122 <consolewrite+0x20>
  }

  return i;
}
    8000014c:	854a                	mv	a0,s2
    8000014e:	60a6                	ld	ra,72(sp)
    80000150:	6406                	ld	s0,64(sp)
    80000152:	74e2                	ld	s1,56(sp)
    80000154:	7942                	ld	s2,48(sp)
    80000156:	79a2                	ld	s3,40(sp)
    80000158:	7a02                	ld	s4,32(sp)
    8000015a:	6ae2                	ld	s5,24(sp)
    8000015c:	6161                	addi	sp,sp,80
    8000015e:	8082                	ret
  for (i = 0; i < n; i++)
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4a>

0000000080000164 <consoleread>:
// copy (up to) a whole input line to dst.
// user_dist indicates whether dst is a user
// or kernel address.
//
int consoleread(int user_dst, uint64 dst, int n)
{
    80000164:	7159                	addi	sp,sp,-112
    80000166:	f486                	sd	ra,104(sp)
    80000168:	f0a2                	sd	s0,96(sp)
    8000016a:	eca6                	sd	s1,88(sp)
    8000016c:	e8ca                	sd	s2,80(sp)
    8000016e:	e4ce                	sd	s3,72(sp)
    80000170:	e0d2                	sd	s4,64(sp)
    80000172:	fc56                	sd	s5,56(sp)
    80000174:	f85a                	sd	s6,48(sp)
    80000176:	f45e                	sd	s7,40(sp)
    80000178:	f062                	sd	s8,32(sp)
    8000017a:	ec66                	sd	s9,24(sp)
    8000017c:	e86a                	sd	s10,16(sp)
    8000017e:	1880                	addi	s0,sp,112
    80000180:	8aaa                	mv	s5,a0
    80000182:	8a2e                	mv	s4,a1
    80000184:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000186:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018a:	00012517          	auipc	a0,0x12
    8000018e:	b2650513          	addi	a0,a0,-1242 # 80011cb0 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	c00080e7          	jalr	-1024(ra) # 80000d92 <acquire>
  while (n > 0)
  {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w)
    8000019a:	00012497          	auipc	s1,0x12
    8000019e:	b1648493          	addi	s1,s1,-1258 # 80011cb0 <cons>
      if (killed(myproc()))
      {
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a2:	00012917          	auipc	s2,0x12
    800001a6:	ba690913          	addi	s2,s2,-1114 # 80011d48 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if (c == C('D'))
    800001aa:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001ac:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if (c == '\n')
    800001ae:	4ca9                	li	s9,10
  while (n > 0)
    800001b0:	07305b63          	blez	s3,80000226 <consoleread+0xc2>
    while (cons.r == cons.w)
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	02f71763          	bne	a4,a5,800001ea <consoleread+0x86>
      if (killed(myproc()))
    800001c0:	00002097          	auipc	ra,0x2
    800001c4:	a2e080e7          	jalr	-1490(ra) # 80001bee <myproc>
    800001c8:	00002097          	auipc	ra,0x2
    800001cc:	7ca080e7          	jalr	1994(ra) # 80002992 <killed>
    800001d0:	e535                	bnez	a0,8000023c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800001d2:	85a6                	mv	a1,s1
    800001d4:	854a                	mv	a0,s2
    800001d6:	00002097          	auipc	ra,0x2
    800001da:	390080e7          	jalr	912(ra) # 80002566 <sleep>
    while (cons.r == cons.w)
    800001de:	0984a783          	lw	a5,152(s1)
    800001e2:	09c4a703          	lw	a4,156(s1)
    800001e6:	fcf70de3          	beq	a4,a5,800001c0 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ea:	0017871b          	addiw	a4,a5,1
    800001ee:	08e4ac23          	sw	a4,152(s1)
    800001f2:	07f7f713          	andi	a4,a5,127
    800001f6:	9726                	add	a4,a4,s1
    800001f8:	01874703          	lbu	a4,24(a4)
    800001fc:	00070d1b          	sext.w	s10,a4
    if (c == C('D'))
    80000200:	077d0563          	beq	s10,s7,8000026a <consoleread+0x106>
    cbuf = c;
    80000204:	f8e40fa3          	sb	a4,-97(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000208:	4685                	li	a3,1
    8000020a:	f9f40613          	addi	a2,s0,-97
    8000020e:	85d2                	mv	a1,s4
    80000210:	8556                	mv	a0,s5
    80000212:	00003097          	auipc	ra,0x3
    80000216:	8e0080e7          	jalr	-1824(ra) # 80002af2 <either_copyout>
    8000021a:	01850663          	beq	a0,s8,80000226 <consoleread+0xc2>
    dst++;
    8000021e:	0a05                	addi	s4,s4,1
    --n;
    80000220:	39fd                	addiw	s3,s3,-1
    if (c == '\n')
    80000222:	f99d17e3          	bne	s10,s9,800001b0 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000226:	00012517          	auipc	a0,0x12
    8000022a:	a8a50513          	addi	a0,a0,-1398 # 80011cb0 <cons>
    8000022e:	00001097          	auipc	ra,0x1
    80000232:	c18080e7          	jalr	-1000(ra) # 80000e46 <release>

  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	a811                	j	8000024e <consoleread+0xea>
        release(&cons.lock);
    8000023c:	00012517          	auipc	a0,0x12
    80000240:	a7450513          	addi	a0,a0,-1420 # 80011cb0 <cons>
    80000244:	00001097          	auipc	ra,0x1
    80000248:	c02080e7          	jalr	-1022(ra) # 80000e46 <release>
        return -1;
    8000024c:	557d                	li	a0,-1
}
    8000024e:	70a6                	ld	ra,104(sp)
    80000250:	7406                	ld	s0,96(sp)
    80000252:	64e6                	ld	s1,88(sp)
    80000254:	6946                	ld	s2,80(sp)
    80000256:	69a6                	ld	s3,72(sp)
    80000258:	6a06                	ld	s4,64(sp)
    8000025a:	7ae2                	ld	s5,56(sp)
    8000025c:	7b42                	ld	s6,48(sp)
    8000025e:	7ba2                	ld	s7,40(sp)
    80000260:	7c02                	ld	s8,32(sp)
    80000262:	6ce2                	ld	s9,24(sp)
    80000264:	6d42                	ld	s10,16(sp)
    80000266:	6165                	addi	sp,sp,112
    80000268:	8082                	ret
      if (n < target)
    8000026a:	0009871b          	sext.w	a4,s3
    8000026e:	fb677ce3          	bgeu	a4,s6,80000226 <consoleread+0xc2>
        cons.r--;
    80000272:	00012717          	auipc	a4,0x12
    80000276:	acf72b23          	sw	a5,-1322(a4) # 80011d48 <cons+0x98>
    8000027a:	b775                	j	80000226 <consoleread+0xc2>

000000008000027c <consputc>:
{
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	addi	s0,sp,16
  if (c == BACKSPACE)
    80000284:	10000793          	li	a5,256
    80000288:	00f50a63          	beq	a0,a5,8000029c <consputc+0x20>
    uartputc_sync(c);
    8000028c:	00000097          	auipc	ra,0x0
    80000290:	55e080e7          	jalr	1374(ra) # 800007ea <uartputc_sync>
}
    80000294:	60a2                	ld	ra,8(sp)
    80000296:	6402                	ld	s0,0(sp)
    80000298:	0141                	addi	sp,sp,16
    8000029a:	8082                	ret
    uartputc_sync('\b');
    8000029c:	4521                	li	a0,8
    8000029e:	00000097          	auipc	ra,0x0
    800002a2:	54c080e7          	jalr	1356(ra) # 800007ea <uartputc_sync>
    uartputc_sync(' ');
    800002a6:	02000513          	li	a0,32
    800002aa:	00000097          	auipc	ra,0x0
    800002ae:	540080e7          	jalr	1344(ra) # 800007ea <uartputc_sync>
    uartputc_sync('\b');
    800002b2:	4521                	li	a0,8
    800002b4:	00000097          	auipc	ra,0x0
    800002b8:	536080e7          	jalr	1334(ra) # 800007ea <uartputc_sync>
    800002bc:	bfe1                	j	80000294 <consputc+0x18>

00000000800002be <consoleintr>:
// uartintr() calls this for input character.
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void consoleintr(int c)
{
    800002be:	1101                	addi	sp,sp,-32
    800002c0:	ec06                	sd	ra,24(sp)
    800002c2:	e822                	sd	s0,16(sp)
    800002c4:	e426                	sd	s1,8(sp)
    800002c6:	e04a                	sd	s2,0(sp)
    800002c8:	1000                	addi	s0,sp,32
    800002ca:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002cc:	00012517          	auipc	a0,0x12
    800002d0:	9e450513          	addi	a0,a0,-1564 # 80011cb0 <cons>
    800002d4:	00001097          	auipc	ra,0x1
    800002d8:	abe080e7          	jalr	-1346(ra) # 80000d92 <acquire>

  switch (c)
    800002dc:	47d5                	li	a5,21
    800002de:	0af48663          	beq	s1,a5,8000038a <consoleintr+0xcc>
    800002e2:	0297ca63          	blt	a5,s1,80000316 <consoleintr+0x58>
    800002e6:	47a1                	li	a5,8
    800002e8:	0ef48763          	beq	s1,a5,800003d6 <consoleintr+0x118>
    800002ec:	47c1                	li	a5,16
    800002ee:	10f49a63          	bne	s1,a5,80000402 <consoleintr+0x144>
  {
  case C('P'): // Print process list.
    procdump();
    800002f2:	00003097          	auipc	ra,0x3
    800002f6:	8ac080e7          	jalr	-1876(ra) # 80002b9e <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002fa:	00012517          	auipc	a0,0x12
    800002fe:	9b650513          	addi	a0,a0,-1610 # 80011cb0 <cons>
    80000302:	00001097          	auipc	ra,0x1
    80000306:	b44080e7          	jalr	-1212(ra) # 80000e46 <release>
}
    8000030a:	60e2                	ld	ra,24(sp)
    8000030c:	6442                	ld	s0,16(sp)
    8000030e:	64a2                	ld	s1,8(sp)
    80000310:	6902                	ld	s2,0(sp)
    80000312:	6105                	addi	sp,sp,32
    80000314:	8082                	ret
  switch (c)
    80000316:	07f00793          	li	a5,127
    8000031a:	0af48e63          	beq	s1,a5,800003d6 <consoleintr+0x118>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE)
    8000031e:	00012717          	auipc	a4,0x12
    80000322:	99270713          	addi	a4,a4,-1646 # 80011cb0 <cons>
    80000326:	0a072783          	lw	a5,160(a4)
    8000032a:	09872703          	lw	a4,152(a4)
    8000032e:	9f99                	subw	a5,a5,a4
    80000330:	07f00713          	li	a4,127
    80000334:	fcf763e3          	bltu	a4,a5,800002fa <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000338:	47b5                	li	a5,13
    8000033a:	0cf48763          	beq	s1,a5,80000408 <consoleintr+0x14a>
      consputc(c);
    8000033e:	8526                	mv	a0,s1
    80000340:	00000097          	auipc	ra,0x0
    80000344:	f3c080e7          	jalr	-196(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000348:	00012797          	auipc	a5,0x12
    8000034c:	96878793          	addi	a5,a5,-1688 # 80011cb0 <cons>
    80000350:	0a07a683          	lw	a3,160(a5)
    80000354:	0016871b          	addiw	a4,a3,1
    80000358:	0007061b          	sext.w	a2,a4
    8000035c:	0ae7a023          	sw	a4,160(a5)
    80000360:	07f6f693          	andi	a3,a3,127
    80000364:	97b6                	add	a5,a5,a3
    80000366:	00978c23          	sb	s1,24(a5)
      if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE)
    8000036a:	47a9                	li	a5,10
    8000036c:	0cf48563          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000370:	4791                	li	a5,4
    80000372:	0cf48263          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000376:	00012797          	auipc	a5,0x12
    8000037a:	9d27a783          	lw	a5,-1582(a5) # 80011d48 <cons+0x98>
    8000037e:	9f1d                	subw	a4,a4,a5
    80000380:	08000793          	li	a5,128
    80000384:	f6f71be3          	bne	a4,a5,800002fa <consoleintr+0x3c>
    80000388:	a07d                	j	80000436 <consoleintr+0x178>
    while (cons.e != cons.w &&
    8000038a:	00012717          	auipc	a4,0x12
    8000038e:	92670713          	addi	a4,a4,-1754 # 80011cb0 <cons>
    80000392:	0a072783          	lw	a5,160(a4)
    80000396:	09c72703          	lw	a4,156(a4)
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    8000039a:	00012497          	auipc	s1,0x12
    8000039e:	91648493          	addi	s1,s1,-1770 # 80011cb0 <cons>
    while (cons.e != cons.w &&
    800003a2:	4929                	li	s2,10
    800003a4:	f4f70be3          	beq	a4,a5,800002fa <consoleintr+0x3c>
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    800003a8:	37fd                	addiw	a5,a5,-1
    800003aa:	07f7f713          	andi	a4,a5,127
    800003ae:	9726                	add	a4,a4,s1
    while (cons.e != cons.w &&
    800003b0:	01874703          	lbu	a4,24(a4)
    800003b4:	f52703e3          	beq	a4,s2,800002fa <consoleintr+0x3c>
      cons.e--;
    800003b8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003bc:	10000513          	li	a0,256
    800003c0:	00000097          	auipc	ra,0x0
    800003c4:	ebc080e7          	jalr	-324(ra) # 8000027c <consputc>
    while (cons.e != cons.w &&
    800003c8:	0a04a783          	lw	a5,160(s1)
    800003cc:	09c4a703          	lw	a4,156(s1)
    800003d0:	fcf71ce3          	bne	a4,a5,800003a8 <consoleintr+0xea>
    800003d4:	b71d                	j	800002fa <consoleintr+0x3c>
    if (cons.e != cons.w)
    800003d6:	00012717          	auipc	a4,0x12
    800003da:	8da70713          	addi	a4,a4,-1830 # 80011cb0 <cons>
    800003de:	0a072783          	lw	a5,160(a4)
    800003e2:	09c72703          	lw	a4,156(a4)
    800003e6:	f0f70ae3          	beq	a4,a5,800002fa <consoleintr+0x3c>
      cons.e--;
    800003ea:	37fd                	addiw	a5,a5,-1
    800003ec:	00012717          	auipc	a4,0x12
    800003f0:	96f72223          	sw	a5,-1692(a4) # 80011d50 <cons+0xa0>
      consputc(BACKSPACE);
    800003f4:	10000513          	li	a0,256
    800003f8:	00000097          	auipc	ra,0x0
    800003fc:	e84080e7          	jalr	-380(ra) # 8000027c <consputc>
    80000400:	bded                	j	800002fa <consoleintr+0x3c>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE)
    80000402:	ee048ce3          	beqz	s1,800002fa <consoleintr+0x3c>
    80000406:	bf21                	j	8000031e <consoleintr+0x60>
      consputc(c);
    80000408:	4529                	li	a0,10
    8000040a:	00000097          	auipc	ra,0x0
    8000040e:	e72080e7          	jalr	-398(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000412:	00012797          	auipc	a5,0x12
    80000416:	89e78793          	addi	a5,a5,-1890 # 80011cb0 <cons>
    8000041a:	0a07a703          	lw	a4,160(a5)
    8000041e:	0017069b          	addiw	a3,a4,1
    80000422:	0006861b          	sext.w	a2,a3
    80000426:	0ad7a023          	sw	a3,160(a5)
    8000042a:	07f77713          	andi	a4,a4,127
    8000042e:	97ba                	add	a5,a5,a4
    80000430:	4729                	li	a4,10
    80000432:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000436:	00012797          	auipc	a5,0x12
    8000043a:	90c7ab23          	sw	a2,-1770(a5) # 80011d4c <cons+0x9c>
        wakeup(&cons.r);
    8000043e:	00012517          	auipc	a0,0x12
    80000442:	90a50513          	addi	a0,a0,-1782 # 80011d48 <cons+0x98>
    80000446:	00002097          	auipc	ra,0x2
    8000044a:	2dc080e7          	jalr	732(ra) # 80002722 <wakeup>
    8000044e:	b575                	j	800002fa <consoleintr+0x3c>

0000000080000450 <consoleinit>:

void consoleinit(void)
{
    80000450:	1141                	addi	sp,sp,-16
    80000452:	e406                	sd	ra,8(sp)
    80000454:	e022                	sd	s0,0(sp)
    80000456:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000458:	00009597          	auipc	a1,0x9
    8000045c:	bb858593          	addi	a1,a1,-1096 # 80009010 <etext+0x10>
    80000460:	00012517          	auipc	a0,0x12
    80000464:	85050513          	addi	a0,a0,-1968 # 80011cb0 <cons>
    80000468:	00001097          	auipc	ra,0x1
    8000046c:	89a080e7          	jalr	-1894(ra) # 80000d02 <initlock>

  uartinit();
    80000470:	00000097          	auipc	ra,0x0
    80000474:	32a080e7          	jalr	810(ra) # 8000079a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000478:	00244797          	auipc	a5,0x244
    8000047c:	a8878793          	addi	a5,a5,-1400 # 80243f00 <devsw>
    80000480:	00000717          	auipc	a4,0x0
    80000484:	ce470713          	addi	a4,a4,-796 # 80000164 <consoleread>
    80000488:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000048a:	00000717          	auipc	a4,0x0
    8000048e:	c7870713          	addi	a4,a4,-904 # 80000102 <consolewrite>
    80000492:	ef98                	sd	a4,24(a5)
}
    80000494:	60a2                	ld	ra,8(sp)
    80000496:	6402                	ld	s0,0(sp)
    80000498:	0141                	addi	sp,sp,16
    8000049a:	8082                	ret

000000008000049c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000049c:	7179                	addi	sp,sp,-48
    8000049e:	f406                	sd	ra,40(sp)
    800004a0:	f022                	sd	s0,32(sp)
    800004a2:	ec26                	sd	s1,24(sp)
    800004a4:	e84a                	sd	s2,16(sp)
    800004a6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if (sign && (sign = xx < 0))
    800004a8:	c219                	beqz	a2,800004ae <printint+0x12>
    800004aa:	08054663          	bltz	a0,80000536 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004ae:	2501                	sext.w	a0,a0
    800004b0:	4881                	li	a7,0
    800004b2:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004b6:	4701                	li	a4,0
  do
  {
    buf[i++] = digits[x % base];
    800004b8:	2581                	sext.w	a1,a1
    800004ba:	00009617          	auipc	a2,0x9
    800004be:	b8660613          	addi	a2,a2,-1146 # 80009040 <digits>
    800004c2:	883a                	mv	a6,a4
    800004c4:	2705                	addiw	a4,a4,1
    800004c6:	02b577bb          	remuw	a5,a0,a1
    800004ca:	1782                	slli	a5,a5,0x20
    800004cc:	9381                	srli	a5,a5,0x20
    800004ce:	97b2                	add	a5,a5,a2
    800004d0:	0007c783          	lbu	a5,0(a5)
    800004d4:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    800004d8:	0005079b          	sext.w	a5,a0
    800004dc:	02b5553b          	divuw	a0,a0,a1
    800004e0:	0685                	addi	a3,a3,1
    800004e2:	feb7f0e3          	bgeu	a5,a1,800004c2 <printint+0x26>

  if (sign)
    800004e6:	00088b63          	beqz	a7,800004fc <printint+0x60>
    buf[i++] = '-';
    800004ea:	fe040793          	addi	a5,s0,-32
    800004ee:	973e                	add	a4,a4,a5
    800004f0:	02d00793          	li	a5,45
    800004f4:	fef70823          	sb	a5,-16(a4)
    800004f8:	0028071b          	addiw	a4,a6,2

  while (--i >= 0)
    800004fc:	02e05763          	blez	a4,8000052a <printint+0x8e>
    80000500:	fd040793          	addi	a5,s0,-48
    80000504:	00e784b3          	add	s1,a5,a4
    80000508:	fff78913          	addi	s2,a5,-1
    8000050c:	993a                	add	s2,s2,a4
    8000050e:	377d                	addiw	a4,a4,-1
    80000510:	1702                	slli	a4,a4,0x20
    80000512:	9301                	srli	a4,a4,0x20
    80000514:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000518:	fff4c503          	lbu	a0,-1(s1)
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	d60080e7          	jalr	-672(ra) # 8000027c <consputc>
  while (--i >= 0)
    80000524:	14fd                	addi	s1,s1,-1
    80000526:	ff2499e3          	bne	s1,s2,80000518 <printint+0x7c>
}
    8000052a:	70a2                	ld	ra,40(sp)
    8000052c:	7402                	ld	s0,32(sp)
    8000052e:	64e2                	ld	s1,24(sp)
    80000530:	6942                	ld	s2,16(sp)
    80000532:	6145                	addi	sp,sp,48
    80000534:	8082                	ret
    x = -xx;
    80000536:	40a0053b          	negw	a0,a0
  if (sign && (sign = xx < 0))
    8000053a:	4885                	li	a7,1
    x = -xx;
    8000053c:	bf9d                	j	800004b2 <printint+0x16>

000000008000053e <panic>:
  if (locking)
    release(&pr.lock);
}

void panic(char *s)
{
    8000053e:	1101                	addi	sp,sp,-32
    80000540:	ec06                	sd	ra,24(sp)
    80000542:	e822                	sd	s0,16(sp)
    80000544:	e426                	sd	s1,8(sp)
    80000546:	1000                	addi	s0,sp,32
    80000548:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000054a:	00012797          	auipc	a5,0x12
    8000054e:	8207a323          	sw	zero,-2010(a5) # 80011d70 <pr+0x18>
  printf("panic: ");
    80000552:	00009517          	auipc	a0,0x9
    80000556:	ac650513          	addi	a0,a0,-1338 # 80009018 <etext+0x18>
    8000055a:	00000097          	auipc	ra,0x0
    8000055e:	02e080e7          	jalr	46(ra) # 80000588 <printf>
  printf(s);
    80000562:	8526                	mv	a0,s1
    80000564:	00000097          	auipc	ra,0x0
    80000568:	024080e7          	jalr	36(ra) # 80000588 <printf>
  printf("\n");
    8000056c:	00009517          	auipc	a0,0x9
    80000570:	b9c50513          	addi	a0,a0,-1124 # 80009108 <digits+0xc8>
    80000574:	00000097          	auipc	ra,0x0
    80000578:	014080e7          	jalr	20(ra) # 80000588 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000057c:	4785                	li	a5,1
    8000057e:	00009717          	auipc	a4,0x9
    80000582:	5af72923          	sw	a5,1458(a4) # 80009b30 <panicked>
  for (;;)
    80000586:	a001                	j	80000586 <panic+0x48>

0000000080000588 <printf>:
{
    80000588:	7131                	addi	sp,sp,-192
    8000058a:	fc86                	sd	ra,120(sp)
    8000058c:	f8a2                	sd	s0,112(sp)
    8000058e:	f4a6                	sd	s1,104(sp)
    80000590:	f0ca                	sd	s2,96(sp)
    80000592:	ecce                	sd	s3,88(sp)
    80000594:	e8d2                	sd	s4,80(sp)
    80000596:	e4d6                	sd	s5,72(sp)
    80000598:	e0da                	sd	s6,64(sp)
    8000059a:	fc5e                	sd	s7,56(sp)
    8000059c:	f862                	sd	s8,48(sp)
    8000059e:	f466                	sd	s9,40(sp)
    800005a0:	f06a                	sd	s10,32(sp)
    800005a2:	ec6e                	sd	s11,24(sp)
    800005a4:	0100                	addi	s0,sp,128
    800005a6:	8a2a                	mv	s4,a0
    800005a8:	e40c                	sd	a1,8(s0)
    800005aa:	e810                	sd	a2,16(s0)
    800005ac:	ec14                	sd	a3,24(s0)
    800005ae:	f018                	sd	a4,32(s0)
    800005b0:	f41c                	sd	a5,40(s0)
    800005b2:	03043823          	sd	a6,48(s0)
    800005b6:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005ba:	00011d97          	auipc	s11,0x11
    800005be:	7b6dad83          	lw	s11,1974(s11) # 80011d70 <pr+0x18>
  if (locking)
    800005c2:	020d9b63          	bnez	s11,800005f8 <printf+0x70>
  if (fmt == 0)
    800005c6:	040a0263          	beqz	s4,8000060a <printf+0x82>
  va_start(ap, fmt);
    800005ca:	00840793          	addi	a5,s0,8
    800005ce:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
    800005d2:	000a4503          	lbu	a0,0(s4)
    800005d6:	14050f63          	beqz	a0,80000734 <printf+0x1ac>
    800005da:	4981                	li	s3,0
    if (c != '%')
    800005dc:	02500a93          	li	s5,37
    switch (c)
    800005e0:	07000b93          	li	s7,112
  consputc('x');
    800005e4:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005e6:	00009b17          	auipc	s6,0x9
    800005ea:	a5ab0b13          	addi	s6,s6,-1446 # 80009040 <digits>
    switch (c)
    800005ee:	07300c93          	li	s9,115
    800005f2:	06400c13          	li	s8,100
    800005f6:	a82d                	j	80000630 <printf+0xa8>
    acquire(&pr.lock);
    800005f8:	00011517          	auipc	a0,0x11
    800005fc:	76050513          	addi	a0,a0,1888 # 80011d58 <pr>
    80000600:	00000097          	auipc	ra,0x0
    80000604:	792080e7          	jalr	1938(ra) # 80000d92 <acquire>
    80000608:	bf7d                	j	800005c6 <printf+0x3e>
    panic("null fmt");
    8000060a:	00009517          	auipc	a0,0x9
    8000060e:	a1e50513          	addi	a0,a0,-1506 # 80009028 <etext+0x28>
    80000612:	00000097          	auipc	ra,0x0
    80000616:	f2c080e7          	jalr	-212(ra) # 8000053e <panic>
      consputc(c);
    8000061a:	00000097          	auipc	ra,0x0
    8000061e:	c62080e7          	jalr	-926(ra) # 8000027c <consputc>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
    80000622:	2985                	addiw	s3,s3,1
    80000624:	013a07b3          	add	a5,s4,s3
    80000628:	0007c503          	lbu	a0,0(a5)
    8000062c:	10050463          	beqz	a0,80000734 <printf+0x1ac>
    if (c != '%')
    80000630:	ff5515e3          	bne	a0,s5,8000061a <printf+0x92>
    c = fmt[++i] & 0xff;
    80000634:	2985                	addiw	s3,s3,1
    80000636:	013a07b3          	add	a5,s4,s3
    8000063a:	0007c783          	lbu	a5,0(a5)
    8000063e:	0007849b          	sext.w	s1,a5
    if (c == 0)
    80000642:	cbed                	beqz	a5,80000734 <printf+0x1ac>
    switch (c)
    80000644:	05778a63          	beq	a5,s7,80000698 <printf+0x110>
    80000648:	02fbf663          	bgeu	s7,a5,80000674 <printf+0xec>
    8000064c:	09978863          	beq	a5,s9,800006dc <printf+0x154>
    80000650:	07800713          	li	a4,120
    80000654:	0ce79563          	bne	a5,a4,8000071e <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000658:	f8843783          	ld	a5,-120(s0)
    8000065c:	00878713          	addi	a4,a5,8
    80000660:	f8e43423          	sd	a4,-120(s0)
    80000664:	4605                	li	a2,1
    80000666:	85ea                	mv	a1,s10
    80000668:	4388                	lw	a0,0(a5)
    8000066a:	00000097          	auipc	ra,0x0
    8000066e:	e32080e7          	jalr	-462(ra) # 8000049c <printint>
      break;
    80000672:	bf45                	j	80000622 <printf+0x9a>
    switch (c)
    80000674:	09578f63          	beq	a5,s5,80000712 <printf+0x18a>
    80000678:	0b879363          	bne	a5,s8,8000071e <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000067c:	f8843783          	ld	a5,-120(s0)
    80000680:	00878713          	addi	a4,a5,8
    80000684:	f8e43423          	sd	a4,-120(s0)
    80000688:	4605                	li	a2,1
    8000068a:	45a9                	li	a1,10
    8000068c:	4388                	lw	a0,0(a5)
    8000068e:	00000097          	auipc	ra,0x0
    80000692:	e0e080e7          	jalr	-498(ra) # 8000049c <printint>
      break;
    80000696:	b771                	j	80000622 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000698:	f8843783          	ld	a5,-120(s0)
    8000069c:	00878713          	addi	a4,a5,8
    800006a0:	f8e43423          	sd	a4,-120(s0)
    800006a4:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006a8:	03000513          	li	a0,48
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	bd0080e7          	jalr	-1072(ra) # 8000027c <consputc>
  consputc('x');
    800006b4:	07800513          	li	a0,120
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	bc4080e7          	jalr	-1084(ra) # 8000027c <consputc>
    800006c0:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c2:	03c95793          	srli	a5,s2,0x3c
    800006c6:	97da                	add	a5,a5,s6
    800006c8:	0007c503          	lbu	a0,0(a5)
    800006cc:	00000097          	auipc	ra,0x0
    800006d0:	bb0080e7          	jalr	-1104(ra) # 8000027c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d4:	0912                	slli	s2,s2,0x4
    800006d6:	34fd                	addiw	s1,s1,-1
    800006d8:	f4ed                	bnez	s1,800006c2 <printf+0x13a>
    800006da:	b7a1                	j	80000622 <printf+0x9a>
      if ((s = va_arg(ap, char *)) == 0)
    800006dc:	f8843783          	ld	a5,-120(s0)
    800006e0:	00878713          	addi	a4,a5,8
    800006e4:	f8e43423          	sd	a4,-120(s0)
    800006e8:	6384                	ld	s1,0(a5)
    800006ea:	cc89                	beqz	s1,80000704 <printf+0x17c>
      for (; *s; s++)
    800006ec:	0004c503          	lbu	a0,0(s1)
    800006f0:	d90d                	beqz	a0,80000622 <printf+0x9a>
        consputc(*s);
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	b8a080e7          	jalr	-1142(ra) # 8000027c <consputc>
      for (; *s; s++)
    800006fa:	0485                	addi	s1,s1,1
    800006fc:	0004c503          	lbu	a0,0(s1)
    80000700:	f96d                	bnez	a0,800006f2 <printf+0x16a>
    80000702:	b705                	j	80000622 <printf+0x9a>
        s = "(null)";
    80000704:	00009497          	auipc	s1,0x9
    80000708:	91c48493          	addi	s1,s1,-1764 # 80009020 <etext+0x20>
      for (; *s; s++)
    8000070c:	02800513          	li	a0,40
    80000710:	b7cd                	j	800006f2 <printf+0x16a>
      consputc('%');
    80000712:	8556                	mv	a0,s5
    80000714:	00000097          	auipc	ra,0x0
    80000718:	b68080e7          	jalr	-1176(ra) # 8000027c <consputc>
      break;
    8000071c:	b719                	j	80000622 <printf+0x9a>
      consputc('%');
    8000071e:	8556                	mv	a0,s5
    80000720:	00000097          	auipc	ra,0x0
    80000724:	b5c080e7          	jalr	-1188(ra) # 8000027c <consputc>
      consputc(c);
    80000728:	8526                	mv	a0,s1
    8000072a:	00000097          	auipc	ra,0x0
    8000072e:	b52080e7          	jalr	-1198(ra) # 8000027c <consputc>
      break;
    80000732:	bdc5                	j	80000622 <printf+0x9a>
  if (locking)
    80000734:	020d9163          	bnez	s11,80000756 <printf+0x1ce>
}
    80000738:	70e6                	ld	ra,120(sp)
    8000073a:	7446                	ld	s0,112(sp)
    8000073c:	74a6                	ld	s1,104(sp)
    8000073e:	7906                	ld	s2,96(sp)
    80000740:	69e6                	ld	s3,88(sp)
    80000742:	6a46                	ld	s4,80(sp)
    80000744:	6aa6                	ld	s5,72(sp)
    80000746:	6b06                	ld	s6,64(sp)
    80000748:	7be2                	ld	s7,56(sp)
    8000074a:	7c42                	ld	s8,48(sp)
    8000074c:	7ca2                	ld	s9,40(sp)
    8000074e:	7d02                	ld	s10,32(sp)
    80000750:	6de2                	ld	s11,24(sp)
    80000752:	6129                	addi	sp,sp,192
    80000754:	8082                	ret
    release(&pr.lock);
    80000756:	00011517          	auipc	a0,0x11
    8000075a:	60250513          	addi	a0,a0,1538 # 80011d58 <pr>
    8000075e:	00000097          	auipc	ra,0x0
    80000762:	6e8080e7          	jalr	1768(ra) # 80000e46 <release>
}
    80000766:	bfc9                	j	80000738 <printf+0x1b0>

0000000080000768 <printfinit>:
    ;
}

void printfinit(void)
{
    80000768:	1101                	addi	sp,sp,-32
    8000076a:	ec06                	sd	ra,24(sp)
    8000076c:	e822                	sd	s0,16(sp)
    8000076e:	e426                	sd	s1,8(sp)
    80000770:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000772:	00011497          	auipc	s1,0x11
    80000776:	5e648493          	addi	s1,s1,1510 # 80011d58 <pr>
    8000077a:	00009597          	auipc	a1,0x9
    8000077e:	8be58593          	addi	a1,a1,-1858 # 80009038 <etext+0x38>
    80000782:	8526                	mv	a0,s1
    80000784:	00000097          	auipc	ra,0x0
    80000788:	57e080e7          	jalr	1406(ra) # 80000d02 <initlock>
  pr.locking = 1;
    8000078c:	4785                	li	a5,1
    8000078e:	cc9c                	sw	a5,24(s1)
}
    80000790:	60e2                	ld	ra,24(sp)
    80000792:	6442                	ld	s0,16(sp)
    80000794:	64a2                	ld	s1,8(sp)
    80000796:	6105                	addi	sp,sp,32
    80000798:	8082                	ret

000000008000079a <uartinit>:
extern volatile int panicked; // from printf.c

void uartstart();

void uartinit(void)
{
    8000079a:	1141                	addi	sp,sp,-16
    8000079c:	e406                	sd	ra,8(sp)
    8000079e:	e022                	sd	s0,0(sp)
    800007a0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007a2:	100007b7          	lui	a5,0x10000
    800007a6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007aa:	f8000713          	li	a4,-128
    800007ae:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007b2:	470d                	li	a4,3
    800007b4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007b8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007bc:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007c0:	469d                	li	a3,7
    800007c2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007c6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007ca:	00009597          	auipc	a1,0x9
    800007ce:	88e58593          	addi	a1,a1,-1906 # 80009058 <digits+0x18>
    800007d2:	00011517          	auipc	a0,0x11
    800007d6:	5a650513          	addi	a0,a0,1446 # 80011d78 <uart_tx_lock>
    800007da:	00000097          	auipc	ra,0x0
    800007de:	528080e7          	jalr	1320(ra) # 80000d02 <initlock>
}
    800007e2:	60a2                	ld	ra,8(sp)
    800007e4:	6402                	ld	s0,0(sp)
    800007e6:	0141                	addi	sp,sp,16
    800007e8:	8082                	ret

00000000800007ea <uartputc_sync>:
// alternate version of uartputc() that doesn't
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void uartputc_sync(int c)
{
    800007ea:	1101                	addi	sp,sp,-32
    800007ec:	ec06                	sd	ra,24(sp)
    800007ee:	e822                	sd	s0,16(sp)
    800007f0:	e426                	sd	s1,8(sp)
    800007f2:	1000                	addi	s0,sp,32
    800007f4:	84aa                	mv	s1,a0
  push_off();
    800007f6:	00000097          	auipc	ra,0x0
    800007fa:	550080e7          	jalr	1360(ra) # 80000d46 <push_off>

  if (panicked)
    800007fe:	00009797          	auipc	a5,0x9
    80000802:	3327a783          	lw	a5,818(a5) # 80009b30 <panicked>
    for (;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000806:	10000737          	lui	a4,0x10000
  if (panicked)
    8000080a:	c391                	beqz	a5,8000080e <uartputc_sync+0x24>
    for (;;)
    8000080c:	a001                	j	8000080c <uartputc_sync+0x22>
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000080e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000812:	0207f793          	andi	a5,a5,32
    80000816:	dfe5                	beqz	a5,8000080e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000818:	0ff4f513          	andi	a0,s1,255
    8000081c:	100007b7          	lui	a5,0x10000
    80000820:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000824:	00000097          	auipc	ra,0x0
    80000828:	5c2080e7          	jalr	1474(ra) # 80000de6 <pop_off>
}
    8000082c:	60e2                	ld	ra,24(sp)
    8000082e:	6442                	ld	s0,16(sp)
    80000830:	64a2                	ld	s1,8(sp)
    80000832:	6105                	addi	sp,sp,32
    80000834:	8082                	ret

0000000080000836 <uartstart>:
// called from both the top- and bottom-half.
void uartstart()
{
  while (1)
  {
    if (uart_tx_w == uart_tx_r)
    80000836:	00009797          	auipc	a5,0x9
    8000083a:	3027b783          	ld	a5,770(a5) # 80009b38 <uart_tx_r>
    8000083e:	00009717          	auipc	a4,0x9
    80000842:	30273703          	ld	a4,770(a4) # 80009b40 <uart_tx_w>
    80000846:	06f70a63          	beq	a4,a5,800008ba <uartstart+0x84>
{
    8000084a:	7139                	addi	sp,sp,-64
    8000084c:	fc06                	sd	ra,56(sp)
    8000084e:	f822                	sd	s0,48(sp)
    80000850:	f426                	sd	s1,40(sp)
    80000852:	f04a                	sd	s2,32(sp)
    80000854:	ec4e                	sd	s3,24(sp)
    80000856:	e852                	sd	s4,16(sp)
    80000858:	e456                	sd	s5,8(sp)
    8000085a:	0080                	addi	s0,sp,64
    {
      // transmit buffer is empty.
      return;
    }

    if ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000085c:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }

    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000860:	00011a17          	auipc	s4,0x11
    80000864:	518a0a13          	addi	s4,s4,1304 # 80011d78 <uart_tx_lock>
    uart_tx_r += 1;
    80000868:	00009497          	auipc	s1,0x9
    8000086c:	2d048493          	addi	s1,s1,720 # 80009b38 <uart_tx_r>
    if (uart_tx_w == uart_tx_r)
    80000870:	00009997          	auipc	s3,0x9
    80000874:	2d098993          	addi	s3,s3,720 # 80009b40 <uart_tx_w>
    if ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000878:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000087c:	02077713          	andi	a4,a4,32
    80000880:	c705                	beqz	a4,800008a8 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000882:	01f7f713          	andi	a4,a5,31
    80000886:	9752                	add	a4,a4,s4
    80000888:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000088c:	0785                	addi	a5,a5,1
    8000088e:	e09c                	sd	a5,0(s1)

    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000890:	8526                	mv	a0,s1
    80000892:	00002097          	auipc	ra,0x2
    80000896:	e90080e7          	jalr	-368(ra) # 80002722 <wakeup>

    WriteReg(THR, c);
    8000089a:	01590023          	sb	s5,0(s2)
    if (uart_tx_w == uart_tx_r)
    8000089e:	609c                	ld	a5,0(s1)
    800008a0:	0009b703          	ld	a4,0(s3)
    800008a4:	fcf71ae3          	bne	a4,a5,80000878 <uartstart+0x42>
  }
}
    800008a8:	70e2                	ld	ra,56(sp)
    800008aa:	7442                	ld	s0,48(sp)
    800008ac:	74a2                	ld	s1,40(sp)
    800008ae:	7902                	ld	s2,32(sp)
    800008b0:	69e2                	ld	s3,24(sp)
    800008b2:	6a42                	ld	s4,16(sp)
    800008b4:	6aa2                	ld	s5,8(sp)
    800008b6:	6121                	addi	sp,sp,64
    800008b8:	8082                	ret
    800008ba:	8082                	ret

00000000800008bc <uartputc>:
{
    800008bc:	7179                	addi	sp,sp,-48
    800008be:	f406                	sd	ra,40(sp)
    800008c0:	f022                	sd	s0,32(sp)
    800008c2:	ec26                	sd	s1,24(sp)
    800008c4:	e84a                	sd	s2,16(sp)
    800008c6:	e44e                	sd	s3,8(sp)
    800008c8:	e052                	sd	s4,0(sp)
    800008ca:	1800                	addi	s0,sp,48
    800008cc:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008ce:	00011517          	auipc	a0,0x11
    800008d2:	4aa50513          	addi	a0,a0,1194 # 80011d78 <uart_tx_lock>
    800008d6:	00000097          	auipc	ra,0x0
    800008da:	4bc080e7          	jalr	1212(ra) # 80000d92 <acquire>
  if (panicked)
    800008de:	00009797          	auipc	a5,0x9
    800008e2:	2527a783          	lw	a5,594(a5) # 80009b30 <panicked>
    800008e6:	e7c9                	bnez	a5,80000970 <uartputc+0xb4>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE)
    800008e8:	00009717          	auipc	a4,0x9
    800008ec:	25873703          	ld	a4,600(a4) # 80009b40 <uart_tx_w>
    800008f0:	00009797          	auipc	a5,0x9
    800008f4:	2487b783          	ld	a5,584(a5) # 80009b38 <uart_tx_r>
    800008f8:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800008fc:	00011997          	auipc	s3,0x11
    80000900:	47c98993          	addi	s3,s3,1148 # 80011d78 <uart_tx_lock>
    80000904:	00009497          	auipc	s1,0x9
    80000908:	23448493          	addi	s1,s1,564 # 80009b38 <uart_tx_r>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE)
    8000090c:	00009917          	auipc	s2,0x9
    80000910:	23490913          	addi	s2,s2,564 # 80009b40 <uart_tx_w>
    80000914:	00e79f63          	bne	a5,a4,80000932 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000918:	85ce                	mv	a1,s3
    8000091a:	8526                	mv	a0,s1
    8000091c:	00002097          	auipc	ra,0x2
    80000920:	c4a080e7          	jalr	-950(ra) # 80002566 <sleep>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE)
    80000924:	00093703          	ld	a4,0(s2)
    80000928:	609c                	ld	a5,0(s1)
    8000092a:	02078793          	addi	a5,a5,32
    8000092e:	fee785e3          	beq	a5,a4,80000918 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000932:	00011497          	auipc	s1,0x11
    80000936:	44648493          	addi	s1,s1,1094 # 80011d78 <uart_tx_lock>
    8000093a:	01f77793          	andi	a5,a4,31
    8000093e:	97a6                	add	a5,a5,s1
    80000940:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000944:	0705                	addi	a4,a4,1
    80000946:	00009797          	auipc	a5,0x9
    8000094a:	1ee7bd23          	sd	a4,506(a5) # 80009b40 <uart_tx_w>
  uartstart();
    8000094e:	00000097          	auipc	ra,0x0
    80000952:	ee8080e7          	jalr	-280(ra) # 80000836 <uartstart>
  release(&uart_tx_lock);
    80000956:	8526                	mv	a0,s1
    80000958:	00000097          	auipc	ra,0x0
    8000095c:	4ee080e7          	jalr	1262(ra) # 80000e46 <release>
}
    80000960:	70a2                	ld	ra,40(sp)
    80000962:	7402                	ld	s0,32(sp)
    80000964:	64e2                	ld	s1,24(sp)
    80000966:	6942                	ld	s2,16(sp)
    80000968:	69a2                	ld	s3,8(sp)
    8000096a:	6a02                	ld	s4,0(sp)
    8000096c:	6145                	addi	sp,sp,48
    8000096e:	8082                	ret
    for (;;)
    80000970:	a001                	j	80000970 <uartputc+0xb4>

0000000080000972 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int uartgetc(void)
{
    80000972:	1141                	addi	sp,sp,-16
    80000974:	e422                	sd	s0,8(sp)
    80000976:	0800                	addi	s0,sp,16
  if (ReadReg(LSR) & 0x01)
    80000978:	100007b7          	lui	a5,0x10000
    8000097c:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000980:	8b85                	andi	a5,a5,1
    80000982:	cb91                	beqz	a5,80000996 <uartgetc+0x24>
  {
    // input data is ready.
    return ReadReg(RHR);
    80000984:	100007b7          	lui	a5,0x10000
    80000988:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000098c:	0ff57513          	andi	a0,a0,255
  }
  else
  {
    return -1;
  }
}
    80000990:	6422                	ld	s0,8(sp)
    80000992:	0141                	addi	sp,sp,16
    80000994:	8082                	ret
    return -1;
    80000996:	557d                	li	a0,-1
    80000998:	bfe5                	j	80000990 <uartgetc+0x1e>

000000008000099a <uartintr>:

// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void uartintr(void)
{
    8000099a:	1101                	addi	sp,sp,-32
    8000099c:	ec06                	sd	ra,24(sp)
    8000099e:	e822                	sd	s0,16(sp)
    800009a0:	e426                	sd	s1,8(sp)
    800009a2:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while (1)
  {
    int c = uartgetc();
    if (c == -1)
    800009a4:	54fd                	li	s1,-1
    800009a6:	a029                	j	800009b0 <uartintr+0x16>
      break;
    consoleintr(c);
    800009a8:	00000097          	auipc	ra,0x0
    800009ac:	916080e7          	jalr	-1770(ra) # 800002be <consoleintr>
    int c = uartgetc();
    800009b0:	00000097          	auipc	ra,0x0
    800009b4:	fc2080e7          	jalr	-62(ra) # 80000972 <uartgetc>
    if (c == -1)
    800009b8:	fe9518e3          	bne	a0,s1,800009a8 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009bc:	00011497          	auipc	s1,0x11
    800009c0:	3bc48493          	addi	s1,s1,956 # 80011d78 <uart_tx_lock>
    800009c4:	8526                	mv	a0,s1
    800009c6:	00000097          	auipc	ra,0x0
    800009ca:	3cc080e7          	jalr	972(ra) # 80000d92 <acquire>
  uartstart();
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	e68080e7          	jalr	-408(ra) # 80000836 <uartstart>
  release(&uart_tx_lock);
    800009d6:	8526                	mv	a0,s1
    800009d8:	00000097          	auipc	ra,0x0
    800009dc:	46e080e7          	jalr	1134(ra) # 80000e46 <release>
}
    800009e0:	60e2                	ld	ra,24(sp)
    800009e2:	6442                	ld	s0,16(sp)
    800009e4:	64a2                	ld	s1,8(sp)
    800009e6:	6105                	addi	sp,sp,32
    800009e8:	8082                	ret

00000000800009ea <decrease_pgreference>:
  }
  return (void *)r;
}

int decrease_pgreference(void *pa)
{
    800009ea:	1101                	addi	sp,sp,-32
    800009ec:	ec06                	sd	ra,24(sp)
    800009ee:	e822                	sd	s0,16(sp)
    800009f0:	e426                	sd	s1,8(sp)
    800009f2:	1000                	addi	s0,sp,32
    800009f4:	84aa                	mv	s1,a0
  acquire(&page_ref.lock);
    800009f6:	00011517          	auipc	a0,0x11
    800009fa:	3da50513          	addi	a0,a0,986 # 80011dd0 <page_ref>
    800009fe:	00000097          	auipc	ra,0x0
    80000a02:	394080e7          	jalr	916(ra) # 80000d92 <acquire>
  if (page_ref.count[(uint64)pa >> 12] <= 0)
    80000a06:	00c4d513          	srli	a0,s1,0xc
    80000a0a:	00450793          	addi	a5,a0,4
    80000a0e:	00279713          	slli	a4,a5,0x2
    80000a12:	00011797          	auipc	a5,0x11
    80000a16:	3be78793          	addi	a5,a5,958 # 80011dd0 <page_ref>
    80000a1a:	97ba                	add	a5,a5,a4
    80000a1c:	479c                	lw	a5,8(a5)
    80000a1e:	02f05d63          	blez	a5,80000a58 <decrease_pgreference+0x6e>
  {
    panic("decrease_pgreference");
  }
  page_ref.count[(uint64)pa >> 12]--;
    80000a22:	37fd                	addiw	a5,a5,-1
    80000a24:	0007869b          	sext.w	a3,a5
    80000a28:	0511                	addi	a0,a0,4
    80000a2a:	050a                	slli	a0,a0,0x2
    80000a2c:	00011717          	auipc	a4,0x11
    80000a30:	3a470713          	addi	a4,a4,932 # 80011dd0 <page_ref>
    80000a34:	953a                	add	a0,a0,a4
    80000a36:	c51c                	sw	a5,8(a0)
  if (page_ref.count[(uint64)pa >> 12] > 0)
    80000a38:	02d04863          	bgtz	a3,80000a68 <decrease_pgreference+0x7e>
  {
    release(&page_ref.lock);
    return 0;
  }
  release(&page_ref.lock);
    80000a3c:	00011517          	auipc	a0,0x11
    80000a40:	39450513          	addi	a0,a0,916 # 80011dd0 <page_ref>
    80000a44:	00000097          	auipc	ra,0x0
    80000a48:	402080e7          	jalr	1026(ra) # 80000e46 <release>
  return 1;
    80000a4c:	4505                	li	a0,1
}
    80000a4e:	60e2                	ld	ra,24(sp)
    80000a50:	6442                	ld	s0,16(sp)
    80000a52:	64a2                	ld	s1,8(sp)
    80000a54:	6105                	addi	sp,sp,32
    80000a56:	8082                	ret
    panic("decrease_pgreference");
    80000a58:	00008517          	auipc	a0,0x8
    80000a5c:	60850513          	addi	a0,a0,1544 # 80009060 <digits+0x20>
    80000a60:	00000097          	auipc	ra,0x0
    80000a64:	ade080e7          	jalr	-1314(ra) # 8000053e <panic>
    release(&page_ref.lock);
    80000a68:	853a                	mv	a0,a4
    80000a6a:	00000097          	auipc	ra,0x0
    80000a6e:	3dc080e7          	jalr	988(ra) # 80000e46 <release>
    return 0;
    80000a72:	4501                	li	a0,0
    80000a74:	bfe9                	j	80000a4e <decrease_pgreference+0x64>

0000000080000a76 <kfree>:
{
    80000a76:	1101                	addi	sp,sp,-32
    80000a78:	ec06                	sd	ra,24(sp)
    80000a7a:	e822                	sd	s0,16(sp)
    80000a7c:	e426                	sd	s1,8(sp)
    80000a7e:	e04a                	sd	s2,0(sp)
    80000a80:	1000                	addi	s0,sp,32
  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000a82:	03451793          	slli	a5,a0,0x34
    80000a86:	e79d                	bnez	a5,80000ab4 <kfree+0x3e>
    80000a88:	84aa                	mv	s1,a0
    80000a8a:	00246797          	auipc	a5,0x246
    80000a8e:	98e78793          	addi	a5,a5,-1650 # 80246418 <end>
    80000a92:	02f56163          	bltu	a0,a5,80000ab4 <kfree+0x3e>
    80000a96:	47c5                	li	a5,17
    80000a98:	07ee                	slli	a5,a5,0x1b
    80000a9a:	00f57d63          	bgeu	a0,a5,80000ab4 <kfree+0x3e>
  if (!decrease_pgreference(pa))
    80000a9e:	00000097          	auipc	ra,0x0
    80000aa2:	f4c080e7          	jalr	-180(ra) # 800009ea <decrease_pgreference>
    80000aa6:	ed19                	bnez	a0,80000ac4 <kfree+0x4e>
}
    80000aa8:	60e2                	ld	ra,24(sp)
    80000aaa:	6442                	ld	s0,16(sp)
    80000aac:	64a2                	ld	s1,8(sp)
    80000aae:	6902                	ld	s2,0(sp)
    80000ab0:	6105                	addi	sp,sp,32
    80000ab2:	8082                	ret
    panic("kfree");
    80000ab4:	00008517          	auipc	a0,0x8
    80000ab8:	5c450513          	addi	a0,a0,1476 # 80009078 <digits+0x38>
    80000abc:	00000097          	auipc	ra,0x0
    80000ac0:	a82080e7          	jalr	-1406(ra) # 8000053e <panic>
  memset(pa, 1, PGSIZE);
    80000ac4:	6605                	lui	a2,0x1
    80000ac6:	4585                	li	a1,1
    80000ac8:	8526                	mv	a0,s1
    80000aca:	00000097          	auipc	ra,0x0
    80000ace:	3c4080e7          	jalr	964(ra) # 80000e8e <memset>
  acquire(&kmem.lock);
    80000ad2:	00011917          	auipc	s2,0x11
    80000ad6:	2de90913          	addi	s2,s2,734 # 80011db0 <kmem>
    80000ada:	854a                	mv	a0,s2
    80000adc:	00000097          	auipc	ra,0x0
    80000ae0:	2b6080e7          	jalr	694(ra) # 80000d92 <acquire>
  r->next = kmem.freelist;
    80000ae4:	01893783          	ld	a5,24(s2)
    80000ae8:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000aea:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000aee:	854a                	mv	a0,s2
    80000af0:	00000097          	auipc	ra,0x0
    80000af4:	356080e7          	jalr	854(ra) # 80000e46 <release>
    80000af8:	bf45                	j	80000aa8 <kfree+0x32>

0000000080000afa <increase_pgreference>:

void increase_pgreference(void *pa)
{
    80000afa:	1101                	addi	sp,sp,-32
    80000afc:	ec06                	sd	ra,24(sp)
    80000afe:	e822                	sd	s0,16(sp)
    80000b00:	e426                	sd	s1,8(sp)
    80000b02:	1000                	addi	s0,sp,32
    80000b04:	84aa                	mv	s1,a0
  acquire(&page_ref.lock);
    80000b06:	00011517          	auipc	a0,0x11
    80000b0a:	2ca50513          	addi	a0,a0,714 # 80011dd0 <page_ref>
    80000b0e:	00000097          	auipc	ra,0x0
    80000b12:	284080e7          	jalr	644(ra) # 80000d92 <acquire>
  if (page_ref.count[(uint64)pa >> 12] < 0)
    80000b16:	00c4d793          	srli	a5,s1,0xc
    80000b1a:	00478713          	addi	a4,a5,4
    80000b1e:	00271693          	slli	a3,a4,0x2
    80000b22:	00011717          	auipc	a4,0x11
    80000b26:	2ae70713          	addi	a4,a4,686 # 80011dd0 <page_ref>
    80000b2a:	9736                	add	a4,a4,a3
    80000b2c:	4718                	lw	a4,8(a4)
    80000b2e:	02074463          	bltz	a4,80000b56 <increase_pgreference+0x5c>
  {
    panic("increase_pgreference");
  }
  page_ref.count[(uint64)pa >> 12]++;
    80000b32:	00011517          	auipc	a0,0x11
    80000b36:	29e50513          	addi	a0,a0,670 # 80011dd0 <page_ref>
    80000b3a:	0791                	addi	a5,a5,4
    80000b3c:	078a                	slli	a5,a5,0x2
    80000b3e:	97aa                	add	a5,a5,a0
    80000b40:	2705                	addiw	a4,a4,1
    80000b42:	c798                	sw	a4,8(a5)
  release(&page_ref.lock);
    80000b44:	00000097          	auipc	ra,0x0
    80000b48:	302080e7          	jalr	770(ra) # 80000e46 <release>
}
    80000b4c:	60e2                	ld	ra,24(sp)
    80000b4e:	6442                	ld	s0,16(sp)
    80000b50:	64a2                	ld	s1,8(sp)
    80000b52:	6105                	addi	sp,sp,32
    80000b54:	8082                	ret
    panic("increase_pgreference");
    80000b56:	00008517          	auipc	a0,0x8
    80000b5a:	52a50513          	addi	a0,a0,1322 # 80009080 <digits+0x40>
    80000b5e:	00000097          	auipc	ra,0x0
    80000b62:	9e0080e7          	jalr	-1568(ra) # 8000053e <panic>

0000000080000b66 <freerange>:
{
    80000b66:	7139                	addi	sp,sp,-64
    80000b68:	fc06                	sd	ra,56(sp)
    80000b6a:	f822                	sd	s0,48(sp)
    80000b6c:	f426                	sd	s1,40(sp)
    80000b6e:	f04a                	sd	s2,32(sp)
    80000b70:	ec4e                	sd	s3,24(sp)
    80000b72:	e852                	sd	s4,16(sp)
    80000b74:	e456                	sd	s5,8(sp)
    80000b76:	0080                	addi	s0,sp,64
  p = (char *)PGROUNDUP((uint64)pa_start);
    80000b78:	6785                	lui	a5,0x1
    80000b7a:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000b7e:	94aa                	add	s1,s1,a0
    80000b80:	757d                	lui	a0,0xfffff
    80000b82:	8ce9                	and	s1,s1,a0
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000b84:	94be                	add	s1,s1,a5
    80000b86:	0295e463          	bltu	a1,s1,80000bae <freerange+0x48>
    80000b8a:	89ae                	mv	s3,a1
    80000b8c:	7afd                	lui	s5,0xfffff
    80000b8e:	6a05                	lui	s4,0x1
    80000b90:	01548933          	add	s2,s1,s5
    increase_pgreference(p);
    80000b94:	854a                	mv	a0,s2
    80000b96:	00000097          	auipc	ra,0x0
    80000b9a:	f64080e7          	jalr	-156(ra) # 80000afa <increase_pgreference>
    kfree(p);
    80000b9e:	854a                	mv	a0,s2
    80000ba0:	00000097          	auipc	ra,0x0
    80000ba4:	ed6080e7          	jalr	-298(ra) # 80000a76 <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000ba8:	94d2                	add	s1,s1,s4
    80000baa:	fe99f3e3          	bgeu	s3,s1,80000b90 <freerange+0x2a>
}
    80000bae:	70e2                	ld	ra,56(sp)
    80000bb0:	7442                	ld	s0,48(sp)
    80000bb2:	74a2                	ld	s1,40(sp)
    80000bb4:	7902                	ld	s2,32(sp)
    80000bb6:	69e2                	ld	s3,24(sp)
    80000bb8:	6a42                	ld	s4,16(sp)
    80000bba:	6aa2                	ld	s5,8(sp)
    80000bbc:	6121                	addi	sp,sp,64
    80000bbe:	8082                	ret

0000000080000bc0 <kinit>:
{
    80000bc0:	1141                	addi	sp,sp,-16
    80000bc2:	e406                	sd	ra,8(sp)
    80000bc4:	e022                	sd	s0,0(sp)
    80000bc6:	0800                	addi	s0,sp,16
  initlock(&page_ref.lock, "page_ref");
    80000bc8:	00008597          	auipc	a1,0x8
    80000bcc:	4d058593          	addi	a1,a1,1232 # 80009098 <digits+0x58>
    80000bd0:	00011517          	auipc	a0,0x11
    80000bd4:	20050513          	addi	a0,a0,512 # 80011dd0 <page_ref>
    80000bd8:	00000097          	auipc	ra,0x0
    80000bdc:	12a080e7          	jalr	298(ra) # 80000d02 <initlock>
  acquire(&page_ref.lock);
    80000be0:	00011517          	auipc	a0,0x11
    80000be4:	1f050513          	addi	a0,a0,496 # 80011dd0 <page_ref>
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	1aa080e7          	jalr	426(ra) # 80000d92 <acquire>
  for (int i = 0; i < (PGROUNDUP(PHYSTOP) >> 12); ++i)
    80000bf0:	00011797          	auipc	a5,0x11
    80000bf4:	1f878793          	addi	a5,a5,504 # 80011de8 <page_ref+0x18>
    80000bf8:	00231717          	auipc	a4,0x231
    80000bfc:	1f070713          	addi	a4,a4,496 # 80231de8 <pid_lock>
    page_ref.count[i] = 0;
    80000c00:	0007a023          	sw	zero,0(a5)
  for (int i = 0; i < (PGROUNDUP(PHYSTOP) >> 12); ++i)
    80000c04:	0791                	addi	a5,a5,4
    80000c06:	fee79de3          	bne	a5,a4,80000c00 <kinit+0x40>
  release(&page_ref.lock);
    80000c0a:	00011517          	auipc	a0,0x11
    80000c0e:	1c650513          	addi	a0,a0,454 # 80011dd0 <page_ref>
    80000c12:	00000097          	auipc	ra,0x0
    80000c16:	234080e7          	jalr	564(ra) # 80000e46 <release>
  initlock(&kmem.lock, "kmem");
    80000c1a:	00008597          	auipc	a1,0x8
    80000c1e:	48e58593          	addi	a1,a1,1166 # 800090a8 <digits+0x68>
    80000c22:	00011517          	auipc	a0,0x11
    80000c26:	18e50513          	addi	a0,a0,398 # 80011db0 <kmem>
    80000c2a:	00000097          	auipc	ra,0x0
    80000c2e:	0d8080e7          	jalr	216(ra) # 80000d02 <initlock>
  freerange(end, (void *)PHYSTOP);
    80000c32:	45c5                	li	a1,17
    80000c34:	05ee                	slli	a1,a1,0x1b
    80000c36:	00245517          	auipc	a0,0x245
    80000c3a:	7e250513          	addi	a0,a0,2018 # 80246418 <end>
    80000c3e:	00000097          	auipc	ra,0x0
    80000c42:	f28080e7          	jalr	-216(ra) # 80000b66 <freerange>
}
    80000c46:	60a2                	ld	ra,8(sp)
    80000c48:	6402                	ld	s0,0(sp)
    80000c4a:	0141                	addi	sp,sp,16
    80000c4c:	8082                	ret

0000000080000c4e <kalloc>:
{
    80000c4e:	1101                	addi	sp,sp,-32
    80000c50:	ec06                	sd	ra,24(sp)
    80000c52:	e822                	sd	s0,16(sp)
    80000c54:	e426                	sd	s1,8(sp)
    80000c56:	1000                	addi	s0,sp,32
  acquire(&kmem.lock);
    80000c58:	00011497          	auipc	s1,0x11
    80000c5c:	15848493          	addi	s1,s1,344 # 80011db0 <kmem>
    80000c60:	8526                	mv	a0,s1
    80000c62:	00000097          	auipc	ra,0x0
    80000c66:	130080e7          	jalr	304(ra) # 80000d92 <acquire>
  r = kmem.freelist;
    80000c6a:	6c84                	ld	s1,24(s1)
  if (r)
    80000c6c:	cc8d                	beqz	s1,80000ca6 <kalloc+0x58>
    kmem.freelist = r->next;
    80000c6e:	609c                	ld	a5,0(s1)
    80000c70:	00011517          	auipc	a0,0x11
    80000c74:	14050513          	addi	a0,a0,320 # 80011db0 <kmem>
    80000c78:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000c7a:	00000097          	auipc	ra,0x0
    80000c7e:	1cc080e7          	jalr	460(ra) # 80000e46 <release>
    memset((char *)r, 5, PGSIZE); // fill with junk
    80000c82:	6605                	lui	a2,0x1
    80000c84:	4595                	li	a1,5
    80000c86:	8526                	mv	a0,s1
    80000c88:	00000097          	auipc	ra,0x0
    80000c8c:	206080e7          	jalr	518(ra) # 80000e8e <memset>
    increase_pgreference((void *)r);
    80000c90:	8526                	mv	a0,s1
    80000c92:	00000097          	auipc	ra,0x0
    80000c96:	e68080e7          	jalr	-408(ra) # 80000afa <increase_pgreference>
}
    80000c9a:	8526                	mv	a0,s1
    80000c9c:	60e2                	ld	ra,24(sp)
    80000c9e:	6442                	ld	s0,16(sp)
    80000ca0:	64a2                	ld	s1,8(sp)
    80000ca2:	6105                	addi	sp,sp,32
    80000ca4:	8082                	ret
  release(&kmem.lock);
    80000ca6:	00011517          	auipc	a0,0x11
    80000caa:	10a50513          	addi	a0,a0,266 # 80011db0 <kmem>
    80000cae:	00000097          	auipc	ra,0x0
    80000cb2:	198080e7          	jalr	408(ra) # 80000e46 <release>
  if (r)
    80000cb6:	b7d5                	j	80000c9a <kalloc+0x4c>

0000000080000cb8 <kfreemem>:


uint64
kfreemem(void)
{
    80000cb8:	1101                	addi	sp,sp,-32
    80000cba:	ec06                	sd	ra,24(sp)
    80000cbc:	e822                	sd	s0,16(sp)
    80000cbe:	e426                	sd	s1,8(sp)
    80000cc0:	1000                	addi	s0,sp,32
    struct run *r;
    uint64 free_bytes = 0;
    acquire(&kmem.lock);
    80000cc2:	00011497          	auipc	s1,0x11
    80000cc6:	0ee48493          	addi	s1,s1,238 # 80011db0 <kmem>
    80000cca:	8526                	mv	a0,s1
    80000ccc:	00000097          	auipc	ra,0x0
    80000cd0:	0c6080e7          	jalr	198(ra) # 80000d92 <acquire>
    for (r = kmem.freelist; r; r = r->next)
    80000cd4:	6c9c                	ld	a5,24(s1)
    80000cd6:	c785                	beqz	a5,80000cfe <kfreemem+0x46>
    uint64 free_bytes = 0;
    80000cd8:	4481                	li	s1,0
        free_bytes += PGSIZE;
    80000cda:	6705                	lui	a4,0x1
    80000cdc:	94ba                	add	s1,s1,a4
    for (r = kmem.freelist; r; r = r->next)
    80000cde:	639c                	ld	a5,0(a5)
    80000ce0:	fff5                	bnez	a5,80000cdc <kfreemem+0x24>
    release(&kmem.lock);
    80000ce2:	00011517          	auipc	a0,0x11
    80000ce6:	0ce50513          	addi	a0,a0,206 # 80011db0 <kmem>
    80000cea:	00000097          	auipc	ra,0x0
    80000cee:	15c080e7          	jalr	348(ra) # 80000e46 <release>
    return free_bytes;
}
    80000cf2:	8526                	mv	a0,s1
    80000cf4:	60e2                	ld	ra,24(sp)
    80000cf6:	6442                	ld	s0,16(sp)
    80000cf8:	64a2                	ld	s1,8(sp)
    80000cfa:	6105                	addi	sp,sp,32
    80000cfc:	8082                	ret
    uint64 free_bytes = 0;
    80000cfe:	4481                	li	s1,0
    80000d00:	b7cd                	j	80000ce2 <kfreemem+0x2a>

0000000080000d02 <initlock>:
#include "riscv.h"
#include "proc.h"
#include "defs.h"

void initlock(struct spinlock *lk, char *name)
{
    80000d02:	1141                	addi	sp,sp,-16
    80000d04:	e422                	sd	s0,8(sp)
    80000d06:	0800                	addi	s0,sp,16
  lk->name = name;
    80000d08:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000d0a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000d0e:	00053823          	sd	zero,16(a0)
}
    80000d12:	6422                	ld	s0,8(sp)
    80000d14:	0141                	addi	sp,sp,16
    80000d16:	8082                	ret

0000000080000d18 <holding>:
// Check whether this cpu is holding the lock.
// Interrupts must be off.
int holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000d18:	411c                	lw	a5,0(a0)
    80000d1a:	e399                	bnez	a5,80000d20 <holding+0x8>
    80000d1c:	4501                	li	a0,0
  return r;
}
    80000d1e:	8082                	ret
{
    80000d20:	1101                	addi	sp,sp,-32
    80000d22:	ec06                	sd	ra,24(sp)
    80000d24:	e822                	sd	s0,16(sp)
    80000d26:	e426                	sd	s1,8(sp)
    80000d28:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000d2a:	6904                	ld	s1,16(a0)
    80000d2c:	00001097          	auipc	ra,0x1
    80000d30:	ea6080e7          	jalr	-346(ra) # 80001bd2 <mycpu>
    80000d34:	40a48533          	sub	a0,s1,a0
    80000d38:	00153513          	seqz	a0,a0
}
    80000d3c:	60e2                	ld	ra,24(sp)
    80000d3e:	6442                	ld	s0,16(sp)
    80000d40:	64a2                	ld	s1,8(sp)
    80000d42:	6105                	addi	sp,sp,32
    80000d44:	8082                	ret

0000000080000d46 <push_off>:
// push_off/pop_off are like intr_off()/intr_on() except that they are matched:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void push_off(void)
{
    80000d46:	1101                	addi	sp,sp,-32
    80000d48:	ec06                	sd	ra,24(sp)
    80000d4a:	e822                	sd	s0,16(sp)
    80000d4c:	e426                	sd	s1,8(sp)
    80000d4e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus"
    80000d50:	100024f3          	csrr	s1,sstatus
    80000d54:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000d58:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0"
    80000d5a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if (mycpu()->noff == 0)
    80000d5e:	00001097          	auipc	ra,0x1
    80000d62:	e74080e7          	jalr	-396(ra) # 80001bd2 <mycpu>
    80000d66:	5d3c                	lw	a5,120(a0)
    80000d68:	cf89                	beqz	a5,80000d82 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000d6a:	00001097          	auipc	ra,0x1
    80000d6e:	e68080e7          	jalr	-408(ra) # 80001bd2 <mycpu>
    80000d72:	5d3c                	lw	a5,120(a0)
    80000d74:	2785                	addiw	a5,a5,1
    80000d76:	dd3c                	sw	a5,120(a0)
}
    80000d78:	60e2                	ld	ra,24(sp)
    80000d7a:	6442                	ld	s0,16(sp)
    80000d7c:	64a2                	ld	s1,8(sp)
    80000d7e:	6105                	addi	sp,sp,32
    80000d80:	8082                	ret
    mycpu()->intena = old;
    80000d82:	00001097          	auipc	ra,0x1
    80000d86:	e50080e7          	jalr	-432(ra) # 80001bd2 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000d8a:	8085                	srli	s1,s1,0x1
    80000d8c:	8885                	andi	s1,s1,1
    80000d8e:	dd64                	sw	s1,124(a0)
    80000d90:	bfe9                	j	80000d6a <push_off+0x24>

0000000080000d92 <acquire>:
{
    80000d92:	1101                	addi	sp,sp,-32
    80000d94:	ec06                	sd	ra,24(sp)
    80000d96:	e822                	sd	s0,16(sp)
    80000d98:	e426                	sd	s1,8(sp)
    80000d9a:	1000                	addi	s0,sp,32
    80000d9c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000d9e:	00000097          	auipc	ra,0x0
    80000da2:	fa8080e7          	jalr	-88(ra) # 80000d46 <push_off>
  if (holding(lk))
    80000da6:	8526                	mv	a0,s1
    80000da8:	00000097          	auipc	ra,0x0
    80000dac:	f70080e7          	jalr	-144(ra) # 80000d18 <holding>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000db0:	4705                	li	a4,1
  if (holding(lk))
    80000db2:	e115                	bnez	a0,80000dd6 <acquire+0x44>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000db4:	87ba                	mv	a5,a4
    80000db6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000dba:	2781                	sext.w	a5,a5
    80000dbc:	ffe5                	bnez	a5,80000db4 <acquire+0x22>
  __sync_synchronize();
    80000dbe:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000dc2:	00001097          	auipc	ra,0x1
    80000dc6:	e10080e7          	jalr	-496(ra) # 80001bd2 <mycpu>
    80000dca:	e888                	sd	a0,16(s1)
}
    80000dcc:	60e2                	ld	ra,24(sp)
    80000dce:	6442                	ld	s0,16(sp)
    80000dd0:	64a2                	ld	s1,8(sp)
    80000dd2:	6105                	addi	sp,sp,32
    80000dd4:	8082                	ret
    panic("acquire");
    80000dd6:	00008517          	auipc	a0,0x8
    80000dda:	2da50513          	addi	a0,a0,730 # 800090b0 <digits+0x70>
    80000dde:	fffff097          	auipc	ra,0xfffff
    80000de2:	760080e7          	jalr	1888(ra) # 8000053e <panic>

0000000080000de6 <pop_off>:

void pop_off(void)
{
    80000de6:	1141                	addi	sp,sp,-16
    80000de8:	e406                	sd	ra,8(sp)
    80000dea:	e022                	sd	s0,0(sp)
    80000dec:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000dee:	00001097          	auipc	ra,0x1
    80000df2:	de4080e7          	jalr	-540(ra) # 80001bd2 <mycpu>
  asm volatile("csrr %0, sstatus"
    80000df6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000dfa:	8b89                	andi	a5,a5,2
  if (intr_get())
    80000dfc:	e78d                	bnez	a5,80000e26 <pop_off+0x40>
    panic("pop_off - interruptible");
  if (c->noff < 1)
    80000dfe:	5d3c                	lw	a5,120(a0)
    80000e00:	02f05b63          	blez	a5,80000e36 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000e04:	37fd                	addiw	a5,a5,-1
    80000e06:	0007871b          	sext.w	a4,a5
    80000e0a:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena)
    80000e0c:	eb09                	bnez	a4,80000e1e <pop_off+0x38>
    80000e0e:	5d7c                	lw	a5,124(a0)
    80000e10:	c799                	beqz	a5,80000e1e <pop_off+0x38>
  asm volatile("csrr %0, sstatus"
    80000e12:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000e16:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0"
    80000e1a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000e1e:	60a2                	ld	ra,8(sp)
    80000e20:	6402                	ld	s0,0(sp)
    80000e22:	0141                	addi	sp,sp,16
    80000e24:	8082                	ret
    panic("pop_off - interruptible");
    80000e26:	00008517          	auipc	a0,0x8
    80000e2a:	29250513          	addi	a0,a0,658 # 800090b8 <digits+0x78>
    80000e2e:	fffff097          	auipc	ra,0xfffff
    80000e32:	710080e7          	jalr	1808(ra) # 8000053e <panic>
    panic("pop_off");
    80000e36:	00008517          	auipc	a0,0x8
    80000e3a:	29a50513          	addi	a0,a0,666 # 800090d0 <digits+0x90>
    80000e3e:	fffff097          	auipc	ra,0xfffff
    80000e42:	700080e7          	jalr	1792(ra) # 8000053e <panic>

0000000080000e46 <release>:
{
    80000e46:	1101                	addi	sp,sp,-32
    80000e48:	ec06                	sd	ra,24(sp)
    80000e4a:	e822                	sd	s0,16(sp)
    80000e4c:	e426                	sd	s1,8(sp)
    80000e4e:	1000                	addi	s0,sp,32
    80000e50:	84aa                	mv	s1,a0
  if (!holding(lk))
    80000e52:	00000097          	auipc	ra,0x0
    80000e56:	ec6080e7          	jalr	-314(ra) # 80000d18 <holding>
    80000e5a:	c115                	beqz	a0,80000e7e <release+0x38>
  lk->cpu = 0;
    80000e5c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000e60:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000e64:	0f50000f          	fence	iorw,ow
    80000e68:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000e6c:	00000097          	auipc	ra,0x0
    80000e70:	f7a080e7          	jalr	-134(ra) # 80000de6 <pop_off>
}
    80000e74:	60e2                	ld	ra,24(sp)
    80000e76:	6442                	ld	s0,16(sp)
    80000e78:	64a2                	ld	s1,8(sp)
    80000e7a:	6105                	addi	sp,sp,32
    80000e7c:	8082                	ret
    panic("release");
    80000e7e:	00008517          	auipc	a0,0x8
    80000e82:	25a50513          	addi	a0,a0,602 # 800090d8 <digits+0x98>
    80000e86:	fffff097          	auipc	ra,0xfffff
    80000e8a:	6b8080e7          	jalr	1720(ra) # 8000053e <panic>

0000000080000e8e <memset>:
#include "types.h"

void *
memset(void *dst, int c, uint n)
{
    80000e8e:	1141                	addi	sp,sp,-16
    80000e90:	e422                	sd	s0,8(sp)
    80000e92:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++)
    80000e94:	ca19                	beqz	a2,80000eaa <memset+0x1c>
    80000e96:	87aa                	mv	a5,a0
    80000e98:	1602                	slli	a2,a2,0x20
    80000e9a:	9201                	srli	a2,a2,0x20
    80000e9c:	00a60733          	add	a4,a2,a0
  {
    cdst[i] = c;
    80000ea0:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++)
    80000ea4:	0785                	addi	a5,a5,1
    80000ea6:	fee79de3          	bne	a5,a4,80000ea0 <memset+0x12>
  }
  return dst;
}
    80000eaa:	6422                	ld	s0,8(sp)
    80000eac:	0141                	addi	sp,sp,16
    80000eae:	8082                	ret

0000000080000eb0 <memcmp>:

int memcmp(const void *v1, const void *v2, uint n)
{
    80000eb0:	1141                	addi	sp,sp,-16
    80000eb2:	e422                	sd	s0,8(sp)
    80000eb4:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0)
    80000eb6:	ca05                	beqz	a2,80000ee6 <memcmp+0x36>
    80000eb8:	fff6069b          	addiw	a3,a2,-1
    80000ebc:	1682                	slli	a3,a3,0x20
    80000ebe:	9281                	srli	a3,a3,0x20
    80000ec0:	0685                	addi	a3,a3,1
    80000ec2:	96aa                	add	a3,a3,a0
  {
    if (*s1 != *s2)
    80000ec4:	00054783          	lbu	a5,0(a0)
    80000ec8:	0005c703          	lbu	a4,0(a1)
    80000ecc:	00e79863          	bne	a5,a4,80000edc <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000ed0:	0505                	addi	a0,a0,1
    80000ed2:	0585                	addi	a1,a1,1
  while (n-- > 0)
    80000ed4:	fed518e3          	bne	a0,a3,80000ec4 <memcmp+0x14>
  }

  return 0;
    80000ed8:	4501                	li	a0,0
    80000eda:	a019                	j	80000ee0 <memcmp+0x30>
      return *s1 - *s2;
    80000edc:	40e7853b          	subw	a0,a5,a4
}
    80000ee0:	6422                	ld	s0,8(sp)
    80000ee2:	0141                	addi	sp,sp,16
    80000ee4:	8082                	ret
  return 0;
    80000ee6:	4501                	li	a0,0
    80000ee8:	bfe5                	j	80000ee0 <memcmp+0x30>

0000000080000eea <memmove>:

void *
memmove(void *dst, const void *src, uint n)
{
    80000eea:	1141                	addi	sp,sp,-16
    80000eec:	e422                	sd	s0,8(sp)
    80000eee:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0)
    80000ef0:	c205                	beqz	a2,80000f10 <memmove+0x26>
    return dst;

  s = src;
  d = dst;
  if (s < d && s + n > d)
    80000ef2:	02a5e263          	bltu	a1,a0,80000f16 <memmove+0x2c>
    d += n;
    while (n-- > 0)
      *--d = *--s;
  }
  else
    while (n-- > 0)
    80000ef6:	1602                	slli	a2,a2,0x20
    80000ef8:	9201                	srli	a2,a2,0x20
    80000efa:	00c587b3          	add	a5,a1,a2
{
    80000efe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000f00:	0585                	addi	a1,a1,1
    80000f02:	0705                	addi	a4,a4,1
    80000f04:	fff5c683          	lbu	a3,-1(a1)
    80000f08:	fed70fa3          	sb	a3,-1(a4) # fff <_entry-0x7ffff001>
    while (n-- > 0)
    80000f0c:	fef59ae3          	bne	a1,a5,80000f00 <memmove+0x16>

  return dst;
}
    80000f10:	6422                	ld	s0,8(sp)
    80000f12:	0141                	addi	sp,sp,16
    80000f14:	8082                	ret
  if (s < d && s + n > d)
    80000f16:	02061693          	slli	a3,a2,0x20
    80000f1a:	9281                	srli	a3,a3,0x20
    80000f1c:	00d58733          	add	a4,a1,a3
    80000f20:	fce57be3          	bgeu	a0,a4,80000ef6 <memmove+0xc>
    d += n;
    80000f24:	96aa                	add	a3,a3,a0
    while (n-- > 0)
    80000f26:	fff6079b          	addiw	a5,a2,-1
    80000f2a:	1782                	slli	a5,a5,0x20
    80000f2c:	9381                	srli	a5,a5,0x20
    80000f2e:	fff7c793          	not	a5,a5
    80000f32:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000f34:	177d                	addi	a4,a4,-1
    80000f36:	16fd                	addi	a3,a3,-1
    80000f38:	00074603          	lbu	a2,0(a4)
    80000f3c:	00c68023          	sb	a2,0(a3)
    while (n-- > 0)
    80000f40:	fee79ae3          	bne	a5,a4,80000f34 <memmove+0x4a>
    80000f44:	b7f1                	j	80000f10 <memmove+0x26>

0000000080000f46 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *
memcpy(void *dst, const void *src, uint n)
{
    80000f46:	1141                	addi	sp,sp,-16
    80000f48:	e406                	sd	ra,8(sp)
    80000f4a:	e022                	sd	s0,0(sp)
    80000f4c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000f4e:	00000097          	auipc	ra,0x0
    80000f52:	f9c080e7          	jalr	-100(ra) # 80000eea <memmove>
}
    80000f56:	60a2                	ld	ra,8(sp)
    80000f58:	6402                	ld	s0,0(sp)
    80000f5a:	0141                	addi	sp,sp,16
    80000f5c:	8082                	ret

0000000080000f5e <strncmp>:

int strncmp(const char *p, const char *q, uint n)
{
    80000f5e:	1141                	addi	sp,sp,-16
    80000f60:	e422                	sd	s0,8(sp)
    80000f62:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q)
    80000f64:	ce11                	beqz	a2,80000f80 <strncmp+0x22>
    80000f66:	00054783          	lbu	a5,0(a0)
    80000f6a:	cf89                	beqz	a5,80000f84 <strncmp+0x26>
    80000f6c:	0005c703          	lbu	a4,0(a1)
    80000f70:	00f71a63          	bne	a4,a5,80000f84 <strncmp+0x26>
    n--, p++, q++;
    80000f74:	367d                	addiw	a2,a2,-1
    80000f76:	0505                	addi	a0,a0,1
    80000f78:	0585                	addi	a1,a1,1
  while (n > 0 && *p && *p == *q)
    80000f7a:	f675                	bnez	a2,80000f66 <strncmp+0x8>
  if (n == 0)
    return 0;
    80000f7c:	4501                	li	a0,0
    80000f7e:	a809                	j	80000f90 <strncmp+0x32>
    80000f80:	4501                	li	a0,0
    80000f82:	a039                	j	80000f90 <strncmp+0x32>
  if (n == 0)
    80000f84:	ca09                	beqz	a2,80000f96 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000f86:	00054503          	lbu	a0,0(a0)
    80000f8a:	0005c783          	lbu	a5,0(a1)
    80000f8e:	9d1d                	subw	a0,a0,a5
}
    80000f90:	6422                	ld	s0,8(sp)
    80000f92:	0141                	addi	sp,sp,16
    80000f94:	8082                	ret
    return 0;
    80000f96:	4501                	li	a0,0
    80000f98:	bfe5                	j	80000f90 <strncmp+0x32>

0000000080000f9a <strncpy>:

char *
strncpy(char *s, const char *t, int n)
{
    80000f9a:	1141                	addi	sp,sp,-16
    80000f9c:	e422                	sd	s0,8(sp)
    80000f9e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0)
    80000fa0:	872a                	mv	a4,a0
    80000fa2:	8832                	mv	a6,a2
    80000fa4:	367d                	addiw	a2,a2,-1
    80000fa6:	01005963          	blez	a6,80000fb8 <strncpy+0x1e>
    80000faa:	0705                	addi	a4,a4,1
    80000fac:	0005c783          	lbu	a5,0(a1)
    80000fb0:	fef70fa3          	sb	a5,-1(a4)
    80000fb4:	0585                	addi	a1,a1,1
    80000fb6:	f7f5                	bnez	a5,80000fa2 <strncpy+0x8>
    ;
  while (n-- > 0)
    80000fb8:	86ba                	mv	a3,a4
    80000fba:	00c05c63          	blez	a2,80000fd2 <strncpy+0x38>
    *s++ = 0;
    80000fbe:	0685                	addi	a3,a3,1
    80000fc0:	fe068fa3          	sb	zero,-1(a3)
  while (n-- > 0)
    80000fc4:	fff6c793          	not	a5,a3
    80000fc8:	9fb9                	addw	a5,a5,a4
    80000fca:	010787bb          	addw	a5,a5,a6
    80000fce:	fef048e3          	bgtz	a5,80000fbe <strncpy+0x24>
  return os;
}
    80000fd2:	6422                	ld	s0,8(sp)
    80000fd4:	0141                	addi	sp,sp,16
    80000fd6:	8082                	ret

0000000080000fd8 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *
safestrcpy(char *s, const char *t, int n)
{
    80000fd8:	1141                	addi	sp,sp,-16
    80000fda:	e422                	sd	s0,8(sp)
    80000fdc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0)
    80000fde:	02c05363          	blez	a2,80001004 <safestrcpy+0x2c>
    80000fe2:	fff6069b          	addiw	a3,a2,-1
    80000fe6:	1682                	slli	a3,a3,0x20
    80000fe8:	9281                	srli	a3,a3,0x20
    80000fea:	96ae                	add	a3,a3,a1
    80000fec:	87aa                	mv	a5,a0
    return os;
  while (--n > 0 && (*s++ = *t++) != 0)
    80000fee:	00d58963          	beq	a1,a3,80001000 <safestrcpy+0x28>
    80000ff2:	0585                	addi	a1,a1,1
    80000ff4:	0785                	addi	a5,a5,1
    80000ff6:	fff5c703          	lbu	a4,-1(a1)
    80000ffa:	fee78fa3          	sb	a4,-1(a5)
    80000ffe:	fb65                	bnez	a4,80000fee <safestrcpy+0x16>
    ;
  *s = 0;
    80001000:	00078023          	sb	zero,0(a5)
  return os;
}
    80001004:	6422                	ld	s0,8(sp)
    80001006:	0141                	addi	sp,sp,16
    80001008:	8082                	ret

000000008000100a <strlen>:

int strlen(const char *s)
{
    8000100a:	1141                	addi	sp,sp,-16
    8000100c:	e422                	sd	s0,8(sp)
    8000100e:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    80001010:	00054783          	lbu	a5,0(a0)
    80001014:	cf91                	beqz	a5,80001030 <strlen+0x26>
    80001016:	0505                	addi	a0,a0,1
    80001018:	87aa                	mv	a5,a0
    8000101a:	4685                	li	a3,1
    8000101c:	9e89                	subw	a3,a3,a0
    8000101e:	00f6853b          	addw	a0,a3,a5
    80001022:	0785                	addi	a5,a5,1
    80001024:	fff7c703          	lbu	a4,-1(a5)
    80001028:	fb7d                	bnez	a4,8000101e <strlen+0x14>
    ;
  return n;
}
    8000102a:	6422                	ld	s0,8(sp)
    8000102c:	0141                	addi	sp,sp,16
    8000102e:	8082                	ret
  for (n = 0; s[n]; n++)
    80001030:	4501                	li	a0,0
    80001032:	bfe5                	j	8000102a <strlen+0x20>

0000000080001034 <main>:

volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void main()
{
    80001034:	1141                	addi	sp,sp,-16
    80001036:	e406                	sd	ra,8(sp)
    80001038:	e022                	sd	s0,0(sp)
    8000103a:	0800                	addi	s0,sp,16
  if (cpuid() == 0)
    8000103c:	00001097          	auipc	ra,0x1
    80001040:	b86080e7          	jalr	-1146(ra) # 80001bc2 <cpuid>
    __sync_synchronize();
    started = 1;
  }
  else
  {
    while (started == 0)
    80001044:	00009717          	auipc	a4,0x9
    80001048:	b0470713          	addi	a4,a4,-1276 # 80009b48 <started>
  if (cpuid() == 0)
    8000104c:	c139                	beqz	a0,80001092 <main+0x5e>
    while (started == 0)
    8000104e:	431c                	lw	a5,0(a4)
    80001050:	2781                	sext.w	a5,a5
    80001052:	dff5                	beqz	a5,8000104e <main+0x1a>
      ;
    __sync_synchronize();
    80001054:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80001058:	00001097          	auipc	ra,0x1
    8000105c:	b6a080e7          	jalr	-1174(ra) # 80001bc2 <cpuid>
    80001060:	85aa                	mv	a1,a0
    80001062:	00008517          	auipc	a0,0x8
    80001066:	09650513          	addi	a0,a0,150 # 800090f8 <digits+0xb8>
    8000106a:	fffff097          	auipc	ra,0xfffff
    8000106e:	51e080e7          	jalr	1310(ra) # 80000588 <printf>
    kvminithart();  // turn on paging
    80001072:	00000097          	auipc	ra,0x0
    80001076:	0d8080e7          	jalr	216(ra) # 8000114a <kvminithart>
    trapinithart(); // install kernel trap vector
    8000107a:	00002097          	auipc	ra,0x2
    8000107e:	cee080e7          	jalr	-786(ra) # 80002d68 <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    80001082:	00005097          	auipc	ra,0x5
    80001086:	68e080e7          	jalr	1678(ra) # 80006710 <plicinithart>
  }

  scheduler();
    8000108a:	00001097          	auipc	ra,0x1
    8000108e:	158080e7          	jalr	344(ra) # 800021e2 <scheduler>
    consoleinit();
    80001092:	fffff097          	auipc	ra,0xfffff
    80001096:	3be080e7          	jalr	958(ra) # 80000450 <consoleinit>
    printfinit();
    8000109a:	fffff097          	auipc	ra,0xfffff
    8000109e:	6ce080e7          	jalr	1742(ra) # 80000768 <printfinit>
    printf("\n");
    800010a2:	00008517          	auipc	a0,0x8
    800010a6:	06650513          	addi	a0,a0,102 # 80009108 <digits+0xc8>
    800010aa:	fffff097          	auipc	ra,0xfffff
    800010ae:	4de080e7          	jalr	1246(ra) # 80000588 <printf>
    printf("xv6 kernel is booting\n");
    800010b2:	00008517          	auipc	a0,0x8
    800010b6:	02e50513          	addi	a0,a0,46 # 800090e0 <digits+0xa0>
    800010ba:	fffff097          	auipc	ra,0xfffff
    800010be:	4ce080e7          	jalr	1230(ra) # 80000588 <printf>
    printf("\n");
    800010c2:	00008517          	auipc	a0,0x8
    800010c6:	04650513          	addi	a0,a0,70 # 80009108 <digits+0xc8>
    800010ca:	fffff097          	auipc	ra,0xfffff
    800010ce:	4be080e7          	jalr	1214(ra) # 80000588 <printf>
    kinit();            // physical page allocator
    800010d2:	00000097          	auipc	ra,0x0
    800010d6:	aee080e7          	jalr	-1298(ra) # 80000bc0 <kinit>
    kvminit();          // create kernel page table
    800010da:	00000097          	auipc	ra,0x0
    800010de:	326080e7          	jalr	806(ra) # 80001400 <kvminit>
    kvminithart();      // turn on paging
    800010e2:	00000097          	auipc	ra,0x0
    800010e6:	068080e7          	jalr	104(ra) # 8000114a <kvminithart>
    procinit();         // process table
    800010ea:	00001097          	auipc	ra,0x1
    800010ee:	9f8080e7          	jalr	-1544(ra) # 80001ae2 <procinit>
    trapinit();         // trap vectors
    800010f2:	00002097          	auipc	ra,0x2
    800010f6:	c4e080e7          	jalr	-946(ra) # 80002d40 <trapinit>
    trapinithart();     // install kernel trap vector
    800010fa:	00002097          	auipc	ra,0x2
    800010fe:	c6e080e7          	jalr	-914(ra) # 80002d68 <trapinithart>
    plicinit();         // set up interrupt controller
    80001102:	00005097          	auipc	ra,0x5
    80001106:	5f8080e7          	jalr	1528(ra) # 800066fa <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    8000110a:	00005097          	auipc	ra,0x5
    8000110e:	606080e7          	jalr	1542(ra) # 80006710 <plicinithart>
    binit();            // buffer cache
    80001112:	00002097          	auipc	ra,0x2
    80001116:	7a2080e7          	jalr	1954(ra) # 800038b4 <binit>
    iinit();            // inode table
    8000111a:	00003097          	auipc	ra,0x3
    8000111e:	e46080e7          	jalr	-442(ra) # 80003f60 <iinit>
    fileinit();         // file table
    80001122:	00004097          	auipc	ra,0x4
    80001126:	de4080e7          	jalr	-540(ra) # 80004f06 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000112a:	00006097          	auipc	ra,0x6
    8000112e:	b0e080e7          	jalr	-1266(ra) # 80006c38 <virtio_disk_init>
    userinit();         // first user process
    80001132:	00001097          	auipc	ra,0x1
    80001136:	e1c080e7          	jalr	-484(ra) # 80001f4e <userinit>
    __sync_synchronize();
    8000113a:	0ff0000f          	fence
    started = 1;
    8000113e:	4785                	li	a5,1
    80001140:	00009717          	auipc	a4,0x9
    80001144:	a0f72423          	sw	a5,-1528(a4) # 80009b48 <started>
    80001148:	b789                	j	8000108a <main+0x56>

000000008000114a <kvminithart>:
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart()
{
    8000114a:	1141                	addi	sp,sp,-16
    8000114c:	e422                	sd	s0,8(sp)
    8000114e:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80001150:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80001154:	00009797          	auipc	a5,0x9
    80001158:	9fc7b783          	ld	a5,-1540(a5) # 80009b50 <kernel_pagetable>
    8000115c:	83b1                	srli	a5,a5,0xc
    8000115e:	577d                	li	a4,-1
    80001160:	177e                	slli	a4,a4,0x3f
    80001162:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0"
    80001164:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80001168:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000116c:	6422                	ld	s0,8(sp)
    8000116e:	0141                	addi	sp,sp,16
    80001170:	8082                	ret

0000000080001172 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001172:	7139                	addi	sp,sp,-64
    80001174:	fc06                	sd	ra,56(sp)
    80001176:	f822                	sd	s0,48(sp)
    80001178:	f426                	sd	s1,40(sp)
    8000117a:	f04a                	sd	s2,32(sp)
    8000117c:	ec4e                	sd	s3,24(sp)
    8000117e:	e852                	sd	s4,16(sp)
    80001180:	e456                	sd	s5,8(sp)
    80001182:	e05a                	sd	s6,0(sp)
    80001184:	0080                	addi	s0,sp,64
    80001186:	84aa                	mv	s1,a0
    80001188:	89ae                	mv	s3,a1
    8000118a:	8ab2                	mv	s5,a2
  if (va >= MAXVA)
    8000118c:	57fd                	li	a5,-1
    8000118e:	83e9                	srli	a5,a5,0x1a
    80001190:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--)
    80001192:	4b31                	li	s6,12
  if (va >= MAXVA)
    80001194:	04b7f263          	bgeu	a5,a1,800011d8 <walk+0x66>
    panic("walk");
    80001198:	00008517          	auipc	a0,0x8
    8000119c:	f7850513          	addi	a0,a0,-136 # 80009110 <digits+0xd0>
    800011a0:	fffff097          	auipc	ra,0xfffff
    800011a4:	39e080e7          	jalr	926(ra) # 8000053e <panic>
    {
      pagetable = (pagetable_t)PTE2PA(*pte);
    }
    else
    {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    800011a8:	060a8663          	beqz	s5,80001214 <walk+0xa2>
    800011ac:	00000097          	auipc	ra,0x0
    800011b0:	aa2080e7          	jalr	-1374(ra) # 80000c4e <kalloc>
    800011b4:	84aa                	mv	s1,a0
    800011b6:	c529                	beqz	a0,80001200 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800011b8:	6605                	lui	a2,0x1
    800011ba:	4581                	li	a1,0
    800011bc:	00000097          	auipc	ra,0x0
    800011c0:	cd2080e7          	jalr	-814(ra) # 80000e8e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800011c4:	00c4d793          	srli	a5,s1,0xc
    800011c8:	07aa                	slli	a5,a5,0xa
    800011ca:	0017e793          	ori	a5,a5,1
    800011ce:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--)
    800011d2:	3a5d                	addiw	s4,s4,-9
    800011d4:	036a0063          	beq	s4,s6,800011f4 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800011d8:	0149d933          	srl	s2,s3,s4
    800011dc:	1ff97913          	andi	s2,s2,511
    800011e0:	090e                	slli	s2,s2,0x3
    800011e2:	9926                	add	s2,s2,s1
    if (*pte & PTE_V)
    800011e4:	00093483          	ld	s1,0(s2)
    800011e8:	0014f793          	andi	a5,s1,1
    800011ec:	dfd5                	beqz	a5,800011a8 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800011ee:	80a9                	srli	s1,s1,0xa
    800011f0:	04b2                	slli	s1,s1,0xc
    800011f2:	b7c5                	j	800011d2 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800011f4:	00c9d513          	srli	a0,s3,0xc
    800011f8:	1ff57513          	andi	a0,a0,511
    800011fc:	050e                	slli	a0,a0,0x3
    800011fe:	9526                	add	a0,a0,s1
}
    80001200:	70e2                	ld	ra,56(sp)
    80001202:	7442                	ld	s0,48(sp)
    80001204:	74a2                	ld	s1,40(sp)
    80001206:	7902                	ld	s2,32(sp)
    80001208:	69e2                	ld	s3,24(sp)
    8000120a:	6a42                	ld	s4,16(sp)
    8000120c:	6aa2                	ld	s5,8(sp)
    8000120e:	6b02                	ld	s6,0(sp)
    80001210:	6121                	addi	sp,sp,64
    80001212:	8082                	ret
        return 0;
    80001214:	4501                	li	a0,0
    80001216:	b7ed                	j	80001200 <walk+0x8e>

0000000080001218 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    80001218:	57fd                	li	a5,-1
    8000121a:	83e9                	srli	a5,a5,0x1a
    8000121c:	00b7f463          	bgeu	a5,a1,80001224 <walkaddr+0xc>
    return 0;
    80001220:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001222:	8082                	ret
{
    80001224:	1141                	addi	sp,sp,-16
    80001226:	e406                	sd	ra,8(sp)
    80001228:	e022                	sd	s0,0(sp)
    8000122a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000122c:	4601                	li	a2,0
    8000122e:	00000097          	auipc	ra,0x0
    80001232:	f44080e7          	jalr	-188(ra) # 80001172 <walk>
  if (pte == 0)
    80001236:	c105                	beqz	a0,80001256 <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0)
    80001238:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    8000123a:	0117f693          	andi	a3,a5,17
    8000123e:	4745                	li	a4,17
    return 0;
    80001240:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    80001242:	00e68663          	beq	a3,a4,8000124e <walkaddr+0x36>
}
    80001246:	60a2                	ld	ra,8(sp)
    80001248:	6402                	ld	s0,0(sp)
    8000124a:	0141                	addi	sp,sp,16
    8000124c:	8082                	ret
  pa = PTE2PA(*pte);
    8000124e:	00a7d513          	srli	a0,a5,0xa
    80001252:	0532                	slli	a0,a0,0xc
  return pa;
    80001254:	bfcd                	j	80001246 <walkaddr+0x2e>
    return 0;
    80001256:	4501                	li	a0,0
    80001258:	b7fd                	j	80001246 <walkaddr+0x2e>

000000008000125a <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000125a:	715d                	addi	sp,sp,-80
    8000125c:	e486                	sd	ra,72(sp)
    8000125e:	e0a2                	sd	s0,64(sp)
    80001260:	fc26                	sd	s1,56(sp)
    80001262:	f84a                	sd	s2,48(sp)
    80001264:	f44e                	sd	s3,40(sp)
    80001266:	f052                	sd	s4,32(sp)
    80001268:	ec56                	sd	s5,24(sp)
    8000126a:	e85a                	sd	s6,16(sp)
    8000126c:	e45e                	sd	s7,8(sp)
    8000126e:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if (size == 0)
    80001270:	c639                	beqz	a2,800012be <mappages+0x64>
    80001272:	8aaa                	mv	s5,a0
    80001274:	8b3a                	mv	s6,a4
    panic("mappages: size");

  a = PGROUNDDOWN(va);
    80001276:	77fd                	lui	a5,0xfffff
    80001278:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000127c:	15fd                	addi	a1,a1,-1
    8000127e:	00c589b3          	add	s3,a1,a2
    80001282:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80001286:	8952                	mv	s2,s4
    80001288:	41468a33          	sub	s4,a3,s4
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    8000128c:	6b85                	lui	s7,0x1
    8000128e:	012a04b3          	add	s1,s4,s2
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001292:	4605                	li	a2,1
    80001294:	85ca                	mv	a1,s2
    80001296:	8556                	mv	a0,s5
    80001298:	00000097          	auipc	ra,0x0
    8000129c:	eda080e7          	jalr	-294(ra) # 80001172 <walk>
    800012a0:	cd1d                	beqz	a0,800012de <mappages+0x84>
    if (*pte & PTE_V)
    800012a2:	611c                	ld	a5,0(a0)
    800012a4:	8b85                	andi	a5,a5,1
    800012a6:	e785                	bnez	a5,800012ce <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800012a8:	80b1                	srli	s1,s1,0xc
    800012aa:	04aa                	slli	s1,s1,0xa
    800012ac:	0164e4b3          	or	s1,s1,s6
    800012b0:	0014e493          	ori	s1,s1,1
    800012b4:	e104                	sd	s1,0(a0)
    if (a == last)
    800012b6:	05390063          	beq	s2,s3,800012f6 <mappages+0x9c>
    a += PGSIZE;
    800012ba:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    800012bc:	bfc9                	j	8000128e <mappages+0x34>
    panic("mappages: size");
    800012be:	00008517          	auipc	a0,0x8
    800012c2:	e5a50513          	addi	a0,a0,-422 # 80009118 <digits+0xd8>
    800012c6:	fffff097          	auipc	ra,0xfffff
    800012ca:	278080e7          	jalr	632(ra) # 8000053e <panic>
      panic("mappages: remap");
    800012ce:	00008517          	auipc	a0,0x8
    800012d2:	e5a50513          	addi	a0,a0,-422 # 80009128 <digits+0xe8>
    800012d6:	fffff097          	auipc	ra,0xfffff
    800012da:	268080e7          	jalr	616(ra) # 8000053e <panic>
      return -1;
    800012de:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800012e0:	60a6                	ld	ra,72(sp)
    800012e2:	6406                	ld	s0,64(sp)
    800012e4:	74e2                	ld	s1,56(sp)
    800012e6:	7942                	ld	s2,48(sp)
    800012e8:	79a2                	ld	s3,40(sp)
    800012ea:	7a02                	ld	s4,32(sp)
    800012ec:	6ae2                	ld	s5,24(sp)
    800012ee:	6b42                	ld	s6,16(sp)
    800012f0:	6ba2                	ld	s7,8(sp)
    800012f2:	6161                	addi	sp,sp,80
    800012f4:	8082                	ret
  return 0;
    800012f6:	4501                	li	a0,0
    800012f8:	b7e5                	j	800012e0 <mappages+0x86>

00000000800012fa <kvmmap>:
{
    800012fa:	1141                	addi	sp,sp,-16
    800012fc:	e406                	sd	ra,8(sp)
    800012fe:	e022                	sd	s0,0(sp)
    80001300:	0800                	addi	s0,sp,16
    80001302:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001304:	86b2                	mv	a3,a2
    80001306:	863e                	mv	a2,a5
    80001308:	00000097          	auipc	ra,0x0
    8000130c:	f52080e7          	jalr	-174(ra) # 8000125a <mappages>
    80001310:	e509                	bnez	a0,8000131a <kvmmap+0x20>
}
    80001312:	60a2                	ld	ra,8(sp)
    80001314:	6402                	ld	s0,0(sp)
    80001316:	0141                	addi	sp,sp,16
    80001318:	8082                	ret
    panic("kvmmap");
    8000131a:	00008517          	auipc	a0,0x8
    8000131e:	e1e50513          	addi	a0,a0,-482 # 80009138 <digits+0xf8>
    80001322:	fffff097          	auipc	ra,0xfffff
    80001326:	21c080e7          	jalr	540(ra) # 8000053e <panic>

000000008000132a <kvmmake>:
{
    8000132a:	1101                	addi	sp,sp,-32
    8000132c:	ec06                	sd	ra,24(sp)
    8000132e:	e822                	sd	s0,16(sp)
    80001330:	e426                	sd	s1,8(sp)
    80001332:	e04a                	sd	s2,0(sp)
    80001334:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    80001336:	00000097          	auipc	ra,0x0
    8000133a:	918080e7          	jalr	-1768(ra) # 80000c4e <kalloc>
    8000133e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001340:	6605                	lui	a2,0x1
    80001342:	4581                	li	a1,0
    80001344:	00000097          	auipc	ra,0x0
    80001348:	b4a080e7          	jalr	-1206(ra) # 80000e8e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000134c:	4719                	li	a4,6
    8000134e:	6685                	lui	a3,0x1
    80001350:	10000637          	lui	a2,0x10000
    80001354:	100005b7          	lui	a1,0x10000
    80001358:	8526                	mv	a0,s1
    8000135a:	00000097          	auipc	ra,0x0
    8000135e:	fa0080e7          	jalr	-96(ra) # 800012fa <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001362:	4719                	li	a4,6
    80001364:	6685                	lui	a3,0x1
    80001366:	10001637          	lui	a2,0x10001
    8000136a:	100015b7          	lui	a1,0x10001
    8000136e:	8526                	mv	a0,s1
    80001370:	00000097          	auipc	ra,0x0
    80001374:	f8a080e7          	jalr	-118(ra) # 800012fa <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001378:	4719                	li	a4,6
    8000137a:	004006b7          	lui	a3,0x400
    8000137e:	0c000637          	lui	a2,0xc000
    80001382:	0c0005b7          	lui	a1,0xc000
    80001386:	8526                	mv	a0,s1
    80001388:	00000097          	auipc	ra,0x0
    8000138c:	f72080e7          	jalr	-142(ra) # 800012fa <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    80001390:	00008917          	auipc	s2,0x8
    80001394:	c7090913          	addi	s2,s2,-912 # 80009000 <etext>
    80001398:	4729                	li	a4,10
    8000139a:	80008697          	auipc	a3,0x80008
    8000139e:	c6668693          	addi	a3,a3,-922 # 9000 <_entry-0x7fff7000>
    800013a2:	4605                	li	a2,1
    800013a4:	067e                	slli	a2,a2,0x1f
    800013a6:	85b2                	mv	a1,a2
    800013a8:	8526                	mv	a0,s1
    800013aa:	00000097          	auipc	ra,0x0
    800013ae:	f50080e7          	jalr	-176(ra) # 800012fa <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
    800013b2:	4719                	li	a4,6
    800013b4:	46c5                	li	a3,17
    800013b6:	06ee                	slli	a3,a3,0x1b
    800013b8:	412686b3          	sub	a3,a3,s2
    800013bc:	864a                	mv	a2,s2
    800013be:	85ca                	mv	a1,s2
    800013c0:	8526                	mv	a0,s1
    800013c2:	00000097          	auipc	ra,0x0
    800013c6:	f38080e7          	jalr	-200(ra) # 800012fa <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800013ca:	4729                	li	a4,10
    800013cc:	6685                	lui	a3,0x1
    800013ce:	00007617          	auipc	a2,0x7
    800013d2:	c3260613          	addi	a2,a2,-974 # 80008000 <_trampoline>
    800013d6:	040005b7          	lui	a1,0x4000
    800013da:	15fd                	addi	a1,a1,-1
    800013dc:	05b2                	slli	a1,a1,0xc
    800013de:	8526                	mv	a0,s1
    800013e0:	00000097          	auipc	ra,0x0
    800013e4:	f1a080e7          	jalr	-230(ra) # 800012fa <kvmmap>
  proc_mapstacks(kpgtbl);
    800013e8:	8526                	mv	a0,s1
    800013ea:	00000097          	auipc	ra,0x0
    800013ee:	662080e7          	jalr	1634(ra) # 80001a4c <proc_mapstacks>
}
    800013f2:	8526                	mv	a0,s1
    800013f4:	60e2                	ld	ra,24(sp)
    800013f6:	6442                	ld	s0,16(sp)
    800013f8:	64a2                	ld	s1,8(sp)
    800013fa:	6902                	ld	s2,0(sp)
    800013fc:	6105                	addi	sp,sp,32
    800013fe:	8082                	ret

0000000080001400 <kvminit>:
{
    80001400:	1141                	addi	sp,sp,-16
    80001402:	e406                	sd	ra,8(sp)
    80001404:	e022                	sd	s0,0(sp)
    80001406:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001408:	00000097          	auipc	ra,0x0
    8000140c:	f22080e7          	jalr	-222(ra) # 8000132a <kvmmake>
    80001410:	00008797          	auipc	a5,0x8
    80001414:	74a7b023          	sd	a0,1856(a5) # 80009b50 <kernel_pagetable>
}
    80001418:	60a2                	ld	ra,8(sp)
    8000141a:	6402                	ld	s0,0(sp)
    8000141c:	0141                	addi	sp,sp,16
    8000141e:	8082                	ret

0000000080001420 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001420:	715d                	addi	sp,sp,-80
    80001422:	e486                	sd	ra,72(sp)
    80001424:	e0a2                	sd	s0,64(sp)
    80001426:	fc26                	sd	s1,56(sp)
    80001428:	f84a                	sd	s2,48(sp)
    8000142a:	f44e                	sd	s3,40(sp)
    8000142c:	f052                	sd	s4,32(sp)
    8000142e:	ec56                	sd	s5,24(sp)
    80001430:	e85a                	sd	s6,16(sp)
    80001432:	e45e                	sd	s7,8(sp)
    80001434:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    80001436:	03459793          	slli	a5,a1,0x34
    8000143a:	e795                	bnez	a5,80001466 <uvmunmap+0x46>
    8000143c:	8a2a                	mv	s4,a0
    8000143e:	892e                	mv	s2,a1
    80001440:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80001442:	0632                	slli	a2,a2,0xc
    80001444:	00b609b3          	add	s3,a2,a1
  {
    if ((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V)
    80001448:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    8000144a:	6b05                	lui	s6,0x1
    8000144c:	0735e263          	bltu	a1,s3,800014b0 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
  }
}
    80001450:	60a6                	ld	ra,72(sp)
    80001452:	6406                	ld	s0,64(sp)
    80001454:	74e2                	ld	s1,56(sp)
    80001456:	7942                	ld	s2,48(sp)
    80001458:	79a2                	ld	s3,40(sp)
    8000145a:	7a02                	ld	s4,32(sp)
    8000145c:	6ae2                	ld	s5,24(sp)
    8000145e:	6b42                	ld	s6,16(sp)
    80001460:	6ba2                	ld	s7,8(sp)
    80001462:	6161                	addi	sp,sp,80
    80001464:	8082                	ret
    panic("uvmunmap: not aligned");
    80001466:	00008517          	auipc	a0,0x8
    8000146a:	cda50513          	addi	a0,a0,-806 # 80009140 <digits+0x100>
    8000146e:	fffff097          	auipc	ra,0xfffff
    80001472:	0d0080e7          	jalr	208(ra) # 8000053e <panic>
      panic("uvmunmap: walk");
    80001476:	00008517          	auipc	a0,0x8
    8000147a:	ce250513          	addi	a0,a0,-798 # 80009158 <digits+0x118>
    8000147e:	fffff097          	auipc	ra,0xfffff
    80001482:	0c0080e7          	jalr	192(ra) # 8000053e <panic>
      panic("uvmunmap: not mapped");
    80001486:	00008517          	auipc	a0,0x8
    8000148a:	ce250513          	addi	a0,a0,-798 # 80009168 <digits+0x128>
    8000148e:	fffff097          	auipc	ra,0xfffff
    80001492:	0b0080e7          	jalr	176(ra) # 8000053e <panic>
      panic("uvmunmap: not a leaf");
    80001496:	00008517          	auipc	a0,0x8
    8000149a:	cea50513          	addi	a0,a0,-790 # 80009180 <digits+0x140>
    8000149e:	fffff097          	auipc	ra,0xfffff
    800014a2:	0a0080e7          	jalr	160(ra) # 8000053e <panic>
    *pte = 0;
    800014a6:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    800014aa:	995a                	add	s2,s2,s6
    800014ac:	fb3972e3          	bgeu	s2,s3,80001450 <uvmunmap+0x30>
    if ((pte = walk(pagetable, a, 0)) == 0)
    800014b0:	4601                	li	a2,0
    800014b2:	85ca                	mv	a1,s2
    800014b4:	8552                	mv	a0,s4
    800014b6:	00000097          	auipc	ra,0x0
    800014ba:	cbc080e7          	jalr	-836(ra) # 80001172 <walk>
    800014be:	84aa                	mv	s1,a0
    800014c0:	d95d                	beqz	a0,80001476 <uvmunmap+0x56>
    if ((*pte & PTE_V) == 0)
    800014c2:	6108                	ld	a0,0(a0)
    800014c4:	00157793          	andi	a5,a0,1
    800014c8:	dfdd                	beqz	a5,80001486 <uvmunmap+0x66>
    if (PTE_FLAGS(*pte) == PTE_V)
    800014ca:	3ff57793          	andi	a5,a0,1023
    800014ce:	fd7784e3          	beq	a5,s7,80001496 <uvmunmap+0x76>
    if (do_free)
    800014d2:	fc0a8ae3          	beqz	s5,800014a6 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800014d6:	8129                	srli	a0,a0,0xa
      kfree((void *)pa);
    800014d8:	0532                	slli	a0,a0,0xc
    800014da:	fffff097          	auipc	ra,0xfffff
    800014de:	59c080e7          	jalr	1436(ra) # 80000a76 <kfree>
    800014e2:	b7d1                	j	800014a6 <uvmunmap+0x86>

00000000800014e4 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800014e4:	1101                	addi	sp,sp,-32
    800014e6:	ec06                	sd	ra,24(sp)
    800014e8:	e822                	sd	s0,16(sp)
    800014ea:	e426                	sd	s1,8(sp)
    800014ec:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800014ee:	fffff097          	auipc	ra,0xfffff
    800014f2:	760080e7          	jalr	1888(ra) # 80000c4e <kalloc>
    800014f6:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800014f8:	c519                	beqz	a0,80001506 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800014fa:	6605                	lui	a2,0x1
    800014fc:	4581                	li	a1,0
    800014fe:	00000097          	auipc	ra,0x0
    80001502:	990080e7          	jalr	-1648(ra) # 80000e8e <memset>
  return pagetable;
}
    80001506:	8526                	mv	a0,s1
    80001508:	60e2                	ld	ra,24(sp)
    8000150a:	6442                	ld	s0,16(sp)
    8000150c:	64a2                	ld	s1,8(sp)
    8000150e:	6105                	addi	sp,sp,32
    80001510:	8082                	ret

0000000080001512 <uvmfirst>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001512:	7179                	addi	sp,sp,-48
    80001514:	f406                	sd	ra,40(sp)
    80001516:	f022                	sd	s0,32(sp)
    80001518:	ec26                	sd	s1,24(sp)
    8000151a:	e84a                	sd	s2,16(sp)
    8000151c:	e44e                	sd	s3,8(sp)
    8000151e:	e052                	sd	s4,0(sp)
    80001520:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE)
    80001522:	6785                	lui	a5,0x1
    80001524:	04f67863          	bgeu	a2,a5,80001574 <uvmfirst+0x62>
    80001528:	8a2a                	mv	s4,a0
    8000152a:	89ae                	mv	s3,a1
    8000152c:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000152e:	fffff097          	auipc	ra,0xfffff
    80001532:	720080e7          	jalr	1824(ra) # 80000c4e <kalloc>
    80001536:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001538:	6605                	lui	a2,0x1
    8000153a:	4581                	li	a1,0
    8000153c:	00000097          	auipc	ra,0x0
    80001540:	952080e7          	jalr	-1710(ra) # 80000e8e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    80001544:	4779                	li	a4,30
    80001546:	86ca                	mv	a3,s2
    80001548:	6605                	lui	a2,0x1
    8000154a:	4581                	li	a1,0
    8000154c:	8552                	mv	a0,s4
    8000154e:	00000097          	auipc	ra,0x0
    80001552:	d0c080e7          	jalr	-756(ra) # 8000125a <mappages>
  memmove(mem, src, sz);
    80001556:	8626                	mv	a2,s1
    80001558:	85ce                	mv	a1,s3
    8000155a:	854a                	mv	a0,s2
    8000155c:	00000097          	auipc	ra,0x0
    80001560:	98e080e7          	jalr	-1650(ra) # 80000eea <memmove>
}
    80001564:	70a2                	ld	ra,40(sp)
    80001566:	7402                	ld	s0,32(sp)
    80001568:	64e2                	ld	s1,24(sp)
    8000156a:	6942                	ld	s2,16(sp)
    8000156c:	69a2                	ld	s3,8(sp)
    8000156e:	6a02                	ld	s4,0(sp)
    80001570:	6145                	addi	sp,sp,48
    80001572:	8082                	ret
    panic("uvmfirst: more than a page");
    80001574:	00008517          	auipc	a0,0x8
    80001578:	c2450513          	addi	a0,a0,-988 # 80009198 <digits+0x158>
    8000157c:	fffff097          	auipc	ra,0xfffff
    80001580:	fc2080e7          	jalr	-62(ra) # 8000053e <panic>

0000000080001584 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001584:	1101                	addi	sp,sp,-32
    80001586:	ec06                	sd	ra,24(sp)
    80001588:	e822                	sd	s0,16(sp)
    8000158a:	e426                	sd	s1,8(sp)
    8000158c:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    8000158e:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    80001590:	00b67d63          	bgeu	a2,a1,800015aa <uvmdealloc+0x26>
    80001594:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz))
    80001596:	6785                	lui	a5,0x1
    80001598:	17fd                	addi	a5,a5,-1
    8000159a:	00f60733          	add	a4,a2,a5
    8000159e:	767d                	lui	a2,0xfffff
    800015a0:	8f71                	and	a4,a4,a2
    800015a2:	97ae                	add	a5,a5,a1
    800015a4:	8ff1                	and	a5,a5,a2
    800015a6:	00f76863          	bltu	a4,a5,800015b6 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800015aa:	8526                	mv	a0,s1
    800015ac:	60e2                	ld	ra,24(sp)
    800015ae:	6442                	ld	s0,16(sp)
    800015b0:	64a2                	ld	s1,8(sp)
    800015b2:	6105                	addi	sp,sp,32
    800015b4:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800015b6:	8f99                	sub	a5,a5,a4
    800015b8:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800015ba:	4685                	li	a3,1
    800015bc:	0007861b          	sext.w	a2,a5
    800015c0:	85ba                	mv	a1,a4
    800015c2:	00000097          	auipc	ra,0x0
    800015c6:	e5e080e7          	jalr	-418(ra) # 80001420 <uvmunmap>
    800015ca:	b7c5                	j	800015aa <uvmdealloc+0x26>

00000000800015cc <uvmalloc>:
  if (newsz < oldsz)
    800015cc:	0ab66563          	bltu	a2,a1,80001676 <uvmalloc+0xaa>
{
    800015d0:	7139                	addi	sp,sp,-64
    800015d2:	fc06                	sd	ra,56(sp)
    800015d4:	f822                	sd	s0,48(sp)
    800015d6:	f426                	sd	s1,40(sp)
    800015d8:	f04a                	sd	s2,32(sp)
    800015da:	ec4e                	sd	s3,24(sp)
    800015dc:	e852                	sd	s4,16(sp)
    800015de:	e456                	sd	s5,8(sp)
    800015e0:	e05a                	sd	s6,0(sp)
    800015e2:	0080                	addi	s0,sp,64
    800015e4:	8aaa                	mv	s5,a0
    800015e6:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800015e8:	6985                	lui	s3,0x1
    800015ea:	19fd                	addi	s3,s3,-1
    800015ec:	95ce                	add	a1,a1,s3
    800015ee:	79fd                	lui	s3,0xfffff
    800015f0:	0135f9b3          	and	s3,a1,s3
  for (a = oldsz; a < newsz; a += PGSIZE)
    800015f4:	08c9f363          	bgeu	s3,a2,8000167a <uvmalloc+0xae>
    800015f8:	894e                	mv	s2,s3
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) != 0)
    800015fa:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800015fe:	fffff097          	auipc	ra,0xfffff
    80001602:	650080e7          	jalr	1616(ra) # 80000c4e <kalloc>
    80001606:	84aa                	mv	s1,a0
    if (mem == 0)
    80001608:	c51d                	beqz	a0,80001636 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    8000160a:	6605                	lui	a2,0x1
    8000160c:	4581                	li	a1,0
    8000160e:	00000097          	auipc	ra,0x0
    80001612:	880080e7          	jalr	-1920(ra) # 80000e8e <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) != 0)
    80001616:	875a                	mv	a4,s6
    80001618:	86a6                	mv	a3,s1
    8000161a:	6605                	lui	a2,0x1
    8000161c:	85ca                	mv	a1,s2
    8000161e:	8556                	mv	a0,s5
    80001620:	00000097          	auipc	ra,0x0
    80001624:	c3a080e7          	jalr	-966(ra) # 8000125a <mappages>
    80001628:	e90d                	bnez	a0,8000165a <uvmalloc+0x8e>
  for (a = oldsz; a < newsz; a += PGSIZE)
    8000162a:	6785                	lui	a5,0x1
    8000162c:	993e                	add	s2,s2,a5
    8000162e:	fd4968e3          	bltu	s2,s4,800015fe <uvmalloc+0x32>
  return newsz;
    80001632:	8552                	mv	a0,s4
    80001634:	a809                	j	80001646 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80001636:	864e                	mv	a2,s3
    80001638:	85ca                	mv	a1,s2
    8000163a:	8556                	mv	a0,s5
    8000163c:	00000097          	auipc	ra,0x0
    80001640:	f48080e7          	jalr	-184(ra) # 80001584 <uvmdealloc>
      return 0;
    80001644:	4501                	li	a0,0
}
    80001646:	70e2                	ld	ra,56(sp)
    80001648:	7442                	ld	s0,48(sp)
    8000164a:	74a2                	ld	s1,40(sp)
    8000164c:	7902                	ld	s2,32(sp)
    8000164e:	69e2                	ld	s3,24(sp)
    80001650:	6a42                	ld	s4,16(sp)
    80001652:	6aa2                	ld	s5,8(sp)
    80001654:	6b02                	ld	s6,0(sp)
    80001656:	6121                	addi	sp,sp,64
    80001658:	8082                	ret
      kfree(mem);
    8000165a:	8526                	mv	a0,s1
    8000165c:	fffff097          	auipc	ra,0xfffff
    80001660:	41a080e7          	jalr	1050(ra) # 80000a76 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001664:	864e                	mv	a2,s3
    80001666:	85ca                	mv	a1,s2
    80001668:	8556                	mv	a0,s5
    8000166a:	00000097          	auipc	ra,0x0
    8000166e:	f1a080e7          	jalr	-230(ra) # 80001584 <uvmdealloc>
      return 0;
    80001672:	4501                	li	a0,0
    80001674:	bfc9                	j	80001646 <uvmalloc+0x7a>
    return oldsz;
    80001676:	852e                	mv	a0,a1
}
    80001678:	8082                	ret
  return newsz;
    8000167a:	8532                	mv	a0,a2
    8000167c:	b7e9                	j	80001646 <uvmalloc+0x7a>

000000008000167e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    8000167e:	7179                	addi	sp,sp,-48
    80001680:	f406                	sd	ra,40(sp)
    80001682:	f022                	sd	s0,32(sp)
    80001684:	ec26                	sd	s1,24(sp)
    80001686:	e84a                	sd	s2,16(sp)
    80001688:	e44e                	sd	s3,8(sp)
    8000168a:	e052                	sd	s4,0(sp)
    8000168c:	1800                	addi	s0,sp,48
    8000168e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++)
    80001690:	84aa                	mv	s1,a0
    80001692:	6905                	lui	s2,0x1
    80001694:	992a                	add	s2,s2,a0
  {
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    80001696:	4985                	li	s3,1
    80001698:	a821                	j	800016b0 <freewalk+0x32>
    {
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000169a:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    8000169c:	0532                	slli	a0,a0,0xc
    8000169e:	00000097          	auipc	ra,0x0
    800016a2:	fe0080e7          	jalr	-32(ra) # 8000167e <freewalk>
      pagetable[i] = 0;
    800016a6:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++)
    800016aa:	04a1                	addi	s1,s1,8
    800016ac:	03248163          	beq	s1,s2,800016ce <freewalk+0x50>
    pte_t pte = pagetable[i];
    800016b0:	6088                	ld	a0,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    800016b2:	00f57793          	andi	a5,a0,15
    800016b6:	ff3782e3          	beq	a5,s3,8000169a <freewalk+0x1c>
    }
    else if (pte & PTE_V)
    800016ba:	8905                	andi	a0,a0,1
    800016bc:	d57d                	beqz	a0,800016aa <freewalk+0x2c>
    {
      panic("freewalk: leaf");
    800016be:	00008517          	auipc	a0,0x8
    800016c2:	afa50513          	addi	a0,a0,-1286 # 800091b8 <digits+0x178>
    800016c6:	fffff097          	auipc	ra,0xfffff
    800016ca:	e78080e7          	jalr	-392(ra) # 8000053e <panic>
    }
  }
  kfree((void *)pagetable);
    800016ce:	8552                	mv	a0,s4
    800016d0:	fffff097          	auipc	ra,0xfffff
    800016d4:	3a6080e7          	jalr	934(ra) # 80000a76 <kfree>
}
    800016d8:	70a2                	ld	ra,40(sp)
    800016da:	7402                	ld	s0,32(sp)
    800016dc:	64e2                	ld	s1,24(sp)
    800016de:	6942                	ld	s2,16(sp)
    800016e0:	69a2                	ld	s3,8(sp)
    800016e2:	6a02                	ld	s4,0(sp)
    800016e4:	6145                	addi	sp,sp,48
    800016e6:	8082                	ret

00000000800016e8 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz)
{
    800016e8:	1101                	addi	sp,sp,-32
    800016ea:	ec06                	sd	ra,24(sp)
    800016ec:	e822                	sd	s0,16(sp)
    800016ee:	e426                	sd	s1,8(sp)
    800016f0:	1000                	addi	s0,sp,32
    800016f2:	84aa                	mv	s1,a0
  if (sz > 0)
    800016f4:	e999                	bnez	a1,8000170a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    800016f6:	8526                	mv	a0,s1
    800016f8:	00000097          	auipc	ra,0x0
    800016fc:	f86080e7          	jalr	-122(ra) # 8000167e <freewalk>
}
    80001700:	60e2                	ld	ra,24(sp)
    80001702:	6442                	ld	s0,16(sp)
    80001704:	64a2                	ld	s1,8(sp)
    80001706:	6105                	addi	sp,sp,32
    80001708:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    8000170a:	6605                	lui	a2,0x1
    8000170c:	167d                	addi	a2,a2,-1
    8000170e:	962e                	add	a2,a2,a1
    80001710:	4685                	li	a3,1
    80001712:	8231                	srli	a2,a2,0xc
    80001714:	4581                	li	a1,0
    80001716:	00000097          	auipc	ra,0x0
    8000171a:	d0a080e7          	jalr	-758(ra) # 80001420 <uvmunmap>
    8000171e:	bfe1                	j	800016f6 <uvmfree+0xe>

0000000080001720 <uvmcowpy>:

int uvmcowpy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80001720:	715d                	addi	sp,sp,-80
    80001722:	e486                	sd	ra,72(sp)
    80001724:	e0a2                	sd	s0,64(sp)
    80001726:	fc26                	sd	s1,56(sp)
    80001728:	f84a                	sd	s2,48(sp)
    8000172a:	f44e                	sd	s3,40(sp)
    8000172c:	f052                	sd	s4,32(sp)
    8000172e:	ec56                	sd	s5,24(sp)
    80001730:	e85a                	sd	s6,16(sp)
    80001732:	e45e                	sd	s7,8(sp)
    80001734:	0880                	addi	s0,sp,80
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for (i = 0; i < sz; i += PGSIZE)
    80001736:	ce5d                	beqz	a2,800017f4 <uvmcowpy+0xd4>
    80001738:	8aaa                	mv	s5,a0
    8000173a:	8a2e                	mv	s4,a1
    8000173c:	89b2                	mv	s3,a2
    8000173e:	4481                	li	s1,0
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if (flags & PTE_W)
    {
      flags = (flags & (~PTE_W)) | PTE_COW;
      *pte = PA2PTE(pa) | flags;
    80001740:	7b7d                	lui	s6,0xfffff
    80001742:	002b5b13          	srli	s6,s6,0x2
    80001746:	a0a1                	j	8000178e <uvmcowpy+0x6e>
      panic("uvmcopy: pte should exist");
    80001748:	00008517          	auipc	a0,0x8
    8000174c:	a8050513          	addi	a0,a0,-1408 # 800091c8 <digits+0x188>
    80001750:	fffff097          	auipc	ra,0xfffff
    80001754:	dee080e7          	jalr	-530(ra) # 8000053e <panic>
      panic("uvmcopy: page not present");
    80001758:	00008517          	auipc	a0,0x8
    8000175c:	a9050513          	addi	a0,a0,-1392 # 800091e8 <digits+0x1a8>
    80001760:	fffff097          	auipc	ra,0xfffff
    80001764:	dde080e7          	jalr	-546(ra) # 8000053e <panic>
    }
    // if ((mem = kalloc()) == 0)
    //   goto err;
    // memmove(mem, (char *)pa, PGSIZE);
    if (mappages(new, i, PGSIZE, (uint64)pa, flags) != 0)
    80001768:	86ca                	mv	a3,s2
    8000176a:	6605                	lui	a2,0x1
    8000176c:	85a6                	mv	a1,s1
    8000176e:	8552                	mv	a0,s4
    80001770:	00000097          	auipc	ra,0x0
    80001774:	aea080e7          	jalr	-1302(ra) # 8000125a <mappages>
    80001778:	8baa                	mv	s7,a0
    8000177a:	e539                	bnez	a0,800017c8 <uvmcowpy+0xa8>
    {
      // kfree(mem);
      goto err;
    }

    increase_pgreference((void *)pa);
    8000177c:	854a                	mv	a0,s2
    8000177e:	fffff097          	auipc	ra,0xfffff
    80001782:	37c080e7          	jalr	892(ra) # 80000afa <increase_pgreference>
  for (i = 0; i < sz; i += PGSIZE)
    80001786:	6785                	lui	a5,0x1
    80001788:	94be                	add	s1,s1,a5
    8000178a:	0534f963          	bgeu	s1,s3,800017dc <uvmcowpy+0xbc>
    if ((pte = walk(old, i, 0)) == 0)
    8000178e:	4601                	li	a2,0
    80001790:	85a6                	mv	a1,s1
    80001792:	8556                	mv	a0,s5
    80001794:	00000097          	auipc	ra,0x0
    80001798:	9de080e7          	jalr	-1570(ra) # 80001172 <walk>
    8000179c:	d555                	beqz	a0,80001748 <uvmcowpy+0x28>
    if ((*pte & PTE_V) == 0)
    8000179e:	611c                	ld	a5,0(a0)
    800017a0:	0017f713          	andi	a4,a5,1
    800017a4:	db55                	beqz	a4,80001758 <uvmcowpy+0x38>
    pa = PTE2PA(*pte);
    800017a6:	00a7d913          	srli	s2,a5,0xa
    800017aa:	0932                	slli	s2,s2,0xc
    flags = PTE_FLAGS(*pte);
    800017ac:	3ff7f713          	andi	a4,a5,1023
    if (flags & PTE_W)
    800017b0:	0047f693          	andi	a3,a5,4
    800017b4:	dad5                	beqz	a3,80001768 <uvmcowpy+0x48>
      flags = (flags & (~PTE_W)) | PTE_COW;
    800017b6:	efb77693          	andi	a3,a4,-261
    800017ba:	1006e713          	ori	a4,a3,256
      *pte = PA2PTE(pa) | flags;
    800017be:	0167f7b3          	and	a5,a5,s6
    800017c2:	8fd9                	or	a5,a5,a4
    800017c4:	e11c                	sd	a5,0(a0)
    800017c6:	b74d                	j	80001768 <uvmcowpy+0x48>
    // }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800017c8:	4685                	li	a3,1
    800017ca:	00c4d613          	srli	a2,s1,0xc
    800017ce:	4581                	li	a1,0
    800017d0:	8552                	mv	a0,s4
    800017d2:	00000097          	auipc	ra,0x0
    800017d6:	c4e080e7          	jalr	-946(ra) # 80001420 <uvmunmap>
  return -1;
    800017da:	5bfd                	li	s7,-1
}
    800017dc:	855e                	mv	a0,s7
    800017de:	60a6                	ld	ra,72(sp)
    800017e0:	6406                	ld	s0,64(sp)
    800017e2:	74e2                	ld	s1,56(sp)
    800017e4:	7942                	ld	s2,48(sp)
    800017e6:	79a2                	ld	s3,40(sp)
    800017e8:	7a02                	ld	s4,32(sp)
    800017ea:	6ae2                	ld	s5,24(sp)
    800017ec:	6b42                	ld	s6,16(sp)
    800017ee:	6ba2                	ld	s7,8(sp)
    800017f0:	6161                	addi	sp,sp,80
    800017f2:	8082                	ret
  return 0;
    800017f4:	4b81                	li	s7,0
    800017f6:	b7dd                	j	800017dc <uvmcowpy+0xbc>

00000000800017f8 <uvmcopy>:
// Copies both the page table and the
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    800017f8:	1141                	addi	sp,sp,-16
    800017fa:	e406                	sd	ra,8(sp)
    800017fc:	e022                	sd	s0,0(sp)
    800017fe:	0800                	addi	s0,sp,16

#ifndef NOCOW
  return uvmcowpy(old, new, sz);
    80001800:	00000097          	auipc	ra,0x0
    80001804:	f20080e7          	jalr	-224(ra) # 80001720 <uvmcowpy>
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
  return -1;
}
    80001808:	60a2                	ld	ra,8(sp)
    8000180a:	6402                	ld	s0,0(sp)
    8000180c:	0141                	addi	sp,sp,16
    8000180e:	8082                	ret

0000000080001810 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va)
{
    80001810:	1141                	addi	sp,sp,-16
    80001812:	e406                	sd	ra,8(sp)
    80001814:	e022                	sd	s0,0(sp)
    80001816:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80001818:	4601                	li	a2,0
    8000181a:	00000097          	auipc	ra,0x0
    8000181e:	958080e7          	jalr	-1704(ra) # 80001172 <walk>
  if (pte == 0)
    80001822:	c901                	beqz	a0,80001832 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001824:	611c                	ld	a5,0(a0)
    80001826:	9bbd                	andi	a5,a5,-17
    80001828:	e11c                	sd	a5,0(a0)
}
    8000182a:	60a2                	ld	ra,8(sp)
    8000182c:	6402                	ld	s0,0(sp)
    8000182e:	0141                	addi	sp,sp,16
    80001830:	8082                	ret
    panic("uvmclear");
    80001832:	00008517          	auipc	a0,0x8
    80001836:	9d650513          	addi	a0,a0,-1578 # 80009208 <digits+0x1c8>
    8000183a:	fffff097          	auipc	ra,0xfffff
    8000183e:	d04080e7          	jalr	-764(ra) # 8000053e <panic>

0000000080001842 <copyout>:
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while (len > 0)
    80001842:	c6c5                	beqz	a3,800018ea <copyout+0xa8>
{
    80001844:	711d                	addi	sp,sp,-96
    80001846:	ec86                	sd	ra,88(sp)
    80001848:	e8a2                	sd	s0,80(sp)
    8000184a:	e4a6                	sd	s1,72(sp)
    8000184c:	e0ca                	sd	s2,64(sp)
    8000184e:	fc4e                	sd	s3,56(sp)
    80001850:	f852                	sd	s4,48(sp)
    80001852:	f456                	sd	s5,40(sp)
    80001854:	f05a                	sd	s6,32(sp)
    80001856:	ec5e                	sd	s7,24(sp)
    80001858:	e862                	sd	s8,16(sp)
    8000185a:	e466                	sd	s9,8(sp)
    8000185c:	1080                	addi	s0,sp,96
    8000185e:	8baa                	mv	s7,a0
    80001860:	8a2e                	mv	s4,a1
    80001862:	8b32                	mv	s6,a2
    80001864:	8ab6                	mv	s5,a3
  {
    va0 = PGROUNDDOWN(dstva);
    80001866:	7cfd                	lui	s9,0xfffff
    }

    if (pa0 == 0)
      return -1;

    n = PGSIZE - (dstva - va0);
    80001868:	6c05                	lui	s8,0x1
    8000186a:	a091                	j	800018ae <copyout+0x6c>
      pgfault(va0, pagetable);
    8000186c:	85de                	mv	a1,s7
    8000186e:	854a                	mv	a0,s2
    80001870:	00001097          	auipc	ra,0x1
    80001874:	798080e7          	jalr	1944(ra) # 80003008 <pgfault>
      pa0 = walkaddr(pagetable, va0);
    80001878:	85ca                	mv	a1,s2
    8000187a:	855e                	mv	a0,s7
    8000187c:	00000097          	auipc	ra,0x0
    80001880:	99c080e7          	jalr	-1636(ra) # 80001218 <walkaddr>
    80001884:	89aa                	mv	s3,a0
    if (pa0 == 0)
    80001886:	e929                	bnez	a0,800018d8 <copyout+0x96>
      return -1;
    80001888:	557d                	li	a0,-1
    8000188a:	a09d                	j	800018f0 <copyout+0xae>
    if (n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000188c:	412a0533          	sub	a0,s4,s2
    80001890:	0004861b          	sext.w	a2,s1
    80001894:	85da                	mv	a1,s6
    80001896:	954e                	add	a0,a0,s3
    80001898:	fffff097          	auipc	ra,0xfffff
    8000189c:	652080e7          	jalr	1618(ra) # 80000eea <memmove>

    len -= n;
    800018a0:	409a8ab3          	sub	s5,s5,s1
    src += n;
    800018a4:	9b26                	add	s6,s6,s1
    dstva = va0 + PGSIZE;
    800018a6:	01890a33          	add	s4,s2,s8
  while (len > 0)
    800018aa:	020a8e63          	beqz	s5,800018e6 <copyout+0xa4>
    va0 = PGROUNDDOWN(dstva);
    800018ae:	019a7933          	and	s2,s4,s9
    pa0 = walkaddr(pagetable, va0);
    800018b2:	85ca                	mv	a1,s2
    800018b4:	855e                	mv	a0,s7
    800018b6:	00000097          	auipc	ra,0x0
    800018ba:	962080e7          	jalr	-1694(ra) # 80001218 <walkaddr>
    800018be:	89aa                	mv	s3,a0
    if (pa0 == 0)
    800018c0:	c51d                	beqz	a0,800018ee <copyout+0xac>
    if (PTE_FLAGS(*(walk(pagetable, va0, 0))) & PTE_COW)
    800018c2:	4601                	li	a2,0
    800018c4:	85ca                	mv	a1,s2
    800018c6:	855e                	mv	a0,s7
    800018c8:	00000097          	auipc	ra,0x0
    800018cc:	8aa080e7          	jalr	-1878(ra) # 80001172 <walk>
    800018d0:	611c                	ld	a5,0(a0)
    800018d2:	1007f793          	andi	a5,a5,256
    800018d6:	fbd9                	bnez	a5,8000186c <copyout+0x2a>
    n = PGSIZE - (dstva - va0);
    800018d8:	414904b3          	sub	s1,s2,s4
    800018dc:	94e2                	add	s1,s1,s8
    if (n > len)
    800018de:	fa9af7e3          	bgeu	s5,s1,8000188c <copyout+0x4a>
    800018e2:	84d6                	mv	s1,s5
    800018e4:	b765                	j	8000188c <copyout+0x4a>
  }
  return 0;
    800018e6:	4501                	li	a0,0
    800018e8:	a021                	j	800018f0 <copyout+0xae>
    800018ea:	4501                	li	a0,0
}
    800018ec:	8082                	ret
      return -1;
    800018ee:	557d                	li	a0,-1
}
    800018f0:	60e6                	ld	ra,88(sp)
    800018f2:	6446                	ld	s0,80(sp)
    800018f4:	64a6                	ld	s1,72(sp)
    800018f6:	6906                	ld	s2,64(sp)
    800018f8:	79e2                	ld	s3,56(sp)
    800018fa:	7a42                	ld	s4,48(sp)
    800018fc:	7aa2                	ld	s5,40(sp)
    800018fe:	7b02                	ld	s6,32(sp)
    80001900:	6be2                	ld	s7,24(sp)
    80001902:	6c42                	ld	s8,16(sp)
    80001904:	6ca2                	ld	s9,8(sp)
    80001906:	6125                	addi	sp,sp,96
    80001908:	8082                	ret

000000008000190a <copyin>:
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while (len > 0)
    8000190a:	caa5                	beqz	a3,8000197a <copyin+0x70>
{
    8000190c:	715d                	addi	sp,sp,-80
    8000190e:	e486                	sd	ra,72(sp)
    80001910:	e0a2                	sd	s0,64(sp)
    80001912:	fc26                	sd	s1,56(sp)
    80001914:	f84a                	sd	s2,48(sp)
    80001916:	f44e                	sd	s3,40(sp)
    80001918:	f052                	sd	s4,32(sp)
    8000191a:	ec56                	sd	s5,24(sp)
    8000191c:	e85a                	sd	s6,16(sp)
    8000191e:	e45e                	sd	s7,8(sp)
    80001920:	e062                	sd	s8,0(sp)
    80001922:	0880                	addi	s0,sp,80
    80001924:	8b2a                	mv	s6,a0
    80001926:	8a2e                	mv	s4,a1
    80001928:	8c32                	mv	s8,a2
    8000192a:	89b6                	mv	s3,a3
  {
    va0 = PGROUNDDOWN(srcva);
    8000192c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000192e:	6a85                	lui	s5,0x1
    80001930:	a01d                	j	80001956 <copyin+0x4c>
    if (n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001932:	018505b3          	add	a1,a0,s8
    80001936:	0004861b          	sext.w	a2,s1
    8000193a:	412585b3          	sub	a1,a1,s2
    8000193e:	8552                	mv	a0,s4
    80001940:	fffff097          	auipc	ra,0xfffff
    80001944:	5aa080e7          	jalr	1450(ra) # 80000eea <memmove>

    len -= n;
    80001948:	409989b3          	sub	s3,s3,s1
    dst += n;
    8000194c:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000194e:	01590c33          	add	s8,s2,s5
  while (len > 0)
    80001952:	02098263          	beqz	s3,80001976 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001956:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000195a:	85ca                	mv	a1,s2
    8000195c:	855a                	mv	a0,s6
    8000195e:	00000097          	auipc	ra,0x0
    80001962:	8ba080e7          	jalr	-1862(ra) # 80001218 <walkaddr>
    if (pa0 == 0)
    80001966:	cd01                	beqz	a0,8000197e <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001968:	418904b3          	sub	s1,s2,s8
    8000196c:	94d6                	add	s1,s1,s5
    if (n > len)
    8000196e:	fc99f2e3          	bgeu	s3,s1,80001932 <copyin+0x28>
    80001972:	84ce                	mv	s1,s3
    80001974:	bf7d                	j	80001932 <copyin+0x28>
  }
  return 0;
    80001976:	4501                	li	a0,0
    80001978:	a021                	j	80001980 <copyin+0x76>
    8000197a:	4501                	li	a0,0
}
    8000197c:	8082                	ret
      return -1;
    8000197e:	557d                	li	a0,-1
}
    80001980:	60a6                	ld	ra,72(sp)
    80001982:	6406                	ld	s0,64(sp)
    80001984:	74e2                	ld	s1,56(sp)
    80001986:	7942                	ld	s2,48(sp)
    80001988:	79a2                	ld	s3,40(sp)
    8000198a:	7a02                	ld	s4,32(sp)
    8000198c:	6ae2                	ld	s5,24(sp)
    8000198e:	6b42                	ld	s6,16(sp)
    80001990:	6ba2                	ld	s7,8(sp)
    80001992:	6c02                	ld	s8,0(sp)
    80001994:	6161                	addi	sp,sp,80
    80001996:	8082                	ret

0000000080001998 <copyinstr>:
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0)
    80001998:	c6c5                	beqz	a3,80001a40 <copyinstr+0xa8>
{
    8000199a:	715d                	addi	sp,sp,-80
    8000199c:	e486                	sd	ra,72(sp)
    8000199e:	e0a2                	sd	s0,64(sp)
    800019a0:	fc26                	sd	s1,56(sp)
    800019a2:	f84a                	sd	s2,48(sp)
    800019a4:	f44e                	sd	s3,40(sp)
    800019a6:	f052                	sd	s4,32(sp)
    800019a8:	ec56                	sd	s5,24(sp)
    800019aa:	e85a                	sd	s6,16(sp)
    800019ac:	e45e                	sd	s7,8(sp)
    800019ae:	0880                	addi	s0,sp,80
    800019b0:	8a2a                	mv	s4,a0
    800019b2:	8b2e                	mv	s6,a1
    800019b4:	8bb2                	mv	s7,a2
    800019b6:	84b6                	mv	s1,a3
  {
    va0 = PGROUNDDOWN(srcva);
    800019b8:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800019ba:	6985                	lui	s3,0x1
    800019bc:	a035                	j	800019e8 <copyinstr+0x50>
    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0)
    {
      if (*p == '\0')
      {
        *dst = '\0';
    800019be:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800019c2:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null)
    800019c4:	0017b793          	seqz	a5,a5
    800019c8:	40f00533          	neg	a0,a5
  }
  else
  {
    return -1;
  }
}
    800019cc:	60a6                	ld	ra,72(sp)
    800019ce:	6406                	ld	s0,64(sp)
    800019d0:	74e2                	ld	s1,56(sp)
    800019d2:	7942                	ld	s2,48(sp)
    800019d4:	79a2                	ld	s3,40(sp)
    800019d6:	7a02                	ld	s4,32(sp)
    800019d8:	6ae2                	ld	s5,24(sp)
    800019da:	6b42                	ld	s6,16(sp)
    800019dc:	6ba2                	ld	s7,8(sp)
    800019de:	6161                	addi	sp,sp,80
    800019e0:	8082                	ret
    srcva = va0 + PGSIZE;
    800019e2:	01390bb3          	add	s7,s2,s3
  while (got_null == 0 && max > 0)
    800019e6:	c8a9                	beqz	s1,80001a38 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    800019e8:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800019ec:	85ca                	mv	a1,s2
    800019ee:	8552                	mv	a0,s4
    800019f0:	00000097          	auipc	ra,0x0
    800019f4:	828080e7          	jalr	-2008(ra) # 80001218 <walkaddr>
    if (pa0 == 0)
    800019f8:	c131                	beqz	a0,80001a3c <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800019fa:	41790833          	sub	a6,s2,s7
    800019fe:	984e                	add	a6,a6,s3
    if (n > max)
    80001a00:	0104f363          	bgeu	s1,a6,80001a06 <copyinstr+0x6e>
    80001a04:	8826                	mv	a6,s1
    char *p = (char *)(pa0 + (srcva - va0));
    80001a06:	955e                	add	a0,a0,s7
    80001a08:	41250533          	sub	a0,a0,s2
    while (n > 0)
    80001a0c:	fc080be3          	beqz	a6,800019e2 <copyinstr+0x4a>
    80001a10:	985a                	add	a6,a6,s6
    80001a12:	87da                	mv	a5,s6
      if (*p == '\0')
    80001a14:	41650633          	sub	a2,a0,s6
    80001a18:	14fd                	addi	s1,s1,-1
    80001a1a:	9b26                	add	s6,s6,s1
    80001a1c:	00f60733          	add	a4,a2,a5
    80001a20:	00074703          	lbu	a4,0(a4)
    80001a24:	df49                	beqz	a4,800019be <copyinstr+0x26>
        *dst = *p;
    80001a26:	00e78023          	sb	a4,0(a5)
      --max;
    80001a2a:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80001a2e:	0785                	addi	a5,a5,1
    while (n > 0)
    80001a30:	ff0796e3          	bne	a5,a6,80001a1c <copyinstr+0x84>
      dst++;
    80001a34:	8b42                	mv	s6,a6
    80001a36:	b775                	j	800019e2 <copyinstr+0x4a>
    80001a38:	4781                	li	a5,0
    80001a3a:	b769                	j	800019c4 <copyinstr+0x2c>
      return -1;
    80001a3c:	557d                	li	a0,-1
    80001a3e:	b779                	j	800019cc <copyinstr+0x34>
  int got_null = 0;
    80001a40:	4781                	li	a5,0
  if (got_null)
    80001a42:	0017b793          	seqz	a5,a5
    80001a46:	40f00533          	neg	a0,a5
}
    80001a4a:	8082                	ret

0000000080001a4c <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80001a4c:	7139                	addi	sp,sp,-64
    80001a4e:	fc06                	sd	ra,56(sp)
    80001a50:	f822                	sd	s0,48(sp)
    80001a52:	f426                	sd	s1,40(sp)
    80001a54:	f04a                	sd	s2,32(sp)
    80001a56:	ec4e                	sd	s3,24(sp)
    80001a58:	e852                	sd	s4,16(sp)
    80001a5a:	e456                	sd	s5,8(sp)
    80001a5c:	e05a                	sd	s6,0(sp)
    80001a5e:	0080                	addi	s0,sp,64
    80001a60:	89aa                	mv	s3,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80001a62:	00230497          	auipc	s1,0x230
    80001a66:	7b648493          	addi	s1,s1,1974 # 80232218 <proc>
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80001a6a:	8b26                	mv	s6,s1
    80001a6c:	00007a97          	auipc	s5,0x7
    80001a70:	594a8a93          	addi	s5,s5,1428 # 80009000 <etext>
    80001a74:	04000937          	lui	s2,0x4000
    80001a78:	197d                	addi	s2,s2,-1
    80001a7a:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001a7c:	00237a17          	auipc	s4,0x237
    80001a80:	79ca0a13          	addi	s4,s4,1948 # 80239218 <mlfq>
    char *pa = kalloc();
    80001a84:	fffff097          	auipc	ra,0xfffff
    80001a88:	1ca080e7          	jalr	458(ra) # 80000c4e <kalloc>
    80001a8c:	862a                	mv	a2,a0
    if (pa == 0)
    80001a8e:	c131                	beqz	a0,80001ad2 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int)(p - proc));
    80001a90:	416485b3          	sub	a1,s1,s6
    80001a94:	8599                	srai	a1,a1,0x6
    80001a96:	000ab783          	ld	a5,0(s5)
    80001a9a:	02f585b3          	mul	a1,a1,a5
    80001a9e:	2585                	addiw	a1,a1,1
    80001aa0:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001aa4:	4719                	li	a4,6
    80001aa6:	6685                	lui	a3,0x1
    80001aa8:	40b905b3          	sub	a1,s2,a1
    80001aac:	854e                	mv	a0,s3
    80001aae:	00000097          	auipc	ra,0x0
    80001ab2:	84c080e7          	jalr	-1972(ra) # 800012fa <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++)
    80001ab6:	1c048493          	addi	s1,s1,448
    80001aba:	fd4495e3          	bne	s1,s4,80001a84 <proc_mapstacks+0x38>
  }
}
    80001abe:	70e2                	ld	ra,56(sp)
    80001ac0:	7442                	ld	s0,48(sp)
    80001ac2:	74a2                	ld	s1,40(sp)
    80001ac4:	7902                	ld	s2,32(sp)
    80001ac6:	69e2                	ld	s3,24(sp)
    80001ac8:	6a42                	ld	s4,16(sp)
    80001aca:	6aa2                	ld	s5,8(sp)
    80001acc:	6b02                	ld	s6,0(sp)
    80001ace:	6121                	addi	sp,sp,64
    80001ad0:	8082                	ret
      panic("kalloc");
    80001ad2:	00007517          	auipc	a0,0x7
    80001ad6:	74650513          	addi	a0,a0,1862 # 80009218 <digits+0x1d8>
    80001ada:	fffff097          	auipc	ra,0xfffff
    80001ade:	a64080e7          	jalr	-1436(ra) # 8000053e <panic>

0000000080001ae2 <procinit>:

// initialize the proc table.
void procinit(void)
{
    80001ae2:	7139                	addi	sp,sp,-64
    80001ae4:	fc06                	sd	ra,56(sp)
    80001ae6:	f822                	sd	s0,48(sp)
    80001ae8:	f426                	sd	s1,40(sp)
    80001aea:	f04a                	sd	s2,32(sp)
    80001aec:	ec4e                	sd	s3,24(sp)
    80001aee:	e852                	sd	s4,16(sp)
    80001af0:	e456                	sd	s5,8(sp)
    80001af2:	e05a                	sd	s6,0(sp)
    80001af4:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001af6:	00007597          	auipc	a1,0x7
    80001afa:	72a58593          	addi	a1,a1,1834 # 80009220 <digits+0x1e0>
    80001afe:	00230517          	auipc	a0,0x230
    80001b02:	2ea50513          	addi	a0,a0,746 # 80231de8 <pid_lock>
    80001b06:	fffff097          	auipc	ra,0xfffff
    80001b0a:	1fc080e7          	jalr	508(ra) # 80000d02 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001b0e:	00007597          	auipc	a1,0x7
    80001b12:	71a58593          	addi	a1,a1,1818 # 80009228 <digits+0x1e8>
    80001b16:	00230517          	auipc	a0,0x230
    80001b1a:	2ea50513          	addi	a0,a0,746 # 80231e00 <wait_lock>
    80001b1e:	fffff097          	auipc	ra,0xfffff
    80001b22:	1e4080e7          	jalr	484(ra) # 80000d02 <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    80001b26:	00230497          	auipc	s1,0x230
    80001b2a:	6f248493          	addi	s1,s1,1778 # 80232218 <proc>
  {
    initlock(&p->lock, "proc");
    80001b2e:	00007b17          	auipc	s6,0x7
    80001b32:	70ab0b13          	addi	s6,s6,1802 # 80009238 <digits+0x1f8>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80001b36:	8aa6                	mv	s5,s1
    80001b38:	00007a17          	auipc	s4,0x7
    80001b3c:	4c8a0a13          	addi	s4,s4,1224 # 80009000 <etext>
    80001b40:	04000937          	lui	s2,0x4000
    80001b44:	197d                	addi	s2,s2,-1
    80001b46:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001b48:	00237997          	auipc	s3,0x237
    80001b4c:	6d098993          	addi	s3,s3,1744 # 80239218 <mlfq>
    initlock(&p->lock, "proc");
    80001b50:	85da                	mv	a1,s6
    80001b52:	8526                	mv	a0,s1
    80001b54:	fffff097          	auipc	ra,0xfffff
    80001b58:	1ae080e7          	jalr	430(ra) # 80000d02 <initlock>
    p->state = UNUSED;
    80001b5c:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80001b60:	415487b3          	sub	a5,s1,s5
    80001b64:	8799                	srai	a5,a5,0x6
    80001b66:	000a3703          	ld	a4,0(s4)
    80001b6a:	02e787b3          	mul	a5,a5,a4
    80001b6e:	2785                	addiw	a5,a5,1
    80001b70:	00d7979b          	slliw	a5,a5,0xd
    80001b74:	40f907b3          	sub	a5,s2,a5
    80001b78:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++)
    80001b7a:	1c048493          	addi	s1,s1,448
    80001b7e:	fd3499e3          	bne	s1,s3,80001b50 <procinit+0x6e>
    80001b82:	00238497          	auipc	s1,0x238
    80001b86:	89e48493          	addi	s1,s1,-1890 # 80239420 <mlfq+0x208>
    80001b8a:	00238997          	auipc	s3,0x238
    80001b8e:	33698993          	addi	s3,s3,822 # 80239ec0 <bcache+0x1f0>
  }

  #ifdef MLFQ
  // Example initialization (if NMLFQ is the number of queues)
  for(int i = 0; i < NMLFQ; i++) {
      initlock(&mlfq[i].lock, "mlfq_queue");
    80001b92:	00007917          	auipc	s2,0x7
    80001b96:	6ae90913          	addi	s2,s2,1710 # 80009240 <digits+0x200>
    80001b9a:	85ca                	mv	a1,s2
    80001b9c:	8526                	mv	a0,s1
    80001b9e:	fffff097          	auipc	ra,0xfffff
    80001ba2:	164080e7          	jalr	356(ra) # 80000d02 <initlock>
  for(int i = 0; i < NMLFQ; i++) {
    80001ba6:	22048493          	addi	s1,s1,544
    80001baa:	ff3498e3          	bne	s1,s3,80001b9a <procinit+0xb8>
  }
  #endif
}
    80001bae:	70e2                	ld	ra,56(sp)
    80001bb0:	7442                	ld	s0,48(sp)
    80001bb2:	74a2                	ld	s1,40(sp)
    80001bb4:	7902                	ld	s2,32(sp)
    80001bb6:	69e2                	ld	s3,24(sp)
    80001bb8:	6a42                	ld	s4,16(sp)
    80001bba:	6aa2                	ld	s5,8(sp)
    80001bbc:	6b02                	ld	s6,0(sp)
    80001bbe:	6121                	addi	sp,sp,64
    80001bc0:	8082                	ret

0000000080001bc2 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80001bc2:	1141                	addi	sp,sp,-16
    80001bc4:	e422                	sd	s0,8(sp)
    80001bc6:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp"
    80001bc8:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001bca:	2501                	sext.w	a0,a0
    80001bcc:	6422                	ld	s0,8(sp)
    80001bce:	0141                	addi	sp,sp,16
    80001bd0:	8082                	ret

0000000080001bd2 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80001bd2:	1141                	addi	sp,sp,-16
    80001bd4:	e422                	sd	s0,8(sp)
    80001bd6:	0800                	addi	s0,sp,16
    80001bd8:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001bda:	2781                	sext.w	a5,a5
    80001bdc:	079e                	slli	a5,a5,0x7
  return c;
}
    80001bde:	00230517          	auipc	a0,0x230
    80001be2:	23a50513          	addi	a0,a0,570 # 80231e18 <cpus>
    80001be6:	953e                	add	a0,a0,a5
    80001be8:	6422                	ld	s0,8(sp)
    80001bea:	0141                	addi	sp,sp,16
    80001bec:	8082                	ret

0000000080001bee <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80001bee:	1101                	addi	sp,sp,-32
    80001bf0:	ec06                	sd	ra,24(sp)
    80001bf2:	e822                	sd	s0,16(sp)
    80001bf4:	e426                	sd	s1,8(sp)
    80001bf6:	1000                	addi	s0,sp,32
  push_off();
    80001bf8:	fffff097          	auipc	ra,0xfffff
    80001bfc:	14e080e7          	jalr	334(ra) # 80000d46 <push_off>
    80001c00:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001c02:	2781                	sext.w	a5,a5
    80001c04:	079e                	slli	a5,a5,0x7
    80001c06:	00230717          	auipc	a4,0x230
    80001c0a:	1e270713          	addi	a4,a4,482 # 80231de8 <pid_lock>
    80001c0e:	97ba                	add	a5,a5,a4
    80001c10:	7b84                	ld	s1,48(a5)
  pop_off();
    80001c12:	fffff097          	auipc	ra,0xfffff
    80001c16:	1d4080e7          	jalr	468(ra) # 80000de6 <pop_off>
  return p;
}
    80001c1a:	8526                	mv	a0,s1
    80001c1c:	60e2                	ld	ra,24(sp)
    80001c1e:	6442                	ld	s0,16(sp)
    80001c20:	64a2                	ld	s1,8(sp)
    80001c22:	6105                	addi	sp,sp,32
    80001c24:	8082                	ret

0000000080001c26 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001c26:	1141                	addi	sp,sp,-16
    80001c28:	e406                	sd	ra,8(sp)
    80001c2a:	e022                	sd	s0,0(sp)
    80001c2c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001c2e:	00000097          	auipc	ra,0x0
    80001c32:	fc0080e7          	jalr	-64(ra) # 80001bee <myproc>
    80001c36:	fffff097          	auipc	ra,0xfffff
    80001c3a:	210080e7          	jalr	528(ra) # 80000e46 <release>

  if (first)
    80001c3e:	00008797          	auipc	a5,0x8
    80001c42:	dd27a783          	lw	a5,-558(a5) # 80009a10 <first.1>
    80001c46:	eb89                	bnez	a5,80001c58 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001c48:	00001097          	auipc	ra,0x1
    80001c4c:	138080e7          	jalr	312(ra) # 80002d80 <usertrapret>
}
    80001c50:	60a2                	ld	ra,8(sp)
    80001c52:	6402                	ld	s0,0(sp)
    80001c54:	0141                	addi	sp,sp,16
    80001c56:	8082                	ret
    first = 0;
    80001c58:	00008797          	auipc	a5,0x8
    80001c5c:	da07ac23          	sw	zero,-584(a5) # 80009a10 <first.1>
    fsinit(ROOTDEV);
    80001c60:	4505                	li	a0,1
    80001c62:	00002097          	auipc	ra,0x2
    80001c66:	27e080e7          	jalr	638(ra) # 80003ee0 <fsinit>
    80001c6a:	bff9                	j	80001c48 <forkret+0x22>

0000000080001c6c <allocpid>:
{
    80001c6c:	1101                	addi	sp,sp,-32
    80001c6e:	ec06                	sd	ra,24(sp)
    80001c70:	e822                	sd	s0,16(sp)
    80001c72:	e426                	sd	s1,8(sp)
    80001c74:	e04a                	sd	s2,0(sp)
    80001c76:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001c78:	00230917          	auipc	s2,0x230
    80001c7c:	17090913          	addi	s2,s2,368 # 80231de8 <pid_lock>
    80001c80:	854a                	mv	a0,s2
    80001c82:	fffff097          	auipc	ra,0xfffff
    80001c86:	110080e7          	jalr	272(ra) # 80000d92 <acquire>
  pid = nextpid;
    80001c8a:	00008797          	auipc	a5,0x8
    80001c8e:	d8a78793          	addi	a5,a5,-630 # 80009a14 <nextpid>
    80001c92:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001c94:	0014871b          	addiw	a4,s1,1
    80001c98:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001c9a:	854a                	mv	a0,s2
    80001c9c:	fffff097          	auipc	ra,0xfffff
    80001ca0:	1aa080e7          	jalr	426(ra) # 80000e46 <release>
}
    80001ca4:	8526                	mv	a0,s1
    80001ca6:	60e2                	ld	ra,24(sp)
    80001ca8:	6442                	ld	s0,16(sp)
    80001caa:	64a2                	ld	s1,8(sp)
    80001cac:	6902                	ld	s2,0(sp)
    80001cae:	6105                	addi	sp,sp,32
    80001cb0:	8082                	ret

0000000080001cb2 <proc_pagetable>:
{
    80001cb2:	1101                	addi	sp,sp,-32
    80001cb4:	ec06                	sd	ra,24(sp)
    80001cb6:	e822                	sd	s0,16(sp)
    80001cb8:	e426                	sd	s1,8(sp)
    80001cba:	e04a                	sd	s2,0(sp)
    80001cbc:	1000                	addi	s0,sp,32
    80001cbe:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001cc0:	00000097          	auipc	ra,0x0
    80001cc4:	824080e7          	jalr	-2012(ra) # 800014e4 <uvmcreate>
    80001cc8:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001cca:	c121                	beqz	a0,80001d0a <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001ccc:	4729                	li	a4,10
    80001cce:	00006697          	auipc	a3,0x6
    80001cd2:	33268693          	addi	a3,a3,818 # 80008000 <_trampoline>
    80001cd6:	6605                	lui	a2,0x1
    80001cd8:	040005b7          	lui	a1,0x4000
    80001cdc:	15fd                	addi	a1,a1,-1
    80001cde:	05b2                	slli	a1,a1,0xc
    80001ce0:	fffff097          	auipc	ra,0xfffff
    80001ce4:	57a080e7          	jalr	1402(ra) # 8000125a <mappages>
    80001ce8:	02054863          	bltz	a0,80001d18 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001cec:	4719                	li	a4,6
    80001cee:	05893683          	ld	a3,88(s2)
    80001cf2:	6605                	lui	a2,0x1
    80001cf4:	020005b7          	lui	a1,0x2000
    80001cf8:	15fd                	addi	a1,a1,-1
    80001cfa:	05b6                	slli	a1,a1,0xd
    80001cfc:	8526                	mv	a0,s1
    80001cfe:	fffff097          	auipc	ra,0xfffff
    80001d02:	55c080e7          	jalr	1372(ra) # 8000125a <mappages>
    80001d06:	02054163          	bltz	a0,80001d28 <proc_pagetable+0x76>
}
    80001d0a:	8526                	mv	a0,s1
    80001d0c:	60e2                	ld	ra,24(sp)
    80001d0e:	6442                	ld	s0,16(sp)
    80001d10:	64a2                	ld	s1,8(sp)
    80001d12:	6902                	ld	s2,0(sp)
    80001d14:	6105                	addi	sp,sp,32
    80001d16:	8082                	ret
    uvmfree(pagetable, 0);
    80001d18:	4581                	li	a1,0
    80001d1a:	8526                	mv	a0,s1
    80001d1c:	00000097          	auipc	ra,0x0
    80001d20:	9cc080e7          	jalr	-1588(ra) # 800016e8 <uvmfree>
    return 0;
    80001d24:	4481                	li	s1,0
    80001d26:	b7d5                	j	80001d0a <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001d28:	4681                	li	a3,0
    80001d2a:	4605                	li	a2,1
    80001d2c:	040005b7          	lui	a1,0x4000
    80001d30:	15fd                	addi	a1,a1,-1
    80001d32:	05b2                	slli	a1,a1,0xc
    80001d34:	8526                	mv	a0,s1
    80001d36:	fffff097          	auipc	ra,0xfffff
    80001d3a:	6ea080e7          	jalr	1770(ra) # 80001420 <uvmunmap>
    uvmfree(pagetable, 0);
    80001d3e:	4581                	li	a1,0
    80001d40:	8526                	mv	a0,s1
    80001d42:	00000097          	auipc	ra,0x0
    80001d46:	9a6080e7          	jalr	-1626(ra) # 800016e8 <uvmfree>
    return 0;
    80001d4a:	4481                	li	s1,0
    80001d4c:	bf7d                	j	80001d0a <proc_pagetable+0x58>

0000000080001d4e <proc_freepagetable>:
{
    80001d4e:	1101                	addi	sp,sp,-32
    80001d50:	ec06                	sd	ra,24(sp)
    80001d52:	e822                	sd	s0,16(sp)
    80001d54:	e426                	sd	s1,8(sp)
    80001d56:	e04a                	sd	s2,0(sp)
    80001d58:	1000                	addi	s0,sp,32
    80001d5a:	84aa                	mv	s1,a0
    80001d5c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001d5e:	4681                	li	a3,0
    80001d60:	4605                	li	a2,1
    80001d62:	040005b7          	lui	a1,0x4000
    80001d66:	15fd                	addi	a1,a1,-1
    80001d68:	05b2                	slli	a1,a1,0xc
    80001d6a:	fffff097          	auipc	ra,0xfffff
    80001d6e:	6b6080e7          	jalr	1718(ra) # 80001420 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001d72:	4681                	li	a3,0
    80001d74:	4605                	li	a2,1
    80001d76:	020005b7          	lui	a1,0x2000
    80001d7a:	15fd                	addi	a1,a1,-1
    80001d7c:	05b6                	slli	a1,a1,0xd
    80001d7e:	8526                	mv	a0,s1
    80001d80:	fffff097          	auipc	ra,0xfffff
    80001d84:	6a0080e7          	jalr	1696(ra) # 80001420 <uvmunmap>
  uvmfree(pagetable, sz);
    80001d88:	85ca                	mv	a1,s2
    80001d8a:	8526                	mv	a0,s1
    80001d8c:	00000097          	auipc	ra,0x0
    80001d90:	95c080e7          	jalr	-1700(ra) # 800016e8 <uvmfree>
}
    80001d94:	60e2                	ld	ra,24(sp)
    80001d96:	6442                	ld	s0,16(sp)
    80001d98:	64a2                	ld	s1,8(sp)
    80001d9a:	6902                	ld	s2,0(sp)
    80001d9c:	6105                	addi	sp,sp,32
    80001d9e:	8082                	ret

0000000080001da0 <freeproc>:
{
    80001da0:	1101                	addi	sp,sp,-32
    80001da2:	ec06                	sd	ra,24(sp)
    80001da4:	e822                	sd	s0,16(sp)
    80001da6:	e426                	sd	s1,8(sp)
    80001da8:	1000                	addi	s0,sp,32
    80001daa:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001dac:	6d28                	ld	a0,88(a0)
    80001dae:	c509                	beqz	a0,80001db8 <freeproc+0x18>
    kfree((void *)p->trapframe);
    80001db0:	fffff097          	auipc	ra,0xfffff
    80001db4:	cc6080e7          	jalr	-826(ra) # 80000a76 <kfree>
  if (p->alarm_trapframe)
    80001db8:	1b04b503          	ld	a0,432(s1)
    80001dbc:	c509                	beqz	a0,80001dc6 <freeproc+0x26>
    kfree((void *)p->alarm_trapframe);
    80001dbe:	fffff097          	auipc	ra,0xfffff
    80001dc2:	cb8080e7          	jalr	-840(ra) # 80000a76 <kfree>
  p->trapframe = 0;
    80001dc6:	0404bc23          	sd	zero,88(s1)
  p->alarm_trapframe = 0;
    80001dca:	1a04b823          	sd	zero,432(s1)
  if (p->pagetable)
    80001dce:	68a8                	ld	a0,80(s1)
    80001dd0:	c511                	beqz	a0,80001ddc <freeproc+0x3c>
    proc_freepagetable(p->pagetable, p->sz);
    80001dd2:	64ac                	ld	a1,72(s1)
    80001dd4:	00000097          	auipc	ra,0x0
    80001dd8:	f7a080e7          	jalr	-134(ra) # 80001d4e <proc_freepagetable>
  p->pagetable = 0;
    80001ddc:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001de0:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001de4:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001de8:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001dec:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001df0:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001df4:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001df8:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001dfc:	0004ac23          	sw	zero,24(s1)
}
    80001e00:	60e2                	ld	ra,24(sp)
    80001e02:	6442                	ld	s0,16(sp)
    80001e04:	64a2                	ld	s1,8(sp)
    80001e06:	6105                	addi	sp,sp,32
    80001e08:	8082                	ret

0000000080001e0a <allocproc>:
{
    80001e0a:	1101                	addi	sp,sp,-32
    80001e0c:	ec06                	sd	ra,24(sp)
    80001e0e:	e822                	sd	s0,16(sp)
    80001e10:	e426                	sd	s1,8(sp)
    80001e12:	e04a                	sd	s2,0(sp)
    80001e14:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++)
    80001e16:	00230497          	auipc	s1,0x230
    80001e1a:	40248493          	addi	s1,s1,1026 # 80232218 <proc>
    80001e1e:	00237917          	auipc	s2,0x237
    80001e22:	3fa90913          	addi	s2,s2,1018 # 80239218 <mlfq>
    acquire(&p->lock);
    80001e26:	8526                	mv	a0,s1
    80001e28:	fffff097          	auipc	ra,0xfffff
    80001e2c:	f6a080e7          	jalr	-150(ra) # 80000d92 <acquire>
    if (p->state == UNUSED)
    80001e30:	4c9c                	lw	a5,24(s1)
    80001e32:	cf81                	beqz	a5,80001e4a <allocproc+0x40>
      release(&p->lock);
    80001e34:	8526                	mv	a0,s1
    80001e36:	fffff097          	auipc	ra,0xfffff
    80001e3a:	010080e7          	jalr	16(ra) # 80000e46 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001e3e:	1c048493          	addi	s1,s1,448
    80001e42:	ff2492e3          	bne	s1,s2,80001e26 <allocproc+0x1c>
  return 0;
    80001e46:	4481                	li	s1,0
    80001e48:	a86d                	j	80001f02 <allocproc+0xf8>
  p->pid = allocpid();
    80001e4a:	00000097          	auipc	ra,0x0
    80001e4e:	e22080e7          	jalr	-478(ra) # 80001c6c <allocpid>
    80001e52:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001e54:	4785                	li	a5,1
    80001e56:	cc9c                	sw	a5,24(s1)
  p->static_priority = 60;
    80001e58:	03c00713          	li	a4,60
    80001e5c:	16e4ae23          	sw	a4,380(s1)
  p->number_of_times_scheduled = 0;
    80001e60:	1604ac23          	sw	zero,376(s1)
  p->sleeping_ticks = 0;
    80001e64:	1804a423          	sw	zero,392(s1)
  p->running_ticks = 0;
    80001e68:	1804a623          	sw	zero,396(s1)
  p->sleep_start = 0;
    80001e6c:	1804a023          	sw	zero,384(s1)
  p->reset_niceness = 1;
    80001e70:	18f4a223          	sw	a5,388(s1)
  p->level = 0;
    80001e74:	1804a823          	sw	zero,400(s1)
  p->change_queue = 1 << p->level;
    80001e78:	18f4ac23          	sw	a5,408(s1)
  p->in_queue = 0;
    80001e7c:	1804aa23          	sw	zero,404(s1)
  p->enter_ticks = ticks;
    80001e80:	00008797          	auipc	a5,0x8
    80001e84:	ce87a783          	lw	a5,-792(a5) # 80009b68 <ticks>
    80001e88:	18f4ae23          	sw	a5,412(s1)
  p->now_ticks = 0;
    80001e8c:	1a04a623          	sw	zero,428(s1)
  p->sigalarm_status = 0;
    80001e90:	1a04ac23          	sw	zero,440(s1)
  p->interval = 0;
    80001e94:	1a04a423          	sw	zero,424(s1)
  p->handler = -1;
    80001e98:	57fd                	li	a5,-1
    80001e9a:	1af4b023          	sd	a5,416(s1)
  p->alarm_trapframe = NULL;
    80001e9e:	1a04b823          	sd	zero,432(s1)
  if (forked_process && p->parent)
    80001ea2:	00008797          	auipc	a5,0x8
    80001ea6:	cb67a783          	lw	a5,-842(a5) # 80009b58 <forked_process>
    80001eaa:	e3bd                	bnez	a5,80001f10 <allocproc+0x106>
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001eac:	fffff097          	auipc	ra,0xfffff
    80001eb0:	da2080e7          	jalr	-606(ra) # 80000c4e <kalloc>
    80001eb4:	892a                	mv	s2,a0
    80001eb6:	eca8                	sd	a0,88(s1)
    80001eb8:	c13d                	beqz	a0,80001f1e <allocproc+0x114>
  p->pagetable = proc_pagetable(p);
    80001eba:	8526                	mv	a0,s1
    80001ebc:	00000097          	auipc	ra,0x0
    80001ec0:	df6080e7          	jalr	-522(ra) # 80001cb2 <proc_pagetable>
    80001ec4:	892a                	mv	s2,a0
    80001ec6:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0)
    80001ec8:	c53d                	beqz	a0,80001f36 <allocproc+0x12c>
  memset(&p->context, 0, sizeof(p->context));
    80001eca:	07000613          	li	a2,112
    80001ece:	4581                	li	a1,0
    80001ed0:	06048513          	addi	a0,s1,96
    80001ed4:	fffff097          	auipc	ra,0xfffff
    80001ed8:	fba080e7          	jalr	-70(ra) # 80000e8e <memset>
  p->context.ra = (uint64)forkret;
    80001edc:	00000797          	auipc	a5,0x0
    80001ee0:	d4a78793          	addi	a5,a5,-694 # 80001c26 <forkret>
    80001ee4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001ee6:	60bc                	ld	a5,64(s1)
    80001ee8:	6705                	lui	a4,0x1
    80001eea:	97ba                	add	a5,a5,a4
    80001eec:	f4bc                	sd	a5,104(s1)
  p->rtime = 0;
    80001eee:	1604a423          	sw	zero,360(s1)
  p->etime = 0;
    80001ef2:	1604a823          	sw	zero,368(s1)
  p->ctime = ticks;
    80001ef6:	00008797          	auipc	a5,0x8
    80001efa:	c727a783          	lw	a5,-910(a5) # 80009b68 <ticks>
    80001efe:	16f4a623          	sw	a5,364(s1)
}
    80001f02:	8526                	mv	a0,s1
    80001f04:	60e2                	ld	ra,24(sp)
    80001f06:	6442                	ld	s0,16(sp)
    80001f08:	64a2                	ld	s1,8(sp)
    80001f0a:	6902                	ld	s2,0(sp)
    80001f0c:	6105                	addi	sp,sp,32
    80001f0e:	8082                	ret
  if (forked_process && p->parent)
    80001f10:	7c9c                	ld	a5,56(s1)
    80001f12:	dfc9                	beqz	a5,80001eac <allocproc+0xa2>
    forked_process = 0;
    80001f14:	00008797          	auipc	a5,0x8
    80001f18:	c407a223          	sw	zero,-956(a5) # 80009b58 <forked_process>
    80001f1c:	bf41                	j	80001eac <allocproc+0xa2>
    freeproc(p);
    80001f1e:	8526                	mv	a0,s1
    80001f20:	00000097          	auipc	ra,0x0
    80001f24:	e80080e7          	jalr	-384(ra) # 80001da0 <freeproc>
    release(&p->lock);
    80001f28:	8526                	mv	a0,s1
    80001f2a:	fffff097          	auipc	ra,0xfffff
    80001f2e:	f1c080e7          	jalr	-228(ra) # 80000e46 <release>
    return 0;
    80001f32:	84ca                	mv	s1,s2
    80001f34:	b7f9                	j	80001f02 <allocproc+0xf8>
    freeproc(p);
    80001f36:	8526                	mv	a0,s1
    80001f38:	00000097          	auipc	ra,0x0
    80001f3c:	e68080e7          	jalr	-408(ra) # 80001da0 <freeproc>
    release(&p->lock);
    80001f40:	8526                	mv	a0,s1
    80001f42:	fffff097          	auipc	ra,0xfffff
    80001f46:	f04080e7          	jalr	-252(ra) # 80000e46 <release>
    return 0;
    80001f4a:	84ca                	mv	s1,s2
    80001f4c:	bf5d                	j	80001f02 <allocproc+0xf8>

0000000080001f4e <userinit>:
{
    80001f4e:	1101                	addi	sp,sp,-32
    80001f50:	ec06                	sd	ra,24(sp)
    80001f52:	e822                	sd	s0,16(sp)
    80001f54:	e426                	sd	s1,8(sp)
    80001f56:	1000                	addi	s0,sp,32
  p = allocproc();
    80001f58:	00000097          	auipc	ra,0x0
    80001f5c:	eb2080e7          	jalr	-334(ra) # 80001e0a <allocproc>
    80001f60:	84aa                	mv	s1,a0
  initproc = p;
    80001f62:	00008797          	auipc	a5,0x8
    80001f66:	bea7bf23          	sd	a0,-1026(a5) # 80009b60 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001f6a:	03400613          	li	a2,52
    80001f6e:	00008597          	auipc	a1,0x8
    80001f72:	ab258593          	addi	a1,a1,-1358 # 80009a20 <initcode>
    80001f76:	6928                	ld	a0,80(a0)
    80001f78:	fffff097          	auipc	ra,0xfffff
    80001f7c:	59a080e7          	jalr	1434(ra) # 80001512 <uvmfirst>
  p->sz = PGSIZE;
    80001f80:	6785                	lui	a5,0x1
    80001f82:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;     // user program counter
    80001f84:	6cb8                	ld	a4,88(s1)
    80001f86:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    80001f8a:	6cb8                	ld	a4,88(s1)
    80001f8c:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001f8e:	4641                	li	a2,16
    80001f90:	00007597          	auipc	a1,0x7
    80001f94:	2c058593          	addi	a1,a1,704 # 80009250 <digits+0x210>
    80001f98:	15848513          	addi	a0,s1,344
    80001f9c:	fffff097          	auipc	ra,0xfffff
    80001fa0:	03c080e7          	jalr	60(ra) # 80000fd8 <safestrcpy>
  p->cwd = namei("/");
    80001fa4:	00007517          	auipc	a0,0x7
    80001fa8:	2bc50513          	addi	a0,a0,700 # 80009260 <digits+0x220>
    80001fac:	00003097          	auipc	ra,0x3
    80001fb0:	956080e7          	jalr	-1706(ra) # 80004902 <namei>
    80001fb4:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001fb8:	478d                	li	a5,3
    80001fba:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001fbc:	8526                	mv	a0,s1
    80001fbe:	fffff097          	auipc	ra,0xfffff
    80001fc2:	e88080e7          	jalr	-376(ra) # 80000e46 <release>
}
    80001fc6:	60e2                	ld	ra,24(sp)
    80001fc8:	6442                	ld	s0,16(sp)
    80001fca:	64a2                	ld	s1,8(sp)
    80001fcc:	6105                	addi	sp,sp,32
    80001fce:	8082                	ret

0000000080001fd0 <growproc>:
{
    80001fd0:	1101                	addi	sp,sp,-32
    80001fd2:	ec06                	sd	ra,24(sp)
    80001fd4:	e822                	sd	s0,16(sp)
    80001fd6:	e426                	sd	s1,8(sp)
    80001fd8:	e04a                	sd	s2,0(sp)
    80001fda:	1000                	addi	s0,sp,32
    80001fdc:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001fde:	00000097          	auipc	ra,0x0
    80001fe2:	c10080e7          	jalr	-1008(ra) # 80001bee <myproc>
    80001fe6:	84aa                	mv	s1,a0
  sz = p->sz;
    80001fe8:	652c                	ld	a1,72(a0)
  if (n > 0)
    80001fea:	01204c63          	bgtz	s2,80002002 <growproc+0x32>
  else if (n < 0)
    80001fee:	02094663          	bltz	s2,8000201a <growproc+0x4a>
  p->sz = sz;
    80001ff2:	e4ac                	sd	a1,72(s1)
  return 0;
    80001ff4:	4501                	li	a0,0
}
    80001ff6:	60e2                	ld	ra,24(sp)
    80001ff8:	6442                	ld	s0,16(sp)
    80001ffa:	64a2                	ld	s1,8(sp)
    80001ffc:	6902                	ld	s2,0(sp)
    80001ffe:	6105                	addi	sp,sp,32
    80002000:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80002002:	4691                	li	a3,4
    80002004:	00b90633          	add	a2,s2,a1
    80002008:	6928                	ld	a0,80(a0)
    8000200a:	fffff097          	auipc	ra,0xfffff
    8000200e:	5c2080e7          	jalr	1474(ra) # 800015cc <uvmalloc>
    80002012:	85aa                	mv	a1,a0
    80002014:	fd79                	bnez	a0,80001ff2 <growproc+0x22>
      return -1;
    80002016:	557d                	li	a0,-1
    80002018:	bff9                	j	80001ff6 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000201a:	00b90633          	add	a2,s2,a1
    8000201e:	6928                	ld	a0,80(a0)
    80002020:	fffff097          	auipc	ra,0xfffff
    80002024:	564080e7          	jalr	1380(ra) # 80001584 <uvmdealloc>
    80002028:	85aa                	mv	a1,a0
    8000202a:	b7e1                	j	80001ff2 <growproc+0x22>

000000008000202c <fork>:
{
    8000202c:	7139                	addi	sp,sp,-64
    8000202e:	fc06                	sd	ra,56(sp)
    80002030:	f822                	sd	s0,48(sp)
    80002032:	f426                	sd	s1,40(sp)
    80002034:	f04a                	sd	s2,32(sp)
    80002036:	ec4e                	sd	s3,24(sp)
    80002038:	e852                	sd	s4,16(sp)
    8000203a:	e456                	sd	s5,8(sp)
    8000203c:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000203e:	00000097          	auipc	ra,0x0
    80002042:	bb0080e7          	jalr	-1104(ra) # 80001bee <myproc>
    80002046:	8aaa                	mv	s5,a0
  if (p->pid > 1)
    80002048:	5918                	lw	a4,48(a0)
    8000204a:	4785                	li	a5,1
    8000204c:	00e7d663          	bge	a5,a4,80002058 <fork+0x2c>
    forked_process = 1;
    80002050:	00008717          	auipc	a4,0x8
    80002054:	b0f72423          	sw	a5,-1272(a4) # 80009b58 <forked_process>
  if ((np = allocproc()) == 0)
    80002058:	00000097          	auipc	ra,0x0
    8000205c:	db2080e7          	jalr	-590(ra) # 80001e0a <allocproc>
    80002060:	89aa                	mv	s3,a0
    80002062:	10050f63          	beqz	a0,80002180 <fork+0x154>
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80002066:	048ab603          	ld	a2,72(s5)
    8000206a:	692c                	ld	a1,80(a0)
    8000206c:	050ab503          	ld	a0,80(s5)
    80002070:	fffff097          	auipc	ra,0xfffff
    80002074:	788080e7          	jalr	1928(ra) # 800017f8 <uvmcopy>
    80002078:	04054c63          	bltz	a0,800020d0 <fork+0xa4>
  np->sz = p->sz;
    8000207c:	048ab783          	ld	a5,72(s5)
    80002080:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80002084:	058ab683          	ld	a3,88(s5)
    80002088:	87b6                	mv	a5,a3
    8000208a:	0589b703          	ld	a4,88(s3)
    8000208e:	12068693          	addi	a3,a3,288
    80002092:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80002096:	6788                	ld	a0,8(a5)
    80002098:	6b8c                	ld	a1,16(a5)
    8000209a:	6f90                	ld	a2,24(a5)
    8000209c:	01073023          	sd	a6,0(a4)
    800020a0:	e708                	sd	a0,8(a4)
    800020a2:	eb0c                	sd	a1,16(a4)
    800020a4:	ef10                	sd	a2,24(a4)
    800020a6:	02078793          	addi	a5,a5,32
    800020aa:	02070713          	addi	a4,a4,32
    800020ae:	fed792e3          	bne	a5,a3,80002092 <fork+0x66>
  np->tmask = p->tmask;
    800020b2:	174aa783          	lw	a5,372(s5)
    800020b6:	16f9aa23          	sw	a5,372(s3)
  np->trapframe->a0 = 0;
    800020ba:	0589b783          	ld	a5,88(s3)
    800020be:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    800020c2:	0d0a8493          	addi	s1,s5,208
    800020c6:	0d098913          	addi	s2,s3,208
    800020ca:	150a8a13          	addi	s4,s5,336
    800020ce:	a00d                	j	800020f0 <fork+0xc4>
    freeproc(np);
    800020d0:	854e                	mv	a0,s3
    800020d2:	00000097          	auipc	ra,0x0
    800020d6:	cce080e7          	jalr	-818(ra) # 80001da0 <freeproc>
    release(&np->lock);
    800020da:	854e                	mv	a0,s3
    800020dc:	fffff097          	auipc	ra,0xfffff
    800020e0:	d6a080e7          	jalr	-662(ra) # 80000e46 <release>
    return -1;
    800020e4:	597d                	li	s2,-1
    800020e6:	a059                	j	8000216c <fork+0x140>
  for (i = 0; i < NOFILE; i++)
    800020e8:	04a1                	addi	s1,s1,8
    800020ea:	0921                	addi	s2,s2,8
    800020ec:	01448b63          	beq	s1,s4,80002102 <fork+0xd6>
    if (p->ofile[i])
    800020f0:	6088                	ld	a0,0(s1)
    800020f2:	d97d                	beqz	a0,800020e8 <fork+0xbc>
      np->ofile[i] = filedup(p->ofile[i]);
    800020f4:	00003097          	auipc	ra,0x3
    800020f8:	ea4080e7          	jalr	-348(ra) # 80004f98 <filedup>
    800020fc:	00a93023          	sd	a0,0(s2)
    80002100:	b7e5                	j	800020e8 <fork+0xbc>
  np->cwd = idup(p->cwd);
    80002102:	150ab503          	ld	a0,336(s5)
    80002106:	00002097          	auipc	ra,0x2
    8000210a:	018080e7          	jalr	24(ra) # 8000411e <idup>
    8000210e:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002112:	4641                	li	a2,16
    80002114:	158a8593          	addi	a1,s5,344
    80002118:	15898513          	addi	a0,s3,344
    8000211c:	fffff097          	auipc	ra,0xfffff
    80002120:	ebc080e7          	jalr	-324(ra) # 80000fd8 <safestrcpy>
  pid = np->pid;
    80002124:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80002128:	854e                	mv	a0,s3
    8000212a:	fffff097          	auipc	ra,0xfffff
    8000212e:	d1c080e7          	jalr	-740(ra) # 80000e46 <release>
  acquire(&wait_lock);
    80002132:	00230497          	auipc	s1,0x230
    80002136:	cce48493          	addi	s1,s1,-818 # 80231e00 <wait_lock>
    8000213a:	8526                	mv	a0,s1
    8000213c:	fffff097          	auipc	ra,0xfffff
    80002140:	c56080e7          	jalr	-938(ra) # 80000d92 <acquire>
  np->parent = p;
    80002144:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80002148:	8526                	mv	a0,s1
    8000214a:	fffff097          	auipc	ra,0xfffff
    8000214e:	cfc080e7          	jalr	-772(ra) # 80000e46 <release>
  acquire(&np->lock);
    80002152:	854e                	mv	a0,s3
    80002154:	fffff097          	auipc	ra,0xfffff
    80002158:	c3e080e7          	jalr	-962(ra) # 80000d92 <acquire>
  np->state = RUNNABLE;
    8000215c:	478d                	li	a5,3
    8000215e:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80002162:	854e                	mv	a0,s3
    80002164:	fffff097          	auipc	ra,0xfffff
    80002168:	ce2080e7          	jalr	-798(ra) # 80000e46 <release>
}
    8000216c:	854a                	mv	a0,s2
    8000216e:	70e2                	ld	ra,56(sp)
    80002170:	7442                	ld	s0,48(sp)
    80002172:	74a2                	ld	s1,40(sp)
    80002174:	7902                	ld	s2,32(sp)
    80002176:	69e2                	ld	s3,24(sp)
    80002178:	6a42                	ld	s4,16(sp)
    8000217a:	6aa2                	ld	s5,8(sp)
    8000217c:	6121                	addi	sp,sp,64
    8000217e:	8082                	ret
    return -1;
    80002180:	597d                	li	s2,-1
    80002182:	b7ed                	j	8000216c <fork+0x140>

0000000080002184 <update_time>:
{
    80002184:	7179                	addi	sp,sp,-48
    80002186:	f406                	sd	ra,40(sp)
    80002188:	f022                	sd	s0,32(sp)
    8000218a:	ec26                	sd	s1,24(sp)
    8000218c:	e84a                	sd	s2,16(sp)
    8000218e:	e44e                	sd	s3,8(sp)
    80002190:	1800                	addi	s0,sp,48
  for (p = proc; p < &proc[NPROC]; p++)
    80002192:	00230497          	auipc	s1,0x230
    80002196:	08648493          	addi	s1,s1,134 # 80232218 <proc>
    if (p->state == RUNNING)
    8000219a:	4991                	li	s3,4
  for (p = proc; p < &proc[NPROC]; p++)
    8000219c:	00237917          	auipc	s2,0x237
    800021a0:	07c90913          	addi	s2,s2,124 # 80239218 <mlfq>
    800021a4:	a811                	j	800021b8 <update_time+0x34>
    release(&p->lock);
    800021a6:	8526                	mv	a0,s1
    800021a8:	fffff097          	auipc	ra,0xfffff
    800021ac:	c9e080e7          	jalr	-866(ra) # 80000e46 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    800021b0:	1c048493          	addi	s1,s1,448
    800021b4:	03248063          	beq	s1,s2,800021d4 <update_time+0x50>
    acquire(&p->lock);
    800021b8:	8526                	mv	a0,s1
    800021ba:	fffff097          	auipc	ra,0xfffff
    800021be:	bd8080e7          	jalr	-1064(ra) # 80000d92 <acquire>
    if (p->state == RUNNING)
    800021c2:	4c9c                	lw	a5,24(s1)
    800021c4:	ff3791e3          	bne	a5,s3,800021a6 <update_time+0x22>
      p->rtime++;
    800021c8:	1684a783          	lw	a5,360(s1)
    800021cc:	2785                	addiw	a5,a5,1
    800021ce:	16f4a423          	sw	a5,360(s1)
    800021d2:	bfd1                	j	800021a6 <update_time+0x22>
}
    800021d4:	70a2                	ld	ra,40(sp)
    800021d6:	7402                	ld	s0,32(sp)
    800021d8:	64e2                	ld	s1,24(sp)
    800021da:	6942                	ld	s2,16(sp)
    800021dc:	69a2                	ld	s3,8(sp)
    800021de:	6145                	addi	sp,sp,48
    800021e0:	8082                	ret

00000000800021e2 <scheduler>:
{
    800021e2:	7119                	addi	sp,sp,-128
    800021e4:	fc86                	sd	ra,120(sp)
    800021e6:	f8a2                	sd	s0,112(sp)
    800021e8:	f4a6                	sd	s1,104(sp)
    800021ea:	f0ca                	sd	s2,96(sp)
    800021ec:	ecce                	sd	s3,88(sp)
    800021ee:	e8d2                	sd	s4,80(sp)
    800021f0:	e4d6                	sd	s5,72(sp)
    800021f2:	e0da                	sd	s6,64(sp)
    800021f4:	fc5e                	sd	s7,56(sp)
    800021f6:	f862                	sd	s8,48(sp)
    800021f8:	f466                	sd	s9,40(sp)
    800021fa:	f06a                	sd	s10,32(sp)
    800021fc:	ec6e                	sd	s11,24(sp)
    800021fe:	0100                	addi	s0,sp,128
    80002200:	8792                	mv	a5,tp
  int id = r_tp();
    80002202:	2781                	sext.w	a5,a5
  c->proc = 0;
    80002204:	00779693          	slli	a3,a5,0x7
    80002208:	00230717          	auipc	a4,0x230
    8000220c:	be070713          	addi	a4,a4,-1056 # 80231de8 <pid_lock>
    80002210:	9736                	add	a4,a4,a3
    80002212:	02073823          	sd	zero,48(a4)
      swtch(&c->context, &p->context);
    80002216:	00230717          	auipc	a4,0x230
    8000221a:	c0a70713          	addi	a4,a4,-1014 # 80231e20 <cpus+0x8>
    8000221e:	9736                	add	a4,a4,a3
    80002220:	f8e43423          	sd	a4,-120(s0)
      if(p->state == RUNNABLE && ticks-p->enter_ticks >= AGETICK){
    80002224:	490d                	li	s2,3
          delete(&mlfq[p->level],p->pid);
    80002226:	00237d17          	auipc	s10,0x237
    8000222a:	ff2d0d13          	addi	s10,s10,-14 # 80239218 <mlfq>
    for(struct proc* p = proc; p < &proc[NPROC]; p++){
    8000222e:	00237997          	auipc	s3,0x237
    80002232:	fea98993          	addi	s3,s3,-22 # 80239218 <mlfq>
      c->proc = p;
    80002236:	00230717          	auipc	a4,0x230
    8000223a:	bb270713          	addi	a4,a4,-1102 # 80231de8 <pid_lock>
    8000223e:	00d707b3          	add	a5,a4,a3
    80002242:	f8f43023          	sd	a5,-128(s0)
    80002246:	a2f1                	j	80002412 <scheduler+0x230>
          delete(&mlfq[p->level],p->pid);
    80002248:	1904e783          	lwu	a5,400(s1)
    8000224c:	00479513          	slli	a0,a5,0x4
    80002250:	953e                	add	a0,a0,a5
    80002252:	0516                	slli	a0,a0,0x5
    80002254:	588c                	lw	a1,48(s1)
    80002256:	956a                	add	a0,a0,s10
    80002258:	00005097          	auipc	ra,0x5
    8000225c:	8e6080e7          	jalr	-1818(ra) # 80006b3e <delete>
          p->in_queue = 0;
    80002260:	1804aa23          	sw	zero,404(s1)
    80002264:	a035                	j	80002290 <scheduler+0xae>
        p->enter_ticks = ticks;
    80002266:	000a2783          	lw	a5,0(s4)
    8000226a:	18f4ae23          	sw	a5,412(s1)
    for(struct proc* p = proc; p < &proc[NPROC]; p++){
    8000226e:	1c048493          	addi	s1,s1,448
    80002272:	03348663          	beq	s1,s3,8000229e <scheduler+0xbc>
      if(p->state == RUNNABLE && ticks-p->enter_ticks >= AGETICK){
    80002276:	4c9c                	lw	a5,24(s1)
    80002278:	ff279be3          	bne	a5,s2,8000226e <scheduler+0x8c>
    8000227c:	000a2783          	lw	a5,0(s4)
    80002280:	19c4a703          	lw	a4,412(s1)
    80002284:	9f99                	subw	a5,a5,a4
    80002286:	fefaf4e3          	bgeu	s5,a5,8000226e <scheduler+0x8c>
        if(p->in_queue){
    8000228a:	1944a783          	lw	a5,404(s1)
    8000228e:	ffcd                	bnez	a5,80002248 <scheduler+0x66>
        if(p->level){
    80002290:	1904a783          	lw	a5,400(s1)
    80002294:	dbe9                	beqz	a5,80002266 <scheduler+0x84>
          p->level--;
    80002296:	37fd                	addiw	a5,a5,-1
    80002298:	18f4a823          	sw	a5,400(s1)
    8000229c:	b7e9                	j	80002266 <scheduler+0x84>
    for(struct proc* p = proc; p < &proc[NPROC]; p++){
    8000229e:	00230497          	auipc	s1,0x230
    800022a2:	f7a48493          	addi	s1,s1,-134 # 80232218 <proc>
        p->in_queue = 1;
    800022a6:	4a05                	li	s4,1
    800022a8:	a029                	j	800022b2 <scheduler+0xd0>
    for(struct proc* p = proc; p < &proc[NPROC]; p++){
    800022aa:	1c048493          	addi	s1,s1,448
    800022ae:	03348763          	beq	s1,s3,800022dc <scheduler+0xfa>
      if(p->state == RUNNABLE && p->in_queue == 0){
    800022b2:	4c9c                	lw	a5,24(s1)
    800022b4:	ff279be3          	bne	a5,s2,800022aa <scheduler+0xc8>
    800022b8:	1944a783          	lw	a5,404(s1)
    800022bc:	f7fd                	bnez	a5,800022aa <scheduler+0xc8>
        push_back(&mlfq[p->level],p);
    800022be:	1904e783          	lwu	a5,400(s1)
    800022c2:	00479513          	slli	a0,a5,0x4
    800022c6:	953e                	add	a0,a0,a5
    800022c8:	0516                	slli	a0,a0,0x5
    800022ca:	85a6                	mv	a1,s1
    800022cc:	956a                	add	a0,a0,s10
    800022ce:	00004097          	auipc	ra,0x4
    800022d2:	790080e7          	jalr	1936(ra) # 80006a5e <push_back>
        p->in_queue = 1;
    800022d6:	1944aa23          	sw	s4,404(s1)
    800022da:	bfc1                	j	800022aa <scheduler+0xc8>
    800022dc:	00237c17          	auipc	s8,0x237
    800022e0:	f3cc0c13          	addi	s8,s8,-196 # 80239218 <mlfq>
    800022e4:	00238b17          	auipc	s6,0x238
    800022e8:	9d4b0b13          	addi	s6,s6,-1580 # 80239cb8 <tickslock>
    for(struct proc* p = proc; p < &proc[NPROC]; p++){
    800022ec:	8ae2                	mv	s5,s8
    800022ee:	a029                	j	800022f8 <scheduler+0x116>
    for(int level = 0; level < NMLFQ; level++){
    800022f0:	220a8a93          	addi	s5,s5,544
    800022f4:	156a8763          	beq	s5,s6,80002442 <scheduler+0x260>
      while(size(&mlfq[level])){
    800022f8:	8a56                	mv	s4,s5
    800022fa:	8552                	mv	a0,s4
    800022fc:	00005097          	auipc	ra,0x5
    80002300:	80a080e7          	jalr	-2038(ra) # 80006b06 <size>
    80002304:	d575                	beqz	a0,800022f0 <scheduler+0x10e>
        p = front(&mlfq[level]);
    80002306:	8552                	mv	a0,s4
    80002308:	00004097          	auipc	ra,0x4
    8000230c:	7be080e7          	jalr	1982(ra) # 80006ac6 <front>
    80002310:	84aa                	mv	s1,a0
        pop(&mlfq[level]); 
    80002312:	8552                	mv	a0,s4
    80002314:	00004097          	auipc	ra,0x4
    80002318:	670080e7          	jalr	1648(ra) # 80006984 <pop>
        p->in_queue = 0;
    8000231c:	1804aa23          	sw	zero,404(s1)
        if(p->state == RUNNABLE){
    80002320:	4c9c                	lw	a5,24(s1)
    80002322:	fd279ce3          	bne	a5,s2,800022fa <scheduler+0x118>
          p->enter_ticks = ticks;
    80002326:	00008797          	auipc	a5,0x8
    8000232a:	8427a783          	lw	a5,-1982(a5) # 80009b68 <ticks>
    8000232e:	18f4ae23          	sw	a5,412(s1)
    80002332:	4c81                	li	s9,0
        printf("%d %d ",ticks, level);
    80002334:	00008d97          	auipc	s11,0x8
    80002338:	834d8d93          	addi	s11,s11,-1996 # 80009b68 <ticks>
          printf("%d ", (mlfq[level].n)[z]->pid);
    8000233c:	00007b97          	auipc	s7,0x7
    80002340:	f34b8b93          	addi	s7,s7,-204 # 80009270 <digits+0x230>
        printf("%d %d ",ticks, level);
    80002344:	8666                	mv	a2,s9
    80002346:	000da583          	lw	a1,0(s11)
    8000234a:	00007517          	auipc	a0,0x7
    8000234e:	f1e50513          	addi	a0,a0,-226 # 80009268 <digits+0x228>
    80002352:	ffffe097          	auipc	ra,0xffffe
    80002356:	236080e7          	jalr	566(ra) # 80000588 <printf>
        for (int z = 0; z < mlfq[level].end; z++)
    8000235a:	8b62                	mv	s6,s8
    8000235c:	200c2783          	lw	a5,512(s8)
    80002360:	c785                	beqz	a5,80002388 <scheduler+0x1a6>
    80002362:	8a62                	mv	s4,s8
    80002364:	4a81                	li	s5,0
          printf("%d ", (mlfq[level].n)[z]->pid);
    80002366:	000a3783          	ld	a5,0(s4)
    8000236a:	5b8c                	lw	a1,48(a5)
    8000236c:	855e                	mv	a0,s7
    8000236e:	ffffe097          	auipc	ra,0xffffe
    80002372:	21a080e7          	jalr	538(ra) # 80000588 <printf>
        for (int z = 0; z < mlfq[level].end; z++)
    80002376:	001a879b          	addiw	a5,s5,1
    8000237a:	00078a9b          	sext.w	s5,a5
    8000237e:	0a21                	addi	s4,s4,8
    80002380:	200b2703          	lw	a4,512(s6)
    80002384:	feeae1e3          	bltu	s5,a4,80002366 <scheduler+0x184>
        printf("\n");
    80002388:	00007517          	auipc	a0,0x7
    8000238c:	d8050513          	addi	a0,a0,-640 # 80009108 <digits+0xc8>
    80002390:	ffffe097          	auipc	ra,0xffffe
    80002394:	1f8080e7          	jalr	504(ra) # 80000588 <printf>
      for (int level = 0; level < NMLFQ; level++)
    80002398:	2c85                	addiw	s9,s9,1
    8000239a:	220c0c13          	addi	s8,s8,544
    8000239e:	4795                	li	a5,5
    800023a0:	fafc92e3          	bne	s9,a5,80002344 <scheduler+0x162>
      printf("\n");
    800023a4:	00007517          	auipc	a0,0x7
    800023a8:	d6450513          	addi	a0,a0,-668 # 80009108 <digits+0xc8>
    800023ac:	ffffe097          	auipc	ra,0xffffe
    800023b0:	1dc080e7          	jalr	476(ra) # 80000588 <printf>
      p->state = RUNNING;
    800023b4:	4791                	li	a5,4
    800023b6:	cc9c                	sw	a5,24(s1)
      p->enter_ticks = ticks;
    800023b8:	00007797          	auipc	a5,0x7
    800023bc:	7b07a783          	lw	a5,1968(a5) # 80009b68 <ticks>
    800023c0:	18f4ae23          	sw	a5,412(s1)
      c->proc = p;
    800023c4:	f8043a03          	ld	s4,-128(s0)
    800023c8:	029a3823          	sd	s1,48(s4)
      release(&proc->lock);
    800023cc:	00230517          	auipc	a0,0x230
    800023d0:	e4c50513          	addi	a0,a0,-436 # 80232218 <proc>
    800023d4:	fffff097          	auipc	ra,0xfffff
    800023d8:	a72080e7          	jalr	-1422(ra) # 80000e46 <release>
      acquire(&p->lock);
    800023dc:	8526                	mv	a0,s1
    800023de:	fffff097          	auipc	ra,0xfffff
    800023e2:	9b4080e7          	jalr	-1612(ra) # 80000d92 <acquire>
      p->change_queue = 1 << p->level;
    800023e6:	1904a703          	lw	a4,400(s1)
    800023ea:	4785                	li	a5,1
    800023ec:	00e797bb          	sllw	a5,a5,a4
    800023f0:	18f4ac23          	sw	a5,408(s1)
      swtch(&c->context, &p->context);
    800023f4:	06048593          	addi	a1,s1,96
    800023f8:	f8843503          	ld	a0,-120(s0)
    800023fc:	00001097          	auipc	ra,0x1
    80002400:	8da080e7          	jalr	-1830(ra) # 80002cd6 <swtch>
      c->proc = 0;
    80002404:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80002408:	8526                	mv	a0,s1
    8000240a:	fffff097          	auipc	ra,0xfffff
    8000240e:	a3c080e7          	jalr	-1476(ra) # 80000e46 <release>
  asm volatile("csrr %0, sstatus"
    80002412:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002416:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0"
    8000241a:	10079073          	csrw	sstatus,a5
    acquire(&proc->lock);
    8000241e:	00230517          	auipc	a0,0x230
    80002422:	dfa50513          	addi	a0,a0,-518 # 80232218 <proc>
    80002426:	fffff097          	auipc	ra,0xfffff
    8000242a:	96c080e7          	jalr	-1684(ra) # 80000d92 <acquire>
    for(struct proc* p = proc; p < &proc[NPROC]; p++){
    8000242e:	00230497          	auipc	s1,0x230
    80002432:	dea48493          	addi	s1,s1,-534 # 80232218 <proc>
      if(p->state == RUNNABLE && ticks-p->enter_ticks >= AGETICK){
    80002436:	00007a17          	auipc	s4,0x7
    8000243a:	732a0a13          	addi	s4,s4,1842 # 80009b68 <ticks>
    8000243e:	4af5                	li	s5,29
    80002440:	bd1d                	j	80002276 <scheduler+0x94>
      release(&proc->lock);
    80002442:	00230517          	auipc	a0,0x230
    80002446:	dd650513          	addi	a0,a0,-554 # 80232218 <proc>
    8000244a:	fffff097          	auipc	ra,0xfffff
    8000244e:	9fc080e7          	jalr	-1540(ra) # 80000e46 <release>
    80002452:	b7c1                	j	80002412 <scheduler+0x230>

0000000080002454 <sched>:
{
    80002454:	7179                	addi	sp,sp,-48
    80002456:	f406                	sd	ra,40(sp)
    80002458:	f022                	sd	s0,32(sp)
    8000245a:	ec26                	sd	s1,24(sp)
    8000245c:	e84a                	sd	s2,16(sp)
    8000245e:	e44e                	sd	s3,8(sp)
    80002460:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002462:	fffff097          	auipc	ra,0xfffff
    80002466:	78c080e7          	jalr	1932(ra) # 80001bee <myproc>
    8000246a:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    8000246c:	fffff097          	auipc	ra,0xfffff
    80002470:	8ac080e7          	jalr	-1876(ra) # 80000d18 <holding>
    80002474:	c93d                	beqz	a0,800024ea <sched+0x96>
  asm volatile("mv %0, tp"
    80002476:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80002478:	2781                	sext.w	a5,a5
    8000247a:	079e                	slli	a5,a5,0x7
    8000247c:	00230717          	auipc	a4,0x230
    80002480:	96c70713          	addi	a4,a4,-1684 # 80231de8 <pid_lock>
    80002484:	97ba                	add	a5,a5,a4
    80002486:	0a87a703          	lw	a4,168(a5)
    8000248a:	4785                	li	a5,1
    8000248c:	06f71763          	bne	a4,a5,800024fa <sched+0xa6>
  if (p->state == RUNNING)
    80002490:	4c98                	lw	a4,24(s1)
    80002492:	4791                	li	a5,4
    80002494:	06f70b63          	beq	a4,a5,8000250a <sched+0xb6>
  asm volatile("csrr %0, sstatus"
    80002498:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000249c:	8b89                	andi	a5,a5,2
  if (intr_get())
    8000249e:	efb5                	bnez	a5,8000251a <sched+0xc6>
  asm volatile("mv %0, tp"
    800024a0:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800024a2:	00230917          	auipc	s2,0x230
    800024a6:	94690913          	addi	s2,s2,-1722 # 80231de8 <pid_lock>
    800024aa:	2781                	sext.w	a5,a5
    800024ac:	079e                	slli	a5,a5,0x7
    800024ae:	97ca                	add	a5,a5,s2
    800024b0:	0ac7a983          	lw	s3,172(a5)
    800024b4:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800024b6:	2781                	sext.w	a5,a5
    800024b8:	079e                	slli	a5,a5,0x7
    800024ba:	00230597          	auipc	a1,0x230
    800024be:	96658593          	addi	a1,a1,-1690 # 80231e20 <cpus+0x8>
    800024c2:	95be                	add	a1,a1,a5
    800024c4:	06048513          	addi	a0,s1,96
    800024c8:	00001097          	auipc	ra,0x1
    800024cc:	80e080e7          	jalr	-2034(ra) # 80002cd6 <swtch>
    800024d0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800024d2:	2781                	sext.w	a5,a5
    800024d4:	079e                	slli	a5,a5,0x7
    800024d6:	97ca                	add	a5,a5,s2
    800024d8:	0b37a623          	sw	s3,172(a5)
}
    800024dc:	70a2                	ld	ra,40(sp)
    800024de:	7402                	ld	s0,32(sp)
    800024e0:	64e2                	ld	s1,24(sp)
    800024e2:	6942                	ld	s2,16(sp)
    800024e4:	69a2                	ld	s3,8(sp)
    800024e6:	6145                	addi	sp,sp,48
    800024e8:	8082                	ret
    panic("sched p->lock");
    800024ea:	00007517          	auipc	a0,0x7
    800024ee:	d8e50513          	addi	a0,a0,-626 # 80009278 <digits+0x238>
    800024f2:	ffffe097          	auipc	ra,0xffffe
    800024f6:	04c080e7          	jalr	76(ra) # 8000053e <panic>
    panic("sched locks");
    800024fa:	00007517          	auipc	a0,0x7
    800024fe:	d8e50513          	addi	a0,a0,-626 # 80009288 <digits+0x248>
    80002502:	ffffe097          	auipc	ra,0xffffe
    80002506:	03c080e7          	jalr	60(ra) # 8000053e <panic>
    panic("sched running");
    8000250a:	00007517          	auipc	a0,0x7
    8000250e:	d8e50513          	addi	a0,a0,-626 # 80009298 <digits+0x258>
    80002512:	ffffe097          	auipc	ra,0xffffe
    80002516:	02c080e7          	jalr	44(ra) # 8000053e <panic>
    panic("sched interruptible");
    8000251a:	00007517          	auipc	a0,0x7
    8000251e:	d8e50513          	addi	a0,a0,-626 # 800092a8 <digits+0x268>
    80002522:	ffffe097          	auipc	ra,0xffffe
    80002526:	01c080e7          	jalr	28(ra) # 8000053e <panic>

000000008000252a <yield>:
{
    8000252a:	1101                	addi	sp,sp,-32
    8000252c:	ec06                	sd	ra,24(sp)
    8000252e:	e822                	sd	s0,16(sp)
    80002530:	e426                	sd	s1,8(sp)
    80002532:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002534:	fffff097          	auipc	ra,0xfffff
    80002538:	6ba080e7          	jalr	1722(ra) # 80001bee <myproc>
    8000253c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000253e:	fffff097          	auipc	ra,0xfffff
    80002542:	854080e7          	jalr	-1964(ra) # 80000d92 <acquire>
  p->state = RUNNABLE;
    80002546:	478d                	li	a5,3
    80002548:	cc9c                	sw	a5,24(s1)
  sched();
    8000254a:	00000097          	auipc	ra,0x0
    8000254e:	f0a080e7          	jalr	-246(ra) # 80002454 <sched>
  release(&p->lock);
    80002552:	8526                	mv	a0,s1
    80002554:	fffff097          	auipc	ra,0xfffff
    80002558:	8f2080e7          	jalr	-1806(ra) # 80000e46 <release>
}
    8000255c:	60e2                	ld	ra,24(sp)
    8000255e:	6442                	ld	s0,16(sp)
    80002560:	64a2                	ld	s1,8(sp)
    80002562:	6105                	addi	sp,sp,32
    80002564:	8082                	ret

0000000080002566 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    80002566:	7179                	addi	sp,sp,-48
    80002568:	f406                	sd	ra,40(sp)
    8000256a:	f022                	sd	s0,32(sp)
    8000256c:	ec26                	sd	s1,24(sp)
    8000256e:	e84a                	sd	s2,16(sp)
    80002570:	e44e                	sd	s3,8(sp)
    80002572:	1800                	addi	s0,sp,48
    80002574:	89aa                	mv	s3,a0
    80002576:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002578:	fffff097          	auipc	ra,0xfffff
    8000257c:	676080e7          	jalr	1654(ra) # 80001bee <myproc>
    80002580:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    80002582:	fffff097          	auipc	ra,0xfffff
    80002586:	810080e7          	jalr	-2032(ra) # 80000d92 <acquire>
  release(lk);
    8000258a:	854a                	mv	a0,s2
    8000258c:	fffff097          	auipc	ra,0xfffff
    80002590:	8ba080e7          	jalr	-1862(ra) # 80000e46 <release>

  // Go to sleep.
  p->sleep_start = ticks;
    80002594:	00007797          	auipc	a5,0x7
    80002598:	5d47a783          	lw	a5,1492(a5) # 80009b68 <ticks>
    8000259c:	18f4a023          	sw	a5,384(s1)
  p->chan = chan;
    800025a0:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800025a4:	4789                	li	a5,2
    800025a6:	cc9c                	sw	a5,24(s1)

  sched();
    800025a8:	00000097          	auipc	ra,0x0
    800025ac:	eac080e7          	jalr	-340(ra) # 80002454 <sched>

  // Tidy up.
  p->chan = 0;
    800025b0:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800025b4:	8526                	mv	a0,s1
    800025b6:	fffff097          	auipc	ra,0xfffff
    800025ba:	890080e7          	jalr	-1904(ra) # 80000e46 <release>
  acquire(lk);
    800025be:	854a                	mv	a0,s2
    800025c0:	ffffe097          	auipc	ra,0xffffe
    800025c4:	7d2080e7          	jalr	2002(ra) # 80000d92 <acquire>
}
    800025c8:	70a2                	ld	ra,40(sp)
    800025ca:	7402                	ld	s0,32(sp)
    800025cc:	64e2                	ld	s1,24(sp)
    800025ce:	6942                	ld	s2,16(sp)
    800025d0:	69a2                	ld	s3,8(sp)
    800025d2:	6145                	addi	sp,sp,48
    800025d4:	8082                	ret

00000000800025d6 <waitx>:
{
    800025d6:	711d                	addi	sp,sp,-96
    800025d8:	ec86                	sd	ra,88(sp)
    800025da:	e8a2                	sd	s0,80(sp)
    800025dc:	e4a6                	sd	s1,72(sp)
    800025de:	e0ca                	sd	s2,64(sp)
    800025e0:	fc4e                	sd	s3,56(sp)
    800025e2:	f852                	sd	s4,48(sp)
    800025e4:	f456                	sd	s5,40(sp)
    800025e6:	f05a                	sd	s6,32(sp)
    800025e8:	ec5e                	sd	s7,24(sp)
    800025ea:	e862                	sd	s8,16(sp)
    800025ec:	e466                	sd	s9,8(sp)
    800025ee:	e06a                	sd	s10,0(sp)
    800025f0:	1080                	addi	s0,sp,96
    800025f2:	8b2a                	mv	s6,a0
    800025f4:	8bae                	mv	s7,a1
    800025f6:	8c32                	mv	s8,a2
  struct proc *p = myproc();
    800025f8:	fffff097          	auipc	ra,0xfffff
    800025fc:	5f6080e7          	jalr	1526(ra) # 80001bee <myproc>
    80002600:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002602:	0022f517          	auipc	a0,0x22f
    80002606:	7fe50513          	addi	a0,a0,2046 # 80231e00 <wait_lock>
    8000260a:	ffffe097          	auipc	ra,0xffffe
    8000260e:	788080e7          	jalr	1928(ra) # 80000d92 <acquire>
    havekids = 0;
    80002612:	4c81                	li	s9,0
        if (np->state == ZOMBIE)
    80002614:	4a15                	li	s4,5
        havekids = 1;
    80002616:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++)
    80002618:	00237997          	auipc	s3,0x237
    8000261c:	c0098993          	addi	s3,s3,-1024 # 80239218 <mlfq>
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002620:	0022fd17          	auipc	s10,0x22f
    80002624:	7e0d0d13          	addi	s10,s10,2016 # 80231e00 <wait_lock>
    havekids = 0;
    80002628:	8766                	mv	a4,s9
    for (np = proc; np < &proc[NPROC]; np++)
    8000262a:	00230497          	auipc	s1,0x230
    8000262e:	bee48493          	addi	s1,s1,-1042 # 80232218 <proc>
    80002632:	a059                	j	800026b8 <waitx+0xe2>
          pid = np->pid;
    80002634:	0304a983          	lw	s3,48(s1)
          *rtime = np->rtime;
    80002638:	1684a703          	lw	a4,360(s1)
    8000263c:	00ec2023          	sw	a4,0(s8)
          *wtime = np->etime - np->ctime - np->rtime;
    80002640:	16c4a783          	lw	a5,364(s1)
    80002644:	9f3d                	addw	a4,a4,a5
    80002646:	1704a783          	lw	a5,368(s1)
    8000264a:	9f99                	subw	a5,a5,a4
    8000264c:	00fba023          	sw	a5,0(s7)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002650:	000b0e63          	beqz	s6,8000266c <waitx+0x96>
    80002654:	4691                	li	a3,4
    80002656:	02c48613          	addi	a2,s1,44
    8000265a:	85da                	mv	a1,s6
    8000265c:	05093503          	ld	a0,80(s2)
    80002660:	fffff097          	auipc	ra,0xfffff
    80002664:	1e2080e7          	jalr	482(ra) # 80001842 <copyout>
    80002668:	02054563          	bltz	a0,80002692 <waitx+0xbc>
          freeproc(np);
    8000266c:	8526                	mv	a0,s1
    8000266e:	fffff097          	auipc	ra,0xfffff
    80002672:	732080e7          	jalr	1842(ra) # 80001da0 <freeproc>
          release(&np->lock);
    80002676:	8526                	mv	a0,s1
    80002678:	ffffe097          	auipc	ra,0xffffe
    8000267c:	7ce080e7          	jalr	1998(ra) # 80000e46 <release>
          release(&wait_lock);
    80002680:	0022f517          	auipc	a0,0x22f
    80002684:	78050513          	addi	a0,a0,1920 # 80231e00 <wait_lock>
    80002688:	ffffe097          	auipc	ra,0xffffe
    8000268c:	7be080e7          	jalr	1982(ra) # 80000e46 <release>
          return pid;
    80002690:	a09d                	j	800026f6 <waitx+0x120>
            release(&np->lock);
    80002692:	8526                	mv	a0,s1
    80002694:	ffffe097          	auipc	ra,0xffffe
    80002698:	7b2080e7          	jalr	1970(ra) # 80000e46 <release>
            release(&wait_lock);
    8000269c:	0022f517          	auipc	a0,0x22f
    800026a0:	76450513          	addi	a0,a0,1892 # 80231e00 <wait_lock>
    800026a4:	ffffe097          	auipc	ra,0xffffe
    800026a8:	7a2080e7          	jalr	1954(ra) # 80000e46 <release>
            return -1;
    800026ac:	59fd                	li	s3,-1
    800026ae:	a0a1                	j	800026f6 <waitx+0x120>
    for (np = proc; np < &proc[NPROC]; np++)
    800026b0:	1c048493          	addi	s1,s1,448
    800026b4:	03348463          	beq	s1,s3,800026dc <waitx+0x106>
      if (np->parent == p)
    800026b8:	7c9c                	ld	a5,56(s1)
    800026ba:	ff279be3          	bne	a5,s2,800026b0 <waitx+0xda>
        acquire(&np->lock);
    800026be:	8526                	mv	a0,s1
    800026c0:	ffffe097          	auipc	ra,0xffffe
    800026c4:	6d2080e7          	jalr	1746(ra) # 80000d92 <acquire>
        if (np->state == ZOMBIE)
    800026c8:	4c9c                	lw	a5,24(s1)
    800026ca:	f74785e3          	beq	a5,s4,80002634 <waitx+0x5e>
        release(&np->lock);
    800026ce:	8526                	mv	a0,s1
    800026d0:	ffffe097          	auipc	ra,0xffffe
    800026d4:	776080e7          	jalr	1910(ra) # 80000e46 <release>
        havekids = 1;
    800026d8:	8756                	mv	a4,s5
    800026da:	bfd9                	j	800026b0 <waitx+0xda>
    if (!havekids || p->killed)
    800026dc:	c701                	beqz	a4,800026e4 <waitx+0x10e>
    800026de:	02892783          	lw	a5,40(s2)
    800026e2:	cb8d                	beqz	a5,80002714 <waitx+0x13e>
      release(&wait_lock);
    800026e4:	0022f517          	auipc	a0,0x22f
    800026e8:	71c50513          	addi	a0,a0,1820 # 80231e00 <wait_lock>
    800026ec:	ffffe097          	auipc	ra,0xffffe
    800026f0:	75a080e7          	jalr	1882(ra) # 80000e46 <release>
      return -1;
    800026f4:	59fd                	li	s3,-1
}
    800026f6:	854e                	mv	a0,s3
    800026f8:	60e6                	ld	ra,88(sp)
    800026fa:	6446                	ld	s0,80(sp)
    800026fc:	64a6                	ld	s1,72(sp)
    800026fe:	6906                	ld	s2,64(sp)
    80002700:	79e2                	ld	s3,56(sp)
    80002702:	7a42                	ld	s4,48(sp)
    80002704:	7aa2                	ld	s5,40(sp)
    80002706:	7b02                	ld	s6,32(sp)
    80002708:	6be2                	ld	s7,24(sp)
    8000270a:	6c42                	ld	s8,16(sp)
    8000270c:	6ca2                	ld	s9,8(sp)
    8000270e:	6d02                	ld	s10,0(sp)
    80002710:	6125                	addi	sp,sp,96
    80002712:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002714:	85ea                	mv	a1,s10
    80002716:	854a                	mv	a0,s2
    80002718:	00000097          	auipc	ra,0x0
    8000271c:	e4e080e7          	jalr	-434(ra) # 80002566 <sleep>
    havekids = 0;
    80002720:	b721                	j	80002628 <waitx+0x52>

0000000080002722 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    80002722:	7139                	addi	sp,sp,-64
    80002724:	fc06                	sd	ra,56(sp)
    80002726:	f822                	sd	s0,48(sp)
    80002728:	f426                	sd	s1,40(sp)
    8000272a:	f04a                	sd	s2,32(sp)
    8000272c:	ec4e                	sd	s3,24(sp)
    8000272e:	e852                	sd	s4,16(sp)
    80002730:	e456                	sd	s5,8(sp)
    80002732:	e05a                	sd	s6,0(sp)
    80002734:	0080                	addi	s0,sp,64
    80002736:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80002738:	00230497          	auipc	s1,0x230
    8000273c:	ae048493          	addi	s1,s1,-1312 # 80232218 <proc>
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
    80002740:	4989                	li	s3,2
      {
        p->sleeping_ticks += (ticks - p->sleep_start);
    80002742:	00007b17          	auipc	s6,0x7
    80002746:	426b0b13          	addi	s6,s6,1062 # 80009b68 <ticks>
        p->state = RUNNABLE;
    8000274a:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++)
    8000274c:	00237917          	auipc	s2,0x237
    80002750:	acc90913          	addi	s2,s2,-1332 # 80239218 <mlfq>
    80002754:	a811                	j	80002768 <wakeup+0x46>
      }
      release(&p->lock);
    80002756:	8526                	mv	a0,s1
    80002758:	ffffe097          	auipc	ra,0xffffe
    8000275c:	6ee080e7          	jalr	1774(ra) # 80000e46 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002760:	1c048493          	addi	s1,s1,448
    80002764:	05248063          	beq	s1,s2,800027a4 <wakeup+0x82>
    if (p != myproc())
    80002768:	fffff097          	auipc	ra,0xfffff
    8000276c:	486080e7          	jalr	1158(ra) # 80001bee <myproc>
    80002770:	fea488e3          	beq	s1,a0,80002760 <wakeup+0x3e>
      acquire(&p->lock);
    80002774:	8526                	mv	a0,s1
    80002776:	ffffe097          	auipc	ra,0xffffe
    8000277a:	61c080e7          	jalr	1564(ra) # 80000d92 <acquire>
      if (p->state == SLEEPING && p->chan == chan)
    8000277e:	4c9c                	lw	a5,24(s1)
    80002780:	fd379be3          	bne	a5,s3,80002756 <wakeup+0x34>
    80002784:	709c                	ld	a5,32(s1)
    80002786:	fd4798e3          	bne	a5,s4,80002756 <wakeup+0x34>
        p->sleeping_ticks += (ticks - p->sleep_start);
    8000278a:	1884a783          	lw	a5,392(s1)
    8000278e:	000b2703          	lw	a4,0(s6)
    80002792:	9fb9                	addw	a5,a5,a4
    80002794:	1804a703          	lw	a4,384(s1)
    80002798:	9f99                	subw	a5,a5,a4
    8000279a:	18f4a423          	sw	a5,392(s1)
        p->state = RUNNABLE;
    8000279e:	0154ac23          	sw	s5,24(s1)
    800027a2:	bf55                	j	80002756 <wakeup+0x34>
    }
  }
}
    800027a4:	70e2                	ld	ra,56(sp)
    800027a6:	7442                	ld	s0,48(sp)
    800027a8:	74a2                	ld	s1,40(sp)
    800027aa:	7902                	ld	s2,32(sp)
    800027ac:	69e2                	ld	s3,24(sp)
    800027ae:	6a42                	ld	s4,16(sp)
    800027b0:	6aa2                	ld	s5,8(sp)
    800027b2:	6b02                	ld	s6,0(sp)
    800027b4:	6121                	addi	sp,sp,64
    800027b6:	8082                	ret

00000000800027b8 <reparent>:
{
    800027b8:	7179                	addi	sp,sp,-48
    800027ba:	f406                	sd	ra,40(sp)
    800027bc:	f022                	sd	s0,32(sp)
    800027be:	ec26                	sd	s1,24(sp)
    800027c0:	e84a                	sd	s2,16(sp)
    800027c2:	e44e                	sd	s3,8(sp)
    800027c4:	e052                	sd	s4,0(sp)
    800027c6:	1800                	addi	s0,sp,48
    800027c8:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++)
    800027ca:	00230497          	auipc	s1,0x230
    800027ce:	a4e48493          	addi	s1,s1,-1458 # 80232218 <proc>
      pp->parent = initproc;
    800027d2:	00007a17          	auipc	s4,0x7
    800027d6:	38ea0a13          	addi	s4,s4,910 # 80009b60 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    800027da:	00237997          	auipc	s3,0x237
    800027de:	a3e98993          	addi	s3,s3,-1474 # 80239218 <mlfq>
    800027e2:	a029                	j	800027ec <reparent+0x34>
    800027e4:	1c048493          	addi	s1,s1,448
    800027e8:	01348d63          	beq	s1,s3,80002802 <reparent+0x4a>
    if (pp->parent == p)
    800027ec:	7c9c                	ld	a5,56(s1)
    800027ee:	ff279be3          	bne	a5,s2,800027e4 <reparent+0x2c>
      pp->parent = initproc;
    800027f2:	000a3503          	ld	a0,0(s4)
    800027f6:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800027f8:	00000097          	auipc	ra,0x0
    800027fc:	f2a080e7          	jalr	-214(ra) # 80002722 <wakeup>
    80002800:	b7d5                	j	800027e4 <reparent+0x2c>
}
    80002802:	70a2                	ld	ra,40(sp)
    80002804:	7402                	ld	s0,32(sp)
    80002806:	64e2                	ld	s1,24(sp)
    80002808:	6942                	ld	s2,16(sp)
    8000280a:	69a2                	ld	s3,8(sp)
    8000280c:	6a02                	ld	s4,0(sp)
    8000280e:	6145                	addi	sp,sp,48
    80002810:	8082                	ret

0000000080002812 <exit>:
{
    80002812:	7179                	addi	sp,sp,-48
    80002814:	f406                	sd	ra,40(sp)
    80002816:	f022                	sd	s0,32(sp)
    80002818:	ec26                	sd	s1,24(sp)
    8000281a:	e84a                	sd	s2,16(sp)
    8000281c:	e44e                	sd	s3,8(sp)
    8000281e:	e052                	sd	s4,0(sp)
    80002820:	1800                	addi	s0,sp,48
    80002822:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002824:	fffff097          	auipc	ra,0xfffff
    80002828:	3ca080e7          	jalr	970(ra) # 80001bee <myproc>
    8000282c:	89aa                	mv	s3,a0
  if (p == initproc)
    8000282e:	00007797          	auipc	a5,0x7
    80002832:	3327b783          	ld	a5,818(a5) # 80009b60 <initproc>
    80002836:	0d050493          	addi	s1,a0,208
    8000283a:	15050913          	addi	s2,a0,336
    8000283e:	02a79363          	bne	a5,a0,80002864 <exit+0x52>
    panic("init exiting");
    80002842:	00007517          	auipc	a0,0x7
    80002846:	a7e50513          	addi	a0,a0,-1410 # 800092c0 <digits+0x280>
    8000284a:	ffffe097          	auipc	ra,0xffffe
    8000284e:	cf4080e7          	jalr	-780(ra) # 8000053e <panic>
      fileclose(f);
    80002852:	00002097          	auipc	ra,0x2
    80002856:	798080e7          	jalr	1944(ra) # 80004fea <fileclose>
      p->ofile[fd] = 0;
    8000285a:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++)
    8000285e:	04a1                	addi	s1,s1,8
    80002860:	01248563          	beq	s1,s2,8000286a <exit+0x58>
    if (p->ofile[fd])
    80002864:	6088                	ld	a0,0(s1)
    80002866:	f575                	bnez	a0,80002852 <exit+0x40>
    80002868:	bfdd                	j	8000285e <exit+0x4c>
  begin_op();
    8000286a:	00002097          	auipc	ra,0x2
    8000286e:	2b4080e7          	jalr	692(ra) # 80004b1e <begin_op>
  iput(p->cwd);
    80002872:	1509b503          	ld	a0,336(s3)
    80002876:	00002097          	auipc	ra,0x2
    8000287a:	aa0080e7          	jalr	-1376(ra) # 80004316 <iput>
  end_op();
    8000287e:	00002097          	auipc	ra,0x2
    80002882:	320080e7          	jalr	800(ra) # 80004b9e <end_op>
  p->cwd = 0;
    80002886:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000288a:	0022f497          	auipc	s1,0x22f
    8000288e:	57648493          	addi	s1,s1,1398 # 80231e00 <wait_lock>
    80002892:	8526                	mv	a0,s1
    80002894:	ffffe097          	auipc	ra,0xffffe
    80002898:	4fe080e7          	jalr	1278(ra) # 80000d92 <acquire>
  reparent(p);
    8000289c:	854e                	mv	a0,s3
    8000289e:	00000097          	auipc	ra,0x0
    800028a2:	f1a080e7          	jalr	-230(ra) # 800027b8 <reparent>
  wakeup(p->parent);
    800028a6:	0389b503          	ld	a0,56(s3)
    800028aa:	00000097          	auipc	ra,0x0
    800028ae:	e78080e7          	jalr	-392(ra) # 80002722 <wakeup>
  acquire(&p->lock);
    800028b2:	854e                	mv	a0,s3
    800028b4:	ffffe097          	auipc	ra,0xffffe
    800028b8:	4de080e7          	jalr	1246(ra) # 80000d92 <acquire>
  p->xstate = status;
    800028bc:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800028c0:	4795                	li	a5,5
    800028c2:	00f9ac23          	sw	a5,24(s3)
  p->etime = ticks;
    800028c6:	00007797          	auipc	a5,0x7
    800028ca:	2a27a783          	lw	a5,674(a5) # 80009b68 <ticks>
    800028ce:	16f9a823          	sw	a5,368(s3)
  release(&wait_lock);
    800028d2:	8526                	mv	a0,s1
    800028d4:	ffffe097          	auipc	ra,0xffffe
    800028d8:	572080e7          	jalr	1394(ra) # 80000e46 <release>
  sched();
    800028dc:	00000097          	auipc	ra,0x0
    800028e0:	b78080e7          	jalr	-1160(ra) # 80002454 <sched>
  panic("zombie exit");
    800028e4:	00007517          	auipc	a0,0x7
    800028e8:	9ec50513          	addi	a0,a0,-1556 # 800092d0 <digits+0x290>
    800028ec:	ffffe097          	auipc	ra,0xffffe
    800028f0:	c52080e7          	jalr	-942(ra) # 8000053e <panic>

00000000800028f4 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    800028f4:	7179                	addi	sp,sp,-48
    800028f6:	f406                	sd	ra,40(sp)
    800028f8:	f022                	sd	s0,32(sp)
    800028fa:	ec26                	sd	s1,24(sp)
    800028fc:	e84a                	sd	s2,16(sp)
    800028fe:	e44e                	sd	s3,8(sp)
    80002900:	1800                	addi	s0,sp,48
    80002902:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80002904:	00230497          	auipc	s1,0x230
    80002908:	91448493          	addi	s1,s1,-1772 # 80232218 <proc>
    8000290c:	00237997          	auipc	s3,0x237
    80002910:	90c98993          	addi	s3,s3,-1780 # 80239218 <mlfq>
  {
    acquire(&p->lock);
    80002914:	8526                	mv	a0,s1
    80002916:	ffffe097          	auipc	ra,0xffffe
    8000291a:	47c080e7          	jalr	1148(ra) # 80000d92 <acquire>
    if (p->pid == pid)
    8000291e:	589c                	lw	a5,48(s1)
    80002920:	01278d63          	beq	a5,s2,8000293a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002924:	8526                	mv	a0,s1
    80002926:	ffffe097          	auipc	ra,0xffffe
    8000292a:	520080e7          	jalr	1312(ra) # 80000e46 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    8000292e:	1c048493          	addi	s1,s1,448
    80002932:	ff3491e3          	bne	s1,s3,80002914 <kill+0x20>
  }
  return -1;
    80002936:	557d                	li	a0,-1
    80002938:	a829                	j	80002952 <kill+0x5e>
      p->killed = 1;
    8000293a:	4785                	li	a5,1
    8000293c:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING)
    8000293e:	4c98                	lw	a4,24(s1)
    80002940:	4789                	li	a5,2
    80002942:	00f70f63          	beq	a4,a5,80002960 <kill+0x6c>
      release(&p->lock);
    80002946:	8526                	mv	a0,s1
    80002948:	ffffe097          	auipc	ra,0xffffe
    8000294c:	4fe080e7          	jalr	1278(ra) # 80000e46 <release>
      return 0;
    80002950:	4501                	li	a0,0
}
    80002952:	70a2                	ld	ra,40(sp)
    80002954:	7402                	ld	s0,32(sp)
    80002956:	64e2                	ld	s1,24(sp)
    80002958:	6942                	ld	s2,16(sp)
    8000295a:	69a2                	ld	s3,8(sp)
    8000295c:	6145                	addi	sp,sp,48
    8000295e:	8082                	ret
        p->state = RUNNABLE;
    80002960:	478d                	li	a5,3
    80002962:	cc9c                	sw	a5,24(s1)
    80002964:	b7cd                	j	80002946 <kill+0x52>

0000000080002966 <setkilled>:

void setkilled(struct proc *p)
{
    80002966:	1101                	addi	sp,sp,-32
    80002968:	ec06                	sd	ra,24(sp)
    8000296a:	e822                	sd	s0,16(sp)
    8000296c:	e426                	sd	s1,8(sp)
    8000296e:	1000                	addi	s0,sp,32
    80002970:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002972:	ffffe097          	auipc	ra,0xffffe
    80002976:	420080e7          	jalr	1056(ra) # 80000d92 <acquire>
  p->killed = 1;
    8000297a:	4785                	li	a5,1
    8000297c:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000297e:	8526                	mv	a0,s1
    80002980:	ffffe097          	auipc	ra,0xffffe
    80002984:	4c6080e7          	jalr	1222(ra) # 80000e46 <release>
}
    80002988:	60e2                	ld	ra,24(sp)
    8000298a:	6442                	ld	s0,16(sp)
    8000298c:	64a2                	ld	s1,8(sp)
    8000298e:	6105                	addi	sp,sp,32
    80002990:	8082                	ret

0000000080002992 <killed>:

int killed(struct proc *p)
{
    80002992:	1101                	addi	sp,sp,-32
    80002994:	ec06                	sd	ra,24(sp)
    80002996:	e822                	sd	s0,16(sp)
    80002998:	e426                	sd	s1,8(sp)
    8000299a:	e04a                	sd	s2,0(sp)
    8000299c:	1000                	addi	s0,sp,32
    8000299e:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    800029a0:	ffffe097          	auipc	ra,0xffffe
    800029a4:	3f2080e7          	jalr	1010(ra) # 80000d92 <acquire>
  k = p->killed;
    800029a8:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800029ac:	8526                	mv	a0,s1
    800029ae:	ffffe097          	auipc	ra,0xffffe
    800029b2:	498080e7          	jalr	1176(ra) # 80000e46 <release>
  return k;
}
    800029b6:	854a                	mv	a0,s2
    800029b8:	60e2                	ld	ra,24(sp)
    800029ba:	6442                	ld	s0,16(sp)
    800029bc:	64a2                	ld	s1,8(sp)
    800029be:	6902                	ld	s2,0(sp)
    800029c0:	6105                	addi	sp,sp,32
    800029c2:	8082                	ret

00000000800029c4 <wait>:
{
    800029c4:	715d                	addi	sp,sp,-80
    800029c6:	e486                	sd	ra,72(sp)
    800029c8:	e0a2                	sd	s0,64(sp)
    800029ca:	fc26                	sd	s1,56(sp)
    800029cc:	f84a                	sd	s2,48(sp)
    800029ce:	f44e                	sd	s3,40(sp)
    800029d0:	f052                	sd	s4,32(sp)
    800029d2:	ec56                	sd	s5,24(sp)
    800029d4:	e85a                	sd	s6,16(sp)
    800029d6:	e45e                	sd	s7,8(sp)
    800029d8:	e062                	sd	s8,0(sp)
    800029da:	0880                	addi	s0,sp,80
    800029dc:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800029de:	fffff097          	auipc	ra,0xfffff
    800029e2:	210080e7          	jalr	528(ra) # 80001bee <myproc>
    800029e6:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800029e8:	0022f517          	auipc	a0,0x22f
    800029ec:	41850513          	addi	a0,a0,1048 # 80231e00 <wait_lock>
    800029f0:	ffffe097          	auipc	ra,0xffffe
    800029f4:	3a2080e7          	jalr	930(ra) # 80000d92 <acquire>
    havekids = 0;
    800029f8:	4b81                	li	s7,0
        if (pp->state == ZOMBIE)
    800029fa:	4a15                	li	s4,5
        havekids = 1;
    800029fc:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800029fe:	00237997          	auipc	s3,0x237
    80002a02:	81a98993          	addi	s3,s3,-2022 # 80239218 <mlfq>
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002a06:	0022fc17          	auipc	s8,0x22f
    80002a0a:	3fac0c13          	addi	s8,s8,1018 # 80231e00 <wait_lock>
    havekids = 0;
    80002a0e:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002a10:	00230497          	auipc	s1,0x230
    80002a14:	80848493          	addi	s1,s1,-2040 # 80232218 <proc>
    80002a18:	a0bd                	j	80002a86 <wait+0xc2>
          pid = pp->pid;
    80002a1a:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002a1e:	000b0e63          	beqz	s6,80002a3a <wait+0x76>
    80002a22:	4691                	li	a3,4
    80002a24:	02c48613          	addi	a2,s1,44
    80002a28:	85da                	mv	a1,s6
    80002a2a:	05093503          	ld	a0,80(s2)
    80002a2e:	fffff097          	auipc	ra,0xfffff
    80002a32:	e14080e7          	jalr	-492(ra) # 80001842 <copyout>
    80002a36:	02054563          	bltz	a0,80002a60 <wait+0x9c>
          freeproc(pp);
    80002a3a:	8526                	mv	a0,s1
    80002a3c:	fffff097          	auipc	ra,0xfffff
    80002a40:	364080e7          	jalr	868(ra) # 80001da0 <freeproc>
          release(&pp->lock);
    80002a44:	8526                	mv	a0,s1
    80002a46:	ffffe097          	auipc	ra,0xffffe
    80002a4a:	400080e7          	jalr	1024(ra) # 80000e46 <release>
          release(&wait_lock);
    80002a4e:	0022f517          	auipc	a0,0x22f
    80002a52:	3b250513          	addi	a0,a0,946 # 80231e00 <wait_lock>
    80002a56:	ffffe097          	auipc	ra,0xffffe
    80002a5a:	3f0080e7          	jalr	1008(ra) # 80000e46 <release>
          return pid;
    80002a5e:	a0b5                	j	80002aca <wait+0x106>
            release(&pp->lock);
    80002a60:	8526                	mv	a0,s1
    80002a62:	ffffe097          	auipc	ra,0xffffe
    80002a66:	3e4080e7          	jalr	996(ra) # 80000e46 <release>
            release(&wait_lock);
    80002a6a:	0022f517          	auipc	a0,0x22f
    80002a6e:	39650513          	addi	a0,a0,918 # 80231e00 <wait_lock>
    80002a72:	ffffe097          	auipc	ra,0xffffe
    80002a76:	3d4080e7          	jalr	980(ra) # 80000e46 <release>
            return -1;
    80002a7a:	59fd                	li	s3,-1
    80002a7c:	a0b9                	j	80002aca <wait+0x106>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002a7e:	1c048493          	addi	s1,s1,448
    80002a82:	03348463          	beq	s1,s3,80002aaa <wait+0xe6>
      if (pp->parent == p)
    80002a86:	7c9c                	ld	a5,56(s1)
    80002a88:	ff279be3          	bne	a5,s2,80002a7e <wait+0xba>
        acquire(&pp->lock);
    80002a8c:	8526                	mv	a0,s1
    80002a8e:	ffffe097          	auipc	ra,0xffffe
    80002a92:	304080e7          	jalr	772(ra) # 80000d92 <acquire>
        if (pp->state == ZOMBIE)
    80002a96:	4c9c                	lw	a5,24(s1)
    80002a98:	f94781e3          	beq	a5,s4,80002a1a <wait+0x56>
        release(&pp->lock);
    80002a9c:	8526                	mv	a0,s1
    80002a9e:	ffffe097          	auipc	ra,0xffffe
    80002aa2:	3a8080e7          	jalr	936(ra) # 80000e46 <release>
        havekids = 1;
    80002aa6:	8756                	mv	a4,s5
    80002aa8:	bfd9                	j	80002a7e <wait+0xba>
    if (!havekids || killed(p))
    80002aaa:	c719                	beqz	a4,80002ab8 <wait+0xf4>
    80002aac:	854a                	mv	a0,s2
    80002aae:	00000097          	auipc	ra,0x0
    80002ab2:	ee4080e7          	jalr	-284(ra) # 80002992 <killed>
    80002ab6:	c51d                	beqz	a0,80002ae4 <wait+0x120>
      release(&wait_lock);
    80002ab8:	0022f517          	auipc	a0,0x22f
    80002abc:	34850513          	addi	a0,a0,840 # 80231e00 <wait_lock>
    80002ac0:	ffffe097          	auipc	ra,0xffffe
    80002ac4:	386080e7          	jalr	902(ra) # 80000e46 <release>
      return -1;
    80002ac8:	59fd                	li	s3,-1
}
    80002aca:	854e                	mv	a0,s3
    80002acc:	60a6                	ld	ra,72(sp)
    80002ace:	6406                	ld	s0,64(sp)
    80002ad0:	74e2                	ld	s1,56(sp)
    80002ad2:	7942                	ld	s2,48(sp)
    80002ad4:	79a2                	ld	s3,40(sp)
    80002ad6:	7a02                	ld	s4,32(sp)
    80002ad8:	6ae2                	ld	s5,24(sp)
    80002ada:	6b42                	ld	s6,16(sp)
    80002adc:	6ba2                	ld	s7,8(sp)
    80002ade:	6c02                	ld	s8,0(sp)
    80002ae0:	6161                	addi	sp,sp,80
    80002ae2:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002ae4:	85e2                	mv	a1,s8
    80002ae6:	854a                	mv	a0,s2
    80002ae8:	00000097          	auipc	ra,0x0
    80002aec:	a7e080e7          	jalr	-1410(ra) # 80002566 <sleep>
    havekids = 0;
    80002af0:	bf39                	j	80002a0e <wait+0x4a>

0000000080002af2 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002af2:	7179                	addi	sp,sp,-48
    80002af4:	f406                	sd	ra,40(sp)
    80002af6:	f022                	sd	s0,32(sp)
    80002af8:	ec26                	sd	s1,24(sp)
    80002afa:	e84a                	sd	s2,16(sp)
    80002afc:	e44e                	sd	s3,8(sp)
    80002afe:	e052                	sd	s4,0(sp)
    80002b00:	1800                	addi	s0,sp,48
    80002b02:	84aa                	mv	s1,a0
    80002b04:	892e                	mv	s2,a1
    80002b06:	89b2                	mv	s3,a2
    80002b08:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002b0a:	fffff097          	auipc	ra,0xfffff
    80002b0e:	0e4080e7          	jalr	228(ra) # 80001bee <myproc>
  if (user_dst)
    80002b12:	c08d                	beqz	s1,80002b34 <either_copyout+0x42>
  {
    return copyout(p->pagetable, dst, src, len);
    80002b14:	86d2                	mv	a3,s4
    80002b16:	864e                	mv	a2,s3
    80002b18:	85ca                	mv	a1,s2
    80002b1a:	6928                	ld	a0,80(a0)
    80002b1c:	fffff097          	auipc	ra,0xfffff
    80002b20:	d26080e7          	jalr	-730(ra) # 80001842 <copyout>
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002b24:	70a2                	ld	ra,40(sp)
    80002b26:	7402                	ld	s0,32(sp)
    80002b28:	64e2                	ld	s1,24(sp)
    80002b2a:	6942                	ld	s2,16(sp)
    80002b2c:	69a2                	ld	s3,8(sp)
    80002b2e:	6a02                	ld	s4,0(sp)
    80002b30:	6145                	addi	sp,sp,48
    80002b32:	8082                	ret
    memmove((char *)dst, src, len);
    80002b34:	000a061b          	sext.w	a2,s4
    80002b38:	85ce                	mv	a1,s3
    80002b3a:	854a                	mv	a0,s2
    80002b3c:	ffffe097          	auipc	ra,0xffffe
    80002b40:	3ae080e7          	jalr	942(ra) # 80000eea <memmove>
    return 0;
    80002b44:	8526                	mv	a0,s1
    80002b46:	bff9                	j	80002b24 <either_copyout+0x32>

0000000080002b48 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002b48:	7179                	addi	sp,sp,-48
    80002b4a:	f406                	sd	ra,40(sp)
    80002b4c:	f022                	sd	s0,32(sp)
    80002b4e:	ec26                	sd	s1,24(sp)
    80002b50:	e84a                	sd	s2,16(sp)
    80002b52:	e44e                	sd	s3,8(sp)
    80002b54:	e052                	sd	s4,0(sp)
    80002b56:	1800                	addi	s0,sp,48
    80002b58:	892a                	mv	s2,a0
    80002b5a:	84ae                	mv	s1,a1
    80002b5c:	89b2                	mv	s3,a2
    80002b5e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002b60:	fffff097          	auipc	ra,0xfffff
    80002b64:	08e080e7          	jalr	142(ra) # 80001bee <myproc>
  if (user_src)
    80002b68:	c08d                	beqz	s1,80002b8a <either_copyin+0x42>
  {
    return copyin(p->pagetable, dst, src, len);
    80002b6a:	86d2                	mv	a3,s4
    80002b6c:	864e                	mv	a2,s3
    80002b6e:	85ca                	mv	a1,s2
    80002b70:	6928                	ld	a0,80(a0)
    80002b72:	fffff097          	auipc	ra,0xfffff
    80002b76:	d98080e7          	jalr	-616(ra) # 8000190a <copyin>
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80002b7a:	70a2                	ld	ra,40(sp)
    80002b7c:	7402                	ld	s0,32(sp)
    80002b7e:	64e2                	ld	s1,24(sp)
    80002b80:	6942                	ld	s2,16(sp)
    80002b82:	69a2                	ld	s3,8(sp)
    80002b84:	6a02                	ld	s4,0(sp)
    80002b86:	6145                	addi	sp,sp,48
    80002b88:	8082                	ret
    memmove(dst, (char *)src, len);
    80002b8a:	000a061b          	sext.w	a2,s4
    80002b8e:	85ce                	mv	a1,s3
    80002b90:	854a                	mv	a0,s2
    80002b92:	ffffe097          	auipc	ra,0xffffe
    80002b96:	358080e7          	jalr	856(ra) # 80000eea <memmove>
    return 0;
    80002b9a:	8526                	mv	a0,s1
    80002b9c:	bff9                	j	80002b7a <either_copyin+0x32>

0000000080002b9e <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80002b9e:	715d                	addi	sp,sp,-80
    80002ba0:	e486                	sd	ra,72(sp)
    80002ba2:	e0a2                	sd	s0,64(sp)
    80002ba4:	fc26                	sd	s1,56(sp)
    80002ba6:	f84a                	sd	s2,48(sp)
    80002ba8:	f44e                	sd	s3,40(sp)
    80002baa:	f052                	sd	s4,32(sp)
    80002bac:	ec56                	sd	s5,24(sp)
    80002bae:	e85a                	sd	s6,16(sp)
    80002bb0:	e45e                	sd	s7,8(sp)
    80002bb2:	0880                	addi	s0,sp,80
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    80002bb4:	00006517          	auipc	a0,0x6
    80002bb8:	55450513          	addi	a0,a0,1364 # 80009108 <digits+0xc8>
    80002bbc:	ffffe097          	auipc	ra,0xffffe
    80002bc0:	9cc080e7          	jalr	-1588(ra) # 80000588 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80002bc4:	0022f497          	auipc	s1,0x22f
    80002bc8:	7ac48493          	addi	s1,s1,1964 # 80232370 <proc+0x158>
    80002bcc:	00236917          	auipc	s2,0x236
    80002bd0:	7a490913          	addi	s2,s2,1956 # 80239370 <mlfq+0x158>
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002bd4:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002bd6:	00006997          	auipc	s3,0x6
    80002bda:	70a98993          	addi	s3,s3,1802 # 800092e0 <digits+0x2a0>
    printf("%d %s %s ctime=%d static_prior=%d", p->pid, state, p->name, p->ctime, p->static_priority);
    80002bde:	00006a97          	auipc	s5,0x6
    80002be2:	70aa8a93          	addi	s5,s5,1802 # 800092e8 <digits+0x2a8>
    printf("\n");
    80002be6:	00006a17          	auipc	s4,0x6
    80002bea:	522a0a13          	addi	s4,s4,1314 # 80009108 <digits+0xc8>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002bee:	00006b97          	auipc	s7,0x6
    80002bf2:	752b8b93          	addi	s7,s7,1874 # 80009340 <states.0>
    80002bf6:	a01d                	j	80002c1c <procdump+0x7e>
    printf("%d %s %s ctime=%d static_prior=%d", p->pid, state, p->name, p->ctime, p->static_priority);
    80002bf8:	52dc                	lw	a5,36(a3)
    80002bfa:	4ad8                	lw	a4,20(a3)
    80002bfc:	ed86a583          	lw	a1,-296(a3)
    80002c00:	8556                	mv	a0,s5
    80002c02:	ffffe097          	auipc	ra,0xffffe
    80002c06:	986080e7          	jalr	-1658(ra) # 80000588 <printf>
    printf("\n");
    80002c0a:	8552                	mv	a0,s4
    80002c0c:	ffffe097          	auipc	ra,0xffffe
    80002c10:	97c080e7          	jalr	-1668(ra) # 80000588 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80002c14:	1c048493          	addi	s1,s1,448
    80002c18:	03248163          	beq	s1,s2,80002c3a <procdump+0x9c>
    if (p->state == UNUSED)
    80002c1c:	86a6                	mv	a3,s1
    80002c1e:	ec04a783          	lw	a5,-320(s1)
    80002c22:	dbed                	beqz	a5,80002c14 <procdump+0x76>
      state = "???";
    80002c24:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002c26:	fcfb69e3          	bltu	s6,a5,80002bf8 <procdump+0x5a>
    80002c2a:	1782                	slli	a5,a5,0x20
    80002c2c:	9381                	srli	a5,a5,0x20
    80002c2e:	078e                	slli	a5,a5,0x3
    80002c30:	97de                	add	a5,a5,s7
    80002c32:	6390                	ld	a2,0(a5)
    80002c34:	f271                	bnez	a2,80002bf8 <procdump+0x5a>
      state = "???";
    80002c36:	864e                	mv	a2,s3
    80002c38:	b7c1                	j	80002bf8 <procdump+0x5a>
  }
}
    80002c3a:	60a6                	ld	ra,72(sp)
    80002c3c:	6406                	ld	s0,64(sp)
    80002c3e:	74e2                	ld	s1,56(sp)
    80002c40:	7942                	ld	s2,48(sp)
    80002c42:	79a2                	ld	s3,40(sp)
    80002c44:	7a02                	ld	s4,32(sp)
    80002c46:	6ae2                	ld	s5,24(sp)
    80002c48:	6b42                	ld	s6,16(sp)
    80002c4a:	6ba2                	ld	s7,8(sp)
    80002c4c:	6161                	addi	sp,sp,80
    80002c4e:	8082                	ret

0000000080002c50 <setpriority>:
int setpriority(int number, int piid)
{
    80002c50:	7179                	addi	sp,sp,-48
    80002c52:	f406                	sd	ra,40(sp)
    80002c54:	f022                	sd	s0,32(sp)
    80002c56:	ec26                	sd	s1,24(sp)
    80002c58:	e84a                	sd	s2,16(sp)
    80002c5a:	e44e                	sd	s3,8(sp)
    80002c5c:	e052                	sd	s4,0(sp)
    80002c5e:	1800                	addi	s0,sp,48
    80002c60:	8a2a                	mv	s4,a0
    80002c62:	892e                	mv	s2,a1
  uint original = 0;
  for (struct proc *p = proc; p < &proc[NPROC]; p++)
    80002c64:	0022f497          	auipc	s1,0x22f
    80002c68:	5b448493          	addi	s1,s1,1460 # 80232218 <proc>
    80002c6c:	00236997          	auipc	s3,0x236
    80002c70:	5ac98993          	addi	s3,s3,1452 # 80239218 <mlfq>
  {
    acquire(&p->lock);
    80002c74:	8526                	mv	a0,s1
    80002c76:	ffffe097          	auipc	ra,0xffffe
    80002c7a:	11c080e7          	jalr	284(ra) # 80000d92 <acquire>
    if (p->pid == piid)
    80002c7e:	589c                	lw	a5,48(s1)
    80002c80:	01278d63          	beq	a5,s2,80002c9a <setpriority+0x4a>
        // printf("%d %d %d\n", p->pid, p->static_priority, original);
        yield();
      }
      break;
    }
    release(&p->lock);
    80002c84:	8526                	mv	a0,s1
    80002c86:	ffffe097          	auipc	ra,0xffffe
    80002c8a:	1c0080e7          	jalr	448(ra) # 80000e46 <release>
  for (struct proc *p = proc; p < &proc[NPROC]; p++)
    80002c8e:	1c048493          	addi	s1,s1,448
    80002c92:	ff3491e3          	bne	s1,s3,80002c74 <setpriority+0x24>
  uint original = 0;
    80002c96:	4901                	li	s2,0
    80002c98:	a00d                	j	80002cba <setpriority+0x6a>
      original = p->static_priority;
    80002c9a:	17c4a903          	lw	s2,380(s1)
      p->static_priority = number;
    80002c9e:	1744ae23          	sw	s4,380(s1)
      p->reset_niceness = 1;
    80002ca2:	4785                	li	a5,1
    80002ca4:	18f4a223          	sw	a5,388(s1)
      release(&p->lock);
    80002ca8:	8526                	mv	a0,s1
    80002caa:	ffffe097          	auipc	ra,0xffffe
    80002cae:	19c080e7          	jalr	412(ra) # 80000e46 <release>
      if (p->static_priority < original)
    80002cb2:	17c4a783          	lw	a5,380(s1)
    80002cb6:	0127eb63          	bltu	a5,s2,80002ccc <setpriority+0x7c>
  }
  return original;
    80002cba:	854a                	mv	a0,s2
    80002cbc:	70a2                	ld	ra,40(sp)
    80002cbe:	7402                	ld	s0,32(sp)
    80002cc0:	64e2                	ld	s1,24(sp)
    80002cc2:	6942                	ld	s2,16(sp)
    80002cc4:	69a2                	ld	s3,8(sp)
    80002cc6:	6a02                	ld	s4,0(sp)
    80002cc8:	6145                	addi	sp,sp,48
    80002cca:	8082                	ret
        yield();
    80002ccc:	00000097          	auipc	ra,0x0
    80002cd0:	85e080e7          	jalr	-1954(ra) # 8000252a <yield>
    80002cd4:	b7dd                	j	80002cba <setpriority+0x6a>

0000000080002cd6 <swtch>:
    80002cd6:	00153023          	sd	ra,0(a0)
    80002cda:	00253423          	sd	sp,8(a0)
    80002cde:	e900                	sd	s0,16(a0)
    80002ce0:	ed04                	sd	s1,24(a0)
    80002ce2:	03253023          	sd	s2,32(a0)
    80002ce6:	03353423          	sd	s3,40(a0)
    80002cea:	03453823          	sd	s4,48(a0)
    80002cee:	03553c23          	sd	s5,56(a0)
    80002cf2:	05653023          	sd	s6,64(a0)
    80002cf6:	05753423          	sd	s7,72(a0)
    80002cfa:	05853823          	sd	s8,80(a0)
    80002cfe:	05953c23          	sd	s9,88(a0)
    80002d02:	07a53023          	sd	s10,96(a0)
    80002d06:	07b53423          	sd	s11,104(a0)
    80002d0a:	0005b083          	ld	ra,0(a1)
    80002d0e:	0085b103          	ld	sp,8(a1)
    80002d12:	6980                	ld	s0,16(a1)
    80002d14:	6d84                	ld	s1,24(a1)
    80002d16:	0205b903          	ld	s2,32(a1)
    80002d1a:	0285b983          	ld	s3,40(a1)
    80002d1e:	0305ba03          	ld	s4,48(a1)
    80002d22:	0385ba83          	ld	s5,56(a1)
    80002d26:	0405bb03          	ld	s6,64(a1)
    80002d2a:	0485bb83          	ld	s7,72(a1)
    80002d2e:	0505bc03          	ld	s8,80(a1)
    80002d32:	0585bc83          	ld	s9,88(a1)
    80002d36:	0605bd03          	ld	s10,96(a1)
    80002d3a:	0685bd83          	ld	s11,104(a1)
    80002d3e:	8082                	ret

0000000080002d40 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80002d40:	1141                	addi	sp,sp,-16
    80002d42:	e406                	sd	ra,8(sp)
    80002d44:	e022                	sd	s0,0(sp)
    80002d46:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002d48:	00006597          	auipc	a1,0x6
    80002d4c:	62858593          	addi	a1,a1,1576 # 80009370 <states.0+0x30>
    80002d50:	00237517          	auipc	a0,0x237
    80002d54:	f6850513          	addi	a0,a0,-152 # 80239cb8 <tickslock>
    80002d58:	ffffe097          	auipc	ra,0xffffe
    80002d5c:	faa080e7          	jalr	-86(ra) # 80000d02 <initlock>
}
    80002d60:	60a2                	ld	ra,8(sp)
    80002d62:	6402                	ld	s0,0(sp)
    80002d64:	0141                	addi	sp,sp,16
    80002d66:	8082                	ret

0000000080002d68 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002d68:	1141                	addi	sp,sp,-16
    80002d6a:	e422                	sd	s0,8(sp)
    80002d6c:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0"
    80002d6e:	00004797          	auipc	a5,0x4
    80002d72:	8d278793          	addi	a5,a5,-1838 # 80006640 <kernelvec>
    80002d76:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002d7a:	6422                	ld	s0,8(sp)
    80002d7c:	0141                	addi	sp,sp,16
    80002d7e:	8082                	ret

0000000080002d80 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002d80:	1141                	addi	sp,sp,-16
    80002d82:	e406                	sd	ra,8(sp)
    80002d84:	e022                	sd	s0,0(sp)
    80002d86:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002d88:	fffff097          	auipc	ra,0xfffff
    80002d8c:	e66080e7          	jalr	-410(ra) # 80001bee <myproc>
  asm volatile("csrr %0, sstatus"
    80002d90:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002d94:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0"
    80002d96:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002d9a:	00005617          	auipc	a2,0x5
    80002d9e:	26660613          	addi	a2,a2,614 # 80008000 <_trampoline>
    80002da2:	00005697          	auipc	a3,0x5
    80002da6:	25e68693          	addi	a3,a3,606 # 80008000 <_trampoline>
    80002daa:	8e91                	sub	a3,a3,a2
    80002dac:	040007b7          	lui	a5,0x4000
    80002db0:	17fd                	addi	a5,a5,-1
    80002db2:	07b2                	slli	a5,a5,0xc
    80002db4:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0"
    80002db6:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002dba:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp"
    80002dbc:	180026f3          	csrr	a3,satp
    80002dc0:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002dc2:	6d38                	ld	a4,88(a0)
    80002dc4:	6134                	ld	a3,64(a0)
    80002dc6:	6585                	lui	a1,0x1
    80002dc8:	96ae                	add	a3,a3,a1
    80002dca:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002dcc:	6d38                	ld	a4,88(a0)
    80002dce:	00000697          	auipc	a3,0x0
    80002dd2:	2fa68693          	addi	a3,a3,762 # 800030c8 <usertrap>
    80002dd6:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002dd8:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp"
    80002dda:	8692                	mv	a3,tp
    80002ddc:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus"
    80002dde:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002de2:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002de6:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0"
    80002dea:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002dee:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0"
    80002df0:	6f18                	ld	a4,24(a4)
    80002df2:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002df6:	6928                	ld	a0,80(a0)
    80002df8:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002dfa:	00005717          	auipc	a4,0x5
    80002dfe:	2a270713          	addi	a4,a4,674 # 8000809c <userret>
    80002e02:	8f11                	sub	a4,a4,a2
    80002e04:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002e06:	577d                	li	a4,-1
    80002e08:	177e                	slli	a4,a4,0x3f
    80002e0a:	8d59                	or	a0,a0,a4
    80002e0c:	9782                	jalr	a5
}
    80002e0e:	60a2                	ld	ra,8(sp)
    80002e10:	6402                	ld	s0,0(sp)
    80002e12:	0141                	addi	sp,sp,16
    80002e14:	8082                	ret

0000000080002e16 <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80002e16:	1141                	addi	sp,sp,-16
    80002e18:	e406                	sd	ra,8(sp)
    80002e1a:	e022                	sd	s0,0(sp)
    80002e1c:	0800                	addi	s0,sp,16
  acquire(&tickslock);
    80002e1e:	00237517          	auipc	a0,0x237
    80002e22:	e9a50513          	addi	a0,a0,-358 # 80239cb8 <tickslock>
    80002e26:	ffffe097          	auipc	ra,0xffffe
    80002e2a:	f6c080e7          	jalr	-148(ra) # 80000d92 <acquire>
  ticks++;
    80002e2e:	00007717          	auipc	a4,0x7
    80002e32:	d3a70713          	addi	a4,a4,-710 # 80009b68 <ticks>
    80002e36:	431c                	lw	a5,0(a4)
    80002e38:	2785                	addiw	a5,a5,1
    80002e3a:	c31c                	sw	a5,0(a4)
  update_time();
    80002e3c:	fffff097          	auipc	ra,0xfffff
    80002e40:	348080e7          	jalr	840(ra) # 80002184 <update_time>
  if (myproc() != 0)
    80002e44:	fffff097          	auipc	ra,0xfffff
    80002e48:	daa080e7          	jalr	-598(ra) # 80001bee <myproc>
    80002e4c:	c11d                	beqz	a0,80002e72 <clockintr+0x5c>
  {
    myproc()->running_ticks++;
    80002e4e:	fffff097          	auipc	ra,0xfffff
    80002e52:	da0080e7          	jalr	-608(ra) # 80001bee <myproc>
    80002e56:	18c52783          	lw	a5,396(a0)
    80002e5a:	2785                	addiw	a5,a5,1
    80002e5c:	18f52623          	sw	a5,396(a0)
    myproc()->change_queue--;
    80002e60:	fffff097          	auipc	ra,0xfffff
    80002e64:	d8e080e7          	jalr	-626(ra) # 80001bee <myproc>
    80002e68:	19852783          	lw	a5,408(a0)
    80002e6c:	37fd                	addiw	a5,a5,-1
    80002e6e:	18f52c23          	sw	a5,408(a0)
  }
  wakeup(&ticks);
    80002e72:	00007517          	auipc	a0,0x7
    80002e76:	cf650513          	addi	a0,a0,-778 # 80009b68 <ticks>
    80002e7a:	00000097          	auipc	ra,0x0
    80002e7e:	8a8080e7          	jalr	-1880(ra) # 80002722 <wakeup>
  release(&tickslock);
    80002e82:	00237517          	auipc	a0,0x237
    80002e86:	e3650513          	addi	a0,a0,-458 # 80239cb8 <tickslock>
    80002e8a:	ffffe097          	auipc	ra,0xffffe
    80002e8e:	fbc080e7          	jalr	-68(ra) # 80000e46 <release>
}
    80002e92:	60a2                	ld	ra,8(sp)
    80002e94:	6402                	ld	s0,0(sp)
    80002e96:	0141                	addi	sp,sp,16
    80002e98:	8082                	ret

0000000080002e9a <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    80002e9a:	1101                	addi	sp,sp,-32
    80002e9c:	ec06                	sd	ra,24(sp)
    80002e9e:	e822                	sd	s0,16(sp)
    80002ea0:	e426                	sd	s1,8(sp)
    80002ea2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause"
    80002ea4:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) &&
    80002ea8:	00074d63          	bltz	a4,80002ec2 <devintr+0x28>
    if (irq)
      plic_complete(irq);

    return 1;
  }
  else if (scause == 0x8000000000000001L)
    80002eac:	57fd                	li	a5,-1
    80002eae:	17fe                	slli	a5,a5,0x3f
    80002eb0:	0785                	addi	a5,a5,1

    return 2;
  }
  else
  {
    return 0;
    80002eb2:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80002eb4:	06f70363          	beq	a4,a5,80002f1a <devintr+0x80>
  }
}
    80002eb8:	60e2                	ld	ra,24(sp)
    80002eba:	6442                	ld	s0,16(sp)
    80002ebc:	64a2                	ld	s1,8(sp)
    80002ebe:	6105                	addi	sp,sp,32
    80002ec0:	8082                	ret
      (scause & 0xff) == 9)
    80002ec2:	0ff77793          	andi	a5,a4,255
  if ((scause & 0x8000000000000000L) &&
    80002ec6:	46a5                	li	a3,9
    80002ec8:	fed792e3          	bne	a5,a3,80002eac <devintr+0x12>
    int irq = plic_claim();
    80002ecc:	00004097          	auipc	ra,0x4
    80002ed0:	87c080e7          	jalr	-1924(ra) # 80006748 <plic_claim>
    80002ed4:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80002ed6:	47a9                	li	a5,10
    80002ed8:	02f50763          	beq	a0,a5,80002f06 <devintr+0x6c>
    else if (irq == VIRTIO0_IRQ)
    80002edc:	4785                	li	a5,1
    80002ede:	02f50963          	beq	a0,a5,80002f10 <devintr+0x76>
    return 1;
    80002ee2:	4505                	li	a0,1
    else if (irq)
    80002ee4:	d8f1                	beqz	s1,80002eb8 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002ee6:	85a6                	mv	a1,s1
    80002ee8:	00006517          	auipc	a0,0x6
    80002eec:	49050513          	addi	a0,a0,1168 # 80009378 <states.0+0x38>
    80002ef0:	ffffd097          	auipc	ra,0xffffd
    80002ef4:	698080e7          	jalr	1688(ra) # 80000588 <printf>
      plic_complete(irq);
    80002ef8:	8526                	mv	a0,s1
    80002efa:	00004097          	auipc	ra,0x4
    80002efe:	872080e7          	jalr	-1934(ra) # 8000676c <plic_complete>
    return 1;
    80002f02:	4505                	li	a0,1
    80002f04:	bf55                	j	80002eb8 <devintr+0x1e>
      uartintr();
    80002f06:	ffffe097          	auipc	ra,0xffffe
    80002f0a:	a94080e7          	jalr	-1388(ra) # 8000099a <uartintr>
    80002f0e:	b7ed                	j	80002ef8 <devintr+0x5e>
      virtio_disk_intr();
    80002f10:	00004097          	auipc	ra,0x4
    80002f14:	148080e7          	jalr	328(ra) # 80007058 <virtio_disk_intr>
    80002f18:	b7c5                	j	80002ef8 <devintr+0x5e>
    if (cpuid() == 0)
    80002f1a:	fffff097          	auipc	ra,0xfffff
    80002f1e:	ca8080e7          	jalr	-856(ra) # 80001bc2 <cpuid>
    80002f22:	c901                	beqz	a0,80002f32 <devintr+0x98>
  asm volatile("csrr %0, sip"
    80002f24:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002f28:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0"
    80002f2a:	14479073          	csrw	sip,a5
    return 2;
    80002f2e:	4509                	li	a0,2
    80002f30:	b761                	j	80002eb8 <devintr+0x1e>
      clockintr();
    80002f32:	00000097          	auipc	ra,0x0
    80002f36:	ee4080e7          	jalr	-284(ra) # 80002e16 <clockintr>
    80002f3a:	b7ed                	j	80002f24 <devintr+0x8a>

0000000080002f3c <kerneltrap>:
{
    80002f3c:	7179                	addi	sp,sp,-48
    80002f3e:	f406                	sd	ra,40(sp)
    80002f40:	f022                	sd	s0,32(sp)
    80002f42:	ec26                	sd	s1,24(sp)
    80002f44:	e84a                	sd	s2,16(sp)
    80002f46:	e44e                	sd	s3,8(sp)
    80002f48:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc"
    80002f4a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus"
    80002f4e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause"
    80002f52:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80002f56:	1004f793          	andi	a5,s1,256
    80002f5a:	cb85                	beqz	a5,80002f8a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus"
    80002f5c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002f60:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80002f62:	ef85                	bnez	a5,80002f9a <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    80002f64:	00000097          	auipc	ra,0x0
    80002f68:	f36080e7          	jalr	-202(ra) # 80002e9a <devintr>
    80002f6c:	cd1d                	beqz	a0,80002faa <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002f6e:	4789                	li	a5,2
    80002f70:	06f50a63          	beq	a0,a5,80002fe4 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0"
    80002f74:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0"
    80002f78:	10049073          	csrw	sstatus,s1
}
    80002f7c:	70a2                	ld	ra,40(sp)
    80002f7e:	7402                	ld	s0,32(sp)
    80002f80:	64e2                	ld	s1,24(sp)
    80002f82:	6942                	ld	s2,16(sp)
    80002f84:	69a2                	ld	s3,8(sp)
    80002f86:	6145                	addi	sp,sp,48
    80002f88:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002f8a:	00006517          	auipc	a0,0x6
    80002f8e:	40e50513          	addi	a0,a0,1038 # 80009398 <states.0+0x58>
    80002f92:	ffffd097          	auipc	ra,0xffffd
    80002f96:	5ac080e7          	jalr	1452(ra) # 8000053e <panic>
    panic("kerneltrap: interrupts enabled");
    80002f9a:	00006517          	auipc	a0,0x6
    80002f9e:	42650513          	addi	a0,a0,1062 # 800093c0 <states.0+0x80>
    80002fa2:	ffffd097          	auipc	ra,0xffffd
    80002fa6:	59c080e7          	jalr	1436(ra) # 8000053e <panic>
    printf("scause %p\n", scause);
    80002faa:	85ce                	mv	a1,s3
    80002fac:	00006517          	auipc	a0,0x6
    80002fb0:	43450513          	addi	a0,a0,1076 # 800093e0 <states.0+0xa0>
    80002fb4:	ffffd097          	auipc	ra,0xffffd
    80002fb8:	5d4080e7          	jalr	1492(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc"
    80002fbc:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval"
    80002fc0:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002fc4:	00006517          	auipc	a0,0x6
    80002fc8:	42c50513          	addi	a0,a0,1068 # 800093f0 <states.0+0xb0>
    80002fcc:	ffffd097          	auipc	ra,0xffffd
    80002fd0:	5bc080e7          	jalr	1468(ra) # 80000588 <printf>
    panic("kerneltrap");
    80002fd4:	00006517          	auipc	a0,0x6
    80002fd8:	43450513          	addi	a0,a0,1076 # 80009408 <states.0+0xc8>
    80002fdc:	ffffd097          	auipc	ra,0xffffd
    80002fe0:	562080e7          	jalr	1378(ra) # 8000053e <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002fe4:	fffff097          	auipc	ra,0xfffff
    80002fe8:	c0a080e7          	jalr	-1014(ra) # 80001bee <myproc>
    80002fec:	d541                	beqz	a0,80002f74 <kerneltrap+0x38>
    80002fee:	fffff097          	auipc	ra,0xfffff
    80002ff2:	c00080e7          	jalr	-1024(ra) # 80001bee <myproc>
    80002ff6:	4d18                	lw	a4,24(a0)
    80002ff8:	4791                	li	a5,4
    80002ffa:	f6f71de3          	bne	a4,a5,80002f74 <kerneltrap+0x38>
    yield();
    80002ffe:	fffff097          	auipc	ra,0xfffff
    80003002:	52c080e7          	jalr	1324(ra) # 8000252a <yield>
    80003006:	b7bd                	j	80002f74 <kerneltrap+0x38>

0000000080003008 <pgfault>:

// -1 means cannot alloc mem
// -2 means the address is invalid
// 0 means ok
int pgfault(uint64 va, pagetable_t pagetable)
{
    80003008:	7179                	addi	sp,sp,-48
    8000300a:	f406                	sd	ra,40(sp)
    8000300c:	f022                	sd	s0,32(sp)
    8000300e:	ec26                	sd	s1,24(sp)
    80003010:	e84a                	sd	s2,16(sp)
    80003012:	e44e                	sd	s3,8(sp)
    80003014:	e052                	sd	s4,0(sp)
    80003016:	1800                	addi	s0,sp,48
    80003018:	84aa                	mv	s1,a0
    8000301a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000301c:	fffff097          	auipc	ra,0xfffff
    80003020:	bd2080e7          	jalr	-1070(ra) # 80001bee <myproc>
  if (va >= MAXVA || (va >= PGROUNDDOWN(p->trapframe->sp) - PGSIZE && va <= PGROUNDDOWN(p->trapframe->sp)))
    80003024:	57fd                	li	a5,-1
    80003026:	83e9                	srli	a5,a5,0x1a
    80003028:	0897e663          	bltu	a5,s1,800030b4 <pgfault+0xac>
    8000302c:	6d38                	ld	a4,88(a0)
    8000302e:	77fd                	lui	a5,0xfffff
    80003030:	7b18                	ld	a4,48(a4)
    80003032:	8f7d                	and	a4,a4,a5
    80003034:	97ba                	add	a5,a5,a4
    80003036:	00f4e463          	bltu	s1,a5,8000303e <pgfault+0x36>
    8000303a:	06977f63          	bgeu	a4,s1,800030b8 <pgfault+0xb0>
  {
    return -2;
  }
  va = PGROUNDDOWN(va);
  pte_t *pte = walk(pagetable, va, 0);
    8000303e:	4601                	li	a2,0
    80003040:	75fd                	lui	a1,0xfffff
    80003042:	8de5                	and	a1,a1,s1
    80003044:	854a                	mv	a0,s2
    80003046:	ffffe097          	auipc	ra,0xffffe
    8000304a:	12c080e7          	jalr	300(ra) # 80001172 <walk>
    8000304e:	84aa                	mv	s1,a0
  if (pte == 0)
    80003050:	c535                	beqz	a0,800030bc <pgfault+0xb4>
    return -1;
  
  uint64 pa = PTE2PA(*pte);
    80003052:	611c                	ld	a5,0(a0)
    80003054:	00a7d913          	srli	s2,a5,0xa
    80003058:	0932                	slli	s2,s2,0xc
  if (pa == 0)
    8000305a:	06090363          	beqz	s2,800030c0 <pgfault+0xb8>
  {
    return -1;
  }
  uint flags = PTE_FLAGS(*pte);
    8000305e:	0007871b          	sext.w	a4,a5
  if (flags & PTE_COW)
    80003062:	1007f793          	andi	a5,a5,256
    //   printf("sometthing is wrong in mappages in trap.\n");
    // }

    return 0;
  }
  return 0;
    80003066:	4501                	li	a0,0
  if (flags & PTE_COW)
    80003068:	eb89                	bnez	a5,8000307a <pgfault+0x72>
}
    8000306a:	70a2                	ld	ra,40(sp)
    8000306c:	7402                	ld	s0,32(sp)
    8000306e:	64e2                	ld	s1,24(sp)
    80003070:	6942                	ld	s2,16(sp)
    80003072:	69a2                	ld	s3,8(sp)
    80003074:	6a02                	ld	s4,0(sp)
    80003076:	6145                	addi	sp,sp,48
    80003078:	8082                	ret
    flags = (flags | PTE_W) & (~PTE_COW);
    8000307a:	2ff77713          	andi	a4,a4,767
    8000307e:	00476993          	ori	s3,a4,4
    char *mem = kalloc();
    80003082:	ffffe097          	auipc	ra,0xffffe
    80003086:	bcc080e7          	jalr	-1076(ra) # 80000c4e <kalloc>
    8000308a:	8a2a                	mv	s4,a0
    if (mem == 0)
    8000308c:	cd05                	beqz	a0,800030c4 <pgfault+0xbc>
    memmove(mem, (void *)pa, PGSIZE);
    8000308e:	6605                	lui	a2,0x1
    80003090:	85ca                	mv	a1,s2
    80003092:	ffffe097          	auipc	ra,0xffffe
    80003096:	e58080e7          	jalr	-424(ra) # 80000eea <memmove>
    *pte = PA2PTE(mem) | flags;
    8000309a:	00ca5713          	srli	a4,s4,0xc
    8000309e:	072a                	slli	a4,a4,0xa
    800030a0:	00e9e733          	or	a4,s3,a4
    800030a4:	e098                	sd	a4,0(s1)
    kfree((void *)pa);
    800030a6:	854a                	mv	a0,s2
    800030a8:	ffffe097          	auipc	ra,0xffffe
    800030ac:	9ce080e7          	jalr	-1586(ra) # 80000a76 <kfree>
    return 0;
    800030b0:	4501                	li	a0,0
    800030b2:	bf65                	j	8000306a <pgfault+0x62>
    return -2;
    800030b4:	5579                	li	a0,-2
    800030b6:	bf55                	j	8000306a <pgfault+0x62>
    800030b8:	5579                	li	a0,-2
    800030ba:	bf45                	j	8000306a <pgfault+0x62>
    return -1;
    800030bc:	557d                	li	a0,-1
    800030be:	b775                	j	8000306a <pgfault+0x62>
    return -1;
    800030c0:	557d                	li	a0,-1
    800030c2:	b765                	j	8000306a <pgfault+0x62>
      return -1;
    800030c4:	557d                	li	a0,-1
    800030c6:	b755                	j	8000306a <pgfault+0x62>

00000000800030c8 <usertrap>:
{
    800030c8:	1101                	addi	sp,sp,-32
    800030ca:	ec06                	sd	ra,24(sp)
    800030cc:	e822                	sd	s0,16(sp)
    800030ce:	e426                	sd	s1,8(sp)
    800030d0:	e04a                	sd	s2,0(sp)
    800030d2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus"
    800030d4:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    800030d8:	1007f793          	andi	a5,a5,256
    800030dc:	efad                	bnez	a5,80003156 <usertrap+0x8e>
  asm volatile("csrw stvec, %0"
    800030de:	00003797          	auipc	a5,0x3
    800030e2:	56278793          	addi	a5,a5,1378 # 80006640 <kernelvec>
    800030e6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800030ea:	fffff097          	auipc	ra,0xfffff
    800030ee:	b04080e7          	jalr	-1276(ra) # 80001bee <myproc>
    800030f2:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800030f4:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc"
    800030f6:	14102773          	csrr	a4,sepc
    800030fa:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause"
    800030fc:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80003100:	47a1                	li	a5,8
    80003102:	06f70263          	beq	a4,a5,80003166 <usertrap+0x9e>
  else if ((which_dev = devintr()) != 0)
    80003106:	00000097          	auipc	ra,0x0
    8000310a:	d94080e7          	jalr	-620(ra) # 80002e9a <devintr>
    8000310e:	892a                	mv	s2,a0
    80003110:	ed5d                	bnez	a0,800031ce <usertrap+0x106>
    80003112:	14202773          	csrr	a4,scause
  else if (r_scause() == 15)
    80003116:	47bd                	li	a5,15
    80003118:	0af70063          	beq	a4,a5,800031b8 <usertrap+0xf0>
    8000311c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80003120:	5890                	lw	a2,48(s1)
    80003122:	00006517          	auipc	a0,0x6
    80003126:	31650513          	addi	a0,a0,790 # 80009438 <states.0+0xf8>
    8000312a:	ffffd097          	auipc	ra,0xffffd
    8000312e:	45e080e7          	jalr	1118(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc"
    80003132:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval"
    80003136:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000313a:	00006517          	auipc	a0,0x6
    8000313e:	32e50513          	addi	a0,a0,814 # 80009468 <states.0+0x128>
    80003142:	ffffd097          	auipc	ra,0xffffd
    80003146:	446080e7          	jalr	1094(ra) # 80000588 <printf>
    setkilled(p);
    8000314a:	8526                	mv	a0,s1
    8000314c:	00000097          	auipc	ra,0x0
    80003150:	81a080e7          	jalr	-2022(ra) # 80002966 <setkilled>
    80003154:	a825                	j	8000318c <usertrap+0xc4>
    panic("usertrap: not from user mode");
    80003156:	00006517          	auipc	a0,0x6
    8000315a:	2c250513          	addi	a0,a0,706 # 80009418 <states.0+0xd8>
    8000315e:	ffffd097          	auipc	ra,0xffffd
    80003162:	3e0080e7          	jalr	992(ra) # 8000053e <panic>
    if (killed(p))
    80003166:	00000097          	auipc	ra,0x0
    8000316a:	82c080e7          	jalr	-2004(ra) # 80002992 <killed>
    8000316e:	ed1d                	bnez	a0,800031ac <usertrap+0xe4>
    p->trapframe->epc += 4;
    80003170:	6cb8                	ld	a4,88(s1)
    80003172:	6f1c                	ld	a5,24(a4)
    80003174:	0791                	addi	a5,a5,4
    80003176:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus"
    80003178:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000317c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0"
    80003180:	10079073          	csrw	sstatus,a5
    syscall();
    80003184:	00000097          	auipc	ra,0x0
    80003188:	272080e7          	jalr	626(ra) # 800033f6 <syscall>
  if (killed(p))
    8000318c:	8526                	mv	a0,s1
    8000318e:	00000097          	auipc	ra,0x0
    80003192:	804080e7          	jalr	-2044(ra) # 80002992 <killed>
    80003196:	e139                	bnez	a0,800031dc <usertrap+0x114>
  usertrapret();
    80003198:	00000097          	auipc	ra,0x0
    8000319c:	be8080e7          	jalr	-1048(ra) # 80002d80 <usertrapret>
}
    800031a0:	60e2                	ld	ra,24(sp)
    800031a2:	6442                	ld	s0,16(sp)
    800031a4:	64a2                	ld	s1,8(sp)
    800031a6:	6902                	ld	s2,0(sp)
    800031a8:	6105                	addi	sp,sp,32
    800031aa:	8082                	ret
      exit(-1);
    800031ac:	557d                	li	a0,-1
    800031ae:	fffff097          	auipc	ra,0xfffff
    800031b2:	664080e7          	jalr	1636(ra) # 80002812 <exit>
    800031b6:	bf6d                	j	80003170 <usertrap+0xa8>
  asm volatile("csrr %0, stval"
    800031b8:	14302573          	csrr	a0,stval
    int r = pgfault(r_stval(), p->pagetable);
    800031bc:	68ac                	ld	a1,80(s1)
    800031be:	00000097          	auipc	ra,0x0
    800031c2:	e4a080e7          	jalr	-438(ra) # 80003008 <pgfault>
    if (r)
    800031c6:	d179                	beqz	a0,8000318c <usertrap+0xc4>
      p->killed = 1;
    800031c8:	4785                	li	a5,1
    800031ca:	d49c                	sw	a5,40(s1)
    800031cc:	b7c1                	j	8000318c <usertrap+0xc4>
  if (killed(p))
    800031ce:	8526                	mv	a0,s1
    800031d0:	fffff097          	auipc	ra,0xfffff
    800031d4:	7c2080e7          	jalr	1986(ra) # 80002992 <killed>
    800031d8:	c901                	beqz	a0,800031e8 <usertrap+0x120>
    800031da:	a011                	j	800031de <usertrap+0x116>
    800031dc:	4901                	li	s2,0
    exit(-1);
    800031de:	557d                	li	a0,-1
    800031e0:	fffff097          	auipc	ra,0xfffff
    800031e4:	632080e7          	jalr	1586(ra) # 80002812 <exit>
  if (which_dev == 2)
    800031e8:	4789                	li	a5,2
    800031ea:	faf917e3          	bne	s2,a5,80003198 <usertrap+0xd0>
    if (p->interval)
    800031ee:	1a84a703          	lw	a4,424(s1)
    800031f2:	cf19                	beqz	a4,80003210 <usertrap+0x148>
      p->now_ticks++;
    800031f4:	1ac4a783          	lw	a5,428(s1)
    800031f8:	2785                	addiw	a5,a5,1
    800031fa:	0007869b          	sext.w	a3,a5
    800031fe:	1af4a623          	sw	a5,428(s1)
      if (!p->sigalarm_status && p->interval > 0 && p->now_ticks >= p->interval)
    80003202:	1b84a783          	lw	a5,440(s1)
    80003206:	e789                	bnez	a5,80003210 <usertrap+0x148>
    80003208:	00e05463          	blez	a4,80003210 <usertrap+0x148>
    8000320c:	04e6d063          	bge	a3,a4,8000324c <usertrap+0x184>
    struct proc *p = myproc();
    80003210:	fffff097          	auipc	ra,0xfffff
    80003214:	9de080e7          	jalr	-1570(ra) # 80001bee <myproc>
    80003218:	84aa                	mv	s1,a0
    if (p->change_queue <= 0)
    8000321a:	19852783          	lw	a5,408(a0)
    8000321e:	ffad                	bnez	a5,80003198 <usertrap+0xd0>
      acquire(&p->lock);
    80003220:	ffffe097          	auipc	ra,0xffffe
    80003224:	b72080e7          	jalr	-1166(ra) # 80000d92 <acquire>
      if (p->level + 1 != NMLFQ)
    80003228:	1904a783          	lw	a5,400(s1)
    8000322c:	4711                	li	a4,4
    8000322e:	00e78563          	beq	a5,a4,80003238 <usertrap+0x170>
        p->level++;
    80003232:	2785                	addiw	a5,a5,1
    80003234:	18f4a823          	sw	a5,400(s1)
      release(&p->lock);
    80003238:	8526                	mv	a0,s1
    8000323a:	ffffe097          	auipc	ra,0xffffe
    8000323e:	c0c080e7          	jalr	-1012(ra) # 80000e46 <release>
      yield();
    80003242:	fffff097          	auipc	ra,0xfffff
    80003246:	2e8080e7          	jalr	744(ra) # 8000252a <yield>
    8000324a:	b7b9                	j	80003198 <usertrap+0xd0>
        p->now_ticks = 0;
    8000324c:	1a04a623          	sw	zero,428(s1)
        p->sigalarm_status = 1;
    80003250:	4785                	li	a5,1
    80003252:	1af4ac23          	sw	a5,440(s1)
        p->alarm_trapframe = kalloc();
    80003256:	ffffe097          	auipc	ra,0xffffe
    8000325a:	9f8080e7          	jalr	-1544(ra) # 80000c4e <kalloc>
    8000325e:	1aa4b823          	sd	a0,432(s1)
        memmove(p->alarm_trapframe, p->trapframe, PGSIZE);
    80003262:	6605                	lui	a2,0x1
    80003264:	6cac                	ld	a1,88(s1)
    80003266:	ffffe097          	auipc	ra,0xffffe
    8000326a:	c84080e7          	jalr	-892(ra) # 80000eea <memmove>
        p->trapframe->epc = p->handler;
    8000326e:	6cbc                	ld	a5,88(s1)
    80003270:	1a04b703          	ld	a4,416(s1)
    80003274:	ef98                	sd	a4,24(a5)
    80003276:	bf69                	j	80003210 <usertrap+0x148>

0000000080003278 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80003278:	1101                	addi	sp,sp,-32
    8000327a:	ec06                	sd	ra,24(sp)
    8000327c:	e822                	sd	s0,16(sp)
    8000327e:	e426                	sd	s1,8(sp)
    80003280:	1000                	addi	s0,sp,32
    80003282:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80003284:	fffff097          	auipc	ra,0xfffff
    80003288:	96a080e7          	jalr	-1686(ra) # 80001bee <myproc>
  switch (n)
    8000328c:	4795                	li	a5,5
    8000328e:	0497e163          	bltu	a5,s1,800032d0 <argraw+0x58>
    80003292:	048a                	slli	s1,s1,0x2
    80003294:	00006717          	auipc	a4,0x6
    80003298:	33470713          	addi	a4,a4,820 # 800095c8 <states.0+0x288>
    8000329c:	94ba                	add	s1,s1,a4
    8000329e:	409c                	lw	a5,0(s1)
    800032a0:	97ba                	add	a5,a5,a4
    800032a2:	8782                	jr	a5
  {
  case 0:
    return p->trapframe->a0;
    800032a4:	6d3c                	ld	a5,88(a0)
    800032a6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800032a8:	60e2                	ld	ra,24(sp)
    800032aa:	6442                	ld	s0,16(sp)
    800032ac:	64a2                	ld	s1,8(sp)
    800032ae:	6105                	addi	sp,sp,32
    800032b0:	8082                	ret
    return p->trapframe->a1;
    800032b2:	6d3c                	ld	a5,88(a0)
    800032b4:	7fa8                	ld	a0,120(a5)
    800032b6:	bfcd                	j	800032a8 <argraw+0x30>
    return p->trapframe->a2;
    800032b8:	6d3c                	ld	a5,88(a0)
    800032ba:	63c8                	ld	a0,128(a5)
    800032bc:	b7f5                	j	800032a8 <argraw+0x30>
    return p->trapframe->a3;
    800032be:	6d3c                	ld	a5,88(a0)
    800032c0:	67c8                	ld	a0,136(a5)
    800032c2:	b7dd                	j	800032a8 <argraw+0x30>
    return p->trapframe->a4;
    800032c4:	6d3c                	ld	a5,88(a0)
    800032c6:	6bc8                	ld	a0,144(a5)
    800032c8:	b7c5                	j	800032a8 <argraw+0x30>
    return p->trapframe->a5;
    800032ca:	6d3c                	ld	a5,88(a0)
    800032cc:	6fc8                	ld	a0,152(a5)
    800032ce:	bfe9                	j	800032a8 <argraw+0x30>
  panic("argraw");
    800032d0:	00006517          	auipc	a0,0x6
    800032d4:	1b850513          	addi	a0,a0,440 # 80009488 <states.0+0x148>
    800032d8:	ffffd097          	auipc	ra,0xffffd
    800032dc:	266080e7          	jalr	614(ra) # 8000053e <panic>

00000000800032e0 <fetchaddr>:
{
    800032e0:	1101                	addi	sp,sp,-32
    800032e2:	ec06                	sd	ra,24(sp)
    800032e4:	e822                	sd	s0,16(sp)
    800032e6:	e426                	sd	s1,8(sp)
    800032e8:	e04a                	sd	s2,0(sp)
    800032ea:	1000                	addi	s0,sp,32
    800032ec:	84aa                	mv	s1,a0
    800032ee:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800032f0:	fffff097          	auipc	ra,0xfffff
    800032f4:	8fe080e7          	jalr	-1794(ra) # 80001bee <myproc>
  if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800032f8:	653c                	ld	a5,72(a0)
    800032fa:	02f4f863          	bgeu	s1,a5,8000332a <fetchaddr+0x4a>
    800032fe:	00848713          	addi	a4,s1,8
    80003302:	02e7e663          	bltu	a5,a4,8000332e <fetchaddr+0x4e>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003306:	46a1                	li	a3,8
    80003308:	8626                	mv	a2,s1
    8000330a:	85ca                	mv	a1,s2
    8000330c:	6928                	ld	a0,80(a0)
    8000330e:	ffffe097          	auipc	ra,0xffffe
    80003312:	5fc080e7          	jalr	1532(ra) # 8000190a <copyin>
    80003316:	00a03533          	snez	a0,a0
    8000331a:	40a00533          	neg	a0,a0
}
    8000331e:	60e2                	ld	ra,24(sp)
    80003320:	6442                	ld	s0,16(sp)
    80003322:	64a2                	ld	s1,8(sp)
    80003324:	6902                	ld	s2,0(sp)
    80003326:	6105                	addi	sp,sp,32
    80003328:	8082                	ret
    return -1;
    8000332a:	557d                	li	a0,-1
    8000332c:	bfcd                	j	8000331e <fetchaddr+0x3e>
    8000332e:	557d                	li	a0,-1
    80003330:	b7fd                	j	8000331e <fetchaddr+0x3e>

0000000080003332 <fetchstr>:
{
    80003332:	7179                	addi	sp,sp,-48
    80003334:	f406                	sd	ra,40(sp)
    80003336:	f022                	sd	s0,32(sp)
    80003338:	ec26                	sd	s1,24(sp)
    8000333a:	e84a                	sd	s2,16(sp)
    8000333c:	e44e                	sd	s3,8(sp)
    8000333e:	1800                	addi	s0,sp,48
    80003340:	892a                	mv	s2,a0
    80003342:	84ae                	mv	s1,a1
    80003344:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80003346:	fffff097          	auipc	ra,0xfffff
    8000334a:	8a8080e7          	jalr	-1880(ra) # 80001bee <myproc>
  if (copyinstr(p->pagetable, buf, addr, max) < 0)
    8000334e:	86ce                	mv	a3,s3
    80003350:	864a                	mv	a2,s2
    80003352:	85a6                	mv	a1,s1
    80003354:	6928                	ld	a0,80(a0)
    80003356:	ffffe097          	auipc	ra,0xffffe
    8000335a:	642080e7          	jalr	1602(ra) # 80001998 <copyinstr>
    8000335e:	00054e63          	bltz	a0,8000337a <fetchstr+0x48>
  return strlen(buf);
    80003362:	8526                	mv	a0,s1
    80003364:	ffffe097          	auipc	ra,0xffffe
    80003368:	ca6080e7          	jalr	-858(ra) # 8000100a <strlen>
}
    8000336c:	70a2                	ld	ra,40(sp)
    8000336e:	7402                	ld	s0,32(sp)
    80003370:	64e2                	ld	s1,24(sp)
    80003372:	6942                	ld	s2,16(sp)
    80003374:	69a2                	ld	s3,8(sp)
    80003376:	6145                	addi	sp,sp,48
    80003378:	8082                	ret
    return -1;
    8000337a:	557d                	li	a0,-1
    8000337c:	bfc5                	j	8000336c <fetchstr+0x3a>

000000008000337e <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    8000337e:	1101                	addi	sp,sp,-32
    80003380:	ec06                	sd	ra,24(sp)
    80003382:	e822                	sd	s0,16(sp)
    80003384:	e426                	sd	s1,8(sp)
    80003386:	1000                	addi	s0,sp,32
    80003388:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000338a:	00000097          	auipc	ra,0x0
    8000338e:	eee080e7          	jalr	-274(ra) # 80003278 <argraw>
    80003392:	c088                	sw	a0,0(s1)
}
    80003394:	60e2                	ld	ra,24(sp)
    80003396:	6442                	ld	s0,16(sp)
    80003398:	64a2                	ld	s1,8(sp)
    8000339a:	6105                	addi	sp,sp,32
    8000339c:	8082                	ret

000000008000339e <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    8000339e:	1101                	addi	sp,sp,-32
    800033a0:	ec06                	sd	ra,24(sp)
    800033a2:	e822                	sd	s0,16(sp)
    800033a4:	e426                	sd	s1,8(sp)
    800033a6:	1000                	addi	s0,sp,32
    800033a8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800033aa:	00000097          	auipc	ra,0x0
    800033ae:	ece080e7          	jalr	-306(ra) # 80003278 <argraw>
    800033b2:	e088                	sd	a0,0(s1)
}
    800033b4:	60e2                	ld	ra,24(sp)
    800033b6:	6442                	ld	s0,16(sp)
    800033b8:	64a2                	ld	s1,8(sp)
    800033ba:	6105                	addi	sp,sp,32
    800033bc:	8082                	ret

00000000800033be <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    800033be:	7179                	addi	sp,sp,-48
    800033c0:	f406                	sd	ra,40(sp)
    800033c2:	f022                	sd	s0,32(sp)
    800033c4:	ec26                	sd	s1,24(sp)
    800033c6:	e84a                	sd	s2,16(sp)
    800033c8:	1800                	addi	s0,sp,48
    800033ca:	84ae                	mv	s1,a1
    800033cc:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800033ce:	fd840593          	addi	a1,s0,-40
    800033d2:	00000097          	auipc	ra,0x0
    800033d6:	fcc080e7          	jalr	-52(ra) # 8000339e <argaddr>
  return fetchstr(addr, buf, max);
    800033da:	864a                	mv	a2,s2
    800033dc:	85a6                	mv	a1,s1
    800033de:	fd843503          	ld	a0,-40(s0)
    800033e2:	00000097          	auipc	ra,0x0
    800033e6:	f50080e7          	jalr	-176(ra) # 80003332 <fetchstr>
}
    800033ea:	70a2                	ld	ra,40(sp)
    800033ec:	7402                	ld	s0,32(sp)
    800033ee:	64e2                	ld	s1,24(sp)
    800033f0:	6942                	ld	s2,16(sp)
    800033f2:	6145                	addi	sp,sp,48
    800033f4:	8082                	ret

00000000800033f6 <syscall>:
    "waitx",
    "setpriority",
};

void syscall(void)
{
    800033f6:	7179                	addi	sp,sp,-48
    800033f8:	f406                	sd	ra,40(sp)
    800033fa:	f022                	sd	s0,32(sp)
    800033fc:	ec26                	sd	s1,24(sp)
    800033fe:	e84a                	sd	s2,16(sp)
    80003400:	e44e                	sd	s3,8(sp)
    80003402:	e052                	sd	s4,0(sp)
    80003404:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80003406:	ffffe097          	auipc	ra,0xffffe
    8000340a:	7e8080e7          	jalr	2024(ra) # 80001bee <myproc>
    8000340e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80003410:	05853903          	ld	s2,88(a0)
    80003414:	0a893783          	ld	a5,168(s2)
    80003418:	0007899b          	sext.w	s3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    8000341c:	37fd                	addiw	a5,a5,-1
    8000341e:	4769                	li	a4,26
    80003420:	06f76f63          	bltu	a4,a5,8000349e <syscall+0xa8>
    80003424:	00399713          	slli	a4,s3,0x3
    80003428:	00006797          	auipc	a5,0x6
    8000342c:	1b878793          	addi	a5,a5,440 # 800095e0 <syscalls>
    80003430:	97ba                	add	a5,a5,a4
    80003432:	639c                	ld	a5,0(a5)
    80003434:	c7ad                	beqz	a5,8000349e <syscall+0xa8>
  {
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0

    int arg0 = p->trapframe->a0;
    80003436:	07093a03          	ld	s4,112(s2)
    short argcount = (num == SYS_read || num == SYS_write || num == SYS_mknod || SYS_waitx) ? 3
    : ((num == SYS_exec || num == SYS_fstat || num == SYS_open || num == SYS_link || num == SYS_sigalarm || num == SYS_setpriority) ? 2
    : ((num == SYS_wait || num == SYS_pipe || num == SYS_kill || num == SYS_chdir || num == SYS_dup || num == SYS_sbrk || num == SYS_sleep || num == SYS_unlink || num == SYS_mkdir || num == SYS_close || num == SYS_trace) ? 1
    : 0));

    p->trapframe->a0 = syscalls[num]();
    8000343a:	9782                	jalr	a5
    8000343c:	06a93823          	sd	a0,112(s2)

    if ((p->tmask >> num) & 0x1)
    80003440:	1744a783          	lw	a5,372(s1)
    80003444:	0137d7bb          	srlw	a5,a5,s3
    80003448:	8b85                	andi	a5,a5,1
    8000344a:	cbad                	beqz	a5,800034bc <syscall+0xc6>
    {
      printf("%d: syscall %s (", p->pid, syscall_name[num]);
    8000344c:	098e                	slli	s3,s3,0x3
    8000344e:	00006797          	auipc	a5,0x6
    80003452:	60a78793          	addi	a5,a5,1546 # 80009a58 <syscall_name>
    80003456:	99be                	add	s3,s3,a5
    80003458:	0009b603          	ld	a2,0(s3)
    8000345c:	588c                	lw	a1,48(s1)
    8000345e:	00006517          	auipc	a0,0x6
    80003462:	03250513          	addi	a0,a0,50 # 80009490 <states.0+0x150>
    80003466:	ffffd097          	auipc	ra,0xffffd
    8000346a:	122080e7          	jalr	290(ra) # 80000588 <printf>
      if (argcount == 1)
        printf("%d ", arg0);
      else if (argcount == 2)
        printf("%d %d ", arg0, p->trapframe->a1);
      else if (argcount == 3)
        printf("%d %d %d ", arg0, p->trapframe->a1, p->trapframe->a2);
    8000346e:	6cbc                	ld	a5,88(s1)
    80003470:	63d4                	ld	a3,128(a5)
    80003472:	7fb0                	ld	a2,120(a5)
    80003474:	000a059b          	sext.w	a1,s4
    80003478:	00006517          	auipc	a0,0x6
    8000347c:	03050513          	addi	a0,a0,48 # 800094a8 <states.0+0x168>
    80003480:	ffffd097          	auipc	ra,0xffffd
    80003484:	108080e7          	jalr	264(ra) # 80000588 <printf>

      printf(") -> %d\n", p->trapframe->a0);
    80003488:	6cbc                	ld	a5,88(s1)
    8000348a:	7bac                	ld	a1,112(a5)
    8000348c:	00006517          	auipc	a0,0x6
    80003490:	02c50513          	addi	a0,a0,44 # 800094b8 <states.0+0x178>
    80003494:	ffffd097          	auipc	ra,0xffffd
    80003498:	0f4080e7          	jalr	244(ra) # 80000588 <printf>
    8000349c:	a005                	j	800034bc <syscall+0xc6>
    }
  }
  else
  {
    printf("%d %s: unknown sys call %d\n",
    8000349e:	86ce                	mv	a3,s3
    800034a0:	15848613          	addi	a2,s1,344
    800034a4:	588c                	lw	a1,48(s1)
    800034a6:	00006517          	auipc	a0,0x6
    800034aa:	02250513          	addi	a0,a0,34 # 800094c8 <states.0+0x188>
    800034ae:	ffffd097          	auipc	ra,0xffffd
    800034b2:	0da080e7          	jalr	218(ra) # 80000588 <printf>
           p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800034b6:	6cbc                	ld	a5,88(s1)
    800034b8:	577d                	li	a4,-1
    800034ba:	fbb8                	sd	a4,112(a5)
  }
}
    800034bc:	70a2                	ld	ra,40(sp)
    800034be:	7402                	ld	s0,32(sp)
    800034c0:	64e2                	ld	s1,24(sp)
    800034c2:	6942                	ld	s2,16(sp)
    800034c4:	69a2                	ld	s3,8(sp)
    800034c6:	6a02                	ld	s4,0(sp)
    800034c8:	6145                	addi	sp,sp,48
    800034ca:	8082                	ret

00000000800034cc <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800034cc:	1101                	addi	sp,sp,-32
    800034ce:	ec06                	sd	ra,24(sp)
    800034d0:	e822                	sd	s0,16(sp)
    800034d2:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800034d4:	fec40593          	addi	a1,s0,-20
    800034d8:	4501                	li	a0,0
    800034da:	00000097          	auipc	ra,0x0
    800034de:	ea4080e7          	jalr	-348(ra) # 8000337e <argint>
  exit(n);
    800034e2:	fec42503          	lw	a0,-20(s0)
    800034e6:	fffff097          	auipc	ra,0xfffff
    800034ea:	32c080e7          	jalr	812(ra) # 80002812 <exit>
  return 0; // not reached
}
    800034ee:	4501                	li	a0,0
    800034f0:	60e2                	ld	ra,24(sp)
    800034f2:	6442                	ld	s0,16(sp)
    800034f4:	6105                	addi	sp,sp,32
    800034f6:	8082                	ret

00000000800034f8 <sys_getpid>:

uint64
sys_getpid(void)
{
    800034f8:	1141                	addi	sp,sp,-16
    800034fa:	e406                	sd	ra,8(sp)
    800034fc:	e022                	sd	s0,0(sp)
    800034fe:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80003500:	ffffe097          	auipc	ra,0xffffe
    80003504:	6ee080e7          	jalr	1774(ra) # 80001bee <myproc>
}
    80003508:	5908                	lw	a0,48(a0)
    8000350a:	60a2                	ld	ra,8(sp)
    8000350c:	6402                	ld	s0,0(sp)
    8000350e:	0141                	addi	sp,sp,16
    80003510:	8082                	ret

0000000080003512 <sys_fork>:

uint64
sys_fork(void)
{
    80003512:	1141                	addi	sp,sp,-16
    80003514:	e406                	sd	ra,8(sp)
    80003516:	e022                	sd	s0,0(sp)
    80003518:	0800                	addi	s0,sp,16
  return fork();
    8000351a:	fffff097          	auipc	ra,0xfffff
    8000351e:	b12080e7          	jalr	-1262(ra) # 8000202c <fork>
}
    80003522:	60a2                	ld	ra,8(sp)
    80003524:	6402                	ld	s0,0(sp)
    80003526:	0141                	addi	sp,sp,16
    80003528:	8082                	ret

000000008000352a <sys_wait>:

uint64
sys_wait(void)
{
    8000352a:	1101                	addi	sp,sp,-32
    8000352c:	ec06                	sd	ra,24(sp)
    8000352e:	e822                	sd	s0,16(sp)
    80003530:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80003532:	fe840593          	addi	a1,s0,-24
    80003536:	4501                	li	a0,0
    80003538:	00000097          	auipc	ra,0x0
    8000353c:	e66080e7          	jalr	-410(ra) # 8000339e <argaddr>
  return wait(p);
    80003540:	fe843503          	ld	a0,-24(s0)
    80003544:	fffff097          	auipc	ra,0xfffff
    80003548:	480080e7          	jalr	1152(ra) # 800029c4 <wait>
}
    8000354c:	60e2                	ld	ra,24(sp)
    8000354e:	6442                	ld	s0,16(sp)
    80003550:	6105                	addi	sp,sp,32
    80003552:	8082                	ret

0000000080003554 <sys_waitx>:

uint64
sys_waitx(void)
{
    80003554:	7139                	addi	sp,sp,-64
    80003556:	fc06                	sd	ra,56(sp)
    80003558:	f822                	sd	s0,48(sp)
    8000355a:	f426                	sd	s1,40(sp)
    8000355c:	f04a                	sd	s2,32(sp)
    8000355e:	0080                	addi	s0,sp,64
  uint64 addr, addr1, addr2;
  uint wtime, rtime;
  argaddr(0, &addr);
    80003560:	fd840593          	addi	a1,s0,-40
    80003564:	4501                	li	a0,0
    80003566:	00000097          	auipc	ra,0x0
    8000356a:	e38080e7          	jalr	-456(ra) # 8000339e <argaddr>
  argaddr(1, &addr1); // user virtual memory
    8000356e:	fd040593          	addi	a1,s0,-48
    80003572:	4505                	li	a0,1
    80003574:	00000097          	auipc	ra,0x0
    80003578:	e2a080e7          	jalr	-470(ra) # 8000339e <argaddr>
  argaddr(2, &addr2);
    8000357c:	fc840593          	addi	a1,s0,-56
    80003580:	4509                	li	a0,2
    80003582:	00000097          	auipc	ra,0x0
    80003586:	e1c080e7          	jalr	-484(ra) # 8000339e <argaddr>
  int ret = waitx(addr, &wtime, &rtime);
    8000358a:	fc040613          	addi	a2,s0,-64
    8000358e:	fc440593          	addi	a1,s0,-60
    80003592:	fd843503          	ld	a0,-40(s0)
    80003596:	fffff097          	auipc	ra,0xfffff
    8000359a:	040080e7          	jalr	64(ra) # 800025d6 <waitx>
    8000359e:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800035a0:	ffffe097          	auipc	ra,0xffffe
    800035a4:	64e080e7          	jalr	1614(ra) # 80001bee <myproc>
    800035a8:	84aa                	mv	s1,a0
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    800035aa:	4691                	li	a3,4
    800035ac:	fc440613          	addi	a2,s0,-60
    800035b0:	fd043583          	ld	a1,-48(s0)
    800035b4:	6928                	ld	a0,80(a0)
    800035b6:	ffffe097          	auipc	ra,0xffffe
    800035ba:	28c080e7          	jalr	652(ra) # 80001842 <copyout>
    return -1;
    800035be:	57fd                	li	a5,-1
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    800035c0:	00054f63          	bltz	a0,800035de <sys_waitx+0x8a>
  if (copyout(p->pagetable, addr2, (char *)&rtime, sizeof(int)) < 0)
    800035c4:	4691                	li	a3,4
    800035c6:	fc040613          	addi	a2,s0,-64
    800035ca:	fc843583          	ld	a1,-56(s0)
    800035ce:	68a8                	ld	a0,80(s1)
    800035d0:	ffffe097          	auipc	ra,0xffffe
    800035d4:	272080e7          	jalr	626(ra) # 80001842 <copyout>
    800035d8:	00054a63          	bltz	a0,800035ec <sys_waitx+0x98>
    return -1;
  return ret;
    800035dc:	87ca                	mv	a5,s2
}
    800035de:	853e                	mv	a0,a5
    800035e0:	70e2                	ld	ra,56(sp)
    800035e2:	7442                	ld	s0,48(sp)
    800035e4:	74a2                	ld	s1,40(sp)
    800035e6:	7902                	ld	s2,32(sp)
    800035e8:	6121                	addi	sp,sp,64
    800035ea:	8082                	ret
    return -1;
    800035ec:	57fd                	li	a5,-1
    800035ee:	bfc5                	j	800035de <sys_waitx+0x8a>

00000000800035f0 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800035f0:	7179                	addi	sp,sp,-48
    800035f2:	f406                	sd	ra,40(sp)
    800035f4:	f022                	sd	s0,32(sp)
    800035f6:	ec26                	sd	s1,24(sp)
    800035f8:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800035fa:	fdc40593          	addi	a1,s0,-36
    800035fe:	4501                	li	a0,0
    80003600:	00000097          	auipc	ra,0x0
    80003604:	d7e080e7          	jalr	-642(ra) # 8000337e <argint>
  addr = myproc()->sz;
    80003608:	ffffe097          	auipc	ra,0xffffe
    8000360c:	5e6080e7          	jalr	1510(ra) # 80001bee <myproc>
    80003610:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0)
    80003612:	fdc42503          	lw	a0,-36(s0)
    80003616:	fffff097          	auipc	ra,0xfffff
    8000361a:	9ba080e7          	jalr	-1606(ra) # 80001fd0 <growproc>
    8000361e:	00054863          	bltz	a0,8000362e <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80003622:	8526                	mv	a0,s1
    80003624:	70a2                	ld	ra,40(sp)
    80003626:	7402                	ld	s0,32(sp)
    80003628:	64e2                	ld	s1,24(sp)
    8000362a:	6145                	addi	sp,sp,48
    8000362c:	8082                	ret
    return -1;
    8000362e:	54fd                	li	s1,-1
    80003630:	bfcd                	j	80003622 <sys_sbrk+0x32>

0000000080003632 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003632:	7139                	addi	sp,sp,-64
    80003634:	fc06                	sd	ra,56(sp)
    80003636:	f822                	sd	s0,48(sp)
    80003638:	f426                	sd	s1,40(sp)
    8000363a:	f04a                	sd	s2,32(sp)
    8000363c:	ec4e                	sd	s3,24(sp)
    8000363e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80003640:	fcc40593          	addi	a1,s0,-52
    80003644:	4501                	li	a0,0
    80003646:	00000097          	auipc	ra,0x0
    8000364a:	d38080e7          	jalr	-712(ra) # 8000337e <argint>
  acquire(&tickslock);
    8000364e:	00236517          	auipc	a0,0x236
    80003652:	66a50513          	addi	a0,a0,1642 # 80239cb8 <tickslock>
    80003656:	ffffd097          	auipc	ra,0xffffd
    8000365a:	73c080e7          	jalr	1852(ra) # 80000d92 <acquire>
  ticks0 = ticks;
    8000365e:	00006917          	auipc	s2,0x6
    80003662:	50a92903          	lw	s2,1290(s2) # 80009b68 <ticks>
  while (ticks - ticks0 < n)
    80003666:	fcc42783          	lw	a5,-52(s0)
    8000366a:	cf9d                	beqz	a5,800036a8 <sys_sleep+0x76>
    if (killed(myproc()))
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000366c:	00236997          	auipc	s3,0x236
    80003670:	64c98993          	addi	s3,s3,1612 # 80239cb8 <tickslock>
    80003674:	00006497          	auipc	s1,0x6
    80003678:	4f448493          	addi	s1,s1,1268 # 80009b68 <ticks>
    if (killed(myproc()))
    8000367c:	ffffe097          	auipc	ra,0xffffe
    80003680:	572080e7          	jalr	1394(ra) # 80001bee <myproc>
    80003684:	fffff097          	auipc	ra,0xfffff
    80003688:	30e080e7          	jalr	782(ra) # 80002992 <killed>
    8000368c:	ed15                	bnez	a0,800036c8 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    8000368e:	85ce                	mv	a1,s3
    80003690:	8526                	mv	a0,s1
    80003692:	fffff097          	auipc	ra,0xfffff
    80003696:	ed4080e7          	jalr	-300(ra) # 80002566 <sleep>
  while (ticks - ticks0 < n)
    8000369a:	409c                	lw	a5,0(s1)
    8000369c:	412787bb          	subw	a5,a5,s2
    800036a0:	fcc42703          	lw	a4,-52(s0)
    800036a4:	fce7ece3          	bltu	a5,a4,8000367c <sys_sleep+0x4a>
  }
  release(&tickslock);
    800036a8:	00236517          	auipc	a0,0x236
    800036ac:	61050513          	addi	a0,a0,1552 # 80239cb8 <tickslock>
    800036b0:	ffffd097          	auipc	ra,0xffffd
    800036b4:	796080e7          	jalr	1942(ra) # 80000e46 <release>
  return 0;
    800036b8:	4501                	li	a0,0
}
    800036ba:	70e2                	ld	ra,56(sp)
    800036bc:	7442                	ld	s0,48(sp)
    800036be:	74a2                	ld	s1,40(sp)
    800036c0:	7902                	ld	s2,32(sp)
    800036c2:	69e2                	ld	s3,24(sp)
    800036c4:	6121                	addi	sp,sp,64
    800036c6:	8082                	ret
      release(&tickslock);
    800036c8:	00236517          	auipc	a0,0x236
    800036cc:	5f050513          	addi	a0,a0,1520 # 80239cb8 <tickslock>
    800036d0:	ffffd097          	auipc	ra,0xffffd
    800036d4:	776080e7          	jalr	1910(ra) # 80000e46 <release>
      return -1;
    800036d8:	557d                	li	a0,-1
    800036da:	b7c5                	j	800036ba <sys_sleep+0x88>

00000000800036dc <sys_kill>:

uint64
sys_kill(void)
{
    800036dc:	1101                	addi	sp,sp,-32
    800036de:	ec06                	sd	ra,24(sp)
    800036e0:	e822                	sd	s0,16(sp)
    800036e2:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800036e4:	fec40593          	addi	a1,s0,-20
    800036e8:	4501                	li	a0,0
    800036ea:	00000097          	auipc	ra,0x0
    800036ee:	c94080e7          	jalr	-876(ra) # 8000337e <argint>
  return kill(pid);
    800036f2:	fec42503          	lw	a0,-20(s0)
    800036f6:	fffff097          	auipc	ra,0xfffff
    800036fa:	1fe080e7          	jalr	510(ra) # 800028f4 <kill>
}
    800036fe:	60e2                	ld	ra,24(sp)
    80003700:	6442                	ld	s0,16(sp)
    80003702:	6105                	addi	sp,sp,32
    80003704:	8082                	ret

0000000080003706 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003706:	1101                	addi	sp,sp,-32
    80003708:	ec06                	sd	ra,24(sp)
    8000370a:	e822                	sd	s0,16(sp)
    8000370c:	e426                	sd	s1,8(sp)
    8000370e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003710:	00236517          	auipc	a0,0x236
    80003714:	5a850513          	addi	a0,a0,1448 # 80239cb8 <tickslock>
    80003718:	ffffd097          	auipc	ra,0xffffd
    8000371c:	67a080e7          	jalr	1658(ra) # 80000d92 <acquire>
  xticks = ticks;
    80003720:	00006497          	auipc	s1,0x6
    80003724:	4484a483          	lw	s1,1096(s1) # 80009b68 <ticks>
  release(&tickslock);
    80003728:	00236517          	auipc	a0,0x236
    8000372c:	59050513          	addi	a0,a0,1424 # 80239cb8 <tickslock>
    80003730:	ffffd097          	auipc	ra,0xffffd
    80003734:	716080e7          	jalr	1814(ra) # 80000e46 <release>
  return xticks;
}
    80003738:	02049513          	slli	a0,s1,0x20
    8000373c:	9101                	srli	a0,a0,0x20
    8000373e:	60e2                	ld	ra,24(sp)
    80003740:	6442                	ld	s0,16(sp)
    80003742:	64a2                	ld	s1,8(sp)
    80003744:	6105                	addi	sp,sp,32
    80003746:	8082                	ret

0000000080003748 <sys_trace>:

// system trace
uint64 sys_trace(void)
{
    80003748:	7179                	addi	sp,sp,-48
    8000374a:	f406                	sd	ra,40(sp)
    8000374c:	f022                	sd	s0,32(sp)
    8000374e:	ec26                	sd	s1,24(sp)
    80003750:	1800                	addi	s0,sp,48
  int tmask;
  argint(0, &tmask);
    80003752:	fdc40593          	addi	a1,s0,-36
    80003756:	4501                	li	a0,0
    80003758:	00000097          	auipc	ra,0x0
    8000375c:	c26080e7          	jalr	-986(ra) # 8000337e <argint>
  myproc()->tmask = tmask;
    80003760:	fdc42483          	lw	s1,-36(s0)
    80003764:	ffffe097          	auipc	ra,0xffffe
    80003768:	48a080e7          	jalr	1162(ra) # 80001bee <myproc>
    8000376c:	16952a23          	sw	s1,372(a0)
  return 0;
}
    80003770:	4501                	li	a0,0
    80003772:	70a2                	ld	ra,40(sp)
    80003774:	7402                	ld	s0,32(sp)
    80003776:	64e2                	ld	s1,24(sp)
    80003778:	6145                	addi	sp,sp,48
    8000377a:	8082                	ret

000000008000377c <sys_sigalarm>:


// sigalarm
uint64 sys_sigalarm(void)
{
    8000377c:	1101                	addi	sp,sp,-32
    8000377e:	ec06                	sd	ra,24(sp)
    80003780:	e822                	sd	s0,16(sp)
    80003782:	1000                	addi	s0,sp,32
  int interval;
  uint64 fn;
  argint(0, &interval);
    80003784:	fec40593          	addi	a1,s0,-20
    80003788:	4501                	li	a0,0
    8000378a:	00000097          	auipc	ra,0x0
    8000378e:	bf4080e7          	jalr	-1036(ra) # 8000337e <argint>
  argaddr(1, &fn);
    80003792:	fe040593          	addi	a1,s0,-32
    80003796:	4505                	li	a0,1
    80003798:	00000097          	auipc	ra,0x0
    8000379c:	c06080e7          	jalr	-1018(ra) # 8000339e <argaddr>

  struct proc *p = myproc();
    800037a0:	ffffe097          	auipc	ra,0xffffe
    800037a4:	44e080e7          	jalr	1102(ra) # 80001bee <myproc>

  p->sigalarm_status = 0;
    800037a8:	1a052c23          	sw	zero,440(a0)
  p->interval = interval;
    800037ac:	fec42783          	lw	a5,-20(s0)
    800037b0:	1af52423          	sw	a5,424(a0)
  p->now_ticks = 0;
    800037b4:	1a052623          	sw	zero,428(a0)
  p->handler = fn;
    800037b8:	fe043783          	ld	a5,-32(s0)
    800037bc:	1af53023          	sd	a5,416(a0)

  return 0;
}
    800037c0:	4501                	li	a0,0
    800037c2:	60e2                	ld	ra,24(sp)
    800037c4:	6442                	ld	s0,16(sp)
    800037c6:	6105                	addi	sp,sp,32
    800037c8:	8082                	ret

00000000800037ca <sys_sigreturn>:

uint64 sys_sigreturn(void)
{
    800037ca:	1101                	addi	sp,sp,-32
    800037cc:	ec06                	sd	ra,24(sp)
    800037ce:	e822                	sd	s0,16(sp)
    800037d0:	e426                	sd	s1,8(sp)
    800037d2:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800037d4:	ffffe097          	auipc	ra,0xffffe
    800037d8:	41a080e7          	jalr	1050(ra) # 80001bee <myproc>
    800037dc:	84aa                	mv	s1,a0

  // Restore Kernel Values
  memmove(p->trapframe, p->alarm_trapframe, PGSIZE);
    800037de:	6605                	lui	a2,0x1
    800037e0:	1b053583          	ld	a1,432(a0)
    800037e4:	6d28                	ld	a0,88(a0)
    800037e6:	ffffd097          	auipc	ra,0xffffd
    800037ea:	704080e7          	jalr	1796(ra) # 80000eea <memmove>
  kfree(p->alarm_trapframe);
    800037ee:	1b04b503          	ld	a0,432(s1)
    800037f2:	ffffd097          	auipc	ra,0xffffd
    800037f6:	284080e7          	jalr	644(ra) # 80000a76 <kfree>

  p->sigalarm_status = 0;
    800037fa:	1a04ac23          	sw	zero,440(s1)
  p->alarm_trapframe = 0;
    800037fe:	1a04b823          	sd	zero,432(s1)
  p->now_ticks = 0;
    80003802:	1a04a623          	sw	zero,428(s1)
  usertrapret();
    80003806:	fffff097          	auipc	ra,0xfffff
    8000380a:	57a080e7          	jalr	1402(ra) # 80002d80 <usertrapret>
  return 0;
}
    8000380e:	4501                	li	a0,0
    80003810:	60e2                	ld	ra,24(sp)
    80003812:	6442                	ld	s0,16(sp)
    80003814:	64a2                	ld	s1,8(sp)
    80003816:	6105                	addi	sp,sp,32
    80003818:	8082                	ret

000000008000381a <sys_setpriority>:

uint64 sys_setpriority(void)
{
    8000381a:	1101                	addi	sp,sp,-32
    8000381c:	ec06                	sd	ra,24(sp)
    8000381e:	e822                	sd	s0,16(sp)
    80003820:	1000                	addi	s0,sp,32
  int number, piid;
  argint(0, &number);
    80003822:	fec40593          	addi	a1,s0,-20
    80003826:	4501                	li	a0,0
    80003828:	00000097          	auipc	ra,0x0
    8000382c:	b56080e7          	jalr	-1194(ra) # 8000337e <argint>
  argint(1, &piid);
    80003830:	fe840593          	addi	a1,s0,-24
    80003834:	4505                	li	a0,1
    80003836:	00000097          	auipc	ra,0x0
    8000383a:	b48080e7          	jalr	-1208(ra) # 8000337e <argint>
  setpriority(number, piid);
    8000383e:	fe842583          	lw	a1,-24(s0)
    80003842:	fec42503          	lw	a0,-20(s0)
    80003846:	fffff097          	auipc	ra,0xfffff
    8000384a:	40a080e7          	jalr	1034(ra) # 80002c50 <setpriority>
  return 0;
}
    8000384e:	4501                	li	a0,0
    80003850:	60e2                	ld	ra,24(sp)
    80003852:	6442                	ld	s0,16(sp)
    80003854:	6105                	addi	sp,sp,32
    80003856:	8082                	ret

0000000080003858 <sys_sysinfo>:


uint64
sys_sysinfo(void)
{
    80003858:	7179                	addi	sp,sp,-48
    8000385a:	f406                	sd	ra,40(sp)
    8000385c:	f022                	sd	s0,32(sp)
    8000385e:	1800                	addi	s0,sp,48
        uint64 used;
    };

    struct sysinfo info;

    info.total = PHYSTOP - KERNBASE;
    80003860:	080007b7          	lui	a5,0x8000
    80003864:	fcf43c23          	sd	a5,-40(s0)
    info.free = kfreemem();  // We'll add this function
    80003868:	ffffd097          	auipc	ra,0xffffd
    8000386c:	450080e7          	jalr	1104(ra) # 80000cb8 <kfreemem>
    80003870:	fea43023          	sd	a0,-32(s0)
    info.used = info.total - info.free;
    80003874:	fd843783          	ld	a5,-40(s0)
    80003878:	40a78533          	sub	a0,a5,a0
    8000387c:	fea43423          	sd	a0,-24(s0)

    uint64 addr;
    argaddr(0, &addr);
    80003880:	fd040593          	addi	a1,s0,-48
    80003884:	4501                	li	a0,0
    80003886:	00000097          	auipc	ra,0x0
    8000388a:	b18080e7          	jalr	-1256(ra) # 8000339e <argaddr>
    if (copyout(myproc()->pagetable, addr, (char *)&info, sizeof(info)) < 0)
    8000388e:	ffffe097          	auipc	ra,0xffffe
    80003892:	360080e7          	jalr	864(ra) # 80001bee <myproc>
    80003896:	46e1                	li	a3,24
    80003898:	fd840613          	addi	a2,s0,-40
    8000389c:	fd043583          	ld	a1,-48(s0)
    800038a0:	6928                	ld	a0,80(a0)
    800038a2:	ffffe097          	auipc	ra,0xffffe
    800038a6:	fa0080e7          	jalr	-96(ra) # 80001842 <copyout>
        return -1;
    return 0;
    800038aa:	957d                	srai	a0,a0,0x3f
    800038ac:	70a2                	ld	ra,40(sp)
    800038ae:	7402                	ld	s0,32(sp)
    800038b0:	6145                	addi	sp,sp,48
    800038b2:	8082                	ret

00000000800038b4 <binit>:
  // head.next is most recent, head.prev is least.
  struct buf head;
} bcache;

void binit(void)
{
    800038b4:	7179                	addi	sp,sp,-48
    800038b6:	f406                	sd	ra,40(sp)
    800038b8:	f022                	sd	s0,32(sp)
    800038ba:	ec26                	sd	s1,24(sp)
    800038bc:	e84a                	sd	s2,16(sp)
    800038be:	e44e                	sd	s3,8(sp)
    800038c0:	e052                	sd	s4,0(sp)
    800038c2:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800038c4:	00006597          	auipc	a1,0x6
    800038c8:	dfc58593          	addi	a1,a1,-516 # 800096c0 <syscalls+0xe0>
    800038cc:	00236517          	auipc	a0,0x236
    800038d0:	40450513          	addi	a0,a0,1028 # 80239cd0 <bcache>
    800038d4:	ffffd097          	auipc	ra,0xffffd
    800038d8:	42e080e7          	jalr	1070(ra) # 80000d02 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800038dc:	0023e797          	auipc	a5,0x23e
    800038e0:	3f478793          	addi	a5,a5,1012 # 80241cd0 <bcache+0x8000>
    800038e4:	0023e717          	auipc	a4,0x23e
    800038e8:	65470713          	addi	a4,a4,1620 # 80241f38 <bcache+0x8268>
    800038ec:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800038f0:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++)
    800038f4:	00236497          	auipc	s1,0x236
    800038f8:	3f448493          	addi	s1,s1,1012 # 80239ce8 <bcache+0x18>
  {
    b->next = bcache.head.next;
    800038fc:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800038fe:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003900:	00006a17          	auipc	s4,0x6
    80003904:	dc8a0a13          	addi	s4,s4,-568 # 800096c8 <syscalls+0xe8>
    b->next = bcache.head.next;
    80003908:	2b893783          	ld	a5,696(s2)
    8000390c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000390e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003912:	85d2                	mv	a1,s4
    80003914:	01048513          	addi	a0,s1,16
    80003918:	00001097          	auipc	ra,0x1
    8000391c:	4c4080e7          	jalr	1220(ra) # 80004ddc <initsleeplock>
    bcache.head.next->prev = b;
    80003920:	2b893783          	ld	a5,696(s2)
    80003924:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003926:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++)
    8000392a:	45848493          	addi	s1,s1,1112
    8000392e:	fd349de3          	bne	s1,s3,80003908 <binit+0x54>
  }
}
    80003932:	70a2                	ld	ra,40(sp)
    80003934:	7402                	ld	s0,32(sp)
    80003936:	64e2                	ld	s1,24(sp)
    80003938:	6942                	ld	s2,16(sp)
    8000393a:	69a2                	ld	s3,8(sp)
    8000393c:	6a02                	ld	s4,0(sp)
    8000393e:	6145                	addi	sp,sp,48
    80003940:	8082                	ret

0000000080003942 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf *
bread(uint dev, uint blockno)
{
    80003942:	7179                	addi	sp,sp,-48
    80003944:	f406                	sd	ra,40(sp)
    80003946:	f022                	sd	s0,32(sp)
    80003948:	ec26                	sd	s1,24(sp)
    8000394a:	e84a                	sd	s2,16(sp)
    8000394c:	e44e                	sd	s3,8(sp)
    8000394e:	1800                	addi	s0,sp,48
    80003950:	892a                	mv	s2,a0
    80003952:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003954:	00236517          	auipc	a0,0x236
    80003958:	37c50513          	addi	a0,a0,892 # 80239cd0 <bcache>
    8000395c:	ffffd097          	auipc	ra,0xffffd
    80003960:	436080e7          	jalr	1078(ra) # 80000d92 <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next)
    80003964:	0023e497          	auipc	s1,0x23e
    80003968:	6244b483          	ld	s1,1572(s1) # 80241f88 <bcache+0x82b8>
    8000396c:	0023e797          	auipc	a5,0x23e
    80003970:	5cc78793          	addi	a5,a5,1484 # 80241f38 <bcache+0x8268>
    80003974:	02f48f63          	beq	s1,a5,800039b2 <bread+0x70>
    80003978:	873e                	mv	a4,a5
    8000397a:	a021                	j	80003982 <bread+0x40>
    8000397c:	68a4                	ld	s1,80(s1)
    8000397e:	02e48a63          	beq	s1,a4,800039b2 <bread+0x70>
    if (b->dev == dev && b->blockno == blockno)
    80003982:	449c                	lw	a5,8(s1)
    80003984:	ff279ce3          	bne	a5,s2,8000397c <bread+0x3a>
    80003988:	44dc                	lw	a5,12(s1)
    8000398a:	ff3799e3          	bne	a5,s3,8000397c <bread+0x3a>
      b->refcnt++;
    8000398e:	40bc                	lw	a5,64(s1)
    80003990:	2785                	addiw	a5,a5,1
    80003992:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003994:	00236517          	auipc	a0,0x236
    80003998:	33c50513          	addi	a0,a0,828 # 80239cd0 <bcache>
    8000399c:	ffffd097          	auipc	ra,0xffffd
    800039a0:	4aa080e7          	jalr	1194(ra) # 80000e46 <release>
      acquiresleep(&b->lock);
    800039a4:	01048513          	addi	a0,s1,16
    800039a8:	00001097          	auipc	ra,0x1
    800039ac:	46e080e7          	jalr	1134(ra) # 80004e16 <acquiresleep>
      return b;
    800039b0:	a8b9                	j	80003a0e <bread+0xcc>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev)
    800039b2:	0023e497          	auipc	s1,0x23e
    800039b6:	5ce4b483          	ld	s1,1486(s1) # 80241f80 <bcache+0x82b0>
    800039ba:	0023e797          	auipc	a5,0x23e
    800039be:	57e78793          	addi	a5,a5,1406 # 80241f38 <bcache+0x8268>
    800039c2:	00f48863          	beq	s1,a5,800039d2 <bread+0x90>
    800039c6:	873e                	mv	a4,a5
    if (b->refcnt == 0)
    800039c8:	40bc                	lw	a5,64(s1)
    800039ca:	cf81                	beqz	a5,800039e2 <bread+0xa0>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev)
    800039cc:	64a4                	ld	s1,72(s1)
    800039ce:	fee49de3          	bne	s1,a4,800039c8 <bread+0x86>
  panic("bget: no buffers");
    800039d2:	00006517          	auipc	a0,0x6
    800039d6:	cfe50513          	addi	a0,a0,-770 # 800096d0 <syscalls+0xf0>
    800039da:	ffffd097          	auipc	ra,0xffffd
    800039de:	b64080e7          	jalr	-1180(ra) # 8000053e <panic>
      b->dev = dev;
    800039e2:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800039e6:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800039ea:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800039ee:	4785                	li	a5,1
    800039f0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800039f2:	00236517          	auipc	a0,0x236
    800039f6:	2de50513          	addi	a0,a0,734 # 80239cd0 <bcache>
    800039fa:	ffffd097          	auipc	ra,0xffffd
    800039fe:	44c080e7          	jalr	1100(ra) # 80000e46 <release>
      acquiresleep(&b->lock);
    80003a02:	01048513          	addi	a0,s1,16
    80003a06:	00001097          	auipc	ra,0x1
    80003a0a:	410080e7          	jalr	1040(ra) # 80004e16 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid)
    80003a0e:	409c                	lw	a5,0(s1)
    80003a10:	cb89                	beqz	a5,80003a22 <bread+0xe0>
  {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003a12:	8526                	mv	a0,s1
    80003a14:	70a2                	ld	ra,40(sp)
    80003a16:	7402                	ld	s0,32(sp)
    80003a18:	64e2                	ld	s1,24(sp)
    80003a1a:	6942                	ld	s2,16(sp)
    80003a1c:	69a2                	ld	s3,8(sp)
    80003a1e:	6145                	addi	sp,sp,48
    80003a20:	8082                	ret
    virtio_disk_rw(b, 0);
    80003a22:	4581                	li	a1,0
    80003a24:	8526                	mv	a0,s1
    80003a26:	00003097          	auipc	ra,0x3
    80003a2a:	3fe080e7          	jalr	1022(ra) # 80006e24 <virtio_disk_rw>
    b->valid = 1;
    80003a2e:	4785                	li	a5,1
    80003a30:	c09c                	sw	a5,0(s1)
  return b;
    80003a32:	b7c5                	j	80003a12 <bread+0xd0>

0000000080003a34 <bwrite>:

// Write b's contents to disk.  Must be locked.
void bwrite(struct buf *b)
{
    80003a34:	1101                	addi	sp,sp,-32
    80003a36:	ec06                	sd	ra,24(sp)
    80003a38:	e822                	sd	s0,16(sp)
    80003a3a:	e426                	sd	s1,8(sp)
    80003a3c:	1000                	addi	s0,sp,32
    80003a3e:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80003a40:	0541                	addi	a0,a0,16
    80003a42:	00001097          	auipc	ra,0x1
    80003a46:	46e080e7          	jalr	1134(ra) # 80004eb0 <holdingsleep>
    80003a4a:	cd01                	beqz	a0,80003a62 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003a4c:	4585                	li	a1,1
    80003a4e:	8526                	mv	a0,s1
    80003a50:	00003097          	auipc	ra,0x3
    80003a54:	3d4080e7          	jalr	980(ra) # 80006e24 <virtio_disk_rw>
}
    80003a58:	60e2                	ld	ra,24(sp)
    80003a5a:	6442                	ld	s0,16(sp)
    80003a5c:	64a2                	ld	s1,8(sp)
    80003a5e:	6105                	addi	sp,sp,32
    80003a60:	8082                	ret
    panic("bwrite");
    80003a62:	00006517          	auipc	a0,0x6
    80003a66:	c8650513          	addi	a0,a0,-890 # 800096e8 <syscalls+0x108>
    80003a6a:	ffffd097          	auipc	ra,0xffffd
    80003a6e:	ad4080e7          	jalr	-1324(ra) # 8000053e <panic>

0000000080003a72 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void brelse(struct buf *b)
{
    80003a72:	1101                	addi	sp,sp,-32
    80003a74:	ec06                	sd	ra,24(sp)
    80003a76:	e822                	sd	s0,16(sp)
    80003a78:	e426                	sd	s1,8(sp)
    80003a7a:	e04a                	sd	s2,0(sp)
    80003a7c:	1000                	addi	s0,sp,32
    80003a7e:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80003a80:	01050913          	addi	s2,a0,16
    80003a84:	854a                	mv	a0,s2
    80003a86:	00001097          	auipc	ra,0x1
    80003a8a:	42a080e7          	jalr	1066(ra) # 80004eb0 <holdingsleep>
    80003a8e:	c92d                	beqz	a0,80003b00 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80003a90:	854a                	mv	a0,s2
    80003a92:	00001097          	auipc	ra,0x1
    80003a96:	3da080e7          	jalr	986(ra) # 80004e6c <releasesleep>

  acquire(&bcache.lock);
    80003a9a:	00236517          	auipc	a0,0x236
    80003a9e:	23650513          	addi	a0,a0,566 # 80239cd0 <bcache>
    80003aa2:	ffffd097          	auipc	ra,0xffffd
    80003aa6:	2f0080e7          	jalr	752(ra) # 80000d92 <acquire>
  b->refcnt--;
    80003aaa:	40bc                	lw	a5,64(s1)
    80003aac:	37fd                	addiw	a5,a5,-1
    80003aae:	0007871b          	sext.w	a4,a5
    80003ab2:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0)
    80003ab4:	eb05                	bnez	a4,80003ae4 <brelse+0x72>
  {
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003ab6:	68bc                	ld	a5,80(s1)
    80003ab8:	64b8                	ld	a4,72(s1)
    80003aba:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003abc:	64bc                	ld	a5,72(s1)
    80003abe:	68b8                	ld	a4,80(s1)
    80003ac0:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003ac2:	0023e797          	auipc	a5,0x23e
    80003ac6:	20e78793          	addi	a5,a5,526 # 80241cd0 <bcache+0x8000>
    80003aca:	2b87b703          	ld	a4,696(a5)
    80003ace:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003ad0:	0023e717          	auipc	a4,0x23e
    80003ad4:	46870713          	addi	a4,a4,1128 # 80241f38 <bcache+0x8268>
    80003ad8:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003ada:	2b87b703          	ld	a4,696(a5)
    80003ade:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003ae0:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    80003ae4:	00236517          	auipc	a0,0x236
    80003ae8:	1ec50513          	addi	a0,a0,492 # 80239cd0 <bcache>
    80003aec:	ffffd097          	auipc	ra,0xffffd
    80003af0:	35a080e7          	jalr	858(ra) # 80000e46 <release>
}
    80003af4:	60e2                	ld	ra,24(sp)
    80003af6:	6442                	ld	s0,16(sp)
    80003af8:	64a2                	ld	s1,8(sp)
    80003afa:	6902                	ld	s2,0(sp)
    80003afc:	6105                	addi	sp,sp,32
    80003afe:	8082                	ret
    panic("brelse");
    80003b00:	00006517          	auipc	a0,0x6
    80003b04:	bf050513          	addi	a0,a0,-1040 # 800096f0 <syscalls+0x110>
    80003b08:	ffffd097          	auipc	ra,0xffffd
    80003b0c:	a36080e7          	jalr	-1482(ra) # 8000053e <panic>

0000000080003b10 <bpin>:

void bpin(struct buf *b)
{
    80003b10:	1101                	addi	sp,sp,-32
    80003b12:	ec06                	sd	ra,24(sp)
    80003b14:	e822                	sd	s0,16(sp)
    80003b16:	e426                	sd	s1,8(sp)
    80003b18:	1000                	addi	s0,sp,32
    80003b1a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003b1c:	00236517          	auipc	a0,0x236
    80003b20:	1b450513          	addi	a0,a0,436 # 80239cd0 <bcache>
    80003b24:	ffffd097          	auipc	ra,0xffffd
    80003b28:	26e080e7          	jalr	622(ra) # 80000d92 <acquire>
  b->refcnt++;
    80003b2c:	40bc                	lw	a5,64(s1)
    80003b2e:	2785                	addiw	a5,a5,1
    80003b30:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003b32:	00236517          	auipc	a0,0x236
    80003b36:	19e50513          	addi	a0,a0,414 # 80239cd0 <bcache>
    80003b3a:	ffffd097          	auipc	ra,0xffffd
    80003b3e:	30c080e7          	jalr	780(ra) # 80000e46 <release>
}
    80003b42:	60e2                	ld	ra,24(sp)
    80003b44:	6442                	ld	s0,16(sp)
    80003b46:	64a2                	ld	s1,8(sp)
    80003b48:	6105                	addi	sp,sp,32
    80003b4a:	8082                	ret

0000000080003b4c <bunpin>:

void bunpin(struct buf *b)
{
    80003b4c:	1101                	addi	sp,sp,-32
    80003b4e:	ec06                	sd	ra,24(sp)
    80003b50:	e822                	sd	s0,16(sp)
    80003b52:	e426                	sd	s1,8(sp)
    80003b54:	1000                	addi	s0,sp,32
    80003b56:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003b58:	00236517          	auipc	a0,0x236
    80003b5c:	17850513          	addi	a0,a0,376 # 80239cd0 <bcache>
    80003b60:	ffffd097          	auipc	ra,0xffffd
    80003b64:	232080e7          	jalr	562(ra) # 80000d92 <acquire>
  b->refcnt--;
    80003b68:	40bc                	lw	a5,64(s1)
    80003b6a:	37fd                	addiw	a5,a5,-1
    80003b6c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003b6e:	00236517          	auipc	a0,0x236
    80003b72:	16250513          	addi	a0,a0,354 # 80239cd0 <bcache>
    80003b76:	ffffd097          	auipc	ra,0xffffd
    80003b7a:	2d0080e7          	jalr	720(ra) # 80000e46 <release>
}
    80003b7e:	60e2                	ld	ra,24(sp)
    80003b80:	6442                	ld	s0,16(sp)
    80003b82:	64a2                	ld	s1,8(sp)
    80003b84:	6105                	addi	sp,sp,32
    80003b86:	8082                	ret

0000000080003b88 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003b88:	1101                	addi	sp,sp,-32
    80003b8a:	ec06                	sd	ra,24(sp)
    80003b8c:	e822                	sd	s0,16(sp)
    80003b8e:	e426                	sd	s1,8(sp)
    80003b90:	e04a                	sd	s2,0(sp)
    80003b92:	1000                	addi	s0,sp,32
    80003b94:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003b96:	00d5d59b          	srliw	a1,a1,0xd
    80003b9a:	0023f797          	auipc	a5,0x23f
    80003b9e:	8127a783          	lw	a5,-2030(a5) # 802423ac <sb+0x1c>
    80003ba2:	9dbd                	addw	a1,a1,a5
    80003ba4:	00000097          	auipc	ra,0x0
    80003ba8:	d9e080e7          	jalr	-610(ra) # 80003942 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003bac:	0074f713          	andi	a4,s1,7
    80003bb0:	4785                	li	a5,1
    80003bb2:	00e797bb          	sllw	a5,a5,a4
  if ((bp->data[bi / 8] & m) == 0)
    80003bb6:	14ce                	slli	s1,s1,0x33
    80003bb8:	90d9                	srli	s1,s1,0x36
    80003bba:	00950733          	add	a4,a0,s1
    80003bbe:	05874703          	lbu	a4,88(a4)
    80003bc2:	00e7f6b3          	and	a3,a5,a4
    80003bc6:	c69d                	beqz	a3,80003bf4 <bfree+0x6c>
    80003bc8:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi / 8] &= ~m;
    80003bca:	94aa                	add	s1,s1,a0
    80003bcc:	fff7c793          	not	a5,a5
    80003bd0:	8ff9                	and	a5,a5,a4
    80003bd2:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80003bd6:	00001097          	auipc	ra,0x1
    80003bda:	120080e7          	jalr	288(ra) # 80004cf6 <log_write>
  brelse(bp);
    80003bde:	854a                	mv	a0,s2
    80003be0:	00000097          	auipc	ra,0x0
    80003be4:	e92080e7          	jalr	-366(ra) # 80003a72 <brelse>
}
    80003be8:	60e2                	ld	ra,24(sp)
    80003bea:	6442                	ld	s0,16(sp)
    80003bec:	64a2                	ld	s1,8(sp)
    80003bee:	6902                	ld	s2,0(sp)
    80003bf0:	6105                	addi	sp,sp,32
    80003bf2:	8082                	ret
    panic("freeing free block");
    80003bf4:	00006517          	auipc	a0,0x6
    80003bf8:	b0450513          	addi	a0,a0,-1276 # 800096f8 <syscalls+0x118>
    80003bfc:	ffffd097          	auipc	ra,0xffffd
    80003c00:	942080e7          	jalr	-1726(ra) # 8000053e <panic>

0000000080003c04 <balloc>:
{
    80003c04:	711d                	addi	sp,sp,-96
    80003c06:	ec86                	sd	ra,88(sp)
    80003c08:	e8a2                	sd	s0,80(sp)
    80003c0a:	e4a6                	sd	s1,72(sp)
    80003c0c:	e0ca                	sd	s2,64(sp)
    80003c0e:	fc4e                	sd	s3,56(sp)
    80003c10:	f852                	sd	s4,48(sp)
    80003c12:	f456                	sd	s5,40(sp)
    80003c14:	f05a                	sd	s6,32(sp)
    80003c16:	ec5e                	sd	s7,24(sp)
    80003c18:	e862                	sd	s8,16(sp)
    80003c1a:	e466                	sd	s9,8(sp)
    80003c1c:	1080                	addi	s0,sp,96
  for (b = 0; b < sb.size; b += BPB)
    80003c1e:	0023e797          	auipc	a5,0x23e
    80003c22:	7767a783          	lw	a5,1910(a5) # 80242394 <sb+0x4>
    80003c26:	10078163          	beqz	a5,80003d28 <balloc+0x124>
    80003c2a:	8baa                	mv	s7,a0
    80003c2c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003c2e:	0023eb17          	auipc	s6,0x23e
    80003c32:	762b0b13          	addi	s6,s6,1890 # 80242390 <sb>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    80003c36:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003c38:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    80003c3a:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB)
    80003c3c:	6c89                	lui	s9,0x2
    80003c3e:	a061                	j	80003cc6 <balloc+0xc2>
        bp->data[bi / 8] |= m; // Mark block in use.
    80003c40:	974a                	add	a4,a4,s2
    80003c42:	8fd5                	or	a5,a5,a3
    80003c44:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80003c48:	854a                	mv	a0,s2
    80003c4a:	00001097          	auipc	ra,0x1
    80003c4e:	0ac080e7          	jalr	172(ra) # 80004cf6 <log_write>
        brelse(bp);
    80003c52:	854a                	mv	a0,s2
    80003c54:	00000097          	auipc	ra,0x0
    80003c58:	e1e080e7          	jalr	-482(ra) # 80003a72 <brelse>
  bp = bread(dev, bno);
    80003c5c:	85a6                	mv	a1,s1
    80003c5e:	855e                	mv	a0,s7
    80003c60:	00000097          	auipc	ra,0x0
    80003c64:	ce2080e7          	jalr	-798(ra) # 80003942 <bread>
    80003c68:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003c6a:	40000613          	li	a2,1024
    80003c6e:	4581                	li	a1,0
    80003c70:	05850513          	addi	a0,a0,88
    80003c74:	ffffd097          	auipc	ra,0xffffd
    80003c78:	21a080e7          	jalr	538(ra) # 80000e8e <memset>
  log_write(bp);
    80003c7c:	854a                	mv	a0,s2
    80003c7e:	00001097          	auipc	ra,0x1
    80003c82:	078080e7          	jalr	120(ra) # 80004cf6 <log_write>
  brelse(bp);
    80003c86:	854a                	mv	a0,s2
    80003c88:	00000097          	auipc	ra,0x0
    80003c8c:	dea080e7          	jalr	-534(ra) # 80003a72 <brelse>
}
    80003c90:	8526                	mv	a0,s1
    80003c92:	60e6                	ld	ra,88(sp)
    80003c94:	6446                	ld	s0,80(sp)
    80003c96:	64a6                	ld	s1,72(sp)
    80003c98:	6906                	ld	s2,64(sp)
    80003c9a:	79e2                	ld	s3,56(sp)
    80003c9c:	7a42                	ld	s4,48(sp)
    80003c9e:	7aa2                	ld	s5,40(sp)
    80003ca0:	7b02                	ld	s6,32(sp)
    80003ca2:	6be2                	ld	s7,24(sp)
    80003ca4:	6c42                	ld	s8,16(sp)
    80003ca6:	6ca2                	ld	s9,8(sp)
    80003ca8:	6125                	addi	sp,sp,96
    80003caa:	8082                	ret
    brelse(bp);
    80003cac:	854a                	mv	a0,s2
    80003cae:	00000097          	auipc	ra,0x0
    80003cb2:	dc4080e7          	jalr	-572(ra) # 80003a72 <brelse>
  for (b = 0; b < sb.size; b += BPB)
    80003cb6:	015c87bb          	addw	a5,s9,s5
    80003cba:	00078a9b          	sext.w	s5,a5
    80003cbe:	004b2703          	lw	a4,4(s6)
    80003cc2:	06eaf363          	bgeu	s5,a4,80003d28 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    80003cc6:	41fad79b          	sraiw	a5,s5,0x1f
    80003cca:	0137d79b          	srliw	a5,a5,0x13
    80003cce:	015787bb          	addw	a5,a5,s5
    80003cd2:	40d7d79b          	sraiw	a5,a5,0xd
    80003cd6:	01cb2583          	lw	a1,28(s6)
    80003cda:	9dbd                	addw	a1,a1,a5
    80003cdc:	855e                	mv	a0,s7
    80003cde:	00000097          	auipc	ra,0x0
    80003ce2:	c64080e7          	jalr	-924(ra) # 80003942 <bread>
    80003ce6:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    80003ce8:	004b2503          	lw	a0,4(s6)
    80003cec:	000a849b          	sext.w	s1,s5
    80003cf0:	8662                	mv	a2,s8
    80003cf2:	faa4fde3          	bgeu	s1,a0,80003cac <balloc+0xa8>
      m = 1 << (bi % 8);
    80003cf6:	41f6579b          	sraiw	a5,a2,0x1f
    80003cfa:	01d7d69b          	srliw	a3,a5,0x1d
    80003cfe:	00c6873b          	addw	a4,a3,a2
    80003d02:	00777793          	andi	a5,a4,7
    80003d06:	9f95                	subw	a5,a5,a3
    80003d08:	00f997bb          	sllw	a5,s3,a5
      if ((bp->data[bi / 8] & m) == 0)
    80003d0c:	4037571b          	sraiw	a4,a4,0x3
    80003d10:	00e906b3          	add	a3,s2,a4
    80003d14:	0586c683          	lbu	a3,88(a3)
    80003d18:	00d7f5b3          	and	a1,a5,a3
    80003d1c:	d195                	beqz	a1,80003c40 <balloc+0x3c>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    80003d1e:	2605                	addiw	a2,a2,1
    80003d20:	2485                	addiw	s1,s1,1
    80003d22:	fd4618e3          	bne	a2,s4,80003cf2 <balloc+0xee>
    80003d26:	b759                	j	80003cac <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80003d28:	00006517          	auipc	a0,0x6
    80003d2c:	9e850513          	addi	a0,a0,-1560 # 80009710 <syscalls+0x130>
    80003d30:	ffffd097          	auipc	ra,0xffffd
    80003d34:	858080e7          	jalr	-1960(ra) # 80000588 <printf>
  return 0;
    80003d38:	4481                	li	s1,0
    80003d3a:	bf99                	j	80003c90 <balloc+0x8c>

0000000080003d3c <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003d3c:	7179                	addi	sp,sp,-48
    80003d3e:	f406                	sd	ra,40(sp)
    80003d40:	f022                	sd	s0,32(sp)
    80003d42:	ec26                	sd	s1,24(sp)
    80003d44:	e84a                	sd	s2,16(sp)
    80003d46:	e44e                	sd	s3,8(sp)
    80003d48:	e052                	sd	s4,0(sp)
    80003d4a:	1800                	addi	s0,sp,48
    80003d4c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT)
    80003d4e:	47ad                	li	a5,11
    80003d50:	02b7e763          	bltu	a5,a1,80003d7e <bmap+0x42>
  {
    if ((addr = ip->addrs[bn]) == 0)
    80003d54:	02059493          	slli	s1,a1,0x20
    80003d58:	9081                	srli	s1,s1,0x20
    80003d5a:	048a                	slli	s1,s1,0x2
    80003d5c:	94aa                	add	s1,s1,a0
    80003d5e:	0504a903          	lw	s2,80(s1)
    80003d62:	06091e63          	bnez	s2,80003dde <bmap+0xa2>
    {
      addr = balloc(ip->dev);
    80003d66:	4108                	lw	a0,0(a0)
    80003d68:	00000097          	auipc	ra,0x0
    80003d6c:	e9c080e7          	jalr	-356(ra) # 80003c04 <balloc>
    80003d70:	0005091b          	sext.w	s2,a0
      if (addr == 0)
    80003d74:	06090563          	beqz	s2,80003dde <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80003d78:	0524a823          	sw	s2,80(s1)
    80003d7c:	a08d                	j	80003dde <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003d7e:	ff45849b          	addiw	s1,a1,-12
    80003d82:	0004871b          	sext.w	a4,s1

  if (bn < NINDIRECT)
    80003d86:	0ff00793          	li	a5,255
    80003d8a:	08e7e563          	bltu	a5,a4,80003e14 <bmap+0xd8>
  {
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0)
    80003d8e:	08052903          	lw	s2,128(a0)
    80003d92:	00091d63          	bnez	s2,80003dac <bmap+0x70>
    {
      addr = balloc(ip->dev);
    80003d96:	4108                	lw	a0,0(a0)
    80003d98:	00000097          	auipc	ra,0x0
    80003d9c:	e6c080e7          	jalr	-404(ra) # 80003c04 <balloc>
    80003da0:	0005091b          	sext.w	s2,a0
      if (addr == 0)
    80003da4:	02090d63          	beqz	s2,80003dde <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003da8:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80003dac:	85ca                	mv	a1,s2
    80003dae:	0009a503          	lw	a0,0(s3)
    80003db2:	00000097          	auipc	ra,0x0
    80003db6:	b90080e7          	jalr	-1136(ra) # 80003942 <bread>
    80003dba:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    80003dbc:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0)
    80003dc0:	02049593          	slli	a1,s1,0x20
    80003dc4:	9181                	srli	a1,a1,0x20
    80003dc6:	058a                	slli	a1,a1,0x2
    80003dc8:	00b784b3          	add	s1,a5,a1
    80003dcc:	0004a903          	lw	s2,0(s1)
    80003dd0:	02090063          	beqz	s2,80003df0 <bmap+0xb4>
      {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003dd4:	8552                	mv	a0,s4
    80003dd6:	00000097          	auipc	ra,0x0
    80003dda:	c9c080e7          	jalr	-868(ra) # 80003a72 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003dde:	854a                	mv	a0,s2
    80003de0:	70a2                	ld	ra,40(sp)
    80003de2:	7402                	ld	s0,32(sp)
    80003de4:	64e2                	ld	s1,24(sp)
    80003de6:	6942                	ld	s2,16(sp)
    80003de8:	69a2                	ld	s3,8(sp)
    80003dea:	6a02                	ld	s4,0(sp)
    80003dec:	6145                	addi	sp,sp,48
    80003dee:	8082                	ret
      addr = balloc(ip->dev);
    80003df0:	0009a503          	lw	a0,0(s3)
    80003df4:	00000097          	auipc	ra,0x0
    80003df8:	e10080e7          	jalr	-496(ra) # 80003c04 <balloc>
    80003dfc:	0005091b          	sext.w	s2,a0
      if (addr)
    80003e00:	fc090ae3          	beqz	s2,80003dd4 <bmap+0x98>
        a[bn] = addr;
    80003e04:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003e08:	8552                	mv	a0,s4
    80003e0a:	00001097          	auipc	ra,0x1
    80003e0e:	eec080e7          	jalr	-276(ra) # 80004cf6 <log_write>
    80003e12:	b7c9                	j	80003dd4 <bmap+0x98>
  panic("bmap: out of range");
    80003e14:	00006517          	auipc	a0,0x6
    80003e18:	91450513          	addi	a0,a0,-1772 # 80009728 <syscalls+0x148>
    80003e1c:	ffffc097          	auipc	ra,0xffffc
    80003e20:	722080e7          	jalr	1826(ra) # 8000053e <panic>

0000000080003e24 <iget>:
{
    80003e24:	7179                	addi	sp,sp,-48
    80003e26:	f406                	sd	ra,40(sp)
    80003e28:	f022                	sd	s0,32(sp)
    80003e2a:	ec26                	sd	s1,24(sp)
    80003e2c:	e84a                	sd	s2,16(sp)
    80003e2e:	e44e                	sd	s3,8(sp)
    80003e30:	e052                	sd	s4,0(sp)
    80003e32:	1800                	addi	s0,sp,48
    80003e34:	89aa                	mv	s3,a0
    80003e36:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003e38:	0023e517          	auipc	a0,0x23e
    80003e3c:	57850513          	addi	a0,a0,1400 # 802423b0 <itable>
    80003e40:	ffffd097          	auipc	ra,0xffffd
    80003e44:	f52080e7          	jalr	-174(ra) # 80000d92 <acquire>
  empty = 0;
    80003e48:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    80003e4a:	0023e497          	auipc	s1,0x23e
    80003e4e:	57e48493          	addi	s1,s1,1406 # 802423c8 <itable+0x18>
    80003e52:	00240697          	auipc	a3,0x240
    80003e56:	00668693          	addi	a3,a3,6 # 80243e58 <log>
    80003e5a:	a039                	j	80003e68 <iget+0x44>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80003e5c:	02090b63          	beqz	s2,80003e92 <iget+0x6e>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    80003e60:	08848493          	addi	s1,s1,136
    80003e64:	02d48a63          	beq	s1,a3,80003e98 <iget+0x74>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum)
    80003e68:	449c                	lw	a5,8(s1)
    80003e6a:	fef059e3          	blez	a5,80003e5c <iget+0x38>
    80003e6e:	4098                	lw	a4,0(s1)
    80003e70:	ff3716e3          	bne	a4,s3,80003e5c <iget+0x38>
    80003e74:	40d8                	lw	a4,4(s1)
    80003e76:	ff4713e3          	bne	a4,s4,80003e5c <iget+0x38>
      ip->ref++;
    80003e7a:	2785                	addiw	a5,a5,1
    80003e7c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003e7e:	0023e517          	auipc	a0,0x23e
    80003e82:	53250513          	addi	a0,a0,1330 # 802423b0 <itable>
    80003e86:	ffffd097          	auipc	ra,0xffffd
    80003e8a:	fc0080e7          	jalr	-64(ra) # 80000e46 <release>
      return ip;
    80003e8e:	8926                	mv	s2,s1
    80003e90:	a03d                	j	80003ebe <iget+0x9a>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80003e92:	f7f9                	bnez	a5,80003e60 <iget+0x3c>
    80003e94:	8926                	mv	s2,s1
    80003e96:	b7e9                	j	80003e60 <iget+0x3c>
  if (empty == 0)
    80003e98:	02090c63          	beqz	s2,80003ed0 <iget+0xac>
  ip->dev = dev;
    80003e9c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003ea0:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003ea4:	4785                	li	a5,1
    80003ea6:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003eaa:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003eae:	0023e517          	auipc	a0,0x23e
    80003eb2:	50250513          	addi	a0,a0,1282 # 802423b0 <itable>
    80003eb6:	ffffd097          	auipc	ra,0xffffd
    80003eba:	f90080e7          	jalr	-112(ra) # 80000e46 <release>
}
    80003ebe:	854a                	mv	a0,s2
    80003ec0:	70a2                	ld	ra,40(sp)
    80003ec2:	7402                	ld	s0,32(sp)
    80003ec4:	64e2                	ld	s1,24(sp)
    80003ec6:	6942                	ld	s2,16(sp)
    80003ec8:	69a2                	ld	s3,8(sp)
    80003eca:	6a02                	ld	s4,0(sp)
    80003ecc:	6145                	addi	sp,sp,48
    80003ece:	8082                	ret
    panic("iget: no inodes");
    80003ed0:	00006517          	auipc	a0,0x6
    80003ed4:	87050513          	addi	a0,a0,-1936 # 80009740 <syscalls+0x160>
    80003ed8:	ffffc097          	auipc	ra,0xffffc
    80003edc:	666080e7          	jalr	1638(ra) # 8000053e <panic>

0000000080003ee0 <fsinit>:
{
    80003ee0:	7179                	addi	sp,sp,-48
    80003ee2:	f406                	sd	ra,40(sp)
    80003ee4:	f022                	sd	s0,32(sp)
    80003ee6:	ec26                	sd	s1,24(sp)
    80003ee8:	e84a                	sd	s2,16(sp)
    80003eea:	e44e                	sd	s3,8(sp)
    80003eec:	1800                	addi	s0,sp,48
    80003eee:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003ef0:	4585                	li	a1,1
    80003ef2:	00000097          	auipc	ra,0x0
    80003ef6:	a50080e7          	jalr	-1456(ra) # 80003942 <bread>
    80003efa:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003efc:	0023e997          	auipc	s3,0x23e
    80003f00:	49498993          	addi	s3,s3,1172 # 80242390 <sb>
    80003f04:	02000613          	li	a2,32
    80003f08:	05850593          	addi	a1,a0,88
    80003f0c:	854e                	mv	a0,s3
    80003f0e:	ffffd097          	auipc	ra,0xffffd
    80003f12:	fdc080e7          	jalr	-36(ra) # 80000eea <memmove>
  brelse(bp);
    80003f16:	8526                	mv	a0,s1
    80003f18:	00000097          	auipc	ra,0x0
    80003f1c:	b5a080e7          	jalr	-1190(ra) # 80003a72 <brelse>
  if (sb.magic != FSMAGIC)
    80003f20:	0009a703          	lw	a4,0(s3)
    80003f24:	102037b7          	lui	a5,0x10203
    80003f28:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003f2c:	02f71263          	bne	a4,a5,80003f50 <fsinit+0x70>
  initlog(dev, &sb);
    80003f30:	0023e597          	auipc	a1,0x23e
    80003f34:	46058593          	addi	a1,a1,1120 # 80242390 <sb>
    80003f38:	854a                	mv	a0,s2
    80003f3a:	00001097          	auipc	ra,0x1
    80003f3e:	b40080e7          	jalr	-1216(ra) # 80004a7a <initlog>
}
    80003f42:	70a2                	ld	ra,40(sp)
    80003f44:	7402                	ld	s0,32(sp)
    80003f46:	64e2                	ld	s1,24(sp)
    80003f48:	6942                	ld	s2,16(sp)
    80003f4a:	69a2                	ld	s3,8(sp)
    80003f4c:	6145                	addi	sp,sp,48
    80003f4e:	8082                	ret
    panic("invalid file system");
    80003f50:	00006517          	auipc	a0,0x6
    80003f54:	80050513          	addi	a0,a0,-2048 # 80009750 <syscalls+0x170>
    80003f58:	ffffc097          	auipc	ra,0xffffc
    80003f5c:	5e6080e7          	jalr	1510(ra) # 8000053e <panic>

0000000080003f60 <iinit>:
{
    80003f60:	7179                	addi	sp,sp,-48
    80003f62:	f406                	sd	ra,40(sp)
    80003f64:	f022                	sd	s0,32(sp)
    80003f66:	ec26                	sd	s1,24(sp)
    80003f68:	e84a                	sd	s2,16(sp)
    80003f6a:	e44e                	sd	s3,8(sp)
    80003f6c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003f6e:	00005597          	auipc	a1,0x5
    80003f72:	7fa58593          	addi	a1,a1,2042 # 80009768 <syscalls+0x188>
    80003f76:	0023e517          	auipc	a0,0x23e
    80003f7a:	43a50513          	addi	a0,a0,1082 # 802423b0 <itable>
    80003f7e:	ffffd097          	auipc	ra,0xffffd
    80003f82:	d84080e7          	jalr	-636(ra) # 80000d02 <initlock>
  for (i = 0; i < NINODE; i++)
    80003f86:	0023e497          	auipc	s1,0x23e
    80003f8a:	45248493          	addi	s1,s1,1106 # 802423d8 <itable+0x28>
    80003f8e:	00240997          	auipc	s3,0x240
    80003f92:	eda98993          	addi	s3,s3,-294 # 80243e68 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003f96:	00005917          	auipc	s2,0x5
    80003f9a:	7da90913          	addi	s2,s2,2010 # 80009770 <syscalls+0x190>
    80003f9e:	85ca                	mv	a1,s2
    80003fa0:	8526                	mv	a0,s1
    80003fa2:	00001097          	auipc	ra,0x1
    80003fa6:	e3a080e7          	jalr	-454(ra) # 80004ddc <initsleeplock>
  for (i = 0; i < NINODE; i++)
    80003faa:	08848493          	addi	s1,s1,136
    80003fae:	ff3498e3          	bne	s1,s3,80003f9e <iinit+0x3e>
}
    80003fb2:	70a2                	ld	ra,40(sp)
    80003fb4:	7402                	ld	s0,32(sp)
    80003fb6:	64e2                	ld	s1,24(sp)
    80003fb8:	6942                	ld	s2,16(sp)
    80003fba:	69a2                	ld	s3,8(sp)
    80003fbc:	6145                	addi	sp,sp,48
    80003fbe:	8082                	ret

0000000080003fc0 <ialloc>:
{
    80003fc0:	715d                	addi	sp,sp,-80
    80003fc2:	e486                	sd	ra,72(sp)
    80003fc4:	e0a2                	sd	s0,64(sp)
    80003fc6:	fc26                	sd	s1,56(sp)
    80003fc8:	f84a                	sd	s2,48(sp)
    80003fca:	f44e                	sd	s3,40(sp)
    80003fcc:	f052                	sd	s4,32(sp)
    80003fce:	ec56                	sd	s5,24(sp)
    80003fd0:	e85a                	sd	s6,16(sp)
    80003fd2:	e45e                	sd	s7,8(sp)
    80003fd4:	0880                	addi	s0,sp,80
  for (inum = 1; inum < sb.ninodes; inum++)
    80003fd6:	0023e717          	auipc	a4,0x23e
    80003fda:	3c672703          	lw	a4,966(a4) # 8024239c <sb+0xc>
    80003fde:	4785                	li	a5,1
    80003fe0:	04e7fa63          	bgeu	a5,a4,80004034 <ialloc+0x74>
    80003fe4:	8aaa                	mv	s5,a0
    80003fe6:	8bae                	mv	s7,a1
    80003fe8:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003fea:	0023ea17          	auipc	s4,0x23e
    80003fee:	3a6a0a13          	addi	s4,s4,934 # 80242390 <sb>
    80003ff2:	00048b1b          	sext.w	s6,s1
    80003ff6:	0044d793          	srli	a5,s1,0x4
    80003ffa:	018a2583          	lw	a1,24(s4)
    80003ffe:	9dbd                	addw	a1,a1,a5
    80004000:	8556                	mv	a0,s5
    80004002:	00000097          	auipc	ra,0x0
    80004006:	940080e7          	jalr	-1728(ra) # 80003942 <bread>
    8000400a:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    8000400c:	05850993          	addi	s3,a0,88
    80004010:	00f4f793          	andi	a5,s1,15
    80004014:	079a                	slli	a5,a5,0x6
    80004016:	99be                	add	s3,s3,a5
    if (dip->type == 0)
    80004018:	00099783          	lh	a5,0(s3)
    8000401c:	c3a1                	beqz	a5,8000405c <ialloc+0x9c>
    brelse(bp);
    8000401e:	00000097          	auipc	ra,0x0
    80004022:	a54080e7          	jalr	-1452(ra) # 80003a72 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++)
    80004026:	0485                	addi	s1,s1,1
    80004028:	00ca2703          	lw	a4,12(s4)
    8000402c:	0004879b          	sext.w	a5,s1
    80004030:	fce7e1e3          	bltu	a5,a4,80003ff2 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80004034:	00005517          	auipc	a0,0x5
    80004038:	74450513          	addi	a0,a0,1860 # 80009778 <syscalls+0x198>
    8000403c:	ffffc097          	auipc	ra,0xffffc
    80004040:	54c080e7          	jalr	1356(ra) # 80000588 <printf>
  return 0;
    80004044:	4501                	li	a0,0
}
    80004046:	60a6                	ld	ra,72(sp)
    80004048:	6406                	ld	s0,64(sp)
    8000404a:	74e2                	ld	s1,56(sp)
    8000404c:	7942                	ld	s2,48(sp)
    8000404e:	79a2                	ld	s3,40(sp)
    80004050:	7a02                	ld	s4,32(sp)
    80004052:	6ae2                	ld	s5,24(sp)
    80004054:	6b42                	ld	s6,16(sp)
    80004056:	6ba2                	ld	s7,8(sp)
    80004058:	6161                	addi	sp,sp,80
    8000405a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000405c:	04000613          	li	a2,64
    80004060:	4581                	li	a1,0
    80004062:	854e                	mv	a0,s3
    80004064:	ffffd097          	auipc	ra,0xffffd
    80004068:	e2a080e7          	jalr	-470(ra) # 80000e8e <memset>
      dip->type = type;
    8000406c:	01799023          	sh	s7,0(s3)
      log_write(bp); // mark it allocated on the disk
    80004070:	854a                	mv	a0,s2
    80004072:	00001097          	auipc	ra,0x1
    80004076:	c84080e7          	jalr	-892(ra) # 80004cf6 <log_write>
      brelse(bp);
    8000407a:	854a                	mv	a0,s2
    8000407c:	00000097          	auipc	ra,0x0
    80004080:	9f6080e7          	jalr	-1546(ra) # 80003a72 <brelse>
      return iget(dev, inum);
    80004084:	85da                	mv	a1,s6
    80004086:	8556                	mv	a0,s5
    80004088:	00000097          	auipc	ra,0x0
    8000408c:	d9c080e7          	jalr	-612(ra) # 80003e24 <iget>
    80004090:	bf5d                	j	80004046 <ialloc+0x86>

0000000080004092 <iupdate>:
{
    80004092:	1101                	addi	sp,sp,-32
    80004094:	ec06                	sd	ra,24(sp)
    80004096:	e822                	sd	s0,16(sp)
    80004098:	e426                	sd	s1,8(sp)
    8000409a:	e04a                	sd	s2,0(sp)
    8000409c:	1000                	addi	s0,sp,32
    8000409e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800040a0:	415c                	lw	a5,4(a0)
    800040a2:	0047d79b          	srliw	a5,a5,0x4
    800040a6:	0023e597          	auipc	a1,0x23e
    800040aa:	3025a583          	lw	a1,770(a1) # 802423a8 <sb+0x18>
    800040ae:	9dbd                	addw	a1,a1,a5
    800040b0:	4108                	lw	a0,0(a0)
    800040b2:	00000097          	auipc	ra,0x0
    800040b6:	890080e7          	jalr	-1904(ra) # 80003942 <bread>
    800040ba:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    800040bc:	05850793          	addi	a5,a0,88
    800040c0:	40c8                	lw	a0,4(s1)
    800040c2:	893d                	andi	a0,a0,15
    800040c4:	051a                	slli	a0,a0,0x6
    800040c6:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800040c8:	04449703          	lh	a4,68(s1)
    800040cc:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800040d0:	04649703          	lh	a4,70(s1)
    800040d4:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    800040d8:	04849703          	lh	a4,72(s1)
    800040dc:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    800040e0:	04a49703          	lh	a4,74(s1)
    800040e4:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    800040e8:	44f8                	lw	a4,76(s1)
    800040ea:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800040ec:	03400613          	li	a2,52
    800040f0:	05048593          	addi	a1,s1,80
    800040f4:	0531                	addi	a0,a0,12
    800040f6:	ffffd097          	auipc	ra,0xffffd
    800040fa:	df4080e7          	jalr	-524(ra) # 80000eea <memmove>
  log_write(bp);
    800040fe:	854a                	mv	a0,s2
    80004100:	00001097          	auipc	ra,0x1
    80004104:	bf6080e7          	jalr	-1034(ra) # 80004cf6 <log_write>
  brelse(bp);
    80004108:	854a                	mv	a0,s2
    8000410a:	00000097          	auipc	ra,0x0
    8000410e:	968080e7          	jalr	-1688(ra) # 80003a72 <brelse>
}
    80004112:	60e2                	ld	ra,24(sp)
    80004114:	6442                	ld	s0,16(sp)
    80004116:	64a2                	ld	s1,8(sp)
    80004118:	6902                	ld	s2,0(sp)
    8000411a:	6105                	addi	sp,sp,32
    8000411c:	8082                	ret

000000008000411e <idup>:
{
    8000411e:	1101                	addi	sp,sp,-32
    80004120:	ec06                	sd	ra,24(sp)
    80004122:	e822                	sd	s0,16(sp)
    80004124:	e426                	sd	s1,8(sp)
    80004126:	1000                	addi	s0,sp,32
    80004128:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000412a:	0023e517          	auipc	a0,0x23e
    8000412e:	28650513          	addi	a0,a0,646 # 802423b0 <itable>
    80004132:	ffffd097          	auipc	ra,0xffffd
    80004136:	c60080e7          	jalr	-928(ra) # 80000d92 <acquire>
  ip->ref++;
    8000413a:	449c                	lw	a5,8(s1)
    8000413c:	2785                	addiw	a5,a5,1
    8000413e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80004140:	0023e517          	auipc	a0,0x23e
    80004144:	27050513          	addi	a0,a0,624 # 802423b0 <itable>
    80004148:	ffffd097          	auipc	ra,0xffffd
    8000414c:	cfe080e7          	jalr	-770(ra) # 80000e46 <release>
}
    80004150:	8526                	mv	a0,s1
    80004152:	60e2                	ld	ra,24(sp)
    80004154:	6442                	ld	s0,16(sp)
    80004156:	64a2                	ld	s1,8(sp)
    80004158:	6105                	addi	sp,sp,32
    8000415a:	8082                	ret

000000008000415c <ilock>:
{
    8000415c:	1101                	addi	sp,sp,-32
    8000415e:	ec06                	sd	ra,24(sp)
    80004160:	e822                	sd	s0,16(sp)
    80004162:	e426                	sd	s1,8(sp)
    80004164:	e04a                	sd	s2,0(sp)
    80004166:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1)
    80004168:	c115                	beqz	a0,8000418c <ilock+0x30>
    8000416a:	84aa                	mv	s1,a0
    8000416c:	451c                	lw	a5,8(a0)
    8000416e:	00f05f63          	blez	a5,8000418c <ilock+0x30>
  acquiresleep(&ip->lock);
    80004172:	0541                	addi	a0,a0,16
    80004174:	00001097          	auipc	ra,0x1
    80004178:	ca2080e7          	jalr	-862(ra) # 80004e16 <acquiresleep>
  if (ip->valid == 0)
    8000417c:	40bc                	lw	a5,64(s1)
    8000417e:	cf99                	beqz	a5,8000419c <ilock+0x40>
}
    80004180:	60e2                	ld	ra,24(sp)
    80004182:	6442                	ld	s0,16(sp)
    80004184:	64a2                	ld	s1,8(sp)
    80004186:	6902                	ld	s2,0(sp)
    80004188:	6105                	addi	sp,sp,32
    8000418a:	8082                	ret
    panic("ilock");
    8000418c:	00005517          	auipc	a0,0x5
    80004190:	60450513          	addi	a0,a0,1540 # 80009790 <syscalls+0x1b0>
    80004194:	ffffc097          	auipc	ra,0xffffc
    80004198:	3aa080e7          	jalr	938(ra) # 8000053e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000419c:	40dc                	lw	a5,4(s1)
    8000419e:	0047d79b          	srliw	a5,a5,0x4
    800041a2:	0023e597          	auipc	a1,0x23e
    800041a6:	2065a583          	lw	a1,518(a1) # 802423a8 <sb+0x18>
    800041aa:	9dbd                	addw	a1,a1,a5
    800041ac:	4088                	lw	a0,0(s1)
    800041ae:	fffff097          	auipc	ra,0xfffff
    800041b2:	794080e7          	jalr	1940(ra) # 80003942 <bread>
    800041b6:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    800041b8:	05850593          	addi	a1,a0,88
    800041bc:	40dc                	lw	a5,4(s1)
    800041be:	8bbd                	andi	a5,a5,15
    800041c0:	079a                	slli	a5,a5,0x6
    800041c2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800041c4:	00059783          	lh	a5,0(a1)
    800041c8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800041cc:	00259783          	lh	a5,2(a1)
    800041d0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800041d4:	00459783          	lh	a5,4(a1)
    800041d8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800041dc:	00659783          	lh	a5,6(a1)
    800041e0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800041e4:	459c                	lw	a5,8(a1)
    800041e6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800041e8:	03400613          	li	a2,52
    800041ec:	05b1                	addi	a1,a1,12
    800041ee:	05048513          	addi	a0,s1,80
    800041f2:	ffffd097          	auipc	ra,0xffffd
    800041f6:	cf8080e7          	jalr	-776(ra) # 80000eea <memmove>
    brelse(bp);
    800041fa:	854a                	mv	a0,s2
    800041fc:	00000097          	auipc	ra,0x0
    80004200:	876080e7          	jalr	-1930(ra) # 80003a72 <brelse>
    ip->valid = 1;
    80004204:	4785                	li	a5,1
    80004206:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0)
    80004208:	04449783          	lh	a5,68(s1)
    8000420c:	fbb5                	bnez	a5,80004180 <ilock+0x24>
      panic("ilock: no type");
    8000420e:	00005517          	auipc	a0,0x5
    80004212:	58a50513          	addi	a0,a0,1418 # 80009798 <syscalls+0x1b8>
    80004216:	ffffc097          	auipc	ra,0xffffc
    8000421a:	328080e7          	jalr	808(ra) # 8000053e <panic>

000000008000421e <iunlock>:
{
    8000421e:	1101                	addi	sp,sp,-32
    80004220:	ec06                	sd	ra,24(sp)
    80004222:	e822                	sd	s0,16(sp)
    80004224:	e426                	sd	s1,8(sp)
    80004226:	e04a                	sd	s2,0(sp)
    80004228:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000422a:	c905                	beqz	a0,8000425a <iunlock+0x3c>
    8000422c:	84aa                	mv	s1,a0
    8000422e:	01050913          	addi	s2,a0,16
    80004232:	854a                	mv	a0,s2
    80004234:	00001097          	auipc	ra,0x1
    80004238:	c7c080e7          	jalr	-900(ra) # 80004eb0 <holdingsleep>
    8000423c:	cd19                	beqz	a0,8000425a <iunlock+0x3c>
    8000423e:	449c                	lw	a5,8(s1)
    80004240:	00f05d63          	blez	a5,8000425a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80004244:	854a                	mv	a0,s2
    80004246:	00001097          	auipc	ra,0x1
    8000424a:	c26080e7          	jalr	-986(ra) # 80004e6c <releasesleep>
}
    8000424e:	60e2                	ld	ra,24(sp)
    80004250:	6442                	ld	s0,16(sp)
    80004252:	64a2                	ld	s1,8(sp)
    80004254:	6902                	ld	s2,0(sp)
    80004256:	6105                	addi	sp,sp,32
    80004258:	8082                	ret
    panic("iunlock");
    8000425a:	00005517          	auipc	a0,0x5
    8000425e:	54e50513          	addi	a0,a0,1358 # 800097a8 <syscalls+0x1c8>
    80004262:	ffffc097          	auipc	ra,0xffffc
    80004266:	2dc080e7          	jalr	732(ra) # 8000053e <panic>

000000008000426a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip)
{
    8000426a:	7179                	addi	sp,sp,-48
    8000426c:	f406                	sd	ra,40(sp)
    8000426e:	f022                	sd	s0,32(sp)
    80004270:	ec26                	sd	s1,24(sp)
    80004272:	e84a                	sd	s2,16(sp)
    80004274:	e44e                	sd	s3,8(sp)
    80004276:	e052                	sd	s4,0(sp)
    80004278:	1800                	addi	s0,sp,48
    8000427a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++)
    8000427c:	05050493          	addi	s1,a0,80
    80004280:	08050913          	addi	s2,a0,128
    80004284:	a021                	j	8000428c <itrunc+0x22>
    80004286:	0491                	addi	s1,s1,4
    80004288:	01248d63          	beq	s1,s2,800042a2 <itrunc+0x38>
  {
    if (ip->addrs[i])
    8000428c:	408c                	lw	a1,0(s1)
    8000428e:	dde5                	beqz	a1,80004286 <itrunc+0x1c>
    {
      bfree(ip->dev, ip->addrs[i]);
    80004290:	0009a503          	lw	a0,0(s3)
    80004294:	00000097          	auipc	ra,0x0
    80004298:	8f4080e7          	jalr	-1804(ra) # 80003b88 <bfree>
      ip->addrs[i] = 0;
    8000429c:	0004a023          	sw	zero,0(s1)
    800042a0:	b7dd                	j	80004286 <itrunc+0x1c>
    }
  }

  if (ip->addrs[NDIRECT])
    800042a2:	0809a583          	lw	a1,128(s3)
    800042a6:	e185                	bnez	a1,800042c6 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800042a8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800042ac:	854e                	mv	a0,s3
    800042ae:	00000097          	auipc	ra,0x0
    800042b2:	de4080e7          	jalr	-540(ra) # 80004092 <iupdate>
}
    800042b6:	70a2                	ld	ra,40(sp)
    800042b8:	7402                	ld	s0,32(sp)
    800042ba:	64e2                	ld	s1,24(sp)
    800042bc:	6942                	ld	s2,16(sp)
    800042be:	69a2                	ld	s3,8(sp)
    800042c0:	6a02                	ld	s4,0(sp)
    800042c2:	6145                	addi	sp,sp,48
    800042c4:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800042c6:	0009a503          	lw	a0,0(s3)
    800042ca:	fffff097          	auipc	ra,0xfffff
    800042ce:	678080e7          	jalr	1656(ra) # 80003942 <bread>
    800042d2:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++)
    800042d4:	05850493          	addi	s1,a0,88
    800042d8:	45850913          	addi	s2,a0,1112
    800042dc:	a021                	j	800042e4 <itrunc+0x7a>
    800042de:	0491                	addi	s1,s1,4
    800042e0:	01248b63          	beq	s1,s2,800042f6 <itrunc+0x8c>
      if (a[j])
    800042e4:	408c                	lw	a1,0(s1)
    800042e6:	dde5                	beqz	a1,800042de <itrunc+0x74>
        bfree(ip->dev, a[j]);
    800042e8:	0009a503          	lw	a0,0(s3)
    800042ec:	00000097          	auipc	ra,0x0
    800042f0:	89c080e7          	jalr	-1892(ra) # 80003b88 <bfree>
    800042f4:	b7ed                	j	800042de <itrunc+0x74>
    brelse(bp);
    800042f6:	8552                	mv	a0,s4
    800042f8:	fffff097          	auipc	ra,0xfffff
    800042fc:	77a080e7          	jalr	1914(ra) # 80003a72 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80004300:	0809a583          	lw	a1,128(s3)
    80004304:	0009a503          	lw	a0,0(s3)
    80004308:	00000097          	auipc	ra,0x0
    8000430c:	880080e7          	jalr	-1920(ra) # 80003b88 <bfree>
    ip->addrs[NDIRECT] = 0;
    80004310:	0809a023          	sw	zero,128(s3)
    80004314:	bf51                	j	800042a8 <itrunc+0x3e>

0000000080004316 <iput>:
{
    80004316:	1101                	addi	sp,sp,-32
    80004318:	ec06                	sd	ra,24(sp)
    8000431a:	e822                	sd	s0,16(sp)
    8000431c:	e426                	sd	s1,8(sp)
    8000431e:	e04a                	sd	s2,0(sp)
    80004320:	1000                	addi	s0,sp,32
    80004322:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80004324:	0023e517          	auipc	a0,0x23e
    80004328:	08c50513          	addi	a0,a0,140 # 802423b0 <itable>
    8000432c:	ffffd097          	auipc	ra,0xffffd
    80004330:	a66080e7          	jalr	-1434(ra) # 80000d92 <acquire>
  if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    80004334:	4498                	lw	a4,8(s1)
    80004336:	4785                	li	a5,1
    80004338:	02f70363          	beq	a4,a5,8000435e <iput+0x48>
  ip->ref--;
    8000433c:	449c                	lw	a5,8(s1)
    8000433e:	37fd                	addiw	a5,a5,-1
    80004340:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80004342:	0023e517          	auipc	a0,0x23e
    80004346:	06e50513          	addi	a0,a0,110 # 802423b0 <itable>
    8000434a:	ffffd097          	auipc	ra,0xffffd
    8000434e:	afc080e7          	jalr	-1284(ra) # 80000e46 <release>
}
    80004352:	60e2                	ld	ra,24(sp)
    80004354:	6442                	ld	s0,16(sp)
    80004356:	64a2                	ld	s1,8(sp)
    80004358:	6902                	ld	s2,0(sp)
    8000435a:	6105                	addi	sp,sp,32
    8000435c:	8082                	ret
  if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    8000435e:	40bc                	lw	a5,64(s1)
    80004360:	dff1                	beqz	a5,8000433c <iput+0x26>
    80004362:	04a49783          	lh	a5,74(s1)
    80004366:	fbf9                	bnez	a5,8000433c <iput+0x26>
    acquiresleep(&ip->lock);
    80004368:	01048913          	addi	s2,s1,16
    8000436c:	854a                	mv	a0,s2
    8000436e:	00001097          	auipc	ra,0x1
    80004372:	aa8080e7          	jalr	-1368(ra) # 80004e16 <acquiresleep>
    release(&itable.lock);
    80004376:	0023e517          	auipc	a0,0x23e
    8000437a:	03a50513          	addi	a0,a0,58 # 802423b0 <itable>
    8000437e:	ffffd097          	auipc	ra,0xffffd
    80004382:	ac8080e7          	jalr	-1336(ra) # 80000e46 <release>
    itrunc(ip);
    80004386:	8526                	mv	a0,s1
    80004388:	00000097          	auipc	ra,0x0
    8000438c:	ee2080e7          	jalr	-286(ra) # 8000426a <itrunc>
    ip->type = 0;
    80004390:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80004394:	8526                	mv	a0,s1
    80004396:	00000097          	auipc	ra,0x0
    8000439a:	cfc080e7          	jalr	-772(ra) # 80004092 <iupdate>
    ip->valid = 0;
    8000439e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800043a2:	854a                	mv	a0,s2
    800043a4:	00001097          	auipc	ra,0x1
    800043a8:	ac8080e7          	jalr	-1336(ra) # 80004e6c <releasesleep>
    acquire(&itable.lock);
    800043ac:	0023e517          	auipc	a0,0x23e
    800043b0:	00450513          	addi	a0,a0,4 # 802423b0 <itable>
    800043b4:	ffffd097          	auipc	ra,0xffffd
    800043b8:	9de080e7          	jalr	-1570(ra) # 80000d92 <acquire>
    800043bc:	b741                	j	8000433c <iput+0x26>

00000000800043be <iunlockput>:
{
    800043be:	1101                	addi	sp,sp,-32
    800043c0:	ec06                	sd	ra,24(sp)
    800043c2:	e822                	sd	s0,16(sp)
    800043c4:	e426                	sd	s1,8(sp)
    800043c6:	1000                	addi	s0,sp,32
    800043c8:	84aa                	mv	s1,a0
  iunlock(ip);
    800043ca:	00000097          	auipc	ra,0x0
    800043ce:	e54080e7          	jalr	-428(ra) # 8000421e <iunlock>
  iput(ip);
    800043d2:	8526                	mv	a0,s1
    800043d4:	00000097          	auipc	ra,0x0
    800043d8:	f42080e7          	jalr	-190(ra) # 80004316 <iput>
}
    800043dc:	60e2                	ld	ra,24(sp)
    800043de:	6442                	ld	s0,16(sp)
    800043e0:	64a2                	ld	s1,8(sp)
    800043e2:	6105                	addi	sp,sp,32
    800043e4:	8082                	ret

00000000800043e6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st)
{
    800043e6:	1141                	addi	sp,sp,-16
    800043e8:	e422                	sd	s0,8(sp)
    800043ea:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800043ec:	411c                	lw	a5,0(a0)
    800043ee:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800043f0:	415c                	lw	a5,4(a0)
    800043f2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800043f4:	04451783          	lh	a5,68(a0)
    800043f8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800043fc:	04a51783          	lh	a5,74(a0)
    80004400:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80004404:	04c56783          	lwu	a5,76(a0)
    80004408:	e99c                	sd	a5,16(a1)
}
    8000440a:	6422                	ld	s0,8(sp)
    8000440c:	0141                	addi	sp,sp,16
    8000440e:	8082                	ret

0000000080004410 <readi>:
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    80004410:	457c                	lw	a5,76(a0)
    80004412:	0ed7e963          	bltu	a5,a3,80004504 <readi+0xf4>
{
    80004416:	7159                	addi	sp,sp,-112
    80004418:	f486                	sd	ra,104(sp)
    8000441a:	f0a2                	sd	s0,96(sp)
    8000441c:	eca6                	sd	s1,88(sp)
    8000441e:	e8ca                	sd	s2,80(sp)
    80004420:	e4ce                	sd	s3,72(sp)
    80004422:	e0d2                	sd	s4,64(sp)
    80004424:	fc56                	sd	s5,56(sp)
    80004426:	f85a                	sd	s6,48(sp)
    80004428:	f45e                	sd	s7,40(sp)
    8000442a:	f062                	sd	s8,32(sp)
    8000442c:	ec66                	sd	s9,24(sp)
    8000442e:	e86a                	sd	s10,16(sp)
    80004430:	e46e                	sd	s11,8(sp)
    80004432:	1880                	addi	s0,sp,112
    80004434:	8b2a                	mv	s6,a0
    80004436:	8bae                	mv	s7,a1
    80004438:	8a32                	mv	s4,a2
    8000443a:	84b6                	mv	s1,a3
    8000443c:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off)
    8000443e:	9f35                	addw	a4,a4,a3
    return 0;
    80004440:	4501                	li	a0,0
  if (off > ip->size || off + n < off)
    80004442:	0ad76063          	bltu	a4,a3,800044e2 <readi+0xd2>
  if (off + n > ip->size)
    80004446:	00e7f463          	bgeu	a5,a4,8000444e <readi+0x3e>
    n = ip->size - off;
    8000444a:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m)
    8000444e:	0a0a8963          	beqz	s5,80004500 <readi+0xf0>
    80004452:	4981                	li	s3,0
  {
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80004454:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1)
    80004458:	5c7d                	li	s8,-1
    8000445a:	a82d                	j	80004494 <readi+0x84>
    8000445c:	020d1d93          	slli	s11,s10,0x20
    80004460:	020ddd93          	srli	s11,s11,0x20
    80004464:	05890793          	addi	a5,s2,88
    80004468:	86ee                	mv	a3,s11
    8000446a:	963e                	add	a2,a2,a5
    8000446c:	85d2                	mv	a1,s4
    8000446e:	855e                	mv	a0,s7
    80004470:	ffffe097          	auipc	ra,0xffffe
    80004474:	682080e7          	jalr	1666(ra) # 80002af2 <either_copyout>
    80004478:	05850d63          	beq	a0,s8,800044d2 <readi+0xc2>
    {
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000447c:	854a                	mv	a0,s2
    8000447e:	fffff097          	auipc	ra,0xfffff
    80004482:	5f4080e7          	jalr	1524(ra) # 80003a72 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80004486:	013d09bb          	addw	s3,s10,s3
    8000448a:	009d04bb          	addw	s1,s10,s1
    8000448e:	9a6e                	add	s4,s4,s11
    80004490:	0559f763          	bgeu	s3,s5,800044de <readi+0xce>
    uint addr = bmap(ip, off / BSIZE);
    80004494:	00a4d59b          	srliw	a1,s1,0xa
    80004498:	855a                	mv	a0,s6
    8000449a:	00000097          	auipc	ra,0x0
    8000449e:	8a2080e7          	jalr	-1886(ra) # 80003d3c <bmap>
    800044a2:	0005059b          	sext.w	a1,a0
    if (addr == 0)
    800044a6:	cd85                	beqz	a1,800044de <readi+0xce>
    bp = bread(ip->dev, addr);
    800044a8:	000b2503          	lw	a0,0(s6)
    800044ac:	fffff097          	auipc	ra,0xfffff
    800044b0:	496080e7          	jalr	1174(ra) # 80003942 <bread>
    800044b4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    800044b6:	3ff4f613          	andi	a2,s1,1023
    800044ba:	40cc87bb          	subw	a5,s9,a2
    800044be:	413a873b          	subw	a4,s5,s3
    800044c2:	8d3e                	mv	s10,a5
    800044c4:	2781                	sext.w	a5,a5
    800044c6:	0007069b          	sext.w	a3,a4
    800044ca:	f8f6f9e3          	bgeu	a3,a5,8000445c <readi+0x4c>
    800044ce:	8d3a                	mv	s10,a4
    800044d0:	b771                	j	8000445c <readi+0x4c>
      brelse(bp);
    800044d2:	854a                	mv	a0,s2
    800044d4:	fffff097          	auipc	ra,0xfffff
    800044d8:	59e080e7          	jalr	1438(ra) # 80003a72 <brelse>
      tot = -1;
    800044dc:	59fd                	li	s3,-1
  }
  return tot;
    800044de:	0009851b          	sext.w	a0,s3
}
    800044e2:	70a6                	ld	ra,104(sp)
    800044e4:	7406                	ld	s0,96(sp)
    800044e6:	64e6                	ld	s1,88(sp)
    800044e8:	6946                	ld	s2,80(sp)
    800044ea:	69a6                	ld	s3,72(sp)
    800044ec:	6a06                	ld	s4,64(sp)
    800044ee:	7ae2                	ld	s5,56(sp)
    800044f0:	7b42                	ld	s6,48(sp)
    800044f2:	7ba2                	ld	s7,40(sp)
    800044f4:	7c02                	ld	s8,32(sp)
    800044f6:	6ce2                	ld	s9,24(sp)
    800044f8:	6d42                	ld	s10,16(sp)
    800044fa:	6da2                	ld	s11,8(sp)
    800044fc:	6165                	addi	sp,sp,112
    800044fe:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80004500:	89d6                	mv	s3,s5
    80004502:	bff1                	j	800044de <readi+0xce>
    return 0;
    80004504:	4501                	li	a0,0
}
    80004506:	8082                	ret

0000000080004508 <writei>:
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    80004508:	457c                	lw	a5,76(a0)
    8000450a:	10d7e863          	bltu	a5,a3,8000461a <writei+0x112>
{
    8000450e:	7159                	addi	sp,sp,-112
    80004510:	f486                	sd	ra,104(sp)
    80004512:	f0a2                	sd	s0,96(sp)
    80004514:	eca6                	sd	s1,88(sp)
    80004516:	e8ca                	sd	s2,80(sp)
    80004518:	e4ce                	sd	s3,72(sp)
    8000451a:	e0d2                	sd	s4,64(sp)
    8000451c:	fc56                	sd	s5,56(sp)
    8000451e:	f85a                	sd	s6,48(sp)
    80004520:	f45e                	sd	s7,40(sp)
    80004522:	f062                	sd	s8,32(sp)
    80004524:	ec66                	sd	s9,24(sp)
    80004526:	e86a                	sd	s10,16(sp)
    80004528:	e46e                	sd	s11,8(sp)
    8000452a:	1880                	addi	s0,sp,112
    8000452c:	8aaa                	mv	s5,a0
    8000452e:	8bae                	mv	s7,a1
    80004530:	8a32                	mv	s4,a2
    80004532:	8936                	mv	s2,a3
    80004534:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    80004536:	00e687bb          	addw	a5,a3,a4
    8000453a:	0ed7e263          	bltu	a5,a3,8000461e <writei+0x116>
    return -1;
  if (off + n > MAXFILE * BSIZE)
    8000453e:	00043737          	lui	a4,0x43
    80004542:	0ef76063          	bltu	a4,a5,80004622 <writei+0x11a>
    return -1;

  for (tot = 0; tot < n; tot += m, off += m, src += m)
    80004546:	0c0b0863          	beqz	s6,80004616 <writei+0x10e>
    8000454a:	4981                	li	s3,0
  {
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    8000454c:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1)
    80004550:	5c7d                	li	s8,-1
    80004552:	a091                	j	80004596 <writei+0x8e>
    80004554:	020d1d93          	slli	s11,s10,0x20
    80004558:	020ddd93          	srli	s11,s11,0x20
    8000455c:	05848793          	addi	a5,s1,88
    80004560:	86ee                	mv	a3,s11
    80004562:	8652                	mv	a2,s4
    80004564:	85de                	mv	a1,s7
    80004566:	953e                	add	a0,a0,a5
    80004568:	ffffe097          	auipc	ra,0xffffe
    8000456c:	5e0080e7          	jalr	1504(ra) # 80002b48 <either_copyin>
    80004570:	07850263          	beq	a0,s8,800045d4 <writei+0xcc>
    {
      brelse(bp);
      break;
    }
    log_write(bp);
    80004574:	8526                	mv	a0,s1
    80004576:	00000097          	auipc	ra,0x0
    8000457a:	780080e7          	jalr	1920(ra) # 80004cf6 <log_write>
    brelse(bp);
    8000457e:	8526                	mv	a0,s1
    80004580:	fffff097          	auipc	ra,0xfffff
    80004584:	4f2080e7          	jalr	1266(ra) # 80003a72 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m)
    80004588:	013d09bb          	addw	s3,s10,s3
    8000458c:	012d093b          	addw	s2,s10,s2
    80004590:	9a6e                	add	s4,s4,s11
    80004592:	0569f663          	bgeu	s3,s6,800045de <writei+0xd6>
    uint addr = bmap(ip, off / BSIZE);
    80004596:	00a9559b          	srliw	a1,s2,0xa
    8000459a:	8556                	mv	a0,s5
    8000459c:	fffff097          	auipc	ra,0xfffff
    800045a0:	7a0080e7          	jalr	1952(ra) # 80003d3c <bmap>
    800045a4:	0005059b          	sext.w	a1,a0
    if (addr == 0)
    800045a8:	c99d                	beqz	a1,800045de <writei+0xd6>
    bp = bread(ip->dev, addr);
    800045aa:	000aa503          	lw	a0,0(s5)
    800045ae:	fffff097          	auipc	ra,0xfffff
    800045b2:	394080e7          	jalr	916(ra) # 80003942 <bread>
    800045b6:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    800045b8:	3ff97513          	andi	a0,s2,1023
    800045bc:	40ac87bb          	subw	a5,s9,a0
    800045c0:	413b073b          	subw	a4,s6,s3
    800045c4:	8d3e                	mv	s10,a5
    800045c6:	2781                	sext.w	a5,a5
    800045c8:	0007069b          	sext.w	a3,a4
    800045cc:	f8f6f4e3          	bgeu	a3,a5,80004554 <writei+0x4c>
    800045d0:	8d3a                	mv	s10,a4
    800045d2:	b749                	j	80004554 <writei+0x4c>
      brelse(bp);
    800045d4:	8526                	mv	a0,s1
    800045d6:	fffff097          	auipc	ra,0xfffff
    800045da:	49c080e7          	jalr	1180(ra) # 80003a72 <brelse>
  }

  if (off > ip->size)
    800045de:	04caa783          	lw	a5,76(s5)
    800045e2:	0127f463          	bgeu	a5,s2,800045ea <writei+0xe2>
    ip->size = off;
    800045e6:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800045ea:	8556                	mv	a0,s5
    800045ec:	00000097          	auipc	ra,0x0
    800045f0:	aa6080e7          	jalr	-1370(ra) # 80004092 <iupdate>

  return tot;
    800045f4:	0009851b          	sext.w	a0,s3
}
    800045f8:	70a6                	ld	ra,104(sp)
    800045fa:	7406                	ld	s0,96(sp)
    800045fc:	64e6                	ld	s1,88(sp)
    800045fe:	6946                	ld	s2,80(sp)
    80004600:	69a6                	ld	s3,72(sp)
    80004602:	6a06                	ld	s4,64(sp)
    80004604:	7ae2                	ld	s5,56(sp)
    80004606:	7b42                	ld	s6,48(sp)
    80004608:	7ba2                	ld	s7,40(sp)
    8000460a:	7c02                	ld	s8,32(sp)
    8000460c:	6ce2                	ld	s9,24(sp)
    8000460e:	6d42                	ld	s10,16(sp)
    80004610:	6da2                	ld	s11,8(sp)
    80004612:	6165                	addi	sp,sp,112
    80004614:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m)
    80004616:	89da                	mv	s3,s6
    80004618:	bfc9                	j	800045ea <writei+0xe2>
    return -1;
    8000461a:	557d                	li	a0,-1
}
    8000461c:	8082                	ret
    return -1;
    8000461e:	557d                	li	a0,-1
    80004620:	bfe1                	j	800045f8 <writei+0xf0>
    return -1;
    80004622:	557d                	li	a0,-1
    80004624:	bfd1                	j	800045f8 <writei+0xf0>

0000000080004626 <namecmp>:

// Directories

int namecmp(const char *s, const char *t)
{
    80004626:	1141                	addi	sp,sp,-16
    80004628:	e406                	sd	ra,8(sp)
    8000462a:	e022                	sd	s0,0(sp)
    8000462c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000462e:	4639                	li	a2,14
    80004630:	ffffd097          	auipc	ra,0xffffd
    80004634:	92e080e7          	jalr	-1746(ra) # 80000f5e <strncmp>
}
    80004638:	60a2                	ld	ra,8(sp)
    8000463a:	6402                	ld	s0,0(sp)
    8000463c:	0141                	addi	sp,sp,16
    8000463e:	8082                	ret

0000000080004640 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004640:	7139                	addi	sp,sp,-64
    80004642:	fc06                	sd	ra,56(sp)
    80004644:	f822                	sd	s0,48(sp)
    80004646:	f426                	sd	s1,40(sp)
    80004648:	f04a                	sd	s2,32(sp)
    8000464a:	ec4e                	sd	s3,24(sp)
    8000464c:	e852                	sd	s4,16(sp)
    8000464e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
    80004650:	04451703          	lh	a4,68(a0)
    80004654:	4785                	li	a5,1
    80004656:	00f71a63          	bne	a4,a5,8000466a <dirlookup+0x2a>
    8000465a:	892a                	mv	s2,a0
    8000465c:	89ae                	mv	s3,a1
    8000465e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for (off = 0; off < dp->size; off += sizeof(de))
    80004660:	457c                	lw	a5,76(a0)
    80004662:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004664:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de))
    80004666:	e79d                	bnez	a5,80004694 <dirlookup+0x54>
    80004668:	a8a5                	j	800046e0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000466a:	00005517          	auipc	a0,0x5
    8000466e:	14650513          	addi	a0,a0,326 # 800097b0 <syscalls+0x1d0>
    80004672:	ffffc097          	auipc	ra,0xffffc
    80004676:	ecc080e7          	jalr	-308(ra) # 8000053e <panic>
      panic("dirlookup read");
    8000467a:	00005517          	auipc	a0,0x5
    8000467e:	14e50513          	addi	a0,a0,334 # 800097c8 <syscalls+0x1e8>
    80004682:	ffffc097          	auipc	ra,0xffffc
    80004686:	ebc080e7          	jalr	-324(ra) # 8000053e <panic>
  for (off = 0; off < dp->size; off += sizeof(de))
    8000468a:	24c1                	addiw	s1,s1,16
    8000468c:	04c92783          	lw	a5,76(s2)
    80004690:	04f4f763          	bgeu	s1,a5,800046de <dirlookup+0x9e>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004694:	4741                	li	a4,16
    80004696:	86a6                	mv	a3,s1
    80004698:	fc040613          	addi	a2,s0,-64
    8000469c:	4581                	li	a1,0
    8000469e:	854a                	mv	a0,s2
    800046a0:	00000097          	auipc	ra,0x0
    800046a4:	d70080e7          	jalr	-656(ra) # 80004410 <readi>
    800046a8:	47c1                	li	a5,16
    800046aa:	fcf518e3          	bne	a0,a5,8000467a <dirlookup+0x3a>
    if (de.inum == 0)
    800046ae:	fc045783          	lhu	a5,-64(s0)
    800046b2:	dfe1                	beqz	a5,8000468a <dirlookup+0x4a>
    if (namecmp(name, de.name) == 0)
    800046b4:	fc240593          	addi	a1,s0,-62
    800046b8:	854e                	mv	a0,s3
    800046ba:	00000097          	auipc	ra,0x0
    800046be:	f6c080e7          	jalr	-148(ra) # 80004626 <namecmp>
    800046c2:	f561                	bnez	a0,8000468a <dirlookup+0x4a>
      if (poff)
    800046c4:	000a0463          	beqz	s4,800046cc <dirlookup+0x8c>
        *poff = off;
    800046c8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800046cc:	fc045583          	lhu	a1,-64(s0)
    800046d0:	00092503          	lw	a0,0(s2)
    800046d4:	fffff097          	auipc	ra,0xfffff
    800046d8:	750080e7          	jalr	1872(ra) # 80003e24 <iget>
    800046dc:	a011                	j	800046e0 <dirlookup+0xa0>
  return 0;
    800046de:	4501                	li	a0,0
}
    800046e0:	70e2                	ld	ra,56(sp)
    800046e2:	7442                	ld	s0,48(sp)
    800046e4:	74a2                	ld	s1,40(sp)
    800046e6:	7902                	ld	s2,32(sp)
    800046e8:	69e2                	ld	s3,24(sp)
    800046ea:	6a42                	ld	s4,16(sp)
    800046ec:	6121                	addi	sp,sp,64
    800046ee:	8082                	ret

00000000800046f0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    800046f0:	711d                	addi	sp,sp,-96
    800046f2:	ec86                	sd	ra,88(sp)
    800046f4:	e8a2                	sd	s0,80(sp)
    800046f6:	e4a6                	sd	s1,72(sp)
    800046f8:	e0ca                	sd	s2,64(sp)
    800046fa:	fc4e                	sd	s3,56(sp)
    800046fc:	f852                	sd	s4,48(sp)
    800046fe:	f456                	sd	s5,40(sp)
    80004700:	f05a                	sd	s6,32(sp)
    80004702:	ec5e                	sd	s7,24(sp)
    80004704:	e862                	sd	s8,16(sp)
    80004706:	e466                	sd	s9,8(sp)
    80004708:	1080                	addi	s0,sp,96
    8000470a:	84aa                	mv	s1,a0
    8000470c:	8aae                	mv	s5,a1
    8000470e:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if (*path == '/')
    80004710:	00054703          	lbu	a4,0(a0)
    80004714:	02f00793          	li	a5,47
    80004718:	02f70363          	beq	a4,a5,8000473e <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000471c:	ffffd097          	auipc	ra,0xffffd
    80004720:	4d2080e7          	jalr	1234(ra) # 80001bee <myproc>
    80004724:	15053503          	ld	a0,336(a0)
    80004728:	00000097          	auipc	ra,0x0
    8000472c:	9f6080e7          	jalr	-1546(ra) # 8000411e <idup>
    80004730:	89aa                	mv	s3,a0
  while (*path == '/')
    80004732:	02f00913          	li	s2,47
  len = path - s;
    80004736:	4b01                	li	s6,0
  if (len >= DIRSIZ)
    80004738:	4c35                	li	s8,13

  while ((path = skipelem(path, name)) != 0)
  {
    ilock(ip);
    if (ip->type != T_DIR)
    8000473a:	4b85                	li	s7,1
    8000473c:	a865                	j	800047f4 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000473e:	4585                	li	a1,1
    80004740:	4505                	li	a0,1
    80004742:	fffff097          	auipc	ra,0xfffff
    80004746:	6e2080e7          	jalr	1762(ra) # 80003e24 <iget>
    8000474a:	89aa                	mv	s3,a0
    8000474c:	b7dd                	j	80004732 <namex+0x42>
    {
      iunlockput(ip);
    8000474e:	854e                	mv	a0,s3
    80004750:	00000097          	auipc	ra,0x0
    80004754:	c6e080e7          	jalr	-914(ra) # 800043be <iunlockput>
      return 0;
    80004758:	4981                	li	s3,0
  {
    iput(ip);
    return 0;
  }
  return ip;
}
    8000475a:	854e                	mv	a0,s3
    8000475c:	60e6                	ld	ra,88(sp)
    8000475e:	6446                	ld	s0,80(sp)
    80004760:	64a6                	ld	s1,72(sp)
    80004762:	6906                	ld	s2,64(sp)
    80004764:	79e2                	ld	s3,56(sp)
    80004766:	7a42                	ld	s4,48(sp)
    80004768:	7aa2                	ld	s5,40(sp)
    8000476a:	7b02                	ld	s6,32(sp)
    8000476c:	6be2                	ld	s7,24(sp)
    8000476e:	6c42                	ld	s8,16(sp)
    80004770:	6ca2                	ld	s9,8(sp)
    80004772:	6125                	addi	sp,sp,96
    80004774:	8082                	ret
      iunlock(ip);
    80004776:	854e                	mv	a0,s3
    80004778:	00000097          	auipc	ra,0x0
    8000477c:	aa6080e7          	jalr	-1370(ra) # 8000421e <iunlock>
      return ip;
    80004780:	bfe9                	j	8000475a <namex+0x6a>
      iunlockput(ip);
    80004782:	854e                	mv	a0,s3
    80004784:	00000097          	auipc	ra,0x0
    80004788:	c3a080e7          	jalr	-966(ra) # 800043be <iunlockput>
      return 0;
    8000478c:	89e6                	mv	s3,s9
    8000478e:	b7f1                	j	8000475a <namex+0x6a>
  len = path - s;
    80004790:	40b48633          	sub	a2,s1,a1
    80004794:	00060c9b          	sext.w	s9,a2
  if (len >= DIRSIZ)
    80004798:	099c5463          	bge	s8,s9,80004820 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000479c:	4639                	li	a2,14
    8000479e:	8552                	mv	a0,s4
    800047a0:	ffffc097          	auipc	ra,0xffffc
    800047a4:	74a080e7          	jalr	1866(ra) # 80000eea <memmove>
  while (*path == '/')
    800047a8:	0004c783          	lbu	a5,0(s1)
    800047ac:	01279763          	bne	a5,s2,800047ba <namex+0xca>
    path++;
    800047b0:	0485                	addi	s1,s1,1
  while (*path == '/')
    800047b2:	0004c783          	lbu	a5,0(s1)
    800047b6:	ff278de3          	beq	a5,s2,800047b0 <namex+0xc0>
    ilock(ip);
    800047ba:	854e                	mv	a0,s3
    800047bc:	00000097          	auipc	ra,0x0
    800047c0:	9a0080e7          	jalr	-1632(ra) # 8000415c <ilock>
    if (ip->type != T_DIR)
    800047c4:	04499783          	lh	a5,68(s3)
    800047c8:	f97793e3          	bne	a5,s7,8000474e <namex+0x5e>
    if (nameiparent && *path == '\0')
    800047cc:	000a8563          	beqz	s5,800047d6 <namex+0xe6>
    800047d0:	0004c783          	lbu	a5,0(s1)
    800047d4:	d3cd                	beqz	a5,80004776 <namex+0x86>
    if ((next = dirlookup(ip, name, 0)) == 0)
    800047d6:	865a                	mv	a2,s6
    800047d8:	85d2                	mv	a1,s4
    800047da:	854e                	mv	a0,s3
    800047dc:	00000097          	auipc	ra,0x0
    800047e0:	e64080e7          	jalr	-412(ra) # 80004640 <dirlookup>
    800047e4:	8caa                	mv	s9,a0
    800047e6:	dd51                	beqz	a0,80004782 <namex+0x92>
    iunlockput(ip);
    800047e8:	854e                	mv	a0,s3
    800047ea:	00000097          	auipc	ra,0x0
    800047ee:	bd4080e7          	jalr	-1068(ra) # 800043be <iunlockput>
    ip = next;
    800047f2:	89e6                	mv	s3,s9
  while (*path == '/')
    800047f4:	0004c783          	lbu	a5,0(s1)
    800047f8:	05279763          	bne	a5,s2,80004846 <namex+0x156>
    path++;
    800047fc:	0485                	addi	s1,s1,1
  while (*path == '/')
    800047fe:	0004c783          	lbu	a5,0(s1)
    80004802:	ff278de3          	beq	a5,s2,800047fc <namex+0x10c>
  if (*path == 0)
    80004806:	c79d                	beqz	a5,80004834 <namex+0x144>
    path++;
    80004808:	85a6                	mv	a1,s1
  len = path - s;
    8000480a:	8cda                	mv	s9,s6
    8000480c:	865a                	mv	a2,s6
  while (*path != '/' && *path != 0)
    8000480e:	01278963          	beq	a5,s2,80004820 <namex+0x130>
    80004812:	dfbd                	beqz	a5,80004790 <namex+0xa0>
    path++;
    80004814:	0485                	addi	s1,s1,1
  while (*path != '/' && *path != 0)
    80004816:	0004c783          	lbu	a5,0(s1)
    8000481a:	ff279ce3          	bne	a5,s2,80004812 <namex+0x122>
    8000481e:	bf8d                	j	80004790 <namex+0xa0>
    memmove(name, s, len);
    80004820:	2601                	sext.w	a2,a2
    80004822:	8552                	mv	a0,s4
    80004824:	ffffc097          	auipc	ra,0xffffc
    80004828:	6c6080e7          	jalr	1734(ra) # 80000eea <memmove>
    name[len] = 0;
    8000482c:	9cd2                	add	s9,s9,s4
    8000482e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004832:	bf9d                	j	800047a8 <namex+0xb8>
  if (nameiparent)
    80004834:	f20a83e3          	beqz	s5,8000475a <namex+0x6a>
    iput(ip);
    80004838:	854e                	mv	a0,s3
    8000483a:	00000097          	auipc	ra,0x0
    8000483e:	adc080e7          	jalr	-1316(ra) # 80004316 <iput>
    return 0;
    80004842:	4981                	li	s3,0
    80004844:	bf19                	j	8000475a <namex+0x6a>
  if (*path == 0)
    80004846:	d7fd                	beqz	a5,80004834 <namex+0x144>
  while (*path != '/' && *path != 0)
    80004848:	0004c783          	lbu	a5,0(s1)
    8000484c:	85a6                	mv	a1,s1
    8000484e:	b7d1                	j	80004812 <namex+0x122>

0000000080004850 <dirlink>:
{
    80004850:	7139                	addi	sp,sp,-64
    80004852:	fc06                	sd	ra,56(sp)
    80004854:	f822                	sd	s0,48(sp)
    80004856:	f426                	sd	s1,40(sp)
    80004858:	f04a                	sd	s2,32(sp)
    8000485a:	ec4e                	sd	s3,24(sp)
    8000485c:	e852                	sd	s4,16(sp)
    8000485e:	0080                	addi	s0,sp,64
    80004860:	892a                	mv	s2,a0
    80004862:	8a2e                	mv	s4,a1
    80004864:	89b2                	mv	s3,a2
  if ((ip = dirlookup(dp, name, 0)) != 0)
    80004866:	4601                	li	a2,0
    80004868:	00000097          	auipc	ra,0x0
    8000486c:	dd8080e7          	jalr	-552(ra) # 80004640 <dirlookup>
    80004870:	e93d                	bnez	a0,800048e6 <dirlink+0x96>
  for (off = 0; off < dp->size; off += sizeof(de))
    80004872:	04c92483          	lw	s1,76(s2)
    80004876:	c49d                	beqz	s1,800048a4 <dirlink+0x54>
    80004878:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000487a:	4741                	li	a4,16
    8000487c:	86a6                	mv	a3,s1
    8000487e:	fc040613          	addi	a2,s0,-64
    80004882:	4581                	li	a1,0
    80004884:	854a                	mv	a0,s2
    80004886:	00000097          	auipc	ra,0x0
    8000488a:	b8a080e7          	jalr	-1142(ra) # 80004410 <readi>
    8000488e:	47c1                	li	a5,16
    80004890:	06f51163          	bne	a0,a5,800048f2 <dirlink+0xa2>
    if (de.inum == 0)
    80004894:	fc045783          	lhu	a5,-64(s0)
    80004898:	c791                	beqz	a5,800048a4 <dirlink+0x54>
  for (off = 0; off < dp->size; off += sizeof(de))
    8000489a:	24c1                	addiw	s1,s1,16
    8000489c:	04c92783          	lw	a5,76(s2)
    800048a0:	fcf4ede3          	bltu	s1,a5,8000487a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800048a4:	4639                	li	a2,14
    800048a6:	85d2                	mv	a1,s4
    800048a8:	fc240513          	addi	a0,s0,-62
    800048ac:	ffffc097          	auipc	ra,0xffffc
    800048b0:	6ee080e7          	jalr	1774(ra) # 80000f9a <strncpy>
  de.inum = inum;
    800048b4:	fd341023          	sh	s3,-64(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800048b8:	4741                	li	a4,16
    800048ba:	86a6                	mv	a3,s1
    800048bc:	fc040613          	addi	a2,s0,-64
    800048c0:	4581                	li	a1,0
    800048c2:	854a                	mv	a0,s2
    800048c4:	00000097          	auipc	ra,0x0
    800048c8:	c44080e7          	jalr	-956(ra) # 80004508 <writei>
    800048cc:	1541                	addi	a0,a0,-16
    800048ce:	00a03533          	snez	a0,a0
    800048d2:	40a00533          	neg	a0,a0
}
    800048d6:	70e2                	ld	ra,56(sp)
    800048d8:	7442                	ld	s0,48(sp)
    800048da:	74a2                	ld	s1,40(sp)
    800048dc:	7902                	ld	s2,32(sp)
    800048de:	69e2                	ld	s3,24(sp)
    800048e0:	6a42                	ld	s4,16(sp)
    800048e2:	6121                	addi	sp,sp,64
    800048e4:	8082                	ret
    iput(ip);
    800048e6:	00000097          	auipc	ra,0x0
    800048ea:	a30080e7          	jalr	-1488(ra) # 80004316 <iput>
    return -1;
    800048ee:	557d                	li	a0,-1
    800048f0:	b7dd                	j	800048d6 <dirlink+0x86>
      panic("dirlink read");
    800048f2:	00005517          	auipc	a0,0x5
    800048f6:	ee650513          	addi	a0,a0,-282 # 800097d8 <syscalls+0x1f8>
    800048fa:	ffffc097          	auipc	ra,0xffffc
    800048fe:	c44080e7          	jalr	-956(ra) # 8000053e <panic>

0000000080004902 <namei>:

struct inode *
namei(char *path)
{
    80004902:	1101                	addi	sp,sp,-32
    80004904:	ec06                	sd	ra,24(sp)
    80004906:	e822                	sd	s0,16(sp)
    80004908:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000490a:	fe040613          	addi	a2,s0,-32
    8000490e:	4581                	li	a1,0
    80004910:	00000097          	auipc	ra,0x0
    80004914:	de0080e7          	jalr	-544(ra) # 800046f0 <namex>
}
    80004918:	60e2                	ld	ra,24(sp)
    8000491a:	6442                	ld	s0,16(sp)
    8000491c:	6105                	addi	sp,sp,32
    8000491e:	8082                	ret

0000000080004920 <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    80004920:	1141                	addi	sp,sp,-16
    80004922:	e406                	sd	ra,8(sp)
    80004924:	e022                	sd	s0,0(sp)
    80004926:	0800                	addi	s0,sp,16
    80004928:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000492a:	4585                	li	a1,1
    8000492c:	00000097          	auipc	ra,0x0
    80004930:	dc4080e7          	jalr	-572(ra) # 800046f0 <namex>
}
    80004934:	60a2                	ld	ra,8(sp)
    80004936:	6402                	ld	s0,0(sp)
    80004938:	0141                	addi	sp,sp,16
    8000493a:	8082                	ret

000000008000493c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000493c:	1101                	addi	sp,sp,-32
    8000493e:	ec06                	sd	ra,24(sp)
    80004940:	e822                	sd	s0,16(sp)
    80004942:	e426                	sd	s1,8(sp)
    80004944:	e04a                	sd	s2,0(sp)
    80004946:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004948:	0023f917          	auipc	s2,0x23f
    8000494c:	51090913          	addi	s2,s2,1296 # 80243e58 <log>
    80004950:	01892583          	lw	a1,24(s2)
    80004954:	02892503          	lw	a0,40(s2)
    80004958:	fffff097          	auipc	ra,0xfffff
    8000495c:	fea080e7          	jalr	-22(ra) # 80003942 <bread>
    80004960:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    80004962:	02c92683          	lw	a3,44(s2)
    80004966:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++)
    80004968:	02d05763          	blez	a3,80004996 <write_head+0x5a>
    8000496c:	0023f797          	auipc	a5,0x23f
    80004970:	51c78793          	addi	a5,a5,1308 # 80243e88 <log+0x30>
    80004974:	05c50713          	addi	a4,a0,92
    80004978:	36fd                	addiw	a3,a3,-1
    8000497a:	1682                	slli	a3,a3,0x20
    8000497c:	9281                	srli	a3,a3,0x20
    8000497e:	068a                	slli	a3,a3,0x2
    80004980:	0023f617          	auipc	a2,0x23f
    80004984:	50c60613          	addi	a2,a2,1292 # 80243e8c <log+0x34>
    80004988:	96b2                	add	a3,a3,a2
  {
    hb->block[i] = log.lh.block[i];
    8000498a:	4390                	lw	a2,0(a5)
    8000498c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++)
    8000498e:	0791                	addi	a5,a5,4
    80004990:	0711                	addi	a4,a4,4
    80004992:	fed79ce3          	bne	a5,a3,8000498a <write_head+0x4e>
  }
  bwrite(buf);
    80004996:	8526                	mv	a0,s1
    80004998:	fffff097          	auipc	ra,0xfffff
    8000499c:	09c080e7          	jalr	156(ra) # 80003a34 <bwrite>
  brelse(buf);
    800049a0:	8526                	mv	a0,s1
    800049a2:	fffff097          	auipc	ra,0xfffff
    800049a6:	0d0080e7          	jalr	208(ra) # 80003a72 <brelse>
}
    800049aa:	60e2                	ld	ra,24(sp)
    800049ac:	6442                	ld	s0,16(sp)
    800049ae:	64a2                	ld	s1,8(sp)
    800049b0:	6902                	ld	s2,0(sp)
    800049b2:	6105                	addi	sp,sp,32
    800049b4:	8082                	ret

00000000800049b6 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++)
    800049b6:	0023f797          	auipc	a5,0x23f
    800049ba:	4ce7a783          	lw	a5,1230(a5) # 80243e84 <log+0x2c>
    800049be:	0af05d63          	blez	a5,80004a78 <install_trans+0xc2>
{
    800049c2:	7139                	addi	sp,sp,-64
    800049c4:	fc06                	sd	ra,56(sp)
    800049c6:	f822                	sd	s0,48(sp)
    800049c8:	f426                	sd	s1,40(sp)
    800049ca:	f04a                	sd	s2,32(sp)
    800049cc:	ec4e                	sd	s3,24(sp)
    800049ce:	e852                	sd	s4,16(sp)
    800049d0:	e456                	sd	s5,8(sp)
    800049d2:	e05a                	sd	s6,0(sp)
    800049d4:	0080                	addi	s0,sp,64
    800049d6:	8b2a                	mv	s6,a0
    800049d8:	0023fa97          	auipc	s5,0x23f
    800049dc:	4b0a8a93          	addi	s5,s5,1200 # 80243e88 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++)
    800049e0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    800049e2:	0023f997          	auipc	s3,0x23f
    800049e6:	47698993          	addi	s3,s3,1142 # 80243e58 <log>
    800049ea:	a00d                	j	80004a0c <install_trans+0x56>
    brelse(lbuf);
    800049ec:	854a                	mv	a0,s2
    800049ee:	fffff097          	auipc	ra,0xfffff
    800049f2:	084080e7          	jalr	132(ra) # 80003a72 <brelse>
    brelse(dbuf);
    800049f6:	8526                	mv	a0,s1
    800049f8:	fffff097          	auipc	ra,0xfffff
    800049fc:	07a080e7          	jalr	122(ra) # 80003a72 <brelse>
  for (tail = 0; tail < log.lh.n; tail++)
    80004a00:	2a05                	addiw	s4,s4,1
    80004a02:	0a91                	addi	s5,s5,4
    80004a04:	02c9a783          	lw	a5,44(s3)
    80004a08:	04fa5e63          	bge	s4,a5,80004a64 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80004a0c:	0189a583          	lw	a1,24(s3)
    80004a10:	014585bb          	addw	a1,a1,s4
    80004a14:	2585                	addiw	a1,a1,1
    80004a16:	0289a503          	lw	a0,40(s3)
    80004a1a:	fffff097          	auipc	ra,0xfffff
    80004a1e:	f28080e7          	jalr	-216(ra) # 80003942 <bread>
    80004a22:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
    80004a24:	000aa583          	lw	a1,0(s5)
    80004a28:	0289a503          	lw	a0,40(s3)
    80004a2c:	fffff097          	auipc	ra,0xfffff
    80004a30:	f16080e7          	jalr	-234(ra) # 80003942 <bread>
    80004a34:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);                  // copy block to dst
    80004a36:	40000613          	li	a2,1024
    80004a3a:	05890593          	addi	a1,s2,88
    80004a3e:	05850513          	addi	a0,a0,88
    80004a42:	ffffc097          	auipc	ra,0xffffc
    80004a46:	4a8080e7          	jalr	1192(ra) # 80000eea <memmove>
    bwrite(dbuf);                                            // write dst to disk
    80004a4a:	8526                	mv	a0,s1
    80004a4c:	fffff097          	auipc	ra,0xfffff
    80004a50:	fe8080e7          	jalr	-24(ra) # 80003a34 <bwrite>
    if (recovering == 0)
    80004a54:	f80b1ce3          	bnez	s6,800049ec <install_trans+0x36>
      bunpin(dbuf);
    80004a58:	8526                	mv	a0,s1
    80004a5a:	fffff097          	auipc	ra,0xfffff
    80004a5e:	0f2080e7          	jalr	242(ra) # 80003b4c <bunpin>
    80004a62:	b769                	j	800049ec <install_trans+0x36>
}
    80004a64:	70e2                	ld	ra,56(sp)
    80004a66:	7442                	ld	s0,48(sp)
    80004a68:	74a2                	ld	s1,40(sp)
    80004a6a:	7902                	ld	s2,32(sp)
    80004a6c:	69e2                	ld	s3,24(sp)
    80004a6e:	6a42                	ld	s4,16(sp)
    80004a70:	6aa2                	ld	s5,8(sp)
    80004a72:	6b02                	ld	s6,0(sp)
    80004a74:	6121                	addi	sp,sp,64
    80004a76:	8082                	ret
    80004a78:	8082                	ret

0000000080004a7a <initlog>:
{
    80004a7a:	7179                	addi	sp,sp,-48
    80004a7c:	f406                	sd	ra,40(sp)
    80004a7e:	f022                	sd	s0,32(sp)
    80004a80:	ec26                	sd	s1,24(sp)
    80004a82:	e84a                	sd	s2,16(sp)
    80004a84:	e44e                	sd	s3,8(sp)
    80004a86:	1800                	addi	s0,sp,48
    80004a88:	892a                	mv	s2,a0
    80004a8a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004a8c:	0023f497          	auipc	s1,0x23f
    80004a90:	3cc48493          	addi	s1,s1,972 # 80243e58 <log>
    80004a94:	00005597          	auipc	a1,0x5
    80004a98:	d5458593          	addi	a1,a1,-684 # 800097e8 <syscalls+0x208>
    80004a9c:	8526                	mv	a0,s1
    80004a9e:	ffffc097          	auipc	ra,0xffffc
    80004aa2:	264080e7          	jalr	612(ra) # 80000d02 <initlock>
  log.start = sb->logstart;
    80004aa6:	0149a583          	lw	a1,20(s3)
    80004aaa:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004aac:	0109a783          	lw	a5,16(s3)
    80004ab0:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004ab2:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004ab6:	854a                	mv	a0,s2
    80004ab8:	fffff097          	auipc	ra,0xfffff
    80004abc:	e8a080e7          	jalr	-374(ra) # 80003942 <bread>
  log.lh.n = lh->n;
    80004ac0:	4d34                	lw	a3,88(a0)
    80004ac2:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++)
    80004ac4:	02d05563          	blez	a3,80004aee <initlog+0x74>
    80004ac8:	05c50793          	addi	a5,a0,92
    80004acc:	0023f717          	auipc	a4,0x23f
    80004ad0:	3bc70713          	addi	a4,a4,956 # 80243e88 <log+0x30>
    80004ad4:	36fd                	addiw	a3,a3,-1
    80004ad6:	1682                	slli	a3,a3,0x20
    80004ad8:	9281                	srli	a3,a3,0x20
    80004ada:	068a                	slli	a3,a3,0x2
    80004adc:	06050613          	addi	a2,a0,96
    80004ae0:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80004ae2:	4390                	lw	a2,0(a5)
    80004ae4:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++)
    80004ae6:	0791                	addi	a5,a5,4
    80004ae8:	0711                	addi	a4,a4,4
    80004aea:	fed79ce3          	bne	a5,a3,80004ae2 <initlog+0x68>
  brelse(buf);
    80004aee:	fffff097          	auipc	ra,0xfffff
    80004af2:	f84080e7          	jalr	-124(ra) # 80003a72 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004af6:	4505                	li	a0,1
    80004af8:	00000097          	auipc	ra,0x0
    80004afc:	ebe080e7          	jalr	-322(ra) # 800049b6 <install_trans>
  log.lh.n = 0;
    80004b00:	0023f797          	auipc	a5,0x23f
    80004b04:	3807a223          	sw	zero,900(a5) # 80243e84 <log+0x2c>
  write_head(); // clear the log
    80004b08:	00000097          	auipc	ra,0x0
    80004b0c:	e34080e7          	jalr	-460(ra) # 8000493c <write_head>
}
    80004b10:	70a2                	ld	ra,40(sp)
    80004b12:	7402                	ld	s0,32(sp)
    80004b14:	64e2                	ld	s1,24(sp)
    80004b16:	6942                	ld	s2,16(sp)
    80004b18:	69a2                	ld	s3,8(sp)
    80004b1a:	6145                	addi	sp,sp,48
    80004b1c:	8082                	ret

0000000080004b1e <begin_op>:
}

// called at the start of each FS system call.
void begin_op(void)
{
    80004b1e:	1101                	addi	sp,sp,-32
    80004b20:	ec06                	sd	ra,24(sp)
    80004b22:	e822                	sd	s0,16(sp)
    80004b24:	e426                	sd	s1,8(sp)
    80004b26:	e04a                	sd	s2,0(sp)
    80004b28:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004b2a:	0023f517          	auipc	a0,0x23f
    80004b2e:	32e50513          	addi	a0,a0,814 # 80243e58 <log>
    80004b32:	ffffc097          	auipc	ra,0xffffc
    80004b36:	260080e7          	jalr	608(ra) # 80000d92 <acquire>
  while (1)
  {
    if (log.committing)
    80004b3a:	0023f497          	auipc	s1,0x23f
    80004b3e:	31e48493          	addi	s1,s1,798 # 80243e58 <log>
    {
      sleep(&log, &log.lock);
    }
    else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE)
    80004b42:	4979                	li	s2,30
    80004b44:	a039                	j	80004b52 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004b46:	85a6                	mv	a1,s1
    80004b48:	8526                	mv	a0,s1
    80004b4a:	ffffe097          	auipc	ra,0xffffe
    80004b4e:	a1c080e7          	jalr	-1508(ra) # 80002566 <sleep>
    if (log.committing)
    80004b52:	50dc                	lw	a5,36(s1)
    80004b54:	fbed                	bnez	a5,80004b46 <begin_op+0x28>
    else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE)
    80004b56:	509c                	lw	a5,32(s1)
    80004b58:	0017871b          	addiw	a4,a5,1
    80004b5c:	0007069b          	sext.w	a3,a4
    80004b60:	0027179b          	slliw	a5,a4,0x2
    80004b64:	9fb9                	addw	a5,a5,a4
    80004b66:	0017979b          	slliw	a5,a5,0x1
    80004b6a:	54d8                	lw	a4,44(s1)
    80004b6c:	9fb9                	addw	a5,a5,a4
    80004b6e:	00f95963          	bge	s2,a5,80004b80 <begin_op+0x62>
    {
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004b72:	85a6                	mv	a1,s1
    80004b74:	8526                	mv	a0,s1
    80004b76:	ffffe097          	auipc	ra,0xffffe
    80004b7a:	9f0080e7          	jalr	-1552(ra) # 80002566 <sleep>
    80004b7e:	bfd1                	j	80004b52 <begin_op+0x34>
    }
    else
    {
      log.outstanding += 1;
    80004b80:	0023f517          	auipc	a0,0x23f
    80004b84:	2d850513          	addi	a0,a0,728 # 80243e58 <log>
    80004b88:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004b8a:	ffffc097          	auipc	ra,0xffffc
    80004b8e:	2bc080e7          	jalr	700(ra) # 80000e46 <release>
      break;
    }
  }
}
    80004b92:	60e2                	ld	ra,24(sp)
    80004b94:	6442                	ld	s0,16(sp)
    80004b96:	64a2                	ld	s1,8(sp)
    80004b98:	6902                	ld	s2,0(sp)
    80004b9a:	6105                	addi	sp,sp,32
    80004b9c:	8082                	ret

0000000080004b9e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void end_op(void)
{
    80004b9e:	7139                	addi	sp,sp,-64
    80004ba0:	fc06                	sd	ra,56(sp)
    80004ba2:	f822                	sd	s0,48(sp)
    80004ba4:	f426                	sd	s1,40(sp)
    80004ba6:	f04a                	sd	s2,32(sp)
    80004ba8:	ec4e                	sd	s3,24(sp)
    80004baa:	e852                	sd	s4,16(sp)
    80004bac:	e456                	sd	s5,8(sp)
    80004bae:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004bb0:	0023f497          	auipc	s1,0x23f
    80004bb4:	2a848493          	addi	s1,s1,680 # 80243e58 <log>
    80004bb8:	8526                	mv	a0,s1
    80004bba:	ffffc097          	auipc	ra,0xffffc
    80004bbe:	1d8080e7          	jalr	472(ra) # 80000d92 <acquire>
  log.outstanding -= 1;
    80004bc2:	509c                	lw	a5,32(s1)
    80004bc4:	37fd                	addiw	a5,a5,-1
    80004bc6:	0007891b          	sext.w	s2,a5
    80004bca:	d09c                	sw	a5,32(s1)
  if (log.committing)
    80004bcc:	50dc                	lw	a5,36(s1)
    80004bce:	e7b9                	bnez	a5,80004c1c <end_op+0x7e>
    panic("log.committing");
  if (log.outstanding == 0)
    80004bd0:	04091e63          	bnez	s2,80004c2c <end_op+0x8e>
  {
    do_commit = 1;
    log.committing = 1;
    80004bd4:	0023f497          	auipc	s1,0x23f
    80004bd8:	28448493          	addi	s1,s1,644 # 80243e58 <log>
    80004bdc:	4785                	li	a5,1
    80004bde:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004be0:	8526                	mv	a0,s1
    80004be2:	ffffc097          	auipc	ra,0xffffc
    80004be6:	264080e7          	jalr	612(ra) # 80000e46 <release>
}

static void
commit()
{
  if (log.lh.n > 0)
    80004bea:	54dc                	lw	a5,44(s1)
    80004bec:	06f04763          	bgtz	a5,80004c5a <end_op+0xbc>
    acquire(&log.lock);
    80004bf0:	0023f497          	auipc	s1,0x23f
    80004bf4:	26848493          	addi	s1,s1,616 # 80243e58 <log>
    80004bf8:	8526                	mv	a0,s1
    80004bfa:	ffffc097          	auipc	ra,0xffffc
    80004bfe:	198080e7          	jalr	408(ra) # 80000d92 <acquire>
    log.committing = 0;
    80004c02:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004c06:	8526                	mv	a0,s1
    80004c08:	ffffe097          	auipc	ra,0xffffe
    80004c0c:	b1a080e7          	jalr	-1254(ra) # 80002722 <wakeup>
    release(&log.lock);
    80004c10:	8526                	mv	a0,s1
    80004c12:	ffffc097          	auipc	ra,0xffffc
    80004c16:	234080e7          	jalr	564(ra) # 80000e46 <release>
}
    80004c1a:	a03d                	j	80004c48 <end_op+0xaa>
    panic("log.committing");
    80004c1c:	00005517          	auipc	a0,0x5
    80004c20:	bd450513          	addi	a0,a0,-1068 # 800097f0 <syscalls+0x210>
    80004c24:	ffffc097          	auipc	ra,0xffffc
    80004c28:	91a080e7          	jalr	-1766(ra) # 8000053e <panic>
    wakeup(&log);
    80004c2c:	0023f497          	auipc	s1,0x23f
    80004c30:	22c48493          	addi	s1,s1,556 # 80243e58 <log>
    80004c34:	8526                	mv	a0,s1
    80004c36:	ffffe097          	auipc	ra,0xffffe
    80004c3a:	aec080e7          	jalr	-1300(ra) # 80002722 <wakeup>
  release(&log.lock);
    80004c3e:	8526                	mv	a0,s1
    80004c40:	ffffc097          	auipc	ra,0xffffc
    80004c44:	206080e7          	jalr	518(ra) # 80000e46 <release>
}
    80004c48:	70e2                	ld	ra,56(sp)
    80004c4a:	7442                	ld	s0,48(sp)
    80004c4c:	74a2                	ld	s1,40(sp)
    80004c4e:	7902                	ld	s2,32(sp)
    80004c50:	69e2                	ld	s3,24(sp)
    80004c52:	6a42                	ld	s4,16(sp)
    80004c54:	6aa2                	ld	s5,8(sp)
    80004c56:	6121                	addi	sp,sp,64
    80004c58:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++)
    80004c5a:	0023fa97          	auipc	s5,0x23f
    80004c5e:	22ea8a93          	addi	s5,s5,558 # 80243e88 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1); // log block
    80004c62:	0023fa17          	auipc	s4,0x23f
    80004c66:	1f6a0a13          	addi	s4,s4,502 # 80243e58 <log>
    80004c6a:	018a2583          	lw	a1,24(s4)
    80004c6e:	012585bb          	addw	a1,a1,s2
    80004c72:	2585                	addiw	a1,a1,1
    80004c74:	028a2503          	lw	a0,40(s4)
    80004c78:	fffff097          	auipc	ra,0xfffff
    80004c7c:	cca080e7          	jalr	-822(ra) # 80003942 <bread>
    80004c80:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004c82:	000aa583          	lw	a1,0(s5)
    80004c86:	028a2503          	lw	a0,40(s4)
    80004c8a:	fffff097          	auipc	ra,0xfffff
    80004c8e:	cb8080e7          	jalr	-840(ra) # 80003942 <bread>
    80004c92:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004c94:	40000613          	li	a2,1024
    80004c98:	05850593          	addi	a1,a0,88
    80004c9c:	05848513          	addi	a0,s1,88
    80004ca0:	ffffc097          	auipc	ra,0xffffc
    80004ca4:	24a080e7          	jalr	586(ra) # 80000eea <memmove>
    bwrite(to); // write the log
    80004ca8:	8526                	mv	a0,s1
    80004caa:	fffff097          	auipc	ra,0xfffff
    80004cae:	d8a080e7          	jalr	-630(ra) # 80003a34 <bwrite>
    brelse(from);
    80004cb2:	854e                	mv	a0,s3
    80004cb4:	fffff097          	auipc	ra,0xfffff
    80004cb8:	dbe080e7          	jalr	-578(ra) # 80003a72 <brelse>
    brelse(to);
    80004cbc:	8526                	mv	a0,s1
    80004cbe:	fffff097          	auipc	ra,0xfffff
    80004cc2:	db4080e7          	jalr	-588(ra) # 80003a72 <brelse>
  for (tail = 0; tail < log.lh.n; tail++)
    80004cc6:	2905                	addiw	s2,s2,1
    80004cc8:	0a91                	addi	s5,s5,4
    80004cca:	02ca2783          	lw	a5,44(s4)
    80004cce:	f8f94ee3          	blt	s2,a5,80004c6a <end_op+0xcc>
  {
    write_log();      // Write modified blocks from cache to log
    write_head();     // Write header to disk -- the real commit
    80004cd2:	00000097          	auipc	ra,0x0
    80004cd6:	c6a080e7          	jalr	-918(ra) # 8000493c <write_head>
    install_trans(0); // Now install writes to home locations
    80004cda:	4501                	li	a0,0
    80004cdc:	00000097          	auipc	ra,0x0
    80004ce0:	cda080e7          	jalr	-806(ra) # 800049b6 <install_trans>
    log.lh.n = 0;
    80004ce4:	0023f797          	auipc	a5,0x23f
    80004ce8:	1a07a023          	sw	zero,416(a5) # 80243e84 <log+0x2c>
    write_head(); // Erase the transaction from the log
    80004cec:	00000097          	auipc	ra,0x0
    80004cf0:	c50080e7          	jalr	-944(ra) # 8000493c <write_head>
    80004cf4:	bdf5                	j	80004bf0 <end_op+0x52>

0000000080004cf6 <log_write>:
//   bp = bread(...)
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void log_write(struct buf *b)
{
    80004cf6:	1101                	addi	sp,sp,-32
    80004cf8:	ec06                	sd	ra,24(sp)
    80004cfa:	e822                	sd	s0,16(sp)
    80004cfc:	e426                	sd	s1,8(sp)
    80004cfe:	e04a                	sd	s2,0(sp)
    80004d00:	1000                	addi	s0,sp,32
    80004d02:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004d04:	0023f917          	auipc	s2,0x23f
    80004d08:	15490913          	addi	s2,s2,340 # 80243e58 <log>
    80004d0c:	854a                	mv	a0,s2
    80004d0e:	ffffc097          	auipc	ra,0xffffc
    80004d12:	084080e7          	jalr	132(ra) # 80000d92 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004d16:	02c92603          	lw	a2,44(s2)
    80004d1a:	47f5                	li	a5,29
    80004d1c:	06c7c563          	blt	a5,a2,80004d86 <log_write+0x90>
    80004d20:	0023f797          	auipc	a5,0x23f
    80004d24:	1547a783          	lw	a5,340(a5) # 80243e74 <log+0x1c>
    80004d28:	37fd                	addiw	a5,a5,-1
    80004d2a:	04f65e63          	bge	a2,a5,80004d86 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004d2e:	0023f797          	auipc	a5,0x23f
    80004d32:	14a7a783          	lw	a5,330(a5) # 80243e78 <log+0x20>
    80004d36:	06f05063          	blez	a5,80004d96 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++)
    80004d3a:	4781                	li	a5,0
    80004d3c:	06c05563          	blez	a2,80004da6 <log_write+0xb0>
  {
    if (log.lh.block[i] == b->blockno) // log absorption
    80004d40:	44cc                	lw	a1,12(s1)
    80004d42:	0023f717          	auipc	a4,0x23f
    80004d46:	14670713          	addi	a4,a4,326 # 80243e88 <log+0x30>
  for (i = 0; i < log.lh.n; i++)
    80004d4a:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno) // log absorption
    80004d4c:	4314                	lw	a3,0(a4)
    80004d4e:	04b68c63          	beq	a3,a1,80004da6 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++)
    80004d52:	2785                	addiw	a5,a5,1
    80004d54:	0711                	addi	a4,a4,4
    80004d56:	fef61be3          	bne	a2,a5,80004d4c <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004d5a:	0621                	addi	a2,a2,8
    80004d5c:	060a                	slli	a2,a2,0x2
    80004d5e:	0023f797          	auipc	a5,0x23f
    80004d62:	0fa78793          	addi	a5,a5,250 # 80243e58 <log>
    80004d66:	963e                	add	a2,a2,a5
    80004d68:	44dc                	lw	a5,12(s1)
    80004d6a:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n)
  { // Add new block to log?
    bpin(b);
    80004d6c:	8526                	mv	a0,s1
    80004d6e:	fffff097          	auipc	ra,0xfffff
    80004d72:	da2080e7          	jalr	-606(ra) # 80003b10 <bpin>
    log.lh.n++;
    80004d76:	0023f717          	auipc	a4,0x23f
    80004d7a:	0e270713          	addi	a4,a4,226 # 80243e58 <log>
    80004d7e:	575c                	lw	a5,44(a4)
    80004d80:	2785                	addiw	a5,a5,1
    80004d82:	d75c                	sw	a5,44(a4)
    80004d84:	a835                	j	80004dc0 <log_write+0xca>
    panic("too big a transaction");
    80004d86:	00005517          	auipc	a0,0x5
    80004d8a:	a7a50513          	addi	a0,a0,-1414 # 80009800 <syscalls+0x220>
    80004d8e:	ffffb097          	auipc	ra,0xffffb
    80004d92:	7b0080e7          	jalr	1968(ra) # 8000053e <panic>
    panic("log_write outside of trans");
    80004d96:	00005517          	auipc	a0,0x5
    80004d9a:	a8250513          	addi	a0,a0,-1406 # 80009818 <syscalls+0x238>
    80004d9e:	ffffb097          	auipc	ra,0xffffb
    80004da2:	7a0080e7          	jalr	1952(ra) # 8000053e <panic>
  log.lh.block[i] = b->blockno;
    80004da6:	00878713          	addi	a4,a5,8
    80004daa:	00271693          	slli	a3,a4,0x2
    80004dae:	0023f717          	auipc	a4,0x23f
    80004db2:	0aa70713          	addi	a4,a4,170 # 80243e58 <log>
    80004db6:	9736                	add	a4,a4,a3
    80004db8:	44d4                	lw	a3,12(s1)
    80004dba:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n)
    80004dbc:	faf608e3          	beq	a2,a5,80004d6c <log_write+0x76>
  }
  release(&log.lock);
    80004dc0:	0023f517          	auipc	a0,0x23f
    80004dc4:	09850513          	addi	a0,a0,152 # 80243e58 <log>
    80004dc8:	ffffc097          	auipc	ra,0xffffc
    80004dcc:	07e080e7          	jalr	126(ra) # 80000e46 <release>
}
    80004dd0:	60e2                	ld	ra,24(sp)
    80004dd2:	6442                	ld	s0,16(sp)
    80004dd4:	64a2                	ld	s1,8(sp)
    80004dd6:	6902                	ld	s2,0(sp)
    80004dd8:	6105                	addi	sp,sp,32
    80004dda:	8082                	ret

0000000080004ddc <initsleeplock>:
#include "spinlock.h"
#include "proc.h"
#include "sleeplock.h"

void initsleeplock(struct sleeplock *lk, char *name)
{
    80004ddc:	1101                	addi	sp,sp,-32
    80004dde:	ec06                	sd	ra,24(sp)
    80004de0:	e822                	sd	s0,16(sp)
    80004de2:	e426                	sd	s1,8(sp)
    80004de4:	e04a                	sd	s2,0(sp)
    80004de6:	1000                	addi	s0,sp,32
    80004de8:	84aa                	mv	s1,a0
    80004dea:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004dec:	00005597          	auipc	a1,0x5
    80004df0:	a4c58593          	addi	a1,a1,-1460 # 80009838 <syscalls+0x258>
    80004df4:	0521                	addi	a0,a0,8
    80004df6:	ffffc097          	auipc	ra,0xffffc
    80004dfa:	f0c080e7          	jalr	-244(ra) # 80000d02 <initlock>
  lk->name = name;
    80004dfe:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004e02:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004e06:	0204a423          	sw	zero,40(s1)
}
    80004e0a:	60e2                	ld	ra,24(sp)
    80004e0c:	6442                	ld	s0,16(sp)
    80004e0e:	64a2                	ld	s1,8(sp)
    80004e10:	6902                	ld	s2,0(sp)
    80004e12:	6105                	addi	sp,sp,32
    80004e14:	8082                	ret

0000000080004e16 <acquiresleep>:

void acquiresleep(struct sleeplock *lk)
{
    80004e16:	1101                	addi	sp,sp,-32
    80004e18:	ec06                	sd	ra,24(sp)
    80004e1a:	e822                	sd	s0,16(sp)
    80004e1c:	e426                	sd	s1,8(sp)
    80004e1e:	e04a                	sd	s2,0(sp)
    80004e20:	1000                	addi	s0,sp,32
    80004e22:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004e24:	00850913          	addi	s2,a0,8
    80004e28:	854a                	mv	a0,s2
    80004e2a:	ffffc097          	auipc	ra,0xffffc
    80004e2e:	f68080e7          	jalr	-152(ra) # 80000d92 <acquire>
  while (lk->locked)
    80004e32:	409c                	lw	a5,0(s1)
    80004e34:	cb89                	beqz	a5,80004e46 <acquiresleep+0x30>
  {
    sleep(lk, &lk->lk);
    80004e36:	85ca                	mv	a1,s2
    80004e38:	8526                	mv	a0,s1
    80004e3a:	ffffd097          	auipc	ra,0xffffd
    80004e3e:	72c080e7          	jalr	1836(ra) # 80002566 <sleep>
  while (lk->locked)
    80004e42:	409c                	lw	a5,0(s1)
    80004e44:	fbed                	bnez	a5,80004e36 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004e46:	4785                	li	a5,1
    80004e48:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004e4a:	ffffd097          	auipc	ra,0xffffd
    80004e4e:	da4080e7          	jalr	-604(ra) # 80001bee <myproc>
    80004e52:	591c                	lw	a5,48(a0)
    80004e54:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004e56:	854a                	mv	a0,s2
    80004e58:	ffffc097          	auipc	ra,0xffffc
    80004e5c:	fee080e7          	jalr	-18(ra) # 80000e46 <release>
}
    80004e60:	60e2                	ld	ra,24(sp)
    80004e62:	6442                	ld	s0,16(sp)
    80004e64:	64a2                	ld	s1,8(sp)
    80004e66:	6902                	ld	s2,0(sp)
    80004e68:	6105                	addi	sp,sp,32
    80004e6a:	8082                	ret

0000000080004e6c <releasesleep>:

void releasesleep(struct sleeplock *lk)
{
    80004e6c:	1101                	addi	sp,sp,-32
    80004e6e:	ec06                	sd	ra,24(sp)
    80004e70:	e822                	sd	s0,16(sp)
    80004e72:	e426                	sd	s1,8(sp)
    80004e74:	e04a                	sd	s2,0(sp)
    80004e76:	1000                	addi	s0,sp,32
    80004e78:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004e7a:	00850913          	addi	s2,a0,8
    80004e7e:	854a                	mv	a0,s2
    80004e80:	ffffc097          	auipc	ra,0xffffc
    80004e84:	f12080e7          	jalr	-238(ra) # 80000d92 <acquire>
  lk->locked = 0;
    80004e88:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004e8c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004e90:	8526                	mv	a0,s1
    80004e92:	ffffe097          	auipc	ra,0xffffe
    80004e96:	890080e7          	jalr	-1904(ra) # 80002722 <wakeup>
  release(&lk->lk);
    80004e9a:	854a                	mv	a0,s2
    80004e9c:	ffffc097          	auipc	ra,0xffffc
    80004ea0:	faa080e7          	jalr	-86(ra) # 80000e46 <release>
}
    80004ea4:	60e2                	ld	ra,24(sp)
    80004ea6:	6442                	ld	s0,16(sp)
    80004ea8:	64a2                	ld	s1,8(sp)
    80004eaa:	6902                	ld	s2,0(sp)
    80004eac:	6105                	addi	sp,sp,32
    80004eae:	8082                	ret

0000000080004eb0 <holdingsleep>:

int holdingsleep(struct sleeplock *lk)
{
    80004eb0:	7179                	addi	sp,sp,-48
    80004eb2:	f406                	sd	ra,40(sp)
    80004eb4:	f022                	sd	s0,32(sp)
    80004eb6:	ec26                	sd	s1,24(sp)
    80004eb8:	e84a                	sd	s2,16(sp)
    80004eba:	e44e                	sd	s3,8(sp)
    80004ebc:	1800                	addi	s0,sp,48
    80004ebe:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    80004ec0:	00850913          	addi	s2,a0,8
    80004ec4:	854a                	mv	a0,s2
    80004ec6:	ffffc097          	auipc	ra,0xffffc
    80004eca:	ecc080e7          	jalr	-308(ra) # 80000d92 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004ece:	409c                	lw	a5,0(s1)
    80004ed0:	ef99                	bnez	a5,80004eee <holdingsleep+0x3e>
    80004ed2:	4481                	li	s1,0
  release(&lk->lk);
    80004ed4:	854a                	mv	a0,s2
    80004ed6:	ffffc097          	auipc	ra,0xffffc
    80004eda:	f70080e7          	jalr	-144(ra) # 80000e46 <release>
  return r;
}
    80004ede:	8526                	mv	a0,s1
    80004ee0:	70a2                	ld	ra,40(sp)
    80004ee2:	7402                	ld	s0,32(sp)
    80004ee4:	64e2                	ld	s1,24(sp)
    80004ee6:	6942                	ld	s2,16(sp)
    80004ee8:	69a2                	ld	s3,8(sp)
    80004eea:	6145                	addi	sp,sp,48
    80004eec:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004eee:	0284a983          	lw	s3,40(s1)
    80004ef2:	ffffd097          	auipc	ra,0xffffd
    80004ef6:	cfc080e7          	jalr	-772(ra) # 80001bee <myproc>
    80004efa:	5904                	lw	s1,48(a0)
    80004efc:	413484b3          	sub	s1,s1,s3
    80004f00:	0014b493          	seqz	s1,s1
    80004f04:	bfc1                	j	80004ed4 <holdingsleep+0x24>

0000000080004f06 <fileinit>:
  struct spinlock lock;
  struct file file[NFILE];
} ftable;

void fileinit(void)
{
    80004f06:	1141                	addi	sp,sp,-16
    80004f08:	e406                	sd	ra,8(sp)
    80004f0a:	e022                	sd	s0,0(sp)
    80004f0c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004f0e:	00005597          	auipc	a1,0x5
    80004f12:	93a58593          	addi	a1,a1,-1734 # 80009848 <syscalls+0x268>
    80004f16:	0023f517          	auipc	a0,0x23f
    80004f1a:	08a50513          	addi	a0,a0,138 # 80243fa0 <ftable>
    80004f1e:	ffffc097          	auipc	ra,0xffffc
    80004f22:	de4080e7          	jalr	-540(ra) # 80000d02 <initlock>
}
    80004f26:	60a2                	ld	ra,8(sp)
    80004f28:	6402                	ld	s0,0(sp)
    80004f2a:	0141                	addi	sp,sp,16
    80004f2c:	8082                	ret

0000000080004f2e <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    80004f2e:	1101                	addi	sp,sp,-32
    80004f30:	ec06                	sd	ra,24(sp)
    80004f32:	e822                	sd	s0,16(sp)
    80004f34:	e426                	sd	s1,8(sp)
    80004f36:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004f38:	0023f517          	auipc	a0,0x23f
    80004f3c:	06850513          	addi	a0,a0,104 # 80243fa0 <ftable>
    80004f40:	ffffc097          	auipc	ra,0xffffc
    80004f44:	e52080e7          	jalr	-430(ra) # 80000d92 <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++)
    80004f48:	0023f497          	auipc	s1,0x23f
    80004f4c:	07048493          	addi	s1,s1,112 # 80243fb8 <ftable+0x18>
    80004f50:	00240717          	auipc	a4,0x240
    80004f54:	00870713          	addi	a4,a4,8 # 80244f58 <mt>
  {
    if (f->ref == 0)
    80004f58:	40dc                	lw	a5,4(s1)
    80004f5a:	cf99                	beqz	a5,80004f78 <filealloc+0x4a>
  for (f = ftable.file; f < ftable.file + NFILE; f++)
    80004f5c:	02848493          	addi	s1,s1,40
    80004f60:	fee49ce3          	bne	s1,a4,80004f58 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004f64:	0023f517          	auipc	a0,0x23f
    80004f68:	03c50513          	addi	a0,a0,60 # 80243fa0 <ftable>
    80004f6c:	ffffc097          	auipc	ra,0xffffc
    80004f70:	eda080e7          	jalr	-294(ra) # 80000e46 <release>
  return 0;
    80004f74:	4481                	li	s1,0
    80004f76:	a819                	j	80004f8c <filealloc+0x5e>
      f->ref = 1;
    80004f78:	4785                	li	a5,1
    80004f7a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004f7c:	0023f517          	auipc	a0,0x23f
    80004f80:	02450513          	addi	a0,a0,36 # 80243fa0 <ftable>
    80004f84:	ffffc097          	auipc	ra,0xffffc
    80004f88:	ec2080e7          	jalr	-318(ra) # 80000e46 <release>
}
    80004f8c:	8526                	mv	a0,s1
    80004f8e:	60e2                	ld	ra,24(sp)
    80004f90:	6442                	ld	s0,16(sp)
    80004f92:	64a2                	ld	s1,8(sp)
    80004f94:	6105                	addi	sp,sp,32
    80004f96:	8082                	ret

0000000080004f98 <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    80004f98:	1101                	addi	sp,sp,-32
    80004f9a:	ec06                	sd	ra,24(sp)
    80004f9c:	e822                	sd	s0,16(sp)
    80004f9e:	e426                	sd	s1,8(sp)
    80004fa0:	1000                	addi	s0,sp,32
    80004fa2:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004fa4:	0023f517          	auipc	a0,0x23f
    80004fa8:	ffc50513          	addi	a0,a0,-4 # 80243fa0 <ftable>
    80004fac:	ffffc097          	auipc	ra,0xffffc
    80004fb0:	de6080e7          	jalr	-538(ra) # 80000d92 <acquire>
  if (f->ref < 1)
    80004fb4:	40dc                	lw	a5,4(s1)
    80004fb6:	02f05263          	blez	a5,80004fda <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004fba:	2785                	addiw	a5,a5,1
    80004fbc:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004fbe:	0023f517          	auipc	a0,0x23f
    80004fc2:	fe250513          	addi	a0,a0,-30 # 80243fa0 <ftable>
    80004fc6:	ffffc097          	auipc	ra,0xffffc
    80004fca:	e80080e7          	jalr	-384(ra) # 80000e46 <release>
  return f;
}
    80004fce:	8526                	mv	a0,s1
    80004fd0:	60e2                	ld	ra,24(sp)
    80004fd2:	6442                	ld	s0,16(sp)
    80004fd4:	64a2                	ld	s1,8(sp)
    80004fd6:	6105                	addi	sp,sp,32
    80004fd8:	8082                	ret
    panic("filedup");
    80004fda:	00005517          	auipc	a0,0x5
    80004fde:	87650513          	addi	a0,a0,-1930 # 80009850 <syscalls+0x270>
    80004fe2:	ffffb097          	auipc	ra,0xffffb
    80004fe6:	55c080e7          	jalr	1372(ra) # 8000053e <panic>

0000000080004fea <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f)
{
    80004fea:	7139                	addi	sp,sp,-64
    80004fec:	fc06                	sd	ra,56(sp)
    80004fee:	f822                	sd	s0,48(sp)
    80004ff0:	f426                	sd	s1,40(sp)
    80004ff2:	f04a                	sd	s2,32(sp)
    80004ff4:	ec4e                	sd	s3,24(sp)
    80004ff6:	e852                	sd	s4,16(sp)
    80004ff8:	e456                	sd	s5,8(sp)
    80004ffa:	0080                	addi	s0,sp,64
    80004ffc:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004ffe:	0023f517          	auipc	a0,0x23f
    80005002:	fa250513          	addi	a0,a0,-94 # 80243fa0 <ftable>
    80005006:	ffffc097          	auipc	ra,0xffffc
    8000500a:	d8c080e7          	jalr	-628(ra) # 80000d92 <acquire>
  if (f->ref < 1)
    8000500e:	40dc                	lw	a5,4(s1)
    80005010:	06f05163          	blez	a5,80005072 <fileclose+0x88>
    panic("fileclose");
  if (--f->ref > 0)
    80005014:	37fd                	addiw	a5,a5,-1
    80005016:	0007871b          	sext.w	a4,a5
    8000501a:	c0dc                	sw	a5,4(s1)
    8000501c:	06e04363          	bgtz	a4,80005082 <fileclose+0x98>
  {
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80005020:	0004a903          	lw	s2,0(s1)
    80005024:	0094ca83          	lbu	s5,9(s1)
    80005028:	0104ba03          	ld	s4,16(s1)
    8000502c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80005030:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80005034:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80005038:	0023f517          	auipc	a0,0x23f
    8000503c:	f6850513          	addi	a0,a0,-152 # 80243fa0 <ftable>
    80005040:	ffffc097          	auipc	ra,0xffffc
    80005044:	e06080e7          	jalr	-506(ra) # 80000e46 <release>

  if (ff.type == FD_PIPE)
    80005048:	4785                	li	a5,1
    8000504a:	04f90d63          	beq	s2,a5,800050a4 <fileclose+0xba>
  {
    pipeclose(ff.pipe, ff.writable);
  }
  else if (ff.type == FD_INODE || ff.type == FD_DEVICE)
    8000504e:	3979                	addiw	s2,s2,-2
    80005050:	4785                	li	a5,1
    80005052:	0527e063          	bltu	a5,s2,80005092 <fileclose+0xa8>
  {
    begin_op();
    80005056:	00000097          	auipc	ra,0x0
    8000505a:	ac8080e7          	jalr	-1336(ra) # 80004b1e <begin_op>
    iput(ff.ip);
    8000505e:	854e                	mv	a0,s3
    80005060:	fffff097          	auipc	ra,0xfffff
    80005064:	2b6080e7          	jalr	694(ra) # 80004316 <iput>
    end_op();
    80005068:	00000097          	auipc	ra,0x0
    8000506c:	b36080e7          	jalr	-1226(ra) # 80004b9e <end_op>
    80005070:	a00d                	j	80005092 <fileclose+0xa8>
    panic("fileclose");
    80005072:	00004517          	auipc	a0,0x4
    80005076:	7e650513          	addi	a0,a0,2022 # 80009858 <syscalls+0x278>
    8000507a:	ffffb097          	auipc	ra,0xffffb
    8000507e:	4c4080e7          	jalr	1220(ra) # 8000053e <panic>
    release(&ftable.lock);
    80005082:	0023f517          	auipc	a0,0x23f
    80005086:	f1e50513          	addi	a0,a0,-226 # 80243fa0 <ftable>
    8000508a:	ffffc097          	auipc	ra,0xffffc
    8000508e:	dbc080e7          	jalr	-580(ra) # 80000e46 <release>
  }
}
    80005092:	70e2                	ld	ra,56(sp)
    80005094:	7442                	ld	s0,48(sp)
    80005096:	74a2                	ld	s1,40(sp)
    80005098:	7902                	ld	s2,32(sp)
    8000509a:	69e2                	ld	s3,24(sp)
    8000509c:	6a42                	ld	s4,16(sp)
    8000509e:	6aa2                	ld	s5,8(sp)
    800050a0:	6121                	addi	sp,sp,64
    800050a2:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800050a4:	85d6                	mv	a1,s5
    800050a6:	8552                	mv	a0,s4
    800050a8:	00000097          	auipc	ra,0x0
    800050ac:	34c080e7          	jalr	844(ra) # 800053f4 <pipeclose>
    800050b0:	b7cd                	j	80005092 <fileclose+0xa8>

00000000800050b2 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr)
{
    800050b2:	715d                	addi	sp,sp,-80
    800050b4:	e486                	sd	ra,72(sp)
    800050b6:	e0a2                	sd	s0,64(sp)
    800050b8:	fc26                	sd	s1,56(sp)
    800050ba:	f84a                	sd	s2,48(sp)
    800050bc:	f44e                	sd	s3,40(sp)
    800050be:	0880                	addi	s0,sp,80
    800050c0:	84aa                	mv	s1,a0
    800050c2:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800050c4:	ffffd097          	auipc	ra,0xffffd
    800050c8:	b2a080e7          	jalr	-1238(ra) # 80001bee <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE)
    800050cc:	409c                	lw	a5,0(s1)
    800050ce:	37f9                	addiw	a5,a5,-2
    800050d0:	4705                	li	a4,1
    800050d2:	04f76763          	bltu	a4,a5,80005120 <filestat+0x6e>
    800050d6:	892a                	mv	s2,a0
  {
    ilock(f->ip);
    800050d8:	6c88                	ld	a0,24(s1)
    800050da:	fffff097          	auipc	ra,0xfffff
    800050de:	082080e7          	jalr	130(ra) # 8000415c <ilock>
    stati(f->ip, &st);
    800050e2:	fb840593          	addi	a1,s0,-72
    800050e6:	6c88                	ld	a0,24(s1)
    800050e8:	fffff097          	auipc	ra,0xfffff
    800050ec:	2fe080e7          	jalr	766(ra) # 800043e6 <stati>
    iunlock(f->ip);
    800050f0:	6c88                	ld	a0,24(s1)
    800050f2:	fffff097          	auipc	ra,0xfffff
    800050f6:	12c080e7          	jalr	300(ra) # 8000421e <iunlock>
    if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800050fa:	46e1                	li	a3,24
    800050fc:	fb840613          	addi	a2,s0,-72
    80005100:	85ce                	mv	a1,s3
    80005102:	05093503          	ld	a0,80(s2)
    80005106:	ffffc097          	auipc	ra,0xffffc
    8000510a:	73c080e7          	jalr	1852(ra) # 80001842 <copyout>
    8000510e:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80005112:	60a6                	ld	ra,72(sp)
    80005114:	6406                	ld	s0,64(sp)
    80005116:	74e2                	ld	s1,56(sp)
    80005118:	7942                	ld	s2,48(sp)
    8000511a:	79a2                	ld	s3,40(sp)
    8000511c:	6161                	addi	sp,sp,80
    8000511e:	8082                	ret
  return -1;
    80005120:	557d                	li	a0,-1
    80005122:	bfc5                	j	80005112 <filestat+0x60>

0000000080005124 <fileread>:

// Read from file f.
// addr is a user virtual address.
int fileread(struct file *f, uint64 addr, int n)
{
    80005124:	7179                	addi	sp,sp,-48
    80005126:	f406                	sd	ra,40(sp)
    80005128:	f022                	sd	s0,32(sp)
    8000512a:	ec26                	sd	s1,24(sp)
    8000512c:	e84a                	sd	s2,16(sp)
    8000512e:	e44e                	sd	s3,8(sp)
    80005130:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0)
    80005132:	00854783          	lbu	a5,8(a0)
    80005136:	c3d5                	beqz	a5,800051da <fileread+0xb6>
    80005138:	84aa                	mv	s1,a0
    8000513a:	89ae                	mv	s3,a1
    8000513c:	8932                	mv	s2,a2
    return -1;

  if (f->type == FD_PIPE)
    8000513e:	411c                	lw	a5,0(a0)
    80005140:	4705                	li	a4,1
    80005142:	04e78963          	beq	a5,a4,80005194 <fileread+0x70>
  {
    r = piperead(f->pipe, addr, n);
  }
  else if (f->type == FD_DEVICE)
    80005146:	470d                	li	a4,3
    80005148:	04e78d63          	beq	a5,a4,800051a2 <fileread+0x7e>
  {
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  }
  else if (f->type == FD_INODE)
    8000514c:	4709                	li	a4,2
    8000514e:	06e79e63          	bne	a5,a4,800051ca <fileread+0xa6>
  {
    ilock(f->ip);
    80005152:	6d08                	ld	a0,24(a0)
    80005154:	fffff097          	auipc	ra,0xfffff
    80005158:	008080e7          	jalr	8(ra) # 8000415c <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000515c:	874a                	mv	a4,s2
    8000515e:	5094                	lw	a3,32(s1)
    80005160:	864e                	mv	a2,s3
    80005162:	4585                	li	a1,1
    80005164:	6c88                	ld	a0,24(s1)
    80005166:	fffff097          	auipc	ra,0xfffff
    8000516a:	2aa080e7          	jalr	682(ra) # 80004410 <readi>
    8000516e:	892a                	mv	s2,a0
    80005170:	00a05563          	blez	a0,8000517a <fileread+0x56>
      f->off += r;
    80005174:	509c                	lw	a5,32(s1)
    80005176:	9fa9                	addw	a5,a5,a0
    80005178:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000517a:	6c88                	ld	a0,24(s1)
    8000517c:	fffff097          	auipc	ra,0xfffff
    80005180:	0a2080e7          	jalr	162(ra) # 8000421e <iunlock>
  {
    panic("fileread");
  }

  return r;
}
    80005184:	854a                	mv	a0,s2
    80005186:	70a2                	ld	ra,40(sp)
    80005188:	7402                	ld	s0,32(sp)
    8000518a:	64e2                	ld	s1,24(sp)
    8000518c:	6942                	ld	s2,16(sp)
    8000518e:	69a2                	ld	s3,8(sp)
    80005190:	6145                	addi	sp,sp,48
    80005192:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80005194:	6908                	ld	a0,16(a0)
    80005196:	00000097          	auipc	ra,0x0
    8000519a:	3c6080e7          	jalr	966(ra) # 8000555c <piperead>
    8000519e:	892a                	mv	s2,a0
    800051a0:	b7d5                	j	80005184 <fileread+0x60>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800051a2:	02451783          	lh	a5,36(a0)
    800051a6:	03079693          	slli	a3,a5,0x30
    800051aa:	92c1                	srli	a3,a3,0x30
    800051ac:	4725                	li	a4,9
    800051ae:	02d76863          	bltu	a4,a3,800051de <fileread+0xba>
    800051b2:	0792                	slli	a5,a5,0x4
    800051b4:	0023f717          	auipc	a4,0x23f
    800051b8:	d4c70713          	addi	a4,a4,-692 # 80243f00 <devsw>
    800051bc:	97ba                	add	a5,a5,a4
    800051be:	639c                	ld	a5,0(a5)
    800051c0:	c38d                	beqz	a5,800051e2 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800051c2:	4505                	li	a0,1
    800051c4:	9782                	jalr	a5
    800051c6:	892a                	mv	s2,a0
    800051c8:	bf75                	j	80005184 <fileread+0x60>
    panic("fileread");
    800051ca:	00004517          	auipc	a0,0x4
    800051ce:	69e50513          	addi	a0,a0,1694 # 80009868 <syscalls+0x288>
    800051d2:	ffffb097          	auipc	ra,0xffffb
    800051d6:	36c080e7          	jalr	876(ra) # 8000053e <panic>
    return -1;
    800051da:	597d                	li	s2,-1
    800051dc:	b765                	j	80005184 <fileread+0x60>
      return -1;
    800051de:	597d                	li	s2,-1
    800051e0:	b755                	j	80005184 <fileread+0x60>
    800051e2:	597d                	li	s2,-1
    800051e4:	b745                	j	80005184 <fileread+0x60>

00000000800051e6 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int filewrite(struct file *f, uint64 addr, int n)
{
    800051e6:	715d                	addi	sp,sp,-80
    800051e8:	e486                	sd	ra,72(sp)
    800051ea:	e0a2                	sd	s0,64(sp)
    800051ec:	fc26                	sd	s1,56(sp)
    800051ee:	f84a                	sd	s2,48(sp)
    800051f0:	f44e                	sd	s3,40(sp)
    800051f2:	f052                	sd	s4,32(sp)
    800051f4:	ec56                	sd	s5,24(sp)
    800051f6:	e85a                	sd	s6,16(sp)
    800051f8:	e45e                	sd	s7,8(sp)
    800051fa:	e062                	sd	s8,0(sp)
    800051fc:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if (f->writable == 0)
    800051fe:	00954783          	lbu	a5,9(a0)
    80005202:	10078663          	beqz	a5,8000530e <filewrite+0x128>
    80005206:	892a                	mv	s2,a0
    80005208:	8aae                	mv	s5,a1
    8000520a:	8a32                	mv	s4,a2
    return -1;

  if (f->type == FD_PIPE)
    8000520c:	411c                	lw	a5,0(a0)
    8000520e:	4705                	li	a4,1
    80005210:	02e78263          	beq	a5,a4,80005234 <filewrite+0x4e>
  {
    ret = pipewrite(f->pipe, addr, n);
  }
  else if (f->type == FD_DEVICE)
    80005214:	470d                	li	a4,3
    80005216:	02e78663          	beq	a5,a4,80005242 <filewrite+0x5c>
  {
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  }
  else if (f->type == FD_INODE)
    8000521a:	4709                	li	a4,2
    8000521c:	0ee79163          	bne	a5,a4,800052fe <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n)
    80005220:	0ac05d63          	blez	a2,800052da <filewrite+0xf4>
    int i = 0;
    80005224:	4981                	li	s3,0
    80005226:	6b05                	lui	s6,0x1
    80005228:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    8000522c:	6b85                	lui	s7,0x1
    8000522e:	c00b8b9b          	addiw	s7,s7,-1024
    80005232:	a861                	j	800052ca <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80005234:	6908                	ld	a0,16(a0)
    80005236:	00000097          	auipc	ra,0x0
    8000523a:	22e080e7          	jalr	558(ra) # 80005464 <pipewrite>
    8000523e:	8a2a                	mv	s4,a0
    80005240:	a045                	j	800052e0 <filewrite+0xfa>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80005242:	02451783          	lh	a5,36(a0)
    80005246:	03079693          	slli	a3,a5,0x30
    8000524a:	92c1                	srli	a3,a3,0x30
    8000524c:	4725                	li	a4,9
    8000524e:	0cd76263          	bltu	a4,a3,80005312 <filewrite+0x12c>
    80005252:	0792                	slli	a5,a5,0x4
    80005254:	0023f717          	auipc	a4,0x23f
    80005258:	cac70713          	addi	a4,a4,-852 # 80243f00 <devsw>
    8000525c:	97ba                	add	a5,a5,a4
    8000525e:	679c                	ld	a5,8(a5)
    80005260:	cbdd                	beqz	a5,80005316 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80005262:	4505                	li	a0,1
    80005264:	9782                	jalr	a5
    80005266:	8a2a                	mv	s4,a0
    80005268:	a8a5                	j	800052e0 <filewrite+0xfa>
    8000526a:	00048c1b          	sext.w	s8,s1
    {
      int n1 = n - i;
      if (n1 > max)
        n1 = max;

      begin_op();
    8000526e:	00000097          	auipc	ra,0x0
    80005272:	8b0080e7          	jalr	-1872(ra) # 80004b1e <begin_op>
      ilock(f->ip);
    80005276:	01893503          	ld	a0,24(s2)
    8000527a:	fffff097          	auipc	ra,0xfffff
    8000527e:	ee2080e7          	jalr	-286(ra) # 8000415c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80005282:	8762                	mv	a4,s8
    80005284:	02092683          	lw	a3,32(s2)
    80005288:	01598633          	add	a2,s3,s5
    8000528c:	4585                	li	a1,1
    8000528e:	01893503          	ld	a0,24(s2)
    80005292:	fffff097          	auipc	ra,0xfffff
    80005296:	276080e7          	jalr	630(ra) # 80004508 <writei>
    8000529a:	84aa                	mv	s1,a0
    8000529c:	00a05763          	blez	a0,800052aa <filewrite+0xc4>
        f->off += r;
    800052a0:	02092783          	lw	a5,32(s2)
    800052a4:	9fa9                	addw	a5,a5,a0
    800052a6:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800052aa:	01893503          	ld	a0,24(s2)
    800052ae:	fffff097          	auipc	ra,0xfffff
    800052b2:	f70080e7          	jalr	-144(ra) # 8000421e <iunlock>
      end_op();
    800052b6:	00000097          	auipc	ra,0x0
    800052ba:	8e8080e7          	jalr	-1816(ra) # 80004b9e <end_op>

      if (r != n1)
    800052be:	009c1f63          	bne	s8,s1,800052dc <filewrite+0xf6>
      {
        // error from writei
        break;
      }
      i += r;
    800052c2:	013489bb          	addw	s3,s1,s3
    while (i < n)
    800052c6:	0149db63          	bge	s3,s4,800052dc <filewrite+0xf6>
      int n1 = n - i;
    800052ca:	413a07bb          	subw	a5,s4,s3
      if (n1 > max)
    800052ce:	84be                	mv	s1,a5
    800052d0:	2781                	sext.w	a5,a5
    800052d2:	f8fb5ce3          	bge	s6,a5,8000526a <filewrite+0x84>
    800052d6:	84de                	mv	s1,s7
    800052d8:	bf49                	j	8000526a <filewrite+0x84>
    int i = 0;
    800052da:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    800052dc:	013a1f63          	bne	s4,s3,800052fa <filewrite+0x114>
  {
    panic("filewrite");
  }

  return ret;
}
    800052e0:	8552                	mv	a0,s4
    800052e2:	60a6                	ld	ra,72(sp)
    800052e4:	6406                	ld	s0,64(sp)
    800052e6:	74e2                	ld	s1,56(sp)
    800052e8:	7942                	ld	s2,48(sp)
    800052ea:	79a2                	ld	s3,40(sp)
    800052ec:	7a02                	ld	s4,32(sp)
    800052ee:	6ae2                	ld	s5,24(sp)
    800052f0:	6b42                	ld	s6,16(sp)
    800052f2:	6ba2                	ld	s7,8(sp)
    800052f4:	6c02                	ld	s8,0(sp)
    800052f6:	6161                	addi	sp,sp,80
    800052f8:	8082                	ret
    ret = (i == n ? n : -1);
    800052fa:	5a7d                	li	s4,-1
    800052fc:	b7d5                	j	800052e0 <filewrite+0xfa>
    panic("filewrite");
    800052fe:	00004517          	auipc	a0,0x4
    80005302:	57a50513          	addi	a0,a0,1402 # 80009878 <syscalls+0x298>
    80005306:	ffffb097          	auipc	ra,0xffffb
    8000530a:	238080e7          	jalr	568(ra) # 8000053e <panic>
    return -1;
    8000530e:	5a7d                	li	s4,-1
    80005310:	bfc1                	j	800052e0 <filewrite+0xfa>
      return -1;
    80005312:	5a7d                	li	s4,-1
    80005314:	b7f1                	j	800052e0 <filewrite+0xfa>
    80005316:	5a7d                	li	s4,-1
    80005318:	b7e1                	j	800052e0 <filewrite+0xfa>

000000008000531a <pipealloc>:
  int readopen;  // read fd is still open
  int writeopen; // write fd is still open
};

int pipealloc(struct file **f0, struct file **f1)
{
    8000531a:	7179                	addi	sp,sp,-48
    8000531c:	f406                	sd	ra,40(sp)
    8000531e:	f022                	sd	s0,32(sp)
    80005320:	ec26                	sd	s1,24(sp)
    80005322:	e84a                	sd	s2,16(sp)
    80005324:	e44e                	sd	s3,8(sp)
    80005326:	e052                	sd	s4,0(sp)
    80005328:	1800                	addi	s0,sp,48
    8000532a:	84aa                	mv	s1,a0
    8000532c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000532e:	0005b023          	sd	zero,0(a1)
    80005332:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80005336:	00000097          	auipc	ra,0x0
    8000533a:	bf8080e7          	jalr	-1032(ra) # 80004f2e <filealloc>
    8000533e:	e088                	sd	a0,0(s1)
    80005340:	c551                	beqz	a0,800053cc <pipealloc+0xb2>
    80005342:	00000097          	auipc	ra,0x0
    80005346:	bec080e7          	jalr	-1044(ra) # 80004f2e <filealloc>
    8000534a:	00aa3023          	sd	a0,0(s4)
    8000534e:	c92d                	beqz	a0,800053c0 <pipealloc+0xa6>
    goto bad;
  if ((pi = (struct pipe *)kalloc()) == 0)
    80005350:	ffffc097          	auipc	ra,0xffffc
    80005354:	8fe080e7          	jalr	-1794(ra) # 80000c4e <kalloc>
    80005358:	892a                	mv	s2,a0
    8000535a:	c125                	beqz	a0,800053ba <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000535c:	4985                	li	s3,1
    8000535e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80005362:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80005366:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000536a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000536e:	00004597          	auipc	a1,0x4
    80005372:	19258593          	addi	a1,a1,402 # 80009500 <states.0+0x1c0>
    80005376:	ffffc097          	auipc	ra,0xffffc
    8000537a:	98c080e7          	jalr	-1652(ra) # 80000d02 <initlock>
  (*f0)->type = FD_PIPE;
    8000537e:	609c                	ld	a5,0(s1)
    80005380:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80005384:	609c                	ld	a5,0(s1)
    80005386:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000538a:	609c                	ld	a5,0(s1)
    8000538c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80005390:	609c                	ld	a5,0(s1)
    80005392:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80005396:	000a3783          	ld	a5,0(s4)
    8000539a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000539e:	000a3783          	ld	a5,0(s4)
    800053a2:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800053a6:	000a3783          	ld	a5,0(s4)
    800053aa:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800053ae:	000a3783          	ld	a5,0(s4)
    800053b2:	0127b823          	sd	s2,16(a5)
  return 0;
    800053b6:	4501                	li	a0,0
    800053b8:	a025                	j	800053e0 <pipealloc+0xc6>

bad:
  if (pi)
    kfree((char *)pi);
  if (*f0)
    800053ba:	6088                	ld	a0,0(s1)
    800053bc:	e501                	bnez	a0,800053c4 <pipealloc+0xaa>
    800053be:	a039                	j	800053cc <pipealloc+0xb2>
    800053c0:	6088                	ld	a0,0(s1)
    800053c2:	c51d                	beqz	a0,800053f0 <pipealloc+0xd6>
    fileclose(*f0);
    800053c4:	00000097          	auipc	ra,0x0
    800053c8:	c26080e7          	jalr	-986(ra) # 80004fea <fileclose>
  if (*f1)
    800053cc:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800053d0:	557d                	li	a0,-1
  if (*f1)
    800053d2:	c799                	beqz	a5,800053e0 <pipealloc+0xc6>
    fileclose(*f1);
    800053d4:	853e                	mv	a0,a5
    800053d6:	00000097          	auipc	ra,0x0
    800053da:	c14080e7          	jalr	-1004(ra) # 80004fea <fileclose>
  return -1;
    800053de:	557d                	li	a0,-1
}
    800053e0:	70a2                	ld	ra,40(sp)
    800053e2:	7402                	ld	s0,32(sp)
    800053e4:	64e2                	ld	s1,24(sp)
    800053e6:	6942                	ld	s2,16(sp)
    800053e8:	69a2                	ld	s3,8(sp)
    800053ea:	6a02                	ld	s4,0(sp)
    800053ec:	6145                	addi	sp,sp,48
    800053ee:	8082                	ret
  return -1;
    800053f0:	557d                	li	a0,-1
    800053f2:	b7fd                	j	800053e0 <pipealloc+0xc6>

00000000800053f4 <pipeclose>:

void pipeclose(struct pipe *pi, int writable)
{
    800053f4:	1101                	addi	sp,sp,-32
    800053f6:	ec06                	sd	ra,24(sp)
    800053f8:	e822                	sd	s0,16(sp)
    800053fa:	e426                	sd	s1,8(sp)
    800053fc:	e04a                	sd	s2,0(sp)
    800053fe:	1000                	addi	s0,sp,32
    80005400:	84aa                	mv	s1,a0
    80005402:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005404:	ffffc097          	auipc	ra,0xffffc
    80005408:	98e080e7          	jalr	-1650(ra) # 80000d92 <acquire>
  if (writable)
    8000540c:	02090d63          	beqz	s2,80005446 <pipeclose+0x52>
  {
    pi->writeopen = 0;
    80005410:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005414:	21848513          	addi	a0,s1,536
    80005418:	ffffd097          	auipc	ra,0xffffd
    8000541c:	30a080e7          	jalr	778(ra) # 80002722 <wakeup>
  else
  {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0)
    80005420:	2204b783          	ld	a5,544(s1)
    80005424:	eb95                	bnez	a5,80005458 <pipeclose+0x64>
  {
    release(&pi->lock);
    80005426:	8526                	mv	a0,s1
    80005428:	ffffc097          	auipc	ra,0xffffc
    8000542c:	a1e080e7          	jalr	-1506(ra) # 80000e46 <release>
    kfree((char *)pi);
    80005430:	8526                	mv	a0,s1
    80005432:	ffffb097          	auipc	ra,0xffffb
    80005436:	644080e7          	jalr	1604(ra) # 80000a76 <kfree>
  }
  else
    release(&pi->lock);
}
    8000543a:	60e2                	ld	ra,24(sp)
    8000543c:	6442                	ld	s0,16(sp)
    8000543e:	64a2                	ld	s1,8(sp)
    80005440:	6902                	ld	s2,0(sp)
    80005442:	6105                	addi	sp,sp,32
    80005444:	8082                	ret
    pi->readopen = 0;
    80005446:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000544a:	21c48513          	addi	a0,s1,540
    8000544e:	ffffd097          	auipc	ra,0xffffd
    80005452:	2d4080e7          	jalr	724(ra) # 80002722 <wakeup>
    80005456:	b7e9                	j	80005420 <pipeclose+0x2c>
    release(&pi->lock);
    80005458:	8526                	mv	a0,s1
    8000545a:	ffffc097          	auipc	ra,0xffffc
    8000545e:	9ec080e7          	jalr	-1556(ra) # 80000e46 <release>
}
    80005462:	bfe1                	j	8000543a <pipeclose+0x46>

0000000080005464 <pipewrite>:

int pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005464:	711d                	addi	sp,sp,-96
    80005466:	ec86                	sd	ra,88(sp)
    80005468:	e8a2                	sd	s0,80(sp)
    8000546a:	e4a6                	sd	s1,72(sp)
    8000546c:	e0ca                	sd	s2,64(sp)
    8000546e:	fc4e                	sd	s3,56(sp)
    80005470:	f852                	sd	s4,48(sp)
    80005472:	f456                	sd	s5,40(sp)
    80005474:	f05a                	sd	s6,32(sp)
    80005476:	ec5e                	sd	s7,24(sp)
    80005478:	e862                	sd	s8,16(sp)
    8000547a:	1080                	addi	s0,sp,96
    8000547c:	84aa                	mv	s1,a0
    8000547e:	8aae                	mv	s5,a1
    80005480:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80005482:	ffffc097          	auipc	ra,0xffffc
    80005486:	76c080e7          	jalr	1900(ra) # 80001bee <myproc>
    8000548a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000548c:	8526                	mv	a0,s1
    8000548e:	ffffc097          	auipc	ra,0xffffc
    80005492:	904080e7          	jalr	-1788(ra) # 80000d92 <acquire>
  while (i < n)
    80005496:	0b405663          	blez	s4,80005542 <pipewrite+0xde>
  int i = 0;
    8000549a:	4901                	li	s2,0
      sleep(&pi->nwrite, &pi->lock);
    }
    else
    {
      char ch;
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000549c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000549e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800054a2:	21c48b93          	addi	s7,s1,540
    800054a6:	a089                	j	800054e8 <pipewrite+0x84>
      release(&pi->lock);
    800054a8:	8526                	mv	a0,s1
    800054aa:	ffffc097          	auipc	ra,0xffffc
    800054ae:	99c080e7          	jalr	-1636(ra) # 80000e46 <release>
      return -1;
    800054b2:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800054b4:	854a                	mv	a0,s2
    800054b6:	60e6                	ld	ra,88(sp)
    800054b8:	6446                	ld	s0,80(sp)
    800054ba:	64a6                	ld	s1,72(sp)
    800054bc:	6906                	ld	s2,64(sp)
    800054be:	79e2                	ld	s3,56(sp)
    800054c0:	7a42                	ld	s4,48(sp)
    800054c2:	7aa2                	ld	s5,40(sp)
    800054c4:	7b02                	ld	s6,32(sp)
    800054c6:	6be2                	ld	s7,24(sp)
    800054c8:	6c42                	ld	s8,16(sp)
    800054ca:	6125                	addi	sp,sp,96
    800054cc:	8082                	ret
      wakeup(&pi->nread);
    800054ce:	8562                	mv	a0,s8
    800054d0:	ffffd097          	auipc	ra,0xffffd
    800054d4:	252080e7          	jalr	594(ra) # 80002722 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800054d8:	85a6                	mv	a1,s1
    800054da:	855e                	mv	a0,s7
    800054dc:	ffffd097          	auipc	ra,0xffffd
    800054e0:	08a080e7          	jalr	138(ra) # 80002566 <sleep>
  while (i < n)
    800054e4:	07495063          	bge	s2,s4,80005544 <pipewrite+0xe0>
    if (pi->readopen == 0 || killed(pr))
    800054e8:	2204a783          	lw	a5,544(s1)
    800054ec:	dfd5                	beqz	a5,800054a8 <pipewrite+0x44>
    800054ee:	854e                	mv	a0,s3
    800054f0:	ffffd097          	auipc	ra,0xffffd
    800054f4:	4a2080e7          	jalr	1186(ra) # 80002992 <killed>
    800054f8:	f945                	bnez	a0,800054a8 <pipewrite+0x44>
    if (pi->nwrite == pi->nread + PIPESIZE)
    800054fa:	2184a783          	lw	a5,536(s1)
    800054fe:	21c4a703          	lw	a4,540(s1)
    80005502:	2007879b          	addiw	a5,a5,512
    80005506:	fcf704e3          	beq	a4,a5,800054ce <pipewrite+0x6a>
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000550a:	4685                	li	a3,1
    8000550c:	01590633          	add	a2,s2,s5
    80005510:	faf40593          	addi	a1,s0,-81
    80005514:	0509b503          	ld	a0,80(s3)
    80005518:	ffffc097          	auipc	ra,0xffffc
    8000551c:	3f2080e7          	jalr	1010(ra) # 8000190a <copyin>
    80005520:	03650263          	beq	a0,s6,80005544 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005524:	21c4a783          	lw	a5,540(s1)
    80005528:	0017871b          	addiw	a4,a5,1
    8000552c:	20e4ae23          	sw	a4,540(s1)
    80005530:	1ff7f793          	andi	a5,a5,511
    80005534:	97a6                	add	a5,a5,s1
    80005536:	faf44703          	lbu	a4,-81(s0)
    8000553a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000553e:	2905                	addiw	s2,s2,1
    80005540:	b755                	j	800054e4 <pipewrite+0x80>
  int i = 0;
    80005542:	4901                	li	s2,0
  wakeup(&pi->nread);
    80005544:	21848513          	addi	a0,s1,536
    80005548:	ffffd097          	auipc	ra,0xffffd
    8000554c:	1da080e7          	jalr	474(ra) # 80002722 <wakeup>
  release(&pi->lock);
    80005550:	8526                	mv	a0,s1
    80005552:	ffffc097          	auipc	ra,0xffffc
    80005556:	8f4080e7          	jalr	-1804(ra) # 80000e46 <release>
  return i;
    8000555a:	bfa9                	j	800054b4 <pipewrite+0x50>

000000008000555c <piperead>:

int piperead(struct pipe *pi, uint64 addr, int n)
{
    8000555c:	715d                	addi	sp,sp,-80
    8000555e:	e486                	sd	ra,72(sp)
    80005560:	e0a2                	sd	s0,64(sp)
    80005562:	fc26                	sd	s1,56(sp)
    80005564:	f84a                	sd	s2,48(sp)
    80005566:	f44e                	sd	s3,40(sp)
    80005568:	f052                	sd	s4,32(sp)
    8000556a:	ec56                	sd	s5,24(sp)
    8000556c:	e85a                	sd	s6,16(sp)
    8000556e:	0880                	addi	s0,sp,80
    80005570:	84aa                	mv	s1,a0
    80005572:	892e                	mv	s2,a1
    80005574:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80005576:	ffffc097          	auipc	ra,0xffffc
    8000557a:	678080e7          	jalr	1656(ra) # 80001bee <myproc>
    8000557e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80005580:	8526                	mv	a0,s1
    80005582:	ffffc097          	auipc	ra,0xffffc
    80005586:	810080e7          	jalr	-2032(ra) # 80000d92 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen)
    8000558a:	2184a703          	lw	a4,536(s1)
    8000558e:	21c4a783          	lw	a5,540(s1)
    if (killed(pr))
    {
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); // DOC: piperead-sleep
    80005592:	21848993          	addi	s3,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen)
    80005596:	02f71763          	bne	a4,a5,800055c4 <piperead+0x68>
    8000559a:	2244a783          	lw	a5,548(s1)
    8000559e:	c39d                	beqz	a5,800055c4 <piperead+0x68>
    if (killed(pr))
    800055a0:	8552                	mv	a0,s4
    800055a2:	ffffd097          	auipc	ra,0xffffd
    800055a6:	3f0080e7          	jalr	1008(ra) # 80002992 <killed>
    800055aa:	e941                	bnez	a0,8000563a <piperead+0xde>
    sleep(&pi->nread, &pi->lock); // DOC: piperead-sleep
    800055ac:	85a6                	mv	a1,s1
    800055ae:	854e                	mv	a0,s3
    800055b0:	ffffd097          	auipc	ra,0xffffd
    800055b4:	fb6080e7          	jalr	-74(ra) # 80002566 <sleep>
  while (pi->nread == pi->nwrite && pi->writeopen)
    800055b8:	2184a703          	lw	a4,536(s1)
    800055bc:	21c4a783          	lw	a5,540(s1)
    800055c0:	fcf70de3          	beq	a4,a5,8000559a <piperead+0x3e>
  }
  for (i = 0; i < n; i++)
    800055c4:	4981                	li	s3,0
  { // DOC: piperead-copy
    if (pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800055c6:	5b7d                	li	s6,-1
  for (i = 0; i < n; i++)
    800055c8:	05505363          	blez	s5,8000560e <piperead+0xb2>
    if (pi->nread == pi->nwrite)
    800055cc:	2184a783          	lw	a5,536(s1)
    800055d0:	21c4a703          	lw	a4,540(s1)
    800055d4:	02f70d63          	beq	a4,a5,8000560e <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800055d8:	0017871b          	addiw	a4,a5,1
    800055dc:	20e4ac23          	sw	a4,536(s1)
    800055e0:	1ff7f793          	andi	a5,a5,511
    800055e4:	97a6                	add	a5,a5,s1
    800055e6:	0187c783          	lbu	a5,24(a5)
    800055ea:	faf40fa3          	sb	a5,-65(s0)
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800055ee:	4685                	li	a3,1
    800055f0:	fbf40613          	addi	a2,s0,-65
    800055f4:	85ca                	mv	a1,s2
    800055f6:	050a3503          	ld	a0,80(s4)
    800055fa:	ffffc097          	auipc	ra,0xffffc
    800055fe:	248080e7          	jalr	584(ra) # 80001842 <copyout>
    80005602:	01650663          	beq	a0,s6,8000560e <piperead+0xb2>
  for (i = 0; i < n; i++)
    80005606:	2985                	addiw	s3,s3,1
    80005608:	0905                	addi	s2,s2,1
    8000560a:	fd3a91e3          	bne	s5,s3,800055cc <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite); // DOC: piperead-wakeup
    8000560e:	21c48513          	addi	a0,s1,540
    80005612:	ffffd097          	auipc	ra,0xffffd
    80005616:	110080e7          	jalr	272(ra) # 80002722 <wakeup>
  release(&pi->lock);
    8000561a:	8526                	mv	a0,s1
    8000561c:	ffffc097          	auipc	ra,0xffffc
    80005620:	82a080e7          	jalr	-2006(ra) # 80000e46 <release>
  return i;
}
    80005624:	854e                	mv	a0,s3
    80005626:	60a6                	ld	ra,72(sp)
    80005628:	6406                	ld	s0,64(sp)
    8000562a:	74e2                	ld	s1,56(sp)
    8000562c:	7942                	ld	s2,48(sp)
    8000562e:	79a2                	ld	s3,40(sp)
    80005630:	7a02                	ld	s4,32(sp)
    80005632:	6ae2                	ld	s5,24(sp)
    80005634:	6b42                	ld	s6,16(sp)
    80005636:	6161                	addi	sp,sp,80
    80005638:	8082                	ret
      release(&pi->lock);
    8000563a:	8526                	mv	a0,s1
    8000563c:	ffffc097          	auipc	ra,0xffffc
    80005640:	80a080e7          	jalr	-2038(ra) # 80000e46 <release>
      return -1;
    80005644:	59fd                	li	s3,-1
    80005646:	bff9                	j	80005624 <piperead+0xc8>

0000000080005648 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80005648:	1141                	addi	sp,sp,-16
    8000564a:	e422                	sd	s0,8(sp)
    8000564c:	0800                	addi	s0,sp,16
    8000564e:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1)
    80005650:	8905                	andi	a0,a0,1
    80005652:	c111                	beqz	a0,80005656 <flags2perm+0xe>
    perm = PTE_X;
    80005654:	4521                	li	a0,8
  if (flags & 0x2)
    80005656:	8b89                	andi	a5,a5,2
    80005658:	c399                	beqz	a5,8000565e <flags2perm+0x16>
    perm |= PTE_W;
    8000565a:	00456513          	ori	a0,a0,4
  return perm;
}
    8000565e:	6422                	ld	s0,8(sp)
    80005660:	0141                	addi	sp,sp,16
    80005662:	8082                	ret

0000000080005664 <exec>:

int exec(char *path, char **argv)
{
    80005664:	de010113          	addi	sp,sp,-544
    80005668:	20113c23          	sd	ra,536(sp)
    8000566c:	20813823          	sd	s0,528(sp)
    80005670:	20913423          	sd	s1,520(sp)
    80005674:	21213023          	sd	s2,512(sp)
    80005678:	ffce                	sd	s3,504(sp)
    8000567a:	fbd2                	sd	s4,496(sp)
    8000567c:	f7d6                	sd	s5,488(sp)
    8000567e:	f3da                	sd	s6,480(sp)
    80005680:	efde                	sd	s7,472(sp)
    80005682:	ebe2                	sd	s8,464(sp)
    80005684:	e7e6                	sd	s9,456(sp)
    80005686:	e3ea                	sd	s10,448(sp)
    80005688:	ff6e                	sd	s11,440(sp)
    8000568a:	1400                	addi	s0,sp,544
    8000568c:	892a                	mv	s2,a0
    8000568e:	dea43423          	sd	a0,-536(s0)
    80005692:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005696:	ffffc097          	auipc	ra,0xffffc
    8000569a:	558080e7          	jalr	1368(ra) # 80001bee <myproc>
    8000569e:	84aa                	mv	s1,a0

  begin_op();
    800056a0:	fffff097          	auipc	ra,0xfffff
    800056a4:	47e080e7          	jalr	1150(ra) # 80004b1e <begin_op>

  if ((ip = namei(path)) == 0)
    800056a8:	854a                	mv	a0,s2
    800056aa:	fffff097          	auipc	ra,0xfffff
    800056ae:	258080e7          	jalr	600(ra) # 80004902 <namei>
    800056b2:	c93d                	beqz	a0,80005728 <exec+0xc4>
    800056b4:	8aaa                	mv	s5,a0
  {
    end_op();
    return -1;
  }
  ilock(ip);
    800056b6:	fffff097          	auipc	ra,0xfffff
    800056ba:	aa6080e7          	jalr	-1370(ra) # 8000415c <ilock>

  // Check ELF header
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800056be:	04000713          	li	a4,64
    800056c2:	4681                	li	a3,0
    800056c4:	e5040613          	addi	a2,s0,-432
    800056c8:	4581                	li	a1,0
    800056ca:	8556                	mv	a0,s5
    800056cc:	fffff097          	auipc	ra,0xfffff
    800056d0:	d44080e7          	jalr	-700(ra) # 80004410 <readi>
    800056d4:	04000793          	li	a5,64
    800056d8:	00f51a63          	bne	a0,a5,800056ec <exec+0x88>
    goto bad;

  if (elf.magic != ELF_MAGIC)
    800056dc:	e5042703          	lw	a4,-432(s0)
    800056e0:	464c47b7          	lui	a5,0x464c4
    800056e4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800056e8:	04f70663          	beq	a4,a5,80005734 <exec+0xd0>
bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip)
  {
    iunlockput(ip);
    800056ec:	8556                	mv	a0,s5
    800056ee:	fffff097          	auipc	ra,0xfffff
    800056f2:	cd0080e7          	jalr	-816(ra) # 800043be <iunlockput>
    end_op();
    800056f6:	fffff097          	auipc	ra,0xfffff
    800056fa:	4a8080e7          	jalr	1192(ra) # 80004b9e <end_op>
  }
  return -1;
    800056fe:	557d                	li	a0,-1
}
    80005700:	21813083          	ld	ra,536(sp)
    80005704:	21013403          	ld	s0,528(sp)
    80005708:	20813483          	ld	s1,520(sp)
    8000570c:	20013903          	ld	s2,512(sp)
    80005710:	79fe                	ld	s3,504(sp)
    80005712:	7a5e                	ld	s4,496(sp)
    80005714:	7abe                	ld	s5,488(sp)
    80005716:	7b1e                	ld	s6,480(sp)
    80005718:	6bfe                	ld	s7,472(sp)
    8000571a:	6c5e                	ld	s8,464(sp)
    8000571c:	6cbe                	ld	s9,456(sp)
    8000571e:	6d1e                	ld	s10,448(sp)
    80005720:	7dfa                	ld	s11,440(sp)
    80005722:	22010113          	addi	sp,sp,544
    80005726:	8082                	ret
    end_op();
    80005728:	fffff097          	auipc	ra,0xfffff
    8000572c:	476080e7          	jalr	1142(ra) # 80004b9e <end_op>
    return -1;
    80005730:	557d                	li	a0,-1
    80005732:	b7f9                	j	80005700 <exec+0x9c>
  if ((pagetable = proc_pagetable(p)) == 0)
    80005734:	8526                	mv	a0,s1
    80005736:	ffffc097          	auipc	ra,0xffffc
    8000573a:	57c080e7          	jalr	1404(ra) # 80001cb2 <proc_pagetable>
    8000573e:	8b2a                	mv	s6,a0
    80005740:	d555                	beqz	a0,800056ec <exec+0x88>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
    80005742:	e7042783          	lw	a5,-400(s0)
    80005746:	e8845703          	lhu	a4,-376(s0)
    8000574a:	c735                	beqz	a4,800057b6 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000574c:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
    8000574e:	e0043423          	sd	zero,-504(s0)
    if (ph.vaddr % PGSIZE != 0)
    80005752:	6a05                	lui	s4,0x1
    80005754:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80005758:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for (i = 0; i < sz; i += PGSIZE)
    8000575c:	6d85                	lui	s11,0x1
    8000575e:	7d7d                	lui	s10,0xfffff
    80005760:	a481                	j	800059a0 <exec+0x33c>
  {
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    80005762:	00004517          	auipc	a0,0x4
    80005766:	12650513          	addi	a0,a0,294 # 80009888 <syscalls+0x2a8>
    8000576a:	ffffb097          	auipc	ra,0xffffb
    8000576e:	dd4080e7          	jalr	-556(ra) # 8000053e <panic>
    if (sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    80005772:	874a                	mv	a4,s2
    80005774:	009c86bb          	addw	a3,s9,s1
    80005778:	4581                	li	a1,0
    8000577a:	8556                	mv	a0,s5
    8000577c:	fffff097          	auipc	ra,0xfffff
    80005780:	c94080e7          	jalr	-876(ra) # 80004410 <readi>
    80005784:	2501                	sext.w	a0,a0
    80005786:	1aa91a63          	bne	s2,a0,8000593a <exec+0x2d6>
  for (i = 0; i < sz; i += PGSIZE)
    8000578a:	009d84bb          	addw	s1,s11,s1
    8000578e:	013d09bb          	addw	s3,s10,s3
    80005792:	1f74f763          	bgeu	s1,s7,80005980 <exec+0x31c>
    pa = walkaddr(pagetable, va + i);
    80005796:	02049593          	slli	a1,s1,0x20
    8000579a:	9181                	srli	a1,a1,0x20
    8000579c:	95e2                	add	a1,a1,s8
    8000579e:	855a                	mv	a0,s6
    800057a0:	ffffc097          	auipc	ra,0xffffc
    800057a4:	a78080e7          	jalr	-1416(ra) # 80001218 <walkaddr>
    800057a8:	862a                	mv	a2,a0
    if (pa == 0)
    800057aa:	dd45                	beqz	a0,80005762 <exec+0xfe>
      n = PGSIZE;
    800057ac:	8952                	mv	s2,s4
    if (sz - i < PGSIZE)
    800057ae:	fd49f2e3          	bgeu	s3,s4,80005772 <exec+0x10e>
      n = sz - i;
    800057b2:	894e                	mv	s2,s3
    800057b4:	bf7d                	j	80005772 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800057b6:	4901                	li	s2,0
  iunlockput(ip);
    800057b8:	8556                	mv	a0,s5
    800057ba:	fffff097          	auipc	ra,0xfffff
    800057be:	c04080e7          	jalr	-1020(ra) # 800043be <iunlockput>
  end_op();
    800057c2:	fffff097          	auipc	ra,0xfffff
    800057c6:	3dc080e7          	jalr	988(ra) # 80004b9e <end_op>
  p = myproc();
    800057ca:	ffffc097          	auipc	ra,0xffffc
    800057ce:	424080e7          	jalr	1060(ra) # 80001bee <myproc>
    800057d2:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800057d4:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800057d8:	6785                	lui	a5,0x1
    800057da:	17fd                	addi	a5,a5,-1
    800057dc:	993e                	add	s2,s2,a5
    800057de:	77fd                	lui	a5,0xfffff
    800057e0:	00f977b3          	and	a5,s2,a5
    800057e4:	def43c23          	sd	a5,-520(s0)
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE, PTE_W)) == 0)
    800057e8:	4691                	li	a3,4
    800057ea:	6609                	lui	a2,0x2
    800057ec:	963e                	add	a2,a2,a5
    800057ee:	85be                	mv	a1,a5
    800057f0:	855a                	mv	a0,s6
    800057f2:	ffffc097          	auipc	ra,0xffffc
    800057f6:	dda080e7          	jalr	-550(ra) # 800015cc <uvmalloc>
    800057fa:	8c2a                	mv	s8,a0
  ip = 0;
    800057fc:	4a81                	li	s5,0
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE, PTE_W)) == 0)
    800057fe:	12050e63          	beqz	a0,8000593a <exec+0x2d6>
  uvmclear(pagetable, sz - 2 * PGSIZE);
    80005802:	75f9                	lui	a1,0xffffe
    80005804:	95aa                	add	a1,a1,a0
    80005806:	855a                	mv	a0,s6
    80005808:	ffffc097          	auipc	ra,0xffffc
    8000580c:	008080e7          	jalr	8(ra) # 80001810 <uvmclear>
  stackbase = sp - PGSIZE;
    80005810:	7afd                	lui	s5,0xfffff
    80005812:	9ae2                	add	s5,s5,s8
  for (argc = 0; argv[argc]; argc++)
    80005814:	df043783          	ld	a5,-528(s0)
    80005818:	6388                	ld	a0,0(a5)
    8000581a:	c925                	beqz	a0,8000588a <exec+0x226>
    8000581c:	e9040993          	addi	s3,s0,-368
    80005820:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80005824:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++)
    80005826:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005828:	ffffb097          	auipc	ra,0xffffb
    8000582c:	7e2080e7          	jalr	2018(ra) # 8000100a <strlen>
    80005830:	0015079b          	addiw	a5,a0,1
    80005834:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005838:	ff097913          	andi	s2,s2,-16
    if (sp < stackbase)
    8000583c:	13596663          	bltu	s2,s5,80005968 <exec+0x304>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005840:	df043d83          	ld	s11,-528(s0)
    80005844:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80005848:	8552                	mv	a0,s4
    8000584a:	ffffb097          	auipc	ra,0xffffb
    8000584e:	7c0080e7          	jalr	1984(ra) # 8000100a <strlen>
    80005852:	0015069b          	addiw	a3,a0,1
    80005856:	8652                	mv	a2,s4
    80005858:	85ca                	mv	a1,s2
    8000585a:	855a                	mv	a0,s6
    8000585c:	ffffc097          	auipc	ra,0xffffc
    80005860:	fe6080e7          	jalr	-26(ra) # 80001842 <copyout>
    80005864:	10054663          	bltz	a0,80005970 <exec+0x30c>
    ustack[argc] = sp;
    80005868:	0129b023          	sd	s2,0(s3)
  for (argc = 0; argv[argc]; argc++)
    8000586c:	0485                	addi	s1,s1,1
    8000586e:	008d8793          	addi	a5,s11,8
    80005872:	def43823          	sd	a5,-528(s0)
    80005876:	008db503          	ld	a0,8(s11)
    8000587a:	c911                	beqz	a0,8000588e <exec+0x22a>
    if (argc >= MAXARG)
    8000587c:	09a1                	addi	s3,s3,8
    8000587e:	fb3c95e3          	bne	s9,s3,80005828 <exec+0x1c4>
  sz = sz1;
    80005882:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005886:	4a81                	li	s5,0
    80005888:	a84d                	j	8000593a <exec+0x2d6>
  sp = sz;
    8000588a:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++)
    8000588c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000588e:	00349793          	slli	a5,s1,0x3
    80005892:	f9040713          	addi	a4,s0,-112
    80005896:	97ba                	add	a5,a5,a4
    80005898:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7fdb8ae8>
  sp -= (argc + 1) * sizeof(uint64);
    8000589c:	00148693          	addi	a3,s1,1
    800058a0:	068e                	slli	a3,a3,0x3
    800058a2:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800058a6:	ff097913          	andi	s2,s2,-16
  if (sp < stackbase)
    800058aa:	01597663          	bgeu	s2,s5,800058b6 <exec+0x252>
  sz = sz1;
    800058ae:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800058b2:	4a81                	li	s5,0
    800058b4:	a059                	j	8000593a <exec+0x2d6>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    800058b6:	e9040613          	addi	a2,s0,-368
    800058ba:	85ca                	mv	a1,s2
    800058bc:	855a                	mv	a0,s6
    800058be:	ffffc097          	auipc	ra,0xffffc
    800058c2:	f84080e7          	jalr	-124(ra) # 80001842 <copyout>
    800058c6:	0a054963          	bltz	a0,80005978 <exec+0x314>
  p->trapframe->a1 = sp;
    800058ca:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    800058ce:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    800058d2:	de843783          	ld	a5,-536(s0)
    800058d6:	0007c703          	lbu	a4,0(a5)
    800058da:	cf11                	beqz	a4,800058f6 <exec+0x292>
    800058dc:	0785                	addi	a5,a5,1
    if (*s == '/')
    800058de:	02f00693          	li	a3,47
    800058e2:	a039                	j	800058f0 <exec+0x28c>
      last = s + 1;
    800058e4:	def43423          	sd	a5,-536(s0)
  for (last = s = path; *s; s++)
    800058e8:	0785                	addi	a5,a5,1
    800058ea:	fff7c703          	lbu	a4,-1(a5)
    800058ee:	c701                	beqz	a4,800058f6 <exec+0x292>
    if (*s == '/')
    800058f0:	fed71ce3          	bne	a4,a3,800058e8 <exec+0x284>
    800058f4:	bfc5                	j	800058e4 <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    800058f6:	4641                	li	a2,16
    800058f8:	de843583          	ld	a1,-536(s0)
    800058fc:	158b8513          	addi	a0,s7,344
    80005900:	ffffb097          	auipc	ra,0xffffb
    80005904:	6d8080e7          	jalr	1752(ra) # 80000fd8 <safestrcpy>
  oldpagetable = p->pagetable;
    80005908:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000590c:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80005910:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry; // initial program counter = main
    80005914:	058bb783          	ld	a5,88(s7)
    80005918:	e6843703          	ld	a4,-408(s0)
    8000591c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    8000591e:	058bb783          	ld	a5,88(s7)
    80005922:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005926:	85ea                	mv	a1,s10
    80005928:	ffffc097          	auipc	ra,0xffffc
    8000592c:	426080e7          	jalr	1062(ra) # 80001d4e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005930:	0004851b          	sext.w	a0,s1
    80005934:	b3f1                	j	80005700 <exec+0x9c>
    80005936:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000593a:	df843583          	ld	a1,-520(s0)
    8000593e:	855a                	mv	a0,s6
    80005940:	ffffc097          	auipc	ra,0xffffc
    80005944:	40e080e7          	jalr	1038(ra) # 80001d4e <proc_freepagetable>
  if (ip)
    80005948:	da0a92e3          	bnez	s5,800056ec <exec+0x88>
  return -1;
    8000594c:	557d                	li	a0,-1
    8000594e:	bb4d                	j	80005700 <exec+0x9c>
    80005950:	df243c23          	sd	s2,-520(s0)
    80005954:	b7dd                	j	8000593a <exec+0x2d6>
    80005956:	df243c23          	sd	s2,-520(s0)
    8000595a:	b7c5                	j	8000593a <exec+0x2d6>
    8000595c:	df243c23          	sd	s2,-520(s0)
    80005960:	bfe9                	j	8000593a <exec+0x2d6>
    80005962:	df243c23          	sd	s2,-520(s0)
    80005966:	bfd1                	j	8000593a <exec+0x2d6>
  sz = sz1;
    80005968:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000596c:	4a81                	li	s5,0
    8000596e:	b7f1                	j	8000593a <exec+0x2d6>
  sz = sz1;
    80005970:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005974:	4a81                	li	s5,0
    80005976:	b7d1                	j	8000593a <exec+0x2d6>
  sz = sz1;
    80005978:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000597c:	4a81                	li	s5,0
    8000597e:	bf75                	j	8000593a <exec+0x2d6>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005980:	df843903          	ld	s2,-520(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
    80005984:	e0843783          	ld	a5,-504(s0)
    80005988:	0017869b          	addiw	a3,a5,1
    8000598c:	e0d43423          	sd	a3,-504(s0)
    80005990:	e0043783          	ld	a5,-512(s0)
    80005994:	0387879b          	addiw	a5,a5,56
    80005998:	e8845703          	lhu	a4,-376(s0)
    8000599c:	e0e6dee3          	bge	a3,a4,800057b8 <exec+0x154>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800059a0:	2781                	sext.w	a5,a5
    800059a2:	e0f43023          	sd	a5,-512(s0)
    800059a6:	03800713          	li	a4,56
    800059aa:	86be                	mv	a3,a5
    800059ac:	e1840613          	addi	a2,s0,-488
    800059b0:	4581                	li	a1,0
    800059b2:	8556                	mv	a0,s5
    800059b4:	fffff097          	auipc	ra,0xfffff
    800059b8:	a5c080e7          	jalr	-1444(ra) # 80004410 <readi>
    800059bc:	03800793          	li	a5,56
    800059c0:	f6f51be3          	bne	a0,a5,80005936 <exec+0x2d2>
    if (ph.type != ELF_PROG_LOAD)
    800059c4:	e1842783          	lw	a5,-488(s0)
    800059c8:	4705                	li	a4,1
    800059ca:	fae79de3          	bne	a5,a4,80005984 <exec+0x320>
    if (ph.memsz < ph.filesz)
    800059ce:	e4043483          	ld	s1,-448(s0)
    800059d2:	e3843783          	ld	a5,-456(s0)
    800059d6:	f6f4ede3          	bltu	s1,a5,80005950 <exec+0x2ec>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    800059da:	e2843783          	ld	a5,-472(s0)
    800059de:	94be                	add	s1,s1,a5
    800059e0:	f6f4ebe3          	bltu	s1,a5,80005956 <exec+0x2f2>
    if (ph.vaddr % PGSIZE != 0)
    800059e4:	de043703          	ld	a4,-544(s0)
    800059e8:	8ff9                	and	a5,a5,a4
    800059ea:	fbad                	bnez	a5,8000595c <exec+0x2f8>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800059ec:	e1c42503          	lw	a0,-484(s0)
    800059f0:	00000097          	auipc	ra,0x0
    800059f4:	c58080e7          	jalr	-936(ra) # 80005648 <flags2perm>
    800059f8:	86aa                	mv	a3,a0
    800059fa:	8626                	mv	a2,s1
    800059fc:	85ca                	mv	a1,s2
    800059fe:	855a                	mv	a0,s6
    80005a00:	ffffc097          	auipc	ra,0xffffc
    80005a04:	bcc080e7          	jalr	-1076(ra) # 800015cc <uvmalloc>
    80005a08:	dea43c23          	sd	a0,-520(s0)
    80005a0c:	d939                	beqz	a0,80005962 <exec+0x2fe>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005a0e:	e2843c03          	ld	s8,-472(s0)
    80005a12:	e2042c83          	lw	s9,-480(s0)
    80005a16:	e3842b83          	lw	s7,-456(s0)
  for (i = 0; i < sz; i += PGSIZE)
    80005a1a:	f60b83e3          	beqz	s7,80005980 <exec+0x31c>
    80005a1e:	89de                	mv	s3,s7
    80005a20:	4481                	li	s1,0
    80005a22:	bb95                	j	80005796 <exec+0x132>

0000000080005a24 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005a24:	7179                	addi	sp,sp,-48
    80005a26:	f406                	sd	ra,40(sp)
    80005a28:	f022                	sd	s0,32(sp)
    80005a2a:	ec26                	sd	s1,24(sp)
    80005a2c:	e84a                	sd	s2,16(sp)
    80005a2e:	1800                	addi	s0,sp,48
    80005a30:	892e                	mv	s2,a1
    80005a32:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005a34:	fdc40593          	addi	a1,s0,-36
    80005a38:	ffffe097          	auipc	ra,0xffffe
    80005a3c:	946080e7          	jalr	-1722(ra) # 8000337e <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80005a40:	fdc42703          	lw	a4,-36(s0)
    80005a44:	47bd                	li	a5,15
    80005a46:	02e7eb63          	bltu	a5,a4,80005a7c <argfd+0x58>
    80005a4a:	ffffc097          	auipc	ra,0xffffc
    80005a4e:	1a4080e7          	jalr	420(ra) # 80001bee <myproc>
    80005a52:	fdc42703          	lw	a4,-36(s0)
    80005a56:	01a70793          	addi	a5,a4,26
    80005a5a:	078e                	slli	a5,a5,0x3
    80005a5c:	953e                	add	a0,a0,a5
    80005a5e:	611c                	ld	a5,0(a0)
    80005a60:	c385                	beqz	a5,80005a80 <argfd+0x5c>
    return -1;
  if (pfd)
    80005a62:	00090463          	beqz	s2,80005a6a <argfd+0x46>
    *pfd = fd;
    80005a66:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    80005a6a:	4501                	li	a0,0
  if (pf)
    80005a6c:	c091                	beqz	s1,80005a70 <argfd+0x4c>
    *pf = f;
    80005a6e:	e09c                	sd	a5,0(s1)
}
    80005a70:	70a2                	ld	ra,40(sp)
    80005a72:	7402                	ld	s0,32(sp)
    80005a74:	64e2                	ld	s1,24(sp)
    80005a76:	6942                	ld	s2,16(sp)
    80005a78:	6145                	addi	sp,sp,48
    80005a7a:	8082                	ret
    return -1;
    80005a7c:	557d                	li	a0,-1
    80005a7e:	bfcd                	j	80005a70 <argfd+0x4c>
    80005a80:	557d                	li	a0,-1
    80005a82:	b7fd                	j	80005a70 <argfd+0x4c>

0000000080005a84 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005a84:	1101                	addi	sp,sp,-32
    80005a86:	ec06                	sd	ra,24(sp)
    80005a88:	e822                	sd	s0,16(sp)
    80005a8a:	e426                	sd	s1,8(sp)
    80005a8c:	1000                	addi	s0,sp,32
    80005a8e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005a90:	ffffc097          	auipc	ra,0xffffc
    80005a94:	15e080e7          	jalr	350(ra) # 80001bee <myproc>
    80005a98:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++)
    80005a9a:	0d050793          	addi	a5,a0,208
    80005a9e:	4501                	li	a0,0
    80005aa0:	46c1                	li	a3,16
  {
    if (p->ofile[fd] == 0)
    80005aa2:	6398                	ld	a4,0(a5)
    80005aa4:	cb19                	beqz	a4,80005aba <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++)
    80005aa6:	2505                	addiw	a0,a0,1
    80005aa8:	07a1                	addi	a5,a5,8
    80005aaa:	fed51ce3          	bne	a0,a3,80005aa2 <fdalloc+0x1e>
    {
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005aae:	557d                	li	a0,-1
}
    80005ab0:	60e2                	ld	ra,24(sp)
    80005ab2:	6442                	ld	s0,16(sp)
    80005ab4:	64a2                	ld	s1,8(sp)
    80005ab6:	6105                	addi	sp,sp,32
    80005ab8:	8082                	ret
      p->ofile[fd] = f;
    80005aba:	01a50793          	addi	a5,a0,26
    80005abe:	078e                	slli	a5,a5,0x3
    80005ac0:	963e                	add	a2,a2,a5
    80005ac2:	e204                	sd	s1,0(a2)
      return fd;
    80005ac4:	b7f5                	j	80005ab0 <fdalloc+0x2c>

0000000080005ac6 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    80005ac6:	715d                	addi	sp,sp,-80
    80005ac8:	e486                	sd	ra,72(sp)
    80005aca:	e0a2                	sd	s0,64(sp)
    80005acc:	fc26                	sd	s1,56(sp)
    80005ace:	f84a                	sd	s2,48(sp)
    80005ad0:	f44e                	sd	s3,40(sp)
    80005ad2:	f052                	sd	s4,32(sp)
    80005ad4:	ec56                	sd	s5,24(sp)
    80005ad6:	e85a                	sd	s6,16(sp)
    80005ad8:	0880                	addi	s0,sp,80
    80005ada:	8b2e                	mv	s6,a1
    80005adc:	89b2                	mv	s3,a2
    80005ade:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    80005ae0:	fb040593          	addi	a1,s0,-80
    80005ae4:	fffff097          	auipc	ra,0xfffff
    80005ae8:	e3c080e7          	jalr	-452(ra) # 80004920 <nameiparent>
    80005aec:	84aa                	mv	s1,a0
    80005aee:	14050f63          	beqz	a0,80005c4c <create+0x186>
    return 0;

  ilock(dp);
    80005af2:	ffffe097          	auipc	ra,0xffffe
    80005af6:	66a080e7          	jalr	1642(ra) # 8000415c <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
    80005afa:	4601                	li	a2,0
    80005afc:	fb040593          	addi	a1,s0,-80
    80005b00:	8526                	mv	a0,s1
    80005b02:	fffff097          	auipc	ra,0xfffff
    80005b06:	b3e080e7          	jalr	-1218(ra) # 80004640 <dirlookup>
    80005b0a:	8aaa                	mv	s5,a0
    80005b0c:	c931                	beqz	a0,80005b60 <create+0x9a>
  {
    iunlockput(dp);
    80005b0e:	8526                	mv	a0,s1
    80005b10:	fffff097          	auipc	ra,0xfffff
    80005b14:	8ae080e7          	jalr	-1874(ra) # 800043be <iunlockput>
    ilock(ip);
    80005b18:	8556                	mv	a0,s5
    80005b1a:	ffffe097          	auipc	ra,0xffffe
    80005b1e:	642080e7          	jalr	1602(ra) # 8000415c <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005b22:	000b059b          	sext.w	a1,s6
    80005b26:	4789                	li	a5,2
    80005b28:	02f59563          	bne	a1,a5,80005b52 <create+0x8c>
    80005b2c:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7fdb8c2c>
    80005b30:	37f9                	addiw	a5,a5,-2
    80005b32:	17c2                	slli	a5,a5,0x30
    80005b34:	93c1                	srli	a5,a5,0x30
    80005b36:	4705                	li	a4,1
    80005b38:	00f76d63          	bltu	a4,a5,80005b52 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005b3c:	8556                	mv	a0,s5
    80005b3e:	60a6                	ld	ra,72(sp)
    80005b40:	6406                	ld	s0,64(sp)
    80005b42:	74e2                	ld	s1,56(sp)
    80005b44:	7942                	ld	s2,48(sp)
    80005b46:	79a2                	ld	s3,40(sp)
    80005b48:	7a02                	ld	s4,32(sp)
    80005b4a:	6ae2                	ld	s5,24(sp)
    80005b4c:	6b42                	ld	s6,16(sp)
    80005b4e:	6161                	addi	sp,sp,80
    80005b50:	8082                	ret
    iunlockput(ip);
    80005b52:	8556                	mv	a0,s5
    80005b54:	fffff097          	auipc	ra,0xfffff
    80005b58:	86a080e7          	jalr	-1942(ra) # 800043be <iunlockput>
    return 0;
    80005b5c:	4a81                	li	s5,0
    80005b5e:	bff9                	j	80005b3c <create+0x76>
  if ((ip = ialloc(dp->dev, type)) == 0)
    80005b60:	85da                	mv	a1,s6
    80005b62:	4088                	lw	a0,0(s1)
    80005b64:	ffffe097          	auipc	ra,0xffffe
    80005b68:	45c080e7          	jalr	1116(ra) # 80003fc0 <ialloc>
    80005b6c:	8a2a                	mv	s4,a0
    80005b6e:	c539                	beqz	a0,80005bbc <create+0xf6>
  ilock(ip);
    80005b70:	ffffe097          	auipc	ra,0xffffe
    80005b74:	5ec080e7          	jalr	1516(ra) # 8000415c <ilock>
  ip->major = major;
    80005b78:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80005b7c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005b80:	4905                	li	s2,1
    80005b82:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005b86:	8552                	mv	a0,s4
    80005b88:	ffffe097          	auipc	ra,0xffffe
    80005b8c:	50a080e7          	jalr	1290(ra) # 80004092 <iupdate>
  if (type == T_DIR)
    80005b90:	000b059b          	sext.w	a1,s6
    80005b94:	03258b63          	beq	a1,s2,80005bca <create+0x104>
  if (dirlink(dp, name, ip->inum) < 0)
    80005b98:	004a2603          	lw	a2,4(s4)
    80005b9c:	fb040593          	addi	a1,s0,-80
    80005ba0:	8526                	mv	a0,s1
    80005ba2:	fffff097          	auipc	ra,0xfffff
    80005ba6:	cae080e7          	jalr	-850(ra) # 80004850 <dirlink>
    80005baa:	06054f63          	bltz	a0,80005c28 <create+0x162>
  iunlockput(dp);
    80005bae:	8526                	mv	a0,s1
    80005bb0:	fffff097          	auipc	ra,0xfffff
    80005bb4:	80e080e7          	jalr	-2034(ra) # 800043be <iunlockput>
  return ip;
    80005bb8:	8ad2                	mv	s5,s4
    80005bba:	b749                	j	80005b3c <create+0x76>
    iunlockput(dp);
    80005bbc:	8526                	mv	a0,s1
    80005bbe:	fffff097          	auipc	ra,0xfffff
    80005bc2:	800080e7          	jalr	-2048(ra) # 800043be <iunlockput>
    return 0;
    80005bc6:	8ad2                	mv	s5,s4
    80005bc8:	bf95                	j	80005b3c <create+0x76>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005bca:	004a2603          	lw	a2,4(s4)
    80005bce:	00004597          	auipc	a1,0x4
    80005bd2:	cda58593          	addi	a1,a1,-806 # 800098a8 <syscalls+0x2c8>
    80005bd6:	8552                	mv	a0,s4
    80005bd8:	fffff097          	auipc	ra,0xfffff
    80005bdc:	c78080e7          	jalr	-904(ra) # 80004850 <dirlink>
    80005be0:	04054463          	bltz	a0,80005c28 <create+0x162>
    80005be4:	40d0                	lw	a2,4(s1)
    80005be6:	00004597          	auipc	a1,0x4
    80005bea:	cca58593          	addi	a1,a1,-822 # 800098b0 <syscalls+0x2d0>
    80005bee:	8552                	mv	a0,s4
    80005bf0:	fffff097          	auipc	ra,0xfffff
    80005bf4:	c60080e7          	jalr	-928(ra) # 80004850 <dirlink>
    80005bf8:	02054863          	bltz	a0,80005c28 <create+0x162>
  if (dirlink(dp, name, ip->inum) < 0)
    80005bfc:	004a2603          	lw	a2,4(s4)
    80005c00:	fb040593          	addi	a1,s0,-80
    80005c04:	8526                	mv	a0,s1
    80005c06:	fffff097          	auipc	ra,0xfffff
    80005c0a:	c4a080e7          	jalr	-950(ra) # 80004850 <dirlink>
    80005c0e:	00054d63          	bltz	a0,80005c28 <create+0x162>
    dp->nlink++; // for ".."
    80005c12:	04a4d783          	lhu	a5,74(s1)
    80005c16:	2785                	addiw	a5,a5,1
    80005c18:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005c1c:	8526                	mv	a0,s1
    80005c1e:	ffffe097          	auipc	ra,0xffffe
    80005c22:	474080e7          	jalr	1140(ra) # 80004092 <iupdate>
    80005c26:	b761                	j	80005bae <create+0xe8>
  ip->nlink = 0;
    80005c28:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005c2c:	8552                	mv	a0,s4
    80005c2e:	ffffe097          	auipc	ra,0xffffe
    80005c32:	464080e7          	jalr	1124(ra) # 80004092 <iupdate>
  iunlockput(ip);
    80005c36:	8552                	mv	a0,s4
    80005c38:	ffffe097          	auipc	ra,0xffffe
    80005c3c:	786080e7          	jalr	1926(ra) # 800043be <iunlockput>
  iunlockput(dp);
    80005c40:	8526                	mv	a0,s1
    80005c42:	ffffe097          	auipc	ra,0xffffe
    80005c46:	77c080e7          	jalr	1916(ra) # 800043be <iunlockput>
  return 0;
    80005c4a:	bdcd                	j	80005b3c <create+0x76>
    return 0;
    80005c4c:	8aaa                	mv	s5,a0
    80005c4e:	b5fd                	j	80005b3c <create+0x76>

0000000080005c50 <sys_dup>:
{
    80005c50:	7179                	addi	sp,sp,-48
    80005c52:	f406                	sd	ra,40(sp)
    80005c54:	f022                	sd	s0,32(sp)
    80005c56:	ec26                	sd	s1,24(sp)
    80005c58:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    80005c5a:	fd840613          	addi	a2,s0,-40
    80005c5e:	4581                	li	a1,0
    80005c60:	4501                	li	a0,0
    80005c62:	00000097          	auipc	ra,0x0
    80005c66:	dc2080e7          	jalr	-574(ra) # 80005a24 <argfd>
    return -1;
    80005c6a:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    80005c6c:	02054363          	bltz	a0,80005c92 <sys_dup+0x42>
  if ((fd = fdalloc(f)) < 0)
    80005c70:	fd843503          	ld	a0,-40(s0)
    80005c74:	00000097          	auipc	ra,0x0
    80005c78:	e10080e7          	jalr	-496(ra) # 80005a84 <fdalloc>
    80005c7c:	84aa                	mv	s1,a0
    return -1;
    80005c7e:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    80005c80:	00054963          	bltz	a0,80005c92 <sys_dup+0x42>
  filedup(f);
    80005c84:	fd843503          	ld	a0,-40(s0)
    80005c88:	fffff097          	auipc	ra,0xfffff
    80005c8c:	310080e7          	jalr	784(ra) # 80004f98 <filedup>
  return fd;
    80005c90:	87a6                	mv	a5,s1
}
    80005c92:	853e                	mv	a0,a5
    80005c94:	70a2                	ld	ra,40(sp)
    80005c96:	7402                	ld	s0,32(sp)
    80005c98:	64e2                	ld	s1,24(sp)
    80005c9a:	6145                	addi	sp,sp,48
    80005c9c:	8082                	ret

0000000080005c9e <sys_read>:
{
    80005c9e:	7179                	addi	sp,sp,-48
    80005ca0:	f406                	sd	ra,40(sp)
    80005ca2:	f022                	sd	s0,32(sp)
    80005ca4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005ca6:	fd840593          	addi	a1,s0,-40
    80005caa:	4505                	li	a0,1
    80005cac:	ffffd097          	auipc	ra,0xffffd
    80005cb0:	6f2080e7          	jalr	1778(ra) # 8000339e <argaddr>
  argint(2, &n);
    80005cb4:	fe440593          	addi	a1,s0,-28
    80005cb8:	4509                	li	a0,2
    80005cba:	ffffd097          	auipc	ra,0xffffd
    80005cbe:	6c4080e7          	jalr	1732(ra) # 8000337e <argint>
  if (argfd(0, 0, &f) < 0)
    80005cc2:	fe840613          	addi	a2,s0,-24
    80005cc6:	4581                	li	a1,0
    80005cc8:	4501                	li	a0,0
    80005cca:	00000097          	auipc	ra,0x0
    80005cce:	d5a080e7          	jalr	-678(ra) # 80005a24 <argfd>
    80005cd2:	87aa                	mv	a5,a0
    return -1;
    80005cd4:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80005cd6:	0007cc63          	bltz	a5,80005cee <sys_read+0x50>
  return fileread(f, p, n);
    80005cda:	fe442603          	lw	a2,-28(s0)
    80005cde:	fd843583          	ld	a1,-40(s0)
    80005ce2:	fe843503          	ld	a0,-24(s0)
    80005ce6:	fffff097          	auipc	ra,0xfffff
    80005cea:	43e080e7          	jalr	1086(ra) # 80005124 <fileread>
}
    80005cee:	70a2                	ld	ra,40(sp)
    80005cf0:	7402                	ld	s0,32(sp)
    80005cf2:	6145                	addi	sp,sp,48
    80005cf4:	8082                	ret

0000000080005cf6 <sys_write>:
{
    80005cf6:	7179                	addi	sp,sp,-48
    80005cf8:	f406                	sd	ra,40(sp)
    80005cfa:	f022                	sd	s0,32(sp)
    80005cfc:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005cfe:	fd840593          	addi	a1,s0,-40
    80005d02:	4505                	li	a0,1
    80005d04:	ffffd097          	auipc	ra,0xffffd
    80005d08:	69a080e7          	jalr	1690(ra) # 8000339e <argaddr>
  argint(2, &n);
    80005d0c:	fe440593          	addi	a1,s0,-28
    80005d10:	4509                	li	a0,2
    80005d12:	ffffd097          	auipc	ra,0xffffd
    80005d16:	66c080e7          	jalr	1644(ra) # 8000337e <argint>
  if (argfd(0, 0, &f) < 0)
    80005d1a:	fe840613          	addi	a2,s0,-24
    80005d1e:	4581                	li	a1,0
    80005d20:	4501                	li	a0,0
    80005d22:	00000097          	auipc	ra,0x0
    80005d26:	d02080e7          	jalr	-766(ra) # 80005a24 <argfd>
    80005d2a:	87aa                	mv	a5,a0
    return -1;
    80005d2c:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80005d2e:	0007cc63          	bltz	a5,80005d46 <sys_write+0x50>
  return filewrite(f, p, n);
    80005d32:	fe442603          	lw	a2,-28(s0)
    80005d36:	fd843583          	ld	a1,-40(s0)
    80005d3a:	fe843503          	ld	a0,-24(s0)
    80005d3e:	fffff097          	auipc	ra,0xfffff
    80005d42:	4a8080e7          	jalr	1192(ra) # 800051e6 <filewrite>
}
    80005d46:	70a2                	ld	ra,40(sp)
    80005d48:	7402                	ld	s0,32(sp)
    80005d4a:	6145                	addi	sp,sp,48
    80005d4c:	8082                	ret

0000000080005d4e <sys_close>:
{
    80005d4e:	1101                	addi	sp,sp,-32
    80005d50:	ec06                	sd	ra,24(sp)
    80005d52:	e822                	sd	s0,16(sp)
    80005d54:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    80005d56:	fe040613          	addi	a2,s0,-32
    80005d5a:	fec40593          	addi	a1,s0,-20
    80005d5e:	4501                	li	a0,0
    80005d60:	00000097          	auipc	ra,0x0
    80005d64:	cc4080e7          	jalr	-828(ra) # 80005a24 <argfd>
    return -1;
    80005d68:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    80005d6a:	02054463          	bltz	a0,80005d92 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005d6e:	ffffc097          	auipc	ra,0xffffc
    80005d72:	e80080e7          	jalr	-384(ra) # 80001bee <myproc>
    80005d76:	fec42783          	lw	a5,-20(s0)
    80005d7a:	07e9                	addi	a5,a5,26
    80005d7c:	078e                	slli	a5,a5,0x3
    80005d7e:	97aa                	add	a5,a5,a0
    80005d80:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80005d84:	fe043503          	ld	a0,-32(s0)
    80005d88:	fffff097          	auipc	ra,0xfffff
    80005d8c:	262080e7          	jalr	610(ra) # 80004fea <fileclose>
  return 0;
    80005d90:	4781                	li	a5,0
}
    80005d92:	853e                	mv	a0,a5
    80005d94:	60e2                	ld	ra,24(sp)
    80005d96:	6442                	ld	s0,16(sp)
    80005d98:	6105                	addi	sp,sp,32
    80005d9a:	8082                	ret

0000000080005d9c <sys_fstat>:
{
    80005d9c:	1101                	addi	sp,sp,-32
    80005d9e:	ec06                	sd	ra,24(sp)
    80005da0:	e822                	sd	s0,16(sp)
    80005da2:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005da4:	fe040593          	addi	a1,s0,-32
    80005da8:	4505                	li	a0,1
    80005daa:	ffffd097          	auipc	ra,0xffffd
    80005dae:	5f4080e7          	jalr	1524(ra) # 8000339e <argaddr>
  if (argfd(0, 0, &f) < 0)
    80005db2:	fe840613          	addi	a2,s0,-24
    80005db6:	4581                	li	a1,0
    80005db8:	4501                	li	a0,0
    80005dba:	00000097          	auipc	ra,0x0
    80005dbe:	c6a080e7          	jalr	-918(ra) # 80005a24 <argfd>
    80005dc2:	87aa                	mv	a5,a0
    return -1;
    80005dc4:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80005dc6:	0007ca63          	bltz	a5,80005dda <sys_fstat+0x3e>
  return filestat(f, st);
    80005dca:	fe043583          	ld	a1,-32(s0)
    80005dce:	fe843503          	ld	a0,-24(s0)
    80005dd2:	fffff097          	auipc	ra,0xfffff
    80005dd6:	2e0080e7          	jalr	736(ra) # 800050b2 <filestat>
}
    80005dda:	60e2                	ld	ra,24(sp)
    80005ddc:	6442                	ld	s0,16(sp)
    80005dde:	6105                	addi	sp,sp,32
    80005de0:	8082                	ret

0000000080005de2 <sys_link>:
{
    80005de2:	7169                	addi	sp,sp,-304
    80005de4:	f606                	sd	ra,296(sp)
    80005de6:	f222                	sd	s0,288(sp)
    80005de8:	ee26                	sd	s1,280(sp)
    80005dea:	ea4a                	sd	s2,272(sp)
    80005dec:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005dee:	08000613          	li	a2,128
    80005df2:	ed040593          	addi	a1,s0,-304
    80005df6:	4501                	li	a0,0
    80005df8:	ffffd097          	auipc	ra,0xffffd
    80005dfc:	5c6080e7          	jalr	1478(ra) # 800033be <argstr>
    return -1;
    80005e00:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005e02:	10054e63          	bltz	a0,80005f1e <sys_link+0x13c>
    80005e06:	08000613          	li	a2,128
    80005e0a:	f5040593          	addi	a1,s0,-176
    80005e0e:	4505                	li	a0,1
    80005e10:	ffffd097          	auipc	ra,0xffffd
    80005e14:	5ae080e7          	jalr	1454(ra) # 800033be <argstr>
    return -1;
    80005e18:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005e1a:	10054263          	bltz	a0,80005f1e <sys_link+0x13c>
  begin_op();
    80005e1e:	fffff097          	auipc	ra,0xfffff
    80005e22:	d00080e7          	jalr	-768(ra) # 80004b1e <begin_op>
  if ((ip = namei(old)) == 0)
    80005e26:	ed040513          	addi	a0,s0,-304
    80005e2a:	fffff097          	auipc	ra,0xfffff
    80005e2e:	ad8080e7          	jalr	-1320(ra) # 80004902 <namei>
    80005e32:	84aa                	mv	s1,a0
    80005e34:	c551                	beqz	a0,80005ec0 <sys_link+0xde>
  ilock(ip);
    80005e36:	ffffe097          	auipc	ra,0xffffe
    80005e3a:	326080e7          	jalr	806(ra) # 8000415c <ilock>
  if (ip->type == T_DIR)
    80005e3e:	04449703          	lh	a4,68(s1)
    80005e42:	4785                	li	a5,1
    80005e44:	08f70463          	beq	a4,a5,80005ecc <sys_link+0xea>
  ip->nlink++;
    80005e48:	04a4d783          	lhu	a5,74(s1)
    80005e4c:	2785                	addiw	a5,a5,1
    80005e4e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005e52:	8526                	mv	a0,s1
    80005e54:	ffffe097          	auipc	ra,0xffffe
    80005e58:	23e080e7          	jalr	574(ra) # 80004092 <iupdate>
  iunlock(ip);
    80005e5c:	8526                	mv	a0,s1
    80005e5e:	ffffe097          	auipc	ra,0xffffe
    80005e62:	3c0080e7          	jalr	960(ra) # 8000421e <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    80005e66:	fd040593          	addi	a1,s0,-48
    80005e6a:	f5040513          	addi	a0,s0,-176
    80005e6e:	fffff097          	auipc	ra,0xfffff
    80005e72:	ab2080e7          	jalr	-1358(ra) # 80004920 <nameiparent>
    80005e76:	892a                	mv	s2,a0
    80005e78:	c935                	beqz	a0,80005eec <sys_link+0x10a>
  ilock(dp);
    80005e7a:	ffffe097          	auipc	ra,0xffffe
    80005e7e:	2e2080e7          	jalr	738(ra) # 8000415c <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
    80005e82:	00092703          	lw	a4,0(s2)
    80005e86:	409c                	lw	a5,0(s1)
    80005e88:	04f71d63          	bne	a4,a5,80005ee2 <sys_link+0x100>
    80005e8c:	40d0                	lw	a2,4(s1)
    80005e8e:	fd040593          	addi	a1,s0,-48
    80005e92:	854a                	mv	a0,s2
    80005e94:	fffff097          	auipc	ra,0xfffff
    80005e98:	9bc080e7          	jalr	-1604(ra) # 80004850 <dirlink>
    80005e9c:	04054363          	bltz	a0,80005ee2 <sys_link+0x100>
  iunlockput(dp);
    80005ea0:	854a                	mv	a0,s2
    80005ea2:	ffffe097          	auipc	ra,0xffffe
    80005ea6:	51c080e7          	jalr	1308(ra) # 800043be <iunlockput>
  iput(ip);
    80005eaa:	8526                	mv	a0,s1
    80005eac:	ffffe097          	auipc	ra,0xffffe
    80005eb0:	46a080e7          	jalr	1130(ra) # 80004316 <iput>
  end_op();
    80005eb4:	fffff097          	auipc	ra,0xfffff
    80005eb8:	cea080e7          	jalr	-790(ra) # 80004b9e <end_op>
  return 0;
    80005ebc:	4781                	li	a5,0
    80005ebe:	a085                	j	80005f1e <sys_link+0x13c>
    end_op();
    80005ec0:	fffff097          	auipc	ra,0xfffff
    80005ec4:	cde080e7          	jalr	-802(ra) # 80004b9e <end_op>
    return -1;
    80005ec8:	57fd                	li	a5,-1
    80005eca:	a891                	j	80005f1e <sys_link+0x13c>
    iunlockput(ip);
    80005ecc:	8526                	mv	a0,s1
    80005ece:	ffffe097          	auipc	ra,0xffffe
    80005ed2:	4f0080e7          	jalr	1264(ra) # 800043be <iunlockput>
    end_op();
    80005ed6:	fffff097          	auipc	ra,0xfffff
    80005eda:	cc8080e7          	jalr	-824(ra) # 80004b9e <end_op>
    return -1;
    80005ede:	57fd                	li	a5,-1
    80005ee0:	a83d                	j	80005f1e <sys_link+0x13c>
    iunlockput(dp);
    80005ee2:	854a                	mv	a0,s2
    80005ee4:	ffffe097          	auipc	ra,0xffffe
    80005ee8:	4da080e7          	jalr	1242(ra) # 800043be <iunlockput>
  ilock(ip);
    80005eec:	8526                	mv	a0,s1
    80005eee:	ffffe097          	auipc	ra,0xffffe
    80005ef2:	26e080e7          	jalr	622(ra) # 8000415c <ilock>
  ip->nlink--;
    80005ef6:	04a4d783          	lhu	a5,74(s1)
    80005efa:	37fd                	addiw	a5,a5,-1
    80005efc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005f00:	8526                	mv	a0,s1
    80005f02:	ffffe097          	auipc	ra,0xffffe
    80005f06:	190080e7          	jalr	400(ra) # 80004092 <iupdate>
  iunlockput(ip);
    80005f0a:	8526                	mv	a0,s1
    80005f0c:	ffffe097          	auipc	ra,0xffffe
    80005f10:	4b2080e7          	jalr	1202(ra) # 800043be <iunlockput>
  end_op();
    80005f14:	fffff097          	auipc	ra,0xfffff
    80005f18:	c8a080e7          	jalr	-886(ra) # 80004b9e <end_op>
  return -1;
    80005f1c:	57fd                	li	a5,-1
}
    80005f1e:	853e                	mv	a0,a5
    80005f20:	70b2                	ld	ra,296(sp)
    80005f22:	7412                	ld	s0,288(sp)
    80005f24:	64f2                	ld	s1,280(sp)
    80005f26:	6952                	ld	s2,272(sp)
    80005f28:	6155                	addi	sp,sp,304
    80005f2a:	8082                	ret

0000000080005f2c <sys_unlink>:
{
    80005f2c:	7151                	addi	sp,sp,-240
    80005f2e:	f586                	sd	ra,232(sp)
    80005f30:	f1a2                	sd	s0,224(sp)
    80005f32:	eda6                	sd	s1,216(sp)
    80005f34:	e9ca                	sd	s2,208(sp)
    80005f36:	e5ce                	sd	s3,200(sp)
    80005f38:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    80005f3a:	08000613          	li	a2,128
    80005f3e:	f3040593          	addi	a1,s0,-208
    80005f42:	4501                	li	a0,0
    80005f44:	ffffd097          	auipc	ra,0xffffd
    80005f48:	47a080e7          	jalr	1146(ra) # 800033be <argstr>
    80005f4c:	18054163          	bltz	a0,800060ce <sys_unlink+0x1a2>
  begin_op();
    80005f50:	fffff097          	auipc	ra,0xfffff
    80005f54:	bce080e7          	jalr	-1074(ra) # 80004b1e <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
    80005f58:	fb040593          	addi	a1,s0,-80
    80005f5c:	f3040513          	addi	a0,s0,-208
    80005f60:	fffff097          	auipc	ra,0xfffff
    80005f64:	9c0080e7          	jalr	-1600(ra) # 80004920 <nameiparent>
    80005f68:	84aa                	mv	s1,a0
    80005f6a:	c979                	beqz	a0,80006040 <sys_unlink+0x114>
  ilock(dp);
    80005f6c:	ffffe097          	auipc	ra,0xffffe
    80005f70:	1f0080e7          	jalr	496(ra) # 8000415c <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005f74:	00004597          	auipc	a1,0x4
    80005f78:	93458593          	addi	a1,a1,-1740 # 800098a8 <syscalls+0x2c8>
    80005f7c:	fb040513          	addi	a0,s0,-80
    80005f80:	ffffe097          	auipc	ra,0xffffe
    80005f84:	6a6080e7          	jalr	1702(ra) # 80004626 <namecmp>
    80005f88:	14050a63          	beqz	a0,800060dc <sys_unlink+0x1b0>
    80005f8c:	00004597          	auipc	a1,0x4
    80005f90:	92458593          	addi	a1,a1,-1756 # 800098b0 <syscalls+0x2d0>
    80005f94:	fb040513          	addi	a0,s0,-80
    80005f98:	ffffe097          	auipc	ra,0xffffe
    80005f9c:	68e080e7          	jalr	1678(ra) # 80004626 <namecmp>
    80005fa0:	12050e63          	beqz	a0,800060dc <sys_unlink+0x1b0>
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80005fa4:	f2c40613          	addi	a2,s0,-212
    80005fa8:	fb040593          	addi	a1,s0,-80
    80005fac:	8526                	mv	a0,s1
    80005fae:	ffffe097          	auipc	ra,0xffffe
    80005fb2:	692080e7          	jalr	1682(ra) # 80004640 <dirlookup>
    80005fb6:	892a                	mv	s2,a0
    80005fb8:	12050263          	beqz	a0,800060dc <sys_unlink+0x1b0>
  ilock(ip);
    80005fbc:	ffffe097          	auipc	ra,0xffffe
    80005fc0:	1a0080e7          	jalr	416(ra) # 8000415c <ilock>
  if (ip->nlink < 1)
    80005fc4:	04a91783          	lh	a5,74(s2)
    80005fc8:	08f05263          	blez	a5,8000604c <sys_unlink+0x120>
  if (ip->type == T_DIR && !isdirempty(ip))
    80005fcc:	04491703          	lh	a4,68(s2)
    80005fd0:	4785                	li	a5,1
    80005fd2:	08f70563          	beq	a4,a5,8000605c <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005fd6:	4641                	li	a2,16
    80005fd8:	4581                	li	a1,0
    80005fda:	fc040513          	addi	a0,s0,-64
    80005fde:	ffffb097          	auipc	ra,0xffffb
    80005fe2:	eb0080e7          	jalr	-336(ra) # 80000e8e <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005fe6:	4741                	li	a4,16
    80005fe8:	f2c42683          	lw	a3,-212(s0)
    80005fec:	fc040613          	addi	a2,s0,-64
    80005ff0:	4581                	li	a1,0
    80005ff2:	8526                	mv	a0,s1
    80005ff4:	ffffe097          	auipc	ra,0xffffe
    80005ff8:	514080e7          	jalr	1300(ra) # 80004508 <writei>
    80005ffc:	47c1                	li	a5,16
    80005ffe:	0af51563          	bne	a0,a5,800060a8 <sys_unlink+0x17c>
  if (ip->type == T_DIR)
    80006002:	04491703          	lh	a4,68(s2)
    80006006:	4785                	li	a5,1
    80006008:	0af70863          	beq	a4,a5,800060b8 <sys_unlink+0x18c>
  iunlockput(dp);
    8000600c:	8526                	mv	a0,s1
    8000600e:	ffffe097          	auipc	ra,0xffffe
    80006012:	3b0080e7          	jalr	944(ra) # 800043be <iunlockput>
  ip->nlink--;
    80006016:	04a95783          	lhu	a5,74(s2)
    8000601a:	37fd                	addiw	a5,a5,-1
    8000601c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80006020:	854a                	mv	a0,s2
    80006022:	ffffe097          	auipc	ra,0xffffe
    80006026:	070080e7          	jalr	112(ra) # 80004092 <iupdate>
  iunlockput(ip);
    8000602a:	854a                	mv	a0,s2
    8000602c:	ffffe097          	auipc	ra,0xffffe
    80006030:	392080e7          	jalr	914(ra) # 800043be <iunlockput>
  end_op();
    80006034:	fffff097          	auipc	ra,0xfffff
    80006038:	b6a080e7          	jalr	-1174(ra) # 80004b9e <end_op>
  return 0;
    8000603c:	4501                	li	a0,0
    8000603e:	a84d                	j	800060f0 <sys_unlink+0x1c4>
    end_op();
    80006040:	fffff097          	auipc	ra,0xfffff
    80006044:	b5e080e7          	jalr	-1186(ra) # 80004b9e <end_op>
    return -1;
    80006048:	557d                	li	a0,-1
    8000604a:	a05d                	j	800060f0 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    8000604c:	00004517          	auipc	a0,0x4
    80006050:	86c50513          	addi	a0,a0,-1940 # 800098b8 <syscalls+0x2d8>
    80006054:	ffffa097          	auipc	ra,0xffffa
    80006058:	4ea080e7          	jalr	1258(ra) # 8000053e <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    8000605c:	04c92703          	lw	a4,76(s2)
    80006060:	02000793          	li	a5,32
    80006064:	f6e7f9e3          	bgeu	a5,a4,80005fd6 <sys_unlink+0xaa>
    80006068:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000606c:	4741                	li	a4,16
    8000606e:	86ce                	mv	a3,s3
    80006070:	f1840613          	addi	a2,s0,-232
    80006074:	4581                	li	a1,0
    80006076:	854a                	mv	a0,s2
    80006078:	ffffe097          	auipc	ra,0xffffe
    8000607c:	398080e7          	jalr	920(ra) # 80004410 <readi>
    80006080:	47c1                	li	a5,16
    80006082:	00f51b63          	bne	a0,a5,80006098 <sys_unlink+0x16c>
    if (de.inum != 0)
    80006086:	f1845783          	lhu	a5,-232(s0)
    8000608a:	e7a1                	bnez	a5,800060d2 <sys_unlink+0x1a6>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    8000608c:	29c1                	addiw	s3,s3,16
    8000608e:	04c92783          	lw	a5,76(s2)
    80006092:	fcf9ede3          	bltu	s3,a5,8000606c <sys_unlink+0x140>
    80006096:	b781                	j	80005fd6 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80006098:	00004517          	auipc	a0,0x4
    8000609c:	83850513          	addi	a0,a0,-1992 # 800098d0 <syscalls+0x2f0>
    800060a0:	ffffa097          	auipc	ra,0xffffa
    800060a4:	49e080e7          	jalr	1182(ra) # 8000053e <panic>
    panic("unlink: writei");
    800060a8:	00004517          	auipc	a0,0x4
    800060ac:	84050513          	addi	a0,a0,-1984 # 800098e8 <syscalls+0x308>
    800060b0:	ffffa097          	auipc	ra,0xffffa
    800060b4:	48e080e7          	jalr	1166(ra) # 8000053e <panic>
    dp->nlink--;
    800060b8:	04a4d783          	lhu	a5,74(s1)
    800060bc:	37fd                	addiw	a5,a5,-1
    800060be:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800060c2:	8526                	mv	a0,s1
    800060c4:	ffffe097          	auipc	ra,0xffffe
    800060c8:	fce080e7          	jalr	-50(ra) # 80004092 <iupdate>
    800060cc:	b781                	j	8000600c <sys_unlink+0xe0>
    return -1;
    800060ce:	557d                	li	a0,-1
    800060d0:	a005                	j	800060f0 <sys_unlink+0x1c4>
    iunlockput(ip);
    800060d2:	854a                	mv	a0,s2
    800060d4:	ffffe097          	auipc	ra,0xffffe
    800060d8:	2ea080e7          	jalr	746(ra) # 800043be <iunlockput>
  iunlockput(dp);
    800060dc:	8526                	mv	a0,s1
    800060de:	ffffe097          	auipc	ra,0xffffe
    800060e2:	2e0080e7          	jalr	736(ra) # 800043be <iunlockput>
  end_op();
    800060e6:	fffff097          	auipc	ra,0xfffff
    800060ea:	ab8080e7          	jalr	-1352(ra) # 80004b9e <end_op>
  return -1;
    800060ee:	557d                	li	a0,-1
}
    800060f0:	70ae                	ld	ra,232(sp)
    800060f2:	740e                	ld	s0,224(sp)
    800060f4:	64ee                	ld	s1,216(sp)
    800060f6:	694e                	ld	s2,208(sp)
    800060f8:	69ae                	ld	s3,200(sp)
    800060fa:	616d                	addi	sp,sp,240
    800060fc:	8082                	ret

00000000800060fe <sys_open>:

uint64
sys_open(void)
{
    800060fe:	7131                	addi	sp,sp,-192
    80006100:	fd06                	sd	ra,184(sp)
    80006102:	f922                	sd	s0,176(sp)
    80006104:	f526                	sd	s1,168(sp)
    80006106:	f14a                	sd	s2,160(sp)
    80006108:	ed4e                	sd	s3,152(sp)
    8000610a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000610c:	f4c40593          	addi	a1,s0,-180
    80006110:	4505                	li	a0,1
    80006112:	ffffd097          	auipc	ra,0xffffd
    80006116:	26c080e7          	jalr	620(ra) # 8000337e <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    8000611a:	08000613          	li	a2,128
    8000611e:	f5040593          	addi	a1,s0,-176
    80006122:	4501                	li	a0,0
    80006124:	ffffd097          	auipc	ra,0xffffd
    80006128:	29a080e7          	jalr	666(ra) # 800033be <argstr>
    8000612c:	87aa                	mv	a5,a0
    return -1;
    8000612e:	557d                	li	a0,-1
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80006130:	0a07c963          	bltz	a5,800061e2 <sys_open+0xe4>

  begin_op();
    80006134:	fffff097          	auipc	ra,0xfffff
    80006138:	9ea080e7          	jalr	-1558(ra) # 80004b1e <begin_op>

  if (omode & O_CREATE)
    8000613c:	f4c42783          	lw	a5,-180(s0)
    80006140:	2007f793          	andi	a5,a5,512
    80006144:	cfc5                	beqz	a5,800061fc <sys_open+0xfe>
  {
    ip = create(path, T_FILE, 0, 0);
    80006146:	4681                	li	a3,0
    80006148:	4601                	li	a2,0
    8000614a:	4589                	li	a1,2
    8000614c:	f5040513          	addi	a0,s0,-176
    80006150:	00000097          	auipc	ra,0x0
    80006154:	976080e7          	jalr	-1674(ra) # 80005ac6 <create>
    80006158:	84aa                	mv	s1,a0
    if (ip == 0)
    8000615a:	c959                	beqz	a0,800061f0 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV))
    8000615c:	04449703          	lh	a4,68(s1)
    80006160:	478d                	li	a5,3
    80006162:	00f71763          	bne	a4,a5,80006170 <sys_open+0x72>
    80006166:	0464d703          	lhu	a4,70(s1)
    8000616a:	47a5                	li	a5,9
    8000616c:	0ce7ed63          	bltu	a5,a4,80006246 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
    80006170:	fffff097          	auipc	ra,0xfffff
    80006174:	dbe080e7          	jalr	-578(ra) # 80004f2e <filealloc>
    80006178:	89aa                	mv	s3,a0
    8000617a:	10050363          	beqz	a0,80006280 <sys_open+0x182>
    8000617e:	00000097          	auipc	ra,0x0
    80006182:	906080e7          	jalr	-1786(ra) # 80005a84 <fdalloc>
    80006186:	892a                	mv	s2,a0
    80006188:	0e054763          	bltz	a0,80006276 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE)
    8000618c:	04449703          	lh	a4,68(s1)
    80006190:	478d                	li	a5,3
    80006192:	0cf70563          	beq	a4,a5,8000625c <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  }
  else
  {
    f->type = FD_INODE;
    80006196:	4789                	li	a5,2
    80006198:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    8000619c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    800061a0:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    800061a4:	f4c42783          	lw	a5,-180(s0)
    800061a8:	0017c713          	xori	a4,a5,1
    800061ac:	8b05                	andi	a4,a4,1
    800061ae:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800061b2:	0037f713          	andi	a4,a5,3
    800061b6:	00e03733          	snez	a4,a4
    800061ba:	00e984a3          	sb	a4,9(s3)

  if ((omode & O_TRUNC) && ip->type == T_FILE)
    800061be:	4007f793          	andi	a5,a5,1024
    800061c2:	c791                	beqz	a5,800061ce <sys_open+0xd0>
    800061c4:	04449703          	lh	a4,68(s1)
    800061c8:	4789                	li	a5,2
    800061ca:	0af70063          	beq	a4,a5,8000626a <sys_open+0x16c>
  {
    itrunc(ip);
  }

  iunlock(ip);
    800061ce:	8526                	mv	a0,s1
    800061d0:	ffffe097          	auipc	ra,0xffffe
    800061d4:	04e080e7          	jalr	78(ra) # 8000421e <iunlock>
  end_op();
    800061d8:	fffff097          	auipc	ra,0xfffff
    800061dc:	9c6080e7          	jalr	-1594(ra) # 80004b9e <end_op>

  return fd;
    800061e0:	854a                	mv	a0,s2
}
    800061e2:	70ea                	ld	ra,184(sp)
    800061e4:	744a                	ld	s0,176(sp)
    800061e6:	74aa                	ld	s1,168(sp)
    800061e8:	790a                	ld	s2,160(sp)
    800061ea:	69ea                	ld	s3,152(sp)
    800061ec:	6129                	addi	sp,sp,192
    800061ee:	8082                	ret
      end_op();
    800061f0:	fffff097          	auipc	ra,0xfffff
    800061f4:	9ae080e7          	jalr	-1618(ra) # 80004b9e <end_op>
      return -1;
    800061f8:	557d                	li	a0,-1
    800061fa:	b7e5                	j	800061e2 <sys_open+0xe4>
    if ((ip = namei(path)) == 0)
    800061fc:	f5040513          	addi	a0,s0,-176
    80006200:	ffffe097          	auipc	ra,0xffffe
    80006204:	702080e7          	jalr	1794(ra) # 80004902 <namei>
    80006208:	84aa                	mv	s1,a0
    8000620a:	c905                	beqz	a0,8000623a <sys_open+0x13c>
    ilock(ip);
    8000620c:	ffffe097          	auipc	ra,0xffffe
    80006210:	f50080e7          	jalr	-176(ra) # 8000415c <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
    80006214:	04449703          	lh	a4,68(s1)
    80006218:	4785                	li	a5,1
    8000621a:	f4f711e3          	bne	a4,a5,8000615c <sys_open+0x5e>
    8000621e:	f4c42783          	lw	a5,-180(s0)
    80006222:	d7b9                	beqz	a5,80006170 <sys_open+0x72>
      iunlockput(ip);
    80006224:	8526                	mv	a0,s1
    80006226:	ffffe097          	auipc	ra,0xffffe
    8000622a:	198080e7          	jalr	408(ra) # 800043be <iunlockput>
      end_op();
    8000622e:	fffff097          	auipc	ra,0xfffff
    80006232:	970080e7          	jalr	-1680(ra) # 80004b9e <end_op>
      return -1;
    80006236:	557d                	li	a0,-1
    80006238:	b76d                	j	800061e2 <sys_open+0xe4>
      end_op();
    8000623a:	fffff097          	auipc	ra,0xfffff
    8000623e:	964080e7          	jalr	-1692(ra) # 80004b9e <end_op>
      return -1;
    80006242:	557d                	li	a0,-1
    80006244:	bf79                	j	800061e2 <sys_open+0xe4>
    iunlockput(ip);
    80006246:	8526                	mv	a0,s1
    80006248:	ffffe097          	auipc	ra,0xffffe
    8000624c:	176080e7          	jalr	374(ra) # 800043be <iunlockput>
    end_op();
    80006250:	fffff097          	auipc	ra,0xfffff
    80006254:	94e080e7          	jalr	-1714(ra) # 80004b9e <end_op>
    return -1;
    80006258:	557d                	li	a0,-1
    8000625a:	b761                	j	800061e2 <sys_open+0xe4>
    f->type = FD_DEVICE;
    8000625c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80006260:	04649783          	lh	a5,70(s1)
    80006264:	02f99223          	sh	a5,36(s3)
    80006268:	bf25                	j	800061a0 <sys_open+0xa2>
    itrunc(ip);
    8000626a:	8526                	mv	a0,s1
    8000626c:	ffffe097          	auipc	ra,0xffffe
    80006270:	ffe080e7          	jalr	-2(ra) # 8000426a <itrunc>
    80006274:	bfa9                	j	800061ce <sys_open+0xd0>
      fileclose(f);
    80006276:	854e                	mv	a0,s3
    80006278:	fffff097          	auipc	ra,0xfffff
    8000627c:	d72080e7          	jalr	-654(ra) # 80004fea <fileclose>
    iunlockput(ip);
    80006280:	8526                	mv	a0,s1
    80006282:	ffffe097          	auipc	ra,0xffffe
    80006286:	13c080e7          	jalr	316(ra) # 800043be <iunlockput>
    end_op();
    8000628a:	fffff097          	auipc	ra,0xfffff
    8000628e:	914080e7          	jalr	-1772(ra) # 80004b9e <end_op>
    return -1;
    80006292:	557d                	li	a0,-1
    80006294:	b7b9                	j	800061e2 <sys_open+0xe4>

0000000080006296 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80006296:	7175                	addi	sp,sp,-144
    80006298:	e506                	sd	ra,136(sp)
    8000629a:	e122                	sd	s0,128(sp)
    8000629c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000629e:	fffff097          	auipc	ra,0xfffff
    800062a2:	880080e7          	jalr	-1920(ra) # 80004b1e <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
    800062a6:	08000613          	li	a2,128
    800062aa:	f7040593          	addi	a1,s0,-144
    800062ae:	4501                	li	a0,0
    800062b0:	ffffd097          	auipc	ra,0xffffd
    800062b4:	10e080e7          	jalr	270(ra) # 800033be <argstr>
    800062b8:	02054963          	bltz	a0,800062ea <sys_mkdir+0x54>
    800062bc:	4681                	li	a3,0
    800062be:	4601                	li	a2,0
    800062c0:	4585                	li	a1,1
    800062c2:	f7040513          	addi	a0,s0,-144
    800062c6:	00000097          	auipc	ra,0x0
    800062ca:	800080e7          	jalr	-2048(ra) # 80005ac6 <create>
    800062ce:	cd11                	beqz	a0,800062ea <sys_mkdir+0x54>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    800062d0:	ffffe097          	auipc	ra,0xffffe
    800062d4:	0ee080e7          	jalr	238(ra) # 800043be <iunlockput>
  end_op();
    800062d8:	fffff097          	auipc	ra,0xfffff
    800062dc:	8c6080e7          	jalr	-1850(ra) # 80004b9e <end_op>
  return 0;
    800062e0:	4501                	li	a0,0
}
    800062e2:	60aa                	ld	ra,136(sp)
    800062e4:	640a                	ld	s0,128(sp)
    800062e6:	6149                	addi	sp,sp,144
    800062e8:	8082                	ret
    end_op();
    800062ea:	fffff097          	auipc	ra,0xfffff
    800062ee:	8b4080e7          	jalr	-1868(ra) # 80004b9e <end_op>
    return -1;
    800062f2:	557d                	li	a0,-1
    800062f4:	b7fd                	j	800062e2 <sys_mkdir+0x4c>

00000000800062f6 <sys_mknod>:

uint64
sys_mknod(void)
{
    800062f6:	7135                	addi	sp,sp,-160
    800062f8:	ed06                	sd	ra,152(sp)
    800062fa:	e922                	sd	s0,144(sp)
    800062fc:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800062fe:	fffff097          	auipc	ra,0xfffff
    80006302:	820080e7          	jalr	-2016(ra) # 80004b1e <begin_op>
  argint(1, &major);
    80006306:	f6c40593          	addi	a1,s0,-148
    8000630a:	4505                	li	a0,1
    8000630c:	ffffd097          	auipc	ra,0xffffd
    80006310:	072080e7          	jalr	114(ra) # 8000337e <argint>
  argint(2, &minor);
    80006314:	f6840593          	addi	a1,s0,-152
    80006318:	4509                	li	a0,2
    8000631a:	ffffd097          	auipc	ra,0xffffd
    8000631e:	064080e7          	jalr	100(ra) # 8000337e <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80006322:	08000613          	li	a2,128
    80006326:	f7040593          	addi	a1,s0,-144
    8000632a:	4501                	li	a0,0
    8000632c:	ffffd097          	auipc	ra,0xffffd
    80006330:	092080e7          	jalr	146(ra) # 800033be <argstr>
    80006334:	02054b63          	bltz	a0,8000636a <sys_mknod+0x74>
      (ip = create(path, T_DEVICE, major, minor)) == 0)
    80006338:	f6841683          	lh	a3,-152(s0)
    8000633c:	f6c41603          	lh	a2,-148(s0)
    80006340:	458d                	li	a1,3
    80006342:	f7040513          	addi	a0,s0,-144
    80006346:	fffff097          	auipc	ra,0xfffff
    8000634a:	780080e7          	jalr	1920(ra) # 80005ac6 <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    8000634e:	cd11                	beqz	a0,8000636a <sys_mknod+0x74>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    80006350:	ffffe097          	auipc	ra,0xffffe
    80006354:	06e080e7          	jalr	110(ra) # 800043be <iunlockput>
  end_op();
    80006358:	fffff097          	auipc	ra,0xfffff
    8000635c:	846080e7          	jalr	-1978(ra) # 80004b9e <end_op>
  return 0;
    80006360:	4501                	li	a0,0
}
    80006362:	60ea                	ld	ra,152(sp)
    80006364:	644a                	ld	s0,144(sp)
    80006366:	610d                	addi	sp,sp,160
    80006368:	8082                	ret
    end_op();
    8000636a:	fffff097          	auipc	ra,0xfffff
    8000636e:	834080e7          	jalr	-1996(ra) # 80004b9e <end_op>
    return -1;
    80006372:	557d                	li	a0,-1
    80006374:	b7fd                	j	80006362 <sys_mknod+0x6c>

0000000080006376 <sys_chdir>:

uint64
sys_chdir(void)
{
    80006376:	7135                	addi	sp,sp,-160
    80006378:	ed06                	sd	ra,152(sp)
    8000637a:	e922                	sd	s0,144(sp)
    8000637c:	e526                	sd	s1,136(sp)
    8000637e:	e14a                	sd	s2,128(sp)
    80006380:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80006382:	ffffc097          	auipc	ra,0xffffc
    80006386:	86c080e7          	jalr	-1940(ra) # 80001bee <myproc>
    8000638a:	892a                	mv	s2,a0

  begin_op();
    8000638c:	ffffe097          	auipc	ra,0xffffe
    80006390:	792080e7          	jalr	1938(ra) # 80004b1e <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
    80006394:	08000613          	li	a2,128
    80006398:	f6040593          	addi	a1,s0,-160
    8000639c:	4501                	li	a0,0
    8000639e:	ffffd097          	auipc	ra,0xffffd
    800063a2:	020080e7          	jalr	32(ra) # 800033be <argstr>
    800063a6:	04054b63          	bltz	a0,800063fc <sys_chdir+0x86>
    800063aa:	f6040513          	addi	a0,s0,-160
    800063ae:	ffffe097          	auipc	ra,0xffffe
    800063b2:	554080e7          	jalr	1364(ra) # 80004902 <namei>
    800063b6:	84aa                	mv	s1,a0
    800063b8:	c131                	beqz	a0,800063fc <sys_chdir+0x86>
  {
    end_op();
    return -1;
  }
  ilock(ip);
    800063ba:	ffffe097          	auipc	ra,0xffffe
    800063be:	da2080e7          	jalr	-606(ra) # 8000415c <ilock>
  if (ip->type != T_DIR)
    800063c2:	04449703          	lh	a4,68(s1)
    800063c6:	4785                	li	a5,1
    800063c8:	04f71063          	bne	a4,a5,80006408 <sys_chdir+0x92>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800063cc:	8526                	mv	a0,s1
    800063ce:	ffffe097          	auipc	ra,0xffffe
    800063d2:	e50080e7          	jalr	-432(ra) # 8000421e <iunlock>
  iput(p->cwd);
    800063d6:	15093503          	ld	a0,336(s2)
    800063da:	ffffe097          	auipc	ra,0xffffe
    800063de:	f3c080e7          	jalr	-196(ra) # 80004316 <iput>
  end_op();
    800063e2:	ffffe097          	auipc	ra,0xffffe
    800063e6:	7bc080e7          	jalr	1980(ra) # 80004b9e <end_op>
  p->cwd = ip;
    800063ea:	14993823          	sd	s1,336(s2)
  return 0;
    800063ee:	4501                	li	a0,0
}
    800063f0:	60ea                	ld	ra,152(sp)
    800063f2:	644a                	ld	s0,144(sp)
    800063f4:	64aa                	ld	s1,136(sp)
    800063f6:	690a                	ld	s2,128(sp)
    800063f8:	610d                	addi	sp,sp,160
    800063fa:	8082                	ret
    end_op();
    800063fc:	ffffe097          	auipc	ra,0xffffe
    80006400:	7a2080e7          	jalr	1954(ra) # 80004b9e <end_op>
    return -1;
    80006404:	557d                	li	a0,-1
    80006406:	b7ed                	j	800063f0 <sys_chdir+0x7a>
    iunlockput(ip);
    80006408:	8526                	mv	a0,s1
    8000640a:	ffffe097          	auipc	ra,0xffffe
    8000640e:	fb4080e7          	jalr	-76(ra) # 800043be <iunlockput>
    end_op();
    80006412:	ffffe097          	auipc	ra,0xffffe
    80006416:	78c080e7          	jalr	1932(ra) # 80004b9e <end_op>
    return -1;
    8000641a:	557d                	li	a0,-1
    8000641c:	bfd1                	j	800063f0 <sys_chdir+0x7a>

000000008000641e <sys_exec>:

uint64
sys_exec(void)
{
    8000641e:	7145                	addi	sp,sp,-464
    80006420:	e786                	sd	ra,456(sp)
    80006422:	e3a2                	sd	s0,448(sp)
    80006424:	ff26                	sd	s1,440(sp)
    80006426:	fb4a                	sd	s2,432(sp)
    80006428:	f74e                	sd	s3,424(sp)
    8000642a:	f352                	sd	s4,416(sp)
    8000642c:	ef56                	sd	s5,408(sp)
    8000642e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80006430:	e3840593          	addi	a1,s0,-456
    80006434:	4505                	li	a0,1
    80006436:	ffffd097          	auipc	ra,0xffffd
    8000643a:	f68080e7          	jalr	-152(ra) # 8000339e <argaddr>
  if (argstr(0, path, MAXPATH) < 0)
    8000643e:	08000613          	li	a2,128
    80006442:	f4040593          	addi	a1,s0,-192
    80006446:	4501                	li	a0,0
    80006448:	ffffd097          	auipc	ra,0xffffd
    8000644c:	f76080e7          	jalr	-138(ra) # 800033be <argstr>
    80006450:	87aa                	mv	a5,a0
  {
    return -1;
    80006452:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0)
    80006454:	0c07c263          	bltz	a5,80006518 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80006458:	10000613          	li	a2,256
    8000645c:	4581                	li	a1,0
    8000645e:	e4040513          	addi	a0,s0,-448
    80006462:	ffffb097          	auipc	ra,0xffffb
    80006466:	a2c080e7          	jalr	-1492(ra) # 80000e8e <memset>
  for (i = 0;; i++)
  {
    if (i >= NELEM(argv))
    8000646a:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    8000646e:	89a6                	mv	s3,s1
    80006470:	4901                	li	s2,0
    if (i >= NELEM(argv))
    80006472:	02000a13          	li	s4,32
    80006476:	00090a9b          	sext.w	s5,s2
    {
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0)
    8000647a:	00391793          	slli	a5,s2,0x3
    8000647e:	e3040593          	addi	a1,s0,-464
    80006482:	e3843503          	ld	a0,-456(s0)
    80006486:	953e                	add	a0,a0,a5
    80006488:	ffffd097          	auipc	ra,0xffffd
    8000648c:	e58080e7          	jalr	-424(ra) # 800032e0 <fetchaddr>
    80006490:	02054a63          	bltz	a0,800064c4 <sys_exec+0xa6>
    {
      goto bad;
    }
    if (uarg == 0)
    80006494:	e3043783          	ld	a5,-464(s0)
    80006498:	c3b9                	beqz	a5,800064de <sys_exec+0xc0>
    {
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000649a:	ffffa097          	auipc	ra,0xffffa
    8000649e:	7b4080e7          	jalr	1972(ra) # 80000c4e <kalloc>
    800064a2:	85aa                	mv	a1,a0
    800064a4:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    800064a8:	cd11                	beqz	a0,800064c4 <sys_exec+0xa6>
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    800064aa:	6605                	lui	a2,0x1
    800064ac:	e3043503          	ld	a0,-464(s0)
    800064b0:	ffffd097          	auipc	ra,0xffffd
    800064b4:	e82080e7          	jalr	-382(ra) # 80003332 <fetchstr>
    800064b8:	00054663          	bltz	a0,800064c4 <sys_exec+0xa6>
    if (i >= NELEM(argv))
    800064bc:	0905                	addi	s2,s2,1
    800064be:	09a1                	addi	s3,s3,8
    800064c0:	fb491be3          	bne	s2,s4,80006476 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800064c4:	10048913          	addi	s2,s1,256
    800064c8:	6088                	ld	a0,0(s1)
    800064ca:	c531                	beqz	a0,80006516 <sys_exec+0xf8>
    kfree(argv[i]);
    800064cc:	ffffa097          	auipc	ra,0xffffa
    800064d0:	5aa080e7          	jalr	1450(ra) # 80000a76 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800064d4:	04a1                	addi	s1,s1,8
    800064d6:	ff2499e3          	bne	s1,s2,800064c8 <sys_exec+0xaa>
  return -1;
    800064da:	557d                	li	a0,-1
    800064dc:	a835                	j	80006518 <sys_exec+0xfa>
      argv[i] = 0;
    800064de:	0a8e                	slli	s5,s5,0x3
    800064e0:	fc040793          	addi	a5,s0,-64
    800064e4:	9abe                	add	s5,s5,a5
    800064e6:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800064ea:	e4040593          	addi	a1,s0,-448
    800064ee:	f4040513          	addi	a0,s0,-192
    800064f2:	fffff097          	auipc	ra,0xfffff
    800064f6:	172080e7          	jalr	370(ra) # 80005664 <exec>
    800064fa:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800064fc:	10048993          	addi	s3,s1,256
    80006500:	6088                	ld	a0,0(s1)
    80006502:	c901                	beqz	a0,80006512 <sys_exec+0xf4>
    kfree(argv[i]);
    80006504:	ffffa097          	auipc	ra,0xffffa
    80006508:	572080e7          	jalr	1394(ra) # 80000a76 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000650c:	04a1                	addi	s1,s1,8
    8000650e:	ff3499e3          	bne	s1,s3,80006500 <sys_exec+0xe2>
  return ret;
    80006512:	854a                	mv	a0,s2
    80006514:	a011                	j	80006518 <sys_exec+0xfa>
  return -1;
    80006516:	557d                	li	a0,-1
}
    80006518:	60be                	ld	ra,456(sp)
    8000651a:	641e                	ld	s0,448(sp)
    8000651c:	74fa                	ld	s1,440(sp)
    8000651e:	795a                	ld	s2,432(sp)
    80006520:	79ba                	ld	s3,424(sp)
    80006522:	7a1a                	ld	s4,416(sp)
    80006524:	6afa                	ld	s5,408(sp)
    80006526:	6179                	addi	sp,sp,464
    80006528:	8082                	ret

000000008000652a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000652a:	7139                	addi	sp,sp,-64
    8000652c:	fc06                	sd	ra,56(sp)
    8000652e:	f822                	sd	s0,48(sp)
    80006530:	f426                	sd	s1,40(sp)
    80006532:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006534:	ffffb097          	auipc	ra,0xffffb
    80006538:	6ba080e7          	jalr	1722(ra) # 80001bee <myproc>
    8000653c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000653e:	fd840593          	addi	a1,s0,-40
    80006542:	4501                	li	a0,0
    80006544:	ffffd097          	auipc	ra,0xffffd
    80006548:	e5a080e7          	jalr	-422(ra) # 8000339e <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    8000654c:	fc840593          	addi	a1,s0,-56
    80006550:	fd040513          	addi	a0,s0,-48
    80006554:	fffff097          	auipc	ra,0xfffff
    80006558:	dc6080e7          	jalr	-570(ra) # 8000531a <pipealloc>
    return -1;
    8000655c:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    8000655e:	0c054463          	bltz	a0,80006626 <sys_pipe+0xfc>
  fd0 = -1;
    80006562:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
    80006566:	fd043503          	ld	a0,-48(s0)
    8000656a:	fffff097          	auipc	ra,0xfffff
    8000656e:	51a080e7          	jalr	1306(ra) # 80005a84 <fdalloc>
    80006572:	fca42223          	sw	a0,-60(s0)
    80006576:	08054b63          	bltz	a0,8000660c <sys_pipe+0xe2>
    8000657a:	fc843503          	ld	a0,-56(s0)
    8000657e:	fffff097          	auipc	ra,0xfffff
    80006582:	506080e7          	jalr	1286(ra) # 80005a84 <fdalloc>
    80006586:	fca42023          	sw	a0,-64(s0)
    8000658a:	06054863          	bltz	a0,800065fa <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    8000658e:	4691                	li	a3,4
    80006590:	fc440613          	addi	a2,s0,-60
    80006594:	fd843583          	ld	a1,-40(s0)
    80006598:	68a8                	ld	a0,80(s1)
    8000659a:	ffffb097          	auipc	ra,0xffffb
    8000659e:	2a8080e7          	jalr	680(ra) # 80001842 <copyout>
    800065a2:	02054063          	bltz	a0,800065c2 <sys_pipe+0x98>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0)
    800065a6:	4691                	li	a3,4
    800065a8:	fc040613          	addi	a2,s0,-64
    800065ac:	fd843583          	ld	a1,-40(s0)
    800065b0:	0591                	addi	a1,a1,4
    800065b2:	68a8                	ld	a0,80(s1)
    800065b4:	ffffb097          	auipc	ra,0xffffb
    800065b8:	28e080e7          	jalr	654(ra) # 80001842 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800065bc:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800065be:	06055463          	bgez	a0,80006626 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800065c2:	fc442783          	lw	a5,-60(s0)
    800065c6:	07e9                	addi	a5,a5,26
    800065c8:	078e                	slli	a5,a5,0x3
    800065ca:	97a6                	add	a5,a5,s1
    800065cc:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800065d0:	fc042503          	lw	a0,-64(s0)
    800065d4:	0569                	addi	a0,a0,26
    800065d6:	050e                	slli	a0,a0,0x3
    800065d8:	94aa                	add	s1,s1,a0
    800065da:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800065de:	fd043503          	ld	a0,-48(s0)
    800065e2:	fffff097          	auipc	ra,0xfffff
    800065e6:	a08080e7          	jalr	-1528(ra) # 80004fea <fileclose>
    fileclose(wf);
    800065ea:	fc843503          	ld	a0,-56(s0)
    800065ee:	fffff097          	auipc	ra,0xfffff
    800065f2:	9fc080e7          	jalr	-1540(ra) # 80004fea <fileclose>
    return -1;
    800065f6:	57fd                	li	a5,-1
    800065f8:	a03d                	j	80006626 <sys_pipe+0xfc>
    if (fd0 >= 0)
    800065fa:	fc442783          	lw	a5,-60(s0)
    800065fe:	0007c763          	bltz	a5,8000660c <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80006602:	07e9                	addi	a5,a5,26
    80006604:	078e                	slli	a5,a5,0x3
    80006606:	94be                	add	s1,s1,a5
    80006608:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000660c:	fd043503          	ld	a0,-48(s0)
    80006610:	fffff097          	auipc	ra,0xfffff
    80006614:	9da080e7          	jalr	-1574(ra) # 80004fea <fileclose>
    fileclose(wf);
    80006618:	fc843503          	ld	a0,-56(s0)
    8000661c:	fffff097          	auipc	ra,0xfffff
    80006620:	9ce080e7          	jalr	-1586(ra) # 80004fea <fileclose>
    return -1;
    80006624:	57fd                	li	a5,-1
}
    80006626:	853e                	mv	a0,a5
    80006628:	70e2                	ld	ra,56(sp)
    8000662a:	7442                	ld	s0,48(sp)
    8000662c:	74a2                	ld	s1,40(sp)
    8000662e:	6121                	addi	sp,sp,64
    80006630:	8082                	ret
	...

0000000080006640 <kernelvec>:
    80006640:	7111                	addi	sp,sp,-256
    80006642:	e006                	sd	ra,0(sp)
    80006644:	e40a                	sd	sp,8(sp)
    80006646:	e80e                	sd	gp,16(sp)
    80006648:	ec12                	sd	tp,24(sp)
    8000664a:	f016                	sd	t0,32(sp)
    8000664c:	f41a                	sd	t1,40(sp)
    8000664e:	f81e                	sd	t2,48(sp)
    80006650:	fc22                	sd	s0,56(sp)
    80006652:	e0a6                	sd	s1,64(sp)
    80006654:	e4aa                	sd	a0,72(sp)
    80006656:	e8ae                	sd	a1,80(sp)
    80006658:	ecb2                	sd	a2,88(sp)
    8000665a:	f0b6                	sd	a3,96(sp)
    8000665c:	f4ba                	sd	a4,104(sp)
    8000665e:	f8be                	sd	a5,112(sp)
    80006660:	fcc2                	sd	a6,120(sp)
    80006662:	e146                	sd	a7,128(sp)
    80006664:	e54a                	sd	s2,136(sp)
    80006666:	e94e                	sd	s3,144(sp)
    80006668:	ed52                	sd	s4,152(sp)
    8000666a:	f156                	sd	s5,160(sp)
    8000666c:	f55a                	sd	s6,168(sp)
    8000666e:	f95e                	sd	s7,176(sp)
    80006670:	fd62                	sd	s8,184(sp)
    80006672:	e1e6                	sd	s9,192(sp)
    80006674:	e5ea                	sd	s10,200(sp)
    80006676:	e9ee                	sd	s11,208(sp)
    80006678:	edf2                	sd	t3,216(sp)
    8000667a:	f1f6                	sd	t4,224(sp)
    8000667c:	f5fa                	sd	t5,232(sp)
    8000667e:	f9fe                	sd	t6,240(sp)
    80006680:	8bdfc0ef          	jal	ra,80002f3c <kerneltrap>
    80006684:	6082                	ld	ra,0(sp)
    80006686:	6122                	ld	sp,8(sp)
    80006688:	61c2                	ld	gp,16(sp)
    8000668a:	7282                	ld	t0,32(sp)
    8000668c:	7322                	ld	t1,40(sp)
    8000668e:	73c2                	ld	t2,48(sp)
    80006690:	7462                	ld	s0,56(sp)
    80006692:	6486                	ld	s1,64(sp)
    80006694:	6526                	ld	a0,72(sp)
    80006696:	65c6                	ld	a1,80(sp)
    80006698:	6666                	ld	a2,88(sp)
    8000669a:	7686                	ld	a3,96(sp)
    8000669c:	7726                	ld	a4,104(sp)
    8000669e:	77c6                	ld	a5,112(sp)
    800066a0:	7866                	ld	a6,120(sp)
    800066a2:	688a                	ld	a7,128(sp)
    800066a4:	692a                	ld	s2,136(sp)
    800066a6:	69ca                	ld	s3,144(sp)
    800066a8:	6a6a                	ld	s4,152(sp)
    800066aa:	7a8a                	ld	s5,160(sp)
    800066ac:	7b2a                	ld	s6,168(sp)
    800066ae:	7bca                	ld	s7,176(sp)
    800066b0:	7c6a                	ld	s8,184(sp)
    800066b2:	6c8e                	ld	s9,192(sp)
    800066b4:	6d2e                	ld	s10,200(sp)
    800066b6:	6dce                	ld	s11,208(sp)
    800066b8:	6e6e                	ld	t3,216(sp)
    800066ba:	7e8e                	ld	t4,224(sp)
    800066bc:	7f2e                	ld	t5,232(sp)
    800066be:	7fce                	ld	t6,240(sp)
    800066c0:	6111                	addi	sp,sp,256
    800066c2:	10200073          	sret
    800066c6:	00000013          	nop
    800066ca:	00000013          	nop
    800066ce:	0001                	nop

00000000800066d0 <timervec>:
    800066d0:	34051573          	csrrw	a0,mscratch,a0
    800066d4:	e10c                	sd	a1,0(a0)
    800066d6:	e510                	sd	a2,8(a0)
    800066d8:	e914                	sd	a3,16(a0)
    800066da:	6d0c                	ld	a1,24(a0)
    800066dc:	7110                	ld	a2,32(a0)
    800066de:	6194                	ld	a3,0(a1)
    800066e0:	96b2                	add	a3,a3,a2
    800066e2:	e194                	sd	a3,0(a1)
    800066e4:	4589                	li	a1,2
    800066e6:	14459073          	csrw	sip,a1
    800066ea:	6914                	ld	a3,16(a0)
    800066ec:	6510                	ld	a2,8(a0)
    800066ee:	610c                	ld	a1,0(a0)
    800066f0:	34051573          	csrrw	a0,mscratch,a0
    800066f4:	30200073          	mret
	...

00000000800066fa <plicinit>:
//
// the riscv Platform Level Interrupt Controller (PLIC).
//

void plicinit(void)
{
    800066fa:	1141                	addi	sp,sp,-16
    800066fc:	e422                	sd	s0,8(sp)
    800066fe:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32 *)(PLIC + UART0_IRQ * 4) = 1;
    80006700:	0c0007b7          	lui	a5,0xc000
    80006704:	4705                	li	a4,1
    80006706:	d798                	sw	a4,40(a5)
  *(uint32 *)(PLIC + VIRTIO0_IRQ * 4) = 1;
    80006708:	c3d8                	sw	a4,4(a5)
}
    8000670a:	6422                	ld	s0,8(sp)
    8000670c:	0141                	addi	sp,sp,16
    8000670e:	8082                	ret

0000000080006710 <plicinithart>:

void plicinithart(void)
{
    80006710:	1141                	addi	sp,sp,-16
    80006712:	e406                	sd	ra,8(sp)
    80006714:	e022                	sd	s0,0(sp)
    80006716:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006718:	ffffb097          	auipc	ra,0xffffb
    8000671c:	4aa080e7          	jalr	1194(ra) # 80001bc2 <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32 *)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006720:	0085171b          	slliw	a4,a0,0x8
    80006724:	0c0027b7          	lui	a5,0xc002
    80006728:	97ba                	add	a5,a5,a4
    8000672a:	40200713          	li	a4,1026
    8000672e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32 *)PLIC_SPRIORITY(hart) = 0;
    80006732:	00d5151b          	slliw	a0,a0,0xd
    80006736:	0c2017b7          	lui	a5,0xc201
    8000673a:	953e                	add	a0,a0,a5
    8000673c:	00052023          	sw	zero,0(a0)
}
    80006740:	60a2                	ld	ra,8(sp)
    80006742:	6402                	ld	s0,0(sp)
    80006744:	0141                	addi	sp,sp,16
    80006746:	8082                	ret

0000000080006748 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int plic_claim(void)
{
    80006748:	1141                	addi	sp,sp,-16
    8000674a:	e406                	sd	ra,8(sp)
    8000674c:	e022                	sd	s0,0(sp)
    8000674e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006750:	ffffb097          	auipc	ra,0xffffb
    80006754:	472080e7          	jalr	1138(ra) # 80001bc2 <cpuid>
  int irq = *(uint32 *)PLIC_SCLAIM(hart);
    80006758:	00d5179b          	slliw	a5,a0,0xd
    8000675c:	0c201537          	lui	a0,0xc201
    80006760:	953e                	add	a0,a0,a5
  return irq;
}
    80006762:	4148                	lw	a0,4(a0)
    80006764:	60a2                	ld	ra,8(sp)
    80006766:	6402                	ld	s0,0(sp)
    80006768:	0141                	addi	sp,sp,16
    8000676a:	8082                	ret

000000008000676c <plic_complete>:

// tell the PLIC we've served this IRQ.
void plic_complete(int irq)
{
    8000676c:	1101                	addi	sp,sp,-32
    8000676e:	ec06                	sd	ra,24(sp)
    80006770:	e822                	sd	s0,16(sp)
    80006772:	e426                	sd	s1,8(sp)
    80006774:	1000                	addi	s0,sp,32
    80006776:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006778:	ffffb097          	auipc	ra,0xffffb
    8000677c:	44a080e7          	jalr	1098(ra) # 80001bc2 <cpuid>
  *(uint32 *)PLIC_SCLAIM(hart) = irq;
    80006780:	00d5151b          	slliw	a0,a0,0xd
    80006784:	0c2017b7          	lui	a5,0xc201
    80006788:	97aa                	add	a5,a5,a0
    8000678a:	c3c4                	sw	s1,4(a5)
}
    8000678c:	60e2                	ld	ra,24(sp)
    8000678e:	6442                	ld	s0,16(sp)
    80006790:	64a2                	ld	s1,8(sp)
    80006792:	6105                	addi	sp,sp,32
    80006794:	8082                	ret

0000000080006796 <sgenrand>:
static unsigned long mt[N]; /* the array for the state vector  */
static int mti = N + 1;     /* mti==N+1 means mt[N] is not initialized */

/* initializing the array with a NONZERO seed */
void sgenrand(unsigned long seed)
{
    80006796:	1141                	addi	sp,sp,-16
    80006798:	e422                	sd	s0,8(sp)
    8000679a:	0800                	addi	s0,sp,16
    /* setting initial seeds to mt[N] using         */
    /* the generator Line 25 of Table 1 in          */
    /* [KNUTH 1981, The Art of Computer Programming */
    /*    Vol. 2 (2nd Ed.), pp102]                  */
    mt[0] = seed & 0xffffffff;
    8000679c:	0023e717          	auipc	a4,0x23e
    800067a0:	7bc70713          	addi	a4,a4,1980 # 80244f58 <mt>
    800067a4:	1502                	slli	a0,a0,0x20
    800067a6:	9101                	srli	a0,a0,0x20
    800067a8:	e308                	sd	a0,0(a4)
    for (mti = 1; mti < N; mti++)
    800067aa:	00240597          	auipc	a1,0x240
    800067ae:	b2658593          	addi	a1,a1,-1242 # 802462d0 <mt+0x1378>
        mt[mti] = (69069 * mt[mti - 1]) & 0xffffffff;
    800067b2:	6645                	lui	a2,0x11
    800067b4:	dcd60613          	addi	a2,a2,-563 # 10dcd <_entry-0x7ffef233>
    800067b8:	56fd                	li	a3,-1
    800067ba:	9281                	srli	a3,a3,0x20
    800067bc:	631c                	ld	a5,0(a4)
    800067be:	02c787b3          	mul	a5,a5,a2
    800067c2:	8ff5                	and	a5,a5,a3
    800067c4:	e71c                	sd	a5,8(a4)
    for (mti = 1; mti < N; mti++)
    800067c6:	0721                	addi	a4,a4,8
    800067c8:	feb71ae3          	bne	a4,a1,800067bc <sgenrand+0x26>
    800067cc:	27000793          	li	a5,624
    800067d0:	00003717          	auipc	a4,0x3
    800067d4:	24f72423          	sw	a5,584(a4) # 80009a18 <mti>
}
    800067d8:	6422                	ld	s0,8(sp)
    800067da:	0141                	addi	sp,sp,16
    800067dc:	8082                	ret

00000000800067de <genrand>:

long /* for integer generation */
genrand()
{
    800067de:	1141                	addi	sp,sp,-16
    800067e0:	e406                	sd	ra,8(sp)
    800067e2:	e022                	sd	s0,0(sp)
    800067e4:	0800                	addi	s0,sp,16
    unsigned long y;
    static unsigned long mag01[2] = {0x0, MATRIX_A};
    /* mag01[x] = x * MATRIX_A  for x=0,1 */

    if (mti >= N)
    800067e6:	00003797          	auipc	a5,0x3
    800067ea:	2327a783          	lw	a5,562(a5) # 80009a18 <mti>
    800067ee:	26f00713          	li	a4,623
    800067f2:	0ef75963          	bge	a4,a5,800068e4 <genrand+0x106>
    { /* generate N words at one time */
        int kk;

        if (mti == N + 1)   /* if sgenrand() has not been called, */
    800067f6:	27100713          	li	a4,625
    800067fa:	12e78f63          	beq	a5,a4,80006938 <genrand+0x15a>
            sgenrand(4357); /* a default initial seed is used   */

        for (kk = 0; kk < N - M; kk++)
    800067fe:	0023e817          	auipc	a6,0x23e
    80006802:	75a80813          	addi	a6,a6,1882 # 80244f58 <mt>
    80006806:	0023fe17          	auipc	t3,0x23f
    8000680a:	e6ae0e13          	addi	t3,t3,-406 # 80245670 <mt+0x718>
{
    8000680e:	8742                	mv	a4,a6
        {
            y = (mt[kk] & UPPER_MASK) | (mt[kk + 1] & LOWER_MASK);
    80006810:	4885                	li	a7,1
    80006812:	08fe                	slli	a7,a7,0x1f
    80006814:	80000537          	lui	a0,0x80000
    80006818:	fff54513          	not	a0,a0
            mt[kk] = mt[kk + M] ^ (y >> 1) ^ mag01[y & 0x1];
    8000681c:	6585                	lui	a1,0x1
    8000681e:	c6858593          	addi	a1,a1,-920 # c68 <_entry-0x7ffff398>
    80006822:	00003317          	auipc	t1,0x3
    80006826:	0d630313          	addi	t1,t1,214 # 800098f8 <mag01.0>
            y = (mt[kk] & UPPER_MASK) | (mt[kk + 1] & LOWER_MASK);
    8000682a:	631c                	ld	a5,0(a4)
    8000682c:	0117f7b3          	and	a5,a5,a7
    80006830:	6714                	ld	a3,8(a4)
    80006832:	8ee9                	and	a3,a3,a0
    80006834:	8fd5                	or	a5,a5,a3
            mt[kk] = mt[kk + M] ^ (y >> 1) ^ mag01[y & 0x1];
    80006836:	00b70633          	add	a2,a4,a1
    8000683a:	0017d693          	srli	a3,a5,0x1
    8000683e:	6210                	ld	a2,0(a2)
    80006840:	8eb1                	xor	a3,a3,a2
    80006842:	8b85                	andi	a5,a5,1
    80006844:	078e                	slli	a5,a5,0x3
    80006846:	979a                	add	a5,a5,t1
    80006848:	639c                	ld	a5,0(a5)
    8000684a:	8fb5                	xor	a5,a5,a3
    8000684c:	e31c                	sd	a5,0(a4)
        for (kk = 0; kk < N - M; kk++)
    8000684e:	0721                	addi	a4,a4,8
    80006850:	fdc71de3          	bne	a4,t3,8000682a <genrand+0x4c>
        }
        for (; kk < N - 1; kk++)
    80006854:	6605                	lui	a2,0x1
    80006856:	c6060613          	addi	a2,a2,-928 # c60 <_entry-0x7ffff3a0>
    8000685a:	9642                	add	a2,a2,a6
        {
            y = (mt[kk] & UPPER_MASK) | (mt[kk + 1] & LOWER_MASK);
    8000685c:	4505                	li	a0,1
    8000685e:	057e                	slli	a0,a0,0x1f
    80006860:	800005b7          	lui	a1,0x80000
    80006864:	fff5c593          	not	a1,a1
            mt[kk] = mt[kk + (M - N)] ^ (y >> 1) ^ mag01[y & 0x1];
    80006868:	00003897          	auipc	a7,0x3
    8000686c:	09088893          	addi	a7,a7,144 # 800098f8 <mag01.0>
            y = (mt[kk] & UPPER_MASK) | (mt[kk + 1] & LOWER_MASK);
    80006870:	71883783          	ld	a5,1816(a6)
    80006874:	8fe9                	and	a5,a5,a0
    80006876:	72083703          	ld	a4,1824(a6)
    8000687a:	8f6d                	and	a4,a4,a1
    8000687c:	8fd9                	or	a5,a5,a4
            mt[kk] = mt[kk + (M - N)] ^ (y >> 1) ^ mag01[y & 0x1];
    8000687e:	0017d713          	srli	a4,a5,0x1
    80006882:	00083683          	ld	a3,0(a6)
    80006886:	8f35                	xor	a4,a4,a3
    80006888:	8b85                	andi	a5,a5,1
    8000688a:	078e                	slli	a5,a5,0x3
    8000688c:	97c6                	add	a5,a5,a7
    8000688e:	639c                	ld	a5,0(a5)
    80006890:	8fb9                	xor	a5,a5,a4
    80006892:	70f83c23          	sd	a5,1816(a6)
        for (; kk < N - 1; kk++)
    80006896:	0821                	addi	a6,a6,8
    80006898:	fcc81ce3          	bne	a6,a2,80006870 <genrand+0x92>
        }
        y = (mt[N - 1] & UPPER_MASK) | (mt[0] & LOWER_MASK);
    8000689c:	0023f697          	auipc	a3,0x23f
    800068a0:	6bc68693          	addi	a3,a3,1724 # 80245f58 <mt+0x1000>
    800068a4:	3786b783          	ld	a5,888(a3)
    800068a8:	4705                	li	a4,1
    800068aa:	077e                	slli	a4,a4,0x1f
    800068ac:	8ff9                	and	a5,a5,a4
    800068ae:	0023e717          	auipc	a4,0x23e
    800068b2:	6aa73703          	ld	a4,1706(a4) # 80244f58 <mt>
    800068b6:	1706                	slli	a4,a4,0x21
    800068b8:	9305                	srli	a4,a4,0x21
    800068ba:	8fd9                	or	a5,a5,a4
        mt[N - 1] = mt[M - 1] ^ (y >> 1) ^ mag01[y & 0x1];
    800068bc:	0017d713          	srli	a4,a5,0x1
    800068c0:	c606b603          	ld	a2,-928(a3)
    800068c4:	8f31                	xor	a4,a4,a2
    800068c6:	8b85                	andi	a5,a5,1
    800068c8:	078e                	slli	a5,a5,0x3
    800068ca:	00003617          	auipc	a2,0x3
    800068ce:	02e60613          	addi	a2,a2,46 # 800098f8 <mag01.0>
    800068d2:	97b2                	add	a5,a5,a2
    800068d4:	639c                	ld	a5,0(a5)
    800068d6:	8fb9                	xor	a5,a5,a4
    800068d8:	36f6bc23          	sd	a5,888(a3)

        mti = 0;
    800068dc:	00003797          	auipc	a5,0x3
    800068e0:	1207ae23          	sw	zero,316(a5) # 80009a18 <mti>
    }

    y = mt[mti++];
    800068e4:	00003717          	auipc	a4,0x3
    800068e8:	13470713          	addi	a4,a4,308 # 80009a18 <mti>
    800068ec:	431c                	lw	a5,0(a4)
    800068ee:	0017869b          	addiw	a3,a5,1
    800068f2:	c314                	sw	a3,0(a4)
    800068f4:	078e                	slli	a5,a5,0x3
    800068f6:	0023e717          	auipc	a4,0x23e
    800068fa:	66270713          	addi	a4,a4,1634 # 80244f58 <mt>
    800068fe:	97ba                	add	a5,a5,a4
    80006900:	6398                	ld	a4,0(a5)
    y ^= TEMPERING_SHIFT_U(y);
    80006902:	00b75793          	srli	a5,a4,0xb
    80006906:	8f3d                	xor	a4,a4,a5
    y ^= TEMPERING_SHIFT_S(y) & TEMPERING_MASK_B;
    80006908:	013a67b7          	lui	a5,0x13a6
    8000690c:	8ad78793          	addi	a5,a5,-1875 # 13a58ad <_entry-0x7ec5a753>
    80006910:	8ff9                	and	a5,a5,a4
    80006912:	079e                	slli	a5,a5,0x7
    80006914:	8fb9                	xor	a5,a5,a4
    y ^= TEMPERING_SHIFT_T(y) & TEMPERING_MASK_C;
    80006916:	00f79713          	slli	a4,a5,0xf
    8000691a:	077e36b7          	lui	a3,0x77e3
    8000691e:	0696                	slli	a3,a3,0x5
    80006920:	8f75                	and	a4,a4,a3
    80006922:	8fb9                	xor	a5,a5,a4
    y ^= TEMPERING_SHIFT_L(y);
    80006924:	0127d513          	srli	a0,a5,0x12
    80006928:	8fa9                	xor	a5,a5,a0

    // Strip off uppermost bit because we want a long,
    // not an unsigned long
    return y & RAND_MAX;
    8000692a:	02179513          	slli	a0,a5,0x21
}
    8000692e:	9105                	srli	a0,a0,0x21
    80006930:	60a2                	ld	ra,8(sp)
    80006932:	6402                	ld	s0,0(sp)
    80006934:	0141                	addi	sp,sp,16
    80006936:	8082                	ret
            sgenrand(4357); /* a default initial seed is used   */
    80006938:	6505                	lui	a0,0x1
    8000693a:	10550513          	addi	a0,a0,261 # 1105 <_entry-0x7fffeefb>
    8000693e:	00000097          	auipc	ra,0x0
    80006942:	e58080e7          	jalr	-424(ra) # 80006796 <sgenrand>
    80006946:	bd65                	j	800067fe <genrand+0x20>

0000000080006948 <random_at_most>:

// Assumes 0 <= max <= RAND_MAX
// Returns in the half-open interval [0, max]
long random_at_most(long max)
{
    80006948:	1101                	addi	sp,sp,-32
    8000694a:	ec06                	sd	ra,24(sp)
    8000694c:	e822                	sd	s0,16(sp)
    8000694e:	e426                	sd	s1,8(sp)
    80006950:	e04a                	sd	s2,0(sp)
    80006952:	1000                	addi	s0,sp,32
    unsigned long
        // max <= RAND_MAX < ULONG_MAX, so this is okay.
        num_bins = (unsigned long)max + 1,
    80006954:	0505                	addi	a0,a0,1
        num_rand = (unsigned long)RAND_MAX + 1,
        bin_size = num_rand / num_bins,
    80006956:	4485                	li	s1,1
    80006958:	04fe                	slli	s1,s1,0x1f
    8000695a:	02a4d933          	divu	s2,s1,a0
        defect = num_rand % num_bins;
    8000695e:	02a4f533          	remu	a0,s1,a0
    do
    {
        x = genrand();
    }
    // This is carefully written not to overflow
    while (num_rand - defect <= (unsigned long)x);
    80006962:	4485                	li	s1,1
    80006964:	04fe                	slli	s1,s1,0x1f
    80006966:	8c89                	sub	s1,s1,a0
        x = genrand();
    80006968:	00000097          	auipc	ra,0x0
    8000696c:	e76080e7          	jalr	-394(ra) # 800067de <genrand>
    while (num_rand - defect <= (unsigned long)x);
    80006970:	fe957ce3          	bgeu	a0,s1,80006968 <random_at_most+0x20>

    // Truncated division is intentional
    return x / bin_size;
    80006974:	03255533          	divu	a0,a0,s2
    80006978:	60e2                	ld	ra,24(sp)
    8000697a:	6442                	ld	s0,16(sp)
    8000697c:	64a2                	ld	s1,8(sp)
    8000697e:	6902                	ld	s2,0(sp)
    80006980:	6105                	addi	sp,sp,32
    80006982:	8082                	ret

0000000080006984 <pop>:
#include "spinlock.h"
#include "proc.h"
#include "defs.h"


void pop(deque *q){
    80006984:	1101                	addi	sp,sp,-32
    80006986:	ec06                	sd	ra,24(sp)
    80006988:	e822                	sd	s0,16(sp)
    8000698a:	e426                	sd	s1,8(sp)
    8000698c:	e04a                	sd	s2,0(sp)
    8000698e:	1000                	addi	s0,sp,32
    80006990:	84aa                	mv	s1,a0
    acquire(&q->lock);
    80006992:	20850913          	addi	s2,a0,520
    80006996:	854a                	mv	a0,s2
    80006998:	ffffa097          	auipc	ra,0xffffa
    8000699c:	3fa080e7          	jalr	1018(ra) # 80000d92 <acquire>
    for(int i = 0;i < q->end-1;i++){
    800069a0:	2004a703          	lw	a4,512(s1)
    800069a4:	fff7061b          	addiw	a2,a4,-1
    800069a8:	0006079b          	sext.w	a5,a2
    800069ac:	cf91                	beqz	a5,800069c8 <pop+0x44>
    800069ae:	87a6                	mv	a5,s1
    800069b0:	3779                	addiw	a4,a4,-2
    800069b2:	1702                	slli	a4,a4,0x20
    800069b4:	9301                	srli	a4,a4,0x20
    800069b6:	070e                	slli	a4,a4,0x3
    800069b8:	00848693          	addi	a3,s1,8
    800069bc:	9736                	add	a4,a4,a3
        q->n[i] = q->n[i+1];
    800069be:	6794                	ld	a3,8(a5)
    800069c0:	e394                	sd	a3,0(a5)
    for(int i = 0;i < q->end-1;i++){
    800069c2:	07a1                	addi	a5,a5,8
    800069c4:	fee79de3          	bne	a5,a4,800069be <pop+0x3a>
    }
    q->end--;
    800069c8:	20c4a023          	sw	a2,512(s1)
    release(&q->lock);
    800069cc:	854a                	mv	a0,s2
    800069ce:	ffffa097          	auipc	ra,0xffffa
    800069d2:	478080e7          	jalr	1144(ra) # 80000e46 <release>
    return;
}
    800069d6:	60e2                	ld	ra,24(sp)
    800069d8:	6442                	ld	s0,16(sp)
    800069da:	64a2                	ld	s1,8(sp)
    800069dc:	6902                	ld	s2,0(sp)
    800069de:	6105                	addi	sp,sp,32
    800069e0:	8082                	ret

00000000800069e2 <push_front>:


void push_front(deque *q,struct proc* x){
    800069e2:	7179                	addi	sp,sp,-48
    800069e4:	f406                	sd	ra,40(sp)
    800069e6:	f022                	sd	s0,32(sp)
    800069e8:	ec26                	sd	s1,24(sp)
    800069ea:	e84a                	sd	s2,16(sp)
    800069ec:	e44e                	sd	s3,8(sp)
    800069ee:	1800                	addi	s0,sp,48
    800069f0:	84aa                	mv	s1,a0
    800069f2:	892e                	mv	s2,a1
    acquire(&q->lock);
    800069f4:	20850993          	addi	s3,a0,520
    800069f8:	854e                	mv	a0,s3
    800069fa:	ffffa097          	auipc	ra,0xffffa
    800069fe:	398080e7          	jalr	920(ra) # 80000d92 <acquire>
    if(q->end == NPROC){
    80006a02:	2004a603          	lw	a2,512(s1)
    80006a06:	04000793          	li	a5,64
    80006a0a:	04f60263          	beq	a2,a5,80006a4e <push_front+0x6c>
        panic("Error!");
        return;
    }
    for(int i = 0;i < q->end;i++){
    80006a0e:	ce19                	beqz	a2,80006a2c <push_front+0x4a>
    80006a10:	87a6                	mv	a5,s1
    80006a12:	fff6069b          	addiw	a3,a2,-1
    80006a16:	1682                	slli	a3,a3,0x20
    80006a18:	9281                	srli	a3,a3,0x20
    80006a1a:	068e                	slli	a3,a3,0x3
    80006a1c:	00848713          	addi	a4,s1,8
    80006a20:	96ba                	add	a3,a3,a4
        q->n[i+1] = q->n[i];
    80006a22:	6398                	ld	a4,0(a5)
    80006a24:	e798                	sd	a4,8(a5)
    for(int i = 0;i < q->end;i++){
    80006a26:	07a1                	addi	a5,a5,8
    80006a28:	fed79de3          	bne	a5,a3,80006a22 <push_front+0x40>
    }
    q->n[0] = x;
    80006a2c:	0124b023          	sd	s2,0(s1)
    q->end++;
    80006a30:	2605                	addiw	a2,a2,1
    80006a32:	20c4a023          	sw	a2,512(s1)
    release(&q->lock);
    80006a36:	854e                	mv	a0,s3
    80006a38:	ffffa097          	auipc	ra,0xffffa
    80006a3c:	40e080e7          	jalr	1038(ra) # 80000e46 <release>
}
    80006a40:	70a2                	ld	ra,40(sp)
    80006a42:	7402                	ld	s0,32(sp)
    80006a44:	64e2                	ld	s1,24(sp)
    80006a46:	6942                	ld	s2,16(sp)
    80006a48:	69a2                	ld	s3,8(sp)
    80006a4a:	6145                	addi	sp,sp,48
    80006a4c:	8082                	ret
        panic("Error!");
    80006a4e:	00003517          	auipc	a0,0x3
    80006a52:	eba50513          	addi	a0,a0,-326 # 80009908 <mag01.0+0x10>
    80006a56:	ffffa097          	auipc	ra,0xffffa
    80006a5a:	ae8080e7          	jalr	-1304(ra) # 8000053e <panic>

0000000080006a5e <push_back>:

void push_back(deque *q,struct proc* x){
    80006a5e:	7179                	addi	sp,sp,-48
    80006a60:	f406                	sd	ra,40(sp)
    80006a62:	f022                	sd	s0,32(sp)
    80006a64:	ec26                	sd	s1,24(sp)
    80006a66:	e84a                	sd	s2,16(sp)
    80006a68:	e44e                	sd	s3,8(sp)
    80006a6a:	1800                	addi	s0,sp,48
    80006a6c:	84aa                	mv	s1,a0
    80006a6e:	892e                	mv	s2,a1
    acquire(&q->lock);
    80006a70:	20850993          	addi	s3,a0,520
    80006a74:	854e                	mv	a0,s3
    80006a76:	ffffa097          	auipc	ra,0xffffa
    80006a7a:	31c080e7          	jalr	796(ra) # 80000d92 <acquire>
    if (q->end == NPROC){
    80006a7e:	2004a783          	lw	a5,512(s1)
    80006a82:	04000713          	li	a4,64
    80006a86:	02e78863          	beq	a5,a4,80006ab6 <push_back+0x58>
        panic("Error!");
        return;
    }
    q->n[q->end] = x;
    80006a8a:	02079713          	slli	a4,a5,0x20
    80006a8e:	9301                	srli	a4,a4,0x20
    80006a90:	070e                	slli	a4,a4,0x3
    80006a92:	9726                	add	a4,a4,s1
    80006a94:	01273023          	sd	s2,0(a4)
    q->end++;
    80006a98:	2785                	addiw	a5,a5,1
    80006a9a:	20f4a023          	sw	a5,512(s1)
    release(&q->lock);
    80006a9e:	854e                	mv	a0,s3
    80006aa0:	ffffa097          	auipc	ra,0xffffa
    80006aa4:	3a6080e7          	jalr	934(ra) # 80000e46 <release>
}
    80006aa8:	70a2                	ld	ra,40(sp)
    80006aaa:	7402                	ld	s0,32(sp)
    80006aac:	64e2                	ld	s1,24(sp)
    80006aae:	6942                	ld	s2,16(sp)
    80006ab0:	69a2                	ld	s3,8(sp)
    80006ab2:	6145                	addi	sp,sp,48
    80006ab4:	8082                	ret
        panic("Error!");
    80006ab6:	00003517          	auipc	a0,0x3
    80006aba:	e5250513          	addi	a0,a0,-430 # 80009908 <mag01.0+0x10>
    80006abe:	ffffa097          	auipc	ra,0xffffa
    80006ac2:	a80080e7          	jalr	-1408(ra) # 8000053e <panic>

0000000080006ac6 <front>:


struct proc *front(deque *q){
    80006ac6:	1101                	addi	sp,sp,-32
    80006ac8:	ec06                	sd	ra,24(sp)
    80006aca:	e822                	sd	s0,16(sp)
    80006acc:	e426                	sd	s1,8(sp)
    80006ace:	e04a                	sd	s2,0(sp)
    80006ad0:	1000                	addi	s0,sp,32
    80006ad2:	84aa                	mv	s1,a0
    acquire(&q->lock);
    80006ad4:	20850913          	addi	s2,a0,520
    80006ad8:	854a                	mv	a0,s2
    80006ada:	ffffa097          	auipc	ra,0xffffa
    80006ade:	2b8080e7          	jalr	696(ra) # 80000d92 <acquire>
    if (q->end == 0){
    80006ae2:	2004a783          	lw	a5,512(s1)
    80006ae6:	cf91                	beqz	a5,80006b02 <front+0x3c>
        return 0;
    }

    struct proc* p = q->n[0];
    80006ae8:	6084                	ld	s1,0(s1)
    release(&q->lock);
    80006aea:	854a                	mv	a0,s2
    80006aec:	ffffa097          	auipc	ra,0xffffa
    80006af0:	35a080e7          	jalr	858(ra) # 80000e46 <release>
    return p;
}
    80006af4:	8526                	mv	a0,s1
    80006af6:	60e2                	ld	ra,24(sp)
    80006af8:	6442                	ld	s0,16(sp)
    80006afa:	64a2                	ld	s1,8(sp)
    80006afc:	6902                	ld	s2,0(sp)
    80006afe:	6105                	addi	sp,sp,32
    80006b00:	8082                	ret
        return 0;
    80006b02:	4481                	li	s1,0
    80006b04:	bfc5                	j	80006af4 <front+0x2e>

0000000080006b06 <size>:


int size(deque *q){
    80006b06:	1101                	addi	sp,sp,-32
    80006b08:	ec06                	sd	ra,24(sp)
    80006b0a:	e822                	sd	s0,16(sp)
    80006b0c:	e426                	sd	s1,8(sp)
    80006b0e:	e04a                	sd	s2,0(sp)
    80006b10:	1000                	addi	s0,sp,32
    80006b12:	84aa                	mv	s1,a0
    acquire(&q->lock);
    80006b14:	20850913          	addi	s2,a0,520
    80006b18:	854a                	mv	a0,s2
    80006b1a:	ffffa097          	auipc	ra,0xffffa
    80006b1e:	278080e7          	jalr	632(ra) # 80000d92 <acquire>
    int sz = q->end;
    80006b22:	2004a483          	lw	s1,512(s1)
    release(&q->lock);
    80006b26:	854a                	mv	a0,s2
    80006b28:	ffffa097          	auipc	ra,0xffffa
    80006b2c:	31e080e7          	jalr	798(ra) # 80000e46 <release>
    return sz;
}
    80006b30:	8526                	mv	a0,s1
    80006b32:	60e2                	ld	ra,24(sp)
    80006b34:	6442                	ld	s0,16(sp)
    80006b36:	64a2                	ld	s1,8(sp)
    80006b38:	6902                	ld	s2,0(sp)
    80006b3a:	6105                	addi	sp,sp,32
    80006b3c:	8082                	ret

0000000080006b3e <delete>:


void delete (deque *q, uint pid){
    80006b3e:	7179                	addi	sp,sp,-48
    80006b40:	f406                	sd	ra,40(sp)
    80006b42:	f022                	sd	s0,32(sp)
    80006b44:	ec26                	sd	s1,24(sp)
    80006b46:	e84a                	sd	s2,16(sp)
    80006b48:	e44e                	sd	s3,8(sp)
    80006b4a:	1800                	addi	s0,sp,48
    80006b4c:	892a                	mv	s2,a0
    80006b4e:	84ae                	mv	s1,a1
    acquire(&q->lock);
    80006b50:	20850993          	addi	s3,a0,520
    80006b54:	854e                	mv	a0,s3
    80006b56:	ffffa097          	auipc	ra,0xffffa
    80006b5a:	23c080e7          	jalr	572(ra) # 80000d92 <acquire>
    int flag = 0;
    for (int i = 0; i < q->end; i++){
    80006b5e:	20092503          	lw	a0,512(s2)
    80006b62:	c91d                	beqz	a0,80006b98 <delete+0x5a>
    80006b64:	87ca                	mv	a5,s2
    80006b66:	0005059b          	sext.w	a1,a0
    80006b6a:	4701                	li	a4,0
    int flag = 0;
    80006b6c:	4881                	li	a7,0
        
        if (pid == q->n[i]->pid){
            flag = 1;
        }

        if (flag == 1 && i != NPROC){
    80006b6e:	04000313          	li	t1,64
    80006b72:	4805                	li	a6,1
    80006b74:	a811                	j	80006b88 <delete+0x4a>
    80006b76:	88c2                	mv	a7,a6
    80006b78:	00670463          	beq	a4,t1,80006b80 <delete+0x42>
            q->n[i] = q->n[i + 1];
    80006b7c:	6614                	ld	a3,8(a2)
    80006b7e:	e214                	sd	a3,0(a2)
    for (int i = 0; i < q->end; i++){
    80006b80:	2705                	addiw	a4,a4,1
    80006b82:	07a1                	addi	a5,a5,8
    80006b84:	00b70a63          	beq	a4,a1,80006b98 <delete+0x5a>
        if (pid == q->n[i]->pid){
    80006b88:	863e                	mv	a2,a5
    80006b8a:	6394                	ld	a3,0(a5)
    80006b8c:	5a94                	lw	a3,48(a3)
    80006b8e:	fe9684e3          	beq	a3,s1,80006b76 <delete+0x38>
        if (flag == 1 && i != NPROC){
    80006b92:	ff0897e3          	bne	a7,a6,80006b80 <delete+0x42>
    80006b96:	b7c5                	j	80006b76 <delete+0x38>
        }
    }
    q->end--;
    80006b98:	357d                	addiw	a0,a0,-1
    80006b9a:	20a92023          	sw	a0,512(s2)
    release(&q->lock);
    80006b9e:	854e                	mv	a0,s3
    80006ba0:	ffffa097          	auipc	ra,0xffffa
    80006ba4:	2a6080e7          	jalr	678(ra) # 80000e46 <release>
    return;
    80006ba8:	70a2                	ld	ra,40(sp)
    80006baa:	7402                	ld	s0,32(sp)
    80006bac:	64e2                	ld	s1,24(sp)
    80006bae:	6942                	ld	s2,16(sp)
    80006bb0:	69a2                	ld	s3,8(sp)
    80006bb2:	6145                	addi	sp,sp,48
    80006bb4:	8082                	ret

0000000080006bb6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006bb6:	1141                	addi	sp,sp,-16
    80006bb8:	e406                	sd	ra,8(sp)
    80006bba:	e022                	sd	s0,0(sp)
    80006bbc:	0800                	addi	s0,sp,16
  if (i >= NUM)
    80006bbe:	479d                	li	a5,7
    80006bc0:	04a7cc63          	blt	a5,a0,80006c18 <free_desc+0x62>
    panic("free_desc 1");
  if (disk.free[i])
    80006bc4:	0023f797          	auipc	a5,0x23f
    80006bc8:	71478793          	addi	a5,a5,1812 # 802462d8 <disk>
    80006bcc:	97aa                	add	a5,a5,a0
    80006bce:	0187c783          	lbu	a5,24(a5)
    80006bd2:	ebb9                	bnez	a5,80006c28 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006bd4:	00451613          	slli	a2,a0,0x4
    80006bd8:	0023f797          	auipc	a5,0x23f
    80006bdc:	70078793          	addi	a5,a5,1792 # 802462d8 <disk>
    80006be0:	6394                	ld	a3,0(a5)
    80006be2:	96b2                	add	a3,a3,a2
    80006be4:	0006b023          	sd	zero,0(a3) # 77e3000 <_entry-0x7881d000>
  disk.desc[i].len = 0;
    80006be8:	6398                	ld	a4,0(a5)
    80006bea:	9732                	add	a4,a4,a2
    80006bec:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006bf0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006bf4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006bf8:	953e                	add	a0,a0,a5
    80006bfa:	4785                	li	a5,1
    80006bfc:	00f50c23          	sb	a5,24(a0)
  wakeup(&disk.free[0]);
    80006c00:	0023f517          	auipc	a0,0x23f
    80006c04:	6f050513          	addi	a0,a0,1776 # 802462f0 <disk+0x18>
    80006c08:	ffffc097          	auipc	ra,0xffffc
    80006c0c:	b1a080e7          	jalr	-1254(ra) # 80002722 <wakeup>
}
    80006c10:	60a2                	ld	ra,8(sp)
    80006c12:	6402                	ld	s0,0(sp)
    80006c14:	0141                	addi	sp,sp,16
    80006c16:	8082                	ret
    panic("free_desc 1");
    80006c18:	00003517          	auipc	a0,0x3
    80006c1c:	cf850513          	addi	a0,a0,-776 # 80009910 <mag01.0+0x18>
    80006c20:	ffffa097          	auipc	ra,0xffffa
    80006c24:	91e080e7          	jalr	-1762(ra) # 8000053e <panic>
    panic("free_desc 2");
    80006c28:	00003517          	auipc	a0,0x3
    80006c2c:	cf850513          	addi	a0,a0,-776 # 80009920 <mag01.0+0x28>
    80006c30:	ffffa097          	auipc	ra,0xffffa
    80006c34:	90e080e7          	jalr	-1778(ra) # 8000053e <panic>

0000000080006c38 <virtio_disk_init>:
{
    80006c38:	1101                	addi	sp,sp,-32
    80006c3a:	ec06                	sd	ra,24(sp)
    80006c3c:	e822                	sd	s0,16(sp)
    80006c3e:	e426                	sd	s1,8(sp)
    80006c40:	e04a                	sd	s2,0(sp)
    80006c42:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006c44:	00003597          	auipc	a1,0x3
    80006c48:	cec58593          	addi	a1,a1,-788 # 80009930 <mag01.0+0x38>
    80006c4c:	0023f517          	auipc	a0,0x23f
    80006c50:	7b450513          	addi	a0,a0,1972 # 80246400 <disk+0x128>
    80006c54:	ffffa097          	auipc	ra,0xffffa
    80006c58:	0ae080e7          	jalr	174(ra) # 80000d02 <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006c5c:	100017b7          	lui	a5,0x10001
    80006c60:	4398                	lw	a4,0(a5)
    80006c62:	2701                	sext.w	a4,a4
    80006c64:	747277b7          	lui	a5,0x74727
    80006c68:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006c6c:	14f71c63          	bne	a4,a5,80006dc4 <virtio_disk_init+0x18c>
      *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006c70:	100017b7          	lui	a5,0x10001
    80006c74:	43dc                	lw	a5,4(a5)
    80006c76:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006c78:	4709                	li	a4,2
    80006c7a:	14e79563          	bne	a5,a4,80006dc4 <virtio_disk_init+0x18c>
      *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006c7e:	100017b7          	lui	a5,0x10001
    80006c82:	479c                	lw	a5,8(a5)
    80006c84:	2781                	sext.w	a5,a5
      *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006c86:	12e79f63          	bne	a5,a4,80006dc4 <virtio_disk_init+0x18c>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551)
    80006c8a:	100017b7          	lui	a5,0x10001
    80006c8e:	47d8                	lw	a4,12(a5)
    80006c90:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006c92:	554d47b7          	lui	a5,0x554d4
    80006c96:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006c9a:	12f71563          	bne	a4,a5,80006dc4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006c9e:	100017b7          	lui	a5,0x10001
    80006ca2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006ca6:	4705                	li	a4,1
    80006ca8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006caa:	470d                	li	a4,3
    80006cac:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006cae:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006cb0:	c7ffe737          	lui	a4,0xc7ffe
    80006cb4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47db8347>
    80006cb8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006cba:	2701                	sext.w	a4,a4
    80006cbc:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006cbe:	472d                	li	a4,11
    80006cc0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80006cc2:	5bbc                	lw	a5,112(a5)
    80006cc4:	0007891b          	sext.w	s2,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80006cc8:	8ba1                	andi	a5,a5,8
    80006cca:	10078563          	beqz	a5,80006dd4 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006cce:	100017b7          	lui	a5,0x10001
    80006cd2:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    80006cd6:	43fc                	lw	a5,68(a5)
    80006cd8:	2781                	sext.w	a5,a5
    80006cda:	10079563          	bnez	a5,80006de4 <virtio_disk_init+0x1ac>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006cde:	100017b7          	lui	a5,0x10001
    80006ce2:	5bdc                	lw	a5,52(a5)
    80006ce4:	2781                	sext.w	a5,a5
  if (max == 0)
    80006ce6:	10078763          	beqz	a5,80006df4 <virtio_disk_init+0x1bc>
  if (max < NUM)
    80006cea:	471d                	li	a4,7
    80006cec:	10f77c63          	bgeu	a4,a5,80006e04 <virtio_disk_init+0x1cc>
  disk.desc = kalloc();
    80006cf0:	ffffa097          	auipc	ra,0xffffa
    80006cf4:	f5e080e7          	jalr	-162(ra) # 80000c4e <kalloc>
    80006cf8:	0023f497          	auipc	s1,0x23f
    80006cfc:	5e048493          	addi	s1,s1,1504 # 802462d8 <disk>
    80006d00:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006d02:	ffffa097          	auipc	ra,0xffffa
    80006d06:	f4c080e7          	jalr	-180(ra) # 80000c4e <kalloc>
    80006d0a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80006d0c:	ffffa097          	auipc	ra,0xffffa
    80006d10:	f42080e7          	jalr	-190(ra) # 80000c4e <kalloc>
    80006d14:	87aa                	mv	a5,a0
    80006d16:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used)
    80006d18:	6088                	ld	a0,0(s1)
    80006d1a:	cd6d                	beqz	a0,80006e14 <virtio_disk_init+0x1dc>
    80006d1c:	0023f717          	auipc	a4,0x23f
    80006d20:	5c473703          	ld	a4,1476(a4) # 802462e0 <disk+0x8>
    80006d24:	cb65                	beqz	a4,80006e14 <virtio_disk_init+0x1dc>
    80006d26:	c7fd                	beqz	a5,80006e14 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    80006d28:	6605                	lui	a2,0x1
    80006d2a:	4581                	li	a1,0
    80006d2c:	ffffa097          	auipc	ra,0xffffa
    80006d30:	162080e7          	jalr	354(ra) # 80000e8e <memset>
  memset(disk.avail, 0, PGSIZE);
    80006d34:	0023f497          	auipc	s1,0x23f
    80006d38:	5a448493          	addi	s1,s1,1444 # 802462d8 <disk>
    80006d3c:	6605                	lui	a2,0x1
    80006d3e:	4581                	li	a1,0
    80006d40:	6488                	ld	a0,8(s1)
    80006d42:	ffffa097          	auipc	ra,0xffffa
    80006d46:	14c080e7          	jalr	332(ra) # 80000e8e <memset>
  memset(disk.used, 0, PGSIZE);
    80006d4a:	6605                	lui	a2,0x1
    80006d4c:	4581                	li	a1,0
    80006d4e:	6888                	ld	a0,16(s1)
    80006d50:	ffffa097          	auipc	ra,0xffffa
    80006d54:	13e080e7          	jalr	318(ra) # 80000e8e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006d58:	100017b7          	lui	a5,0x10001
    80006d5c:	4721                	li	a4,8
    80006d5e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006d60:	4098                	lw	a4,0(s1)
    80006d62:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006d66:	40d8                	lw	a4,4(s1)
    80006d68:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80006d6c:	6498                	ld	a4,8(s1)
    80006d6e:	0007069b          	sext.w	a3,a4
    80006d72:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006d76:	9701                	srai	a4,a4,0x20
    80006d78:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006d7c:	6898                	ld	a4,16(s1)
    80006d7e:	0007069b          	sext.w	a3,a4
    80006d82:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80006d86:	9701                	srai	a4,a4,0x20
    80006d88:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006d8c:	4705                	li	a4,1
    80006d8e:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80006d90:	00e48c23          	sb	a4,24(s1)
    80006d94:	00e48ca3          	sb	a4,25(s1)
    80006d98:	00e48d23          	sb	a4,26(s1)
    80006d9c:	00e48da3          	sb	a4,27(s1)
    80006da0:	00e48e23          	sb	a4,28(s1)
    80006da4:	00e48ea3          	sb	a4,29(s1)
    80006da8:	00e48f23          	sb	a4,30(s1)
    80006dac:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006db0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006db4:	0727a823          	sw	s2,112(a5)
}
    80006db8:	60e2                	ld	ra,24(sp)
    80006dba:	6442                	ld	s0,16(sp)
    80006dbc:	64a2                	ld	s1,8(sp)
    80006dbe:	6902                	ld	s2,0(sp)
    80006dc0:	6105                	addi	sp,sp,32
    80006dc2:	8082                	ret
    panic("could not find virtio disk");
    80006dc4:	00003517          	auipc	a0,0x3
    80006dc8:	b7c50513          	addi	a0,a0,-1156 # 80009940 <mag01.0+0x48>
    80006dcc:	ffff9097          	auipc	ra,0xffff9
    80006dd0:	772080e7          	jalr	1906(ra) # 8000053e <panic>
    panic("virtio disk FEATURES_OK unset");
    80006dd4:	00003517          	auipc	a0,0x3
    80006dd8:	b8c50513          	addi	a0,a0,-1140 # 80009960 <mag01.0+0x68>
    80006ddc:	ffff9097          	auipc	ra,0xffff9
    80006de0:	762080e7          	jalr	1890(ra) # 8000053e <panic>
    panic("virtio disk should not be ready");
    80006de4:	00003517          	auipc	a0,0x3
    80006de8:	b9c50513          	addi	a0,a0,-1124 # 80009980 <mag01.0+0x88>
    80006dec:	ffff9097          	auipc	ra,0xffff9
    80006df0:	752080e7          	jalr	1874(ra) # 8000053e <panic>
    panic("virtio disk has no queue 0");
    80006df4:	00003517          	auipc	a0,0x3
    80006df8:	bac50513          	addi	a0,a0,-1108 # 800099a0 <mag01.0+0xa8>
    80006dfc:	ffff9097          	auipc	ra,0xffff9
    80006e00:	742080e7          	jalr	1858(ra) # 8000053e <panic>
    panic("virtio disk max queue too short");
    80006e04:	00003517          	auipc	a0,0x3
    80006e08:	bbc50513          	addi	a0,a0,-1092 # 800099c0 <mag01.0+0xc8>
    80006e0c:	ffff9097          	auipc	ra,0xffff9
    80006e10:	732080e7          	jalr	1842(ra) # 8000053e <panic>
    panic("virtio disk kalloc");
    80006e14:	00003517          	auipc	a0,0x3
    80006e18:	bcc50513          	addi	a0,a0,-1076 # 800099e0 <mag01.0+0xe8>
    80006e1c:	ffff9097          	auipc	ra,0xffff9
    80006e20:	722080e7          	jalr	1826(ra) # 8000053e <panic>

0000000080006e24 <virtio_disk_rw>:
  }
  return 0;
}

void virtio_disk_rw(struct buf *b, int write)
{
    80006e24:	7119                	addi	sp,sp,-128
    80006e26:	fc86                	sd	ra,120(sp)
    80006e28:	f8a2                	sd	s0,112(sp)
    80006e2a:	f4a6                	sd	s1,104(sp)
    80006e2c:	f0ca                	sd	s2,96(sp)
    80006e2e:	ecce                	sd	s3,88(sp)
    80006e30:	e8d2                	sd	s4,80(sp)
    80006e32:	e4d6                	sd	s5,72(sp)
    80006e34:	e0da                	sd	s6,64(sp)
    80006e36:	fc5e                	sd	s7,56(sp)
    80006e38:	f862                	sd	s8,48(sp)
    80006e3a:	f466                	sd	s9,40(sp)
    80006e3c:	f06a                	sd	s10,32(sp)
    80006e3e:	ec6e                	sd	s11,24(sp)
    80006e40:	0100                	addi	s0,sp,128
    80006e42:	8aaa                	mv	s5,a0
    80006e44:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006e46:	00c52d03          	lw	s10,12(a0)
    80006e4a:	001d1d1b          	slliw	s10,s10,0x1
    80006e4e:	1d02                	slli	s10,s10,0x20
    80006e50:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80006e54:	0023f517          	auipc	a0,0x23f
    80006e58:	5ac50513          	addi	a0,a0,1452 # 80246400 <disk+0x128>
    80006e5c:	ffffa097          	auipc	ra,0xffffa
    80006e60:	f36080e7          	jalr	-202(ra) # 80000d92 <acquire>
  for (int i = 0; i < 3; i++)
    80006e64:	4981                	li	s3,0
  for (int i = 0; i < NUM; i++)
    80006e66:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006e68:	0023fb97          	auipc	s7,0x23f
    80006e6c:	470b8b93          	addi	s7,s7,1136 # 802462d8 <disk>
  for (int i = 0; i < 3; i++)
    80006e70:	4b0d                	li	s6,3
  {
    if (alloc3_desc(idx) == 0)
    {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006e72:	0023fc97          	auipc	s9,0x23f
    80006e76:	58ec8c93          	addi	s9,s9,1422 # 80246400 <disk+0x128>
    80006e7a:	a08d                	j	80006edc <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80006e7c:	00fb8733          	add	a4,s7,a5
    80006e80:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006e84:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0)
    80006e86:	0207c563          	bltz	a5,80006eb0 <virtio_disk_rw+0x8c>
  for (int i = 0; i < 3; i++)
    80006e8a:	2905                	addiw	s2,s2,1
    80006e8c:	0611                	addi	a2,a2,4
    80006e8e:	05690c63          	beq	s2,s6,80006ee6 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80006e92:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++)
    80006e94:	0023f717          	auipc	a4,0x23f
    80006e98:	44470713          	addi	a4,a4,1092 # 802462d8 <disk>
    80006e9c:	87ce                	mv	a5,s3
    if (disk.free[i])
    80006e9e:	01874683          	lbu	a3,24(a4)
    80006ea2:	fee9                	bnez	a3,80006e7c <virtio_disk_rw+0x58>
  for (int i = 0; i < NUM; i++)
    80006ea4:	2785                	addiw	a5,a5,1
    80006ea6:	0705                	addi	a4,a4,1
    80006ea8:	fe979be3          	bne	a5,s1,80006e9e <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    80006eac:	57fd                	li	a5,-1
    80006eae:	c19c                	sw	a5,0(a1)
      for (int j = 0; j < i; j++)
    80006eb0:	01205d63          	blez	s2,80006eca <virtio_disk_rw+0xa6>
    80006eb4:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80006eb6:	000a2503          	lw	a0,0(s4)
    80006eba:	00000097          	auipc	ra,0x0
    80006ebe:	cfc080e7          	jalr	-772(ra) # 80006bb6 <free_desc>
      for (int j = 0; j < i; j++)
    80006ec2:	2d85                	addiw	s11,s11,1
    80006ec4:	0a11                	addi	s4,s4,4
    80006ec6:	ffb918e3          	bne	s2,s11,80006eb6 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006eca:	85e6                	mv	a1,s9
    80006ecc:	0023f517          	auipc	a0,0x23f
    80006ed0:	42450513          	addi	a0,a0,1060 # 802462f0 <disk+0x18>
    80006ed4:	ffffb097          	auipc	ra,0xffffb
    80006ed8:	692080e7          	jalr	1682(ra) # 80002566 <sleep>
  for (int i = 0; i < 3; i++)
    80006edc:	f8040a13          	addi	s4,s0,-128
{
    80006ee0:	8652                	mv	a2,s4
  for (int i = 0; i < 3; i++)
    80006ee2:	894e                	mv	s2,s3
    80006ee4:	b77d                	j	80006e92 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006ee6:	f8042583          	lw	a1,-128(s0)
    80006eea:	00a58793          	addi	a5,a1,10
    80006eee:	0792                	slli	a5,a5,0x4

  if (write)
    80006ef0:	0023f617          	auipc	a2,0x23f
    80006ef4:	3e860613          	addi	a2,a2,1000 # 802462d8 <disk>
    80006ef8:	00f60733          	add	a4,a2,a5
    80006efc:	018036b3          	snez	a3,s8
    80006f00:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006f02:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80006f06:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64)buf0;
    80006f0a:	f6078693          	addi	a3,a5,-160
    80006f0e:	6218                	ld	a4,0(a2)
    80006f10:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006f12:	00878513          	addi	a0,a5,8
    80006f16:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64)buf0;
    80006f18:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006f1a:	6208                	ld	a0,0(a2)
    80006f1c:	96aa                	add	a3,a3,a0
    80006f1e:	4741                	li	a4,16
    80006f20:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006f22:	4705                	li	a4,1
    80006f24:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80006f28:	f8442703          	lw	a4,-124(s0)
    80006f2c:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64)b->data;
    80006f30:	0712                	slli	a4,a4,0x4
    80006f32:	953a                	add	a0,a0,a4
    80006f34:	058a8693          	addi	a3,s5,88
    80006f38:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    80006f3a:	6208                	ld	a0,0(a2)
    80006f3c:	972a                	add	a4,a4,a0
    80006f3e:	40000693          	li	a3,1024
    80006f42:	c714                	sw	a3,8(a4)
  if (write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006f44:	001c3c13          	seqz	s8,s8
    80006f48:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006f4a:	001c6c13          	ori	s8,s8,1
    80006f4e:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006f52:	f8842603          	lw	a2,-120(s0)
    80006f56:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006f5a:	0023f697          	auipc	a3,0x23f
    80006f5e:	37e68693          	addi	a3,a3,894 # 802462d8 <disk>
    80006f62:	00258713          	addi	a4,a1,2
    80006f66:	0712                	slli	a4,a4,0x4
    80006f68:	9736                	add	a4,a4,a3
    80006f6a:	587d                	li	a6,-1
    80006f6c:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    80006f70:	0612                	slli	a2,a2,0x4
    80006f72:	9532                	add	a0,a0,a2
    80006f74:	f9078793          	addi	a5,a5,-112
    80006f78:	97b6                	add	a5,a5,a3
    80006f7a:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    80006f7c:	629c                	ld	a5,0(a3)
    80006f7e:	97b2                	add	a5,a5,a2
    80006f80:	4605                	li	a2,1
    80006f82:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006f84:	4509                	li	a0,2
    80006f86:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    80006f8a:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006f8e:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80006f92:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006f96:	6698                	ld	a4,8(a3)
    80006f98:	00275783          	lhu	a5,2(a4)
    80006f9c:	8b9d                	andi	a5,a5,7
    80006f9e:	0786                	slli	a5,a5,0x1
    80006fa0:	97ba                	add	a5,a5,a4
    80006fa2:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80006fa6:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006faa:	6698                	ld	a4,8(a3)
    80006fac:	00275783          	lhu	a5,2(a4)
    80006fb0:	2785                	addiw	a5,a5,1
    80006fb2:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006fb6:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006fba:	100017b7          	lui	a5,0x10001
    80006fbe:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1)
    80006fc2:	004aa783          	lw	a5,4(s5)
    80006fc6:	02c79163          	bne	a5,a2,80006fe8 <virtio_disk_rw+0x1c4>
  {
    sleep(b, &disk.vdisk_lock);
    80006fca:	0023f917          	auipc	s2,0x23f
    80006fce:	43690913          	addi	s2,s2,1078 # 80246400 <disk+0x128>
  while (b->disk == 1)
    80006fd2:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006fd4:	85ca                	mv	a1,s2
    80006fd6:	8556                	mv	a0,s5
    80006fd8:	ffffb097          	auipc	ra,0xffffb
    80006fdc:	58e080e7          	jalr	1422(ra) # 80002566 <sleep>
  while (b->disk == 1)
    80006fe0:	004aa783          	lw	a5,4(s5)
    80006fe4:	fe9788e3          	beq	a5,s1,80006fd4 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80006fe8:	f8042903          	lw	s2,-128(s0)
    80006fec:	00290793          	addi	a5,s2,2
    80006ff0:	00479713          	slli	a4,a5,0x4
    80006ff4:	0023f797          	auipc	a5,0x23f
    80006ff8:	2e478793          	addi	a5,a5,740 # 802462d8 <disk>
    80006ffc:	97ba                	add	a5,a5,a4
    80006ffe:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80007002:	0023f997          	auipc	s3,0x23f
    80007006:	2d698993          	addi	s3,s3,726 # 802462d8 <disk>
    8000700a:	00491713          	slli	a4,s2,0x4
    8000700e:	0009b783          	ld	a5,0(s3)
    80007012:	97ba                	add	a5,a5,a4
    80007014:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80007018:	854a                	mv	a0,s2
    8000701a:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000701e:	00000097          	auipc	ra,0x0
    80007022:	b98080e7          	jalr	-1128(ra) # 80006bb6 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    80007026:	8885                	andi	s1,s1,1
    80007028:	f0ed                	bnez	s1,8000700a <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000702a:	0023f517          	auipc	a0,0x23f
    8000702e:	3d650513          	addi	a0,a0,982 # 80246400 <disk+0x128>
    80007032:	ffffa097          	auipc	ra,0xffffa
    80007036:	e14080e7          	jalr	-492(ra) # 80000e46 <release>
}
    8000703a:	70e6                	ld	ra,120(sp)
    8000703c:	7446                	ld	s0,112(sp)
    8000703e:	74a6                	ld	s1,104(sp)
    80007040:	7906                	ld	s2,96(sp)
    80007042:	69e6                	ld	s3,88(sp)
    80007044:	6a46                	ld	s4,80(sp)
    80007046:	6aa6                	ld	s5,72(sp)
    80007048:	6b06                	ld	s6,64(sp)
    8000704a:	7be2                	ld	s7,56(sp)
    8000704c:	7c42                	ld	s8,48(sp)
    8000704e:	7ca2                	ld	s9,40(sp)
    80007050:	7d02                	ld	s10,32(sp)
    80007052:	6de2                	ld	s11,24(sp)
    80007054:	6109                	addi	sp,sp,128
    80007056:	8082                	ret

0000000080007058 <virtio_disk_intr>:

void virtio_disk_intr()
{
    80007058:	1101                	addi	sp,sp,-32
    8000705a:	ec06                	sd	ra,24(sp)
    8000705c:	e822                	sd	s0,16(sp)
    8000705e:	e426                	sd	s1,8(sp)
    80007060:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80007062:	0023f497          	auipc	s1,0x23f
    80007066:	27648493          	addi	s1,s1,630 # 802462d8 <disk>
    8000706a:	0023f517          	auipc	a0,0x23f
    8000706e:	39650513          	addi	a0,a0,918 # 80246400 <disk+0x128>
    80007072:	ffffa097          	auipc	ra,0xffffa
    80007076:	d20080e7          	jalr	-736(ra) # 80000d92 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000707a:	10001737          	lui	a4,0x10001
    8000707e:	533c                	lw	a5,96(a4)
    80007080:	8b8d                	andi	a5,a5,3
    80007082:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80007084:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx)
    80007088:	689c                	ld	a5,16(s1)
    8000708a:	0204d703          	lhu	a4,32(s1)
    8000708e:	0027d783          	lhu	a5,2(a5)
    80007092:	04f70863          	beq	a4,a5,800070e2 <virtio_disk_intr+0x8a>
  {
    __sync_synchronize();
    80007096:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000709a:	6898                	ld	a4,16(s1)
    8000709c:	0204d783          	lhu	a5,32(s1)
    800070a0:	8b9d                	andi	a5,a5,7
    800070a2:	078e                	slli	a5,a5,0x3
    800070a4:	97ba                	add	a5,a5,a4
    800070a6:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0)
    800070a8:	00278713          	addi	a4,a5,2
    800070ac:	0712                	slli	a4,a4,0x4
    800070ae:	9726                	add	a4,a4,s1
    800070b0:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800070b4:	e721                	bnez	a4,800070fc <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800070b6:	0789                	addi	a5,a5,2
    800070b8:	0792                	slli	a5,a5,0x4
    800070ba:	97a6                	add	a5,a5,s1
    800070bc:	6788                	ld	a0,8(a5)
    b->disk = 0; // disk is done with buf
    800070be:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800070c2:	ffffb097          	auipc	ra,0xffffb
    800070c6:	660080e7          	jalr	1632(ra) # 80002722 <wakeup>

    disk.used_idx += 1;
    800070ca:	0204d783          	lhu	a5,32(s1)
    800070ce:	2785                	addiw	a5,a5,1
    800070d0:	17c2                	slli	a5,a5,0x30
    800070d2:	93c1                	srli	a5,a5,0x30
    800070d4:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx)
    800070d8:	6898                	ld	a4,16(s1)
    800070da:	00275703          	lhu	a4,2(a4)
    800070de:	faf71ce3          	bne	a4,a5,80007096 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800070e2:	0023f517          	auipc	a0,0x23f
    800070e6:	31e50513          	addi	a0,a0,798 # 80246400 <disk+0x128>
    800070ea:	ffffa097          	auipc	ra,0xffffa
    800070ee:	d5c080e7          	jalr	-676(ra) # 80000e46 <release>
}
    800070f2:	60e2                	ld	ra,24(sp)
    800070f4:	6442                	ld	s0,16(sp)
    800070f6:	64a2                	ld	s1,8(sp)
    800070f8:	6105                	addi	sp,sp,32
    800070fa:	8082                	ret
      panic("virtio_disk_intr status");
    800070fc:	00003517          	auipc	a0,0x3
    80007100:	8fc50513          	addi	a0,a0,-1796 # 800099f8 <mag01.0+0x100>
    80007104:	ffff9097          	auipc	ra,0xffff9
    80007108:	43a080e7          	jalr	1082(ra) # 8000053e <panic>
	...

0000000080008000 <_trampoline>:
    80008000:	14051073          	csrw	sscratch,a0
    80008004:	02000537          	lui	a0,0x2000
    80008008:	357d                	addiw	a0,a0,-1
    8000800a:	0536                	slli	a0,a0,0xd
    8000800c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80008010:	02253823          	sd	sp,48(a0)
    80008014:	02353c23          	sd	gp,56(a0)
    80008018:	04453023          	sd	tp,64(a0)
    8000801c:	04553423          	sd	t0,72(a0)
    80008020:	04653823          	sd	t1,80(a0)
    80008024:	04753c23          	sd	t2,88(a0)
    80008028:	f120                	sd	s0,96(a0)
    8000802a:	f524                	sd	s1,104(a0)
    8000802c:	fd2c                	sd	a1,120(a0)
    8000802e:	e150                	sd	a2,128(a0)
    80008030:	e554                	sd	a3,136(a0)
    80008032:	e958                	sd	a4,144(a0)
    80008034:	ed5c                	sd	a5,152(a0)
    80008036:	0b053023          	sd	a6,160(a0)
    8000803a:	0b153423          	sd	a7,168(a0)
    8000803e:	0b253823          	sd	s2,176(a0)
    80008042:	0b353c23          	sd	s3,184(a0)
    80008046:	0d453023          	sd	s4,192(a0)
    8000804a:	0d553423          	sd	s5,200(a0)
    8000804e:	0d653823          	sd	s6,208(a0)
    80008052:	0d753c23          	sd	s7,216(a0)
    80008056:	0f853023          	sd	s8,224(a0)
    8000805a:	0f953423          	sd	s9,232(a0)
    8000805e:	0fa53823          	sd	s10,240(a0)
    80008062:	0fb53c23          	sd	s11,248(a0)
    80008066:	11c53023          	sd	t3,256(a0)
    8000806a:	11d53423          	sd	t4,264(a0)
    8000806e:	11e53823          	sd	t5,272(a0)
    80008072:	11f53c23          	sd	t6,280(a0)
    80008076:	140022f3          	csrr	t0,sscratch
    8000807a:	06553823          	sd	t0,112(a0)
    8000807e:	00853103          	ld	sp,8(a0)
    80008082:	02053203          	ld	tp,32(a0)
    80008086:	01053283          	ld	t0,16(a0)
    8000808a:	00053303          	ld	t1,0(a0)
    8000808e:	12000073          	sfence.vma
    80008092:	18031073          	csrw	satp,t1
    80008096:	12000073          	sfence.vma
    8000809a:	8282                	jr	t0

000000008000809c <userret>:
    8000809c:	12000073          	sfence.vma
    800080a0:	18051073          	csrw	satp,a0
    800080a4:	12000073          	sfence.vma
    800080a8:	02000537          	lui	a0,0x2000
    800080ac:	357d                	addiw	a0,a0,-1
    800080ae:	0536                	slli	a0,a0,0xd
    800080b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800080b4:	03053103          	ld	sp,48(a0)
    800080b8:	03853183          	ld	gp,56(a0)
    800080bc:	04053203          	ld	tp,64(a0)
    800080c0:	04853283          	ld	t0,72(a0)
    800080c4:	05053303          	ld	t1,80(a0)
    800080c8:	05853383          	ld	t2,88(a0)
    800080cc:	7120                	ld	s0,96(a0)
    800080ce:	7524                	ld	s1,104(a0)
    800080d0:	7d2c                	ld	a1,120(a0)
    800080d2:	6150                	ld	a2,128(a0)
    800080d4:	6554                	ld	a3,136(a0)
    800080d6:	6958                	ld	a4,144(a0)
    800080d8:	6d5c                	ld	a5,152(a0)
    800080da:	0a053803          	ld	a6,160(a0)
    800080de:	0a853883          	ld	a7,168(a0)
    800080e2:	0b053903          	ld	s2,176(a0)
    800080e6:	0b853983          	ld	s3,184(a0)
    800080ea:	0c053a03          	ld	s4,192(a0)
    800080ee:	0c853a83          	ld	s5,200(a0)
    800080f2:	0d053b03          	ld	s6,208(a0)
    800080f6:	0d853b83          	ld	s7,216(a0)
    800080fa:	0e053c03          	ld	s8,224(a0)
    800080fe:	0e853c83          	ld	s9,232(a0)
    80008102:	0f053d03          	ld	s10,240(a0)
    80008106:	0f853d83          	ld	s11,248(a0)
    8000810a:	10053e03          	ld	t3,256(a0)
    8000810e:	10853e83          	ld	t4,264(a0)
    80008112:	11053f03          	ld	t5,272(a0)
    80008116:	11853f83          	ld	t6,280(a0)
    8000811a:	7928                	ld	a0,112(a0)
    8000811c:	10200073          	sret
	...
