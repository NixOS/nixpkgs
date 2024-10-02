{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  oset,
  pybtex,
  pybtex-docutils,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-bibtex";
  version = "2.6.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fHkDR+8csO3zDeVfwyTZeC0IXonFLCuPqvoILgjiOUY=";
  };

  propagatedBuildInputs = [
    oset
    pybtex
    pybtex-docutils
    sphinx
  ];

  doCheck = false;

  pythonImportsCheck = [ "sphinxcontrib.bibtex" ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Sphinx extension for BibTeX style citations";
    homepage = "https://github.com/mcmtroffaes/sphinxcontrib-bibtex";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
