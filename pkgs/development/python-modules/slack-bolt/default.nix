{ buildPythonPackage
, chalice
, cherrypy
, django
, falcon
, fastapi
, fetchFromGitHub
, flask
, flask-sockets
, lib
, moto
, numpy
, pyramid
, pytest-asyncio
, pytestCheckHook
, sanic
, sanic-testing
, slack-sdk
, starlette
, tornado
}:

buildPythonPackage rec {
  pname = "slack-bolt";
  version = "1.18.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "slackapi";
    repo = "bolt-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-s9djd/MDNnyNkjkeApY6Fb1mhI6iop8RghaSJdi4eAs=";
  };

  propagatedBuildInputs = [ slack-sdk ];

  nativeCheckInputs = [
    chalice
    cherrypy
    django
    falcon
    fastapi
    flask
    flask-sockets
    moto
    pyramid
    pytest-asyncio
    pytestCheckHook
    sanic
    sanic-testing
    starlette
    tornado
  ];

  # Work around "Read-only file system: '/homeless-shelter'" errors
  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  disabledTestPaths = [
    # boddle is not packaged as of 2023-07-15
    "tests/adapter_tests/bottle/"
  ];

  disabledTests = [
    # Require network access
    "test_events"
    "test_interactions"
    "test_lazy_listener_calls"
    "test_lazy_listeners"
  ];

  pythonImportsCheck = [ "slack_bolt" ];

  meta = with lib; {
    description = "A framework to build Slack apps using Python";
    homepage = "https://github.com/slackapi/bolt-python";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
