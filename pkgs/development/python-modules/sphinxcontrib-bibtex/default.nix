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

buildPythonPackage (finalAttrs: {
  pname = "sphinxcontrib-bibtex";
  version = "2.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mcmtroffaes";
    repo = "sphinxcontrib-bibtex";
    tag = finalAttrs.version;
    hash = "sha256-8VmLTr9l+JTUb9oVXGI/j5Yz7Fe+ybEA8t2VUeRGBqI=";
  };

  build-system = [ setuptools ];

  buildInputs = [ sphinx ];

  dependencies = [
    docutils
    oset
    pybtex
    pybtex-docutils
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
    changelog = "https://github.com/mcmtroffaes/sphinxcontrib-bibtex/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
