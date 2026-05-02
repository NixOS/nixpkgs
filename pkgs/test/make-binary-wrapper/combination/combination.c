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

void set_env_prefix(char *env, char *sep, char *prefix) {
  char *existing_env = getenv(env);
  if (existing_env) {
    char *val;

    char *existing_prefix = strstr(existing_env, prefix);
    unsigned long prefix_len = strlen(prefix);
    // If the prefix already exists, remove the original
    if (existing_prefix && is_surrounded_by_sep(existing_env, existing_prefix, prefix_len, sep)) {
      if (existing_env == existing_prefix) {
        return;
      }
      unsigned long sep_len = strlen(sep);
      int n_before = existing_prefix - existing_env;
      assert_success(asprintf(&val, "%s%s%.*s%s", prefix, sep,
                              n_before, existing_env,
                              existing_prefix + prefix_len + sep_len));
    } else {
      assert_success(asprintf(&val, "%s%s%s", prefix, sep, existing_env));
    }
    assert_success(setenv(env, val, 1));
    free(val);
  } else {
    assert_success(setenv(env, prefix, 1));
  }
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
    assert_success(setenv("MESSAGE", "HELLO", 0));
    set_env_prefix("PATH", ":", "/usr/bin/");
    set_env_suffix("PATH", ":", "/usr/local/bin/");
    putenv("MESSAGE2=WORLD");

    char **argv_tmp = calloc(3 + argc + 0 + 1, sizeof(*argv_tmp));
    assert(argv_tmp != NULL);
    argv_tmp[0] = argv[0];
    argv_tmp[1] = "-x";
    argv_tmp[2] = "-y";
    argv_tmp[3] = "-z";
    for (int i = 1; i < argc; ++i) {
        argv_tmp[3 + i] = argv[i];
    }
    argv_tmp[3 + argc + 0] = NULL;
    argv = argv_tmp;

    argv[0] = "my-wrapper";
    return execv("/send/me/flags", argv);
}
