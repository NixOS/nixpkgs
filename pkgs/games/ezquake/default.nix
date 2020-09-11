{ stdenv, fetchFromGitHub, curl, expat
, jansson, libpng, libjpeg, libGLU, libGL, libXxf86vm, pcre
, pkgconfig, SDL2, vim, speex }:

stdenv.mkDerivation rec {
  pname = "ezquake";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "ezQuake";
    repo = pname + "-source";
    rev = version;
    sha256 = "11kyrqpc8w393kvfz2p2h2m7k8rm4w644m86w733b8w157f2fsk0";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    expat curl jansson libpng libjpeg libGLU libGL libXxf86vm pcre SDL2 vim speex
  ];

  installPhase = with stdenv.lib; let
    sys = last (splitString "-" stdenv.hostPlatform.system);
    arch = head (splitString "-" stdenv.hostPlatform.system);
  in ''
    mkdir -p $out/bin
    find .
    mv ezquake-${sys}-${arch} $out/bin/ezquake
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "http://ezquake.github.io/";
    description = "A modern QuakeWorld client focused on competitive online play";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ edwtjo ];
  };
}
