{ lib
, buildPythonPackage
, fetchgit
, packaging
, portalocker
, sympy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "qmake2cmake";
  version = "1.0.2";

  src = fetchgit {
    url = "https://codereview.qt-project.org/qt/qmake2cmake";
    rev = "v${version}";
    hash = "sha256-Ibi7tIaMI44POfoRfKsgTMR3u+Li5UzeHBUNylnc9dw=";
  };

  patches = [
    ./fix-locations.patch
  ];

  propagatedBuildInputs = [
    packaging
    portalocker
    sympy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Tool to convert qmake .pro files to CMakeLists.txt";
    homepage = "https://wiki.qt.io/Qmake2cmake";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wegank ];
  };
}
