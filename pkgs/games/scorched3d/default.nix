{stdenv, fetchurl, mesa, openal, autoconf, automake, libtool, freealut, wxGTK,
freetype, fftwSinglePrec, SDL, SDL_net, zlib, libpng, libjpeg, pkgconfig, libogg,
libvorbis} :

stdenv.mkDerivation {
  name = "scorched3d-43.2a";
  src = fetchurl {
    url = mirror://sourceforge/scorched3d/Scorched3D-43.2a-src.tar.gz;
    sha256 = "1hv1mnfb7y51hqmg95l8rx00j66ff32ddxxi5zgfyw92hsvahgxi";
  };

  buildInputs =
    [ mesa openal freealut wxGTK freetype fftwSinglePrec SDL_net zlib libpng libjpeg
    libogg libvorbis ];

  nativeBuildInputs = [ pkgconfig ];

  patches = [ ./file-existence.patch ];

  sourceRoot = "scorched";

  configureFlags = "--with-fftw=${fftwSinglePrec}";

# Fake openal-config
  preConfigure =
    ''
      mkdir -pv mybin
      export PATH=$PATH:$PWD/mybin
      echo -e "#!/bin/sh\npkg-config openal \"$@\"" > mybin/openal-config
      chmod +x mybin/openal-config
    '';

  meta = {
    homepage = http://scorched3d.co.uk/;
    description = "3D Clone of the classic Scorched Earth";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
