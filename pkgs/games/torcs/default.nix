{ fetchurl, stdenv, mesa, freeglut, libX11, plib, openal, freealut, libXrandr, xproto,
libXext, libSM, libICE, libXi, libXt, libXrender, libXxf86vm, libvorbis,
libpng, zlib, bash }:

stdenv.mkDerivation rec {
  name = "torcs-1.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/torcs/${name}.tar.bz2";
    sha256 = "0171ixhnd9cs8jkwa5awrxklfgyykcbc9m8270b8cw30lsx7qhp1";
  };

  patchPhase = ''
    sed -i -e s,/bin/bash,`type -P bash`, src/linux/torcs.in
  '';

  buildInputs = [ mesa freeglut libX11 plib openal freealut libXrandr xproto
    libXext libSM libICE libXi libXt libXrender libXxf86vm libpng zlib libvorbis ];

  nativeBuildInputs = [ bash ];

  installTargets = "install datainstall";

  meta = {
    description = "Car racing game";
    homepage = http://torcs.sourceforge.net/;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    #platforms = with stdenv.lib.platforms; linux;
  };
}
