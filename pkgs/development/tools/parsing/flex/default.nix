{ stdenv, fetchurl, bison, m4 }:

stdenv.mkDerivation rec {
  name = "flex-${version}";
  version = "2.6.1";

  src = fetchurl {
    url = "https://github.com/westes/flex/releases/download/v${version}/flex-${version}.tar.xz";
    sha256 = "0gqhk4vkwy4gl9xbpgkljph8c0a5kpijz6wd0p5r9q202qn42yic";
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
    homepage = http://flex.sourceforge.net/;
    description = "A fast lexical analyser generator";
    platforms = stdenv.lib.platforms.unix;
  };
}
