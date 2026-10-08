#include <stdio.h>
#include <foo.h>
#include <bar.h>

int main(int argc, char **argv)
{
  if (foo() != 42)
    return 1;
  if (bar() != 42)
    return 1;
  fprintf(stderr, "ok\n");
  return 0;
}
