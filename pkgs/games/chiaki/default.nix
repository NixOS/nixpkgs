{ lib, stdenv
, fetchgit
, cmake
, pkg-config
, protobuf
, python3Packages
, ffmpeg
, libopus
, mkDerivation
, qtbase
, qtmultimedia
, qtsvg
, SDL2
, libevdev
, udev
, qtmacextras
}:

mkDerivation rec {
  pname = "chiaki";
<<<<<<< HEAD
  version = "2.2.0";
=======
  version = "2.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchgit {
    url = "https://git.sr.ht/~thestr4ng3r/chiaki";
    rev = "v${version}";
    fetchSubmodules = true;
<<<<<<< HEAD
    hash = "sha256-mLx2ygMlIuDJt9iT4nIj/dcLGjMvvmneKd49L7C3BQk=";
=======
    sha256 = "sha256-VkCA8KS4EHuVSgoYt1YDT38hA1NEBckiBwRcgDZUSs4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
    python3Packages.protobuf
    python3Packages.python
<<<<<<< HEAD
    python3Packages.setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    ffmpeg
    libopus
    qtbase
    qtmultimedia
    qtsvg
    protobuf
    SDL2
  ] ++ lib.optionals stdenv.isLinux [
    libevdev
    udev
  ] ++ lib.optionals stdenv.isDarwin [
    qtmacextras
  ];

  doCheck = true;

  installCheckPhase = "$out/bin/chiaki --help";

  meta = with lib; {
    homepage = "https://git.sr.ht/~thestr4ng3r/chiaki";
    description = "Free and Open Source PlayStation Remote Play Client";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ delroth ];
    platforms = platforms.all;
<<<<<<< HEAD
    mainProgram = "chiaki";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
