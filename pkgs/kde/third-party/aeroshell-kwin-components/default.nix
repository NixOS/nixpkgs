{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  extra-cmake-modules,
  kcmutils,
  kcolorscheme,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdecoration,
  kguiaddons,
  ki18n,
  kiconthemes,
  kio,
  kirigami,
  knotifications,
  kservice,
  ksvg,
  kwidgetsaddons,
  kwin,
  kwin-x11,
  kwindowsystem,
  libepoxy,
  libx11,
  libxcb,
  nix-update-script,
  pkg-config,
  qtbase,
  qtdeclarative,
  qttools,
  qtwayland,
  vulkan-headers,
  vulkan-loader,
  wayland-protocols,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aeroshell-kwin-components";
  version = "6.7.0-unstable-2026-08-08";

  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "gitgud.io";
    owner = "aeroshell";
    repo = "aeroshell-kwin-components";
    rev = "ba5b59a4b5270a71a17768e0e7a22dc1be926833";
    hash = "sha256-w+C0bNbf23GIyDcAtjqfDsRXI1dTx2KqU7x+6/cG4rE=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    kcmutils
    kcolorscheme
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdecoration
    kguiaddons
    ki18n
    kiconthemes
    kio
    kirigami
    knotifications
    kservice
    ksvg
    kwidgetsaddons
    kwin
    kwin-x11
    kwindowsystem
    libepoxy
    libx11
    libxcb
    qtbase
    qtdeclarative
    qttools
    qtwayland
    vulkan-headers
    vulkan-loader
    wayland-protocols
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" false)
    (lib.cmakeBool "KWIN_BUILD_WAYLAND" true)
  ];

  postInstall = ''
    # The Wayland build already installs shared data, rules, and translations, so omit them from the X11 build
    cmake -S .. -B build-x11 -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$out -DBUILD_TESTING=OFF \
      -DKWIN_BUILD_WAYLAND=OFF -DKWIN_INSTALL_MISC=OFF
    cmake --build build-x11 -j$NIX_BUILD_CORES
    cmake --install build-x11

    ln -s kwin $out/share/kwin-x11
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch=Plasma/${lib.versions.majorMinor finalAttrs.version}" ];
  };

  meta = {
    description = "AeroShell components related to KWin";
    homepage = "https://gitgud.io/aeroshell/aeroshell-kwin-components";
    license = with lib.licenses; [
      agpl3Only
      cc0
      gpl2Only
      gpl2Plus
      gpl3Only
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ aaravrav ];
    platforms = lib.platforms.linux;
  };
})
