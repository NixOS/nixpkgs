#include <stdio.h>

extern unsigned int foo(void);

int main(int argc, char **argv)
{
  if (foo() != 42) {
    return 1;
  }
  fprintf(stderr, "ok\n");
  return 0;
}
