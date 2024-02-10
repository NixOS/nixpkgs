{ stdenv, SDL2_image_2_6, SDL2_ttf, SDL2_net, fpc, ghcWithPackages, ffmpeg_4, freeglut
, lib, fetchurl, cmake, pkg-config, lua5_1, SDL2, SDL2_mixer
, zlib, libpng, libGL, libGLU, physfs
, qtbase, qttools, wrapQtAppsHook
, llvm
, withServer ? true
}:

let
  ghc = ghcWithPackages (pkgs: with pkgs; [
          SHA bytestring entropy hslogger network pkgs.zlib random
          regex-tdfa sandi utf8-string vector
        ]);
in
stdenv.mkDerivation rec {
  pname = "hedgewars";
  version = "1.0.2";

  src = fetchurl {
    url = "https://www.hedgewars.org/download/releases/hedgewars-src-${version}.tar.bz2";
    sha256 = "sha256-IB/l5FvYyls9gbGOwGvWu8n6fCxjvwGQBeL4C+W88hI=";
  };

  nativeBuildInputs = [ cmake pkg-config qttools wrapQtAppsHook ];

  buildInputs = [
    SDL2_ttf SDL2_net SDL2 SDL2_mixer SDL2_image_2_6
    fpc lua5_1
    llvm # hard-requirement on aarch64, for some reason not strictly necessary on x86-64
    ffmpeg_4 freeglut physfs
    qtbase
  ] ++ lib.optional withServer ghc;

  cmakeFlags = [
    "-DNOVERSIONINFOUPDATE=ON"
    "-DNOSERVER=${if withServer then "OFF" else "ON"}"
  ];

  NIX_LDFLAGS = lib.concatMapStringsSep " " (e: "-rpath ${e}/lib") [
    SDL2.out
    SDL2_image_2_6
    SDL2_mixer
    SDL2_net
    SDL2_ttf
    libGL
    libGLU
    libpng.out
    lua5_1
    physfs
    zlib.out
  ];

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libGL libGLU freeglut physfs ]}"
  ];

  meta = with lib; {
    description = "Turn-based strategy artillery game similar to Worms";
    homepage = "https://hedgewars.org/";
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
    broken = stdenv.isDarwin;
    platforms = platforms.linux;
  };
}
