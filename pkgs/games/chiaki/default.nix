{ lib, mkDerivation, fetchFromGitHub
, cmake, ffmpeg, libopus, qtbase, qtmultimedia, qtsvg, pkgconfig, protobuf
, python3Packages, SDL2 }:

mkDerivation rec {
  pname = "chiaki";
  version = "1.2.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "thestr4ng3r";
    repo = "chiaki";
    fetchSubmodules = true;
    sha256 = "00lzsbjd1w1bhlblgf7zp112sk8ac09c3bzi5ljxbn02mi0an3qp";
  };

  nativeBuildInputs = [
    cmake pkgconfig protobuf python3Packages.python python3Packages.protobuf
  ];
  buildInputs = [ ffmpeg libopus qtbase qtmultimedia qtsvg protobuf SDL2 ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/thestr4ng3r/chiaki";
    description = "Free and Open Source PS4 Remote Play Client";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ delroth ];
    platforms = platforms.all;
  };
}
