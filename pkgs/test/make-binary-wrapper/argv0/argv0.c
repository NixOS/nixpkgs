#include <unistd.h>
#include <stdlib.h>

int main(int argc, char **argv) {
    argv[0] = "alternative-name";
    return execv("/send/me/flags", argv);
}
