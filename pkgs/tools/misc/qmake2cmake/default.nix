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
  version = "1.0.7";
  format = "setuptools";

  src = fetchgit {
    url = "https://codereview.qt-project.org/qt/qmake2cmake";
    tag = "v${version}";
    hash = "sha256-Y1HU4bNZY0b1C8HIX43AR24zoIyTEgkVXpnweEBlOYk=";
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
