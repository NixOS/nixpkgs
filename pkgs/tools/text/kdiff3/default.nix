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
<<<<<<< HEAD
  version = "1.10.5";

  src = fetchurl {
    url = "https://download.kde.org/stable/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-2wMm0khBGnqaxBMBx/8O83ecvwQKMw/yhQDdwtTxjIw=";
=======
  version = "1.10.1";

  src = fetchurl {
    url = "https://download.kde.org/stable/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-IFQ0kw9nU2wgUZFir33fQ1hG4qGhJdegmG9M4n+bM8g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
