#pragma once
#include_next <fcntl.h>

// Linux doesn't let you lock during open, make these do nothing
#define O_EXLOCK 0
#define O_SHLOCK 0
