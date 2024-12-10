{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  coreutils,
  portaudio,
  libbsd,
  libpng,
  libvorbis,
  SDL2,
  makeWrapper,
  lua5_2,
  glew,
  openssl,
  picotts,
  alsa-utils,
  espeak-classic,
  sox,
  libopus,
  openscad,
  libxcrypt,
}:

stdenv.mkDerivation {
  pname = "snis_launcher";
  version = "unstable-2021-10-17";

  src = fetchFromGitHub {
    owner = "smcameron";
    repo = "space-nerds-in-space";
    rev = "e70d3c63e33c940feb53c8d818ce2d8ea2aadf00";
    sha256 = "sha256-HVCb1iFn7GWNpedtFCgLyd0It8s4PEmUwDfb8ap1TDc=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "OPUSARCHIVE=libopus.a" "OPUSARCHIVE=" \
      --replace "-I./opus-1.3.1/include" "-I${libopus.dev}/include/opus"
    substituteInPlace snis_launcher \
      --replace "PREFIX=." "PREFIX=$out"
    substituteInPlace snis_text_to_speech.sh \
      --replace "pico2wave" "${sox}/bin/pico2wave" \
      --replace "espeak" "${espeak-classic}/bin/espeak" \
      --replace "play" "${sox}/bin/play" \
      --replace "aplay" "${alsa-utils}/bin/aplay" \
      --replace "/bin/rm" "${coreutils}/bin/rm"
  '';

  nativeBuildInputs = [
    pkg-config
    openscad
    makeWrapper
  ];
  buildInputs = [
    coreutils
    portaudio
    libbsd
    libpng
    libvorbis
    SDL2
    lua5_2
    glew
    openssl
    picotts
    sox
    alsa-utils
    libopus
    libxcrypt
  ];

  postBuild = ''
    make models -j$NIX_BUILD_CORES
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R share $out/share
    cp -R bin $out/bin
    cp snis_launcher $out/bin/
    # without this, snis_client crashes on Wayland
    wrapProgram $out/bin/snis_client --set SDL_VIDEODRIVER x11
    runHook postInstall
  '';

  meta = with lib; {
    description = "Space Nerds In Space, a multi-player spaceship bridge simulator";
    homepage = "https://smcameron.github.io/space-nerds-in-space/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ alyaeanyx ];
    platforms = platforms.linux;
  };
}
