{ lib, fetchPypi, buildPythonPackage, intervaltree, pyflakes, requests, lxml }:

buildPythonPackage rec {
  pname = "xml2rfc";
  version = "2.10.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ace45039e9d71713b4bb09ea199644797a7d884fbdd940e4c02559b4bccb01a1";
  };

  propagatedBuildInputs = [ intervaltree pyflakes requests lxml ];

  meta = with lib; {
    description = "Tool generating IETF RFCs and drafts from XML sources";
    homepage = https://tools.ietf.org/tools/xml2rfc/trac/;
    # Well, parts might be considered unfree, if being strict; see:
    # http://metadata.ftp-master.debian.org/changelogs/non-free/x/xml2rfc/xml2rfc_2.9.6-1_copyright
    license = licenses.bsd3;
    maintainers = [ maintainers.vcunat ];
  };
}
