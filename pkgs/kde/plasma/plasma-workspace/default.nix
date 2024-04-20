{
  lib,
  mkKdeDerivation,
  substituteAll,
  xorg,
  pkg-config,
  spirv-tools,
  qtsvg,
  qtwayland,
  libcanberra,
  libqalculate,
  pipewire,
  breeze,
  qttools,
  qqc2-breeze-style,
  gpsd,
}:
mkKdeDerivation {
  pname = "plasma-workspace";

  patches = [
    (substituteAll {
      src = ./tool-paths.patch;
      xmessage = "${lib.getBin xorg.xmessage}/bin/xmessage";
      xsetroot = "${lib.getBin xorg.xsetroot}/bin/xsetroot";
      qdbus = "${lib.getBin qttools}/bin/qdbus";
    })
    (substituteAll {
      src = ./wallpaper-paths.patch;
      wallpapers = "${lib.getBin breeze}/share/wallpapers";
    })
  ];

  extraNativeBuildInputs = [pkg-config spirv-tools];
  extraBuildInputs = [
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

  passthru.providedSessions = ["plasma" "plasmax11"];
}
