{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  diff-match-patch,
}:

buildPythonPackage (finalAttrs: {
  pname = "three-merge";
  version = "0.1.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "three-merge";
    inherit (finalAttrs) version;
    hash = "sha256-YPav4URZVWDWOuMmJTUbzvO5RzO1Trl4AKn+sPPZ2XA=";
  };

  build-system = [ setuptools ];

  dependencies = [ diff-match-patch ];

  pythonImportsCheck = [ "three_merge" ];

  meta = {
    description = "Simple library for merging two strings with respect to a base one";
    homepage = "https://github.com/spyder-ide/three-merge";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
