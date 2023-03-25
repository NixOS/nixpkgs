{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, wrapQtAppsHook

# propagates
, pyasn1
, pyasn1-modules
, cxxfilt
, msgpack
, pycparser

# extras: gui
, pyqt5
, pyqtwebengine

# knobs
, withGui ? false
}:

buildPythonPackage rec {
  pname = "vivisect";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tAIhsHFds3qwPngfOsR1+xDKgi29ACnvFAYoklRnCAI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'cxxfilt>=0.2.1,<0.3.0' 'cxxfilt'
  '';

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

  pythonImportsCheck = [
    "vivisect"
  ];

  meta = with lib; {
    description = "Pure python disassembler, debugger, emulator, and static analysis framework";
    homepage = "https://github.com/vivisect/vivisect";
    changelog = "https://github.com/vivisect/vivisect/blob/v${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
