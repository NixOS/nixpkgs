{
  mkDerivation, lib, fetchurl,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  kcrash, kconfig, kinit, kparts, kiconthemes
}:

mkDerivation rec {
  pname = "kdiff3";
  version = "1.8.5";

  src = fetchurl {
    url = "https://download.kde.org/stable/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-vJL30E6xI/nFbb4wR69nv3FSQPqZSHrB0czypF4IVME=";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];

  propagatedBuildInputs = [ kconfig kcrash kinit kparts kiconthemes ];

  meta = with lib; {
    homepage = "https://invent.kde.org/sdk/kdiff3";
    license = licenses.gpl2Plus;
    description = "Compares and merges 2 or 3 files or directories";
    maintainers = with maintainers; [ peterhoeg ];
    platforms = with platforms; linux;
  };
}
