{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "alsa-lib-1.0.3b";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/alsa-lib-1.0.3b.tar.bz2;
    md5 = "8ade68f0e9d44a039a741052985a8635";
  };
}
