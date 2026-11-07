{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-markdown";
  version = "3.11.2.20261029";
  pyproject = true;

  src = fetchPypi {
    pname = "types_markdown";
    inherit (finalAttrs) version;
    hash = "sha256-DlygU9ACqNkLGaHUgVpFANtoXMzmoQcgRv8PS/6ccnw=";
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
