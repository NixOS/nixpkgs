{ stdenv, lib, fetchgit
, extra-cmake-modules, ki18n
, kconfig, kconfigwidgets, kcoreaddons, kdbusaddons, kiconthemes, kcmutils
, kio, knotifications, plasma-framework, kwidgetsaddons, kwindowsystem
, kitemviews, lcms2, libXrandr, qtx11extras
}:

stdenv.mkDerivation {
  name = "colord-kde-0.5.0.20160224";
  src = fetchgit {
    url = "git://anongit.kde.org/colord-kde";
    rev = "3729d1348c57902b74283bc8280ffb5561b221db";
    sha256 = "03ww8nskgxl38dwkbb39by18gxvrcm6w2zg9s7q05i76rpl6kkkw";
  };

  nativeBuildInputs = [ extra-cmake-modules ki18n ];

  buildInputs = [
    kconfig kconfigwidgets kcoreaddons kdbusaddons kiconthemes
    kcmutils kio knotifications plasma-framework kwidgetsaddons
    kwindowsystem kitemviews lcms2 libXrandr qtx11extras
  ];

  meta = with lib; {
    homepage = "https://projects.kde.org/projects/playground/graphics/colord-kde";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ttuegel ];
  };
}
