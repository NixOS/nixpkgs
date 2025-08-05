{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-awscrt";
  version = "0.27.5";
  pyproject = true;

  src = fetchPypi {
    pname = "types_awscrt";
    inherit version;
    hash = "sha256-ju/lDRcJUgZjt302Q6dyw1rOPYrPyylvhXYnYiyEy0w=";
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
