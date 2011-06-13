{stdenv, fetchurl, gnutls, libtasn1, pkgconfig, readline, zlib, xz}:

stdenv.mkDerivation rec {
  name = "lftp-4.2.3";

  src = fetchurl {
    url = "ftp://ftp.cs.tu-berlin.de/pub/net/ftp/lftp/${name}.tar.xz";
    sha256 = "0l58lw2xgx9y64kz6mjd8ggdx92yr05rp08zssvsn8wx1vlvg6bh";
  };

  buildInputs = [gnutls libtasn1 pkgconfig readline zlib xz];
}
