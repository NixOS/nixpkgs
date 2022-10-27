#include <unistd.h>
#include <stdlib.h>
#include <assert.h>

int main(int argc, char **argv) {
    char **argv_tmp = calloc(4 + argc + 2 + 1, sizeof(*argv_tmp));
    assert(argv_tmp != NULL);
    argv_tmp[0] = argv[0];
    argv_tmp[1] = "-x";
    argv_tmp[2] = "-y";
    argv_tmp[3] = "-z";
    argv_tmp[4] = "-abc";
    for (int i = 1; i < argc; ++i) {
        argv_tmp[4 + i] = argv[i];
    }
    argv_tmp[4 + argc + 0] = "-foo";
    argv_tmp[4 + argc + 1] = "-bar";
    argv_tmp[4 + argc + 2] = NULL;
    argv = argv_tmp;

    argv[0] = "/send/me/flags";
    return execv("/send/me/flags", argv);
}
