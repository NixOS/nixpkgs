/*
 * LD_PRELOAD trick to make Saleae Logic work from a read-only installation
 * directory.
 *
 * Saleae Logic tries to write to the ./Settings/settings.xml file, relative to
 * its installation directory. Because the nix store is read-only, we have to
 * redirect access to this file somewhere else. Here's the map:
 *
 *   $out/Settings/settings.xml => $HOME/.saleae-logic-settings.xml
 *
 * This also makes the software multi-user aware :-)
 *
 * NOTE: The next Logic version is supposed to have command line parameters for
 * configuring where the Settings/ directory is located, but until then we have
 * to use this.
 *
 * Usage:
 *   gcc -shared -fPIC -DOUT="$out" preload.c -o preload.so -ldl
 *   LD_PRELOAD=$PWD/preload.so ./result/Logic
 *
 * To see the paths that are modified at runtime, set the environment variable
 * PRELOAD_DEBUG to 1 (or anything really; debugging is on as long as the
 * variable exists).
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <dlfcn.h>
#include <limits.h>
#include <sys/stat.h>
#include <sys/types.h>

#ifndef OUT
#error Missing OUT define - path to the installation directory.
#endif

typedef FILE *(*fopen_func_t)(const char *path, const char *mode);
typedef FILE *(*fopen64_func_t)(const char *path, const char *mode);

/*
 * Redirect $out/Settings/settings.xml => $HOME/.saleae-logic-settings.xml. No
 * other paths are changed. Path is truncated if bigger than PATH_MAX.
 *
 * @param pathname Original file path.
 * @param buffer Pointer to a buffer of size PATH_MAX bytes that this function
 * will write the new redirected path to (if needed).
 *
 * @return Pointer to the resulting path. It will either be equal to the
 * pathname or buffer argument.
 */
static const char *redirect(const char *pathname, char *buffer)
{
	const char *homepath;
	const char *new_path;
	static char have_warned;

	homepath = getenv("HOME");
	if (!homepath) {
		homepath = "/";
		if (!have_warned && getenv("PRELOAD_DEBUG")) {
			fprintf(stderr, "preload_debug: WARNING: HOME is unset, using \"/\" (root) instead.\n");
			have_warned = 1;
		}
	}

	new_path = pathname;
	if (strcmp(OUT "/Settings/settings.xml", pathname) == 0) {
		snprintf(buffer, PATH_MAX, "%s/.saleae-logic-settings.xml", homepath);
		buffer[PATH_MAX-1] = '\0';
		new_path = buffer;
	}

	return new_path;
}

FILE *fopen(const char *pathname, const char *mode)
{
	FILE *fp;
	const char *path;
	char buffer[PATH_MAX];
	fopen_func_t orig_fopen;

	orig_fopen = (fopen_func_t)dlsym(RTLD_NEXT, "fopen");
	path = redirect(pathname, buffer);
	fp = orig_fopen(path, mode);

	if (path != pathname && getenv("PRELOAD_DEBUG")) {
		fprintf(stderr, "preload_debug: fopen(\"%s\", \"%s\") => \"%s\": fp=%p\n", pathname, mode, path, fp);
	}

	return fp;
}

FILE *fopen64(const char *pathname, const char *mode)
{
	FILE *fp;
	const char *path;
	char buffer[PATH_MAX];
	fopen64_func_t orig_fopen64;

	orig_fopen64 = (fopen64_func_t)dlsym(RTLD_NEXT, "fopen64");
	path = redirect(pathname, buffer);
	fp = orig_fopen64(path, mode);

	if (path != pathname && getenv("PRELOAD_DEBUG")) {
		fprintf(stderr, "preload_debug: fopen64(\"%s\", \"%s\") => \"%s\": fp=%p\n", pathname, mode, path, fp);
	}

	return fp;
}
