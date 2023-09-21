{ lib
, buildPythonPackage
, fetchPypi
, click
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "vsure";
  version = "2.6.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/eVFa1BTFbvFTAt48Bv+bjsV7f2eVSuKARJQVxDqU9s=";
  };

  propagatedBuildInputs = [
    click
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "verisure"
  ];

  meta = with lib; {
    description = "Python library for working with verisure devices";
    homepage = "https://github.com/persandstrom/python-verisure";
    changelog = "https://github.com/persandstrom/python-verisure#version-history";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
