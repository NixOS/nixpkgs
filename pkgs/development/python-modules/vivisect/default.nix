{ lib
, buildPythonPackage
<<<<<<< HEAD
, cxxfilt
, fetchPypi
, msgpack
, pyasn1
, pyasn1-modules
, pycparser
, pyqt5
, pythonRelaxDepsHook
, pyqtwebengine
, pythonOlder
, withGui ? false
, wrapQtAppsHook
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "vivisect";
<<<<<<< HEAD
  version = "1.1.1";
=======
  version = "1.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-URRBEZelw4s43zqtb/GrLxIksvrqHbqQWntT9jVonhU=";
  };

  pythonRelaxDeps = [
    "cxxfilt"
    "pyasn1"
    "pyasn1-modules"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
=======
    hash = "sha256-tAIhsHFds3qwPngfOsR1+xDKgi29ACnvFAYoklRnCAI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'cxxfilt>=0.2.1,<0.3.0' 'cxxfilt'
  '';

  nativeBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    description = "Python disassembler, debugger, emulator, and static analysis framework";
=======
    description = "Pure python disassembler, debugger, emulator, and static analysis framework";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/vivisect/vivisect";
    changelog = "https://github.com/vivisect/vivisect/blob/v${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
