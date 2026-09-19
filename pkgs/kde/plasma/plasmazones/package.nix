# PlasmaZones — FancyZones-style window tiling for KDE Plasma
# SPDX-License-Identifier: GPL-3.0-or-later
{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  wayland,
  wayland-scanner,
  vulkan-headers,
  vulkan-loader,
  qt6,
  kdePackages,
}:

# PlasmaZones requires Qt 6.6+ and KWin 6.6+.
assert
  (lib.versionAtLeast (lib.getVersion qt6.qtbase) "6.6")
  || throw ''
    PlasmaZones requires Qt 6.6+ and KDE/Plasma 6.6+ (KWin 6.6+).
    Your nixpkgs provides Qt ${lib.getVersion qt6.qtbase}.
    Use nixos-unstable or a nixpkgs revision that includes the Plasma 6.6 stack.
  '';

stdenv.mkDerivation (finalAttrs: {
  pname = "plasmazones";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "fuddlesworth";
    repo = "PlasmaZones";
    rev = "a4d254b564c776adb9be5cc631ca88f5fda4ac8e";
    hash = "sha256-CR4B3N5xYKxAEbXVG72wsHbi1IZxpNXIOZ7U/A7PzZo=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    wayland-scanner # Generates C bindings from Wayland protocol XMLs at build time
    qt6.wrapQtAppsHook # Wraps binaries so they find Qt plugins at runtime
    kdePackages.extra-cmake-modules # KDEInstallDirs, KDECMakeSettings, KDECompilerSettings
  ];

  buildInputs = [
    qt6.qtbase # Core, Gui, Widgets, DBus, Concurrent
    qt6.qtdeclarative # Qml, Quick, QuickControls2
    qt6.qtshadertools # ShaderTools, ShaderToolsPrivate (zone overlay shaders)
    qt6.qtsvg # Svg (icon rendering)
    qt6.qtwayland # WaylandClient, WaylandClientPrivate (layer-shell QPA)
    wayland # libwayland-client (direct Wayland protocol access)
    vulkan-headers # Vulkan headers for QVulkanInstance (build-time only)
    vulkan-loader # libvulkan.so (Vulkan RHI backend)
  ]
  ++ (with kdePackages; [
    kcmutils # KDE System Settings module support
    kglobalaccel # System-wide keyboard shortcuts
    kirigami # QML UI framework used by the settings app
    kwin # KWin effect plugin API (IID must match the running KWin)
    plasma-activities # Optional: per-activity zone layouts
  ]);

  # The KCM (.so plugin loaded by systemsettings) and other QML consumers need
  # these available at runtime in the user environment.
  propagatedBuildInputs = with kdePackages; [
    kirigami # org.kde.kirigami QML module
    qqc2-desktop-style # org.kde.desktop Qt Quick Controls 2 style
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DUSE_KDE_FRAMEWORKS=ON" # Full KDE build: KWin effect + KCM + shortcuts
    "-DBUILD_KWIN_EFFECT=ON" # KWin C++ effect plugin (visual zone overlays)
    "-DBUILD_TESTING=OFF" # Tests require a running Wayland compositor
    "-DBUILD_TOOLS=OFF" # Developer tools not needed in packages
    "-DBUILD_PHOSPHOR_SHELL=OFF" # WIP shell component, not ready for packaging
  ];

  # ECM's KDEInstallDirs may resolve KDE_INSTALL_SYSTEMDUSERUNITDIR to an
  # absolute host path (e.g. /usr/lib/systemd/user) that falls outside $out
  # in the Nix sandbox. Force the relative path so the unit lands in $out.
  preConfigure = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'if(NOT DEFINED KDE_INSTALL_SYSTEMDUSERUNITDIR)' \
        'if(TRUE)  # Nix: always force relative systemd unit path'
  '';

  meta = {
    description = "FancyZones-style window tiling and autotiling for KDE Plasma";
    longDescription = ''
      PlasmaZones brings Windows PowerToys FancyZones-style zone management to
      KDE Plasma. Define zones on your screen, drag windows into them to snap
      and resize. Features include autotiling with 24 algorithms, a visual
      layout editor, GLSL shader effects, per-monitor and per-virtual-desktop
      layouts, and full KDE integration via a KWin effect plugin and System
      Settings module.

      After installing, enable the daemon:
        systemctl --user enable --now plasmazones.service

      Then refresh the KDE service cache so the System Settings entry appears:
        kbuildsycoca6 --noincremental
    '';
    homepage = "https://github.com/fuddlesworth/PlasmaZones";
    changelog = "https://github.com/fuddlesworth/PlasmaZones/blob/main/CHANGELOG.md";
    license = with lib.licenses; [
      gpl3Plus # PlasmaZones itself
      lgpl21Plus # Bundled Phosphor component libraries
    ];
    maintainers = with lib.maintainers; [ disciple153 ];
    platforms = lib.platforms.linux;
    mainProgram = "plasmazonesd";
  };
})
