{
  lib,
  stdenv,
  fetchpatch,
  mkDerivation,
  libcMinimal,
  include,
  libgcc,
  csu,
  extraSrc ? [ ],
}:

mkDerivation {
  path = "lib/libthr";
  extraPaths = [
    "lib/libthread_db"
    "lib/libc" # needs /include + arch-specific files
    "libexec/rtld-elf"
  ]
  ++ extraSrc;

  outputs = [
    "out"
    "man"
    "debug"
  ];

  noLibc = true;

  buildInputs = [
    libcMinimal
    include
    libgcc
  ];

  patches = [
    # https://github.com/freebsd/freebsd-src/pull/1882
    (fetchpatch {
      name = "freebsd-libthr-use-nonstring-attribute.patch";
      url = "https://github.com/freebsd/freebsd-src/pull/1882/commits/650800993deb513dc31e99ef5cdecd50ee70bb04.diff";
      hash = "sha256-WKN7dfGAs1+XADT4aLUkkKmQQ4n7gsyFUTCeo6mcuMY=";
      includes = [ "lib/libthr/thread/thr_printf.c" ];
    })
  ];

  # Presumably newer Clang has gotten more strict.
  CWARNEXTRA = "-Wno-cast-function-type-mismatch";

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${csu}/lib"
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isStatic ''
    rm $out/lib/libpthread.so
  '';

  env.MK_TESTS = "no";
}
