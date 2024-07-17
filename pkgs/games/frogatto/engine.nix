{
  lib,
  stdenv,
  fetchFromGitHub,
  which,
  boost,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
  glew,
  zlib,
  icu,
  pkg-config,
  cairo,
  libvpx,
  glm,
}:

stdenv.mkDerivation {
  pname = "anura-engine";
  version = "unstable-2023-02-27";

  src = fetchFromGitHub {
    owner = "anura-engine";
    repo = "anura";
    rev = "65d85b6646099db1d5cd25d31321bb434a3f94f1";
    sha256 = "sha256-hb4Sn7uI+eXLaGb4zkEy4w+ByQJ6FqkoMUYFsyiFCeE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    which
    pkg-config
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
    glm
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
