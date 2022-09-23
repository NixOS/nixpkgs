{ lib, stdenv, fetchFromGitHub, autoreconfHook, lua5_3, pkg-config, python3
, zlib, bzip2, curl, xz, gettext, libiconv, icu
, SDL2, SDL2_mixer, SDL2_image, SDL2_ttf, SDL2_gfx, freetype, fluidsynth
, sdl2Client ? false
, gtkClient ? true, gtk3, wrapGAppsHook
, qtClient ? false, qt5
, server ? true, readline
, enableSqlite ? true, sqlite
}:

stdenv.mkDerivation rec {
  pname = "freeciv";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "freeciv";
    repo = "freeciv";
    rev = "R${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "sha256-WIp1R27UahbkLZZuF0nbX/XHVDc2OJukPKgoQ+qnjMc=";
  };

  postPatch = ''
    for f in {common,utility}/*.py; do
      substituteInPlace $f \
        --replace '/usr/bin/env python3' ${python3.interpreter}
    done
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config ]
    ++ lib.optional qtClient [ qt5.wrapQtAppsHook ]
    ++ lib.optional gtkClient [ wrapGAppsHook ];

  buildInputs = [ lua5_3 zlib bzip2 curl xz gettext libiconv icu ]
    ++ [ SDL2 SDL2_mixer SDL2_image SDL2_ttf SDL2_gfx freetype fluidsynth ]
    ++ lib.optionals gtkClient [ gtk3 ]
    ++ lib.optionals qtClient  [ qt5.qtbase ]
    ++ lib.optional server readline
    ++ lib.optional enableSqlite sqlite;

  dontWrapQtApps = true;
  dontWrapGApps = true;

  # configure is not smart enough to look for SDL2 headers under
  # .../SDL2, but thankfully $SDL2_PATH is almost exactly what we want
  preConfigure = ''
    export CPPFLAGS="$(echo $SDL2_PATH | sed 's#/nix/store/#-I/nix/store/#g')"
  '';
  configureFlags = [ "--enable-shared" ]
    ++ lib.optionals sdl2Client [
      "--enable-client=sdl2"
      "--enable-sdl-mixer=sdl2"
    ]
    ++ lib.optionals qtClient [
      "--enable-client=qt"
      "--with-qt5-includes=${qt5.qtbase.dev}/include"
    ] ++ lib.optionals gtkClient [ "--enable-client=gtk3.22" ]
    ++ lib.optional enableSqlite "--enable-fcdb=sqlite3"
    ++ lib.optional (!gtkClient) "--enable-fcmp=cli"
    ++ lib.optional (!server)    "--disable-server";

  postFixup = lib.optionalString qtClient ''
    wrapQtApp $out/bin/freeciv-qt
  '' + lib.optionalString gtkClient ''
    wrapGApp $out/bin/freeciv-gtk3.22
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Multiplayer (or single player), turn-based strategy game";
    longDescription = ''
      Freeciv is a Free and Open Source empire-building strategy game
      inspired by the history of human civilization. The game commences in
      prehistory and your mission is to lead your tribe from the stone age
      to the space age...
    '';
    homepage = "http://www.freeciv.org"; # http only
    license = licenses.gpl2;
    maintainers = with maintainers; [ pierron ];
    platforms = platforms.unix;
    hydraPlatforms = platforms.linux; # sdl-config times out on darwin
  };
}
