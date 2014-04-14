{ stdenv, fetchurl, gnutls, pkgconfig, readline, zlib, xz }:

stdenv.mkDerivation rec {
  name = "lftp-4.4.15";

  src = fetchurl {
    url = "http://lftp.yar.ru/ftp/${name}.tar.gz";
    sha256 = "1iw0xvvi9wr7grm6dwbxgm8ms98pg5skj44q477gxzrrff9dvvvp";
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
