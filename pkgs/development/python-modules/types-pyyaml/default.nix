{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-pyyaml";
  version = "6.0.12.20250915";
  pyproject = true;

  src = fetchPypi {
    pname = "types_pyyaml";
    inherit version;
    hash = "sha256-D4tUpSjDA/Dm9xZWh90z+vqByAf8rCP2MrY6piTO0dM=";
  };

  build-system = [ setuptools ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "yaml-stubs" ];

  meta = {
    description = "Typing stubs for PyYAML";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dnr ];
  };
}
