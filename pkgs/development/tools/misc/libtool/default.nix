{stdenv, fetchurl, m4, perl}:

stdenv.mkDerivation {
  name = "libtool-1.5.2";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/libtool-1.5.2.tar.gz;
    md5 = "db66ba05502f533ad0cfd84dc0e03bd5";
  };
  buildInputs = [m4 perl];
}
