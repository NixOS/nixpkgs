{ lib
, appdirs
, buildPythonPackage
, configargparse
, decorator
, dict2xml
, fetchFromGitHub
, google-i18n-address
, html5lib
, intervaltree
, jinja2
, lxml
, markupsafe
, pycairo
, pycountry
, pyflakes
, pypdf2
, pytestCheckHook
, python-fontconfig
, pythonOlder
, pyyaml
, requests
, six
, wcwidth
}:

buildPythonPackage rec {
  pname = "xml2rfc";
  version = "3.17.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ietf-tools";
    repo = "xml2rfc";
    rev = "refs/tags/v${version}";
    hash = "sha256-C5bc32XbAqJtzUbITj1U1ItaY2ZMEXM9z+B7dQadoIs=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "SHELL := /bin/bash" "SHELL := bash" \
      --replace "test flaketest" "test"
    substituteInPlace setup.py \
      --replace "'tox'," ""
  '';

  propagatedBuildInputs = [
    appdirs
    configargparse
    dict2xml
    google-i18n-address
    html5lib
    intervaltree
    jinja2
    lxml
    markupsafe
    pycountry
    pyflakes
    pypdf2
    pyyaml
    requests
    six
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

  pythonImportsCheck = [
    "xml2rfc"
  ];

  meta = with lib; {
    description = "Tool generating IETF RFCs and drafts from XML sources";
    homepage = "https://github.com/ietf-tools/xml2rfc";
    changelog = "https://github.com/ietf-tools/xml2rfc/blob/v${version}/CHANGELOG.md";
    # Well, parts might be considered unfree, if being strict; see:
    # http://metadata.ftp-master.debian.org/changelogs/non-free/x/xml2rfc/xml2rfc_2.9.6-1_copyright
    license = licenses.bsd3;
    maintainers = with maintainers; [ vcunat yrashk ];
  };
}
