{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-tabulate";
  version = "0.10.0.20260308";
  pyproject = true;

  src = fetchPypi {
    pname = "types_tabulate";
    inherit version;
    hash = "sha256-ck3LEzD/ul9G089uKfRQifzLjoWAHm56ye+xGVv3vqE=";
  };

  build-system = [ setuptools ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "tabulate-stubs" ];

  meta = {
    description = "Typing stubs for tabulate";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jpetrucciani ];
  };
}
