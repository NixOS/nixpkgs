{
  lib,
  stdenvLibcMinimal,
  mkDerivation,
  libcMinimal,
}:

mkDerivation {
  path = "lib/i18n_module";

  libcMinimal = true;

  # Hack around GCC's limits.h missing the include_next we want See
  # https://gcc.gnu.org/legacy-ml/gcc/2003-10/msg01278.html
  NIX_CFLAGS_COMPILE_BEFORE = "-isystem ${stdenvLibcMinimal.cc.libc.dev}/include";

  extraPaths = [ libcMinimal.path ];

  meta.platforms = lib.platforms.netbsd;
}
