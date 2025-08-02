{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-python-dateutil";
  version = "2.9.0.20241206";
  pyproject = true;

  src = fetchPypi {
    pname = "types_python_dateutil";
    inherit version;
    hash = "sha256-GPSTQUwm/7ppKnI2n+p6FUxQJkYwHr/j1WoEs3ZyhMs=";
  };

  build-system = [ setuptools ];

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "dateutil-stubs" ];

  meta = {
    description = "Typing stubs for python-dateutil";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
