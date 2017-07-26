{ stdenv, fetchFromGitHub, bison, flex, openssl }:

stdenv.mkDerivation rec {
  name = "charybdis-3.5.5";

  src = fetchFromGitHub {
    owner = "charybdis-ircd";
    repo = "charybdis";
    rev = name;
    sha256 = "16bl516hcj1chgzkfnpg9bf9s6zr314pqzhlz6641lgyzaw1z3w0";
  };

  patches = [
     ./remove-setenv.patch
  ];

  configureFlags = [
    "--enable-epoll"
    "--enable-ipv6"
    "--enable-openssl=${openssl.dev}"
    "--with-program-prefix=charybdis-"
    "--sysconfdir=/etc/charybdis"
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
