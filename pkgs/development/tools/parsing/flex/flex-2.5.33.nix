# !!! this should be moved to default.nix eventually (but I delay
# doing that since it would cause a rebuild of lots of stuff).

{stdenv, fetchurl, yacc, m4}:

assert yacc != null && m4 != null;

stdenv.mkDerivation {
  name = "flex-2.5.33";
  src = fetchurl {
    url = mirror://sourceforge/flex/flex-2.5.33.tar.bz2;
    md5 = "343374a00b38d9e39d1158b71af37150";
  };
  buildInputs = [yacc];
  propagatedBuildInputs = [m4];

  meta = {
    description = "A fast lexical analyser generator";
  };
  NO_PARALLEL_BUILD_installPhase = 1;
}
