{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, sphinxcontrib-serializinghtml
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-programoutput";
  version = "0.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MA7puMrug1XSXMdLTRx+/RLmCNKtFl4xQdMeb7wVK38=";
  };

  buildInputs = [
    sphinx
  ];

  # fails to import sphinxcontrib.serializinghtml
  doCheck = false;

  pythonImportsCheck = [ "sphinxcontrib.programoutput" ];

  meta = with lib; {
    description = "Sphinx extension to include program output";
    homepage = "https://github.com/NextThought/sphinxcontrib-programoutput";
    license = licenses.bsd2;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
