{ runCommand
, fetchurl
, writeText
, m2libc
, mescc-tools
}:
let
  version = "0.24.2";
  ARCH = "x86";

  src = fetchurl {
    url = "mirror://gnu/mes/mes-${version}.tar.gz";
    sha256 = "0vp8v88zszh1imm3dvdfi3m8cywshdj7xcrsq4cgmss69s2y1nkx";
  };

  nyaccVersion = "1.00.2";
  nyaccModules = builtins.fetchTarball {
    url = "http://download.savannah.nongnu.org/releases/nyacc/nyacc-${nyaccVersion}.tar.gz";
    sha256 = "06rg6pn4k8smyydwls1abc9h702cri3z65ac9gvc4rxxklpynslk";
  };
in
# Adapted from https://github.com/fosslinux/live-bootstrap/blob/1bc4296091c51f53a5598050c8956d16e945b0f5/sysa/mes-0.24.2/mes-0.24.2.kaem
(runCommand "mes-${version}" {} ''
  # Unpack source
  ungz --file ${src} --output mes.tar
  mkdir ''${out} ''${out}/bin ''${out}/share
  cd ''${out}/share
  untar --non-strict --file ''${NIX_BUILD_TOP}/mes.tar # ignore symlinks

  MES_PREFIX=''${out}/share/mes-${version}
  LIBDIR=''${MES_PREFIX}/lib

  cd ''${MES_PREFIX}

  cp ${./config.h} include/mes/config.h
  replace --file include/mes/config.h --output include/mes/config.h --match-on @VERSION@ --replace-with ${version}

  mkdir include/arch
  cp include/linux/x86/syscall.h include/arch/syscall.h
  cp include/linux/x86/kernel-stat.h include/arch/kernel-stat.h

  # Remove pregenerated files
  rm mes/module/mes/psyntax.pp mes/module/mes/psyntax.pp.header

  # These files are symlinked in the repo
  cp mes/module/srfi/srfi-9-struct.mes mes/module/srfi/srfi-9.mes
  cp mes/module/srfi/srfi-9/gnu-struct.mes mes/module/srfi/srfi-9/gnu.mes

  # Fixes to support newer M2-Planet
  catm x86_defs.M1 ${m2libc}/x86/x86_defs.M1 lib/m2/x86/x86_defs.M1
  cp x86_defs.M1 lib/m2/x86/x86_defs.M1
  rm x86_defs.M1

  # Remove environment impurities
  __GUILE_LOAD_PATH="\"''${MES_PREFIX}/mes/module:''${MES_PREFIX}/module:${nyaccModules}/module\""
  boot0_scm=mes/module/mes/boot-0.scm
  guile_mes=mes/module/mes/guile.mes
  replace --file ''${boot0_scm} --output ''${boot0_scm} --match-on "(getenv \"GUILE_LOAD_PATH\")" --replace-with ''${__GUILE_LOAD_PATH}
  replace --file ''${guile_mes} --output ''${guile_mes} --match-on "(getenv \"GUILE_LOAD_PATH\")" --replace-with ''${__GUILE_LOAD_PATH}

  module_mescc_scm=module/mescc/mescc.scm
  replace --file ''${module_mescc_scm} --output ''${module_mescc_scm} --match-on "(getenv \"M1\")" --replace-with "\"${mescc-tools}/bin/M1\""
  replace --file ''${module_mescc_scm} --output ''${module_mescc_scm} --match-on "(getenv \"HEX2\")" --replace-with "\"${mescc-tools}/bin/hex2\""
  replace --file ''${module_mescc_scm} --output ''${module_mescc_scm} --match-on "(getenv \"BLOOD_ELF\")" --replace-with "\"${mescc-tools}/bin/blood-elf\""
  replace --file ''${module_mescc_scm} --output ''${module_mescc_scm} --match-on "(getenv \"srcdest\")" --replace-with "\"''${MES_PREFIX}\""

  mes_c=src/mes.c
  replace --file ''${mes_c} --output ''${mes_c} --match-on "getenv (\"MES_PREFIX\")" --replace-with "\"''${MES_PREFIX}\""
  replace --file ''${mes_c} --output ''${mes_c} --match-on "getenv (\"srcdest\")" --replace-with "\"''${MES_PREFIX}\""

  gc_c=src/gc.c
  replace --file ''${gc_c} --output ''${gc_c} --match-on "getenv (\"MES_ARENA\")" --replace-with "\"100000000\""
  replace --file ''${gc_c} --output ''${gc_c} --match-on "getenv (\"MES_MAX_ARENA\")" --replace-with "\"100000000\""
  replace --file ''${gc_c} --output ''${gc_c} --match-on "getenv (\"MES_STACK\")" --replace-with "\"6000000\""

  # Create mescc.scm
  mescc_in=scripts/mescc.scm.in
  replace --file ''${mescc_in} --output ''${mescc_in} --match-on "(getenv \"MES_PREFIX\")" --replace-with "\"''${MES_PREFIX}\""
  replace --file ''${mescc_in} --output ''${mescc_in} --match-on "(getenv \"includedir\")" --replace-with "\"''${MES_PREFIX}/include\""
  replace --file ''${mescc_in} --output ''${mescc_in} --match-on "(getenv \"libdir\")" --replace-with "\"''${MES_PREFIX}/lib\""
  replace --file ''${mescc_in} --output ''${mescc_in} --match-on @prefix@ --replace-with ''${MES_PREFIX}
  replace --file ''${mescc_in} --output ''${mescc_in} --match-on @VERSION@ --replace-with ${version}
  replace --file ''${mescc_in} --output ''${mescc_in} --match-on @mes_cpu@ --replace-with ${ARCH}
  replace --file ''${mescc_in} --output ''${mescc_in} --match-on @mes_kernel@ --replace-with linux
  cp ''${mescc_in} ''${out}/bin/mescc.scm
  chmod 555 ''${out}/bin/mescc.scm

  # Build mes-m2
  mes_cpu=${ARCH}
  stage0_cpu=${ARCH}
  kaem --verbose --strict --file kaem.run
  cp bin/mes-m2 ''${out}/bin/mes-m2
  chmod 555 ''${out}/bin/mes-m2


  # Recompile Mes and Mes C library using mes-m2 bootstrapped Mes
  cd ''${NIX_BUILD_TOP}
  alias mescc="''${out}/bin/mes-m2 -e main ''${out}/bin/mescc.scm -D HAVE_CONFIG_H=1 -I ''${MES_PREFIX}/include -I ''${MES_PREFIX}/include/linux/x86 -c"

  # Start with crt1.o
  mescc ''${MES_PREFIX}/lib/linux/x86-mes-mescc/crt1.c

  # Now for libc-mini.a
  mescc ''${MES_PREFIX}/lib/mes/eputs.c
  mescc ''${MES_PREFIX}/lib/mes/oputs.c
  mescc ''${MES_PREFIX}/lib/mes/globals.c
  mescc ''${MES_PREFIX}/lib/stdlib/exit.c
  mescc ''${MES_PREFIX}/lib/linux/x86-mes-mescc/_exit.c
  mescc ''${MES_PREFIX}/lib/linux/x86-mes-mescc/_write.c
  mescc ''${MES_PREFIX}/lib/stdlib/puts.c
  mescc ''${MES_PREFIX}/lib/string/strlen.c
  mescc ''${MES_PREFIX}/lib/mes/mini-write.c
  catm libc-mini.a eputs.o oputs.o globals.o exit.o _exit.o _write.o puts.o strlen.o mini-write.o
  catm libc-mini.s eputs.s oputs.s globals.s exit.s _exit.s _write.s puts.s strlen.s mini-write.s

  # libmescc.a
  mescc ''${MES_PREFIX}/lib/linux/x86-mes-mescc/syscall-internal.c
  catm libmescc.a globals.o syscall-internal.o
  catm libmescc.s globals.s syscall-internal.s

  # libc.a
  mescc ''${MES_PREFIX}/lib/ctype/isnumber.c
  mescc ''${MES_PREFIX}/lib/mes/abtol.c
  mescc ''${MES_PREFIX}/lib/mes/cast.c
  mescc ''${MES_PREFIX}/lib/mes/eputc.c
  mescc ''${MES_PREFIX}/lib/mes/fdgetc.c
  mescc ''${MES_PREFIX}/lib/mes/fdputc.c
  mescc ''${MES_PREFIX}/lib/mes/fdputs.c
  mescc ''${MES_PREFIX}/lib/mes/fdungetc.c
  mescc ''${MES_PREFIX}/lib/mes/itoa.c
  mescc ''${MES_PREFIX}/lib/mes/ltoa.c
  mescc ''${MES_PREFIX}/lib/mes/ltoab.c
  mescc ''${MES_PREFIX}/lib/mes/mes_open.c
  mescc ''${MES_PREFIX}/lib/mes/ntoab.c
  mescc ''${MES_PREFIX}/lib/mes/oputc.c
  mescc ''${MES_PREFIX}/lib/mes/ultoa.c
  mescc ''${MES_PREFIX}/lib/mes/utoa.c
  mescc ''${MES_PREFIX}/lib/ctype/isdigit.c
  mescc ''${MES_PREFIX}/lib/ctype/isspace.c
  mescc ''${MES_PREFIX}/lib/ctype/isxdigit.c
  mescc ''${MES_PREFIX}/lib/mes/assert_msg.c
  mescc ''${MES_PREFIX}/lib/posix/write.c
  mescc ''${MES_PREFIX}/lib/stdlib/atoi.c
  mescc ''${MES_PREFIX}/lib/linux/lseek.c
  mescc ''${MES_PREFIX}/lib/mes/__assert_fail.c
  mescc ''${MES_PREFIX}/lib/mes/__buffered_read.c
  mescc ''${MES_PREFIX}/lib/mes/__mes_debug.c
  mescc ''${MES_PREFIX}/lib/posix/execv.c
  mescc ''${MES_PREFIX}/lib/posix/getcwd.c
  mescc ''${MES_PREFIX}/lib/posix/getenv.c
  mescc ''${MES_PREFIX}/lib/posix/isatty.c
  mescc ''${MES_PREFIX}/lib/posix/open.c
  mescc ''${MES_PREFIX}/lib/posix/buffered-read.c
  mescc ''${MES_PREFIX}/lib/posix/setenv.c
  mescc ''${MES_PREFIX}/lib/posix/wait.c
  mescc ''${MES_PREFIX}/lib/stdio/fgetc.c
  mescc ''${MES_PREFIX}/lib/stdio/fputc.c
  mescc ''${MES_PREFIX}/lib/stdio/fputs.c
  mescc ''${MES_PREFIX}/lib/stdio/getc.c
  mescc ''${MES_PREFIX}/lib/stdio/getchar.c
  mescc ''${MES_PREFIX}/lib/stdio/putc.c
  mescc ''${MES_PREFIX}/lib/stdio/putchar.c
  mescc ''${MES_PREFIX}/lib/stdio/ungetc.c
  mescc ''${MES_PREFIX}/lib/stdlib/free.c
  mescc ''${MES_PREFIX}/lib/stdlib/realloc.c
  mescc ''${MES_PREFIX}/lib/string/memchr.c
  mescc ''${MES_PREFIX}/lib/string/memcmp.c
  mescc ''${MES_PREFIX}/lib/string/memcpy.c
  mescc ''${MES_PREFIX}/lib/string/memmove.c
  mescc ''${MES_PREFIX}/lib/string/memset.c
  mescc ''${MES_PREFIX}/lib/string/strcmp.c
  mescc ''${MES_PREFIX}/lib/string/strcpy.c
  mescc ''${MES_PREFIX}/lib/string/strncmp.c
  mescc ''${MES_PREFIX}/lib/posix/raise.c
  mescc ''${MES_PREFIX}/lib/linux/access.c
  mescc ''${MES_PREFIX}/lib/linux/brk.c
  mescc ''${MES_PREFIX}/lib/linux/chmod.c
  mescc ''${MES_PREFIX}/lib/linux/clock_gettime.c
  mescc ''${MES_PREFIX}/lib/linux/dup.c
  mescc ''${MES_PREFIX}/lib/linux/dup2.c
  mescc ''${MES_PREFIX}/lib/linux/execve.c
  mescc ''${MES_PREFIX}/lib/linux/fork.c
  mescc ''${MES_PREFIX}/lib/linux/fsync.c
  mescc ''${MES_PREFIX}/lib/linux/_getcwd.c
  mescc ''${MES_PREFIX}/lib/linux/gettimeofday.c
  mescc ''${MES_PREFIX}/lib/linux/ioctl3.c
  mescc ''${MES_PREFIX}/lib/linux/malloc.c
  mescc ''${MES_PREFIX}/lib/linux/_open3.c
  mescc ''${MES_PREFIX}/lib/linux/_read.c
  mescc ''${MES_PREFIX}/lib/linux/time.c
  mescc ''${MES_PREFIX}/lib/linux/unlink.c
  mescc ''${MES_PREFIX}/lib/linux/waitpid.c
  mescc ''${MES_PREFIX}/lib/linux/x86-mes-mescc/syscall.c
  mescc ''${MES_PREFIX}/lib/linux/getpid.c
  mescc ''${MES_PREFIX}/lib/linux/kill.c
  catm libc.a eputs.o oputs.o globals.o exit.o _exit.o _write.o puts.o strlen.o isnumber.o abtol.o cast.o eputc.o fdgetc.o fdputc.o fdputs.o fdungetc.o itoa.o ltoa.o ltoab.o mes_open.o ntoab.o oputc.o ultoa.o utoa.o isdigit.o isspace.o isxdigit.o assert_msg.o write.o atoi.o lseek.o __assert_fail.o __buffered_read.o __mes_debug.o execv.o getcwd.o getenv.o isatty.o open.o buffered-read.o setenv.o wait.o fgetc.o fputc.o fputs.o getc.o getchar.o putc.o putchar.o ungetc.o free.o malloc.o realloc.o memchr.o memcmp.o memcpy.o memmove.o memset.o strcmp.o strcpy.o strncmp.o raise.o access.o brk.o chmod.o clock_gettime.o dup.o dup2.o execve.o fork.o fsync.o _getcwd.o gettimeofday.o ioctl3.o _open3.o _read.o time.o unlink.o waitpid.o syscall.o getpid.o kill.o
  catm libc.s eputs.s oputs.s globals.s exit.s _exit.s _write.s puts.s strlen.s isnumber.s abtol.s cast.s eputc.s fdgetc.s fdputc.s fdputs.s fdungetc.s itoa.s ltoa.s ltoab.s mes_open.s ntoab.s oputc.s ultoa.s utoa.s isdigit.s isspace.s isxdigit.s assert_msg.s write.s atoi.s lseek.s __assert_fail.s __buffered_read.s __mes_debug.s execv.s getcwd.s getenv.s isatty.s open.s buffered-read.s setenv.s wait.s fgetc.s fputc.s fputs.s getc.s getchar.s putc.s putchar.s ungetc.s free.s malloc.s realloc.s memchr.s memcmp.s memcpy.s memmove.s memset.s strcmp.s strcpy.s strncmp.s raise.s access.s brk.s chmod.s clock_gettime.s dup.s dup2.s execve.s fork.s fsync.s _getcwd.s gettimeofday.s ioctl3.s _open3.s _read.s time.s unlink.s waitpid.s syscall.s getpid.s kill.s

  # libc+tcc.a
  mescc ''${MES_PREFIX}/lib/ctype/islower.c
  mescc ''${MES_PREFIX}/lib/ctype/isupper.c
  mescc ''${MES_PREFIX}/lib/ctype/tolower.c
  mescc ''${MES_PREFIX}/lib/ctype/toupper.c
  mescc ''${MES_PREFIX}/lib/mes/abtod.c
  mescc ''${MES_PREFIX}/lib/mes/dtoab.c
  mescc ''${MES_PREFIX}/lib/mes/search-path.c
  mescc ''${MES_PREFIX}/lib/posix/execvp.c
  mescc ''${MES_PREFIX}/lib/stdio/fclose.c
  mescc ''${MES_PREFIX}/lib/stdio/fdopen.c
  mescc ''${MES_PREFIX}/lib/stdio/ferror.c
  mescc ''${MES_PREFIX}/lib/stdio/fflush.c
  mescc ''${MES_PREFIX}/lib/stdio/fopen.c
  mescc ''${MES_PREFIX}/lib/stdio/fprintf.c
  mescc ''${MES_PREFIX}/lib/stdio/fread.c
  mescc ''${MES_PREFIX}/lib/stdio/fseek.c
  mescc ''${MES_PREFIX}/lib/stdio/ftell.c
  mescc ''${MES_PREFIX}/lib/stdio/fwrite.c
  mescc ''${MES_PREFIX}/lib/stdio/printf.c
  mescc ''${MES_PREFIX}/lib/stdio/remove.c
  mescc ''${MES_PREFIX}/lib/stdio/snprintf.c
  mescc ''${MES_PREFIX}/lib/stdio/sprintf.c
  mescc ''${MES_PREFIX}/lib/stdio/sscanf.c
  mescc ''${MES_PREFIX}/lib/stdio/vfprintf.c
  mescc ''${MES_PREFIX}/lib/stdio/vprintf.c
  mescc ''${MES_PREFIX}/lib/stdio/vsnprintf.c
  mescc ''${MES_PREFIX}/lib/stdio/vsprintf.c
  mescc ''${MES_PREFIX}/lib/stdio/vsscanf.c
  mescc ''${MES_PREFIX}/lib/stdlib/calloc.c
  mescc ''${MES_PREFIX}/lib/stdlib/qsort.c
  mescc ''${MES_PREFIX}/lib/stdlib/strtod.c
  mescc ''${MES_PREFIX}/lib/stdlib/strtof.c
  mescc ''${MES_PREFIX}/lib/stdlib/strtol.c
  mescc ''${MES_PREFIX}/lib/stdlib/strtold.c
  mescc ''${MES_PREFIX}/lib/stdlib/strtoll.c
  mescc ''${MES_PREFIX}/lib/stdlib/strtoul.c
  mescc ''${MES_PREFIX}/lib/stdlib/strtoull.c
  mescc ''${MES_PREFIX}/lib/string/memmem.c
  mescc ''${MES_PREFIX}/lib/string/strcat.c
  mescc ''${MES_PREFIX}/lib/string/strchr.c
  mescc ''${MES_PREFIX}/lib/string/strlwr.c
  mescc ''${MES_PREFIX}/lib/string/strncpy.c
  mescc ''${MES_PREFIX}/lib/string/strrchr.c
  mescc ''${MES_PREFIX}/lib/string/strstr.c
  mescc ''${MES_PREFIX}/lib/string/strupr.c
  mescc ''${MES_PREFIX}/lib/stub/sigaction.c
  mescc ''${MES_PREFIX}/lib/stub/ldexp.c
  mescc ''${MES_PREFIX}/lib/stub/mprotect.c
  mescc ''${MES_PREFIX}/lib/stub/localtime.c
  mescc ''${MES_PREFIX}/lib/stub/sigemptyset.c
  mescc ''${MES_PREFIX}/lib/x86-mes-mescc/setjmp.c
  mescc ''${MES_PREFIX}/lib/linux/close.c
  mescc ''${MES_PREFIX}/lib/linux/rmdir.c
  mescc ''${MES_PREFIX}/lib/linux/stat.c
  catm libc+tcc.a libc.a islower.o isupper.o tolower.o toupper.o abtod.o dtoab.o search-path.o execvp.o fclose.o fdopen.o ferror.o fflush.o fopen.o fprintf.o fread.o fseek.o ftell.o fwrite.o printf.o remove.o snprintf.o sprintf.o sscanf.o vfprintf.o vprintf.o vsnprintf.o vsprintf.o vsscanf.o calloc.o qsort.o strtod.o strtof.o strtol.o strtold.o strtoll.o strtoul.o strtoull.o memmem.o strcat.o strchr.o strlwr.o strncpy.o strrchr.o strstr.o strupr.o sigaction.o ldexp.o mprotect.o localtime.o sigemptyset.o setjmp.o close.o rmdir.o stat.o
  catm libc+tcc.s libc.s islower.s isupper.s tolower.s toupper.s abtod.s dtoab.s search-path.s execvp.s fclose.s fdopen.s ferror.s fflush.s fopen.s fprintf.s fread.s fseek.s ftell.s fwrite.s printf.s remove.s snprintf.s sprintf.s sscanf.s vfprintf.s vprintf.s vsnprintf.s vsprintf.s vsscanf.s calloc.s qsort.s strtod.s strtof.s strtol.s strtold.s strtoll.s strtoul.s strtoull.s memmem.s strcat.s strchr.s strlwr.s strncpy.s strrchr.s strstr.s strupr.s sigaction.s ldexp.s mprotect.s localtime.s sigemptyset.s setjmp.s close.s rmdir.s stat.s

  # Build mes itself
  mescc ''${MES_PREFIX}/src/builtins.c
  mescc ''${MES_PREFIX}/src/cc.c
  mescc ''${MES_PREFIX}/src/core.c
  mescc ''${MES_PREFIX}/src/display.c
  mescc ''${MES_PREFIX}/src/eval-apply.c
  mescc ''${MES_PREFIX}/src/gc.c
  mescc ''${MES_PREFIX}/src/globals.c
  mescc ''${MES_PREFIX}/src/hash.c
  mescc ''${MES_PREFIX}/src/lib.c
  mescc ''${MES_PREFIX}/src/math.c
  mescc ''${MES_PREFIX}/src/mes.c
  mescc ''${MES_PREFIX}/src/module.c
  mescc ''${MES_PREFIX}/src/posix.c
  mescc ''${MES_PREFIX}/src/reader.c
  mescc ''${MES_PREFIX}/src/stack.c
  mescc ''${MES_PREFIX}/src/string.c
  mescc ''${MES_PREFIX}/src/struct.c
  mescc ''${MES_PREFIX}/src/symbol.c
  mescc ''${MES_PREFIX}/src/vector.c

  # Install libraries
  cp libc.a ''${MES_PREFIX}/lib/x86-mes/
  cp libc+tcc.a ''${MES_PREFIX}/lib/x86-mes/
  cp libmescc.a ''${MES_PREFIX}/lib/x86-mes/
  cp libc.s ''${MES_PREFIX}/lib/x86-mes/
  cp libc+tcc.s ''${MES_PREFIX}/lib/x86-mes/
  cp libmescc.s ''${MES_PREFIX}/lib/x86-mes/
  cp crt1.o ''${MES_PREFIX}/lib/x86-mes/
  cp crt1.s ''${MES_PREFIX}/lib/x86-mes/

  # Link everything into new mes executable
  ''${out}/bin/mes-m2 -e main ''${out}/bin/mescc.scm -- --base-address 0x08048000 -L ''${MES_PREFIX}/lib -nostdlib -o ''${out}/bin/mes -L . crt1.o builtins.o cc.o core.o display.o eval-apply.o gc.o globals.o hash.o lib.o math.o mes.o module.o posix.o reader.o stack.o string.o struct.o symbol.o vector.o -lc -lmescc
'') // {
  mesPrefix = "/share/mes-${version}";
}
