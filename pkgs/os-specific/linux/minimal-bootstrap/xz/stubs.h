#define sig_atomic_t int

#define SSIZE_MAX LONG_MAX

#define O_NOCTTY 0400
#define O_NONBLOCK 04000

#define S_ISVTX 01000
#define S_ISLNK(mode) (((mode) & S_IFMT) == S_IFLNK)

int fchmod (int fd, int mode)
{
  return 0;
}

int fchown (int fd, int owner, int group)
{
  return 0;
}

#include <signal.h>
int sigfillset (sigset_t * set)
{
  return 0;
}
