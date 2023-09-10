{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "traits";
  version = "6.4.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-W+fMX7epnLp+kBR4Y3PjrS9177RF7s7QlGVLuvOw+oI=";
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
