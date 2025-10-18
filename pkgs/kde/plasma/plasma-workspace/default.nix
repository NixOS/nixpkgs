{
  lib,
  mkKdeDerivation,
  replaceVars,
  fetchpatch,
  dbus,
  fontconfig,
  xorg,
  lsof,
  pkg-config,
  spirv-tools,
  qtlocation,
  qtpositioning,
  qtsvg,
  qtwayland,
  libcanberra,
  libqalculate,
  pipewire,
  qttools,
  qqc2-breeze-style,
  gpsd,
}:
mkKdeDerivation {
  pname = "plasma-workspace";

  patches = [
    (replaceVars ./dependency-paths.patch {
      dbusSend = lib.getExe' dbus "dbus-send";
      fcMatch = lib.getExe' fontconfig "fc-match";
      lsof = lib.getExe lsof;
      qdbus = lib.getExe' qttools "qdbus";
      xmessage = lib.getExe xorg.xmessage;
      xrdb = lib.getExe xorg.xrdb;
      # @QtBinariesDir@ only appears in the *removed* lines of the diff
      QtBinariesDir = null;
    })
    # Fixes https://github.com/NixOS/nixpkgs/issues/442630, next upstream release should already contain this patch
    (fetchpatch {
      name = "fix-media-applet-crash.diff";
      url = "https://invent.kde.org/plasma/plasma-workspace/-/commit/30273fb2afcc6e304951c8895bb17d38255fed39.diff";
      hash = "sha256-1p1CjxRioCDm5ugoI8l6kDlOse5FbDJ71tTAY9LPvRc=";
    })
  ];

  postInstall = ''
    # Prevent patching this shell file, it only is used by sourcing it from /bin/sh.
    chmod -x $out/libexec/plasma-sourceenv.sh
  '';

  extraNativeBuildInputs = [
    pkg-config
    spirv-tools
  ];
  extraBuildInputs = [
    qtlocation
    qtpositioning
    qtsvg
    qtwayland

    qqc2-breeze-style

    libcanberra
    libqalculate
    pipewire

    xorg.libSM
    xorg.libXcursor
    xorg.libXtst
    xorg.libXft

    gpsd
  ];

  qtWrapperArgs = [ "--inherit-argv0" ];

  # Hardcoded as QStrings, which are UTF-16 so Nix can't pick these up automatically
  postFixup = ''
    mkdir -p $out/nix-support
    echo "${lsof} ${xorg.xmessage} ${xorg.xrdb}" > $out/nix-support/depends
  '';

  passthru.providedSessions = [
    "plasma"
    "plasmax11"
  ];
}
