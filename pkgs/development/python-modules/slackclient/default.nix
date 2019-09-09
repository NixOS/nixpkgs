{ stdenv, buildPythonPackage, fetchFromGitHub, websocket_client, requests, six, pytest, codecov, coverage, mock, pytestcov, pytest-mock, responses, flake8 }:

buildPythonPackage rec {
  pname = "python-slackclient";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner  = "slackapi";
    repo   = pname;
    rev    = version;
    sha256 = "073fwf6fm2sqdp5ms3vm1v3ljh0pldi69k048404rp6iy3cfwkp0";
  };

  propagatedBuildInputs = [ websocket_client requests six ];

  checkInputs = [ pytest codecov coverage mock pytestcov pytest-mock responses flake8 ];
  # test_server.py fails because it needs connection (I think);
  checkPhase = ''
    py.test --cov-report= --cov=slackclient tests --ignore=tests/test_server.py
  '';

  meta = with stdenv.lib; {
    description = "A client for Slack, which supports the Slack Web API and Real Time Messaging (RTM) API";
    homepage = https://github.com/slackapi/python-slackclient;
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}

