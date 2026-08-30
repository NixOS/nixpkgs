{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
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

  patches = [
    (fetchpatch2 {
      name = "fix-tests-docutils-0.22.diff";
      url = "https://github.com/mcmtroffaes/sphinxcontrib-bibtex/commit/20781600dad48fdfee91353c821597690bfe5f54.diff?full_index=1";
      hash = "sha256-Ia/ng3yUfhLueEB/n+CW51w/UWfzRhrv/5//Mq2OJ0M=";
    })
  ];

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
