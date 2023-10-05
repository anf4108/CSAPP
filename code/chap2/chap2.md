## 信息的表示和处理

### 信息存储

bit(位):    现代计算机存储和处理的信息,以二值信号表示.
byte(字节): 8位的块, 最小的可寻址的内存单位.
memory:     字节数组
address:    内存的每个字节都由一个唯一的数字来标识

#### 十六进制
```
0    1    2    3    4    5    6    7    8    9    10   11   12   13   14   15
0    1    2    3    4    5    6    7    8    9    A    B    C    D    E    F
0000 0001 0010 0011 0100 0101 0110 0111 1000 1001 1010 1011 1100 1101 1110 1111
```
* 一个字节的值域是`0x00 ~ 0xFF` (0~255).

#### 字数据大小
word size(字长): 指针数据的标称大小 (nominal size) .
对于一个字长为 $w$ 位的机器而言，虚拟地址的范围为 $0$~$2^w-1$, 程序最多访问$2^w$个字节。
```
char    1
short   2
int     4
long    8
char*   8
float   4
double  8
```

#### 寻址与字节顺序
$w$位整数: $[x_{w-1}, x_{w-2}, \ldots , x_1, x_0]$
最低有效字节在最前面的方式，称为小端法 (little endian) .
最高有效字节在最前面的方式，称为大端法 (big endian).

C 语言中字符串被编码为一个以 null( 其值为 0) 字符结尾的字符数组.文
本数据比二进制数据具有更强的平台独立性。
不同的机器类型使用不同的且不兼容的指令和编码方 式 。 即使是完全一样的进程，运行在不同的操作系统上也会有不同的编码规则，因此二进制代码是不兼容的。二进制代码很少能在不同机器和操作系统组合之间移植。
计算机系统的一个基本概念就是，从机器的角度来看，程序仅仅只是字节序列。机器没有关千原始源程序的任何信息，除了可能有些用来帮助调试的辅助表以外。

#### 运算
按位运算:
$\lnot \land \lor \oplus$
`! & | ^`
逻辑运算: `|| && !`
移位运算:  `<< >>`
$[x_{w-1}, x_{w-2}, \ldots , x_1, x_0]$
左移: $[x_{w-k-1}, x_{w-k-2}, \ldots , x_0, 0, \ldots , 0]$
逻辑右移: $[0, 0, \ldots ,x_{w-1}, x_{w-2}, \ldots , x_k,]$
算数右移: $[x_{w-1}, x_{w-1}, \ldots ,x_{w-1}, x_{w-2}, \ldots , x_k,]$
$k \geq w$, 移位 $k \mod w$

### 整数表示
$B$     binary
$U_w$   unsigned            
$T_w$   two's complement    

#### 整数取值范围
$TMin_w = -2^{w-1}$ $TMax_w = 2^{w-1} - 1$ $UMax_w = 2^{w}$ 

#### 编码
$B = \vec{x} = [x_{w-1}, x_{w-2}, \ldots , x_1, x_0]$
$B2U_w(\vec{x}) \doteq \sum_{i=0}^{w-1} x_i 2^i$
$B2T_w(\vec{x}) \doteq -x_{w-1}2^{w-1} + \sum_{i=0}^{w-2} x_i 2^i$

$T2U_w(x) = \begin{cases} x+2^w, &x<0 \\ x, &x\geq 0\end{cases}$
$U2T_w(u) = \begin{cases} u, &u<TMax_w \\ u-2^w, &u\geq TMax_w\end{cases}$

#### 重要数字: 
(8 bits)
$UMax_w = 0xFF$
$TMin_w = 0x80$
$TMax_w = 0x7F$
$-1 = 0xFF\quad 0 = 0x00$

#### 拓展位表示:
无符号数的零拓展: $u'=[0, \ldots ,0,u_{w-1}, u_{w-2}, \ldots u_0]$
补码数的符号拓展: $x'=[x_{w-1}, \ldots ,x_{w-1},x_{w-2}, \ldots x_0]$
#### 截断数字:
$B 2 U_k\left[x_{k-1}, x_{k-2}, \cdots, x_0\right]=B 2 U_w\left(\left[x_{w-1}, x_{w-2}, \cdots, x_0\right]\right) \bmod 2^k$
$B 2 T_k\left[x_{k-1}, x_{k-2}, \cdots, x_0\right]=U 2 T_k\left(B 2 U_w\left(\left[x_{w-1}, x_{w-2}, \cdots, x_0\right]\right) \bmod 2^k\right)$

### 整数运算
$0 \leq x, y < 2^w$
$x +_w^u y = \begin{cases} x+y, &x+y<2^w &\text{normal} \\ x+y-2^w, & 2^w \leqslant x+y<2^{w+1} &\text{overflow} \end{cases}$
* overflow: $s=x +_w^u y \quad s<x, s<y$.

$-_w^u x = \begin{cases} x, &x=0\\2^w-x, &x>0 \end{cases}$

