// makeCWrapper /hello/world \
    --set PART1 HELLO \
    --set-default PART2 WORLD \
    --unset SOME_OTHER_VARIABLE \
    --set PART3 $'"!!\n"'

#include <unistd.h>
#include <stdlib.h>

int main(int argc, char **argv) {
    putenv("PART1=HELLO");
    setenv("PART2", "WORLD", 0);
    unsetenv("SOME_OTHER_VARIABLE");
    putenv("PART3=\"!!\n\"");
    argv[0] = "/hello/world";
    return execv("/hello/world", argv);
}