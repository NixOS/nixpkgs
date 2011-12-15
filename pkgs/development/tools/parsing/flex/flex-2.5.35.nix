# This should be moved to default.nix eventually (?)

{stdenv, fetchurl, yacc, m4}:

assert yacc != null && m4 != null;

stdenv.mkDerivation {
  name = "flex-2.5.35";
  src = fetchurl {
    url = mirror://sourceforge/flex/flex-2.5.35.tar.bz2;
    sha256 = "0ysff249mwhq0053bw3hxh58djc0gy7vjan2z1krrf9n5d5vvv0b";
  };
  buildInputs = [yacc];
  propagatedBuildNativeInputs = [m4];

  crossAttrs = {
    preConfigure = ''
      export ac_cv_func_malloc_0_nonnull=yes
      export ac_cv_func_realloc_0_nonnull=yes
    '';
  };

  meta = {
    description = "A fast lexical analyser generator";
  };
}
