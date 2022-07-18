{ stdenv, lib, fetchFromGitHub, buildEnv, makeWrapper
, SDL2, libGL, curl
, openalSupport ? true, openal
, Cocoa, OpenAL
}:

let
  mkFlag = b: if b then "yes" else "no";

  games = import ./games.nix { inherit stdenv lib fetchFromGitHub; };

  wrapper = import ./wrapper.nix { inherit stdenv lib buildEnv makeWrapper yquake2; };

  yquake2 = stdenv.mkDerivation rec {
    pname = "yquake2";
    version = "8.01";

    src = fetchFromGitHub {
      owner = "yquake2";
      repo = "yquake2";
      rev = "QUAKE2_${builtins.replaceStrings ["."] ["_"] version}";
      sha256 = "1dll5lx4bnls5w5f2zwjhwpcpxa97rjn6ymb2v3vrjm19jbd16yd";
    };

    postPatch = ''
      substituteInPlace src/client/curl/qcurl.c \
        --replace "\"libcurl.so.3\", \"libcurl.so.4\"" "\"${curl.out}/lib/libcurl.so\", \"libcurl.so.3\", \"libcurl.so.4\""
    '' + lib.optionalString (openalSupport && !stdenv.isDarwin) ''
      substituteInPlace Makefile \
        --replace "\"libopenal.so.1\"" "\"${openal}/lib/libopenal.so.1\""
    '';

    buildInputs = [ SDL2 libGL curl ]
      ++ lib.optionals stdenv.isDarwin [ Cocoa OpenAL ]
      ++ lib.optional openalSupport openal;

    makeFlags = [
      "WITH_OPENAL=${mkFlag openalSupport}"
      "WITH_SYSTEMWIDE=yes"
      "WITH_SYSTEMDIR=$\{out}/share/games/quake2"
    ];

    enableParallelBuilding = true;

    installPhase = ''
      # Yamagi Quake II expects all binaries (executables and libs) to be in the
      # same directory.
      mkdir -p $out/bin $out/lib/yquake2 $out/share/games/quake2/baseq2
      cp -r release/* $out/lib/yquake2
      ln -s $out/lib/yquake2/quake2 $out/bin/yquake2
      ln -s $out/lib/yquake2/q2ded $out/bin/yq2ded
      cp $src/stuff/yq2.cfg $out/share/games/quake2/baseq2
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
