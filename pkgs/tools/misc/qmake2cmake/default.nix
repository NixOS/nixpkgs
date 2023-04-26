{ lib
, buildPythonPackage
, fetchgit
, packaging
, platformdirs
, portalocker
, pyparsing
, sympy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "qmake2cmake";
  version = "1.0.5";

  src = fetchgit {
    url = "https://codereview.qt-project.org/qt/qmake2cmake";
    rev = "v${version}";
    hash = "sha256-6a1CIzHj9kmNgWN6QPNNUbiugkyfSrrIb7Fbz0ocr6o=";
  };

  patches = [
    ./fix-locations.patch
  ];

  propagatedBuildInputs = [
    packaging
    platformdirs
    portalocker
    pyparsing
    sympy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Tool to convert qmake .pro files to CMakeLists.txt";
    homepage = "https://wiki.qt.io/Qmake2cmake";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wegank ];
  };
}
