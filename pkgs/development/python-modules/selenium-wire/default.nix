{
  lib,
  blinker,
  brotli,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  h2,
  hyperframe,
  kaitaistruct,
  pyasn1,
  httpbin,
  pyopenssl,
  pyparsing,
  pysocks,
  gunicorn,
  pytestCheckHook,
  pythonOlder,
  selenium,
  setuptools,
  wsproto,
  zstandard,
}:

buildPythonPackage rec {
  pname = "selenium-wire";
  version = "5.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wkeeling";
    repo = "selenium-wire";
    rev = "refs/tags/${version}";
    hash = "sha256-KgaDxHS0dAK6CT53L1qqx1aORMmkeaiXAUtGC82hiIQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    blinker
    brotli
    certifi
    h2
    hyperframe
    kaitaistruct
    pyasn1
    pyopenssl
    pyparsing
    pysocks
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
  ];

  meta = with lib; {
    description = "Extends Selenium's Python bindings to give you the ability to inspect requests made by the browser";
    homepage = "https://github.com/wkeeling/selenium-wire";
    changelog = "https://github.com/wkeeling/selenium-wire/blob/${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    broken = versionAtLeast blinker.version "1.8";
  };
}
