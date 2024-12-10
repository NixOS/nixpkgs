{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qtbase,
  qt6,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "maskromtool";
  version = "2024-01-28";

  src = fetchFromGitHub {
    owner = "travisgoodspeed";
    repo = "maskromtool";
    rev = "v${version}";
    hash = "sha256-jYnJgZ4bn5NDSzNyhb46xnmzbF9Y59shw8y/2zmxiVM=";
  };

  buildInputs = [
    qtbase
    qt6.qtcharts
    qt6.qttools
  ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  meta = {
    description = "A CAD tool for extracting bits from Mask ROM photographs";
    homepage = "https://github.com/travisgoodspeed/maskromtool";
    license = [
      lib.licenses.beerware
      lib.licenses.gpl1Plus
    ];
    maintainers = [
      lib.maintainers.evanrichter
    ];
  };
}
