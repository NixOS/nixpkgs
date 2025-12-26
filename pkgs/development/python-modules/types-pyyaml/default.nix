{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-pyyaml";
  version = "6.0.12.20250516";
  pyproject = true;

  src = fetchPypi {
    pname = "types_pyyaml";
    inherit version;
    hash = "sha256-nyGnAhb8D6GyFqgXbbX54K9us10vKTKsuHaJ0Dpb9ro=";
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
