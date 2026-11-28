{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-markdown";
  version = "3.11.3.20261122";
  pyproject = true;

  src = fetchPypi {
    pname = "types_markdown";
    inherit (finalAttrs) version;
    hash = "sha256-kZ+7hDvN0OH0jPh4xecSqvx0eSX0aS44RbW9FG2XW1k=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "markdown-stubs" ];

  meta = {
    description = "Typing stubs for Markdown";
    homepage = "https://pypi.org/project/types-Markdown/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
