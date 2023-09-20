#define _GNU_SOURCE         /* See feature_test_macros(7) */
#include <unistd.h>
#include <stdlib.h>
#include <assert.h>
#include <stdio.h>

#define assert_success(e) do { if ((e) < 0) { perror(#e); abort(); } } while (0)

void set_env_prefix(char *env, char *sep, char *prefix) {
    char *existing = getenv(env);
    if (existing) {
        char *val;
        assert_success(asprintf(&val, "%s%s%s", prefix, sep, existing));
        assert_success(setenv(env, val, 1));
        free(val);
    } else {
        assert_success(setenv(env, prefix, 1));
    }
}

void set_env_suffix(char *env, char *sep, char *suffix) {
    char *existing = getenv(env);
    if (existing) {
        char *val;
        assert_success(asprintf(&val, "%s%s%s", existing, sep, suffix));
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
