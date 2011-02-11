{stdenv, fetchurl, gnutls, libtasn1, pkgconfig, readline, zlib}:
stdenv.mkDerivation {
  name = "lftp-4.1.3";

  src = fetchurl {
    url = ftp://ftp.cs.tu-berlin.de/pub/net/ftp/lftp/lftp-4.1.3.tar.bz2;
    sha256 = "1nbgbql8kkhdvai0glwgkq8l9ik09l5lb8znpjrv26hfzl15dvv1";
  };

  buildInputs = [gnutls libtasn1 pkgconfig readline zlib];
}
