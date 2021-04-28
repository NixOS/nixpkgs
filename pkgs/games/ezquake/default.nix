{ lib, stdenv, fetchFromGitHub, curl, expat
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
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    expat curl jansson libpng libjpeg libGLU libGL libXxf86vm pcre SDL2 vim speex
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
    homepage = "http://ezquake.github.io/";
    description = "A modern QuakeWorld client focused on competitive online play";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ edwtjo ];
  };
}
