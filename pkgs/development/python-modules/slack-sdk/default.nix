{ stdenv
, lib
, aiodns
, aiohttp
, boto3
, buildPythonPackage
, codecov
<<<<<<< HEAD
=======
, databases
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, flake8
, flask-sockets
, moto
, pythonOlder
, psutil
, pytest-asyncio
, pytestCheckHook
, sqlalchemy
, websocket-client
, websockets
}:

buildPythonPackage rec {
  pname = "slack-sdk";
<<<<<<< HEAD
  version = "3.21.3";
=======
  version = "3.20.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "slackapi";
    repo = "python-slack-sdk";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-begpT/DaDqOi8HZE10FCuIIv18KSU/i5G/Z5DXKUT7Y=";
=======
    hash = "sha256-2MPXV+rVXZYMTZe11T8x8GKQmHZwUlkwarCkheVkERo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    aiodns
    aiohttp
    boto3
    sqlalchemy
    websocket-client
    websockets
  ];

  nativeCheckInputs = [
    codecov
<<<<<<< HEAD
=======
    databases
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    flake8
    flask-sockets
    moto
    psutil
    pytest-asyncio
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTestPaths = [
    # Exclude tests that requires network features
    "integration_tests"
  ];

  disabledTests = [
    # Requires network features
    "test_start_raises_an_error_if_rtm_ws_url_is_not_returned"
    "test_org_installation"
    "test_interactions"
<<<<<<< HEAD
    "test_issue_690_oauth_access"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "slack_sdk"
  ];

  meta = with lib; {
    description = "Slack Developer Kit for Python";
    homepage = "https://slack.dev/python-slack-sdk/";
    changelog = "https://github.com/slackapi/python-slack-sdk/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
