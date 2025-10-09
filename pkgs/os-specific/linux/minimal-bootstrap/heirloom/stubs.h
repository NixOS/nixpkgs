#include <getopt.h>
extern int optopt;

int ftruncate(int fd, int offset) {
  return -1;
}

int getsid (int pid) {
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
int mkstemp(char *t)
{
  mktemp(t);
  int fd = open(t, O_CREAT|O_RDWR|O_TRUNC, 0600);
  return fd;
}

int putenv(char *string)
{
  return 0;
}

char* realpath (char* path, char* resolved) {
  return NULL;
}

#define strncasecmp(a,b,n) strncmp(strupr(a),strupr(b),n)


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
