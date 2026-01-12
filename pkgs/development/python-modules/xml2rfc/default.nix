{
  lib,
  buildPythonPackage,
  configargparse,
  decorator,
  dict2xml,
  fetchFromGitHub,
  google-i18n-address,
  intervaltree,
  jinja2,
  lxml,
  platformdirs,
  pycairo,
  pycountry,
  pypdf,
  pytestCheckHook,
  python-fontconfig,
  pyyaml,
  requests,
  setuptools,
  wcwidth,
}:

buildPythonPackage rec {
  pname = "xml2rfc";
  version = "3.31.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ietf-tools";
    repo = "xml2rfc";
    tag = "v${version}";
    hash = "sha256-thgLt1PHXbKxDDhqQcHUP/AZsGq/OfAOSRV9KrFmPWw=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "SHELL := /bin/bash" "SHELL := bash" \
      --replace-fail "test flaketest" "test"
  '';

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "lxml" ];

  dependencies = [
    configargparse
    dict2xml
    google-i18n-address
    intervaltree
    jinja2
    lxml
    platformdirs
    pycountry
    pypdf
    pyyaml
    requests
    wcwidth
  ];

  nativeCheckInputs = [
    decorator
    pycairo
    pytestCheckHook
    python-fontconfig
  ];

  # Requires Noto Serif and Roboto Mono font
  doCheck = false;

  checkPhase = ''
    make tests-no-network
  '';

  pythonImportsCheck = [ "xml2rfc" ];

  meta = {
    description = "Tool generating IETF RFCs and drafts from XML sources";
    mainProgram = "xml2rfc";
    homepage = "https://github.com/ietf-tools/xml2rfc";
    changelog = "https://github.com/ietf-tools/xml2rfc/blob/${src.tag}/CHANGELOG.md";
    # Well, parts might be considered unfree, if being strict; see:
    # http://metadata.ftp-master.debian.org/changelogs/non-free/x/xml2rfc/xml2rfc_2.9.6-1_copyright
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      vcunat
      yrashk
    ];
  };
}
