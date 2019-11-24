{
  mkDerivation, lib, fetchurl,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  kcrash, kconfig, kinit, kparts, kiconthemes
}:

mkDerivation rec {
  pname = "kdiff3";
  version = "1.8.1";

  src = fetchurl {
    url = "https://download.kde.org/stable/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0vj3rw5w0kry2c1y8gv6hniam417w7k3ydb1dkf5xwr4iprw0xvq";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];

  propagatedBuildInputs = [ kconfig kcrash kinit kparts kiconthemes ];

  meta = with lib; {
    homepage = http://kdiff3.sourceforge.net/;
    license = licenses.gpl2Plus;
    description = "Compares and merges 2 or 3 files or directories";
    maintainers = with maintainers; [ peterhoeg ];
    platforms = with platforms; linux;
  };
}
