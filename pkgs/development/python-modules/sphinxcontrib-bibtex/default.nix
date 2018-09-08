{ stdenv, buildPythonPackage, fetchPypi
, oset, pybtex, pybtex-docutils, sphinx
}:

buildPythonPackage rec {
  version = "0.4.0";
  pname = "sphinxcontrib-bibtex";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cb9fb4526642fc080204fccd5cd8f41e9e95387278e17b1d6969b1e27c2d3e0c";
  };

  propagatedBuildInputs = [ oset pybtex pybtex-docutils sphinx ];

  meta = {
    description = "A Sphinx extension for BibTeX style citations";
    homepage = https://github.com/mcmtroffaes/sphinxcontrib-bibtex;
    license = stdenv.lib.licenses.bsd2;
  };

}
