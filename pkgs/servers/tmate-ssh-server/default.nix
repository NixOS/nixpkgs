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
, msgpack
, libssh
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "tmate-ssh-server";
  version = "unstable-2021-10-17";

  src = fetchFromGitHub {
    owner = "tmate-io";
    repo = "tmate-ssh-server";
    rev = "1f314123df2bb29cb07427ed8663a81c8d9034fd";
    sha256 = "sha256-9/xlMvtkNWUBRYYnJx20qEgtEcjagH2NtEKZcDOM1BY=";
  };

  dontUseCmakeConfigure = true;

  buildInputs = [ libtool zlib openssl libevent ncurses ruby msgpack libssh ];
  nativeBuildInputs = [ autoreconfHook cmake pkg-config ];

  passthru.tests.tmate-ssh-server = nixosTests.tmate-ssh-server;

  meta = with lib; {
    homepage = "https://tmate.io/";
    description = "tmate SSH Server";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ck3d ];
  };
}
