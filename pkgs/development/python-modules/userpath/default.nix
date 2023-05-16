{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, click
, pythonOlder
}:

buildPythonPackage rec {
  pname = "userpath";
<<<<<<< HEAD
  version = "1.9.0";
=======
  version = "1.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-heMnRUMXRHfGLVcB7UOj7xBRgkqd13aWitxBHlhkDdE=";
=======
    hash = "sha256-BCM9L8/lz/kRweT7cYl1VkDhUk/4ekuCq51rh1/uV4c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    click
  ];

  # Test suite is difficult to emulate in sandbox due to shell manipulation
  doCheck = false;

  pythonImportsCheck = [
    "userpath"
  ];

  meta = with lib; {
    description = "Cross-platform tool for adding locations to the user PATH";
    homepage = "https://github.com/ofek/userpath";
    changelog = "https://github.com/ofek/userpath/releases/tag/v${version}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ yshym ];
  };
}
