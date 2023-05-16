{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, pytestCheckHook
, bracex
}:

buildPythonPackage rec {
  pname = "wcmatch";
<<<<<<< HEAD
  version = "8.5";
=======
  version = "8.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-hsF1ctD3XL87yxoY878vnnKzmpwIybSnTpkeGIKo77M=";
=======
    hash = "sha256-sfBCqJnqTEWLcyHaG14zMePg7HgVg0NN4TAZRs6tuUM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [ bracex ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    "TestTilde"
  ];

  pythonImportsCheck = [ "wcmatch" ];

  meta = with lib; {
    description = "Wilcard File Name matching library";
    homepage = "https://github.com/facelessuser/wcmatch";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
