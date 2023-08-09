{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pythonOlder
, numpy
, jsonschema
, svgwrite
}:

buildPythonPackage rec {
  pname = "tskit";
  version = "0.5.5";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-phhBTAHAPlBnmzSiLmPYDMg1Mui85NZacni3WuYAc6c=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
    jsonschema
    svgwrite
  ];

  # Pypi does not include test folder and too complex to compile from GitHub source
  # will ask upstream to include tests in pypi
  doCheck = false;

  pythonImportsCheck = [
    "tskit"
  ];

  meta = with lib; {
    description = "The tree sequence toolkit";
    homepage = "https://github.com/tskit-dev/tskit";
    license = licenses.mit;
    maintainers = with maintainers; [ alxsimon ];
  };
}
