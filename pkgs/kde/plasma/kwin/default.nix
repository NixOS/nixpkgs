{
  fetchpatch,
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
}:
mkKdeDerivation {
  pname = "kwin";

  patches = [
    ./0003-plugins-qpa-allow-using-nixos-wrapper.patch
    ./0001-NixOS-Unwrap-executable-name-for-.desktop-search.patch
    ./0001-Lower-CAP_SYS_NICE-from-the-ambient-set.patch

    # Backport fix for very annoying flickering on AMD GPUs
    # when animating brightness changes.
    # FIXME: remove in 6.4.5
    (fetchpatch {
      url = "https://invent.kde.org/plasma/kwin/-/commit/7d36003cb073ed2ad48b2743883db993106c347a.patch";
      hash = "sha256-x+GVRU1CIne1TsGJsk2+JbWJi/wuDOFiABXuqgDD9bs=";
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
