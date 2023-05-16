{ lib
, buildPythonPackage
, pythonOlder
<<<<<<< HEAD
, fetchFromGitHub
=======
, fetchFromBitbucket
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, nbval
}:

buildPythonPackage rec {
  pname = "ziafont";
<<<<<<< HEAD
  version = "0.6";

  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "cdelker";
    repo = pname;
    rev = version;
    hash = "sha256-3ZVj1ZxbFkFDDYbsIPzo7GMWGx7f5qWZQlcGCVXv73M=";
=======
  version = "0.5";

  disabled = pythonOlder "3.8";

  src = fetchFromBitbucket {
    owner = "cdelker";
    repo = pname;
    rev = version;
    hash = "sha256-mTQ2yRG+E2nZ2g9eSg+XTzK8A1EgKsRfbvNO3CdYeLg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [
    pytestCheckHook
    nbval
  ];

  preCheck = "rm test/manyfonts.ipynb";  # Tries to download fonts

  pytestFlagsArray = [ "--nbval-lax" ];

  pythonImportsCheck = [ "ziafont" ];

  meta = with lib; {
    description = "Convert TTF/OTF font glyphs to SVG paths";
    homepage = "https://ziafont.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
