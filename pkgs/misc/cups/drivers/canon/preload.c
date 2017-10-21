/*
 * LD_PRELOAD trick to make c3pldrv handle the absolute path to /usr/{bin,lib,share)}.
 * As c3pldrv is a 32 bit executable, /lib will be rewritten to /lib32.
 *
 * Usage:
 *   gcc -shared -fPIC -DOUT="$out" preload.c -o preload.so -ldl
 *   LD_PRELOAD=$PWD/preload.so ./c3pldrv
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <dlfcn.h>
#include <limits.h>

#ifndef OUT
#error Missing OUT define - path to the installation directory.
#endif

typedef void *(*dlopen_func_t)(const char *filename, int flag);
typedef int (*open_func_t)(const char *pathname, int flags, ...);
typedef int (*execv_func_t)(const char *path, char *const argv[]);


void *dlopen(const char *filename, int flag)
{
	dlopen_func_t orig_dlopen;
	const char *new_filename;
	char buffer[PATH_MAX];

	orig_dlopen = (dlopen_func_t)dlsym(RTLD_NEXT, "dlopen");

	new_filename = filename;
	if (strncmp("/usr/lib", filename, 8) == 0) {
		snprintf(buffer, PATH_MAX, OUT "/lib32%s", filename+8);
		buffer[PATH_MAX-1] = '\0';
		new_filename = buffer;
	}
	
	return orig_dlopen(new_filename, flag);
}

int open(const char *pathname, int flags, ...)
{
	open_func_t orig_open;
	const char *new_pathname;
	char buffer[PATH_MAX];

	orig_open = (open_func_t)dlsym(RTLD_NEXT, "open");

	new_pathname = pathname;
	if (strncmp("/usr/share", pathname, 10) == 0) {
		snprintf(buffer, PATH_MAX, OUT "%s", pathname+4);
		buffer[PATH_MAX-1] = '\0';
		new_pathname = buffer;
	}
	
	return orig_open(new_pathname, flags);
}

int execv(const char *path, char *const argv[])
{
	execv_func_t orig_execv;
	const char *new_path;
	char buffer[PATH_MAX];

	orig_execv = (execv_func_t)dlsym(RTLD_NEXT, "execv");

	new_path = path;
	if (strncmp("/usr/bin", path, 8) == 0) {
		snprintf(buffer, PATH_MAX, OUT "%s", path+4);
		buffer[PATH_MAX-1] = '\0';
		new_path = buffer;
	}
	
	return orig_execv(new_path, argv);
}

