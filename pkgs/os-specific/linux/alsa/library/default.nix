{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "alsa-lib-1.0.8";
  src = fetchurl {
    url = ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.0.8.tar.bz2;
    md5 = "c677299ed39d069c9a4b6a999e34ffe7";
  };
}
