{ fetchurl, stdenv, mesa, freeglut, libX11, plib, openal, freealut, libXrandr, xproto,
libXext, libSM, libICE, libXi, libXt, libXrender, libXxf86vm,
libpng, zlib, bash, p7zip, SDL, enet, libjpeg, cmake}:

stdenv.mkDerivation rec {
  version = "2.0.0-a3-r3412";
  name = "speed-dreams-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/speed-dreams/2.0.0/${name}-src.tar.7z";
    sha256 = "0hn5fgn90wmd1xha1la133harx47qc647f4zj8hfdvd7wb3kpjab";
  };

  unpackPhase = ''
    7z e -so ${src} | tar -x 
    cd */
  '';

  # Order important; it wants libpng12 and some x libs propagate libpng15
  buildInputs = [ libpng mesa freeglut libX11 plib openal freealut libXrandr xproto
    libXext libSM libICE libXi libXt libXrender libXxf86vm zlib bash 
    p7zip SDL enet libjpeg cmake ];

  installTargets = "install";

  dontUseCmakeBuildDir=true;

  meta = {
    description = "Car racing game - TORCS fork with more experimental approach";
    homepage = http://speed-dreams.sourceforge.net/;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric raskin];
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };
}
