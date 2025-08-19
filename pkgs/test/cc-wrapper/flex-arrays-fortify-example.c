/* an example that should be protected by FORTIFY_SOURCE=2 but
 * only if the appropriate -fstrict-flex-arrays= argument is used
 * for the corresponding value used for BUFFER_DEF_SIZE
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct buffer_with_header {
    char header[1];
    char buffer[BUFFER_DEF_SIZE];
};

int main(int argc, char *argv[]) {
    /* use volatile pointer to prevent compiler
     * using the outer allocation length with a
     * fortified strcpy, which would throw off
     * the function-name-sniffing fortify-detecting
     * approaches
     */
    struct buffer_with_header *volatile b = \
      (struct buffer_with_header *)malloc(sizeof(struct buffer_with_header)+1);

    /* if there are no arguments, skip the write to allow
     * builds with BUFFER_DEF_SIZE=0 to have a case where
     * the program passes even with strict protection.
     */
    if (argc > 1) {
        strcpy(b->buffer, argv[1]);
        puts(b->buffer);
    }
    return 0;
}
