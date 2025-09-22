{
  lib,
  buildPythonPackage,
  fetchgit,
  packaging,
  platformdirs,
  portalocker,
  pyparsing,
  sympy,
  pytestCheckHook,
}:

buildPythonPackage rec {
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
