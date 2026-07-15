#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

#define assert_success(e) do { if ((e) < 0) { perror(#e); abort(); } } while (0)

int main(int argc, char **argv) {
    assert_success(chdir("./tmp/foo"));
    argv[0] = "/send/me/flags";
    return execv("/send/me/flags", argv);
}
