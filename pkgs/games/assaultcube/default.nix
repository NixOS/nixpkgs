{ fetchgit, stdenv, makeDesktopItem, curl, enet, openal, pkgconfig, libogg,
  libvorbis, SDL, SDL_image, SDL_mixer, makeWrapper, zlib,
  client ? true, server ? true }:

with stdenv.lib;

stdenv.mkDerivation rec {

  # master branch has legacy (1.2.0.2) protocol 1201 and gcc 6 fix.
  branch = "master";
  name = "assaultcube";

  meta = {
    description = "Fast and fun first-person-shooter based on the Cube fps";
    homepage = http://assault.cubers.net;
    maintainers = [ maintainers.genesis ];
    license = stdenv.lib.licenses.zlib;
  };

  #sadless , fetchgit seems to refetch all stuff when man switch branch .
  src = fetchgit {
    url = "https://github.com/assaultcube/AC.git";
    rev = "9f537b0876a39d7686e773040469fbb1417de18b";
    branchName = "${branch}";
    #sha256 = "";
  };

  # ${branch} not accepted as a value ?
  patches = [ ./assaultcube-next.patch ];

  nativeBuildInputs = [ pkgconfig ];

  # add optional for server only ?
  buildInputs = [ makeWrapper enet openal SDL SDL_image libogg libvorbis zlib ];

  #makeFlags = [ "CXX=g++" ];

  targets = (optionalString server "server") + (optionalString client " client");
  buildPhase = ''
    BUNDLED_ENET=NO make -C source/src ${targets}
  '';

  desktop = makeDesktopItem {
    name = "AssaultCube";
    desktopName = "AssaultCube";
    comment = "A multiplayer, first-person shooter game, based on the CUBE engine. Fast, arcade gameplay.";
    genericName = "First-person shooter";
    categories = "Application;Game;ActionGame;Shooter";
    icon = "assaultcube.png";
    exec = "${name}";
  };

  gamedatadir = "/share/games/${name}";

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
      ln -s $bindir/${name} $bindir/${name}-server
    fi
    '';
}
