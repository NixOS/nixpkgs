{ stdenv, fetchurl, gnutls, pkgconfig, readline, zlib, libidn, gmp, libiconv }:

stdenv.mkDerivation rec {
  name = "lftp-${version}";
  version = "4.8.0";

  src = fetchurl {
    urls = [
      "https://lftp.tech/ftp/${name}.tar.bz2"
      "ftp://ftp.st.ryukoku.ac.jp/pub/network/ftp/lftp/${name}.tar.bz2"
      "http://lftp.yar.ru/ftp/old/${name}.tar.bz2"
      ];
    sha256 = "0z2432zxzg808swi72yak9kia976qrjj030grk0v4p54mcib3s34";
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
