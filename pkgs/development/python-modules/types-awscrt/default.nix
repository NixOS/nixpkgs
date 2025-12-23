{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-awscrt";
  version = "0.30.0";
  pyproject = true;

  src = fetchPypi {
    pname = "types_awscrt";
    inherit version;
    hash = "sha256-Ni/Y9errz82SLLn9gnT7N131UDGfeAMe43eerAuezHk=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "awscrt-stubs" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Type annotations and code completion for awscrt";
    homepage = "https://github.com/youtype/types-awscrt";
    changelog = "https://github.com/youtype/types-awscrt/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
