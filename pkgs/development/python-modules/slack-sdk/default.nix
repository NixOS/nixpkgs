{
  lib,
  aiodns,
  aiohttp,
  boto3,
  buildPythonPackage,
  fetchFromGitHub,
  flake8,
  flask-sockets,
  moto,
  psutil,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  sqlalchemy,
  websocket-client,
  websockets,
}:

buildPythonPackage rec {
  pname = "slack-sdk";
  version = "3.34.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "slackapi";
    repo = "python-slack-sdk";
    rev = "refs/tags/v${version}";
    hash = "sha256-aL8XOlvnAxT9cgPf8EvJT80FmlgL2Vhu7JxDRHkUoSM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "pytest-runner"' ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiodns
    aiohttp
    boto3
    sqlalchemy
    websocket-client
    websockets
  ];

  pythonImportsCheck = [ "slack_sdk" ];

  nativeCheckInputs = [
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

  disabledTests = [
    # Requires internet access (to slack API)
    "test_start_raises_an_error_if_rtm_ws_url_is_not_returned"
    # Requires network access: [Errno 111] Connection refused
    "test_send_message_while_disconnection"
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
