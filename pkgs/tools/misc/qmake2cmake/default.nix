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

buildPythonPackage {
  pname = "qmake2cmake";
  version = "1.0.8";
  pyproject = true;

  src = fetchgit {
    url = "https://codereview.qt-project.org/qt/qmake2cmake";
    # v1.0.8 is untagged
    rev = "2ae9ac3a5a657f58d7eea0824ead217e495d048b";
    hash = "sha256-LLP/sdFNsBYrz9gAh76QymtK71T+ZyknTGJiHGJnanU=";
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
