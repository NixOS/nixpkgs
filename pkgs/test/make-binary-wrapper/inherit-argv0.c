#include <unistd.h>
#include <stdlib.h>

int main(int argc, char **argv) {
    return execv("/send/me/flags", argv);
}
