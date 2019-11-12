{ stdenv, fetchFromGitHub, autoreconfHook, cmake, libtool, pkgconfig
, zlib, openssl, libevent, ncurses, ruby, msgpack, libssh }:

stdenv.mkDerivation rec {
  pname = "tmate";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner  = "tmate-io";
    repo   = "tmate";
    rev    = version;
    sha256 = "183rvga8nvh9r7p8104vwcmzp3vrfdhnx73vh06m2fgdq9i5rz3l";
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
