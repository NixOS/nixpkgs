{ lib
, stdenv
, aiohttp
, boto3
, buildPythonPackage
, fetchFromGitHub
, flask
, flask-sockets
, pythonOlder
, mock
, moto
, psutil
, pytest-mock
, pytestCheckHook
, requests
, responses
, sqlalchemy
, websockets
, websocket-client
}:

buildPythonPackage rec {
  pname = "slackclient";
  version = "3.23.0";
  format =  "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "slackapi";
    repo = "python-slack-sdk";
    rev = "refs/tags/v${version}";
    hash = "sha256-OsPwLOnmN3kvPmbM6lOaiTWwWvy7b9pgn1X536dCkWk=";
  };

  propagatedBuildInputs = [
    aiohttp
    websocket-client
    requests
  ];

  nativeCheckInputs = [
    boto3
    flask
    flask-sockets
    mock
    moto
    psutil
    pytest-mock
    pytestCheckHook
    responses
    sqlalchemy
    websockets
  ];

  pytestFlagsArray = [
    # Exclude tests that requires network features
    "--ignore=integration_tests"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    "test_start_raises_an_error_if_rtm_ws_url_is_not_returned"
    "test_interactions"
    "test_send_message_while_disconnection"
  ] ++ lib.optionals stdenv.isDarwin [
    # these fail with `ConnectionResetError: [Errno 54] Connection reset by peer`
    "test_issue_690_oauth_access"
    "test_issue_690_oauth_v2_access"
    "test_send"
    "test_send_attachments"
    "test_send_blocks"
    "test_send_dict"
  ];

  pythonImportsCheck = [
    "slack"
  ];

  meta = with lib; {
    description = "A client for Slack, which supports the Slack Web API and Real Time Messaging (RTM) API";
    homepage = "https://github.com/slackapi/python-slackclient";
    changelog = "https://github.com/slackapi/python-slack-sdk/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli psyanticy ];
  };
}
