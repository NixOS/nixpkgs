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
  pytest-asyncio_0,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "slack-bolt";
  version = "1.28.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "slackapi";
    repo = "bolt-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1AJO7+7YG/NFh6Rmqwkm6yua2LWdYQ9Rv1oadfHAlhE=";
  };

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
    pytest-asyncio_0
    pytestCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  __darwinAllowLocalNetworking = true;

  disabledTestPaths = [
    # boddle is not packaged as of 2023-07-15
    "tests/adapter_tests/bottle/"
  ];

  disabledTests = [
    # Require network access
    "test_failure"
    # TypeError
    "test_oauth"
  ];

  meta = {
    description = "Framework to build Slack apps using Python";
    homepage = "https://github.com/slackapi/bolt-python";
    changelog = "https://github.com/slackapi/bolt-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ samuela ];
  };
})
