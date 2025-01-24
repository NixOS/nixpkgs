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
  pythonOlder,
  pyyaml,
  requests,
  setuptools,
  wcwidth,
}:

buildPythonPackage rec {
  pname = "xml2rfc";
  version = "3.24.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ietf-tools";
    repo = "xml2rfc";
    rev = "refs/tags/v${version}";
    hash = "sha256-cymClLsXPeuWsRMbFJHO55ASzEbau++XvYoBsquDv+Y=";
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

  meta = with lib; {
    description = "Tool generating IETF RFCs and drafts from XML sources";
    mainProgram = "xml2rfc";
    homepage = "https://github.com/ietf-tools/xml2rfc";
    changelog = "https://github.com/ietf-tools/xml2rfc/blob/v${version}/CHANGELOG.md";
    # Well, parts might be considered unfree, if being strict; see:
    # http://metadata.ftp-master.debian.org/changelogs/non-free/x/xml2rfc/xml2rfc_2.9.6-1_copyright
    license = licenses.bsd3;
    maintainers = with maintainers; [
      vcunat
      yrashk
    ];
  };
}
