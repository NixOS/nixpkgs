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
    sha256 = "0hnivz4p4llky6djxgcsr9r3j4vr46mkjvp0ksybhpx0fsnhdi81";
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
