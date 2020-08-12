{ lib, fetchPypi, buildPythonPackage, intervaltree, pyflakes, requests, lxml, google-i18n-address
, pycountry, html5lib, six, kitchen, pypdf2, dict2xml, weasyprint
, stdenv
}:

buildPythonPackage rec {
  pname = "xml2rfc";
  version = "2.45.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e083195efc07f84fb22da9e74d5d9f857d3c82a3947995b0d4f3ff9b11a1a7c5";
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
    homepage = "https://tools.ietf.org/tools/xml2rfc/trac/";
    # Well, parts might be considered unfree, if being strict; see:
    # http://metadata.ftp-master.debian.org/changelogs/non-free/x/xml2rfc/xml2rfc_2.9.6-1_copyright
    license = licenses.bsd3;
    maintainers = with maintainers; [ vcunat yrashk ];
  };
}
