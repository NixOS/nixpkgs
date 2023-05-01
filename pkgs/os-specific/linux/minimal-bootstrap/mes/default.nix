{ lib
, runCommand
, fetchurl
, writeText
, m2libc
, mescc-tools
, nyacc
}:
let
  pname = "mes";
  version = "0.24.2";

  src = fetchurl {
    url = "mirror://gnu/mes/mes-${version}.tar.gz";
    sha256 = "0vp8v88zszh1imm3dvdfi3m8cywshdj7xcrsq4cgmss69s2y1nkx";
  };

  config_h = builtins.toFile "config.h" ''
    #undef SYSTEM_LIBC
    #define MES_VERSION "${version}"
  '';

  # Maintenance note:
  # Build steps have been adapted from build-aux/bootstrap.sh.in
  # as well as the live-bootstrap project
  # https://github.com/fosslinux/live-bootstrap/blob/1bc4296091c51f53a5598050c8956d16e945b0f5/sysa/mes-0.24.2/mes-0.24.2.kaem

  # Maintenance note: list of source files derived from build-aux/configure-lib.sh
  libc_mini_shared_SOURCES = cc: [
    "lib/mes/eputs.c"
    "lib/mes/oputs.c"
    "lib/mes/globals.c"
    "lib/stdlib/exit.c"
    "lib/linux/x86-mes-${cc}/_exit.c"
    "lib/linux/x86-mes-${cc}/_write.c"
    "lib/stdlib/puts.c"
    "lib/string/strlen.c"
  ];
  libc_mini_SOURCES = cc: libc_mini_shared_SOURCES cc ++ [
    "lib/mes/mini-write.c"
  ];
  libmescc_SOURCES = cc: [
    "lib/mes/globals.c"
    "lib/linux/x86-mes-${cc}/syscall-internal.c"
  ];
  libmes_SOURCES = cc: libc_mini_shared_SOURCES cc ++ lib.splitString " " (
    "lib/ctype/isnumber.c lib/mes/abtol.c lib/mes/cast.c lib/mes/eputc.c lib/mes/fdgetc.c "
    + "lib/mes/fdputc.c lib/mes/fdputs.c lib/mes/fdungetc.c lib/mes/itoa.c lib/mes/ltoa.c "
    + "lib/mes/ltoab.c lib/mes/mes_open.c lib/mes/ntoab.c lib/mes/oputc.c lib/mes/ultoa.c "
    + "lib/mes/utoa.c lib/stub/__raise.c lib/ctype/isdigit.c lib/ctype/isspace.c "
    + "lib/ctype/isxdigit.c lib/mes/assert_msg.c lib/posix/write.c lib/stdlib/atoi.c "
    + "lib/linux/lseek.c");
  libc_SOURCES = cc: libmes_SOURCES cc ++ lib.splitString " " (
    "lib/mes/__assert_fail.c lib/mes/__buffered_read.c lib/mes/__mes_debug.c "
    + "lib/posix/execv.c lib/posix/getcwd.c lib/posix/getenv.c lib/posix/isatty.c "
    + "lib/posix/open.c lib/posix/buffered-read.c lib/posix/setenv.c lib/posix/wait.c "
    + "lib/stdio/fgetc.c lib/stdio/fputc.c lib/stdio/fputs.c lib/stdio/getc.c "
    + "lib/stdio/getchar.c lib/stdio/putc.c lib/stdio/putchar.c lib/stdio/ungetc.c "
    + "lib/stdlib/free.c lib/stdlib/realloc.c lib/string/memchr.c lib/string/memcmp.c "
    + "lib/string/memcpy.c lib/string/memmove.c lib/string/memset.c lib/string/strcmp.c "
    + "lib/string/strcpy.c lib/string/strncmp.c lib/posix/raise.c "
    + "lib/linux/access.c lib/linux/brk.c lib/linux/chmod.c lib/linux/clock_gettime.c "
    + "lib/linux/dup.c lib/linux/dup2.c lib/linux/execve.c lib/linux/fork.c lib/linux/fsync.c "
    + "lib/linux/_getcwd.c lib/linux/gettimeofday.c lib/linux/ioctl3.c lib/linux/_open3.c "
    + "lib/linux/malloc.c lib/linux/_read.c lib/linux/time.c lib/linux/unlink.c "
    + "lib/linux/waitpid.c lib/linux/x86-mes-${cc}/syscall.c lib/linux/getpid.c "
    + "lib/linux/kill.c");
  libc_tcc_SOURCES = cc: lib.splitString " " (
      "lib/ctype/islower.c lib/ctype/isupper.c lib/ctype/tolower.c lib/ctype/toupper.c "
      + "lib/mes/abtod.c lib/mes/dtoab.c lib/mes/search-path.c lib/posix/execvp.c "
      + "lib/stdio/fclose.c lib/stdio/fdopen.c lib/stdio/ferror.c lib/stdio/fflush.c "
      + "lib/stdio/fopen.c lib/stdio/fprintf.c lib/stdio/fread.c lib/stdio/fseek.c "
      + "lib/stdio/ftell.c lib/stdio/fwrite.c lib/stdio/printf.c lib/stdio/remove.c "
      + "lib/stdio/snprintf.c lib/stdio/sprintf.c lib/stdio/sscanf.c lib/stdio/vfprintf.c "
      + "lib/stdio/vprintf.c lib/stdio/vsnprintf.c lib/stdio/vsprintf.c lib/stdio/vsscanf.c "
      + "lib/stdlib/calloc.c lib/stdlib/qsort.c lib/stdlib/strtod.c lib/stdlib/strtof.c "
      + "lib/stdlib/strtol.c lib/stdlib/strtold.c lib/stdlib/strtoll.c lib/stdlib/strtoul.c "
      + "lib/stdlib/strtoull.c lib/string/memmem.c lib/string/strcat.c lib/string/strchr.c "
      + "lib/string/strlwr.c lib/string/strncpy.c lib/string/strrchr.c lib/string/strstr.c "
      + "lib/string/strupr.c lib/stub/sigaction.c lib/stub/ldexp.c lib/stub/mprotect.c "
      + "lib/stub/localtime.c lib/stub/sigemptyset.c lib/x86-mes-${cc}/setjmp.c "
      + "lib/linux/close.c lib/linux/rmdir.c lib/linux/stat.c"
    ) ++ [
      # add symlink() to libc+tcc so we can use it in ln-boot
      "lib/linux/symlink.c"
    ];
  libc_gnu_SOURCES = cc: libc_tcc_SOURCES cc ++ lib.splitString " " (
    "lib/ctype/isalnum.c lib/ctype/isalpha.c lib/ctype/isascii.c lib/ctype/iscntrl.c "
    + "lib/ctype/isgraph.c lib/ctype/isprint.c lib/ctype/ispunct.c lib/dirent/__getdirentries.c "
    + "lib/dirent/closedir.c lib/dirent/opendir.c lib/dirent/readdir.c lib/math/ceil.c "
    + "lib/math/fabs.c lib/math/floor.c lib/mes/fdgets.c lib/posix/alarm.c lib/posix/execl.c "
    + "lib/posix/execlp.c lib/posix/mktemp.c lib/posix/sbrk.c lib/posix/sleep.c "
    + "lib/posix/unsetenv.c lib/stdio/clearerr.c lib/stdio/feof.c lib/stdio/fgets.c "
    + "lib/stdio/fileno.c lib/stdio/freopen.c lib/stdio/fscanf.c lib/stdio/perror.c "
    + "lib/stdio/vfscanf.c lib/stdlib/__exit.c lib/stdlib/abort.c lib/stdlib/abs.c "
    + "lib/stdlib/alloca.c lib/stdlib/atexit.c lib/stdlib/atof.c lib/stdlib/atol.c "
    + "lib/stdlib/mbstowcs.c lib/string/bcmp.c lib/string/bcopy.c lib/string/bzero.c "
    + "lib/string/index.c lib/string/rindex.c lib/string/strcspn.c lib/string/strdup.c "
    + "lib/string/strerror.c lib/string/strncat.c lib/string/strpbrk.c lib/string/strspn.c "
    + "lib/stub/__cleanup.c lib/stub/atan2.c lib/stub/bsearch.c lib/stub/chown.c "
    + "lib/stub/cos.c lib/stub/ctime.c lib/stub/exp.c lib/stub/fpurge.c lib/stub/freadahead.c "
    + "lib/stub/frexp.c lib/stub/getgrgid.c lib/stub/getgrnam.c lib/stub/getlogin.c "
    + "lib/stub/getpgid.c lib/stub/getpgrp.c lib/stub/getpwnam.c lib/stub/getpwuid.c "
    + "lib/stub/gmtime.c lib/stub/log.c lib/stub/mktime.c lib/stub/modf.c lib/stub/pclose.c "
    + "lib/stub/popen.c lib/stub/pow.c lib/stub/rand.c lib/stub/rewind.c lib/stub/setbuf.c "
    + "lib/stub/setgrent.c lib/stub/setlocale.c lib/stub/setvbuf.c lib/stub/sigaddset.c "
    + "lib/stub/sigblock.c lib/stub/sigdelset.c lib/stub/sigsetmask.c lib/stub/sin.c "
    + "lib/stub/sqrt.c lib/stub/strftime.c lib/stub/sys_siglist.c lib/stub/system.c "
    + "lib/stub/times.c lib/stub/ttyname.c lib/stub/umask.c lib/stub/utime.c "
    + "lib/linux/chdir.c lib/linux/fcntl.c lib/linux/fstat.c lib/linux/getdents.c "
    + "lib/linux/getegid.c lib/linux/geteuid.c lib/linux/getgid.c lib/linux/getppid.c "
    + "lib/linux/getrusage.c lib/linux/getuid.c lib/linux/ioctl.c lib/linux/link.c "
    + "lib/linux/lstat.c lib/linux/mkdir.c lib/linux/mknod.c lib/linux/nanosleep.c "
    + "lib/linux/pipe.c lib/linux/readlink.c lib/linux/rename.c lib/linux/setgid.c "
    + "lib/linux/settimer.c lib/linux/setuid.c lib/linux/signal.c lib/linux/sigprogmask.c "
    + "lib/linux/symlink.c");
  mes_SOURCES = cc: lib.splitString " " (
    "src/builtins.c src/cc.c src/core.c src/display.c src/eval-apply.c src/gc.c "
    + "src/globals.c src/hash.c src/lib.c src/math.c src/mes.c src/module.c src/posix.c "
    + "src/reader.c src/stack.c src/string.c src/struct.c src/symbol.c src/vector.c");

  compile = sources: lib.concatMapStringsSep "\n" (f: ''CC -c ''${MES_PREFIX}/${f}'') sources;
  replaceExt = ext: source: lib.replaceStrings [".c"] [ext] (builtins.baseNameOf source);
  archive = out: sources: "catm ${out} ${lib.concatMapStringsSep " " (replaceExt ".o") sources}";
  sourceArchive = out: sources: "catm ${out} ${lib.concatMapStringsSep " " (replaceExt ".s") sources}";
