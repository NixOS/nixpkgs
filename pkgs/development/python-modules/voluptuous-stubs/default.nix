{
  lib,
  buildPythonPackage,
  fetchPypi,
  mypy,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "voluptuous-stubs";
  version = "0.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-cPscCIJC8g4RAjJStWSM13+DH2ks2RDI+XE8wTXPjMg=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ mypy ];

  pythonImportsCheck = [ "voluptuous-stubs" ];

  doCheck = false;

  meta = {
    description = "Typing stubs for voluptuous";
    homepage = "https://github.com/ryanwang520/voluptuous-stubs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
