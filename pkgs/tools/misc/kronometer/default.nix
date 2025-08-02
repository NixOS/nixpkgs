{
  mkDerivation,
  fetchurl,
  lib,
  extra-cmake-modules,
  kdoctools,
  kconfig,
  kcrash,
  kinit,
}:

mkDerivation rec {
  pname = "kronometer";
  version = "2.3.0";

  src = fetchurl {
    url = "mirror://kde/stable/kronometer/${version}/src/kronometer-${version}.tar.xz";
    sha256 = "sha256-dbnhom8PRo0Bay3DzS2P0xQSrJaMXD51UadQL3z6xHY=";
  };

  meta = {
    homepage = "https://kde.org/applications/utilities/kronometer/";
    description = "Stopwatch application";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ peterhoeg ];
    mainProgram = "kronometer";
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  propagatedBuildInputs = [
    kconfig
    kcrash
    kinit
  ];
}
