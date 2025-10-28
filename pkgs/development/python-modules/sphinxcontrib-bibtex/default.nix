{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  docutils,
  importlib-metadata,
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

  disabled = pythonOlder "3.7";

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
  ]
  ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytestCheckHook
    sphinx-autoapi
  ];

  pythonImportsCheck = [ "sphinxcontrib.bibtex" ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Sphinx extension for BibTeX style citations";
    homepage = "https://github.com/mcmtroffaes/sphinxcontrib-bibtex";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
