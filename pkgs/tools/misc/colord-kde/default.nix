{ stdenv, lib, fetchurl
, extra-cmake-modules, ki18n
, kconfig, kconfigwidgets, kcoreaddons, kdbusaddons, kiconthemes, kcmutils
, kio, knotifications, plasma-framework, kwidgetsaddons, kwindowsystem
, kitemviews, lcms2, libXrandr, qtx11extras
}:

stdenv.mkDerivation rec {
  pname = "colord-kde";
  version = "0.5.0";

  src = fetchurl {
    url = "http://download.kde.org/stable/colord-kde/${version}/src/${pname}-${version}.tar.xz";
    sha256 = "0brdnpflm95vf4l41clrqxwvjrdwhs859n7401wxcykkmw4m0m3c";
  };

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [
    kconfig kconfigwidgets kcoreaddons kdbusaddons kiconthemes
    kcmutils ki18n kio knotifications plasma-framework kwidgetsaddons
    kwindowsystem kitemviews lcms2 libXrandr qtx11extras
  ];

  meta = with lib; {
    homepage = https://projects.kde.org/projects/playground/graphics/colord-kde;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ttuegel ];
  };
}
