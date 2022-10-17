{ lib
, stdenv
, cmake
, openmw
, fetchFromGitHub
, formats
, luajit
, makeWrapper
, symlinkJoin
, mygui
, crudini
, bullet
}:

# revisions are taken from https://github.com/GrimKriegor/TES3MP-deploy

let
  # raknet could also be split into dev and lib outputs
  raknet = stdenv.mkDerivation {
    pname = "raknet";
    version = "unstable-2018-07-14";

    src = fetchFromGitHub {
      owner = "TES3MP";
      repo = "CrabNet";
      # usually fixed:
      # https://github.com/GrimKriegor/TES3MP-deploy/blob/d2a4a5d3acb64b16d9b8ca85906780aeea8d311b/tes3mp-deploy.sh#L589
      rev = "4eeeaad2f6c11aeb82070df35169694b4fb7b04b";
      sha256 = "0p0li9l1i5lcliswm5w9jql0zff9i6fwhiq0bl130m4i7vpr4cr3";
    };

    nativeBuildInputs = [ cmake ];

    installPhase = ''
      install -Dm555 lib/libRakNetLibStatic.a $out/lib/libRakNetLibStatic.a
    '';
  };

  coreScripts = stdenv.mkDerivation {
    pname = "corescripts";
    version = "unstable-2020-07-27";

    src = fetchFromGitHub {
      owner = "TES3MP";
      repo = "CoreScripts";
      # usually latest in stable branch (e.g. 0.7.1)
      rev = "3c2d31595344db586d8585db0ef1fc0da89898a0";
      sha256 = "sha256-m/pt2Et58HOMc1xqllGf4hjPLXNcc14+X0h84ouZDeg=";
    };

    buildCommand = ''
      dir=$out/share/openmw-tes3mp
      mkdir -p $dir
      cp -r $src $dir/CoreScripts
    '';
  };

  # build an unwrapped version so we don't have to rebuild it all over again in
  # case the scripts or wrapper scripts change.
  unwrapped = openmw.overrideAttrs (oldAttrs: rec {
    pname = "openmw-tes3mp-unwrapped";
    version = "unstable-2020-08-07";

    src = fetchFromGitHub {
      owner = "TES3MP";
      repo = "openmw-tes3mp";
      # usually latest in stable branch (e.g. 0.7.1)
      rev = "ce5df6d18546e37aac9746d99c00d27a7f34b00d";
      sha256 = "sha256-xLslShNA6rVFl9kt6BNGDpSYMpO25jBTCteLJoSTXdg=";
    };

    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ makeWrapper ];

    buildInputs = (builtins.map (x: if x.pname or "" == "bullet" then bullet else x) oldAttrs.buildInputs)
      ++ [ luajit ];

    cmakeFlags = oldAttrs.cmakeFlags ++ [
      "-DBUILD_OPENCS=OFF"
      "-DRakNet_INCLUDES=${raknet.src}/include"
      "-DRakNet_LIBRARY_RELEASE=${raknet}/lib/libRakNetLibStatic.a"
      "-DRakNet_LIBRARY_DEBUG=${raknet}/lib/libRakNetLibStatic.a"
    ];

    prePatch = ''
      substituteInPlace components/process/processinvoker.cpp \
        --replace "\"./\"" "\"$out/bin/\""
    '';

    # https://github.com/TES3MP/openmw-tes3mp/issues/552
    patches = oldAttrs.patches ++ [ ./tes3mp.patch ];

    NIX_CFLAGS_COMPILE = "-fpermissive";

    preConfigure = ''
      substituteInPlace files/version.in \
        --subst-var-by OPENMW_VERSION_COMMITHASH ${src.rev}
    '';

    # move everything that we wrap out of the way
    postInstall = ''
      mkdir -p $out/libexec
      mv $out/bin/tes3mp-* $out/libexec
    '';

    meta = with lib; {
      description = "Multiplayer for TES3:Morrowind based on OpenMW";
      homepage = "https://tes3mp.com/";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [ peterhoeg ];
      platforms = [ "x86_64-linux" "i686-linux" ];
      broken = true;
    };
  });

  cfgFile = (formats.ini { }).generate "tes3mp-server.cfg" {
    Plugins.home = "${coreScripts}/share/openmw-tes3mp/CoreScripts";
  };

in
symlinkJoin rec {
  name = "openmw-tes3mp-${unwrapped.version}";
  inherit (unwrapped) version meta;

  nativeBuildInputs = [ makeWrapper ];

  paths = [ unwrapped ];

  # crudini --merge will create the file if it doesn't exist
  postBuild = ''
    mkdir -p $out/bin

    dir=\''${XDG_CONFIG_HOME:-\$HOME/.config}/openmw

    makeWrapper ${unwrapped}/libexec/tes3mp-browser $out/bin/tes3mp-browser \
      --chdir "$out/bin"

    makeWrapper ${unwrapped}/libexec/tes3mp-server $out/bin/tes3mp-server \
      --run "mkdir -p $dir" \
      --run "${crudini}/bin/crudini --merge $dir/${cfgFile.name} < ${cfgFile}" \
      --chdir "$out/bin"
  '';
}
