{ lib, mkDerivation, fetchFromGitHub
, cmake, ffmpeg, libopus, qtbase, qtmultimedia, qtsvg, pkgconfig, protobuf
, python3Packages, SDL2 }:

mkDerivation rec {
  pname = "chiaki";
  version = "1.3.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "thestr4ng3r";
    repo = "chiaki";
    fetchSubmodules = true;
    sha256 = "07w7srxxr8zjp91p5n1sqf4j8lljfrm78lz1m15s2nzlm579015h";
  };

  nativeBuildInputs = [
    cmake pkgconfig protobuf python3Packages.python python3Packages.protobuf
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
