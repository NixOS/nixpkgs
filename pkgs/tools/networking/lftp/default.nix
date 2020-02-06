{ stdenv, fetchurl, gnutls, pkgconfig, readline, zlib, libidn2, gmp, libiconv, libunistring, gettext }:

stdenv.mkDerivation rec {
  pname = "lftp";
  version = "4.9.1";

  src = fetchurl {
    urls = [
      "https://lftp.tech/ftp/${pname}-${version}.tar.xz"
      "https://ftp.st.ryukoku.ac.jp/pub/network/ftp/lftp/${pname}-${version}.tar.xz"
      "https://lftp.yar.ru/ftp/${pname}-${version}.tar.xz"
      ];
    sha256 = "0jq2g8h1bx06ya9fsja748vwb2qrca4wsfrgi3fmaa8hznpgqsar";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gnutls readline zlib libidn2 gmp libiconv libunistring gettext ];

  hardeningDisable = stdenv.lib.optional stdenv.isDarwin "format";

  configureFlags = [
    "--with-readline=${readline.dev}"
    "--with-zlib=${zlib.dev}"
    "--without-expat"
  ];

  installFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A file transfer program supporting a number of network protocols";
    homepage = https://lftp.tech/;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
