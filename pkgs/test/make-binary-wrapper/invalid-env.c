// makeCWrapper /bad/env/example \
    --set "=" "TEST1" \
    --set-default "" "TEST2"

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

#define assert_success(e) do { if ((e) < 0) { perror(#e); exit(1); } } while (0)

int main(int argc, char **argv) {
    putenv("==TEST1");
    #error Illegal environment variable name `=` (cannot contain `=`)
    assert_success(setenv("", "TEST2", 0));
    #error Environment variable name can't be empty.
    argv[0] = "/bad/env/example";
    return execv("/bad/env/example", argv);
}