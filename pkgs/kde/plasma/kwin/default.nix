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
  xwayland,
  libcanberra,
  libdisplay-info,
  libei,
  libgbm,
  lcms2,
  pipewire,
  krunner,
  python3,
  fetchpatch,
}:
mkKdeDerivation {
  pname = "kwin";

  patches = [
    ./0003-plugins-qpa-allow-using-nixos-wrapper.patch
    ./0001-NixOS-Unwrap-executable-name-for-.desktop-search.patch
    ./0001-Lower-CAP_SYS_NICE-from-the-ambient-set.patch

    # backport crash fix recommended by upstream
    (fetchpatch {
      url = "https://invent.kde.org/plasma/kwin/-/commit/ef4504320de2c3a7c7aebcf083d75db361f802ae.diff";
      hash = "sha256-aYUXlpnvtzWd5bJ3Y9NKDBqAg0x+4enaUTnyZiZCB48=";
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

    krunner

    libgbm
    lcms2
    libcanberra
    libdisplay-info
    libei
    libinput
    pipewire

    xorg.libxcvt
    # we need to provide this so it knows our xwayland supports new features
    xwayland
  ];
}
