{ fetchurl, stdenv, mesa, freeglut, libX11, plib, openal, freealut, libXrandr, xproto,
libXext, libSM, libICE, libXi, libXt, libXrender, libXxf86vm, libvorbis,
libpng, zlib, bash, makeWrapper }:

stdenv.mkDerivation rec {
  name = "torcs-1.3.7";

  src = fetchurl {
    url = "mirror://sourceforge/torcs/${name}.tar.bz2";
    sha256 = "0kdq0sc7dsfzlr0ggbxggcbkivc6yp30nqwjwcaxg9295s3b06wa";
  };

  patchPhase = ''
    sed -i -e s,/bin/bash,`type -P bash`, src/linux/torcs.in
  '';

  buildInputs = [ mesa freeglut libX11 plib openal freealut libXrandr xproto
    libXext libSM libICE libXi libXt libXrender libXxf86vm libpng zlib libvorbis makeWrapper ];

  nativeBuildInputs = [ bash ];

  installTargets = "install datainstall";

  hardeningDisable = [ "format" ];

  postInstall = ''
    wrapProgram $out/bin/torcs \
      --prefix LD_LIBRARY_PATH : ${mesa}/lib
  '';

  meta = {
    description = "Car racing game";
    homepage = http://torcs.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };
}
