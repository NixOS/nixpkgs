{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-greenlet";
  version = "3.2.0.20250809";
  pyproject = true;

  src = fetchPypi {
    pname = "types_greenlet";
    inherit version;
    hash = "sha256-1yYUckmNnzPzfXBrwiHy0k13uVYDiM8UzvFYiOLj8kk=";
  };

  build-system = [ setuptools ];

  doCheck = false;

  pythonImportsCheck = [ "greenlet-stubs" ];

  meta = {
    description = "Typing stubs for greenlet";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
