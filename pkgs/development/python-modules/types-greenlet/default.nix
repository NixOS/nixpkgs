{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-greenlet";
  version = "3.3.0.20251206";
  pyproject = true;

  src = fetchPypi {
    pname = "types_greenlet";
    inherit version;
    hash = "sha256-PhqzEqtxVMCO3C6BEPvwDZkgMj7cEUStRZt7AFIGMFU=";
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
