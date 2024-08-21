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
}:

buildPythonPackage rec {
  pname = "vivisect";
  version = "1.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-URRBEZelw4s43zqtb/GrLxIksvrqHbqQWntT9jVonhU=";
  };

  pythonRelaxDeps = [
    "cxxfilt"
    "pyasn1"
    "pyasn1-modules"
  ];

  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    pyasn1
    pyasn1-modules
    cxxfilt
    msgpack
    pycparser
  ] ++ lib.optionals (withGui) passthru.optional-dependencies.gui;

  passthru.optional-dependencies.gui = [
    pyqt5
    pyqtwebengine
  ];

  postFixup = ''
    wrapQtApp $out/bin/vivbin
  '';

  # requires another repo for test files
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
