{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-pyyaml";
  version = "6.0.12.20250326";
  pyproject = true;

  src = fetchPypi {
    pname = "types_pyyaml";
    inherit version;
    hash = "sha256-Xi2G2HBml4A/NhuguBiO7ymZ4cNyzU+u5OuwhEuKQZA=";
  };

  build-system = [ setuptools ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "yaml-stubs" ];

  meta = with lib; {
    description = "Typing stubs for PyYAML";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ dnr ];
  };
}
