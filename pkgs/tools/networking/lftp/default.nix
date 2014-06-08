{ stdenv, fetchurl, gnutls, pkgconfig, readline, zlib, xz }:

stdenv.mkDerivation rec {
  name = "lftp-4.4.16";

  src = fetchurl {
    url = "http://lftp.yar.ru/ftp/${name}.tar.gz";
    sha256 = "1wivcynm4pc18vj4x6r2saczk34ds3slagmz3y3b04rzklplf7s4";
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
