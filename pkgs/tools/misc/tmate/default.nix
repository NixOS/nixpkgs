{ stdenv, fetchFromGitHub, autoreconfHook, cmake, libtool, pkgconfig
, zlib, openssl, libevent, ncurses, ruby, msgpack, libssh }:

stdenv.mkDerivation rec {
  pname = "tmate";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner  = "tmate-io";
    repo   = "tmate";
    rev    = version;
    sha256 = "0fwqhmkp1jfp8qk7497ws3nzvly7p06mv04z8z0qicn6a961v1sa";
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
