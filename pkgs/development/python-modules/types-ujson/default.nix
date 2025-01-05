{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-ujson";
  version = "5.10.0.20240515";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zq5xJ/Da/kr13Q7PmO4T6ddZUe+WO1xam36pLg1x8Nc=";
  };

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "ujson-stubs" ];

  meta = with lib; {
    description = "Typing stubs for ujson";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ centromere ];
  };
}
