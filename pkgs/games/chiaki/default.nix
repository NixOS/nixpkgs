{ lib, mkDerivation, fetchgit
, cmake, ffmpeg, libopus, qtbase, qtmultimedia, qtsvg, pkg-config, protobuf
, python3Packages, SDL2 }:

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
    cmake pkg-config protobuf python3Packages.python python3Packages.protobuf
  ];
  buildInputs = [ ffmpeg libopus qtbase qtmultimedia qtsvg protobuf SDL2 ];

  doCheck = true;
  installCheckPhase = "$out/bin/chiaki --help";

  meta = with lib; {
    homepage = "https://github.com/thestr4ng3r/chiaki";
    description = "Free and Open Source PS4 Remote Play Client";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ delroth ];
    platforms = platforms.all;
  };
}
