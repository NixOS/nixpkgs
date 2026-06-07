#pragma once

#include_next <unistd.h>

// Reimplementing pledge and unvail with seccomp would be a pain,
// so do nothing but claim they succeeded
static int pledge(const char *, const char *) { return 0; }
static int unveil(const char *, const char *) { return 0; }
