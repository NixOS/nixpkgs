{
  lib,
  buildPythonPackage,
  fetchPypi,
  click,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "vsure";
  version = "2.6.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dz7Ud8sOIz/w9IiRgDZWDln65efgf6skNmECwg+MRw0=";
  };

  propagatedBuildInputs = [
    click
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "verisure" ];

  meta = with lib; {
    description = "Python library for working with verisure devices";
    mainProgram = "vsure";
    homepage = "https://github.com/persandstrom/python-verisure";
    changelog = "https://github.com/persandstrom/python-verisure#version-history";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
