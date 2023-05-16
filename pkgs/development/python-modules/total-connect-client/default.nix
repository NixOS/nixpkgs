{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
, zeep
}:

buildPythonPackage rec {
  pname = "total-connect-client";
<<<<<<< HEAD
  version = "2023.7";
=======
  version = "2023.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "craigjmidwinter";
    repo = "total-connect-client";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-sx4KfWQCvGS+w83tECJSyLLWU9GkwYpo39gt4EKndPk=";
=======
    hash = "sha256-sZA+3UjYSHZnN87KUNukRCQ/kG7aobcPVWnhqNOLwJw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    zeep
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "total_connect_client"
  ];

  meta = with lib; {
    description = "Interact with Total Connect 2 alarm systems";
    homepage = "https://github.com/craigjmidwinter/total-connect-client";
    changelog = "https://github.com/craigjmidwinter/total-connect-client/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
