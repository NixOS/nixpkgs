{ stdenv, fetchurl, gnutls, pkgconfig, readline, zlib }:

stdenv.mkDerivation rec {
  name = "lftp-4.5.2";

  src = fetchurl {
    url = "http://lftp.yar.ru/ftp/${name}.tar.gz";
    sha256 = "106llhq9lgvdxlf4r1p94r66fcy5ywfdfvins4dfn9irg0k5gzyv";
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
