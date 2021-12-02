// makeCWrapper /path/to/executable \
    --chdir /usr/local/bin

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

#define assert_success(e) do { if ((e) < 0) { perror(#e); abort(); } } while (0)

int main(int argc, char **argv) {
    assert_success(chdir("/usr/local/bin"));
    argv[0] = "/path/to/executable";
    return execv("/path/to/executable", argv);
}