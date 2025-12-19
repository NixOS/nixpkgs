#include <getopt.h>
extern int optopt;

static int ftruncate(int fd, int offset) {
  return -1;
}

static int getsid (int pid) {
  return -1;
}

static int isblank(int c)
{
	return c == ' ' || c == '\t';
}

#define lchown chown

// meslibc implements lstat but is missing declaration
#include <sys/stat.h>
int lstat (char const *file_name, struct stat *statbuf);

#include <fcntl.h>
static int mkstemp(char *t)
{
  mktemp(t);
  int fd = open(t, O_CREAT|O_RDWR|O_TRUNC, 0600);
  return fd;
}

static int strncasecmp(char *a, char *b, size_t n) {
  while (n > 0 && (*a || *b)) {
      if (toupper(*a) < toupper(*b)) {
          return -1;
      }
      if (toupper(*a) > toupper(*b)) {
          return 1;
      }
      a++; b++; n--;
  }
  return 0;
}


#define nlink_t unsigned long

#include <limits.h>
#define USHRT_MAX UINT16_MAX
#define SSIZE_MAX LONG_MAX
#define MB_LEN_MAX 1 

#define EPERM 1
#define ESRCH 3
#define EDOM 33
#define S_IFSOCK 0140000
#define S_ISVTX 01000
#define S_IREAD S_IRUSR
#define S_IWRITE S_IWUSR
#define S_IEXEC S_IXUSR

#define _PC_PATH_MAX PATH_MAX
#define _PC_VDISABLE 8
#define _POSIX_PATH_MAX PATH_MAX
#define LINE_MAX 4096

#define LC_TIME 0
