{
  lib,
  stdenv,
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

buildPythonPackage (finalAttrs: {
  pname = "slack-sdk";
  version = "3.43.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "slackapi";
    repo = "python-slack-sdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-slgf9U/Rm0pSV84CZR/8gGhvEi1zowjzE7YG9FsqwKk=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    optional = [
      aiodns
      aiohttp
      boto3
      sqlalchemy
      websocket-client
      websockets
    ];
  };

  nativeCheckInputs = [
    aiosqlite
    moto
    pytest-asyncio
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "slack_sdk" ];

  disabledTests = [
    # Requires internet access (to slack API)
    "test_start_raises_an_error_if_rtm_ws_url_is_not_returned"
    "test_send_message_while_disconnection"
    "TestWebClient_HttpRetry"
    "test_issue_690_oauth_access"
    "test_issue_690_oauth_v2_access"
    "test_error_response"
    "test_issue_1441_mixing_user_and_bot_installations"
  ]
  ++ lib.optionals (stdenv.hostPlatform.system == "aarch64-darwin") [
    # ConnectionResetError in webhook test server
    "test_send_dict"
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
    changelog = "https://github.com/slackapi/python-slack-sdk/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
