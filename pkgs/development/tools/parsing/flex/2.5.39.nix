{ stdenv, fetchurl, bison, m4 }:

stdenv.mkDerivation {
  name = "flex-2.5.39";

  src = fetchurl {
    url = mirror://sourceforge/flex/flex-2.5.39.tar.bz2;
    sha256 = "0zv15giw3gma03y2bzw78hjfy49vyir7vbcgnh9bb3637dgvblmd";
  };

  buildInputs = [ bison ];

  propagatedNativeBuildInputs = [ m4 ];

  postConfigure = stdenv.lib.optionalString (stdenv.isDarwin || stdenv.isCygwin) ''
    sed -i Makefile -e 's/-no-undefined//;'
  '';

  crossAttrs = {
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
