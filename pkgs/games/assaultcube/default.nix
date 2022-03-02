{ fetchFromGitHub, lib, stdenv, makeDesktopItem, openal, pkg-config, libogg,
  libvorbis, SDL, SDL_image, makeWrapper, zlib, file,
  client ? true, server ? true }:

with lib;

stdenv.mkDerivation rec {

  # master branch has legacy (1.2.0.2) protocol 1201 and gcc 6 fix.
  pname = "assaultcube";
  version = "unstable-2018-05-20";

  src = fetchFromGitHub {
    owner = "assaultcube";
    repo  = "AC";
    rev = "f58ea22b46b5013a520520670434b3c235212371";
    sha256 = "1vfn3d55vmmipdykrcfvgk6dddi9y95vlclsliirm7jdp20f15hd";
  };

  nativeBuildInputs = [ makeWrapper pkg-config ];

  buildInputs = [ file zlib ] ++ optionals client [ openal SDL SDL_image libogg libvorbis ];

  targets = (optionalString server "server") + (optionalString client " client");
  makeFlags = [ "-C source/src" "CXX=${stdenv.cc.targetPrefix}c++" targets ];

  desktop = makeDesktopItem {
    name = "AssaultCube";
    desktopName = "AssaultCube";
    comment = "A multiplayer, first-person shooter game, based on the CUBE engine. Fast, arcade gameplay.";
    genericName = "First-person shooter";
    categories = [ "Game" "ActionGame" "Shooter" ];
    icon = "assaultcube.png";
    exec = pname;
  };

  gamedatadir = "/share/games/${pname}";

  installPhase = ''

    bindir=$out/bin

    mkdir -p $bindir $out/$gamedatadir

    cp -r config packages $out/$gamedatadir

    if (test -e source/src/ac_client) then
      cp source/src/ac_client $bindir
      mkdir -p $out/share/applications
      cp ${desktop}/share/applications/* $out/share/applications
      install -Dpm644 packages/misc/icon.png $out/share/icons/assaultcube.png
      install -Dpm644 packages/misc/icon.png $out/share/pixmaps/assaultcube.png

      makeWrapper $out/bin/ac_client $out/bin/${pname} \
        --run "cd $out/$gamedatadir" --add-flags "--home=\$HOME/.assaultcube/v1.2next --init"
    fi

    if (test -e source/src/ac_server) then
      cp source/src/ac_server $bindir
      makeWrapper $out/bin/ac_server $out/bin/${pname}-server \
        --run "cd $out/$gamedatadir" --add-flags "-Cconfig/servercmdline.txt"
    fi
    '';

  meta = {
    description = "Fast and fun first-person-shooter based on the Cube fps";
    homepage = "https://assault.cubers.net";
    maintainers = [ ];
    platforms = platforms.linux; # should work on darwin with a little effort.
    license = lib.licenses.unfree;
  };
}
