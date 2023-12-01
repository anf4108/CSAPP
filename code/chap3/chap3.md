## 程序的机器级表示

### 历史观点

Intel处理器系列俗称x86,经历了一个长期的、不断进化的发展过程.开始时,它是第一代单芯片、16位微处理器之一,由千当时集成电路技术水平十分有限,其中做了很多妥协.以后,它不断地成长,利用进步的技术满足更高性能和支持更高级操作系统的需求.

每个后继处理器的设计都是后向兼容的一较早版本上编译的代码可以在较新的处理器上运行.正如我们看到的那样,为了保持这种进化传统,指令集中有许多非常奇怪的东西.Intel处理器系列有好几个名字,包括IA32,也就是"Intel32位体系结构 (IntelArchitecture32-bit)",以及最新的Intel64,即IA32的64位扩展,我们也称为x86-64.最常用的名字是"x86",我们用它指代整个系列,也反映了直到凶86处理器命名的惯例.

### 程序编码

``gcc``是Linux上默认的编译器.gcc命令调用了一整套的程序,将源代码转化成可执行代码.
*C预处理器(C preprocesser)扩展源代码,插入所有用``#include``命令指定的文件,并扩展所有用`#define`声明指定的宏.
*编译器(compiler)产生两个源文件的汇编代码,名字分别为p1.s和p2.s.
*汇编器(assembler)会将汇编代码转化成二进制目标代码文件p2.o和p2.o.目标代码是机器代码的一种形式,它包含所有指令的二进制表示,但是还没有填入全局值的地址.
*链接器(linker)将两个目标代码文件与实现库函数（例如printf)的代码合并,并产生最终的可执行代码文件p（由命令行指示符-o p指定的）.可执行代码是我们要考虑的机器代码的第二种形式,也就是处理器执行的代码格式.
```
text    C program (p1.c p2.c)       Compiler(gcc)
text    Asm program (p1.s p2.s)     Assembler (as)
binary  Object program (p1.o p2.o) 
        Static libraries(.a)        Linker (ld) 
binary  Executable program (p)
```

指令集体系结构或指令集架构 (Instruction Set Architecture, ISA)定义机器级程序的格式和行为,它定义了处理器状态、指令的格式,以及每条指令对状态的影响.
虚拟地址是机器级程序使用的内存地址,看上去是一个非常大的字节数组.
编译过程中,编译器会完成大部分的工作,将把用
C 语言提供的相对比较抽象的 执行模型表示的程序转化成处理器执行的非常基本的指令. 汇编代码表示非常接近于机器代 码. 与机器代码的二进制格式相比,汇编代码的主要特点是它用可读性更好的文本格式表示.

### 数据格式

| C声明   | 汇编后缀  | 字节  |
|--------|----------|------|
| char   | b        | 1    |
| short  | w        | 2    |
| int    | l        | 4    |
| long   | q        | 8    |
| char*  | q        | 8    |
| float  | s        | 4    |
| double | l        | 8    |


### 访问信息
寄存器
| 64 位寄存器 | 低 32 位 | 低 16 位 | 低 8 位 |
|-------------|----------|----------|---------|
| %rax        | %eax     | %ax      | %al     |
| %rbx        | %ebx     | %bx      | %bl     |
| %rcx        | %ecx     | %cx      | %cl     |
| %rdx        | %edx     | %dx      | %dl     |
| %rsi        | %esi     | %si      | %sil    |
| %rdi        | %edi     | %di      | %dil    |
| %rbp        | %ebp     | %bp      | %bpl    |
| %rsp        | %esp     | %sp      | %spl    |
| %r8         | %r8d     | %r8w     | %r8b    |
| %r9         | %r9d     | %r9w     | %r9b    |
| %r10        | %r10d    | %r10w    | %r10b   |
| %r11        | %r11d    | %r11w    | %r11b   |
| %r12        | %r12d    | %r12w    | %r12b   |
| %r13        | %r13d    | %r13w    | %r13b   |
| %r14        | %r14d    | %r14w    | %r14b   |
| %r15        | %r15d    | %r15w    | %r15b   |
```
PC              %rip
return value    %rax
arguments       %rdi %rsi %rdx %rcx %r8 %r9 ...stack
stack pointer   %rsp
frame pointer   %rbp
caller          %rbx, %rbp, %r12, %r13, %r14, %r15
```
操作数(operand): 指示出执行一个操作中要使用的源数据值,以及放置结果的目的位置. 
操作数格式
| 类型   | 格式            | 操作数值          |
|--------|-----------------|-------------------|
| 立即数 | \$Imm            | Imm               |
| 寄存器 | ra              | R[ra]             |
| 存储器 | Imm(rb, ri, s)  | M[Imm+R[rb]+R[ri]*s] |

```
数据传送
MOV     S, D    D<-S        R<-I
movb movw movl movq         movabsq
MOVZ    S, D    D<-z(S)
movzbw movzbl movzwl movzbq movzwq (movl)
MOVS    S, D    D<-s(S)
movsbw movsbl movswl movsbq movswq movslq cltq 
PUSH    S    
POP     D

算数与逻辑操作
leaq    S, D    D<-&S
INC DEC NEG NOT             D
ADD SUB IMUL XOR OR AND     S, D 
SAL SHL SAR SHR             k, D
imulq mulq idivq divq       S 
cqto

控制
CF ZF SF OF
CMP     S1, S2  S2-S1
cmpb  cmpw  cmpl  cmpq
TEST    S1, S2  S2&S1
testb testw testl testq
SET     D
sete setne setz setnz sets setns
setg setge setnge setng
setl setle setnle setnl
seta setae setnae setna
setb setbe setnbe setnb
JMP     lable/*operand
J       lable
je jne jz jnz js jns
jg jge jnge jng
jl jle jnle jnl
ja jae jnae jna
jb jbe jnbe jnb

CMOV    S, R
cmove cmovne cmovz cmovnz cmovs cmovns
cmovg cmovge cmovnge cmovng
cmovl cmovle cmovnle cmovnl
cmova cmovae cmovnae cmovna
cmovb cmovbe cmovnbe cmovnb

call    lable/*operand
ret
``` 




### 命令
```
linux> gcc -Og -o p p1.c p2.c
linux> gcc -Og -S mstore.c
linux> gcc -Og -c mstore.c
linux> objdump -d mstore.o
```
























