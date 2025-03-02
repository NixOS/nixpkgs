/* an example that should be protected by FORTIFY_SOURCE=1 */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>


int main(int argc, char *argv[]) {
    /* allocate on the heap so we're likely to get an
     * over-allocation and can be more sure that a
     * failure is because of fortify protection rather
     * than a genuine segfault */
    char* buffer = malloc(sizeof(char) * 7);
    strcpy(buffer, argv[1]);
    puts(buffer);
    return 0;
}
