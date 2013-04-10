{ stdenv, fetchurl, gnutls, pkgconfig, readline, zlib, xz }:

stdenv.mkDerivation rec {
  name = "lftp-4.4.5";

  src = fetchurl {
    url = "ftp://ftp.cs.tu-berlin.de/pub/net/ftp/lftp/${name}.tar.xz";
    sha256 = "1p3nxsd2an9pdwc3vgwxy8p5nnjrc7mhilikjaddy62cyvxdbpxq";
  };

  patches = [ ./no-gets.patch ];

  buildInputs = [ gnutls pkgconfig readline zlib ];

  meta = {
    homepage = http://lftp.yar.ru/;
    description = "A file transfer program supporting a number of network protocols";
    license = "GPL";
  };
}
