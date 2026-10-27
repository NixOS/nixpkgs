{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "treelog";
  version = "1.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-AcUGrXagX7i8nuBuOasheRM5csqavS6b8ZNScsnf0UI=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  pythonImportsCheck = [ "treelog" ];

  meta = {
    description = "Logging framework that organizes messages in a tree structure";
    homepage = "https://github.com/evalf/treelog";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.Scriptkiddi ];
  };
})
