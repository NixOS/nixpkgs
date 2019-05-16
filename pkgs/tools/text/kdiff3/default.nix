{
  mkDerivation, lib, fetchurl,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  kcrash, kconfig, kinit, kparts
}:

mkDerivation rec {
  pname = "kdiff3";
  version = "1.8";

  src = fetchurl {
    url = "https://download.kde.org/stable/${pname}/${pname}-${version}.tar.xz";
    sha256 = "083pz5c1w7l9h4sb8zz8a763yph5sk3mxnhpdykz1rrggy9f8p54";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];

  propagatedBuildInputs = [ kconfig kcrash kinit kparts ];

  meta = with lib; {
    homepage = http://kdiff3.sourceforge.net/;
    license = licenses.gpl2Plus;
    description = "Compares and merges 2 or 3 files or directories";
    maintainers = with maintainers; [ peterhoeg ];
    platforms = with platforms; linux;
  };
}
