{ lib, fetchPypi, buildPythonPackage, intervaltree, pyflakes, requests, lxml }:

buildPythonPackage rec {
  pname = "xml2rfc";
  version = "2.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dc62e1d2fea896855ee0681f02bcb7596e3b6b5aa559348b8520a4eb0c793282";
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
