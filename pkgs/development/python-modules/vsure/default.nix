{ lib
, buildPythonPackage
, fetchPypi
, click
, requests
}:

buildPythonPackage rec {
  pname = "vsure";
  version = "2.6.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-D6Q76L1BVx5hpFSShP1rUOmgTogEO+6Jj5x8GaepC+c=";
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
