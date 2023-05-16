{ lib, stdenv, fetchFromGitHub, curl, expat
<<<<<<< HEAD
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
=======
, jansson, libpng, libjpeg, libGLU, libGL, libXxf86vm, pcre
, pkg-config, SDL2, vim, speex }:

stdenv.mkDerivation rec {
  pname = "ezquake";
  version = "3.2.3";

  src = fetchFromGitHub {
    owner = "ezQuake";
    repo = pname + "-source";
    rev = version;
    sha256 = "sha256-EBhKmoX11JavTG6tPfg15FY2lqOFfzSDg3058OWfcYQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
<<<<<<< HEAD
    expat curl jansson libpng libjpeg libGLU libGL libsndfile libXxf86vm pcre SDL2 vim speex
=======
    expat curl jansson libpng libjpeg libGLU libGL libXxf86vm pcre SDL2 vim speex
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    homepage = "https://ezquake.com/";
=======
    homepage = "http://ezquake.github.io/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "A modern QuakeWorld client focused on competitive online play";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ edwtjo ];
  };
}
