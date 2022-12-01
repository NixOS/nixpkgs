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

int main(int argc, char **argv) {
    set_env_prefix("PATH", ":", "/usr/bin/");
    set_env_prefix("PATH", ":", "/usr/local/bin/");
    argv[0] = "/send/me/flags";
    return execv("/send/me/flags", argv);
}
