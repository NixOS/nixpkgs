#include <sanitizer/asan_interface.h>
#include <stdio.h>

int main(int argc, char **argv)
{
  fprintf(stderr, "ok\n");
  return 0;
}
