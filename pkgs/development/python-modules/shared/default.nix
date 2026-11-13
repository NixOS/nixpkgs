{
  lib,
  buildPythonPackage,
  fetchPypi,
  kvf,
  paradict,
  probed,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "shared";
  version = "0.0.32";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-cwityVwNqxTQyZY1zYBJ0fAEzH/vc5bT/kcyPDTsWMY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    kvf
    paradict
    probed
  ];

  pythonImportsCheck = [ "shared" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Data exchange and persistence based on human-readable files";
    homepage = "https://github.com/pyrustic/shared";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
