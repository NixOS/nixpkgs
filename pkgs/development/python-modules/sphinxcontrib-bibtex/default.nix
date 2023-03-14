{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, oset
, pybtex
, pybtex-docutils
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-bibtex";
  version = "2.5.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cbQuXbDi4oTyQ4dTJr+ZNqqadjKCJ311BIgm/vWwDqo=";
  };

  propagatedBuildInputs = [
    oset
    pybtex
    pybtex-docutils
    sphinx
  ];

  doCheck = false;

  pythonImportsCheck = [
    "sphinxcontrib.bibtex"
  ];

  meta = with lib; {
    description = "A Sphinx extension for BibTeX style citations";
    homepage = "https://github.com/mcmtroffaes/sphinxcontrib-bibtex";
    license = licenses.bsd2;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
