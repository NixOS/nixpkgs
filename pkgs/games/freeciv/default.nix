{ stdenv, fetchurl, zlib, bzip2, pkgconfig, curl, lzma, gettext
, sdlClient ? true, SDL, SDL_mixer, SDL_image, SDL_ttf, SDL_gfx, freetype, fluidsynth
, gtkClient ? false, gtk
, server ? true, readline }:

let
  inherit (stdenv.lib) optional optionals;

  sdlName = if sdlClient then "-sdl" else "";
  gtkName = if gtkClient then "-gtk" else "";

  name = "freeciv";
  version = "2.5.0";
in
stdenv.mkDerivation {
  name = "${name}${sdlName}${gtkName}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/freeciv/${name}-${version}.tar.bz2";
    sha256 = "bd9f7523ea79b8d2806d0c1844a9f48506ccd18276330580319913c43051210b";
    # sha1 = "477b60e02606e47b31a019b065353c1a6da6c305";
    # md5 = "8a61ecd986853200326711446c573f1b";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ zlib bzip2 curl lzma gettext ]
    ++ optionals sdlClient [ SDL SDL_mixer SDL_image SDL_ttf SDL_gfx freetype fluidsynth ]
    ++ optionals gtkClient [ gtk ]
    ++ optional server readline;

  configureFlags = []
    ++ optional sdlClient "--enable-client=sdl"
    ++ optional (!gtkClient) "--enable-fcmp=cli"
    ++ optional (!server) "--disable-server";

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
    platforms = platforms.linux;
  };
}
