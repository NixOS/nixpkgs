// This one should not come from libc because of -nostdinc
#include <stdio.h>

int main(int argc, char *argv[]) {
  // provided by our own stdio.h
  foo();
  return 0;
}
