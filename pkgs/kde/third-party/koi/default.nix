{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kconfig,
  kcoreaddons,
  kwidgetsaddons,
  wrapQtAppsHook,
}:
stdenv.mkDerivation rec {
  pname = "koi";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "baduhai";
    repo = "Koi";
    rev = version;
    sha256 = "sha256-ip7e/Sz/l5UiTFUTLJPorPO7NltE2Isij2MCmvHZV40=";
  };

  # See https://github.com/baduhai/Koi/blob/master/development/Nix%20OS/dev.nix
  sourceRoot = "source/src";
  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];
  buildInputs = [
    kconfig
    kcoreaddons
    kwidgetsaddons
  ];

  meta = with lib; {
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
    license = licenses.lgpl3;
    platforms = platforms.linux;
    homepage = "https://github.com/baduhai/Koi";
    maintainers = with lib.maintainers; [ fnune ];
  };
}
