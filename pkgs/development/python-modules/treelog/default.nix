{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  flit-core,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "treelog";
  version = "2.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-zwsTVtrnUyncn8ezHLa/YU2JpmcI3fnC815zmFtPhk4=";
  };

  build-system = [
    setuptools
    flit-core
  ];

  dependencies = [ typing-extensions ];

  pythonImportsCheck = [ "treelog" ];

  meta = {
    description = "Logging framework that organizes messages in a tree structure";
    homepage = "https://github.com/evalf/treelog";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.Scriptkiddi ];
  };
})
