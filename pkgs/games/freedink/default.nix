{ stdenv, fetchurl, SDL, SDL_mixer, SDL_image, SDL_ttf, SDL_gfx
, pkgconfig, intltool, fontconfig, libzip, zip, zlib }:

let
  version = "1.08.20121209";

  freedink_data = stdenv.mkDerivation rec {
    name = "freedink-data-${version}";

    src = fetchurl {
      url = "mirror://gnu/freedink/${name}.tar.gz";
      sha256 = "1mhns09l1s898x18ahbcy9gabrmgsr8dv7pm0a2ivid8mhxahn1j";
    };

    prePatch = "substituteInPlace Makefile --replace /usr/local $out";
  };

in stdenv.mkDerivation rec {
  name = "freedink-${version}";

  src = fetchurl {
    url = "mirror://gnu/freedink/${name}.tar.gz";
    sha256 = "19xximbcm6506kvpf3s0q96697kmzca3yrjdr6dgphklp33zqsqr";
  };

  buildInputs = [
    SDL SDL_mixer SDL_image SDL_ttf SDL_gfx
    pkgconfig intltool fontconfig libzip zip zlib
  ];

  postInstall = ''
    mkdir -p "$out/share/"
    ln -s ${freedink_data}/share/dink "$out/share/"
  '';

  meta = {
    description = "A free, portable and enhanced version of the Dink Smallwood game engine";

    longDescription = ''
      GNU FreeDink is a new and portable version of the Dink Smallwood
      game engine, which runs the original game as well as its D-Mods,
      with close compatibility, under multiple platforms.
    '';

    homepage = http://www.freedink.org/;
    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [ stdenv.lib.maintainers.bjg ];
    platforms = stdenv.lib.platforms.all;
  };
}
