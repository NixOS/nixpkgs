{ stdenv, fetchurl, gnutls, pkgconfig, readline, zlib }:

stdenv.mkDerivation rec {
  name = "lftp-4.6.3a";

  src = fetchurl {
    urls = [
      "http://lftp.yar.ru/ftp/${name}.tar.bz2"
      "http://lftp.yar.ru/ftp/old/${name}.tar.bz2"
      ];
    sha256 = "0846p1z5v997lxaqanj8n1qkv470s8nlhs420kiby67k4j2zl576";
  };

  buildInputs = [ gnutls pkgconfig readline zlib ];

  meta = with stdenv.lib; {
    description = "A file transfer program supporting a number of network protocols";
    homepage = http://lftp.yar.ru/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
