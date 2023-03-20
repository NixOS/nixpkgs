{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {

  pname = "mlmmj";
  version = "1.3.0";

  src = fetchurl {
    url = "http://mlmmj.org/releases/${pname}-${version}.tar.gz";
    sha256 = "1sghqvwizvm1a9w56r34qy5njaq1c26bagj85r60h32gh3fx02bn";
  };

  configureFlags = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # AC_FUNC_MALLOC is broken on cross builds.
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: getlistdelim.o:/build/mlmmj-1.3.0/src/../include/mlmmj.h:84: multiple definition of
  #     `subtype_strs'; mlmmj-send.o:/build/mlmmj-1.3.0/src/../include/mlmmj.h:84: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  postInstall = ''
    # grab all documentation files
    docfiles=$(find -maxdepth 1 -name "[[:upper:]][[:upper:]]*")
    install -vDm 644 -t $out/share/doc/mlmmj/ $docfiles
  '';

  meta = with lib; {
    homepage = "http://mlmmj.org";
    description = "Mailing List Management Made Joyful";
    maintainers = [ maintainers.edwtjo ];
    platforms = platforms.linux;
    license = licenses.mit;
  };

}
