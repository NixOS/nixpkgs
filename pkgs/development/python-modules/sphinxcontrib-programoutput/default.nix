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
    hash = "sha256-MA7puMrug1XSXMdLTRx+/RLmCNKtFl4xQdMeb7wVK38=";
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
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
