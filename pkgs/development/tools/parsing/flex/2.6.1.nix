{ stdenv, fetchurl, bison, m4 }:

stdenv.mkDerivation rec {
  name = "flex-2.6.1";

  src = fetchurl {
    url = "https://github.com/westes/flex/releases/download/v2.6.1/flex-2.6.1.tar.gz";
    sha256 = "0fy14c35yz2m1n1m4f02by3501fn0cca37zn7jp8lpp4b3kgjhrw";
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
