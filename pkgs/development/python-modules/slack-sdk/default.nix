{
  lib,
  aiodns,
  aiohttp,
  aiosqlite,
  boto3,
  buildPythonPackage,
  fetchFromGitHub,
  moto,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  sqlalchemy,
  websocket-client,
  websockets,
}:

buildPythonPackage rec {
  pname = "slack-sdk";
  version = "3.39.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "slackapi";
    repo = "python-slack-sdk";
    tag = "v${version}";
    hash = "sha256-c9MPcamxXPxWnj5OpJNME/PTHssOxOJP6zjSLu5cW7Y=";
  };

  build-system = [ setuptools ];

  optional-dependencies.optional = [
    aiodns
    aiohttp
    boto3
    sqlalchemy
    websocket-client
    websockets
  ];

  pythonImportsCheck = [ "slack_sdk" ];

  nativeCheckInputs = [
    aiosqlite
    moto
    pytest-asyncio
    pytestCheckHook
  ]
  ++ optional-dependencies.optional;

  disabledTests = [
    # Requires internet access (to slack API)
    "test_start_raises_an_error_if_rtm_ws_url_is_not_returned"
    "test_send_message_while_disconnection"
    "TestWebClient_HttpRetry"
    "test_issue_690_oauth_access"
    "test_issue_690_oauth_v2_access"
    "test_error_response"
    "test_issue_1441_mixing_user_and_bot_installations"
  ];

  disabledTestPaths = [
    # Event loop issues
    "tests/slack_sdk/oauth/installation_store/test_file.py"
    "tests/slack_sdk/oauth/state_store/test_file.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Slack Developer Kit for Python";
    homepage = "https://slack.dev/python-slack-sdk/";
    changelog = "https://github.com/slackapi/python-slack-sdk/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
