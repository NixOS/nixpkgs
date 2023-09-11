{ aiohttp
, bottle
, buildPythonPackage
, chalice
, cherrypy
, django
, falcon
, fastapi
, fetchFromGitHub
, flask
, flask-sockets
, gunicorn
, lib
, moto
, numpy
, pyramid
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, sanic
, sanic-testing
, slack-sdk
, starlette
, tornado
, uvicorn
, websocket-client
, websockets
, werkzeug
}:

buildPythonPackage rec {
  pname = "slack-bolt";
  version = "1.18.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "slackapi";
    repo = "bolt-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-s9djd/MDNnyNkjkeApY6Fb1mhI6iop8RghaSJdi4eAs=";
  };

  # The packaged pytest-runner version is too new as of 2023-07-27. It's not really needed anyway. Unfortunately,
  # pythonRelaxDepsHook doesn't work on setup_requires packages.
  postPatch = ''
    substituteInPlace setup.py --replace "pytest-runner==5.2" ""
  '';

  propagatedBuildInputs = [ slack-sdk ];

  passthru.optional-dependencies = {
    async = [
      aiohttp
      websockets
    ];
    adapter = [
      bottle
      chalice
      cherrypy
      django
      falcon
      fastapi
      flask
      flask-sockets
      gunicorn
      moto
      pyramid
      sanic
      sanic-testing
      starlette
      tornado
      uvicorn
      websocket-client
      werkzeug
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  # Work around "Read-only file system: '/homeless-shelter'" errors
  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  disabledTestPaths = [
    # boddle is not packaged as of 2023-07-15
    "tests/adapter_tests/bottle/"
    # Tests are blocking at some point. Blocking could be performance-related.
    "tests/scenario_tests_async/"
    "tests/slack_bolt_async/"
  ];

  disabledTests = [
    # Require network access
    "test_events"
    "test_interactions"
    "test_lazy_listener_calls"
    "test_lazy_listeners"
    "test_failure"
  ];

  pythonImportsCheck = [ "slack_bolt" ];

  meta = with lib; {
    description = "A framework to build Slack apps using Python";
    homepage = "https://github.com/slackapi/bolt-python";
    changelog = "https://github.com/slackapi/bolt-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
