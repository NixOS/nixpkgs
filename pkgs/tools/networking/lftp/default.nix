{ stdenv, fetchurl, gnutls, pkgconfig, readline, zlib, libidn, gmp, libiconv }:

stdenv.mkDerivation rec {
  name = "lftp-${version}";
  version = "4.7.7";

  src = fetchurl {
    urls = [
      "https://lftp.tech/ftp/${name}.tar.bz2"
      "ftp://ftp.st.ryukoku.ac.jp/pub/network/ftp/lftp/${name}.tar.bz2"
      "http://lftp.yar.ru/ftp/old/${name}.tar.bz2"
      ];
    sha256 = "104jvzmvbmblfg8n8ffrnrrg8za5l25n53lbkawwy5x3m4h1yi7y";
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
