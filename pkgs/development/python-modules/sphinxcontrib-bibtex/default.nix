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
  version = "2.4.2";
  pname = "sphinxcontrib-bibtex";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ZbAj7kfzXx8DrE1xyCTmfGJMfsrBuyboNiMnGgH52oY=";
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
