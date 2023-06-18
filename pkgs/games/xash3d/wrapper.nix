{ writeShellScriptBin
, makeDesktopItem
, symlinkJoin
, hlsdk
, xash3d-unwrapped
, name # codename, normally matches gamedir
, fullname # the human readable name (e.g. "Half-Life: Opposing Force")
, gamedir ? name # the name of the directory containing game data (e.g. "gearbox")
, dllname ? name # ARGH why couldn't this just be always name (e.g. "opfor")
}:

let
  description = "${fullname} running using the Xash3D engine, a GoldSrc reimplementation";

  wrapper = writeShellScriptBin "xash3d-${name}" ''
    if [ -z "$XDG_DATA_HOME" ]; then
        export XDG_DATA_HOME="$HOME/.local/share"
    fi

    if [ -z "$XASH3D_BASEDIR" ]; then
      export XASH3D_BASEDIR="$XDG_DATA_HOME/xash3d"
    fi

    if [ ! -d "$XASH3D_BASEDIR" ]; then
      echo "$XASH3D_BASEDIR not found"
      exit 1
    fi

    export XASH3D_EXTRAS_PAK1=${xash3d-unwrapped}/share/xash3d/valve/extras.pk3

    flags_dll="-dll ${hlsdk}/${gamedir}/dlls/${dllname}_amd64.so"
    flags_clientlib="-clientlib ${hlsdk}/${gamedir}/cl_dlls/client_amd64.so"

    export LD_LIBRARY_PATH=${xash3d-unwrapped}/lib/xash3d

    exec ${xash3d-unwrapped}/bin/xash3d -game ${gamedir} $flags_dll $flags_clientlib "$@"
  '';

  desktopItem = makeDesktopItem {
    inherit name;
    desktopName = fullname;
    comment = description;
    exec = "xash3d-${name}";
    # The game's icon is in the assets, which we may not have at build time
    # so we use the xash3d icon.
    icon = "xash3d";
    categories = [ "Game" ];
  };
in symlinkJoin {
  name = "xash3d-${name}";
  paths = [ wrapper desktopItem ];
  meta = xash3d-unwrapped.meta // {
    inherit description;
    longDescription = ''
      To be able to run ${fullname} with Xash3D, you must first copy the "${gamedir}"
      folder of your existing ${fullname} installating to $XASH3D_BASEDIR.
      By default, $XASH3D_BASEDIR is $XDG_DATA_HOME/xash3d, but you can also set the environment variable.
    '';
  };
}
