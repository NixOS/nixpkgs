// makeCWrapper /path/to/executable \
    --inherit-argv0

#include <unistd.h>
#include <stdlib.h>

int main(int argc, char **argv) {
    return execv("/path/to/executable", argv);
}