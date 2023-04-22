{ lib
, buildPythonPackage
, fetchgit
, packaging
, portalocker
, pyparsing
, sympy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "qmake2cmake";
  version = "1.0.3";

  src = fetchgit {
    url = "https://codereview.qt-project.org/qt/qmake2cmake";
    rev = "v${version}";
    hash = "sha256-HzbygFmnKq3E2eEdWCFa4z9Qszfck7dJm2Z5s+il4I0=";
  };

  patches = [
    ./fix-locations.patch
  ];

  propagatedBuildInputs = [
    packaging
    portalocker
    pyparsing
    sympy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Tool to convert qmake .pro files to CMakeLists.txt";
    homepage = "https://wiki.qt.io/Qmake2cmake";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wegank ];
  };
}
