{
  lib,
  mkKdeDerivation,
  replaceVars,
  fontconfig,
  libxtst,
  libxft,
  libxcursor,
  libsm,
  xrdb,
  xmessage,
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
      fcMatch = lib.getExe' fontconfig "fc-match";
      lsof = lib.getExe lsof;
      qdbus = lib.getExe' qttools "qdbus";
      xmessage = lib.getExe xmessage;
      xrdb = lib.getExe xrdb;
      # @QtBinariesDir@ only appears in the *removed* lines of the diff
      QtBinariesDir = null;
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

    libsm
    libxcursor
    libxtst
    libxft

    gpsd
  ];

  qtWrapperArgs = [ "--inherit-argv0" ];

  # Hardcoded as QStrings, which are UTF-16 so Nix can't pick these up automatically
  postFixup = ''
    mkdir -p $out/nix-support
    echo "${lsof} ${xmessage} ${xrdb}" > $out/nix-support/depends
  '';

  passthru.providedSessions = [
    "plasma"
    "plasmax11"
  ];
}
