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
  version = "2.2.0";
  pname = "sphinxcontrib-bibtex";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-dQCEPhVNdpg8I7ylynOAll4HJcRrj0hMEyLQtYps47I=";
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
