{ lib, stdenv, fetchFromGitHub, curl, expat
, jansson, libpng, libjpeg, libGLU, libGL
, libsndfile, libXxf86vm, pcre, pkg-config, SDL2
, vim, speex }:

stdenv.mkDerivation rec {
  pname = "ezquake";
  version = "3.6.3";

  src = fetchFromGitHub {
    owner = "QW-Group";
    repo = pname + "-source";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-ThrsJfj+eP7Lv2ZSNLO6/b98VHrL6/rhwf2p0qMvTF8=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    expat curl jansson libpng libjpeg libGLU libGL libsndfile libXxf86vm pcre SDL2 vim speex
  ];

  installPhase = let
    sys = lib.last (lib.splitString "-" stdenv.hostPlatform.system);
    arch = lib.head (lib.splitString "-" stdenv.hostPlatform.system);
  in ''
    mkdir -p $out/bin
    find .
    mv ezquake-${sys}-${arch} $out/bin/ezquake
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "https://ezquake.com/";
    description = "Modern QuakeWorld client focused on competitive online play";
    mainProgram = "ezquake";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ edwtjo ];
  };
}
