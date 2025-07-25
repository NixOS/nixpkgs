{
  lib,
  python3Packages,
  fetchgit,
}:

python3Packages.buildPythonPackage rec {
  pname = "qmake2cmake";
  version = "1.0.6";
  format = "setuptools";

  src = fetchgit {
    url = "https://codereview.qt-project.org/qt/qmake2cmake";
    rev = "v${version}";
    hash = "sha256-M5XVQ8MXo2Yxg5eZCho2YAGFtB0h++mEAg8NcQVuP/w=";
  };

  patches = [
    ./fix-locations.patch
  ];

  propagatedBuildInputs = with python3Packages; [
    packaging
    platformdirs
    portalocker
    pyparsing
    sympy
  ];

  nativeCheckInputs = with python3Packages; [
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
