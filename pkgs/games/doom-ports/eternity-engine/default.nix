{
  lib,
  stdenv,
  cmake,
  libGL,
  SDL2,
  SDL2_mixer,
  SDL2_net,
  fetchFromGitHub,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "eternity-engine";
  version = "4.02.00";
  src = fetchFromGitHub {
    owner = "team-eternity";
    repo = "eternity";
    rev = version;
    sha256 = "0dlz7axbiw003bgwk2hl43w8r2bwnxhi042i1xwdiwaja0cpnf5y";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];
  buildInputs = [
    libGL
    SDL2
    SDL2_mixer
    SDL2_net
  ];

  installPhase = ''
    install -Dm755 eternity/eternity $out/lib/eternity/eternity
    cp -r $src/base $out/lib/eternity/base
    mkdir $out/bin
    makeWrapper $out/lib/eternity/eternity $out/bin/eternity
  '';

  meta = {
    homepage = "https://doomworld.com/eternity";
    description = "New school Doom port by James Haley";
    mainProgram = "eternity";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
