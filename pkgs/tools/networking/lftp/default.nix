{stdenv, fetchurl, gnutls, libtasn1, pkgconfig, readline, zlib, xz}:

stdenv.mkDerivation rec {
  name = "lftp-4.3.1";

  src = fetchurl {
    url = "ftp://ftp.cs.tu-berlin.de/pub/net/ftp/lftp/${name}.tar.xz";
    sha256 = "0v3591fknmimarzk5icm0qxdcfzfckwi2drh165vsiggmj590iyx";
  };

  buildInputs = [gnutls libtasn1 pkgconfig readline zlib];
}
