{ stdenv, fetchurl, zlib, bzip2, pkgconfig, curl, lzma, gettext
, sdlClient ? true, SDL, SDL_mixer, SDL_image, SDL_ttf, SDL_gfx, freetype
, gtkClient ? false, gtk
, server ? true, readline }:

let
  inherit (stdenv.lib) optional optionals;
  client = sdlClient || gtkClient;
in
stdenv.mkDerivation rec {
  name = "freeciv-2.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/freeciv/${name}.tar.bz2";
    sha256 = "1bc01pyihsrby6w95n49gi90ggp40dyxsy4kmlmwcakxfxprwakv";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ zlib bzip2 curl lzma gettext ]
    ++ optionals sdlClient [ SDL SDL_mixer SDL_image SDL_ttf SDL_gfx freetype ]
    ++ optional gtkClient gtk
    ++ optional server readline;

  meta = with stdenv.lib; {
    description = "Multiplayer (or single player), turn-based strategy game";

    longDescription = ''
      Freeciv is a Free and Open Source empire-building strategy game
      inspired by the history of human civilization. The game commences in
      prehistory and your mission is to lead your tribe from the stone age
      to the space age...
    '';

    homepage = http://freeciv.wikia.com/;
    license = licenses.gpl2;

    maintainers = with maintainers; [ pierron ];
    platforms = with platforms; linux;
  };
}
