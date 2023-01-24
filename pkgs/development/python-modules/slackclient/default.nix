{ lib
, stdenv
, aiohttp
, boto3
, buildPythonPackage
, fetchFromGitHub
, flask
, flask-sockets
, isPy3k
, mock
, moto
, psutil
, pytest-cov
, pytest-mock
, pytestCheckHook
, pytest-runner
, requests
, responses
, six
, sqlalchemy
, websockets
, websocket-client
}:

buildPythonPackage rec {
  pname = "slackclient";
  version = "3.19.5";
  format =  "setuptools";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "slackapi";
    repo = "python-slack-sdk";
    rev = "refs/tags/v${version}";
    hash = "sha256-/DVcnfHjvmRreHSlZbzxz6pbqytEUdqbaGbQVxIW4Qk=";
  };

  propagatedBuildInputs = [
    aiohttp
    websocket-client
    requests
    six
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

  # Exclude tests that requires network features
  pytestFlagsArray = [ "--ignore=integration_tests" ];

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

  pythonImportsCheck = [ "slack" ];

  meta = with lib; {
    description = "A client for Slack, which supports the Slack Web API and Real Time Messaging (RTM) API";
    homepage = "https://github.com/slackapi/python-slackclient";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli psyanticy ];
  };
}
