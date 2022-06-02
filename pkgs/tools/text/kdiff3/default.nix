{ mkDerivation
, lib
, fetchurl
, extra-cmake-modules
, kdoctools
, wrapGAppsHook
, boost
, kcrash
, kconfig
, kinit
, kparts
, kiconthemes
}:

mkDerivation rec {
  pname = "kdiff3";
  version = "1.9.5";

  src = fetchurl {
    url = "https://download.kde.org/stable/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-CDchWW2dQ3O8LxKYOUqN21tVp61NckKTOnzYrmRoPBo=";
  };

  buildInputs = [ boost ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];

  propagatedBuildInputs = [ kconfig kcrash kinit kparts kiconthemes ];

  cmakeFlags = [ "-Wno-dev" ];

  meta = with lib; {
    description = "Compares and merges 2 or 3 files or directories";
    homepage = "https://invent.kde.org/sdk/kdiff3";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = with platforms; linux;
  };
}
