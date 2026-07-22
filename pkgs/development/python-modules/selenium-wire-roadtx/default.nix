{
  lib,
  blinker,
  brotli,
  buildPythonPackage,
  certifi,
  cryptography,
  fetchFromGitHub,
  gunicorn,
  h2,
  httpbin,
  hyperframe,
  kaitaistruct,
  nix-update-script,
  pyasn1,
  pyopenssl,
  pyparsing,
  pysocks,
  pytestCheckHook,
  ruamel-yaml,
  selenium,
  setuptools,
  wsproto,
  zstandard,
}:

buildPythonPackage (finalAttrs: {
  pname = "selenium-wire-roadtx";
  version = "0-unstable-2026-05-20";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dirkjanm";
    repo = "selenium-wire-roadtx";
    rev = "98e91ea9e2472902d19b4a328a2ea08539b488b9";
    hash = "sha256-WhGsgIuJrbc6Emq9B0uin7FUKc/qPH9E1DUjt/FIVZs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    blinker
    brotli
    certifi
    cryptography
    h2
    hyperframe
    kaitaistruct
    pyasn1
    pyopenssl
    pyparsing
    pysocks
    ruamel-yaml
    selenium
    wsproto
    zstandard
  ];

  nativeCheckInputs = [
    gunicorn
    httpbin
    pytestCheckHook
  ];

  pythonImportsCheck = [ "seleniumwire" ];

  disabledTestPaths = [
    # Don't run End2End tests
    "tests/end2end/test_end2end.py"
    # Don't run MitM tests
    "tests/seleniumwire/test_server.py"
  ];

  disabledTests = [
    # Tests require setup
    "BackendIntegrationTest"
    # AssertionError
    "test_save_response"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Extends Selenium's Python bindings to give you the ability to inspect requests made by the browser";
    homepage = "https://github.com/dirkjanm/selenium-wire-roadtx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
