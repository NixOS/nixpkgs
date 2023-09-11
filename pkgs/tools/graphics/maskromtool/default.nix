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
  version = "2023-08-06";

  src = fetchFromGitHub {
    owner = "travisgoodspeed";
    repo = "maskromtool";
    rev = "v${version}";
    hash = "sha256-CsGa+MQP0EtG3cPxhD1ymZt20QsYMh94XWppbLdvIaE=";
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
