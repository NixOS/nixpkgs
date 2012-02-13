{ stdenv, fetchurl, SDL, SDL_mixer, SDL_image, SDL_ttf, SDL_gfx, freetype
, pkgconfig, fontconfig, libzip, zip, zlib }:

stdenv.mkDerivation rec {
  name = "freeciv-2.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/freeciv/${name}.tar.bz2";
    sha256 = "1n3ak0y9hj9kha0r3cdbi8zb47vrgal1jsbblamqgwwwgzy8cri3";
  };

  buildInputs = [ SDL SDL_mixer SDL_image SDL_ttf SDL_gfx freetype pkgconfig fontconfig libzip zip zlib] ;

  meta = with stdenv.lib; {
    description = "multiplayer (or single player), turn-based strategy game.";

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
