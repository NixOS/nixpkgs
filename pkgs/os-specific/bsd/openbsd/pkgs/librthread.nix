{
  lib,
  mkDerivation,
  libcMinimal,
}:

mkDerivation {
  path = "lib/librthread";

  libcMinimal = true;

  outputs = [
    "out"
    "dev"
  ];

  makeFlags = [ "LIBCSRCDIR=../libc" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  extraPaths = [
    "lib/libpthread"
    libcMinimal.path
    #"sys"
  ];

  meta.platforms = lib.platforms.openbsd;
}
