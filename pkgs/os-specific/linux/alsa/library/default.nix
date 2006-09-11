{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "alsa-lib-1.0.12";
  src = fetchurl {
    url = ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.0.12.tar.bz2;
    md5 = "d351d46c5e415d4c8448487737939c72";
  };
}
