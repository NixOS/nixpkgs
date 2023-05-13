{ lib
, fetchurl
, writeText
, callPackage
, kaem
, m2libc
, mescc-tools
}:
let
  pname = "mes";
  version = "0.24.2";

  src = fetchurl {
    url = "mirror://gnu/mes/mes-${version}.tar.gz";
    sha256 = "0vp8v88zszh1imm3dvdfi3m8cywshdj7xcrsq4cgmss69s2y1nkx";
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

  compile = sources:
    lib.concatMapStringsSep
      "\n"
      (f: ''CC -c ''${MES_PREFIX}/${f}'')
      sources;
  replaceExt = ext: source:
    lib.replaceStrings
      [ ".c" ]
      [ ext ]
      (builtins.baseNameOf source);
  archive = out: sources:
    "catm ${out} ${lib.concatMapStringsSep " " (replaceExt ".o") sources}";
  sourceArchive = out: sources:
    "catm ${out} ${lib.concatMapStringsSep " " (replaceExt ".s") sources}";
in
kaem.runCommand "${pname}-${version}" {
  inherit pname version;

  passthru = { inherit src nyacc; };

  meta = with lib; {
    description = "Scheme interpreter and C compiler for bootstrapping";
    homepage = "https://www.gnu.org/software/mes";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ emilytrau ];
    platforms = [ "i686-linux" ];
  };
}
# Maintenance note:
# Build steps have been adapted from build-aux/bootstrap.sh.in
# as well as the live-bootstrap project
# https://github.com/fosslinux/live-bootstrap/blob/1bc4296091c51f53a5598050c8956d16e945b0f5/sysa/mes-0.24.2/mes-0.24.2.kaem
''
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
  ${compile libc_mini_SOURCES}
  ${archive "libc-mini.a" libc_mini_SOURCES}
  ${sourceArchive "libc-mini.s" libc_mini_SOURCES}
  cp libc-mini.a ''${LIBDIR}/x86-mes
  cp libc-mini.s ''${LIBDIR}/x86-mes

  # libmescc.a
  ${compile libmescc_SOURCES}
  ${archive "libmescc.a" libmescc_SOURCES}
  ${sourceArchive "libmescc.s" libmescc_SOURCES}
  cp libmescc.a ''${LIBDIR}/x86-mes
  cp libmescc.s ''${LIBDIR}/x86-mes

  # libc.a
  ${compile libc_SOURCES}
  ${archive "libc.a" libc_SOURCES}
  ${sourceArchive "libc.s" libc_SOURCES}
  cp libc.a ''${LIBDIR}/x86-mes
  cp libc.s ''${LIBDIR}/x86-mes

  # libc+tcc.a
  # optimisation: don't recompile common libc sources
  ${compile (lib.subtractLists libc_SOURCES libc_tcc_SOURCES)}
  ${archive "libc+tcc.a" libc_tcc_SOURCES}
  ${sourceArchive "libc+tcc.s" libc_tcc_SOURCES}
  cp libc+tcc.a ''${LIBDIR}/x86-mes
  cp libc+tcc.s ''${LIBDIR}/x86-mes

  # Build mes itself
  ${compile mes_SOURCES}
  ''${out}/bin/mes-m2 -e main ''${out}/bin/mescc.scm -- \
    --base-address 0x08048000 \
    -L ''${MES_PREFIX}/lib \
    -L . \
    -lc \
    -lmescc \
    -nostdlib \
    -o ''${out}/bin/mes \
    crt1.o \
    ${lib.concatMapStringsSep " " (replaceExt ".o") mes_SOURCES}

  # Check
  ''${out}/bin/mes --version
''
