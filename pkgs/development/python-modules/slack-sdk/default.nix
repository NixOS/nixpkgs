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
, isPy3k
, psutil
, pytest-asyncio
, pytest-cov
, pytestCheckHook
, pytestrunner
, sqlalchemy
, websocket_client
, websockets
}:

buildPythonPackage rec {
  pname = "slack-sdk";
  version = "3.5.0";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "slackapi";
    repo = "python-slack-sdk";
    rev = "v${version}";
    sha256 = "sha256-5ZBaF/6p/eOWjAmo+IlF9zCb9xBr2bP6suPZblRogUg=";
  };

  propagatedBuildInputs = [
    aiodns
    aiohttp
    boto3
    sqlalchemy
    websocket_client
    websockets
  ];

  checkInputs = [
    codecov
    databases
    flake8
    flask-sockets
    psutil
    pytest-asyncio
    pytest-cov
    pytestCheckHook
    pytestrunner
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # Exclude tests that requires network features
  pytestFlagsArray = [ "--ignore=integration_tests" ];
  disabledTests = [
    "test_start_raises_an_error_if_rtm_ws_url_is_not_returned"
    "test_org_installation"
  ];

  pythonImportsCheck = [ "slack_sdk" ];

  meta = with lib; {
    description = "Slack Developer Kit for Python";
    homepage = "https://slack.dev/python-slack-sdk/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
