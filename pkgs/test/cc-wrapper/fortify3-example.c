/* an example that should be protected by FORTIFY_SOURCE=3 but
 * not FORTIFY_SOURCE=2 */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>


int main(int argc, char *argv[]) {
    char* buffer = malloc(atoi(argv[2]));
    strcpy(buffer, argv[1]);
    puts(buffer);
    return 0;
}
