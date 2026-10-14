#include <stdio.h>

extern unsigned int foo(void);

extern unsigned int baz(void)
{
    fprintf(stderr, "about to call foo()\n");
    fprintf(stderr, "foo returned %d\n", foo());
    return 0;
}
