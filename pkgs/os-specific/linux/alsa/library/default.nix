{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "alsa-lib-1.0.12";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/alsa-lib-1.0.12.tar.bz2;
    md5 = "d351d46c5e415d4c8448487737939c72";
  };
}
