{ fetchurl, stdenv, mesa, freeglut, libX11, plib, openal, freealut, libXrandr, xproto,
libXext, libSM, libICE, libXi, libXt, libXrender, libXxf86vm,
libpng, zlib, bash }:

stdenv.mkDerivation rec {
  name = "torcs-1.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/torcs/${name}.tar.bz2";
    sha256 = "1zai7nrx93pcv24r3fkr08831szj7vz3a6xy8fihlv6wvfnpn6wh";
  };

  patchPhase = ''
    sed -i -e s,/bin/bash,`type -P bash`, src/linux/torcs.in
  '';

  buildInputs = [ mesa freeglut libX11 plib openal freealut libXrandr xproto
    libXext libSM libICE libXi libXt libXrender libXxf86vm libpng zlib bash ];

  installTargets = "install datainstall";

  meta = {
    description = "Car racing game";
    homepage = http://torcs.sourceforge.net/;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
