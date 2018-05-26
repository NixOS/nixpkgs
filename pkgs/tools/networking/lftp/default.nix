{ stdenv, fetchurl, gnutls, pkgconfig, readline, zlib, libidn2, gmp, libiconv, libunistring, gettext }:

stdenv.mkDerivation rec {
  name = "lftp-${version}";
  version = "4.8.3";

  src = fetchurl {
    urls = [
      "https://lftp.tech/ftp/${name}.tar.xz"
      "https://ftp.st.ryukoku.ac.jp/pub/network/ftp/lftp/${name}.tar.xz"
      "http://lftp.yar.ru/ftp/${name}.tar.xz"
      ];
    sha256 = "12y77jlfs4x4zvcah92mw2h2sb4j0bvbaxkh3wwsm8gs392ywyny";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gnutls readline zlib libidn2 gmp libiconv libunistring gettext ];

  hardeningDisable = stdenv.lib.optional stdenv.isDarwin "format";

  configureFlags = [
    "--with-readline=${readline.dev}"
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "A file transfer program supporting a number of network protocols";
    homepage = https://lftp.tech/;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
