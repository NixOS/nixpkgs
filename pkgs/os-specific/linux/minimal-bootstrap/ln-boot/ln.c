#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char** argv)
{
  if (argc != 4 || strcmp(argv[1], "-s")) {
    fputs("Usage: ", stdout);
    fputs(argv[0], stdout);
<<<<<<< HEAD
    fputs(" -s TARGET LINK_NAME\n", stdout);
=======
    fputs("ln -s TARGET LINK_NAME\n", stdout);
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    exit(EXIT_FAILURE);
  }

  symlink(argv[2], argv[3]);
  exit(EXIT_SUCCESS);
}
