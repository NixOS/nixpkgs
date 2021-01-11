{ stdenv, lib, fetchFromGitHub, buildEnv, cmake, makeWrapper
, SDL2, libGL, curl
, oggSupport ? true, libogg, libvorbis
, openalSupport ? true, openal
, zipSupport ? true, zlib
, Cocoa, OpenAL
}:

let
  mkFlag = b: if b then "ON" else "OFF";

  games = import ./games.nix { inherit stdenv lib fetchFromGitHub cmake; };

  wrapper = import ./wrapper.nix { inherit stdenv lib buildEnv makeWrapper yquake2; };

  yquake2 = stdenv.mkDerivation rec {
    pname = "yquake2";
    version = "7.43";

    src = fetchFromGitHub {
      owner = "yquake2";
      repo = "yquake2";
      rev = "QUAKE2_${builtins.replaceStrings ["."] ["_"] version}";
      sha256 = "1dszbvxlh1npq4nv9s4wv4lcyfgb01k92ncxrrczsxy1dddg86pp";
    };

    nativeBuildInputs = [ cmake ];

    buildInputs = [ SDL2 libGL curl ]
      ++ lib.optionals stdenv.isDarwin [ Cocoa OpenAL ]
      ++ lib.optionals oggSupport [ libogg libvorbis ]
      ++ lib.optional openalSupport openal
      ++ lib.optional zipSupport zlib;

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DOGG_SUPPORT=${mkFlag oggSupport}"
      "-DOPENAL_SUPPORT=${mkFlag openalSupport}"
      "-DZIP_SUPPORT=${mkFlag zipSupport}"
      "-DSYSTEMWIDE_SUPPORT=ON"
    ];

    preConfigure = ''
      # Since we can't expand $out in `cmakeFlags`
      cmakeFlags="$cmakeFlags -DSYSTEMDIR=$out/share/games/quake2"
    '';

    installPhase = ''
      # Yamagi Quake II expects all binaries (executables and libs) to be in the
      # same directory.
      mkdir -p $out/bin $out/lib/yquake2 $out/share/games/quake2
      cp -r release/* $out/lib/yquake2
      ln -s $out/lib/yquake2/quake2 $out/bin/yquake2
      ln -s $out/lib/yquake2/q2ded $out/bin/yq2ded
      cp $src/stuff/yq2.cfg $out/share/games/quake2
    '';

    meta = with lib; {
      description = "Yamagi Quake II client";
      homepage = "https://www.yamagi.org/quake2/";
      license = licenses.gpl2;
      platforms = platforms.unix;
      maintainers = with maintainers; [ tadfisher ];
    };
  };

in {
  inherit yquake2;

  yquake2-ctf = wrapper {
    games = [ games.ctf ];
    name = "yquake2-ctf";
    inherit (games.ctf) description;
  };

  yquake2-ground-zero = wrapper {
    games = [ games.ground-zero ];
    name = "yquake2-ground-zero";
    inherit (games.ground-zero) description;
  };

  yquake2-the-reckoning = wrapper {
    games = [ games.the-reckoning ];
    name = "yquake2-the-reckoning";
    inherit (games.the-reckoning) description;
  };

  yquake2-all-games = wrapper {
    games = lib.attrValues games;
    name = "yquake2-all-games";
    description = "Yamagi Quake II with all add-on games";
  };
}
