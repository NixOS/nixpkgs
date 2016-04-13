{ stdenv, fetchurl, bison, m4 }:

stdenv.mkDerivation rec {
  name = "flex-2.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/flex/${name}.tar.bz2";
    sha256 = "1sdqx63yadindzafrq1w31ajblf9gl1c301g068s20s7bbpi3ri4";
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
  };
}
