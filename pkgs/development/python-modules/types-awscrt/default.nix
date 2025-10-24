{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-awscrt";
  version = "0.28.2";
  pyproject = true;

  src = fetchPypi {
    pname = "types_awscrt";
    inherit version;
    hash = "sha256-Q0m2/Hsc2cnreCcB+yE4dduJqxeBIZwOlH3XxNnc1l4=";
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
