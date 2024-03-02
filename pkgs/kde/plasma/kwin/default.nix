{
  mkKdeDerivation,
  pkg-config,
  qtquick3d,
  qtsensors,
  qttools,
  qtvirtualkeyboard,
  qtwayland,
  libinput,
  xorg,
  libdisplay-info,
  mesa,
  lcms2,
  libcap,
  pipewire,
  krunner,
  python3,
}:
mkKdeDerivation {
  pname = "kwin";

  patches = [
    # Follow symlinks when searching for aurorae configs
    # FIXME(later): upstream?
    ./0001-follow-symlinks.patch
    # The rest are NixOS-specific hacks
    ./0003-plugins-qpa-allow-using-nixos-wrapper.patch
    ./0001-NixOS-Unwrap-executable-name-for-.desktop-search.patch
  ];

  postPatch = ''
    patchShebangs src/plugins/strip-effect-metadata.py
  '';

  extraNativeBuildInputs = [pkg-config python3];
  extraBuildInputs = [
    qtquick3d
    qtsensors
    qttools
    qtvirtualkeyboard
    qtwayland

    krunner

    mesa # libgbm
    lcms2
    libcap
    libdisplay-info
    libinput
    pipewire

    xorg.libxcvt
  ];
}
