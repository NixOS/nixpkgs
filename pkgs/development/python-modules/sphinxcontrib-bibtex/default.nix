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
  version = "2.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9IevaUM28ov7fWoXBwlTp9JkvsQwAKI3lyQnT1+NcK4=";
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
    description = "A Sphinx extension for BibTeX style citations";
    homepage = "https://github.com/mcmtroffaes/sphinxcontrib-bibtex";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
