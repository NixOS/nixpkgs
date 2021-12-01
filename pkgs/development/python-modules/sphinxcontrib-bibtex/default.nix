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
  version = "2.4.1";
  pname = "sphinxcontrib-bibtex";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "282223309bbaf34cd20a8fe1ba346fe8642f403a8930607e77a8cb08ae81fc5f";
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
