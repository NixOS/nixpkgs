{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "asf-library-1.1";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/asf-library-1.1.tar.gz;
    md5 = "09b2ccbd115434cedb180e5575d0fa98";
  };
}

