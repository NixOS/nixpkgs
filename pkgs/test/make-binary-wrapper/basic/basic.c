#include <unistd.h>
#include <stdlib.h>

int main(int argc, char **argv) {
    argv[0] = "/send/me/flags";
    return execv("/send/me/flags", argv);
}
