{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "traits";
<<<<<<< HEAD
  version = "6.4.2";
=======
  version = "6.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-W+fMX7epnLp+kBR4Y3PjrS9177RF7s7QlGVLuvOw+oI=";
=======
    hash = "sha256-eLssyv1gr/YGUVqsRt5kZooKgctcVMZQuYd6hBqp6BI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
