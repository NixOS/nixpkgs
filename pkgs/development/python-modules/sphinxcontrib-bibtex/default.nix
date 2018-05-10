{ stdenv, buildPythonPackage, fetchPypi
, oset, pybtex, pybtex-docutils, sphinx
}:

buildPythonPackage rec {
  version = "0.3.6";
  pname = "sphinxcontrib-bibtex";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mfl3k6axq6rzqwq62fj8y9gabim2zcvydjpqmjj27f8v1qw0kpc";
  };

  propagatedBuildInputs = [ oset pybtex pybtex-docutils sphinx ];

  meta = {
    description = "A Sphinx extension for BibTeX style citations";
    homepage = "https://github.com/mcmtroffaes/sphinxcontrib-bibtex";
    license = stdenv.lib.licenses.bsd2;
  };

}
