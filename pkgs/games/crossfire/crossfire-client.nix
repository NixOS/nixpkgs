{
  stdenv,
  lib,
  fetchgit,
  cmake,
  pkg-config,
  perl,
  vala,
  gtk2,
  pcre,
  zlib,
  libGL,
  libGLU,
  libpng,
  fribidi,
  harfbuzzFull,
  xorg,
  util-linux,
  curl,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  libselinux,
  libsepol,
  version,
  rev,
  hash,
}:

stdenv.mkDerivation {
  pname = "crossfire-client";
  version = rev;

  src = fetchgit {
    url = "https://git.code.sf.net/p/crossfire/crossfire-client";
    inherit hash rev;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    perl
    vala
  ];
  buildInputs = [
    gtk2
    pcre
    zlib
    libGL
    libGLU
    libpng
    fribidi
    harfbuzzFull
    xorg.libpthreadstubs
    xorg.libXdmcp
    curl
    SDL2
    SDL2_image
    SDL2_mixer
    util-linux
    libselinux
    libsepol
  ];
  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "GTKv2 client for the Crossfire free MMORPG";
    mainProgram = "crossfire-client-gtk2";
    homepage = "http://crossfire.real-time.com/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
