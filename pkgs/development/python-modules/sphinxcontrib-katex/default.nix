{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  sphinx,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-katex";
  version = "0.9.10";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "sphinxcontrib_katex";
    inherit version;
    hash = "sha256-MJqS2uJF28WE/36l+2VJcnuuleTlIAi3TSWdL9GtDew=";
  };

  build-system = [ setuptools ];

  dependencies = [ sphinx ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sphinxcontrib.katex" ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Sphinx extension using KaTeX to render math in HTML";
    homepage = "https://github.com/hagenw/sphinxcontrib-katex";
    changelog = "https://github.com/hagenw/sphinxcontrib-katex/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
