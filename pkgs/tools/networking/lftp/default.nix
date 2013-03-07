{ stdenv, fetchurl, gnutls, pkgconfig, readline, zlib, xz }:

stdenv.mkDerivation rec {
  name = "lftp-4.4.0";

  src = fetchurl {
    url = "ftp://ftp.cs.tu-berlin.de/pub/net/ftp/lftp/${name}.tar.xz";
    sha256 = "0cg4gabya2sygbwh2b0cdr8v719q9gv929hdb5g1mxgj8npjd4y7";
  };

  patches = [ ./no-gets.patch ];

  buildInputs = [ gnutls pkgconfig readline zlib ];

  meta = {
    homepage = http://lftp.yar.ru/;
    description = "A file transfer program supporting a number of network protocols";
    license = "GPL";
  };
}
