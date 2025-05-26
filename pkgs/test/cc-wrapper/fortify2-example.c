/* an example that should be protected by FORTIFY_SOURCE=2 but
 * not FORTIFY_SOURCE=1 */
#include <stdio.h>
#include <string.h>

struct buffer_with_pad {
    char buffer[7];
    char pad[25];
};

int main(int argc, char *argv[]) {
    struct buffer_with_pad b;
    strcpy(b.buffer, argv[1]);
    puts(b.buffer);
    return 0;
}
