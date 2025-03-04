{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-awscrt";
  version = "0.23.10";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "types_awscrt";
    inherit version;
    hash = "sha256-llZZJgWZtCFWQgS4lUZ2hBBKLAMRu6z9PCQjuLDT8+k=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "awscrt-stubs" ];

  meta = with lib; {
    description = "Type annotations and code completion for awscrt";
    homepage = "https://github.com/youtype/types-awscrt";
    changelog = "https://github.com/youtype/types-awscrt/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
