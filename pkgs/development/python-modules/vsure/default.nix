{ lib
, buildPythonPackage
, click
, fetchPypi
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "vsure";
  version = "2.5.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ANky4lJnL4W9E9gnYDRaI4myjQ1MKfzv+N2l4Rxjy64=";
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
