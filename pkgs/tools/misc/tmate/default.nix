{ stdenv, fetchFromGitHub, autoreconfHook, cmake, libtool, pkgconfig
, zlib, openssl, libevent, ncurses, ruby, msgpack, libssh }:

stdenv.mkDerivation rec {
  name = "tmate-${version}";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner  = "tmate-io";
    repo   = "tmate";
    rev    = version;
    sha256 = "0pfl9vrswzim9ydi1n652h3rax2zrmy6sqkp0r09yy3lw83h4y1r";
  };

  dontUseCmakeConfigure = true;

  buildInputs = [ libtool zlib openssl libevent ncurses ruby msgpack libssh ];
  nativeBuildInputs = [ autoreconfHook cmake pkgconfig ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage    = https://tmate.io/;
    description = "Instant Terminal Sharing";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
