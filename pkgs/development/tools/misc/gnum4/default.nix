{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "gnum4-1.4.9";
  src = fetchurl {
    url = mirror://gnu/m4/m4-1.4.9.tar.bz2;
    sha256 = "0a9xgknp29zdhpp7xn3bfcxdc0wn2rzvjfdksz5ym82b6y397qm8";
  };
}
