{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, python
=======
, pythonOlder
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, poetry-core
, pytest
, colored
, invoke
}:

buildPythonPackage rec {
  pname = "syrupy";
<<<<<<< HEAD
  version = "4.2.1";
  format = "pyproject";

  disabled = lib.versionOlder python.version "3.8.1";
=======
  version = "4.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.8.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tophat";
    repo = "syrupy";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-MXUuLw4+J/9JtXY1DYwBjj2sgAbO2cXQi1HnVRx3BhM=";
=======
    hash = "sha256-luYYh6L7UxW8wkp1zxR0EOmyTj0mIZ6Miy6HcVHebo4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    colored
  ];

  nativeCheckInputs = [
    invoke
    pytest
  ];

  checkPhase = ''
    runHook preCheck
    # https://github.com/tophat/syrupy/blob/main/CONTRIBUTING.md#local-development
    invoke test
    runHook postCheck
  '';

<<<<<<< HEAD
  pythonImportsCheck = [ "syrupy" ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    changelog = "https://github.com/tophat/syrupy/releases/tag/v${version}";
    description = "Pytest Snapshot Test Utility";
    homepage = "https://github.com/tophat/syrupy";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
