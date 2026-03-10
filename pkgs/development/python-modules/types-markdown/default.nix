{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-markdown";
  version = "3.10.2.20260211";
  pyproject = true;

  src = fetchPypi {
    pname = "types_markdown";
    inherit (finalAttrs) version;
    hash = "sha256-ZhZDEPiMEaWMbHBglMb4xTfEGONSXTO3Ynal+9ZrAc4=";
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
