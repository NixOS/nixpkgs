{ stdenv
, lib
, aiodns
, aiohttp
, boto3
, buildPythonPackage
, codecov
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
  version = "3.26.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "slackapi";
    repo = "python-slack-sdk";
    rev = "refs/tags/v${version}";
    hash = "sha256-jg4mUVT1sB9hxRqhLOeZxQHTpBK/N76b2XUaFe/nBKY=";
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
    "test_issue_690_oauth_access"
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
