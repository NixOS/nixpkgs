{ stdenv, fetchFromGitHub, autoreconfHook, lua5_3, pkgconfig, python
, zlib, bzip2, curl, lzma, gettext, libiconv
, sdlClient ? true, SDL, SDL_mixer, SDL_image, SDL_ttf, SDL_gfx, freetype, fluidsynth
, gtkClient ? false, gtk3
, qtClient ? false, qt5
, server ? true, readline
, enableSqlite ? true, sqlite
}:

let
  inherit (stdenv.lib) optional optionals;

in stdenv.mkDerivation rec {
  pname = "freeciv";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "freeciv";
    repo = "freeciv";
    rev = "R${builtins.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "1b3q5k9wpv7z24svz01ybw8d8wlzkkdr6ia5hgp6cxk6vq67n67s";
  };

  postPatch = ''
    for f in {common,utility}/*.py; do
      substituteInPlace $f \
        --replace '/usr/bin/env python' ${python.interpreter}
    done
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ lua5_3 zlib bzip2 curl lzma gettext libiconv ]
    ++ optionals sdlClient [ SDL SDL_mixer SDL_image SDL_ttf SDL_gfx freetype fluidsynth ]
    ++ optionals gtkClient [ gtk3 ]
    ++ optionals qtClient  [ qt5.qtbase ]
    ++ optional server readline
    ++ optional enableSqlite sqlite;

  configureFlags = [ "--enable-shared" ]
    ++ optional sdlClient "--enable-client=sdl"
    ++ optionals qtClient [
      "--enable-client=qt"
      "--with-qt5-includes=${qt5.qtbase.dev}/include"
    ]
    ++ optional enableSqlite "--enable-fcdb=sqlite3"
    ++ optional (!gtkClient) "--enable-fcmp=cli"
    ++ optional (!server)    "--disable-server";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Multiplayer (or single player), turn-based strategy game";

    longDescription = ''
      Freeciv is a Free and Open Source empire-building strategy game
      inspired by the history of human civilization. The game commences in
      prehistory and your mission is to lead your tribe from the stone age
      to the space age...
    '';

    homepage = http://www.freeciv.org; # http only
    license = licenses.gpl2;

    maintainers = with maintainers; [ pierron ];
    platforms = platforms.unix;
    hydraPlatforms = platforms.linux; # sdl-config times out on darwin
  };
}
