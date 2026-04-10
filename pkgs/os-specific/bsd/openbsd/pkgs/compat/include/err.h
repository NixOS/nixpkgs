#pragma once
#include_next <err.h>

#include <errno.h>
#include <stdarg.h>
static inline void __attribute__((__format__(printf, 3, 4)))
errc(int eval, int code, const char *fmt, ...) {
  // verr uses the error code from errno
  // No need to keep the old value since this is noreturn anyway
  errno = code;

  va_list args;
  va_start(args, fmt);
  verr(eval, fmt, args);
  va_end(args);
}

static inline void __attribute__((__format__(printf, 2, 3)))
warnc(int code, const char *fmt, ...) {
  // verr uses the error code from errno
  int old_errno = errno;
  errno = code;

  va_list args;
  va_start(args, fmt);
  vwarn(fmt, args);
  va_end(args);

  errno = old_errno;
}
