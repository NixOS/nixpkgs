{ stdenv, fetchurl, cmake, ffmpeg, imagemagick, libzip, pkgconfig, qt53, SDL2 }:

stdenv.mkDerivation rec {
  name = "mgba-0.3.0";
  src = fetchurl {
    url = https://github.com/mgba-emu/mgba/archive/0.3.0.tar.gz;
    sha256 = "02zz6bdcwr1fx7i7dacff0s8mwp0pvabycp282qvhhx44x44q7fm";
  };

  buildInputs = [ cmake ffmpeg imagemagick libzip pkgconfig qt53 SDL2 ];

  enableParallelBuilding = true;

  meta = {
    homepage = https://endrist.com/mgba/;
    description = "A modern GBA emulator with a focus on accuracy";
    license = stdenv.lib.licenses.mpl20;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}

