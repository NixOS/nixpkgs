{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "alsa-lib-0.9.8";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.alsa-project.org/pub/lib/alsa-lib-0.9.8.tar.bz2;
    md5 = "c9f163fb0623de1b92bf287712641f6e";
  };
}
