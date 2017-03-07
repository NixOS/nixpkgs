{ stdenv, fetchFromGitHub, autoconf, automake, libtool, pkgconfig, zlib, openssl, libevent, ncurses, cmake, ruby, libmsgpack, libssh }:

stdenv.mkDerivation rec {
  name = "tmate-${version}";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner  = "tmate-io";
    repo   = "tmate";
    rev    = version;
    sha256 = "0pfl9vrswzim9ydi1n652h3rax2zrmy6sqkp0r09yy3lw83h4y1r";
  };

  buildInputs = [ autoconf automake pkgconfig libtool zlib openssl libevent ncurses cmake ruby libmsgpack libssh ];

  dontUseCmakeConfigure=true;

  preConfigure = "./autogen.sh";

  meta = {
    homepage = http://tmate.io/;
    description = "Instant Terminal Sharing";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ ];
  };
}
