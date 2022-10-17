{ buildPythonPackage
, callPackage
, fetchPypi
, packaging
, typing-extensions
, tomli
, setuptools
, lib
}:

buildPythonPackage rec {
  pname = "setuptools-scm";
  version = "7.0.5";

  src = fetchPypi {
    pname = "setuptools_scm";
    inherit version;
    sha256 = "sha256-Ax4Tr3cdb4krlBrbbqBFRbv5Hrxc5ox4qvP/9uH7SEQ=";
  };

  propagatedBuildInputs = [
    packaging
    typing-extensions
    tomli
    setuptools
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
