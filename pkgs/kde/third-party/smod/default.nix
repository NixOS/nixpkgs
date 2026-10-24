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
  pname = "smod";
  version = "6.7.4-unstable-2026-08-23";

  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "gitgud.io";
    owner = "aeroshell";
    repo = "smod";
    rev = "44bbe37c8680df37779d157ac119a5f28f4fca78";
    hash = "sha256-Ha2K+BwptTH3YEHQRZt2Rdav68h6qKYWcTB8NA3ocoA=";
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
  ];

  postInstall = ''
    export PKG_CONFIG_PATH=$out/lib/pkgconfig''${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}

    cmake -S .. -B build-smodglow-x11 \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=$out \
      -DCMAKE_INSTALL_LIBDIR=$out/lib \
      -DBUILD_DECORATION=OFF \
      -DBUILD_EFFECT=OFF \
      -DBUILD_EFFECTX11=ON \
      -DBUILD_TESTING=OFF \
      -DKDE_INSTALL_PLUGINDIR=$out/${qtbase.qtPluginPrefix}
    cmake --build build-smodglow-x11 -j$NIX_BUILD_CORES
    cmake --install build-smodglow-x11
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch=Plasma/${lib.versions.majorMinor finalAttrs.version}" ];
  };

  meta = {
    description = "AeroShell SMOD KDecoration3 engine";
    homepage = "https://gitgud.io/aeroshell/smod";
    license = with lib.licenses; [
      agpl3Only
      bsd3
      gpl2Only
      gpl2Plus
      gpl3Only
      mit
    ];
    maintainers = with lib.maintainers; [ aaravrav ];
    platforms = lib.platforms.linux;
  };
})
