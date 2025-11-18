{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-awscrt";
  version = "0.28.4";
  pyproject = true;

  src = fetchPypi {
    pname = "types_awscrt";
    inherit version;
    hash = "sha256-FZKdqEgC8nAZ7o5EhPscEC4fbUzyLrSGiMNKWobQLrY=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "awscrt-stubs" ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Type annotations and code completion for awscrt";
    homepage = "https://github.com/youtype/types-awscrt";
    changelog = "https://github.com/youtype/types-awscrt/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
