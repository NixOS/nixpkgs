{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, aiohttp
, boddle
, boto3
, bottle
, chalice
, cherrypy
, django
, falcon
, fastapi
, flask
, flask-sockets
, mock
, moto
, pyramid
, pytest-asyncio
, sanic
, sanic-testing
, slack-sdk
, starlette
, tornado
, uvicorn
, websockets
}:

buildPythonPackage rec {
  pname = "slack-bolt";
  version = "1.16.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "slackapi";
    repo = "bolt-python";
    rev = "v${version}";
    hash = "sha256-xzEsTx+44ae++WxArxO2rhCsot+ELuhc0aZ44MXY0c4=";
  };

  propagatedBuildInputs = [ slack-sdk ];

  pythonImportsCheck = [
    "slack_bolt"
  ];

  passthru.optional-dependencies = {
    async = [
      aiohttp
      websockets
    ];
    adapter = [
      boddle
      boto3
      bottle
      cherrypy
      django
      falcon
      fastapi
      flask
      flask-sockets
      pyramid
      starlette
      tornado
      uvicorn
    ] ++ lib.optionals (!stdenv.isDarwin) [
      # server types that are broken on darwin
      chalice
      moto
      sanic
      sanic-testing
    ];
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
    pytest-asyncio
  ] ++ passthru.optional-dependencies.async
  ++ passthru.optional-dependencies.adapter;

  disabledTestPaths = [
    # disable tests that require credentials
    "tests/slack_bolt_async/oauth/test_async_oauth_flow.py"
    "tests/slack_bolt/oauth/test_oauth_flow.py"
  ] ++ lib.optionals stdenv.isDarwin [
    # disable tests that test broken things on darwin
    "tests/adapter_tests_async/test_async_sanic.py"
    "tests/adapter_tests/aws/test_aws_chalice.py"
    "tests/adapter_tests/aws/test_aws_lambda.py"
    "tests/adapter_tests/aws/test_lambda_s3_oauth_flow.py"
  ];

  # disable tests that test auth or end to end integration
  disabledTests = [
    "test_events"
    "test_interactions"
    "test_lazy_listeners"
    "test_oauth"
  ];

  # patch out pytest-runner
  preBuild = ''
    sed -i '/pytest-runner/d' ./setup.py
  '';

  meta = with lib; {
    description = "A framework to build Slack apps";
    homepage = "https://github.com/slackapi/bolt-python";
    changelog = "https://github.com/slackapi/bolt-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
