{
  lib,
  stdenv,
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

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${csu}/lib"
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isStatic ''
    rm $out/lib/libpthread.so
  '';

  env.MK_TESTS = "no";
}
