{ lib
, fetchurl
, callPackage
, kaem
, mescc-tools
}:

# Maintenance note:
# Build steps have been adapted from build-aux/bootstrap.sh.in
# as well as the live-bootstrap project
# https://github.com/fosslinux/live-bootstrap/blob/737bf61a26152fb82510a2797f0d712de918aa78/sysa/mes-0.25/mes-0.25.kaem

let
  pname = "mes";
  version = "0.25";

  src = fetchurl {
    url = "mirror://gnu/mes/mes-${version}.tar.gz";
    hash = "sha256-MlJQs1Z+2SA7pwFhyDWvAQeec+vtl7S1u3fKUAuCiUA=";
  };

  nyacc = callPackage ./nyacc.nix { inherit nyacc; };

  config_h = builtins.toFile "config.h" ''
    #undef SYSTEM_LIBC
    #define MES_VERSION "${version}"
  '';

  sources = (import ./sources.nix).x86.linux.mescc;
  inherit (sources) libc_mini_SOURCES libmescc_SOURCES libc_SOURCES mes_SOURCES;

  # add symlink() to libc+tcc so we can use it in ln-boot
  libc_tcc_SOURCES = sources.libc_tcc_SOURCES ++ [ "lib/linux/symlink.c" ];

  meta = with lib; {
    description = "Scheme interpreter and C compiler for bootstrapping";
    homepage = "https://www.gnu.org/software/mes";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    platforms = [ "i686-linux" ];
  };

  srcPost = kaem.runCommand "${pname}-src-${version}" {
    outputs = [ "out" "bin" ];
    inherit meta;
  } ''
    # Unpack source
    ungz --file ${src} --output mes.tar
    mkdir ''${out}
    cd ''${out}
    untar --non-strict --file ''${NIX_BUILD_TOP}/mes.tar # ignore symlinks

    MES_PREFIX=''${out}/mes-${version}

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
    mkdir -p ''${bin}/bin
    cp ''${mescc_in} ''${bin}/bin/mescc.scm

    # Build mes-m2
    kaem --verbose --strict --file kaem.x86
    cp bin/mes-m2 ''${bin}/bin/mes-m2
    chmod 555 ''${bin}/bin/mes-m2
  '';

  srcPrefix = "${srcPost.out}/mes-${version}";

  cc = "${srcPost.bin}/bin/mes-m2";
  ccArgs = [
    "-e" "main"
    "${srcPost.bin}/bin/mescc.scm"
    "--"
    "-D" "HAVE_CONFIG_H=1"
    "-I" "${srcPrefix}/include"
    "-I" "${srcPrefix}/include/linux/x86"
  ];

  CC = toString ([ cc ] ++ ccArgs);

  stripExt = source:
    lib.replaceStrings
      [ ".c" ]
      [ "" ]
      (builtins.baseNameOf source);

  compile = source: kaem.runCommand (stripExt source) {} ''
    mkdir ''${out}
    cd ''${out}
    ${CC} -c ${srcPrefix}/${source}
  '';

  crt1 = compile "/lib/linux/x86-mes-mescc/crt1.c";

  getRes = suffix: res: "${res}/${res.name}${suffix}";

  archive = out: sources:
    "catm ${out} ${lib.concatMapStringsSep " " (getRes ".o") sources}";
  sourceArchive = out: sources:
    "catm ${out} ${lib.concatMapStringsSep " " (getRes ".s") sources}";

  mkLib = libname: sources: let
    os = map compile sources;
  in kaem.runCommand "${pname}-${libname}-${version}" {
    inherit meta;
  } ''
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
  libs = kaem.runCommand "${pname}-m2-libs-${version}" {
    inherit pname version;

    passthru.tests.get-version = result: kaem.runCommand "${pname}-get-version-${version}" {} ''
      ${result}/bin/mes --version
      mkdir ''${out}
    '';

    inherit meta;
  }
  ''
    LIBDIR=''${out}/lib
    mkdir -p ''${out} ''${LIBDIR}

    mkdir -p ''${LIBDIR}/x86-mes

    # crt1.o
    cp ${crt1}/crt1.o ''${LIBDIR}/x86-mes
    cp ${crt1}/crt1.s ''${LIBDIR}/x86-mes

    # libc-mini.a
    cp ${libc-mini}/lib/libc-mini.a ''${LIBDIR}/x86-mes
    cp ${libc-mini}/lib/libc-mini.s ''${LIBDIR}/x86-mes

    # libmescc.a
    cp ${libmescc}/lib/libmescc.a ''${LIBDIR}/x86-mes
    cp ${libmescc}/lib/libmescc.s ''${LIBDIR}/x86-mes

    # libc.a
    cp ${libc}/lib/libc.a ''${LIBDIR}/x86-mes
    cp ${libc}/lib/libc.s ''${LIBDIR}/x86-mes

    # libc+tcc.a
    cp ${libc_tcc}/lib/libc+tcc.a ''${LIBDIR}/x86-mes
    cp ${libc_tcc}/lib/libc+tcc.s ''${LIBDIR}/x86-mes
  '';

  # Build mes itself
  compiler = kaem.runCommand "${pname}-${version}" {
    inherit pname version;

    passthru.tests.get-version = result: kaem.runCommand "${pname}-get-version-${version}" {} ''
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
      ${libs}/lib/x86-mes/crt1.o \
      ${lib.concatMapStringsSep " " (getRes ".o") (map compile mes_SOURCES)}
  '';
in {
  inherit src srcPost srcPrefix nyacc;
  inherit compiler libs;
}
