{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  docutils,
  oset,
  pybtex,
  pybtex-docutils,
  sphinx,
  sphinx-autoapi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-bibtex";
  version = "2.6.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mcmtroffaes";
    repo = "sphinxcontrib-bibtex";
    tag = version;
    hash = "sha256-sT23DkIfJcb3cFBFdL31RRzlDoJRcCUYIdpUVuYjGuo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    docutils
    oset
    pybtex
    pybtex-docutils
    sphinx
  ];

  nativeCheckInputs = [
    pytestCheckHook
    sphinx-autoapi
  ];

  pythonImportsCheck = [ "sphinxcontrib.bibtex" ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = {
    description = "Sphinx extension for BibTeX style citations";
    homepage = "https://github.com/mcmtroffaes/sphinxcontrib-bibtex";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
