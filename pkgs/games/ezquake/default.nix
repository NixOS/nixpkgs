{ lib, stdenv, fetchFromGitHub, curl, expat
, jansson, libpng, libjpeg, libGLU, libGL
, libsndfile, libXxf86vm, pcre, pkg-config, SDL2
, vim, speex }:

stdenv.mkDerivation rec {
  pname = "ezquake";
  version = "3.6.2";

  src = fetchFromGitHub {
    owner = "QW-Group";
    repo = pname + "-source";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-mi/VDSZ+ybEAaZOhBGh/cSnrRUAB/h+WQZ4Aml0UfW4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    expat curl jansson libpng libjpeg libGLU libGL libsndfile libXxf86vm pcre SDL2 vim speex
  ];

  installPhase = with lib; let
    sys = last (splitString "-" stdenv.hostPlatform.system);
    arch = head (splitString "-" stdenv.hostPlatform.system);
  in ''
    mkdir -p $out/bin
    find .
    mv ezquake-${sys}-${arch} $out/bin/ezquake
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://ezquake.com/";
    description = "A modern QuakeWorld client focused on competitive online play";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ edwtjo ];
  };
}
