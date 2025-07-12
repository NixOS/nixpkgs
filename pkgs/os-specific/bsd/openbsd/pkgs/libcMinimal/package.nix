{
  lib,
  stdenvNoLibc,
  mkDerivation,
  fetchpatch,
  bsdSetupHook,
  openbsdSetupHook,
  makeMinimal,
  install,
  flex,
  byacc,
  gencat,
  lorder,
  tsort,
  rpcgen,
  csu,
  include,
}:

mkDerivation {
  noLibc = true;
  path = "lib/libc";
  pname = "libcMinimal-openbsd";
  outputs = [
    "out"
    "dev"
    "man"
  ];
  extraPaths = [
    "lib/csu/os-note-elf.h"
    "sys/arch"
  ];

  patches = [
    ./netbsd-make-to-lower.patch
    ./disable-librebuild.patch
    # Do not produce ctags, can do that separately.
    (fetchpatch {
      name = "skip-tags.patch";
      url = "https://marc.info/?l=openbsd-tech&m=171575286706032&q=raw";
      hash = "sha256-2fqabJZLUvXUIWe5WZ4NrTOwgQCXqH49Wo0hAPu5lu0=";
    })
  ];

  nativeBuildInputs = [
    bsdSetupHook
    openbsdSetupHook
    makeMinimal
    install
    tsort
    lorder
    gencat
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
  env.NIX_LDFLAGS = lib.optionalString (
    stdenvNoLibc.hostPlatform.linker == "lld"
  ) "--undefined-version";

  makeFlags = [
    "COMPILER_VERSION=clang"
    "LIBC_TAGS=no"
  ];

  postInstall = ''
    pushd ${include}
    find include -type d -exec mkdir -p "$dev/{}" ';'
    find include '(' -type f -o -type l ')' -exec cp -pr "{}" "$dev/{}" ';'
    popd
    substituteInPlace "$dev/include/sys/time.h" --replace "defined (_LIBC)" "true"

    pushd ${csu}
    find lib -type d -exec mkdir -p "$out/{}" ';'
    find lib '(' -type f -o -type l ')' -exec cp -pr "{}" "$out/{}" ';'
    popd
  '';

  meta.platforms = lib.platforms.openbsd;
}