in
runCommand "${pname}-${version}" {
  inherit pname version;

  passthru = {
    mesPrefix = "/share/mes-${version}";
    libcSources = libc_SOURCES "gcc" ++ libc_gnu_SOURCES "gcc";
  };

  meta = with lib; {
    description = "Scheme interpreter and C compiler for bootstrapping";
    homepage = "https://www.gnu.org/software/mes";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ emilytrau ];
    platforms = [ "i686-linux" ];
  };
} ''
  # Unpack source
  ungz --file ${src} --output mes.tar
  mkdir ''${out} ''${out}/bin ''${out}/share
  cd ''${out}/share
  untar --non-strict --file ''${NIX_BUILD_TOP}/mes.tar # ignore symlinks

  MES_PREFIX=''${out}/share/mes-${version}
  LIBDIR=''${MES_PREFIX}/lib

  cd ''${MES_PREFIX}

  cp ${config_h} include/mes/config.h

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
  __GUILE_LOAD_PATH="\"''${MES_PREFIX}/mes/module:''${MES_PREFIX}/module:${nyacc.guilePath}\""
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

  # Increase runtime resource limits
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
  replace --file ''${mescc_in} --output ''${mescc_in} --match-on @mes_cpu@ --replace-with x86
  replace --file ''${mescc_in} --output ''${mescc_in} --match-on @mes_kernel@ --replace-with linux
  cp ''${mescc_in} ''${out}/bin/mescc.scm

  # Build mes-m2
  mes_cpu=x86
  stage0_cpu=x86
  kaem --verbose --strict --file kaem.run
  cp bin/mes-m2 ''${out}/bin/mes-m2
  chmod 555 ''${out}/bin/mes-m2


  # Recompile Mes and Mes C library using mes-m2 bootstrapped Mes
  cd ''${NIX_BUILD_TOP}
  alias CC="''${out}/bin/mes-m2 -e main ''${out}/bin/mescc.scm -- -D HAVE_CONFIG_H=1 -I ''${MES_PREFIX}/include -I ''${MES_PREFIX}/include/linux/x86"
  mkdir -p ''${LIBDIR}/x86-mes

  # crt1.o
  CC -c ''${MES_PREFIX}/lib/linux/x86-mes-mescc/crt1.c
  cp crt1.o ''${LIBDIR}/x86-mes
  cp crt1.s ''${LIBDIR}/x86-mes

  # libc-mini.a
  ${compile (libc_mini_SOURCES "mescc")}
  ${archive "libc-mini.a" (libc_mini_SOURCES "mescc")}
  ${sourceArchive "libc-mini.s" (libc_mini_SOURCES "mescc")}
  cp libc-mini.a ''${LIBDIR}/x86-mes
  cp libc-mini.s ''${LIBDIR}/x86-mes

  # libmescc.a
  ${compile (libmescc_SOURCES "mescc")}
  ${archive "libmescc.a" (libmescc_SOURCES "mescc")}
  ${sourceArchive "libmescc.s" (libmescc_SOURCES "mescc")}
  cp libmescc.a ''${LIBDIR}/x86-mes
  cp libmescc.s ''${LIBDIR}/x86-mes

  # libc.a
  ${compile (libc_SOURCES "mescc")}
  ${archive "libc.a" (libc_SOURCES "mescc")}
  ${sourceArchive "libc.s" (libc_SOURCES "mescc")}
  cp libc.a ''${LIBDIR}/x86-mes
  cp libc.s ''${LIBDIR}/x86-mes

  # libc+tcc.a
  ${compile (libc_tcc_SOURCES "mescc")}
  ${archive "libc+tcc.a" ([ "libc.a" ] ++ libc_tcc_SOURCES "mescc")}
  ${sourceArchive "libc+tcc.s" ([ "libc.s" ] ++ libc_tcc_SOURCES "mescc")}
  cp libc+tcc.a ''${LIBDIR}/x86-mes
  cp libc+tcc.s ''${LIBDIR}/x86-mes

  # Build mes itself
  ${compile (mes_SOURCES "mescc")}
  ''${out}/bin/mes-m2 -e main ''${out}/bin/mescc.scm -- \
    --base-address 0x08048000 \
    -L ''${MES_PREFIX}/lib \
    -L . \
    -lc \
    -lmescc \
    -nostdlib \
    -o ''${out}/bin/mes \
    crt1.o \
    ${lib.concatMapStringsSep " " (replaceExt ".o") (mes_SOURCES "mescc")}

  # Check
  ''${out}/bin/mes --version
''
