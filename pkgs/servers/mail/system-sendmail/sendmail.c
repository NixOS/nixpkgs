#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static int try_exec(const char *path, char **argv) {
  execv(path, argv);

  if (errno == ENOENT || errno == EACCES || errno == ENOTDIR)
    return 1;

  perror(path);
  exit(1);
}

int main(int, char **argv) {
  argv[0] = "sendmail";

  char *path = getenv("PATH");
  char *path_copy = path ? strdup(path) : NULL;
  for (char *dir = path_copy ? strtok(path_copy, ":") : NULL; dir; dir = strtok(NULL, ":")) {
    char *candidate;
    if (asprintf(&candidate, "%s/sendmail", dir) >= 0) {
      if (strcmp(candidate, PATH_SELF) != 0) {
        try_exec(candidate, argv);
      }
      free(candidate);
    }
  }
  free(path_copy);

  try_exec("/run/wrappers/bin/sendmail", argv);
  try_exec("/run/current-system/sw/bin/sendmail", argv);

  fprintf(stderr, "Unable to find system sendmail.\n");
  return 1;
}
