#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
int main(int argc, char *argv[]) {
  if (argc < 2) {
    fprintf(stderr, "%s: no command specified\n", argv[0]);
    exit(-1);
  }
  execvp(argv[1], &argv[1]);
  char* err = strerror(errno);
  fprintf(stderr, "%s: %s: %s", argv[0], argv[1], err);
  exit(127);
}
