{ lib
, stdenv
, fetchFromGitHub
, cmake
, qtbase
, qt6
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "maskromtool";
  version = "2023-05-30";

  src = fetchFromGitHub {
    owner = "travisgoodspeed";
    repo = "maskromtool";
    rev = "v${version}";
    hash = "sha256-HiP9igrq9rmW7MxdTdOsJ86j/Ccxb2lFTaIJfyUW7Bo=";
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
