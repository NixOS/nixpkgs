{stdenv, fetchurl, m4, perl}:

stdenv.mkDerivation {
  name = "autoconf-2.59";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/autoconf-2.59.tar.bz2;
    md5 = "1ee40f7a676b3cfdc0e3f7cd81551b5f";
  };
  buildInputs = [m4 perl];
}
