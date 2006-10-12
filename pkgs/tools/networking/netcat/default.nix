{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "netcat-gnu-0.7.1";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/netcat-0.7.1.tar.bz2;
    md5 = "0a29eff1736ddb5effd0b1ec1f6fe0ef";
  };
}
