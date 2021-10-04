// makeCWrapper /path/to/executable

#include <unistd.h>
#include <stdlib.h>

int main(int argc, char **argv) {
    argv[0] = "/path/to/executable";
    return execv("/path/to/executable", argv);
}
