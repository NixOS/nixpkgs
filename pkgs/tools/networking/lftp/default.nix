{ stdenv, fetchurl, gnutls, pkgconfig, readline, zlib, libidn2, gmp, libiconv, libunistring, gettext }:

stdenv.mkDerivation rec {
  name = "lftp-${version}";
  version = "4.8.2";

  src = fetchurl {
    urls = [
      "https://lftp.tech/ftp/${name}.tar.bz2"
      "ftp://ftp.st.ryukoku.ac.jp/pub/network/ftp/lftp/${name}.tar.bz2"
      "http://lftp.yar.ru/ftp/old/${name}.tar.bz2"
      ];
    sha256 = "0a4sp9khqgny1md0b2c9vvg4c7sz0g31w3sfdslxw7dsvijin3mn";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gnutls readline zlib libidn2 gmp libiconv libunistring ]
    ++ stdenv.lib.optional stdenv.isDarwin gettext;

  hardeningDisable = stdenv.lib.optional stdenv.isDarwin "format";

  configureFlags = [
    "--with-readline=${readline.dev}"
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "A file transfer program supporting a number of network protocols";
    homepage = http://lftp.tech/;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
