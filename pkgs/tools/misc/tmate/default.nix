{ stdenv, fetchFromGitHub, autoreconfHook, cmake, libtool, pkgconfig
, zlib, openssl, libevent, ncurses, ruby, msgpack, libssh }:

stdenv.mkDerivation rec {
  pname = "tmate";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner  = "tmate-io";
    repo   = "tmate";
    rev    = version;
    sha256 = "0x5c31yq7ansmiy20a0qf59wagba9v3pq97mlkxrqxn4n1gcc6vi";
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
