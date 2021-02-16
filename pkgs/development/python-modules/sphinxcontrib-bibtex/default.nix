{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, oset
, pybtex
, pybtex-docutils
, sphinx
}:

buildPythonPackage rec {
  version = "2.1.4";
  pname = "sphinxcontrib-bibtex";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f53ec0cd534d2c8f0a51b4b3473ced46e9cb0dd99a7c5019249fe0ef9cbef18e";
  };

  propagatedBuildInputs = [ oset pybtex pybtex-docutils sphinx ];

  doCheck = false;
  pythonImportsCheck = [ "sphinxcontrib.bibtex" ];

  meta = with lib; {
    description = "A Sphinx extension for BibTeX style citations";
    homepage = "https://github.com/mcmtroffaes/sphinxcontrib-bibtex";
    license = licenses.bsd2;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
