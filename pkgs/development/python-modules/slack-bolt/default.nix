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
  fetchpatch,
  flask,
  flask-sockets,
  gunicorn,
  moto,
  numpy,
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
  version = "1.18.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "slackapi";
    repo = "bolt-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-UwVStemFVA4hgqnSpCKpQGwLYG+p5z7MwFXXnIhrvNk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "pytest-runner==5.2" ""
  '';

  patches = [
    # moto >=5 support, https://github.com/slackapi/bolt-python/pull/1046
    (fetchpatch {
      name = "moto-support.patch";
      url = "https://github.com/slackapi/bolt-python/commit/69c2015ef49773de111f184dca9668aefac9e7c0.patch";
      hash = "sha256-KW7KPeOqanV4n1UOv4DCadplJsqsPY+ju4ry0IvUqpA=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ slack-sdk ];

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
    docker
    pytest-asyncio
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

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
