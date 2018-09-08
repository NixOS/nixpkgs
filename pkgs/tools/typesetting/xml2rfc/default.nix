{ python, stdenv }:

with python.pkgs;

buildPythonPackage rec {
  pname = "xml2rfc";
  version = "2.9.8";

  buildInputs = [ intervaltree lxml requests pyflakes ];
  propagatedBuildInputs = [ intervaltree lxml requests six ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "b50ce2f98bc431cadbcef0523213497049b78c2829ee81c399976f1e4832afc6";
  };

  meta = with stdenv.lib; {
    homepage = https://xml2rfc.tools.ietf.org/;
    license = licenses.bsdOriginal;
    description = "Xml2rfc generates RFCs and IETF drafts from document source in XML according to the dtd in RFC2629.";
    maintainers = [ maintainers.yrashk ];
  };

}
