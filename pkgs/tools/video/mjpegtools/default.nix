{ stdenv, fetchurl, gtk, libdv, libjpeg, libpng, libX11, pkgconfig, SDL, SDL_gfx }:

# TODO:
# - make dependencies optional
# - libpng-apng as alternative to libpng?
# - libXxf86dga support? checking for XF86DGAQueryExtension in -lXxf86dga... no

stdenv.mkDerivation rec {
  name = "mjpegtools-2.0.0";
  src = fetchurl {
    url = "mirror://sourceforge/mjpeg/${name}.tar.gz";
    sha256 = "bf3541593e71602f7b440c2e7d81b433f53d0511e74642f35bea9b3feded7a97";
  };
  buildInputs = [ gtk libdv libjpeg libpng libX11 pkgconfig SDL SDL_gfx ];
}
