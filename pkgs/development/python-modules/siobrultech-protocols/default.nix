{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pyyaml
}:

buildPythonPackage rec {
  pname = "siobrultech-protocols";
<<<<<<< HEAD
  version = "0.12.0";
=======
  version = "0.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sdwilsh";
    repo = "siobrultech-protocols";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-71iFZS5CLYXNw57psLXswNJKfvbeKOqSncLoSsNXqjc=";
=======
    hash = "sha256-8qhg7PX4u4vN2+hWXzFjC1ZzgCEhkSr9Fn58Lc4E76c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    pyyaml
  ];

  pythonImportsCheck = [
    "siobrultech_protocols.gem.api"
    "siobrultech_protocols.gem.protocol"
  ];

<<<<<<< HEAD
  meta = with lib; {
    description = "A Sans-I/O Python client library for Brultech Devices";
    homepage = "https://github.com/sdwilsh/siobrultech-protocols";
    changelog = "https://github.com/sdwilsh/siobrultech-protocols/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
=======
  meta = {
    description = "A Sans-I/O Python client library for Brultech Devices";
    homepage = "https://github.com/sdwilsh/siobrultech-protocols";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
