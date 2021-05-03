{ lib
, aiohttp
, buildPythonPackage
, codecov
, fetchFromGitHub
, flake8
, isPy3k
, mock
, psutil
, pytest-cov
, pytest-mock
, pytestCheckHook
, pytestrunner
, requests
, responses
, six
, websocket_client
}:

buildPythonPackage rec {
  pname = "slackclient";
  version = "2.9.3";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "slackapi";
    repo = "python-slack-sdk";
    rev = "v${version}";
    sha256 = "1rfb7izgddv28ag37gdnv3sd8z2zysrxs7ad8x20x690zshpaq16";
  };

  propagatedBuildInputs = [
    aiohttp
    websocket_client
    requests
    six
  ];

  checkInputs = [
    codecov
    flake8
    mock
    psutil
    pytest-cov
    pytest-mock
    pytestCheckHook
    pytestrunner
    responses
  ];

  # Exclude tests that requires network features
  pytestFlagsArray = [ "--ignore=integration_tests" ];
  disabledTests = [ "test_start_raises_an_error_if_rtm_ws_url_is_not_returned" ];

  pythonImportsCheck = [ "slack" ];

  meta = with lib; {
    description = "A client for Slack, which supports the Slack Web API and Real Time Messaging (RTM) API";
    homepage = "https://github.com/slackapi/python-slackclient";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli psyanticy ];
  };
}
