// makeCWrapper /path/to/some/executable \
    --argv0 alternative-name

#include <unistd.h>
#include <stdlib.h>

int main(int argc, char **argv) {
    argv[0] = "alternative-name";
    return execv("/path/to/some/executable", argv);
}
