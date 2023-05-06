{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, pytestCheckHook
, responses
}:

buildPythonPackage rec {
  pname = "testrail-api";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "tolstislon";
    repo = "testrail-api";
    rev = version;
    sha256 = "sha256-VuAW5Dl3pkA6mtn/mbzxTFoavO5jPoqFSFVlrxc7KRk=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  propagatedBuildInputs = [
    requests
  ];

  meta = with lib; {
    description = "A Python wrapper of the TestRail API";
    homepage = "https://github.com/tolstislon/testrail-api";
    changelog = "https://github.com/tolstislon/ytestrail-api/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ aanderse ];
  };
}
