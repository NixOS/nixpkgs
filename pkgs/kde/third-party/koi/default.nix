{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kconfig,
  kcoreaddons,
  kwidgetsaddons,
  wrapQtAppsHook,
  kdbusaddons,
  kde-cli-tools,
  plasma-workspace,
  qtstyleplugin-kvantum,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "koi";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "baduhai";
    repo = "Koi";
    tag = finalAttrs.version;
    hash = "sha256-YRbS+WZaK0gJxNTU0KKi122Sn2hVk8t0vFhYr91sGfY=";
  };

  patches = [
    # koi tries to access KDE utility binaries at their absolute paths or by using `whereis`.
    # We patch the absolute paths below in `postPatch` and replace the `whereis` invocations
    # here with a placeholder that is also substituted in `postPatch`.
    ./0001-locate-plasma-tools.patch
  ];

  postPatch = ''
    substituteInPlace src/utils.cpp \
      --replace-fail /usr/bin/kquitapp6 ${lib.getExe' kdbusaddons "kquitapp6"} \
      --replace-fail /usr/bin/kstart ${lib.getExe' kde-cli-tools "kstart"}
    substituteInPlace src/plugins/plasmastyle.cpp \
      --replace-fail /usr/bin/plasma-apply-desktoptheme ${lib.getExe' plasma-workspace "plasma-apply-desktoptheme"}
    substituteInPlace src/plugins/colorscheme.cpp \
      --replace-fail '@plasma-apply-colorscheme@' ${lib.getExe' plasma-workspace "plasma-apply-colorscheme"}
    substituteInPlace src/plugins/icons.cpp \
      --replace-fail '@plasma-changeicons@' ${plasma-workspace}/libexec/plasma-changeicons
    substituteInPlace src/plugins/kvantumstyle.cpp \
      --replace-fail /usr/bin/kvantummanager ${lib.getExe' qtstyleplugin-kvantum "kvantummanager"}
  '';

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];
  buildInputs = [
    kconfig
    kcoreaddons
    kwidgetsaddons
  ];

  meta = {
    description = "Scheduling LIGHT/DARK Theme Converter for the KDE Plasma Desktop";
    longDescription = ''
      Koi is a program designed to provide the KDE Plasma Desktop functionality to automatically switch between light and dark themes. Koi is under semi-active development, and while it is stable enough to use daily, expect bugs. Koi is designed to be used with Plasma, and while some features may function under different desktop environments, they are unlikely to work and untested.

      Features:

      - Toggle between light and dark presets based on time
      - Change Plasma style
      - Change Qt colour scheme
      - Change Icon theme
      - Change GTK theme
      - Change wallpaper
      - Hide application to system tray
      - Toggle between LIGHT/DARK themes by clicking mouse wheel
    '';
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.linux;
    changelog = "https://github.com/baduhai/Koi/releases/tag/${finalAttrs.version}";
    homepage = "https://github.com/baduhai/Koi";
    maintainers = with lib.maintainers; [ fnune ];
  };
})
