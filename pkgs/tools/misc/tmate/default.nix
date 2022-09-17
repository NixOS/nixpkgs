{ lib, stdenv, fetchFromGitHub, autoreconfHook, cmake, libtool, pkg-config
, zlib, openssl, libevent, ncurses, ruby, msgpack, libssh }:

stdenv.mkDerivation rec {
  pname = "tmate";
  version = "unstable-2022-08-07";

  src = fetchFromGitHub {
    owner  = "tmate-io";
    repo   = "tmate";
    rev    = "ac919516f4f1b10ec928e20b3a5034d18f609d68";
    sha256 = "sha256-t96gfmAMcsjkGf8pvbEx2fNx4Sj3W6oYoQswB3Dklb8=";
  };

  dontUseCmakeConfigure = true;

  buildInputs = [ libtool zlib openssl libevent ncurses ruby msgpack libssh ];
  nativeBuildInputs = [ autoreconfHook cmake pkg-config ];

  meta = with lib; {
    homepage    = "https://tmate.io/";
    description = "Instant Terminal Sharing";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ ck3d ];
  };
}
