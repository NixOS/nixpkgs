{ fetchurl, lib, stdenv, SDL, SDL_image, SDL_mixer, SDL_sound, libsigcxx, physfs
, boost, expat, freetype, libjpeg, wxGTK, lua, perl, pkg-config, zlib, zip, bzip2
, libpng, libtiff, fluidsynth, libmikmod, libvorbis, flac, libogg }:

stdenv.mkDerivation rec {
  pname = "asc";
  version = "2.6.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/asc-hq/asc-${version}.tar.bz2";
    sha256 = "1fybasb6srqfg6pqbvh0s0vvzjq9r0n6aq0z44hs7n68kmaam775";
  };

  configureFlags = [ "--disable-paragui" "--disable-paraguitest" ];

  NIX_CFLAGS_COMPILE = "-fpermissive -Wno-error=narrowing -std=c++11"; # I'm too lazy to catch all gcc47-related problems
  hardeningDisable = [ "format" ];

  buildInputs = [
    SDL SDL_image SDL_mixer SDL_sound libsigcxx physfs boost expat
    freetype libjpeg wxGTK lua perl pkg-config zlib zip bzip2 libpng
    libtiff fluidsynth libmikmod flac libvorbis libogg
  ];

  meta = with lib; {
    description = "Turn based strategy game";

    longDescription = ''
      Advanced Strategic Command is a free, turn based strategy game. It is
      designed in the tradition of the Battle Isle series from Bluebyte and is
      currently available for Windows and Linux.
    '';

    homepage = "https://www.asc-hq.org/";

    license = licenses.gpl2Plus;

    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
