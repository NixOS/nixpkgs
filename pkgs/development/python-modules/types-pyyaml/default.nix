{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-pyyaml";
  version = "6.0.12.20260815";
  pyproject = true;

  src = fetchPypi {
    pname = "types_pyyaml";
    inherit (finalAttrs) version;
    hash = "sha256-KHZBEMnPNYRucz2jLY1zTfdHPF3envZ8O3My7A6BmFg=";
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
})
