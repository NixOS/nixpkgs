#include <unistd.h>
#include <stdlib.h>
#include <assert.h>

int main(int argc, char **argv) {
    char **argv_tmp = calloc(9 + argc + 3 + 1, sizeof(*argv_tmp));
    assert(argv_tmp != NULL);
    argv_tmp[0] = argv[0];
    argv_tmp[1] = "-x";
    argv_tmp[2] = "-y";
    argv_tmp[3] = "-z";
    argv_tmp[4] = "-abc";
    argv_tmp[5] = "test var here";
    argv_tmp[6] = "-g";
    argv_tmp[7] = "*.txt";
    argv_tmp[8] = "-a";
    argv_tmp[9] = "*";
    for (int i = 1; i < argc; ++i) {
        argv_tmp[9 + i] = argv[i];
    }
    argv_tmp[9 + argc + 0] = "-foo";
    argv_tmp[9 + argc + 1] = "-bar";
    argv_tmp[9 + argc + 2] = "test var 2 here";
    argv_tmp[9 + argc + 3] = NULL;
    argv = argv_tmp;

    argv[0] = "/send/me/flags";
    return execv("/send/me/flags", argv);
}
