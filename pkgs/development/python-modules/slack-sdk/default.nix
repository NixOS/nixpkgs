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
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "slack-sdk";
  version = "3.36.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "slackapi";
    repo = "python-slack-sdk";
    tag = "v${version}";
    hash = "sha256-Y6w4osSpirBjxPdZRlODwEAWd4Z+sPHrr7alVl/6mPA=";
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
    # Requires network access: [Errno 111] Connection refused
    "test_send_message_while_disconnection"
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
