#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char** argv)
{
  if (argc != 4 || strcmp(argv[1], "-s")) {
    fputs("Usage: ", stdout);
    fputs(argv[0], stdout);
    fputs(" -s TARGET LINK_NAME\n", stdout);
    exit(EXIT_FAILURE);
  }

  symlink(argv[2], argv[3]);
  exit(EXIT_SUCCESS);
}
