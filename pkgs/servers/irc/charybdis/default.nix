{ stdenv, fetchFromGitHub, autoreconfHook, bison, flex, openssl, gnutls }:

stdenv.mkDerivation rec {
  name = "charybdis-4.1.1";

  src = fetchFromGitHub {
    owner = "charybdis-ircd";
    repo = "charybdis";
    rev = name;
    sha256 = "0wvssc8b1xq6svcqrwxrpc1ga8ip0sksv73wwbk8na0pmysdvpg0";
  };

  postPatch = ''
    substituteInPlace include/defaults.h --replace 'PKGLOCALSTATEDIR "' '"/var/lib/charybdis'
  '';

  autoreconfPhase = "sh autogen.sh";

  configureFlags = [
    "--enable-epoll"
    "--enable-ipv6"
    "--enable-openssl=${openssl.dev}"
    "--with-program-prefix=charybdis-"
  ];

  nativeBuildInputs = [ autoreconfHook bison flex ];
  buildInputs = [ openssl gnutls ];

  meta = with stdenv.lib; {
    description = "IRCv3 server designed to be highly scalable";
    homepage    = http://atheme.org/projects/charybdis.html;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lassulus fpletz ];
    platforms   = platforms.unix;
  };

}
