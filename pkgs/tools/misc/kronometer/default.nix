{
  mkDerivation, fetchurl, lib,
<<<<<<< HEAD
  extra-cmake-modules, kdoctools,
=======
  extra-cmake-modules, kdoctools, wrapGAppsHook,
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  kconfig, kcrash, kinit
}:

mkDerivation rec {
  pname = "kronometer";
  version = "2.3.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${pname}-${version}.tar.xz";
    sha256 = "sha256-dbnhom8PRo0Bay3DzS2P0xQSrJaMXD51UadQL3z6xHY=";
  };

  meta = with lib; {
    homepage = "https://kde.org/applications/utilities/kronometer/";
    description = "A stopwatch application";
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [ kconfig kcrash kinit ];
}
