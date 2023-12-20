{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, sphinxcontrib-serializinghtml
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-programoutput";
  version = "0.17";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MA7puMrug1XSXMdLTRx+/RLmCNKtFl4xQdMeb7wVK38=";
  };

  buildInputs = [
    sphinx
  ];

  # fails to import sphinxcontrib.serializinghtml
  doCheck = false;

  pythonImportsCheck = [ "sphinxcontrib.programoutput" ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Sphinx extension to include program output";
    homepage = "https://github.com/NextThought/sphinxcontrib-programoutput";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
