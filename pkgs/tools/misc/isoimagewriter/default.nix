{ lib, mkDerivation, fetchurl, cmake, extra-cmake-modules, wrapQtAppsHook,
karchive, kcoreaddons, kcrash, kiconthemes, kwidgetsaddons, solid, qgpgme }:
mkDerivation rec {
  pname = "isoimagewriter";
  version = "0.9.2";

  src = fetchurl {
    url = "mirror://kde/unstable/${pname}/${version}/${pname}-${version}.tar.xz";
    hash = "sha256-c6cHnGVKPOw/cGXlKWsc40/1ZbiUJH/H+XmffE0MQcU=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules wrapQtAppsHook ];
  buildInputs = [
    karchive
    kcoreaddons
    kcrash
    kiconthemes
    kwidgetsaddons
    solid
    qgpgme
  ];

  meta = {
    description = "ISO Image Writer is a tool to write a .iso file to a USB disk.";
    homepage = "https://invent.kde.org/utilities/isoimagewriter";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ k900 ];
  };
}
