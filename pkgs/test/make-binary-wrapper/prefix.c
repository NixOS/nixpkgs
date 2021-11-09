// makeCWrapper /path/to/executable \
    --prefix PATH : /usr/bin/ \
    --prefix PATH : /usr/local/bin/

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

int main(int argc, char **argv) {
    set_env_prefix("PATH", ":", "/usr/bin/");
    set_env_prefix("PATH", ":", "/usr/local/bin/");
    argv[0] = "/path/to/executable";
    return execv("/path/to/executable", argv);
}