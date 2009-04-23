{stdenv, fetchurl, mesa, openal, autoconf, automake, libtool, freealut, wxGTK,
freetype, fftw, SDL, SDL_net, zlib, libpng, libjpeg} :

stdenv.mkDerivation {
  name = "scorched3d-42.1";
  src = fetchurl {
    url = mirror://sourceforge/scorched3d/Scorched3D-42.1-src.tar.gz;
    sha256 = "0vhhi68ii5ldxbacsiqccsascrn3q033hnaa1ha8r9gxspzcqkl8";
  };

  buildInputs = [ mesa openal autoconf automake libtool freealut wxGTK
    freetype fftw SDL SDL_net zlib libpng libjpeg ];

  unpackPhase = "tar xvzf $src ; cd scorched";

  patches = [ ./scorched3d-42.1-fixups.patch ./file-existence.patch ];

  preConfigure = ''
    set +e
    aclocal
    libtoolize --copy --force
    autoconf
    automake
    libtoolize
    set -e
  '';

  meta = {
    homepage = http://scorched3d.co.uk/;
    description = "3D Clone of the classic Scorched Earth";
    license = "GPLv2+";
  };
}
