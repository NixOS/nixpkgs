{ lib, fetchPypi, buildPythonPackage, pythonAtLeast, intervaltree, pyflakes, requests, lxml, google-i18n-address
, pycountry, html5lib, six, kitchen, pypdf2, dict2xml, weasyprint, pyyaml, jinja2, configargparse, appdirs
}:

buildPythonPackage rec {
  pname = "xml2rfc";
  version = "3.9.1";
  disabled = pythonAtLeast "3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "76cee167e81fc3cc0e0cc696fe58cadd039e19a774c8f4d2e5c0fea724c7aaca";
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
    configargparse
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
