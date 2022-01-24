{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "traits";
  version = "6.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4520ef4a675181f38be4a5bab1b1d5472691597fe2cfe4faf91023e89407e2c6";
  };

  # Circular dependency
  doCheck = false;

  pythonImportsCheck = [
    "traits"
  ];

  meta = with lib; {
    description = "Explicitly typed attributes for Python";
    homepage = "https://pypi.python.org/pypi/traits";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
