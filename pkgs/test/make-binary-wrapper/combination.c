// makeCWrapper /path/to/executable \
    --argv0 my-wrapper \
    --set-default MESSAGE HELLO \
    --prefix PATH : /usr/bin/ \
    --suffix PATH : /usr/local/bin/ \
    --add-flags "-x -y -z" \
    --set MESSAGE2 WORLD

#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

char *concat3(char *x, char *y, char *z) {
    int xn = strlen(x);
    int yn = strlen(y);
    int zn = strlen(z);
    char *res = malloc(sizeof(*res)*(xn + yn + zn + 1));
    assert(res != NULL);
    strncpy(res, x, xn);
    strncpy(res + xn, y, yn);
    strncpy(res + xn + yn, z, zn);
    res[xn + yn + zn] = '\0';
    return res;
}

void set_env_prefix(char *env, char *sep, char *val) {
    char *existing = getenv(env);
    if (existing) val = concat3(val, sep, existing);
    setenv(env, val, 1);
    if (existing) free(val);
}

void set_env_suffix(char *env, char *sep, char *val) {
    char *existing = getenv(env);
    if (existing) val = concat3(existing, sep, val);
    setenv(env, val, 1);
    if (existing) free(val);
}

int main(int argc, char **argv) {
    setenv("MESSAGE", "HELLO", 0);
    set_env_prefix("PATH", ":", "/usr/bin/");
    set_env_suffix("PATH", ":", "/usr/local/bin/");
    putenv("MESSAGE2=WORLD");

    char **argv_tmp = malloc(sizeof(*argv_tmp) * (4 + argc));
    assert(argv_tmp != NULL);
    argv_tmp[0] = argv[0];
    argv_tmp[1] = "-x";
    argv_tmp[2] = "-y";
    argv_tmp[3] = "-z";
    for (int i = 1; i < argc; ++i) {
        argv_tmp[3 + i] = argv[i];
    }
    argv_tmp[3 + argc] = NULL;
    argv = argv_tmp;

    argv[0] = "my-wrapper";
    return execv("/path/to/executable", argv);
}
