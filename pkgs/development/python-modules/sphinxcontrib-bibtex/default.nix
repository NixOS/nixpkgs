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
  version = "2.4.0";
  pname = "sphinxcontrib-bibtex";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "be503e2437651531e0512dbe732def518ad2b8d0d785c3b4f36508d814d22e46";
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
