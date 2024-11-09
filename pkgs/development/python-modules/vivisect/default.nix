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
  pythonOlder,
  withGui ? false,
  wrapQtAppsHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "vivisect";
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zBWrVBub48rYBg7k9CDmgCWPpPz3R38/mtUCM1P3Mpk=";
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
  ] ++ lib.optionals (withGui) optional-dependencies.gui;

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

  meta = with lib; {
    description = "Python disassembler, debugger, emulator, and static analysis framework";
    homepage = "https://github.com/vivisect/vivisect";
    changelog = "https://github.com/vivisect/vivisect/blob/v${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
