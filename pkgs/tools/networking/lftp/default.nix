<<<<<<< HEAD
{ lib, stdenv, fetchurl, openssl, pkg-config, readline, zlib, libidn2, gmp, libiconv, libunistring, gettext }:
=======
{ lib, stdenv, fetchurl, gnutls, pkg-config, readline, zlib, libidn2, gmp, libiconv, libunistring, gettext }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

<<<<<<< HEAD
  buildInputs = [ openssl readline zlib libidn2 gmp libiconv libunistring gettext ];
=======
  buildInputs = [ gnutls readline zlib libidn2 gmp libiconv libunistring gettext ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  hardeningDisable = lib.optional stdenv.isDarwin "format";

  configureFlags = [
<<<<<<< HEAD
    "--with-openssl"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
