{
  cmake,
  fetchFromGitLab,
  lib,
  qtbase,
  qtsvg,
  qttools,
  qtwayland,
  stdenv,
  wrapQtAppsHook,
  kdePackages,
  kdeSupport ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "qt6ct";
  version = "0.11";

  src = fetchFromGitLab {
    domain = "www.opencode.net";
    owner = "trialuser";
    repo = "qt6ct";
    tag = finalAttrs.version;
    hash = "sha256-aQmqLpM0vogMsYaDS9OeKVI3N53uY4NBC4FF10hK8Uw=";
  };

  # Patch adapted from the AUR qt6ct-kde package:
  # https://aur.archlinux.org/cgit/aur.git/tree/qt6ct-shenanigans.patch?h=qt6ct-kde
  patches = lib.optionals kdeSupport [
    ./qt6ct-shenanigans.patch
  ];

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ]
  ++ (lib.optionals kdeSupport [
    kdePackages.extra-cmake-modules
  ]);

  buildInputs =
    with kdePackages;
    [
      qtbase
      qtsvg
      qtwayland
    ]
    ++ (lib.optionals kdeSupport (
      with kdePackages;
      [
        kcolorscheme
        kconfig
        kiconthemes
        qtdeclarative
      ]
    ));

  cmakeFlags = [
    (lib.cmakeFeature "PLUGINDIR" "${placeholder "out"}/${qtbase.qtPluginPrefix}")
  ];

  meta = {
    description = "Qt6 Configuration Tool";
    homepage = "https://www.opencode.net/trialuser/qt6ct";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      Flakebi
      Scrumplex
      ReStranger
    ];
    mainProgram = "qt6ct";
  };
})
