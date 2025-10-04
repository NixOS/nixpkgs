{
  lib,
  stdenv,
  fetchgit,
  cmake,
  pkg-config,
  ffmpeg,
  libopus,
  mkDerivation,
  qtbase,
  qtmultimedia,
  qtsvg,
  SDL2,
  libevdev,
  udev,
  qtmacextras,
  nanopb,
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
  ];

  buildInputs = [
    ffmpeg
    libopus
    qtbase
    qtmultimedia
    qtsvg
    SDL2
    nanopb
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libevdev
    udev
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    qtmacextras
  ];

  doCheck = true;

  installCheckPhase = "$out/bin/chiaki --help";

  meta = with lib; {
    homepage = "https://git.sr.ht/~thestr4ng3r/chiaki";
    description = "Free and Open Source PlayStation Remote Play Client";
    license = licenses.agpl3Only;
    maintainers = [ ];
    platforms = platforms.all;
    mainProgram = "chiaki";
  };
}
