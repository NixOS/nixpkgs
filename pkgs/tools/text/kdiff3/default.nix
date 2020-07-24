{
  mkDerivation, lib, fetchurl,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  kcrash, kconfig, kinit, kparts, kiconthemes
}:

mkDerivation rec {
  pname = "kdiff3";
  version = "1.8.3";

  src = fetchurl {
    url = "https://download.kde.org/stable/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1awb62y09kbkjhz22mdkrppd6w5aihd3l0ssvpil8c9hg8syjd9g";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];

  propagatedBuildInputs = [ kconfig kcrash kinit kparts kiconthemes ];

  meta = with lib; {
    homepage = "http://kdiff3.sourceforge.net/";
    license = licenses.gpl2Plus;
    description = "Compares and merges 2 or 3 files or directories";
    maintainers = with maintainers; [ peterhoeg ];
    platforms = with platforms; linux;
  };
}
