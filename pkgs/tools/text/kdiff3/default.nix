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
  version = "1.10.7";

  src = fetchurl {
    url = "mirror://kde/stable/kdiff3/kdiff3-${version}.tar.xz";
    hash = "sha256-/otpnRJM1NJjKzwnqgas7Fyqj8v4t2SM8MANektqzlA=";
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
