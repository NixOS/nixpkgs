{ stdenv, fetchgit, bison, flex, openssl }:

stdenv.mkDerivation rec {
  name = "charybdis-3.5.3";

  src = fetchFromGitHub {
    owner = "charybdis-ircd";
    repo = "charybdis";
    rev = name;
    sha256 = "1s8p26lrc5vm08gi6hc5gqidgyj7v5bzm4d2g81v4xk387f85lnc";
  };

  patches = [
     ./remove-setenv.patch
  ];

  configureFlags = [
    "--enable-epoll"
    "--enable-ipv6"
    "--enable-openssl=${openssl}"
    "--with-program-prefix=charybdis-"
  ];

  buildInputs = [ bison flex openssl ];

  meta = {
    description = "An extremely scalable ircd with some cooperation with the ratbox and ircu guys";
    homepage    = https://github.com/atheme/charybdis;
    license     = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.lassulus ];
    platforms   = stdenv.lib.platforms.linux;
  };


}
