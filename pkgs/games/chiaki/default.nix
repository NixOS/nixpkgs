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
  version = "2.2.0";

  src = fetchgit {
    url = "https://git.sr.ht/~thestr4ng3r/chiaki";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-mLx2ygMlIuDJt9iT4nIj/dcLGjMvvmneKd49L7C3BQk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
    python3Packages.protobuf
    python3Packages.python
    python3Packages.setuptools
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
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
    mainProgram = "chiaki";
  };
}
