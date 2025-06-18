{
  mkKdeDerivation,
  pkg-config,
  qtsensors,
  qtwayland,
  xorg,
  libcanberra,
  libdisplay-info,
  libgbm,
  lcms2,
  python3,
}:
mkKdeDerivation {
  pname = "kwin-x11";

  patches = [
    ./0001-NixOS-Unwrap-executable-name-for-.desktop-search.patch
  ];

  postPatch = ''
    patchShebangs src/plugins/strip-effect-metadata.py
  '';

  extraNativeBuildInputs = [
    pkg-config
    python3
    qtsensors
    qtwayland
  ];

  extraBuildInputs = [
    qtsensors
    qtwayland

    libgbm
    lcms2
    libcanberra
    libdisplay-info

    xorg.libxcvt
  ];
}
