{ stdenv
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, black
, codecov
, flake8
, isPy3k
, mock
, pytest-mock
, pytestCheckHook
, pytestcov
, pytestrunner
, requests
, responses
, six
, websocket_client
}:

buildPythonPackage rec {
  pname = "python-slackclient";
  version = "2.5.0";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner  = "slackapi";
    repo   = pname;
    rev    = version;
    sha256 = "1ngj1mivbln19546195k400w9yaw69g0w6is7c75rqwyxr8wgzsk";
  };

  propagatedBuildInputs = [
    aiohttp
    websocket_client
    requests
    six
  ];

  checkInputs = [
    black
    codecov
    flake8
    mock
    pytest-mock
    pytestCheckHook
    pytestcov
    pytestrunner
    responses
  ];

  meta = with stdenv.lib; {
    description = "A client for Slack, which supports the Slack Web API and Real Time Messaging (RTM) API";
    homepage = "https://github.com/slackapi/python-slackclient";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli psyanticy ];
  };
}
