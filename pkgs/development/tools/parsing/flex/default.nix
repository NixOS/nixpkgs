{ stdenv, fetchurl, bison, m4 }:

stdenv.mkDerivation rec {
  name = "flex-${version}";
  version = "2.6.3";

  src = fetchurl {
    url = "https://github.com/westes/flex/releases/download/v${version}/flex-${version}.tar.gz";
    sha256 = "1an2cn2z85mkpgqcinh1fhhcd7993qm2lil1yxic8iz76ci79ck8";
  };

  buildInputs = [ bison ];

  propagatedNativeBuildInputs = [ m4 ];

  postConfigure = stdenv.lib.optionalString (stdenv.isDarwin || stdenv.isCygwin) ''
    sed -i Makefile -e 's/-no-undefined//;'
  '';

  crossAttrs = {

    # disable tests which can't run on build machine
    postPatch = ''
      substituteInPlace Makefile.in --replace "tests" " ";
    '';

    preConfigure = ''
      export ac_cv_func_malloc_0_nonnull=yes
      export ac_cv_func_realloc_0_nonnull=yes
    '';
  };

  meta = {
    homepage = https://github.com/westes/flex;
    description = "A fast lexical analyser generator";
    platforms = stdenv.lib.platforms.unix;
  };
}
