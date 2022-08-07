{ stdenv, SDL2_image, SDL2_ttf, SDL2_net, fpc, ghcWithPackages, ffmpeg, freeglut
, lib, fetchurl, cmake, pkg-config, lua5_1, SDL2, SDL2_mixer
, zlib, libpng, libGL, libGLU, physfs
, qtbase, qttools, wrapQtAppsHook
, llvm
, withServer ? true
}:

let
  # gameServer/hedgewars-server.cabal depends on network < 3
  ghc = ghcWithPackages (pkgs: with pkgs; [
          SHA bytestring entropy hslogger network_2_6_3_1 pkgs.zlib random
          regex-tdfa sandi utf8-string vector
        ]);

in
stdenv.mkDerivation rec {
  pname = "hedgewars";
  version = "1.0.0";

  src = fetchurl {
    url = "https://www.hedgewars.org/download/releases/hedgewars-src-${version}.tar.bz2";
    sha256 = "0nqm9w02m0xkndlsj6ys3wr0ik8zc14zgilq7k6fwjrf3zk385i1";
  };

  nativeBuildInputs = [ cmake pkg-config qttools wrapQtAppsHook ];

  buildInputs = [
    SDL2_ttf SDL2_net SDL2 SDL2_mixer SDL2_image
    fpc lua5_1
    llvm # hard-requirement on aarch64, for some reason not strictly necessary on x86-64
    ffmpeg freeglut physfs
    qtbase
  ] ++ lib.optional withServer ghc;

  postPatch = ''
    substituteInPlace gameServer/CMakeLists.txt \
      --replace mask evaluate

    # compile with fpc >= 3.2.0
    # https://github.com/archlinux/svntogit-community/blob/75a1b3900fb3dd553d5114bbc8474d85fd6abb02/trunk/PKGBUILD#L26
    sed -i 's/procedure ShiftWorld(Dir: LongInt); inline;/procedure ShiftWorld(Dir: LongInt);/' hedgewars/uWorld.pas
  '';

  cmakeFlags = [
    "-DNOVERSIONINFOUPDATE=ON"
    "-DNOSERVER=${if withServer then "OFF" else "ON"}"
  ];


  # hslogger brings network-3 and network-bsd which conflict with
  # network-2.6.3.1
  preConfigure = ''
    substituteInPlace gameServer/CMakeLists.txt \
      --replace "haskell_flags}" \
        "haskell_flags} -package network-2.6.3.1 -hide-package network-bsd"
  '';

  NIX_LDFLAGS = lib.concatMapStringsSep " " (e: "-rpath ${e}/lib") [
    SDL2.out
    SDL2_image
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
    homepage = "http://hedgewars.org/";
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
    inherit (fpc.meta) platforms;
  };
}
