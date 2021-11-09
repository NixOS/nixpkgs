// makeCWrapper /send/me/flags \
    --add-flags "-x -y -z" \
    --add-flags -abc

#include <unistd.h>
#include <stdlib.h>
#include <assert.h>

int main(int argc, char **argv) {
    char **argv_tmp = malloc(sizeof(*argv_tmp) * (5 + argc));
    assert(argv_tmp != NULL);
    argv_tmp[0] = argv[0];
    argv_tmp[1] = "-x";
    argv_tmp[2] = "-y";
    argv_tmp[3] = "-z";
    argv_tmp[4] = "-abc";
    for (int i = 1; i < argc; ++i) {
        argv_tmp[4 + i] = argv[i];
    }
    argv_tmp[4 + argc] = NULL;
    argv = argv_tmp;

    argv[0] = "/send/me/flags";
    return execv("/send/me/flags", argv);
}