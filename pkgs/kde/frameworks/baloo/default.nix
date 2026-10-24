{
  mkKdeDerivation,
  qtdeclarative,
  lmdb,
  fetchpatch2,
}:
mkKdeDerivation {
  pname = "baloo";

  # Patches for https://bugs.kde.org/show_bug.cgi?id=524392, both are merged in upstream already
  # Can be removed with the release of KDE Frameworks > 6.31.0
  patches = [
    # https://invent.kde.org/frameworks/baloo/-/merge_requests/331
    (fetchpatch2 {
      url = "https://invent.kde.org/frameworks/baloo/-/commit/096b0d3f7166ed2bde0266cfad9f04ca50903090.patch";
      hash = "sha256-S2zV9nJ007mG0+r9H8X3R2O6VcwddXdwPknlnaaBiDg=";
    })
    # https://invent.kde.org/frameworks/baloo/-/merge_requests/334
    (fetchpatch2 {
      url = "https://invent.kde.org/frameworks/baloo/-/commit/a5431882c8cb36116907f59c97b0d2d92a7fe543.patch";
      hash = "sha256-mjTt5M7rtpW8tAgtCWswG/Q0GRIVvbOm+62behSSfkI=";
    })
  ];

  # kde-systemd-start-condition is not part of baloo
  postPatch = ''
    substituteInPlace src/file/kde-baloo.service.in --replace-fail @KDE_INSTALL_FULL_BINDIR@/kde-systemd-start-condition /run/current-system/sw/bin/kde-systemd-start-condition
  '';

  extraBuildInputs = [
    qtdeclarative
    lmdb
  ];
}
