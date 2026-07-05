{
  lib,
  buildPythonPackage,
  fetchPypi,
  click,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "vsure";
  version = "2.8.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-FC2aRsfxBGO8HaEHGJWweKgZzz8UG/03oB/E+hOAe/w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "verisure" ];

  meta = {
    description = "Python library for working with verisure devices";
    homepage = "https://github.com/persandstrom/python-verisure";
    changelog = "https://github.com/persandstrom/python-verisure#version-history";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "vsure";
  };
})
