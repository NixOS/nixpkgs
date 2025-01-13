{
  lib,
  mkKdeDerivation,
  substituteAll,
  dbus,
  fontconfig,
  xorg,
  lsof,
  pkg-config,
  spirv-tools,
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
    (substituteAll {
      src = ./dependency-paths.patch;
      dbus-send = lib.getExe' dbus "dbus-send";
      fc-match = lib.getExe' fontconfig "fc-match";
      lsof = lib.getExe lsof;
      qdbus = lib.getExe' qttools "qdbus";
      xmessage = lib.getExe xorg.xmessage;
      xrdb = lib.getExe xorg.xrdb;
      xsetroot = lib.getExe xorg.xsetroot;
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

  # Hardcoded as QStrings, which are UTF-16 so Nix can't pick these up automatically
  postFixup = ''
    mkdir -p $out/nix-support
    echo "${lsof} ${xorg.xmessage} ${xorg.xrdb} ${xorg.xsetroot}" > $out/nix-support/depends
  '';

  passthru.providedSessions = [
    "plasma"
    "plasmax11"
  ];
}
