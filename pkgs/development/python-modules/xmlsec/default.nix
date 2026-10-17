{
  lib,
  stdenv,
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
  version = "1.3.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xmlsec";
    repo = "python-xmlsec";
    tag = finalAttrs.version;
    hash = "sha256-p3V75DLUI2PKdharP3/0HrKOgma9Kh3lAOZLRAQjo80=";
  };

  patches = [
    # https://github.com/lsh123/xmlsec/issues/1148
    # https://github.com/xmlsec/python-xmlsec/pull/422
    (fetchpatch {
      name = "xmlsec-1.3.11-test-compatibility.patch";
      url = "https://github.com/xmlsec/python-xmlsec/commit/5e8b4e6aa133c358b8aaf8e17ceb5b3b7fea78e8.patch";
      includes = [
        "src/*"
        "tests/*"
      ];
      hash = "sha256-+J2L6oq802/534qIDvFqsWYfn9LExRlXXIeDvVqZEYk=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "lxml==" "lxml>=" \
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
