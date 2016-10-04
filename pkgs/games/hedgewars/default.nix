{ SDL_image, SDL_ttf, SDL_net, fpc, qt4, ghcWithPackages, ffmpeg, freeglut
, stdenv, makeWrapper, fetchurl, cmake, pkgconfig, lua5_1, SDL, SDL_mixer
, zlib, libpng, mesa, physfs
}:

let
  ghc = ghcWithPackages (pkgs: with pkgs; [
          network vector utf8-string bytestring-show random hslogger
          dataenc SHA entropy zlib_0_5_4_2
        ]);
in
stdenv.mkDerivation rec {
  version = "0.9.22";
  name = "hedgewars-${version}";
  src = fetchurl {
    url = "http://download.gna.org/hedgewars/hedgewars-src-${version}.tar.bz2";
    sha256 = "14i1wvqbqib9h9092z10g4g0y14r5sp2fdaksvnw687l3ybwi6dn";
  };

  buildInputs = [
    SDL_ttf SDL_net cmake pkgconfig lua5_1 SDL SDL_mixer SDL_image fpc
    qt4 ghc ffmpeg freeglut makeWrapper physfs
  ];

  postPatch = ''
    substituteInPlace gameServer/CMakeLists.txt --replace mask evaluate
  '';

  preBuild = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath ${SDL_image}/lib
                                     -rpath ${SDL_mixer}/lib
                                     -rpath ${SDL_net}/lib
                                     -rpath ${SDL_ttf}/lib
                                     -rpath ${SDL.out}/lib
                                     -rpath ${libpng.out}/lib
                                     -rpath ${lua5_1}/lib
                                     -rpath ${mesa}/lib
                                     -rpath ${zlib.out}/lib
                                     "
  '';

  postInstall = ''
    wrapProgram $out/bin/hwengine --prefix LD_LIBRARY_PATH : $LD_LIBRARY_PATH:${stdenv.lib.makeLibraryPath [ mesa freeglut physfs ]}
  '';

  meta = with stdenv.lib; {
    description = "Turn-based strategy artillery game similar to Worms";
    homepage = http://hedgewars.org/;
    license = licenses.gpl2;
    longDescription = ''
       Each player controls a team of several hedgehogs. During the course of
       the game, players take turns with one of their hedgehogs. They then use
       whatever tools and weapons are available to attack and kill the
       opponents' hedgehogs, thereby winning the game. Hedgehogs may move
       around the terrain in a variety of ways, normally by walking and jumping
       but also by using particular tools such as the "Rope" or "Parachute", to
       move to otherwise inaccessible areas. Each turn is time-limited to
       ensure that players do not hold up the game with excessive thinking or
       moving.

       A large variety of tools and weapons are available for players during
       the game: Grenade, Cluster Bomb, Bazooka, UFO, Homing Bee, Shotgun,
       Desert Eagle, Fire Punch, Baseball Bat, Dynamite, Mine, Rope, Pneumatic
       pick, Parachute. Most weapons, when used, cause explosions that deform
       the terrain, removing circular chunks. The landscape is an island
       floating on a body of water, or a restricted cave with water at the
       bottom. A hedgehog dies when it enters the water (either by falling off
       the island, or through a hole in the bottom of it), it is thrown off
       either side of the arena or when its health is reduced, typically from
       contact with explosions, to zero (the damage dealt to the attacked
       hedgehog or hedgehogs after a player's or CPU turn is shown only when
       all movement on the battlefield has ceased).'';
    maintainers = with maintainers; [ kragniz fpletz ];
    platforms = ghc.meta.platforms;
  };
}
