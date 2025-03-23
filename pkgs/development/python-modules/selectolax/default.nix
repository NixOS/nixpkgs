{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
}:
buildPythonPackage rec {
  pname = "selectolax";
  version = "0.3.28";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iuPalyYbV77VH6mwPEiJhfbc/y4uREcaqfXiwXzBxFo=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "selectolax" ];

  meta = {
    description = "Python binding to Modest and Lexbor engines (fast HTML5 parser with CSS selectors).";
    homepage = "https://github.com/rushter/selectolax";
    changelog = "https://github.com/rushter/selectolax/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.octvs ];
  };
}
