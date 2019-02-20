{ stdenv, buildPythonPackage, fetchPypi
, oset, pybtex, pybtex-docutils, sphinx
}:

buildPythonPackage rec {
  version = "0.4.2";
  pname = "sphinxcontrib-bibtex";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0af7651hfjh4hv97xns4vpf8n3kqy7ghyjlkfda5wxw56hxgp6hn";
  };

  propagatedBuildInputs = [ oset pybtex pybtex-docutils sphinx ];

  meta = {
    description = "A Sphinx extension for BibTeX style citations";
    homepage = "https://github.com/mcmtroffaes/sphinxcontrib-bibtex";
    license = stdenv.lib.licenses.bsd2;
  };

}
