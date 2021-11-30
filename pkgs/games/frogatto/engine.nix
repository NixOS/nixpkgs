{ lib, stdenv, fetchFromGitHub, which
, boost, SDL2, SDL2_image, SDL2_mixer, SDL2_ttf
, glew, zlib, icu, pkg-config, cairo, libvpx }:

stdenv.mkDerivation {
  pname = "anura-engine";
  version = "unstable-2021-11-23";

  src = fetchFromGitHub {
    owner = "anura-engine";
    repo = "anura";
    rev = "816425df31624066e2815e26a25b1c5d3d355cb4";
    sha256 = "1k7fnfgz003gcbyygv4aakhkkz3w3z9nyz7dlwz01xa6122zqyir";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    which pkg-config
  ];

  buildInputs = [
    boost
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    glew
    zlib
    icu
    cairo
    libvpx
  ];

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin $out/share/frogatto
    cp -ar data images modules $out/share/frogatto/
    cp -a anura $out/bin/frogatto
  '';

  meta = with lib; {
    homepage = "https://github.com/anura-engine/anura";
    description = "Game engine used by Frogatto";
    license = licenses.zlib;
    platforms = platforms.linux;
    maintainers = with maintainers; [ astro ];
  };
}
