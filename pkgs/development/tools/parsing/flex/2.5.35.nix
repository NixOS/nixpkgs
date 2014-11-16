{ stdenv, fetchurl, bison, m4 }:

stdenv.mkDerivation {
  name = "flex-2.5.35";

  src = fetchurl {
    url = mirror://sourceforge/flex/flex-2.5.35.tar.bz2;
    sha256 = "0ysff249mwhq0053bw3hxh58djc0gy7vjan2z1krrf9n5d5vvv0b";
  };

  buildInputs = [ bison ];

  propagatedNativeBuildInputs = [ m4 ];

  crossAttrs = {
    preConfigure = ''
      export ac_cv_func_malloc_0_nonnull=yes
      export ac_cv_func_realloc_0_nonnull=yes
    '';
  };

  meta = {
    branch = "2.5.35";
    homepage = http://flex.sourceforge.net/;
    description = "A fast lexical analyser generator";
  };
}
