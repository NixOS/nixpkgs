{
  lib,
  stdenv,
  mkDerivation,
  bsdSetupHook,
  openbsdSetupHook,
  makeMinimal,
  install,
  flex,
  byacc,
  gencat,
  rpcgen,
  lorder,
  csu,
  include,
  ctags,
  tsort,
  llvmPackages,
  fetchpatch,
}:

mkDerivation rec {
  pname = "libc";
  path = "lib/libc";
  extraPaths = [
    "lib/csu/os-note-elf.h"
    "sys/arch"

    "lib/libm"
    "lib/libpthread"
    "lib/librpcsvc"
    "lib/librpcsvc"
    "lib/librthread"
    "lib/libutil"
  ];

  patches = [
    ./netbsd-make-to-lower.patch
    ./disable-librebuild.patch
    (fetchpatch {
      url = "https://marc.info/?l=openbsd-tech&m=171575286706032&q=raw";
      sha256 = "sha256-2fqabJZLUvXUIWe5WZ4NrTOwgQCXqH49Wo0hAPu5lu0=";
    })
  ];

  nativeBuildInputs = [
    bsdSetupHook
    openbsdSetupHook
    makeMinimal
    install
    flex
    byacc
    gencat
    rpcgen
    ctags
    lorder
    tsort
  ];

  buildInputs = [
    include
    csu
  ];

  env.NIX_CFLAGS_COMPILE = builtins.toString [
    "-B${csu}/lib"
    "-Wno-error"
  ];

  # Suppress lld >= 16 undefined version errors
  # https://github.com/freebsd/freebsd-src/commit/2ba84b4bcdd6012e8cfbf8a0d060a4438623a638
  env.NIX_LDFLAGS = lib.optionalString (stdenv.hostPlatform.linker == "lld") "--undefined-version";

  makeFlags = [
    "STRIP=-s" # flag to install, not command
    "COMPILER_VERSION=clang"
    "LIBC_TAGS=no"
  ];

  postInstall = ''
    symlink_so () {
      pushd $out/lib
      ln -s "lib$1".so.* "lib$1.so"
      popd
    }

    symlink_so c

    pushd ${include}
    find . -type d -exec mkdir -p $out/\{} \;
    find . \( -type f -o -type l \) -exec cp -pr \{} $out/\{} \;
    popd
    substituteInPlace $out/include/sys/time.h --replace "defined (_LIBC)" "true"

    pushd ${csu}
    find . -type d -exec mkdir -p $out/\{} \;
    find . \( -type f -o -type l \) -exec cp -pr \{} $out/\{} \;
    popd

    NIX_CFLAGS_COMPILE+=" -B$out/lib"
    NIX_CFLAGS_COMPILE+=" -I$out/include"
    NIX_LDFLAGS+=" -L$out/lib"

    make -C $BSDSRCDIR/lib/libm $makeFlags
    make -C $BSDSRCDIR/lib/libm $makeFlags install
    symlink_so m

    make -C $BSDSRCDIR/lib/librthread $makeFlags
    make -C $BSDSRCDIR/lib/librthread $makeFlags install
    symlink_so pthread

    make -C $BSDSRCDIR/lib/librpcsvc $makeFlags
    make -C $BSDSRCDIR/lib/librpcsvc $makeFlags install
    symlink_so rpcsv

    make -C $BSDSRCDIR/lib/libutil $makeFlags
    make -C $BSDSRCDIR/lib/libutil $makeFlags install
    symlink_so util
  '';
}
