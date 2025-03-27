{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-markdown";
  version = "3.7.0.20250322";
  pyproject = true;

  src = fetchPypi {
    pname = "types_markdown";
    inherit version;
    hash = "sha256-pI7YLfy2lUWSoQ8QRonS1E35ElzlGzzuIOAZilIW1Vw=";
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