$-2^{w-1} \leq x, y < 2^{w-1}-1$
$x +_w^t y = \begin{cases} x+y-2^w, &2^{w-1}\leq x+y &\text{positive overflow} \\ x+y, &-2^{w-1}\leq x+y<2^{w-1} &\text{normal} \\ x+y+2^w, &x+y<-2^{w-1} &\text{negative overflow} \end{cases}$
$x+_w^t y = U2T_w(T2U_w(x)+_w^u T2U_w(y))$
* overflow: $s=x +_w^u y$
  positive overflow: $x>0, y>0, s\leq 0$
  negative overflow: $x<0, y<0, s\geq 0$

$-_w^t x = \begin{cases} TMin_w, &x=TMin_w \\ -x, &x>TMin_w \end{cases}$

$0 \leq x, y \leq  UMax_w$
$x *_w^u y = (x\cdot y)\bmod 2^w$
$TMin_w \leq x, y \leq TMax_w$
$x *_w^t y=U2T_w((x \cdot y) \bmod 2^w)$
$T2B_w(x *_w^u y) = U2B_w(x *_w^t y)$

`<<`:  left shift
$x \ll k = x\cdot 2^k$
`>>u`: logical right shift 
`>>t`: arithmatic right shift
$x \gg k =\left\lfloor x/2^k \right\rfloor$
$(x+(1\ll k)-1)\gg k = \left\lceil x/2^k \right\rceil$


### 浮点数表示
$V=x \times  2^y$

#### 二进制小数
$\displaystyle b= \sum_{i=-n}^m 2^i \times b_i$

#### IEEE浮点表示
$V=(-1)^s\times M\times 2^E$
* s:  sign(符号)  1位
* M:  significand(尾数)  k位
* E:  exponent(阶码)  n位

``s  exp  frac``
$s \quad e_{k-1}\cdots e_1e_0\quad f_{n-1}\cdots f_1f_0$
$Bias=2^{k-1}-1$ 
$e=e_{k-1}\cdots e_1e_0\quad f=0.f_{n-1}\cdots f_1f_0  \quad 
0\leq f<1 \quad$
``````
float:   k=8bits  n=23bits  Bias=127
double:  k=11bits n=52bits  Bias=2047
``````


**规格化的值**
`exp != 0, exp != ~0`
$E=e-Bias \quad M=1+f$

**非规格化的值**
`exp == 0`
$E=1-Bias, M=f$

**特殊值**
`exp == ~0`
`frac == 0`: $V=\begin{cases} +\infty, &s=0\\ -\infty, &s \neq 0 \end{cases}$
`frac != 0`: $V= \text{NaN}$

#### 舍入 
round-to nearest, round to even

### 浮点数运算
$x +^f y = Round(x+y)$ 
封闭 (可能产生 $\pm\infty, NaN$)
可交换: $x+^fy=y+^fx$
不可结合: `3.14+(1e10-1e10)=3.14 (3.14+1e10)-1e10=0.0`
有逆元 (无穷与NaN除外): $x +^f -x = 0\quad +\infty-\infty=NaN\quad NaN+^fx=NaN$
单调性 $a\geq b, x+a\geq x+b \quad(x \neq NaN)$

$x *^f y = Round(x+y)$ 
封闭, 可交换(单位元1.0), 不可结合(溢出, 舍入失去精度), 在加法上不可分配, 满足下列单调性: 
$\begin{aligned} & a \geqslant b , c \geqslant 0 \Rightarrow a *{ }^{\mathrm{f}} c \geqslant b *{ }^{\mathrm{f}} c \\ & a \geqslant b , c \leqslant 0 \Rightarrow a *{ }^{\mathrm{f}} c \leqslant b *{ }^{\mathrm{f}} c\end{aligned}$
$a \neq NaN \Rightarrow a *^f a \geq 0$

#### 类型转换
从 `int` 转换成 `float`, 数字不会溢出, 但是可能被舍人。
从 `int` 或 `float` 转换成 double, 因为 double 有更大的范围(也就是可表示值的范 围), 也有更高的精度 (也就是有效位数), 所以能够保留精确的数值。
从 double 转换成 `float`, 因为范围要小一些, 所以值可能溢出成 $+\infty$ 或 $-\infty$ 。另 外, 由于精确度较小, 它还可能被舍人。
从 `float` 或者 `double` 转换成 `int`, 值将会向零舍人。例如, 1.999 将被转换成 1 , 而 -1.999 将被转换成 -1 。进一步来说, 值可能会溢出。C 语言标准没有对这种情 况指定固定的结果。与 Intel 兼容的微处理器指定位模式 $[10 \cdots 00]$ (字长为 $w$ 时的 $T M i n_w$ ) 为整数不确定 (`int`eger indefinite) 值。一个从浮点数到整数的转换, 如果不 能为该浮点数找到一个合理的整数近似值, 就会产生这样一个值。因此, 表达式 (`int`) $+1 e 10$ 会得到 -21483648 , 即从一个正值变成了一个负值。
