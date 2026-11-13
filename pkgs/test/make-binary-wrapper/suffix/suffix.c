#define _GNU_SOURCE         /* See feature_test_macros(7) */
#include <unistd.h>
#include <stdlib.h>
#include <assert.h>
#include <stdio.h>
#include <string.h>

#define assert_success(e) do { if ((e) < 0) { perror(#e); abort(); } } while (0)

int is_surrounded_by_sep(char *env, char *ptr, unsigned long len, char *sep) {
  unsigned long sep_len = strlen(sep);

  // Check left side (if not at start)
  if (env != ptr) {
    if (ptr - env < sep_len)
      return 0;
    if (strncmp(sep, ptr - sep_len, sep_len) != 0) {
      return 0;
    }
  }
  // Check right side (if not at end)
  char *end_ptr = ptr + len;
  if (*end_ptr != '\0') {
    if (strncmp(sep, ptr + len, sep_len) != 0) {
      return 0;
    }
  }

  return 1;
}

void set_env_suffix(char *env, char *sep, char *suffix) {
  char *existing_env = getenv(env);
  if (existing_env) {
    char *val;

    char *existing_suffix = strstr(existing_env, suffix);
    unsigned long suffix_len = strlen(suffix);
    // If the suffix already exists, remove the original
    if (existing_suffix && is_surrounded_by_sep(existing_env, existing_suffix, suffix_len, sep)) {
      char *end_ptr = existing_suffix + suffix_len;
      if (*end_ptr == '\0') {
        return;
      }
      unsigned long sep_len = strlen(sep);
      int n_before = existing_suffix - existing_env;
      assert_success(asprintf(&val, "%.*s%s%s%s",
                              n_before, existing_env,
                              existing_suffix + suffix_len + sep_len,
                              sep, suffix));
    } else {
      assert_success(asprintf(&val, "%s%s%s", existing_env, sep, suffix));
    }
    assert_success(setenv(env, val, 1));
    free(val);
  } else {
    assert_success(setenv(env, suffix, 1));
  }
}

int main(int argc, char **argv) {
    set_env_suffix("PATH", ":", "/usr/bin/");
    set_env_suffix("PATH", ":", "/usr/local/bin/");
    argv[0] = "/send/me/flags";
    return execv("/send/me/flags", argv);
}
