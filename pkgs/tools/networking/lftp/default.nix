{ stdenv, fetchurl, gnutls, pkgconfig, readline, zlib, libidn }:

stdenv.mkDerivation rec {
  name = "lftp-4.7.1";

  src = fetchurl {
    urls = [
      "http://lftp.yar.ru/ftp/${name}.tar.bz2"
      "http://lftp.yar.ru/ftp/old/${name}.tar.bz2"
      ];
    sha256 = "0n4l0n6ra6z5lh6v79hc0r0hhrsq0l6c47ir15vmq80sbgc9mmwv";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gnutls readline zlib libidn ];

  configureFlags = [
    "--with-readline=${readline.dev}"
  ];

  meta = with stdenv.lib; {
    description = "A file transfer program supporting a number of network protocols";
    homepage = http://lftp.yar.ru/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
