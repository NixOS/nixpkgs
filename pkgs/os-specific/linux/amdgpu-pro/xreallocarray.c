#include <malloc.h>

void *xreallocarray(void *ptr, size_t nmemb, size_t size) {
  return reallocarray(ptr, nmemb, size);
}
