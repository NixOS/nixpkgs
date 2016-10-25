{ stdenv, fetchurl, gnutls, pkgconfig, readline, zlib, libidn, gmp, libiconv }:

stdenv.mkDerivation rec {
  name = "lftp-4.7.3";

  src = fetchurl {
    urls = [
      "http://lftp.yar.ru/ftp/${name}.tar.bz2"
      "http://lftp.yar.ru/ftp/old/${name}.tar.bz2"
      ];
    sha256 = "06jmc9x86ga67yyx7655zv96gfv1gdm955a7g4afd3bwf6bzfxac";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gnutls readline zlib libidn gmp libiconv ];

  configureFlags = [
    "--with-readline=${readline.dev}"
  ];

  postPatch = ''
    substituteInPlace src/lftp_rl.c --replace 'history.h' 'readline/history.h'
  '';

  meta = with stdenv.lib; {
    description = "A file transfer program supporting a number of network protocols";
    homepage = http://lftp.yar.ru/;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
