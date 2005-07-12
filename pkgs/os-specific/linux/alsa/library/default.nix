{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "alsa-lib-1.0.9";
  src = fetchurl {
    url = ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.0.9.tar.bz2;
    md5 = "114af3304619920ffe2b147b760700b9";
  };
}
