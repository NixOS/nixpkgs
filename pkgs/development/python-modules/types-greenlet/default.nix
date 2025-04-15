{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-greenlet";
  version = "3.1.0.20250401";
  pyproject = true;

  src = fetchPypi {
    pname = "types_greenlet";
    inherit version;
    hash = "sha256-lJOJtkw0ypRy9jNRien+Cy6XBENtTwhQ456bcUWQkII=";
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
