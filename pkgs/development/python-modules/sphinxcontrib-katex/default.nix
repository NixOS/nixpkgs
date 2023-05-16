{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-katex";
<<<<<<< HEAD
  version = "0.9.7";
=======
  version = "0.9.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-OmdUsc/JDhQeP3Pgg16vyCYtpfr+ekxnT6cI+rec69c=";
=======
    hash = "sha256-Mcn+gcP6ywhVlguCggJkH4SA6n1ikmviRbah7LejDZE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    sphinx
  ];

  # There are no unit tests
  doCheck = false;

  pythonImportsCheck = [
    "sphinxcontrib.katex"
  ];

  meta = with lib; {
    description = "Sphinx extension using KaTeX to render math in HTML";
    homepage = "https://github.com/hagenw/sphinxcontrib-katex";
    changelog = "https://github.com/hagenw/sphinxcontrib-katex/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
