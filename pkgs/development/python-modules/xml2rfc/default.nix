{ lib, fetchPypi, buildPythonPackage, intervaltree, pyflakes, requests, lxml, google-i18n-address
, pycountry, html5lib, six
, stdenv
}:

buildPythonPackage rec {
  pname = "xml2rfc";
  version = "2.18.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e192236798615f34479a9bb9f30df72ce0e5f319df75ecc0473d896713a17451";
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

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Tool generating IETF RFCs and drafts from XML sources";
    homepage = https://tools.ietf.org/tools/xml2rfc/trac/;
    # Well, parts might be considered unfree, if being strict; see:
    # http://metadata.ftp-master.debian.org/changelogs/non-free/x/xml2rfc/xml2rfc_2.9.6-1_copyright
    license = licenses.bsd3;
    maintainers = [ maintainers.vcunat ];
  };
}
