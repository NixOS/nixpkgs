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
  version = "2.6.9";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-BdUQB7usj1UwMS4AewUtaWWTl1otamCviX2MF/+x9ic=";
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
