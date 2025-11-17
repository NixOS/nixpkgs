{
  lib,
  buildPythonPackage,
  fetchgit,
  packaging,
  platformdirs,
  portalocker,
  pyparsing,
  setuptools,
  sympy,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "qmake2cmake";
  version = "1.0.7";
  pyproject = true;

  src = fetchgit {
    url = "https://codereview.qt-project.org/qt/qmake2cmake";
    tag = "v${version}";
    hash = "sha256-Y1HU4bNZY0b1C8HIX43AR24zoIyTEgkVXpnweEBlOYk=";
  };

  patches = [
    ./fix-locations.patch
  ];

  build-system = [ setuptools ];

  dependencies = [
    packaging
    platformdirs
    portalocker
    pyparsing
    sympy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Tool to convert qmake .pro files to CMakeLists.txt";
    homepage = "https://wiki.qt.io/Qmake2cmake";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
