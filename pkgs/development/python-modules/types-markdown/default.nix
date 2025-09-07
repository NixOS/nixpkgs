{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-markdown";
  version = "3.8.0.20250809";
  pyproject = true;

  src = fetchPypi {
    pname = "types_markdown";
    inherit version;
    hash = "sha256-+mGec1h4okQzKku+Frz8ROSf9iZMJpYFYnjwZCzfoiM=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "markdown-stubs" ];

  meta = with lib; {
    description = "Typing stubs for Markdown";
    homepage = "https://pypi.org/project/types-Markdown/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
