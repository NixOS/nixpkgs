{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "netcat-gnu-0.7.1";
  src = fetchurl {
    url = mirror://sourceforge/netcat/netcat-0.7.1.tar.bz2;
    md5 = "0a29eff1736ddb5effd0b1ec1f6fe0ef";
  };
}
