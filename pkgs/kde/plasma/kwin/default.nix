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
  libdisplay-info,
  libei,
  libevdev,
  libgbm,
  lcms2,
  pipewire,
  python3,
  fetchpatch,
}:
mkKdeDerivation {
  pname = "kwin";

  patches = [
    ./0003-plugins-qpa-allow-using-nixos-wrapper.patch
    ./0001-NixOS-Unwrap-executable-name-for-.desktop-search.patch

    # backport crash fix with latest Mesa
    # FIXME: remove in next update
    (fetchpatch {
      url = "https://invent.kde.org/plasma/kwin/-/commit/2d0613acd044544e79b034b1cbc248664edf2884.diff";
      hash = "sha256-dpflStJ01aChNYDO+dfI67LhLWoC3sovaAza1AIck1E=";
    })
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
  ];

  # plugin QML relies on non-global imports
  dontQmlLint = true;
}
