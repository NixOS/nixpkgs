{ stdenv, fetchurl, gnutls, pkgconfig, readline, zlib, libidn, gmp, libiconv }:

stdenv.mkDerivation rec {
  name = "lftp-${version}";
  version = "4.7.6";

  src = fetchurl {
    urls = [
      "https://lftp.tech/ftp/${name}.tar.bz2"
      "ftp://ftp.st.ryukoku.ac.jp/pub/network/ftp/lftp/${name}.tar.bz2"
      "http://lftp.yar.ru/ftp/old/${name}.tar.bz2"
      ];
    sha256 = "6b46389e9c2e67af9029a783806facea4c8f0b4d6adca5c1088e948d2fd68ae7";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gnutls readline zlib libidn gmp libiconv ];

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
