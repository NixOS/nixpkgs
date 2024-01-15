{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, cmake
, libtool
, pkg-config
, zlib
, openssl
, libevent
, ncurses
, ruby
, msgpack-c
, libssh
}:

stdenv.mkDerivation {
  pname = "tmate";
  version = "unstable-2022-08-07";

  src = fetchFromGitHub {
    owner  = "tmate-io";
    repo   = "tmate";
    rev    = "ac919516f4f1b10ec928e20b3a5034d18f609d68";
    sha256 = "sha256-t96gfmAMcsjkGf8pvbEx2fNx4Sj3W6oYoQswB3Dklb8=";
  };

  postPatch = ''
    substituteInPlace configure.ac \
      --replace 'msgpack >= 1.1.0' 'msgpack-c >= 1.1.0'
  '';

  nativeBuildInputs = [
    autoreconfHook
    cmake
    pkg-config
  ];

  buildInputs = [
    libtool
    zlib
    openssl
    libevent
    ncurses
    ruby
    msgpack-c
    libssh
  ];

  dontUseCmakeConfigure = true;

  meta = with lib; {
    homepage    = "https://tmate.io/";
    description = "Instant Terminal Sharing";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ ck3d ];
    mainProgram = "tmate";
  };
}
