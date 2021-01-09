{ stdenv
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
  version = "2.0.1";

  src = fetchgit {
    url = "https://git.sr.ht/~thestr4ng3r/chiaki";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "0l532i9j6wmzbxqx7fg69kgfd1zy1r1wlw6f756vpxpgswivi892";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
    python3Packages.protobuf
    python3Packages.python
  ];

  buildInputs = [
    ffmpeg
    libopus
    qtbase
    qtmultimedia
    qtsvg
    protobuf
    SDL2
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    libevdev
    udev
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    qtmacextras
  ];

  doCheck = true;

  installCheckPhase = "$out/bin/chiaki --help";

  meta = with stdenv.lib; {
    homepage = "https://git.sr.ht/~thestr4ng3r/chiaki";
    description = "Free and Open Source PlayStation Remote Play Client";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ delroth ];
    platforms = platforms.all;
  };
}
