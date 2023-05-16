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
<<<<<<< HEAD
, msgpack-c
=======
, msgpack
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, libssh
, nixosTests
}:

<<<<<<< HEAD
stdenv.mkDerivation {
  pname = "tmate-ssh-server";
  version = "unstable-2023-06-02";
=======
stdenv.mkDerivation rec {
  pname = "tmate-ssh-server";
  version = "unstable-2021-10-17";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tmate-io";
    repo = "tmate-ssh-server";
<<<<<<< HEAD
    rev = "d7334ee4c3c8036c27fb35c7a24df3a88a15676b";
    sha256 = "sha256-V3p0vagt13YjQPdqpbSatx5DnIEXL4t/kfxETSFYye0=";
  };

  postPatch = ''
    substituteInPlace configure.ac \
      --replace 'msgpack >= 1.2.0' 'msgpack-c >= 1.2.0'
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

=======
    rev = "1f314123df2bb29cb07427ed8663a81c8d9034fd";
    sha256 = "sha256-9/xlMvtkNWUBRYYnJx20qEgtEcjagH2NtEKZcDOM1BY=";
  };

  dontUseCmakeConfigure = true;

  buildInputs = [ libtool zlib openssl libevent ncurses ruby msgpack libssh ];
  nativeBuildInputs = [ autoreconfHook cmake pkg-config ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  passthru.tests.tmate-ssh-server = nixosTests.tmate-ssh-server;

  meta = with lib; {
    homepage = "https://tmate.io/";
    description = "tmate SSH Server";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ck3d ];
  };
}
