{ lib
, buildPythonPackage
, fetchPypi
, hatch-vcs
, hatchling
, pythonOlder
, pythonRelaxDepsHook
, setuptools
, testscenarios
, traceback2
}:

buildPythonPackage rec {
  pname = "testtools";
  version = "2.7.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-323pYBDinuIfY3oUfqvzDVCyXjhB3R1o+T7onOd+Nmw=";
  };

  pythonRemoveDeps = [
    "fixtures"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
    setuptools
  ];

  buildInputs = [
    traceback2
  ];

  # testscenarios has a circular dependency on testtools
  doCheck = false;

  pythonImportsCheck = [
    "testtools"
  ];

  meta = with lib; {
    description = "A set of extensions to the Python standard library's unit testing framework";
    homepage = "https://github.com/testing-cabal/testtools";
    changelog = "https://github.com/testing-cabal/testtools/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
