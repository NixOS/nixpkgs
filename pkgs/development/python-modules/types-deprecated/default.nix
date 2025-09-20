{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-deprecated";
  version = "1.2.15.20250304";
  pyproject = true;

  src = fetchPypi {
    pname = "types_deprecated";
    inherit version;
    hash = "sha256-wykDBVMCneXMbLMPJpwR9OAOWYxCQSkBefY82n0z9xk=";
  };

  build-system = [ setuptools ];

  # Modules has no tests
  doCheck = false;

  pythonImportsCheck = [ "deprecated-stubs" ];

  meta = {
    description = "Typing stubs for Deprecated";
    homepage = "https://pypi.org/project/types-Deprecated/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
