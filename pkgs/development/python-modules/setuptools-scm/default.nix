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
  version = "8.0.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tfQ/9oAGaVlRk/0JiRVk7p0dfcsZbKtLJQbVOi4clcc=";
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
    maintainers = with maintainers; [ nickcao ];
  };
}
