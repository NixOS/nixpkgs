{ lib, fetchPypi, buildPythonPackage, intervaltree, pyflakes, requests, lxml, google-i18n-address
, pycountry, html5lib, six, kitchen, pypdf2, dict2xml, weasyprint, pyyaml, jinja2
, stdenv
}:

buildPythonPackage rec {
  pname = "xml2rfc";
  version = "2.47.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7f621ed0e5a30c2b67c0e50778627b7a35e1ccfea9db19ea89b4c72a8faf42c0";
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
