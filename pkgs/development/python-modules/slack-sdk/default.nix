{ lib
, aiodns
, aiohttp
, boto3
, buildPythonPackage
, codecov
, databases
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
  version = "3.11.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "slackapi";
    repo = "python-slack-sdk";
    rev = "v${version}";
    sha256 = "0zwz36mpc7syrkslf1rf7c6sxfanw87mbr2758j01sph50m43g6m";
  };

  propagatedBuildInputs = [
    aiodns
    aiohttp
    boto3
    sqlalchemy
    websocket-client
    websockets
  ];

  checkInputs = [
    codecov
    databases
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
  ];

  pythonImportsCheck = [ "slack_sdk" ];

  meta = with lib; {
    description = "Slack Developer Kit for Python";
    homepage = "https://slack.dev/python-slack-sdk/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
