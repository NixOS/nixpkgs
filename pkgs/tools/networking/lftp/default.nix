{ lib, stdenv, fetchurl, gnutls, pkg-config, readline, zlib, libidn2, gmp, libiconv, libunistring, gettext }:

stdenv.mkDerivation rec {
  pname = "lftp";
  version = "4.9.2";

  src = fetchurl {
    urls = [
      "https://lftp.yar.ru/ftp/${pname}-${version}.tar.xz"
      "https://ftp.st.ryukoku.ac.jp/pub/network/ftp/lftp/${pname}-${version}.tar.xz"
      ];
    sha256 = "03b7y0h3mf4jfq5y8zw6hv9v44z3n6i8hc1iswax96y3z7sc85y5";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gnutls readline zlib libidn2 gmp libiconv libunistring gettext ];

  hardeningDisable = lib.optional stdenv.isDarwin "format";

  configureFlags = [
    "--with-readline=${readline.dev}"
    "--with-zlib=${zlib.dev}"
    "--without-expat"
  ];

  installFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A file transfer program supporting a number of network protocols";
    homepage = "https://lftp.yar.ru/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
