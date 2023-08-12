{ lib
, buildPythonPackage
, fetchPypi
, click
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "vsure";
  version = "2.6.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d9t/zO1ROCndS+5kiFVyDbs+96z7GMHaH6T82b8hl40=";
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
