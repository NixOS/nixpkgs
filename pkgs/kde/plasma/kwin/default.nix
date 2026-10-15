{
  mkKdeDerivation,
  pkg-config,
  qtquick3d,
  qtsensors,
  qttools,
  qtvirtualkeyboard,
  qtwayland,
  libinput,
  libxcvt,
  xwayland,
  libcanberra,
  libcap,
  libdisplay-info,
  libei,
  libevdev,
  libgbm,
  lcms2,
  pipewire,
  python3,
}:
mkKdeDerivation {
  pname = "kwin";

  patches = [
    ./0003-plugins-qpa-allow-using-nixos-wrapper.patch
    ./0001-NixOS-Unwrap-executable-name-for-.desktop-search.patch
    ./plasma-setup-xwayland-path.patch
  ];

  postPatch = ''
    patchShebangs src/plugins/strip-effect-metadata.py
  '';

  # TZDIR may be unset when running through the kwin_wayland wrapper,
  # but we need it for the lockscreen clock to render
  qtWrapperArgs = [
    "--set-default TZDIR /etc/zoneinfo"
  ];

  extraNativeBuildInputs = [
    pkg-config
    python3

    # we can't actually have capabilities in the store but it gets mad
    libcap
  ];
  extraBuildInputs = [
    qtquick3d
    qtsensors
    qttools
    qtvirtualkeyboard
    qtwayland

    libgbm
    lcms2
    libcanberra
    libdisplay-info
    libei
    libevdev
    libinput
    pipewire

    libxcvt
    # we need to provide this so it knows our xwayland supports new features
    xwayland

    # and it needs to be in both because cmake is stupid
    libcap
  ];

  # plugin QML relies on non-global imports
  dontQmlLint = true;
}
