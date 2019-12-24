{ lib, fetchPypi, buildPythonPackage, intervaltree, pyflakes, requests, lxml, google-i18n-address
, pycountry, html5lib, six, kitchen, pypdf2, dict2xml, weasyprint
, stdenv
}:

buildPythonPackage rec {
  pname = "xml2rfc";
  version = "2.27.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00v5gsshy1rmjd334d2awh0mvri949lmyk8f02wfr20rq6fc3xqd";
  };

  propagatedBuildInputs = [
    intervaltree
    pyflakes
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
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # lxml tries to fetch from the internet
  doCheck = false;

  meta = with lib; {
    description = "Tool generating IETF RFCs and drafts from XML sources";
    homepage = https://tools.ietf.org/tools/xml2rfc/trac/;
    # Well, parts might be considered unfree, if being strict; see:
    # http://metadata.ftp-master.debian.org/changelogs/non-free/x/xml2rfc/xml2rfc_2.9.6-1_copyright
    license = licenses.bsd3;
    maintainers = with maintainers; [ vcunat yrashk ];
  };
}
