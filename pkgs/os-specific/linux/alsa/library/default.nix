{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "alsa-lib-1.0.10";
  src = fetchurl {
    url = ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.0.10.tar.bz2;
    md5 = "b1a4e15c9ff81798507de470a92fcc43";
  };
}
