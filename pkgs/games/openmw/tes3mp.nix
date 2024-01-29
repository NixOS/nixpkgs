{ lib
, stdenv
, cmake
, openmw
, fetchFromGitHub
, fetchpatch
, luajit
, makeWrapper
, symlinkJoin
, disable-warnings-if-gcc13
}:

# revisions are taken from https://github.com/GrimKriegor/TES3MP-deploy

let
  # raknet could also be split into dev and lib outputs
  raknet = disable-warnings-if-gcc13 (stdenv.mkDerivation {
    pname = "raknet";
    version = "unstable-2020-01-19";

    src = fetchFromGitHub {
      owner = "TES3MP";
      repo = "CrabNet";
      # usually fixed:
      # https://github.com/GrimKriegor/TES3MP-deploy/blob/d2a4a5d3acb64b16d9b8ca85906780aeea8d311b/tes3mp-deploy.sh#L589
      rev = "19e66190e83f53bcdcbcd6513238ed2e54878a21";
      sha256 = "WIaJkSQnoOm9T7GoAwmWl7fNg79coIo/ILUsWcbH+lA=";
    };

    cmakeFlags = [
      "-DCRABNET_ENABLE_DLL=OFF"
    ];

    nativeBuildInputs = [ cmake ];

    installPhase = ''
      install -Dm555 lib/libRakNetLibStatic.a $out/lib/libRakNetLibStatic.a
    '';
  });

  coreScripts = stdenv.mkDerivation {
    pname = "corescripts";
    version = "0.8.1";

    src = fetchFromGitHub {
      owner = "TES3MP";
      repo = "CoreScripts";
      # usually latest in stable branch (e.g. 0.7.1)
      rev = "6ae0a2a5d16171de3764817a7f8b1067ecde3def";
      sha256 = "8j/Sr9IRMNFPEVfFzdb42PckHS3KW7FH7x7rRxIh5gY=";
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
    version = "0.8.1";

    src = fetchFromGitHub {
      owner = "TES3MP";
      repo = "TES3MP";
      # usually latest in stable branch (e.g. 0.7.1)
      rev = "68954091c54d0596037c4fb54d2812313b7582a1";
      sha256 = "8/bV4sw7Q8l8bDTHGQ0t4owf6J6h9q468JFx4KegY5o=";
    };

    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ makeWrapper ];

    buildInputs = oldAttrs.buildInputs ++ [ luajit ];

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

    patches = [
      (fetchpatch {
        url = "https://gitlab.com/OpenMW/openmw/-/commit/98a7d90ee258ceef9c70b0b2955d0458ec46f048.patch";
        sha256 = "sha256-RhbIGeE6GyqnipisiMTwWjcFnIiR055hUPL8IkjPgZw=";
      })

      # https://github.com/TES3MP/openmw-tes3mp/issues/552
      ./tes3mp.patch
    ];

    env.NIX_CFLAGS_COMPILE = "-fpermissive";

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
    };
  });

  tes3mp-server-run = ''
    config="''${XDG_CONFIG_HOME:-''$HOME/.config}"/openmw
    data="''${XDG_DATA_HOME:-''$HOME/.local/share}"/openmw
    if [[ ! -f "$config"/tes3mp-server.cfg && ! -d "$data"/server ]]; then
      mkdir -p "$config"
      echo [Plugins] > "$config"/tes3mp-server.cfg
      echo "home = $data/server" >> "$config"/tes3mp-server.cfg
      mkdir -p "$data"
      cp -r ${coreScripts}/share/openmw-tes3mp/CoreScripts "$data"/server
      chmod -R u+w "$data"/server
    fi
  '';

in
symlinkJoin {
  name = "openmw-tes3mp-${unwrapped.version}";
  inherit (unwrapped) version meta;

  nativeBuildInputs = [ makeWrapper ];

  paths = [ unwrapped ];

  postBuild = ''
    mkdir -p $out/bin

    makeWrapper ${unwrapped}/libexec/tes3mp-browser $out/bin/tes3mp-browser \
      --chdir "$out/bin"

    makeWrapper ${unwrapped}/libexec/tes3mp-server $out/bin/tes3mp-server \
      --run '${tes3mp-server-run}' \
      --chdir "$out/bin"
  '';
}
