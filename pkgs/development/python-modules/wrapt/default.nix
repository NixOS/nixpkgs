{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
<<<<<<< HEAD
, sphinxHook
, sphinx-rtd-theme
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "wrapt";
  version = "1.14.1";
<<<<<<< HEAD
  outputs = [ "out" "doc" ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "GrahamDumpleton";
    repo = pname;
    rev = version;
    hash = "sha256-nXwDuNo4yZxgjnkus9bVwIZltPaSH93D+PcZMGT2nGM=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

<<<<<<< HEAD
  nativeBuildInputs = [
    sphinxHook
    sphinx-rtd-theme
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "wrapt"
  ];

  meta = with lib; {
    description = "Module for decorators, wrappers and monkey patching";
    homepage = "https://github.com/GrahamDumpleton/wrapt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
