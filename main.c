#include <stdio.h>

int isTmax(int x) {
  int a = 1;
  a = a << 31;
  int b = ~(a | x);
  int res = !b;
  return res;
}

int main() {
    printf("%d\n", isTmax(2147483646));
    return 0;
}