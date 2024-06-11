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

  postInstall = ''
    # Prevent patching this shell file, it only is used by sourcing it from /bin/sh.
    chmod -x $out/libexec/plasma-sourceenv.sh
  '';

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
