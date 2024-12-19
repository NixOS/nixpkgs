{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  slack-sdk,

  # optional-dependencies
  # - async
  aiohttp,
  websockets,
  # - adapter
  bottle,
  chalice,
  cherrypy,
  django,
  falcon,
  fastapi,
  flask,
  flask-sockets,
  gunicorn,
  moto,
  pyramid,
  sanic,
  sanic-testing,
  starlette,
  tornado,
  uvicorn,
  websocket-client,
  werkzeug,

  # tests
  docker,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "slack-bolt";
  version = "1.21.2";
  pyproject = true;

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

  pythonImportsCheck = [ "slack_bolt" ];

  nativeCheckInputs = [
    docker
    pytest-asyncio
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  __darwinAllowLocalNetworking = true;

  disabledTestPaths = [
    # boddle is not packaged as of 2023-07-15
    "tests/adapter_tests/bottle/"
  ];

  disabledTests = [
    # Require network access
    "test_failure"
  ];

  meta = {
    description = "Framework to build Slack apps using Python";
    homepage = "https://github.com/slackapi/bolt-python";
    changelog = "https://github.com/slackapi/bolt-python/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ samuela ];
  };
}
