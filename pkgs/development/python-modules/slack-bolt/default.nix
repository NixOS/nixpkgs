{
  lib,
  aiohttp,
  bottle,
  buildPythonPackage,
  chalice,
  cherrypy,
  django,
  docker,
  falcon,
  fastapi,
  fetchFromGitHub,
  flask,
  flask-sockets,
  gunicorn,
  moto,
  pyramid,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  sanic,
  setuptools,
  sanic-testing,
  slack-sdk,
  starlette,
  tornado,
  uvicorn,
  websocket-client,
  websockets,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "slack-bolt";
  version = "1.21.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "slackapi";
    repo = "bolt-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-4zEg60f3wtLnzrZU4mZMJmF6hO0EiHDTx6iw4WDsx0U=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"pytest-runner==5.2",' ""
  '';

  build-system = [ setuptools ];

  dependencies = [ slack-sdk ];

  optional-dependencies = {
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
    docker
    pytest-asyncio
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

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
    description = "Framework to build Slack apps using Python";
    homepage = "https://github.com/slackapi/bolt-python";
    changelog = "https://github.com/slackapi/bolt-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
