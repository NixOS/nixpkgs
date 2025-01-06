{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-dataclasses";
  version = "0.6.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S1ovz45WjVoZdM1pAQ4yDhr4JRF37JaN57m7SapJ97k=";
  };

  build-system = [ setuptools ];

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "dataclasses-stubs" ];

  meta = with lib; {
    description = "Typing stubs for dataclasses";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
