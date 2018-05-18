{ python, stdenv }:

with python.pkgs;

buildPythonPackage rec {
  pname = "xml2rfc";
  version = "2.9.6";

  buildInputs = [ intervaltree lxml requests pyflakes ];
  propagatedBuildInputs = [ intervaltree lxml requests six ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wr161lx6f1b3fq14ddr3y4jl0myrcmqs1s3fzsighvlmqfdihj7";
  };

  meta = with stdenv.lib; {
    homepage = "https://xml2rfc.tools.ietf.org/";
    license = licenses.bsdOriginal;
    description = "Xml2rfc generates RFCs and IETF drafts from document source in XML according to the dtd in RFC2629.";
    maintainers = [ maintainers.yrashk ];
  };

}
