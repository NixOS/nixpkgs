{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "uritools";
<<<<<<< HEAD
  version = "4.0.2";
=======
  version = "4.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-BN8reH0Ot2IA6DGTgqA1Yvv+R0H9ZsFVBrCNO4IR1XM=";
=======
    hash = "sha256-78XDpt4FQEhQaFqNPzTahHa1aqNRb7+O/1yHBMeigm8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  pythonImportsCheck = [
    "uritools"
  ];

  meta = with lib; {
    description = "RFC 3986 compliant, Unicode-aware, scheme-agnostic replacement for urlparse";
    homepage = "https://github.com/tkem/uritools/";
    changelog = "https://github.com/tkem/uritools/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
