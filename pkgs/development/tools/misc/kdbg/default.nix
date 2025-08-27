{
  lib,
  stdenv,
  fetchurl,
  cmake,
  qt6,
  kdePackages,
}:

stdenv.mkDerivation rec {
  pname = "kdbg";
  version = "3.2.0";
  src = fetchurl {
    url = "mirror://sourceforge/kdbg/${version}/kdbg-${version}.tar.gz";
    hash = "sha256-GoWLKWD/nWXBTiTbDLxeNArDMyPI/gSzADqyOgxrNHE=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    qt6.qt5compat
    qt6.qtbase
    kdePackages.ki18n
    kdePackages.kconfig
    kdePackages.kiconthemes
    kdePackages.kxmlgui
    kdePackages.kwindowsystem
  ];

  cmakeFlags = [
    (lib.cmakeFeature "BUILD_FOR_KDE_VERSION" "6")
  ];

  postInstall = ''
    wrapProgram $out/bin/kdbg --prefix QT_PLUGIN_PATH : ${qt6.qtbase}/${qt6.qtbase.qtPluginPrefix}
  '';

  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://www.kdbg.org/";
    description = ''
      A graphical user interface to gdb, the GNU debugger. It provides an
      intuitive interface for setting breakpoints, inspecting variables, and
      stepping through code.
    '';
    mainProgram = "kdbg";
    license = licenses.gpl2;
    maintainers = [ maintainers.catern ];
  };
}
