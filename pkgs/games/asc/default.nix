{ fetchurl, stdenv, SDL, SDL_image, SDL_mixer, SDL_sound, libsigcxx, physfs
, boost, expat, freetype, libjpeg, wxGTK, lua, perl, pkgconfig, zlib, zip, bzip2,
libpng }:

stdenv.mkDerivation rec {
  name = "asc-2.4.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/asc-hq/${name}.tar.bz2";
    sha256 = "1r011l4gsliky6szjvda8xzyhkkc50ahrr7p14911v5ydar0w3hh";
  };

  configureFlags = [ "--disable-paragui" "--disable-paraguitest" ];

  NIX_CFLAGS_COMPILE = "-fpermissive"; # I'm too lazy to catch all gcc47-related problems

  buildInputs = [
    SDL SDL_image SDL_mixer SDL_sound libsigcxx physfs boost expat freetype
    libjpeg wxGTK lua perl pkgconfig zlib zip bzip2 libpng
  ];

  meta = {
    description = "Turn based strategy game";

    longDescription = ''
      Advanced Strategic Command is a free, turn based strategy game. It is
      designed in the tradition of the Battle Isle series from Bluebyte and is
      currently available for Windows and Linux. 
    '';

    homepage = http://www.asc-hq.org/;

    license = "GPLv2+";

    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
