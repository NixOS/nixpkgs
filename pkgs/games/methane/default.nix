{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  fontconfig,
  freealut,
  libglut,
  gettext,
  libGL,
  libGLU,
  openal,
  quesoglc,
  clanlib,
  libXrender,
  libmikmod,
  alsa-lib,
}:

stdenv.mkDerivation rec {
  pname = "methane";
  version = "2.0.1";

  src = fetchFromGitHub {
    repo = "methane";
    owner = "rombust";
    rev = "v${version}";
    sha256 = "sha256-STS2+wfZ8E1jpr0PYQOBQsztxhJU0Dt3IhWBE3sjdWE=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
  ];
  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    fontconfig
    freealut
    libglut
    libGL
    libGLU
    openal
    quesoglc
    clanlib
    libXrender
    libmikmod
    alsa-lib
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin/ $out/share/methane/ $out/share/docs/
    cp methane $out/bin
    cp -r resources/* $out/share/methane/.
    cp -r docs/* $out/share/docs/.
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/rombust/methane";
    description = "Clone of Taito's Bubble Bobble arcade game released for Amiga in 1993 by Apache Software";
    mainProgram = "methane";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ nixinator ];
    platforms = [ "x86_64-linux" ];
  };
}
