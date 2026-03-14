#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

#define assert_success(e) do { if ((e) < 0) { perror(#e); abort(); } } while (0)

int main(int argc, char **argv) {
    putenv("PART1=HELLO");
    assert_success(setenv("PART2", "WORLD", 0));
    assert_success(unsetenv("SOME_OTHER_VARIABLE"));
    putenv("PART3=\"!!\n\"");
    argv[0] = "/send/me/flags";
    return execv("/send/me/flags", argv);
}
