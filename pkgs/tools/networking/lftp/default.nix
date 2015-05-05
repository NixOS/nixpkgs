{ stdenv, fetchurl, gnutls, pkgconfig, readline, zlib }:

stdenv.mkDerivation rec {
  name = "lftp-4.6.1";

  src = fetchurl {
    urls = [
      "http://lftp.yar.ru/ftp/${name}.tar.bz2"
      "http://lftp.yar.ru/ftp/old/${name}.tar.bz2"
      ];
    sha256 = "0w9nb24abqlnjzi30q8s0yv3h0zjxhynliyxwdgnrv0qag0k401s";
  };

  patches = [ ./no-gets.patch ];

  buildInputs = [ gnutls pkgconfig readline zlib ];

  meta = with stdenv.lib; {
    description = "A file transfer program supporting a number of network protocols";
    homepage = http://lftp.yar.ru/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
