{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-markdown";
  version = "3.11.3.20261108";
  pyproject = true;

  src = fetchPypi {
    pname = "types_markdown";
    inherit (finalAttrs) version;
    hash = "sha256-6sAYj8jay/m7vqaKCu6Yx9OwAI+LHe8aFBzWad18cIo=";
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
