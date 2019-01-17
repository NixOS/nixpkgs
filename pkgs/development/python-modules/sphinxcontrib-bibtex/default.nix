{ stdenv, buildPythonPackage, fetchPypi
, oset, pybtex, pybtex-docutils, sphinx
}:

buildPythonPackage rec {
  version = "0.4.2";
  pname = "sphinxcontrib-bibtex";

  src = fetchPypi {
    inherit pname version;
    sha256 = "169afb3a3485775e5473934a0fdff1780e8bdcdd44db7ed286044a074331c729";
  };

  propagatedBuildInputs = [ oset pybtex pybtex-docutils sphinx ];

  meta = {
    description = "A Sphinx extension for BibTeX style citations";
    homepage = "https://github.com/mcmtroffaes/sphinxcontrib-bibtex";
    license = stdenv.lib.licenses.bsd2;
  };

}
