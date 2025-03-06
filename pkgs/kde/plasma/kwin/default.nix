{
  mkKdeDerivation,
  fetchpatch,
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
    # Follow symlinks when searching for aurorae configs
    # FIXME(later): upstream?
    ./0001-follow-symlinks.patch
    # The rest are NixOS-specific hacks
    ./0003-plugins-qpa-allow-using-nixos-wrapper.patch
    ./0001-NixOS-Unwrap-executable-name-for-.desktop-search.patch
    ./0001-Lower-CAP_SYS_NICE-from-the-ambient-set.patch

    # Backport fix for crashes with multiple displays as recommended by upstream
    # FIXME: remove in 6.3.3
    (fetchpatch {
      url = "https://invent.kde.org/plasma/kwin/-/commit/bb263454548f65796e249adcf374aaebdc5e2db6.patch";
      hash = "sha256-BsQq42LRilz9YZyfisNChBEQcf1YXeBNCiF3ASVXmug=";
    })
    (fetchpatch {
      url = "https://invent.kde.org/plasma/kwin/-/commit/e652bdd3118fa55563caf0125deb0999f5ebd503.patch";
      hash = "sha256-4WnyyucIawsFqqSYRT8uY+a1GSDhjtGoqaxEu0o4Il4=";
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
