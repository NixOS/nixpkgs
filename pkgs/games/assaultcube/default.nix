{ fetchFromGitHub, stdenv, makeDesktopItem, openal, pkgconfig, libogg,
  libvorbis, SDL, SDL_image, makeWrapper, zlib,
  client ? true, server ? true }:

with stdenv.lib;

stdenv.mkDerivation rec {

  # master branch has legacy (1.2.0.2) protocol 1201 and gcc 6 fix.
  pname = "assaultcube";
  version = "unstable-2017-05-01";

  meta = {
    description = "Fast and fun first-person-shooter based on the Cube fps";
    homepage = https://assault.cubers.net;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux; # should work on darwin with a little effort.
    license = stdenv.lib.licenses.zlib;
  };

  src = fetchFromGitHub {
    owner = "assaultcube";
    repo  = "AC";
    rev = "9f537b0876a39d7686e773040469fbb1417de18b";
    sha256 = "0nvckn67mmfaa7x3j41xyxjllxqzfx1dxg8pnqsaak3kkzds34pl";
  };

  # ${branch} not accepted as a value ?
  # TODO: write a functional BUNDLED_ENET option and restore it in deps.
  patches = [ ./assaultcube-next.patch ];

  nativeBuildInputs = [ pkgconfig ];

  # add optional for server only ?
  buildInputs = [ makeWrapper openal SDL SDL_image libogg libvorbis zlib ];

  #makeFlags = [ "CXX=g++" ];

  targets = (optionalString server "server") + (optionalString client " client");
  buildPhase = ''
    make -C source/src ${targets}
  '';

  desktop = makeDesktopItem {
    name = "AssaultCube";
    desktopName = "AssaultCube";
    comment = "A multiplayer, first-person shooter game, based on the CUBE engine. Fast, arcade gameplay.";
    genericName = "First-person shooter";
    categories = "Application;Game;ActionGame;Shooter";
    icon = "assaultcube.png";
    exec = "${pname}";
  };

  gamedatadir = "/share/games/${pname}";

  installPhase = ''

    bindir=$out/bin

    mkdir -p $bindir $out/$gamedatadir

    cp -r config packages $out/$gamedatadir

    # install custom script
    substituteAll ${./launcher.sh} $bindir/assaultcube
    chmod +x $bindir/assaultcube

    if (test -e source/src/ac_client) then
      cp source/src/ac_client $bindir
      mkdir -p $out/share/applications
      cp ${desktop}/share/applications/* $out/share/applications
      install -Dpm644 packages/misc/icon.png $out/share/icons/assaultcube.png
      install -Dpm644 packages/misc/icon.png $out/share/pixmaps/assaultcube.png
    fi

    if (test -e source/src/ac_server) then
      cp source/src/ac_server $bindir
      ln -s $bindir/${pname} $bindir/${pname}-server
    fi
    '';
}
