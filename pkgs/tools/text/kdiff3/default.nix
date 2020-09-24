{
  mkDerivation, lib, fetchurl,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  kcrash, kconfig, kinit, kparts, kiconthemes
}:

mkDerivation rec {
  pname = "kdiff3";
  version = "1.8.4";

  src = fetchurl {
    url = "https://download.kde.org/stable/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1f1vyhvc31yfxspv5lzw8qjd2w8x74s2fmij1921m307g84qxqbn";
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
