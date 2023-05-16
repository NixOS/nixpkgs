{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, pytestCheckHook
, responses
}:

buildPythonPackage rec {
  pname = "upcloud-api";
<<<<<<< HEAD
  version = "2.5.0";
=======
  version = "2.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "UpCloudLtd";
    repo = "upcloud-python-api";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-35vPODc/oL+JPMnStFutIRYVTUkYAXKRt/KXBW0Yc+U=";
=======
    sha256 = "sha256-thmrbCpGjlDkHIZwIjRgIVMplaypiKByFS/nS8F2LXA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "upcloud_api" ];

  meta = with lib; {
<<<<<<< HEAD
    changelog = "https://github.com/UpCloudLtd/upcloud-python-api/blob/${src.rev}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "UpCloud API Client";
    homepage = "https://github.com/UpCloudLtd/upcloud-python-api";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
