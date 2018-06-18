{ lib, fetchurl, buildPythonPackage, intervaltree, pyflakes, requests, lxml }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "xml2rfc";
  version = "2.9.8";

  src = fetchurl {
    url = "mirror://pypi/x/${pname}/${name}.tar.gz";
    sha256 = "1img6941wvwpk71q3vi9526bfjbh949k4lphrvdwlcf4igwy435m";
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
