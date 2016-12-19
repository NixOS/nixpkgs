{ stdenv, fetchFromGitHub, bison, flex, openssl }:

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
    "--enable-openssl=${openssl.dev}"
    "--with-program-prefix=charybdis-"
  ];

  buildInputs = [ bison flex openssl ];

  meta = with stdenv.lib; {
    description = "IRCv3 server designed to be highly scalable";
    homepage    = http://www.charybdis.io/;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lassulus fpletz ];
    platforms   = platforms.unix;
  };

}
