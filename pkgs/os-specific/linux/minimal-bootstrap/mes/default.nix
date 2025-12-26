{
  lib,
  fetchurl,
  callPackage,
  kaem,
  mescc-tools,
  buildPlatform,
}:

# Maintenance note:
# Build steps have been adapted from build-aux/bootstrap.sh.in
# as well as the live-bootstrap project
# https://github.com/fosslinux/live-bootstrap/blob/737bf61a26152fb82510a2797f0d712de918aa78/sysa/mes-0.25/mes-0.25.kaem

let
  pname = "mes";
  version = "0.27.1";

  src = fetchurl {
    url = "mirror://gnu/mes/mes-${version}.tar.gz";
    hash = "sha256-GDpA6kfqSfih470bnRLmdjdNZNY7x557wa59Zz398l0=";
  };

  nyacc = callPackage ./nyacc.nix { inherit nyacc; };

  intptr =
    {
      i686-linux = "int";
      x86_64-linux = "long";
    }
    .${buildPlatform.system};
  uintptr = "unsigned ${intptr}";

  config_h = builtins.toFile "config.h" ''
    #ifndef _MES_CONFIG_H
    #undef SYSTEM_LIBC
    #define MES_VERSION "${version}"
    #ifndef __M2__
    typedef ${uintptr} uintptr_t;
    typedef ${uintptr} size_t;
    typedef ${intptr} ssize_t;
    typedef ${intptr} intptr_t;
    typedef ${intptr} ptrdiff_t;
    #define __MES_SIZE_T
    #define __MES_SSIZE_T
    #define __MES_INTPTR_T
    #define __MES_UINTPTR_T
    #define __MES_PTRDIFF_T
    #endif
    #endif
  '';

  arch =
    {
      i686-linux = "x86";
      x86_64-linux = "x86_64";
    }
    .${buildPlatform.system};

  sources = (import ./sources.nix).${arch}.linux.mescc;

  inherit (sources)
    libc_mini_SOURCES
    libmescc_SOURCES
    libc_SOURCES
    mes_SOURCES
    ;

  # add symlink() to libc+tcc so we can use it in ln-boot
  libc_tcc_SOURCES = sources.libc_tcc_SOURCES ++ [ "lib/linux/symlink.c" ];
  setjmp_x86_64 = ./setjmp_x86_64.c;

  meta = {
    description = "Scheme interpreter and C compiler for bootstrapping";
    homepage = "https://www.gnu.org/software/mes";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.minimal-bootstrap ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };

  srcPost =
    kaem.runCommand "${pname}-src-${version}"
      {
        outputs = [
          "out"
          "bin"
        ];
        inherit meta;
      }
      ''
        # Unpack source
        ungz --file ${src} --output mes.tar
        mkdir ''${out}
        cd ''${out}
        untar --non-strict --file ''${NIX_BUILD_TOP}/mes.tar # ignore symlinks

        MES_PREFIX=''${out}/mes-${version}

        cd ''${MES_PREFIX}

        cp ${config_h} include/mes/config.h

        # rax is used to indicate the syscall; we need to inform the assembler that rax should not be used to
        # pass the exit code as it would be overwritten
        exit_c=lib/linux/x86_64-mes-gcc/_exit.c
        replace --file ''${exit_c} --output ''${exit_c} --match-on "(code)" --replace-with "(code) : \"rax\", \"rdi\""

        # Replace broken implementation of setjmp & longjmp with asm.
        cp ${setjmp_x86_64} lib/x86_64-mes-gcc/setjmp.c

        # wrong number of arguments for linkat() syscall
        link_c=lib/linux/link.c
        replace --file ''${link_c} --output ''${link_c} --match-on "_sys_call4" --replace-with "_sys_call5"
        replace --file ''${link_c} --output ''${link_c} --match-on "AT_FDCWD, (long) new_name" --replace-with "AT_FDCWD, (long) new_name, 0"

        # wrong syscall number used for nanosleep.
        amd64_syscall_h=include/linux/x86_64/syscall.h
        replace --file ''${amd64_syscall_h} --output ''${amd64_syscall_h} --match-on "SYS_nanosleep 0x33" --replace-with "SYS_nanosleep 0x23"

        # strpbrk should return NULL when there is no match.
        # The order of these `replace` commands is significant.
        strpbrk_c=lib/string/strpbrk.c
        replace --file ''${strpbrk_c} --output ''${strpbrk_c} --match-on "return p;" --replace-with "return 0;"
        replace --file ''${strpbrk_c} --output ''${strpbrk_c} --match-on "break;" --replace-with "return p;"

        # Wrong type used; fix.
        # ntoab.c:  __measbi_uldiv should use unsigned long as per "ul", not size_t
        # ioctl3.c: unsigned long used to align with ioctl.c
        # lib.h:    change ioctl3 signature, per above
        ntoab=lib/mes/ntoab.c
        replace --file ''${ntoab} --output ''${ntoab} --match-on "size_t" --replace-with "unsigned long"
        ioctl=lib/linux/ioctl3.c
        replace --file ''${ioctl} --output ''${ioctl} --match-on "size_t" --replace-with "unsigned long"
        lib_h=include/mes/lib.h
        replace --file ''${lib_h} --output ''${lib_h} --match-on "size_t command" --replace-with "unsigned long command"

        # vfprintf assumes %d arguments can be accessed as `long`. This
        # is true on sign-extending platforms like RV64, but not on i686 or x86_64.
        # Let's use the caller-specified width for better portability. Also account for
        # potential need to zero-extend.
        vfprintf_c=lib/stdio/vfprintf.c
        replace --file ''${vfprintf_c} --output ''${vfprintf_c} --match-on "int count = 0;" --replace-with "int count = 0; int has_l = 0;"
        replace --file ''${vfprintf_c} --output ''${vfprintf_c} --match-on "long d = va_arg (ap, long);" --replace-with "
          long d;
          if (has_l) {
            has_l = 0;
            d = va_arg (ap, long);
          } else if (c != 'd' && c != 'i') {
            d = (long) (va_arg (ap, unsigned int));
          } else {
            d = (long) (va_arg (ap, int));
          }
        "
        replace --file ''${vfprintf_c} --output ''${vfprintf_c} --match-on "if (c == 'l')" --replace-with "
          if (c == 'l') {
            /* this is annoying to patch... */
            has_l = 1;
            c = *++p;
          } else if (0)"
        # Also, get rid of va_arg8
        replace --file ''${vfprintf_c} --output ''${vfprintf_c} --match-on "va_arg8" --replace-with "va_arg"
        # Same thing for vsnprintf.
        vsnprintf_c=lib/stdio/vsnprintf.c
        replace --file ''${vsnprintf_c} --output ''${vsnprintf_c} --match-on "int count = 0;" --replace-with "int count = 0; int has_l = 0;"
        replace --file ''${vsnprintf_c} --output ''${vsnprintf_c} --match-on "long d = va_arg (ap, long);" --replace-with "
          long d;
          if (has_l) {
            has_l = 0;
            d = va_arg (ap, long);
          } else if (c != 'd' && c != 'i') {
            d = (long) (va_arg (ap, unsigned int));
          } else {
            d = (long) (va_arg (ap, int));
          }
        "
        replace --file ''${vsnprintf_c} --output ''${vsnprintf_c} --match-on "if (c == 'l')" --replace-with "
          if (c == 'l') {
            /* this is annoying to patch... */
            has_l = 1;
            c = *++p;
          } else if (0)"
        replace --file ''${vsnprintf_c} --output ''${vsnprintf_c} --match-on "va_arg8" --replace-with "va_arg"

        mkdir include/arch
        cp include/linux/${arch}/kernel-stat.h include/arch/kernel-stat.h
        cp include/linux/${arch}/signal.h include/arch/signal.h
        cp include/linux/${arch}/syscall.h include/arch/syscall.h

        # Remove pregenerated files
        rm mes/module/mes/psyntax.pp mes/module/mes/psyntax.pp.header

        # These files are symlinked in the repo
        cp mes/module/srfi/srfi-9-struct.mes mes/module/srfi/srfi-9.mes
        cp mes/module/srfi/srfi-9/gnu-struct.mes mes/module/srfi/srfi-9/gnu.mes

        # Remove environment impurities
        __GUILE_LOAD_PATH="\"''${MES_PREFIX}/mes/module:''${MES_PREFIX}/module:${nyacc.guilePath}\""
        guile_module_scm=mes/module/mes/guile-module.mes
        guile_mes=mes/module/mes/guile.mes
        replace --file ''${guile_module_scm} --output ''${guile_module_scm} --match-on "(getenv \"GUILE_LOAD_PATH\")" --replace-with ''${__GUILE_LOAD_PATH}
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
        replace --file ''${mescc_in} --output ''${mescc_in} --match-on @mes_cpu@ --replace-with ${arch}
        replace --file ''${mescc_in} --output ''${mescc_in} --match-on @mes_kernel@ --replace-with linux
        mkdir -p ''${bin}/bin
        cp ''${mescc_in} ''${bin}/bin/mescc.scm

        # Build mes-m2
        kaem --verbose --strict --file kaem.${arch}
        cp bin/mes-m2 ''${bin}/bin/mes-m2
        chmod 555 ''${bin}/bin/mes-m2
      '';

  srcPrefix = "${srcPost.out}/mes-${version}";

  cc = "${srcPost.bin}/bin/mes-m2";
  ccArgs = [
    "-e"
    "main"
    "${srcPost.bin}/bin/mescc.scm"
    "-D"
    "HAVE_CONFIG_H=1"
    "-I"
    "${srcPrefix}/include"
    "-I"
    "${srcPrefix}/include/linux/${arch}"
  ];

  CC = toString ([ cc ] ++ ccArgs);

  stripExt = source: lib.replaceStrings [ ".c" ] [ "" ] (baseNameOf source);

  compile =
    source:
    kaem.runCommand (stripExt source) { } ''
      mkdir ''${out}
      cd ''${out}
      ${CC} -c ${srcPrefix}/${source}
    '';

  crt1 = compile "/lib/linux/${arch}-mes-mescc/crt1.c";

  getRes = suffix: res: "${res}/${res.name}${suffix}";

  archive = out: sources: "catm ${out} ${lib.concatMapStringsSep " " (getRes ".o") sources}";
  sourceArchive = out: sources: "catm ${out} ${lib.concatMapStringsSep " " (getRes ".s") sources}";

  mkLib =
    libname: sources:
    let
      os = map compile sources;
    in
    kaem.runCommand "${pname}-${libname}-${version}"
      {
        inherit meta;
      }
      ''
        LIBDIR=''${out}/lib
        mkdir -p ''${LIBDIR}
        cd ''${LIBDIR}

        ${archive "${libname}.a" os}
        ${sourceArchive "${libname}.s" os}
      '';

  libc-mini = mkLib "libc-mini" libc_mini_SOURCES;
  libmescc = mkLib "libmescc" libmescc_SOURCES;
  libc = mkLib "libc" libc_SOURCES;
  libc_tcc = mkLib "libc+tcc" libc_tcc_SOURCES;

  # Recompile Mes and Mes C library using mes-m2 bootstrapped Mes
  libs =
    kaem.runCommand "${pname}-m2-libs-${version}"
      {
        inherit pname version;

        passthru.tests.get-version =
          result:
          kaem.runCommand "${pname}-get-version-${version}" { } ''
            ${result}/bin/mes --version
            mkdir ''${out}
          '';

        inherit meta;
      }
      ''
        LIBDIR=''${out}/lib
        mkdir -p ''${out} ''${LIBDIR}

        mkdir -p ''${LIBDIR}/${arch}-mes

        # crt1.o
        cp ${crt1}/crt1.o ''${LIBDIR}/${arch}-mes
        cp ${crt1}/crt1.s ''${LIBDIR}/${arch}-mes

        # libc-mini.a
        cp ${libc-mini}/lib/libc-mini.a ''${LIBDIR}/${arch}-mes
        cp ${libc-mini}/lib/libc-mini.s ''${LIBDIR}/${arch}-mes

        # libmescc.a
        cp ${libmescc}/lib/libmescc.a ''${LIBDIR}/${arch}-mes
        cp ${libmescc}/lib/libmescc.s ''${LIBDIR}/${arch}-mes

        # libc.a
        cp ${libc}/lib/libc.a ''${LIBDIR}/${arch}-mes
        cp ${libc}/lib/libc.s ''${LIBDIR}/${arch}-mes

        # libc+tcc.a
        cp ${libc_tcc}/lib/libc+tcc.a ''${LIBDIR}/${arch}-mes
        cp ${libc_tcc}/lib/libc+tcc.s ''${LIBDIR}/${arch}-mes
      '';

  # Build mes itself
  compiler =
    kaem.runCommand "${pname}-${version}"
      {
        inherit pname version;

        passthru.tests.get-version =
          result:
          kaem.runCommand "${pname}-get-version-${version}" { } ''
            ${result}/bin/mes --version
            mkdir ''${out}
          '';

        inherit meta;
      }
      ''
        mkdir -p ''${out}/bin

        ${srcPost.bin}/bin/mes-m2 -e main ${srcPost.bin}/bin/mescc.scm -- \
          -L ''${srcPrefix}/lib \
          -L ${libs}/lib \
          -lc \
          -lmescc \
          -nostdlib \
          -o ''${out}/bin/mes \
          ${libs}/lib/${arch}-mes/crt1.o \
          ${lib.concatMapStringsSep " " (getRes ".o") (map compile mes_SOURCES)}
      '';
in
{
  inherit
    src
    srcPost
    srcPrefix
    nyacc
    ;
  inherit compiler libs;
}
