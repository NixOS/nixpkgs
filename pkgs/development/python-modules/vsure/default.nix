{ lib
, buildPythonPackage
, fetchPypi
, click
, requests
}:

buildPythonPackage rec {
  pname = "vsure";
  version = "2.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KMLW1270Xs9s2a4ROWTvwRpfr4n4RO9rIYlskNjGzFQ=";
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
