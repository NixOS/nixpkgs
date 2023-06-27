{ lib
, buildPythonPackage
, fetchPypi
, click
, requests
}:

buildPythonPackage rec {
  pname = "vsure";
  version = "2.6.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8AqxLIrsFtAazH+ZqhXbkYNhlAhQ5XL/tNFRAGLh2kk=";
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
