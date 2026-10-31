#include <stdio.h>
#include <foo.h>

int main(int argc, char **argv)
{
  if (foo() != 42)
    return 1;
  fprintf(stderr, "ok\n");
  return 0;
}
