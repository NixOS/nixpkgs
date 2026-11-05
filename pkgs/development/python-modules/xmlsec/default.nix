{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  pkgconfig,
  setuptools-scm,

  # nativeBuildInputs
  pkg-config,
  # pkgconfig,

  # buildInputs
  libtool,
  libxml2,
  libxslt,
  xmlsec,

  # dependencies
  lxml,

  # tests
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "xmlsec";
  version = "1.3.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xmlsec";
    repo = "python-xmlsec";
    tag = finalAttrs.version;
    hash = "sha256-dRenBPdX8b4RDy2V6tr1uoMWNl30ZKuSjepzHKeO35Q=";
  };

  build-system = [
    pkgconfig
    setuptools-scm
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libtool
    libxml2
    libxslt
    xmlsec
  ];

  dependencies = [ lxml ];

  nativeCheckInputs = [
    # hypothesis
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Full git clone required for test_doc_examples
    "tests/test_doc_examples.py"
  ];

  pythonImportsCheck = [ "xmlsec" ];

  meta = {
    description = "Python bindings for the XML Security Library";
    homepage = "https://github.com/xmlsec/python-xmlsec";
    changelog = "https://github.com/xmlsec/python-xmlsec/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zhaofengli ];
  };
})
