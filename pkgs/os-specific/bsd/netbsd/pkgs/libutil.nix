{
  lib,
  stdenvLibcMinimal,
  mkDerivation,
  bsdSetupHook,
  netbsdSetupHook,
  makeMinimal,
  byacc,
  install,
  tsort,
  lorder,
  mandoc,
  statHook,
  headers,
}:

mkDerivation {
  path = "lib/libutil";

  libcMinimal = true;

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    bsdSetupHook
    netbsdSetupHook
    makeMinimal
    byacc
    install
    tsort
    lorder
    mandoc
    statHook
  ];

  SHLIBINSTALLDIR = "$(out)/lib";

  # Hack around GCC's limits.h missing the include_next we want See
  # https://gcc.gnu.org/legacy-ml/gcc/2003-10/msg01278.html
  NIX_CFLAGS_COMPILE_BEFORE = "-isystem ${stdenvLibcMinimal.cc.libc.dev}/include";

  extraPaths = [
    "common"
    "lib/libc"
    "sys"
  ];

  meta.platforms = lib.platforms.netbsd;
}
