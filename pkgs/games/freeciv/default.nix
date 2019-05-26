{ stdenv, fetchurl, zlib, bzip2, pkgconfig, curl, lzma, gettext, libiconv
, sdlClient ? true, SDL, SDL_mixer, SDL_image, SDL_ttf, SDL_gfx, freetype, fluidsynth
, gtkClient ? false, gtk2
, server ? true, readline
, enableSqlite ? true, sqlite
}:

let
  inherit (stdenv.lib) optional optionals;

  name = "freeciv";
  version = "2.6.0";
in
stdenv.mkDerivation {
  name = "${name}-${version}";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/freeciv/${name}-${version}.tar.bz2";
    sha256 = "16f9wsnn7073s6chzbm3819swd0iw019p9nrzr3diiynk28kj83w";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ zlib bzip2 curl lzma gettext libiconv ]
    ++ optionals sdlClient [ SDL SDL_mixer SDL_image SDL_ttf SDL_gfx freetype fluidsynth ]
    ++ optionals gtkClient [ gtk2 ]
    ++ optional server readline
    ++ optional enableSqlite sqlite;

  configureFlags = [ "--enable-shared" ]
    ++ optional sdlClient "--enable-client=sdl"
    ++ optional enableSqlite "--enable-fcdb=sqlite3"
    ++ optional (!gtkClient) "--enable-fcmp=cli"
    ++ optional (!server) "--disable-server";

  enableParallelBuilding = true;

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
    platforms = platforms.unix;
    hydraPlatforms = stdenv.lib.platforms.linux; # sdl-config times out on darwin
  };
}
