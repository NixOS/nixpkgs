{ lib, fetchPypi, buildPythonPackage, intervaltree, pyflakes, requests, lxml, google-i18n-address
, pycountry, html5lib, six
}:

buildPythonPackage rec {
  pname = "xml2rfc";
  version = "2.12.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "64609a2194d18c03e2348f1ea2fb97208b3455dfb76a16900143813aa61b6d3c";
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
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Tool generating IETF RFCs and drafts from XML sources";
    homepage = https://tools.ietf.org/tools/xml2rfc/trac/;
    # Well, parts might be considered unfree, if being strict; see:
    # http://metadata.ftp-master.debian.org/changelogs/non-free/x/xml2rfc/xml2rfc_2.9.6-1_copyright
    license = licenses.bsd3;
    maintainers = [ maintainers.vcunat ];
  };
}
