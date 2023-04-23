{ buildPythonPackage
, callPackage
, fetchPypi
, packaging
, typing-extensions
, tomli
, setuptools
, pythonOlder
, lib
}:

buildPythonPackage rec {
  pname = "setuptools-scm";
  version = "7.1.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "setuptools_scm";
    inherit version;
    hash = "sha256-bFCDRadxqtfVbr/w5wYovysOx1c3Yr6ZYCFHMN4njyc=";
  };

  nativeBuildInputs = [
    packaging
    setuptools
    typing-extensions
  ];

  propagatedBuildInputs = [
    packaging
    setuptools
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  pythonImportsCheck = [
    "setuptools_scm"
  ];

  # check in passthru.tests.pytest to escape infinite recursion on pytest
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = with lib; {
    homepage = "https://github.com/pypa/setuptools_scm/";
    description = "Handles managing your python package versions in scm metadata";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
