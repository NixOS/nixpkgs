{ lib, stdenv
, fetchurl
, copyDesktopItems
, makeDesktopItem
, makeWrapper
, wrapGAppsHook
, writeShellScript
, gobject-introspection
, jre # old or modded versions of the game may require Java 8 (https://aur.archlinux.org/packages/minecraft-launcher/#pinned-674960)
, pkgs
, buildFHSEnv
}:
let
  desktopItem = makeDesktopItem {
    name = "minecraft-launcher";
    exec = "minecraft-launcher";
    icon = "minecraft-launcher";
    comment = "Official launcher for Minecraft, a sandbox-building game";
    desktopName = "Minecraft Launcher";
    categories = [ "Game" ];
  };

  mkEnvLibs = pkgs: with pkgs; [
    curl
    libpulseaudio
    systemd
    alsa-lib # needed for narrator
    flite # needed for narrator
  ];

  envLibPath = lib.makeLibraryPath (mkEnvLibs pkgs);

  mkLibs = pkgs: with pkgs; ([
    alsa-lib
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    libdrm
    libglvnd
    libsecret
    pango
    gtk3
    gtk3-x11
    mesa
    nspr
    nss
    stdenv.cc.cc
    zlib
    libuuid
  ] ++
  (with xorg; [
    libX11
    libxcb
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libXScrnSaver
  ]));

  libPath = lib.makeLibraryPath (mkLibs pkgs);

  bootstrap = import ./bootstrap.nix {
    inherit lib stdenv makeWrapper wrapGAppsHook copyDesktopItems gobject-introspection
      desktopItem jre fetchurl libPath envLibPath;
  };

  generic = {
    name ? "minecraft-launcher"
    , runScript ? "minecraft-launcher"
  }: buildFHSEnv {
    inherit name runScript;

    multiArch = false;

    targetPkgs = pkgs: (mkEnvLibs pkgs) ++ (mkLibs pkgs) ++ [ bootstrap ];

    unshareIpc = false;
    unsharePid = false;

    meta = bootstrap.meta;

    passthru = {
      inherit bootstrap run;
      updateScript = ./update.sh;
    };

  };

  fhs = generic { };

  run = generic {
    name = "minecraft-run";
    runScript = writeShellScript "minecraft-run" ''
      run="$1"
      if [ "$run" = "" ]; then
        echo "Usage: minecraft-run command-to-run args..." >&2
        exit 1
      fi
      shift

      exec -- "$run" "$@"
    '';
  };
in
  fhs

