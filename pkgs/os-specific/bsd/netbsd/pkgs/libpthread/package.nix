{
  lib,
  stdenvLibcMinimal,
  mkDerivation,
  headers,
  libcMinimal,
  librt,
}:

mkDerivation {
  path = "lib/libpthread";

  libcMinimal = true;

  outputs = [
    "out"
    "dev"
    "man"
  ];

  SHLIBINSTALLDIR = "$(out)/lib";

  # Hack around GCC's limits.h missing the include_next we want See
  # https://gcc.gnu.org/legacy-ml/gcc/2003-10/msg01278.html
  NIX_CFLAGS_COMPILE_BEFORE = "-isystem ${stdenvLibcMinimal.cc.libc.dev}/include";

  extraPaths = [
    "common"
    libcMinimal.path
    librt.path
    "sys"
  ];

  meta.platforms = lib.platforms.netbsd;
}
