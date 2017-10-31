{stdenv, fetchurl, SDL, SDL_image, SDL_mixer, SDL_net }:

stdenv.mkDerivation rec {
  name = "njam-1.25";

  src = fetchurl {
    url = mirror://sourceforge/njam/njam-1.25-src.tar.gz;
    sha256 = "0ysvqw017xkvddj957pdfmbmji7qi20nyr7f0zxvcvm6c7d3cc7s";
  };

  preBuild = ''
    rm src/*.o
  '';

  buildInputs = [ SDL SDL_image SDL_mixer SDL_net ];

  hardeningDisable = [ "format" ];

  patches = [ ./logfile.patch ];

  meta = {
    homepage = http://trackballs.sourceforge.net/;
    description = "Cross-platform pacman-like game";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
