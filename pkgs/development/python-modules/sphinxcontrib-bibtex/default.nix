{ stdenv, buildPythonPackage, fetchPypi
, oset, pybtex, pybtex-docutils, sphinx
}:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "sphinxcontrib-bibtex";

  src = fetchPypi {
    inherit pname version;
    sha256 = "629612b001f86784669d65e662377a482052decfd9a0a17c46860878eef7b9e0";
  };

  propagatedBuildInputs = [ oset pybtex pybtex-docutils sphinx ];

  meta = {
    description = "A Sphinx extension for BibTeX style citations";
    homepage = "https://github.com/mcmtroffaes/sphinxcontrib-bibtex";
    license = stdenv.lib.licenses.bsd2;
  };

}
