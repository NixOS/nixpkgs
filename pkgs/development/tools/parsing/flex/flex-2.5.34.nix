# This should be moved to default.nix eventually (?)

{stdenv, fetchurl, yacc, m4}:

assert yacc != null && m4 != null;

stdenv.mkDerivation {
  name = "flex-2.5.34";
  src = fetchurl {
    url = mirror://sourceforge/flex/flex-2.5.34.tar.bz2;
    sha256 = "1c8e64f32508841b0441ddfb139c4cfd25fee3728cadb63f5f351c6eb9b224a6";
  };
  buildInputs = [yacc];
  propagatedBuildInputs = [m4];

  meta = {
    description = "A fast lexical analyser generator";
  };
  NO_PARALLEL_BUILD_installPhase = 1;
}
