#define _GNU_SOURCE

#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>
#include <dlfcn.h>

static const char sandbox_path[] = "/chrome-sandbox";

int __xstat(int ver, const char* path, struct stat* stat_buf) {
  static int (*original_xstat)(int, const char*, struct stat*) = NULL;
  if (original_xstat == NULL) {
    int (*fun)(int, const char*, struct stat*) = dlsym(RTLD_NEXT, "__xstat");
    if (fun == NULL) {
      return -1;
    };
    original_xstat = fun;
  };

  int res = (*original_xstat)(ver, path, stat_buf);
  if (res == 0) {
    char* pos = strstr(path, sandbox_path);
    if (pos != NULL && *(pos + sizeof(sandbox_path) - 1) == '\0') {
      printf("Lying about chrome-sandbox access rights...\n");
      stat_buf->st_uid = 0;
      stat_buf->st_gid = 0;
      stat_buf->st_mode = 0104755;
    };
  }
  return res;
}
