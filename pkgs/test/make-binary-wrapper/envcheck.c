#include <limits.h>
#include <stdio.h>
#include <unistd.h>

int main(int argc, char **argv, char **envp) {
  for (char **env = envp; *env != 0; ++env) {
    puts(*env);
  }

   char cwd[PATH_MAX];
   if (getcwd(cwd, sizeof(cwd))) {
     printf("CWD=%s\n", cwd);
   } else {
     perror("getcwd() error");
     return 1;
   }

  for (int i=0; i < argc; ++i) {
    puts(argv[i]);
  }
  return 0;
}
