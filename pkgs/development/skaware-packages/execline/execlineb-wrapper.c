/*
 * A wrapper around execlineb, which provides all execline
 * tools on execlineb’s PATH.
 * It is implemented as a C program, because on non-Linux,
 * nested shebang lines are not supported.
 */

#include <stdlib.h>
#include <string.h>

#include <skalibs/stralloc.h>
#include <skalibs/djbunix.h>
#include <skalibs/strerr2.h>
#include <skalibs/env.h>
#include <skalibs/exec.h>

#define dienomem() strerr_diefu1sys(111, "stralloc_catb")

// macros from outside
/* const char* EXECLINEB_PATH; */
/* const char* EXECLINE_BIN_PATH; */

int main(int argc, char const* argv[], char const *const *envp)
{
  PROG = "execlineb-wrapper";

  char const* path = getenv("PATH");
  stralloc path_modif = STRALLOC_ZERO;

  // modify PATH if unset or EXECLINEB_BIN_PATH is not yet there
  if ( !path || ! strstr(path, EXECLINE_BIN_PATH())) {
    // prepend our execline path
    if ( ! stralloc_cats(&path_modif, "PATH=")
         || ! stralloc_cats(&path_modif, EXECLINE_BIN_PATH()) ) dienomem();
    // old path was not empty
    if ( path && path[0] ) {
      if ( ! stralloc_catb(&path_modif, ":", 1)
           || ! stralloc_cats(&path_modif, path) ) dienomem();
    }
    // append final \0
    if ( ! stralloc_0(&path_modif) ) dienomem();
  }

  // exec into execlineb and append path_modif to the environment
  xmexec_aem(
    EXECLINEB_PATH(),
    argv,
    envp,
    path_modif.s, path_modif.len
  );
}
