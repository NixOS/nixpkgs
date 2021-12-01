// makeCWrapper /hello/world \
    --set PART1 HELLO \
    --set-default PART2 WORLD \
    --unset SOME_OTHER_VARIABLE \
    --set PART3 $'"!!\n"'

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

#define assert_success(e) do { if ((e) < 0) { perror(#e); exit(1); } } while (0)

int main(int argc, char **argv) {
    putenv("PART1=HELLO");
    assert_success(setenv("PART2", "WORLD", 0));
    assert_success(unsetenv("SOME_OTHER_VARIABLE"));
    putenv("PART3=\"!!\n\"");
    argv[0] = "/hello/world";
    return execv("/hello/world", argv);
}