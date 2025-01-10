#define _GNU_SOURCE         /* See feature_test_macros(7) */
#include <unistd.h>
#include <stdlib.h>
#include <assert.h>
#include <stdio.h>

#define assert_success(e) do { if ((e) < 0) { perror(#e); abort(); } } while (0)

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
    set_env_suffix("PATH", ":", "/usr/bin/");
    set_env_suffix("PATH", ":", "/usr/local/bin/");
    argv[0] = "/send/me/flags";
    return execv("/send/me/flags", argv);
}
