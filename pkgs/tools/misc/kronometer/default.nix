{
  mkDerivation,
  fetchurl,
  fetchpatch,
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

  patches = [
    (fetchpatch {
      url = "https://invent.kde.org/utilities/kronometer/-/commit/949f1dccd48f4a1e3068e24d241c5ce73fe2ab8f.patch";
      hash = "sha256-zv9ty25vQXr3xB1S7QmXx3YIouOVUoMpdZ9gHBD1gMQ=";
    })
  ];

  meta = with lib; {
    homepage = "https://kde.org/applications/utilities/kronometer/";
    description = "Stopwatch application";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ peterhoeg ];
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
