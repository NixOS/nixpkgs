{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

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
  version = "1.3.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xmlsec";
    repo = "python-xmlsec";
    tag = finalAttrs.version;
    hash = "sha256-p3V75DLUI2PKdharP3/0HrKOgma9Kh3lAOZLRAQjo80=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==" "setuptools>="
  '';

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
    hypothesis
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Full git clone required for test_doc_examples
    "tests/test_doc_examples.py"
  ];

  disabledTests = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    # AssertionError: memory leak detected
    "test_reinitialize_module"
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
