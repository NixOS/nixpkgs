{
  lib,
  buildPythonPackage,
  cxxfilt,
  fetchPypi,
  msgpack,
  pyasn1,
  pyasn1-modules,
  pycparser,
  pyqt5,
  pyqtwebengine,
  withGui ? false,
  wrapQtAppsHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "vivisect";
  version = "1.3.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UQryZ4aGVEr5vRLElmTwRNtgi3h6CPzzq5n+E58tuo8=";
  };

  pythonRelaxDeps = [
    "cxxfilt"
    "msgpack"
    "pyasn1"
    "pyasn1-modules"
  ];

  build-system = [ setuptools ];

  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  dependencies = [
    pyasn1
    pyasn1-modules
    cxxfilt
    msgpack
    pycparser
  ]
  ++ lib.optionals withGui optional-dependencies.gui;

  optional-dependencies.gui = [
    pyqt5
    pyqtwebengine
  ];

  postFixup = ''
    wrapQtApp $out/bin/vivbin
  '';

  # Tests requires another repo for test files
  doCheck = false;

  pythonImportsCheck = [ "vivisect" ];

  meta = {
    description = "Python disassembler, debugger, emulator, and static analysis framework";
    homepage = "https://github.com/vivisect/vivisect";
    changelog = "https://github.com/vivisect/vivisect/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
