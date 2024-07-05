{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "traits";
  version = "6.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qbv9ngwIt94H6G72TmnLlqKcIQWkO/gyzYsWL6HiL0Q=";
  };

  # Circular dependency
  doCheck = false;

  pythonImportsCheck = [ "traits" ];

  meta = with lib; {
    description = "Explicitly typed attributes for Python";
    homepage = "https://pypi.python.org/pypi/traits";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
