{ lib, fetchPypi, buildPythonPackage, pythonAtLeast, intervaltree, pyflakes, requests, lxml, google-i18n-address
, pycountry, html5lib, six, kitchen, pypdf2, dict2xml, weasyprint, pyyaml, jinja2, ConfigArgParse, appdirs
}:

buildPythonPackage rec {
  pname = "xml2rfc";
  version = "3.5.0";
  disabled = pythonAtLeast "3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3ec836a9545f549707a8c8176038160185b9d08c1dd80304a906527da21bff68";
  };

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
    ConfigArgParse
    appdirs
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # lxml tries to fetch from the internet
  doCheck = false;
  pythonImportsCheck = [ "xml2rfc" ];

  meta = with lib; {
    description = "Tool generating IETF RFCs and drafts from XML sources";
    homepage = "https://tools.ietf.org/tools/xml2rfc/trac/";
    # Well, parts might be considered unfree, if being strict; see:
    # http://metadata.ftp-master.debian.org/changelogs/non-free/x/xml2rfc/xml2rfc_2.9.6-1_copyright
    license = licenses.bsd3;
    maintainers = with maintainers; [ vcunat yrashk ];
  };
}
