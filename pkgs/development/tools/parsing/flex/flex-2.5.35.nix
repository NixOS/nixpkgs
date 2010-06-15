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
  propagatedBuildInputs = [m4];

  meta = {
    description = "A fast lexical analyser generator";
  };
  NO_PARALLEL_BUILD_installPhase = 1;
}
