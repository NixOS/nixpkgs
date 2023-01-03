{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, intervaltree
, pyflakes
, requests
, lxml
, google-i18n-address
, pycountry
, html5lib
, six
, kitchen
, pypdf2
, dict2xml
, weasyprint
, pyyaml
, jinja2
, configargparse
, appdirs
, decorator
, pycairo
, pytestCheckHook
, python-fontconfig
}:

buildPythonPackage rec {
  pname = "xml2rfc";
  version = "3.15.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ietf-tools";
    repo = "xml2rfc";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-/0Y49ZSaPM3IAFJGmWKiKD+mziA0LYQ3fvGFrkPkl9Y=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "SHELL := /bin/bash" "SHELL := bash" \
      --replace "test flaketest" "test"
    substituteInPlace setup.py \
      --replace "'tox'," ""
  '';

  propagatedBuildInputs = [
    intervaltree
    jinja2
    pyflakes
    pyyaml
    requests
    lxml
    google-i18n-address
    pycountry
    html5lib
    six
    kitchen
    pypdf2
    dict2xml
    weasyprint
    configargparse
    appdirs
  ];

  checkInputs = [
    decorator
    pycairo
    pytestCheckHook
    python-fontconfig
  ];

   # requires Noto Serif and Roboto Mono font
  doCheck = false;

  checkPhase = ''
    make tests-no-network
  '';

  pythonImportsCheck = [ "xml2rfc" ];

  meta = with lib; {
    description = "Tool generating IETF RFCs and drafts from XML sources";
    homepage = "https://github.com/ietf-tools/xml2rfc";
    # Well, parts might be considered unfree, if being strict; see:
    # http://metadata.ftp-master.debian.org/changelogs/non-free/x/xml2rfc/xml2rfc_2.9.6-1_copyright
    license = licenses.bsd3;
    maintainers = with maintainers; [ vcunat yrashk ];
  };
}
